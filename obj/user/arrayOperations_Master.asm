
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 3c 0b 00 00       	call   800b72 <libmain>
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
  8000b1:	68 40 4f 80 00       	push   $0x804f40
  8000b6:	e8 3e 0f 00 00       	call   800ff9 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8000be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	8b 00                	mov    (%eax),%eax
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	50                   	push   %eax
  8000d3:	68 42 4f 80 00       	push   $0x804f42
  8000d8:	e8 1c 0f 00 00       	call   800ff9 <cprintf>
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
  800101:	68 47 4f 80 00       	push   $0x804f47
  800106:	e8 ee 0e 00 00       	call   800ff9 <cprintf>
  80010b:	83 c4 10             	add    $0x10,%esp

}
  80010e:	90                   	nop
  80010f:	c9                   	leave  
  800110:	c3                   	ret    

00800111 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var);

void
_main(void)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	57                   	push   %edi
  800115:	56                   	push   %esi
  800116:	53                   	push   %ebx
  800117:	81 ec bc 02 00 00    	sub    $0x2bc,%esp
	/*[1] CREATE SEMAPHORES*/
#if USE_KERN_SEMAPHORE
	//Initialize the kernel semaphores
	int semVal ;
	char initCmd1[64] = "__KSem@0@Init";
  80011d:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  800123:	bb be 51 80 00       	mov    $0x8051be,%ebx
  800128:	ba 0e 00 00 00       	mov    $0xe,%edx
  80012d:	89 c7                	mov    %eax,%edi
  80012f:	89 de                	mov    %ebx,%esi
  800131:	89 d1                	mov    %edx,%ecx
  800133:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800135:	8d 95 52 ff ff ff    	lea    -0xae(%ebp),%edx
  80013b:	b9 32 00 00 00       	mov    $0x32,%ecx
  800140:	b0 00                	mov    $0x0,%al
  800142:	89 d7                	mov    %edx,%edi
  800144:	f3 aa                	rep stos %al,%es:(%edi)
	char initCmd2[64] = "__KSem@1@Init";
  800146:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  80014c:	bb fe 51 80 00       	mov    $0x8051fe,%ebx
  800151:	ba 0e 00 00 00       	mov    $0xe,%edx
  800156:	89 c7                	mov    %eax,%edi
  800158:	89 de                	mov    %ebx,%esi
  80015a:	89 d1                	mov    %edx,%ecx
  80015c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80015e:	8d 95 12 ff ff ff    	lea    -0xee(%ebp),%edx
  800164:	b9 32 00 00 00       	mov    $0x32,%ecx
  800169:	b0 00                	mov    $0x0,%al
  80016b:	89 d7                	mov    %edx,%edi
  80016d:	f3 aa                	rep stos %al,%es:(%edi)
	char initCmd3[64] = "__KSem@2@Init";
  80016f:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800175:	bb 3e 52 80 00       	mov    $0x80523e,%ebx
  80017a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80017f:	89 c7                	mov    %eax,%edi
  800181:	89 de                	mov    %ebx,%esi
  800183:	89 d1                	mov    %edx,%ecx
  800185:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800187:	8d 95 d2 fe ff ff    	lea    -0x12e(%ebp),%edx
  80018d:	b9 32 00 00 00       	mov    $0x32,%ecx
  800192:	b0 00                	mov    $0x0,%al
  800194:	89 d7                	mov    %edx,%edi
  800196:	f3 aa                	rep stos %al,%es:(%edi)
	semVal = 0; sys_utilities(initCmd1, (uint32)(&semVal));
  800198:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
  80019f:	8d 45 84             	lea    -0x7c(%ebp),%eax
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  8001ac:	50                   	push   %eax
  8001ad:	e8 b9 3d 00 00       	call   803f6b <sys_utilities>
  8001b2:	83 c4 10             	add    $0x10,%esp
	semVal = 0; sys_utilities(initCmd2, (uint32)(&semVal));
  8001b5:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
  8001bc:	8d 45 84             	lea    -0x7c(%ebp),%eax
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	50                   	push   %eax
  8001c3:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001c9:	50                   	push   %eax
  8001ca:	e8 9c 3d 00 00       	call   803f6b <sys_utilities>
  8001cf:	83 c4 10             	add    $0x10,%esp
	semVal = 1; sys_utilities(initCmd3, (uint32)(&semVal));
  8001d2:	c7 45 84 01 00 00 00 	movl   $0x1,-0x7c(%ebp)
  8001d9:	8d 45 84             	lea    -0x7c(%ebp),%eax
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	50                   	push   %eax
  8001e0:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  8001e6:	50                   	push   %eax
  8001e7:	e8 7f 3d 00 00       	call   803f6b <sys_utilities>
  8001ec:	83 c4 10             	add    $0x10,%esp
	struct semaphore ready = create_semaphore("Ready", 0);
	struct semaphore finished = create_semaphore("Finished", 0);
	struct semaphore cons_mutex = create_semaphore("Console Mutex", 1);
#endif
	/*[2] RUN THE SLAVES PROGRAMS*/
	int numOfSlaveProgs = 3 ;
  8001ef:	c7 45 dc 03 00 00 00 	movl   $0x3,-0x24(%ebp)

	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  8001f6:	a1 20 60 80 00       	mov    0x806020,%eax
  8001fb:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800201:	a1 20 60 80 00       	mov    0x806020,%eax
  800206:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80020c:	89 c1                	mov    %eax,%ecx
  80020e:	a1 20 60 80 00       	mov    0x806020,%eax
  800213:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800219:	52                   	push   %edx
  80021a:	51                   	push   %ecx
  80021b:	50                   	push   %eax
  80021c:	68 4b 4f 80 00       	push   $0x804f4b
  800221:	e8 a1 3a 00 00       	call   803cc7 <sys_create_env>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80022c:	a1 20 60 80 00       	mov    0x806020,%eax
  800231:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800237:	a1 20 60 80 00       	mov    0x806020,%eax
  80023c:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800242:	89 c1                	mov    %eax,%ecx
  800244:	a1 20 60 80 00       	mov    0x806020,%eax
  800249:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80024f:	52                   	push   %edx
  800250:	51                   	push   %ecx
  800251:	50                   	push   %eax
  800252:	68 54 4f 80 00       	push   $0x804f54
  800257:	e8 6b 3a 00 00       	call   803cc7 <sys_create_env>
  80025c:	83 c4 10             	add    $0x10,%esp
  80025f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800262:	a1 20 60 80 00       	mov    0x806020,%eax
  800267:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80026d:	a1 20 60 80 00       	mov    0x806020,%eax
  800272:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800278:	89 c1                	mov    %eax,%ecx
  80027a:	a1 20 60 80 00       	mov    0x806020,%eax
  80027f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800285:	52                   	push   %edx
  800286:	51                   	push   %ecx
  800287:	50                   	push   %eax
  800288:	68 5d 4f 80 00       	push   $0x804f5d
  80028d:	e8 35 3a 00 00       	call   803cc7 <sys_create_env>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  800298:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  80029c:	74 0c                	je     8002aa <_main+0x199>
  80029e:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8002a2:	74 06                	je     8002aa <_main+0x199>
  8002a4:	83 7d d0 ef          	cmpl   $0xffffffef,-0x30(%ebp)
  8002a8:	75 14                	jne    8002be <_main+0x1ad>
		panic("NO AVAILABLE ENVs...");
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 69 4f 80 00       	push   $0x804f69
  8002b2:	6a 25                	push   $0x25
  8002b4:	68 7e 4f 80 00       	push   $0x804f7e
  8002b9:	e8 6d 0a 00 00       	call   800d2b <_panic>

	sys_run_env(envIdQuickSort);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c4:	e8 1c 3a 00 00       	call   803ce5 <sys_run_env>
  8002c9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002d2:	e8 0e 3a 00 00       	call   803ce5 <sys_run_env>
  8002d7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002da:	83 ec 0c             	sub    $0xc,%esp
  8002dd:	ff 75 d0             	pushl  -0x30(%ebp)
  8002e0:	e8 00 3a 00 00       	call   803ce5 <sys_run_env>
  8002e5:	83 c4 10             	add    $0x10,%esp

	/*[3] CREATE SHARED VARIABLES*/
	//Share the cons_mutex owner ID
	int *mutexOwnerID = smalloc("cons_mutex ownerID", sizeof(int) , 0) ;
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	6a 00                	push   $0x0
  8002ed:	6a 04                	push   $0x4
  8002ef:	68 9c 4f 80 00       	push   $0x804f9c
  8002f4:	e8 af 2b 00 00       	call   802ea8 <smalloc>
  8002f9:	83 c4 10             	add    $0x10,%esp
  8002fc:	89 45 cc             	mov    %eax,-0x34(%ebp)
	*mutexOwnerID = myEnv->env_id ;
  8002ff:	a1 20 60 80 00       	mov    0x806020,%eax
  800304:	8b 50 10             	mov    0x10(%eax),%edx
  800307:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80030a:	89 10                	mov    %edx,(%eax)

	int ret;
	char Chose;
	char Line[30];
	int NumOfElements;
	int *Elements = NULL;
  80030c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	//lock the console
#if USE_KERN_SEMAPHORE
	char waitCmd1[64] = "__KSem@2@Wait";
  800313:	8d 85 66 fe ff ff    	lea    -0x19a(%ebp),%eax
  800319:	bb 7e 52 80 00       	mov    $0x80527e,%ebx
  80031e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800323:	89 c7                	mov    %eax,%edi
  800325:	89 de                	mov    %ebx,%esi
  800327:	89 d1                	mov    %edx,%ecx
  800329:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80032b:	8d 95 74 fe ff ff    	lea    -0x18c(%ebp),%edx
  800331:	b9 32 00 00 00       	mov    $0x32,%ecx
  800336:	b0 00                	mov    $0x0,%al
  800338:	89 d7                	mov    %edx,%edi
  80033a:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd1, 0);
  80033c:	83 ec 08             	sub    $0x8,%esp
  80033f:	6a 00                	push   $0x0
  800341:	8d 85 66 fe ff ff    	lea    -0x19a(%ebp),%eax
  800347:	50                   	push   %eax
  800348:	e8 1e 3c 00 00       	call   803f6b <sys_utilities>
  80034d:	83 c4 10             	add    $0x10,%esp
#else
	wait_semaphore(cons_mutex);
#endif
	{
		cprintf("\n");
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	68 40 4f 80 00       	push   $0x804f40
  800358:	e8 9c 0c 00 00       	call   800ff9 <cprintf>
  80035d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	68 af 4f 80 00       	push   $0x804faf
  800368:	e8 8c 0c 00 00       	call   800ff9 <cprintf>
  80036d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	68 cd 4f 80 00       	push   $0x804fcd
  800378:	e8 7c 0c 00 00       	call   800ff9 <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800380:	83 ec 0c             	sub    $0xc,%esp
  800383:	68 af 4f 80 00       	push   $0x804faf
  800388:	e8 6c 0c 00 00       	call   800ff9 <cprintf>
  80038d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800390:	83 ec 0c             	sub    $0xc,%esp
  800393:	68 40 4f 80 00       	push   $0x804f40
  800398:	e8 5c 0c 00 00       	call   800ff9 <cprintf>
  80039d:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	8d 85 a6 fe ff ff    	lea    -0x15a(%ebp),%eax
  8003a9:	50                   	push   %eax
  8003aa:	68 ec 4f 80 00       	push   $0x804fec
  8003af:	e8 1e 13 00 00       	call   8016d2 <readline>
  8003b4:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	6a 00                	push   $0x0
  8003bc:	6a 04                	push   $0x4
  8003be:	68 0b 50 80 00       	push   $0x80500b
  8003c3:	e8 e0 2a 00 00       	call   802ea8 <smalloc>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	6a 0a                	push   $0xa
  8003d3:	6a 00                	push   $0x0
  8003d5:	8d 85 a6 fe ff ff    	lea    -0x15a(%ebp),%eax
  8003db:	50                   	push   %eax
  8003dc:	e8 08 19 00 00       	call   801ce9 <strtol>
  8003e1:	83 c4 10             	add    $0x10,%esp
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003e9:	89 10                	mov    %edx,(%eax)
		NumOfElements = *arrSize;
  8003eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003ee:	8b 00                	mov    (%eax),%eax
  8003f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8003f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003f6:	c1 e0 02             	shl    $0x2,%eax
  8003f9:	83 ec 04             	sub    $0x4,%esp
  8003fc:	6a 00                	push   $0x0
  8003fe:	50                   	push   %eax
  8003ff:	68 13 50 80 00       	push   $0x805013
  800404:	e8 9f 2a 00 00       	call   802ea8 <smalloc>
  800409:	83 c4 10             	add    $0x10,%esp
  80040c:	89 45 c8             	mov    %eax,-0x38(%ebp)

		cprintf("Chose the initialization method:\n") ;
  80040f:	83 ec 0c             	sub    $0xc,%esp
  800412:	68 18 50 80 00       	push   $0x805018
  800417:	e8 dd 0b 00 00       	call   800ff9 <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80041f:	83 ec 0c             	sub    $0xc,%esp
  800422:	68 3a 50 80 00       	push   $0x80503a
  800427:	e8 cd 0b 00 00       	call   800ff9 <cprintf>
  80042c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80042f:	83 ec 0c             	sub    $0xc,%esp
  800432:	68 48 50 80 00       	push   $0x805048
  800437:	e8 bd 0b 00 00       	call   800ff9 <cprintf>
  80043c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	68 57 50 80 00       	push   $0x805057
  800447:	e8 ad 0b 00 00       	call   800ff9 <cprintf>
  80044c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80044f:	83 ec 0c             	sub    $0xc,%esp
  800452:	68 67 50 80 00       	push   $0x805067
  800457:	e8 9d 0b 00 00       	call   800ff9 <cprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80045f:	e8 f1 06 00 00       	call   800b55 <getchar>
  800464:	88 45 bf             	mov    %al,-0x41(%ebp)
			cputchar(Chose);
  800467:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  80046b:	83 ec 0c             	sub    $0xc,%esp
  80046e:	50                   	push   %eax
  80046f:	e8 c2 06 00 00       	call   800b36 <cputchar>
  800474:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800477:	83 ec 0c             	sub    $0xc,%esp
  80047a:	6a 0a                	push   $0xa
  80047c:	e8 b5 06 00 00       	call   800b36 <cputchar>
  800481:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800484:	80 7d bf 61          	cmpb   $0x61,-0x41(%ebp)
  800488:	74 0c                	je     800496 <_main+0x385>
  80048a:	80 7d bf 62          	cmpb   $0x62,-0x41(%ebp)
  80048e:	74 06                	je     800496 <_main+0x385>
  800490:	80 7d bf 63          	cmpb   $0x63,-0x41(%ebp)
  800494:	75 b9                	jne    80044f <_main+0x33e>

	}
#if USE_KERN_SEMAPHORE
	char signalCmd1[64] = "__KSem@2@Signal";
  800496:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  80049c:	bb be 52 80 00       	mov    $0x8052be,%ebx
  8004a1:	ba 04 00 00 00       	mov    $0x4,%edx
  8004a6:	89 c7                	mov    %eax,%edi
  8004a8:	89 de                	mov    %ebx,%esi
  8004aa:	89 d1                	mov    %edx,%ecx
  8004ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8004ae:	8d 95 36 fe ff ff    	lea    -0x1ca(%ebp),%edx
  8004b4:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8004b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004be:	89 d7                	mov    %edx,%edi
  8004c0:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd1, 0);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 00                	push   $0x0
  8004c7:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 98 3a 00 00       	call   803f6b <sys_utilities>
  8004d3:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(cons_mutex);
#endif
	//unlock the console

	int  i ;
	switch (Chose)
  8004d6:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  8004da:	83 f8 62             	cmp    $0x62,%eax
  8004dd:	74 1d                	je     8004fc <_main+0x3eb>
  8004df:	83 f8 63             	cmp    $0x63,%eax
  8004e2:	74 2b                	je     80050f <_main+0x3fe>
  8004e4:	83 f8 61             	cmp    $0x61,%eax
  8004e7:	75 39                	jne    800522 <_main+0x411>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	ff 75 c0             	pushl  -0x40(%ebp)
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 46 04 00 00       	call   80093d <InitializeAscending>
  8004f7:	83 c4 10             	add    $0x10,%esp
		break ;
  8004fa:	eb 37                	jmp    800533 <_main+0x422>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	ff 75 c0             	pushl  -0x40(%ebp)
  800502:	ff 75 c8             	pushl  -0x38(%ebp)
  800505:	e8 64 04 00 00       	call   80096e <InitializeDescending>
  80050a:	83 c4 10             	add    $0x10,%esp
		break ;
  80050d:	eb 24                	jmp    800533 <_main+0x422>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	ff 75 c0             	pushl  -0x40(%ebp)
  800515:	ff 75 c8             	pushl  -0x38(%ebp)
  800518:	e8 86 04 00 00       	call   8009a3 <InitializeSemiRandom>
  80051d:	83 c4 10             	add    $0x10,%esp
		break ;
  800520:	eb 11                	jmp    800533 <_main+0x422>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	ff 75 c0             	pushl  -0x40(%ebp)
  800528:	ff 75 c8             	pushl  -0x38(%ebp)
  80052b:	e8 73 04 00 00       	call   8009a3 <InitializeSemiRandom>
  800530:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i)
  800533:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80053a:	eb 43                	jmp    80057f <_main+0x46e>
	{
#if USE_KERN_SEMAPHORE
	char signalCmd2[64] = "__KSem@0@Signal";
  80053c:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  800542:	bb fe 52 80 00       	mov    $0x8052fe,%ebx
  800547:	ba 04 00 00 00       	mov    $0x4,%edx
  80054c:	89 c7                	mov    %eax,%edi
  80054e:	89 de                	mov    %ebx,%esi
  800550:	89 d1                	mov    %edx,%ecx
  800552:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800554:	8d 95 60 fd ff ff    	lea    -0x2a0(%ebp),%edx
  80055a:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80055f:	b8 00 00 00 00       	mov    $0x0,%eax
  800564:	89 d7                	mov    %edx,%edi
  800566:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd2, 0);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	6a 00                	push   $0x0
  80056d:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	e8 f2 39 00 00       	call   803f6b <sys_utilities>
  800579:	83 c4 10             	add    $0x10,%esp
	default:
		InitializeSemiRandom(Elements, NumOfElements);
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i)
  80057c:	ff 45 e4             	incl   -0x1c(%ebp)
  80057f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800582:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800585:	7c b5                	jl     80053c <_main+0x42b>
	signal_semaphore(ready);
#endif
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i)
  800587:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80058e:	eb 40                	jmp    8005d0 <_main+0x4bf>
	{
#if USE_KERN_SEMAPHORE
	char waitCmd2[64] = "__KSem@1@Wait";
  800590:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  800596:	bb 3e 53 80 00       	mov    $0x80533e,%ebx
  80059b:	ba 0e 00 00 00       	mov    $0xe,%edx
  8005a0:	89 c7                	mov    %eax,%edi
  8005a2:	89 de                	mov    %ebx,%esi
  8005a4:	89 d1                	mov    %edx,%ecx
  8005a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a8:	8d 95 5e fd ff ff    	lea    -0x2a2(%ebp),%edx
  8005ae:	b9 32 00 00 00       	mov    $0x32,%ecx
  8005b3:	b0 00                	mov    $0x0,%al
  8005b5:	89 d7                	mov    %edx,%edi
  8005b7:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd2, 0);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	6a 00                	push   $0x0
  8005be:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  8005c4:	50                   	push   %eax
  8005c5:	e8 a1 39 00 00       	call   803f6b <sys_utilities>
  8005ca:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(ready);
#endif
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i)
  8005cd:	ff 45 e0             	incl   -0x20(%ebp)
  8005d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d6:	7c b8                	jl     800590 <_main+0x47f>
	wait_semaphore(finished);
#endif
	}

	/*[6] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  8005d8:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	int *mergesortedArr = NULL;
  8005df:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	int64 *mean = NULL;
  8005e6:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
	int64 *var = NULL;
  8005ed:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
	int *min = NULL;
  8005f4:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int *max = NULL;
  8005fb:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
	int *med = NULL;
  800602:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	68 70 50 80 00       	push   $0x805070
  800611:	ff 75 d8             	pushl  -0x28(%ebp)
  800614:	e8 36 2e 00 00       	call   80344f <sget>
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	68 7f 50 80 00       	push   $0x80507f
  800627:	ff 75 d4             	pushl  -0x2c(%ebp)
  80062a:	e8 20 2e 00 00       	call   80344f <sget>
  80062f:	83 c4 10             	add    $0x10,%esp
  800632:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	mean = sget(envIdStats, "mean") ;
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	68 8e 50 80 00       	push   $0x80508e
  80063d:	ff 75 d0             	pushl  -0x30(%ebp)
  800640:	e8 0a 2e 00 00       	call   80344f <sget>
  800645:	83 c4 10             	add    $0x10,%esp
  800648:	89 45 b0             	mov    %eax,-0x50(%ebp)
	var = sget(envIdStats,"var") ;
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	68 93 50 80 00       	push   $0x805093
  800653:	ff 75 d0             	pushl  -0x30(%ebp)
  800656:	e8 f4 2d 00 00       	call   80344f <sget>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	89 45 ac             	mov    %eax,-0x54(%ebp)
	min = sget(envIdStats,"min") ;
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	68 97 50 80 00       	push   $0x805097
  800669:	ff 75 d0             	pushl  -0x30(%ebp)
  80066c:	e8 de 2d 00 00       	call   80344f <sget>
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	89 45 a8             	mov    %eax,-0x58(%ebp)
	max = sget(envIdStats,"max") ;
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	68 9b 50 80 00       	push   $0x80509b
  80067f:	ff 75 d0             	pushl  -0x30(%ebp)
  800682:	e8 c8 2d 00 00       	call   80344f <sget>
  800687:	83 c4 10             	add    $0x10,%esp
  80068a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	med = sget(envIdStats,"med") ;
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	68 9f 50 80 00       	push   $0x80509f
  800695:	ff 75 d0             	pushl  -0x30(%ebp)
  800698:	e8 b2 2d 00 00       	call   80344f <sget>
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	89 45 a0             	mov    %eax,-0x60(%ebp)

	/*[7] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	ff 75 c0             	pushl  -0x40(%ebp)
  8006a9:	ff 75 b8             	pushl  -0x48(%ebp)
  8006ac:	e8 35 02 00 00       	call   8008e6 <CheckSorted>
  8006b1:	83 c4 10             	add    $0x10,%esp
  8006b4:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  8006b7:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8006bb:	75 17                	jne    8006d4 <_main+0x5c3>
  8006bd:	83 ec 04             	sub    $0x4,%esp
  8006c0:	68 a4 50 80 00       	push   $0x8050a4
  8006c5:	68 98 00 00 00       	push   $0x98
  8006ca:	68 7e 4f 80 00       	push   $0x804f7e
  8006cf:	e8 57 06 00 00       	call   800d2b <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 c0             	pushl  -0x40(%ebp)
  8006da:	ff 75 b4             	pushl  -0x4c(%ebp)
  8006dd:	e8 04 02 00 00       	call   8008e6 <CheckSorted>
  8006e2:	83 c4 10             	add    $0x10,%esp
  8006e5:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  8006e8:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8006ec:	75 17                	jne    800705 <_main+0x5f4>
  8006ee:	83 ec 04             	sub    $0x4,%esp
  8006f1:	68 cc 50 80 00       	push   $0x8050cc
  8006f6:	68 9a 00 00 00       	push   $0x9a
  8006fb:	68 7e 4f 80 00       	push   $0x804f7e
  800700:	e8 26 06 00 00       	call   800d2b <_panic>
	int64 correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  800705:	8d 85 10 fe ff ff    	lea    -0x1f0(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	8d 85 18 fe ff ff    	lea    -0x1e8(%ebp),%eax
  800712:	50                   	push   %eax
  800713:	ff 75 c0             	pushl  -0x40(%ebp)
  800716:	ff 75 c8             	pushl  -0x38(%ebp)
  800719:	e8 d1 02 00 00       	call   8009ef <ArrayStats>
  80071e:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  800721:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	89 45 98             	mov    %eax,-0x68(%ebp)
	int last = NumOfElements-1;
  800729:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80072c:	48                   	dec    %eax
  80072d:	89 45 94             	mov    %eax,-0x6c(%ebp)
//	int middle = (NumOfElements-1)/2;
//	if (NumOfElements % 2 != 0)
//		middle--;
	int middle = (NumOfElements+1)/2 - 1; /*-1 to make it ZERO-Based*/
  800730:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800733:	40                   	inc    %eax
  800734:	89 c2                	mov    %eax,%edx
  800736:	c1 ea 1f             	shr    $0x1f,%edx
  800739:	01 d0                	add    %edx,%eax
  80073b:	d1 f8                	sar    %eax
  80073d:	48                   	dec    %eax
  80073e:	89 45 90             	mov    %eax,-0x70(%ebp)

	int correctMax = quicksortedArr[last];
  800741:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800744:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80074e:	01 d0                	add    %edx,%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	89 45 8c             	mov    %eax,-0x74(%ebp)
	int correctMed = quicksortedArr[middle];
  800755:	8b 45 90             	mov    -0x70(%ebp),%eax
  800758:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80075f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800762:	01 d0                	add    %edx,%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	89 45 88             	mov    %eax,-0x78(%ebp)
#if USE_KERN_SEMAPHORE
	char waitCmd3[64] = "__KSem@2@Wait";
  800769:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
  80076f:	bb 7e 52 80 00       	mov    $0x80527e,%ebx
  800774:	ba 0e 00 00 00       	mov    $0xe,%edx
  800779:	89 c7                	mov    %eax,%edi
  80077b:	89 de                	mov    %ebx,%esi
  80077d:	89 d1                	mov    %edx,%ecx
  80077f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800781:	8d 95 de fd ff ff    	lea    -0x222(%ebp),%edx
  800787:	b9 32 00 00 00       	mov    $0x32,%ecx
  80078c:	b0 00                	mov    $0x0,%al
  80078e:	89 d7                	mov    %edx,%edi
  800790:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd3, 0);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	6a 00                	push   $0x0
  800797:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
  80079d:	50                   	push   %eax
  80079e:	e8 c8 37 00 00       	call   803f6b <sys_utilities>
  8007a3:	83 c4 10             	add    $0x10,%esp
#else
	wait_semaphore(cons_mutex);
#endif
	{
		//cprintf("Array is correctly sorted\n");
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
  8007a6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	89 85 44 fd ff ff    	mov    %eax,-0x2bc(%ebp)
  8007b1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8007b4:	8b 38                	mov    (%eax),%edi
  8007b6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8007b9:	8b 30                	mov    (%eax),%esi
  8007bb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8007be:	8b 08                	mov    (%eax),%ecx
  8007c0:	8b 58 04             	mov    0x4(%eax),%ebx
  8007c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8007c6:	8b 50 04             	mov    0x4(%eax),%edx
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	ff b5 44 fd ff ff    	pushl  -0x2bc(%ebp)
  8007d1:	57                   	push   %edi
  8007d2:	56                   	push   %esi
  8007d3:	53                   	push   %ebx
  8007d4:	51                   	push   %ecx
  8007d5:	52                   	push   %edx
  8007d6:	50                   	push   %eax
  8007d7:	68 f4 50 80 00       	push   $0x8050f4
  8007dc:	e8 18 08 00 00       	call   800ff9 <cprintf>
  8007e1:	83 c4 20             	add    $0x20,%esp
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);
  8007e4:	8b 8d 10 fe ff ff    	mov    -0x1f0(%ebp),%ecx
  8007ea:	8b 9d 14 fe ff ff    	mov    -0x1ec(%ebp),%ebx
  8007f0:	8b 85 18 fe ff ff    	mov    -0x1e8(%ebp),%eax
  8007f6:	8b 95 1c fe ff ff    	mov    -0x1e4(%ebp),%edx
  8007fc:	ff 75 88             	pushl  -0x78(%ebp)
  8007ff:	ff 75 8c             	pushl  -0x74(%ebp)
  800802:	ff 75 98             	pushl  -0x68(%ebp)
  800805:	53                   	push   %ebx
  800806:	51                   	push   %ecx
  800807:	52                   	push   %edx
  800808:	50                   	push   %eax
  800809:	68 f4 50 80 00       	push   $0x8050f4
  80080e:	e8 e6 07 00 00       	call   800ff9 <cprintf>
  800813:	83 c4 20             	add    $0x20,%esp
	}
#if USE_KERN_SEMAPHORE
	char signalCmd3[64] = "__KSem@2@Signal";
  800816:	8d 85 90 fd ff ff    	lea    -0x270(%ebp),%eax
  80081c:	bb be 52 80 00       	mov    $0x8052be,%ebx
  800821:	ba 04 00 00 00       	mov    $0x4,%edx
  800826:	89 c7                	mov    %eax,%edi
  800828:	89 de                	mov    %ebx,%esi
  80082a:	89 d1                	mov    %edx,%ecx
  80082c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80082e:	8d 95 a0 fd ff ff    	lea    -0x260(%ebp),%edx
  800834:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800839:	b8 00 00 00 00       	mov    $0x0,%eax
  80083e:	89 d7                	mov    %edx,%edi
  800840:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd3, 0);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	6a 00                	push   $0x0
  800847:	8d 85 90 fd ff ff    	lea    -0x270(%ebp),%eax
  80084d:	50                   	push   %eax
  80084e:	e8 18 37 00 00       	call   803f6b <sys_utilities>
  800853:	83 c4 10             	add    $0x10,%esp
#else
	signal_semaphore(cons_mutex);
#endif

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  800856:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800859:	8b 08                	mov    (%eax),%ecx
  80085b:	8b 58 04             	mov    0x4(%eax),%ebx
  80085e:	8b 85 18 fe ff ff    	mov    -0x1e8(%ebp),%eax
  800864:	8b 95 1c fe ff ff    	mov    -0x1e4(%ebp),%edx
  80086a:	89 de                	mov    %ebx,%esi
  80086c:	31 d6                	xor    %edx,%esi
  80086e:	31 c8                	xor    %ecx,%eax
  800870:	09 f0                	or     %esi,%eax
  800872:	85 c0                	test   %eax,%eax
  800874:	75 3e                	jne    8008b4 <_main+0x7a3>
  800876:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800879:	8b 08                	mov    (%eax),%ecx
  80087b:	8b 58 04             	mov    0x4(%eax),%ebx
  80087e:	8b 85 10 fe ff ff    	mov    -0x1f0(%ebp),%eax
  800884:	8b 95 14 fe ff ff    	mov    -0x1ec(%ebp),%edx
  80088a:	89 de                	mov    %ebx,%esi
  80088c:	31 d6                	xor    %edx,%esi
  80088e:	31 c8                	xor    %ecx,%eax
  800890:	09 f0                	or     %esi,%eax
  800892:	85 c0                	test   %eax,%eax
  800894:	75 1e                	jne    8008b4 <_main+0x7a3>
  800896:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800899:	8b 00                	mov    (%eax),%eax
  80089b:	3b 45 98             	cmp    -0x68(%ebp),%eax
  80089e:	75 14                	jne    8008b4 <_main+0x7a3>
  8008a0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	3b 45 8c             	cmp    -0x74(%ebp),%eax
  8008a8:	75 0a                	jne    8008b4 <_main+0x7a3>
  8008aa:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	3b 45 88             	cmp    -0x78(%ebp),%eax
  8008b2:	74 17                	je     8008cb <_main+0x7ba>
		panic("The array STATS are NOT calculated correctly") ;
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	68 2c 51 80 00       	push   $0x80512c
  8008bc:	68 b9 00 00 00       	push   $0xb9
  8008c1:	68 7e 4f 80 00       	push   $0x804f7e
  8008c6:	e8 60 04 00 00       	call   800d2b <_panic>

	cprintf_colored(TEXT_light_green, "Congratulations!! Scenario of Using the Semaphores & Shared Variables completed successfully!!\n\n\n");
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	68 5c 51 80 00       	push   $0x80515c
  8008d3:	6a 0a                	push   $0xa
  8008d5:	e8 4c 07 00 00       	call   801026 <cprintf_colored>
  8008da:	83 c4 10             	add    $0x10,%esp

	return;
  8008dd:	90                   	nop
}
  8008de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e1:	5b                   	pop    %ebx
  8008e2:	5e                   	pop    %esi
  8008e3:	5f                   	pop    %edi
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8008ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8008f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8008fa:	eb 33                	jmp    80092f <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8008fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8008ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	01 d0                	add    %edx,%eax
  80090b:	8b 10                	mov    (%eax),%edx
  80090d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800910:	40                   	inc    %eax
  800911:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	01 c8                	add    %ecx,%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	39 c2                	cmp    %eax,%edx
  800921:	7e 09                	jle    80092c <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800923:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80092a:	eb 0c                	jmp    800938 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80092c:	ff 45 f8             	incl   -0x8(%ebp)
  80092f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800932:	48                   	dec    %eax
  800933:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800936:	7f c4                	jg     8008fc <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800938:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80093b:	c9                   	leave  
  80093c:	c3                   	ret    

0080093d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800943:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80094a:	eb 17                	jmp    800963 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80094c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80094f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	01 c2                	add    %eax,%edx
  80095b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80095e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800960:	ff 45 fc             	incl   -0x4(%ebp)
  800963:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800966:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800969:	7c e1                	jl     80094c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}
}
  80096b:	90                   	nop
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    

0080096e <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800974:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80097b:	eb 1b                	jmp    800998 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80097d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800980:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	01 c2                	add    %eax,%edx
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800992:	48                   	dec    %eax
  800993:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800995:	ff 45 fc             	incl   -0x4(%ebp)
  800998:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80099b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80099e:	7c dd                	jl     80097d <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8009a0:	90                   	nop
  8009a1:	c9                   	leave  
  8009a2:	c3                   	ret    

008009a3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8009a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ac:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8009b1:	f7 e9                	imul   %ecx
  8009b3:	c1 f9 1f             	sar    $0x1f,%ecx
  8009b6:	89 d0                	mov    %edx,%eax
  8009b8:	29 c8                	sub    %ecx,%eax
  8009ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8009bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009c4:	eb 1e                	jmp    8009e4 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8009c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8009d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009d9:	99                   	cltd   
  8009da:	f7 7d f8             	idivl  -0x8(%ebp)
  8009dd:	89 d0                	mov    %edx,%eax
  8009df:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8009e1:	ff 45 fc             	incl   -0x4(%ebp)
  8009e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009ea:	7c da                	jl     8009c6 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8009ec:	90                   	nop
  8009ed:	c9                   	leave  
  8009ee:	c3                   	ret    

008009ef <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	57                   	push   %edi
  8009f3:	56                   	push   %esi
  8009f4:	53                   	push   %ebx
  8009f5:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  8009f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800a01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800a08:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800a0f:	eb 29                	jmp    800a3a <ArrayStats+0x4b>
	{
		*mean += Elements[i];
  800a11:	8b 45 10             	mov    0x10(%ebp),%eax
  800a14:	8b 08                	mov    (%eax),%ecx
  800a16:	8b 58 04             	mov    0x4(%eax),%ebx
  800a19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	01 d0                	add    %edx,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	99                   	cltd   
  800a2b:	01 c8                	add    %ecx,%eax
  800a2d:	11 da                	adc    %ebx,%edx
  800a2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a32:	89 01                	mov    %eax,(%ecx)
  800a34:	89 51 04             	mov    %edx,0x4(%ecx)

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800a37:	ff 45 e4             	incl   -0x1c(%ebp)
  800a3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a3d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a40:	7c cf                	jl     800a11 <ArrayStats+0x22>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  800a42:	8b 45 10             	mov    0x10(%ebp),%eax
  800a45:	8b 50 04             	mov    0x4(%eax),%edx
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a4d:	89 cb                	mov    %ecx,%ebx
  800a4f:	c1 fb 1f             	sar    $0x1f,%ebx
  800a52:	53                   	push   %ebx
  800a53:	51                   	push   %ecx
  800a54:	52                   	push   %edx
  800a55:	50                   	push   %eax
  800a56:	e8 0d 41 00 00       	call   804b68 <__divdi3>
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a61:	89 01                	mov    %eax,(%ecx)
  800a63:	89 51 04             	mov    %edx,0x4(%ecx)
	*var = 0;
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800a6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800a76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800a7d:	eb 7e                	jmp    800afd <ArrayStats+0x10e>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	8b 50 04             	mov    0x4(%eax),%edx
  800a85:	8b 00                	mov    (%eax),%eax
  800a87:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a8a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	01 d0                	add    %edx,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	89 c1                	mov    %eax,%ecx
  800aa0:	89 c3                	mov    %eax,%ebx
  800aa2:	c1 fb 1f             	sar    $0x1f,%ebx
  800aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa8:	8b 50 04             	mov    0x4(%eax),%edx
  800aab:	8b 00                	mov    (%eax),%eax
  800aad:	29 c1                	sub    %eax,%ecx
  800aaf:	19 d3                	sbb    %edx,%ebx
  800ab1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ab4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	01 d0                	add    %edx,%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	89 c6                	mov    %eax,%esi
  800ac4:	89 c7                	mov    %eax,%edi
  800ac6:	c1 ff 1f             	sar    $0x1f,%edi
  800ac9:	8b 45 10             	mov    0x10(%ebp),%eax
  800acc:	8b 50 04             	mov    0x4(%eax),%edx
  800acf:	8b 00                	mov    (%eax),%eax
  800ad1:	29 c6                	sub    %eax,%esi
  800ad3:	19 d7                	sbb    %edx,%edi
  800ad5:	89 f0                	mov    %esi,%eax
  800ad7:	89 fa                	mov    %edi,%edx
  800ad9:	89 df                	mov    %ebx,%edi
  800adb:	0f af f8             	imul   %eax,%edi
  800ade:	89 d6                	mov    %edx,%esi
  800ae0:	0f af f1             	imul   %ecx,%esi
  800ae3:	01 fe                	add    %edi,%esi
  800ae5:	f7 e1                	mul    %ecx
  800ae7:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  800aea:	89 ca                	mov    %ecx,%edx
  800aec:	03 45 d0             	add    -0x30(%ebp),%eax
  800aef:	13 55 d4             	adc    -0x2c(%ebp),%edx
  800af2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800af5:	89 01                	mov    %eax,(%ecx)
  800af7:	89 51 04             	mov    %edx,0x4(%ecx)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  800afa:	ff 45 e4             	incl   -0x1c(%ebp)
  800afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b00:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b03:	0f 8c 76 ff ff ff    	jl     800a7f <ArrayStats+0x90>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
//		if (i%1000 == 0)
//			cprintf("current #elements = %d, current var = %lld\n", i , *var);
	}
	*var /= NumOfElements;
  800b09:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0c:	8b 50 04             	mov    0x4(%eax),%edx
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b14:	89 cb                	mov    %ecx,%ebx
  800b16:	c1 fb 1f             	sar    $0x1f,%ebx
  800b19:	53                   	push   %ebx
  800b1a:	51                   	push   %ecx
  800b1b:	52                   	push   %edx
  800b1c:	50                   	push   %eax
  800b1d:	e8 46 40 00 00       	call   804b68 <__divdi3>
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800b28:	89 01                	mov    %eax,(%ecx)
  800b2a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  800b2d:	90                   	nop
  800b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b31:	5b                   	pop    %ebx
  800b32:	5e                   	pop    %esi
  800b33:	5f                   	pop    %edi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800b42:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800b46:	83 ec 0c             	sub    $0xc,%esp
  800b49:	50                   	push   %eax
  800b4a:	e8 b5 30 00 00       	call   803c04 <sys_cputc>
  800b4f:	83 c4 10             	add    $0x10,%esp
}
  800b52:	90                   	nop
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <getchar>:


int
getchar(void)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800b5b:	e8 43 2f 00 00       	call   803aa3 <sys_cgetc>
  800b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b66:	c9                   	leave  
  800b67:	c3                   	ret    

00800b68 <iscons>:

int iscons(int fdnum)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800b6b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	57                   	push   %edi
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
  800b78:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800b7b:	e8 b5 31 00 00       	call   803d35 <sys_getenvindex>
  800b80:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800b83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b86:	89 d0                	mov    %edx,%eax
  800b88:	c1 e0 02             	shl    $0x2,%eax
  800b8b:	01 d0                	add    %edx,%eax
  800b8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b94:	01 d0                	add    %edx,%eax
  800b96:	89 c2                	mov    %eax,%edx
  800b98:	c1 e2 04             	shl    $0x4,%edx
  800b9b:	29 c2                	sub    %eax,%edx
  800b9d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800bac:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800bb1:	a1 20 60 80 00       	mov    0x806020,%eax
  800bb6:	8a 40 20             	mov    0x20(%eax),%al
  800bb9:	84 c0                	test   %al,%al
  800bbb:	74 0d                	je     800bca <libmain+0x58>
		binaryname = myEnv->prog_name;
  800bbd:	a1 20 60 80 00       	mov    0x806020,%eax
  800bc2:	83 c0 20             	add    $0x20,%eax
  800bc5:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bce:	7e 0a                	jle    800bda <libmain+0x68>
		binaryname = argv[0];
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	8b 00                	mov    (%eax),%eax
  800bd5:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 29 f5 ff ff       	call   800111 <_main>
  800be8:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800beb:	a1 00 60 80 00       	mov    0x806000,%eax
  800bf0:	85 c0                	test   %eax,%eax
  800bf2:	0f 84 01 01 00 00    	je     800cf9 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800bf8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800bfe:	bb 78 54 80 00       	mov    $0x805478,%ebx
  800c03:	ba 0e 00 00 00       	mov    $0xe,%edx
  800c08:	89 c7                	mov    %eax,%edi
  800c0a:	89 de                	mov    %ebx,%esi
  800c0c:	89 d1                	mov    %edx,%ecx
  800c0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800c10:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800c13:	b9 56 00 00 00       	mov    $0x56,%ecx
  800c18:	b0 00                	mov    $0x0,%al
  800c1a:	89 d7                	mov    %edx,%edi
  800c1c:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800c1e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800c25:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800c28:	83 ec 08             	sub    $0x8,%esp
  800c2b:	50                   	push   %eax
  800c2c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800c32:	50                   	push   %eax
  800c33:	e8 33 33 00 00       	call   803f6b <sys_utilities>
  800c38:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800c3b:	e8 7c 2e 00 00       	call   803abc <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800c40:	83 ec 0c             	sub    $0xc,%esp
  800c43:	68 98 53 80 00       	push   $0x805398
  800c48:	e8 ac 03 00 00       	call   800ff9 <cprintf>
  800c4d:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800c50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c53:	85 c0                	test   %eax,%eax
  800c55:	74 18                	je     800c6f <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800c57:	e8 2d 33 00 00       	call   803f89 <sys_get_optimal_num_faults>
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	50                   	push   %eax
  800c60:	68 c0 53 80 00       	push   $0x8053c0
  800c65:	e8 8f 03 00 00       	call   800ff9 <cprintf>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	eb 59                	jmp    800cc8 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c6f:	a1 20 60 80 00       	mov    0x806020,%eax
  800c74:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800c7a:	a1 20 60 80 00       	mov    0x806020,%eax
  800c7f:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800c85:	83 ec 04             	sub    $0x4,%esp
  800c88:	52                   	push   %edx
  800c89:	50                   	push   %eax
  800c8a:	68 e4 53 80 00       	push   $0x8053e4
  800c8f:	e8 65 03 00 00       	call   800ff9 <cprintf>
  800c94:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c97:	a1 20 60 80 00       	mov    0x806020,%eax
  800c9c:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800ca2:	a1 20 60 80 00       	mov    0x806020,%eax
  800ca7:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800cad:	a1 20 60 80 00       	mov    0x806020,%eax
  800cb2:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800cb8:	51                   	push   %ecx
  800cb9:	52                   	push   %edx
  800cba:	50                   	push   %eax
  800cbb:	68 0c 54 80 00       	push   $0x80540c
  800cc0:	e8 34 03 00 00       	call   800ff9 <cprintf>
  800cc5:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800cc8:	a1 20 60 80 00       	mov    0x806020,%eax
  800ccd:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	50                   	push   %eax
  800cd7:	68 64 54 80 00       	push   $0x805464
  800cdc:	e8 18 03 00 00       	call   800ff9 <cprintf>
  800ce1:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800ce4:	83 ec 0c             	sub    $0xc,%esp
  800ce7:	68 98 53 80 00       	push   $0x805398
  800cec:	e8 08 03 00 00       	call   800ff9 <cprintf>
  800cf1:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800cf4:	e8 dd 2d 00 00       	call   803ad6 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800cf9:	e8 1f 00 00 00       	call   800d1d <exit>
}
  800cfe:	90                   	nop
  800cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d0d:	83 ec 0c             	sub    $0xc,%esp
  800d10:	6a 00                	push   $0x0
  800d12:	e8 ea 2f 00 00       	call   803d01 <sys_destroy_env>
  800d17:	83 c4 10             	add    $0x10,%esp
}
  800d1a:	90                   	nop
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <exit>:

void
exit(void)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d23:	e8 3f 30 00 00       	call   803d67 <sys_exit_env>
}
  800d28:	90                   	nop
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d31:	8d 45 10             	lea    0x10(%ebp),%eax
  800d34:	83 c0 04             	add    $0x4,%eax
  800d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d3a:	a1 18 e1 81 00       	mov    0x81e118,%eax
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	74 16                	je     800d59 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d43:	a1 18 e1 81 00       	mov    0x81e118,%eax
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	50                   	push   %eax
  800d4c:	68 dc 54 80 00       	push   $0x8054dc
  800d51:	e8 a3 02 00 00       	call   800ff9 <cprintf>
  800d56:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800d59:	a1 04 60 80 00       	mov    0x806004,%eax
  800d5e:	83 ec 0c             	sub    $0xc,%esp
  800d61:	ff 75 0c             	pushl  0xc(%ebp)
  800d64:	ff 75 08             	pushl  0x8(%ebp)
  800d67:	50                   	push   %eax
  800d68:	68 e4 54 80 00       	push   $0x8054e4
  800d6d:	6a 74                	push   $0x74
  800d6f:	e8 b2 02 00 00       	call   801026 <cprintf_colored>
  800d74:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800d77:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7a:	83 ec 08             	sub    $0x8,%esp
  800d7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d80:	50                   	push   %eax
  800d81:	e8 04 02 00 00       	call   800f8a <vcprintf>
  800d86:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d89:	83 ec 08             	sub    $0x8,%esp
  800d8c:	6a 00                	push   $0x0
  800d8e:	68 0c 55 80 00       	push   $0x80550c
  800d93:	e8 f2 01 00 00       	call   800f8a <vcprintf>
  800d98:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d9b:	e8 7d ff ff ff       	call   800d1d <exit>

	// should not return here
	while (1) ;
  800da0:	eb fe                	jmp    800da0 <_panic+0x75>

00800da2 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800da8:	a1 20 60 80 00       	mov    0x806020,%eax
  800dad:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	39 c2                	cmp    %eax,%edx
  800db8:	74 14                	je     800dce <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800dba:	83 ec 04             	sub    $0x4,%esp
  800dbd:	68 10 55 80 00       	push   $0x805510
  800dc2:	6a 26                	push   $0x26
  800dc4:	68 5c 55 80 00       	push   $0x80555c
  800dc9:	e8 5d ff ff ff       	call   800d2b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800dd5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ddc:	e9 c5 00 00 00       	jmp    800ea6 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	01 d0                	add    %edx,%eax
  800df0:	8b 00                	mov    (%eax),%eax
  800df2:	85 c0                	test   %eax,%eax
  800df4:	75 08                	jne    800dfe <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800df6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800df9:	e9 a5 00 00 00       	jmp    800ea3 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800dfe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e0c:	eb 69                	jmp    800e77 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e0e:	a1 20 60 80 00       	mov    0x806020,%eax
  800e13:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800e19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	01 c0                	add    %eax,%eax
  800e20:	01 d0                	add    %edx,%eax
  800e22:	c1 e0 03             	shl    $0x3,%eax
  800e25:	01 c8                	add    %ecx,%eax
  800e27:	8a 40 04             	mov    0x4(%eax),%al
  800e2a:	84 c0                	test   %al,%al
  800e2c:	75 46                	jne    800e74 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e2e:	a1 20 60 80 00       	mov    0x806020,%eax
  800e33:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800e39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e3c:	89 d0                	mov    %edx,%eax
  800e3e:	01 c0                	add    %eax,%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	c1 e0 03             	shl    $0x3,%eax
  800e45:	01 c8                	add    %ecx,%eax
  800e47:	8b 00                	mov    (%eax),%eax
  800e49:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e54:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e59:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	01 c8                	add    %ecx,%eax
  800e65:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e67:	39 c2                	cmp    %eax,%edx
  800e69:	75 09                	jne    800e74 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800e6b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e72:	eb 15                	jmp    800e89 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e74:	ff 45 e8             	incl   -0x18(%ebp)
  800e77:	a1 20 60 80 00       	mov    0x806020,%eax
  800e7c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800e82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e85:	39 c2                	cmp    %eax,%edx
  800e87:	77 85                	ja     800e0e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e89:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e8d:	75 14                	jne    800ea3 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	68 68 55 80 00       	push   $0x805568
  800e97:	6a 3a                	push   $0x3a
  800e99:	68 5c 55 80 00       	push   $0x80555c
  800e9e:	e8 88 fe ff ff       	call   800d2b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ea3:	ff 45 f0             	incl   -0x10(%ebp)
  800ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800eac:	0f 8c 2f ff ff ff    	jl     800de1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800eb2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800eb9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ec0:	eb 26                	jmp    800ee8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ec2:	a1 20 60 80 00       	mov    0x806020,%eax
  800ec7:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800ecd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	01 c0                	add    %eax,%eax
  800ed4:	01 d0                	add    %edx,%eax
  800ed6:	c1 e0 03             	shl    $0x3,%eax
  800ed9:	01 c8                	add    %ecx,%eax
  800edb:	8a 40 04             	mov    0x4(%eax),%al
  800ede:	3c 01                	cmp    $0x1,%al
  800ee0:	75 03                	jne    800ee5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800ee2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ee5:	ff 45 e0             	incl   -0x20(%ebp)
  800ee8:	a1 20 60 80 00       	mov    0x806020,%eax
  800eed:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800ef3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ef6:	39 c2                	cmp    %eax,%edx
  800ef8:	77 c8                	ja     800ec2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800efd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800f00:	74 14                	je     800f16 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800f02:	83 ec 04             	sub    $0x4,%esp
  800f05:	68 bc 55 80 00       	push   $0x8055bc
  800f0a:	6a 44                	push   $0x44
  800f0c:	68 5c 55 80 00       	push   $0x80555c
  800f11:	e8 15 fe ff ff       	call   800d2b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f16:	90                   	nop
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	53                   	push   %ebx
  800f1d:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f23:	8b 00                	mov    (%eax),%eax
  800f25:	8d 48 01             	lea    0x1(%eax),%ecx
  800f28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2b:	89 0a                	mov    %ecx,(%edx)
  800f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f30:	88 d1                	mov    %dl,%cl
  800f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f35:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	8b 00                	mov    (%eax),%eax
  800f3e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f43:	75 30                	jne    800f75 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800f45:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800f4b:	a0 44 60 80 00       	mov    0x806044,%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f56:	8b 09                	mov    (%ecx),%ecx
  800f58:	89 cb                	mov    %ecx,%ebx
  800f5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5d:	83 c1 08             	add    $0x8,%ecx
  800f60:	52                   	push   %edx
  800f61:	50                   	push   %eax
  800f62:	53                   	push   %ebx
  800f63:	51                   	push   %ecx
  800f64:	e8 0f 2b 00 00       	call   803a78 <sys_cputs>
  800f69:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	8b 40 04             	mov    0x4(%eax),%eax
  800f7b:	8d 50 01             	lea    0x1(%eax),%edx
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f84:	90                   	nop
  800f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f93:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f9a:	00 00 00 
	b.cnt = 0;
  800f9d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800fa4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800fa7:	ff 75 0c             	pushl  0xc(%ebp)
  800faa:	ff 75 08             	pushl  0x8(%ebp)
  800fad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fb3:	50                   	push   %eax
  800fb4:	68 19 0f 80 00       	push   $0x800f19
  800fb9:	e8 5a 02 00 00       	call   801218 <vprintfmt>
  800fbe:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800fc1:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800fc7:	a0 44 60 80 00       	mov    0x806044,%al
  800fcc:	0f b6 c0             	movzbl %al,%eax
  800fcf:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800fd5:	52                   	push   %edx
  800fd6:	50                   	push   %eax
  800fd7:	51                   	push   %ecx
  800fd8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fde:	83 c0 08             	add    $0x8,%eax
  800fe1:	50                   	push   %eax
  800fe2:	e8 91 2a 00 00       	call   803a78 <sys_cputs>
  800fe7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fea:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800ff1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ff7:	c9                   	leave  
  800ff8:	c3                   	ret    

00800ff9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800fff:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  801006:	8d 45 0c             	lea    0xc(%ebp),%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	83 ec 08             	sub    $0x8,%esp
  801012:	ff 75 f4             	pushl  -0xc(%ebp)
  801015:	50                   	push   %eax
  801016:	e8 6f ff ff ff       	call   800f8a <vcprintf>
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801021:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80102c:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	c1 e0 08             	shl    $0x8,%eax
  801039:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  80103e:	8d 45 0c             	lea    0xc(%ebp),%eax
  801041:	83 c0 04             	add    $0x4,%eax
  801044:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	83 ec 08             	sub    $0x8,%esp
  80104d:	ff 75 f4             	pushl  -0xc(%ebp)
  801050:	50                   	push   %eax
  801051:	e8 34 ff ff ff       	call   800f8a <vcprintf>
  801056:	83 c4 10             	add    $0x10,%esp
  801059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80105c:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  801063:	07 00 00 

	return cnt;
  801066:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801071:	e8 46 2a 00 00       	call   803abc <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801076:	8d 45 0c             	lea    0xc(%ebp),%eax
  801079:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	83 ec 08             	sub    $0x8,%esp
  801082:	ff 75 f4             	pushl  -0xc(%ebp)
  801085:	50                   	push   %eax
  801086:	e8 ff fe ff ff       	call   800f8a <vcprintf>
  80108b:	83 c4 10             	add    $0x10,%esp
  80108e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801091:	e8 40 2a 00 00       	call   803ad6 <sys_unlock_cons>
	return cnt;
  801096:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	53                   	push   %ebx
  80109f:	83 ec 14             	sub    $0x14,%esp
  8010a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8010ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8010b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8010b9:	77 55                	ja     801110 <printnum+0x75>
  8010bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8010be:	72 05                	jb     8010c5 <printnum+0x2a>
  8010c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010c3:	77 4b                	ja     801110 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8010c5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8010c8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8010cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8010ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d3:	52                   	push   %edx
  8010d4:	50                   	push   %eax
  8010d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8010d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8010db:	e8 f0 3b 00 00       	call   804cd0 <__udivdi3>
  8010e0:	83 c4 10             	add    $0x10,%esp
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	ff 75 20             	pushl  0x20(%ebp)
  8010e9:	53                   	push   %ebx
  8010ea:	ff 75 18             	pushl  0x18(%ebp)
  8010ed:	52                   	push   %edx
  8010ee:	50                   	push   %eax
  8010ef:	ff 75 0c             	pushl  0xc(%ebp)
  8010f2:	ff 75 08             	pushl  0x8(%ebp)
  8010f5:	e8 a1 ff ff ff       	call   80109b <printnum>
  8010fa:	83 c4 20             	add    $0x20,%esp
  8010fd:	eb 1a                	jmp    801119 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8010ff:	83 ec 08             	sub    $0x8,%esp
  801102:	ff 75 0c             	pushl  0xc(%ebp)
  801105:	ff 75 20             	pushl  0x20(%ebp)
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	ff d0                	call   *%eax
  80110d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801110:	ff 4d 1c             	decl   0x1c(%ebp)
  801113:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801117:	7f e6                	jg     8010ff <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801119:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80111c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801127:	53                   	push   %ebx
  801128:	51                   	push   %ecx
  801129:	52                   	push   %edx
  80112a:	50                   	push   %eax
  80112b:	e8 b0 3c 00 00       	call   804de0 <__umoddi3>
  801130:	83 c4 10             	add    $0x10,%esp
  801133:	05 34 58 80 00       	add    $0x805834,%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	0f be c0             	movsbl %al,%eax
  80113d:	83 ec 08             	sub    $0x8,%esp
  801140:	ff 75 0c             	pushl  0xc(%ebp)
  801143:	50                   	push   %eax
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	ff d0                	call   *%eax
  801149:	83 c4 10             	add    $0x10,%esp
}
  80114c:	90                   	nop
  80114d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801155:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801159:	7e 1c                	jle    801177 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8b 00                	mov    (%eax),%eax
  801160:	8d 50 08             	lea    0x8(%eax),%edx
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	89 10                	mov    %edx,(%eax)
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8b 00                	mov    (%eax),%eax
  80116d:	83 e8 08             	sub    $0x8,%eax
  801170:	8b 50 04             	mov    0x4(%eax),%edx
  801173:	8b 00                	mov    (%eax),%eax
  801175:	eb 40                	jmp    8011b7 <getuint+0x65>
	else if (lflag)
  801177:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117b:	74 1e                	je     80119b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	8d 50 04             	lea    0x4(%eax),%edx
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	89 10                	mov    %edx,(%eax)
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8b 00                	mov    (%eax),%eax
  80118f:	83 e8 04             	sub    $0x4,%eax
  801192:	8b 00                	mov    (%eax),%eax
  801194:	ba 00 00 00 00       	mov    $0x0,%edx
  801199:	eb 1c                	jmp    8011b7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8b 00                	mov    (%eax),%eax
  8011a0:	8d 50 04             	lea    0x4(%eax),%edx
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	89 10                	mov    %edx,(%eax)
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8b 00                	mov    (%eax),%eax
  8011ad:	83 e8 04             	sub    $0x4,%eax
  8011b0:	8b 00                	mov    (%eax),%eax
  8011b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    

008011b9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8011c0:	7e 1c                	jle    8011de <getint+0x25>
		return va_arg(*ap, long long);
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8b 00                	mov    (%eax),%eax
  8011c7:	8d 50 08             	lea    0x8(%eax),%edx
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	89 10                	mov    %edx,(%eax)
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8b 00                	mov    (%eax),%eax
  8011d4:	83 e8 08             	sub    $0x8,%eax
  8011d7:	8b 50 04             	mov    0x4(%eax),%edx
  8011da:	8b 00                	mov    (%eax),%eax
  8011dc:	eb 38                	jmp    801216 <getint+0x5d>
	else if (lflag)
  8011de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e2:	74 1a                	je     8011fe <getint+0x45>
		return va_arg(*ap, long);
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8b 00                	mov    (%eax),%eax
  8011e9:	8d 50 04             	lea    0x4(%eax),%edx
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	89 10                	mov    %edx,(%eax)
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8b 00                	mov    (%eax),%eax
  8011f6:	83 e8 04             	sub    $0x4,%eax
  8011f9:	8b 00                	mov    (%eax),%eax
  8011fb:	99                   	cltd   
  8011fc:	eb 18                	jmp    801216 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	8b 00                	mov    (%eax),%eax
  801203:	8d 50 04             	lea    0x4(%eax),%edx
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	89 10                	mov    %edx,(%eax)
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8b 00                	mov    (%eax),%eax
  801210:	83 e8 04             	sub    $0x4,%eax
  801213:	8b 00                	mov    (%eax),%eax
  801215:	99                   	cltd   
}
  801216:	5d                   	pop    %ebp
  801217:	c3                   	ret    

00801218 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	56                   	push   %esi
  80121c:	53                   	push   %ebx
  80121d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801220:	eb 17                	jmp    801239 <vprintfmt+0x21>
			if (ch == '\0')
  801222:	85 db                	test   %ebx,%ebx
  801224:	0f 84 c1 03 00 00    	je     8015eb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80122a:	83 ec 08             	sub    $0x8,%esp
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	53                   	push   %ebx
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	ff d0                	call   *%eax
  801236:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801239:	8b 45 10             	mov    0x10(%ebp),%eax
  80123c:	8d 50 01             	lea    0x1(%eax),%edx
  80123f:	89 55 10             	mov    %edx,0x10(%ebp)
  801242:	8a 00                	mov    (%eax),%al
  801244:	0f b6 d8             	movzbl %al,%ebx
  801247:	83 fb 25             	cmp    $0x25,%ebx
  80124a:	75 d6                	jne    801222 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80124c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801250:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801257:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80125e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801265:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	8d 50 01             	lea    0x1(%eax),%edx
  801272:	89 55 10             	mov    %edx,0x10(%ebp)
  801275:	8a 00                	mov    (%eax),%al
  801277:	0f b6 d8             	movzbl %al,%ebx
  80127a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80127d:	83 f8 5b             	cmp    $0x5b,%eax
  801280:	0f 87 3d 03 00 00    	ja     8015c3 <vprintfmt+0x3ab>
  801286:	8b 04 85 58 58 80 00 	mov    0x805858(,%eax,4),%eax
  80128d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80128f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801293:	eb d7                	jmp    80126c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801295:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801299:	eb d1                	jmp    80126c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80129b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8012a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8012a5:	89 d0                	mov    %edx,%eax
  8012a7:	c1 e0 02             	shl    $0x2,%eax
  8012aa:	01 d0                	add    %edx,%eax
  8012ac:	01 c0                	add    %eax,%eax
  8012ae:	01 d8                	add    %ebx,%eax
  8012b0:	83 e8 30             	sub    $0x30,%eax
  8012b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8012be:	83 fb 2f             	cmp    $0x2f,%ebx
  8012c1:	7e 3e                	jle    801301 <vprintfmt+0xe9>
  8012c3:	83 fb 39             	cmp    $0x39,%ebx
  8012c6:	7f 39                	jg     801301 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012c8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012cb:	eb d5                	jmp    8012a2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 c0 04             	add    $0x4,%eax
  8012d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	83 e8 04             	sub    $0x4,%eax
  8012dc:	8b 00                	mov    (%eax),%eax
  8012de:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8012e1:	eb 1f                	jmp    801302 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8012e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012e7:	79 83                	jns    80126c <vprintfmt+0x54>
				width = 0;
  8012e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8012f0:	e9 77 ff ff ff       	jmp    80126c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8012f5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8012fc:	e9 6b ff ff ff       	jmp    80126c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801301:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801302:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801306:	0f 89 60 ff ff ff    	jns    80126c <vprintfmt+0x54>
				width = precision, precision = -1;
  80130c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80130f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801312:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801319:	e9 4e ff ff ff       	jmp    80126c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80131e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801321:	e9 46 ff ff ff       	jmp    80126c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801326:	8b 45 14             	mov    0x14(%ebp),%eax
  801329:	83 c0 04             	add    $0x4,%eax
  80132c:	89 45 14             	mov    %eax,0x14(%ebp)
  80132f:	8b 45 14             	mov    0x14(%ebp),%eax
  801332:	83 e8 04             	sub    $0x4,%eax
  801335:	8b 00                	mov    (%eax),%eax
  801337:	83 ec 08             	sub    $0x8,%esp
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	50                   	push   %eax
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	ff d0                	call   *%eax
  801343:	83 c4 10             	add    $0x10,%esp
			break;
  801346:	e9 9b 02 00 00       	jmp    8015e6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	83 c0 04             	add    $0x4,%eax
  801351:	89 45 14             	mov    %eax,0x14(%ebp)
  801354:	8b 45 14             	mov    0x14(%ebp),%eax
  801357:	83 e8 04             	sub    $0x4,%eax
  80135a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80135c:	85 db                	test   %ebx,%ebx
  80135e:	79 02                	jns    801362 <vprintfmt+0x14a>
				err = -err;
  801360:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801362:	83 fb 64             	cmp    $0x64,%ebx
  801365:	7f 0b                	jg     801372 <vprintfmt+0x15a>
  801367:	8b 34 9d a0 56 80 00 	mov    0x8056a0(,%ebx,4),%esi
  80136e:	85 f6                	test   %esi,%esi
  801370:	75 19                	jne    80138b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801372:	53                   	push   %ebx
  801373:	68 45 58 80 00       	push   $0x805845
  801378:	ff 75 0c             	pushl  0xc(%ebp)
  80137b:	ff 75 08             	pushl  0x8(%ebp)
  80137e:	e8 70 02 00 00       	call   8015f3 <printfmt>
  801383:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801386:	e9 5b 02 00 00       	jmp    8015e6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80138b:	56                   	push   %esi
  80138c:	68 4e 58 80 00       	push   $0x80584e
  801391:	ff 75 0c             	pushl  0xc(%ebp)
  801394:	ff 75 08             	pushl  0x8(%ebp)
  801397:	e8 57 02 00 00       	call   8015f3 <printfmt>
  80139c:	83 c4 10             	add    $0x10,%esp
			break;
  80139f:	e9 42 02 00 00       	jmp    8015e6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8013a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a7:	83 c0 04             	add    $0x4,%eax
  8013aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8013ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b0:	83 e8 04             	sub    $0x4,%eax
  8013b3:	8b 30                	mov    (%eax),%esi
  8013b5:	85 f6                	test   %esi,%esi
  8013b7:	75 05                	jne    8013be <vprintfmt+0x1a6>
				p = "(null)";
  8013b9:	be 51 58 80 00       	mov    $0x805851,%esi
			if (width > 0 && padc != '-')
  8013be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013c2:	7e 6d                	jle    801431 <vprintfmt+0x219>
  8013c4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8013c8:	74 67                	je     801431 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013cd:	83 ec 08             	sub    $0x8,%esp
  8013d0:	50                   	push   %eax
  8013d1:	56                   	push   %esi
  8013d2:	e8 26 05 00 00       	call   8018fd <strnlen>
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8013dd:	eb 16                	jmp    8013f5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8013df:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8013e3:	83 ec 08             	sub    $0x8,%esp
  8013e6:	ff 75 0c             	pushl  0xc(%ebp)
  8013e9:	50                   	push   %eax
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	ff d0                	call   *%eax
  8013ef:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013f2:	ff 4d e4             	decl   -0x1c(%ebp)
  8013f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013f9:	7f e4                	jg     8013df <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013fb:	eb 34                	jmp    801431 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8013fd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801401:	74 1c                	je     80141f <vprintfmt+0x207>
  801403:	83 fb 1f             	cmp    $0x1f,%ebx
  801406:	7e 05                	jle    80140d <vprintfmt+0x1f5>
  801408:	83 fb 7e             	cmp    $0x7e,%ebx
  80140b:	7e 12                	jle    80141f <vprintfmt+0x207>
					putch('?', putdat);
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	ff 75 0c             	pushl  0xc(%ebp)
  801413:	6a 3f                	push   $0x3f
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	ff d0                	call   *%eax
  80141a:	83 c4 10             	add    $0x10,%esp
  80141d:	eb 0f                	jmp    80142e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80141f:	83 ec 08             	sub    $0x8,%esp
  801422:	ff 75 0c             	pushl  0xc(%ebp)
  801425:	53                   	push   %ebx
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	ff d0                	call   *%eax
  80142b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80142e:	ff 4d e4             	decl   -0x1c(%ebp)
  801431:	89 f0                	mov    %esi,%eax
  801433:	8d 70 01             	lea    0x1(%eax),%esi
  801436:	8a 00                	mov    (%eax),%al
  801438:	0f be d8             	movsbl %al,%ebx
  80143b:	85 db                	test   %ebx,%ebx
  80143d:	74 24                	je     801463 <vprintfmt+0x24b>
  80143f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801443:	78 b8                	js     8013fd <vprintfmt+0x1e5>
  801445:	ff 4d e0             	decl   -0x20(%ebp)
  801448:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80144c:	79 af                	jns    8013fd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80144e:	eb 13                	jmp    801463 <vprintfmt+0x24b>
				putch(' ', putdat);
  801450:	83 ec 08             	sub    $0x8,%esp
  801453:	ff 75 0c             	pushl  0xc(%ebp)
  801456:	6a 20                	push   $0x20
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	ff d0                	call   *%eax
  80145d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801460:	ff 4d e4             	decl   -0x1c(%ebp)
  801463:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801467:	7f e7                	jg     801450 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801469:	e9 78 01 00 00       	jmp    8015e6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80146e:	83 ec 08             	sub    $0x8,%esp
  801471:	ff 75 e8             	pushl  -0x18(%ebp)
  801474:	8d 45 14             	lea    0x14(%ebp),%eax
  801477:	50                   	push   %eax
  801478:	e8 3c fd ff ff       	call   8011b9 <getint>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801483:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801489:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80148c:	85 d2                	test   %edx,%edx
  80148e:	79 23                	jns    8014b3 <vprintfmt+0x29b>
				putch('-', putdat);
  801490:	83 ec 08             	sub    $0x8,%esp
  801493:	ff 75 0c             	pushl  0xc(%ebp)
  801496:	6a 2d                	push   $0x2d
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	ff d0                	call   *%eax
  80149d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8014a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a6:	f7 d8                	neg    %eax
  8014a8:	83 d2 00             	adc    $0x0,%edx
  8014ab:	f7 da                	neg    %edx
  8014ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8014b3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8014ba:	e9 bc 00 00 00       	jmp    80157b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8014bf:	83 ec 08             	sub    $0x8,%esp
  8014c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8014c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8014c8:	50                   	push   %eax
  8014c9:	e8 84 fc ff ff       	call   801152 <getuint>
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8014d7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8014de:	e9 98 00 00 00       	jmp    80157b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8014e3:	83 ec 08             	sub    $0x8,%esp
  8014e6:	ff 75 0c             	pushl  0xc(%ebp)
  8014e9:	6a 58                	push   $0x58
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	ff d0                	call   *%eax
  8014f0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	ff 75 0c             	pushl  0xc(%ebp)
  8014f9:	6a 58                	push   $0x58
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	ff d0                	call   *%eax
  801500:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	ff 75 0c             	pushl  0xc(%ebp)
  801509:	6a 58                	push   $0x58
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	ff d0                	call   *%eax
  801510:	83 c4 10             	add    $0x10,%esp
			break;
  801513:	e9 ce 00 00 00       	jmp    8015e6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801518:	83 ec 08             	sub    $0x8,%esp
  80151b:	ff 75 0c             	pushl  0xc(%ebp)
  80151e:	6a 30                	push   $0x30
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	ff d0                	call   *%eax
  801525:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	ff 75 0c             	pushl  0xc(%ebp)
  80152e:	6a 78                	push   $0x78
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	ff d0                	call   *%eax
  801535:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801538:	8b 45 14             	mov    0x14(%ebp),%eax
  80153b:	83 c0 04             	add    $0x4,%eax
  80153e:	89 45 14             	mov    %eax,0x14(%ebp)
  801541:	8b 45 14             	mov    0x14(%ebp),%eax
  801544:	83 e8 04             	sub    $0x4,%eax
  801547:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801549:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80154c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801553:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80155a:	eb 1f                	jmp    80157b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	ff 75 e8             	pushl  -0x18(%ebp)
  801562:	8d 45 14             	lea    0x14(%ebp),%eax
  801565:	50                   	push   %eax
  801566:	e8 e7 fb ff ff       	call   801152 <getuint>
  80156b:	83 c4 10             	add    $0x10,%esp
  80156e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801571:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801574:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80157b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80157f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	52                   	push   %edx
  801586:	ff 75 e4             	pushl  -0x1c(%ebp)
  801589:	50                   	push   %eax
  80158a:	ff 75 f4             	pushl  -0xc(%ebp)
  80158d:	ff 75 f0             	pushl  -0x10(%ebp)
  801590:	ff 75 0c             	pushl  0xc(%ebp)
  801593:	ff 75 08             	pushl  0x8(%ebp)
  801596:	e8 00 fb ff ff       	call   80109b <printnum>
  80159b:	83 c4 20             	add    $0x20,%esp
			break;
  80159e:	eb 46                	jmp    8015e6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8015a0:	83 ec 08             	sub    $0x8,%esp
  8015a3:	ff 75 0c             	pushl  0xc(%ebp)
  8015a6:	53                   	push   %ebx
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	ff d0                	call   *%eax
  8015ac:	83 c4 10             	add    $0x10,%esp
			break;
  8015af:	eb 35                	jmp    8015e6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8015b1:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  8015b8:	eb 2c                	jmp    8015e6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8015ba:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  8015c1:	eb 23                	jmp    8015e6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015c3:	83 ec 08             	sub    $0x8,%esp
  8015c6:	ff 75 0c             	pushl  0xc(%ebp)
  8015c9:	6a 25                	push   $0x25
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	ff d0                	call   *%eax
  8015d0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015d3:	ff 4d 10             	decl   0x10(%ebp)
  8015d6:	eb 03                	jmp    8015db <vprintfmt+0x3c3>
  8015d8:	ff 4d 10             	decl   0x10(%ebp)
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	48                   	dec    %eax
  8015df:	8a 00                	mov    (%eax),%al
  8015e1:	3c 25                	cmp    $0x25,%al
  8015e3:	75 f3                	jne    8015d8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8015e5:	90                   	nop
		}
	}
  8015e6:	e9 35 fc ff ff       	jmp    801220 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8015eb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8015ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ef:	5b                   	pop    %ebx
  8015f0:	5e                   	pop    %esi
  8015f1:	5d                   	pop    %ebp
  8015f2:	c3                   	ret    

008015f3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8015f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8015fc:	83 c0 04             	add    $0x4,%eax
  8015ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801602:	8b 45 10             	mov    0x10(%ebp),%eax
  801605:	ff 75 f4             	pushl  -0xc(%ebp)
  801608:	50                   	push   %eax
  801609:	ff 75 0c             	pushl  0xc(%ebp)
  80160c:	ff 75 08             	pushl  0x8(%ebp)
  80160f:	e8 04 fc ff ff       	call   801218 <vprintfmt>
  801614:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801617:	90                   	nop
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80161d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801620:	8b 40 08             	mov    0x8(%eax),%eax
  801623:	8d 50 01             	lea    0x1(%eax),%edx
  801626:	8b 45 0c             	mov    0xc(%ebp),%eax
  801629:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80162c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162f:	8b 10                	mov    (%eax),%edx
  801631:	8b 45 0c             	mov    0xc(%ebp),%eax
  801634:	8b 40 04             	mov    0x4(%eax),%eax
  801637:	39 c2                	cmp    %eax,%edx
  801639:	73 12                	jae    80164d <sprintputch+0x33>
		*b->buf++ = ch;
  80163b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163e:	8b 00                	mov    (%eax),%eax
  801640:	8d 48 01             	lea    0x1(%eax),%ecx
  801643:	8b 55 0c             	mov    0xc(%ebp),%edx
  801646:	89 0a                	mov    %ecx,(%edx)
  801648:	8b 55 08             	mov    0x8(%ebp),%edx
  80164b:	88 10                	mov    %dl,(%eax)
}
  80164d:	90                   	nop
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80165c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80166a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801671:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801675:	74 06                	je     80167d <vsnprintf+0x2d>
  801677:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80167b:	7f 07                	jg     801684 <vsnprintf+0x34>
		return -E_INVAL;
  80167d:	b8 03 00 00 00       	mov    $0x3,%eax
  801682:	eb 20                	jmp    8016a4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801684:	ff 75 14             	pushl  0x14(%ebp)
  801687:	ff 75 10             	pushl  0x10(%ebp)
  80168a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80168d:	50                   	push   %eax
  80168e:	68 1a 16 80 00       	push   $0x80161a
  801693:	e8 80 fb ff ff       	call   801218 <vprintfmt>
  801698:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80169b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8016ac:	8d 45 10             	lea    0x10(%ebp),%eax
  8016af:	83 c0 04             	add    $0x4,%eax
  8016b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8016bb:	50                   	push   %eax
  8016bc:	ff 75 0c             	pushl  0xc(%ebp)
  8016bf:	ff 75 08             	pushl  0x8(%ebp)
  8016c2:	e8 89 ff ff ff       	call   801650 <vsnprintf>
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8016cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8016d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016dc:	74 13                	je     8016f1 <readline+0x1f>
		cprintf("%s", prompt);
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	ff 75 08             	pushl  0x8(%ebp)
  8016e4:	68 c8 59 80 00       	push   $0x8059c8
  8016e9:	e8 0b f9 ff ff       	call   800ff9 <cprintf>
  8016ee:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8016f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8016f8:	83 ec 0c             	sub    $0xc,%esp
  8016fb:	6a 00                	push   $0x0
  8016fd:	e8 66 f4 ff ff       	call   800b68 <iscons>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801708:	e8 48 f4 ff ff       	call   800b55 <getchar>
  80170d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801710:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801714:	79 22                	jns    801738 <readline+0x66>
			if (c != -E_EOF)
  801716:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80171a:	0f 84 ad 00 00 00    	je     8017cd <readline+0xfb>
				cprintf("read error: %e\n", c);
  801720:	83 ec 08             	sub    $0x8,%esp
  801723:	ff 75 ec             	pushl  -0x14(%ebp)
  801726:	68 cb 59 80 00       	push   $0x8059cb
  80172b:	e8 c9 f8 ff ff       	call   800ff9 <cprintf>
  801730:	83 c4 10             	add    $0x10,%esp
			break;
  801733:	e9 95 00 00 00       	jmp    8017cd <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801738:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80173c:	7e 34                	jle    801772 <readline+0xa0>
  80173e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801745:	7f 2b                	jg     801772 <readline+0xa0>
			if (echoing)
  801747:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80174b:	74 0e                	je     80175b <readline+0x89>
				cputchar(c);
  80174d:	83 ec 0c             	sub    $0xc,%esp
  801750:	ff 75 ec             	pushl  -0x14(%ebp)
  801753:	e8 de f3 ff ff       	call   800b36 <cputchar>
  801758:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80175b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175e:	8d 50 01             	lea    0x1(%eax),%edx
  801761:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801764:	89 c2                	mov    %eax,%edx
  801766:	8b 45 0c             	mov    0xc(%ebp),%eax
  801769:	01 d0                	add    %edx,%eax
  80176b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80176e:	88 10                	mov    %dl,(%eax)
  801770:	eb 56                	jmp    8017c8 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801772:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801776:	75 1f                	jne    801797 <readline+0xc5>
  801778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80177c:	7e 19                	jle    801797 <readline+0xc5>
			if (echoing)
  80177e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801782:	74 0e                	je     801792 <readline+0xc0>
				cputchar(c);
  801784:	83 ec 0c             	sub    $0xc,%esp
  801787:	ff 75 ec             	pushl  -0x14(%ebp)
  80178a:	e8 a7 f3 ff ff       	call   800b36 <cputchar>
  80178f:	83 c4 10             	add    $0x10,%esp

			i--;
  801792:	ff 4d f4             	decl   -0xc(%ebp)
  801795:	eb 31                	jmp    8017c8 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801797:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80179b:	74 0a                	je     8017a7 <readline+0xd5>
  80179d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8017a1:	0f 85 61 ff ff ff    	jne    801708 <readline+0x36>
			if (echoing)
  8017a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017ab:	74 0e                	je     8017bb <readline+0xe9>
				cputchar(c);
  8017ad:	83 ec 0c             	sub    $0xc,%esp
  8017b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8017b3:	e8 7e f3 ff ff       	call   800b36 <cputchar>
  8017b8:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8017bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c1:	01 d0                	add    %edx,%eax
  8017c3:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8017c6:	eb 06                	jmp    8017ce <readline+0xfc>
		}
	}
  8017c8:	e9 3b ff ff ff       	jmp    801708 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8017cd:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8017ce:	90                   	nop
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8017d7:	e8 e0 22 00 00       	call   803abc <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8017dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017e0:	74 13                	je     8017f5 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8017e2:	83 ec 08             	sub    $0x8,%esp
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	68 c8 59 80 00       	push   $0x8059c8
  8017ed:	e8 07 f8 ff ff       	call   800ff9 <cprintf>
  8017f2:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8017f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8017fc:	83 ec 0c             	sub    $0xc,%esp
  8017ff:	6a 00                	push   $0x0
  801801:	e8 62 f3 ff ff       	call   800b68 <iscons>
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80180c:	e8 44 f3 ff ff       	call   800b55 <getchar>
  801811:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801814:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801818:	79 22                	jns    80183c <atomic_readline+0x6b>
				if (c != -E_EOF)
  80181a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80181e:	0f 84 ad 00 00 00    	je     8018d1 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801824:	83 ec 08             	sub    $0x8,%esp
  801827:	ff 75 ec             	pushl  -0x14(%ebp)
  80182a:	68 cb 59 80 00       	push   $0x8059cb
  80182f:	e8 c5 f7 ff ff       	call   800ff9 <cprintf>
  801834:	83 c4 10             	add    $0x10,%esp
				break;
  801837:	e9 95 00 00 00       	jmp    8018d1 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80183c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801840:	7e 34                	jle    801876 <atomic_readline+0xa5>
  801842:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801849:	7f 2b                	jg     801876 <atomic_readline+0xa5>
				if (echoing)
  80184b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80184f:	74 0e                	je     80185f <atomic_readline+0x8e>
					cputchar(c);
  801851:	83 ec 0c             	sub    $0xc,%esp
  801854:	ff 75 ec             	pushl  -0x14(%ebp)
  801857:	e8 da f2 ff ff       	call   800b36 <cputchar>
  80185c:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801862:	8d 50 01             	lea    0x1(%eax),%edx
  801865:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801868:	89 c2                	mov    %eax,%edx
  80186a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186d:	01 d0                	add    %edx,%eax
  80186f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801872:	88 10                	mov    %dl,(%eax)
  801874:	eb 56                	jmp    8018cc <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801876:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80187a:	75 1f                	jne    80189b <atomic_readline+0xca>
  80187c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801880:	7e 19                	jle    80189b <atomic_readline+0xca>
				if (echoing)
  801882:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801886:	74 0e                	je     801896 <atomic_readline+0xc5>
					cputchar(c);
  801888:	83 ec 0c             	sub    $0xc,%esp
  80188b:	ff 75 ec             	pushl  -0x14(%ebp)
  80188e:	e8 a3 f2 ff ff       	call   800b36 <cputchar>
  801893:	83 c4 10             	add    $0x10,%esp
				i--;
  801896:	ff 4d f4             	decl   -0xc(%ebp)
  801899:	eb 31                	jmp    8018cc <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80189b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80189f:	74 0a                	je     8018ab <atomic_readline+0xda>
  8018a1:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8018a5:	0f 85 61 ff ff ff    	jne    80180c <atomic_readline+0x3b>
				if (echoing)
  8018ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018af:	74 0e                	je     8018bf <atomic_readline+0xee>
					cputchar(c);
  8018b1:	83 ec 0c             	sub    $0xc,%esp
  8018b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8018b7:	e8 7a f2 ff ff       	call   800b36 <cputchar>
  8018bc:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8018bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	01 d0                	add    %edx,%eax
  8018c7:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8018ca:	eb 06                	jmp    8018d2 <atomic_readline+0x101>
			}
		}
  8018cc:	e9 3b ff ff ff       	jmp    80180c <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8018d1:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8018d2:	e8 ff 21 00 00       	call   803ad6 <sys_unlock_cons>
}
  8018d7:	90                   	nop
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018e7:	eb 06                	jmp    8018ef <strlen+0x15>
		n++;
  8018e9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018ec:	ff 45 08             	incl   0x8(%ebp)
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	8a 00                	mov    (%eax),%al
  8018f4:	84 c0                	test   %al,%al
  8018f6:	75 f1                	jne    8018e9 <strlen+0xf>
		n++;
	return n;
  8018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801903:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80190a:	eb 09                	jmp    801915 <strnlen+0x18>
		n++;
  80190c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80190f:	ff 45 08             	incl   0x8(%ebp)
  801912:	ff 4d 0c             	decl   0xc(%ebp)
  801915:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801919:	74 09                	je     801924 <strnlen+0x27>
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	84 c0                	test   %al,%al
  801922:	75 e8                	jne    80190c <strnlen+0xf>
		n++;
	return n;
  801924:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801935:	90                   	nop
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8d 50 01             	lea    0x1(%eax),%edx
  80193c:	89 55 08             	mov    %edx,0x8(%ebp)
  80193f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801942:	8d 4a 01             	lea    0x1(%edx),%ecx
  801945:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801948:	8a 12                	mov    (%edx),%dl
  80194a:	88 10                	mov    %dl,(%eax)
  80194c:	8a 00                	mov    (%eax),%al
  80194e:	84 c0                	test   %al,%al
  801950:	75 e4                	jne    801936 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801952:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801963:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80196a:	eb 1f                	jmp    80198b <strncpy+0x34>
		*dst++ = *src;
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	8d 50 01             	lea    0x1(%eax),%edx
  801972:	89 55 08             	mov    %edx,0x8(%ebp)
  801975:	8b 55 0c             	mov    0xc(%ebp),%edx
  801978:	8a 12                	mov    (%edx),%dl
  80197a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80197c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197f:	8a 00                	mov    (%eax),%al
  801981:	84 c0                	test   %al,%al
  801983:	74 03                	je     801988 <strncpy+0x31>
			src++;
  801985:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801988:	ff 45 fc             	incl   -0x4(%ebp)
  80198b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80198e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801991:	72 d9                	jb     80196c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801993:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8019a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019a8:	74 30                	je     8019da <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8019aa:	eb 16                	jmp    8019c2 <strlcpy+0x2a>
			*dst++ = *src++;
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	8d 50 01             	lea    0x1(%eax),%edx
  8019b2:	89 55 08             	mov    %edx,0x8(%ebp)
  8019b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019bb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8019be:	8a 12                	mov    (%edx),%dl
  8019c0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019c2:	ff 4d 10             	decl   0x10(%ebp)
  8019c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019c9:	74 09                	je     8019d4 <strlcpy+0x3c>
  8019cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	84 c0                	test   %al,%al
  8019d2:	75 d8                	jne    8019ac <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019da:	8b 55 08             	mov    0x8(%ebp),%edx
  8019dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e0:	29 c2                	sub    %eax,%edx
  8019e2:	89 d0                	mov    %edx,%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019e9:	eb 06                	jmp    8019f1 <strcmp+0xb>
		p++, q++;
  8019eb:	ff 45 08             	incl   0x8(%ebp)
  8019ee:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	84 c0                	test   %al,%al
  8019f8:	74 0e                	je     801a08 <strcmp+0x22>
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	8a 10                	mov    (%eax),%dl
  8019ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	38 c2                	cmp    %al,%dl
  801a06:	74 e3                	je     8019eb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	8a 00                	mov    (%eax),%al
  801a0d:	0f b6 d0             	movzbl %al,%edx
  801a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a13:	8a 00                	mov    (%eax),%al
  801a15:	0f b6 c0             	movzbl %al,%eax
  801a18:	29 c2                	sub    %eax,%edx
  801a1a:	89 d0                	mov    %edx,%eax
}
  801a1c:	5d                   	pop    %ebp
  801a1d:	c3                   	ret    

00801a1e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801a21:	eb 09                	jmp    801a2c <strncmp+0xe>
		n--, p++, q++;
  801a23:	ff 4d 10             	decl   0x10(%ebp)
  801a26:	ff 45 08             	incl   0x8(%ebp)
  801a29:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801a2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a30:	74 17                	je     801a49 <strncmp+0x2b>
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8a 00                	mov    (%eax),%al
  801a37:	84 c0                	test   %al,%al
  801a39:	74 0e                	je     801a49 <strncmp+0x2b>
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	8a 10                	mov    (%eax),%dl
  801a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a43:	8a 00                	mov    (%eax),%al
  801a45:	38 c2                	cmp    %al,%dl
  801a47:	74 da                	je     801a23 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a4d:	75 07                	jne    801a56 <strncmp+0x38>
		return 0;
  801a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a54:	eb 14                	jmp    801a6a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	8a 00                	mov    (%eax),%al
  801a5b:	0f b6 d0             	movzbl %al,%edx
  801a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a61:	8a 00                	mov    (%eax),%al
  801a63:	0f b6 c0             	movzbl %al,%eax
  801a66:	29 c2                	sub    %eax,%edx
  801a68:	89 d0                	mov    %edx,%eax
}
  801a6a:	5d                   	pop    %ebp
  801a6b:	c3                   	ret    

00801a6c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 04             	sub    $0x4,%esp
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a75:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a78:	eb 12                	jmp    801a8c <strchr+0x20>
		if (*s == c)
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	8a 00                	mov    (%eax),%al
  801a7f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a82:	75 05                	jne    801a89 <strchr+0x1d>
			return (char *) s;
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	eb 11                	jmp    801a9a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a89:	ff 45 08             	incl   0x8(%ebp)
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	8a 00                	mov    (%eax),%al
  801a91:	84 c0                	test   %al,%al
  801a93:	75 e5                	jne    801a7a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801aa8:	eb 0d                	jmp    801ab7 <strfind+0x1b>
		if (*s == c)
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	8a 00                	mov    (%eax),%al
  801aaf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ab2:	74 0e                	je     801ac2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801ab4:	ff 45 08             	incl   0x8(%ebp)
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	84 c0                	test   %al,%al
  801abe:	75 ea                	jne    801aaa <strfind+0xe>
  801ac0:	eb 01                	jmp    801ac3 <strfind+0x27>
		if (*s == c)
			break;
  801ac2:	90                   	nop
	return (char *) s;
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801ad4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801ad8:	76 63                	jbe    801b3d <memset+0x75>
		uint64 data_block = c;
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	99                   	cltd   
  801ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ae1:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aea:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801aee:	c1 e0 08             	shl    $0x8,%eax
  801af1:	09 45 f0             	or     %eax,-0x10(%ebp)
  801af4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801afd:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801b01:	c1 e0 10             	shl    $0x10,%eax
  801b04:	09 45 f0             	or     %eax,-0x10(%ebp)
  801b07:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b10:	89 c2                	mov    %eax,%edx
  801b12:	b8 00 00 00 00       	mov    $0x0,%eax
  801b17:	09 45 f0             	or     %eax,-0x10(%ebp)
  801b1a:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801b1d:	eb 18                	jmp    801b37 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801b1f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b22:	8d 41 08             	lea    0x8(%ecx),%eax
  801b25:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2e:	89 01                	mov    %eax,(%ecx)
  801b30:	89 51 04             	mov    %edx,0x4(%ecx)
  801b33:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801b37:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801b3b:	77 e2                	ja     801b1f <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801b3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b41:	74 23                	je     801b66 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b46:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b49:	eb 0e                	jmp    801b59 <memset+0x91>
			*p8++ = (uint8)c;
  801b4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4e:	8d 50 01             	lea    0x1(%eax),%edx
  801b51:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b57:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801b59:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b5f:	89 55 10             	mov    %edx,0x10(%ebp)
  801b62:	85 c0                	test   %eax,%eax
  801b64:	75 e5                	jne    801b4b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801b7d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801b81:	76 24                	jbe    801ba7 <memcpy+0x3c>
		while(n >= 8){
  801b83:	eb 1c                	jmp    801ba1 <memcpy+0x36>
			*d64 = *s64;
  801b85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b88:	8b 50 04             	mov    0x4(%eax),%edx
  801b8b:	8b 00                	mov    (%eax),%eax
  801b8d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b90:	89 01                	mov    %eax,(%ecx)
  801b92:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801b95:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801b99:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801b9d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801ba1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801ba5:	77 de                	ja     801b85 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801ba7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bab:	74 31                	je     801bde <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801bb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801bb9:	eb 16                	jmp    801bd1 <memcpy+0x66>
			*d8++ = *s8++;
  801bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbe:	8d 50 01             	lea    0x1(%eax),%edx
  801bc1:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801bc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  801bca:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801bcd:	8a 12                	mov    (%edx),%dl
  801bcf:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801bd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bd7:	89 55 10             	mov    %edx,0x10(%ebp)
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	75 dd                	jne    801bbb <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bf8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801bfb:	73 50                	jae    801c4d <memmove+0x6a>
  801bfd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c00:	8b 45 10             	mov    0x10(%ebp),%eax
  801c03:	01 d0                	add    %edx,%eax
  801c05:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801c08:	76 43                	jbe    801c4d <memmove+0x6a>
		s += n;
  801c0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801c10:	8b 45 10             	mov    0x10(%ebp),%eax
  801c13:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801c16:	eb 10                	jmp    801c28 <memmove+0x45>
			*--d = *--s;
  801c18:	ff 4d f8             	decl   -0x8(%ebp)
  801c1b:	ff 4d fc             	decl   -0x4(%ebp)
  801c1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c21:	8a 10                	mov    (%eax),%dl
  801c23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c26:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801c28:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c2e:	89 55 10             	mov    %edx,0x10(%ebp)
  801c31:	85 c0                	test   %eax,%eax
  801c33:	75 e3                	jne    801c18 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801c35:	eb 23                	jmp    801c5a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801c37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c3a:	8d 50 01             	lea    0x1(%eax),%edx
  801c3d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c43:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c46:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801c49:	8a 12                	mov    (%edx),%dl
  801c4b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801c4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c50:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c53:	89 55 10             	mov    %edx,0x10(%ebp)
  801c56:	85 c0                	test   %eax,%eax
  801c58:	75 dd                	jne    801c37 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801c71:	eb 2a                	jmp    801c9d <memcmp+0x3e>
		if (*s1 != *s2)
  801c73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c76:	8a 10                	mov    (%eax),%dl
  801c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7b:	8a 00                	mov    (%eax),%al
  801c7d:	38 c2                	cmp    %al,%dl
  801c7f:	74 16                	je     801c97 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801c81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c84:	8a 00                	mov    (%eax),%al
  801c86:	0f b6 d0             	movzbl %al,%edx
  801c89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c8c:	8a 00                	mov    (%eax),%al
  801c8e:	0f b6 c0             	movzbl %al,%eax
  801c91:	29 c2                	sub    %eax,%edx
  801c93:	89 d0                	mov    %edx,%eax
  801c95:	eb 18                	jmp    801caf <memcmp+0x50>
		s1++, s2++;
  801c97:	ff 45 fc             	incl   -0x4(%ebp)
  801c9a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca0:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ca3:	89 55 10             	mov    %edx,0x10(%ebp)
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	75 c9                	jne    801c73 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  801cba:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbd:	01 d0                	add    %edx,%eax
  801cbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801cc2:	eb 15                	jmp    801cd9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	8a 00                	mov    (%eax),%al
  801cc9:	0f b6 d0             	movzbl %al,%edx
  801ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccf:	0f b6 c0             	movzbl %al,%eax
  801cd2:	39 c2                	cmp    %eax,%edx
  801cd4:	74 0d                	je     801ce3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801cd6:	ff 45 08             	incl   0x8(%ebp)
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cdf:	72 e3                	jb     801cc4 <memfind+0x13>
  801ce1:	eb 01                	jmp    801ce4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801ce3:	90                   	nop
	return (void *) s;
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801cf6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801cfd:	eb 03                	jmp    801d02 <strtol+0x19>
		s++;
  801cff:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	8a 00                	mov    (%eax),%al
  801d07:	3c 20                	cmp    $0x20,%al
  801d09:	74 f4                	je     801cff <strtol+0x16>
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	8a 00                	mov    (%eax),%al
  801d10:	3c 09                	cmp    $0x9,%al
  801d12:	74 eb                	je     801cff <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	8a 00                	mov    (%eax),%al
  801d19:	3c 2b                	cmp    $0x2b,%al
  801d1b:	75 05                	jne    801d22 <strtol+0x39>
		s++;
  801d1d:	ff 45 08             	incl   0x8(%ebp)
  801d20:	eb 13                	jmp    801d35 <strtol+0x4c>
	else if (*s == '-')
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	8a 00                	mov    (%eax),%al
  801d27:	3c 2d                	cmp    $0x2d,%al
  801d29:	75 0a                	jne    801d35 <strtol+0x4c>
		s++, neg = 1;
  801d2b:	ff 45 08             	incl   0x8(%ebp)
  801d2e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d39:	74 06                	je     801d41 <strtol+0x58>
  801d3b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801d3f:	75 20                	jne    801d61 <strtol+0x78>
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8a 00                	mov    (%eax),%al
  801d46:	3c 30                	cmp    $0x30,%al
  801d48:	75 17                	jne    801d61 <strtol+0x78>
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	40                   	inc    %eax
  801d4e:	8a 00                	mov    (%eax),%al
  801d50:	3c 78                	cmp    $0x78,%al
  801d52:	75 0d                	jne    801d61 <strtol+0x78>
		s += 2, base = 16;
  801d54:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801d58:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801d5f:	eb 28                	jmp    801d89 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801d61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d65:	75 15                	jne    801d7c <strtol+0x93>
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	8a 00                	mov    (%eax),%al
  801d6c:	3c 30                	cmp    $0x30,%al
  801d6e:	75 0c                	jne    801d7c <strtol+0x93>
		s++, base = 8;
  801d70:	ff 45 08             	incl   0x8(%ebp)
  801d73:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801d7a:	eb 0d                	jmp    801d89 <strtol+0xa0>
	else if (base == 0)
  801d7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d80:	75 07                	jne    801d89 <strtol+0xa0>
		base = 10;
  801d82:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	8a 00                	mov    (%eax),%al
  801d8e:	3c 2f                	cmp    $0x2f,%al
  801d90:	7e 19                	jle    801dab <strtol+0xc2>
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8a 00                	mov    (%eax),%al
  801d97:	3c 39                	cmp    $0x39,%al
  801d99:	7f 10                	jg     801dab <strtol+0xc2>
			dig = *s - '0';
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	8a 00                	mov    (%eax),%al
  801da0:	0f be c0             	movsbl %al,%eax
  801da3:	83 e8 30             	sub    $0x30,%eax
  801da6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da9:	eb 42                	jmp    801ded <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	8a 00                	mov    (%eax),%al
  801db0:	3c 60                	cmp    $0x60,%al
  801db2:	7e 19                	jle    801dcd <strtol+0xe4>
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	8a 00                	mov    (%eax),%al
  801db9:	3c 7a                	cmp    $0x7a,%al
  801dbb:	7f 10                	jg     801dcd <strtol+0xe4>
			dig = *s - 'a' + 10;
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8a 00                	mov    (%eax),%al
  801dc2:	0f be c0             	movsbl %al,%eax
  801dc5:	83 e8 57             	sub    $0x57,%eax
  801dc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dcb:	eb 20                	jmp    801ded <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	8a 00                	mov    (%eax),%al
  801dd2:	3c 40                	cmp    $0x40,%al
  801dd4:	7e 39                	jle    801e0f <strtol+0x126>
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	8a 00                	mov    (%eax),%al
  801ddb:	3c 5a                	cmp    $0x5a,%al
  801ddd:	7f 30                	jg     801e0f <strtol+0x126>
			dig = *s - 'A' + 10;
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	8a 00                	mov    (%eax),%al
  801de4:	0f be c0             	movsbl %al,%eax
  801de7:	83 e8 37             	sub    $0x37,%eax
  801dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df0:	3b 45 10             	cmp    0x10(%ebp),%eax
  801df3:	7d 19                	jge    801e0e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801df5:	ff 45 08             	incl   0x8(%ebp)
  801df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dfb:	0f af 45 10          	imul   0x10(%ebp),%eax
  801dff:	89 c2                	mov    %eax,%edx
  801e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e04:	01 d0                	add    %edx,%eax
  801e06:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801e09:	e9 7b ff ff ff       	jmp    801d89 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801e0e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801e0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e13:	74 08                	je     801e1d <strtol+0x134>
		*endptr = (char *) s;
  801e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e18:	8b 55 08             	mov    0x8(%ebp),%edx
  801e1b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801e1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e21:	74 07                	je     801e2a <strtol+0x141>
  801e23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e26:	f7 d8                	neg    %eax
  801e28:	eb 03                	jmp    801e2d <strtol+0x144>
  801e2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <ltostr>:

void
ltostr(long value, char *str)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801e3c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801e43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e47:	79 13                	jns    801e5c <ltostr+0x2d>
	{
		neg = 1;
  801e49:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801e56:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801e59:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801e64:	99                   	cltd   
  801e65:	f7 f9                	idiv   %ecx
  801e67:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801e6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e6d:	8d 50 01             	lea    0x1(%eax),%edx
  801e70:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e73:	89 c2                	mov    %eax,%edx
  801e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e78:	01 d0                	add    %edx,%eax
  801e7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e7d:	83 c2 30             	add    $0x30,%edx
  801e80:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801e82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e85:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801e8a:	f7 e9                	imul   %ecx
  801e8c:	c1 fa 02             	sar    $0x2,%edx
  801e8f:	89 c8                	mov    %ecx,%eax
  801e91:	c1 f8 1f             	sar    $0x1f,%eax
  801e94:	29 c2                	sub    %eax,%edx
  801e96:	89 d0                	mov    %edx,%eax
  801e98:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801e9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e9f:	75 bb                	jne    801e5c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ea1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ea8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eab:	48                   	dec    %eax
  801eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801eaf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801eb3:	74 3d                	je     801ef2 <ltostr+0xc3>
		start = 1 ;
  801eb5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801ebc:	eb 34                	jmp    801ef2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec4:	01 d0                	add    %edx,%eax
  801ec6:	8a 00                	mov    (%eax),%al
  801ec8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	01 c2                	add    %eax,%edx
  801ed3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed9:	01 c8                	add    %ecx,%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801edf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee5:	01 c2                	add    %eax,%edx
  801ee7:	8a 45 eb             	mov    -0x15(%ebp),%al
  801eea:	88 02                	mov    %al,(%edx)
		start++ ;
  801eec:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801eef:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ef8:	7c c4                	jl     801ebe <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801efa:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f00:	01 d0                	add    %edx,%eax
  801f02:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801f05:	90                   	nop
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801f0e:	ff 75 08             	pushl  0x8(%ebp)
  801f11:	e8 c4 f9 ff ff       	call   8018da <strlen>
  801f16:	83 c4 04             	add    $0x4,%esp
  801f19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	e8 b6 f9 ff ff       	call   8018da <strlen>
  801f24:	83 c4 04             	add    $0x4,%esp
  801f27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801f2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801f31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f38:	eb 17                	jmp    801f51 <strcconcat+0x49>
		final[s] = str1[s] ;
  801f3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f40:	01 c2                	add    %eax,%edx
  801f42:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	01 c8                	add    %ecx,%eax
  801f4a:	8a 00                	mov    (%eax),%al
  801f4c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801f4e:	ff 45 fc             	incl   -0x4(%ebp)
  801f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f54:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f57:	7c e1                	jl     801f3a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801f59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801f60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801f67:	eb 1f                	jmp    801f88 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6c:	8d 50 01             	lea    0x1(%eax),%edx
  801f6f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f72:	89 c2                	mov    %eax,%edx
  801f74:	8b 45 10             	mov    0x10(%ebp),%eax
  801f77:	01 c2                	add    %eax,%edx
  801f79:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7f:	01 c8                	add    %ecx,%eax
  801f81:	8a 00                	mov    (%eax),%al
  801f83:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801f85:	ff 45 f8             	incl   -0x8(%ebp)
  801f88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f8b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f8e:	7c d9                	jl     801f69 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801f90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f93:	8b 45 10             	mov    0x10(%ebp),%eax
  801f96:	01 d0                	add    %edx,%eax
  801f98:	c6 00 00             	movb   $0x0,(%eax)
}
  801f9b:	90                   	nop
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801fa1:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801faa:	8b 45 14             	mov    0x14(%ebp),%eax
  801fad:	8b 00                	mov    (%eax),%eax
  801faf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fb6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb9:	01 d0                	add    %edx,%eax
  801fbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801fc1:	eb 0c                	jmp    801fcf <strsplit+0x31>
			*string++ = 0;
  801fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc6:	8d 50 01             	lea    0x1(%eax),%edx
  801fc9:	89 55 08             	mov    %edx,0x8(%ebp)
  801fcc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	8a 00                	mov    (%eax),%al
  801fd4:	84 c0                	test   %al,%al
  801fd6:	74 18                	je     801ff0 <strsplit+0x52>
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	8a 00                	mov    (%eax),%al
  801fdd:	0f be c0             	movsbl %al,%eax
  801fe0:	50                   	push   %eax
  801fe1:	ff 75 0c             	pushl  0xc(%ebp)
  801fe4:	e8 83 fa ff ff       	call   801a6c <strchr>
  801fe9:	83 c4 08             	add    $0x8,%esp
  801fec:	85 c0                	test   %eax,%eax
  801fee:	75 d3                	jne    801fc3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	8a 00                	mov    (%eax),%al
  801ff5:	84 c0                	test   %al,%al
  801ff7:	74 5a                	je     802053 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ff9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ffc:	8b 00                	mov    (%eax),%eax
  801ffe:	83 f8 0f             	cmp    $0xf,%eax
  802001:	75 07                	jne    80200a <strsplit+0x6c>
		{
			return 0;
  802003:	b8 00 00 00 00       	mov    $0x0,%eax
  802008:	eb 66                	jmp    802070 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80200a:	8b 45 14             	mov    0x14(%ebp),%eax
  80200d:	8b 00                	mov    (%eax),%eax
  80200f:	8d 48 01             	lea    0x1(%eax),%ecx
  802012:	8b 55 14             	mov    0x14(%ebp),%edx
  802015:	89 0a                	mov    %ecx,(%edx)
  802017:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80201e:	8b 45 10             	mov    0x10(%ebp),%eax
  802021:	01 c2                	add    %eax,%edx
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802028:	eb 03                	jmp    80202d <strsplit+0x8f>
			string++;
  80202a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8a 00                	mov    (%eax),%al
  802032:	84 c0                	test   %al,%al
  802034:	74 8b                	je     801fc1 <strsplit+0x23>
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8a 00                	mov    (%eax),%al
  80203b:	0f be c0             	movsbl %al,%eax
  80203e:	50                   	push   %eax
  80203f:	ff 75 0c             	pushl  0xc(%ebp)
  802042:	e8 25 fa ff ff       	call   801a6c <strchr>
  802047:	83 c4 08             	add    $0x8,%esp
  80204a:	85 c0                	test   %eax,%eax
  80204c:	74 dc                	je     80202a <strsplit+0x8c>
			string++;
	}
  80204e:	e9 6e ff ff ff       	jmp    801fc1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802053:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802054:	8b 45 14             	mov    0x14(%ebp),%eax
  802057:	8b 00                	mov    (%eax),%eax
  802059:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802060:	8b 45 10             	mov    0x10(%ebp),%eax
  802063:	01 d0                	add    %edx,%eax
  802065:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80206b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80207e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802085:	eb 4a                	jmp    8020d1 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802087:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	01 c2                	add    %eax,%edx
  80208f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802092:	8b 45 0c             	mov    0xc(%ebp),%eax
  802095:	01 c8                	add    %ecx,%eax
  802097:	8a 00                	mov    (%eax),%al
  802099:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80209b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80209e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a1:	01 d0                	add    %edx,%eax
  8020a3:	8a 00                	mov    (%eax),%al
  8020a5:	3c 40                	cmp    $0x40,%al
  8020a7:	7e 25                	jle    8020ce <str2lower+0x5c>
  8020a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020af:	01 d0                	add    %edx,%eax
  8020b1:	8a 00                	mov    (%eax),%al
  8020b3:	3c 5a                	cmp    $0x5a,%al
  8020b5:	7f 17                	jg     8020ce <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8020b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	01 d0                	add    %edx,%eax
  8020bf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8020c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c5:	01 ca                	add    %ecx,%edx
  8020c7:	8a 12                	mov    (%edx),%dl
  8020c9:	83 c2 20             	add    $0x20,%edx
  8020cc:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8020ce:	ff 45 fc             	incl   -0x4(%ebp)
  8020d1:	ff 75 0c             	pushl  0xc(%ebp)
  8020d4:	e8 01 f8 ff ff       	call   8018da <strlen>
  8020d9:	83 c4 04             	add    $0x4,%esp
  8020dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020df:	7f a6                	jg     802087 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8020e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8020ec:	a1 08 60 80 00       	mov    0x806008,%eax
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	0f 84 95 00 00 00    	je     80218e <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8020f9:	83 ec 08             	sub    $0x8,%esp
  8020fc:	68 00 00 00 82       	push   $0x82000000
  802101:	68 00 00 00 80       	push   $0x80000000
  802106:	e8 59 1f 00 00       	call   804064 <initialize_dynamic_allocator>
  80210b:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80210e:	e8 93 1d 00 00       	call   803ea6 <sys_get_uheap_strategy>
  802113:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802118:	a1 40 60 80 00       	mov    0x806040,%eax
  80211d:	05 00 10 00 00       	add    $0x1000,%eax
  802122:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  802127:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80212c:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  802131:	83 ec 04             	sub    $0x4,%esp
  802134:	6a 01                	push   $0x1
  802136:	68 dc 59 80 00       	push   $0x8059dc
  80213b:	68 40 e1 81 00       	push   $0x81e140
  802140:	e8 1a 29 00 00       	call   804a5f <init_uspinlock>
  802145:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  802148:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  80214f:	00 00 00 
  802152:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  802159:	00 00 00 
  80215c:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  802163:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  802166:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  80216d:	00 00 00 
  802170:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  802177:	00 00 00 
  80217a:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  802181:	00 00 00 
		__firstTimeFlag = 0;
  802184:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  80218b:	00 00 00 
	}
}
  80218e:	90                   	nop
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021a5:	83 ec 08             	sub    $0x8,%esp
  8021a8:	68 06 04 00 00       	push   $0x406
  8021ad:	50                   	push   %eax
  8021ae:	e8 3d 19 00 00       	call   803af0 <__sys_allocate_page>
  8021b3:	83 c4 10             	add    $0x10,%esp
  8021b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8021b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021bd:	79 14                	jns    8021d3 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 e4 59 80 00       	push   $0x8059e4
  8021c7:	6a 2d                	push   $0x2d
  8021c9:	68 20 5a 80 00       	push   $0x805a20
  8021ce:	e8 58 eb ff ff       	call   800d2b <_panic>
	return 0;
  8021d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021ee:	83 ec 0c             	sub    $0xc,%esp
  8021f1:	50                   	push   %eax
  8021f2:	e8 40 19 00 00       	call   803b37 <__sys_unmap_frame>
  8021f7:	83 c4 10             	add    $0x10,%esp
  8021fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8021fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802201:	79 14                	jns    802217 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802203:	83 ec 04             	sub    $0x4,%esp
  802206:	68 2c 5a 80 00       	push   $0x805a2c
  80220b:	6a 38                	push   $0x38
  80220d:	68 20 5a 80 00       	push   $0x805a20
  802212:	e8 14 eb ff ff       	call   800d2b <_panic>
}
  802217:	90                   	nop
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802220:	e8 c1 fe ff ff       	call   8020e6 <uheap_init>
	if (size == 0) return NULL ;
  802225:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802229:	75 0a                	jne    802235 <malloc+0x1b>
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
  802230:	e9 e1 04 00 00       	jmp    802716 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  802235:	83 ec 0c             	sub    $0xc,%esp
  802238:	68 40 e1 81 00       	push   $0x81e140
  80223d:	e8 6c 28 00 00       	call   804aae <acquire_uspinlock>
  802242:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  802245:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  80224c:	77 23                	ja     802271 <malloc+0x57>
		release_uspinlock(&ulock);
  80224e:	83 ec 0c             	sub    $0xc,%esp
  802251:	68 40 e1 81 00       	push   $0x81e140
  802256:	e8 ab 28 00 00       	call   804b06 <release_uspinlock>
  80225b:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	ff 75 08             	pushl  0x8(%ebp)
  802264:	e8 dd 1f 00 00       	call   804246 <alloc_block>
  802269:	83 c4 10             	add    $0x10,%esp
  80226c:	e9 a5 04 00 00       	jmp    802716 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802271:	83 ec 0c             	sub    $0xc,%esp
  802274:	6a 10                	push   $0x10
  802276:	e8 cb 1f 00 00       	call   804246 <alloc_block>
  80227b:	83 c4 10             	add    $0x10,%esp
  80227e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  802281:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802285:	75 0a                	jne    802291 <malloc+0x77>
			return NULL;
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
  80228c:	e9 85 04 00 00       	jmp    802716 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  802291:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802298:	8b 55 08             	mov    0x8(%ebp),%edx
  80229b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80229e:	01 d0                	add    %edx,%eax
  8022a0:	48                   	dec    %eax
  8022a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ac:	f7 75 e8             	divl   -0x18(%ebp)
  8022af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022b2:	29 d0                	sub    %edx,%eax
  8022b4:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8022b7:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8022bc:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8022bf:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	74 0f                	je     8022d7 <malloc+0xbd>
  8022c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022cb:	8b 40 04             	mov    0x4(%eax),%eax
  8022ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d1:	0f 83 ea 00 00 00    	jae    8023c1 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  8022d7:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8022dc:	2b 45 08             	sub    0x8(%ebp),%eax
  8022df:	89 c2                	mov    %eax,%edx
  8022e1:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8022e6:	39 c2                	cmp    %eax,%edx
  8022e8:	0f 86 b9 00 00 00    	jbe    8023a7 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  8022ee:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8022f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  8022f6:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	01 d0                	add    %edx,%eax
  802301:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  802306:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802309:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80230c:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80230e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802311:	8b 55 08             	mov    0x8(%ebp),%edx
  802314:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802317:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80231b:	75 14                	jne    802331 <malloc+0x117>
  80231d:	83 ec 04             	sub    $0x4,%esp
  802320:	68 6c 5a 80 00       	push   $0x805a6c
  802325:	6a 60                	push   $0x60
  802327:	68 20 5a 80 00       	push   $0x805a20
  80232c:	e8 fa e9 ff ff       	call   800d2b <_panic>
  802331:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802337:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233a:	89 50 0c             	mov    %edx,0xc(%eax)
  80233d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802340:	8b 40 0c             	mov    0xc(%eax),%eax
  802343:	85 c0                	test   %eax,%eax
  802345:	74 0d                	je     802354 <malloc+0x13a>
  802347:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80234c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80234f:	89 50 08             	mov    %edx,0x8(%eax)
  802352:	eb 08                	jmp    80235c <malloc+0x142>
  802354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802357:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80235c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235f:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802367:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80236e:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802373:	40                   	inc    %eax
  802374:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  802379:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237c:	8b 00                	mov    (%eax),%eax
  80237e:	83 ec 08             	sub    $0x8,%esp
  802381:	ff 75 08             	pushl  0x8(%ebp)
  802384:	50                   	push   %eax
  802385:	e8 34 1c 00 00       	call   803fbe <sys_allocate_user_mem>
  80238a:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  80238d:	83 ec 0c             	sub    $0xc,%esp
  802390:	68 40 e1 81 00       	push   $0x81e140
  802395:	e8 6c 27 00 00       	call   804b06 <release_uspinlock>
  80239a:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80239d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	e9 6f 03 00 00       	jmp    802716 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  8023a7:	83 ec 0c             	sub    $0xc,%esp
  8023aa:	68 40 e1 81 00       	push   $0x81e140
  8023af:	e8 52 27 00 00       	call   804b06 <release_uspinlock>
  8023b4:	83 c4 10             	add    $0x10,%esp
					return NULL;
  8023b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bc:	e9 55 03 00 00       	jmp    802716 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8023c1:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8023c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  8023c9:	e9 39 03 00 00       	jmp    802707 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	8b 40 04             	mov    0x4(%eax),%eax
  8023d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d7:	0f 86 e7 01 00 00    	jbe    8025c4 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  8023dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023e0:	8b 10                	mov    (%eax),%edx
  8023e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e5:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  8023e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ed:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8023f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023f4:	75 14                	jne    80240a <malloc+0x1f0>
  8023f6:	83 ec 04             	sub    $0x4,%esp
  8023f9:	68 6c 5a 80 00       	push   $0x805a6c
  8023fe:	6a 72                	push   $0x72
  802400:	68 20 5a 80 00       	push   $0x805a20
  802405:	e8 21 e9 ff ff       	call   800d2b <_panic>
  80240a:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802413:	89 50 0c             	mov    %edx,0xc(%eax)
  802416:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802419:	8b 40 0c             	mov    0xc(%eax),%eax
  80241c:	85 c0                	test   %eax,%eax
  80241e:	74 0d                	je     80242d <malloc+0x213>
  802420:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802425:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802428:	89 50 08             	mov    %edx,0x8(%eax)
  80242b:	eb 08                	jmp    802435 <malloc+0x21b>
  80242d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802430:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802435:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802438:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80243d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802440:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802447:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80244c:	40                   	inc    %eax
  80244d:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  802452:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802455:	8b 10                	mov    (%eax),%edx
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	01 c2                	add    %eax,%edx
  80245c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80245f:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  802461:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802464:	8b 40 04             	mov    0x4(%eax),%eax
  802467:	2b 45 08             	sub    0x8(%ebp),%eax
  80246a:	89 c2                	mov    %eax,%edx
  80246c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80246f:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802472:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802477:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  80247a:	e9 0d 01 00 00       	jmp    80258c <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  80247f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802482:	8b 50 04             	mov    0x4(%eax),%edx
  802485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802488:	8b 40 04             	mov    0x4(%eax),%eax
  80248b:	39 c2                	cmp    %eax,%edx
  80248d:	0f 83 f0 00 00 00    	jae    802583 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802493:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802497:	75 14                	jne    8024ad <malloc+0x293>
  802499:	83 ec 04             	sub    $0x4,%esp
  80249c:	68 8f 5a 80 00       	push   $0x805a8f
  8024a1:	6a 7a                	push   $0x7a
  8024a3:	68 20 5a 80 00       	push   $0x805a20
  8024a8:	e8 7e e8 ff ff       	call   800d2b <_panic>
  8024ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b0:	8b 40 08             	mov    0x8(%eax),%eax
  8024b3:	85 c0                	test   %eax,%eax
  8024b5:	74 11                	je     8024c8 <malloc+0x2ae>
  8024b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ba:	8b 40 08             	mov    0x8(%eax),%eax
  8024bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024c0:	8b 52 0c             	mov    0xc(%edx),%edx
  8024c3:	89 50 0c             	mov    %edx,0xc(%eax)
  8024c6:	eb 0b                	jmp    8024d3 <malloc+0x2b9>
  8024c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ce:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8024d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	74 11                	je     8024ee <malloc+0x2d4>
  8024dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024e6:	8b 52 08             	mov    0x8(%edx),%edx
  8024e9:	89 50 08             	mov    %edx,0x8(%eax)
  8024ec:	eb 0b                	jmp    8024f9 <malloc+0x2df>
  8024ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f1:	8b 40 08             	mov    0x8(%eax),%eax
  8024f4:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8024f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802503:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802506:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80250d:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802512:	48                   	dec    %eax
  802513:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802518:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80251c:	74 06                	je     802524 <malloc+0x30a>
  80251e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802522:	75 14                	jne    802538 <malloc+0x31e>
  802524:	83 ec 04             	sub    $0x4,%esp
  802527:	68 b0 5a 80 00       	push   $0x805ab0
  80252c:	6a 7b                	push   $0x7b
  80252e:	68 20 5a 80 00       	push   $0x805a20
  802533:	e8 f3 e7 ff ff       	call   800d2b <_panic>
  802538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253b:	8b 50 0c             	mov    0xc(%eax),%edx
  80253e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802541:	89 50 0c             	mov    %edx,0xc(%eax)
  802544:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802547:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80254a:	89 50 08             	mov    %edx,0x8(%eax)
  80254d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802550:	8b 40 0c             	mov    0xc(%eax),%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	74 0e                	je     802565 <malloc+0x34b>
  802557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255a:	8b 40 0c             	mov    0xc(%eax),%eax
  80255d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802560:	89 50 08             	mov    %edx,0x8(%eax)
  802563:	eb 08                	jmp    80256d <malloc+0x353>
  802565:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802568:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80256d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802570:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802573:	89 50 0c             	mov    %edx,0xc(%eax)
  802576:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80257b:	40                   	inc    %eax
  80257c:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  802581:	eb 13                	jmp    802596 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  802583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802586:	8b 40 08             	mov    0x8(%eax),%eax
  802589:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  80258c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802590:	0f 85 e9 fe ff ff    	jne    80247f <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  802596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802599:	8b 00                	mov    (%eax),%eax
  80259b:	83 ec 08             	sub    $0x8,%esp
  80259e:	ff 75 08             	pushl  0x8(%ebp)
  8025a1:	50                   	push   %eax
  8025a2:	e8 17 1a 00 00       	call   803fbe <sys_allocate_user_mem>
  8025a7:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  8025aa:	83 ec 0c             	sub    $0xc,%esp
  8025ad:	68 40 e1 81 00       	push   $0x81e140
  8025b2:	e8 4f 25 00 00       	call   804b06 <release_uspinlock>
  8025b7:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  8025ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	e9 52 01 00 00       	jmp    802716 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025cd:	0f 85 2b 01 00 00    	jne    8026fe <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 10                	mov    (%eax),%edx
  8025d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025db:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  8025dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e3:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  8025e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025ea:	75 17                	jne    802603 <malloc+0x3e9>
  8025ec:	83 ec 04             	sub    $0x4,%esp
  8025ef:	68 6c 5a 80 00       	push   $0x805a6c
  8025f4:	68 89 00 00 00       	push   $0x89
  8025f9:	68 20 5a 80 00       	push   $0x805a20
  8025fe:	e8 28 e7 ff ff       	call   800d2b <_panic>
  802603:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802609:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260c:	89 50 0c             	mov    %edx,0xc(%eax)
  80260f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802612:	8b 40 0c             	mov    0xc(%eax),%eax
  802615:	85 c0                	test   %eax,%eax
  802617:	74 0d                	je     802626 <malloc+0x40c>
  802619:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80261e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802621:	89 50 08             	mov    %edx,0x8(%eax)
  802624:	eb 08                	jmp    80262e <malloc+0x414>
  802626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802629:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80262e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802631:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802636:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802639:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802640:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802645:	40                   	inc    %eax
  802646:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  80264b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264f:	75 17                	jne    802668 <malloc+0x44e>
  802651:	83 ec 04             	sub    $0x4,%esp
  802654:	68 8f 5a 80 00       	push   $0x805a8f
  802659:	68 8a 00 00 00       	push   $0x8a
  80265e:	68 20 5a 80 00       	push   $0x805a20
  802663:	e8 c3 e6 ff ff       	call   800d2b <_panic>
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 08             	mov    0x8(%eax),%eax
  80266e:	85 c0                	test   %eax,%eax
  802670:	74 11                	je     802683 <malloc+0x469>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 40 08             	mov    0x8(%eax),%eax
  802678:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267b:	8b 52 0c             	mov    0xc(%edx),%edx
  80267e:	89 50 0c             	mov    %edx,0xc(%eax)
  802681:	eb 0b                	jmp    80268e <malloc+0x474>
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 40 0c             	mov    0xc(%eax),%eax
  802689:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 40 0c             	mov    0xc(%eax),%eax
  802694:	85 c0                	test   %eax,%eax
  802696:	74 11                	je     8026a9 <malloc+0x48f>
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 40 0c             	mov    0xc(%eax),%eax
  80269e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a1:	8b 52 08             	mov    0x8(%edx),%edx
  8026a4:	89 50 08             	mov    %edx,0x8(%eax)
  8026a7:	eb 0b                	jmp    8026b4 <malloc+0x49a>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 40 08             	mov    0x8(%eax),%eax
  8026af:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8026c8:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8026cd:	48                   	dec    %eax
  8026ce:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  8026d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	83 ec 08             	sub    $0x8,%esp
  8026db:	ff 75 08             	pushl  0x8(%ebp)
  8026de:	50                   	push   %eax
  8026df:	e8 da 18 00 00       	call   803fbe <sys_allocate_user_mem>
  8026e4:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  8026e7:	83 ec 0c             	sub    $0xc,%esp
  8026ea:	68 40 e1 81 00       	push   $0x81e140
  8026ef:	e8 12 24 00 00       	call   804b06 <release_uspinlock>
  8026f4:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  8026f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fa:	8b 00                	mov    (%eax),%eax
  8026fc:	eb 18                	jmp    802716 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 08             	mov    0x8(%eax),%eax
  802704:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  802707:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270b:	0f 85 bd fc ff ff    	jne    8023ce <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  802711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
  80271b:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802724:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802727:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80272c:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  80272f:	e8 b2 f9 ff ff       	call   8020e6 <uheap_init>
		acquire_uspinlock(&ulock);
  802734:	83 ec 0c             	sub    $0xc,%esp
  802737:	68 40 e1 81 00       	push   $0x81e140
  80273c:	e8 6d 23 00 00       	call   804aae <acquire_uspinlock>
  802741:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  802744:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802749:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80274c:	73 23                	jae    802771 <free+0x59>
			free_block(virtual_address);
  80274e:	83 ec 0c             	sub    $0xc,%esp
  802751:	ff 75 08             	pushl  0x8(%ebp)
  802754:	e8 89 1f 00 00       	call   8046e2 <free_block>
  802759:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  80275c:	83 ec 0c             	sub    $0xc,%esp
  80275f:	68 40 e1 81 00       	push   $0x81e140
  802764:	e8 9d 23 00 00       	call   804b06 <release_uspinlock>
  802769:	83 c4 10             	add    $0x10,%esp
			return;
  80276c:	e9 35 07 00 00       	jmp    802ea6 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802771:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802776:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802779:	72 30                	jb     8027ab <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  80277b:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802780:	83 ec 04             	sub    $0x4,%esp
  802783:	50                   	push   %eax
  802784:	ff 75 d8             	pushl  -0x28(%ebp)
  802787:	68 e5 5a 80 00       	push   $0x805ae5
  80278c:	e8 68 e8 ff ff       	call   800ff9 <cprintf>
  802791:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802794:	83 ec 04             	sub    $0x4,%esp
  802797:	68 ed 5a 80 00       	push   $0x805aed
  80279c:	68 a7 00 00 00       	push   $0xa7
  8027a1:	68 20 5a 80 00       	push   $0x805a20
  8027a6:	e8 80 e5 ff ff       	call   800d2b <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8027ab:	83 ec 0c             	sub    $0xc,%esp
  8027ae:	6a 10                	push   $0x10
  8027b0:	e8 91 1a 00 00       	call   804246 <alloc_block>
  8027b5:	83 c4 10             	add    $0x10,%esp
  8027b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  8027bb:	83 ec 0c             	sub    $0xc,%esp
  8027be:	6a 10                	push   $0x10
  8027c0:	e8 81 1a 00 00       	call   804246 <alloc_block>
  8027c5:	83 c4 10             	add    $0x10,%esp
  8027c8:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  8027cb:	a1 30 e1 81 00       	mov    0x81e130,%eax
  8027d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  8027d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  8027da:	eb 1c                	jmp    8027f8 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8027e4:	75 09                	jne    8027ef <free+0xd7>
				foundVA = 1;
  8027e6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  8027ed:	eb 0f                	jmp    8027fe <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 40 08             	mov    0x8(%eax),%eax
  8027f5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  8027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fc:	75 de                	jne    8027dc <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  8027fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802802:	75 17                	jne    80281b <free+0x103>
				panic("INVALID ADDRESS!");
  802804:	83 ec 04             	sub    $0x4,%esp
  802807:	68 0a 5b 80 00       	push   $0x805b0a
  80280c:	68 be 00 00 00       	push   $0xbe
  802811:	68 20 5a 80 00       	push   $0x805a20
  802816:	e8 10 e5 ff ff       	call   800d2b <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 10                	mov    (%eax),%edx
  802820:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802823:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 50 04             	mov    0x4(%eax),%edx
  80282b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80282e:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  802831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802835:	75 17                	jne    80284e <free+0x136>
  802837:	83 ec 04             	sub    $0x4,%esp
  80283a:	68 8f 5a 80 00       	push   $0x805a8f
  80283f:	68 c8 00 00 00       	push   $0xc8
  802844:	68 20 5a 80 00       	push   $0x805a20
  802849:	e8 dd e4 ff ff       	call   800d2b <_panic>
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 40 08             	mov    0x8(%eax),%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	74 11                	je     802869 <free+0x151>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 40 08             	mov    0x8(%eax),%eax
  80285e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802861:	8b 52 0c             	mov    0xc(%edx),%edx
  802864:	89 50 0c             	mov    %edx,0xc(%eax)
  802867:	eb 0b                	jmp    802874 <free+0x15c>
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 40 0c             	mov    0xc(%eax),%eax
  80286f:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 40 0c             	mov    0xc(%eax),%eax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	74 11                	je     80288f <free+0x177>
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 40 0c             	mov    0xc(%eax),%eax
  802884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802887:	8b 52 08             	mov    0x8(%edx),%edx
  80288a:	89 50 08             	mov    %edx,0x8(%eax)
  80288d:	eb 0b                	jmp    80289a <free+0x182>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 40 08             	mov    0x8(%eax),%eax
  802895:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028ae:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8028b3:	48                   	dec    %eax
  8028b4:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 50 04             	mov    0x4(%eax),%edx
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 00                	mov    (%eax),%eax
  8028c4:	83 ec 08             	sub    $0x8,%esp
  8028c7:	52                   	push   %edx
  8028c8:	50                   	push   %eax
  8028c9:	e8 d4 16 00 00       	call   803fa2 <sys_free_user_mem>
  8028ce:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  8028d1:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	75 7a                	jne    802954 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  8028da:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8028de:	75 17                	jne    8028f7 <free+0x1df>
  8028e0:	83 ec 04             	sub    $0x4,%esp
  8028e3:	68 1c 5b 80 00       	push   $0x805b1c
  8028e8:	68 d0 00 00 00       	push   $0xd0
  8028ed:	68 20 5a 80 00       	push   $0x805a20
  8028f2:	e8 34 e4 ff ff       	call   800d2b <_panic>
  8028f7:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  8028fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802900:	89 50 08             	mov    %edx,0x8(%eax)
  802903:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802906:	8b 40 08             	mov    0x8(%eax),%eax
  802909:	85 c0                	test   %eax,%eax
  80290b:	74 0d                	je     80291a <free+0x202>
  80290d:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802912:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802915:	89 50 0c             	mov    %edx,0xc(%eax)
  802918:	eb 08                	jmp    802922 <free+0x20a>
  80291a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80291d:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802922:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802925:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80292a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80292d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802934:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802939:	40                   	inc    %eax
  80293a:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  80293f:	83 ec 0c             	sub    $0xc,%esp
  802942:	68 40 e1 81 00       	push   $0x81e140
  802947:	e8 ba 21 00 00       	call   804b06 <release_uspinlock>
  80294c:	83 c4 10             	add    $0x10,%esp
			return;
  80294f:	e9 52 05 00 00       	jmp    802ea6 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  802954:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802959:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  80295c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  802963:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  80296a:	e9 d2 00 00 00       	jmp    802a41 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  80296f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802972:	8b 10                	mov    (%eax),%edx
  802974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802977:	8b 40 04             	mov    0x4(%eax),%eax
  80297a:	01 c2                	add    %eax,%edx
  80297c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80297f:	8b 00                	mov    (%eax),%eax
  802981:	39 c2                	cmp    %eax,%edx
  802983:	0f 85 af 00 00 00    	jne    802a38 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  802989:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298c:	8b 10                	mov    (%eax),%edx
  80298e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802991:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  802993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802996:	8b 50 04             	mov    0x4(%eax),%edx
  802999:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80299c:	8b 40 04             	mov    0x4(%eax),%eax
  80299f:	01 c2                	add    %eax,%edx
  8029a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029a4:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  8029a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ab:	75 17                	jne    8029c4 <free+0x2ac>
  8029ad:	83 ec 04             	sub    $0x4,%esp
  8029b0:	68 8f 5a 80 00       	push   $0x805a8f
  8029b5:	68 df 00 00 00       	push   $0xdf
  8029ba:	68 20 5a 80 00       	push   $0x805a20
  8029bf:	e8 67 e3 ff ff       	call   800d2b <_panic>
  8029c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	74 11                	je     8029df <free+0x2c7>
  8029ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d1:	8b 40 08             	mov    0x8(%eax),%eax
  8029d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d7:	8b 52 0c             	mov    0xc(%edx),%edx
  8029da:	89 50 0c             	mov    %edx,0xc(%eax)
  8029dd:	eb 0b                	jmp    8029ea <free+0x2d2>
  8029df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e5:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8029ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	74 11                	je     802a05 <free+0x2ed>
  8029f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029fd:	8b 52 08             	mov    0x8(%edx),%edx
  802a00:	89 50 08             	mov    %edx,0x8(%eax)
  802a03:	eb 0b                	jmp    802a10 <free+0x2f8>
  802a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a08:	8b 40 08             	mov    0x8(%eax),%eax
  802a0b:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802a10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a24:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802a29:	48                   	dec    %eax
  802a2a:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  802a2f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  802a36:	eb 13                	jmp    802a4b <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3b:	8b 40 08             	mov    0x8(%eax),%eax
  802a3e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  802a41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a45:	0f 85 24 ff ff ff    	jne    80296f <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  802a4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a4e:	8b 10                	mov    (%eax),%edx
  802a50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a53:	8b 40 04             	mov    0x4(%eax),%eax
  802a56:	01 c2                	add    %eax,%edx
  802a58:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802a5d:	39 c2                	cmp    %eax,%edx
  802a5f:	75 44                	jne    802aa5 <free+0x38d>

			if(mergeprev){
  802a61:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a65:	74 1f                	je     802a86 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  802a67:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802a71:	83 ec 0c             	sub    $0xc,%esp
  802a74:	68 40 e1 81 00       	push   $0x81e140
  802a79:	e8 88 20 00 00       	call   804b06 <release_uspinlock>
  802a7e:	83 c4 10             	add    $0x10,%esp
				return;
  802a81:	e9 20 04 00 00       	jmp    802ea6 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  802a86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802a90:	83 ec 0c             	sub    $0xc,%esp
  802a93:	68 40 e1 81 00       	push   $0x81e140
  802a98:	e8 69 20 00 00       	call   804b06 <release_uspinlock>
  802a9d:	83 c4 10             	add    $0x10,%esp
				return;
  802aa0:	e9 01 04 00 00       	jmp    802ea6 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  802aa5:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802aaa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  802aad:	e9 7d 01 00 00       	jmp    802c2f <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  802ab2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ab5:	8b 10                	mov    (%eax),%edx
  802ab7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aba:	8b 40 04             	mov    0x4(%eax),%eax
  802abd:	01 c2                	add    %eax,%edx
  802abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	39 c2                	cmp    %eax,%edx
  802ac6:	0f 85 5a 01 00 00    	jne    802c26 <free+0x50e>
				if (mergeprev){
  802acc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ad0:	0f 84 a1 00 00 00    	je     802b77 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  802ad6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ad9:	8b 50 04             	mov    0x4(%eax),%edx
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	8b 40 04             	mov    0x4(%eax),%eax
  802ae2:	01 c2                	add    %eax,%edx
  802ae4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ae7:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802aea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aee:	75 17                	jne    802b07 <free+0x3ef>
  802af0:	83 ec 04             	sub    $0x4,%esp
  802af3:	68 8f 5a 80 00       	push   $0x805a8f
  802af8:	68 0a 01 00 00       	push   $0x10a
  802afd:	68 20 5a 80 00       	push   $0x805a20
  802b02:	e8 24 e2 ff ff       	call   800d2b <_panic>
  802b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0a:	8b 40 08             	mov    0x8(%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	74 11                	je     802b22 <free+0x40a>
  802b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b14:	8b 40 08             	mov    0x8(%eax),%eax
  802b17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1a:	8b 52 0c             	mov    0xc(%edx),%edx
  802b1d:	89 50 0c             	mov    %edx,0xc(%eax)
  802b20:	eb 0b                	jmp    802b2d <free+0x415>
  802b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b25:	8b 40 0c             	mov    0xc(%eax),%eax
  802b28:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	8b 40 0c             	mov    0xc(%eax),%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	74 11                	je     802b48 <free+0x430>
  802b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b40:	8b 52 08             	mov    0x8(%edx),%edx
  802b43:	89 50 08             	mov    %edx,0x8(%eax)
  802b46:	eb 0b                	jmp    802b53 <free+0x43b>
  802b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4b:	8b 40 08             	mov    0x8(%eax),%eax
  802b4e:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b60:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b67:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802b6c:	48                   	dec    %eax
  802b6d:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  802b72:	e9 c2 00 00 00       	jmp    802c39 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  802b77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b7a:	8b 10                	mov    (%eax),%edx
  802b7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b7f:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  802b81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b84:	8b 50 04             	mov    0x4(%eax),%edx
  802b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8a:	8b 40 04             	mov    0x4(%eax),%eax
  802b8d:	01 c2                	add    %eax,%edx
  802b8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b92:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802b95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b99:	75 17                	jne    802bb2 <free+0x49a>
  802b9b:	83 ec 04             	sub    $0x4,%esp
  802b9e:	68 8f 5a 80 00       	push   $0x805a8f
  802ba3:	68 10 01 00 00       	push   $0x110
  802ba8:	68 20 5a 80 00       	push   $0x805a20
  802bad:	e8 79 e1 ff ff       	call   800d2b <_panic>
  802bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb5:	8b 40 08             	mov    0x8(%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 11                	je     802bcd <free+0x4b5>
  802bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbf:	8b 40 08             	mov    0x8(%eax),%eax
  802bc2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc5:	8b 52 0c             	mov    0xc(%edx),%edx
  802bc8:	89 50 0c             	mov    %edx,0xc(%eax)
  802bcb:	eb 0b                	jmp    802bd8 <free+0x4c0>
  802bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd3:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bde:	85 c0                	test   %eax,%eax
  802be0:	74 11                	je     802bf3 <free+0x4db>
  802be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be5:	8b 40 0c             	mov    0xc(%eax),%eax
  802be8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802beb:	8b 52 08             	mov    0x8(%edx),%edx
  802bee:	89 50 08             	mov    %edx,0x8(%eax)
  802bf1:	eb 0b                	jmp    802bfe <free+0x4e6>
  802bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf6:	8b 40 08             	mov    0x8(%eax),%eax
  802bf9:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802bfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c12:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802c17:	48                   	dec    %eax
  802c18:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  802c1d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  802c24:	eb 13                	jmp    802c39 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c29:	8b 40 08             	mov    0x8(%eax),%eax
  802c2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  802c2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c33:	0f 85 79 fe ff ff    	jne    802ab2 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  802c39:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802c3e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  802c41:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c45:	0f 85 ad 00 00 00    	jne    802cf8 <free+0x5e0>
  802c4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c4f:	0f 84 c3 01 00 00    	je     802e18 <free+0x700>
				while(currentfree != NULL){
  802c55:	e9 9e 00 00 00       	jmp    802cf8 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  802c5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c5d:	8b 50 04             	mov    0x4(%eax),%edx
  802c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c63:	8b 40 04             	mov    0x4(%eax),%eax
  802c66:	39 c2                	cmp    %eax,%edx
  802c68:	0f 83 81 00 00 00    	jae    802cef <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  802c6e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c72:	74 06                	je     802c7a <free+0x562>
  802c74:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802c78:	75 17                	jne    802c91 <free+0x579>
  802c7a:	83 ec 04             	sub    $0x4,%esp
  802c7d:	68 b0 5a 80 00       	push   $0x805ab0
  802c82:	68 23 01 00 00       	push   $0x123
  802c87:	68 20 5a 80 00       	push   $0x805a20
  802c8c:	e8 9a e0 ff ff       	call   800d2b <_panic>
  802c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c94:	8b 50 0c             	mov    0xc(%eax),%edx
  802c97:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c9a:	89 50 0c             	mov    %edx,0xc(%eax)
  802c9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ca0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ca3:	89 50 08             	mov    %edx,0x8(%eax)
  802ca6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cac:	85 c0                	test   %eax,%eax
  802cae:	74 0e                	je     802cbe <free+0x5a6>
  802cb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802cb9:	89 50 08             	mov    %edx,0x8(%eax)
  802cbc:	eb 08                	jmp    802cc6 <free+0x5ae>
  802cbe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cc1:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802cc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ccc:	89 50 0c             	mov    %edx,0xc(%eax)
  802ccf:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802cd4:	40                   	inc    %eax
  802cd5:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  802cda:	83 ec 0c             	sub    $0xc,%esp
  802cdd:	68 40 e1 81 00       	push   $0x81e140
  802ce2:	e8 1f 1e 00 00       	call   804b06 <release_uspinlock>
  802ce7:	83 c4 10             	add    $0x10,%esp
							return;
  802cea:	e9 b7 01 00 00       	jmp    802ea6 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802cef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf2:	8b 40 08             	mov    0x8(%eax),%eax
  802cf5:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  802cf8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802cfc:	0f 85 58 ff ff ff    	jne    802c5a <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802d02:	83 ec 0c             	sub    $0xc,%esp
  802d05:	ff 75 d4             	pushl  -0x2c(%ebp)
  802d08:	e8 d5 19 00 00       	call   8046e2 <free_block>
  802d0d:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  802d10:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802d14:	75 17                	jne    802d2d <free+0x615>
  802d16:	83 ec 04             	sub    $0x4,%esp
  802d19:	68 6c 5a 80 00       	push   $0x805a6c
  802d1e:	68 2a 01 00 00       	push   $0x12a
  802d23:	68 20 5a 80 00       	push   $0x805a20
  802d28:	e8 fe df ff ff       	call   800d2b <_panic>
  802d2d:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  802d33:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d36:	89 50 0c             	mov    %edx,0xc(%eax)
  802d39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	74 0d                	je     802d50 <free+0x638>
  802d43:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802d48:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802d4b:	89 50 08             	mov    %edx,0x8(%eax)
  802d4e:	eb 08                	jmp    802d58 <free+0x640>
  802d50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d53:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802d58:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d5b:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802d60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d6a:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802d6f:	40                   	inc    %eax
  802d70:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  802d75:	e9 1b 01 00 00       	jmp    802e95 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  802d7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d7d:	8b 50 04             	mov    0x4(%eax),%edx
  802d80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d83:	8b 40 04             	mov    0x4(%eax),%eax
  802d86:	39 c2                	cmp    %eax,%edx
  802d88:	0f 83 81 00 00 00    	jae    802e0f <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  802d8e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d92:	74 06                	je     802d9a <free+0x682>
  802d94:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d98:	75 17                	jne    802db1 <free+0x699>
  802d9a:	83 ec 04             	sub    $0x4,%esp
  802d9d:	68 b0 5a 80 00       	push   $0x805ab0
  802da2:	68 30 01 00 00       	push   $0x130
  802da7:	68 20 5a 80 00       	push   $0x805a20
  802dac:	e8 7a df ff ff       	call   800d2b <_panic>
  802db1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db4:	8b 50 0c             	mov    0xc(%eax),%edx
  802db7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dba:	89 50 0c             	mov    %edx,0xc(%eax)
  802dbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dc0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dc3:	89 50 08             	mov    %edx,0x8(%eax)
  802dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	74 0e                	je     802dde <free+0x6c6>
  802dd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802dd9:	89 50 08             	mov    %edx,0x8(%eax)
  802ddc:	eb 08                	jmp    802de6 <free+0x6ce>
  802dde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802de1:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802dec:	89 50 0c             	mov    %edx,0xc(%eax)
  802def:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802df4:	40                   	inc    %eax
  802df5:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  802dfa:	83 ec 0c             	sub    $0xc,%esp
  802dfd:	68 40 e1 81 00       	push   $0x81e140
  802e02:	e8 ff 1c 00 00       	call   804b06 <release_uspinlock>
  802e07:	83 c4 10             	add    $0x10,%esp
							return;
  802e0a:	e9 97 00 00 00       	jmp    802ea6 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e12:	8b 40 08             	mov    0x8(%eax),%eax
  802e15:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  802e18:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e1c:	0f 85 58 ff ff ff    	jne    802d7a <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  802e22:	83 ec 0c             	sub    $0xc,%esp
  802e25:	ff 75 d0             	pushl  -0x30(%ebp)
  802e28:	e8 b5 18 00 00       	call   8046e2 <free_block>
  802e2d:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  802e30:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e34:	75 17                	jne    802e4d <free+0x735>
  802e36:	83 ec 04             	sub    $0x4,%esp
  802e39:	68 6c 5a 80 00       	push   $0x805a6c
  802e3e:	68 37 01 00 00       	push   $0x137
  802e43:	68 20 5a 80 00       	push   $0x805a20
  802e48:	e8 de de ff ff       	call   800d2b <_panic>
  802e4d:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  802e53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e56:	89 50 0c             	mov    %edx,0xc(%eax)
  802e59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5f:	85 c0                	test   %eax,%eax
  802e61:	74 0d                	je     802e70 <free+0x758>
  802e63:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802e68:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e6b:	89 50 08             	mov    %edx,0x8(%eax)
  802e6e:	eb 08                	jmp    802e78 <free+0x760>
  802e70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e73:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802e78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e7b:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802e80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e8a:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802e8f:	40                   	inc    %eax
  802e90:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  802e95:	83 ec 0c             	sub    $0xc,%esp
  802e98:	68 40 e1 81 00       	push   $0x81e140
  802e9d:	e8 64 1c 00 00       	call   804b06 <release_uspinlock>
  802ea2:	83 c4 10             	add    $0x10,%esp
		return;
  802ea5:	90                   	nop
}
  802ea6:	c9                   	leave  
  802ea7:	c3                   	ret    

00802ea8 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802ea8:	55                   	push   %ebp
  802ea9:	89 e5                	mov    %esp,%ebp
  802eab:	83 ec 48             	sub    $0x48,%esp
  802eae:	8b 45 10             	mov    0x10(%ebp),%eax
  802eb1:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802eb4:	e8 2d f2 ff ff       	call   8020e6 <uheap_init>
	if (size == 0) return NULL;
  802eb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ebd:	75 0a                	jne    802ec9 <smalloc+0x21>
  802ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec4:	e9 84 05 00 00       	jmp    80344d <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802ec9:	83 ec 0c             	sub    $0xc,%esp
  802ecc:	68 40 e1 81 00       	push   $0x81e140
  802ed1:	e8 d8 1b 00 00       	call   804aae <acquire_uspinlock>
  802ed6:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802ed9:	83 ec 0c             	sub    $0xc,%esp
  802edc:	6a 10                	push   $0x10
  802ede:	e8 63 13 00 00       	call   804246 <alloc_block>
  802ee3:	83 c4 10             	add    $0x10,%esp
  802ee6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802ee9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802eed:	75 0a                	jne    802ef9 <smalloc+0x51>
				return NULL;
  802eef:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef4:	e9 54 05 00 00       	jmp    80344d <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802ef9:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f06:	01 d0                	add    %edx,%eax
  802f08:	48                   	dec    %eax
  802f09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802f0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0f:	ba 00 00 00 00       	mov    $0x0,%edx
  802f14:	f7 75 e8             	divl   -0x18(%ebp)
  802f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1a:	29 d0                	sub    %edx,%eax
  802f1c:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802f1f:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802f24:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802f27:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 0f                	je     802f3f <smalloc+0x97>
  802f30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f33:	8b 40 04             	mov    0x4(%eax),%eax
  802f36:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f39:	0f 83 25 01 00 00    	jae    803064 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802f3f:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802f44:	2b 45 0c             	sub    0xc(%ebp),%eax
  802f47:	89 c2                	mov    %eax,%edx
  802f49:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802f4e:	39 c2                	cmp    %eax,%edx
  802f50:	0f 82 f4 00 00 00    	jb     80304a <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802f56:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802f5b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  802f5e:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f67:	01 d0                	add    %edx,%eax
  802f69:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f74:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802f76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f79:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f7c:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802f7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f83:	75 17                	jne    802f9c <smalloc+0xf4>
  802f85:	83 ec 04             	sub    $0x4,%esp
  802f88:	68 6c 5a 80 00       	push   $0x805a6c
  802f8d:	68 57 01 00 00       	push   $0x157
  802f92:	68 20 5a 80 00       	push   $0x805a20
  802f97:	e8 8f dd ff ff       	call   800d2b <_panic>
  802f9c:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa5:	89 50 0c             	mov    %edx,0xc(%eax)
  802fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fab:	8b 40 0c             	mov    0xc(%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0d                	je     802fbf <smalloc+0x117>
  802fb2:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802fb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fba:	89 50 08             	mov    %edx,0x8(%eax)
  802fbd:	eb 08                	jmp    802fc7 <smalloc+0x11f>
  802fbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc2:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fca:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802fcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fd9:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802fde:	40                   	inc    %eax
  802fdf:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe7:	8b 00                	mov    (%eax),%eax
  802fe9:	89 c2                	mov    %eax,%edx
  802feb:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802fef:	52                   	push   %edx
  802ff0:	50                   	push   %eax
  802ff1:	ff 75 0c             	pushl  0xc(%ebp)
  802ff4:	ff 75 08             	pushl  0x8(%ebp)
  802ff7:	e8 48 0c 00 00       	call   803c44 <sys_create_shared_object>
  802ffc:	83 c4 10             	add    $0x10,%esp
  802fff:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  803002:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803006:	79 28                	jns    803030 <smalloc+0x188>
							free_block(allocblock);
  803008:	83 ec 0c             	sub    $0xc,%esp
  80300b:	ff 75 ec             	pushl  -0x14(%ebp)
  80300e:	e8 cf 16 00 00       	call   8046e2 <free_block>
  803013:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803016:	83 ec 0c             	sub    $0xc,%esp
  803019:	68 40 e1 81 00       	push   $0x81e140
  80301e:	e8 e3 1a 00 00       	call   804b06 <release_uspinlock>
  803023:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803026:	b8 00 00 00 00       	mov    $0x0,%eax
  80302b:	e9 1d 04 00 00       	jmp    80344d <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  803030:	83 ec 0c             	sub    $0xc,%esp
  803033:	68 40 e1 81 00       	push   $0x81e140
  803038:	e8 c9 1a 00 00       	call   804b06 <release_uspinlock>
  80303d:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803040:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	e9 03 04 00 00       	jmp    80344d <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  80304a:	83 ec 0c             	sub    $0xc,%esp
  80304d:	68 40 e1 81 00       	push   $0x81e140
  803052:	e8 af 1a 00 00       	call   804b06 <release_uspinlock>
  803057:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80305a:	b8 00 00 00 00       	mov    $0x0,%eax
  80305f:	e9 e9 03 00 00       	jmp    80344d <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803064:	a1 20 e1 81 00       	mov    0x81e120,%eax
  803069:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  80306c:	e9 af 03 00 00       	jmp    803420 <smalloc+0x578>
				if(size<currentfreeelement->size){
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 40 04             	mov    0x4(%eax),%eax
  803077:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80307a:	0f 86 28 02 00 00    	jbe    8032a8 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  803080:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803083:	8b 10                	mov    (%eax),%edx
  803085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803088:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  80308a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803090:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803093:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803097:	75 17                	jne    8030b0 <smalloc+0x208>
  803099:	83 ec 04             	sub    $0x4,%esp
  80309c:	68 6c 5a 80 00       	push   $0x805a6c
  8030a1:	68 6f 01 00 00       	push   $0x16f
  8030a6:	68 20 5a 80 00       	push   $0x805a20
  8030ab:	e8 7b dc ff ff       	call   800d2b <_panic>
  8030b0:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8030b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b9:	89 50 0c             	mov    %edx,0xc(%eax)
  8030bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c2:	85 c0                	test   %eax,%eax
  8030c4:	74 0d                	je     8030d3 <smalloc+0x22b>
  8030c6:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8030cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030ce:	89 50 08             	mov    %edx,0x8(%eax)
  8030d1:	eb 08                	jmp    8030db <smalloc+0x233>
  8030d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d6:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8030db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030de:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8030e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030ed:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8030f2:	40                   	inc    %eax
  8030f3:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  8030f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fb:	8b 10                	mov    (%eax),%edx
  8030fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803100:	01 c2                	add    %eax,%edx
  803102:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803105:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  803107:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80310a:	8b 40 04             	mov    0x4(%eax),%eax
  80310d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803110:	89 c2                	mov    %eax,%edx
  803112:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803115:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803118:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80311d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  803120:	e9 13 01 00 00       	jmp    803238 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  803125:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803128:	8b 50 04             	mov    0x4(%eax),%edx
  80312b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312e:	8b 40 04             	mov    0x4(%eax),%eax
  803131:	39 c2                	cmp    %eax,%edx
  803133:	0f 83 f6 00 00 00    	jae    80322f <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  803139:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80313d:	75 17                	jne    803156 <smalloc+0x2ae>
  80313f:	83 ec 04             	sub    $0x4,%esp
  803142:	68 8f 5a 80 00       	push   $0x805a8f
  803147:	68 77 01 00 00       	push   $0x177
  80314c:	68 20 5a 80 00       	push   $0x805a20
  803151:	e8 d5 db ff ff       	call   800d2b <_panic>
  803156:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803159:	8b 40 08             	mov    0x8(%eax),%eax
  80315c:	85 c0                	test   %eax,%eax
  80315e:	74 11                	je     803171 <smalloc+0x2c9>
  803160:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803163:	8b 40 08             	mov    0x8(%eax),%eax
  803166:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803169:	8b 52 0c             	mov    0xc(%edx),%edx
  80316c:	89 50 0c             	mov    %edx,0xc(%eax)
  80316f:	eb 0b                	jmp    80317c <smalloc+0x2d4>
  803171:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803174:	8b 40 0c             	mov    0xc(%eax),%eax
  803177:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80317c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80317f:	8b 40 0c             	mov    0xc(%eax),%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	74 11                	je     803197 <smalloc+0x2ef>
  803186:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803189:	8b 40 0c             	mov    0xc(%eax),%eax
  80318c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80318f:	8b 52 08             	mov    0x8(%edx),%edx
  803192:	89 50 08             	mov    %edx,0x8(%eax)
  803195:	eb 0b                	jmp    8031a2 <smalloc+0x2fa>
  803197:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80319a:	8b 40 08             	mov    0x8(%eax),%eax
  80319d:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8031a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8031b6:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8031bb:	48                   	dec    %eax
  8031bc:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8031c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031c5:	74 06                	je     8031cd <smalloc+0x325>
  8031c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031cb:	75 17                	jne    8031e4 <smalloc+0x33c>
  8031cd:	83 ec 04             	sub    $0x4,%esp
  8031d0:	68 b0 5a 80 00       	push   $0x805ab0
  8031d5:	68 78 01 00 00       	push   $0x178
  8031da:	68 20 5a 80 00       	push   $0x805a20
  8031df:	e8 47 db ff ff       	call   800d2b <_panic>
  8031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ed:	89 50 0c             	mov    %edx,0xc(%eax)
  8031f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f6:	89 50 08             	mov    %edx,0x8(%eax)
  8031f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	74 0e                	je     803211 <smalloc+0x369>
  803203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803206:	8b 40 0c             	mov    0xc(%eax),%eax
  803209:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80320c:	89 50 08             	mov    %edx,0x8(%eax)
  80320f:	eb 08                	jmp    803219 <smalloc+0x371>
  803211:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803214:	a3 20 e1 81 00       	mov    %eax,0x81e120
  803219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80321f:	89 50 0c             	mov    %edx,0xc(%eax)
  803222:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803227:	40                   	inc    %eax
  803228:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  80322d:	eb 13                	jmp    803242 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  80322f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803232:	8b 40 08             	mov    0x8(%eax),%eax
  803235:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  803238:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80323c:	0f 85 e3 fe ff ff    	jne    803125 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803242:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803245:	8b 00                	mov    (%eax),%eax
  803247:	89 c2                	mov    %eax,%edx
  803249:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80324d:	52                   	push   %edx
  80324e:	50                   	push   %eax
  80324f:	ff 75 0c             	pushl  0xc(%ebp)
  803252:	ff 75 08             	pushl  0x8(%ebp)
  803255:	e8 ea 09 00 00       	call   803c44 <sys_create_shared_object>
  80325a:	83 c4 10             	add    $0x10,%esp
  80325d:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  803260:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803264:	79 28                	jns    80328e <smalloc+0x3e6>
	                	free_block(allocblock);
  803266:	83 ec 0c             	sub    $0xc,%esp
  803269:	ff 75 ec             	pushl  -0x14(%ebp)
  80326c:	e8 71 14 00 00       	call   8046e2 <free_block>
  803271:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  803274:	83 ec 0c             	sub    $0xc,%esp
  803277:	68 40 e1 81 00       	push   $0x81e140
  80327c:	e8 85 18 00 00       	call   804b06 <release_uspinlock>
  803281:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  803284:	b8 00 00 00 00       	mov    $0x0,%eax
  803289:	e9 bf 01 00 00       	jmp    80344d <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  80328e:	83 ec 0c             	sub    $0xc,%esp
  803291:	68 40 e1 81 00       	push   $0x81e140
  803296:	e8 6b 18 00 00       	call   804b06 <release_uspinlock>
  80329b:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  80329e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a1:	8b 00                	mov    (%eax),%eax
  8032a3:	e9 a5 01 00 00       	jmp    80344d <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8b 40 04             	mov    0x4(%eax),%eax
  8032ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032b1:	0f 85 60 01 00 00    	jne    803417 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	8b 10                	mov    (%eax),%edx
  8032bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bf:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8032c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032c7:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  8032ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032ce:	75 17                	jne    8032e7 <smalloc+0x43f>
  8032d0:	83 ec 04             	sub    $0x4,%esp
  8032d3:	68 6c 5a 80 00       	push   $0x805a6c
  8032d8:	68 8c 01 00 00       	push   $0x18c
  8032dd:	68 20 5a 80 00       	push   $0x805a20
  8032e2:	e8 44 da ff ff       	call   800d2b <_panic>
  8032e7:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8032ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f0:	89 50 0c             	mov    %edx,0xc(%eax)
  8032f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f9:	85 c0                	test   %eax,%eax
  8032fb:	74 0d                	je     80330a <smalloc+0x462>
  8032fd:	a1 34 e1 81 00       	mov    0x81e134,%eax
  803302:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803305:	89 50 08             	mov    %edx,0x8(%eax)
  803308:	eb 08                	jmp    803312 <smalloc+0x46a>
  80330a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330d:	a3 30 e1 81 00       	mov    %eax,0x81e130
  803312:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803315:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80331a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803324:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  803329:	40                   	inc    %eax
  80332a:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  80332f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803333:	75 17                	jne    80334c <smalloc+0x4a4>
  803335:	83 ec 04             	sub    $0x4,%esp
  803338:	68 8f 5a 80 00       	push   $0x805a8f
  80333d:	68 8d 01 00 00       	push   $0x18d
  803342:	68 20 5a 80 00       	push   $0x805a20
  803347:	e8 df d9 ff ff       	call   800d2b <_panic>
  80334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334f:	8b 40 08             	mov    0x8(%eax),%eax
  803352:	85 c0                	test   %eax,%eax
  803354:	74 11                	je     803367 <smalloc+0x4bf>
  803356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803359:	8b 40 08             	mov    0x8(%eax),%eax
  80335c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335f:	8b 52 0c             	mov    0xc(%edx),%edx
  803362:	89 50 0c             	mov    %edx,0xc(%eax)
  803365:	eb 0b                	jmp    803372 <smalloc+0x4ca>
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	8b 40 0c             	mov    0xc(%eax),%eax
  80336d:	a3 24 e1 81 00       	mov    %eax,0x81e124
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	8b 40 0c             	mov    0xc(%eax),%eax
  803378:	85 c0                	test   %eax,%eax
  80337a:	74 11                	je     80338d <smalloc+0x4e5>
  80337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337f:	8b 40 0c             	mov    0xc(%eax),%eax
  803382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803385:	8b 52 08             	mov    0x8(%edx),%edx
  803388:	89 50 08             	mov    %edx,0x8(%eax)
  80338b:	eb 0b                	jmp    803398 <smalloc+0x4f0>
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	8b 40 08             	mov    0x8(%eax),%eax
  803393:	a3 20 e1 81 00       	mov    %eax,0x81e120
  803398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8033ac:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8033b1:	48                   	dec    %eax
  8033b2:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8033b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ba:	8b 00                	mov    (%eax),%eax
  8033bc:	89 c2                	mov    %eax,%edx
  8033be:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8033c2:	52                   	push   %edx
  8033c3:	50                   	push   %eax
  8033c4:	ff 75 0c             	pushl  0xc(%ebp)
  8033c7:	ff 75 08             	pushl  0x8(%ebp)
  8033ca:	e8 75 08 00 00       	call   803c44 <sys_create_shared_object>
  8033cf:	83 c4 10             	add    $0x10,%esp
  8033d2:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  8033d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033d9:	79 25                	jns    803400 <smalloc+0x558>
						free_block(allocblock);
  8033db:	83 ec 0c             	sub    $0xc,%esp
  8033de:	ff 75 ec             	pushl  -0x14(%ebp)
  8033e1:	e8 fc 12 00 00       	call   8046e2 <free_block>
  8033e6:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8033e9:	83 ec 0c             	sub    $0xc,%esp
  8033ec:	68 40 e1 81 00       	push   $0x81e140
  8033f1:	e8 10 17 00 00       	call   804b06 <release_uspinlock>
  8033f6:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8033f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033fe:	eb 4d                	jmp    80344d <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  803400:	83 ec 0c             	sub    $0xc,%esp
  803403:	68 40 e1 81 00       	push   $0x81e140
  803408:	e8 f9 16 00 00       	call   804b06 <release_uspinlock>
  80340d:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803413:	8b 00                	mov    (%eax),%eax
  803415:	eb 36                	jmp    80344d <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341a:	8b 40 08             	mov    0x8(%eax),%eax
  80341d:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803424:	0f 85 47 fc ff ff    	jne    803071 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  80342a:	83 ec 0c             	sub    $0xc,%esp
  80342d:	ff 75 ec             	pushl  -0x14(%ebp)
  803430:	e8 ad 12 00 00       	call   8046e2 <free_block>
  803435:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803438:	83 ec 0c             	sub    $0xc,%esp
  80343b:	68 40 e1 81 00       	push   $0x81e140
  803440:	e8 c1 16 00 00       	call   804b06 <release_uspinlock>
  803445:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80344d:	c9                   	leave  
  80344e:	c3                   	ret    

0080344f <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80344f:	55                   	push   %ebp
  803450:	89 e5                	mov    %esp,%ebp
  803452:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  803455:	e8 8c ec ff ff       	call   8020e6 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  80345a:	83 ec 0c             	sub    $0xc,%esp
  80345d:	68 40 e1 81 00       	push   $0x81e140
  803462:	e8 47 16 00 00       	call   804aae <acquire_uspinlock>
  803467:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  80346a:	83 ec 08             	sub    $0x8,%esp
  80346d:	ff 75 0c             	pushl  0xc(%ebp)
  803470:	ff 75 08             	pushl  0x8(%ebp)
  803473:	e8 f6 07 00 00       	call   803c6e <sys_size_of_shared_object>
  803478:	83 c4 10             	add    $0x10,%esp
  80347b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  80347e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803482:	79 1a                	jns    80349e <sget+0x4f>
			release_uspinlock(&ulock);
  803484:	83 ec 0c             	sub    $0xc,%esp
  803487:	68 40 e1 81 00       	push   $0x81e140
  80348c:	e8 75 16 00 00       	call   804b06 <release_uspinlock>
  803491:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803494:	b8 00 00 00 00       	mov    $0x0,%eax
  803499:	e9 6e 05 00 00       	jmp    803a0c <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  80349e:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8034a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ab:	01 d0                	add    %edx,%eax
  8034ad:	48                   	dec    %eax
  8034ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8034b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8034b9:	f7 75 e8             	divl   -0x18(%ebp)
  8034bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bf:	29 d0                	sub    %edx,%eax
  8034c1:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8034c4:	83 ec 0c             	sub    $0xc,%esp
  8034c7:	6a 10                	push   $0x10
  8034c9:	e8 78 0d 00 00       	call   804246 <alloc_block>
  8034ce:	83 c4 10             	add    $0x10,%esp
  8034d1:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  8034d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034d8:	75 0a                	jne    8034e4 <sget+0x95>
			return NULL;
  8034da:	b8 00 00 00 00       	mov    $0x0,%eax
  8034df:	e9 28 05 00 00       	jmp    803a0c <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8034e4:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8034e9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8034ec:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8034f1:	85 c0                	test   %eax,%eax
  8034f3:	74 11                	je     803506 <sget+0xb7>
  8034f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034f8:	8b 50 04             	mov    0x4(%eax),%edx
  8034fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fe:	39 c2                	cmp    %eax,%edx
  803500:	0f 83 21 01 00 00    	jae    803627 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  803506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803509:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  80350e:	29 c2                	sub    %eax,%edx
  803510:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803515:	39 c2                	cmp    %eax,%edx
  803517:	0f 82 f0 00 00 00    	jb     80360d <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  80351d:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803522:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  803525:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80352b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352e:	01 d0                	add    %edx,%eax
  803530:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  803535:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803538:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80353b:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  80353d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803543:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  803546:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80354a:	75 17                	jne    803563 <sget+0x114>
  80354c:	83 ec 04             	sub    $0x4,%esp
  80354f:	68 6c 5a 80 00       	push   $0x805a6c
  803554:	68 c8 01 00 00       	push   $0x1c8
  803559:	68 20 5a 80 00       	push   $0x805a20
  80355e:	e8 c8 d7 ff ff       	call   800d2b <_panic>
  803563:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  803569:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80356c:	89 50 0c             	mov    %edx,0xc(%eax)
  80356f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803572:	8b 40 0c             	mov    0xc(%eax),%eax
  803575:	85 c0                	test   %eax,%eax
  803577:	74 0d                	je     803586 <sget+0x137>
  803579:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80357e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803581:	89 50 08             	mov    %edx,0x8(%eax)
  803584:	eb 08                	jmp    80358e <sget+0x13f>
  803586:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803589:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80358e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803591:	a3 34 e1 81 00       	mov    %eax,0x81e134
  803596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803599:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8035a0:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8035a5:	40                   	inc    %eax
  8035a6:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  8035ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ae:	8b 00                	mov    (%eax),%eax
  8035b0:	83 ec 04             	sub    $0x4,%esp
  8035b3:	50                   	push   %eax
  8035b4:	ff 75 0c             	pushl  0xc(%ebp)
  8035b7:	ff 75 08             	pushl  0x8(%ebp)
  8035ba:	e8 cc 06 00 00       	call   803c8b <sys_get_shared_object>
  8035bf:	83 c4 10             	add    $0x10,%esp
  8035c2:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  8035c5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8035c9:	79 28                	jns    8035f3 <sget+0x1a4>
							free_block(allocblock);
  8035cb:	83 ec 0c             	sub    $0xc,%esp
  8035ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8035d1:	e8 0c 11 00 00       	call   8046e2 <free_block>
  8035d6:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8035d9:	83 ec 0c             	sub    $0xc,%esp
  8035dc:	68 40 e1 81 00       	push   $0x81e140
  8035e1:	e8 20 15 00 00       	call   804b06 <release_uspinlock>
  8035e6:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8035e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ee:	e9 19 04 00 00       	jmp    803a0c <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  8035f3:	83 ec 0c             	sub    $0xc,%esp
  8035f6:	68 40 e1 81 00       	push   $0x81e140
  8035fb:	e8 06 15 00 00       	call   804b06 <release_uspinlock>
  803600:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803603:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803606:	8b 00                	mov    (%eax),%eax
  803608:	e9 ff 03 00 00       	jmp    803a0c <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  80360d:	83 ec 0c             	sub    $0xc,%esp
  803610:	68 40 e1 81 00       	push   $0x81e140
  803615:	e8 ec 14 00 00       	call   804b06 <release_uspinlock>
  80361a:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80361d:	b8 00 00 00 00       	mov    $0x0,%eax
  803622:	e9 e5 03 00 00       	jmp    803a0c <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803627:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80362c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  80362f:	e9 ab 03 00 00       	jmp    8039df <sget+0x590>
				if(size<currentfreeelement->size){
  803634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803637:	8b 50 04             	mov    0x4(%eax),%edx
  80363a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363d:	39 c2                	cmp    %eax,%edx
  80363f:	0f 86 24 02 00 00    	jbe    803869 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  803645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803648:	8b 10                	mov    (%eax),%edx
  80364a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80364d:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80364f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803652:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803655:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803658:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80365c:	75 17                	jne    803675 <sget+0x226>
  80365e:	83 ec 04             	sub    $0x4,%esp
  803661:	68 6c 5a 80 00       	push   $0x805a6c
  803666:	68 e0 01 00 00       	push   $0x1e0
  80366b:	68 20 5a 80 00       	push   $0x805a20
  803670:	e8 b6 d6 ff ff       	call   800d2b <_panic>
  803675:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80367b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80367e:	89 50 0c             	mov    %edx,0xc(%eax)
  803681:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803684:	8b 40 0c             	mov    0xc(%eax),%eax
  803687:	85 c0                	test   %eax,%eax
  803689:	74 0d                	je     803698 <sget+0x249>
  80368b:	a1 34 e1 81 00       	mov    0x81e134,%eax
  803690:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803693:	89 50 08             	mov    %edx,0x8(%eax)
  803696:	eb 08                	jmp    8036a0 <sget+0x251>
  803698:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80369b:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8036a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036a3:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8036a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036ab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8036b2:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8036b7:	40                   	inc    %eax
  8036b8:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  8036bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036c0:	8b 10                	mov    (%eax),%edx
  8036c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c5:	01 c2                	add    %eax,%edx
  8036c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ca:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  8036cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036cf:	8b 50 04             	mov    0x4(%eax),%edx
  8036d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d5:	29 c2                	sub    %eax,%edx
  8036d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036da:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8036dd:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8036e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  8036e5:	e9 13 01 00 00       	jmp    8037fd <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  8036ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ed:	8b 50 04             	mov    0x4(%eax),%edx
  8036f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f3:	8b 40 04             	mov    0x4(%eax),%eax
  8036f6:	39 c2                	cmp    %eax,%edx
  8036f8:	0f 83 f6 00 00 00    	jae    8037f4 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  8036fe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803702:	75 17                	jne    80371b <sget+0x2cc>
  803704:	83 ec 04             	sub    $0x4,%esp
  803707:	68 8f 5a 80 00       	push   $0x805a8f
  80370c:	68 e8 01 00 00       	push   $0x1e8
  803711:	68 20 5a 80 00       	push   $0x805a20
  803716:	e8 10 d6 ff ff       	call   800d2b <_panic>
  80371b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80371e:	8b 40 08             	mov    0x8(%eax),%eax
  803721:	85 c0                	test   %eax,%eax
  803723:	74 11                	je     803736 <sget+0x2e7>
  803725:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803728:	8b 40 08             	mov    0x8(%eax),%eax
  80372b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80372e:	8b 52 0c             	mov    0xc(%edx),%edx
  803731:	89 50 0c             	mov    %edx,0xc(%eax)
  803734:	eb 0b                	jmp    803741 <sget+0x2f2>
  803736:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803739:	8b 40 0c             	mov    0xc(%eax),%eax
  80373c:	a3 24 e1 81 00       	mov    %eax,0x81e124
  803741:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803744:	8b 40 0c             	mov    0xc(%eax),%eax
  803747:	85 c0                	test   %eax,%eax
  803749:	74 11                	je     80375c <sget+0x30d>
  80374b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80374e:	8b 40 0c             	mov    0xc(%eax),%eax
  803751:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803754:	8b 52 08             	mov    0x8(%edx),%edx
  803757:	89 50 08             	mov    %edx,0x8(%eax)
  80375a:	eb 0b                	jmp    803767 <sget+0x318>
  80375c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80375f:	8b 40 08             	mov    0x8(%eax),%eax
  803762:	a3 20 e1 81 00       	mov    %eax,0x81e120
  803767:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803771:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803774:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80377b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803780:	48                   	dec    %eax
  803781:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803786:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80378a:	74 06                	je     803792 <sget+0x343>
  80378c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803790:	75 17                	jne    8037a9 <sget+0x35a>
  803792:	83 ec 04             	sub    $0x4,%esp
  803795:	68 b0 5a 80 00       	push   $0x805ab0
  80379a:	68 e9 01 00 00       	push   $0x1e9
  80379f:	68 20 5a 80 00       	push   $0x805a20
  8037a4:	e8 82 d5 ff ff       	call   800d2b <_panic>
  8037a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ac:	8b 50 0c             	mov    0xc(%eax),%edx
  8037af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037b2:	89 50 0c             	mov    %edx,0xc(%eax)
  8037b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037bb:	89 50 08             	mov    %edx,0x8(%eax)
  8037be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c4:	85 c0                	test   %eax,%eax
  8037c6:	74 0e                	je     8037d6 <sget+0x387>
  8037c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037d1:	89 50 08             	mov    %edx,0x8(%eax)
  8037d4:	eb 08                	jmp    8037de <sget+0x38f>
  8037d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d9:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8037de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037e4:	89 50 0c             	mov    %edx,0xc(%eax)
  8037e7:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8037ec:	40                   	inc    %eax
  8037ed:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  8037f2:	eb 13                	jmp    803807 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  8037f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f7:	8b 40 08             	mov    0x8(%eax),%eax
  8037fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  8037fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803801:	0f 85 e3 fe ff ff    	jne    8036ea <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803807:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	83 ec 04             	sub    $0x4,%esp
  80380f:	50                   	push   %eax
  803810:	ff 75 0c             	pushl  0xc(%ebp)
  803813:	ff 75 08             	pushl  0x8(%ebp)
  803816:	e8 70 04 00 00       	call   803c8b <sys_get_shared_object>
  80381b:	83 c4 10             	add    $0x10,%esp
  80381e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  803821:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803825:	79 28                	jns    80384f <sget+0x400>
						free_block(allocblock);
  803827:	83 ec 0c             	sub    $0xc,%esp
  80382a:	ff 75 e0             	pushl  -0x20(%ebp)
  80382d:	e8 b0 0e 00 00       	call   8046e2 <free_block>
  803832:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803835:	83 ec 0c             	sub    $0xc,%esp
  803838:	68 40 e1 81 00       	push   $0x81e140
  80383d:	e8 c4 12 00 00       	call   804b06 <release_uspinlock>
  803842:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803845:	b8 00 00 00 00       	mov    $0x0,%eax
  80384a:	e9 bd 01 00 00       	jmp    803a0c <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  80384f:	83 ec 0c             	sub    $0xc,%esp
  803852:	68 40 e1 81 00       	push   $0x81e140
  803857:	e8 aa 12 00 00       	call   804b06 <release_uspinlock>
  80385c:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80385f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803862:	8b 00                	mov    (%eax),%eax
  803864:	e9 a3 01 00 00       	jmp    803a0c <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  803869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386c:	8b 50 04             	mov    0x4(%eax),%edx
  80386f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803872:	39 c2                	cmp    %eax,%edx
  803874:	0f 85 5c 01 00 00    	jne    8039d6 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  80387a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387d:	8b 10                	mov    (%eax),%edx
  80387f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803882:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803884:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803887:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80388a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  80388d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803891:	75 17                	jne    8038aa <sget+0x45b>
  803893:	83 ec 04             	sub    $0x4,%esp
  803896:	68 6c 5a 80 00       	push   $0x805a6c
  80389b:	68 fe 01 00 00       	push   $0x1fe
  8038a0:	68 20 5a 80 00       	push   $0x805a20
  8038a5:	e8 81 d4 ff ff       	call   800d2b <_panic>
  8038aa:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8038b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b3:	89 50 0c             	mov    %edx,0xc(%eax)
  8038b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8038bc:	85 c0                	test   %eax,%eax
  8038be:	74 0d                	je     8038cd <sget+0x47e>
  8038c0:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8038c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038c8:	89 50 08             	mov    %edx,0x8(%eax)
  8038cb:	eb 08                	jmp    8038d5 <sget+0x486>
  8038cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038d0:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8038d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038d8:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8038dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8038e7:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8038ec:	40                   	inc    %eax
  8038ed:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8038f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f6:	75 17                	jne    80390f <sget+0x4c0>
  8038f8:	83 ec 04             	sub    $0x4,%esp
  8038fb:	68 8f 5a 80 00       	push   $0x805a8f
  803900:	68 ff 01 00 00       	push   $0x1ff
  803905:	68 20 5a 80 00       	push   $0x805a20
  80390a:	e8 1c d4 ff ff       	call   800d2b <_panic>
  80390f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803912:	8b 40 08             	mov    0x8(%eax),%eax
  803915:	85 c0                	test   %eax,%eax
  803917:	74 11                	je     80392a <sget+0x4db>
  803919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391c:	8b 40 08             	mov    0x8(%eax),%eax
  80391f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803922:	8b 52 0c             	mov    0xc(%edx),%edx
  803925:	89 50 0c             	mov    %edx,0xc(%eax)
  803928:	eb 0b                	jmp    803935 <sget+0x4e6>
  80392a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392d:	8b 40 0c             	mov    0xc(%eax),%eax
  803930:	a3 24 e1 81 00       	mov    %eax,0x81e124
  803935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803938:	8b 40 0c             	mov    0xc(%eax),%eax
  80393b:	85 c0                	test   %eax,%eax
  80393d:	74 11                	je     803950 <sget+0x501>
  80393f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803942:	8b 40 0c             	mov    0xc(%eax),%eax
  803945:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803948:	8b 52 08             	mov    0x8(%edx),%edx
  80394b:	89 50 08             	mov    %edx,0x8(%eax)
  80394e:	eb 0b                	jmp    80395b <sget+0x50c>
  803950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803953:	8b 40 08             	mov    0x8(%eax),%eax
  803956:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80395b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803968:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80396f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803974:	48                   	dec    %eax
  803975:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80397a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80397d:	8b 00                	mov    (%eax),%eax
  80397f:	83 ec 04             	sub    $0x4,%esp
  803982:	50                   	push   %eax
  803983:	ff 75 0c             	pushl  0xc(%ebp)
  803986:	ff 75 08             	pushl  0x8(%ebp)
  803989:	e8 fd 02 00 00       	call   803c8b <sys_get_shared_object>
  80398e:	83 c4 10             	add    $0x10,%esp
  803991:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803994:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803998:	79 25                	jns    8039bf <sget+0x570>
						free_block(allocblock);
  80399a:	83 ec 0c             	sub    $0xc,%esp
  80399d:	ff 75 e0             	pushl  -0x20(%ebp)
  8039a0:	e8 3d 0d 00 00       	call   8046e2 <free_block>
  8039a5:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8039a8:	83 ec 0c             	sub    $0xc,%esp
  8039ab:	68 40 e1 81 00       	push   $0x81e140
  8039b0:	e8 51 11 00 00       	call   804b06 <release_uspinlock>
  8039b5:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8039b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bd:	eb 4d                	jmp    803a0c <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  8039bf:	83 ec 0c             	sub    $0xc,%esp
  8039c2:	68 40 e1 81 00       	push   $0x81e140
  8039c7:	e8 3a 11 00 00       	call   804b06 <release_uspinlock>
  8039cc:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8039cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039d2:	8b 00                	mov    (%eax),%eax
  8039d4:	eb 36                	jmp    803a0c <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8039d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d9:	8b 40 08             	mov    0x8(%eax),%eax
  8039dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8039df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039e3:	0f 85 4b fc ff ff    	jne    803634 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8039e9:	83 ec 0c             	sub    $0xc,%esp
  8039ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8039ef:	e8 ee 0c 00 00       	call   8046e2 <free_block>
  8039f4:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8039f7:	83 ec 0c             	sub    $0xc,%esp
  8039fa:	68 40 e1 81 00       	push   $0x81e140
  8039ff:	e8 02 11 00 00       	call   804b06 <release_uspinlock>
  803a04:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a0c:	c9                   	leave  
  803a0d:	c3                   	ret    

00803a0e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803a0e:	55                   	push   %ebp
  803a0f:	89 e5                	mov    %esp,%ebp
  803a11:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803a14:	e8 cd e6 ff ff       	call   8020e6 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803a19:	83 ec 04             	sub    $0x4,%esp
  803a1c:	68 40 5b 80 00       	push   $0x805b40
  803a21:	68 2d 02 00 00       	push   $0x22d
  803a26:	68 20 5a 80 00       	push   $0x805a20
  803a2b:	e8 fb d2 ff ff       	call   800d2b <_panic>

00803a30 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803a30:	55                   	push   %ebp
  803a31:	89 e5                	mov    %esp,%ebp
  803a33:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803a36:	83 ec 04             	sub    $0x4,%esp
  803a39:	68 68 5b 80 00       	push   $0x805b68
  803a3e:	68 40 02 00 00       	push   $0x240
  803a43:	68 20 5a 80 00       	push   $0x805a20
  803a48:	e8 de d2 ff ff       	call   800d2b <_panic>

00803a4d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803a4d:	55                   	push   %ebp
  803a4e:	89 e5                	mov    %esp,%ebp
  803a50:	57                   	push   %edi
  803a51:	56                   	push   %esi
  803a52:	53                   	push   %ebx
  803a53:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803a56:	8b 45 08             	mov    0x8(%ebp),%eax
  803a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803a5f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803a62:	8b 7d 18             	mov    0x18(%ebp),%edi
  803a65:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803a68:	cd 30                	int    $0x30
  803a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803a70:	83 c4 10             	add    $0x10,%esp
  803a73:	5b                   	pop    %ebx
  803a74:	5e                   	pop    %esi
  803a75:	5f                   	pop    %edi
  803a76:	5d                   	pop    %ebp
  803a77:	c3                   	ret    

00803a78 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803a78:	55                   	push   %ebp
  803a79:	89 e5                	mov    %esp,%ebp
  803a7b:	83 ec 04             	sub    $0x4,%esp
  803a7e:	8b 45 10             	mov    0x10(%ebp),%eax
  803a81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803a84:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803a87:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8e:	6a 00                	push   $0x0
  803a90:	51                   	push   %ecx
  803a91:	52                   	push   %edx
  803a92:	ff 75 0c             	pushl  0xc(%ebp)
  803a95:	50                   	push   %eax
  803a96:	6a 00                	push   $0x0
  803a98:	e8 b0 ff ff ff       	call   803a4d <syscall>
  803a9d:	83 c4 18             	add    $0x18,%esp
}
  803aa0:	90                   	nop
  803aa1:	c9                   	leave  
  803aa2:	c3                   	ret    

00803aa3 <sys_cgetc>:

int
sys_cgetc(void)
{
  803aa3:	55                   	push   %ebp
  803aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803aa6:	6a 00                	push   $0x0
  803aa8:	6a 00                	push   $0x0
  803aaa:	6a 00                	push   $0x0
  803aac:	6a 00                	push   $0x0
  803aae:	6a 00                	push   $0x0
  803ab0:	6a 02                	push   $0x2
  803ab2:	e8 96 ff ff ff       	call   803a4d <syscall>
  803ab7:	83 c4 18             	add    $0x18,%esp
}
  803aba:	c9                   	leave  
  803abb:	c3                   	ret    

00803abc <sys_lock_cons>:

void sys_lock_cons(void)
{
  803abc:	55                   	push   %ebp
  803abd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803abf:	6a 00                	push   $0x0
  803ac1:	6a 00                	push   $0x0
  803ac3:	6a 00                	push   $0x0
  803ac5:	6a 00                	push   $0x0
  803ac7:	6a 00                	push   $0x0
  803ac9:	6a 03                	push   $0x3
  803acb:	e8 7d ff ff ff       	call   803a4d <syscall>
  803ad0:	83 c4 18             	add    $0x18,%esp
}
  803ad3:	90                   	nop
  803ad4:	c9                   	leave  
  803ad5:	c3                   	ret    

00803ad6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803ad6:	55                   	push   %ebp
  803ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803ad9:	6a 00                	push   $0x0
  803adb:	6a 00                	push   $0x0
  803add:	6a 00                	push   $0x0
  803adf:	6a 00                	push   $0x0
  803ae1:	6a 00                	push   $0x0
  803ae3:	6a 04                	push   $0x4
  803ae5:	e8 63 ff ff ff       	call   803a4d <syscall>
  803aea:	83 c4 18             	add    $0x18,%esp
}
  803aed:	90                   	nop
  803aee:	c9                   	leave  
  803aef:	c3                   	ret    

00803af0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803af0:	55                   	push   %ebp
  803af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	6a 00                	push   $0x0
  803afb:	6a 00                	push   $0x0
  803afd:	6a 00                	push   $0x0
  803aff:	52                   	push   %edx
  803b00:	50                   	push   %eax
  803b01:	6a 08                	push   $0x8
  803b03:	e8 45 ff ff ff       	call   803a4d <syscall>
  803b08:	83 c4 18             	add    $0x18,%esp
}
  803b0b:	c9                   	leave  
  803b0c:	c3                   	ret    

00803b0d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803b0d:	55                   	push   %ebp
  803b0e:	89 e5                	mov    %esp,%ebp
  803b10:	56                   	push   %esi
  803b11:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803b12:	8b 75 18             	mov    0x18(%ebp),%esi
  803b15:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803b18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b21:	56                   	push   %esi
  803b22:	53                   	push   %ebx
  803b23:	51                   	push   %ecx
  803b24:	52                   	push   %edx
  803b25:	50                   	push   %eax
  803b26:	6a 09                	push   $0x9
  803b28:	e8 20 ff ff ff       	call   803a4d <syscall>
  803b2d:	83 c4 18             	add    $0x18,%esp
}
  803b30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803b33:	5b                   	pop    %ebx
  803b34:	5e                   	pop    %esi
  803b35:	5d                   	pop    %ebp
  803b36:	c3                   	ret    

00803b37 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803b37:	55                   	push   %ebp
  803b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803b3a:	6a 00                	push   $0x0
  803b3c:	6a 00                	push   $0x0
  803b3e:	6a 00                	push   $0x0
  803b40:	6a 00                	push   $0x0
  803b42:	ff 75 08             	pushl  0x8(%ebp)
  803b45:	6a 0a                	push   $0xa
  803b47:	e8 01 ff ff ff       	call   803a4d <syscall>
  803b4c:	83 c4 18             	add    $0x18,%esp
}
  803b4f:	c9                   	leave  
  803b50:	c3                   	ret    

00803b51 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803b51:	55                   	push   %ebp
  803b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803b54:	6a 00                	push   $0x0
  803b56:	6a 00                	push   $0x0
  803b58:	6a 00                	push   $0x0
  803b5a:	ff 75 0c             	pushl  0xc(%ebp)
  803b5d:	ff 75 08             	pushl  0x8(%ebp)
  803b60:	6a 0b                	push   $0xb
  803b62:	e8 e6 fe ff ff       	call   803a4d <syscall>
  803b67:	83 c4 18             	add    $0x18,%esp
}
  803b6a:	c9                   	leave  
  803b6b:	c3                   	ret    

00803b6c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803b6c:	55                   	push   %ebp
  803b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803b6f:	6a 00                	push   $0x0
  803b71:	6a 00                	push   $0x0
  803b73:	6a 00                	push   $0x0
  803b75:	6a 00                	push   $0x0
  803b77:	6a 00                	push   $0x0
  803b79:	6a 0c                	push   $0xc
  803b7b:	e8 cd fe ff ff       	call   803a4d <syscall>
  803b80:	83 c4 18             	add    $0x18,%esp
}
  803b83:	c9                   	leave  
  803b84:	c3                   	ret    

00803b85 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803b85:	55                   	push   %ebp
  803b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803b88:	6a 00                	push   $0x0
  803b8a:	6a 00                	push   $0x0
  803b8c:	6a 00                	push   $0x0
  803b8e:	6a 00                	push   $0x0
  803b90:	6a 00                	push   $0x0
  803b92:	6a 0d                	push   $0xd
  803b94:	e8 b4 fe ff ff       	call   803a4d <syscall>
  803b99:	83 c4 18             	add    $0x18,%esp
}
  803b9c:	c9                   	leave  
  803b9d:	c3                   	ret    

00803b9e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803b9e:	55                   	push   %ebp
  803b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803ba1:	6a 00                	push   $0x0
  803ba3:	6a 00                	push   $0x0
  803ba5:	6a 00                	push   $0x0
  803ba7:	6a 00                	push   $0x0
  803ba9:	6a 00                	push   $0x0
  803bab:	6a 0e                	push   $0xe
  803bad:	e8 9b fe ff ff       	call   803a4d <syscall>
  803bb2:	83 c4 18             	add    $0x18,%esp
}
  803bb5:	c9                   	leave  
  803bb6:	c3                   	ret    

00803bb7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803bb7:	55                   	push   %ebp
  803bb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803bba:	6a 00                	push   $0x0
  803bbc:	6a 00                	push   $0x0
  803bbe:	6a 00                	push   $0x0
  803bc0:	6a 00                	push   $0x0
  803bc2:	6a 00                	push   $0x0
  803bc4:	6a 0f                	push   $0xf
  803bc6:	e8 82 fe ff ff       	call   803a4d <syscall>
  803bcb:	83 c4 18             	add    $0x18,%esp
}
  803bce:	c9                   	leave  
  803bcf:	c3                   	ret    

00803bd0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803bd0:	55                   	push   %ebp
  803bd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803bd3:	6a 00                	push   $0x0
  803bd5:	6a 00                	push   $0x0
  803bd7:	6a 00                	push   $0x0
  803bd9:	6a 00                	push   $0x0
  803bdb:	ff 75 08             	pushl  0x8(%ebp)
  803bde:	6a 10                	push   $0x10
  803be0:	e8 68 fe ff ff       	call   803a4d <syscall>
  803be5:	83 c4 18             	add    $0x18,%esp
}
  803be8:	c9                   	leave  
  803be9:	c3                   	ret    

00803bea <sys_scarce_memory>:

void sys_scarce_memory()
{
  803bea:	55                   	push   %ebp
  803beb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803bed:	6a 00                	push   $0x0
  803bef:	6a 00                	push   $0x0
  803bf1:	6a 00                	push   $0x0
  803bf3:	6a 00                	push   $0x0
  803bf5:	6a 00                	push   $0x0
  803bf7:	6a 11                	push   $0x11
  803bf9:	e8 4f fe ff ff       	call   803a4d <syscall>
  803bfe:	83 c4 18             	add    $0x18,%esp
}
  803c01:	90                   	nop
  803c02:	c9                   	leave  
  803c03:	c3                   	ret    

00803c04 <sys_cputc>:

void
sys_cputc(const char c)
{
  803c04:	55                   	push   %ebp
  803c05:	89 e5                	mov    %esp,%ebp
  803c07:	83 ec 04             	sub    $0x4,%esp
  803c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803c10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803c14:	6a 00                	push   $0x0
  803c16:	6a 00                	push   $0x0
  803c18:	6a 00                	push   $0x0
  803c1a:	6a 00                	push   $0x0
  803c1c:	50                   	push   %eax
  803c1d:	6a 01                	push   $0x1
  803c1f:	e8 29 fe ff ff       	call   803a4d <syscall>
  803c24:	83 c4 18             	add    $0x18,%esp
}
  803c27:	90                   	nop
  803c28:	c9                   	leave  
  803c29:	c3                   	ret    

00803c2a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803c2a:	55                   	push   %ebp
  803c2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803c2d:	6a 00                	push   $0x0
  803c2f:	6a 00                	push   $0x0
  803c31:	6a 00                	push   $0x0
  803c33:	6a 00                	push   $0x0
  803c35:	6a 00                	push   $0x0
  803c37:	6a 14                	push   $0x14
  803c39:	e8 0f fe ff ff       	call   803a4d <syscall>
  803c3e:	83 c4 18             	add    $0x18,%esp
}
  803c41:	90                   	nop
  803c42:	c9                   	leave  
  803c43:	c3                   	ret    

00803c44 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803c44:	55                   	push   %ebp
  803c45:	89 e5                	mov    %esp,%ebp
  803c47:	83 ec 04             	sub    $0x4,%esp
  803c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  803c4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803c50:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803c53:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803c57:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5a:	6a 00                	push   $0x0
  803c5c:	51                   	push   %ecx
  803c5d:	52                   	push   %edx
  803c5e:	ff 75 0c             	pushl  0xc(%ebp)
  803c61:	50                   	push   %eax
  803c62:	6a 15                	push   $0x15
  803c64:	e8 e4 fd ff ff       	call   803a4d <syscall>
  803c69:	83 c4 18             	add    $0x18,%esp
}
  803c6c:	c9                   	leave  
  803c6d:	c3                   	ret    

00803c6e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803c6e:	55                   	push   %ebp
  803c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c74:	8b 45 08             	mov    0x8(%ebp),%eax
  803c77:	6a 00                	push   $0x0
  803c79:	6a 00                	push   $0x0
  803c7b:	6a 00                	push   $0x0
  803c7d:	52                   	push   %edx
  803c7e:	50                   	push   %eax
  803c7f:	6a 16                	push   $0x16
  803c81:	e8 c7 fd ff ff       	call   803a4d <syscall>
  803c86:	83 c4 18             	add    $0x18,%esp
}
  803c89:	c9                   	leave  
  803c8a:	c3                   	ret    

00803c8b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803c8b:	55                   	push   %ebp
  803c8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803c8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803c91:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c94:	8b 45 08             	mov    0x8(%ebp),%eax
  803c97:	6a 00                	push   $0x0
  803c99:	6a 00                	push   $0x0
  803c9b:	51                   	push   %ecx
  803c9c:	52                   	push   %edx
  803c9d:	50                   	push   %eax
  803c9e:	6a 17                	push   $0x17
  803ca0:	e8 a8 fd ff ff       	call   803a4d <syscall>
  803ca5:	83 c4 18             	add    $0x18,%esp
}
  803ca8:	c9                   	leave  
  803ca9:	c3                   	ret    

00803caa <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803caa:	55                   	push   %ebp
  803cab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb3:	6a 00                	push   $0x0
  803cb5:	6a 00                	push   $0x0
  803cb7:	6a 00                	push   $0x0
  803cb9:	52                   	push   %edx
  803cba:	50                   	push   %eax
  803cbb:	6a 18                	push   $0x18
  803cbd:	e8 8b fd ff ff       	call   803a4d <syscall>
  803cc2:	83 c4 18             	add    $0x18,%esp
}
  803cc5:	c9                   	leave  
  803cc6:	c3                   	ret    

00803cc7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803cc7:	55                   	push   %ebp
  803cc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803cca:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccd:	6a 00                	push   $0x0
  803ccf:	ff 75 14             	pushl  0x14(%ebp)
  803cd2:	ff 75 10             	pushl  0x10(%ebp)
  803cd5:	ff 75 0c             	pushl  0xc(%ebp)
  803cd8:	50                   	push   %eax
  803cd9:	6a 19                	push   $0x19
  803cdb:	e8 6d fd ff ff       	call   803a4d <syscall>
  803ce0:	83 c4 18             	add    $0x18,%esp
}
  803ce3:	c9                   	leave  
  803ce4:	c3                   	ret    

00803ce5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803ce5:	55                   	push   %ebp
  803ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ceb:	6a 00                	push   $0x0
  803ced:	6a 00                	push   $0x0
  803cef:	6a 00                	push   $0x0
  803cf1:	6a 00                	push   $0x0
  803cf3:	50                   	push   %eax
  803cf4:	6a 1a                	push   $0x1a
  803cf6:	e8 52 fd ff ff       	call   803a4d <syscall>
  803cfb:	83 c4 18             	add    $0x18,%esp
}
  803cfe:	90                   	nop
  803cff:	c9                   	leave  
  803d00:	c3                   	ret    

00803d01 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803d01:	55                   	push   %ebp
  803d02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803d04:	8b 45 08             	mov    0x8(%ebp),%eax
  803d07:	6a 00                	push   $0x0
  803d09:	6a 00                	push   $0x0
  803d0b:	6a 00                	push   $0x0
  803d0d:	6a 00                	push   $0x0
  803d0f:	50                   	push   %eax
  803d10:	6a 1b                	push   $0x1b
  803d12:	e8 36 fd ff ff       	call   803a4d <syscall>
  803d17:	83 c4 18             	add    $0x18,%esp
}
  803d1a:	c9                   	leave  
  803d1b:	c3                   	ret    

00803d1c <sys_getenvid>:

int32 sys_getenvid(void)
{
  803d1c:	55                   	push   %ebp
  803d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803d1f:	6a 00                	push   $0x0
  803d21:	6a 00                	push   $0x0
  803d23:	6a 00                	push   $0x0
  803d25:	6a 00                	push   $0x0
  803d27:	6a 00                	push   $0x0
  803d29:	6a 05                	push   $0x5
  803d2b:	e8 1d fd ff ff       	call   803a4d <syscall>
  803d30:	83 c4 18             	add    $0x18,%esp
}
  803d33:	c9                   	leave  
  803d34:	c3                   	ret    

00803d35 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803d35:	55                   	push   %ebp
  803d36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803d38:	6a 00                	push   $0x0
  803d3a:	6a 00                	push   $0x0
  803d3c:	6a 00                	push   $0x0
  803d3e:	6a 00                	push   $0x0
  803d40:	6a 00                	push   $0x0
  803d42:	6a 06                	push   $0x6
  803d44:	e8 04 fd ff ff       	call   803a4d <syscall>
  803d49:	83 c4 18             	add    $0x18,%esp
}
  803d4c:	c9                   	leave  
  803d4d:	c3                   	ret    

00803d4e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803d4e:	55                   	push   %ebp
  803d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803d51:	6a 00                	push   $0x0
  803d53:	6a 00                	push   $0x0
  803d55:	6a 00                	push   $0x0
  803d57:	6a 00                	push   $0x0
  803d59:	6a 00                	push   $0x0
  803d5b:	6a 07                	push   $0x7
  803d5d:	e8 eb fc ff ff       	call   803a4d <syscall>
  803d62:	83 c4 18             	add    $0x18,%esp
}
  803d65:	c9                   	leave  
  803d66:	c3                   	ret    

00803d67 <sys_exit_env>:


void sys_exit_env(void)
{
  803d67:	55                   	push   %ebp
  803d68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803d6a:	6a 00                	push   $0x0
  803d6c:	6a 00                	push   $0x0
  803d6e:	6a 00                	push   $0x0
  803d70:	6a 00                	push   $0x0
  803d72:	6a 00                	push   $0x0
  803d74:	6a 1c                	push   $0x1c
  803d76:	e8 d2 fc ff ff       	call   803a4d <syscall>
  803d7b:	83 c4 18             	add    $0x18,%esp
}
  803d7e:	90                   	nop
  803d7f:	c9                   	leave  
  803d80:	c3                   	ret    

00803d81 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803d81:	55                   	push   %ebp
  803d82:	89 e5                	mov    %esp,%ebp
  803d84:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803d87:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803d8a:	8d 50 04             	lea    0x4(%eax),%edx
  803d8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803d90:	6a 00                	push   $0x0
  803d92:	6a 00                	push   $0x0
  803d94:	6a 00                	push   $0x0
  803d96:	52                   	push   %edx
  803d97:	50                   	push   %eax
  803d98:	6a 1d                	push   $0x1d
  803d9a:	e8 ae fc ff ff       	call   803a4d <syscall>
  803d9f:	83 c4 18             	add    $0x18,%esp
	return result;
  803da2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803da5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803da8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803dab:	89 01                	mov    %eax,(%ecx)
  803dad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803db0:	8b 45 08             	mov    0x8(%ebp),%eax
  803db3:	c9                   	leave  
  803db4:	c2 04 00             	ret    $0x4

00803db7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803db7:	55                   	push   %ebp
  803db8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803dba:	6a 00                	push   $0x0
  803dbc:	6a 00                	push   $0x0
  803dbe:	ff 75 10             	pushl  0x10(%ebp)
  803dc1:	ff 75 0c             	pushl  0xc(%ebp)
  803dc4:	ff 75 08             	pushl  0x8(%ebp)
  803dc7:	6a 13                	push   $0x13
  803dc9:	e8 7f fc ff ff       	call   803a4d <syscall>
  803dce:	83 c4 18             	add    $0x18,%esp
	return ;
  803dd1:	90                   	nop
}
  803dd2:	c9                   	leave  
  803dd3:	c3                   	ret    

00803dd4 <sys_rcr2>:
uint32 sys_rcr2()
{
  803dd4:	55                   	push   %ebp
  803dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803dd7:	6a 00                	push   $0x0
  803dd9:	6a 00                	push   $0x0
  803ddb:	6a 00                	push   $0x0
  803ddd:	6a 00                	push   $0x0
  803ddf:	6a 00                	push   $0x0
  803de1:	6a 1e                	push   $0x1e
  803de3:	e8 65 fc ff ff       	call   803a4d <syscall>
  803de8:	83 c4 18             	add    $0x18,%esp
}
  803deb:	c9                   	leave  
  803dec:	c3                   	ret    

00803ded <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803ded:	55                   	push   %ebp
  803dee:	89 e5                	mov    %esp,%ebp
  803df0:	83 ec 04             	sub    $0x4,%esp
  803df3:	8b 45 08             	mov    0x8(%ebp),%eax
  803df6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803df9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803dfd:	6a 00                	push   $0x0
  803dff:	6a 00                	push   $0x0
  803e01:	6a 00                	push   $0x0
  803e03:	6a 00                	push   $0x0
  803e05:	50                   	push   %eax
  803e06:	6a 1f                	push   $0x1f
  803e08:	e8 40 fc ff ff       	call   803a4d <syscall>
  803e0d:	83 c4 18             	add    $0x18,%esp
	return ;
  803e10:	90                   	nop
}
  803e11:	c9                   	leave  
  803e12:	c3                   	ret    

00803e13 <rsttst>:
void rsttst()
{
  803e13:	55                   	push   %ebp
  803e14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803e16:	6a 00                	push   $0x0
  803e18:	6a 00                	push   $0x0
  803e1a:	6a 00                	push   $0x0
  803e1c:	6a 00                	push   $0x0
  803e1e:	6a 00                	push   $0x0
  803e20:	6a 21                	push   $0x21
  803e22:	e8 26 fc ff ff       	call   803a4d <syscall>
  803e27:	83 c4 18             	add    $0x18,%esp
	return ;
  803e2a:	90                   	nop
}
  803e2b:	c9                   	leave  
  803e2c:	c3                   	ret    

00803e2d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803e2d:	55                   	push   %ebp
  803e2e:	89 e5                	mov    %esp,%ebp
  803e30:	83 ec 04             	sub    $0x4,%esp
  803e33:	8b 45 14             	mov    0x14(%ebp),%eax
  803e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803e39:	8b 55 18             	mov    0x18(%ebp),%edx
  803e3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803e40:	52                   	push   %edx
  803e41:	50                   	push   %eax
  803e42:	ff 75 10             	pushl  0x10(%ebp)
  803e45:	ff 75 0c             	pushl  0xc(%ebp)
  803e48:	ff 75 08             	pushl  0x8(%ebp)
  803e4b:	6a 20                	push   $0x20
  803e4d:	e8 fb fb ff ff       	call   803a4d <syscall>
  803e52:	83 c4 18             	add    $0x18,%esp
	return ;
  803e55:	90                   	nop
}
  803e56:	c9                   	leave  
  803e57:	c3                   	ret    

00803e58 <chktst>:
void chktst(uint32 n)
{
  803e58:	55                   	push   %ebp
  803e59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803e5b:	6a 00                	push   $0x0
  803e5d:	6a 00                	push   $0x0
  803e5f:	6a 00                	push   $0x0
  803e61:	6a 00                	push   $0x0
  803e63:	ff 75 08             	pushl  0x8(%ebp)
  803e66:	6a 22                	push   $0x22
  803e68:	e8 e0 fb ff ff       	call   803a4d <syscall>
  803e6d:	83 c4 18             	add    $0x18,%esp
	return ;
  803e70:	90                   	nop
}
  803e71:	c9                   	leave  
  803e72:	c3                   	ret    

00803e73 <inctst>:

void inctst()
{
  803e73:	55                   	push   %ebp
  803e74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803e76:	6a 00                	push   $0x0
  803e78:	6a 00                	push   $0x0
  803e7a:	6a 00                	push   $0x0
  803e7c:	6a 00                	push   $0x0
  803e7e:	6a 00                	push   $0x0
  803e80:	6a 23                	push   $0x23
  803e82:	e8 c6 fb ff ff       	call   803a4d <syscall>
  803e87:	83 c4 18             	add    $0x18,%esp
	return ;
  803e8a:	90                   	nop
}
  803e8b:	c9                   	leave  
  803e8c:	c3                   	ret    

00803e8d <gettst>:
uint32 gettst()
{
  803e8d:	55                   	push   %ebp
  803e8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803e90:	6a 00                	push   $0x0
  803e92:	6a 00                	push   $0x0
  803e94:	6a 00                	push   $0x0
  803e96:	6a 00                	push   $0x0
  803e98:	6a 00                	push   $0x0
  803e9a:	6a 24                	push   $0x24
  803e9c:	e8 ac fb ff ff       	call   803a4d <syscall>
  803ea1:	83 c4 18             	add    $0x18,%esp
}
  803ea4:	c9                   	leave  
  803ea5:	c3                   	ret    

00803ea6 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803ea6:	55                   	push   %ebp
  803ea7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803ea9:	6a 00                	push   $0x0
  803eab:	6a 00                	push   $0x0
  803ead:	6a 00                	push   $0x0
  803eaf:	6a 00                	push   $0x0
  803eb1:	6a 00                	push   $0x0
  803eb3:	6a 25                	push   $0x25
  803eb5:	e8 93 fb ff ff       	call   803a4d <syscall>
  803eba:	83 c4 18             	add    $0x18,%esp
  803ebd:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  803ec2:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  803ec7:	c9                   	leave  
  803ec8:	c3                   	ret    

00803ec9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803ec9:	55                   	push   %ebp
  803eca:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  803ecf:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803ed4:	6a 00                	push   $0x0
  803ed6:	6a 00                	push   $0x0
  803ed8:	6a 00                	push   $0x0
  803eda:	6a 00                	push   $0x0
  803edc:	ff 75 08             	pushl  0x8(%ebp)
  803edf:	6a 26                	push   $0x26
  803ee1:	e8 67 fb ff ff       	call   803a4d <syscall>
  803ee6:	83 c4 18             	add    $0x18,%esp
	return ;
  803ee9:	90                   	nop
}
  803eea:	c9                   	leave  
  803eeb:	c3                   	ret    

00803eec <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803eec:	55                   	push   %ebp
  803eed:	89 e5                	mov    %esp,%ebp
  803eef:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803ef0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803ef3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  803efc:	6a 00                	push   $0x0
  803efe:	53                   	push   %ebx
  803eff:	51                   	push   %ecx
  803f00:	52                   	push   %edx
  803f01:	50                   	push   %eax
  803f02:	6a 27                	push   $0x27
  803f04:	e8 44 fb ff ff       	call   803a4d <syscall>
  803f09:	83 c4 18             	add    $0x18,%esp
}
  803f0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803f0f:	c9                   	leave  
  803f10:	c3                   	ret    

00803f11 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803f11:	55                   	push   %ebp
  803f12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  803f17:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1a:	6a 00                	push   $0x0
  803f1c:	6a 00                	push   $0x0
  803f1e:	6a 00                	push   $0x0
  803f20:	52                   	push   %edx
  803f21:	50                   	push   %eax
  803f22:	6a 28                	push   $0x28
  803f24:	e8 24 fb ff ff       	call   803a4d <syscall>
  803f29:	83 c4 18             	add    $0x18,%esp
}
  803f2c:	c9                   	leave  
  803f2d:	c3                   	ret    

00803f2e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803f2e:	55                   	push   %ebp
  803f2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803f31:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803f34:	8b 55 0c             	mov    0xc(%ebp),%edx
  803f37:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3a:	6a 00                	push   $0x0
  803f3c:	51                   	push   %ecx
  803f3d:	ff 75 10             	pushl  0x10(%ebp)
  803f40:	52                   	push   %edx
  803f41:	50                   	push   %eax
  803f42:	6a 29                	push   $0x29
  803f44:	e8 04 fb ff ff       	call   803a4d <syscall>
  803f49:	83 c4 18             	add    $0x18,%esp
}
  803f4c:	c9                   	leave  
  803f4d:	c3                   	ret    

00803f4e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803f4e:	55                   	push   %ebp
  803f4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803f51:	6a 00                	push   $0x0
  803f53:	6a 00                	push   $0x0
  803f55:	ff 75 10             	pushl  0x10(%ebp)
  803f58:	ff 75 0c             	pushl  0xc(%ebp)
  803f5b:	ff 75 08             	pushl  0x8(%ebp)
  803f5e:	6a 12                	push   $0x12
  803f60:	e8 e8 fa ff ff       	call   803a4d <syscall>
  803f65:	83 c4 18             	add    $0x18,%esp
	return ;
  803f68:	90                   	nop
}
  803f69:	c9                   	leave  
  803f6a:	c3                   	ret    

00803f6b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803f6b:	55                   	push   %ebp
  803f6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803f71:	8b 45 08             	mov    0x8(%ebp),%eax
  803f74:	6a 00                	push   $0x0
  803f76:	6a 00                	push   $0x0
  803f78:	6a 00                	push   $0x0
  803f7a:	52                   	push   %edx
  803f7b:	50                   	push   %eax
  803f7c:	6a 2a                	push   $0x2a
  803f7e:	e8 ca fa ff ff       	call   803a4d <syscall>
  803f83:	83 c4 18             	add    $0x18,%esp
	return;
  803f86:	90                   	nop
}
  803f87:	c9                   	leave  
  803f88:	c3                   	ret    

00803f89 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803f89:	55                   	push   %ebp
  803f8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803f8c:	6a 00                	push   $0x0
  803f8e:	6a 00                	push   $0x0
  803f90:	6a 00                	push   $0x0
  803f92:	6a 00                	push   $0x0
  803f94:	6a 00                	push   $0x0
  803f96:	6a 2b                	push   $0x2b
  803f98:	e8 b0 fa ff ff       	call   803a4d <syscall>
  803f9d:	83 c4 18             	add    $0x18,%esp
}
  803fa0:	c9                   	leave  
  803fa1:	c3                   	ret    

00803fa2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803fa2:	55                   	push   %ebp
  803fa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803fa5:	6a 00                	push   $0x0
  803fa7:	6a 00                	push   $0x0
  803fa9:	6a 00                	push   $0x0
  803fab:	ff 75 0c             	pushl  0xc(%ebp)
  803fae:	ff 75 08             	pushl  0x8(%ebp)
  803fb1:	6a 2d                	push   $0x2d
  803fb3:	e8 95 fa ff ff       	call   803a4d <syscall>
  803fb8:	83 c4 18             	add    $0x18,%esp
	return;
  803fbb:	90                   	nop
}
  803fbc:	c9                   	leave  
  803fbd:	c3                   	ret    

00803fbe <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803fbe:	55                   	push   %ebp
  803fbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803fc1:	6a 00                	push   $0x0
  803fc3:	6a 00                	push   $0x0
  803fc5:	6a 00                	push   $0x0
  803fc7:	ff 75 0c             	pushl  0xc(%ebp)
  803fca:	ff 75 08             	pushl  0x8(%ebp)
  803fcd:	6a 2c                	push   $0x2c
  803fcf:	e8 79 fa ff ff       	call   803a4d <syscall>
  803fd4:	83 c4 18             	add    $0x18,%esp
	return ;
  803fd7:	90                   	nop
}
  803fd8:	c9                   	leave  
  803fd9:	c3                   	ret    

00803fda <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803fda:	55                   	push   %ebp
  803fdb:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803fdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  803fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe3:	6a 00                	push   $0x0
  803fe5:	6a 00                	push   $0x0
  803fe7:	6a 00                	push   $0x0
  803fe9:	52                   	push   %edx
  803fea:	50                   	push   %eax
  803feb:	6a 2e                	push   $0x2e
  803fed:	e8 5b fa ff ff       	call   803a4d <syscall>
  803ff2:	83 c4 18             	add    $0x18,%esp
	    return;
  803ff5:	90                   	nop
}
  803ff6:	c9                   	leave  
  803ff7:	c3                   	ret    

00803ff8 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803ff8:	55                   	push   %ebp
  803ff9:	89 e5                	mov    %esp,%ebp
  803ffb:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  804001:	ba 60 60 80 00       	mov    $0x806060,%edx
  804006:	29 d0                	sub    %edx,%eax
  804008:	c1 f8 02             	sar    $0x2,%eax
  80400b:	89 c2                	mov    %eax,%edx
  80400d:	89 d0                	mov    %edx,%eax
  80400f:	c1 e0 02             	shl    $0x2,%eax
  804012:	01 d0                	add    %edx,%eax
  804014:	c1 e0 02             	shl    $0x2,%eax
  804017:	01 d0                	add    %edx,%eax
  804019:	c1 e0 02             	shl    $0x2,%eax
  80401c:	01 d0                	add    %edx,%eax
  80401e:	89 c1                	mov    %eax,%ecx
  804020:	c1 e1 08             	shl    $0x8,%ecx
  804023:	01 c8                	add    %ecx,%eax
  804025:	89 c1                	mov    %eax,%ecx
  804027:	c1 e1 10             	shl    $0x10,%ecx
  80402a:	01 c8                	add    %ecx,%eax
  80402c:	01 c0                	add    %eax,%eax
  80402e:	01 d0                	add    %edx,%eax
  804030:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  804033:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804036:	c1 e0 0c             	shl    $0xc,%eax
  804039:	89 c2                	mov    %eax,%edx
  80403b:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804040:	01 d0                	add    %edx,%eax
}
  804042:	c9                   	leave  
  804043:	c3                   	ret    

00804044 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  804044:	55                   	push   %ebp
  804045:	89 e5                	mov    %esp,%ebp
  804047:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  80404a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  804051:	eb 06                	jmp    804059 <log2+0x15>
			n >>=1;
  804053:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  804056:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  804059:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80405d:	77 f4                	ja     804053 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  80405f:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  804062:	c9                   	leave  
  804063:	c3                   	ret    

00804064 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  804064:	55                   	push   %ebp
  804065:	89 e5                	mov    %esp,%ebp
  804067:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80406a:	8b 45 08             	mov    0x8(%ebp),%eax
  80406d:	05 00 00 00 02       	add    $0x2000000,%eax
  804072:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804075:	73 16                	jae    80408d <initialize_dynamic_allocator+0x29>
  804077:	68 8c 5b 80 00       	push   $0x805b8c
  80407c:	68 b2 5b 80 00       	push   $0x805bb2
  804081:	6a 2d                	push   $0x2d
  804083:	68 c7 5b 80 00       	push   $0x805bc7
  804088:	e8 9e cc ff ff       	call   800d2b <_panic>
		is_initialized = 1;
  80408d:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  804094:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  804097:	8b 45 08             	mov    0x8(%ebp),%eax
  80409a:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  80409f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040a2:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  8040a7:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8040ad:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8040b2:	29 c2                	sub    %eax,%edx
  8040b4:	89 d0                	mov    %edx,%eax
  8040b6:	c1 e8 0c             	shr    $0xc,%eax
  8040b9:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  8040bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8040c3:	eb 2f                	jmp    8040f4 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  8040c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040c8:	89 d0                	mov    %edx,%eax
  8040ca:	01 c0                	add    %eax,%eax
  8040cc:	01 d0                	add    %edx,%eax
  8040ce:	c1 e0 02             	shl    $0x2,%eax
  8040d1:	05 68 60 80 00       	add    $0x806068,%eax
  8040d6:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  8040db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040de:	89 d0                	mov    %edx,%eax
  8040e0:	01 c0                	add    %eax,%eax
  8040e2:	01 d0                	add    %edx,%eax
  8040e4:	c1 e0 02             	shl    $0x2,%eax
  8040e7:	05 6a 60 80 00       	add    $0x80606a,%eax
  8040ec:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  8040f1:	ff 45 f4             	incl   -0xc(%ebp)
  8040f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8040fa:	7c c9                	jl     8040c5 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  8040fc:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  804103:	00 00 00 
  804106:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  80410d:	00 00 00 
  804110:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  804117:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  80411a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804121:	e9 9c 00 00 00       	jmp    8041c2 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  804126:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  80412c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80412f:	89 c8                	mov    %ecx,%eax
  804131:	01 c0                	add    %eax,%eax
  804133:	01 c8                	add    %ecx,%eax
  804135:	c1 e0 02             	shl    $0x2,%eax
  804138:	05 64 60 80 00       	add    $0x806064,%eax
  80413d:	89 10                	mov    %edx,(%eax)
  80413f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804142:	89 d0                	mov    %edx,%eax
  804144:	01 c0                	add    %eax,%eax
  804146:	01 d0                	add    %edx,%eax
  804148:	c1 e0 02             	shl    $0x2,%eax
  80414b:	05 64 60 80 00       	add    $0x806064,%eax
  804150:	8b 00                	mov    (%eax),%eax
  804152:	85 c0                	test   %eax,%eax
  804154:	74 1b                	je     804171 <initialize_dynamic_allocator+0x10d>
  804156:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  80415c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80415f:	89 c8                	mov    %ecx,%eax
  804161:	01 c0                	add    %eax,%eax
  804163:	01 c8                	add    %ecx,%eax
  804165:	c1 e0 02             	shl    $0x2,%eax
  804168:	05 60 60 80 00       	add    $0x806060,%eax
  80416d:	89 02                	mov    %eax,(%edx)
  80416f:	eb 16                	jmp    804187 <initialize_dynamic_allocator+0x123>
  804171:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804174:	89 d0                	mov    %edx,%eax
  804176:	01 c0                	add    %eax,%eax
  804178:	01 d0                	add    %edx,%eax
  80417a:	c1 e0 02             	shl    $0x2,%eax
  80417d:	05 60 60 80 00       	add    $0x806060,%eax
  804182:	a3 48 60 80 00       	mov    %eax,0x806048
  804187:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80418a:	89 d0                	mov    %edx,%eax
  80418c:	01 c0                	add    %eax,%eax
  80418e:	01 d0                	add    %edx,%eax
  804190:	c1 e0 02             	shl    $0x2,%eax
  804193:	05 60 60 80 00       	add    $0x806060,%eax
  804198:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80419d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041a0:	89 d0                	mov    %edx,%eax
  8041a2:	01 c0                	add    %eax,%eax
  8041a4:	01 d0                	add    %edx,%eax
  8041a6:	c1 e0 02             	shl    $0x2,%eax
  8041a9:	05 60 60 80 00       	add    $0x806060,%eax
  8041ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041b4:	a1 54 60 80 00       	mov    0x806054,%eax
  8041b9:	40                   	inc    %eax
  8041ba:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  8041bf:	ff 45 f0             	incl   -0x10(%ebp)
  8041c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041c5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8041c8:	0f 8c 58 ff ff ff    	jl     804126 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8041ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8041d5:	eb 36                	jmp    80420d <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  8041d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041da:	c1 e0 04             	shl    $0x4,%eax
  8041dd:	05 80 e0 81 00       	add    $0x81e080,%eax
  8041e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041eb:	c1 e0 04             	shl    $0x4,%eax
  8041ee:	05 84 e0 81 00       	add    $0x81e084,%eax
  8041f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041fc:	c1 e0 04             	shl    $0x4,%eax
  8041ff:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804204:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80420a:	ff 45 ec             	incl   -0x14(%ebp)
  80420d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804211:	7e c4                	jle    8041d7 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  804213:	90                   	nop
  804214:	c9                   	leave  
  804215:	c3                   	ret    

00804216 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  804216:	55                   	push   %ebp
  804217:	89 e5                	mov    %esp,%ebp
  804219:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  80421c:	8b 55 08             	mov    0x8(%ebp),%edx
  80421f:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804224:	29 c2                	sub    %eax,%edx
  804226:	89 d0                	mov    %edx,%eax
  804228:	c1 e8 0c             	shr    $0xc,%eax
  80422b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  80422e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804231:	89 d0                	mov    %edx,%eax
  804233:	01 c0                	add    %eax,%eax
  804235:	01 d0                	add    %edx,%eax
  804237:	c1 e0 02             	shl    $0x2,%eax
  80423a:	05 68 60 80 00       	add    $0x806068,%eax
  80423f:	8b 00                	mov    (%eax),%eax
  804241:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  804244:	c9                   	leave  
  804245:	c3                   	ret    

00804246 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  804246:	55                   	push   %ebp
  804247:	89 e5                	mov    %esp,%ebp
  804249:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80424c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  804253:	76 16                	jbe    80426b <alloc_block+0x25>
  804255:	68 e0 5b 80 00       	push   $0x805be0
  80425a:	68 b2 5b 80 00       	push   $0x805bb2
  80425f:	6a 6c                	push   $0x6c
  804261:	68 c7 5b 80 00       	push   $0x805bc7
  804266:	e8 c0 ca ff ff       	call   800d2b <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  80426b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80426f:	75 0a                	jne    80427b <alloc_block+0x35>
		return NULL;
  804271:	b8 00 00 00 00       	mov    $0x0,%eax
  804276:	e9 65 04 00 00       	jmp    8046e0 <alloc_block+0x49a>
	}
	else if(size<=8){
  80427b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  80427f:	77 09                	ja     80428a <alloc_block+0x44>
		size=8;
  804281:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  804288:	eb 1f                	jmp    8042a9 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  80428a:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  804291:	eb 08                	jmp    80429b <alloc_block+0x55>
			reqsize*=2;
  804293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804296:	01 c0                	add    %eax,%eax
  804298:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  80429b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80429e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8042a1:	72 f0                	jb     804293 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  8042a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042a6:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  8042a9:	83 ec 0c             	sub    $0xc,%esp
  8042ac:	ff 75 08             	pushl  0x8(%ebp)
  8042af:	e8 90 fd ff ff       	call   804044 <log2>
  8042b4:	83 c4 10             	add    $0x10,%esp
  8042b7:	83 e8 03             	sub    $0x3,%eax
  8042ba:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  8042bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042c0:	c1 e0 04             	shl    $0x4,%eax
  8042c3:	05 80 e0 81 00       	add    $0x81e080,%eax
  8042c8:	8b 00                	mov    (%eax),%eax
  8042ca:	85 c0                	test   %eax,%eax
  8042cc:	0f 84 fb 00 00 00    	je     8043cd <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  8042d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042d5:	c1 e0 04             	shl    $0x4,%eax
  8042d8:	05 80 e0 81 00       	add    $0x81e080,%eax
  8042dd:	8b 00                	mov    (%eax),%eax
  8042df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  8042e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8042e6:	75 17                	jne    8042ff <alloc_block+0xb9>
  8042e8:	83 ec 04             	sub    $0x4,%esp
  8042eb:	68 01 5c 80 00       	push   $0x805c01
  8042f0:	68 86 00 00 00       	push   $0x86
  8042f5:	68 c7 5b 80 00       	push   $0x805bc7
  8042fa:	e8 2c ca ff ff       	call   800d2b <_panic>
  8042ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804302:	8b 00                	mov    (%eax),%eax
  804304:	85 c0                	test   %eax,%eax
  804306:	74 10                	je     804318 <alloc_block+0xd2>
  804308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80430b:	8b 00                	mov    (%eax),%eax
  80430d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804310:	8b 52 04             	mov    0x4(%edx),%edx
  804313:	89 50 04             	mov    %edx,0x4(%eax)
  804316:	eb 14                	jmp    80432c <alloc_block+0xe6>
  804318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80431b:	8b 40 04             	mov    0x4(%eax),%eax
  80431e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804321:	c1 e2 04             	shl    $0x4,%edx
  804324:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  80432a:	89 02                	mov    %eax,(%edx)
  80432c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80432f:	8b 40 04             	mov    0x4(%eax),%eax
  804332:	85 c0                	test   %eax,%eax
  804334:	74 0f                	je     804345 <alloc_block+0xff>
  804336:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804339:	8b 40 04             	mov    0x4(%eax),%eax
  80433c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80433f:	8b 12                	mov    (%edx),%edx
  804341:	89 10                	mov    %edx,(%eax)
  804343:	eb 13                	jmp    804358 <alloc_block+0x112>
  804345:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804348:	8b 00                	mov    (%eax),%eax
  80434a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80434d:	c1 e2 04             	shl    $0x4,%edx
  804350:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  804356:	89 02                	mov    %eax,(%edx)
  804358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80435b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804361:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804364:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80436b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80436e:	c1 e0 04             	shl    $0x4,%eax
  804371:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804376:	8b 00                	mov    (%eax),%eax
  804378:	8d 50 ff             	lea    -0x1(%eax),%edx
  80437b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80437e:	c1 e0 04             	shl    $0x4,%eax
  804381:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804386:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804388:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80438b:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804390:	29 c2                	sub    %eax,%edx
  804392:	89 d0                	mov    %edx,%eax
  804394:	c1 e8 0c             	shr    $0xc,%eax
  804397:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  80439a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80439d:	89 d0                	mov    %edx,%eax
  80439f:	01 c0                	add    %eax,%eax
  8043a1:	01 d0                	add    %edx,%eax
  8043a3:	c1 e0 02             	shl    $0x2,%eax
  8043a6:	05 6a 60 80 00       	add    $0x80606a,%eax
  8043ab:	66 8b 00             	mov    (%eax),%ax
  8043ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8043b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8043b4:	89 c8                	mov    %ecx,%eax
  8043b6:	01 c0                	add    %eax,%eax
  8043b8:	01 c8                	add    %ecx,%eax
  8043ba:	c1 e0 02             	shl    $0x2,%eax
  8043bd:	05 6a 60 80 00       	add    $0x80606a,%eax
  8043c2:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  8043c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043c8:	e9 13 03 00 00       	jmp    8046e0 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  8043cd:	a1 48 60 80 00       	mov    0x806048,%eax
  8043d2:	85 c0                	test   %eax,%eax
  8043d4:	0f 84 c9 01 00 00    	je     8045a3 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  8043da:	a1 48 60 80 00       	mov    0x806048,%eax
  8043df:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  8043e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8043e6:	75 17                	jne    8043ff <alloc_block+0x1b9>
  8043e8:	83 ec 04             	sub    $0x4,%esp
  8043eb:	68 01 5c 80 00       	push   $0x805c01
  8043f0:	68 8f 00 00 00       	push   $0x8f
  8043f5:	68 c7 5b 80 00       	push   $0x805bc7
  8043fa:	e8 2c c9 ff ff       	call   800d2b <_panic>
  8043ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804402:	8b 00                	mov    (%eax),%eax
  804404:	85 c0                	test   %eax,%eax
  804406:	74 10                	je     804418 <alloc_block+0x1d2>
  804408:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80440b:	8b 00                	mov    (%eax),%eax
  80440d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804410:	8b 52 04             	mov    0x4(%edx),%edx
  804413:	89 50 04             	mov    %edx,0x4(%eax)
  804416:	eb 0b                	jmp    804423 <alloc_block+0x1dd>
  804418:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80441b:	8b 40 04             	mov    0x4(%eax),%eax
  80441e:	a3 4c 60 80 00       	mov    %eax,0x80604c
  804423:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804426:	8b 40 04             	mov    0x4(%eax),%eax
  804429:	85 c0                	test   %eax,%eax
  80442b:	74 0f                	je     80443c <alloc_block+0x1f6>
  80442d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804430:	8b 40 04             	mov    0x4(%eax),%eax
  804433:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804436:	8b 12                	mov    (%edx),%edx
  804438:	89 10                	mov    %edx,(%eax)
  80443a:	eb 0a                	jmp    804446 <alloc_block+0x200>
  80443c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80443f:	8b 00                	mov    (%eax),%eax
  804441:	a3 48 60 80 00       	mov    %eax,0x806048
  804446:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804449:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80444f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804452:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804459:	a1 54 60 80 00       	mov    0x806054,%eax
  80445e:	48                   	dec    %eax
  80445f:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  804464:	83 ec 0c             	sub    $0xc,%esp
  804467:	ff 75 dc             	pushl  -0x24(%ebp)
  80446a:	e8 89 fb ff ff       	call   803ff8 <to_page_va>
  80446f:	83 c4 10             	add    $0x10,%esp
  804472:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  804475:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80447a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80447d:	29 c2                	sub    %eax,%edx
  80447f:	89 d0                	mov    %edx,%eax
  804481:	c1 e8 0c             	shr    $0xc,%eax
  804484:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  804487:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80448a:	83 ec 0c             	sub    $0xc,%esp
  80448d:	50                   	push   %eax
  80448e:	e8 fe dc ff ff       	call   802191 <get_page>
  804493:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  804496:	8b 45 08             	mov    0x8(%ebp),%eax
  804499:	89 c2                	mov    %eax,%edx
  80449b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80449e:	89 c8                	mov    %ecx,%eax
  8044a0:	01 c0                	add    %eax,%eax
  8044a2:	01 c8                	add    %ecx,%eax
  8044a4:	c1 e0 02             	shl    $0x2,%eax
  8044a7:	05 68 60 80 00       	add    $0x806068,%eax
  8044ac:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  8044af:	b8 00 10 00 00       	mov    $0x1000,%eax
  8044b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8044b9:	f7 75 08             	divl   0x8(%ebp)
  8044bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  8044bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8044c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8044c5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8044c8:	89 c8                	mov    %ecx,%eax
  8044ca:	01 c0                	add    %eax,%eax
  8044cc:	01 c8                	add    %ecx,%eax
  8044ce:	c1 e0 02             	shl    $0x2,%eax
  8044d1:	05 6a 60 80 00       	add    $0x80606a,%eax
  8044d6:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  8044d9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  8044e0:	e9 aa 00 00 00       	jmp    80458f <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  8044e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044e8:	0f af 45 08          	imul   0x8(%ebp),%eax
  8044ec:	89 c2                	mov    %eax,%edx
  8044ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8044f1:	01 d0                	add    %edx,%eax
  8044f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  8044f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8044fa:	75 17                	jne    804513 <alloc_block+0x2cd>
  8044fc:	83 ec 04             	sub    $0x4,%esp
  8044ff:	68 20 5c 80 00       	push   $0x805c20
  804504:	68 9d 00 00 00       	push   $0x9d
  804509:	68 c7 5b 80 00       	push   $0x805bc7
  80450e:	e8 18 c8 ff ff       	call   800d2b <_panic>
  804513:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804516:	c1 e0 04             	shl    $0x4,%eax
  804519:	05 84 e0 81 00       	add    $0x81e084,%eax
  80451e:	8b 10                	mov    (%eax),%edx
  804520:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804523:	89 50 04             	mov    %edx,0x4(%eax)
  804526:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804529:	8b 40 04             	mov    0x4(%eax),%eax
  80452c:	85 c0                	test   %eax,%eax
  80452e:	74 14                	je     804544 <alloc_block+0x2fe>
  804530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804533:	c1 e0 04             	shl    $0x4,%eax
  804536:	05 84 e0 81 00       	add    $0x81e084,%eax
  80453b:	8b 00                	mov    (%eax),%eax
  80453d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804540:	89 10                	mov    %edx,(%eax)
  804542:	eb 11                	jmp    804555 <alloc_block+0x30f>
  804544:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804547:	c1 e0 04             	shl    $0x4,%eax
  80454a:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  804550:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804553:	89 02                	mov    %eax,(%edx)
  804555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804558:	c1 e0 04             	shl    $0x4,%eax
  80455b:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  804561:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804564:	89 02                	mov    %eax,(%edx)
  804566:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804569:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80456f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804572:	c1 e0 04             	shl    $0x4,%eax
  804575:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80457a:	8b 00                	mov    (%eax),%eax
  80457c:	8d 50 01             	lea    0x1(%eax),%edx
  80457f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804582:	c1 e0 04             	shl    $0x4,%eax
  804585:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80458a:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  80458c:	ff 45 f0             	incl   -0x10(%ebp)
  80458f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804592:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  804595:	0f 8c 4a ff ff ff    	jl     8044e5 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  80459b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80459e:	e9 3d 01 00 00       	jmp    8046e0 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  8045a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045a6:	40                   	inc    %eax
  8045a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8045aa:	e9 10 01 00 00       	jmp    8046bf <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  8045af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045b2:	c1 e0 04             	shl    $0x4,%eax
  8045b5:	05 80 e0 81 00       	add    $0x81e080,%eax
  8045ba:	8b 00                	mov    (%eax),%eax
  8045bc:	85 c0                	test   %eax,%eax
  8045be:	0f 84 f8 00 00 00    	je     8046bc <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8045c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045c7:	c1 e0 04             	shl    $0x4,%eax
  8045ca:	05 80 e0 81 00       	add    $0x81e080,%eax
  8045cf:	8b 00                	mov    (%eax),%eax
  8045d1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  8045d4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8045d8:	75 17                	jne    8045f1 <alloc_block+0x3ab>
  8045da:	83 ec 04             	sub    $0x4,%esp
  8045dd:	68 01 5c 80 00       	push   $0x805c01
  8045e2:	68 a8 00 00 00       	push   $0xa8
  8045e7:	68 c7 5b 80 00       	push   $0x805bc7
  8045ec:	e8 3a c7 ff ff       	call   800d2b <_panic>
  8045f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045f4:	8b 00                	mov    (%eax),%eax
  8045f6:	85 c0                	test   %eax,%eax
  8045f8:	74 10                	je     80460a <alloc_block+0x3c4>
  8045fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045fd:	8b 00                	mov    (%eax),%eax
  8045ff:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804602:	8b 52 04             	mov    0x4(%edx),%edx
  804605:	89 50 04             	mov    %edx,0x4(%eax)
  804608:	eb 14                	jmp    80461e <alloc_block+0x3d8>
  80460a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80460d:	8b 40 04             	mov    0x4(%eax),%eax
  804610:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804613:	c1 e2 04             	shl    $0x4,%edx
  804616:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  80461c:	89 02                	mov    %eax,(%edx)
  80461e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804621:	8b 40 04             	mov    0x4(%eax),%eax
  804624:	85 c0                	test   %eax,%eax
  804626:	74 0f                	je     804637 <alloc_block+0x3f1>
  804628:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80462b:	8b 40 04             	mov    0x4(%eax),%eax
  80462e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804631:	8b 12                	mov    (%edx),%edx
  804633:	89 10                	mov    %edx,(%eax)
  804635:	eb 13                	jmp    80464a <alloc_block+0x404>
  804637:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80463a:	8b 00                	mov    (%eax),%eax
  80463c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80463f:	c1 e2 04             	shl    $0x4,%edx
  804642:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  804648:	89 02                	mov    %eax,(%edx)
  80464a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80464d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804653:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804656:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80465d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804660:	c1 e0 04             	shl    $0x4,%eax
  804663:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804668:	8b 00                	mov    (%eax),%eax
  80466a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80466d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804670:	c1 e0 04             	shl    $0x4,%eax
  804673:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804678:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  80467a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80467d:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804682:	29 c2                	sub    %eax,%edx
  804684:	89 d0                	mov    %edx,%eax
  804686:	c1 e8 0c             	shr    $0xc,%eax
  804689:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  80468c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80468f:	89 d0                	mov    %edx,%eax
  804691:	01 c0                	add    %eax,%eax
  804693:	01 d0                	add    %edx,%eax
  804695:	c1 e0 02             	shl    $0x2,%eax
  804698:	05 6a 60 80 00       	add    $0x80606a,%eax
  80469d:	66 8b 00             	mov    (%eax),%ax
  8046a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8046a3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8046a6:	89 c8                	mov    %ecx,%eax
  8046a8:	01 c0                	add    %eax,%eax
  8046aa:	01 c8                	add    %ecx,%eax
  8046ac:	c1 e0 02             	shl    $0x2,%eax
  8046af:	05 6a 60 80 00       	add    $0x80606a,%eax
  8046b4:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  8046b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8046ba:	eb 24                	jmp    8046e0 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  8046bc:	ff 45 ec             	incl   -0x14(%ebp)
  8046bf:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8046c3:	0f 8e e6 fe ff ff    	jle    8045af <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  8046c9:	83 ec 04             	sub    $0x4,%esp
  8046cc:	68 43 5c 80 00       	push   $0x805c43
  8046d1:	68 b1 00 00 00       	push   $0xb1
  8046d6:	68 c7 5b 80 00       	push   $0x805bc7
  8046db:	e8 4b c6 ff ff       	call   800d2b <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8046e0:	c9                   	leave  
  8046e1:	c3                   	ret    

008046e2 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8046e2:	55                   	push   %ebp
  8046e3:	89 e5                	mov    %esp,%ebp
  8046e5:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8046e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8046eb:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8046f0:	39 c2                	cmp    %eax,%edx
  8046f2:	72 0c                	jb     804700 <free_block+0x1e>
  8046f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8046f7:	a1 40 60 80 00       	mov    0x806040,%eax
  8046fc:	39 c2                	cmp    %eax,%edx
  8046fe:	72 19                	jb     804719 <free_block+0x37>
  804700:	68 60 5c 80 00       	push   $0x805c60
  804705:	68 b2 5b 80 00       	push   $0x805bb2
  80470a:	68 c3 00 00 00       	push   $0xc3
  80470f:	68 c7 5b 80 00       	push   $0x805bc7
  804714:	e8 12 c6 ff ff       	call   800d2b <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804719:	8b 55 08             	mov    0x8(%ebp),%edx
  80471c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804721:	29 c2                	sub    %eax,%edx
  804723:	89 d0                	mov    %edx,%eax
  804725:	c1 e8 0c             	shr    $0xc,%eax
  804728:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  80472b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80472e:	89 d0                	mov    %edx,%eax
  804730:	01 c0                	add    %eax,%eax
  804732:	01 d0                	add    %edx,%eax
  804734:	c1 e0 02             	shl    $0x2,%eax
  804737:	05 68 60 80 00       	add    $0x806068,%eax
  80473c:	8b 00                	mov    (%eax),%eax
  80473e:	0f b7 c0             	movzwl %ax,%eax
  804741:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  804744:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804748:	75 17                	jne    804761 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  80474a:	83 ec 04             	sub    $0x4,%esp
  80474d:	68 98 5c 80 00       	push   $0x805c98
  804752:	68 cf 00 00 00       	push   $0xcf
  804757:	68 c7 5b 80 00       	push   $0x805bc7
  80475c:	e8 ca c5 ff ff       	call   800d2b <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804761:	83 ec 0c             	sub    $0xc,%esp
  804764:	ff 75 ec             	pushl  -0x14(%ebp)
  804767:	e8 d8 f8 ff ff       	call   804044 <log2>
  80476c:	83 c4 10             	add    $0x10,%esp
  80476f:	83 e8 03             	sub    $0x3,%eax
  804772:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804775:	8b 45 08             	mov    0x8(%ebp),%eax
  804778:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  80477b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80477f:	75 17                	jne    804798 <free_block+0xb6>
  804781:	83 ec 04             	sub    $0x4,%esp
  804784:	68 20 5c 80 00       	push   $0x805c20
  804789:	68 d5 00 00 00       	push   $0xd5
  80478e:	68 c7 5b 80 00       	push   $0x805bc7
  804793:	e8 93 c5 ff ff       	call   800d2b <_panic>
  804798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80479b:	c1 e0 04             	shl    $0x4,%eax
  80479e:	05 84 e0 81 00       	add    $0x81e084,%eax
  8047a3:	8b 10                	mov    (%eax),%edx
  8047a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047a8:	89 50 04             	mov    %edx,0x4(%eax)
  8047ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047ae:	8b 40 04             	mov    0x4(%eax),%eax
  8047b1:	85 c0                	test   %eax,%eax
  8047b3:	74 14                	je     8047c9 <free_block+0xe7>
  8047b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047b8:	c1 e0 04             	shl    $0x4,%eax
  8047bb:	05 84 e0 81 00       	add    $0x81e084,%eax
  8047c0:	8b 00                	mov    (%eax),%eax
  8047c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8047c5:	89 10                	mov    %edx,(%eax)
  8047c7:	eb 11                	jmp    8047da <free_block+0xf8>
  8047c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047cc:	c1 e0 04             	shl    $0x4,%eax
  8047cf:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  8047d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047d8:	89 02                	mov    %eax,(%edx)
  8047da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047dd:	c1 e0 04             	shl    $0x4,%eax
  8047e0:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  8047e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047e9:	89 02                	mov    %eax,(%edx)
  8047eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047f7:	c1 e0 04             	shl    $0x4,%eax
  8047fa:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8047ff:	8b 00                	mov    (%eax),%eax
  804801:	8d 50 01             	lea    0x1(%eax),%edx
  804804:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804807:	c1 e0 04             	shl    $0x4,%eax
  80480a:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80480f:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  804811:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804814:	89 d0                	mov    %edx,%eax
  804816:	01 c0                	add    %eax,%eax
  804818:	01 d0                	add    %edx,%eax
  80481a:	c1 e0 02             	shl    $0x2,%eax
  80481d:	05 6a 60 80 00       	add    $0x80606a,%eax
  804822:	66 8b 00             	mov    (%eax),%ax
  804825:	8d 50 01             	lea    0x1(%eax),%edx
  804828:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80482b:	89 c8                	mov    %ecx,%eax
  80482d:	01 c0                	add    %eax,%eax
  80482f:	01 c8                	add    %ecx,%eax
  804831:	c1 e0 02             	shl    $0x2,%eax
  804834:	05 6a 60 80 00       	add    $0x80606a,%eax
  804839:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  80483c:	b8 00 10 00 00       	mov    $0x1000,%eax
  804841:	ba 00 00 00 00       	mov    $0x0,%edx
  804846:	f7 75 ec             	divl   -0x14(%ebp)
  804849:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  80484c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80484f:	89 d0                	mov    %edx,%eax
  804851:	01 c0                	add    %eax,%eax
  804853:	01 d0                	add    %edx,%eax
  804855:	c1 e0 02             	shl    $0x2,%eax
  804858:	05 6a 60 80 00       	add    $0x80606a,%eax
  80485d:	66 8b 00             	mov    (%eax),%ax
  804860:	0f b7 c0             	movzwl %ax,%eax
  804863:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804866:	0f 85 d3 01 00 00    	jne    804a3f <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  80486c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80486f:	c1 e0 04             	shl    $0x4,%eax
  804872:	05 80 e0 81 00       	add    $0x81e080,%eax
  804877:	8b 00                	mov    (%eax),%eax
  804879:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  80487c:	e9 f1 00 00 00       	jmp    804972 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804884:	8b 00                	mov    (%eax),%eax
  804886:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  804889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80488c:	c1 e0 0c             	shl    $0xc,%eax
  80488f:	89 c2                	mov    %eax,%edx
  804891:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804896:	01 d0                	add    %edx,%eax
  804898:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  80489b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80489e:	40                   	inc    %eax
  80489f:	c1 e0 0c             	shl    $0xc,%eax
  8048a2:	89 c2                	mov    %eax,%edx
  8048a4:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8048a9:	01 d0                	add    %edx,%eax
  8048ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  8048ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048b1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8048b4:	0f 82 b8 00 00 00    	jb     804972 <free_block+0x290>
  8048ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048bd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8048c0:	0f 83 ac 00 00 00    	jae    804972 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  8048c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8048ca:	75 17                	jne    8048e3 <free_block+0x201>
  8048cc:	83 ec 04             	sub    $0x4,%esp
  8048cf:	68 01 5c 80 00       	push   $0x805c01
  8048d4:	68 e2 00 00 00       	push   $0xe2
  8048d9:	68 c7 5b 80 00       	push   $0x805bc7
  8048de:	e8 48 c4 ff ff       	call   800d2b <_panic>
  8048e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048e6:	8b 00                	mov    (%eax),%eax
  8048e8:	85 c0                	test   %eax,%eax
  8048ea:	74 10                	je     8048fc <free_block+0x21a>
  8048ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048ef:	8b 00                	mov    (%eax),%eax
  8048f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8048f4:	8b 52 04             	mov    0x4(%edx),%edx
  8048f7:	89 50 04             	mov    %edx,0x4(%eax)
  8048fa:	eb 14                	jmp    804910 <free_block+0x22e>
  8048fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048ff:	8b 40 04             	mov    0x4(%eax),%eax
  804902:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804905:	c1 e2 04             	shl    $0x4,%edx
  804908:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  80490e:	89 02                	mov    %eax,(%edx)
  804910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804913:	8b 40 04             	mov    0x4(%eax),%eax
  804916:	85 c0                	test   %eax,%eax
  804918:	74 0f                	je     804929 <free_block+0x247>
  80491a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80491d:	8b 40 04             	mov    0x4(%eax),%eax
  804920:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804923:	8b 12                	mov    (%edx),%edx
  804925:	89 10                	mov    %edx,(%eax)
  804927:	eb 13                	jmp    80493c <free_block+0x25a>
  804929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80492c:	8b 00                	mov    (%eax),%eax
  80492e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804931:	c1 e2 04             	shl    $0x4,%edx
  804934:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  80493a:	89 02                	mov    %eax,(%edx)
  80493c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80493f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804948:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80494f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804952:	c1 e0 04             	shl    $0x4,%eax
  804955:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80495a:	8b 00                	mov    (%eax),%eax
  80495c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80495f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804962:	c1 e0 04             	shl    $0x4,%eax
  804965:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80496a:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  80496c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80496f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804976:	0f 85 05 ff ff ff    	jne    804881 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  80497c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80497f:	89 d0                	mov    %edx,%eax
  804981:	01 c0                	add    %eax,%eax
  804983:	01 d0                	add    %edx,%eax
  804985:	c1 e0 02             	shl    $0x2,%eax
  804988:	05 68 60 80 00       	add    $0x806068,%eax
  80498d:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  804992:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804995:	89 d0                	mov    %edx,%eax
  804997:	01 c0                	add    %eax,%eax
  804999:	01 d0                	add    %edx,%eax
  80499b:	c1 e0 02             	shl    $0x2,%eax
  80499e:	05 6a 60 80 00       	add    $0x80606a,%eax
  8049a3:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  8049a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8049ab:	89 d0                	mov    %edx,%eax
  8049ad:	01 c0                	add    %eax,%eax
  8049af:	01 d0                	add    %edx,%eax
  8049b1:	c1 e0 02             	shl    $0x2,%eax
  8049b4:	05 60 60 80 00       	add    $0x806060,%eax
  8049b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  8049bc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8049c0:	75 17                	jne    8049d9 <free_block+0x2f7>
  8049c2:	83 ec 04             	sub    $0x4,%esp
  8049c5:	68 20 5c 80 00       	push   $0x805c20
  8049ca:	68 eb 00 00 00       	push   $0xeb
  8049cf:	68 c7 5b 80 00       	push   $0x805bc7
  8049d4:	e8 52 c3 ff ff       	call   800d2b <_panic>
  8049d9:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8049df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8049e2:	89 50 04             	mov    %edx,0x4(%eax)
  8049e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8049e8:	8b 40 04             	mov    0x4(%eax),%eax
  8049eb:	85 c0                	test   %eax,%eax
  8049ed:	74 0c                	je     8049fb <free_block+0x319>
  8049ef:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8049f4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8049f7:	89 10                	mov    %edx,(%eax)
  8049f9:	eb 08                	jmp    804a03 <free_block+0x321>
  8049fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8049fe:	a3 48 60 80 00       	mov    %eax,0x806048
  804a03:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804a06:	a3 4c 60 80 00       	mov    %eax,0x80604c
  804a0b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804a0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a14:	a1 54 60 80 00       	mov    0x806054,%eax
  804a19:	40                   	inc    %eax
  804a1a:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  804a1f:	83 ec 0c             	sub    $0xc,%esp
  804a22:	ff 75 d0             	pushl  -0x30(%ebp)
  804a25:	e8 ce f5 ff ff       	call   803ff8 <to_page_va>
  804a2a:	83 c4 10             	add    $0x10,%esp
  804a2d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  804a30:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804a33:	83 ec 0c             	sub    $0xc,%esp
  804a36:	50                   	push   %eax
  804a37:	e8 9e d7 ff ff       	call   8021da <return_page>
  804a3c:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  804a3f:	90                   	nop
  804a40:	c9                   	leave  
  804a41:	c3                   	ret    

00804a42 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  804a42:	55                   	push   %ebp
  804a43:	89 e5                	mov    %esp,%ebp
  804a45:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  804a48:	83 ec 04             	sub    $0x4,%esp
  804a4b:	68 c0 5c 80 00       	push   $0x805cc0
  804a50:	68 01 01 00 00       	push   $0x101
  804a55:	68 c7 5b 80 00       	push   $0x805bc7
  804a5a:	e8 cc c2 ff ff       	call   800d2b <_panic>

00804a5f <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  804a5f:	55                   	push   %ebp
  804a60:	89 e5                	mov    %esp,%ebp
  804a62:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  804a65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804a69:	74 1c                	je     804a87 <init_uspinlock+0x28>
  804a6b:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  804a6f:	74 16                	je     804a87 <init_uspinlock+0x28>
  804a71:	68 e4 5c 80 00       	push   $0x805ce4
  804a76:	68 03 5d 80 00       	push   $0x805d03
  804a7b:	6a 10                	push   $0x10
  804a7d:	68 18 5d 80 00       	push   $0x805d18
  804a82:	e8 a4 c2 ff ff       	call   800d2b <_panic>
	strcpy(lk->name, name);
  804a87:	8b 45 08             	mov    0x8(%ebp),%eax
  804a8a:	83 c0 04             	add    $0x4,%eax
  804a8d:	83 ec 08             	sub    $0x8,%esp
  804a90:	ff 75 0c             	pushl  0xc(%ebp)
  804a93:	50                   	push   %eax
  804a94:	e8 90 ce ff ff       	call   801929 <strcpy>
  804a99:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  804a9c:	b8 01 00 00 00       	mov    $0x1,%eax
  804aa1:	2b 45 10             	sub    0x10(%ebp),%eax
  804aa4:	89 c2                	mov    %eax,%edx
  804aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  804aa9:	89 10                	mov    %edx,(%eax)
}
  804aab:	90                   	nop
  804aac:	c9                   	leave  
  804aad:	c3                   	ret    

00804aae <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  804aae:	55                   	push   %ebp
  804aaf:	89 e5                	mov    %esp,%ebp
  804ab1:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  804ab4:	90                   	nop
  804ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  804ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804abb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  804ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804ac8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  804acb:	f0 87 02             	lock xchg %eax,(%edx)
  804ace:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  804ad1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804ad4:	85 c0                	test   %eax,%eax
  804ad6:	75 dd                	jne    804ab5 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  804adb:	8d 48 04             	lea    0x4(%eax),%ecx
  804ade:	a1 20 60 80 00       	mov    0x806020,%eax
  804ae3:	8d 50 20             	lea    0x20(%eax),%edx
  804ae6:	a1 20 60 80 00       	mov    0x806020,%eax
  804aeb:	8b 40 10             	mov    0x10(%eax),%eax
  804aee:	51                   	push   %ecx
  804aef:	52                   	push   %edx
  804af0:	50                   	push   %eax
  804af1:	68 28 5d 80 00       	push   $0x805d28
  804af6:	e8 fe c4 ff ff       	call   800ff9 <cprintf>
  804afb:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  804afe:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  804b03:	90                   	nop
  804b04:	c9                   	leave  
  804b05:	c3                   	ret    

00804b06 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  804b06:	55                   	push   %ebp
  804b07:	89 e5                	mov    %esp,%ebp
  804b09:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  804b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  804b0f:	8b 00                	mov    (%eax),%eax
  804b11:	85 c0                	test   %eax,%eax
  804b13:	75 18                	jne    804b2d <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  804b15:	8b 45 08             	mov    0x8(%ebp),%eax
  804b18:	83 c0 04             	add    $0x4,%eax
  804b1b:	50                   	push   %eax
  804b1c:	68 4c 5d 80 00       	push   $0x805d4c
  804b21:	6a 2b                	push   $0x2b
  804b23:	68 18 5d 80 00       	push   $0x805d18
  804b28:	e8 fe c1 ff ff       	call   800d2b <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  804b2d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  804b32:	8b 45 08             	mov    0x8(%ebp),%eax
  804b35:	8b 55 08             	mov    0x8(%ebp),%edx
  804b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  804b41:	8d 48 04             	lea    0x4(%eax),%ecx
  804b44:	a1 20 60 80 00       	mov    0x806020,%eax
  804b49:	8d 50 20             	lea    0x20(%eax),%edx
  804b4c:	a1 20 60 80 00       	mov    0x806020,%eax
  804b51:	8b 40 10             	mov    0x10(%eax),%eax
  804b54:	51                   	push   %ecx
  804b55:	52                   	push   %edx
  804b56:	50                   	push   %eax
  804b57:	68 6c 5d 80 00       	push   $0x805d6c
  804b5c:	e8 98 c4 ff ff       	call   800ff9 <cprintf>
  804b61:	83 c4 10             	add    $0x10,%esp
}
  804b64:	90                   	nop
  804b65:	c9                   	leave  
  804b66:	c3                   	ret    
  804b67:	90                   	nop

00804b68 <__divdi3>:
  804b68:	55                   	push   %ebp
  804b69:	57                   	push   %edi
  804b6a:	56                   	push   %esi
  804b6b:	53                   	push   %ebx
  804b6c:	83 ec 1c             	sub    $0x1c,%esp
  804b6f:	8b 44 24 30          	mov    0x30(%esp),%eax
  804b73:	8b 54 24 34          	mov    0x34(%esp),%edx
  804b77:	8b 74 24 38          	mov    0x38(%esp),%esi
  804b7b:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  804b7f:	89 f9                	mov    %edi,%ecx
  804b81:	85 d2                	test   %edx,%edx
  804b83:	0f 88 bb 00 00 00    	js     804c44 <__divdi3+0xdc>
  804b89:	31 ed                	xor    %ebp,%ebp
  804b8b:	85 c9                	test   %ecx,%ecx
  804b8d:	0f 88 99 00 00 00    	js     804c2c <__divdi3+0xc4>
  804b93:	89 34 24             	mov    %esi,(%esp)
  804b96:	89 7c 24 04          	mov    %edi,0x4(%esp)
  804b9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804b9e:	89 d3                	mov    %edx,%ebx
  804ba0:	8b 34 24             	mov    (%esp),%esi
  804ba3:	8b 7c 24 04          	mov    0x4(%esp),%edi
  804ba7:	89 74 24 08          	mov    %esi,0x8(%esp)
  804bab:	8b 34 24             	mov    (%esp),%esi
  804bae:	89 c1                	mov    %eax,%ecx
  804bb0:	85 ff                	test   %edi,%edi
  804bb2:	75 10                	jne    804bc4 <__divdi3+0x5c>
  804bb4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  804bb8:	39 d7                	cmp    %edx,%edi
  804bba:	76 4c                	jbe    804c08 <__divdi3+0xa0>
  804bbc:	f7 f7                	div    %edi
  804bbe:	89 c1                	mov    %eax,%ecx
  804bc0:	31 f6                	xor    %esi,%esi
  804bc2:	eb 08                	jmp    804bcc <__divdi3+0x64>
  804bc4:	39 d7                	cmp    %edx,%edi
  804bc6:	76 1c                	jbe    804be4 <__divdi3+0x7c>
  804bc8:	31 f6                	xor    %esi,%esi
  804bca:	31 c9                	xor    %ecx,%ecx
  804bcc:	89 c8                	mov    %ecx,%eax
  804bce:	89 f2                	mov    %esi,%edx
  804bd0:	85 ed                	test   %ebp,%ebp
  804bd2:	74 07                	je     804bdb <__divdi3+0x73>
  804bd4:	f7 d8                	neg    %eax
  804bd6:	83 d2 00             	adc    $0x0,%edx
  804bd9:	f7 da                	neg    %edx
  804bdb:	83 c4 1c             	add    $0x1c,%esp
  804bde:	5b                   	pop    %ebx
  804bdf:	5e                   	pop    %esi
  804be0:	5f                   	pop    %edi
  804be1:	5d                   	pop    %ebp
  804be2:	c3                   	ret    
  804be3:	90                   	nop
  804be4:	0f bd f7             	bsr    %edi,%esi
  804be7:	83 f6 1f             	xor    $0x1f,%esi
  804bea:	75 6c                	jne    804c58 <__divdi3+0xf0>
  804bec:	39 d7                	cmp    %edx,%edi
  804bee:	72 0e                	jb     804bfe <__divdi3+0x96>
  804bf0:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  804bf4:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  804bf8:	0f 87 ca 00 00 00    	ja     804cc8 <__divdi3+0x160>
  804bfe:	b9 01 00 00 00       	mov    $0x1,%ecx
  804c03:	eb c7                	jmp    804bcc <__divdi3+0x64>
  804c05:	8d 76 00             	lea    0x0(%esi),%esi
  804c08:	85 f6                	test   %esi,%esi
  804c0a:	75 0b                	jne    804c17 <__divdi3+0xaf>
  804c0c:	b8 01 00 00 00       	mov    $0x1,%eax
  804c11:	31 d2                	xor    %edx,%edx
  804c13:	f7 f6                	div    %esi
  804c15:	89 c6                	mov    %eax,%esi
  804c17:	31 d2                	xor    %edx,%edx
  804c19:	89 d8                	mov    %ebx,%eax
  804c1b:	f7 f6                	div    %esi
  804c1d:	89 c7                	mov    %eax,%edi
  804c1f:	89 c8                	mov    %ecx,%eax
  804c21:	f7 f6                	div    %esi
  804c23:	89 c1                	mov    %eax,%ecx
  804c25:	89 fe                	mov    %edi,%esi
  804c27:	eb a3                	jmp    804bcc <__divdi3+0x64>
  804c29:	8d 76 00             	lea    0x0(%esi),%esi
  804c2c:	f7 d5                	not    %ebp
  804c2e:	f7 de                	neg    %esi
  804c30:	83 d7 00             	adc    $0x0,%edi
  804c33:	f7 df                	neg    %edi
  804c35:	89 34 24             	mov    %esi,(%esp)
  804c38:	89 7c 24 04          	mov    %edi,0x4(%esp)
  804c3c:	e9 59 ff ff ff       	jmp    804b9a <__divdi3+0x32>
  804c41:	8d 76 00             	lea    0x0(%esi),%esi
  804c44:	f7 d8                	neg    %eax
  804c46:	83 d2 00             	adc    $0x0,%edx
  804c49:	f7 da                	neg    %edx
  804c4b:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  804c50:	e9 36 ff ff ff       	jmp    804b8b <__divdi3+0x23>
  804c55:	8d 76 00             	lea    0x0(%esi),%esi
  804c58:	b8 20 00 00 00       	mov    $0x20,%eax
  804c5d:	29 f0                	sub    %esi,%eax
  804c5f:	89 f1                	mov    %esi,%ecx
  804c61:	d3 e7                	shl    %cl,%edi
  804c63:	8b 54 24 08          	mov    0x8(%esp),%edx
  804c67:	88 c1                	mov    %al,%cl
  804c69:	d3 ea                	shr    %cl,%edx
  804c6b:	89 d1                	mov    %edx,%ecx
  804c6d:	09 f9                	or     %edi,%ecx
  804c6f:	89 0c 24             	mov    %ecx,(%esp)
  804c72:	8b 54 24 08          	mov    0x8(%esp),%edx
  804c76:	89 f1                	mov    %esi,%ecx
  804c78:	d3 e2                	shl    %cl,%edx
  804c7a:	89 54 24 08          	mov    %edx,0x8(%esp)
  804c7e:	89 df                	mov    %ebx,%edi
  804c80:	88 c1                	mov    %al,%cl
  804c82:	d3 ef                	shr    %cl,%edi
  804c84:	89 f1                	mov    %esi,%ecx
  804c86:	d3 e3                	shl    %cl,%ebx
  804c88:	8b 54 24 0c          	mov    0xc(%esp),%edx
  804c8c:	88 c1                	mov    %al,%cl
  804c8e:	d3 ea                	shr    %cl,%edx
  804c90:	09 d3                	or     %edx,%ebx
  804c92:	89 d8                	mov    %ebx,%eax
  804c94:	89 fa                	mov    %edi,%edx
  804c96:	f7 34 24             	divl   (%esp)
  804c99:	89 d1                	mov    %edx,%ecx
  804c9b:	89 c3                	mov    %eax,%ebx
  804c9d:	f7 64 24 08          	mull   0x8(%esp)
  804ca1:	39 d1                	cmp    %edx,%ecx
  804ca3:	72 17                	jb     804cbc <__divdi3+0x154>
  804ca5:	74 09                	je     804cb0 <__divdi3+0x148>
  804ca7:	89 d9                	mov    %ebx,%ecx
  804ca9:	31 f6                	xor    %esi,%esi
  804cab:	e9 1c ff ff ff       	jmp    804bcc <__divdi3+0x64>
  804cb0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  804cb4:	89 f1                	mov    %esi,%ecx
  804cb6:	d3 e2                	shl    %cl,%edx
  804cb8:	39 c2                	cmp    %eax,%edx
  804cba:	73 eb                	jae    804ca7 <__divdi3+0x13f>
  804cbc:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  804cbf:	31 f6                	xor    %esi,%esi
  804cc1:	e9 06 ff ff ff       	jmp    804bcc <__divdi3+0x64>
  804cc6:	66 90                	xchg   %ax,%ax
  804cc8:	31 c9                	xor    %ecx,%ecx
  804cca:	e9 fd fe ff ff       	jmp    804bcc <__divdi3+0x64>
  804ccf:	90                   	nop

00804cd0 <__udivdi3>:
  804cd0:	55                   	push   %ebp
  804cd1:	57                   	push   %edi
  804cd2:	56                   	push   %esi
  804cd3:	53                   	push   %ebx
  804cd4:	83 ec 1c             	sub    $0x1c,%esp
  804cd7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804cdb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804cdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804ce3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804ce7:	89 ca                	mov    %ecx,%edx
  804ce9:	89 f8                	mov    %edi,%eax
  804ceb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804cef:	85 f6                	test   %esi,%esi
  804cf1:	75 2d                	jne    804d20 <__udivdi3+0x50>
  804cf3:	39 cf                	cmp    %ecx,%edi
  804cf5:	77 65                	ja     804d5c <__udivdi3+0x8c>
  804cf7:	89 fd                	mov    %edi,%ebp
  804cf9:	85 ff                	test   %edi,%edi
  804cfb:	75 0b                	jne    804d08 <__udivdi3+0x38>
  804cfd:	b8 01 00 00 00       	mov    $0x1,%eax
  804d02:	31 d2                	xor    %edx,%edx
  804d04:	f7 f7                	div    %edi
  804d06:	89 c5                	mov    %eax,%ebp
  804d08:	31 d2                	xor    %edx,%edx
  804d0a:	89 c8                	mov    %ecx,%eax
  804d0c:	f7 f5                	div    %ebp
  804d0e:	89 c1                	mov    %eax,%ecx
  804d10:	89 d8                	mov    %ebx,%eax
  804d12:	f7 f5                	div    %ebp
  804d14:	89 cf                	mov    %ecx,%edi
  804d16:	89 fa                	mov    %edi,%edx
  804d18:	83 c4 1c             	add    $0x1c,%esp
  804d1b:	5b                   	pop    %ebx
  804d1c:	5e                   	pop    %esi
  804d1d:	5f                   	pop    %edi
  804d1e:	5d                   	pop    %ebp
  804d1f:	c3                   	ret    
  804d20:	39 ce                	cmp    %ecx,%esi
  804d22:	77 28                	ja     804d4c <__udivdi3+0x7c>
  804d24:	0f bd fe             	bsr    %esi,%edi
  804d27:	83 f7 1f             	xor    $0x1f,%edi
  804d2a:	75 40                	jne    804d6c <__udivdi3+0x9c>
  804d2c:	39 ce                	cmp    %ecx,%esi
  804d2e:	72 0a                	jb     804d3a <__udivdi3+0x6a>
  804d30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804d34:	0f 87 9e 00 00 00    	ja     804dd8 <__udivdi3+0x108>
  804d3a:	b8 01 00 00 00       	mov    $0x1,%eax
  804d3f:	89 fa                	mov    %edi,%edx
  804d41:	83 c4 1c             	add    $0x1c,%esp
  804d44:	5b                   	pop    %ebx
  804d45:	5e                   	pop    %esi
  804d46:	5f                   	pop    %edi
  804d47:	5d                   	pop    %ebp
  804d48:	c3                   	ret    
  804d49:	8d 76 00             	lea    0x0(%esi),%esi
  804d4c:	31 ff                	xor    %edi,%edi
  804d4e:	31 c0                	xor    %eax,%eax
  804d50:	89 fa                	mov    %edi,%edx
  804d52:	83 c4 1c             	add    $0x1c,%esp
  804d55:	5b                   	pop    %ebx
  804d56:	5e                   	pop    %esi
  804d57:	5f                   	pop    %edi
  804d58:	5d                   	pop    %ebp
  804d59:	c3                   	ret    
  804d5a:	66 90                	xchg   %ax,%ax
  804d5c:	89 d8                	mov    %ebx,%eax
  804d5e:	f7 f7                	div    %edi
  804d60:	31 ff                	xor    %edi,%edi
  804d62:	89 fa                	mov    %edi,%edx
  804d64:	83 c4 1c             	add    $0x1c,%esp
  804d67:	5b                   	pop    %ebx
  804d68:	5e                   	pop    %esi
  804d69:	5f                   	pop    %edi
  804d6a:	5d                   	pop    %ebp
  804d6b:	c3                   	ret    
  804d6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804d71:	89 eb                	mov    %ebp,%ebx
  804d73:	29 fb                	sub    %edi,%ebx
  804d75:	89 f9                	mov    %edi,%ecx
  804d77:	d3 e6                	shl    %cl,%esi
  804d79:	89 c5                	mov    %eax,%ebp
  804d7b:	88 d9                	mov    %bl,%cl
  804d7d:	d3 ed                	shr    %cl,%ebp
  804d7f:	89 e9                	mov    %ebp,%ecx
  804d81:	09 f1                	or     %esi,%ecx
  804d83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804d87:	89 f9                	mov    %edi,%ecx
  804d89:	d3 e0                	shl    %cl,%eax
  804d8b:	89 c5                	mov    %eax,%ebp
  804d8d:	89 d6                	mov    %edx,%esi
  804d8f:	88 d9                	mov    %bl,%cl
  804d91:	d3 ee                	shr    %cl,%esi
  804d93:	89 f9                	mov    %edi,%ecx
  804d95:	d3 e2                	shl    %cl,%edx
  804d97:	8b 44 24 08          	mov    0x8(%esp),%eax
  804d9b:	88 d9                	mov    %bl,%cl
  804d9d:	d3 e8                	shr    %cl,%eax
  804d9f:	09 c2                	or     %eax,%edx
  804da1:	89 d0                	mov    %edx,%eax
  804da3:	89 f2                	mov    %esi,%edx
  804da5:	f7 74 24 0c          	divl   0xc(%esp)
  804da9:	89 d6                	mov    %edx,%esi
  804dab:	89 c3                	mov    %eax,%ebx
  804dad:	f7 e5                	mul    %ebp
  804daf:	39 d6                	cmp    %edx,%esi
  804db1:	72 19                	jb     804dcc <__udivdi3+0xfc>
  804db3:	74 0b                	je     804dc0 <__udivdi3+0xf0>
  804db5:	89 d8                	mov    %ebx,%eax
  804db7:	31 ff                	xor    %edi,%edi
  804db9:	e9 58 ff ff ff       	jmp    804d16 <__udivdi3+0x46>
  804dbe:	66 90                	xchg   %ax,%ax
  804dc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  804dc4:	89 f9                	mov    %edi,%ecx
  804dc6:	d3 e2                	shl    %cl,%edx
  804dc8:	39 c2                	cmp    %eax,%edx
  804dca:	73 e9                	jae    804db5 <__udivdi3+0xe5>
  804dcc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804dcf:	31 ff                	xor    %edi,%edi
  804dd1:	e9 40 ff ff ff       	jmp    804d16 <__udivdi3+0x46>
  804dd6:	66 90                	xchg   %ax,%ax
  804dd8:	31 c0                	xor    %eax,%eax
  804dda:	e9 37 ff ff ff       	jmp    804d16 <__udivdi3+0x46>
  804ddf:	90                   	nop

00804de0 <__umoddi3>:
  804de0:	55                   	push   %ebp
  804de1:	57                   	push   %edi
  804de2:	56                   	push   %esi
  804de3:	53                   	push   %ebx
  804de4:	83 ec 1c             	sub    $0x1c,%esp
  804de7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804deb:	8b 74 24 34          	mov    0x34(%esp),%esi
  804def:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804df3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804df7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804dfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804dff:	89 f3                	mov    %esi,%ebx
  804e01:	89 fa                	mov    %edi,%edx
  804e03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804e07:	89 34 24             	mov    %esi,(%esp)
  804e0a:	85 c0                	test   %eax,%eax
  804e0c:	75 1a                	jne    804e28 <__umoddi3+0x48>
  804e0e:	39 f7                	cmp    %esi,%edi
  804e10:	0f 86 a2 00 00 00    	jbe    804eb8 <__umoddi3+0xd8>
  804e16:	89 c8                	mov    %ecx,%eax
  804e18:	89 f2                	mov    %esi,%edx
  804e1a:	f7 f7                	div    %edi
  804e1c:	89 d0                	mov    %edx,%eax
  804e1e:	31 d2                	xor    %edx,%edx
  804e20:	83 c4 1c             	add    $0x1c,%esp
  804e23:	5b                   	pop    %ebx
  804e24:	5e                   	pop    %esi
  804e25:	5f                   	pop    %edi
  804e26:	5d                   	pop    %ebp
  804e27:	c3                   	ret    
  804e28:	39 f0                	cmp    %esi,%eax
  804e2a:	0f 87 ac 00 00 00    	ja     804edc <__umoddi3+0xfc>
  804e30:	0f bd e8             	bsr    %eax,%ebp
  804e33:	83 f5 1f             	xor    $0x1f,%ebp
  804e36:	0f 84 ac 00 00 00    	je     804ee8 <__umoddi3+0x108>
  804e3c:	bf 20 00 00 00       	mov    $0x20,%edi
  804e41:	29 ef                	sub    %ebp,%edi
  804e43:	89 fe                	mov    %edi,%esi
  804e45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804e49:	89 e9                	mov    %ebp,%ecx
  804e4b:	d3 e0                	shl    %cl,%eax
  804e4d:	89 d7                	mov    %edx,%edi
  804e4f:	89 f1                	mov    %esi,%ecx
  804e51:	d3 ef                	shr    %cl,%edi
  804e53:	09 c7                	or     %eax,%edi
  804e55:	89 e9                	mov    %ebp,%ecx
  804e57:	d3 e2                	shl    %cl,%edx
  804e59:	89 14 24             	mov    %edx,(%esp)
  804e5c:	89 d8                	mov    %ebx,%eax
  804e5e:	d3 e0                	shl    %cl,%eax
  804e60:	89 c2                	mov    %eax,%edx
  804e62:	8b 44 24 08          	mov    0x8(%esp),%eax
  804e66:	d3 e0                	shl    %cl,%eax
  804e68:	89 44 24 04          	mov    %eax,0x4(%esp)
  804e6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804e70:	89 f1                	mov    %esi,%ecx
  804e72:	d3 e8                	shr    %cl,%eax
  804e74:	09 d0                	or     %edx,%eax
  804e76:	d3 eb                	shr    %cl,%ebx
  804e78:	89 da                	mov    %ebx,%edx
  804e7a:	f7 f7                	div    %edi
  804e7c:	89 d3                	mov    %edx,%ebx
  804e7e:	f7 24 24             	mull   (%esp)
  804e81:	89 c6                	mov    %eax,%esi
  804e83:	89 d1                	mov    %edx,%ecx
  804e85:	39 d3                	cmp    %edx,%ebx
  804e87:	0f 82 87 00 00 00    	jb     804f14 <__umoddi3+0x134>
  804e8d:	0f 84 91 00 00 00    	je     804f24 <__umoddi3+0x144>
  804e93:	8b 54 24 04          	mov    0x4(%esp),%edx
  804e97:	29 f2                	sub    %esi,%edx
  804e99:	19 cb                	sbb    %ecx,%ebx
  804e9b:	89 d8                	mov    %ebx,%eax
  804e9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804ea1:	d3 e0                	shl    %cl,%eax
  804ea3:	89 e9                	mov    %ebp,%ecx
  804ea5:	d3 ea                	shr    %cl,%edx
  804ea7:	09 d0                	or     %edx,%eax
  804ea9:	89 e9                	mov    %ebp,%ecx
  804eab:	d3 eb                	shr    %cl,%ebx
  804ead:	89 da                	mov    %ebx,%edx
  804eaf:	83 c4 1c             	add    $0x1c,%esp
  804eb2:	5b                   	pop    %ebx
  804eb3:	5e                   	pop    %esi
  804eb4:	5f                   	pop    %edi
  804eb5:	5d                   	pop    %ebp
  804eb6:	c3                   	ret    
  804eb7:	90                   	nop
  804eb8:	89 fd                	mov    %edi,%ebp
  804eba:	85 ff                	test   %edi,%edi
  804ebc:	75 0b                	jne    804ec9 <__umoddi3+0xe9>
  804ebe:	b8 01 00 00 00       	mov    $0x1,%eax
  804ec3:	31 d2                	xor    %edx,%edx
  804ec5:	f7 f7                	div    %edi
  804ec7:	89 c5                	mov    %eax,%ebp
  804ec9:	89 f0                	mov    %esi,%eax
  804ecb:	31 d2                	xor    %edx,%edx
  804ecd:	f7 f5                	div    %ebp
  804ecf:	89 c8                	mov    %ecx,%eax
  804ed1:	f7 f5                	div    %ebp
  804ed3:	89 d0                	mov    %edx,%eax
  804ed5:	e9 44 ff ff ff       	jmp    804e1e <__umoddi3+0x3e>
  804eda:	66 90                	xchg   %ax,%ax
  804edc:	89 c8                	mov    %ecx,%eax
  804ede:	89 f2                	mov    %esi,%edx
  804ee0:	83 c4 1c             	add    $0x1c,%esp
  804ee3:	5b                   	pop    %ebx
  804ee4:	5e                   	pop    %esi
  804ee5:	5f                   	pop    %edi
  804ee6:	5d                   	pop    %ebp
  804ee7:	c3                   	ret    
  804ee8:	3b 04 24             	cmp    (%esp),%eax
  804eeb:	72 06                	jb     804ef3 <__umoddi3+0x113>
  804eed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804ef1:	77 0f                	ja     804f02 <__umoddi3+0x122>
  804ef3:	89 f2                	mov    %esi,%edx
  804ef5:	29 f9                	sub    %edi,%ecx
  804ef7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804efb:	89 14 24             	mov    %edx,(%esp)
  804efe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804f02:	8b 44 24 04          	mov    0x4(%esp),%eax
  804f06:	8b 14 24             	mov    (%esp),%edx
  804f09:	83 c4 1c             	add    $0x1c,%esp
  804f0c:	5b                   	pop    %ebx
  804f0d:	5e                   	pop    %esi
  804f0e:	5f                   	pop    %edi
  804f0f:	5d                   	pop    %ebp
  804f10:	c3                   	ret    
  804f11:	8d 76 00             	lea    0x0(%esi),%esi
  804f14:	2b 04 24             	sub    (%esp),%eax
  804f17:	19 fa                	sbb    %edi,%edx
  804f19:	89 d1                	mov    %edx,%ecx
  804f1b:	89 c6                	mov    %eax,%esi
  804f1d:	e9 71 ff ff ff       	jmp    804e93 <__umoddi3+0xb3>
  804f22:	66 90                	xchg   %ax,%ax
  804f24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804f28:	72 ea                	jb     804f14 <__umoddi3+0x134>
  804f2a:	89 d9                	mov    %ebx,%ecx
  804f2c:	e9 62 ff ff ff       	jmp    804e93 <__umoddi3+0xb3>
