
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 b3 07 00 00       	call   8007e9 <libmain>
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
  8000b1:	68 c0 49 80 00       	push   $0x8049c0
  8000b6:	e8 c7 09 00 00       	call   800a82 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8000be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	8b 00                	mov    (%eax),%eax
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	50                   	push   %eax
  8000d3:	68 c2 49 80 00       	push   $0x8049c2
  8000d8:	e8 a5 09 00 00       	call   800a82 <cprintf>
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
  800101:	68 c7 49 80 00       	push   $0x8049c7
  800106:	e8 77 09 00 00       	call   800a82 <cprintf>
  80010b:	83 c4 10             	add    $0x10,%esp

}
  80010e:	90                   	nop
  80010f:	c9                   	leave  
  800110:	c3                   	ret    

00800111 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	57                   	push   %edi
  800115:	56                   	push   %esi
  800116:	53                   	push   %ebx
  800117:	81 ec dc 01 00 00    	sub    $0x1dc,%esp
	int32 envID = sys_getenvid();
  80011d:	e8 7b 34 00 00       	call   80359d <sys_getenvid>
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800125:	e8 a5 34 00 00       	call   8035cf <sys_getparentenvid>
  80012a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
#endif

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
#if USE_KERN_SEMAPHORE
	char waitCmd1[64] = "__KSem@0@Wait";
  80012d:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800133:	bb 80 4a 80 00       	mov    $0x804a80,%ebx
  800138:	ba 0e 00 00 00       	mov    $0xe,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800145:	8d 55 86             	lea    -0x7a(%ebp),%edx
  800148:	b9 32 00 00 00       	mov    $0x32,%ecx
  80014d:	b0 00                	mov    $0x0,%al
  80014f:	89 d7                	mov    %edx,%edi
  800151:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd1, 0);
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	6a 00                	push   $0x0
  800158:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  80015e:	50                   	push   %eax
  80015f:	e8 88 36 00 00       	call   8037ec <sys_utilities>
  800164:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(ready);
#endif

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800167:	83 ec 08             	sub    $0x8,%esp
  80016a:	68 cb 49 80 00       	push   $0x8049cb
  80016f:	ff 75 dc             	pushl  -0x24(%ebp)
  800172:	e8 59 2b 00 00       	call   802cd0 <sget>
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	89 45 d8             	mov    %eax,-0x28(%ebp)
#else
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
#endif

	//Get the shared array & its size
	int *numOfElements = NULL;
  80017d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	int *sharedArray = NULL;
  800184:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	68 de 49 80 00       	push   $0x8049de
  800193:	ff 75 dc             	pushl  -0x24(%ebp)
  800196:	e8 35 2b 00 00       	call   802cd0 <sget>
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	68 e2 49 80 00       	push   $0x8049e2
  8001a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ac:	e8 1f 2b 00 00       	call   802cd0 <sget>
  8001b1:	83 c4 10             	add    $0x10,%esp
  8001b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8001b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001ba:	8b 00                	mov    (%eax),%eax
  8001bc:	c1 e0 02             	shl    $0x2,%eax
  8001bf:	83 ec 04             	sub    $0x4,%esp
  8001c2:	6a 00                	push   $0x0
  8001c4:	50                   	push   %eax
  8001c5:	68 ea 49 80 00       	push   $0x8049ea
  8001ca:	e8 5a 25 00 00       	call   802729 <smalloc>
  8001cf:	83 c4 10             	add    $0x10,%esp
  8001d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8001d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001dc:	eb 25                	jmp    800203 <_main+0xf2>
	{
		tmpArray[i] = sharedArray[i];
  8001de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001eb:	01 c2                	add    %eax,%edx
  8001ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001fa:	01 c8                	add    %ecx,%eax
  8001fc:	8b 00                	mov    (%eax),%eax
  8001fe:	89 02                	mov    %eax,(%edx)

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800200:	ff 45 e4             	incl   -0x1c(%ebp)
  800203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800206:	8b 00                	mov    (%eax),%eax
  800208:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80020b:	7f d1                	jg     8001de <_main+0xcd>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  80020d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800210:	8b 00                	mov    (%eax),%eax
  800212:	83 ec 04             	sub    $0x4,%esp
  800215:	8d 95 5c ff ff ff    	lea    -0xa4(%ebp),%edx
  80021b:	52                   	push   %edx
  80021c:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  800222:	52                   	push   %edx
  800223:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  800229:	52                   	push   %edx
  80022a:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800230:	52                   	push   %edx
  800231:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  800237:	52                   	push   %edx
  800238:	50                   	push   %eax
  800239:	ff 75 cc             	pushl  -0x34(%ebp)
  80023c:	e8 c2 03 00 00       	call   800603 <ArrayStats>
  800241:	83 c4 20             	add    $0x20,%esp

#if USE_KERN_SEMAPHORE
	char waitCmd2[64] = "__KSem@2@Wait";
  800244:	8d 85 1c ff ff ff    	lea    -0xe4(%ebp),%eax
  80024a:	bb c0 4a 80 00       	mov    $0x804ac0,%ebx
  80024f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800254:	89 c7                	mov    %eax,%edi
  800256:	89 de                	mov    %ebx,%esi
  800258:	89 d1                	mov    %edx,%ecx
  80025a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80025c:	8d 95 2a ff ff ff    	lea    -0xd6(%ebp),%edx
  800262:	b9 32 00 00 00       	mov    $0x32,%ecx
  800267:	b0 00                	mov    $0x0,%al
  800269:	89 d7                	mov    %edx,%edi
  80026b:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd2, 0);
  80026d:	83 ec 08             	sub    $0x8,%esp
  800270:	6a 00                	push   $0x0
  800272:	8d 85 1c ff ff ff    	lea    -0xe4(%ebp),%eax
  800278:	50                   	push   %eax
  800279:	e8 6e 35 00 00       	call   8037ec <sys_utilities>
  80027e:	83 c4 10             	add    $0x10,%esp
#else
	wait_semaphore(cons_mutex);
#endif
	{
		cprintf("Stats Calculations are Finished!!!!\n") ;
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	68 f4 49 80 00       	push   $0x8049f4
  800289:	e8 f4 07 00 00       	call   800a82 <cprintf>
  80028e:	83 c4 10             	add    $0x10,%esp
		cprintf("will share the results & notify the master now...\n");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 1c 4a 80 00       	push   $0x804a1c
  800299:	e8 e4 07 00 00       	call   800a82 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp
	}
#if USE_KERN_SEMAPHORE
	char signalCmd1[64] = "__KSem@2@Signal";
  8002a1:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  8002a7:	bb 00 4b 80 00       	mov    $0x804b00,%ebx
  8002ac:	ba 04 00 00 00       	mov    $0x4,%edx
  8002b1:	89 c7                	mov    %eax,%edi
  8002b3:	89 de                	mov    %ebx,%esi
  8002b5:	89 d1                	mov    %edx,%ecx
  8002b7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8002b9:	8d 95 ec fe ff ff    	lea    -0x114(%ebp),%edx
  8002bf:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8002c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c9:	89 d7                	mov    %edx,%edi
  8002cb:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd1, 0);
  8002cd:	83 ec 08             	sub    $0x8,%esp
  8002d0:	6a 00                	push   $0x0
  8002d2:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  8002d8:	50                   	push   %eax
  8002d9:	e8 0e 35 00 00       	call   8037ec <sys_utilities>
  8002de:	83 c4 10             	add    $0x10,%esp
#endif

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int64 *shMean, *shVar;
	int *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int64), 0) ; *shMean = mean;
  8002e1:	83 ec 04             	sub    $0x4,%esp
  8002e4:	6a 00                	push   $0x0
  8002e6:	6a 08                	push   $0x8
  8002e8:	68 4f 4a 80 00       	push   $0x804a4f
  8002ed:	e8 37 24 00 00       	call   802729 <smalloc>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8002f8:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8002fe:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  800304:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800307:	89 01                	mov    %eax,(%ecx)
  800309:	89 51 04             	mov    %edx,0x4(%ecx)
	shVar = smalloc("var", sizeof(int64), 0) ; *shVar = var;
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	6a 00                	push   $0x0
  800311:	6a 08                	push   $0x8
  800313:	68 54 4a 80 00       	push   $0x804a54
  800318:	e8 0c 24 00 00       	call   802729 <smalloc>
  80031d:	83 c4 10             	add    $0x10,%esp
  800320:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800323:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800329:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  80032f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800332:	89 01                	mov    %eax,(%ecx)
  800334:	89 51 04             	mov    %edx,0x4(%ecx)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	6a 00                	push   $0x0
  80033c:	6a 04                	push   $0x4
  80033e:	68 58 4a 80 00       	push   $0x804a58
  800343:	e8 e1 23 00 00       	call   802729 <smalloc>
  800348:	83 c4 10             	add    $0x10,%esp
  80034b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80034e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  800354:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800357:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	6a 00                	push   $0x0
  80035e:	6a 04                	push   $0x4
  800360:	68 5c 4a 80 00       	push   $0x804a5c
  800365:	e8 bf 23 00 00       	call   802729 <smalloc>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800370:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800376:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800379:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	6a 00                	push   $0x0
  800380:	6a 04                	push   $0x4
  800382:	68 60 4a 80 00       	push   $0x804a60
  800387:	e8 9d 23 00 00       	call   802729 <smalloc>
  80038c:	83 c4 10             	add    $0x10,%esp
  80038f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800392:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800398:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80039b:	89 10                	mov    %edx,(%eax)

#if USE_KERN_SEMAPHORE
	char waitCmd3[64] = "__KSem@2@Wait";
  80039d:	8d 85 9c fe ff ff    	lea    -0x164(%ebp),%eax
  8003a3:	bb c0 4a 80 00       	mov    $0x804ac0,%ebx
  8003a8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003ad:	89 c7                	mov    %eax,%edi
  8003af:	89 de                	mov    %ebx,%esi
  8003b1:	89 d1                	mov    %edx,%ecx
  8003b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003b5:	8d 95 aa fe ff ff    	lea    -0x156(%ebp),%edx
  8003bb:	b9 32 00 00 00       	mov    $0x32,%ecx
  8003c0:	b0 00                	mov    $0x0,%al
  8003c2:	89 d7                	mov    %edx,%edi
  8003c4:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd3, 0);
  8003c6:	83 ec 08             	sub    $0x8,%esp
  8003c9:	6a 00                	push   $0x0
  8003cb:	8d 85 9c fe ff ff    	lea    -0x164(%ebp),%eax
  8003d1:	50                   	push   %eax
  8003d2:	e8 15 34 00 00       	call   8037ec <sys_utilities>
  8003d7:	83 c4 10             	add    $0x10,%esp
#else
	wait_semaphore(cons_mutex);
#endif
	{
		cprintf("Stats app says GOOD BYE :)\n") ;
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	68 64 4a 80 00       	push   $0x804a64
  8003e2:	e8 9b 06 00 00       	call   800a82 <cprintf>
  8003e7:	83 c4 10             	add    $0x10,%esp
	}
#if USE_KERN_SEMAPHORE
	char signalCmd3[64] = "__KSem@2@Signal";
  8003ea:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  8003f0:	bb 00 4b 80 00       	mov    $0x804b00,%ebx
  8003f5:	ba 04 00 00 00       	mov    $0x4,%edx
  8003fa:	89 c7                	mov    %eax,%edi
  8003fc:	89 de                	mov    %ebx,%esi
  8003fe:	89 d1                	mov    %edx,%ecx
  800400:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800402:	8d 95 6c fe ff ff    	lea    -0x194(%ebp),%edx
  800408:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80040d:	b8 00 00 00 00       	mov    $0x0,%eax
  800412:	89 d7                	mov    %edx,%edi
  800414:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd3, 0);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	6a 00                	push   $0x0
  80041b:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  800421:	50                   	push   %eax
  800422:	e8 c5 33 00 00       	call   8037ec <sys_utilities>
  800427:	83 c4 10             	add    $0x10,%esp
#else
	signal_semaphore(cons_mutex);
#endif

#if USE_KERN_SEMAPHORE
	char signalCmd2[64] = "__KSem@1@Signal";
  80042a:	8d 85 1c fe ff ff    	lea    -0x1e4(%ebp),%eax
  800430:	bb 40 4b 80 00       	mov    $0x804b40,%ebx
  800435:	ba 04 00 00 00       	mov    $0x4,%edx
  80043a:	89 c7                	mov    %eax,%edi
  80043c:	89 de                	mov    %ebx,%esi
  80043e:	89 d1                	mov    %edx,%ecx
  800440:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800442:	8d 95 2c fe ff ff    	lea    -0x1d4(%ebp),%edx
  800448:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80044d:	b8 00 00 00 00       	mov    $0x0,%eax
  800452:	89 d7                	mov    %edx,%edi
  800454:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd2, 0);
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	6a 00                	push   $0x0
  80045b:	8d 85 1c fe ff ff    	lea    -0x1e4(%ebp),%eax
  800461:	50                   	push   %eax
  800462:	e8 85 33 00 00       	call   8037ec <sys_utilities>
  800467:	83 c4 10             	add    $0x10,%esp
#else
	signal_semaphore(finished);
#endif
}
  80046a:	90                   	nop
  80046b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80046e:	5b                   	pop    %ebx
  80046f:	5e                   	pop    %esi
  800470:	5f                   	pop    %edi
  800471:	5d                   	pop    %ebp
  800472:	c3                   	ret    

00800473 <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  800479:	8b 45 10             	mov    0x10(%ebp),%eax
  80047c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80047f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800482:	48                   	dec    %eax
  800483:	83 ec 0c             	sub    $0xc,%esp
  800486:	52                   	push   %edx
  800487:	50                   	push   %eax
  800488:	6a 00                	push   $0x0
  80048a:	ff 75 0c             	pushl  0xc(%ebp)
  80048d:	ff 75 08             	pushl  0x8(%ebp)
  800490:	e8 05 00 00 00       	call   80049a <QSort>
  800495:	83 c4 20             	add    $0x20,%esp
}
  800498:	c9                   	leave  
  800499:	c3                   	ret    

0080049a <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  8004a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004a6:	7c 16                	jl     8004be <QSort+0x24>
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	01 d0                	add    %edx,%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	e9 43 01 00 00       	jmp    800601 <QSort+0x167>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8004be:	0f 31                	rdtsc  
  8004c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004c3:	89 55 e0             	mov    %edx,-0x20(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8004c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004cf:	89 55 e8             	mov    %edx,-0x18(%ebp)

	int pvtIndex = RANDU(startIndex, finalIndex) ;
  8004d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d5:	8b 55 14             	mov    0x14(%ebp),%edx
  8004d8:	2b 55 10             	sub    0x10(%ebp),%edx
  8004db:	89 d1                	mov    %edx,%ecx
  8004dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e2:	f7 f1                	div    %ecx
  8004e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  8004ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8004ef:	ff 75 10             	pushl  0x10(%ebp)
  8004f2:	ff 75 08             	pushl  0x8(%ebp)
  8004f5:	e8 3e fb ff ff       	call   800038 <Swap>
  8004fa:	83 c4 0c             	add    $0xc,%esp

	int i = startIndex+1, j = finalIndex;
  8004fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800500:	40                   	inc    %eax
  800501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80050a:	eb 7d                	jmp    800589 <QSort+0xef>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80050c:	ff 45 f4             	incl   -0xc(%ebp)
  80050f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800512:	3b 45 14             	cmp    0x14(%ebp),%eax
  800515:	7f 2b                	jg     800542 <QSort+0xa8>
  800517:	8b 45 10             	mov    0x10(%ebp),%eax
  80051a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	8b 10                	mov    (%eax),%edx
  800528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	01 c8                	add    %ecx,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	7d cf                	jge    80050c <QSort+0x72>
		while (j > startIndex && Elements[startIndex] < Elements[j]) j--;
  80053d:	eb 03                	jmp    800542 <QSort+0xa8>
  80053f:	ff 4d f0             	decl   -0x10(%ebp)
  800542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800545:	3b 45 10             	cmp    0x10(%ebp),%eax
  800548:	7e 26                	jle    800570 <QSort+0xd6>
  80054a:	8b 45 10             	mov    0x10(%ebp),%eax
  80054d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	01 d0                	add    %edx,%eax
  800559:	8b 10                	mov    (%eax),%edx
  80055b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80055e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	01 c8                	add    %ecx,%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	39 c2                	cmp    %eax,%edx
  80056e:	7c cf                	jl     80053f <QSort+0xa5>

		if (i <= j)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800576:	7f 11                	jg     800589 <QSort+0xef>
		{
			Swap(Elements, i, j);
  800578:	ff 75 f0             	pushl  -0x10(%ebp)
  80057b:	ff 75 f4             	pushl  -0xc(%ebp)
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	e8 b2 fa ff ff       	call   800038 <Swap>
  800586:	83 c4 0c             	add    $0xc,%esp
	int pvtIndex = RANDU(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80058c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80058f:	0f 8e 7a ff ff ff    	jle    80050f <QSort+0x75>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800595:	ff 75 f0             	pushl  -0x10(%ebp)
  800598:	ff 75 10             	pushl  0x10(%ebp)
  80059b:	ff 75 08             	pushl  0x8(%ebp)
  80059e:	e8 95 fa ff ff       	call   800038 <Swap>
  8005a3:	83 c4 0c             	add    $0xc,%esp

	if (kIndex == j)
  8005a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ac:	75 13                	jne    8005c1 <QSort+0x127>
		return Elements[kIndex] ;
  8005ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	eb 40                	jmp    800601 <QSort+0x167>
	else if (kIndex < j)
  8005c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c7:	7d 1e                	jge    8005e7 <QSort+0x14d>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  8005c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cc:	48                   	dec    %eax
  8005cd:	83 ec 0c             	sub    $0xc,%esp
  8005d0:	ff 75 18             	pushl  0x18(%ebp)
  8005d3:	50                   	push   %eax
  8005d4:	ff 75 10             	pushl  0x10(%ebp)
  8005d7:	ff 75 0c             	pushl  0xc(%ebp)
  8005da:	ff 75 08             	pushl  0x8(%ebp)
  8005dd:	e8 b8 fe ff ff       	call   80049a <QSort>
  8005e2:	83 c4 20             	add    $0x20,%esp
  8005e5:	eb 1a                	jmp    800601 <QSort+0x167>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	ff 75 18             	pushl  0x18(%ebp)
  8005ed:	ff 75 14             	pushl  0x14(%ebp)
  8005f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	ff 75 08             	pushl  0x8(%ebp)
  8005f9:	e8 9c fe ff ff       	call   80049a <QSort>
  8005fe:	83 c4 20             	add    $0x20,%esp
}
  800601:	c9                   	leave  
  800602:	c3                   	ret    

00800603 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med)
{
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	57                   	push   %edi
  800607:	56                   	push   %esi
  800608:	53                   	push   %ebx
  800609:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  80060c:	8b 45 10             	mov    0x10(%ebp),%eax
  80060f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800615:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	*min = 0x7FFFFFFF ;
  80061c:	8b 45 18             	mov    0x18(%ebp),%eax
  80061f:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  800625:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800628:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80062e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800635:	e9 89 00 00 00       	jmp    8006c3 <ArrayStats+0xc0>
	{
		(*mean) += Elements[i];
  80063a:	8b 45 10             	mov    0x10(%ebp),%eax
  80063d:	8b 08                	mov    (%eax),%ecx
  80063f:	8b 58 04             	mov    0x4(%eax),%ebx
  800642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800645:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	01 d0                	add    %edx,%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	99                   	cltd   
  800654:	01 c8                	add    %ecx,%eax
  800656:	11 da                	adc    %ebx,%edx
  800658:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80065b:	89 01                	mov    %eax,(%ecx)
  80065d:	89 51 04             	mov    %edx,0x4(%ecx)
		if (Elements[i] < (*min))
  800660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800663:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	01 d0                	add    %edx,%eax
  80066f:	8b 10                	mov    (%eax),%edx
  800671:	8b 45 18             	mov    0x18(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	39 c2                	cmp    %eax,%edx
  800678:	7d 16                	jge    800690 <ArrayStats+0x8d>
		{
			(*min) = Elements[i];
  80067a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80067d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	8b 45 18             	mov    0x18(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  800690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	01 d0                	add    %edx,%eax
  80069f:	8b 10                	mov    (%eax),%edx
  8006a1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	7e 16                	jle    8006c0 <ArrayStats+0xbd>
		{
			(*max) = Elements[i];
  8006aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 10                	mov    (%eax),%edx
  8006bb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006be:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c0:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006c9:	0f 8c 6b ff ff ff    	jl     80063a <ArrayStats+0x37>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, (NumOfElements+1)/2);
  8006cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d2:	40                   	inc    %eax
  8006d3:	89 c2                	mov    %eax,%edx
  8006d5:	c1 ea 1f             	shr    $0x1f,%edx
  8006d8:	01 d0                	add    %edx,%eax
  8006da:	d1 f8                	sar    %eax
  8006dc:	83 ec 04             	sub    $0x4,%esp
  8006df:	50                   	push   %eax
  8006e0:	ff 75 0c             	pushl  0xc(%ebp)
  8006e3:	ff 75 08             	pushl  0x8(%ebp)
  8006e6:	e8 88 fd ff ff       	call   800473 <KthElement>
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	89 c2                	mov    %eax,%edx
  8006f0:	8b 45 20             	mov    0x20(%ebp),%eax
  8006f3:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  8006f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f8:	8b 50 04             	mov    0x4(%eax),%edx
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800700:	89 cb                	mov    %ecx,%ebx
  800702:	c1 fb 1f             	sar    $0x1f,%ebx
  800705:	53                   	push   %ebx
  800706:	51                   	push   %ecx
  800707:	52                   	push   %edx
  800708:	50                   	push   %eax
  800709:	e8 ca 3e 00 00       	call   8045d8 <__divdi3>
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800714:	89 01                	mov    %eax,(%ecx)
  800716:	89 51 04             	mov    %edx,0x4(%ecx)
	(*var) = 0;
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800722:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800729:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800730:	eb 7e                	jmp    8007b0 <ArrayStats+0x1ad>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 50 04             	mov    0x4(%eax),%edx
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80073d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	89 c1                	mov    %eax,%ecx
  800753:	89 c3                	mov    %eax,%ebx
  800755:	c1 fb 1f             	sar    $0x1f,%ebx
  800758:	8b 45 10             	mov    0x10(%ebp),%eax
  80075b:	8b 50 04             	mov    0x4(%eax),%edx
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	29 c1                	sub    %eax,%ecx
  800762:	19 d3                	sbb    %edx,%ebx
  800764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800767:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	01 d0                	add    %edx,%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	89 c6                	mov    %eax,%esi
  800777:	89 c7                	mov    %eax,%edi
  800779:	c1 ff 1f             	sar    $0x1f,%edi
  80077c:	8b 45 10             	mov    0x10(%ebp),%eax
  80077f:	8b 50 04             	mov    0x4(%eax),%edx
  800782:	8b 00                	mov    (%eax),%eax
  800784:	29 c6                	sub    %eax,%esi
  800786:	19 d7                	sbb    %edx,%edi
  800788:	89 f0                	mov    %esi,%eax
  80078a:	89 fa                	mov    %edi,%edx
  80078c:	89 df                	mov    %ebx,%edi
  80078e:	0f af f8             	imul   %eax,%edi
  800791:	89 d6                	mov    %edx,%esi
  800793:	0f af f1             	imul   %ecx,%esi
  800796:	01 fe                	add    %edi,%esi
  800798:	f7 e1                	mul    %ecx
  80079a:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  80079d:	89 ca                	mov    %ecx,%edx
  80079f:	03 45 d0             	add    -0x30(%ebp),%eax
  8007a2:	13 55 d4             	adc    -0x2c(%ebp),%edx
  8007a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007a8:	89 01                	mov    %eax,(%ecx)
  8007aa:	89 51 04             	mov    %edx,0x4(%ecx)

	(*med) = KthElement(Elements, NumOfElements, (NumOfElements+1)/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8007ad:	ff 45 e4             	incl   -0x1c(%ebp)
  8007b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8007b6:	0f 8c 76 ff ff ff    	jl     800732 <ArrayStats+0x12f>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
	}
	(*var) /= NumOfElements;
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8b 50 04             	mov    0x4(%eax),%edx
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c7:	89 cb                	mov    %ecx,%ebx
  8007c9:	c1 fb 1f             	sar    $0x1f,%ebx
  8007cc:	53                   	push   %ebx
  8007cd:	51                   	push   %ecx
  8007ce:	52                   	push   %edx
  8007cf:	50                   	push   %eax
  8007d0:	e8 03 3e 00 00       	call   8045d8 <__divdi3>
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007db:	89 01                	mov    %eax,(%ecx)
  8007dd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8007e0:	90                   	nop
  8007e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007e4:	5b                   	pop    %ebx
  8007e5:	5e                   	pop    %esi
  8007e6:	5f                   	pop    %edi
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	57                   	push   %edi
  8007ed:	56                   	push   %esi
  8007ee:	53                   	push   %ebx
  8007ef:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8007f2:	e8 bf 2d 00 00       	call   8035b6 <sys_getenvindex>
  8007f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8007fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007fd:	89 d0                	mov    %edx,%eax
  8007ff:	c1 e0 02             	shl    $0x2,%eax
  800802:	01 d0                	add    %edx,%eax
  800804:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80080b:	01 d0                	add    %edx,%eax
  80080d:	89 c2                	mov    %eax,%edx
  80080f:	c1 e2 04             	shl    $0x4,%edx
  800812:	29 c2                	sub    %eax,%edx
  800814:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80081b:	89 c2                	mov    %eax,%edx
  80081d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800823:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800828:	a1 20 60 80 00       	mov    0x806020,%eax
  80082d:	8a 40 20             	mov    0x20(%eax),%al
  800830:	84 c0                	test   %al,%al
  800832:	74 0d                	je     800841 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800834:	a1 20 60 80 00       	mov    0x806020,%eax
  800839:	83 c0 20             	add    $0x20,%eax
  80083c:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800841:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800845:	7e 0a                	jle    800851 <libmain+0x68>
		binaryname = argv[0];
  800847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	ff 75 0c             	pushl  0xc(%ebp)
  800857:	ff 75 08             	pushl  0x8(%ebp)
  80085a:	e8 b2 f8 ff ff       	call   800111 <_main>
  80085f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800862:	a1 00 60 80 00       	mov    0x806000,%eax
  800867:	85 c0                	test   %eax,%eax
  800869:	0f 84 01 01 00 00    	je     800970 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80086f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800875:	bb 78 4c 80 00       	mov    $0x804c78,%ebx
  80087a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80087f:	89 c7                	mov    %eax,%edi
  800881:	89 de                	mov    %ebx,%esi
  800883:	89 d1                	mov    %edx,%ecx
  800885:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800887:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80088a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80088f:	b0 00                	mov    $0x0,%al
  800891:	89 d7                	mov    %edx,%edi
  800893:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800895:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80089c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	50                   	push   %eax
  8008a3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8008a9:	50                   	push   %eax
  8008aa:	e8 3d 2f 00 00       	call   8037ec <sys_utilities>
  8008af:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8008b2:	e8 86 2a 00 00       	call   80333d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8008b7:	83 ec 0c             	sub    $0xc,%esp
  8008ba:	68 98 4b 80 00       	push   $0x804b98
  8008bf:	e8 be 01 00 00       	call   800a82 <cprintf>
  8008c4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8008c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ca:	85 c0                	test   %eax,%eax
  8008cc:	74 18                	je     8008e6 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8008ce:	e8 37 2f 00 00       	call   80380a <sys_get_optimal_num_faults>
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	50                   	push   %eax
  8008d7:	68 c0 4b 80 00       	push   $0x804bc0
  8008dc:	e8 a1 01 00 00       	call   800a82 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	eb 59                	jmp    80093f <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008e6:	a1 20 60 80 00       	mov    0x806020,%eax
  8008eb:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8008f1:	a1 20 60 80 00       	mov    0x806020,%eax
  8008f6:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8008fc:	83 ec 04             	sub    $0x4,%esp
  8008ff:	52                   	push   %edx
  800900:	50                   	push   %eax
  800901:	68 e4 4b 80 00       	push   $0x804be4
  800906:	e8 77 01 00 00       	call   800a82 <cprintf>
  80090b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80090e:	a1 20 60 80 00       	mov    0x806020,%eax
  800913:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800919:	a1 20 60 80 00       	mov    0x806020,%eax
  80091e:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800924:	a1 20 60 80 00       	mov    0x806020,%eax
  800929:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80092f:	51                   	push   %ecx
  800930:	52                   	push   %edx
  800931:	50                   	push   %eax
  800932:	68 0c 4c 80 00       	push   $0x804c0c
  800937:	e8 46 01 00 00       	call   800a82 <cprintf>
  80093c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80093f:	a1 20 60 80 00       	mov    0x806020,%eax
  800944:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	50                   	push   %eax
  80094e:	68 64 4c 80 00       	push   $0x804c64
  800953:	e8 2a 01 00 00       	call   800a82 <cprintf>
  800958:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80095b:	83 ec 0c             	sub    $0xc,%esp
  80095e:	68 98 4b 80 00       	push   $0x804b98
  800963:	e8 1a 01 00 00       	call   800a82 <cprintf>
  800968:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80096b:	e8 e7 29 00 00       	call   803357 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800970:	e8 1f 00 00 00       	call   800994 <exit>
}
  800975:	90                   	nop
  800976:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800979:	5b                   	pop    %ebx
  80097a:	5e                   	pop    %esi
  80097b:	5f                   	pop    %edi
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    

0080097e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	6a 00                	push   $0x0
  800989:	e8 f4 2b 00 00       	call   803582 <sys_destroy_env>
  80098e:	83 c4 10             	add    $0x10,%esp
}
  800991:	90                   	nop
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <exit>:

void
exit(void)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80099a:	e8 49 2c 00 00       	call   8035e8 <sys_exit_env>
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	8d 48 01             	lea    0x1(%eax),%ecx
  8009b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b4:	89 0a                	mov    %ecx,(%edx)
  8009b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b9:	88 d1                	mov    %dl,%cl
  8009bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009be:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c5:	8b 00                	mov    (%eax),%eax
  8009c7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009cc:	75 30                	jne    8009fe <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009ce:	8b 15 18 e1 81 00    	mov    0x81e118,%edx
  8009d4:	a0 44 60 80 00       	mov    0x806044,%al
  8009d9:	0f b6 c0             	movzbl %al,%eax
  8009dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009df:	8b 09                	mov    (%ecx),%ecx
  8009e1:	89 cb                	mov    %ecx,%ebx
  8009e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e6:	83 c1 08             	add    $0x8,%ecx
  8009e9:	52                   	push   %edx
  8009ea:	50                   	push   %eax
  8009eb:	53                   	push   %ebx
  8009ec:	51                   	push   %ecx
  8009ed:	e8 07 29 00 00       	call   8032f9 <sys_cputs>
  8009f2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a01:	8b 40 04             	mov    0x4(%eax),%eax
  800a04:	8d 50 01             	lea    0x1(%eax),%edx
  800a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a0d:	90                   	nop
  800a0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a11:	c9                   	leave  
  800a12:	c3                   	ret    

00800a13 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a1c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a23:	00 00 00 
	b.cnt = 0;
  800a26:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a2d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	ff 75 08             	pushl  0x8(%ebp)
  800a36:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a3c:	50                   	push   %eax
  800a3d:	68 a2 09 80 00       	push   $0x8009a2
  800a42:	e8 5a 02 00 00       	call   800ca1 <vprintfmt>
  800a47:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a4a:	8b 15 18 e1 81 00    	mov    0x81e118,%edx
  800a50:	a0 44 60 80 00       	mov    0x806044,%al
  800a55:	0f b6 c0             	movzbl %al,%eax
  800a58:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a5e:	52                   	push   %edx
  800a5f:	50                   	push   %eax
  800a60:	51                   	push   %ecx
  800a61:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a67:	83 c0 08             	add    $0x8,%eax
  800a6a:	50                   	push   %eax
  800a6b:	e8 89 28 00 00       	call   8032f9 <sys_cputs>
  800a70:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a73:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800a7a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a88:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  800a8f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9e:	50                   	push   %eax
  800a9f:	e8 6f ff ff ff       	call   800a13 <vcprintf>
  800aa4:	83 c4 10             	add    $0x10,%esp
  800aa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aad:	c9                   	leave  
  800aae:	c3                   	ret    

00800aaf <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ab5:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	c1 e0 08             	shl    $0x8,%eax
  800ac2:	a3 18 e1 81 00       	mov    %eax,0x81e118
	va_start(ap, fmt);
  800ac7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aca:	83 c0 04             	add    $0x4,%eax
  800acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad9:	50                   	push   %eax
  800ada:	e8 34 ff ff ff       	call   800a13 <vcprintf>
  800adf:	83 c4 10             	add    $0x10,%esp
  800ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800ae5:	c7 05 18 e1 81 00 00 	movl   $0x700,0x81e118
  800aec:	07 00 00 

	return cnt;
  800aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800afa:	e8 3e 28 00 00       	call   80333d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800aff:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0e:	50                   	push   %eax
  800b0f:	e8 ff fe ff ff       	call   800a13 <vcprintf>
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b1a:	e8 38 28 00 00       	call   803357 <sys_unlock_cons>
	return cnt;
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b22:	c9                   	leave  
  800b23:	c3                   	ret    

00800b24 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	53                   	push   %ebx
  800b28:	83 ec 14             	sub    $0x14,%esp
  800b2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b31:	8b 45 14             	mov    0x14(%ebp),%eax
  800b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b37:	8b 45 18             	mov    0x18(%ebp),%eax
  800b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b42:	77 55                	ja     800b99 <printnum+0x75>
  800b44:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b47:	72 05                	jb     800b4e <printnum+0x2a>
  800b49:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b4c:	77 4b                	ja     800b99 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b4e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b51:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b54:	8b 45 18             	mov    0x18(%ebp),%eax
  800b57:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5c:	52                   	push   %edx
  800b5d:	50                   	push   %eax
  800b5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b61:	ff 75 f0             	pushl  -0x10(%ebp)
  800b64:	e8 d7 3b 00 00       	call   804740 <__udivdi3>
  800b69:	83 c4 10             	add    $0x10,%esp
  800b6c:	83 ec 04             	sub    $0x4,%esp
  800b6f:	ff 75 20             	pushl  0x20(%ebp)
  800b72:	53                   	push   %ebx
  800b73:	ff 75 18             	pushl  0x18(%ebp)
  800b76:	52                   	push   %edx
  800b77:	50                   	push   %eax
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	ff 75 08             	pushl  0x8(%ebp)
  800b7e:	e8 a1 ff ff ff       	call   800b24 <printnum>
  800b83:	83 c4 20             	add    $0x20,%esp
  800b86:	eb 1a                	jmp    800ba2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b88:	83 ec 08             	sub    $0x8,%esp
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	ff 75 20             	pushl  0x20(%ebp)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	ff d0                	call   *%eax
  800b96:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b99:	ff 4d 1c             	decl   0x1c(%ebp)
  800b9c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ba0:	7f e6                	jg     800b88 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ba2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ba5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb0:	53                   	push   %ebx
  800bb1:	51                   	push   %ecx
  800bb2:	52                   	push   %edx
  800bb3:	50                   	push   %eax
  800bb4:	e8 97 3c 00 00       	call   804850 <__umoddi3>
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	05 f4 4e 80 00       	add    $0x804ef4,%eax
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	0f be c0             	movsbl %al,%eax
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	50                   	push   %eax
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
}
  800bd5:	90                   	nop
  800bd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bde:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800be2:	7e 1c                	jle    800c00 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	8d 50 08             	lea    0x8(%eax),%edx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	89 10                	mov    %edx,(%eax)
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	8b 00                	mov    (%eax),%eax
  800bf6:	83 e8 08             	sub    $0x8,%eax
  800bf9:	8b 50 04             	mov    0x4(%eax),%edx
  800bfc:	8b 00                	mov    (%eax),%eax
  800bfe:	eb 40                	jmp    800c40 <getuint+0x65>
	else if (lflag)
  800c00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c04:	74 1e                	je     800c24 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	8d 50 04             	lea    0x4(%eax),%edx
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	89 10                	mov    %edx,(%eax)
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8b 00                	mov    (%eax),%eax
  800c18:	83 e8 04             	sub    $0x4,%eax
  800c1b:	8b 00                	mov    (%eax),%eax
  800c1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c22:	eb 1c                	jmp    800c40 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	8b 00                	mov    (%eax),%eax
  800c29:	8d 50 04             	lea    0x4(%eax),%edx
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	89 10                	mov    %edx,(%eax)
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	8b 00                	mov    (%eax),%eax
  800c36:	83 e8 04             	sub    $0x4,%eax
  800c39:	8b 00                	mov    (%eax),%eax
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    

00800c42 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c45:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c49:	7e 1c                	jle    800c67 <getint+0x25>
		return va_arg(*ap, long long);
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	8b 00                	mov    (%eax),%eax
  800c50:	8d 50 08             	lea    0x8(%eax),%edx
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	89 10                	mov    %edx,(%eax)
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8b 00                	mov    (%eax),%eax
  800c5d:	83 e8 08             	sub    $0x8,%eax
  800c60:	8b 50 04             	mov    0x4(%eax),%edx
  800c63:	8b 00                	mov    (%eax),%eax
  800c65:	eb 38                	jmp    800c9f <getint+0x5d>
	else if (lflag)
  800c67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6b:	74 1a                	je     800c87 <getint+0x45>
		return va_arg(*ap, long);
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	8d 50 04             	lea    0x4(%eax),%edx
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	89 10                	mov    %edx,(%eax)
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8b 00                	mov    (%eax),%eax
  800c7f:	83 e8 04             	sub    $0x4,%eax
  800c82:	8b 00                	mov    (%eax),%eax
  800c84:	99                   	cltd   
  800c85:	eb 18                	jmp    800c9f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8b 00                	mov    (%eax),%eax
  800c8c:	8d 50 04             	lea    0x4(%eax),%edx
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	89 10                	mov    %edx,(%eax)
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8b 00                	mov    (%eax),%eax
  800c99:	83 e8 04             	sub    $0x4,%eax
  800c9c:	8b 00                	mov    (%eax),%eax
  800c9e:	99                   	cltd   
}
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	56                   	push   %esi
  800ca5:	53                   	push   %ebx
  800ca6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca9:	eb 17                	jmp    800cc2 <vprintfmt+0x21>
			if (ch == '\0')
  800cab:	85 db                	test   %ebx,%ebx
  800cad:	0f 84 c1 03 00 00    	je     801074 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	53                   	push   %ebx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	ff d0                	call   *%eax
  800cbf:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	8d 50 01             	lea    0x1(%eax),%edx
  800cc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	0f b6 d8             	movzbl %al,%ebx
  800cd0:	83 fb 25             	cmp    $0x25,%ebx
  800cd3:	75 d6                	jne    800cab <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cd5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cd9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ce0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ce7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf8:	8d 50 01             	lea    0x1(%eax),%edx
  800cfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	0f b6 d8             	movzbl %al,%ebx
  800d03:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d06:	83 f8 5b             	cmp    $0x5b,%eax
  800d09:	0f 87 3d 03 00 00    	ja     80104c <vprintfmt+0x3ab>
  800d0f:	8b 04 85 18 4f 80 00 	mov    0x804f18(,%eax,4),%eax
  800d16:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d18:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d1c:	eb d7                	jmp    800cf5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d1e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d22:	eb d1                	jmp    800cf5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d24:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d2e:	89 d0                	mov    %edx,%eax
  800d30:	c1 e0 02             	shl    $0x2,%eax
  800d33:	01 d0                	add    %edx,%eax
  800d35:	01 c0                	add    %eax,%eax
  800d37:	01 d8                	add    %ebx,%eax
  800d39:	83 e8 30             	sub    $0x30,%eax
  800d3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d47:	83 fb 2f             	cmp    $0x2f,%ebx
  800d4a:	7e 3e                	jle    800d8a <vprintfmt+0xe9>
  800d4c:	83 fb 39             	cmp    $0x39,%ebx
  800d4f:	7f 39                	jg     800d8a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d51:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d54:	eb d5                	jmp    800d2b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d56:	8b 45 14             	mov    0x14(%ebp),%eax
  800d59:	83 c0 04             	add    $0x4,%eax
  800d5c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d62:	83 e8 04             	sub    $0x4,%eax
  800d65:	8b 00                	mov    (%eax),%eax
  800d67:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d6a:	eb 1f                	jmp    800d8b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d70:	79 83                	jns    800cf5 <vprintfmt+0x54>
				width = 0;
  800d72:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d79:	e9 77 ff ff ff       	jmp    800cf5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d7e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d85:	e9 6b ff ff ff       	jmp    800cf5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d8a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8f:	0f 89 60 ff ff ff    	jns    800cf5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d9b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800da2:	e9 4e ff ff ff       	jmp    800cf5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800da7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800daa:	e9 46 ff ff ff       	jmp    800cf5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800daf:	8b 45 14             	mov    0x14(%ebp),%eax
  800db2:	83 c0 04             	add    $0x4,%eax
  800db5:	89 45 14             	mov    %eax,0x14(%ebp)
  800db8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbb:	83 e8 04             	sub    $0x4,%eax
  800dbe:	8b 00                	mov    (%eax),%eax
  800dc0:	83 ec 08             	sub    $0x8,%esp
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	50                   	push   %eax
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	ff d0                	call   *%eax
  800dcc:	83 c4 10             	add    $0x10,%esp
			break;
  800dcf:	e9 9b 02 00 00       	jmp    80106f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd7:	83 c0 04             	add    $0x4,%eax
  800dda:	89 45 14             	mov    %eax,0x14(%ebp)
  800ddd:	8b 45 14             	mov    0x14(%ebp),%eax
  800de0:	83 e8 04             	sub    $0x4,%eax
  800de3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800de5:	85 db                	test   %ebx,%ebx
  800de7:	79 02                	jns    800deb <vprintfmt+0x14a>
				err = -err;
  800de9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800deb:	83 fb 64             	cmp    $0x64,%ebx
  800dee:	7f 0b                	jg     800dfb <vprintfmt+0x15a>
  800df0:	8b 34 9d 60 4d 80 00 	mov    0x804d60(,%ebx,4),%esi
  800df7:	85 f6                	test   %esi,%esi
  800df9:	75 19                	jne    800e14 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dfb:	53                   	push   %ebx
  800dfc:	68 05 4f 80 00       	push   $0x804f05
  800e01:	ff 75 0c             	pushl  0xc(%ebp)
  800e04:	ff 75 08             	pushl  0x8(%ebp)
  800e07:	e8 70 02 00 00       	call   80107c <printfmt>
  800e0c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e0f:	e9 5b 02 00 00       	jmp    80106f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e14:	56                   	push   %esi
  800e15:	68 0e 4f 80 00       	push   $0x804f0e
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 57 02 00 00       	call   80107c <printfmt>
  800e25:	83 c4 10             	add    $0x10,%esp
			break;
  800e28:	e9 42 02 00 00       	jmp    80106f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e30:	83 c0 04             	add    $0x4,%eax
  800e33:	89 45 14             	mov    %eax,0x14(%ebp)
  800e36:	8b 45 14             	mov    0x14(%ebp),%eax
  800e39:	83 e8 04             	sub    $0x4,%eax
  800e3c:	8b 30                	mov    (%eax),%esi
  800e3e:	85 f6                	test   %esi,%esi
  800e40:	75 05                	jne    800e47 <vprintfmt+0x1a6>
				p = "(null)";
  800e42:	be 11 4f 80 00       	mov    $0x804f11,%esi
			if (width > 0 && padc != '-')
  800e47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e4b:	7e 6d                	jle    800eba <vprintfmt+0x219>
  800e4d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e51:	74 67                	je     800eba <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e56:	83 ec 08             	sub    $0x8,%esp
  800e59:	50                   	push   %eax
  800e5a:	56                   	push   %esi
  800e5b:	e8 1e 03 00 00       	call   80117e <strnlen>
  800e60:	83 c4 10             	add    $0x10,%esp
  800e63:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e66:	eb 16                	jmp    800e7e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e68:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e6c:	83 ec 08             	sub    $0x8,%esp
  800e6f:	ff 75 0c             	pushl  0xc(%ebp)
  800e72:	50                   	push   %eax
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	ff d0                	call   *%eax
  800e78:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800e7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e82:	7f e4                	jg     800e68 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e84:	eb 34                	jmp    800eba <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e86:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e8a:	74 1c                	je     800ea8 <vprintfmt+0x207>
  800e8c:	83 fb 1f             	cmp    $0x1f,%ebx
  800e8f:	7e 05                	jle    800e96 <vprintfmt+0x1f5>
  800e91:	83 fb 7e             	cmp    $0x7e,%ebx
  800e94:	7e 12                	jle    800ea8 <vprintfmt+0x207>
					putch('?', putdat);
  800e96:	83 ec 08             	sub    $0x8,%esp
  800e99:	ff 75 0c             	pushl  0xc(%ebp)
  800e9c:	6a 3f                	push   $0x3f
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	ff d0                	call   *%eax
  800ea3:	83 c4 10             	add    $0x10,%esp
  800ea6:	eb 0f                	jmp    800eb7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ea8:	83 ec 08             	sub    $0x8,%esp
  800eab:	ff 75 0c             	pushl  0xc(%ebp)
  800eae:	53                   	push   %ebx
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	ff d0                	call   *%eax
  800eb4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb7:	ff 4d e4             	decl   -0x1c(%ebp)
  800eba:	89 f0                	mov    %esi,%eax
  800ebc:	8d 70 01             	lea    0x1(%eax),%esi
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	0f be d8             	movsbl %al,%ebx
  800ec4:	85 db                	test   %ebx,%ebx
  800ec6:	74 24                	je     800eec <vprintfmt+0x24b>
  800ec8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ecc:	78 b8                	js     800e86 <vprintfmt+0x1e5>
  800ece:	ff 4d e0             	decl   -0x20(%ebp)
  800ed1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ed5:	79 af                	jns    800e86 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ed7:	eb 13                	jmp    800eec <vprintfmt+0x24b>
				putch(' ', putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	6a 20                	push   $0x20
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	ff d0                	call   *%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee9:	ff 4d e4             	decl   -0x1c(%ebp)
  800eec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef0:	7f e7                	jg     800ed9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ef2:	e9 78 01 00 00       	jmp    80106f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 e8             	pushl  -0x18(%ebp)
  800efd:	8d 45 14             	lea    0x14(%ebp),%eax
  800f00:	50                   	push   %eax
  800f01:	e8 3c fd ff ff       	call   800c42 <getint>
  800f06:	83 c4 10             	add    $0x10,%esp
  800f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f15:	85 d2                	test   %edx,%edx
  800f17:	79 23                	jns    800f3c <vprintfmt+0x29b>
				putch('-', putdat);
  800f19:	83 ec 08             	sub    $0x8,%esp
  800f1c:	ff 75 0c             	pushl  0xc(%ebp)
  800f1f:	6a 2d                	push   $0x2d
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	ff d0                	call   *%eax
  800f26:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2f:	f7 d8                	neg    %eax
  800f31:	83 d2 00             	adc    $0x0,%edx
  800f34:	f7 da                	neg    %edx
  800f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f39:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f3c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f43:	e9 bc 00 00 00       	jmp    801004 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f48:	83 ec 08             	sub    $0x8,%esp
  800f4b:	ff 75 e8             	pushl  -0x18(%ebp)
  800f4e:	8d 45 14             	lea    0x14(%ebp),%eax
  800f51:	50                   	push   %eax
  800f52:	e8 84 fc ff ff       	call   800bdb <getuint>
  800f57:	83 c4 10             	add    $0x10,%esp
  800f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f5d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f60:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f67:	e9 98 00 00 00       	jmp    801004 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	6a 58                	push   $0x58
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	ff d0                	call   *%eax
  800f79:	83 c4 10             	add    $0x10,%esp
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
			break;
  800f9c:	e9 ce 00 00 00       	jmp    80106f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	ff 75 0c             	pushl  0xc(%ebp)
  800fa7:	6a 30                	push   $0x30
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	ff d0                	call   *%eax
  800fae:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	6a 78                	push   $0x78
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	ff d0                	call   *%eax
  800fbe:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc4:	83 c0 04             	add    $0x4,%eax
  800fc7:	89 45 14             	mov    %eax,0x14(%ebp)
  800fca:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcd:	83 e8 04             	sub    $0x4,%eax
  800fd0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fe3:	eb 1f                	jmp    801004 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	ff 75 e8             	pushl  -0x18(%ebp)
  800feb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fee:	50                   	push   %eax
  800fef:	e8 e7 fb ff ff       	call   800bdb <getuint>
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ffd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801004:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801008:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80100b:	83 ec 04             	sub    $0x4,%esp
  80100e:	52                   	push   %edx
  80100f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801012:	50                   	push   %eax
  801013:	ff 75 f4             	pushl  -0xc(%ebp)
  801016:	ff 75 f0             	pushl  -0x10(%ebp)
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	ff 75 08             	pushl  0x8(%ebp)
  80101f:	e8 00 fb ff ff       	call   800b24 <printnum>
  801024:	83 c4 20             	add    $0x20,%esp
			break;
  801027:	eb 46                	jmp    80106f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801029:	83 ec 08             	sub    $0x8,%esp
  80102c:	ff 75 0c             	pushl  0xc(%ebp)
  80102f:	53                   	push   %ebx
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	ff d0                	call   *%eax
  801035:	83 c4 10             	add    $0x10,%esp
			break;
  801038:	eb 35                	jmp    80106f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80103a:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  801041:	eb 2c                	jmp    80106f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801043:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  80104a:	eb 23                	jmp    80106f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	6a 25                	push   $0x25
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80105c:	ff 4d 10             	decl   0x10(%ebp)
  80105f:	eb 03                	jmp    801064 <vprintfmt+0x3c3>
  801061:	ff 4d 10             	decl   0x10(%ebp)
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	48                   	dec    %eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 25                	cmp    $0x25,%al
  80106c:	75 f3                	jne    801061 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80106e:	90                   	nop
		}
	}
  80106f:	e9 35 fc ff ff       	jmp    800ca9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801074:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801075:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801078:	5b                   	pop    %ebx
  801079:	5e                   	pop    %esi
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    

0080107c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801082:	8d 45 10             	lea    0x10(%ebp),%eax
  801085:	83 c0 04             	add    $0x4,%eax
  801088:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80108b:	8b 45 10             	mov    0x10(%ebp),%eax
  80108e:	ff 75 f4             	pushl  -0xc(%ebp)
  801091:	50                   	push   %eax
  801092:	ff 75 0c             	pushl  0xc(%ebp)
  801095:	ff 75 08             	pushl  0x8(%ebp)
  801098:	e8 04 fc ff ff       	call   800ca1 <vprintfmt>
  80109d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010a0:	90                   	nop
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a9:	8b 40 08             	mov    0x8(%eax),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b8:	8b 10                	mov    (%eax),%edx
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	8b 40 04             	mov    0x4(%eax),%eax
  8010c0:	39 c2                	cmp    %eax,%edx
  8010c2:	73 12                	jae    8010d6 <sprintputch+0x33>
		*b->buf++ = ch;
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	8b 00                	mov    (%eax),%eax
  8010c9:	8d 48 01             	lea    0x1(%eax),%ecx
  8010cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cf:	89 0a                	mov    %ecx,(%edx)
  8010d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d4:	88 10                	mov    %dl,(%eax)
}
  8010d6:	90                   	nop
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	01 d0                	add    %edx,%eax
  8010f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010fe:	74 06                	je     801106 <vsnprintf+0x2d>
  801100:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801104:	7f 07                	jg     80110d <vsnprintf+0x34>
		return -E_INVAL;
  801106:	b8 03 00 00 00       	mov    $0x3,%eax
  80110b:	eb 20                	jmp    80112d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80110d:	ff 75 14             	pushl  0x14(%ebp)
  801110:	ff 75 10             	pushl  0x10(%ebp)
  801113:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801116:	50                   	push   %eax
  801117:	68 a3 10 80 00       	push   $0x8010a3
  80111c:	e8 80 fb ff ff       	call   800ca1 <vprintfmt>
  801121:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801127:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801135:	8d 45 10             	lea    0x10(%ebp),%eax
  801138:	83 c0 04             	add    $0x4,%eax
  80113b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80113e:	8b 45 10             	mov    0x10(%ebp),%eax
  801141:	ff 75 f4             	pushl  -0xc(%ebp)
  801144:	50                   	push   %eax
  801145:	ff 75 0c             	pushl  0xc(%ebp)
  801148:	ff 75 08             	pushl  0x8(%ebp)
  80114b:	e8 89 ff ff ff       	call   8010d9 <vsnprintf>
  801150:	83 c4 10             	add    $0x10,%esp
  801153:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801156:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801159:	c9                   	leave  
  80115a:	c3                   	ret    

0080115b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801161:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801168:	eb 06                	jmp    801170 <strlen+0x15>
		n++;
  80116a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80116d:	ff 45 08             	incl   0x8(%ebp)
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	84 c0                	test   %al,%al
  801177:	75 f1                	jne    80116a <strlen+0xf>
		n++;
	return n;
  801179:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80117c:	c9                   	leave  
  80117d:	c3                   	ret    

0080117e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801184:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80118b:	eb 09                	jmp    801196 <strnlen+0x18>
		n++;
  80118d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801190:	ff 45 08             	incl   0x8(%ebp)
  801193:	ff 4d 0c             	decl   0xc(%ebp)
  801196:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80119a:	74 09                	je     8011a5 <strnlen+0x27>
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	84 c0                	test   %al,%al
  8011a3:	75 e8                	jne    80118d <strnlen+0xf>
		n++;
	return n;
  8011a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011b6:	90                   	nop
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8d 50 01             	lea    0x1(%eax),%edx
  8011bd:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011c6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011c9:	8a 12                	mov    (%edx),%dl
  8011cb:	88 10                	mov    %dl,(%eax)
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	84 c0                	test   %al,%al
  8011d1:	75 e4                	jne    8011b7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011eb:	eb 1f                	jmp    80120c <strncpy+0x34>
		*dst++ = *src;
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	8d 50 01             	lea    0x1(%eax),%edx
  8011f3:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f9:	8a 12                	mov    (%edx),%dl
  8011fb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	84 c0                	test   %al,%al
  801204:	74 03                	je     801209 <strncpy+0x31>
			src++;
  801206:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801209:	ff 45 fc             	incl   -0x4(%ebp)
  80120c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801212:	72 d9                	jb     8011ed <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801214:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801217:	c9                   	leave  
  801218:	c3                   	ret    

00801219 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801225:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801229:	74 30                	je     80125b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80122b:	eb 16                	jmp    801243 <strlcpy+0x2a>
			*dst++ = *src++;
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8d 50 01             	lea    0x1(%eax),%edx
  801233:	89 55 08             	mov    %edx,0x8(%ebp)
  801236:	8b 55 0c             	mov    0xc(%ebp),%edx
  801239:	8d 4a 01             	lea    0x1(%edx),%ecx
  80123c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80123f:	8a 12                	mov    (%edx),%dl
  801241:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801243:	ff 4d 10             	decl   0x10(%ebp)
  801246:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124a:	74 09                	je     801255 <strlcpy+0x3c>
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	84 c0                	test   %al,%al
  801253:	75 d8                	jne    80122d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80125b:	8b 55 08             	mov    0x8(%ebp),%edx
  80125e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801261:	29 c2                	sub    %eax,%edx
  801263:	89 d0                	mov    %edx,%eax
}
  801265:	c9                   	leave  
  801266:	c3                   	ret    

00801267 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80126a:	eb 06                	jmp    801272 <strcmp+0xb>
		p++, q++;
  80126c:	ff 45 08             	incl   0x8(%ebp)
  80126f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 0e                	je     801289 <strcmp+0x22>
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 10                	mov    (%eax),%dl
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	38 c2                	cmp    %al,%dl
  801287:	74 e3                	je     80126c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	0f b6 d0             	movzbl %al,%edx
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	0f b6 c0             	movzbl %al,%eax
  801299:	29 c2                	sub    %eax,%edx
  80129b:	89 d0                	mov    %edx,%eax
}
  80129d:	5d                   	pop    %ebp
  80129e:	c3                   	ret    

0080129f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012a2:	eb 09                	jmp    8012ad <strncmp+0xe>
		n--, p++, q++;
  8012a4:	ff 4d 10             	decl   0x10(%ebp)
  8012a7:	ff 45 08             	incl   0x8(%ebp)
  8012aa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b1:	74 17                	je     8012ca <strncmp+0x2b>
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	84 c0                	test   %al,%al
  8012ba:	74 0e                	je     8012ca <strncmp+0x2b>
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	8a 10                	mov    (%eax),%dl
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	38 c2                	cmp    %al,%dl
  8012c8:	74 da                	je     8012a4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ce:	75 07                	jne    8012d7 <strncmp+0x38>
		return 0;
  8012d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d5:	eb 14                	jmp    8012eb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	8a 00                	mov    (%eax),%al
  8012dc:	0f b6 d0             	movzbl %al,%edx
  8012df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	0f b6 c0             	movzbl %al,%eax
  8012e7:	29 c2                	sub    %eax,%edx
  8012e9:	89 d0                	mov    %edx,%eax
}
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 04             	sub    $0x4,%esp
  8012f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012f9:	eb 12                	jmp    80130d <strchr+0x20>
		if (*s == c)
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801303:	75 05                	jne    80130a <strchr+0x1d>
			return (char *) s;
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	eb 11                	jmp    80131b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80130a:	ff 45 08             	incl   0x8(%ebp)
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	84 c0                	test   %al,%al
  801314:	75 e5                	jne    8012fb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801316:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	83 ec 04             	sub    $0x4,%esp
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801329:	eb 0d                	jmp    801338 <strfind+0x1b>
		if (*s == c)
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801333:	74 0e                	je     801343 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801335:	ff 45 08             	incl   0x8(%ebp)
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	84 c0                	test   %al,%al
  80133f:	75 ea                	jne    80132b <strfind+0xe>
  801341:	eb 01                	jmp    801344 <strfind+0x27>
		if (*s == c)
			break;
  801343:	90                   	nop
	return (char *) s;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801355:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801359:	76 63                	jbe    8013be <memset+0x75>
		uint64 data_block = c;
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	99                   	cltd   
  80135f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801362:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801368:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80136b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80136f:	c1 e0 08             	shl    $0x8,%eax
  801372:	09 45 f0             	or     %eax,-0x10(%ebp)
  801375:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801382:	c1 e0 10             	shl    $0x10,%eax
  801385:	09 45 f0             	or     %eax,-0x10(%ebp)
  801388:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80138b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801391:	89 c2                	mov    %eax,%edx
  801393:	b8 00 00 00 00       	mov    $0x0,%eax
  801398:	09 45 f0             	or     %eax,-0x10(%ebp)
  80139b:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80139e:	eb 18                	jmp    8013b8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8013a0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013a3:	8d 41 08             	lea    0x8(%ecx),%eax
  8013a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8013a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013af:	89 01                	mov    %eax,(%ecx)
  8013b1:	89 51 04             	mov    %edx,0x4(%ecx)
  8013b4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8013b8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013bc:	77 e2                	ja     8013a0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8013be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c2:	74 23                	je     8013e7 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8013c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013ca:	eb 0e                	jmp    8013da <memset+0x91>
			*p8++ = (uint8)c;
  8013cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cf:	8d 50 01             	lea    0x1(%eax),%edx
  8013d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8013da:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013e0:	89 55 10             	mov    %edx,0x10(%ebp)
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	75 e5                	jne    8013cc <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8013fe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801402:	76 24                	jbe    801428 <memcpy+0x3c>
		while(n >= 8){
  801404:	eb 1c                	jmp    801422 <memcpy+0x36>
			*d64 = *s64;
  801406:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801409:	8b 50 04             	mov    0x4(%eax),%edx
  80140c:	8b 00                	mov    (%eax),%eax
  80140e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801411:	89 01                	mov    %eax,(%ecx)
  801413:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801416:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80141a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80141e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801422:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801426:	77 de                	ja     801406 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801428:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142c:	74 31                	je     80145f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80142e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801431:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801437:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80143a:	eb 16                	jmp    801452 <memcpy+0x66>
			*d8++ = *s8++;
  80143c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143f:	8d 50 01             	lea    0x1(%eax),%edx
  801442:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801445:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801448:	8d 4a 01             	lea    0x1(%edx),%ecx
  80144b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80144e:	8a 12                	mov    (%edx),%dl
  801450:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801452:	8b 45 10             	mov    0x10(%ebp),%eax
  801455:	8d 50 ff             	lea    -0x1(%eax),%edx
  801458:	89 55 10             	mov    %edx,0x10(%ebp)
  80145b:	85 c0                	test   %eax,%eax
  80145d:	75 dd                	jne    80143c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80146a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801476:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801479:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80147c:	73 50                	jae    8014ce <memmove+0x6a>
  80147e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801481:	8b 45 10             	mov    0x10(%ebp),%eax
  801484:	01 d0                	add    %edx,%eax
  801486:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801489:	76 43                	jbe    8014ce <memmove+0x6a>
		s += n;
  80148b:	8b 45 10             	mov    0x10(%ebp),%eax
  80148e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801497:	eb 10                	jmp    8014a9 <memmove+0x45>
			*--d = *--s;
  801499:	ff 4d f8             	decl   -0x8(%ebp)
  80149c:	ff 4d fc             	decl   -0x4(%ebp)
  80149f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a2:	8a 10                	mov    (%eax),%dl
  8014a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014af:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	75 e3                	jne    801499 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014b6:	eb 23                	jmp    8014db <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014bb:	8d 50 01             	lea    0x1(%eax),%edx
  8014be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014c7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014ca:	8a 12                	mov    (%edx),%dl
  8014cc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8014d7:	85 c0                	test   %eax,%eax
  8014d9:	75 dd                	jne    8014b8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ef:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014f2:	eb 2a                	jmp    80151e <memcmp+0x3e>
		if (*s1 != *s2)
  8014f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f7:	8a 10                	mov    (%eax),%dl
  8014f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	38 c2                	cmp    %al,%dl
  801500:	74 16                	je     801518 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801502:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	0f b6 d0             	movzbl %al,%edx
  80150a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80150d:	8a 00                	mov    (%eax),%al
  80150f:	0f b6 c0             	movzbl %al,%eax
  801512:	29 c2                	sub    %eax,%edx
  801514:	89 d0                	mov    %edx,%eax
  801516:	eb 18                	jmp    801530 <memcmp+0x50>
		s1++, s2++;
  801518:	ff 45 fc             	incl   -0x4(%ebp)
  80151b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	8d 50 ff             	lea    -0x1(%eax),%edx
  801524:	89 55 10             	mov    %edx,0x10(%ebp)
  801527:	85 c0                	test   %eax,%eax
  801529:	75 c9                	jne    8014f4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801538:	8b 55 08             	mov    0x8(%ebp),%edx
  80153b:	8b 45 10             	mov    0x10(%ebp),%eax
  80153e:	01 d0                	add    %edx,%eax
  801540:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801543:	eb 15                	jmp    80155a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	8a 00                	mov    (%eax),%al
  80154a:	0f b6 d0             	movzbl %al,%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	0f b6 c0             	movzbl %al,%eax
  801553:	39 c2                	cmp    %eax,%edx
  801555:	74 0d                	je     801564 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801557:	ff 45 08             	incl   0x8(%ebp)
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801560:	72 e3                	jb     801545 <memfind+0x13>
  801562:	eb 01                	jmp    801565 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801564:	90                   	nop
	return (void *) s;
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801570:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801577:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157e:	eb 03                	jmp    801583 <strtol+0x19>
		s++;
  801580:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	3c 20                	cmp    $0x20,%al
  80158a:	74 f4                	je     801580 <strtol+0x16>
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	3c 09                	cmp    $0x9,%al
  801593:	74 eb                	je     801580 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 00                	mov    (%eax),%al
  80159a:	3c 2b                	cmp    $0x2b,%al
  80159c:	75 05                	jne    8015a3 <strtol+0x39>
		s++;
  80159e:	ff 45 08             	incl   0x8(%ebp)
  8015a1:	eb 13                	jmp    8015b6 <strtol+0x4c>
	else if (*s == '-')
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	3c 2d                	cmp    $0x2d,%al
  8015aa:	75 0a                	jne    8015b6 <strtol+0x4c>
		s++, neg = 1;
  8015ac:	ff 45 08             	incl   0x8(%ebp)
  8015af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ba:	74 06                	je     8015c2 <strtol+0x58>
  8015bc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015c0:	75 20                	jne    8015e2 <strtol+0x78>
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	3c 30                	cmp    $0x30,%al
  8015c9:	75 17                	jne    8015e2 <strtol+0x78>
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	40                   	inc    %eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	3c 78                	cmp    $0x78,%al
  8015d3:	75 0d                	jne    8015e2 <strtol+0x78>
		s += 2, base = 16;
  8015d5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015d9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015e0:	eb 28                	jmp    80160a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015e6:	75 15                	jne    8015fd <strtol+0x93>
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	3c 30                	cmp    $0x30,%al
  8015ef:	75 0c                	jne    8015fd <strtol+0x93>
		s++, base = 8;
  8015f1:	ff 45 08             	incl   0x8(%ebp)
  8015f4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8015fb:	eb 0d                	jmp    80160a <strtol+0xa0>
	else if (base == 0)
  8015fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801601:	75 07                	jne    80160a <strtol+0xa0>
		base = 10;
  801603:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	3c 2f                	cmp    $0x2f,%al
  801611:	7e 19                	jle    80162c <strtol+0xc2>
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	8a 00                	mov    (%eax),%al
  801618:	3c 39                	cmp    $0x39,%al
  80161a:	7f 10                	jg     80162c <strtol+0xc2>
			dig = *s - '0';
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	0f be c0             	movsbl %al,%eax
  801624:	83 e8 30             	sub    $0x30,%eax
  801627:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80162a:	eb 42                	jmp    80166e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	3c 60                	cmp    $0x60,%al
  801633:	7e 19                	jle    80164e <strtol+0xe4>
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 7a                	cmp    $0x7a,%al
  80163c:	7f 10                	jg     80164e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	0f be c0             	movsbl %al,%eax
  801646:	83 e8 57             	sub    $0x57,%eax
  801649:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80164c:	eb 20                	jmp    80166e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	3c 40                	cmp    $0x40,%al
  801655:	7e 39                	jle    801690 <strtol+0x126>
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	3c 5a                	cmp    $0x5a,%al
  80165e:	7f 30                	jg     801690 <strtol+0x126>
			dig = *s - 'A' + 10;
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	0f be c0             	movsbl %al,%eax
  801668:	83 e8 37             	sub    $0x37,%eax
  80166b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80166e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801671:	3b 45 10             	cmp    0x10(%ebp),%eax
  801674:	7d 19                	jge    80168f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801676:	ff 45 08             	incl   0x8(%ebp)
  801679:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801680:	89 c2                	mov    %eax,%edx
  801682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801685:	01 d0                	add    %edx,%eax
  801687:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80168a:	e9 7b ff ff ff       	jmp    80160a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80168f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801690:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801694:	74 08                	je     80169e <strtol+0x134>
		*endptr = (char *) s;
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	8b 55 08             	mov    0x8(%ebp),%edx
  80169c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80169e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016a2:	74 07                	je     8016ab <strtol+0x141>
  8016a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a7:	f7 d8                	neg    %eax
  8016a9:	eb 03                	jmp    8016ae <strtol+0x144>
  8016ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <ltostr>:

void
ltostr(long value, char *str)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016c8:	79 13                	jns    8016dd <ltostr+0x2d>
	{
		neg = 1;
  8016ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016d7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016da:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016e5:	99                   	cltd   
  8016e6:	f7 f9                	idiv   %ecx
  8016e8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8d 50 01             	lea    0x1(%eax),%edx
  8016f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f4:	89 c2                	mov    %eax,%edx
  8016f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f9:	01 d0                	add    %edx,%eax
  8016fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016fe:	83 c2 30             	add    $0x30,%edx
  801701:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801703:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801706:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80170b:	f7 e9                	imul   %ecx
  80170d:	c1 fa 02             	sar    $0x2,%edx
  801710:	89 c8                	mov    %ecx,%eax
  801712:	c1 f8 1f             	sar    $0x1f,%eax
  801715:	29 c2                	sub    %eax,%edx
  801717:	89 d0                	mov    %edx,%eax
  801719:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80171c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801720:	75 bb                	jne    8016dd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801722:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801729:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172c:	48                   	dec    %eax
  80172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801730:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801734:	74 3d                	je     801773 <ltostr+0xc3>
		start = 1 ;
  801736:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80173d:	eb 34                	jmp    801773 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80173f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	01 d0                	add    %edx,%eax
  801747:	8a 00                	mov    (%eax),%al
  801749:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80174c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	01 c2                	add    %eax,%edx
  801754:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175a:	01 c8                	add    %ecx,%eax
  80175c:	8a 00                	mov    (%eax),%al
  80175e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801760:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801763:	8b 45 0c             	mov    0xc(%ebp),%eax
  801766:	01 c2                	add    %eax,%edx
  801768:	8a 45 eb             	mov    -0x15(%ebp),%al
  80176b:	88 02                	mov    %al,(%edx)
		start++ ;
  80176d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801770:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801776:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801779:	7c c4                	jl     80173f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80177b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80177e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801781:	01 d0                	add    %edx,%eax
  801783:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801786:	90                   	nop
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80178f:	ff 75 08             	pushl  0x8(%ebp)
  801792:	e8 c4 f9 ff ff       	call   80115b <strlen>
  801797:	83 c4 04             	add    $0x4,%esp
  80179a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	e8 b6 f9 ff ff       	call   80115b <strlen>
  8017a5:	83 c4 04             	add    $0x4,%esp
  8017a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b9:	eb 17                	jmp    8017d2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017be:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c1:	01 c2                	add    %eax,%edx
  8017c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	01 c8                	add    %ecx,%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017cf:	ff 45 fc             	incl   -0x4(%ebp)
  8017d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017d8:	7c e1                	jl     8017bb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017e8:	eb 1f                	jmp    801809 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8017ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017ed:	8d 50 01             	lea    0x1(%eax),%edx
  8017f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017f3:	89 c2                	mov    %eax,%edx
  8017f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f8:	01 c2                	add    %eax,%edx
  8017fa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	01 c8                	add    %ecx,%eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801806:	ff 45 f8             	incl   -0x8(%ebp)
  801809:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80180f:	7c d9                	jl     8017ea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801811:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801814:	8b 45 10             	mov    0x10(%ebp),%eax
  801817:	01 d0                	add    %edx,%eax
  801819:	c6 00 00             	movb   $0x0,(%eax)
}
  80181c:	90                   	nop
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801822:	8b 45 14             	mov    0x14(%ebp),%eax
  801825:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80182b:	8b 45 14             	mov    0x14(%ebp),%eax
  80182e:	8b 00                	mov    (%eax),%eax
  801830:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801837:	8b 45 10             	mov    0x10(%ebp),%eax
  80183a:	01 d0                	add    %edx,%eax
  80183c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801842:	eb 0c                	jmp    801850 <strsplit+0x31>
			*string++ = 0;
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	8d 50 01             	lea    0x1(%eax),%edx
  80184a:	89 55 08             	mov    %edx,0x8(%ebp)
  80184d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	8a 00                	mov    (%eax),%al
  801855:	84 c0                	test   %al,%al
  801857:	74 18                	je     801871 <strsplit+0x52>
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	8a 00                	mov    (%eax),%al
  80185e:	0f be c0             	movsbl %al,%eax
  801861:	50                   	push   %eax
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	e8 83 fa ff ff       	call   8012ed <strchr>
  80186a:	83 c4 08             	add    $0x8,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	75 d3                	jne    801844 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	84 c0                	test   %al,%al
  801878:	74 5a                	je     8018d4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80187a:	8b 45 14             	mov    0x14(%ebp),%eax
  80187d:	8b 00                	mov    (%eax),%eax
  80187f:	83 f8 0f             	cmp    $0xf,%eax
  801882:	75 07                	jne    80188b <strsplit+0x6c>
		{
			return 0;
  801884:	b8 00 00 00 00       	mov    $0x0,%eax
  801889:	eb 66                	jmp    8018f1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80188b:	8b 45 14             	mov    0x14(%ebp),%eax
  80188e:	8b 00                	mov    (%eax),%eax
  801890:	8d 48 01             	lea    0x1(%eax),%ecx
  801893:	8b 55 14             	mov    0x14(%ebp),%edx
  801896:	89 0a                	mov    %ecx,(%edx)
  801898:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80189f:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a2:	01 c2                	add    %eax,%edx
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018a9:	eb 03                	jmp    8018ae <strsplit+0x8f>
			string++;
  8018ab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	8a 00                	mov    (%eax),%al
  8018b3:	84 c0                	test   %al,%al
  8018b5:	74 8b                	je     801842 <strsplit+0x23>
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	8a 00                	mov    (%eax),%al
  8018bc:	0f be c0             	movsbl %al,%eax
  8018bf:	50                   	push   %eax
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	e8 25 fa ff ff       	call   8012ed <strchr>
  8018c8:	83 c4 08             	add    $0x8,%esp
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	74 dc                	je     8018ab <strsplit+0x8c>
			string++;
	}
  8018cf:	e9 6e ff ff ff       	jmp    801842 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018d4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d8:	8b 00                	mov    (%eax),%eax
  8018da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e4:	01 d0                	add    %edx,%eax
  8018e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8018ec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8018ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801906:	eb 4a                	jmp    801952 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801908:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	01 c2                	add    %eax,%edx
  801910:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801913:	8b 45 0c             	mov    0xc(%ebp),%eax
  801916:	01 c8                	add    %ecx,%eax
  801918:	8a 00                	mov    (%eax),%al
  80191a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80191c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80191f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	3c 40                	cmp    $0x40,%al
  801928:	7e 25                	jle    80194f <str2lower+0x5c>
  80192a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80192d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801930:	01 d0                	add    %edx,%eax
  801932:	8a 00                	mov    (%eax),%al
  801934:	3c 5a                	cmp    $0x5a,%al
  801936:	7f 17                	jg     80194f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801938:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801943:	8b 55 08             	mov    0x8(%ebp),%edx
  801946:	01 ca                	add    %ecx,%edx
  801948:	8a 12                	mov    (%edx),%dl
  80194a:	83 c2 20             	add    $0x20,%edx
  80194d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80194f:	ff 45 fc             	incl   -0x4(%ebp)
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	e8 01 f8 ff ff       	call   80115b <strlen>
  80195a:	83 c4 04             	add    $0x4,%esp
  80195d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801960:	7f a6                	jg     801908 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801962:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80196d:	a1 08 60 80 00       	mov    0x806008,%eax
  801972:	85 c0                	test   %eax,%eax
  801974:	0f 84 95 00 00 00    	je     801a0f <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80197a:	83 ec 08             	sub    $0x8,%esp
  80197d:	68 00 00 00 82       	push   $0x82000000
  801982:	68 00 00 00 80       	push   $0x80000000
  801987:	e8 59 1f 00 00       	call   8038e5 <initialize_dynamic_allocator>
  80198c:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80198f:	e8 93 1d 00 00       	call   803727 <sys_get_uheap_strategy>
  801994:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801999:	a1 40 60 80 00       	mov    0x806040,%eax
  80199e:	05 00 10 00 00       	add    $0x1000,%eax
  8019a3:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  8019a8:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8019ad:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  8019b2:	83 ec 04             	sub    $0x4,%esp
  8019b5:	6a 01                	push   $0x1
  8019b7:	68 88 50 80 00       	push   $0x805088
  8019bc:	68 40 e1 81 00       	push   $0x81e140
  8019c1:	e8 1a 29 00 00       	call   8042e0 <init_uspinlock>
  8019c6:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  8019c9:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  8019d0:	00 00 00 
  8019d3:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  8019da:	00 00 00 
  8019dd:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  8019e4:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  8019e7:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  8019ee:	00 00 00 
  8019f1:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  8019f8:	00 00 00 
  8019fb:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  801a02:	00 00 00 
		__firstTimeFlag = 0;
  801a05:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801a0c:	00 00 00 
	}
}
  801a0f:	90                   	nop
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a26:	83 ec 08             	sub    $0x8,%esp
  801a29:	68 06 04 00 00       	push   $0x406
  801a2e:	50                   	push   %eax
  801a2f:	e8 3d 19 00 00       	call   803371 <__sys_allocate_page>
  801a34:	83 c4 10             	add    $0x10,%esp
  801a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801a3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a3e:	79 14                	jns    801a54 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	68 90 50 80 00       	push   $0x805090
  801a48:	6a 2d                	push   $0x2d
  801a4a:	68 cc 50 80 00       	push   $0x8050cc
  801a4f:	e8 94 29 00 00       	call   8043e8 <_panic>
	return 0;
  801a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a6f:	83 ec 0c             	sub    $0xc,%esp
  801a72:	50                   	push   %eax
  801a73:	e8 40 19 00 00       	call   8033b8 <__sys_unmap_frame>
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801a7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a82:	79 14                	jns    801a98 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	68 d8 50 80 00       	push   $0x8050d8
  801a8c:	6a 38                	push   $0x38
  801a8e:	68 cc 50 80 00       	push   $0x8050cc
  801a93:	e8 50 29 00 00       	call   8043e8 <_panic>
}
  801a98:	90                   	nop
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801aa1:	e8 c1 fe ff ff       	call   801967 <uheap_init>
	if (size == 0) return NULL ;
  801aa6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801aaa:	75 0a                	jne    801ab6 <malloc+0x1b>
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab1:	e9 e1 04 00 00       	jmp    801f97 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801ab6:	83 ec 0c             	sub    $0xc,%esp
  801ab9:	68 40 e1 81 00       	push   $0x81e140
  801abe:	e8 6c 28 00 00       	call   80432f <acquire_uspinlock>
  801ac3:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801ac6:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  801acd:	77 23                	ja     801af2 <malloc+0x57>
		release_uspinlock(&ulock);
  801acf:	83 ec 0c             	sub    $0xc,%esp
  801ad2:	68 40 e1 81 00       	push   $0x81e140
  801ad7:	e8 ab 28 00 00       	call   804387 <release_uspinlock>
  801adc:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  801adf:	83 ec 0c             	sub    $0xc,%esp
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	e8 dd 1f 00 00       	call   803ac7 <alloc_block>
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	e9 a5 04 00 00       	jmp    801f97 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801af2:	83 ec 0c             	sub    $0xc,%esp
  801af5:	6a 10                	push   $0x10
  801af7:	e8 cb 1f 00 00       	call   803ac7 <alloc_block>
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801b02:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b06:	75 0a                	jne    801b12 <malloc+0x77>
			return NULL;
  801b08:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0d:	e9 85 04 00 00       	jmp    801f97 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801b12:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801b19:	8b 55 08             	mov    0x8(%ebp),%edx
  801b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b1f:	01 d0                	add    %edx,%eax
  801b21:	48                   	dec    %eax
  801b22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b28:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2d:	f7 75 e8             	divl   -0x18(%ebp)
  801b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b33:	29 d0                	sub    %edx,%eax
  801b35:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801b38:	a1 24 e1 81 00       	mov    0x81e124,%eax
  801b3d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801b40:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801b45:	85 c0                	test   %eax,%eax
  801b47:	74 0f                	je     801b58 <malloc+0xbd>
  801b49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b4c:	8b 40 04             	mov    0x4(%eax),%eax
  801b4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b52:	0f 83 ea 00 00 00    	jae    801c42 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801b58:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801b5d:	2b 45 08             	sub    0x8(%ebp),%eax
  801b60:	89 c2                	mov    %eax,%edx
  801b62:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801b67:	39 c2                	cmp    %eax,%edx
  801b69:	0f 86 b9 00 00 00    	jbe    801c28 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801b6f:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801b74:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801b77:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	01 d0                	add    %edx,%eax
  801b82:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  801b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b8a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801b8d:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b92:	8b 55 08             	mov    0x8(%ebp),%edx
  801b95:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801b98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b9c:	75 14                	jne    801bb2 <malloc+0x117>
  801b9e:	83 ec 04             	sub    $0x4,%esp
  801ba1:	68 18 51 80 00       	push   $0x805118
  801ba6:	6a 60                	push   $0x60
  801ba8:	68 cc 50 80 00       	push   $0x8050cc
  801bad:	e8 36 28 00 00       	call   8043e8 <_panic>
  801bb2:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bbb:	89 50 0c             	mov    %edx,0xc(%eax)
  801bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	74 0d                	je     801bd5 <malloc+0x13a>
  801bc8:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801bcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bd0:	89 50 08             	mov    %edx,0x8(%eax)
  801bd3:	eb 08                	jmp    801bdd <malloc+0x142>
  801bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd8:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be0:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801bef:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801bf4:	40                   	inc    %eax
  801bf5:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801bfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bfd:	8b 00                	mov    (%eax),%eax
  801bff:	83 ec 08             	sub    $0x8,%esp
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	50                   	push   %eax
  801c06:	e8 34 1c 00 00       	call   80383f <sys_allocate_user_mem>
  801c0b:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	68 40 e1 81 00       	push   $0x81e140
  801c16:	e8 6c 27 00 00       	call   804387 <release_uspinlock>
  801c1b:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c21:	8b 00                	mov    (%eax),%eax
  801c23:	e9 6f 03 00 00       	jmp    801f97 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801c28:	83 ec 0c             	sub    $0xc,%esp
  801c2b:	68 40 e1 81 00       	push   $0x81e140
  801c30:	e8 52 27 00 00       	call   804387 <release_uspinlock>
  801c35:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801c38:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3d:	e9 55 03 00 00       	jmp    801f97 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801c42:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801c47:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801c4a:	e9 39 03 00 00       	jmp    801f88 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c52:	8b 40 04             	mov    0x4(%eax),%eax
  801c55:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c58:	0f 86 e7 01 00 00    	jbe    801e45 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801c5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c61:	8b 10                	mov    (%eax),%edx
  801c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c66:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6b:	8b 55 08             	mov    0x8(%ebp),%edx
  801c6e:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801c71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c75:	75 14                	jne    801c8b <malloc+0x1f0>
  801c77:	83 ec 04             	sub    $0x4,%esp
  801c7a:	68 18 51 80 00       	push   $0x805118
  801c7f:	6a 72                	push   $0x72
  801c81:	68 cc 50 80 00       	push   $0x8050cc
  801c86:	e8 5d 27 00 00       	call   8043e8 <_panic>
  801c8b:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c94:	89 50 0c             	mov    %edx,0xc(%eax)
  801c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	74 0d                	je     801cae <malloc+0x213>
  801ca1:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801ca6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ca9:	89 50 08             	mov    %edx,0x8(%eax)
  801cac:	eb 08                	jmp    801cb6 <malloc+0x21b>
  801cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb1:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb9:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801cc8:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801ccd:	40                   	inc    %eax
  801cce:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  801cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cd6:	8b 10                	mov    (%eax),%edx
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	01 c2                	add    %eax,%edx
  801cdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ce0:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801ce2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ce5:	8b 40 04             	mov    0x4(%eax),%eax
  801ce8:	2b 45 08             	sub    0x8(%ebp),%eax
  801ceb:	89 c2                	mov    %eax,%edx
  801ced:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cf0:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801cf3:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801cfb:	e9 0d 01 00 00       	jmp    801e0d <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  801d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d03:	8b 50 04             	mov    0x4(%eax),%edx
  801d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d09:	8b 40 04             	mov    0x4(%eax),%eax
  801d0c:	39 c2                	cmp    %eax,%edx
  801d0e:	0f 83 f0 00 00 00    	jae    801e04 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801d14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d18:	75 14                	jne    801d2e <malloc+0x293>
  801d1a:	83 ec 04             	sub    $0x4,%esp
  801d1d:	68 3b 51 80 00       	push   $0x80513b
  801d22:	6a 7a                	push   $0x7a
  801d24:	68 cc 50 80 00       	push   $0x8050cc
  801d29:	e8 ba 26 00 00       	call   8043e8 <_panic>
  801d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d31:	8b 40 08             	mov    0x8(%eax),%eax
  801d34:	85 c0                	test   %eax,%eax
  801d36:	74 11                	je     801d49 <malloc+0x2ae>
  801d38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d3b:	8b 40 08             	mov    0x8(%eax),%eax
  801d3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d41:	8b 52 0c             	mov    0xc(%edx),%edx
  801d44:	89 50 0c             	mov    %edx,0xc(%eax)
  801d47:	eb 0b                	jmp    801d54 <malloc+0x2b9>
  801d49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d4f:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801d54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d57:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	74 11                	je     801d6f <malloc+0x2d4>
  801d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d61:	8b 40 0c             	mov    0xc(%eax),%eax
  801d64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d67:	8b 52 08             	mov    0x8(%edx),%edx
  801d6a:	89 50 08             	mov    %edx,0x8(%eax)
  801d6d:	eb 0b                	jmp    801d7a <malloc+0x2df>
  801d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d72:	8b 40 08             	mov    0x8(%eax),%eax
  801d75:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801d7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d7d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d87:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801d8e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801d93:	48                   	dec    %eax
  801d94:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801d99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d9d:	74 06                	je     801da5 <malloc+0x30a>
  801d9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801da3:	75 14                	jne    801db9 <malloc+0x31e>
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	68 5c 51 80 00       	push   $0x80515c
  801dad:	6a 7b                	push   $0x7b
  801daf:	68 cc 50 80 00       	push   $0x8050cc
  801db4:	e8 2f 26 00 00       	call   8043e8 <_panic>
  801db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbc:	8b 50 0c             	mov    0xc(%eax),%edx
  801dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc2:	89 50 0c             	mov    %edx,0xc(%eax)
  801dc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dcb:	89 50 08             	mov    %edx,0x8(%eax)
  801dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	74 0e                	je     801de6 <malloc+0x34b>
  801dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddb:	8b 40 0c             	mov    0xc(%eax),%eax
  801dde:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801de1:	89 50 08             	mov    %edx,0x8(%eax)
  801de4:	eb 08                	jmp    801dee <malloc+0x353>
  801de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de9:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801df4:	89 50 0c             	mov    %edx,0xc(%eax)
  801df7:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801dfc:	40                   	inc    %eax
  801dfd:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  801e02:	eb 13                	jmp    801e17 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e07:	8b 40 08             	mov    0x8(%eax),%eax
  801e0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801e0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e11:	0f 85 e9 fe ff ff    	jne    801d00 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1a:	8b 00                	mov    (%eax),%eax
  801e1c:	83 ec 08             	sub    $0x8,%esp
  801e1f:	ff 75 08             	pushl  0x8(%ebp)
  801e22:	50                   	push   %eax
  801e23:	e8 17 1a 00 00       	call   80383f <sys_allocate_user_mem>
  801e28:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	68 40 e1 81 00       	push   $0x81e140
  801e33:	e8 4f 25 00 00       	call   804387 <release_uspinlock>
  801e38:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801e3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3e:	8b 00                	mov    (%eax),%eax
  801e40:	e9 52 01 00 00       	jmp    801f97 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e48:	8b 40 04             	mov    0x4(%eax),%eax
  801e4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e4e:	0f 85 2b 01 00 00    	jne    801f7f <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	8b 10                	mov    (%eax),%edx
  801e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e5c:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e61:	8b 55 08             	mov    0x8(%ebp),%edx
  801e64:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801e67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e6b:	75 17                	jne    801e84 <malloc+0x3e9>
  801e6d:	83 ec 04             	sub    $0x4,%esp
  801e70:	68 18 51 80 00       	push   $0x805118
  801e75:	68 89 00 00 00       	push   $0x89
  801e7a:	68 cc 50 80 00       	push   $0x8050cc
  801e7f:	e8 64 25 00 00       	call   8043e8 <_panic>
  801e84:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801e8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e8d:	89 50 0c             	mov    %edx,0xc(%eax)
  801e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e93:	8b 40 0c             	mov    0xc(%eax),%eax
  801e96:	85 c0                	test   %eax,%eax
  801e98:	74 0d                	je     801ea7 <malloc+0x40c>
  801e9a:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801e9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ea2:	89 50 08             	mov    %edx,0x8(%eax)
  801ea5:	eb 08                	jmp    801eaf <malloc+0x414>
  801ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eaa:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb2:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801ec1:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801ec6:	40                   	inc    %eax
  801ec7:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801ecc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed0:	75 17                	jne    801ee9 <malloc+0x44e>
  801ed2:	83 ec 04             	sub    $0x4,%esp
  801ed5:	68 3b 51 80 00       	push   $0x80513b
  801eda:	68 8a 00 00 00       	push   $0x8a
  801edf:	68 cc 50 80 00       	push   $0x8050cc
  801ee4:	e8 ff 24 00 00       	call   8043e8 <_panic>
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	8b 40 08             	mov    0x8(%eax),%eax
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	74 11                	je     801f04 <malloc+0x469>
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 40 08             	mov    0x8(%eax),%eax
  801ef9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efc:	8b 52 0c             	mov    0xc(%edx),%edx
  801eff:	89 50 0c             	mov    %edx,0xc(%eax)
  801f02:	eb 0b                	jmp    801f0f <malloc+0x474>
  801f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f07:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0a:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	8b 40 0c             	mov    0xc(%eax),%eax
  801f15:	85 c0                	test   %eax,%eax
  801f17:	74 11                	je     801f2a <malloc+0x48f>
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f22:	8b 52 08             	mov    0x8(%edx),%edx
  801f25:	89 50 08             	mov    %edx,0x8(%eax)
  801f28:	eb 0b                	jmp    801f35 <malloc+0x49a>
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	8b 40 08             	mov    0x8(%eax),%eax
  801f30:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f49:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f4e:	48                   	dec    %eax
  801f4f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f57:	8b 00                	mov    (%eax),%eax
  801f59:	83 ec 08             	sub    $0x8,%esp
  801f5c:	ff 75 08             	pushl  0x8(%ebp)
  801f5f:	50                   	push   %eax
  801f60:	e8 da 18 00 00       	call   80383f <sys_allocate_user_mem>
  801f65:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801f68:	83 ec 0c             	sub    $0xc,%esp
  801f6b:	68 40 e1 81 00       	push   $0x81e140
  801f70:	e8 12 24 00 00       	call   804387 <release_uspinlock>
  801f75:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801f78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7b:	8b 00                	mov    (%eax),%eax
  801f7d:	eb 18                	jmp    801f97 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	8b 40 08             	mov    0x8(%eax),%eax
  801f85:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801f88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8c:	0f 85 bd fc ff ff    	jne    801c4f <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801fa5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fa8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801fad:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801fb0:	e8 b2 f9 ff ff       	call   801967 <uheap_init>
		acquire_uspinlock(&ulock);
  801fb5:	83 ec 0c             	sub    $0xc,%esp
  801fb8:	68 40 e1 81 00       	push   $0x81e140
  801fbd:	e8 6d 23 00 00       	call   80432f <acquire_uspinlock>
  801fc2:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801fc5:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801fca:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801fcd:	73 23                	jae    801ff2 <free+0x59>
			free_block(virtual_address);
  801fcf:	83 ec 0c             	sub    $0xc,%esp
  801fd2:	ff 75 08             	pushl  0x8(%ebp)
  801fd5:	e8 89 1f 00 00       	call   803f63 <free_block>
  801fda:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	68 40 e1 81 00       	push   $0x81e140
  801fe5:	e8 9d 23 00 00       	call   804387 <release_uspinlock>
  801fea:	83 c4 10             	add    $0x10,%esp
			return;
  801fed:	e9 35 07 00 00       	jmp    802727 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801ff2:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801ff7:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801ffa:	72 30                	jb     80202c <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801ffc:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802001:	83 ec 04             	sub    $0x4,%esp
  802004:	50                   	push   %eax
  802005:	ff 75 d8             	pushl  -0x28(%ebp)
  802008:	68 91 51 80 00       	push   $0x805191
  80200d:	e8 70 ea ff ff       	call   800a82 <cprintf>
  802012:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802015:	83 ec 04             	sub    $0x4,%esp
  802018:	68 99 51 80 00       	push   $0x805199
  80201d:	68 a7 00 00 00       	push   $0xa7
  802022:	68 cc 50 80 00       	push   $0x8050cc
  802027:	e8 bc 23 00 00       	call   8043e8 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	6a 10                	push   $0x10
  802031:	e8 91 1a 00 00       	call   803ac7 <alloc_block>
  802036:	83 c4 10             	add    $0x10,%esp
  802039:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  80203c:	83 ec 0c             	sub    $0xc,%esp
  80203f:	6a 10                	push   $0x10
  802041:	e8 81 1a 00 00       	call   803ac7 <alloc_block>
  802046:	83 c4 10             	add    $0x10,%esp
  802049:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  80204c:	a1 30 e1 81 00       	mov    0x81e130,%eax
  802051:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  802054:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  80205b:	eb 1c                	jmp    802079 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	8b 00                	mov    (%eax),%eax
  802062:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802065:	75 09                	jne    802070 <free+0xd7>
				foundVA = 1;
  802067:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  80206e:	eb 0f                	jmp    80207f <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  802070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802073:	8b 40 08             	mov    0x8(%eax),%eax
  802076:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  802079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207d:	75 de                	jne    80205d <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  80207f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802083:	75 17                	jne    80209c <free+0x103>
				panic("INVALID ADDRESS!");
  802085:	83 ec 04             	sub    $0x4,%esp
  802088:	68 b6 51 80 00       	push   $0x8051b6
  80208d:	68 be 00 00 00       	push   $0xbe
  802092:	68 cc 50 80 00       	push   $0x8050cc
  802097:	e8 4c 23 00 00       	call   8043e8 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	8b 10                	mov    (%eax),%edx
  8020a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020a4:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  8020a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a9:	8b 50 04             	mov    0x4(%eax),%edx
  8020ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020af:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  8020b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b6:	75 17                	jne    8020cf <free+0x136>
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	68 3b 51 80 00       	push   $0x80513b
  8020c0:	68 c8 00 00 00       	push   $0xc8
  8020c5:	68 cc 50 80 00       	push   $0x8050cc
  8020ca:	e8 19 23 00 00       	call   8043e8 <_panic>
  8020cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d2:	8b 40 08             	mov    0x8(%eax),%eax
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	74 11                	je     8020ea <free+0x151>
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	8b 40 08             	mov    0x8(%eax),%eax
  8020df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e2:	8b 52 0c             	mov    0xc(%edx),%edx
  8020e5:	89 50 0c             	mov    %edx,0xc(%eax)
  8020e8:	eb 0b                	jmp    8020f5 <free+0x15c>
  8020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f0:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	74 11                	je     802110 <free+0x177>
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	8b 40 0c             	mov    0xc(%eax),%eax
  802105:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802108:	8b 52 08             	mov    0x8(%edx),%edx
  80210b:	89 50 08             	mov    %edx,0x8(%eax)
  80210e:	eb 0b                	jmp    80211b <free+0x182>
  802110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802113:	8b 40 08             	mov    0x8(%eax),%eax
  802116:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802128:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80212f:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802134:	48                   	dec    %eax
  802135:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  80213a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213d:	8b 50 04             	mov    0x4(%eax),%edx
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	8b 00                	mov    (%eax),%eax
  802145:	83 ec 08             	sub    $0x8,%esp
  802148:	52                   	push   %edx
  802149:	50                   	push   %eax
  80214a:	e8 d4 16 00 00       	call   803823 <sys_free_user_mem>
  80214f:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  802152:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	75 7a                	jne    8021d5 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  80215b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80215f:	75 17                	jne    802178 <free+0x1df>
  802161:	83 ec 04             	sub    $0x4,%esp
  802164:	68 c8 51 80 00       	push   $0x8051c8
  802169:	68 d0 00 00 00       	push   $0xd0
  80216e:	68 cc 50 80 00       	push   $0x8050cc
  802173:	e8 70 22 00 00       	call   8043e8 <_panic>
  802178:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  80217e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802181:	89 50 08             	mov    %edx,0x8(%eax)
  802184:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802187:	8b 40 08             	mov    0x8(%eax),%eax
  80218a:	85 c0                	test   %eax,%eax
  80218c:	74 0d                	je     80219b <free+0x202>
  80218e:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802193:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802196:	89 50 0c             	mov    %edx,0xc(%eax)
  802199:	eb 08                	jmp    8021a3 <free+0x20a>
  80219b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80219e:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8021a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021a6:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8021ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021ae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8021b5:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8021ba:	40                   	inc    %eax
  8021bb:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  8021c0:	83 ec 0c             	sub    $0xc,%esp
  8021c3:	68 40 e1 81 00       	push   $0x81e140
  8021c8:	e8 ba 21 00 00       	call   804387 <release_uspinlock>
  8021cd:	83 c4 10             	add    $0x10,%esp
			return;
  8021d0:	e9 52 05 00 00       	jmp    802727 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  8021d5:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8021da:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  8021dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  8021e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  8021eb:	e9 d2 00 00 00       	jmp    8022c2 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  8021f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f3:	8b 10                	mov    (%eax),%edx
  8021f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f8:	8b 40 04             	mov    0x4(%eax),%eax
  8021fb:	01 c2                	add    %eax,%edx
  8021fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802200:	8b 00                	mov    (%eax),%eax
  802202:	39 c2                	cmp    %eax,%edx
  802204:	0f 85 af 00 00 00    	jne    8022b9 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  80220a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220d:	8b 10                	mov    (%eax),%edx
  80220f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802212:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  802214:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802217:	8b 50 04             	mov    0x4(%eax),%edx
  80221a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80221d:	8b 40 04             	mov    0x4(%eax),%eax
  802220:	01 c2                	add    %eax,%edx
  802222:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802225:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  802228:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80222c:	75 17                	jne    802245 <free+0x2ac>
  80222e:	83 ec 04             	sub    $0x4,%esp
  802231:	68 3b 51 80 00       	push   $0x80513b
  802236:	68 df 00 00 00       	push   $0xdf
  80223b:	68 cc 50 80 00       	push   $0x8050cc
  802240:	e8 a3 21 00 00       	call   8043e8 <_panic>
  802245:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802248:	8b 40 08             	mov    0x8(%eax),%eax
  80224b:	85 c0                	test   %eax,%eax
  80224d:	74 11                	je     802260 <free+0x2c7>
  80224f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802252:	8b 40 08             	mov    0x8(%eax),%eax
  802255:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802258:	8b 52 0c             	mov    0xc(%edx),%edx
  80225b:	89 50 0c             	mov    %edx,0xc(%eax)
  80225e:	eb 0b                	jmp    80226b <free+0x2d2>
  802260:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802263:	8b 40 0c             	mov    0xc(%eax),%eax
  802266:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80226b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226e:	8b 40 0c             	mov    0xc(%eax),%eax
  802271:	85 c0                	test   %eax,%eax
  802273:	74 11                	je     802286 <free+0x2ed>
  802275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802278:	8b 40 0c             	mov    0xc(%eax),%eax
  80227b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80227e:	8b 52 08             	mov    0x8(%edx),%edx
  802281:	89 50 08             	mov    %edx,0x8(%eax)
  802284:	eb 0b                	jmp    802291 <free+0x2f8>
  802286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802289:	8b 40 08             	mov    0x8(%eax),%eax
  80228c:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802291:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802294:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80229b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8022a5:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8022aa:	48                   	dec    %eax
  8022ab:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  8022b0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  8022b7:	eb 13                	jmp    8022cc <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8022b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bc:	8b 40 08             	mov    0x8(%eax),%eax
  8022bf:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  8022c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022c6:	0f 85 24 ff ff ff    	jne    8021f0 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  8022cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022cf:	8b 10                	mov    (%eax),%edx
  8022d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022d4:	8b 40 04             	mov    0x4(%eax),%eax
  8022d7:	01 c2                	add    %eax,%edx
  8022d9:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8022de:	39 c2                	cmp    %eax,%edx
  8022e0:	75 44                	jne    802326 <free+0x38d>

			if(mergeprev){
  8022e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8022e6:	74 1f                	je     802307 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  8022e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  8022f2:	83 ec 0c             	sub    $0xc,%esp
  8022f5:	68 40 e1 81 00       	push   $0x81e140
  8022fa:	e8 88 20 00 00       	call   804387 <release_uspinlock>
  8022ff:	83 c4 10             	add    $0x10,%esp
				return;
  802302:	e9 20 04 00 00       	jmp    802727 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  802307:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80230a:	8b 00                	mov    (%eax),%eax
  80230c:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802311:	83 ec 0c             	sub    $0xc,%esp
  802314:	68 40 e1 81 00       	push   $0x81e140
  802319:	e8 69 20 00 00       	call   804387 <release_uspinlock>
  80231e:	83 c4 10             	add    $0x10,%esp
				return;
  802321:	e9 01 04 00 00       	jmp    802727 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  802326:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80232b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  80232e:	e9 7d 01 00 00       	jmp    8024b0 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  802333:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802336:	8b 10                	mov    (%eax),%edx
  802338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80233b:	8b 40 04             	mov    0x4(%eax),%eax
  80233e:	01 c2                	add    %eax,%edx
  802340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	39 c2                	cmp    %eax,%edx
  802347:	0f 85 5a 01 00 00    	jne    8024a7 <free+0x50e>
				if (mergeprev){
  80234d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802351:	0f 84 a1 00 00 00    	je     8023f8 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  802357:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80235a:	8b 50 04             	mov    0x4(%eax),%edx
  80235d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802360:	8b 40 04             	mov    0x4(%eax),%eax
  802363:	01 c2                	add    %eax,%edx
  802365:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802368:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  80236b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80236f:	75 17                	jne    802388 <free+0x3ef>
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	68 3b 51 80 00       	push   $0x80513b
  802379:	68 0a 01 00 00       	push   $0x10a
  80237e:	68 cc 50 80 00       	push   $0x8050cc
  802383:	e8 60 20 00 00       	call   8043e8 <_panic>
  802388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238b:	8b 40 08             	mov    0x8(%eax),%eax
  80238e:	85 c0                	test   %eax,%eax
  802390:	74 11                	je     8023a3 <free+0x40a>
  802392:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802395:	8b 40 08             	mov    0x8(%eax),%eax
  802398:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80239b:	8b 52 0c             	mov    0xc(%edx),%edx
  80239e:	89 50 0c             	mov    %edx,0xc(%eax)
  8023a1:	eb 0b                	jmp    8023ae <free+0x415>
  8023a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a9:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8023ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	74 11                	je     8023c9 <free+0x430>
  8023b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023c1:	8b 52 08             	mov    0x8(%edx),%edx
  8023c4:	89 50 08             	mov    %edx,0x8(%eax)
  8023c7:	eb 0b                	jmp    8023d4 <free+0x43b>
  8023c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cc:	8b 40 08             	mov    0x8(%eax),%eax
  8023cf:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8023d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8023e8:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8023ed:	48                   	dec    %eax
  8023ee:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  8023f3:	e9 c2 00 00 00       	jmp    8024ba <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8023f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023fb:	8b 10                	mov    (%eax),%edx
  8023fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802400:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  802402:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802405:	8b 50 04             	mov    0x4(%eax),%edx
  802408:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240b:	8b 40 04             	mov    0x4(%eax),%eax
  80240e:	01 c2                	add    %eax,%edx
  802410:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802413:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802416:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80241a:	75 17                	jne    802433 <free+0x49a>
  80241c:	83 ec 04             	sub    $0x4,%esp
  80241f:	68 3b 51 80 00       	push   $0x80513b
  802424:	68 10 01 00 00       	push   $0x110
  802429:	68 cc 50 80 00       	push   $0x8050cc
  80242e:	e8 b5 1f 00 00       	call   8043e8 <_panic>
  802433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802436:	8b 40 08             	mov    0x8(%eax),%eax
  802439:	85 c0                	test   %eax,%eax
  80243b:	74 11                	je     80244e <free+0x4b5>
  80243d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802440:	8b 40 08             	mov    0x8(%eax),%eax
  802443:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802446:	8b 52 0c             	mov    0xc(%edx),%edx
  802449:	89 50 0c             	mov    %edx,0xc(%eax)
  80244c:	eb 0b                	jmp    802459 <free+0x4c0>
  80244e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802451:	8b 40 0c             	mov    0xc(%eax),%eax
  802454:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245c:	8b 40 0c             	mov    0xc(%eax),%eax
  80245f:	85 c0                	test   %eax,%eax
  802461:	74 11                	je     802474 <free+0x4db>
  802463:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802466:	8b 40 0c             	mov    0xc(%eax),%eax
  802469:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80246c:	8b 52 08             	mov    0x8(%edx),%edx
  80246f:	89 50 08             	mov    %edx,0x8(%eax)
  802472:	eb 0b                	jmp    80247f <free+0x4e6>
  802474:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802477:	8b 40 08             	mov    0x8(%eax),%eax
  80247a:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80247f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802482:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802493:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802498:	48                   	dec    %eax
  802499:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  80249e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8024a5:	eb 13                	jmp    8024ba <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8024a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024aa:	8b 40 08             	mov    0x8(%eax),%eax
  8024ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  8024b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024b4:	0f 85 79 fe ff ff    	jne    802333 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  8024ba:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8024bf:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  8024c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024c6:	0f 85 ad 00 00 00    	jne    802579 <free+0x5e0>
  8024cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024d0:	0f 84 c3 01 00 00    	je     802699 <free+0x700>
				while(currentfree != NULL){
  8024d6:	e9 9e 00 00 00       	jmp    802579 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8024db:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024de:	8b 50 04             	mov    0x4(%eax),%edx
  8024e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e4:	8b 40 04             	mov    0x4(%eax),%eax
  8024e7:	39 c2                	cmp    %eax,%edx
  8024e9:	0f 83 81 00 00 00    	jae    802570 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8024ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8024f3:	74 06                	je     8024fb <free+0x562>
  8024f5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8024f9:	75 17                	jne    802512 <free+0x579>
  8024fb:	83 ec 04             	sub    $0x4,%esp
  8024fe:	68 5c 51 80 00       	push   $0x80515c
  802503:	68 23 01 00 00       	push   $0x123
  802508:	68 cc 50 80 00       	push   $0x8050cc
  80250d:	e8 d6 1e 00 00       	call   8043e8 <_panic>
  802512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802515:	8b 50 0c             	mov    0xc(%eax),%edx
  802518:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80251b:	89 50 0c             	mov    %edx,0xc(%eax)
  80251e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802521:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802524:	89 50 08             	mov    %edx,0x8(%eax)
  802527:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80252a:	8b 40 0c             	mov    0xc(%eax),%eax
  80252d:	85 c0                	test   %eax,%eax
  80252f:	74 0e                	je     80253f <free+0x5a6>
  802531:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802534:	8b 40 0c             	mov    0xc(%eax),%eax
  802537:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80253a:	89 50 08             	mov    %edx,0x8(%eax)
  80253d:	eb 08                	jmp    802547 <free+0x5ae>
  80253f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802542:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802547:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80254a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80254d:	89 50 0c             	mov    %edx,0xc(%eax)
  802550:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802555:	40                   	inc    %eax
  802556:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  80255b:	83 ec 0c             	sub    $0xc,%esp
  80255e:	68 40 e1 81 00       	push   $0x81e140
  802563:	e8 1f 1e 00 00       	call   804387 <release_uspinlock>
  802568:	83 c4 10             	add    $0x10,%esp
							return;
  80256b:	e9 b7 01 00 00       	jmp    802727 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802570:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802573:	8b 40 08             	mov    0x8(%eax),%eax
  802576:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  802579:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80257d:	0f 85 58 ff ff ff    	jne    8024db <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802583:	83 ec 0c             	sub    $0xc,%esp
  802586:	ff 75 d4             	pushl  -0x2c(%ebp)
  802589:	e8 d5 19 00 00       	call   803f63 <free_block>
  80258e:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  802591:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802595:	75 17                	jne    8025ae <free+0x615>
  802597:	83 ec 04             	sub    $0x4,%esp
  80259a:	68 18 51 80 00       	push   $0x805118
  80259f:	68 2a 01 00 00       	push   $0x12a
  8025a4:	68 cc 50 80 00       	push   $0x8050cc
  8025a9:	e8 3a 1e 00 00       	call   8043e8 <_panic>
  8025ae:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  8025b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025b7:	89 50 0c             	mov    %edx,0xc(%eax)
  8025ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	74 0d                	je     8025d1 <free+0x638>
  8025c4:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8025c9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8025cc:	89 50 08             	mov    %edx,0x8(%eax)
  8025cf:	eb 08                	jmp    8025d9 <free+0x640>
  8025d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025d4:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8025d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025dc:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8025e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8025eb:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8025f0:	40                   	inc    %eax
  8025f1:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  8025f6:	e9 1b 01 00 00       	jmp    802716 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8025fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025fe:	8b 50 04             	mov    0x4(%eax),%edx
  802601:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802604:	8b 40 04             	mov    0x4(%eax),%eax
  802607:	39 c2                	cmp    %eax,%edx
  802609:	0f 83 81 00 00 00    	jae    802690 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  80260f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802613:	74 06                	je     80261b <free+0x682>
  802615:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802619:	75 17                	jne    802632 <free+0x699>
  80261b:	83 ec 04             	sub    $0x4,%esp
  80261e:	68 5c 51 80 00       	push   $0x80515c
  802623:	68 30 01 00 00       	push   $0x130
  802628:	68 cc 50 80 00       	push   $0x8050cc
  80262d:	e8 b6 1d 00 00       	call   8043e8 <_panic>
  802632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802635:	8b 50 0c             	mov    0xc(%eax),%edx
  802638:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80263b:	89 50 0c             	mov    %edx,0xc(%eax)
  80263e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802641:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802644:	89 50 08             	mov    %edx,0x8(%eax)
  802647:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80264a:	8b 40 0c             	mov    0xc(%eax),%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	74 0e                	je     80265f <free+0x6c6>
  802651:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802654:	8b 40 0c             	mov    0xc(%eax),%eax
  802657:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80265a:	89 50 08             	mov    %edx,0x8(%eax)
  80265d:	eb 08                	jmp    802667 <free+0x6ce>
  80265f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802662:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80266d:	89 50 0c             	mov    %edx,0xc(%eax)
  802670:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802675:	40                   	inc    %eax
  802676:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  80267b:	83 ec 0c             	sub    $0xc,%esp
  80267e:	68 40 e1 81 00       	push   $0x81e140
  802683:	e8 ff 1c 00 00       	call   804387 <release_uspinlock>
  802688:	83 c4 10             	add    $0x10,%esp
							return;
  80268b:	e9 97 00 00 00       	jmp    802727 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802693:	8b 40 08             	mov    0x8(%eax),%eax
  802696:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  802699:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80269d:	0f 85 58 ff ff ff    	jne    8025fb <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	ff 75 d0             	pushl  -0x30(%ebp)
  8026a9:	e8 b5 18 00 00       	call   803f63 <free_block>
  8026ae:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8026b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026b5:	75 17                	jne    8026ce <free+0x735>
  8026b7:	83 ec 04             	sub    $0x4,%esp
  8026ba:	68 18 51 80 00       	push   $0x805118
  8026bf:	68 37 01 00 00       	push   $0x137
  8026c4:	68 cc 50 80 00       	push   $0x8050cc
  8026c9:	e8 1a 1d 00 00       	call   8043e8 <_panic>
  8026ce:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  8026d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026d7:	89 50 0c             	mov    %edx,0xc(%eax)
  8026da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	74 0d                	je     8026f1 <free+0x758>
  8026e4:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8026e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026ec:	89 50 08             	mov    %edx,0x8(%eax)
  8026ef:	eb 08                	jmp    8026f9 <free+0x760>
  8026f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f4:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8026f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026fc:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802701:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802704:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80270b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802710:	40                   	inc    %eax
  802711:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  802716:	83 ec 0c             	sub    $0xc,%esp
  802719:	68 40 e1 81 00       	push   $0x81e140
  80271e:	e8 64 1c 00 00       	call   804387 <release_uspinlock>
  802723:	83 c4 10             	add    $0x10,%esp
		return;
  802726:	90                   	nop
}
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	83 ec 48             	sub    $0x48,%esp
  80272f:	8b 45 10             	mov    0x10(%ebp),%eax
  802732:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802735:	e8 2d f2 ff ff       	call   801967 <uheap_init>
	if (size == 0) return NULL;
  80273a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80273e:	75 0a                	jne    80274a <smalloc+0x21>
  802740:	b8 00 00 00 00       	mov    $0x0,%eax
  802745:	e9 84 05 00 00       	jmp    802cce <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  80274a:	83 ec 0c             	sub    $0xc,%esp
  80274d:	68 40 e1 81 00       	push   $0x81e140
  802752:	e8 d8 1b 00 00       	call   80432f <acquire_uspinlock>
  802757:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80275a:	83 ec 0c             	sub    $0xc,%esp
  80275d:	6a 10                	push   $0x10
  80275f:	e8 63 13 00 00       	call   803ac7 <alloc_block>
  802764:	83 c4 10             	add    $0x10,%esp
  802767:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  80276a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80276e:	75 0a                	jne    80277a <smalloc+0x51>
				return NULL;
  802770:	b8 00 00 00 00       	mov    $0x0,%eax
  802775:	e9 54 05 00 00       	jmp    802cce <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  80277a:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802781:	8b 55 0c             	mov    0xc(%ebp),%edx
  802784:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802787:	01 d0                	add    %edx,%eax
  802789:	48                   	dec    %eax
  80278a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80278d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802790:	ba 00 00 00 00       	mov    $0x0,%edx
  802795:	f7 75 e8             	divl   -0x18(%ebp)
  802798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279b:	29 d0                	sub    %edx,%eax
  80279d:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8027a0:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8027a5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8027a8:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	74 0f                	je     8027c0 <smalloc+0x97>
  8027b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b4:	8b 40 04             	mov    0x4(%eax),%eax
  8027b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027ba:	0f 83 25 01 00 00    	jae    8028e5 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8027c0:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8027c5:	2b 45 0c             	sub    0xc(%ebp),%eax
  8027c8:	89 c2                	mov    %eax,%edx
  8027ca:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8027cf:	39 c2                	cmp    %eax,%edx
  8027d1:	0f 82 f4 00 00 00    	jb     8028cb <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  8027d7:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8027dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  8027df:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8027e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e8:	01 d0                	add    %edx,%eax
  8027ea:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  8027ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8027f5:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8027f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027fd:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802800:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802804:	75 17                	jne    80281d <smalloc+0xf4>
  802806:	83 ec 04             	sub    $0x4,%esp
  802809:	68 18 51 80 00       	push   $0x805118
  80280e:	68 57 01 00 00       	push   $0x157
  802813:	68 cc 50 80 00       	push   $0x8050cc
  802818:	e8 cb 1b 00 00       	call   8043e8 <_panic>
  80281d:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802823:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802826:	89 50 0c             	mov    %edx,0xc(%eax)
  802829:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282c:	8b 40 0c             	mov    0xc(%eax),%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	74 0d                	je     802840 <smalloc+0x117>
  802833:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802838:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80283b:	89 50 08             	mov    %edx,0x8(%eax)
  80283e:	eb 08                	jmp    802848 <smalloc+0x11f>
  802840:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802843:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284b:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802853:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80285a:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80285f:	40                   	inc    %eax
  802860:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	89 c2                	mov    %eax,%edx
  80286c:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802870:	52                   	push   %edx
  802871:	50                   	push   %eax
  802872:	ff 75 0c             	pushl  0xc(%ebp)
  802875:	ff 75 08             	pushl  0x8(%ebp)
  802878:	e8 48 0c 00 00       	call   8034c5 <sys_create_shared_object>
  80287d:	83 c4 10             	add    $0x10,%esp
  802880:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802883:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802887:	79 28                	jns    8028b1 <smalloc+0x188>
							free_block(allocblock);
  802889:	83 ec 0c             	sub    $0xc,%esp
  80288c:	ff 75 ec             	pushl  -0x14(%ebp)
  80288f:	e8 cf 16 00 00       	call   803f63 <free_block>
  802894:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802897:	83 ec 0c             	sub    $0xc,%esp
  80289a:	68 40 e1 81 00       	push   $0x81e140
  80289f:	e8 e3 1a 00 00       	call   804387 <release_uspinlock>
  8028a4:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8028a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ac:	e9 1d 04 00 00       	jmp    802cce <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  8028b1:	83 ec 0c             	sub    $0xc,%esp
  8028b4:	68 40 e1 81 00       	push   $0x81e140
  8028b9:	e8 c9 1a 00 00       	call   804387 <release_uspinlock>
  8028be:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8028c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	e9 03 04 00 00       	jmp    802cce <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  8028cb:	83 ec 0c             	sub    $0xc,%esp
  8028ce:	68 40 e1 81 00       	push   $0x81e140
  8028d3:	e8 af 1a 00 00       	call   804387 <release_uspinlock>
  8028d8:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8028db:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e0:	e9 e9 03 00 00       	jmp    802cce <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8028e5:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8028ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8028ed:	e9 af 03 00 00       	jmp    802ca1 <smalloc+0x578>
				if(size<currentfreeelement->size){
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	8b 40 04             	mov    0x4(%eax),%eax
  8028f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8028fb:	0f 86 28 02 00 00    	jbe    802b29 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802901:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802904:	8b 10                	mov    (%eax),%edx
  802906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802909:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  80290b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802911:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802914:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802918:	75 17                	jne    802931 <smalloc+0x208>
  80291a:	83 ec 04             	sub    $0x4,%esp
  80291d:	68 18 51 80 00       	push   $0x805118
  802922:	68 6f 01 00 00       	push   $0x16f
  802927:	68 cc 50 80 00       	push   $0x8050cc
  80292c:	e8 b7 1a 00 00       	call   8043e8 <_panic>
  802931:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802937:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293a:	89 50 0c             	mov    %edx,0xc(%eax)
  80293d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802940:	8b 40 0c             	mov    0xc(%eax),%eax
  802943:	85 c0                	test   %eax,%eax
  802945:	74 0d                	je     802954 <smalloc+0x22b>
  802947:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80294c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80294f:	89 50 08             	mov    %edx,0x8(%eax)
  802952:	eb 08                	jmp    80295c <smalloc+0x233>
  802954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802957:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80295c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295f:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802967:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80296e:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802973:	40                   	inc    %eax
  802974:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  802979:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80297c:	8b 10                	mov    (%eax),%edx
  80297e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802981:	01 c2                	add    %eax,%edx
  802983:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802986:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802988:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298b:	8b 40 04             	mov    0x4(%eax),%eax
  80298e:	2b 45 0c             	sub    0xc(%ebp),%eax
  802991:	89 c2                	mov    %eax,%edx
  802993:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802996:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802999:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80299e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  8029a1:	e9 13 01 00 00       	jmp    802ab9 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  8029a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a9:	8b 50 04             	mov    0x4(%eax),%edx
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	39 c2                	cmp    %eax,%edx
  8029b4:	0f 83 f6 00 00 00    	jae    802ab0 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8029ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029be:	75 17                	jne    8029d7 <smalloc+0x2ae>
  8029c0:	83 ec 04             	sub    $0x4,%esp
  8029c3:	68 3b 51 80 00       	push   $0x80513b
  8029c8:	68 77 01 00 00       	push   $0x177
  8029cd:	68 cc 50 80 00       	push   $0x8050cc
  8029d2:	e8 11 1a 00 00       	call   8043e8 <_panic>
  8029d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029da:	8b 40 08             	mov    0x8(%eax),%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	74 11                	je     8029f2 <smalloc+0x2c9>
  8029e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e4:	8b 40 08             	mov    0x8(%eax),%eax
  8029e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029ea:	8b 52 0c             	mov    0xc(%edx),%edx
  8029ed:	89 50 0c             	mov    %edx,0xc(%eax)
  8029f0:	eb 0b                	jmp    8029fd <smalloc+0x2d4>
  8029f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f8:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8029fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a00:	8b 40 0c             	mov    0xc(%eax),%eax
  802a03:	85 c0                	test   %eax,%eax
  802a05:	74 11                	je     802a18 <smalloc+0x2ef>
  802a07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a10:	8b 52 08             	mov    0x8(%edx),%edx
  802a13:	89 50 08             	mov    %edx,0x8(%eax)
  802a16:	eb 0b                	jmp    802a23 <smalloc+0x2fa>
  802a18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a1b:	8b 40 08             	mov    0x8(%eax),%eax
  802a1e:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802a23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a26:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a30:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a37:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802a3c:	48                   	dec    %eax
  802a3d:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802a42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a46:	74 06                	je     802a4e <smalloc+0x325>
  802a48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a4c:	75 17                	jne    802a65 <smalloc+0x33c>
  802a4e:	83 ec 04             	sub    $0x4,%esp
  802a51:	68 5c 51 80 00       	push   $0x80515c
  802a56:	68 78 01 00 00       	push   $0x178
  802a5b:	68 cc 50 80 00       	push   $0x8050cc
  802a60:	e8 83 19 00 00       	call   8043e8 <_panic>
  802a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a68:	8b 50 0c             	mov    0xc(%eax),%edx
  802a6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a6e:	89 50 0c             	mov    %edx,0xc(%eax)
  802a71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a77:	89 50 08             	mov    %edx,0x8(%eax)
  802a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 0e                	je     802a92 <smalloc+0x369>
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a8d:	89 50 08             	mov    %edx,0x8(%eax)
  802a90:	eb 08                	jmp    802a9a <smalloc+0x371>
  802a92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a95:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802aa0:	89 50 0c             	mov    %edx,0xc(%eax)
  802aa3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802aa8:	40                   	inc    %eax
  802aa9:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  802aae:	eb 13                	jmp    802ac3 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab3:	8b 40 08             	mov    0x8(%eax),%eax
  802ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802ab9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802abd:	0f 85 e3 fe ff ff    	jne    8029a6 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	89 c2                	mov    %eax,%edx
  802aca:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802ace:	52                   	push   %edx
  802acf:	50                   	push   %eax
  802ad0:	ff 75 0c             	pushl  0xc(%ebp)
  802ad3:	ff 75 08             	pushl  0x8(%ebp)
  802ad6:	e8 ea 09 00 00       	call   8034c5 <sys_create_shared_object>
  802adb:	83 c4 10             	add    $0x10,%esp
  802ade:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802ae1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802ae5:	79 28                	jns    802b0f <smalloc+0x3e6>
	                	free_block(allocblock);
  802ae7:	83 ec 0c             	sub    $0xc,%esp
  802aea:	ff 75 ec             	pushl  -0x14(%ebp)
  802aed:	e8 71 14 00 00       	call   803f63 <free_block>
  802af2:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802af5:	83 ec 0c             	sub    $0xc,%esp
  802af8:	68 40 e1 81 00       	push   $0x81e140
  802afd:	e8 85 18 00 00       	call   804387 <release_uspinlock>
  802b02:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0a:	e9 bf 01 00 00       	jmp    802cce <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802b0f:	83 ec 0c             	sub    $0xc,%esp
  802b12:	68 40 e1 81 00       	push   $0x81e140
  802b17:	e8 6b 18 00 00       	call   804387 <release_uspinlock>
  802b1c:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b22:	8b 00                	mov    (%eax),%eax
  802b24:	e9 a5 01 00 00       	jmp    802cce <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 40 04             	mov    0x4(%eax),%eax
  802b2f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b32:	0f 85 60 01 00 00    	jne    802c98 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 10                	mov    (%eax),%edx
  802b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b40:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b48:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802b4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b4f:	75 17                	jne    802b68 <smalloc+0x43f>
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	68 18 51 80 00       	push   $0x805118
  802b59:	68 8c 01 00 00       	push   $0x18c
  802b5e:	68 cc 50 80 00       	push   $0x8050cc
  802b63:	e8 80 18 00 00       	call   8043e8 <_panic>
  802b68:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b71:	89 50 0c             	mov    %edx,0xc(%eax)
  802b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b77:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 0d                	je     802b8b <smalloc+0x462>
  802b7e:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802b83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b86:	89 50 08             	mov    %edx,0x8(%eax)
  802b89:	eb 08                	jmp    802b93 <smalloc+0x46a>
  802b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8e:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b96:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ba5:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802baa:	40                   	inc    %eax
  802bab:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802bb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb4:	75 17                	jne    802bcd <smalloc+0x4a4>
  802bb6:	83 ec 04             	sub    $0x4,%esp
  802bb9:	68 3b 51 80 00       	push   $0x80513b
  802bbe:	68 8d 01 00 00       	push   $0x18d
  802bc3:	68 cc 50 80 00       	push   $0x8050cc
  802bc8:	e8 1b 18 00 00       	call   8043e8 <_panic>
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	8b 40 08             	mov    0x8(%eax),%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	74 11                	je     802be8 <smalloc+0x4bf>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 40 08             	mov    0x8(%eax),%eax
  802bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be0:	8b 52 0c             	mov    0xc(%edx),%edx
  802be3:	89 50 0c             	mov    %edx,0xc(%eax)
  802be6:	eb 0b                	jmp    802bf3 <smalloc+0x4ca>
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bee:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	74 11                	je     802c0e <smalloc+0x4e5>
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 40 0c             	mov    0xc(%eax),%eax
  802c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c06:	8b 52 08             	mov    0x8(%edx),%edx
  802c09:	89 50 08             	mov    %edx,0x8(%eax)
  802c0c:	eb 0b                	jmp    802c19 <smalloc+0x4f0>
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 40 08             	mov    0x8(%eax),%eax
  802c14:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c2d:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802c32:	48                   	dec    %eax
  802c33:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	89 c2                	mov    %eax,%edx
  802c3f:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802c43:	52                   	push   %edx
  802c44:	50                   	push   %eax
  802c45:	ff 75 0c             	pushl  0xc(%ebp)
  802c48:	ff 75 08             	pushl  0x8(%ebp)
  802c4b:	e8 75 08 00 00       	call   8034c5 <sys_create_shared_object>
  802c50:	83 c4 10             	add    $0x10,%esp
  802c53:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802c56:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c5a:	79 25                	jns    802c81 <smalloc+0x558>
						free_block(allocblock);
  802c5c:	83 ec 0c             	sub    $0xc,%esp
  802c5f:	ff 75 ec             	pushl  -0x14(%ebp)
  802c62:	e8 fc 12 00 00       	call   803f63 <free_block>
  802c67:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802c6a:	83 ec 0c             	sub    $0xc,%esp
  802c6d:	68 40 e1 81 00       	push   $0x81e140
  802c72:	e8 10 17 00 00       	call   804387 <release_uspinlock>
  802c77:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7f:	eb 4d                	jmp    802cce <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802c81:	83 ec 0c             	sub    $0xc,%esp
  802c84:	68 40 e1 81 00       	push   $0x81e140
  802c89:	e8 f9 16 00 00       	call   804387 <release_uspinlock>
  802c8e:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	eb 36                	jmp    802cce <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 40 08             	mov    0x8(%eax),%eax
  802c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802ca1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca5:	0f 85 47 fc ff ff    	jne    8028f2 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802cab:	83 ec 0c             	sub    $0xc,%esp
  802cae:	ff 75 ec             	pushl  -0x14(%ebp)
  802cb1:	e8 ad 12 00 00       	call   803f63 <free_block>
  802cb6:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802cb9:	83 ec 0c             	sub    $0xc,%esp
  802cbc:	68 40 e1 81 00       	push   $0x81e140
  802cc1:	e8 c1 16 00 00       	call   804387 <release_uspinlock>
  802cc6:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802cc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cce:	c9                   	leave  
  802ccf:	c3                   	ret    

00802cd0 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802cd0:	55                   	push   %ebp
  802cd1:	89 e5                	mov    %esp,%ebp
  802cd3:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802cd6:	e8 8c ec ff ff       	call   801967 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802cdb:	83 ec 0c             	sub    $0xc,%esp
  802cde:	68 40 e1 81 00       	push   $0x81e140
  802ce3:	e8 47 16 00 00       	call   80432f <acquire_uspinlock>
  802ce8:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802ceb:	83 ec 08             	sub    $0x8,%esp
  802cee:	ff 75 0c             	pushl  0xc(%ebp)
  802cf1:	ff 75 08             	pushl  0x8(%ebp)
  802cf4:	e8 f6 07 00 00       	call   8034ef <sys_size_of_shared_object>
  802cf9:	83 c4 10             	add    $0x10,%esp
  802cfc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  802cff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d03:	79 1a                	jns    802d1f <sget+0x4f>
			release_uspinlock(&ulock);
  802d05:	83 ec 0c             	sub    $0xc,%esp
  802d08:	68 40 e1 81 00       	push   $0x81e140
  802d0d:	e8 75 16 00 00       	call   804387 <release_uspinlock>
  802d12:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802d15:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1a:	e9 6e 05 00 00       	jmp    80328d <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802d1f:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802d26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2c:	01 d0                	add    %edx,%eax
  802d2e:	48                   	dec    %eax
  802d2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d35:	ba 00 00 00 00       	mov    $0x0,%edx
  802d3a:	f7 75 e8             	divl   -0x18(%ebp)
  802d3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d40:	29 d0                	sub    %edx,%eax
  802d42:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802d45:	83 ec 0c             	sub    $0xc,%esp
  802d48:	6a 10                	push   $0x10
  802d4a:	e8 78 0d 00 00       	call   803ac7 <alloc_block>
  802d4f:	83 c4 10             	add    $0x10,%esp
  802d52:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802d55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d59:	75 0a                	jne    802d65 <sget+0x95>
			return NULL;
  802d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d60:	e9 28 05 00 00       	jmp    80328d <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802d65:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802d6a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802d6d:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802d72:	85 c0                	test   %eax,%eax
  802d74:	74 11                	je     802d87 <sget+0xb7>
  802d76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d79:	8b 50 04             	mov    0x4(%eax),%edx
  802d7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7f:	39 c2                	cmp    %eax,%edx
  802d81:	0f 83 21 01 00 00    	jae    802ea8 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8a:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802d8f:	29 c2                	sub    %eax,%edx
  802d91:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802d96:	39 c2                	cmp    %eax,%edx
  802d98:	0f 82 f0 00 00 00    	jb     802e8e <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802d9e:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802da3:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802da6:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802daf:	01 d0                	add    %edx,%eax
  802db1:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802db6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802dbc:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802dbe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc4:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802dc7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dcb:	75 17                	jne    802de4 <sget+0x114>
  802dcd:	83 ec 04             	sub    $0x4,%esp
  802dd0:	68 18 51 80 00       	push   $0x805118
  802dd5:	68 c8 01 00 00       	push   $0x1c8
  802dda:	68 cc 50 80 00       	push   $0x8050cc
  802ddf:	e8 04 16 00 00       	call   8043e8 <_panic>
  802de4:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802dea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ded:	89 50 0c             	mov    %edx,0xc(%eax)
  802df0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df3:	8b 40 0c             	mov    0xc(%eax),%eax
  802df6:	85 c0                	test   %eax,%eax
  802df8:	74 0d                	je     802e07 <sget+0x137>
  802dfa:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802dff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e02:	89 50 08             	mov    %edx,0x8(%eax)
  802e05:	eb 08                	jmp    802e0f <sget+0x13f>
  802e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0a:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e12:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802e17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e21:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802e26:	40                   	inc    %eax
  802e27:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802e2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	83 ec 04             	sub    $0x4,%esp
  802e34:	50                   	push   %eax
  802e35:	ff 75 0c             	pushl  0xc(%ebp)
  802e38:	ff 75 08             	pushl  0x8(%ebp)
  802e3b:	e8 cc 06 00 00       	call   80350c <sys_get_shared_object>
  802e40:	83 c4 10             	add    $0x10,%esp
  802e43:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802e46:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e4a:	79 28                	jns    802e74 <sget+0x1a4>
							free_block(allocblock);
  802e4c:	83 ec 0c             	sub    $0xc,%esp
  802e4f:	ff 75 e0             	pushl  -0x20(%ebp)
  802e52:	e8 0c 11 00 00       	call   803f63 <free_block>
  802e57:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802e5a:	83 ec 0c             	sub    $0xc,%esp
  802e5d:	68 40 e1 81 00       	push   $0x81e140
  802e62:	e8 20 15 00 00       	call   804387 <release_uspinlock>
  802e67:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6f:	e9 19 04 00 00       	jmp    80328d <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802e74:	83 ec 0c             	sub    $0xc,%esp
  802e77:	68 40 e1 81 00       	push   $0x81e140
  802e7c:	e8 06 15 00 00       	call   804387 <release_uspinlock>
  802e81:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e87:	8b 00                	mov    (%eax),%eax
  802e89:	e9 ff 03 00 00       	jmp    80328d <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802e8e:	83 ec 0c             	sub    $0xc,%esp
  802e91:	68 40 e1 81 00       	push   $0x81e140
  802e96:	e8 ec 14 00 00       	call   804387 <release_uspinlock>
  802e9b:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea3:	e9 e5 03 00 00       	jmp    80328d <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802ea8:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802eb0:	e9 ab 03 00 00       	jmp    803260 <sget+0x590>
				if(size<currentfreeelement->size){
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	8b 50 04             	mov    0x4(%eax),%edx
  802ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebe:	39 c2                	cmp    %eax,%edx
  802ec0:	0f 86 24 02 00 00    	jbe    8030ea <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802ec6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec9:	8b 10                	mov    (%eax),%edx
  802ecb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ece:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802ed0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed6:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802ed9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802edd:	75 17                	jne    802ef6 <sget+0x226>
  802edf:	83 ec 04             	sub    $0x4,%esp
  802ee2:	68 18 51 80 00       	push   $0x805118
  802ee7:	68 e0 01 00 00       	push   $0x1e0
  802eec:	68 cc 50 80 00       	push   $0x8050cc
  802ef1:	e8 f2 14 00 00       	call   8043e8 <_panic>
  802ef6:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802efc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eff:	89 50 0c             	mov    %edx,0xc(%eax)
  802f02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f05:	8b 40 0c             	mov    0xc(%eax),%eax
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	74 0d                	je     802f19 <sget+0x249>
  802f0c:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802f11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f14:	89 50 08             	mov    %edx,0x8(%eax)
  802f17:	eb 08                	jmp    802f21 <sget+0x251>
  802f19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1c:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802f21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f24:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802f29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f33:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802f38:	40                   	inc    %eax
  802f39:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  802f3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f41:	8b 10                	mov    (%eax),%edx
  802f43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f46:	01 c2                	add    %eax,%edx
  802f48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f4b:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802f4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f50:	8b 50 04             	mov    0x4(%eax),%edx
  802f53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f56:	29 c2                	sub    %eax,%edx
  802f58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5b:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802f5e:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802f66:	e9 13 01 00 00       	jmp    80307e <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802f6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f6e:	8b 50 04             	mov    0x4(%eax),%edx
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	39 c2                	cmp    %eax,%edx
  802f79:	0f 83 f6 00 00 00    	jae    803075 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802f7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f83:	75 17                	jne    802f9c <sget+0x2cc>
  802f85:	83 ec 04             	sub    $0x4,%esp
  802f88:	68 3b 51 80 00       	push   $0x80513b
  802f8d:	68 e8 01 00 00       	push   $0x1e8
  802f92:	68 cc 50 80 00       	push   $0x8050cc
  802f97:	e8 4c 14 00 00       	call   8043e8 <_panic>
  802f9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9f:	8b 40 08             	mov    0x8(%eax),%eax
  802fa2:	85 c0                	test   %eax,%eax
  802fa4:	74 11                	je     802fb7 <sget+0x2e7>
  802fa6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa9:	8b 40 08             	mov    0x8(%eax),%eax
  802fac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802faf:	8b 52 0c             	mov    0xc(%edx),%edx
  802fb2:	89 50 0c             	mov    %edx,0xc(%eax)
  802fb5:	eb 0b                	jmp    802fc2 <sget+0x2f2>
  802fb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fba:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbd:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802fc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 11                	je     802fdd <sget+0x30d>
  802fcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fcf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fd5:	8b 52 08             	mov    0x8(%edx),%edx
  802fd8:	89 50 08             	mov    %edx,0x8(%eax)
  802fdb:	eb 0b                	jmp    802fe8 <sget+0x318>
  802fdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe0:	8b 40 08             	mov    0x8(%eax),%eax
  802fe3:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802fe8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802feb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ff2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ffc:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803001:	48                   	dec    %eax
  803002:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803007:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80300b:	74 06                	je     803013 <sget+0x343>
  80300d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803011:	75 17                	jne    80302a <sget+0x35a>
  803013:	83 ec 04             	sub    $0x4,%esp
  803016:	68 5c 51 80 00       	push   $0x80515c
  80301b:	68 e9 01 00 00       	push   $0x1e9
  803020:	68 cc 50 80 00       	push   $0x8050cc
  803025:	e8 be 13 00 00       	call   8043e8 <_panic>
  80302a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302d:	8b 50 0c             	mov    0xc(%eax),%edx
  803030:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803033:	89 50 0c             	mov    %edx,0xc(%eax)
  803036:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803039:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80303c:	89 50 08             	mov    %edx,0x8(%eax)
  80303f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803042:	8b 40 0c             	mov    0xc(%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	74 0e                	je     803057 <sget+0x387>
  803049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304c:	8b 40 0c             	mov    0xc(%eax),%eax
  80304f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803052:	89 50 08             	mov    %edx,0x8(%eax)
  803055:	eb 08                	jmp    80305f <sget+0x38f>
  803057:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305a:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80305f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803062:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803065:	89 50 0c             	mov    %edx,0xc(%eax)
  803068:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80306d:	40                   	inc    %eax
  80306e:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  803073:	eb 13                	jmp    803088 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  803075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803078:	8b 40 08             	mov    0x8(%eax),%eax
  80307b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  80307e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803082:	0f 85 e3 fe ff ff    	jne    802f6b <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803088:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308b:	8b 00                	mov    (%eax),%eax
  80308d:	83 ec 04             	sub    $0x4,%esp
  803090:	50                   	push   %eax
  803091:	ff 75 0c             	pushl  0xc(%ebp)
  803094:	ff 75 08             	pushl  0x8(%ebp)
  803097:	e8 70 04 00 00       	call   80350c <sys_get_shared_object>
  80309c:	83 c4 10             	add    $0x10,%esp
  80309f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  8030a2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8030a6:	79 28                	jns    8030d0 <sget+0x400>
						free_block(allocblock);
  8030a8:	83 ec 0c             	sub    $0xc,%esp
  8030ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8030ae:	e8 b0 0e 00 00       	call   803f63 <free_block>
  8030b3:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8030b6:	83 ec 0c             	sub    $0xc,%esp
  8030b9:	68 40 e1 81 00       	push   $0x81e140
  8030be:	e8 c4 12 00 00       	call   804387 <release_uspinlock>
  8030c3:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8030c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030cb:	e9 bd 01 00 00       	jmp    80328d <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  8030d0:	83 ec 0c             	sub    $0xc,%esp
  8030d3:	68 40 e1 81 00       	push   $0x81e140
  8030d8:	e8 aa 12 00 00       	call   804387 <release_uspinlock>
  8030dd:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8030e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e3:	8b 00                	mov    (%eax),%eax
  8030e5:	e9 a3 01 00 00       	jmp    80328d <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	8b 50 04             	mov    0x4(%eax),%edx
  8030f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f3:	39 c2                	cmp    %eax,%edx
  8030f5:	0f 85 5c 01 00 00    	jne    803257 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	8b 10                	mov    (%eax),%edx
  803100:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803103:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803105:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803108:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80310b:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  80310e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803112:	75 17                	jne    80312b <sget+0x45b>
  803114:	83 ec 04             	sub    $0x4,%esp
  803117:	68 18 51 80 00       	push   $0x805118
  80311c:	68 fe 01 00 00       	push   $0x1fe
  803121:	68 cc 50 80 00       	push   $0x8050cc
  803126:	e8 bd 12 00 00       	call   8043e8 <_panic>
  80312b:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  803131:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803134:	89 50 0c             	mov    %edx,0xc(%eax)
  803137:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80313a:	8b 40 0c             	mov    0xc(%eax),%eax
  80313d:	85 c0                	test   %eax,%eax
  80313f:	74 0d                	je     80314e <sget+0x47e>
  803141:	a1 34 e1 81 00       	mov    0x81e134,%eax
  803146:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803149:	89 50 08             	mov    %edx,0x8(%eax)
  80314c:	eb 08                	jmp    803156 <sget+0x486>
  80314e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803151:	a3 30 e1 81 00       	mov    %eax,0x81e130
  803156:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803159:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80315e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803161:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803168:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80316d:	40                   	inc    %eax
  80316e:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803173:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803177:	75 17                	jne    803190 <sget+0x4c0>
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	68 3b 51 80 00       	push   $0x80513b
  803181:	68 ff 01 00 00       	push   $0x1ff
  803186:	68 cc 50 80 00       	push   $0x8050cc
  80318b:	e8 58 12 00 00       	call   8043e8 <_panic>
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 40 08             	mov    0x8(%eax),%eax
  803196:	85 c0                	test   %eax,%eax
  803198:	74 11                	je     8031ab <sget+0x4db>
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	8b 40 08             	mov    0x8(%eax),%eax
  8031a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a3:	8b 52 0c             	mov    0xc(%edx),%edx
  8031a6:	89 50 0c             	mov    %edx,0xc(%eax)
  8031a9:	eb 0b                	jmp    8031b6 <sget+0x4e6>
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b1:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	74 11                	je     8031d1 <sget+0x501>
  8031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031c9:	8b 52 08             	mov    0x8(%edx),%edx
  8031cc:	89 50 08             	mov    %edx,0x8(%eax)
  8031cf:	eb 0b                	jmp    8031dc <sget+0x50c>
  8031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d4:	8b 40 08             	mov    0x8(%eax),%eax
  8031d7:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8031f0:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8031f5:	48                   	dec    %eax
  8031f6:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  8031fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	83 ec 04             	sub    $0x4,%esp
  803203:	50                   	push   %eax
  803204:	ff 75 0c             	pushl  0xc(%ebp)
  803207:	ff 75 08             	pushl  0x8(%ebp)
  80320a:	e8 fd 02 00 00       	call   80350c <sys_get_shared_object>
  80320f:	83 c4 10             	add    $0x10,%esp
  803212:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803215:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803219:	79 25                	jns    803240 <sget+0x570>
						free_block(allocblock);
  80321b:	83 ec 0c             	sub    $0xc,%esp
  80321e:	ff 75 e0             	pushl  -0x20(%ebp)
  803221:	e8 3d 0d 00 00       	call   803f63 <free_block>
  803226:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803229:	83 ec 0c             	sub    $0xc,%esp
  80322c:	68 40 e1 81 00       	push   $0x81e140
  803231:	e8 51 11 00 00       	call   804387 <release_uspinlock>
  803236:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803239:	b8 00 00 00 00       	mov    $0x0,%eax
  80323e:	eb 4d                	jmp    80328d <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  803240:	83 ec 0c             	sub    $0xc,%esp
  803243:	68 40 e1 81 00       	push   $0x81e140
  803248:	e8 3a 11 00 00       	call   804387 <release_uspinlock>
  80324d:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803250:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803253:	8b 00                	mov    (%eax),%eax
  803255:	eb 36                	jmp    80328d <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	8b 40 08             	mov    0x8(%eax),%eax
  80325d:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803264:	0f 85 4b fc ff ff    	jne    802eb5 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  80326a:	83 ec 0c             	sub    $0xc,%esp
  80326d:	ff 75 e0             	pushl  -0x20(%ebp)
  803270:	e8 ee 0c 00 00       	call   803f63 <free_block>
  803275:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803278:	83 ec 0c             	sub    $0xc,%esp
  80327b:	68 40 e1 81 00       	push   $0x81e140
  803280:	e8 02 11 00 00       	call   804387 <release_uspinlock>
  803285:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80328d:	c9                   	leave  
  80328e:	c3                   	ret    

0080328f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80328f:	55                   	push   %ebp
  803290:	89 e5                	mov    %esp,%ebp
  803292:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803295:	e8 cd e6 ff ff       	call   801967 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80329a:	83 ec 04             	sub    $0x4,%esp
  80329d:	68 ec 51 80 00       	push   $0x8051ec
  8032a2:	68 2d 02 00 00       	push   $0x22d
  8032a7:	68 cc 50 80 00       	push   $0x8050cc
  8032ac:	e8 37 11 00 00       	call   8043e8 <_panic>

008032b1 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8032b1:	55                   	push   %ebp
  8032b2:	89 e5                	mov    %esp,%ebp
  8032b4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8032b7:	83 ec 04             	sub    $0x4,%esp
  8032ba:	68 14 52 80 00       	push   $0x805214
  8032bf:	68 40 02 00 00       	push   $0x240
  8032c4:	68 cc 50 80 00       	push   $0x8050cc
  8032c9:	e8 1a 11 00 00       	call   8043e8 <_panic>

008032ce <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8032ce:	55                   	push   %ebp
  8032cf:	89 e5                	mov    %esp,%ebp
  8032d1:	57                   	push   %edi
  8032d2:	56                   	push   %esi
  8032d3:	53                   	push   %ebx
  8032d4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032e3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8032e6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8032e9:	cd 30                	int    $0x30
  8032eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8032ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8032f1:	83 c4 10             	add    $0x10,%esp
  8032f4:	5b                   	pop    %ebx
  8032f5:	5e                   	pop    %esi
  8032f6:	5f                   	pop    %edi
  8032f7:	5d                   	pop    %ebp
  8032f8:	c3                   	ret    

008032f9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8032f9:	55                   	push   %ebp
  8032fa:	89 e5                	mov    %esp,%ebp
  8032fc:	83 ec 04             	sub    $0x4,%esp
  8032ff:	8b 45 10             	mov    0x10(%ebp),%eax
  803302:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803305:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803308:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	6a 00                	push   $0x0
  803311:	51                   	push   %ecx
  803312:	52                   	push   %edx
  803313:	ff 75 0c             	pushl  0xc(%ebp)
  803316:	50                   	push   %eax
  803317:	6a 00                	push   $0x0
  803319:	e8 b0 ff ff ff       	call   8032ce <syscall>
  80331e:	83 c4 18             	add    $0x18,%esp
}
  803321:	90                   	nop
  803322:	c9                   	leave  
  803323:	c3                   	ret    

00803324 <sys_cgetc>:

int
sys_cgetc(void)
{
  803324:	55                   	push   %ebp
  803325:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803327:	6a 00                	push   $0x0
  803329:	6a 00                	push   $0x0
  80332b:	6a 00                	push   $0x0
  80332d:	6a 00                	push   $0x0
  80332f:	6a 00                	push   $0x0
  803331:	6a 02                	push   $0x2
  803333:	e8 96 ff ff ff       	call   8032ce <syscall>
  803338:	83 c4 18             	add    $0x18,%esp
}
  80333b:	c9                   	leave  
  80333c:	c3                   	ret    

0080333d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80333d:	55                   	push   %ebp
  80333e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803340:	6a 00                	push   $0x0
  803342:	6a 00                	push   $0x0
  803344:	6a 00                	push   $0x0
  803346:	6a 00                	push   $0x0
  803348:	6a 00                	push   $0x0
  80334a:	6a 03                	push   $0x3
  80334c:	e8 7d ff ff ff       	call   8032ce <syscall>
  803351:	83 c4 18             	add    $0x18,%esp
}
  803354:	90                   	nop
  803355:	c9                   	leave  
  803356:	c3                   	ret    

00803357 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803357:	55                   	push   %ebp
  803358:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80335a:	6a 00                	push   $0x0
  80335c:	6a 00                	push   $0x0
  80335e:	6a 00                	push   $0x0
  803360:	6a 00                	push   $0x0
  803362:	6a 00                	push   $0x0
  803364:	6a 04                	push   $0x4
  803366:	e8 63 ff ff ff       	call   8032ce <syscall>
  80336b:	83 c4 18             	add    $0x18,%esp
}
  80336e:	90                   	nop
  80336f:	c9                   	leave  
  803370:	c3                   	ret    

00803371 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803371:	55                   	push   %ebp
  803372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803374:	8b 55 0c             	mov    0xc(%ebp),%edx
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	6a 00                	push   $0x0
  80337c:	6a 00                	push   $0x0
  80337e:	6a 00                	push   $0x0
  803380:	52                   	push   %edx
  803381:	50                   	push   %eax
  803382:	6a 08                	push   $0x8
  803384:	e8 45 ff ff ff       	call   8032ce <syscall>
  803389:	83 c4 18             	add    $0x18,%esp
}
  80338c:	c9                   	leave  
  80338d:	c3                   	ret    

0080338e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80338e:	55                   	push   %ebp
  80338f:	89 e5                	mov    %esp,%ebp
  803391:	56                   	push   %esi
  803392:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803393:	8b 75 18             	mov    0x18(%ebp),%esi
  803396:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803399:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80339c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	56                   	push   %esi
  8033a3:	53                   	push   %ebx
  8033a4:	51                   	push   %ecx
  8033a5:	52                   	push   %edx
  8033a6:	50                   	push   %eax
  8033a7:	6a 09                	push   $0x9
  8033a9:	e8 20 ff ff ff       	call   8032ce <syscall>
  8033ae:	83 c4 18             	add    $0x18,%esp
}
  8033b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8033b4:	5b                   	pop    %ebx
  8033b5:	5e                   	pop    %esi
  8033b6:	5d                   	pop    %ebp
  8033b7:	c3                   	ret    

008033b8 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8033b8:	55                   	push   %ebp
  8033b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8033bb:	6a 00                	push   $0x0
  8033bd:	6a 00                	push   $0x0
  8033bf:	6a 00                	push   $0x0
  8033c1:	6a 00                	push   $0x0
  8033c3:	ff 75 08             	pushl  0x8(%ebp)
  8033c6:	6a 0a                	push   $0xa
  8033c8:	e8 01 ff ff ff       	call   8032ce <syscall>
  8033cd:	83 c4 18             	add    $0x18,%esp
}
  8033d0:	c9                   	leave  
  8033d1:	c3                   	ret    

008033d2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8033d2:	55                   	push   %ebp
  8033d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8033d5:	6a 00                	push   $0x0
  8033d7:	6a 00                	push   $0x0
  8033d9:	6a 00                	push   $0x0
  8033db:	ff 75 0c             	pushl  0xc(%ebp)
  8033de:	ff 75 08             	pushl  0x8(%ebp)
  8033e1:	6a 0b                	push   $0xb
  8033e3:	e8 e6 fe ff ff       	call   8032ce <syscall>
  8033e8:	83 c4 18             	add    $0x18,%esp
}
  8033eb:	c9                   	leave  
  8033ec:	c3                   	ret    

008033ed <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8033ed:	55                   	push   %ebp
  8033ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8033f0:	6a 00                	push   $0x0
  8033f2:	6a 00                	push   $0x0
  8033f4:	6a 00                	push   $0x0
  8033f6:	6a 00                	push   $0x0
  8033f8:	6a 00                	push   $0x0
  8033fa:	6a 0c                	push   $0xc
  8033fc:	e8 cd fe ff ff       	call   8032ce <syscall>
  803401:	83 c4 18             	add    $0x18,%esp
}
  803404:	c9                   	leave  
  803405:	c3                   	ret    

00803406 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803406:	55                   	push   %ebp
  803407:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803409:	6a 00                	push   $0x0
  80340b:	6a 00                	push   $0x0
  80340d:	6a 00                	push   $0x0
  80340f:	6a 00                	push   $0x0
  803411:	6a 00                	push   $0x0
  803413:	6a 0d                	push   $0xd
  803415:	e8 b4 fe ff ff       	call   8032ce <syscall>
  80341a:	83 c4 18             	add    $0x18,%esp
}
  80341d:	c9                   	leave  
  80341e:	c3                   	ret    

0080341f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80341f:	55                   	push   %ebp
  803420:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803422:	6a 00                	push   $0x0
  803424:	6a 00                	push   $0x0
  803426:	6a 00                	push   $0x0
  803428:	6a 00                	push   $0x0
  80342a:	6a 00                	push   $0x0
  80342c:	6a 0e                	push   $0xe
  80342e:	e8 9b fe ff ff       	call   8032ce <syscall>
  803433:	83 c4 18             	add    $0x18,%esp
}
  803436:	c9                   	leave  
  803437:	c3                   	ret    

00803438 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803438:	55                   	push   %ebp
  803439:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80343b:	6a 00                	push   $0x0
  80343d:	6a 00                	push   $0x0
  80343f:	6a 00                	push   $0x0
  803441:	6a 00                	push   $0x0
  803443:	6a 00                	push   $0x0
  803445:	6a 0f                	push   $0xf
  803447:	e8 82 fe ff ff       	call   8032ce <syscall>
  80344c:	83 c4 18             	add    $0x18,%esp
}
  80344f:	c9                   	leave  
  803450:	c3                   	ret    

00803451 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803451:	55                   	push   %ebp
  803452:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803454:	6a 00                	push   $0x0
  803456:	6a 00                	push   $0x0
  803458:	6a 00                	push   $0x0
  80345a:	6a 00                	push   $0x0
  80345c:	ff 75 08             	pushl  0x8(%ebp)
  80345f:	6a 10                	push   $0x10
  803461:	e8 68 fe ff ff       	call   8032ce <syscall>
  803466:	83 c4 18             	add    $0x18,%esp
}
  803469:	c9                   	leave  
  80346a:	c3                   	ret    

0080346b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80346b:	55                   	push   %ebp
  80346c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80346e:	6a 00                	push   $0x0
  803470:	6a 00                	push   $0x0
  803472:	6a 00                	push   $0x0
  803474:	6a 00                	push   $0x0
  803476:	6a 00                	push   $0x0
  803478:	6a 11                	push   $0x11
  80347a:	e8 4f fe ff ff       	call   8032ce <syscall>
  80347f:	83 c4 18             	add    $0x18,%esp
}
  803482:	90                   	nop
  803483:	c9                   	leave  
  803484:	c3                   	ret    

00803485 <sys_cputc>:

void
sys_cputc(const char c)
{
  803485:	55                   	push   %ebp
  803486:	89 e5                	mov    %esp,%ebp
  803488:	83 ec 04             	sub    $0x4,%esp
  80348b:	8b 45 08             	mov    0x8(%ebp),%eax
  80348e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803491:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803495:	6a 00                	push   $0x0
  803497:	6a 00                	push   $0x0
  803499:	6a 00                	push   $0x0
  80349b:	6a 00                	push   $0x0
  80349d:	50                   	push   %eax
  80349e:	6a 01                	push   $0x1
  8034a0:	e8 29 fe ff ff       	call   8032ce <syscall>
  8034a5:	83 c4 18             	add    $0x18,%esp
}
  8034a8:	90                   	nop
  8034a9:	c9                   	leave  
  8034aa:	c3                   	ret    

008034ab <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8034ab:	55                   	push   %ebp
  8034ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8034ae:	6a 00                	push   $0x0
  8034b0:	6a 00                	push   $0x0
  8034b2:	6a 00                	push   $0x0
  8034b4:	6a 00                	push   $0x0
  8034b6:	6a 00                	push   $0x0
  8034b8:	6a 14                	push   $0x14
  8034ba:	e8 0f fe ff ff       	call   8032ce <syscall>
  8034bf:	83 c4 18             	add    $0x18,%esp
}
  8034c2:	90                   	nop
  8034c3:	c9                   	leave  
  8034c4:	c3                   	ret    

008034c5 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8034c5:	55                   	push   %ebp
  8034c6:	89 e5                	mov    %esp,%ebp
  8034c8:	83 ec 04             	sub    $0x4,%esp
  8034cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8034ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8034d1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8034d4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	6a 00                	push   $0x0
  8034dd:	51                   	push   %ecx
  8034de:	52                   	push   %edx
  8034df:	ff 75 0c             	pushl  0xc(%ebp)
  8034e2:	50                   	push   %eax
  8034e3:	6a 15                	push   $0x15
  8034e5:	e8 e4 fd ff ff       	call   8032ce <syscall>
  8034ea:	83 c4 18             	add    $0x18,%esp
}
  8034ed:	c9                   	leave  
  8034ee:	c3                   	ret    

008034ef <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8034ef:	55                   	push   %ebp
  8034f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8034f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	6a 00                	push   $0x0
  8034fa:	6a 00                	push   $0x0
  8034fc:	6a 00                	push   $0x0
  8034fe:	52                   	push   %edx
  8034ff:	50                   	push   %eax
  803500:	6a 16                	push   $0x16
  803502:	e8 c7 fd ff ff       	call   8032ce <syscall>
  803507:	83 c4 18             	add    $0x18,%esp
}
  80350a:	c9                   	leave  
  80350b:	c3                   	ret    

0080350c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80350c:	55                   	push   %ebp
  80350d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80350f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803512:	8b 55 0c             	mov    0xc(%ebp),%edx
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	6a 00                	push   $0x0
  80351a:	6a 00                	push   $0x0
  80351c:	51                   	push   %ecx
  80351d:	52                   	push   %edx
  80351e:	50                   	push   %eax
  80351f:	6a 17                	push   $0x17
  803521:	e8 a8 fd ff ff       	call   8032ce <syscall>
  803526:	83 c4 18             	add    $0x18,%esp
}
  803529:	c9                   	leave  
  80352a:	c3                   	ret    

0080352b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80352b:	55                   	push   %ebp
  80352c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80352e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	6a 00                	push   $0x0
  803536:	6a 00                	push   $0x0
  803538:	6a 00                	push   $0x0
  80353a:	52                   	push   %edx
  80353b:	50                   	push   %eax
  80353c:	6a 18                	push   $0x18
  80353e:	e8 8b fd ff ff       	call   8032ce <syscall>
  803543:	83 c4 18             	add    $0x18,%esp
}
  803546:	c9                   	leave  
  803547:	c3                   	ret    

00803548 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803548:	55                   	push   %ebp
  803549:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80354b:	8b 45 08             	mov    0x8(%ebp),%eax
  80354e:	6a 00                	push   $0x0
  803550:	ff 75 14             	pushl  0x14(%ebp)
  803553:	ff 75 10             	pushl  0x10(%ebp)
  803556:	ff 75 0c             	pushl  0xc(%ebp)
  803559:	50                   	push   %eax
  80355a:	6a 19                	push   $0x19
  80355c:	e8 6d fd ff ff       	call   8032ce <syscall>
  803561:	83 c4 18             	add    $0x18,%esp
}
  803564:	c9                   	leave  
  803565:	c3                   	ret    

00803566 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803566:	55                   	push   %ebp
  803567:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803569:	8b 45 08             	mov    0x8(%ebp),%eax
  80356c:	6a 00                	push   $0x0
  80356e:	6a 00                	push   $0x0
  803570:	6a 00                	push   $0x0
  803572:	6a 00                	push   $0x0
  803574:	50                   	push   %eax
  803575:	6a 1a                	push   $0x1a
  803577:	e8 52 fd ff ff       	call   8032ce <syscall>
  80357c:	83 c4 18             	add    $0x18,%esp
}
  80357f:	90                   	nop
  803580:	c9                   	leave  
  803581:	c3                   	ret    

00803582 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803582:	55                   	push   %ebp
  803583:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	6a 00                	push   $0x0
  80358a:	6a 00                	push   $0x0
  80358c:	6a 00                	push   $0x0
  80358e:	6a 00                	push   $0x0
  803590:	50                   	push   %eax
  803591:	6a 1b                	push   $0x1b
  803593:	e8 36 fd ff ff       	call   8032ce <syscall>
  803598:	83 c4 18             	add    $0x18,%esp
}
  80359b:	c9                   	leave  
  80359c:	c3                   	ret    

0080359d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80359d:	55                   	push   %ebp
  80359e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8035a0:	6a 00                	push   $0x0
  8035a2:	6a 00                	push   $0x0
  8035a4:	6a 00                	push   $0x0
  8035a6:	6a 00                	push   $0x0
  8035a8:	6a 00                	push   $0x0
  8035aa:	6a 05                	push   $0x5
  8035ac:	e8 1d fd ff ff       	call   8032ce <syscall>
  8035b1:	83 c4 18             	add    $0x18,%esp
}
  8035b4:	c9                   	leave  
  8035b5:	c3                   	ret    

008035b6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8035b6:	55                   	push   %ebp
  8035b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8035b9:	6a 00                	push   $0x0
  8035bb:	6a 00                	push   $0x0
  8035bd:	6a 00                	push   $0x0
  8035bf:	6a 00                	push   $0x0
  8035c1:	6a 00                	push   $0x0
  8035c3:	6a 06                	push   $0x6
  8035c5:	e8 04 fd ff ff       	call   8032ce <syscall>
  8035ca:	83 c4 18             	add    $0x18,%esp
}
  8035cd:	c9                   	leave  
  8035ce:	c3                   	ret    

008035cf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8035cf:	55                   	push   %ebp
  8035d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8035d2:	6a 00                	push   $0x0
  8035d4:	6a 00                	push   $0x0
  8035d6:	6a 00                	push   $0x0
  8035d8:	6a 00                	push   $0x0
  8035da:	6a 00                	push   $0x0
  8035dc:	6a 07                	push   $0x7
  8035de:	e8 eb fc ff ff       	call   8032ce <syscall>
  8035e3:	83 c4 18             	add    $0x18,%esp
}
  8035e6:	c9                   	leave  
  8035e7:	c3                   	ret    

008035e8 <sys_exit_env>:


void sys_exit_env(void)
{
  8035e8:	55                   	push   %ebp
  8035e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8035eb:	6a 00                	push   $0x0
  8035ed:	6a 00                	push   $0x0
  8035ef:	6a 00                	push   $0x0
  8035f1:	6a 00                	push   $0x0
  8035f3:	6a 00                	push   $0x0
  8035f5:	6a 1c                	push   $0x1c
  8035f7:	e8 d2 fc ff ff       	call   8032ce <syscall>
  8035fc:	83 c4 18             	add    $0x18,%esp
}
  8035ff:	90                   	nop
  803600:	c9                   	leave  
  803601:	c3                   	ret    

00803602 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803602:	55                   	push   %ebp
  803603:	89 e5                	mov    %esp,%ebp
  803605:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803608:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80360b:	8d 50 04             	lea    0x4(%eax),%edx
  80360e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803611:	6a 00                	push   $0x0
  803613:	6a 00                	push   $0x0
  803615:	6a 00                	push   $0x0
  803617:	52                   	push   %edx
  803618:	50                   	push   %eax
  803619:	6a 1d                	push   $0x1d
  80361b:	e8 ae fc ff ff       	call   8032ce <syscall>
  803620:	83 c4 18             	add    $0x18,%esp
	return result;
  803623:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803626:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803629:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80362c:	89 01                	mov    %eax,(%ecx)
  80362e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803631:	8b 45 08             	mov    0x8(%ebp),%eax
  803634:	c9                   	leave  
  803635:	c2 04 00             	ret    $0x4

00803638 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803638:	55                   	push   %ebp
  803639:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80363b:	6a 00                	push   $0x0
  80363d:	6a 00                	push   $0x0
  80363f:	ff 75 10             	pushl  0x10(%ebp)
  803642:	ff 75 0c             	pushl  0xc(%ebp)
  803645:	ff 75 08             	pushl  0x8(%ebp)
  803648:	6a 13                	push   $0x13
  80364a:	e8 7f fc ff ff       	call   8032ce <syscall>
  80364f:	83 c4 18             	add    $0x18,%esp
	return ;
  803652:	90                   	nop
}
  803653:	c9                   	leave  
  803654:	c3                   	ret    

00803655 <sys_rcr2>:
uint32 sys_rcr2()
{
  803655:	55                   	push   %ebp
  803656:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803658:	6a 00                	push   $0x0
  80365a:	6a 00                	push   $0x0
  80365c:	6a 00                	push   $0x0
  80365e:	6a 00                	push   $0x0
  803660:	6a 00                	push   $0x0
  803662:	6a 1e                	push   $0x1e
  803664:	e8 65 fc ff ff       	call   8032ce <syscall>
  803669:	83 c4 18             	add    $0x18,%esp
}
  80366c:	c9                   	leave  
  80366d:	c3                   	ret    

0080366e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80366e:	55                   	push   %ebp
  80366f:	89 e5                	mov    %esp,%ebp
  803671:	83 ec 04             	sub    $0x4,%esp
  803674:	8b 45 08             	mov    0x8(%ebp),%eax
  803677:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80367a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80367e:	6a 00                	push   $0x0
  803680:	6a 00                	push   $0x0
  803682:	6a 00                	push   $0x0
  803684:	6a 00                	push   $0x0
  803686:	50                   	push   %eax
  803687:	6a 1f                	push   $0x1f
  803689:	e8 40 fc ff ff       	call   8032ce <syscall>
  80368e:	83 c4 18             	add    $0x18,%esp
	return ;
  803691:	90                   	nop
}
  803692:	c9                   	leave  
  803693:	c3                   	ret    

00803694 <rsttst>:
void rsttst()
{
  803694:	55                   	push   %ebp
  803695:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803697:	6a 00                	push   $0x0
  803699:	6a 00                	push   $0x0
  80369b:	6a 00                	push   $0x0
  80369d:	6a 00                	push   $0x0
  80369f:	6a 00                	push   $0x0
  8036a1:	6a 21                	push   $0x21
  8036a3:	e8 26 fc ff ff       	call   8032ce <syscall>
  8036a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8036ab:	90                   	nop
}
  8036ac:	c9                   	leave  
  8036ad:	c3                   	ret    

008036ae <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8036ae:	55                   	push   %ebp
  8036af:	89 e5                	mov    %esp,%ebp
  8036b1:	83 ec 04             	sub    $0x4,%esp
  8036b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8036b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8036ba:	8b 55 18             	mov    0x18(%ebp),%edx
  8036bd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8036c1:	52                   	push   %edx
  8036c2:	50                   	push   %eax
  8036c3:	ff 75 10             	pushl  0x10(%ebp)
  8036c6:	ff 75 0c             	pushl  0xc(%ebp)
  8036c9:	ff 75 08             	pushl  0x8(%ebp)
  8036cc:	6a 20                	push   $0x20
  8036ce:	e8 fb fb ff ff       	call   8032ce <syscall>
  8036d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8036d6:	90                   	nop
}
  8036d7:	c9                   	leave  
  8036d8:	c3                   	ret    

008036d9 <chktst>:
void chktst(uint32 n)
{
  8036d9:	55                   	push   %ebp
  8036da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8036dc:	6a 00                	push   $0x0
  8036de:	6a 00                	push   $0x0
  8036e0:	6a 00                	push   $0x0
  8036e2:	6a 00                	push   $0x0
  8036e4:	ff 75 08             	pushl  0x8(%ebp)
  8036e7:	6a 22                	push   $0x22
  8036e9:	e8 e0 fb ff ff       	call   8032ce <syscall>
  8036ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8036f1:	90                   	nop
}
  8036f2:	c9                   	leave  
  8036f3:	c3                   	ret    

008036f4 <inctst>:

void inctst()
{
  8036f4:	55                   	push   %ebp
  8036f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8036f7:	6a 00                	push   $0x0
  8036f9:	6a 00                	push   $0x0
  8036fb:	6a 00                	push   $0x0
  8036fd:	6a 00                	push   $0x0
  8036ff:	6a 00                	push   $0x0
  803701:	6a 23                	push   $0x23
  803703:	e8 c6 fb ff ff       	call   8032ce <syscall>
  803708:	83 c4 18             	add    $0x18,%esp
	return ;
  80370b:	90                   	nop
}
  80370c:	c9                   	leave  
  80370d:	c3                   	ret    

0080370e <gettst>:
uint32 gettst()
{
  80370e:	55                   	push   %ebp
  80370f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803711:	6a 00                	push   $0x0
  803713:	6a 00                	push   $0x0
  803715:	6a 00                	push   $0x0
  803717:	6a 00                	push   $0x0
  803719:	6a 00                	push   $0x0
  80371b:	6a 24                	push   $0x24
  80371d:	e8 ac fb ff ff       	call   8032ce <syscall>
  803722:	83 c4 18             	add    $0x18,%esp
}
  803725:	c9                   	leave  
  803726:	c3                   	ret    

00803727 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803727:	55                   	push   %ebp
  803728:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80372a:	6a 00                	push   $0x0
  80372c:	6a 00                	push   $0x0
  80372e:	6a 00                	push   $0x0
  803730:	6a 00                	push   $0x0
  803732:	6a 00                	push   $0x0
  803734:	6a 25                	push   $0x25
  803736:	e8 93 fb ff ff       	call   8032ce <syscall>
  80373b:	83 c4 18             	add    $0x18,%esp
  80373e:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  803743:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  803748:	c9                   	leave  
  803749:	c3                   	ret    

0080374a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80374a:	55                   	push   %ebp
  80374b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80374d:	8b 45 08             	mov    0x8(%ebp),%eax
  803750:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803755:	6a 00                	push   $0x0
  803757:	6a 00                	push   $0x0
  803759:	6a 00                	push   $0x0
  80375b:	6a 00                	push   $0x0
  80375d:	ff 75 08             	pushl  0x8(%ebp)
  803760:	6a 26                	push   $0x26
  803762:	e8 67 fb ff ff       	call   8032ce <syscall>
  803767:	83 c4 18             	add    $0x18,%esp
	return ;
  80376a:	90                   	nop
}
  80376b:	c9                   	leave  
  80376c:	c3                   	ret    

0080376d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80376d:	55                   	push   %ebp
  80376e:	89 e5                	mov    %esp,%ebp
  803770:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803771:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803774:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803777:	8b 55 0c             	mov    0xc(%ebp),%edx
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	6a 00                	push   $0x0
  80377f:	53                   	push   %ebx
  803780:	51                   	push   %ecx
  803781:	52                   	push   %edx
  803782:	50                   	push   %eax
  803783:	6a 27                	push   $0x27
  803785:	e8 44 fb ff ff       	call   8032ce <syscall>
  80378a:	83 c4 18             	add    $0x18,%esp
}
  80378d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803790:	c9                   	leave  
  803791:	c3                   	ret    

00803792 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803792:	55                   	push   %ebp
  803793:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803795:	8b 55 0c             	mov    0xc(%ebp),%edx
  803798:	8b 45 08             	mov    0x8(%ebp),%eax
  80379b:	6a 00                	push   $0x0
  80379d:	6a 00                	push   $0x0
  80379f:	6a 00                	push   $0x0
  8037a1:	52                   	push   %edx
  8037a2:	50                   	push   %eax
  8037a3:	6a 28                	push   $0x28
  8037a5:	e8 24 fb ff ff       	call   8032ce <syscall>
  8037aa:	83 c4 18             	add    $0x18,%esp
}
  8037ad:	c9                   	leave  
  8037ae:	c3                   	ret    

008037af <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8037af:	55                   	push   %ebp
  8037b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8037b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8037b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bb:	6a 00                	push   $0x0
  8037bd:	51                   	push   %ecx
  8037be:	ff 75 10             	pushl  0x10(%ebp)
  8037c1:	52                   	push   %edx
  8037c2:	50                   	push   %eax
  8037c3:	6a 29                	push   $0x29
  8037c5:	e8 04 fb ff ff       	call   8032ce <syscall>
  8037ca:	83 c4 18             	add    $0x18,%esp
}
  8037cd:	c9                   	leave  
  8037ce:	c3                   	ret    

008037cf <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8037cf:	55                   	push   %ebp
  8037d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8037d2:	6a 00                	push   $0x0
  8037d4:	6a 00                	push   $0x0
  8037d6:	ff 75 10             	pushl  0x10(%ebp)
  8037d9:	ff 75 0c             	pushl  0xc(%ebp)
  8037dc:	ff 75 08             	pushl  0x8(%ebp)
  8037df:	6a 12                	push   $0x12
  8037e1:	e8 e8 fa ff ff       	call   8032ce <syscall>
  8037e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8037e9:	90                   	nop
}
  8037ea:	c9                   	leave  
  8037eb:	c3                   	ret    

008037ec <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8037ec:	55                   	push   %ebp
  8037ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8037ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f5:	6a 00                	push   $0x0
  8037f7:	6a 00                	push   $0x0
  8037f9:	6a 00                	push   $0x0
  8037fb:	52                   	push   %edx
  8037fc:	50                   	push   %eax
  8037fd:	6a 2a                	push   $0x2a
  8037ff:	e8 ca fa ff ff       	call   8032ce <syscall>
  803804:	83 c4 18             	add    $0x18,%esp
	return;
  803807:	90                   	nop
}
  803808:	c9                   	leave  
  803809:	c3                   	ret    

0080380a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80380a:	55                   	push   %ebp
  80380b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80380d:	6a 00                	push   $0x0
  80380f:	6a 00                	push   $0x0
  803811:	6a 00                	push   $0x0
  803813:	6a 00                	push   $0x0
  803815:	6a 00                	push   $0x0
  803817:	6a 2b                	push   $0x2b
  803819:	e8 b0 fa ff ff       	call   8032ce <syscall>
  80381e:	83 c4 18             	add    $0x18,%esp
}
  803821:	c9                   	leave  
  803822:	c3                   	ret    

00803823 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803823:	55                   	push   %ebp
  803824:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803826:	6a 00                	push   $0x0
  803828:	6a 00                	push   $0x0
  80382a:	6a 00                	push   $0x0
  80382c:	ff 75 0c             	pushl  0xc(%ebp)
  80382f:	ff 75 08             	pushl  0x8(%ebp)
  803832:	6a 2d                	push   $0x2d
  803834:	e8 95 fa ff ff       	call   8032ce <syscall>
  803839:	83 c4 18             	add    $0x18,%esp
	return;
  80383c:	90                   	nop
}
  80383d:	c9                   	leave  
  80383e:	c3                   	ret    

0080383f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80383f:	55                   	push   %ebp
  803840:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803842:	6a 00                	push   $0x0
  803844:	6a 00                	push   $0x0
  803846:	6a 00                	push   $0x0
  803848:	ff 75 0c             	pushl  0xc(%ebp)
  80384b:	ff 75 08             	pushl  0x8(%ebp)
  80384e:	6a 2c                	push   $0x2c
  803850:	e8 79 fa ff ff       	call   8032ce <syscall>
  803855:	83 c4 18             	add    $0x18,%esp
	return ;
  803858:	90                   	nop
}
  803859:	c9                   	leave  
  80385a:	c3                   	ret    

0080385b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80385b:	55                   	push   %ebp
  80385c:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80385e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803861:	8b 45 08             	mov    0x8(%ebp),%eax
  803864:	6a 00                	push   $0x0
  803866:	6a 00                	push   $0x0
  803868:	6a 00                	push   $0x0
  80386a:	52                   	push   %edx
  80386b:	50                   	push   %eax
  80386c:	6a 2e                	push   $0x2e
  80386e:	e8 5b fa ff ff       	call   8032ce <syscall>
  803873:	83 c4 18             	add    $0x18,%esp
	    return;
  803876:	90                   	nop
}
  803877:	c9                   	leave  
  803878:	c3                   	ret    

00803879 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803879:	55                   	push   %ebp
  80387a:	89 e5                	mov    %esp,%ebp
  80387c:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80387f:	8b 45 08             	mov    0x8(%ebp),%eax
  803882:	ba 60 60 80 00       	mov    $0x806060,%edx
  803887:	29 d0                	sub    %edx,%eax
  803889:	c1 f8 02             	sar    $0x2,%eax
  80388c:	89 c2                	mov    %eax,%edx
  80388e:	89 d0                	mov    %edx,%eax
  803890:	c1 e0 02             	shl    $0x2,%eax
  803893:	01 d0                	add    %edx,%eax
  803895:	c1 e0 02             	shl    $0x2,%eax
  803898:	01 d0                	add    %edx,%eax
  80389a:	c1 e0 02             	shl    $0x2,%eax
  80389d:	01 d0                	add    %edx,%eax
  80389f:	89 c1                	mov    %eax,%ecx
  8038a1:	c1 e1 08             	shl    $0x8,%ecx
  8038a4:	01 c8                	add    %ecx,%eax
  8038a6:	89 c1                	mov    %eax,%ecx
  8038a8:	c1 e1 10             	shl    $0x10,%ecx
  8038ab:	01 c8                	add    %ecx,%eax
  8038ad:	01 c0                	add    %eax,%eax
  8038af:	01 d0                	add    %edx,%eax
  8038b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8038b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038b7:	c1 e0 0c             	shl    $0xc,%eax
  8038ba:	89 c2                	mov    %eax,%edx
  8038bc:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8038c1:	01 d0                	add    %edx,%eax
}
  8038c3:	c9                   	leave  
  8038c4:	c3                   	ret    

008038c5 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  8038c5:	55                   	push   %ebp
  8038c6:	89 e5                	mov    %esp,%ebp
  8038c8:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  8038cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8038d2:	eb 06                	jmp    8038da <log2+0x15>
			n >>=1;
  8038d4:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  8038d7:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  8038da:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8038de:	77 f4                	ja     8038d4 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  8038e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8038e3:	c9                   	leave  
  8038e4:	c3                   	ret    

008038e5 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8038e5:	55                   	push   %ebp
  8038e6:	89 e5                	mov    %esp,%ebp
  8038e8:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	05 00 00 00 02       	add    $0x2000000,%eax
  8038f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8038f6:	73 16                	jae    80390e <initialize_dynamic_allocator+0x29>
  8038f8:	68 38 52 80 00       	push   $0x805238
  8038fd:	68 5e 52 80 00       	push   $0x80525e
  803902:	6a 2d                	push   $0x2d
  803904:	68 73 52 80 00       	push   $0x805273
  803909:	e8 da 0a 00 00       	call   8043e8 <_panic>
		is_initialized = 1;
  80390e:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  803915:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803918:	8b 45 08             	mov    0x8(%ebp),%eax
  80391b:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  803920:	8b 45 0c             	mov    0xc(%ebp),%eax
  803923:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803928:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80392e:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803933:	29 c2                	sub    %eax,%edx
  803935:	89 d0                	mov    %edx,%eax
  803937:	c1 e8 0c             	shr    $0xc,%eax
  80393a:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  80393d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803944:	eb 2f                	jmp    803975 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803946:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803949:	89 d0                	mov    %edx,%eax
  80394b:	01 c0                	add    %eax,%eax
  80394d:	01 d0                	add    %edx,%eax
  80394f:	c1 e0 02             	shl    $0x2,%eax
  803952:	05 68 60 80 00       	add    $0x806068,%eax
  803957:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  80395c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80395f:	89 d0                	mov    %edx,%eax
  803961:	01 c0                	add    %eax,%eax
  803963:	01 d0                	add    %edx,%eax
  803965:	c1 e0 02             	shl    $0x2,%eax
  803968:	05 6a 60 80 00       	add    $0x80606a,%eax
  80396d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803972:	ff 45 f4             	incl   -0xc(%ebp)
  803975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803978:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80397b:	7c c9                	jl     803946 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  80397d:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  803984:	00 00 00 
  803987:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  80398e:	00 00 00 
  803991:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803998:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  80399b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8039a2:	e9 9c 00 00 00       	jmp    803a43 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8039a7:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8039ad:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8039b0:	89 c8                	mov    %ecx,%eax
  8039b2:	01 c0                	add    %eax,%eax
  8039b4:	01 c8                	add    %ecx,%eax
  8039b6:	c1 e0 02             	shl    $0x2,%eax
  8039b9:	05 64 60 80 00       	add    $0x806064,%eax
  8039be:	89 10                	mov    %edx,(%eax)
  8039c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039c3:	89 d0                	mov    %edx,%eax
  8039c5:	01 c0                	add    %eax,%eax
  8039c7:	01 d0                	add    %edx,%eax
  8039c9:	c1 e0 02             	shl    $0x2,%eax
  8039cc:	05 64 60 80 00       	add    $0x806064,%eax
  8039d1:	8b 00                	mov    (%eax),%eax
  8039d3:	85 c0                	test   %eax,%eax
  8039d5:	74 1b                	je     8039f2 <initialize_dynamic_allocator+0x10d>
  8039d7:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8039dd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8039e0:	89 c8                	mov    %ecx,%eax
  8039e2:	01 c0                	add    %eax,%eax
  8039e4:	01 c8                	add    %ecx,%eax
  8039e6:	c1 e0 02             	shl    $0x2,%eax
  8039e9:	05 60 60 80 00       	add    $0x806060,%eax
  8039ee:	89 02                	mov    %eax,(%edx)
  8039f0:	eb 16                	jmp    803a08 <initialize_dynamic_allocator+0x123>
  8039f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039f5:	89 d0                	mov    %edx,%eax
  8039f7:	01 c0                	add    %eax,%eax
  8039f9:	01 d0                	add    %edx,%eax
  8039fb:	c1 e0 02             	shl    $0x2,%eax
  8039fe:	05 60 60 80 00       	add    $0x806060,%eax
  803a03:	a3 48 60 80 00       	mov    %eax,0x806048
  803a08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a0b:	89 d0                	mov    %edx,%eax
  803a0d:	01 c0                	add    %eax,%eax
  803a0f:	01 d0                	add    %edx,%eax
  803a11:	c1 e0 02             	shl    $0x2,%eax
  803a14:	05 60 60 80 00       	add    $0x806060,%eax
  803a19:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803a1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a21:	89 d0                	mov    %edx,%eax
  803a23:	01 c0                	add    %eax,%eax
  803a25:	01 d0                	add    %edx,%eax
  803a27:	c1 e0 02             	shl    $0x2,%eax
  803a2a:	05 60 60 80 00       	add    $0x806060,%eax
  803a2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a35:	a1 54 60 80 00       	mov    0x806054,%eax
  803a3a:	40                   	inc    %eax
  803a3b:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803a40:	ff 45 f0             	incl   -0x10(%ebp)
  803a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a46:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a49:	0f 8c 58 ff ff ff    	jl     8039a7 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803a4f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803a56:	eb 36                	jmp    803a8e <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a5b:	c1 e0 04             	shl    $0x4,%eax
  803a5e:	05 80 e0 81 00       	add    $0x81e080,%eax
  803a63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a6c:	c1 e0 04             	shl    $0x4,%eax
  803a6f:	05 84 e0 81 00       	add    $0x81e084,%eax
  803a74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a7d:	c1 e0 04             	shl    $0x4,%eax
  803a80:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803a85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803a8b:	ff 45 ec             	incl   -0x14(%ebp)
  803a8e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803a92:	7e c4                	jle    803a58 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803a94:	90                   	nop
  803a95:	c9                   	leave  
  803a96:	c3                   	ret    

00803a97 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803a97:	55                   	push   %ebp
  803a98:	89 e5                	mov    %esp,%ebp
  803a9a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803a9d:	8b 55 08             	mov    0x8(%ebp),%edx
  803aa0:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803aa5:	29 c2                	sub    %eax,%edx
  803aa7:	89 d0                	mov    %edx,%eax
  803aa9:	c1 e8 0c             	shr    $0xc,%eax
  803aac:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803aaf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803ab2:	89 d0                	mov    %edx,%eax
  803ab4:	01 c0                	add    %eax,%eax
  803ab6:	01 d0                	add    %edx,%eax
  803ab8:	c1 e0 02             	shl    $0x2,%eax
  803abb:	05 68 60 80 00       	add    $0x806068,%eax
  803ac0:	8b 00                	mov    (%eax),%eax
  803ac2:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803ac5:	c9                   	leave  
  803ac6:	c3                   	ret    

00803ac7 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803ac7:	55                   	push   %ebp
  803ac8:	89 e5                	mov    %esp,%ebp
  803aca:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803acd:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803ad4:	76 16                	jbe    803aec <alloc_block+0x25>
  803ad6:	68 8c 52 80 00       	push   $0x80528c
  803adb:	68 5e 52 80 00       	push   $0x80525e
  803ae0:	6a 6c                	push   $0x6c
  803ae2:	68 73 52 80 00       	push   $0x805273
  803ae7:	e8 fc 08 00 00       	call   8043e8 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  803aec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803af0:	75 0a                	jne    803afc <alloc_block+0x35>
		return NULL;
  803af2:	b8 00 00 00 00       	mov    $0x0,%eax
  803af7:	e9 65 04 00 00       	jmp    803f61 <alloc_block+0x49a>
	}
	else if(size<=8){
  803afc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803b00:	77 09                	ja     803b0b <alloc_block+0x44>
		size=8;
  803b02:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803b09:	eb 1f                	jmp    803b2a <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803b0b:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803b12:	eb 08                	jmp    803b1c <alloc_block+0x55>
			reqsize*=2;
  803b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b17:	01 c0                	add    %eax,%eax
  803b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b22:	72 f0                	jb     803b14 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b27:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803b2a:	83 ec 0c             	sub    $0xc,%esp
  803b2d:	ff 75 08             	pushl  0x8(%ebp)
  803b30:	e8 90 fd ff ff       	call   8038c5 <log2>
  803b35:	83 c4 10             	add    $0x10,%esp
  803b38:	83 e8 03             	sub    $0x3,%eax
  803b3b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b41:	c1 e0 04             	shl    $0x4,%eax
  803b44:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b49:	8b 00                	mov    (%eax),%eax
  803b4b:	85 c0                	test   %eax,%eax
  803b4d:	0f 84 fb 00 00 00    	je     803c4e <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803b53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b56:	c1 e0 04             	shl    $0x4,%eax
  803b59:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b5e:	8b 00                	mov    (%eax),%eax
  803b60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803b63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b67:	75 17                	jne    803b80 <alloc_block+0xb9>
  803b69:	83 ec 04             	sub    $0x4,%esp
  803b6c:	68 ad 52 80 00       	push   $0x8052ad
  803b71:	68 86 00 00 00       	push   $0x86
  803b76:	68 73 52 80 00       	push   $0x805273
  803b7b:	e8 68 08 00 00       	call   8043e8 <_panic>
  803b80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b83:	8b 00                	mov    (%eax),%eax
  803b85:	85 c0                	test   %eax,%eax
  803b87:	74 10                	je     803b99 <alloc_block+0xd2>
  803b89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b8c:	8b 00                	mov    (%eax),%eax
  803b8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b91:	8b 52 04             	mov    0x4(%edx),%edx
  803b94:	89 50 04             	mov    %edx,0x4(%eax)
  803b97:	eb 14                	jmp    803bad <alloc_block+0xe6>
  803b99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b9c:	8b 40 04             	mov    0x4(%eax),%eax
  803b9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ba2:	c1 e2 04             	shl    $0x4,%edx
  803ba5:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803bab:	89 02                	mov    %eax,(%edx)
  803bad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb0:	8b 40 04             	mov    0x4(%eax),%eax
  803bb3:	85 c0                	test   %eax,%eax
  803bb5:	74 0f                	je     803bc6 <alloc_block+0xff>
  803bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bba:	8b 40 04             	mov    0x4(%eax),%eax
  803bbd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bc0:	8b 12                	mov    (%edx),%edx
  803bc2:	89 10                	mov    %edx,(%eax)
  803bc4:	eb 13                	jmp    803bd9 <alloc_block+0x112>
  803bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc9:	8b 00                	mov    (%eax),%eax
  803bcb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bce:	c1 e2 04             	shl    $0x4,%edx
  803bd1:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803bd7:	89 02                	mov    %eax,(%edx)
  803bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bef:	c1 e0 04             	shl    $0x4,%eax
  803bf2:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803bf7:	8b 00                	mov    (%eax),%eax
  803bf9:	8d 50 ff             	lea    -0x1(%eax),%edx
  803bfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bff:	c1 e0 04             	shl    $0x4,%eax
  803c02:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803c07:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803c09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c0c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c11:	29 c2                	sub    %eax,%edx
  803c13:	89 d0                	mov    %edx,%eax
  803c15:	c1 e8 0c             	shr    $0xc,%eax
  803c18:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803c1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c1e:	89 d0                	mov    %edx,%eax
  803c20:	01 c0                	add    %eax,%eax
  803c22:	01 d0                	add    %edx,%eax
  803c24:	c1 e0 02             	shl    $0x2,%eax
  803c27:	05 6a 60 80 00       	add    $0x80606a,%eax
  803c2c:	66 8b 00             	mov    (%eax),%ax
  803c2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c32:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803c35:	89 c8                	mov    %ecx,%eax
  803c37:	01 c0                	add    %eax,%eax
  803c39:	01 c8                	add    %ecx,%eax
  803c3b:	c1 e0 02             	shl    $0x2,%eax
  803c3e:	05 6a 60 80 00       	add    $0x80606a,%eax
  803c43:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c49:	e9 13 03 00 00       	jmp    803f61 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803c4e:	a1 48 60 80 00       	mov    0x806048,%eax
  803c53:	85 c0                	test   %eax,%eax
  803c55:	0f 84 c9 01 00 00    	je     803e24 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803c5b:	a1 48 60 80 00       	mov    0x806048,%eax
  803c60:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803c63:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803c67:	75 17                	jne    803c80 <alloc_block+0x1b9>
  803c69:	83 ec 04             	sub    $0x4,%esp
  803c6c:	68 ad 52 80 00       	push   $0x8052ad
  803c71:	68 8f 00 00 00       	push   $0x8f
  803c76:	68 73 52 80 00       	push   $0x805273
  803c7b:	e8 68 07 00 00       	call   8043e8 <_panic>
  803c80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c83:	8b 00                	mov    (%eax),%eax
  803c85:	85 c0                	test   %eax,%eax
  803c87:	74 10                	je     803c99 <alloc_block+0x1d2>
  803c89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c8c:	8b 00                	mov    (%eax),%eax
  803c8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c91:	8b 52 04             	mov    0x4(%edx),%edx
  803c94:	89 50 04             	mov    %edx,0x4(%eax)
  803c97:	eb 0b                	jmp    803ca4 <alloc_block+0x1dd>
  803c99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c9c:	8b 40 04             	mov    0x4(%eax),%eax
  803c9f:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803ca4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ca7:	8b 40 04             	mov    0x4(%eax),%eax
  803caa:	85 c0                	test   %eax,%eax
  803cac:	74 0f                	je     803cbd <alloc_block+0x1f6>
  803cae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cb1:	8b 40 04             	mov    0x4(%eax),%eax
  803cb4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803cb7:	8b 12                	mov    (%edx),%edx
  803cb9:	89 10                	mov    %edx,(%eax)
  803cbb:	eb 0a                	jmp    803cc7 <alloc_block+0x200>
  803cbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cc0:	8b 00                	mov    (%eax),%eax
  803cc2:	a3 48 60 80 00       	mov    %eax,0x806048
  803cc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cda:	a1 54 60 80 00       	mov    0x806054,%eax
  803cdf:	48                   	dec    %eax
  803ce0:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803ce5:	83 ec 0c             	sub    $0xc,%esp
  803ce8:	ff 75 dc             	pushl  -0x24(%ebp)
  803ceb:	e8 89 fb ff ff       	call   803879 <to_page_va>
  803cf0:	83 c4 10             	add    $0x10,%esp
  803cf3:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803cf6:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803cfb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803cfe:	29 c2                	sub    %eax,%edx
  803d00:	89 d0                	mov    %edx,%eax
  803d02:	c1 e8 0c             	shr    $0xc,%eax
  803d05:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803d08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d0b:	83 ec 0c             	sub    $0xc,%esp
  803d0e:	50                   	push   %eax
  803d0f:	e8 fe dc ff ff       	call   801a12 <get_page>
  803d14:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803d17:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1a:	89 c2                	mov    %eax,%edx
  803d1c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803d1f:	89 c8                	mov    %ecx,%eax
  803d21:	01 c0                	add    %eax,%eax
  803d23:	01 c8                	add    %ecx,%eax
  803d25:	c1 e0 02             	shl    $0x2,%eax
  803d28:	05 68 60 80 00       	add    $0x806068,%eax
  803d2d:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803d30:	b8 00 10 00 00       	mov    $0x1000,%eax
  803d35:	ba 00 00 00 00       	mov    $0x0,%edx
  803d3a:	f7 75 08             	divl   0x8(%ebp)
  803d3d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803d40:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d43:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d46:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803d49:	89 c8                	mov    %ecx,%eax
  803d4b:	01 c0                	add    %eax,%eax
  803d4d:	01 c8                	add    %ecx,%eax
  803d4f:	c1 e0 02             	shl    $0x2,%eax
  803d52:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d57:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803d5a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803d61:	e9 aa 00 00 00       	jmp    803e10 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d69:	0f af 45 08          	imul   0x8(%ebp),%eax
  803d6d:	89 c2                	mov    %eax,%edx
  803d6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d72:	01 d0                	add    %edx,%eax
  803d74:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803d77:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803d7b:	75 17                	jne    803d94 <alloc_block+0x2cd>
  803d7d:	83 ec 04             	sub    $0x4,%esp
  803d80:	68 cc 52 80 00       	push   $0x8052cc
  803d85:	68 9d 00 00 00       	push   $0x9d
  803d8a:	68 73 52 80 00       	push   $0x805273
  803d8f:	e8 54 06 00 00       	call   8043e8 <_panic>
  803d94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d97:	c1 e0 04             	shl    $0x4,%eax
  803d9a:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d9f:	8b 10                	mov    (%eax),%edx
  803da1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803da4:	89 50 04             	mov    %edx,0x4(%eax)
  803da7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803daa:	8b 40 04             	mov    0x4(%eax),%eax
  803dad:	85 c0                	test   %eax,%eax
  803daf:	74 14                	je     803dc5 <alloc_block+0x2fe>
  803db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803db4:	c1 e0 04             	shl    $0x4,%eax
  803db7:	05 84 e0 81 00       	add    $0x81e084,%eax
  803dbc:	8b 00                	mov    (%eax),%eax
  803dbe:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803dc1:	89 10                	mov    %edx,(%eax)
  803dc3:	eb 11                	jmp    803dd6 <alloc_block+0x30f>
  803dc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dc8:	c1 e0 04             	shl    $0x4,%eax
  803dcb:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803dd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803dd4:	89 02                	mov    %eax,(%edx)
  803dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dd9:	c1 e0 04             	shl    $0x4,%eax
  803ddc:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803de2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803de5:	89 02                	mov    %eax,(%edx)
  803de7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803dea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803df0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803df3:	c1 e0 04             	shl    $0x4,%eax
  803df6:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803dfb:	8b 00                	mov    (%eax),%eax
  803dfd:	8d 50 01             	lea    0x1(%eax),%edx
  803e00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e03:	c1 e0 04             	shl    $0x4,%eax
  803e06:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803e0b:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803e0d:	ff 45 f0             	incl   -0x10(%ebp)
  803e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e13:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803e16:	0f 8c 4a ff ff ff    	jl     803d66 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803e1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e1f:	e9 3d 01 00 00       	jmp    803f61 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803e24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e27:	40                   	inc    %eax
  803e28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803e2b:	e9 10 01 00 00       	jmp    803f40 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e33:	c1 e0 04             	shl    $0x4,%eax
  803e36:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e3b:	8b 00                	mov    (%eax),%eax
  803e3d:	85 c0                	test   %eax,%eax
  803e3f:	0f 84 f8 00 00 00    	je     803f3d <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803e45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e48:	c1 e0 04             	shl    $0x4,%eax
  803e4b:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e50:	8b 00                	mov    (%eax),%eax
  803e52:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803e55:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803e59:	75 17                	jne    803e72 <alloc_block+0x3ab>
  803e5b:	83 ec 04             	sub    $0x4,%esp
  803e5e:	68 ad 52 80 00       	push   $0x8052ad
  803e63:	68 a8 00 00 00       	push   $0xa8
  803e68:	68 73 52 80 00       	push   $0x805273
  803e6d:	e8 76 05 00 00       	call   8043e8 <_panic>
  803e72:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803e75:	8b 00                	mov    (%eax),%eax
  803e77:	85 c0                	test   %eax,%eax
  803e79:	74 10                	je     803e8b <alloc_block+0x3c4>
  803e7b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803e7e:	8b 00                	mov    (%eax),%eax
  803e80:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803e83:	8b 52 04             	mov    0x4(%edx),%edx
  803e86:	89 50 04             	mov    %edx,0x4(%eax)
  803e89:	eb 14                	jmp    803e9f <alloc_block+0x3d8>
  803e8b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803e8e:	8b 40 04             	mov    0x4(%eax),%eax
  803e91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e94:	c1 e2 04             	shl    $0x4,%edx
  803e97:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803e9d:	89 02                	mov    %eax,(%edx)
  803e9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ea2:	8b 40 04             	mov    0x4(%eax),%eax
  803ea5:	85 c0                	test   %eax,%eax
  803ea7:	74 0f                	je     803eb8 <alloc_block+0x3f1>
  803ea9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803eac:	8b 40 04             	mov    0x4(%eax),%eax
  803eaf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803eb2:	8b 12                	mov    (%edx),%edx
  803eb4:	89 10                	mov    %edx,(%eax)
  803eb6:	eb 13                	jmp    803ecb <alloc_block+0x404>
  803eb8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ebb:	8b 00                	mov    (%eax),%eax
  803ebd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ec0:	c1 e2 04             	shl    $0x4,%edx
  803ec3:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803ec9:	89 02                	mov    %eax,(%edx)
  803ecb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ece:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ed4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ed7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ede:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ee1:	c1 e0 04             	shl    $0x4,%eax
  803ee4:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ee9:	8b 00                	mov    (%eax),%eax
  803eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  803eee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ef1:	c1 e0 04             	shl    $0x4,%eax
  803ef4:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ef9:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803efb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803efe:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803f03:	29 c2                	sub    %eax,%edx
  803f05:	89 d0                	mov    %edx,%eax
  803f07:	c1 e8 0c             	shr    $0xc,%eax
  803f0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803f0d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803f10:	89 d0                	mov    %edx,%eax
  803f12:	01 c0                	add    %eax,%eax
  803f14:	01 d0                	add    %edx,%eax
  803f16:	c1 e0 02             	shl    $0x2,%eax
  803f19:	05 6a 60 80 00       	add    $0x80606a,%eax
  803f1e:	66 8b 00             	mov    (%eax),%ax
  803f21:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f24:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803f27:	89 c8                	mov    %ecx,%eax
  803f29:	01 c0                	add    %eax,%eax
  803f2b:	01 c8                	add    %ecx,%eax
  803f2d:	c1 e0 02             	shl    $0x2,%eax
  803f30:	05 6a 60 80 00       	add    $0x80606a,%eax
  803f35:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803f38:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f3b:	eb 24                	jmp    803f61 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803f3d:	ff 45 ec             	incl   -0x14(%ebp)
  803f40:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803f44:	0f 8e e6 fe ff ff    	jle    803e30 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803f4a:	83 ec 04             	sub    $0x4,%esp
  803f4d:	68 ef 52 80 00       	push   $0x8052ef
  803f52:	68 b1 00 00 00       	push   $0xb1
  803f57:	68 73 52 80 00       	push   $0x805273
  803f5c:	e8 87 04 00 00       	call   8043e8 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803f61:	c9                   	leave  
  803f62:	c3                   	ret    

00803f63 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803f63:	55                   	push   %ebp
  803f64:	89 e5                	mov    %esp,%ebp
  803f66:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803f69:	8b 55 08             	mov    0x8(%ebp),%edx
  803f6c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803f71:	39 c2                	cmp    %eax,%edx
  803f73:	72 0c                	jb     803f81 <free_block+0x1e>
  803f75:	8b 55 08             	mov    0x8(%ebp),%edx
  803f78:	a1 40 60 80 00       	mov    0x806040,%eax
  803f7d:	39 c2                	cmp    %eax,%edx
  803f7f:	72 19                	jb     803f9a <free_block+0x37>
  803f81:	68 0c 53 80 00       	push   $0x80530c
  803f86:	68 5e 52 80 00       	push   $0x80525e
  803f8b:	68 c3 00 00 00       	push   $0xc3
  803f90:	68 73 52 80 00       	push   $0x805273
  803f95:	e8 4e 04 00 00       	call   8043e8 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803f9a:	8b 55 08             	mov    0x8(%ebp),%edx
  803f9d:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803fa2:	29 c2                	sub    %eax,%edx
  803fa4:	89 d0                	mov    %edx,%eax
  803fa6:	c1 e8 0c             	shr    $0xc,%eax
  803fa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803fac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803faf:	89 d0                	mov    %edx,%eax
  803fb1:	01 c0                	add    %eax,%eax
  803fb3:	01 d0                	add    %edx,%eax
  803fb5:	c1 e0 02             	shl    $0x2,%eax
  803fb8:	05 68 60 80 00       	add    $0x806068,%eax
  803fbd:	8b 00                	mov    (%eax),%eax
  803fbf:	0f b7 c0             	movzwl %ax,%eax
  803fc2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803fc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803fc9:	75 17                	jne    803fe2 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803fcb:	83 ec 04             	sub    $0x4,%esp
  803fce:	68 44 53 80 00       	push   $0x805344
  803fd3:	68 cf 00 00 00       	push   $0xcf
  803fd8:	68 73 52 80 00       	push   $0x805273
  803fdd:	e8 06 04 00 00       	call   8043e8 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803fe2:	83 ec 0c             	sub    $0xc,%esp
  803fe5:	ff 75 ec             	pushl  -0x14(%ebp)
  803fe8:	e8 d8 f8 ff ff       	call   8038c5 <log2>
  803fed:	83 c4 10             	add    $0x10,%esp
  803ff0:	83 e8 03             	sub    $0x3,%eax
  803ff3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803ffc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804000:	75 17                	jne    804019 <free_block+0xb6>
  804002:	83 ec 04             	sub    $0x4,%esp
  804005:	68 cc 52 80 00       	push   $0x8052cc
  80400a:	68 d5 00 00 00       	push   $0xd5
  80400f:	68 73 52 80 00       	push   $0x805273
  804014:	e8 cf 03 00 00       	call   8043e8 <_panic>
  804019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80401c:	c1 e0 04             	shl    $0x4,%eax
  80401f:	05 84 e0 81 00       	add    $0x81e084,%eax
  804024:	8b 10                	mov    (%eax),%edx
  804026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804029:	89 50 04             	mov    %edx,0x4(%eax)
  80402c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80402f:	8b 40 04             	mov    0x4(%eax),%eax
  804032:	85 c0                	test   %eax,%eax
  804034:	74 14                	je     80404a <free_block+0xe7>
  804036:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804039:	c1 e0 04             	shl    $0x4,%eax
  80403c:	05 84 e0 81 00       	add    $0x81e084,%eax
  804041:	8b 00                	mov    (%eax),%eax
  804043:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804046:	89 10                	mov    %edx,(%eax)
  804048:	eb 11                	jmp    80405b <free_block+0xf8>
  80404a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80404d:	c1 e0 04             	shl    $0x4,%eax
  804050:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  804056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804059:	89 02                	mov    %eax,(%edx)
  80405b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80405e:	c1 e0 04             	shl    $0x4,%eax
  804061:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  804067:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80406a:	89 02                	mov    %eax,(%edx)
  80406c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80406f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804075:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804078:	c1 e0 04             	shl    $0x4,%eax
  80407b:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804080:	8b 00                	mov    (%eax),%eax
  804082:	8d 50 01             	lea    0x1(%eax),%edx
  804085:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804088:	c1 e0 04             	shl    $0x4,%eax
  80408b:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804090:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  804092:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804095:	89 d0                	mov    %edx,%eax
  804097:	01 c0                	add    %eax,%eax
  804099:	01 d0                	add    %edx,%eax
  80409b:	c1 e0 02             	shl    $0x2,%eax
  80409e:	05 6a 60 80 00       	add    $0x80606a,%eax
  8040a3:	66 8b 00             	mov    (%eax),%ax
  8040a6:	8d 50 01             	lea    0x1(%eax),%edx
  8040a9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8040ac:	89 c8                	mov    %ecx,%eax
  8040ae:	01 c0                	add    %eax,%eax
  8040b0:	01 c8                	add    %ecx,%eax
  8040b2:	c1 e0 02             	shl    $0x2,%eax
  8040b5:	05 6a 60 80 00       	add    $0x80606a,%eax
  8040ba:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  8040bd:	b8 00 10 00 00       	mov    $0x1000,%eax
  8040c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8040c7:	f7 75 ec             	divl   -0x14(%ebp)
  8040ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  8040cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040d0:	89 d0                	mov    %edx,%eax
  8040d2:	01 c0                	add    %eax,%eax
  8040d4:	01 d0                	add    %edx,%eax
  8040d6:	c1 e0 02             	shl    $0x2,%eax
  8040d9:	05 6a 60 80 00       	add    $0x80606a,%eax
  8040de:	66 8b 00             	mov    (%eax),%ax
  8040e1:	0f b7 c0             	movzwl %ax,%eax
  8040e4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8040e7:	0f 85 d3 01 00 00    	jne    8042c0 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  8040ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040f0:	c1 e0 04             	shl    $0x4,%eax
  8040f3:	05 80 e0 81 00       	add    $0x81e080,%eax
  8040f8:	8b 00                	mov    (%eax),%eax
  8040fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  8040fd:	e9 f1 00 00 00       	jmp    8041f3 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804105:	8b 00                	mov    (%eax),%eax
  804107:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  80410a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80410d:	c1 e0 0c             	shl    $0xc,%eax
  804110:	89 c2                	mov    %eax,%edx
  804112:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804117:	01 d0                	add    %edx,%eax
  804119:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  80411c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80411f:	40                   	inc    %eax
  804120:	c1 e0 0c             	shl    $0xc,%eax
  804123:	89 c2                	mov    %eax,%edx
  804125:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80412a:	01 d0                	add    %edx,%eax
  80412c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  80412f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804132:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  804135:	0f 82 b8 00 00 00    	jb     8041f3 <free_block+0x290>
  80413b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80413e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804141:	0f 83 ac 00 00 00    	jae    8041f3 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  804147:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80414b:	75 17                	jne    804164 <free_block+0x201>
  80414d:	83 ec 04             	sub    $0x4,%esp
  804150:	68 ad 52 80 00       	push   $0x8052ad
  804155:	68 e2 00 00 00       	push   $0xe2
  80415a:	68 73 52 80 00       	push   $0x805273
  80415f:	e8 84 02 00 00       	call   8043e8 <_panic>
  804164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804167:	8b 00                	mov    (%eax),%eax
  804169:	85 c0                	test   %eax,%eax
  80416b:	74 10                	je     80417d <free_block+0x21a>
  80416d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804170:	8b 00                	mov    (%eax),%eax
  804172:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804175:	8b 52 04             	mov    0x4(%edx),%edx
  804178:	89 50 04             	mov    %edx,0x4(%eax)
  80417b:	eb 14                	jmp    804191 <free_block+0x22e>
  80417d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804180:	8b 40 04             	mov    0x4(%eax),%eax
  804183:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804186:	c1 e2 04             	shl    $0x4,%edx
  804189:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  80418f:	89 02                	mov    %eax,(%edx)
  804191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804194:	8b 40 04             	mov    0x4(%eax),%eax
  804197:	85 c0                	test   %eax,%eax
  804199:	74 0f                	je     8041aa <free_block+0x247>
  80419b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80419e:	8b 40 04             	mov    0x4(%eax),%eax
  8041a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8041a4:	8b 12                	mov    (%edx),%edx
  8041a6:	89 10                	mov    %edx,(%eax)
  8041a8:	eb 13                	jmp    8041bd <free_block+0x25a>
  8041aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ad:	8b 00                	mov    (%eax),%eax
  8041af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041b2:	c1 e2 04             	shl    $0x4,%edx
  8041b5:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8041bb:	89 02                	mov    %eax,(%edx)
  8041bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041d3:	c1 e0 04             	shl    $0x4,%eax
  8041d6:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8041db:	8b 00                	mov    (%eax),%eax
  8041dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8041e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041e3:	c1 e0 04             	shl    $0x4,%eax
  8041e6:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8041eb:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  8041ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8041f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  8041f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041f7:	0f 85 05 ff ff ff    	jne    804102 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  8041fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804200:	89 d0                	mov    %edx,%eax
  804202:	01 c0                	add    %eax,%eax
  804204:	01 d0                	add    %edx,%eax
  804206:	c1 e0 02             	shl    $0x2,%eax
  804209:	05 68 60 80 00       	add    $0x806068,%eax
  80420e:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  804213:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804216:	89 d0                	mov    %edx,%eax
  804218:	01 c0                	add    %eax,%eax
  80421a:	01 d0                	add    %edx,%eax
  80421c:	c1 e0 02             	shl    $0x2,%eax
  80421f:	05 6a 60 80 00       	add    $0x80606a,%eax
  804224:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  804229:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80422c:	89 d0                	mov    %edx,%eax
  80422e:	01 c0                	add    %eax,%eax
  804230:	01 d0                	add    %edx,%eax
  804232:	c1 e0 02             	shl    $0x2,%eax
  804235:	05 60 60 80 00       	add    $0x806060,%eax
  80423a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  80423d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804241:	75 17                	jne    80425a <free_block+0x2f7>
  804243:	83 ec 04             	sub    $0x4,%esp
  804246:	68 cc 52 80 00       	push   $0x8052cc
  80424b:	68 eb 00 00 00       	push   $0xeb
  804250:	68 73 52 80 00       	push   $0x805273
  804255:	e8 8e 01 00 00       	call   8043e8 <_panic>
  80425a:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  804260:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804263:	89 50 04             	mov    %edx,0x4(%eax)
  804266:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804269:	8b 40 04             	mov    0x4(%eax),%eax
  80426c:	85 c0                	test   %eax,%eax
  80426e:	74 0c                	je     80427c <free_block+0x319>
  804270:	a1 4c 60 80 00       	mov    0x80604c,%eax
  804275:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804278:	89 10                	mov    %edx,(%eax)
  80427a:	eb 08                	jmp    804284 <free_block+0x321>
  80427c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80427f:	a3 48 60 80 00       	mov    %eax,0x806048
  804284:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804287:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80428c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80428f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804295:	a1 54 60 80 00       	mov    0x806054,%eax
  80429a:	40                   	inc    %eax
  80429b:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  8042a0:	83 ec 0c             	sub    $0xc,%esp
  8042a3:	ff 75 d0             	pushl  -0x30(%ebp)
  8042a6:	e8 ce f5 ff ff       	call   803879 <to_page_va>
  8042ab:	83 c4 10             	add    $0x10,%esp
  8042ae:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  8042b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8042b4:	83 ec 0c             	sub    $0xc,%esp
  8042b7:	50                   	push   %eax
  8042b8:	e8 9e d7 ff ff       	call   801a5b <return_page>
  8042bd:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8042c0:	90                   	nop
  8042c1:	c9                   	leave  
  8042c2:	c3                   	ret    

008042c3 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8042c3:	55                   	push   %ebp
  8042c4:	89 e5                	mov    %esp,%ebp
  8042c6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8042c9:	83 ec 04             	sub    $0x4,%esp
  8042cc:	68 6c 53 80 00       	push   $0x80536c
  8042d1:	68 01 01 00 00       	push   $0x101
  8042d6:	68 73 52 80 00       	push   $0x805273
  8042db:	e8 08 01 00 00       	call   8043e8 <_panic>

008042e0 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  8042e0:	55                   	push   %ebp
  8042e1:	89 e5                	mov    %esp,%ebp
  8042e3:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  8042e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8042ea:	74 1c                	je     804308 <init_uspinlock+0x28>
  8042ec:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8042f0:	74 16                	je     804308 <init_uspinlock+0x28>
  8042f2:	68 90 53 80 00       	push   $0x805390
  8042f7:	68 af 53 80 00       	push   $0x8053af
  8042fc:	6a 10                	push   $0x10
  8042fe:	68 c4 53 80 00       	push   $0x8053c4
  804303:	e8 e0 00 00 00       	call   8043e8 <_panic>
	strcpy(lk->name, name);
  804308:	8b 45 08             	mov    0x8(%ebp),%eax
  80430b:	83 c0 04             	add    $0x4,%eax
  80430e:	83 ec 08             	sub    $0x8,%esp
  804311:	ff 75 0c             	pushl  0xc(%ebp)
  804314:	50                   	push   %eax
  804315:	e8 90 ce ff ff       	call   8011aa <strcpy>
  80431a:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  80431d:	b8 01 00 00 00       	mov    $0x1,%eax
  804322:	2b 45 10             	sub    0x10(%ebp),%eax
  804325:	89 c2                	mov    %eax,%edx
  804327:	8b 45 08             	mov    0x8(%ebp),%eax
  80432a:	89 10                	mov    %edx,(%eax)
}
  80432c:	90                   	nop
  80432d:	c9                   	leave  
  80432e:	c3                   	ret    

0080432f <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  80432f:	55                   	push   %ebp
  804330:	89 e5                	mov    %esp,%ebp
  804332:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  804335:	90                   	nop
  804336:	8b 45 08             	mov    0x8(%ebp),%eax
  804339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80433c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  804343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804349:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80434c:	f0 87 02             	lock xchg %eax,(%edx)
  80434f:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  804352:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804355:	85 c0                	test   %eax,%eax
  804357:	75 dd                	jne    804336 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804359:	8b 45 08             	mov    0x8(%ebp),%eax
  80435c:	8d 48 04             	lea    0x4(%eax),%ecx
  80435f:	a1 20 60 80 00       	mov    0x806020,%eax
  804364:	8d 50 20             	lea    0x20(%eax),%edx
  804367:	a1 20 60 80 00       	mov    0x806020,%eax
  80436c:	8b 40 10             	mov    0x10(%eax),%eax
  80436f:	51                   	push   %ecx
  804370:	52                   	push   %edx
  804371:	50                   	push   %eax
  804372:	68 d4 53 80 00       	push   $0x8053d4
  804377:	e8 06 c7 ff ff       	call   800a82 <cprintf>
  80437c:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  80437f:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  804384:	90                   	nop
  804385:	c9                   	leave  
  804386:	c3                   	ret    

00804387 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  804387:	55                   	push   %ebp
  804388:	89 e5                	mov    %esp,%ebp
  80438a:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  80438d:	8b 45 08             	mov    0x8(%ebp),%eax
  804390:	8b 00                	mov    (%eax),%eax
  804392:	85 c0                	test   %eax,%eax
  804394:	75 18                	jne    8043ae <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  804396:	8b 45 08             	mov    0x8(%ebp),%eax
  804399:	83 c0 04             	add    $0x4,%eax
  80439c:	50                   	push   %eax
  80439d:	68 f8 53 80 00       	push   $0x8053f8
  8043a2:	6a 2b                	push   $0x2b
  8043a4:	68 c4 53 80 00       	push   $0x8053c4
  8043a9:	e8 3a 00 00 00       	call   8043e8 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8043ae:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8043b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8043b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8043bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8043c2:	8d 48 04             	lea    0x4(%eax),%ecx
  8043c5:	a1 20 60 80 00       	mov    0x806020,%eax
  8043ca:	8d 50 20             	lea    0x20(%eax),%edx
  8043cd:	a1 20 60 80 00       	mov    0x806020,%eax
  8043d2:	8b 40 10             	mov    0x10(%eax),%eax
  8043d5:	51                   	push   %ecx
  8043d6:	52                   	push   %edx
  8043d7:	50                   	push   %eax
  8043d8:	68 18 54 80 00       	push   $0x805418
  8043dd:	e8 a0 c6 ff ff       	call   800a82 <cprintf>
  8043e2:	83 c4 10             	add    $0x10,%esp
}
  8043e5:	90                   	nop
  8043e6:	c9                   	leave  
  8043e7:	c3                   	ret    

008043e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8043e8:	55                   	push   %ebp
  8043e9:	89 e5                	mov    %esp,%ebp
  8043eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8043ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8043f1:	83 c0 04             	add    $0x4,%eax
  8043f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8043f7:	a1 84 e1 81 00       	mov    0x81e184,%eax
  8043fc:	85 c0                	test   %eax,%eax
  8043fe:	74 16                	je     804416 <_panic+0x2e>
		cprintf("%s: ", argv0);
  804400:	a1 84 e1 81 00       	mov    0x81e184,%eax
  804405:	83 ec 08             	sub    $0x8,%esp
  804408:	50                   	push   %eax
  804409:	68 3c 54 80 00       	push   $0x80543c
  80440e:	e8 6f c6 ff ff       	call   800a82 <cprintf>
  804413:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  804416:	a1 04 60 80 00       	mov    0x806004,%eax
  80441b:	83 ec 0c             	sub    $0xc,%esp
  80441e:	ff 75 0c             	pushl  0xc(%ebp)
  804421:	ff 75 08             	pushl  0x8(%ebp)
  804424:	50                   	push   %eax
  804425:	68 44 54 80 00       	push   $0x805444
  80442a:	6a 74                	push   $0x74
  80442c:	e8 7e c6 ff ff       	call   800aaf <cprintf_colored>
  804431:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  804434:	8b 45 10             	mov    0x10(%ebp),%eax
  804437:	83 ec 08             	sub    $0x8,%esp
  80443a:	ff 75 f4             	pushl  -0xc(%ebp)
  80443d:	50                   	push   %eax
  80443e:	e8 d0 c5 ff ff       	call   800a13 <vcprintf>
  804443:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  804446:	83 ec 08             	sub    $0x8,%esp
  804449:	6a 00                	push   $0x0
  80444b:	68 6c 54 80 00       	push   $0x80546c
  804450:	e8 be c5 ff ff       	call   800a13 <vcprintf>
  804455:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  804458:	e8 37 c5 ff ff       	call   800994 <exit>

	// should not return here
	while (1) ;
  80445d:	eb fe                	jmp    80445d <_panic+0x75>

0080445f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80445f:	55                   	push   %ebp
  804460:	89 e5                	mov    %esp,%ebp
  804462:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  804465:	a1 20 60 80 00       	mov    0x806020,%eax
  80446a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  804470:	8b 45 0c             	mov    0xc(%ebp),%eax
  804473:	39 c2                	cmp    %eax,%edx
  804475:	74 14                	je     80448b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  804477:	83 ec 04             	sub    $0x4,%esp
  80447a:	68 70 54 80 00       	push   $0x805470
  80447f:	6a 26                	push   $0x26
  804481:	68 bc 54 80 00       	push   $0x8054bc
  804486:	e8 5d ff ff ff       	call   8043e8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80448b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  804492:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804499:	e9 c5 00 00 00       	jmp    804563 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80449e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8044a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ab:	01 d0                	add    %edx,%eax
  8044ad:	8b 00                	mov    (%eax),%eax
  8044af:	85 c0                	test   %eax,%eax
  8044b1:	75 08                	jne    8044bb <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8044b3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8044b6:	e9 a5 00 00 00       	jmp    804560 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8044bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8044c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8044c9:	eb 69                	jmp    804534 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8044cb:	a1 20 60 80 00       	mov    0x806020,%eax
  8044d0:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8044d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8044d9:	89 d0                	mov    %edx,%eax
  8044db:	01 c0                	add    %eax,%eax
  8044dd:	01 d0                	add    %edx,%eax
  8044df:	c1 e0 03             	shl    $0x3,%eax
  8044e2:	01 c8                	add    %ecx,%eax
  8044e4:	8a 40 04             	mov    0x4(%eax),%al
  8044e7:	84 c0                	test   %al,%al
  8044e9:	75 46                	jne    804531 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8044eb:	a1 20 60 80 00       	mov    0x806020,%eax
  8044f0:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8044f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8044f9:	89 d0                	mov    %edx,%eax
  8044fb:	01 c0                	add    %eax,%eax
  8044fd:	01 d0                	add    %edx,%eax
  8044ff:	c1 e0 03             	shl    $0x3,%eax
  804502:	01 c8                	add    %ecx,%eax
  804504:	8b 00                	mov    (%eax),%eax
  804506:	89 45 dc             	mov    %eax,-0x24(%ebp)
  804509:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80450c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  804511:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  804513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804516:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80451d:	8b 45 08             	mov    0x8(%ebp),%eax
  804520:	01 c8                	add    %ecx,%eax
  804522:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804524:	39 c2                	cmp    %eax,%edx
  804526:	75 09                	jne    804531 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804528:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80452f:	eb 15                	jmp    804546 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804531:	ff 45 e8             	incl   -0x18(%ebp)
  804534:	a1 20 60 80 00       	mov    0x806020,%eax
  804539:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80453f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804542:	39 c2                	cmp    %eax,%edx
  804544:	77 85                	ja     8044cb <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  804546:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80454a:	75 14                	jne    804560 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80454c:	83 ec 04             	sub    $0x4,%esp
  80454f:	68 c8 54 80 00       	push   $0x8054c8
  804554:	6a 3a                	push   $0x3a
  804556:	68 bc 54 80 00       	push   $0x8054bc
  80455b:	e8 88 fe ff ff       	call   8043e8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  804560:	ff 45 f0             	incl   -0x10(%ebp)
  804563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804566:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804569:	0f 8c 2f ff ff ff    	jl     80449e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80456f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804576:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80457d:	eb 26                	jmp    8045a5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80457f:	a1 20 60 80 00       	mov    0x806020,%eax
  804584:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80458a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80458d:	89 d0                	mov    %edx,%eax
  80458f:	01 c0                	add    %eax,%eax
  804591:	01 d0                	add    %edx,%eax
  804593:	c1 e0 03             	shl    $0x3,%eax
  804596:	01 c8                	add    %ecx,%eax
  804598:	8a 40 04             	mov    0x4(%eax),%al
  80459b:	3c 01                	cmp    $0x1,%al
  80459d:	75 03                	jne    8045a2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80459f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8045a2:	ff 45 e0             	incl   -0x20(%ebp)
  8045a5:	a1 20 60 80 00       	mov    0x806020,%eax
  8045aa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8045b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8045b3:	39 c2                	cmp    %eax,%edx
  8045b5:	77 c8                	ja     80457f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8045b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045ba:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8045bd:	74 14                	je     8045d3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8045bf:	83 ec 04             	sub    $0x4,%esp
  8045c2:	68 1c 55 80 00       	push   $0x80551c
  8045c7:	6a 44                	push   $0x44
  8045c9:	68 bc 54 80 00       	push   $0x8054bc
  8045ce:	e8 15 fe ff ff       	call   8043e8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8045d3:	90                   	nop
  8045d4:	c9                   	leave  
  8045d5:	c3                   	ret    
  8045d6:	66 90                	xchg   %ax,%ax

008045d8 <__divdi3>:
  8045d8:	55                   	push   %ebp
  8045d9:	57                   	push   %edi
  8045da:	56                   	push   %esi
  8045db:	53                   	push   %ebx
  8045dc:	83 ec 1c             	sub    $0x1c,%esp
  8045df:	8b 44 24 30          	mov    0x30(%esp),%eax
  8045e3:	8b 54 24 34          	mov    0x34(%esp),%edx
  8045e7:	8b 74 24 38          	mov    0x38(%esp),%esi
  8045eb:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  8045ef:	89 f9                	mov    %edi,%ecx
  8045f1:	85 d2                	test   %edx,%edx
  8045f3:	0f 88 bb 00 00 00    	js     8046b4 <__divdi3+0xdc>
  8045f9:	31 ed                	xor    %ebp,%ebp
  8045fb:	85 c9                	test   %ecx,%ecx
  8045fd:	0f 88 99 00 00 00    	js     80469c <__divdi3+0xc4>
  804603:	89 34 24             	mov    %esi,(%esp)
  804606:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80460a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80460e:	89 d3                	mov    %edx,%ebx
  804610:	8b 34 24             	mov    (%esp),%esi
  804613:	8b 7c 24 04          	mov    0x4(%esp),%edi
  804617:	89 74 24 08          	mov    %esi,0x8(%esp)
  80461b:	8b 34 24             	mov    (%esp),%esi
  80461e:	89 c1                	mov    %eax,%ecx
  804620:	85 ff                	test   %edi,%edi
  804622:	75 10                	jne    804634 <__divdi3+0x5c>
  804624:	8b 7c 24 08          	mov    0x8(%esp),%edi
  804628:	39 d7                	cmp    %edx,%edi
  80462a:	76 4c                	jbe    804678 <__divdi3+0xa0>
  80462c:	f7 f7                	div    %edi
  80462e:	89 c1                	mov    %eax,%ecx
  804630:	31 f6                	xor    %esi,%esi
  804632:	eb 08                	jmp    80463c <__divdi3+0x64>
  804634:	39 d7                	cmp    %edx,%edi
  804636:	76 1c                	jbe    804654 <__divdi3+0x7c>
  804638:	31 f6                	xor    %esi,%esi
  80463a:	31 c9                	xor    %ecx,%ecx
  80463c:	89 c8                	mov    %ecx,%eax
  80463e:	89 f2                	mov    %esi,%edx
  804640:	85 ed                	test   %ebp,%ebp
  804642:	74 07                	je     80464b <__divdi3+0x73>
  804644:	f7 d8                	neg    %eax
  804646:	83 d2 00             	adc    $0x0,%edx
  804649:	f7 da                	neg    %edx
  80464b:	83 c4 1c             	add    $0x1c,%esp
  80464e:	5b                   	pop    %ebx
  80464f:	5e                   	pop    %esi
  804650:	5f                   	pop    %edi
  804651:	5d                   	pop    %ebp
  804652:	c3                   	ret    
  804653:	90                   	nop
  804654:	0f bd f7             	bsr    %edi,%esi
  804657:	83 f6 1f             	xor    $0x1f,%esi
  80465a:	75 6c                	jne    8046c8 <__divdi3+0xf0>
  80465c:	39 d7                	cmp    %edx,%edi
  80465e:	72 0e                	jb     80466e <__divdi3+0x96>
  804660:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  804664:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  804668:	0f 87 ca 00 00 00    	ja     804738 <__divdi3+0x160>
  80466e:	b9 01 00 00 00       	mov    $0x1,%ecx
  804673:	eb c7                	jmp    80463c <__divdi3+0x64>
  804675:	8d 76 00             	lea    0x0(%esi),%esi
  804678:	85 f6                	test   %esi,%esi
  80467a:	75 0b                	jne    804687 <__divdi3+0xaf>
  80467c:	b8 01 00 00 00       	mov    $0x1,%eax
  804681:	31 d2                	xor    %edx,%edx
  804683:	f7 f6                	div    %esi
  804685:	89 c6                	mov    %eax,%esi
  804687:	31 d2                	xor    %edx,%edx
  804689:	89 d8                	mov    %ebx,%eax
  80468b:	f7 f6                	div    %esi
  80468d:	89 c7                	mov    %eax,%edi
  80468f:	89 c8                	mov    %ecx,%eax
  804691:	f7 f6                	div    %esi
  804693:	89 c1                	mov    %eax,%ecx
  804695:	89 fe                	mov    %edi,%esi
  804697:	eb a3                	jmp    80463c <__divdi3+0x64>
  804699:	8d 76 00             	lea    0x0(%esi),%esi
  80469c:	f7 d5                	not    %ebp
  80469e:	f7 de                	neg    %esi
  8046a0:	83 d7 00             	adc    $0x0,%edi
  8046a3:	f7 df                	neg    %edi
  8046a5:	89 34 24             	mov    %esi,(%esp)
  8046a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8046ac:	e9 59 ff ff ff       	jmp    80460a <__divdi3+0x32>
  8046b1:	8d 76 00             	lea    0x0(%esi),%esi
  8046b4:	f7 d8                	neg    %eax
  8046b6:	83 d2 00             	adc    $0x0,%edx
  8046b9:	f7 da                	neg    %edx
  8046bb:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  8046c0:	e9 36 ff ff ff       	jmp    8045fb <__divdi3+0x23>
  8046c5:	8d 76 00             	lea    0x0(%esi),%esi
  8046c8:	b8 20 00 00 00       	mov    $0x20,%eax
  8046cd:	29 f0                	sub    %esi,%eax
  8046cf:	89 f1                	mov    %esi,%ecx
  8046d1:	d3 e7                	shl    %cl,%edi
  8046d3:	8b 54 24 08          	mov    0x8(%esp),%edx
  8046d7:	88 c1                	mov    %al,%cl
  8046d9:	d3 ea                	shr    %cl,%edx
  8046db:	89 d1                	mov    %edx,%ecx
  8046dd:	09 f9                	or     %edi,%ecx
  8046df:	89 0c 24             	mov    %ecx,(%esp)
  8046e2:	8b 54 24 08          	mov    0x8(%esp),%edx
  8046e6:	89 f1                	mov    %esi,%ecx
  8046e8:	d3 e2                	shl    %cl,%edx
  8046ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8046ee:	89 df                	mov    %ebx,%edi
  8046f0:	88 c1                	mov    %al,%cl
  8046f2:	d3 ef                	shr    %cl,%edi
  8046f4:	89 f1                	mov    %esi,%ecx
  8046f6:	d3 e3                	shl    %cl,%ebx
  8046f8:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8046fc:	88 c1                	mov    %al,%cl
  8046fe:	d3 ea                	shr    %cl,%edx
  804700:	09 d3                	or     %edx,%ebx
  804702:	89 d8                	mov    %ebx,%eax
  804704:	89 fa                	mov    %edi,%edx
  804706:	f7 34 24             	divl   (%esp)
  804709:	89 d1                	mov    %edx,%ecx
  80470b:	89 c3                	mov    %eax,%ebx
  80470d:	f7 64 24 08          	mull   0x8(%esp)
  804711:	39 d1                	cmp    %edx,%ecx
  804713:	72 17                	jb     80472c <__divdi3+0x154>
  804715:	74 09                	je     804720 <__divdi3+0x148>
  804717:	89 d9                	mov    %ebx,%ecx
  804719:	31 f6                	xor    %esi,%esi
  80471b:	e9 1c ff ff ff       	jmp    80463c <__divdi3+0x64>
  804720:	8b 54 24 0c          	mov    0xc(%esp),%edx
  804724:	89 f1                	mov    %esi,%ecx
  804726:	d3 e2                	shl    %cl,%edx
  804728:	39 c2                	cmp    %eax,%edx
  80472a:	73 eb                	jae    804717 <__divdi3+0x13f>
  80472c:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  80472f:	31 f6                	xor    %esi,%esi
  804731:	e9 06 ff ff ff       	jmp    80463c <__divdi3+0x64>
  804736:	66 90                	xchg   %ax,%ax
  804738:	31 c9                	xor    %ecx,%ecx
  80473a:	e9 fd fe ff ff       	jmp    80463c <__divdi3+0x64>
  80473f:	90                   	nop

00804740 <__udivdi3>:
  804740:	55                   	push   %ebp
  804741:	57                   	push   %edi
  804742:	56                   	push   %esi
  804743:	53                   	push   %ebx
  804744:	83 ec 1c             	sub    $0x1c,%esp
  804747:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80474b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80474f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804753:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804757:	89 ca                	mov    %ecx,%edx
  804759:	89 f8                	mov    %edi,%eax
  80475b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80475f:	85 f6                	test   %esi,%esi
  804761:	75 2d                	jne    804790 <__udivdi3+0x50>
  804763:	39 cf                	cmp    %ecx,%edi
  804765:	77 65                	ja     8047cc <__udivdi3+0x8c>
  804767:	89 fd                	mov    %edi,%ebp
  804769:	85 ff                	test   %edi,%edi
  80476b:	75 0b                	jne    804778 <__udivdi3+0x38>
  80476d:	b8 01 00 00 00       	mov    $0x1,%eax
  804772:	31 d2                	xor    %edx,%edx
  804774:	f7 f7                	div    %edi
  804776:	89 c5                	mov    %eax,%ebp
  804778:	31 d2                	xor    %edx,%edx
  80477a:	89 c8                	mov    %ecx,%eax
  80477c:	f7 f5                	div    %ebp
  80477e:	89 c1                	mov    %eax,%ecx
  804780:	89 d8                	mov    %ebx,%eax
  804782:	f7 f5                	div    %ebp
  804784:	89 cf                	mov    %ecx,%edi
  804786:	89 fa                	mov    %edi,%edx
  804788:	83 c4 1c             	add    $0x1c,%esp
  80478b:	5b                   	pop    %ebx
  80478c:	5e                   	pop    %esi
  80478d:	5f                   	pop    %edi
  80478e:	5d                   	pop    %ebp
  80478f:	c3                   	ret    
  804790:	39 ce                	cmp    %ecx,%esi
  804792:	77 28                	ja     8047bc <__udivdi3+0x7c>
  804794:	0f bd fe             	bsr    %esi,%edi
  804797:	83 f7 1f             	xor    $0x1f,%edi
  80479a:	75 40                	jne    8047dc <__udivdi3+0x9c>
  80479c:	39 ce                	cmp    %ecx,%esi
  80479e:	72 0a                	jb     8047aa <__udivdi3+0x6a>
  8047a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8047a4:	0f 87 9e 00 00 00    	ja     804848 <__udivdi3+0x108>
  8047aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8047af:	89 fa                	mov    %edi,%edx
  8047b1:	83 c4 1c             	add    $0x1c,%esp
  8047b4:	5b                   	pop    %ebx
  8047b5:	5e                   	pop    %esi
  8047b6:	5f                   	pop    %edi
  8047b7:	5d                   	pop    %ebp
  8047b8:	c3                   	ret    
  8047b9:	8d 76 00             	lea    0x0(%esi),%esi
  8047bc:	31 ff                	xor    %edi,%edi
  8047be:	31 c0                	xor    %eax,%eax
  8047c0:	89 fa                	mov    %edi,%edx
  8047c2:	83 c4 1c             	add    $0x1c,%esp
  8047c5:	5b                   	pop    %ebx
  8047c6:	5e                   	pop    %esi
  8047c7:	5f                   	pop    %edi
  8047c8:	5d                   	pop    %ebp
  8047c9:	c3                   	ret    
  8047ca:	66 90                	xchg   %ax,%ax
  8047cc:	89 d8                	mov    %ebx,%eax
  8047ce:	f7 f7                	div    %edi
  8047d0:	31 ff                	xor    %edi,%edi
  8047d2:	89 fa                	mov    %edi,%edx
  8047d4:	83 c4 1c             	add    $0x1c,%esp
  8047d7:	5b                   	pop    %ebx
  8047d8:	5e                   	pop    %esi
  8047d9:	5f                   	pop    %edi
  8047da:	5d                   	pop    %ebp
  8047db:	c3                   	ret    
  8047dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8047e1:	89 eb                	mov    %ebp,%ebx
  8047e3:	29 fb                	sub    %edi,%ebx
  8047e5:	89 f9                	mov    %edi,%ecx
  8047e7:	d3 e6                	shl    %cl,%esi
  8047e9:	89 c5                	mov    %eax,%ebp
  8047eb:	88 d9                	mov    %bl,%cl
  8047ed:	d3 ed                	shr    %cl,%ebp
  8047ef:	89 e9                	mov    %ebp,%ecx
  8047f1:	09 f1                	or     %esi,%ecx
  8047f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8047f7:	89 f9                	mov    %edi,%ecx
  8047f9:	d3 e0                	shl    %cl,%eax
  8047fb:	89 c5                	mov    %eax,%ebp
  8047fd:	89 d6                	mov    %edx,%esi
  8047ff:	88 d9                	mov    %bl,%cl
  804801:	d3 ee                	shr    %cl,%esi
  804803:	89 f9                	mov    %edi,%ecx
  804805:	d3 e2                	shl    %cl,%edx
  804807:	8b 44 24 08          	mov    0x8(%esp),%eax
  80480b:	88 d9                	mov    %bl,%cl
  80480d:	d3 e8                	shr    %cl,%eax
  80480f:	09 c2                	or     %eax,%edx
  804811:	89 d0                	mov    %edx,%eax
  804813:	89 f2                	mov    %esi,%edx
  804815:	f7 74 24 0c          	divl   0xc(%esp)
  804819:	89 d6                	mov    %edx,%esi
  80481b:	89 c3                	mov    %eax,%ebx
  80481d:	f7 e5                	mul    %ebp
  80481f:	39 d6                	cmp    %edx,%esi
  804821:	72 19                	jb     80483c <__udivdi3+0xfc>
  804823:	74 0b                	je     804830 <__udivdi3+0xf0>
  804825:	89 d8                	mov    %ebx,%eax
  804827:	31 ff                	xor    %edi,%edi
  804829:	e9 58 ff ff ff       	jmp    804786 <__udivdi3+0x46>
  80482e:	66 90                	xchg   %ax,%ax
  804830:	8b 54 24 08          	mov    0x8(%esp),%edx
  804834:	89 f9                	mov    %edi,%ecx
  804836:	d3 e2                	shl    %cl,%edx
  804838:	39 c2                	cmp    %eax,%edx
  80483a:	73 e9                	jae    804825 <__udivdi3+0xe5>
  80483c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80483f:	31 ff                	xor    %edi,%edi
  804841:	e9 40 ff ff ff       	jmp    804786 <__udivdi3+0x46>
  804846:	66 90                	xchg   %ax,%ax
  804848:	31 c0                	xor    %eax,%eax
  80484a:	e9 37 ff ff ff       	jmp    804786 <__udivdi3+0x46>
  80484f:	90                   	nop

00804850 <__umoddi3>:
  804850:	55                   	push   %ebp
  804851:	57                   	push   %edi
  804852:	56                   	push   %esi
  804853:	53                   	push   %ebx
  804854:	83 ec 1c             	sub    $0x1c,%esp
  804857:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80485b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80485f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804863:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804867:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80486b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80486f:	89 f3                	mov    %esi,%ebx
  804871:	89 fa                	mov    %edi,%edx
  804873:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804877:	89 34 24             	mov    %esi,(%esp)
  80487a:	85 c0                	test   %eax,%eax
  80487c:	75 1a                	jne    804898 <__umoddi3+0x48>
  80487e:	39 f7                	cmp    %esi,%edi
  804880:	0f 86 a2 00 00 00    	jbe    804928 <__umoddi3+0xd8>
  804886:	89 c8                	mov    %ecx,%eax
  804888:	89 f2                	mov    %esi,%edx
  80488a:	f7 f7                	div    %edi
  80488c:	89 d0                	mov    %edx,%eax
  80488e:	31 d2                	xor    %edx,%edx
  804890:	83 c4 1c             	add    $0x1c,%esp
  804893:	5b                   	pop    %ebx
  804894:	5e                   	pop    %esi
  804895:	5f                   	pop    %edi
  804896:	5d                   	pop    %ebp
  804897:	c3                   	ret    
  804898:	39 f0                	cmp    %esi,%eax
  80489a:	0f 87 ac 00 00 00    	ja     80494c <__umoddi3+0xfc>
  8048a0:	0f bd e8             	bsr    %eax,%ebp
  8048a3:	83 f5 1f             	xor    $0x1f,%ebp
  8048a6:	0f 84 ac 00 00 00    	je     804958 <__umoddi3+0x108>
  8048ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8048b1:	29 ef                	sub    %ebp,%edi
  8048b3:	89 fe                	mov    %edi,%esi
  8048b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8048b9:	89 e9                	mov    %ebp,%ecx
  8048bb:	d3 e0                	shl    %cl,%eax
  8048bd:	89 d7                	mov    %edx,%edi
  8048bf:	89 f1                	mov    %esi,%ecx
  8048c1:	d3 ef                	shr    %cl,%edi
  8048c3:	09 c7                	or     %eax,%edi
  8048c5:	89 e9                	mov    %ebp,%ecx
  8048c7:	d3 e2                	shl    %cl,%edx
  8048c9:	89 14 24             	mov    %edx,(%esp)
  8048cc:	89 d8                	mov    %ebx,%eax
  8048ce:	d3 e0                	shl    %cl,%eax
  8048d0:	89 c2                	mov    %eax,%edx
  8048d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048d6:	d3 e0                	shl    %cl,%eax
  8048d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8048dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048e0:	89 f1                	mov    %esi,%ecx
  8048e2:	d3 e8                	shr    %cl,%eax
  8048e4:	09 d0                	or     %edx,%eax
  8048e6:	d3 eb                	shr    %cl,%ebx
  8048e8:	89 da                	mov    %ebx,%edx
  8048ea:	f7 f7                	div    %edi
  8048ec:	89 d3                	mov    %edx,%ebx
  8048ee:	f7 24 24             	mull   (%esp)
  8048f1:	89 c6                	mov    %eax,%esi
  8048f3:	89 d1                	mov    %edx,%ecx
  8048f5:	39 d3                	cmp    %edx,%ebx
  8048f7:	0f 82 87 00 00 00    	jb     804984 <__umoddi3+0x134>
  8048fd:	0f 84 91 00 00 00    	je     804994 <__umoddi3+0x144>
  804903:	8b 54 24 04          	mov    0x4(%esp),%edx
  804907:	29 f2                	sub    %esi,%edx
  804909:	19 cb                	sbb    %ecx,%ebx
  80490b:	89 d8                	mov    %ebx,%eax
  80490d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804911:	d3 e0                	shl    %cl,%eax
  804913:	89 e9                	mov    %ebp,%ecx
  804915:	d3 ea                	shr    %cl,%edx
  804917:	09 d0                	or     %edx,%eax
  804919:	89 e9                	mov    %ebp,%ecx
  80491b:	d3 eb                	shr    %cl,%ebx
  80491d:	89 da                	mov    %ebx,%edx
  80491f:	83 c4 1c             	add    $0x1c,%esp
  804922:	5b                   	pop    %ebx
  804923:	5e                   	pop    %esi
  804924:	5f                   	pop    %edi
  804925:	5d                   	pop    %ebp
  804926:	c3                   	ret    
  804927:	90                   	nop
  804928:	89 fd                	mov    %edi,%ebp
  80492a:	85 ff                	test   %edi,%edi
  80492c:	75 0b                	jne    804939 <__umoddi3+0xe9>
  80492e:	b8 01 00 00 00       	mov    $0x1,%eax
  804933:	31 d2                	xor    %edx,%edx
  804935:	f7 f7                	div    %edi
  804937:	89 c5                	mov    %eax,%ebp
  804939:	89 f0                	mov    %esi,%eax
  80493b:	31 d2                	xor    %edx,%edx
  80493d:	f7 f5                	div    %ebp
  80493f:	89 c8                	mov    %ecx,%eax
  804941:	f7 f5                	div    %ebp
  804943:	89 d0                	mov    %edx,%eax
  804945:	e9 44 ff ff ff       	jmp    80488e <__umoddi3+0x3e>
  80494a:	66 90                	xchg   %ax,%ax
  80494c:	89 c8                	mov    %ecx,%eax
  80494e:	89 f2                	mov    %esi,%edx
  804950:	83 c4 1c             	add    $0x1c,%esp
  804953:	5b                   	pop    %ebx
  804954:	5e                   	pop    %esi
  804955:	5f                   	pop    %edi
  804956:	5d                   	pop    %ebp
  804957:	c3                   	ret    
  804958:	3b 04 24             	cmp    (%esp),%eax
  80495b:	72 06                	jb     804963 <__umoddi3+0x113>
  80495d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804961:	77 0f                	ja     804972 <__umoddi3+0x122>
  804963:	89 f2                	mov    %esi,%edx
  804965:	29 f9                	sub    %edi,%ecx
  804967:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80496b:	89 14 24             	mov    %edx,(%esp)
  80496e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804972:	8b 44 24 04          	mov    0x4(%esp),%eax
  804976:	8b 14 24             	mov    (%esp),%edx
  804979:	83 c4 1c             	add    $0x1c,%esp
  80497c:	5b                   	pop    %ebx
  80497d:	5e                   	pop    %esi
  80497e:	5f                   	pop    %edi
  80497f:	5d                   	pop    %ebp
  804980:	c3                   	ret    
  804981:	8d 76 00             	lea    0x0(%esi),%esi
  804984:	2b 04 24             	sub    (%esp),%eax
  804987:	19 fa                	sbb    %edi,%edx
  804989:	89 d1                	mov    %edx,%ecx
  80498b:	89 c6                	mov    %eax,%esi
  80498d:	e9 71 ff ff ff       	jmp    804903 <__umoddi3+0xb3>
  804992:	66 90                	xchg   %ax,%ax
  804994:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804998:	72 ea                	jb     804984 <__umoddi3+0x134>
  80499a:	89 d9                	mov    %ebx,%ecx
  80499c:	e9 62 ff ff ff       	jmp    804903 <__umoddi3+0xb3>
