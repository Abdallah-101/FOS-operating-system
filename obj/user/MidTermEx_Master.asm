
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 dc 02 00 00       	call   800312 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 e0 43 80 00       	push   $0x8043e0
  80004a:	e8 03 22 00 00       	call   802252 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	char select;
	sys_lock_cons();
  80005e:	e8 03 2e 00 00       	call   802e66 <sys_lock_cons>
	{
		cprintf("%~Which type of concurrency protection do you want to use? \n") ;
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 e4 43 80 00       	push   $0x8043e4
  80006b:	e8 3b 05 00 00       	call   8005ab <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("%~0) Nothing\n") ;
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 21 44 80 00       	push   $0x804421
  80007b:	e8 2b 05 00 00       	call   8005ab <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("%~1) Semaphores\n") ;
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 2f 44 80 00       	push   $0x80442f
  80008b:	e8 1b 05 00 00       	call   8005ab <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("%~2) SpinLock\n") ;
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 40 44 80 00       	push   $0x804440
  80009b:	e8 0b 05 00 00       	call   8005ab <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("%~your choice (0, 1, 2): ") ;
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 4f 44 80 00       	push   $0x80444f
  8000ab:	e8 fb 04 00 00       	call   8005ab <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp
		select = getchar() ;
  8000b3:	e8 3d 02 00 00       	call   8002f5 <getchar>
  8000b8:	88 45 f3             	mov    %al,-0xd(%ebp)
		cputchar(select);
  8000bb:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  8000bf:	83 ec 0c             	sub    $0xc,%esp
  8000c2:	50                   	push   %eax
  8000c3:	e8 0e 02 00 00       	call   8002d6 <cputchar>
  8000c8:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	6a 0a                	push   $0xa
  8000d0:	e8 01 02 00 00       	call   8002d6 <cputchar>
  8000d5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8000d8:	e8 a3 2d 00 00       	call   802e80 <sys_unlock_cons>

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *protType = smalloc("protType", sizeof(int) , 0) ;
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	6a 00                	push   $0x0
  8000e2:	6a 04                	push   $0x4
  8000e4:	68 69 44 80 00       	push   $0x804469
  8000e9:	e8 64 21 00 00       	call   802252 <smalloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*protType = 0 ;
  8000f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == '1') 		*protType = 1 ;
  8000fd:	80 7d f3 31          	cmpb   $0x31,-0xd(%ebp)
  800101:	75 0b                	jne    80010e <_main+0xd6>
  800103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800106:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  80010c:	eb 0f                	jmp    80011d <_main+0xe5>
	else if (select == '2') *protType = 2 ;
  80010e:	80 7d f3 32          	cmpb   $0x32,-0xd(%ebp)
  800112:	75 09                	jne    80011d <_main+0xe5>
  800114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800117:	c7 00 02 00 00 00    	movl   $0x2,(%eax)

	struct semaphore T, finished, finishedCountMutex;
	struct uspinlock *sT, *sfinishedCountMutex;
	int *numOfFinished ;
	if (*protType == 1)
  80011d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800120:	8b 00                	mov    (%eax),%eax
  800122:	83 f8 01             	cmp    $0x1,%eax
  800125:	75 44                	jne    80016b <_main+0x133>
	{
		T = create_semaphore("T", 0);
  800127:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80012a:	83 ec 04             	sub    $0x4,%esp
  80012d:	6a 00                	push   $0x0
  80012f:	68 72 44 80 00       	push   $0x804472
  800134:	50                   	push   %eax
  800135:	e8 cf 3c 00 00       	call   803e09 <create_semaphore>
  80013a:	83 c4 0c             	add    $0xc,%esp
		finished = create_semaphore("finished", 0);
  80013d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 00                	push   $0x0
  800145:	68 74 44 80 00       	push   $0x804474
  80014a:	50                   	push   %eax
  80014b:	e8 b9 3c 00 00       	call   803e09 <create_semaphore>
  800150:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = create_semaphore("finishedCountMutex", 1);
  800153:	8d 45 cc             	lea    -0x34(%ebp),%eax
  800156:	83 ec 04             	sub    $0x4,%esp
  800159:	6a 01                	push   $0x1
  80015b:	68 7d 44 80 00       	push   $0x80447d
  800160:	50                   	push   %eax
  800161:	e8 a3 3c 00 00       	call   803e09 <create_semaphore>
  800166:	83 c4 0c             	add    $0xc,%esp
  800169:	eb 62                	jmp    8001cd <_main+0x195>
	}
	else if (*protType == 2)
  80016b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016e:	8b 00                	mov    (%eax),%eax
  800170:	83 f8 02             	cmp    $0x2,%eax
  800173:	75 58                	jne    8001cd <_main+0x195>
	{
		sT = smalloc("T", sizeof(struct uspinlock), 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 44                	push   $0x44
  80017c:	68 72 44 80 00       	push   $0x804472
  800181:	e8 cc 20 00 00       	call   802252 <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e8             	mov    %eax,-0x18(%ebp)
		init_uspinlock(sT, "T", 0);
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	6a 00                	push   $0x0
  800191:	68 72 44 80 00       	push   $0x804472
  800196:	ff 75 e8             	pushl  -0x18(%ebp)
  800199:	e8 de 3c 00 00       	call   803e7c <init_uspinlock>
  80019e:	83 c4 10             	add    $0x10,%esp
		sfinishedCountMutex = smalloc("finishedCountMutex", sizeof(struct uspinlock), 1);
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	6a 01                	push   $0x1
  8001a6:	6a 44                	push   $0x44
  8001a8:	68 7d 44 80 00       	push   $0x80447d
  8001ad:	e8 a0 20 00 00       	call   802252 <smalloc>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		init_uspinlock(sfinishedCountMutex, "finishedCountMutex", 1);
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	6a 01                	push   $0x1
  8001bd:	68 7d 44 80 00       	push   $0x80447d
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 b2 3c 00 00       	call   803e7c <init_uspinlock>
  8001ca:	83 c4 10             	add    $0x10,%esp
	}
	//Create the check-finishing counter
	numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001cd:	83 ec 04             	sub    $0x4,%esp
  8001d0:	6a 01                	push   $0x1
  8001d2:	6a 04                	push   $0x4
  8001d4:	68 90 44 80 00       	push   $0x804490
  8001d9:	e8 74 20 00 00       	call   802252 <smalloc>
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  8001e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f2:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001fd:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800203:	89 c1                	mov    %eax,%ecx
  800205:	a1 20 50 80 00       	mov    0x805020,%eax
  80020a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800210:	52                   	push   %edx
  800211:	51                   	push   %ecx
  800212:	50                   	push   %eax
  800213:	68 9e 44 80 00       	push   $0x80449e
  800218:	e8 54 2e 00 00       	call   803071 <sys_create_env>
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800223:	a1 20 50 80 00       	mov    0x805020,%eax
  800228:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80022e:	a1 20 50 80 00       	mov    0x805020,%eax
  800233:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800239:	89 c1                	mov    %eax,%ecx
  80023b:	a1 20 50 80 00       	mov    0x805020,%eax
  800240:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800246:	52                   	push   %edx
  800247:	51                   	push   %ecx
  800248:	50                   	push   %eax
  800249:	68 a8 44 80 00       	push   $0x8044a8
  80024e:	e8 1e 2e 00 00       	call   803071 <sys_create_env>
  800253:	83 c4 10             	add    $0x10,%esp
  800256:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 dc             	pushl  -0x24(%ebp)
  80025f:	e8 2b 2e 00 00       	call   80308f <sys_run_env>
  800264:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	ff 75 d8             	pushl  -0x28(%ebp)
  80026d:	e8 1d 2e 00 00       	call   80308f <sys_run_env>
  800272:	83 c4 10             	add    $0x10,%esp

	/*[5] WAIT TILL FINISHING BOTH PROCESSES*/
	if (*protType == 1)
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	83 f8 01             	cmp    $0x1,%eax
  80027d:	75 1c                	jne    80029b <_main+0x263>
	{
		wait_semaphore(finished);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	ff 75 d0             	pushl  -0x30(%ebp)
  800285:	e8 b3 3b 00 00       	call   803e3d <wait_semaphore>
  80028a:	83 c4 10             	add    $0x10,%esp
		wait_semaphore(finished);
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	ff 75 d0             	pushl  -0x30(%ebp)
  800293:	e8 a5 3b 00 00       	call   803e3d <wait_semaphore>
  800298:	83 c4 10             	add    $0x10,%esp
	}
	if (*protType == 2)
  80029b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029e:	8b 00                	mov    (%eax),%eax
  8002a0:	83 f8 02             	cmp    $0x2,%eax
  8002a3:	75 0d                	jne    8002b2 <_main+0x27a>
	{
		while (*numOfFinished != 2) ;
  8002a5:	90                   	nop
  8002a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a9:	8b 00                	mov    (%eax),%eax
  8002ab:	83 f8 02             	cmp    $0x2,%eax
  8002ae:	75 f6                	jne    8002a6 <_main+0x26e>
  8002b0:	eb 0b                	jmp    8002bd <_main+0x285>
	}
	else
	{
		while (*numOfFinished != 2) ;
  8002b2:	90                   	nop
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	8b 00                	mov    (%eax),%eax
  8002b8:	83 f8 02             	cmp    $0x2,%eax
  8002bb:	75 f6                	jne    8002b3 <_main+0x27b>
	}

	/*[6] PRINT X*/
	atomic_cprintf("%~Final value of X = %d\n", *X);
  8002bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c0:	8b 00                	mov    (%eax),%eax
  8002c2:	83 ec 08             	sub    $0x8,%esp
  8002c5:	50                   	push   %eax
  8002c6:	68 b2 44 80 00       	push   $0x8044b2
  8002cb:	e8 4d 03 00 00       	call   80061d <atomic_cprintf>
  8002d0:	83 c4 10             	add    $0x10,%esp

	return;
  8002d3:	90                   	nop
}
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002df:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8002e2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	50                   	push   %eax
  8002ea:	e8 bf 2c 00 00       	call   802fae <sys_cputc>
  8002ef:	83 c4 10             	add    $0x10,%esp
}
  8002f2:	90                   	nop
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <getchar>:


int
getchar(void)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8002fb:	e8 4d 2b 00 00       	call   802e4d <sys_cgetc>
  800300:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <iscons>:

int iscons(int fdnum)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80030b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	57                   	push   %edi
  800316:	56                   	push   %esi
  800317:	53                   	push   %ebx
  800318:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80031b:	e8 bf 2d 00 00       	call   8030df <sys_getenvindex>
  800320:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800323:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800326:	89 d0                	mov    %edx,%eax
  800328:	c1 e0 02             	shl    $0x2,%eax
  80032b:	01 d0                	add    %edx,%eax
  80032d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800334:	01 d0                	add    %edx,%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	c1 e2 04             	shl    $0x4,%edx
  80033b:	29 c2                	sub    %eax,%edx
  80033d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800344:	89 c2                	mov    %eax,%edx
  800346:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80034c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800351:	a1 20 50 80 00       	mov    0x805020,%eax
  800356:	8a 40 20             	mov    0x20(%eax),%al
  800359:	84 c0                	test   %al,%al
  80035b:	74 0d                	je     80036a <libmain+0x58>
		binaryname = myEnv->prog_name;
  80035d:	a1 20 50 80 00       	mov    0x805020,%eax
  800362:	83 c0 20             	add    $0x20,%eax
  800365:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80036a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80036e:	7e 0a                	jle    80037a <libmain+0x68>
		binaryname = argv[0];
  800370:	8b 45 0c             	mov    0xc(%ebp),%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	ff 75 0c             	pushl  0xc(%ebp)
  800380:	ff 75 08             	pushl  0x8(%ebp)
  800383:	e8 b0 fc ff ff       	call   800038 <_main>
  800388:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80038b:	a1 00 50 80 00       	mov    0x805000,%eax
  800390:	85 c0                	test   %eax,%eax
  800392:	0f 84 01 01 00 00    	je     800499 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800398:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80039e:	bb c4 45 80 00       	mov    $0x8045c4,%ebx
  8003a3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003a8:	89 c7                	mov    %eax,%edi
  8003aa:	89 de                	mov    %ebx,%esi
  8003ac:	89 d1                	mov    %edx,%ecx
  8003ae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003b0:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003b3:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003b8:	b0 00                	mov    $0x0,%al
  8003ba:	89 d7                	mov    %edx,%edi
  8003bc:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	50                   	push   %eax
  8003cc:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003d2:	50                   	push   %eax
  8003d3:	e8 3d 2f 00 00       	call   803315 <sys_utilities>
  8003d8:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003db:	e8 86 2a 00 00       	call   802e66 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003e0:	83 ec 0c             	sub    $0xc,%esp
  8003e3:	68 e4 44 80 00       	push   $0x8044e4
  8003e8:	e8 be 01 00 00       	call   8005ab <cprintf>
  8003ed:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f3:	85 c0                	test   %eax,%eax
  8003f5:	74 18                	je     80040f <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003f7:	e8 37 2f 00 00       	call   803333 <sys_get_optimal_num_faults>
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	50                   	push   %eax
  800400:	68 0c 45 80 00       	push   $0x80450c
  800405:	e8 a1 01 00 00       	call   8005ab <cprintf>
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	eb 59                	jmp    800468 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80040f:	a1 20 50 80 00       	mov    0x805020,%eax
  800414:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80041a:	a1 20 50 80 00       	mov    0x805020,%eax
  80041f:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800425:	83 ec 04             	sub    $0x4,%esp
  800428:	52                   	push   %edx
  800429:	50                   	push   %eax
  80042a:	68 30 45 80 00       	push   $0x804530
  80042f:	e8 77 01 00 00       	call   8005ab <cprintf>
  800434:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800437:	a1 20 50 80 00       	mov    0x805020,%eax
  80043c:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800442:	a1 20 50 80 00       	mov    0x805020,%eax
  800447:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80044d:	a1 20 50 80 00       	mov    0x805020,%eax
  800452:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800458:	51                   	push   %ecx
  800459:	52                   	push   %edx
  80045a:	50                   	push   %eax
  80045b:	68 58 45 80 00       	push   $0x804558
  800460:	e8 46 01 00 00       	call   8005ab <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800468:	a1 20 50 80 00       	mov    0x805020,%eax
  80046d:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	50                   	push   %eax
  800477:	68 b0 45 80 00       	push   $0x8045b0
  80047c:	e8 2a 01 00 00       	call   8005ab <cprintf>
  800481:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 e4 44 80 00       	push   $0x8044e4
  80048c:	e8 1a 01 00 00       	call   8005ab <cprintf>
  800491:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800494:	e8 e7 29 00 00       	call   802e80 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800499:	e8 1f 00 00 00       	call   8004bd <exit>
}
  80049e:	90                   	nop
  80049f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004a2:	5b                   	pop    %ebx
  8004a3:	5e                   	pop    %esi
  8004a4:	5f                   	pop    %edi
  8004a5:	5d                   	pop    %ebp
  8004a6:	c3                   	ret    

008004a7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004ad:	83 ec 0c             	sub    $0xc,%esp
  8004b0:	6a 00                	push   $0x0
  8004b2:	e8 f4 2b 00 00       	call   8030ab <sys_destroy_env>
  8004b7:	83 c4 10             	add    $0x10,%esp
}
  8004ba:	90                   	nop
  8004bb:	c9                   	leave  
  8004bc:	c3                   	ret    

008004bd <exit>:

void
exit(void)
{
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004c3:	e8 49 2c 00 00       	call   803111 <sys_exit_env>
}
  8004c8:	90                   	nop
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	53                   	push   %ebx
  8004cf:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d5:	8b 00                	mov    (%eax),%eax
  8004d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8004da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004dd:	89 0a                	mov    %ecx,(%edx)
  8004df:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e2:	88 d1                	mov    %dl,%cl
  8004e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f5:	75 30                	jne    800527 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004f7:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  8004fd:	a0 44 50 80 00       	mov    0x805044,%al
  800502:	0f b6 c0             	movzbl %al,%eax
  800505:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800508:	8b 09                	mov    (%ecx),%ecx
  80050a:	89 cb                	mov    %ecx,%ebx
  80050c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80050f:	83 c1 08             	add    $0x8,%ecx
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	53                   	push   %ebx
  800515:	51                   	push   %ecx
  800516:	e8 07 29 00 00       	call   802e22 <sys_cputs>
  80051b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800521:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	8b 40 04             	mov    0x4(%eax),%eax
  80052d:	8d 50 01             	lea    0x1(%eax),%edx
  800530:	8b 45 0c             	mov    0xc(%ebp),%eax
  800533:	89 50 04             	mov    %edx,0x4(%eax)
}
  800536:	90                   	nop
  800537:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800545:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80054c:	00 00 00 
	b.cnt = 0;
  80054f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800556:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800559:	ff 75 0c             	pushl  0xc(%ebp)
  80055c:	ff 75 08             	pushl  0x8(%ebp)
  80055f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800565:	50                   	push   %eax
  800566:	68 cb 04 80 00       	push   $0x8004cb
  80056b:	e8 5a 02 00 00       	call   8007ca <vprintfmt>
  800570:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800573:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  800579:	a0 44 50 80 00       	mov    0x805044,%al
  80057e:	0f b6 c0             	movzbl %al,%eax
  800581:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800587:	52                   	push   %edx
  800588:	50                   	push   %eax
  800589:	51                   	push   %ecx
  80058a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800590:	83 c0 08             	add    $0x8,%eax
  800593:	50                   	push   %eax
  800594:	e8 89 28 00 00       	call   802e22 <sys_cputs>
  800599:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80059c:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8005a3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005a9:	c9                   	leave  
  8005aa:	c3                   	ret    

008005ab <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005ab:	55                   	push   %ebp
  8005ac:	89 e5                	mov    %esp,%ebp
  8005ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005b1:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8005b8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005be:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c7:	50                   	push   %eax
  8005c8:	e8 6f ff ff ff       	call   80053c <vcprintf>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d6:	c9                   	leave  
  8005d7:	c3                   	ret    

008005d8 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005d8:	55                   	push   %ebp
  8005d9:	89 e5                	mov    %esp,%ebp
  8005db:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005de:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e8:	c1 e0 08             	shl    $0x8,%eax
  8005eb:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  8005f0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f3:	83 c0 04             	add    $0x4,%eax
  8005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800602:	50                   	push   %eax
  800603:	e8 34 ff ff ff       	call   80053c <vcprintf>
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80060e:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  800615:	07 00 00 

	return cnt;
  800618:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80061b:	c9                   	leave  
  80061c:	c3                   	ret    

0080061d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800623:	e8 3e 28 00 00       	call   802e66 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800628:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80062e:	8b 45 08             	mov    0x8(%ebp),%eax
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	50                   	push   %eax
  800638:	e8 ff fe ff ff       	call   80053c <vcprintf>
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800643:	e8 38 28 00 00       	call   802e80 <sys_unlock_cons>
	return cnt;
  800648:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064b:	c9                   	leave  
  80064c:	c3                   	ret    

0080064d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80064d:	55                   	push   %ebp
  80064e:	89 e5                	mov    %esp,%ebp
  800650:	53                   	push   %ebx
  800651:	83 ec 14             	sub    $0x14,%esp
  800654:	8b 45 10             	mov    0x10(%ebp),%eax
  800657:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800660:	8b 45 18             	mov    0x18(%ebp),%eax
  800663:	ba 00 00 00 00       	mov    $0x0,%edx
  800668:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80066b:	77 55                	ja     8006c2 <printnum+0x75>
  80066d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800670:	72 05                	jb     800677 <printnum+0x2a>
  800672:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800675:	77 4b                	ja     8006c2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800677:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80067a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80067d:	8b 45 18             	mov    0x18(%ebp),%eax
  800680:	ba 00 00 00 00       	mov    $0x0,%edx
  800685:	52                   	push   %edx
  800686:	50                   	push   %eax
  800687:	ff 75 f4             	pushl  -0xc(%ebp)
  80068a:	ff 75 f0             	pushl  -0x10(%ebp)
  80068d:	e8 e2 3a 00 00       	call   804174 <__udivdi3>
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	ff 75 20             	pushl  0x20(%ebp)
  80069b:	53                   	push   %ebx
  80069c:	ff 75 18             	pushl  0x18(%ebp)
  80069f:	52                   	push   %edx
  8006a0:	50                   	push   %eax
  8006a1:	ff 75 0c             	pushl  0xc(%ebp)
  8006a4:	ff 75 08             	pushl  0x8(%ebp)
  8006a7:	e8 a1 ff ff ff       	call   80064d <printnum>
  8006ac:	83 c4 20             	add    $0x20,%esp
  8006af:	eb 1a                	jmp    8006cb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	ff 75 0c             	pushl  0xc(%ebp)
  8006b7:	ff 75 20             	pushl  0x20(%ebp)
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	ff d0                	call   *%eax
  8006bf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006c2:	ff 4d 1c             	decl   0x1c(%ebp)
  8006c5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c9:	7f e6                	jg     8006b1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006cb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d9:	53                   	push   %ebx
  8006da:	51                   	push   %ecx
  8006db:	52                   	push   %edx
  8006dc:	50                   	push   %eax
  8006dd:	e8 a2 3b 00 00       	call   804284 <__umoddi3>
  8006e2:	83 c4 10             	add    $0x10,%esp
  8006e5:	05 54 48 80 00       	add    $0x804854,%eax
  8006ea:	8a 00                	mov    (%eax),%al
  8006ec:	0f be c0             	movsbl %al,%eax
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	50                   	push   %eax
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	ff d0                	call   *%eax
  8006fb:	83 c4 10             	add    $0x10,%esp
}
  8006fe:	90                   	nop
  8006ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800707:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80070b:	7e 1c                	jle    800729 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	8d 50 08             	lea    0x8(%eax),%edx
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	89 10                	mov    %edx,(%eax)
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	83 e8 08             	sub    $0x8,%eax
  800722:	8b 50 04             	mov    0x4(%eax),%edx
  800725:	8b 00                	mov    (%eax),%eax
  800727:	eb 40                	jmp    800769 <getuint+0x65>
	else if (lflag)
  800729:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80072d:	74 1e                	je     80074d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	8d 50 04             	lea    0x4(%eax),%edx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	89 10                	mov    %edx,(%eax)
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	83 e8 04             	sub    $0x4,%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	ba 00 00 00 00       	mov    $0x0,%edx
  80074b:	eb 1c                	jmp    800769 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	8d 50 04             	lea    0x4(%eax),%edx
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	89 10                	mov    %edx,(%eax)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	83 e8 04             	sub    $0x4,%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800769:	5d                   	pop    %ebp
  80076a:	c3                   	ret    

0080076b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80076e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800772:	7e 1c                	jle    800790 <getint+0x25>
		return va_arg(*ap, long long);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	8d 50 08             	lea    0x8(%eax),%edx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	89 10                	mov    %edx,(%eax)
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	83 e8 08             	sub    $0x8,%eax
  800789:	8b 50 04             	mov    0x4(%eax),%edx
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	eb 38                	jmp    8007c8 <getint+0x5d>
	else if (lflag)
  800790:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800794:	74 1a                	je     8007b0 <getint+0x45>
		return va_arg(*ap, long);
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	8d 50 04             	lea    0x4(%eax),%edx
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	89 10                	mov    %edx,(%eax)
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	83 e8 04             	sub    $0x4,%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	99                   	cltd   
  8007ae:	eb 18                	jmp    8007c8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	8d 50 04             	lea    0x4(%eax),%edx
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	89 10                	mov    %edx,(%eax)
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	83 e8 04             	sub    $0x4,%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	99                   	cltd   
}
  8007c8:	5d                   	pop    %ebp
  8007c9:	c3                   	ret    

008007ca <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	56                   	push   %esi
  8007ce:	53                   	push   %ebx
  8007cf:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d2:	eb 17                	jmp    8007eb <vprintfmt+0x21>
			if (ch == '\0')
  8007d4:	85 db                	test   %ebx,%ebx
  8007d6:	0f 84 c1 03 00 00    	je     800b9d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 0c             	pushl  0xc(%ebp)
  8007e2:	53                   	push   %ebx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	ff d0                	call   *%eax
  8007e8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ee:	8d 50 01             	lea    0x1(%eax),%edx
  8007f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007f4:	8a 00                	mov    (%eax),%al
  8007f6:	0f b6 d8             	movzbl %al,%ebx
  8007f9:	83 fb 25             	cmp    $0x25,%ebx
  8007fc:	75 d6                	jne    8007d4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007fe:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800802:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800809:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800810:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800817:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80081e:	8b 45 10             	mov    0x10(%ebp),%eax
  800821:	8d 50 01             	lea    0x1(%eax),%edx
  800824:	89 55 10             	mov    %edx,0x10(%ebp)
  800827:	8a 00                	mov    (%eax),%al
  800829:	0f b6 d8             	movzbl %al,%ebx
  80082c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80082f:	83 f8 5b             	cmp    $0x5b,%eax
  800832:	0f 87 3d 03 00 00    	ja     800b75 <vprintfmt+0x3ab>
  800838:	8b 04 85 78 48 80 00 	mov    0x804878(,%eax,4),%eax
  80083f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800841:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800845:	eb d7                	jmp    80081e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800847:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80084b:	eb d1                	jmp    80081e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80084d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800854:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800857:	89 d0                	mov    %edx,%eax
  800859:	c1 e0 02             	shl    $0x2,%eax
  80085c:	01 d0                	add    %edx,%eax
  80085e:	01 c0                	add    %eax,%eax
  800860:	01 d8                	add    %ebx,%eax
  800862:	83 e8 30             	sub    $0x30,%eax
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800868:	8b 45 10             	mov    0x10(%ebp),%eax
  80086b:	8a 00                	mov    (%eax),%al
  80086d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800870:	83 fb 2f             	cmp    $0x2f,%ebx
  800873:	7e 3e                	jle    8008b3 <vprintfmt+0xe9>
  800875:	83 fb 39             	cmp    $0x39,%ebx
  800878:	7f 39                	jg     8008b3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80087d:	eb d5                	jmp    800854 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 c0 04             	add    $0x4,%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
  800888:	8b 45 14             	mov    0x14(%ebp),%eax
  80088b:	83 e8 04             	sub    $0x4,%eax
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800893:	eb 1f                	jmp    8008b4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800895:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800899:	79 83                	jns    80081e <vprintfmt+0x54>
				width = 0;
  80089b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008a2:	e9 77 ff ff ff       	jmp    80081e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008ae:	e9 6b ff ff ff       	jmp    80081e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008b3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b8:	0f 89 60 ff ff ff    	jns    80081e <vprintfmt+0x54>
				width = precision, precision = -1;
  8008be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008cb:	e9 4e ff ff ff       	jmp    80081e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008d0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008d3:	e9 46 ff ff ff       	jmp    80081e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 c0 04             	add    $0x4,%eax
  8008de:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	83 e8 04             	sub    $0x4,%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
			break;
  8008f8:	e9 9b 02 00 00       	jmp    800b98 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	83 c0 04             	add    $0x4,%eax
  800903:	89 45 14             	mov    %eax,0x14(%ebp)
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 e8 04             	sub    $0x4,%eax
  80090c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80090e:	85 db                	test   %ebx,%ebx
  800910:	79 02                	jns    800914 <vprintfmt+0x14a>
				err = -err;
  800912:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800914:	83 fb 64             	cmp    $0x64,%ebx
  800917:	7f 0b                	jg     800924 <vprintfmt+0x15a>
  800919:	8b 34 9d c0 46 80 00 	mov    0x8046c0(,%ebx,4),%esi
  800920:	85 f6                	test   %esi,%esi
  800922:	75 19                	jne    80093d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800924:	53                   	push   %ebx
  800925:	68 65 48 80 00       	push   $0x804865
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	ff 75 08             	pushl  0x8(%ebp)
  800930:	e8 70 02 00 00       	call   800ba5 <printfmt>
  800935:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800938:	e9 5b 02 00 00       	jmp    800b98 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80093d:	56                   	push   %esi
  80093e:	68 6e 48 80 00       	push   $0x80486e
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	ff 75 08             	pushl  0x8(%ebp)
  800949:	e8 57 02 00 00       	call   800ba5 <printfmt>
  80094e:	83 c4 10             	add    $0x10,%esp
			break;
  800951:	e9 42 02 00 00       	jmp    800b98 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	83 c0 04             	add    $0x4,%eax
  80095c:	89 45 14             	mov    %eax,0x14(%ebp)
  80095f:	8b 45 14             	mov    0x14(%ebp),%eax
  800962:	83 e8 04             	sub    $0x4,%eax
  800965:	8b 30                	mov    (%eax),%esi
  800967:	85 f6                	test   %esi,%esi
  800969:	75 05                	jne    800970 <vprintfmt+0x1a6>
				p = "(null)";
  80096b:	be 71 48 80 00       	mov    $0x804871,%esi
			if (width > 0 && padc != '-')
  800970:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800974:	7e 6d                	jle    8009e3 <vprintfmt+0x219>
  800976:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80097a:	74 67                	je     8009e3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80097c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	50                   	push   %eax
  800983:	56                   	push   %esi
  800984:	e8 1e 03 00 00       	call   800ca7 <strnlen>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80098f:	eb 16                	jmp    8009a7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800991:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	ff 75 0c             	pushl  0xc(%ebp)
  80099b:	50                   	push   %eax
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	ff d0                	call   *%eax
  8009a1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ab:	7f e4                	jg     800991 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ad:	eb 34                	jmp    8009e3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009b3:	74 1c                	je     8009d1 <vprintfmt+0x207>
  8009b5:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b8:	7e 05                	jle    8009bf <vprintfmt+0x1f5>
  8009ba:	83 fb 7e             	cmp    $0x7e,%ebx
  8009bd:	7e 12                	jle    8009d1 <vprintfmt+0x207>
					putch('?', putdat);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	ff 75 0c             	pushl  0xc(%ebp)
  8009c5:	6a 3f                	push   $0x3f
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	ff d0                	call   *%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
  8009cf:	eb 0f                	jmp    8009e0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	53                   	push   %ebx
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e3:	89 f0                	mov    %esi,%eax
  8009e5:	8d 70 01             	lea    0x1(%eax),%esi
  8009e8:	8a 00                	mov    (%eax),%al
  8009ea:	0f be d8             	movsbl %al,%ebx
  8009ed:	85 db                	test   %ebx,%ebx
  8009ef:	74 24                	je     800a15 <vprintfmt+0x24b>
  8009f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f5:	78 b8                	js     8009af <vprintfmt+0x1e5>
  8009f7:	ff 4d e0             	decl   -0x20(%ebp)
  8009fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009fe:	79 af                	jns    8009af <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a00:	eb 13                	jmp    800a15 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a02:	83 ec 08             	sub    $0x8,%esp
  800a05:	ff 75 0c             	pushl  0xc(%ebp)
  800a08:	6a 20                	push   $0x20
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a12:	ff 4d e4             	decl   -0x1c(%ebp)
  800a15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a19:	7f e7                	jg     800a02 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a1b:	e9 78 01 00 00       	jmp    800b98 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 e8             	pushl  -0x18(%ebp)
  800a26:	8d 45 14             	lea    0x14(%ebp),%eax
  800a29:	50                   	push   %eax
  800a2a:	e8 3c fd ff ff       	call   80076b <getint>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a35:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a3e:	85 d2                	test   %edx,%edx
  800a40:	79 23                	jns    800a65 <vprintfmt+0x29b>
				putch('-', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 2d                	push   $0x2d
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a58:	f7 d8                	neg    %eax
  800a5a:	83 d2 00             	adc    $0x0,%edx
  800a5d:	f7 da                	neg    %edx
  800a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a62:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a65:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a6c:	e9 bc 00 00 00       	jmp    800b2d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 e8             	pushl  -0x18(%ebp)
  800a77:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7a:	50                   	push   %eax
  800a7b:	e8 84 fc ff ff       	call   800704 <getuint>
  800a80:	83 c4 10             	add    $0x10,%esp
  800a83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a86:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a89:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a90:	e9 98 00 00 00       	jmp    800b2d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	6a 58                	push   $0x58
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aa5:	83 ec 08             	sub    $0x8,%esp
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	6a 58                	push   $0x58
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	6a 58                	push   $0x58
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	ff d0                	call   *%eax
  800ac2:	83 c4 10             	add    $0x10,%esp
			break;
  800ac5:	e9 ce 00 00 00       	jmp    800b98 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	6a 30                	push   $0x30
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	6a 78                	push   $0x78
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	83 c0 04             	add    $0x4,%eax
  800af0:	89 45 14             	mov    %eax,0x14(%ebp)
  800af3:	8b 45 14             	mov    0x14(%ebp),%eax
  800af6:	83 e8 04             	sub    $0x4,%eax
  800af9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b05:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b0c:	eb 1f                	jmp    800b2d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 e8             	pushl  -0x18(%ebp)
  800b14:	8d 45 14             	lea    0x14(%ebp),%eax
  800b17:	50                   	push   %eax
  800b18:	e8 e7 fb ff ff       	call   800704 <getuint>
  800b1d:	83 c4 10             	add    $0x10,%esp
  800b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b23:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b26:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b2d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b34:	83 ec 04             	sub    $0x4,%esp
  800b37:	52                   	push   %edx
  800b38:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b3b:	50                   	push   %eax
  800b3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3f:	ff 75 f0             	pushl  -0x10(%ebp)
  800b42:	ff 75 0c             	pushl  0xc(%ebp)
  800b45:	ff 75 08             	pushl  0x8(%ebp)
  800b48:	e8 00 fb ff ff       	call   80064d <printnum>
  800b4d:	83 c4 20             	add    $0x20,%esp
			break;
  800b50:	eb 46                	jmp    800b98 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	ff 75 0c             	pushl  0xc(%ebp)
  800b58:	53                   	push   %ebx
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	ff d0                	call   *%eax
  800b5e:	83 c4 10             	add    $0x10,%esp
			break;
  800b61:	eb 35                	jmp    800b98 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b63:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800b6a:	eb 2c                	jmp    800b98 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b6c:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800b73:	eb 23                	jmp    800b98 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 25                	push   $0x25
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b85:	ff 4d 10             	decl   0x10(%ebp)
  800b88:	eb 03                	jmp    800b8d <vprintfmt+0x3c3>
  800b8a:	ff 4d 10             	decl   0x10(%ebp)
  800b8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b90:	48                   	dec    %eax
  800b91:	8a 00                	mov    (%eax),%al
  800b93:	3c 25                	cmp    $0x25,%al
  800b95:	75 f3                	jne    800b8a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b97:	90                   	nop
		}
	}
  800b98:	e9 35 fc ff ff       	jmp    8007d2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b9d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bab:	8d 45 10             	lea    0x10(%ebp),%eax
  800bae:	83 c0 04             	add    $0x4,%eax
  800bb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bba:	50                   	push   %eax
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	ff 75 08             	pushl  0x8(%ebp)
  800bc1:	e8 04 fc ff ff       	call   8007ca <vprintfmt>
  800bc6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bc9:	90                   	nop
  800bca:	c9                   	leave  
  800bcb:	c3                   	ret    

00800bcc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	8b 40 08             	mov    0x8(%eax),%eax
  800bd5:	8d 50 01             	lea    0x1(%eax),%edx
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be1:	8b 10                	mov    (%eax),%edx
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	8b 40 04             	mov    0x4(%eax),%eax
  800be9:	39 c2                	cmp    %eax,%edx
  800beb:	73 12                	jae    800bff <sprintputch+0x33>
		*b->buf++ = ch;
  800bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf0:	8b 00                	mov    (%eax),%eax
  800bf2:	8d 48 01             	lea    0x1(%eax),%ecx
  800bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf8:	89 0a                	mov    %ecx,(%edx)
  800bfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfd:	88 10                	mov    %dl,(%eax)
}
  800bff:	90                   	nop
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	01 d0                	add    %edx,%eax
  800c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c27:	74 06                	je     800c2f <vsnprintf+0x2d>
  800c29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2d:	7f 07                	jg     800c36 <vsnprintf+0x34>
		return -E_INVAL;
  800c2f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c34:	eb 20                	jmp    800c56 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c36:	ff 75 14             	pushl  0x14(%ebp)
  800c39:	ff 75 10             	pushl  0x10(%ebp)
  800c3c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c3f:	50                   	push   %eax
  800c40:	68 cc 0b 80 00       	push   $0x800bcc
  800c45:	e8 80 fb ff ff       	call   8007ca <vprintfmt>
  800c4a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c50:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c5e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c61:	83 c0 04             	add    $0x4,%eax
  800c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6d:	50                   	push   %eax
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	ff 75 08             	pushl  0x8(%ebp)
  800c74:	e8 89 ff ff ff       	call   800c02 <vsnprintf>
  800c79:	83 c4 10             	add    $0x10,%esp
  800c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c91:	eb 06                	jmp    800c99 <strlen+0x15>
		n++;
  800c93:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c96:	ff 45 08             	incl   0x8(%ebp)
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	84 c0                	test   %al,%al
  800ca0:	75 f1                	jne    800c93 <strlen+0xf>
		n++;
	return n;
  800ca2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb4:	eb 09                	jmp    800cbf <strnlen+0x18>
		n++;
  800cb6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb9:	ff 45 08             	incl   0x8(%ebp)
  800cbc:	ff 4d 0c             	decl   0xc(%ebp)
  800cbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc3:	74 09                	je     800cce <strnlen+0x27>
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8a 00                	mov    (%eax),%al
  800cca:	84 c0                	test   %al,%al
  800ccc:	75 e8                	jne    800cb6 <strnlen+0xf>
		n++;
	return n;
  800cce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cdf:	90                   	nop
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8d 50 01             	lea    0x1(%eax),%edx
  800ce6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cef:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cf2:	8a 12                	mov    (%edx),%dl
  800cf4:	88 10                	mov    %dl,(%eax)
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	84 c0                	test   %al,%al
  800cfa:	75 e4                	jne    800ce0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cff:	c9                   	leave  
  800d00:	c3                   	ret    

00800d01 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d14:	eb 1f                	jmp    800d35 <strncpy+0x34>
		*dst++ = *src;
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8d 50 01             	lea    0x1(%eax),%edx
  800d1c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d22:	8a 12                	mov    (%edx),%dl
  800d24:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	84 c0                	test   %al,%al
  800d2d:	74 03                	je     800d32 <strncpy+0x31>
			src++;
  800d2f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d32:	ff 45 fc             	incl   -0x4(%ebp)
  800d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d38:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d3b:	72 d9                	jb     800d16 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    

00800d42 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d52:	74 30                	je     800d84 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d54:	eb 16                	jmp    800d6c <strlcpy+0x2a>
			*dst++ = *src++;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8d 50 01             	lea    0x1(%eax),%edx
  800d5c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d62:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d65:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d68:	8a 12                	mov    (%edx),%dl
  800d6a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d6c:	ff 4d 10             	decl   0x10(%ebp)
  800d6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d73:	74 09                	je     800d7e <strlcpy+0x3c>
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	75 d8                	jne    800d56 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d84:	8b 55 08             	mov    0x8(%ebp),%edx
  800d87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8a:	29 c2                	sub    %eax,%edx
  800d8c:	89 d0                	mov    %edx,%eax
}
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    

00800d90 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d93:	eb 06                	jmp    800d9b <strcmp+0xb>
		p++, q++;
  800d95:	ff 45 08             	incl   0x8(%ebp)
  800d98:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	84 c0                	test   %al,%al
  800da2:	74 0e                	je     800db2 <strcmp+0x22>
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 10                	mov    (%eax),%dl
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	38 c2                	cmp    %al,%dl
  800db0:	74 e3                	je     800d95 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8a 00                	mov    (%eax),%al
  800db7:	0f b6 d0             	movzbl %al,%edx
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	0f b6 c0             	movzbl %al,%eax
  800dc2:	29 c2                	sub    %eax,%edx
  800dc4:	89 d0                	mov    %edx,%eax
}
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    

00800dc8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dcb:	eb 09                	jmp    800dd6 <strncmp+0xe>
		n--, p++, q++;
  800dcd:	ff 4d 10             	decl   0x10(%ebp)
  800dd0:	ff 45 08             	incl   0x8(%ebp)
  800dd3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dda:	74 17                	je     800df3 <strncmp+0x2b>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	84 c0                	test   %al,%al
  800de3:	74 0e                	je     800df3 <strncmp+0x2b>
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 10                	mov    (%eax),%dl
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	38 c2                	cmp    %al,%dl
  800df1:	74 da                	je     800dcd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800df3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df7:	75 07                	jne    800e00 <strncmp+0x38>
		return 0;
  800df9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfe:	eb 14                	jmp    800e14 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	0f b6 d0             	movzbl %al,%edx
  800e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	0f b6 c0             	movzbl %al,%eax
  800e10:	29 c2                	sub    %eax,%edx
  800e12:	89 d0                	mov    %edx,%eax
}
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    

00800e16 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	83 ec 04             	sub    $0x4,%esp
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e22:	eb 12                	jmp    800e36 <strchr+0x20>
		if (*s == c)
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e2c:	75 05                	jne    800e33 <strchr+0x1d>
			return (char *) s;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	eb 11                	jmp    800e44 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e33:	ff 45 08             	incl   0x8(%ebp)
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	84 c0                	test   %al,%al
  800e3d:	75 e5                	jne    800e24 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e52:	eb 0d                	jmp    800e61 <strfind+0x1b>
		if (*s == c)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5c:	74 0e                	je     800e6c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e5e:	ff 45 08             	incl   0x8(%ebp)
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	75 ea                	jne    800e54 <strfind+0xe>
  800e6a:	eb 01                	jmp    800e6d <strfind+0x27>
		if (*s == c)
			break;
  800e6c:	90                   	nop
	return (char *) s;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e7e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e82:	76 63                	jbe    800ee7 <memset+0x75>
		uint64 data_block = c;
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	99                   	cltd   
  800e88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e94:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e98:	c1 e0 08             	shl    $0x8,%eax
  800e9b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e9e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea7:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eab:	c1 e0 10             	shl    $0x10,%eax
  800eae:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eba:	89 c2                	mov    %eax,%edx
  800ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec4:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ec7:	eb 18                	jmp    800ee1 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ec9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ecc:	8d 41 08             	lea    0x8(%ecx),%eax
  800ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed8:	89 01                	mov    %eax,(%ecx)
  800eda:	89 51 04             	mov    %edx,0x4(%ecx)
  800edd:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ee1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ee5:	77 e2                	ja     800ec9 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ee7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eeb:	74 23                	je     800f10 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef3:	eb 0e                	jmp    800f03 <memset+0x91>
			*p8++ = (uint8)c;
  800ef5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef8:	8d 50 01             	lea    0x1(%eax),%edx
  800efb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800efe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f01:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f03:	8b 45 10             	mov    0x10(%ebp),%eax
  800f06:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f09:	89 55 10             	mov    %edx,0x10(%ebp)
  800f0c:	85 c0                	test   %eax,%eax
  800f0e:	75 e5                	jne    800ef5 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f27:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f2b:	76 24                	jbe    800f51 <memcpy+0x3c>
		while(n >= 8){
  800f2d:	eb 1c                	jmp    800f4b <memcpy+0x36>
			*d64 = *s64;
  800f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f32:	8b 50 04             	mov    0x4(%eax),%edx
  800f35:	8b 00                	mov    (%eax),%eax
  800f37:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f3a:	89 01                	mov    %eax,(%ecx)
  800f3c:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f3f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f43:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f47:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f4b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f4f:	77 de                	ja     800f2f <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f55:	74 31                	je     800f88 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f63:	eb 16                	jmp    800f7b <memcpy+0x66>
			*d8++ = *s8++;
  800f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f71:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f74:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f77:	8a 12                	mov    (%edx),%dl
  800f79:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f81:	89 55 10             	mov    %edx,0x10(%ebp)
  800f84:	85 c0                	test   %eax,%eax
  800f86:	75 dd                	jne    800f65 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8b:	c9                   	leave  
  800f8c:	c3                   	ret    

00800f8d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa5:	73 50                	jae    800ff7 <memmove+0x6a>
  800fa7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800faa:	8b 45 10             	mov    0x10(%ebp),%eax
  800fad:	01 d0                	add    %edx,%eax
  800faf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb2:	76 43                	jbe    800ff7 <memmove+0x6a>
		s += n;
  800fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fba:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fc0:	eb 10                	jmp    800fd2 <memmove+0x45>
			*--d = *--s;
  800fc2:	ff 4d f8             	decl   -0x8(%ebp)
  800fc5:	ff 4d fc             	decl   -0x4(%ebp)
  800fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcb:	8a 10                	mov    (%eax),%dl
  800fcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd8:	89 55 10             	mov    %edx,0x10(%ebp)
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	75 e3                	jne    800fc2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fdf:	eb 23                	jmp    801004 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe4:	8d 50 01             	lea    0x1(%eax),%edx
  800fe7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fed:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ff0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff3:	8a 12                	mov    (%edx),%dl
  800ff5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffd:	89 55 10             	mov    %edx,0x10(%ebp)
  801000:	85 c0                	test   %eax,%eax
  801002:	75 dd                	jne    800fe1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80101b:	eb 2a                	jmp    801047 <memcmp+0x3e>
		if (*s1 != *s2)
  80101d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801020:	8a 10                	mov    (%eax),%dl
  801022:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	38 c2                	cmp    %al,%dl
  801029:	74 16                	je     801041 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80102b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	0f b6 d0             	movzbl %al,%edx
  801033:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	0f b6 c0             	movzbl %al,%eax
  80103b:	29 c2                	sub    %eax,%edx
  80103d:	89 d0                	mov    %edx,%eax
  80103f:	eb 18                	jmp    801059 <memcmp+0x50>
		s1++, s2++;
  801041:	ff 45 fc             	incl   -0x4(%ebp)
  801044:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104d:	89 55 10             	mov    %edx,0x10(%ebp)
  801050:	85 c0                	test   %eax,%eax
  801052:	75 c9                	jne    80101d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801054:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801061:	8b 55 08             	mov    0x8(%ebp),%edx
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	01 d0                	add    %edx,%eax
  801069:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80106c:	eb 15                	jmp    801083 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	0f b6 d0             	movzbl %al,%edx
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	0f b6 c0             	movzbl %al,%eax
  80107c:	39 c2                	cmp    %eax,%edx
  80107e:	74 0d                	je     80108d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801080:	ff 45 08             	incl   0x8(%ebp)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801089:	72 e3                	jb     80106e <memfind+0x13>
  80108b:	eb 01                	jmp    80108e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80108d:	90                   	nop
	return (void *) s;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801091:	c9                   	leave  
  801092:	c3                   	ret    

00801093 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801099:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010a0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a7:	eb 03                	jmp    8010ac <strtol+0x19>
		s++;
  8010a9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 20                	cmp    $0x20,%al
  8010b3:	74 f4                	je     8010a9 <strtol+0x16>
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 09                	cmp    $0x9,%al
  8010bc:	74 eb                	je     8010a9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	3c 2b                	cmp    $0x2b,%al
  8010c5:	75 05                	jne    8010cc <strtol+0x39>
		s++;
  8010c7:	ff 45 08             	incl   0x8(%ebp)
  8010ca:	eb 13                	jmp    8010df <strtol+0x4c>
	else if (*s == '-')
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	3c 2d                	cmp    $0x2d,%al
  8010d3:	75 0a                	jne    8010df <strtol+0x4c>
		s++, neg = 1;
  8010d5:	ff 45 08             	incl   0x8(%ebp)
  8010d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e3:	74 06                	je     8010eb <strtol+0x58>
  8010e5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e9:	75 20                	jne    80110b <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	3c 30                	cmp    $0x30,%al
  8010f2:	75 17                	jne    80110b <strtol+0x78>
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	40                   	inc    %eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 78                	cmp    $0x78,%al
  8010fc:	75 0d                	jne    80110b <strtol+0x78>
		s += 2, base = 16;
  8010fe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801102:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801109:	eb 28                	jmp    801133 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80110b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110f:	75 15                	jne    801126 <strtol+0x93>
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	3c 30                	cmp    $0x30,%al
  801118:	75 0c                	jne    801126 <strtol+0x93>
		s++, base = 8;
  80111a:	ff 45 08             	incl   0x8(%ebp)
  80111d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801124:	eb 0d                	jmp    801133 <strtol+0xa0>
	else if (base == 0)
  801126:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112a:	75 07                	jne    801133 <strtol+0xa0>
		base = 10;
  80112c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 2f                	cmp    $0x2f,%al
  80113a:	7e 19                	jle    801155 <strtol+0xc2>
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	3c 39                	cmp    $0x39,%al
  801143:	7f 10                	jg     801155 <strtol+0xc2>
			dig = *s - '0';
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f be c0             	movsbl %al,%eax
  80114d:	83 e8 30             	sub    $0x30,%eax
  801150:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801153:	eb 42                	jmp    801197 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 60                	cmp    $0x60,%al
  80115c:	7e 19                	jle    801177 <strtol+0xe4>
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	3c 7a                	cmp    $0x7a,%al
  801165:	7f 10                	jg     801177 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	0f be c0             	movsbl %al,%eax
  80116f:	83 e8 57             	sub    $0x57,%eax
  801172:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801175:	eb 20                	jmp    801197 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 40                	cmp    $0x40,%al
  80117e:	7e 39                	jle    8011b9 <strtol+0x126>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	3c 5a                	cmp    $0x5a,%al
  801187:	7f 30                	jg     8011b9 <strtol+0x126>
			dig = *s - 'A' + 10;
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f be c0             	movsbl %al,%eax
  801191:	83 e8 37             	sub    $0x37,%eax
  801194:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119d:	7d 19                	jge    8011b8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80119f:	ff 45 08             	incl   0x8(%ebp)
  8011a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a9:	89 c2                	mov    %eax,%edx
  8011ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ae:	01 d0                	add    %edx,%eax
  8011b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b3:	e9 7b ff ff ff       	jmp    801133 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011b8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011bd:	74 08                	je     8011c7 <strtol+0x134>
		*endptr = (char *) s;
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011cb:	74 07                	je     8011d4 <strtol+0x141>
  8011cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d0:	f7 d8                	neg    %eax
  8011d2:	eb 03                	jmp    8011d7 <strtol+0x144>
  8011d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011e6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f1:	79 13                	jns    801206 <ltostr+0x2d>
	{
		neg = 1;
  8011f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801200:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801203:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80120e:	99                   	cltd   
  80120f:	f7 f9                	idiv   %ecx
  801211:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801214:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801217:	8d 50 01             	lea    0x1(%eax),%edx
  80121a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121d:	89 c2                	mov    %eax,%edx
  80121f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801222:	01 d0                	add    %edx,%eax
  801224:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801227:	83 c2 30             	add    $0x30,%edx
  80122a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80122c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801234:	f7 e9                	imul   %ecx
  801236:	c1 fa 02             	sar    $0x2,%edx
  801239:	89 c8                	mov    %ecx,%eax
  80123b:	c1 f8 1f             	sar    $0x1f,%eax
  80123e:	29 c2                	sub    %eax,%edx
  801240:	89 d0                	mov    %edx,%eax
  801242:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801249:	75 bb                	jne    801206 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80124b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801252:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801255:	48                   	dec    %eax
  801256:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801259:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80125d:	74 3d                	je     80129c <ltostr+0xc3>
		start = 1 ;
  80125f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801266:	eb 34                	jmp    80129c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801268:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801275:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	01 c2                	add    %eax,%edx
  80127d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	01 c8                	add    %ecx,%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801289:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	01 c2                	add    %eax,%edx
  801291:	8a 45 eb             	mov    -0x15(%ebp),%al
  801294:	88 02                	mov    %al,(%edx)
		start++ ;
  801296:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801299:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80129c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a2:	7c c4                	jl     801268 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012a4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	01 d0                	add    %edx,%eax
  8012ac:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012af:	90                   	nop
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012b8:	ff 75 08             	pushl  0x8(%ebp)
  8012bb:	e8 c4 f9 ff ff       	call   800c84 <strlen>
  8012c0:	83 c4 04             	add    $0x4,%esp
  8012c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012c6:	ff 75 0c             	pushl  0xc(%ebp)
  8012c9:	e8 b6 f9 ff ff       	call   800c84 <strlen>
  8012ce:	83 c4 04             	add    $0x4,%esp
  8012d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e2:	eb 17                	jmp    8012fb <strcconcat+0x49>
		final[s] = str1[s] ;
  8012e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ea:	01 c2                	add    %eax,%edx
  8012ec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	01 c8                	add    %ecx,%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012f8:	ff 45 fc             	incl   -0x4(%ebp)
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801301:	7c e1                	jl     8012e4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801303:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80130a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801311:	eb 1f                	jmp    801332 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801316:	8d 50 01             	lea    0x1(%eax),%edx
  801319:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80131c:	89 c2                	mov    %eax,%edx
  80131e:	8b 45 10             	mov    0x10(%ebp),%eax
  801321:	01 c2                	add    %eax,%edx
  801323:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	01 c8                	add    %ecx,%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80132f:	ff 45 f8             	incl   -0x8(%ebp)
  801332:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801335:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801338:	7c d9                	jl     801313 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80133a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80133d:	8b 45 10             	mov    0x10(%ebp),%eax
  801340:	01 d0                	add    %edx,%eax
  801342:	c6 00 00             	movb   $0x0,(%eax)
}
  801345:	90                   	nop
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801354:	8b 45 14             	mov    0x14(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801360:	8b 45 10             	mov    0x10(%ebp),%eax
  801363:	01 d0                	add    %edx,%eax
  801365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136b:	eb 0c                	jmp    801379 <strsplit+0x31>
			*string++ = 0;
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	8d 50 01             	lea    0x1(%eax),%edx
  801373:	89 55 08             	mov    %edx,0x8(%ebp)
  801376:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	84 c0                	test   %al,%al
  801380:	74 18                	je     80139a <strsplit+0x52>
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	0f be c0             	movsbl %al,%eax
  80138a:	50                   	push   %eax
  80138b:	ff 75 0c             	pushl  0xc(%ebp)
  80138e:	e8 83 fa ff ff       	call   800e16 <strchr>
  801393:	83 c4 08             	add    $0x8,%esp
  801396:	85 c0                	test   %eax,%eax
  801398:	75 d3                	jne    80136d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	84 c0                	test   %al,%al
  8013a1:	74 5a                	je     8013fd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a6:	8b 00                	mov    (%eax),%eax
  8013a8:	83 f8 0f             	cmp    $0xf,%eax
  8013ab:	75 07                	jne    8013b4 <strsplit+0x6c>
		{
			return 0;
  8013ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b2:	eb 66                	jmp    80141a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	8b 00                	mov    (%eax),%eax
  8013b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8013bc:	8b 55 14             	mov    0x14(%ebp),%edx
  8013bf:	89 0a                	mov    %ecx,(%edx)
  8013c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cb:	01 c2                	add    %eax,%edx
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013d2:	eb 03                	jmp    8013d7 <strsplit+0x8f>
			string++;
  8013d4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	84 c0                	test   %al,%al
  8013de:	74 8b                	je     80136b <strsplit+0x23>
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	0f be c0             	movsbl %al,%eax
  8013e8:	50                   	push   %eax
  8013e9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ec:	e8 25 fa ff ff       	call   800e16 <strchr>
  8013f1:	83 c4 08             	add    $0x8,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	74 dc                	je     8013d4 <strsplit+0x8c>
			string++;
	}
  8013f8:	e9 6e ff ff ff       	jmp    80136b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013fd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801401:	8b 00                	mov    (%eax),%eax
  801403:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140a:	8b 45 10             	mov    0x10(%ebp),%eax
  80140d:	01 d0                	add    %edx,%eax
  80140f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801415:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801428:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80142f:	eb 4a                	jmp    80147b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801431:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	01 c2                	add    %eax,%edx
  801439:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	01 c8                	add    %ecx,%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801445:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144b:	01 d0                	add    %edx,%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 40                	cmp    $0x40,%al
  801451:	7e 25                	jle    801478 <str2lower+0x5c>
  801453:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801456:	8b 45 0c             	mov    0xc(%ebp),%eax
  801459:	01 d0                	add    %edx,%eax
  80145b:	8a 00                	mov    (%eax),%al
  80145d:	3c 5a                	cmp    $0x5a,%al
  80145f:	7f 17                	jg     801478 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801461:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	01 d0                	add    %edx,%eax
  801469:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80146c:	8b 55 08             	mov    0x8(%ebp),%edx
  80146f:	01 ca                	add    %ecx,%edx
  801471:	8a 12                	mov    (%edx),%dl
  801473:	83 c2 20             	add    $0x20,%edx
  801476:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801478:	ff 45 fc             	incl   -0x4(%ebp)
  80147b:	ff 75 0c             	pushl  0xc(%ebp)
  80147e:	e8 01 f8 ff ff       	call   800c84 <strlen>
  801483:	83 c4 04             	add    $0x4,%esp
  801486:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801489:	7f a6                	jg     801431 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80148b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801496:	a1 08 50 80 00       	mov    0x805008,%eax
  80149b:	85 c0                	test   %eax,%eax
  80149d:	0f 84 95 00 00 00    	je     801538 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8014a3:	83 ec 08             	sub    $0x8,%esp
  8014a6:	68 00 00 00 82       	push   $0x82000000
  8014ab:	68 00 00 00 80       	push   $0x80000000
  8014b0:	e8 59 1f 00 00       	call   80340e <initialize_dynamic_allocator>
  8014b5:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014b8:	e8 93 1d 00 00       	call   803250 <sys_get_uheap_strategy>
  8014bd:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014c2:	a1 40 50 80 00       	mov    0x805040,%eax
  8014c7:	05 00 10 00 00       	add    $0x1000,%eax
  8014cc:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  8014d1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8014d6:	a3 68 d0 81 00       	mov    %eax,0x81d068
		init_uspinlock(&ulock,"malloc",1);
  8014db:	83 ec 04             	sub    $0x4,%esp
  8014de:	6a 01                	push   $0x1
  8014e0:	68 e8 49 80 00       	push   $0x8049e8
  8014e5:	68 40 d1 81 00       	push   $0x81d140
  8014ea:	e8 8d 29 00 00       	call   803e7c <init_uspinlock>
  8014ef:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  8014f2:	c7 05 20 d1 81 00 00 	movl   $0x0,0x81d120
  8014f9:	00 00 00 
  8014fc:	c7 05 24 d1 81 00 00 	movl   $0x0,0x81d124
  801503:	00 00 00 
  801506:	c7 05 2c d1 81 00 00 	movl   $0x0,0x81d12c
  80150d:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801510:	c7 05 30 d1 81 00 00 	movl   $0x0,0x81d130
  801517:	00 00 00 
  80151a:	c7 05 34 d1 81 00 00 	movl   $0x0,0x81d134
  801521:	00 00 00 
  801524:	c7 05 3c d1 81 00 00 	movl   $0x0,0x81d13c
  80152b:	00 00 00 
		__firstTimeFlag = 0;
  80152e:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801535:	00 00 00 
	}
}
  801538:	90                   	nop
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	68 06 04 00 00       	push   $0x406
  801557:	50                   	push   %eax
  801558:	e8 3d 19 00 00       	call   802e9a <__sys_allocate_page>
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801563:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801567:	79 14                	jns    80157d <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801569:	83 ec 04             	sub    $0x4,%esp
  80156c:	68 f0 49 80 00       	push   $0x8049f0
  801571:	6a 2d                	push   $0x2d
  801573:	68 2c 4a 80 00       	push   $0x804a2c
  801578:	e8 07 2a 00 00       	call   803f84 <_panic>
	return 0;
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801598:	83 ec 0c             	sub    $0xc,%esp
  80159b:	50                   	push   %eax
  80159c:	e8 40 19 00 00       	call   802ee1 <__sys_unmap_frame>
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015ab:	79 14                	jns    8015c1 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	68 38 4a 80 00       	push   $0x804a38
  8015b5:	6a 38                	push   $0x38
  8015b7:	68 2c 4a 80 00       	push   $0x804a2c
  8015bc:	e8 c3 29 00 00       	call   803f84 <_panic>
}
  8015c1:	90                   	nop
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015ca:	e8 c1 fe ff ff       	call   801490 <uheap_init>
	if (size == 0) return NULL ;
  8015cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015d3:	75 0a                	jne    8015df <malloc+0x1b>
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015da:	e9 e1 04 00 00       	jmp    801ac0 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  8015df:	83 ec 0c             	sub    $0xc,%esp
  8015e2:	68 40 d1 81 00       	push   $0x81d140
  8015e7:	e8 df 28 00 00       	call   803ecb <acquire_uspinlock>
  8015ec:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  8015ef:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  8015f6:	77 23                	ja     80161b <malloc+0x57>
		release_uspinlock(&ulock);
  8015f8:	83 ec 0c             	sub    $0xc,%esp
  8015fb:	68 40 d1 81 00       	push   $0x81d140
  801600:	e8 1e 29 00 00       	call   803f23 <release_uspinlock>
  801605:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	ff 75 08             	pushl  0x8(%ebp)
  80160e:	e8 dd 1f 00 00       	call   8035f0 <alloc_block>
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	e9 a5 04 00 00       	jmp    801ac0 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80161b:	83 ec 0c             	sub    $0xc,%esp
  80161e:	6a 10                	push   $0x10
  801620:	e8 cb 1f 00 00       	call   8035f0 <alloc_block>
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  80162b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80162f:	75 0a                	jne    80163b <malloc+0x77>
			return NULL;
  801631:	b8 00 00 00 00       	mov    $0x0,%eax
  801636:	e9 85 04 00 00       	jmp    801ac0 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  80163b:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801642:	8b 55 08             	mov    0x8(%ebp),%edx
  801645:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801648:	01 d0                	add    %edx,%eax
  80164a:	48                   	dec    %eax
  80164b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80164e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801651:	ba 00 00 00 00       	mov    $0x0,%edx
  801656:	f7 75 e8             	divl   -0x18(%ebp)
  801659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80165c:	29 d0                	sub    %edx,%eax
  80165e:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801661:	a1 24 d1 81 00       	mov    0x81d124,%eax
  801666:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801669:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80166e:	85 c0                	test   %eax,%eax
  801670:	74 0f                	je     801681 <malloc+0xbd>
  801672:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801675:	8b 40 04             	mov    0x4(%eax),%eax
  801678:	3b 45 08             	cmp    0x8(%ebp),%eax
  80167b:	0f 83 ea 00 00 00    	jae    80176b <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801681:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801686:	2b 45 08             	sub    0x8(%ebp),%eax
  801689:	89 c2                	mov    %eax,%edx
  80168b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801690:	39 c2                	cmp    %eax,%edx
  801692:	0f 86 b9 00 00 00    	jbe    801751 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801698:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80169d:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  8016a0:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	01 d0                	add    %edx,%eax
  8016ab:	a3 68 d0 81 00       	mov    %eax,0x81d068
					allocblock->startva = requestedblockva;
  8016b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016b6:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8016b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016be:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8016c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016c5:	75 14                	jne    8016db <malloc+0x117>
  8016c7:	83 ec 04             	sub    $0x4,%esp
  8016ca:	68 78 4a 80 00       	push   $0x804a78
  8016cf:	6a 60                	push   $0x60
  8016d1:	68 2c 4a 80 00       	push   $0x804a2c
  8016d6:	e8 a9 28 00 00       	call   803f84 <_panic>
  8016db:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8016e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e4:	89 50 0c             	mov    %edx,0xc(%eax)
  8016e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	74 0d                	je     8016fe <malloc+0x13a>
  8016f1:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8016f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016f9:	89 50 08             	mov    %edx,0x8(%eax)
  8016fc:	eb 08                	jmp    801706 <malloc+0x142>
  8016fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801701:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801706:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801709:	a3 34 d1 81 00       	mov    %eax,0x81d134
  80170e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801711:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801718:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80171d:	40                   	inc    %eax
  80171e:	a3 3c d1 81 00       	mov    %eax,0x81d13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801723:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801726:	8b 00                	mov    (%eax),%eax
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	ff 75 08             	pushl  0x8(%ebp)
  80172e:	50                   	push   %eax
  80172f:	e8 34 1c 00 00       	call   803368 <sys_allocate_user_mem>
  801734:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801737:	83 ec 0c             	sub    $0xc,%esp
  80173a:	68 40 d1 81 00       	push   $0x81d140
  80173f:	e8 df 27 00 00       	call   803f23 <release_uspinlock>
  801744:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801747:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174a:	8b 00                	mov    (%eax),%eax
  80174c:	e9 6f 03 00 00       	jmp    801ac0 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801751:	83 ec 0c             	sub    $0xc,%esp
  801754:	68 40 d1 81 00       	push   $0x81d140
  801759:	e8 c5 27 00 00       	call   803f23 <release_uspinlock>
  80175e:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801761:	b8 00 00 00 00       	mov    $0x0,%eax
  801766:	e9 55 03 00 00       	jmp    801ac0 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80176b:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801770:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801773:	e9 39 03 00 00       	jmp    801ab1 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177b:	8b 40 04             	mov    0x4(%eax),%eax
  80177e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801781:	0f 86 e7 01 00 00    	jbe    80196e <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801787:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80178a:	8b 10                	mov    (%eax),%edx
  80178c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178f:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801794:	8b 55 08             	mov    0x8(%ebp),%edx
  801797:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  80179a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80179e:	75 14                	jne    8017b4 <malloc+0x1f0>
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	68 78 4a 80 00       	push   $0x804a78
  8017a8:	6a 72                	push   $0x72
  8017aa:	68 2c 4a 80 00       	push   $0x804a2c
  8017af:	e8 d0 27 00 00       	call   803f84 <_panic>
  8017b4:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bd:	89 50 0c             	mov    %edx,0xc(%eax)
  8017c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	74 0d                	je     8017d7 <malloc+0x213>
  8017ca:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8017cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017d2:	89 50 08             	mov    %edx,0x8(%eax)
  8017d5:	eb 08                	jmp    8017df <malloc+0x21b>
  8017d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017da:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8017df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e2:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8017e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8017f1:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8017f6:	40                   	inc    %eax
  8017f7:	a3 3c d1 81 00       	mov    %eax,0x81d13c
                lastfreeelement->startva += size;
  8017fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017ff:	8b 10                	mov    (%eax),%edx
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	01 c2                	add    %eax,%edx
  801806:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801809:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  80180b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80180e:	8b 40 04             	mov    0x4(%eax),%eax
  801811:	2b 45 08             	sub    0x8(%ebp),%eax
  801814:	89 c2                	mov    %eax,%edx
  801816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801819:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  80181c:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801821:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801824:	e9 0d 01 00 00       	jmp    801936 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  801829:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182c:	8b 50 04             	mov    0x4(%eax),%edx
  80182f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801832:	8b 40 04             	mov    0x4(%eax),%eax
  801835:	39 c2                	cmp    %eax,%edx
  801837:	0f 83 f0 00 00 00    	jae    80192d <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  80183d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801841:	75 14                	jne    801857 <malloc+0x293>
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	68 9b 4a 80 00       	push   $0x804a9b
  80184b:	6a 7a                	push   $0x7a
  80184d:	68 2c 4a 80 00       	push   $0x804a2c
  801852:	e8 2d 27 00 00       	call   803f84 <_panic>
  801857:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80185a:	8b 40 08             	mov    0x8(%eax),%eax
  80185d:	85 c0                	test   %eax,%eax
  80185f:	74 11                	je     801872 <malloc+0x2ae>
  801861:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801864:	8b 40 08             	mov    0x8(%eax),%eax
  801867:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80186a:	8b 52 0c             	mov    0xc(%edx),%edx
  80186d:	89 50 0c             	mov    %edx,0xc(%eax)
  801870:	eb 0b                	jmp    80187d <malloc+0x2b9>
  801872:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801875:	8b 40 0c             	mov    0xc(%eax),%eax
  801878:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80187d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801880:	8b 40 0c             	mov    0xc(%eax),%eax
  801883:	85 c0                	test   %eax,%eax
  801885:	74 11                	je     801898 <malloc+0x2d4>
  801887:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80188a:	8b 40 0c             	mov    0xc(%eax),%eax
  80188d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801890:	8b 52 08             	mov    0x8(%edx),%edx
  801893:	89 50 08             	mov    %edx,0x8(%eax)
  801896:	eb 0b                	jmp    8018a3 <malloc+0x2df>
  801898:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189b:	8b 40 08             	mov    0x8(%eax),%eax
  80189e:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8018a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8018ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8018b7:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8018bc:	48                   	dec    %eax
  8018bd:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8018c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018c6:	74 06                	je     8018ce <malloc+0x30a>
  8018c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018cc:	75 14                	jne    8018e2 <malloc+0x31e>
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	68 bc 4a 80 00       	push   $0x804abc
  8018d6:	6a 7b                	push   $0x7b
  8018d8:	68 2c 4a 80 00       	push   $0x804a2c
  8018dd:	e8 a2 26 00 00       	call   803f84 <_panic>
  8018e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e5:	8b 50 0c             	mov    0xc(%eax),%edx
  8018e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018eb:	89 50 0c             	mov    %edx,0xc(%eax)
  8018ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f4:	89 50 08             	mov    %edx,0x8(%eax)
  8018f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	74 0e                	je     80190f <malloc+0x34b>
  801901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801904:	8b 40 0c             	mov    0xc(%eax),%eax
  801907:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80190a:	89 50 08             	mov    %edx,0x8(%eax)
  80190d:	eb 08                	jmp    801917 <malloc+0x353>
  80190f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801912:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80191d:	89 50 0c             	mov    %edx,0xc(%eax)
  801920:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801925:	40                   	inc    %eax
  801926:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		break;
  80192b:	eb 13                	jmp    801940 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  80192d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801930:	8b 40 08             	mov    0x8(%eax),%eax
  801933:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801936:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80193a:	0f 85 e9 fe ff ff    	jne    801829 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801940:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801943:	8b 00                	mov    (%eax),%eax
  801945:	83 ec 08             	sub    $0x8,%esp
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	50                   	push   %eax
  80194c:	e8 17 1a 00 00       	call   803368 <sys_allocate_user_mem>
  801951:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801954:	83 ec 0c             	sub    $0xc,%esp
  801957:	68 40 d1 81 00       	push   $0x81d140
  80195c:	e8 c2 25 00 00       	call   803f23 <release_uspinlock>
  801961:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801967:	8b 00                	mov    (%eax),%eax
  801969:	e9 52 01 00 00       	jmp    801ac0 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  80196e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801971:	8b 40 04             	mov    0x4(%eax),%eax
  801974:	3b 45 08             	cmp    0x8(%ebp),%eax
  801977:	0f 85 2b 01 00 00    	jne    801aa8 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  80197d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801980:	8b 10                	mov    (%eax),%edx
  801982:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801985:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198a:	8b 55 08             	mov    0x8(%ebp),%edx
  80198d:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801990:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801994:	75 17                	jne    8019ad <malloc+0x3e9>
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	68 78 4a 80 00       	push   $0x804a78
  80199e:	68 89 00 00 00       	push   $0x89
  8019a3:	68 2c 4a 80 00       	push   $0x804a2c
  8019a8:	e8 d7 25 00 00       	call   803f84 <_panic>
  8019ad:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8019b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b6:	89 50 0c             	mov    %edx,0xc(%eax)
  8019b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	74 0d                	je     8019d0 <malloc+0x40c>
  8019c3:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8019c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019cb:	89 50 08             	mov    %edx,0x8(%eax)
  8019ce:	eb 08                	jmp    8019d8 <malloc+0x414>
  8019d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d3:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8019d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019db:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8019e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8019ea:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8019ef:	40                   	inc    %eax
  8019f0:	a3 3c d1 81 00       	mov    %eax,0x81d13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  8019f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019f9:	75 17                	jne    801a12 <malloc+0x44e>
  8019fb:	83 ec 04             	sub    $0x4,%esp
  8019fe:	68 9b 4a 80 00       	push   $0x804a9b
  801a03:	68 8a 00 00 00       	push   $0x8a
  801a08:	68 2c 4a 80 00       	push   $0x804a2c
  801a0d:	e8 72 25 00 00       	call   803f84 <_panic>
  801a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a15:	8b 40 08             	mov    0x8(%eax),%eax
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	74 11                	je     801a2d <malloc+0x469>
  801a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1f:	8b 40 08             	mov    0x8(%eax),%eax
  801a22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a25:	8b 52 0c             	mov    0xc(%edx),%edx
  801a28:	89 50 0c             	mov    %edx,0xc(%eax)
  801a2b:	eb 0b                	jmp    801a38 <malloc+0x474>
  801a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a30:	8b 40 0c             	mov    0xc(%eax),%eax
  801a33:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	74 11                	je     801a53 <malloc+0x48f>
  801a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a45:	8b 40 0c             	mov    0xc(%eax),%eax
  801a48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a4b:	8b 52 08             	mov    0x8(%edx),%edx
  801a4e:	89 50 08             	mov    %edx,0x8(%eax)
  801a51:	eb 0b                	jmp    801a5e <malloc+0x49a>
  801a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a56:	8b 40 08             	mov    0x8(%eax),%eax
  801a59:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a61:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a72:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801a77:	48                   	dec    %eax
  801a78:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 08             	pushl  0x8(%ebp)
  801a88:	50                   	push   %eax
  801a89:	e8 da 18 00 00       	call   803368 <sys_allocate_user_mem>
  801a8e:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801a91:	83 ec 0c             	sub    $0xc,%esp
  801a94:	68 40 d1 81 00       	push   $0x81d140
  801a99:	e8 85 24 00 00       	call   803f23 <release_uspinlock>
  801a9e:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa4:	8b 00                	mov    (%eax),%eax
  801aa6:	eb 18                	jmp    801ac0 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aab:	8b 40 08             	mov    0x8(%eax),%eax
  801aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ab5:	0f 85 bd fc ff ff    	jne    801778 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801abb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ace:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ad1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ad6:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801ad9:	e8 b2 f9 ff ff       	call   801490 <uheap_init>
		acquire_uspinlock(&ulock);
  801ade:	83 ec 0c             	sub    $0xc,%esp
  801ae1:	68 40 d1 81 00       	push   $0x81d140
  801ae6:	e8 e0 23 00 00       	call   803ecb <acquire_uspinlock>
  801aeb:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801aee:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801af3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801af6:	73 23                	jae    801b1b <free+0x59>
			free_block(virtual_address);
  801af8:	83 ec 0c             	sub    $0xc,%esp
  801afb:	ff 75 08             	pushl  0x8(%ebp)
  801afe:	e8 89 1f 00 00       	call   803a8c <free_block>
  801b03:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801b06:	83 ec 0c             	sub    $0xc,%esp
  801b09:	68 40 d1 81 00       	push   $0x81d140
  801b0e:	e8 10 24 00 00       	call   803f23 <release_uspinlock>
  801b13:	83 c4 10             	add    $0x10,%esp
			return;
  801b16:	e9 35 07 00 00       	jmp    802250 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801b1b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b20:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801b23:	72 30                	jb     801b55 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801b25:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	50                   	push   %eax
  801b2e:	ff 75 d8             	pushl  -0x28(%ebp)
  801b31:	68 f1 4a 80 00       	push   $0x804af1
  801b36:	e8 70 ea ff ff       	call   8005ab <cprintf>
  801b3b:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801b3e:	83 ec 04             	sub    $0x4,%esp
  801b41:	68 f9 4a 80 00       	push   $0x804af9
  801b46:	68 a7 00 00 00       	push   $0xa7
  801b4b:	68 2c 4a 80 00       	push   $0x804a2c
  801b50:	e8 2f 24 00 00       	call   803f84 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801b55:	83 ec 0c             	sub    $0xc,%esp
  801b58:	6a 10                	push   $0x10
  801b5a:	e8 91 1a 00 00       	call   8035f0 <alloc_block>
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801b65:	83 ec 0c             	sub    $0xc,%esp
  801b68:	6a 10                	push   $0x10
  801b6a:	e8 81 1a 00 00       	call   8035f0 <alloc_block>
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801b75:	a1 30 d1 81 00       	mov    0x81d130,%eax
  801b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801b7d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801b84:	eb 1c                	jmp    801ba2 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b89:	8b 00                	mov    (%eax),%eax
  801b8b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801b8e:	75 09                	jne    801b99 <free+0xd7>
				foundVA = 1;
  801b90:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801b97:	eb 0f                	jmp    801ba8 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9c:	8b 40 08             	mov    0x8(%eax),%eax
  801b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801ba2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ba6:	75 de                	jne    801b86 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801ba8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bac:	75 17                	jne    801bc5 <free+0x103>
				panic("INVALID ADDRESS!");
  801bae:	83 ec 04             	sub    $0x4,%esp
  801bb1:	68 16 4b 80 00       	push   $0x804b16
  801bb6:	68 be 00 00 00       	push   $0xbe
  801bbb:	68 2c 4a 80 00       	push   $0x804a2c
  801bc0:	e8 bf 23 00 00       	call   803f84 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc8:	8b 10                	mov    (%eax),%edx
  801bca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bcd:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd2:	8b 50 04             	mov    0x4(%eax),%edx
  801bd5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bd8:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bdf:	75 17                	jne    801bf8 <free+0x136>
  801be1:	83 ec 04             	sub    $0x4,%esp
  801be4:	68 9b 4a 80 00       	push   $0x804a9b
  801be9:	68 c8 00 00 00       	push   $0xc8
  801bee:	68 2c 4a 80 00       	push   $0x804a2c
  801bf3:	e8 8c 23 00 00       	call   803f84 <_panic>
  801bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfb:	8b 40 08             	mov    0x8(%eax),%eax
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	74 11                	je     801c13 <free+0x151>
  801c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c05:	8b 40 08             	mov    0x8(%eax),%eax
  801c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c0b:	8b 52 0c             	mov    0xc(%edx),%edx
  801c0e:	89 50 0c             	mov    %edx,0xc(%eax)
  801c11:	eb 0b                	jmp    801c1e <free+0x15c>
  801c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c16:	8b 40 0c             	mov    0xc(%eax),%eax
  801c19:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c21:	8b 40 0c             	mov    0xc(%eax),%eax
  801c24:	85 c0                	test   %eax,%eax
  801c26:	74 11                	je     801c39 <free+0x177>
  801c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c31:	8b 52 08             	mov    0x8(%edx),%edx
  801c34:	89 50 08             	mov    %edx,0x8(%eax)
  801c37:	eb 0b                	jmp    801c44 <free+0x182>
  801c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3c:	8b 40 08             	mov    0x8(%eax),%eax
  801c3f:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c51:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c58:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801c5d:	48                   	dec    %eax
  801c5e:	a3 3c d1 81 00       	mov    %eax,0x81d13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c66:	8b 50 04             	mov    0x4(%eax),%edx
  801c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6c:	8b 00                	mov    (%eax),%eax
  801c6e:	83 ec 08             	sub    $0x8,%esp
  801c71:	52                   	push   %edx
  801c72:	50                   	push   %eax
  801c73:	e8 d4 16 00 00       	call   80334c <sys_free_user_mem>
  801c78:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801c7b:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801c80:	85 c0                	test   %eax,%eax
  801c82:	75 7a                	jne    801cfe <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801c84:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801c88:	75 17                	jne    801ca1 <free+0x1df>
  801c8a:	83 ec 04             	sub    $0x4,%esp
  801c8d:	68 28 4b 80 00       	push   $0x804b28
  801c92:	68 d0 00 00 00       	push   $0xd0
  801c97:	68 2c 4a 80 00       	push   $0x804a2c
  801c9c:	e8 e3 22 00 00       	call   803f84 <_panic>
  801ca1:	8b 15 20 d1 81 00    	mov    0x81d120,%edx
  801ca7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801caa:	89 50 08             	mov    %edx,0x8(%eax)
  801cad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cb0:	8b 40 08             	mov    0x8(%eax),%eax
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	74 0d                	je     801cc4 <free+0x202>
  801cb7:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801cbc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801cbf:	89 50 0c             	mov    %edx,0xc(%eax)
  801cc2:	eb 08                	jmp    801ccc <free+0x20a>
  801cc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cc7:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801ccc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ccf:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801cd4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cd7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801cde:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801ce3:	40                   	inc    %eax
  801ce4:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			release_uspinlock(&ulock);
  801ce9:	83 ec 0c             	sub    $0xc,%esp
  801cec:	68 40 d1 81 00       	push   $0x81d140
  801cf1:	e8 2d 22 00 00       	call   803f23 <release_uspinlock>
  801cf6:	83 c4 10             	add    $0x10,%esp
			return;
  801cf9:	e9 52 05 00 00       	jmp    802250 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801cfe:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801d03:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801d06:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801d0d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801d14:	e9 d2 00 00 00       	jmp    801deb <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d1c:	8b 10                	mov    (%eax),%edx
  801d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d21:	8b 40 04             	mov    0x4(%eax),%eax
  801d24:	01 c2                	add    %eax,%edx
  801d26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d29:	8b 00                	mov    (%eax),%eax
  801d2b:	39 c2                	cmp    %eax,%edx
  801d2d:	0f 85 af 00 00 00    	jne    801de2 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801d33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d36:	8b 10                	mov    (%eax),%edx
  801d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d3b:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d40:	8b 50 04             	mov    0x4(%eax),%edx
  801d43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d46:	8b 40 04             	mov    0x4(%eax),%eax
  801d49:	01 c2                	add    %eax,%edx
  801d4b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d4e:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801d51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d55:	75 17                	jne    801d6e <free+0x2ac>
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	68 9b 4a 80 00       	push   $0x804a9b
  801d5f:	68 df 00 00 00       	push   $0xdf
  801d64:	68 2c 4a 80 00       	push   $0x804a2c
  801d69:	e8 16 22 00 00       	call   803f84 <_panic>
  801d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d71:	8b 40 08             	mov    0x8(%eax),%eax
  801d74:	85 c0                	test   %eax,%eax
  801d76:	74 11                	je     801d89 <free+0x2c7>
  801d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7b:	8b 40 08             	mov    0x8(%eax),%eax
  801d7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d81:	8b 52 0c             	mov    0xc(%edx),%edx
  801d84:	89 50 0c             	mov    %edx,0xc(%eax)
  801d87:	eb 0b                	jmp    801d94 <free+0x2d2>
  801d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8f:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801d94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d97:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9a:	85 c0                	test   %eax,%eax
  801d9c:	74 11                	je     801daf <free+0x2ed>
  801d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da1:	8b 40 0c             	mov    0xc(%eax),%eax
  801da4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801da7:	8b 52 08             	mov    0x8(%edx),%edx
  801daa:	89 50 08             	mov    %edx,0x8(%eax)
  801dad:	eb 0b                	jmp    801dba <free+0x2f8>
  801daf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db2:	8b 40 08             	mov    0x8(%eax),%eax
  801db5:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801dce:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801dd3:	48                   	dec    %eax
  801dd4:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				mergeprev = 1;
  801dd9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801de0:	eb 13                	jmp    801df5 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de5:	8b 40 08             	mov    0x8(%eax),%eax
  801de8:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801deb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801def:	0f 85 24 ff ff ff    	jne    801d19 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801df5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801df8:	8b 10                	mov    (%eax),%edx
  801dfa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dfd:	8b 40 04             	mov    0x4(%eax),%eax
  801e00:	01 c2                	add    %eax,%edx
  801e02:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e07:	39 c2                	cmp    %eax,%edx
  801e09:	75 44                	jne    801e4f <free+0x38d>

			if(mergeprev){
  801e0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e0f:	74 1f                	je     801e30 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801e11:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e14:	8b 00                	mov    (%eax),%eax
  801e16:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801e1b:	83 ec 0c             	sub    $0xc,%esp
  801e1e:	68 40 d1 81 00       	push   $0x81d140
  801e23:	e8 fb 20 00 00       	call   803f23 <release_uspinlock>
  801e28:	83 c4 10             	add    $0x10,%esp
				return;
  801e2b:	e9 20 04 00 00       	jmp    802250 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801e30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e33:	8b 00                	mov    (%eax),%eax
  801e35:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801e3a:	83 ec 0c             	sub    $0xc,%esp
  801e3d:	68 40 d1 81 00       	push   $0x81d140
  801e42:	e8 dc 20 00 00       	call   803f23 <release_uspinlock>
  801e47:	83 c4 10             	add    $0x10,%esp
				return;
  801e4a:	e9 01 04 00 00       	jmp    802250 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  801e4f:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801e54:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  801e57:	e9 7d 01 00 00       	jmp    801fd9 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  801e5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e5f:	8b 10                	mov    (%eax),%edx
  801e61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e64:	8b 40 04             	mov    0x4(%eax),%eax
  801e67:	01 c2                	add    %eax,%edx
  801e69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6c:	8b 00                	mov    (%eax),%eax
  801e6e:	39 c2                	cmp    %eax,%edx
  801e70:	0f 85 5a 01 00 00    	jne    801fd0 <free+0x50e>
				if (mergeprev){
  801e76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e7a:	0f 84 a1 00 00 00    	je     801f21 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  801e80:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e83:	8b 50 04             	mov    0x4(%eax),%edx
  801e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e89:	8b 40 04             	mov    0x4(%eax),%eax
  801e8c:	01 c2                	add    %eax,%edx
  801e8e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e91:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  801e94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e98:	75 17                	jne    801eb1 <free+0x3ef>
  801e9a:	83 ec 04             	sub    $0x4,%esp
  801e9d:	68 9b 4a 80 00       	push   $0x804a9b
  801ea2:	68 0a 01 00 00       	push   $0x10a
  801ea7:	68 2c 4a 80 00       	push   $0x804a2c
  801eac:	e8 d3 20 00 00       	call   803f84 <_panic>
  801eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb4:	8b 40 08             	mov    0x8(%eax),%eax
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	74 11                	je     801ecc <free+0x40a>
  801ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebe:	8b 40 08             	mov    0x8(%eax),%eax
  801ec1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ec4:	8b 52 0c             	mov    0xc(%edx),%edx
  801ec7:	89 50 0c             	mov    %edx,0xc(%eax)
  801eca:	eb 0b                	jmp    801ed7 <free+0x415>
  801ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed2:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eda:	8b 40 0c             	mov    0xc(%eax),%eax
  801edd:	85 c0                	test   %eax,%eax
  801edf:	74 11                	je     801ef2 <free+0x430>
  801ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801eea:	8b 52 08             	mov    0x8(%edx),%edx
  801eed:	89 50 08             	mov    %edx,0x8(%eax)
  801ef0:	eb 0b                	jmp    801efd <free+0x43b>
  801ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef5:	8b 40 08             	mov    0x8(%eax),%eax
  801ef8:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f11:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801f16:	48                   	dec    %eax
  801f17:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					break;
  801f1c:	e9 c2 00 00 00       	jmp    801fe3 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  801f21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f24:	8b 10                	mov    (%eax),%edx
  801f26:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f29:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  801f2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f2e:	8b 50 04             	mov    0x4(%eax),%edx
  801f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f34:	8b 40 04             	mov    0x4(%eax),%eax
  801f37:	01 c2                	add    %eax,%edx
  801f39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f3c:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  801f3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f43:	75 17                	jne    801f5c <free+0x49a>
  801f45:	83 ec 04             	sub    $0x4,%esp
  801f48:	68 9b 4a 80 00       	push   $0x804a9b
  801f4d:	68 10 01 00 00       	push   $0x110
  801f52:	68 2c 4a 80 00       	push   $0x804a2c
  801f57:	e8 28 20 00 00       	call   803f84 <_panic>
  801f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f5f:	8b 40 08             	mov    0x8(%eax),%eax
  801f62:	85 c0                	test   %eax,%eax
  801f64:	74 11                	je     801f77 <free+0x4b5>
  801f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f69:	8b 40 08             	mov    0x8(%eax),%eax
  801f6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f6f:	8b 52 0c             	mov    0xc(%edx),%edx
  801f72:	89 50 0c             	mov    %edx,0xc(%eax)
  801f75:	eb 0b                	jmp    801f82 <free+0x4c0>
  801f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7d:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f85:	8b 40 0c             	mov    0xc(%eax),%eax
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	74 11                	je     801f9d <free+0x4db>
  801f8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f95:	8b 52 08             	mov    0x8(%edx),%edx
  801f98:	89 50 08             	mov    %edx,0x8(%eax)
  801f9b:	eb 0b                	jmp    801fa8 <free+0x4e6>
  801f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa0:	8b 40 08             	mov    0x8(%eax),%eax
  801fa3:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801fbc:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801fc1:	48                   	dec    %eax
  801fc2:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					mergenext = 1;
  801fc7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801fce:	eb 13                	jmp    801fe3 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd3:	8b 40 08             	mov    0x8(%eax),%eax
  801fd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  801fd9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fdd:	0f 85 79 fe ff ff    	jne    801e5c <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  801fe3:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801fe8:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  801feb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fef:	0f 85 ad 00 00 00    	jne    8020a2 <free+0x5e0>
  801ff5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ff9:	0f 84 c3 01 00 00    	je     8021c2 <free+0x700>
				while(currentfree != NULL){
  801fff:	e9 9e 00 00 00       	jmp    8020a2 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  802004:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802007:	8b 50 04             	mov    0x4(%eax),%edx
  80200a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80200d:	8b 40 04             	mov    0x4(%eax),%eax
  802010:	39 c2                	cmp    %eax,%edx
  802012:	0f 83 81 00 00 00    	jae    802099 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  802018:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80201c:	74 06                	je     802024 <free+0x562>
  80201e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802022:	75 17                	jne    80203b <free+0x579>
  802024:	83 ec 04             	sub    $0x4,%esp
  802027:	68 bc 4a 80 00       	push   $0x804abc
  80202c:	68 23 01 00 00       	push   $0x123
  802031:	68 2c 4a 80 00       	push   $0x804a2c
  802036:	e8 49 1f 00 00       	call   803f84 <_panic>
  80203b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80203e:	8b 50 0c             	mov    0xc(%eax),%edx
  802041:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802044:	89 50 0c             	mov    %edx,0xc(%eax)
  802047:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80204a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80204d:	89 50 08             	mov    %edx,0x8(%eax)
  802050:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802053:	8b 40 0c             	mov    0xc(%eax),%eax
  802056:	85 c0                	test   %eax,%eax
  802058:	74 0e                	je     802068 <free+0x5a6>
  80205a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80205d:	8b 40 0c             	mov    0xc(%eax),%eax
  802060:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802063:	89 50 08             	mov    %edx,0x8(%eax)
  802066:	eb 08                	jmp    802070 <free+0x5ae>
  802068:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80206b:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802070:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802073:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802076:	89 50 0c             	mov    %edx,0xc(%eax)
  802079:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80207e:	40                   	inc    %eax
  80207f:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  802084:	83 ec 0c             	sub    $0xc,%esp
  802087:	68 40 d1 81 00       	push   $0x81d140
  80208c:	e8 92 1e 00 00       	call   803f23 <release_uspinlock>
  802091:	83 c4 10             	add    $0x10,%esp
							return;
  802094:	e9 b7 01 00 00       	jmp    802250 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802099:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80209c:	8b 40 08             	mov    0x8(%eax),%eax
  80209f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  8020a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020a6:	0f 85 58 ff ff ff    	jne    802004 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  8020ac:	83 ec 0c             	sub    $0xc,%esp
  8020af:	ff 75 d4             	pushl  -0x2c(%ebp)
  8020b2:	e8 d5 19 00 00       	call   803a8c <free_block>
  8020b7:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8020ba:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8020be:	75 17                	jne    8020d7 <free+0x615>
  8020c0:	83 ec 04             	sub    $0x4,%esp
  8020c3:	68 78 4a 80 00       	push   $0x804a78
  8020c8:	68 2a 01 00 00       	push   $0x12a
  8020cd:	68 2c 4a 80 00       	push   $0x804a2c
  8020d2:	e8 ad 1e 00 00       	call   803f84 <_panic>
  8020d7:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  8020dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020e0:	89 50 0c             	mov    %edx,0xc(%eax)
  8020e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	74 0d                	je     8020fa <free+0x638>
  8020ed:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8020f2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8020f5:	89 50 08             	mov    %edx,0x8(%eax)
  8020f8:	eb 08                	jmp    802102 <free+0x640>
  8020fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020fd:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802102:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802105:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80210a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80210d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802114:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802119:	40                   	inc    %eax
  80211a:	a3 2c d1 81 00       	mov    %eax,0x81d12c
  80211f:	e9 1b 01 00 00       	jmp    80223f <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  802124:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802127:	8b 50 04             	mov    0x4(%eax),%edx
  80212a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80212d:	8b 40 04             	mov    0x4(%eax),%eax
  802130:	39 c2                	cmp    %eax,%edx
  802132:	0f 83 81 00 00 00    	jae    8021b9 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  802138:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80213c:	74 06                	je     802144 <free+0x682>
  80213e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802142:	75 17                	jne    80215b <free+0x699>
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	68 bc 4a 80 00       	push   $0x804abc
  80214c:	68 30 01 00 00       	push   $0x130
  802151:	68 2c 4a 80 00       	push   $0x804a2c
  802156:	e8 29 1e 00 00       	call   803f84 <_panic>
  80215b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80215e:	8b 50 0c             	mov    0xc(%eax),%edx
  802161:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802164:	89 50 0c             	mov    %edx,0xc(%eax)
  802167:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80216a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80216d:	89 50 08             	mov    %edx,0x8(%eax)
  802170:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802173:	8b 40 0c             	mov    0xc(%eax),%eax
  802176:	85 c0                	test   %eax,%eax
  802178:	74 0e                	je     802188 <free+0x6c6>
  80217a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80217d:	8b 40 0c             	mov    0xc(%eax),%eax
  802180:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802183:	89 50 08             	mov    %edx,0x8(%eax)
  802186:	eb 08                	jmp    802190 <free+0x6ce>
  802188:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80218b:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802190:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802193:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802196:	89 50 0c             	mov    %edx,0xc(%eax)
  802199:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80219e:	40                   	inc    %eax
  80219f:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  8021a4:	83 ec 0c             	sub    $0xc,%esp
  8021a7:	68 40 d1 81 00       	push   $0x81d140
  8021ac:	e8 72 1d 00 00       	call   803f23 <release_uspinlock>
  8021b1:	83 c4 10             	add    $0x10,%esp
							return;
  8021b4:	e9 97 00 00 00       	jmp    802250 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8021b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021bc:	8b 40 08             	mov    0x8(%eax),%eax
  8021bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  8021c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021c6:	0f 85 58 ff ff ff    	jne    802124 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8021cc:	83 ec 0c             	sub    $0xc,%esp
  8021cf:	ff 75 d0             	pushl  -0x30(%ebp)
  8021d2:	e8 b5 18 00 00       	call   803a8c <free_block>
  8021d7:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8021da:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8021de:	75 17                	jne    8021f7 <free+0x735>
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	68 78 4a 80 00       	push   $0x804a78
  8021e8:	68 37 01 00 00       	push   $0x137
  8021ed:	68 2c 4a 80 00       	push   $0x804a2c
  8021f2:	e8 8d 1d 00 00       	call   803f84 <_panic>
  8021f7:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  8021fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802200:	89 50 0c             	mov    %edx,0xc(%eax)
  802203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802206:	8b 40 0c             	mov    0xc(%eax),%eax
  802209:	85 c0                	test   %eax,%eax
  80220b:	74 0d                	je     80221a <free+0x758>
  80220d:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802212:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802215:	89 50 08             	mov    %edx,0x8(%eax)
  802218:	eb 08                	jmp    802222 <free+0x760>
  80221a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80221d:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802222:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802225:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80222a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80222d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802234:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802239:	40                   	inc    %eax
  80223a:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			}
		release_uspinlock(&ulock);
  80223f:	83 ec 0c             	sub    $0xc,%esp
  802242:	68 40 d1 81 00       	push   $0x81d140
  802247:	e8 d7 1c 00 00       	call   803f23 <release_uspinlock>
  80224c:	83 c4 10             	add    $0x10,%esp
		return;
  80224f:	90                   	nop
}
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 48             	sub    $0x48,%esp
  802258:	8b 45 10             	mov    0x10(%ebp),%eax
  80225b:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80225e:	e8 2d f2 ff ff       	call   801490 <uheap_init>
	if (size == 0) return NULL;
  802263:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802267:	75 0a                	jne    802273 <smalloc+0x21>
  802269:	b8 00 00 00 00       	mov    $0x0,%eax
  80226e:	e9 84 05 00 00       	jmp    8027f7 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802273:	83 ec 0c             	sub    $0xc,%esp
  802276:	68 40 d1 81 00       	push   $0x81d140
  80227b:	e8 4b 1c 00 00       	call   803ecb <acquire_uspinlock>
  802280:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802283:	83 ec 0c             	sub    $0xc,%esp
  802286:	6a 10                	push   $0x10
  802288:	e8 63 13 00 00       	call   8035f0 <alloc_block>
  80228d:	83 c4 10             	add    $0x10,%esp
  802290:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802293:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802297:	75 0a                	jne    8022a3 <smalloc+0x51>
				return NULL;
  802299:	b8 00 00 00 00       	mov    $0x0,%eax
  80229e:	e9 54 05 00 00       	jmp    8027f7 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  8022a3:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8022aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b0:	01 d0                	add    %edx,%eax
  8022b2:	48                   	dec    %eax
  8022b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8022be:	f7 75 e8             	divl   -0x18(%ebp)
  8022c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022c4:	29 d0                	sub    %edx,%eax
  8022c6:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8022c9:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8022ce:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8022d1:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	74 0f                	je     8022e9 <smalloc+0x97>
  8022da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022dd:	8b 40 04             	mov    0x4(%eax),%eax
  8022e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022e3:	0f 83 25 01 00 00    	jae    80240e <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8022e9:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8022ee:	2b 45 0c             	sub    0xc(%ebp),%eax
  8022f1:	89 c2                	mov    %eax,%edx
  8022f3:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022f8:	39 c2                	cmp    %eax,%edx
  8022fa:	0f 82 f4 00 00 00    	jb     8023f4 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802300:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802305:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  802308:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80230e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802311:	01 d0                	add    %edx,%eax
  802313:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  802318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80231e:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802320:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802323:	8b 55 0c             	mov    0xc(%ebp),%edx
  802326:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802329:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80232d:	75 17                	jne    802346 <smalloc+0xf4>
  80232f:	83 ec 04             	sub    $0x4,%esp
  802332:	68 78 4a 80 00       	push   $0x804a78
  802337:	68 57 01 00 00       	push   $0x157
  80233c:	68 2c 4a 80 00       	push   $0x804a2c
  802341:	e8 3e 1c 00 00       	call   803f84 <_panic>
  802346:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  80234c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234f:	89 50 0c             	mov    %edx,0xc(%eax)
  802352:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802355:	8b 40 0c             	mov    0xc(%eax),%eax
  802358:	85 c0                	test   %eax,%eax
  80235a:	74 0d                	je     802369 <smalloc+0x117>
  80235c:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802364:	89 50 08             	mov    %edx,0x8(%eax)
  802367:	eb 08                	jmp    802371 <smalloc+0x11f>
  802369:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236c:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802371:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802374:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802379:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802383:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802388:	40                   	inc    %eax
  802389:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80238e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802391:	8b 00                	mov    (%eax),%eax
  802393:	89 c2                	mov    %eax,%edx
  802395:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802399:	52                   	push   %edx
  80239a:	50                   	push   %eax
  80239b:	ff 75 0c             	pushl  0xc(%ebp)
  80239e:	ff 75 08             	pushl  0x8(%ebp)
  8023a1:	e8 48 0c 00 00       	call   802fee <sys_create_shared_object>
  8023a6:	83 c4 10             	add    $0x10,%esp
  8023a9:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  8023ac:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8023b0:	79 28                	jns    8023da <smalloc+0x188>
							free_block(allocblock);
  8023b2:	83 ec 0c             	sub    $0xc,%esp
  8023b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8023b8:	e8 cf 16 00 00       	call   803a8c <free_block>
  8023bd:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8023c0:	83 ec 0c             	sub    $0xc,%esp
  8023c3:	68 40 d1 81 00       	push   $0x81d140
  8023c8:	e8 56 1b 00 00       	call   803f23 <release_uspinlock>
  8023cd:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d5:	e9 1d 04 00 00       	jmp    8027f7 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  8023da:	83 ec 0c             	sub    $0xc,%esp
  8023dd:	68 40 d1 81 00       	push   $0x81d140
  8023e2:	e8 3c 1b 00 00       	call   803f23 <release_uspinlock>
  8023e7:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8023ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ed:	8b 00                	mov    (%eax),%eax
  8023ef:	e9 03 04 00 00       	jmp    8027f7 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  8023f4:	83 ec 0c             	sub    $0xc,%esp
  8023f7:	68 40 d1 81 00       	push   $0x81d140
  8023fc:	e8 22 1b 00 00       	call   803f23 <release_uspinlock>
  802401:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802404:	b8 00 00 00 00       	mov    $0x0,%eax
  802409:	e9 e9 03 00 00       	jmp    8027f7 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80240e:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802413:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802416:	e9 af 03 00 00       	jmp    8027ca <smalloc+0x578>
				if(size<currentfreeelement->size){
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802424:	0f 86 28 02 00 00    	jbe    802652 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  80242a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80242d:	8b 10                	mov    (%eax),%edx
  80242f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802432:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  802434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802437:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243a:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  80243d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802441:	75 17                	jne    80245a <smalloc+0x208>
  802443:	83 ec 04             	sub    $0x4,%esp
  802446:	68 78 4a 80 00       	push   $0x804a78
  80244b:	68 6f 01 00 00       	push   $0x16f
  802450:	68 2c 4a 80 00       	push   $0x804a2c
  802455:	e8 2a 1b 00 00       	call   803f84 <_panic>
  80245a:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802460:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802463:	89 50 0c             	mov    %edx,0xc(%eax)
  802466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802469:	8b 40 0c             	mov    0xc(%eax),%eax
  80246c:	85 c0                	test   %eax,%eax
  80246e:	74 0d                	je     80247d <smalloc+0x22b>
  802470:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802475:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802478:	89 50 08             	mov    %edx,0x8(%eax)
  80247b:	eb 08                	jmp    802485 <smalloc+0x233>
  80247d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802480:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802485:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802488:	a3 34 d1 81 00       	mov    %eax,0x81d134
  80248d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802490:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802497:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80249c:	40                   	inc    %eax
  80249d:	a3 3c d1 81 00       	mov    %eax,0x81d13c
	                lastfreeelement->startva += size;
  8024a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a5:	8b 10                	mov    (%eax),%edx
  8024a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024aa:	01 c2                	add    %eax,%edx
  8024ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024af:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  8024b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	2b 45 0c             	sub    0xc(%ebp),%eax
  8024ba:	89 c2                	mov    %eax,%edx
  8024bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024bf:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8024c2:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8024c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  8024ca:	e9 13 01 00 00       	jmp    8025e2 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  8024cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d2:	8b 50 04             	mov    0x4(%eax),%edx
  8024d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d8:	8b 40 04             	mov    0x4(%eax),%eax
  8024db:	39 c2                	cmp    %eax,%edx
  8024dd:	0f 83 f6 00 00 00    	jae    8025d9 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8024e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8024e7:	75 17                	jne    802500 <smalloc+0x2ae>
  8024e9:	83 ec 04             	sub    $0x4,%esp
  8024ec:	68 9b 4a 80 00       	push   $0x804a9b
  8024f1:	68 77 01 00 00       	push   $0x177
  8024f6:	68 2c 4a 80 00       	push   $0x804a2c
  8024fb:	e8 84 1a 00 00       	call   803f84 <_panic>
  802500:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802503:	8b 40 08             	mov    0x8(%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 11                	je     80251b <smalloc+0x2c9>
  80250a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80250d:	8b 40 08             	mov    0x8(%eax),%eax
  802510:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802513:	8b 52 0c             	mov    0xc(%edx),%edx
  802516:	89 50 0c             	mov    %edx,0xc(%eax)
  802519:	eb 0b                	jmp    802526 <smalloc+0x2d4>
  80251b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80251e:	8b 40 0c             	mov    0xc(%eax),%eax
  802521:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802526:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802529:	8b 40 0c             	mov    0xc(%eax),%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	74 11                	je     802541 <smalloc+0x2ef>
  802530:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802533:	8b 40 0c             	mov    0xc(%eax),%eax
  802536:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802539:	8b 52 08             	mov    0x8(%edx),%edx
  80253c:	89 50 08             	mov    %edx,0x8(%eax)
  80253f:	eb 0b                	jmp    80254c <smalloc+0x2fa>
  802541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802544:	8b 40 08             	mov    0x8(%eax),%eax
  802547:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80254c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80254f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802559:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802560:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802565:	48                   	dec    %eax
  802566:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80256b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80256f:	74 06                	je     802577 <smalloc+0x325>
  802571:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802575:	75 17                	jne    80258e <smalloc+0x33c>
  802577:	83 ec 04             	sub    $0x4,%esp
  80257a:	68 bc 4a 80 00       	push   $0x804abc
  80257f:	68 78 01 00 00       	push   $0x178
  802584:	68 2c 4a 80 00       	push   $0x804a2c
  802589:	e8 f6 19 00 00       	call   803f84 <_panic>
  80258e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802591:	8b 50 0c             	mov    0xc(%eax),%edx
  802594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802597:	89 50 0c             	mov    %edx,0xc(%eax)
  80259a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a0:	89 50 08             	mov    %edx,0x8(%eax)
  8025a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	74 0e                	je     8025bb <smalloc+0x369>
  8025ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025b6:	89 50 08             	mov    %edx,0x8(%eax)
  8025b9:	eb 08                	jmp    8025c3 <smalloc+0x371>
  8025bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025be:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8025c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025c9:	89 50 0c             	mov    %edx,0xc(%eax)
  8025cc:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8025d1:	40                   	inc    %eax
  8025d2:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		break;
  8025d7:	eb 13                	jmp    8025ec <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  8025d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025dc:	8b 40 08             	mov    0x8(%eax),%eax
  8025df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  8025e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e6:	0f 85 e3 fe ff ff    	jne    8024cf <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8025ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	89 c2                	mov    %eax,%edx
  8025f3:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8025f7:	52                   	push   %edx
  8025f8:	50                   	push   %eax
  8025f9:	ff 75 0c             	pushl  0xc(%ebp)
  8025fc:	ff 75 08             	pushl  0x8(%ebp)
  8025ff:	e8 ea 09 00 00       	call   802fee <sys_create_shared_object>
  802604:	83 c4 10             	add    $0x10,%esp
  802607:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  80260a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80260e:	79 28                	jns    802638 <smalloc+0x3e6>
	                	free_block(allocblock);
  802610:	83 ec 0c             	sub    $0xc,%esp
  802613:	ff 75 ec             	pushl  -0x14(%ebp)
  802616:	e8 71 14 00 00       	call   803a8c <free_block>
  80261b:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  80261e:	83 ec 0c             	sub    $0xc,%esp
  802621:	68 40 d1 81 00       	push   $0x81d140
  802626:	e8 f8 18 00 00       	call   803f23 <release_uspinlock>
  80262b:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  80262e:	b8 00 00 00 00       	mov    $0x0,%eax
  802633:	e9 bf 01 00 00       	jmp    8027f7 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802638:	83 ec 0c             	sub    $0xc,%esp
  80263b:	68 40 d1 81 00       	push   $0x81d140
  802640:	e8 de 18 00 00       	call   803f23 <release_uspinlock>
  802645:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	e9 a5 01 00 00       	jmp    8027f7 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 40 04             	mov    0x4(%eax),%eax
  802658:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80265b:	0f 85 60 01 00 00    	jne    8027c1 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 10                	mov    (%eax),%edx
  802666:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802669:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80266b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802671:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802674:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802678:	75 17                	jne    802691 <smalloc+0x43f>
  80267a:	83 ec 04             	sub    $0x4,%esp
  80267d:	68 78 4a 80 00       	push   $0x804a78
  802682:	68 8c 01 00 00       	push   $0x18c
  802687:	68 2c 4a 80 00       	push   $0x804a2c
  80268c:	e8 f3 18 00 00       	call   803f84 <_panic>
  802691:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802697:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269a:	89 50 0c             	mov    %edx,0xc(%eax)
  80269d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	74 0d                	je     8026b4 <smalloc+0x462>
  8026a7:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8026ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026af:	89 50 08             	mov    %edx,0x8(%eax)
  8026b2:	eb 08                	jmp    8026bc <smalloc+0x46a>
  8026b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b7:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8026bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bf:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8026c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8026ce:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8026d3:	40                   	inc    %eax
  8026d4:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8026d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dd:	75 17                	jne    8026f6 <smalloc+0x4a4>
  8026df:	83 ec 04             	sub    $0x4,%esp
  8026e2:	68 9b 4a 80 00       	push   $0x804a9b
  8026e7:	68 8d 01 00 00       	push   $0x18d
  8026ec:	68 2c 4a 80 00       	push   $0x804a2c
  8026f1:	e8 8e 18 00 00       	call   803f84 <_panic>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 08             	mov    0x8(%eax),%eax
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	74 11                	je     802711 <smalloc+0x4bf>
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 40 08             	mov    0x8(%eax),%eax
  802706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802709:	8b 52 0c             	mov    0xc(%edx),%edx
  80270c:	89 50 0c             	mov    %edx,0xc(%eax)
  80270f:	eb 0b                	jmp    80271c <smalloc+0x4ca>
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 0c             	mov    0xc(%eax),%eax
  802717:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 40 0c             	mov    0xc(%eax),%eax
  802722:	85 c0                	test   %eax,%eax
  802724:	74 11                	je     802737 <smalloc+0x4e5>
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 40 0c             	mov    0xc(%eax),%eax
  80272c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272f:	8b 52 08             	mov    0x8(%edx),%edx
  802732:	89 50 08             	mov    %edx,0x8(%eax)
  802735:	eb 0b                	jmp    802742 <smalloc+0x4f0>
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 40 08             	mov    0x8(%eax),%eax
  80273d:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802756:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80275b:	48                   	dec    %eax
  80275c:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802761:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	89 c2                	mov    %eax,%edx
  802768:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80276c:	52                   	push   %edx
  80276d:	50                   	push   %eax
  80276e:	ff 75 0c             	pushl  0xc(%ebp)
  802771:	ff 75 08             	pushl  0x8(%ebp)
  802774:	e8 75 08 00 00       	call   802fee <sys_create_shared_object>
  802779:	83 c4 10             	add    $0x10,%esp
  80277c:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  80277f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802783:	79 25                	jns    8027aa <smalloc+0x558>
						free_block(allocblock);
  802785:	83 ec 0c             	sub    $0xc,%esp
  802788:	ff 75 ec             	pushl  -0x14(%ebp)
  80278b:	e8 fc 12 00 00       	call   803a8c <free_block>
  802790:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802793:	83 ec 0c             	sub    $0xc,%esp
  802796:	68 40 d1 81 00       	push   $0x81d140
  80279b:	e8 83 17 00 00       	call   803f23 <release_uspinlock>
  8027a0:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	eb 4d                	jmp    8027f7 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  8027aa:	83 ec 0c             	sub    $0xc,%esp
  8027ad:	68 40 d1 81 00       	push   $0x81d140
  8027b2:	e8 6c 17 00 00       	call   803f23 <release_uspinlock>
  8027b7:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8027ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bd:	8b 00                	mov    (%eax),%eax
  8027bf:	eb 36                	jmp    8027f7 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 08             	mov    0x8(%eax),%eax
  8027c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8027ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ce:	0f 85 47 fc ff ff    	jne    80241b <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8027d4:	83 ec 0c             	sub    $0xc,%esp
  8027d7:	ff 75 ec             	pushl  -0x14(%ebp)
  8027da:	e8 ad 12 00 00       	call   803a8c <free_block>
  8027df:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8027e2:	83 ec 0c             	sub    $0xc,%esp
  8027e5:	68 40 d1 81 00       	push   $0x81d140
  8027ea:	e8 34 17 00 00       	call   803f23 <release_uspinlock>
  8027ef:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8027f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f7:	c9                   	leave  
  8027f8:	c3                   	ret    

008027f9 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8027f9:	55                   	push   %ebp
  8027fa:	89 e5                	mov    %esp,%ebp
  8027fc:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  8027ff:	e8 8c ec ff ff       	call   801490 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802804:	83 ec 0c             	sub    $0xc,%esp
  802807:	68 40 d1 81 00       	push   $0x81d140
  80280c:	e8 ba 16 00 00       	call   803ecb <acquire_uspinlock>
  802811:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802814:	83 ec 08             	sub    $0x8,%esp
  802817:	ff 75 0c             	pushl  0xc(%ebp)
  80281a:	ff 75 08             	pushl  0x8(%ebp)
  80281d:	e8 f6 07 00 00       	call   803018 <sys_size_of_shared_object>
  802822:	83 c4 10             	add    $0x10,%esp
  802825:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  802828:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80282c:	79 1a                	jns    802848 <sget+0x4f>
			release_uspinlock(&ulock);
  80282e:	83 ec 0c             	sub    $0xc,%esp
  802831:	68 40 d1 81 00       	push   $0x81d140
  802836:	e8 e8 16 00 00       	call   803f23 <release_uspinlock>
  80283b:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80283e:	b8 00 00 00 00       	mov    $0x0,%eax
  802843:	e9 6e 05 00 00       	jmp    802db6 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802848:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80284f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802852:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802855:	01 d0                	add    %edx,%eax
  802857:	48                   	dec    %eax
  802858:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80285b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285e:	ba 00 00 00 00       	mov    $0x0,%edx
  802863:	f7 75 e8             	divl   -0x18(%ebp)
  802866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802869:	29 d0                	sub    %edx,%eax
  80286b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80286e:	83 ec 0c             	sub    $0xc,%esp
  802871:	6a 10                	push   $0x10
  802873:	e8 78 0d 00 00       	call   8035f0 <alloc_block>
  802878:	83 c4 10             	add    $0x10,%esp
  80287b:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  80287e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802882:	75 0a                	jne    80288e <sget+0x95>
			return NULL;
  802884:	b8 00 00 00 00       	mov    $0x0,%eax
  802889:	e9 28 05 00 00       	jmp    802db6 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80288e:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802893:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802896:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	74 11                	je     8028b0 <sget+0xb7>
  80289f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028a2:	8b 50 04             	mov    0x4(%eax),%edx
  8028a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a8:	39 c2                	cmp    %eax,%edx
  8028aa:	0f 83 21 01 00 00    	jae    8029d1 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8028b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b3:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  8028b8:	29 c2                	sub    %eax,%edx
  8028ba:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8028bf:	39 c2                	cmp    %eax,%edx
  8028c1:	0f 82 f0 00 00 00    	jb     8029b7 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  8028c7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8028cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  8028cf:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8028d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d8:	01 d0                	add    %edx,%eax
  8028da:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  8028df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028e5:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8028e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ed:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8028f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028f4:	75 17                	jne    80290d <sget+0x114>
  8028f6:	83 ec 04             	sub    $0x4,%esp
  8028f9:	68 78 4a 80 00       	push   $0x804a78
  8028fe:	68 c8 01 00 00       	push   $0x1c8
  802903:	68 2c 4a 80 00       	push   $0x804a2c
  802908:	e8 77 16 00 00       	call   803f84 <_panic>
  80290d:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802916:	89 50 0c             	mov    %edx,0xc(%eax)
  802919:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291c:	8b 40 0c             	mov    0xc(%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 0d                	je     802930 <sget+0x137>
  802923:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802928:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80292b:	89 50 08             	mov    %edx,0x8(%eax)
  80292e:	eb 08                	jmp    802938 <sget+0x13f>
  802930:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802933:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802938:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293b:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802940:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802943:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80294a:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80294f:	40                   	inc    %eax
  802950:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	83 ec 04             	sub    $0x4,%esp
  80295d:	50                   	push   %eax
  80295e:	ff 75 0c             	pushl  0xc(%ebp)
  802961:	ff 75 08             	pushl  0x8(%ebp)
  802964:	e8 cc 06 00 00       	call   803035 <sys_get_shared_object>
  802969:	83 c4 10             	add    $0x10,%esp
  80296c:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  80296f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802973:	79 28                	jns    80299d <sget+0x1a4>
							free_block(allocblock);
  802975:	83 ec 0c             	sub    $0xc,%esp
  802978:	ff 75 e0             	pushl  -0x20(%ebp)
  80297b:	e8 0c 11 00 00       	call   803a8c <free_block>
  802980:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802983:	83 ec 0c             	sub    $0xc,%esp
  802986:	68 40 d1 81 00       	push   $0x81d140
  80298b:	e8 93 15 00 00       	call   803f23 <release_uspinlock>
  802990:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
  802998:	e9 19 04 00 00       	jmp    802db6 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  80299d:	83 ec 0c             	sub    $0xc,%esp
  8029a0:	68 40 d1 81 00       	push   $0x81d140
  8029a5:	e8 79 15 00 00       	call   803f23 <release_uspinlock>
  8029aa:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8029ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	e9 ff 03 00 00       	jmp    802db6 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  8029b7:	83 ec 0c             	sub    $0xc,%esp
  8029ba:	68 40 d1 81 00       	push   $0x81d140
  8029bf:	e8 5f 15 00 00       	call   803f23 <release_uspinlock>
  8029c4:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8029c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029cc:	e9 e5 03 00 00       	jmp    802db6 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8029d1:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8029d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8029d9:	e9 ab 03 00 00       	jmp    802d89 <sget+0x590>
				if(size<currentfreeelement->size){
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 50 04             	mov    0x4(%eax),%edx
  8029e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e7:	39 c2                	cmp    %eax,%edx
  8029e9:	0f 86 24 02 00 00    	jbe    802c13 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  8029ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029f2:	8b 10                	mov    (%eax),%edx
  8029f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029f7:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8029f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ff:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802a02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a06:	75 17                	jne    802a1f <sget+0x226>
  802a08:	83 ec 04             	sub    $0x4,%esp
  802a0b:	68 78 4a 80 00       	push   $0x804a78
  802a10:	68 e0 01 00 00       	push   $0x1e0
  802a15:	68 2c 4a 80 00       	push   $0x804a2c
  802a1a:	e8 65 15 00 00       	call   803f84 <_panic>
  802a1f:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802a25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a28:	89 50 0c             	mov    %edx,0xc(%eax)
  802a2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a31:	85 c0                	test   %eax,%eax
  802a33:	74 0d                	je     802a42 <sget+0x249>
  802a35:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802a3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a3d:	89 50 08             	mov    %edx,0x8(%eax)
  802a40:	eb 08                	jmp    802a4a <sget+0x251>
  802a42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a45:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802a4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a4d:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802a52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a5c:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802a61:	40                   	inc    %eax
  802a62:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					lastfreeelement->startva += size;
  802a67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a6a:	8b 10                	mov    (%eax),%edx
  802a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6f:	01 c2                	add    %eax,%edx
  802a71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a74:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802a76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a79:	8b 50 04             	mov    0x4(%eax),%edx
  802a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7f:	29 c2                	sub    %eax,%edx
  802a81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a84:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802a87:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802a8f:	e9 13 01 00 00       	jmp    802ba7 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802a94:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a97:	8b 50 04             	mov    0x4(%eax),%edx
  802a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9d:	8b 40 04             	mov    0x4(%eax),%eax
  802aa0:	39 c2                	cmp    %eax,%edx
  802aa2:	0f 83 f6 00 00 00    	jae    802b9e <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802aa8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802aac:	75 17                	jne    802ac5 <sget+0x2cc>
  802aae:	83 ec 04             	sub    $0x4,%esp
  802ab1:	68 9b 4a 80 00       	push   $0x804a9b
  802ab6:	68 e8 01 00 00       	push   $0x1e8
  802abb:	68 2c 4a 80 00       	push   $0x804a2c
  802ac0:	e8 bf 14 00 00       	call   803f84 <_panic>
  802ac5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ac8:	8b 40 08             	mov    0x8(%eax),%eax
  802acb:	85 c0                	test   %eax,%eax
  802acd:	74 11                	je     802ae0 <sget+0x2e7>
  802acf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ad2:	8b 40 08             	mov    0x8(%eax),%eax
  802ad5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ad8:	8b 52 0c             	mov    0xc(%edx),%edx
  802adb:	89 50 0c             	mov    %edx,0xc(%eax)
  802ade:	eb 0b                	jmp    802aeb <sget+0x2f2>
  802ae0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ae3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae6:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802aeb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aee:	8b 40 0c             	mov    0xc(%eax),%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	74 11                	je     802b06 <sget+0x30d>
  802af5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802af8:	8b 40 0c             	mov    0xc(%eax),%eax
  802afb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802afe:	8b 52 08             	mov    0x8(%edx),%edx
  802b01:	89 50 08             	mov    %edx,0x8(%eax)
  802b04:	eb 0b                	jmp    802b11 <sget+0x318>
  802b06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b09:	8b 40 08             	mov    0x8(%eax),%eax
  802b0c:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802b11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b1e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b25:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802b2a:	48                   	dec    %eax
  802b2b:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802b30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b34:	74 06                	je     802b3c <sget+0x343>
  802b36:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b3a:	75 17                	jne    802b53 <sget+0x35a>
  802b3c:	83 ec 04             	sub    $0x4,%esp
  802b3f:	68 bc 4a 80 00       	push   $0x804abc
  802b44:	68 e9 01 00 00       	push   $0x1e9
  802b49:	68 2c 4a 80 00       	push   $0x804a2c
  802b4e:	e8 31 14 00 00       	call   803f84 <_panic>
  802b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b56:	8b 50 0c             	mov    0xc(%eax),%edx
  802b59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b5c:	89 50 0c             	mov    %edx,0xc(%eax)
  802b5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b65:	89 50 08             	mov    %edx,0x8(%eax)
  802b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	74 0e                	je     802b80 <sget+0x387>
  802b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b75:	8b 40 0c             	mov    0xc(%eax),%eax
  802b78:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b7b:	89 50 08             	mov    %edx,0x8(%eax)
  802b7e:	eb 08                	jmp    802b88 <sget+0x38f>
  802b80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b83:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b8e:	89 50 0c             	mov    %edx,0xc(%eax)
  802b91:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802b96:	40                   	inc    %eax
  802b97:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							break;
  802b9c:	eb 13                	jmp    802bb1 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba1:	8b 40 08             	mov    0x8(%eax),%eax
  802ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802ba7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bab:	0f 85 e3 fe ff ff    	jne    802a94 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802bb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	83 ec 04             	sub    $0x4,%esp
  802bb9:	50                   	push   %eax
  802bba:	ff 75 0c             	pushl  0xc(%ebp)
  802bbd:	ff 75 08             	pushl  0x8(%ebp)
  802bc0:	e8 70 04 00 00       	call   803035 <sys_get_shared_object>
  802bc5:	83 c4 10             	add    $0x10,%esp
  802bc8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802bcb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802bcf:	79 28                	jns    802bf9 <sget+0x400>
						free_block(allocblock);
  802bd1:	83 ec 0c             	sub    $0xc,%esp
  802bd4:	ff 75 e0             	pushl  -0x20(%ebp)
  802bd7:	e8 b0 0e 00 00       	call   803a8c <free_block>
  802bdc:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802bdf:	83 ec 0c             	sub    $0xc,%esp
  802be2:	68 40 d1 81 00       	push   $0x81d140
  802be7:	e8 37 13 00 00       	call   803f23 <release_uspinlock>
  802bec:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802bef:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf4:	e9 bd 01 00 00       	jmp    802db6 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802bf9:	83 ec 0c             	sub    $0xc,%esp
  802bfc:	68 40 d1 81 00       	push   $0x81d140
  802c01:	e8 1d 13 00 00       	call   803f23 <release_uspinlock>
  802c06:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	e9 a3 01 00 00       	jmp    802db6 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	8b 50 04             	mov    0x4(%eax),%edx
  802c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1c:	39 c2                	cmp    %eax,%edx
  802c1e:	0f 85 5c 01 00 00    	jne    802d80 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 10                	mov    (%eax),%edx
  802c29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c2c:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802c2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c34:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802c37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c3b:	75 17                	jne    802c54 <sget+0x45b>
  802c3d:	83 ec 04             	sub    $0x4,%esp
  802c40:	68 78 4a 80 00       	push   $0x804a78
  802c45:	68 fe 01 00 00       	push   $0x1fe
  802c4a:	68 2c 4a 80 00       	push   $0x804a2c
  802c4f:	e8 30 13 00 00       	call   803f84 <_panic>
  802c54:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5d:	89 50 0c             	mov    %edx,0xc(%eax)
  802c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c63:	8b 40 0c             	mov    0xc(%eax),%eax
  802c66:	85 c0                	test   %eax,%eax
  802c68:	74 0d                	je     802c77 <sget+0x47e>
  802c6a:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802c6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c72:	89 50 08             	mov    %edx,0x8(%eax)
  802c75:	eb 08                	jmp    802c7f <sget+0x486>
  802c77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7a:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802c7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c82:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802c87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c8a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c91:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802c96:	40                   	inc    %eax
  802c97:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802c9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca0:	75 17                	jne    802cb9 <sget+0x4c0>
  802ca2:	83 ec 04             	sub    $0x4,%esp
  802ca5:	68 9b 4a 80 00       	push   $0x804a9b
  802caa:	68 ff 01 00 00       	push   $0x1ff
  802caf:	68 2c 4a 80 00       	push   $0x804a2c
  802cb4:	e8 cb 12 00 00       	call   803f84 <_panic>
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 40 08             	mov    0x8(%eax),%eax
  802cbf:	85 c0                	test   %eax,%eax
  802cc1:	74 11                	je     802cd4 <sget+0x4db>
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	8b 40 08             	mov    0x8(%eax),%eax
  802cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccc:	8b 52 0c             	mov    0xc(%edx),%edx
  802ccf:	89 50 0c             	mov    %edx,0xc(%eax)
  802cd2:	eb 0b                	jmp    802cdf <sget+0x4e6>
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cda:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	74 11                	je     802cfa <sget+0x501>
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 40 0c             	mov    0xc(%eax),%eax
  802cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf2:	8b 52 08             	mov    0x8(%edx),%edx
  802cf5:	89 50 08             	mov    %edx,0x8(%eax)
  802cf8:	eb 0b                	jmp    802d05 <sget+0x50c>
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	8b 40 08             	mov    0x8(%eax),%eax
  802d00:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d19:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802d1e:	48                   	dec    %eax
  802d1f:	a3 2c d1 81 00       	mov    %eax,0x81d12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	83 ec 04             	sub    $0x4,%esp
  802d2c:	50                   	push   %eax
  802d2d:	ff 75 0c             	pushl  0xc(%ebp)
  802d30:	ff 75 08             	pushl  0x8(%ebp)
  802d33:	e8 fd 02 00 00       	call   803035 <sys_get_shared_object>
  802d38:	83 c4 10             	add    $0x10,%esp
  802d3b:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802d3e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802d42:	79 25                	jns    802d69 <sget+0x570>
						free_block(allocblock);
  802d44:	83 ec 0c             	sub    $0xc,%esp
  802d47:	ff 75 e0             	pushl  -0x20(%ebp)
  802d4a:	e8 3d 0d 00 00       	call   803a8c <free_block>
  802d4f:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802d52:	83 ec 0c             	sub    $0xc,%esp
  802d55:	68 40 d1 81 00       	push   $0x81d140
  802d5a:	e8 c4 11 00 00       	call   803f23 <release_uspinlock>
  802d5f:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802d62:	b8 00 00 00 00       	mov    $0x0,%eax
  802d67:	eb 4d                	jmp    802db6 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802d69:	83 ec 0c             	sub    $0xc,%esp
  802d6c:	68 40 d1 81 00       	push   $0x81d140
  802d71:	e8 ad 11 00 00       	call   803f23 <release_uspinlock>
  802d76:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802d79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	eb 36                	jmp    802db6 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 08             	mov    0x8(%eax),%eax
  802d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8d:	0f 85 4b fc ff ff    	jne    8029de <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802d93:	83 ec 0c             	sub    $0xc,%esp
  802d96:	ff 75 e0             	pushl  -0x20(%ebp)
  802d99:	e8 ee 0c 00 00       	call   803a8c <free_block>
  802d9e:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802da1:	83 ec 0c             	sub    $0xc,%esp
  802da4:	68 40 d1 81 00       	push   $0x81d140
  802da9:	e8 75 11 00 00       	call   803f23 <release_uspinlock>
  802dae:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802db1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802db6:	c9                   	leave  
  802db7:	c3                   	ret    

00802db8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802db8:	55                   	push   %ebp
  802db9:	89 e5                	mov    %esp,%ebp
  802dbb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802dbe:	e8 cd e6 ff ff       	call   801490 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802dc3:	83 ec 04             	sub    $0x4,%esp
  802dc6:	68 4c 4b 80 00       	push   $0x804b4c
  802dcb:	68 2d 02 00 00       	push   $0x22d
  802dd0:	68 2c 4a 80 00       	push   $0x804a2c
  802dd5:	e8 aa 11 00 00       	call   803f84 <_panic>

00802dda <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802dda:	55                   	push   %ebp
  802ddb:	89 e5                	mov    %esp,%ebp
  802ddd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802de0:	83 ec 04             	sub    $0x4,%esp
  802de3:	68 74 4b 80 00       	push   $0x804b74
  802de8:	68 40 02 00 00       	push   $0x240
  802ded:	68 2c 4a 80 00       	push   $0x804a2c
  802df2:	e8 8d 11 00 00       	call   803f84 <_panic>

00802df7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802df7:	55                   	push   %ebp
  802df8:	89 e5                	mov    %esp,%ebp
  802dfa:	57                   	push   %edi
  802dfb:	56                   	push   %esi
  802dfc:	53                   	push   %ebx
  802dfd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e06:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e09:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e0c:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e0f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e12:	cd 30                	int    $0x30
  802e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e1a:	83 c4 10             	add    $0x10,%esp
  802e1d:	5b                   	pop    %ebx
  802e1e:	5e                   	pop    %esi
  802e1f:	5f                   	pop    %edi
  802e20:	5d                   	pop    %ebp
  802e21:	c3                   	ret    

00802e22 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802e22:	55                   	push   %ebp
  802e23:	89 e5                	mov    %esp,%ebp
  802e25:	83 ec 04             	sub    $0x4,%esp
  802e28:	8b 45 10             	mov    0x10(%ebp),%eax
  802e2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802e2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e31:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	6a 00                	push   $0x0
  802e3a:	51                   	push   %ecx
  802e3b:	52                   	push   %edx
  802e3c:	ff 75 0c             	pushl  0xc(%ebp)
  802e3f:	50                   	push   %eax
  802e40:	6a 00                	push   $0x0
  802e42:	e8 b0 ff ff ff       	call   802df7 <syscall>
  802e47:	83 c4 18             	add    $0x18,%esp
}
  802e4a:	90                   	nop
  802e4b:	c9                   	leave  
  802e4c:	c3                   	ret    

00802e4d <sys_cgetc>:

int
sys_cgetc(void)
{
  802e4d:	55                   	push   %ebp
  802e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802e50:	6a 00                	push   $0x0
  802e52:	6a 00                	push   $0x0
  802e54:	6a 00                	push   $0x0
  802e56:	6a 00                	push   $0x0
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 02                	push   $0x2
  802e5c:	e8 96 ff ff ff       	call   802df7 <syscall>
  802e61:	83 c4 18             	add    $0x18,%esp
}
  802e64:	c9                   	leave  
  802e65:	c3                   	ret    

00802e66 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802e66:	55                   	push   %ebp
  802e67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802e69:	6a 00                	push   $0x0
  802e6b:	6a 00                	push   $0x0
  802e6d:	6a 00                	push   $0x0
  802e6f:	6a 00                	push   $0x0
  802e71:	6a 00                	push   $0x0
  802e73:	6a 03                	push   $0x3
  802e75:	e8 7d ff ff ff       	call   802df7 <syscall>
  802e7a:	83 c4 18             	add    $0x18,%esp
}
  802e7d:	90                   	nop
  802e7e:	c9                   	leave  
  802e7f:	c3                   	ret    

00802e80 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802e80:	55                   	push   %ebp
  802e81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802e83:	6a 00                	push   $0x0
  802e85:	6a 00                	push   $0x0
  802e87:	6a 00                	push   $0x0
  802e89:	6a 00                	push   $0x0
  802e8b:	6a 00                	push   $0x0
  802e8d:	6a 04                	push   $0x4
  802e8f:	e8 63 ff ff ff       	call   802df7 <syscall>
  802e94:	83 c4 18             	add    $0x18,%esp
}
  802e97:	90                   	nop
  802e98:	c9                   	leave  
  802e99:	c3                   	ret    

00802e9a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802e9a:	55                   	push   %ebp
  802e9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802e9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	6a 00                	push   $0x0
  802ea5:	6a 00                	push   $0x0
  802ea7:	6a 00                	push   $0x0
  802ea9:	52                   	push   %edx
  802eaa:	50                   	push   %eax
  802eab:	6a 08                	push   $0x8
  802ead:	e8 45 ff ff ff       	call   802df7 <syscall>
  802eb2:	83 c4 18             	add    $0x18,%esp
}
  802eb5:	c9                   	leave  
  802eb6:	c3                   	ret    

00802eb7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802eb7:	55                   	push   %ebp
  802eb8:	89 e5                	mov    %esp,%ebp
  802eba:	56                   	push   %esi
  802ebb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802ebc:	8b 75 18             	mov    0x18(%ebp),%esi
  802ebf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ec2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ec5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	56                   	push   %esi
  802ecc:	53                   	push   %ebx
  802ecd:	51                   	push   %ecx
  802ece:	52                   	push   %edx
  802ecf:	50                   	push   %eax
  802ed0:	6a 09                	push   $0x9
  802ed2:	e8 20 ff ff ff       	call   802df7 <syscall>
  802ed7:	83 c4 18             	add    $0x18,%esp
}
  802eda:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802edd:	5b                   	pop    %ebx
  802ede:	5e                   	pop    %esi
  802edf:	5d                   	pop    %ebp
  802ee0:	c3                   	ret    

00802ee1 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802ee1:	55                   	push   %ebp
  802ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802ee4:	6a 00                	push   $0x0
  802ee6:	6a 00                	push   $0x0
  802ee8:	6a 00                	push   $0x0
  802eea:	6a 00                	push   $0x0
  802eec:	ff 75 08             	pushl  0x8(%ebp)
  802eef:	6a 0a                	push   $0xa
  802ef1:	e8 01 ff ff ff       	call   802df7 <syscall>
  802ef6:	83 c4 18             	add    $0x18,%esp
}
  802ef9:	c9                   	leave  
  802efa:	c3                   	ret    

00802efb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802efb:	55                   	push   %ebp
  802efc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802efe:	6a 00                	push   $0x0
  802f00:	6a 00                	push   $0x0
  802f02:	6a 00                	push   $0x0
  802f04:	ff 75 0c             	pushl  0xc(%ebp)
  802f07:	ff 75 08             	pushl  0x8(%ebp)
  802f0a:	6a 0b                	push   $0xb
  802f0c:	e8 e6 fe ff ff       	call   802df7 <syscall>
  802f11:	83 c4 18             	add    $0x18,%esp
}
  802f14:	c9                   	leave  
  802f15:	c3                   	ret    

00802f16 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f16:	55                   	push   %ebp
  802f17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f19:	6a 00                	push   $0x0
  802f1b:	6a 00                	push   $0x0
  802f1d:	6a 00                	push   $0x0
  802f1f:	6a 00                	push   $0x0
  802f21:	6a 00                	push   $0x0
  802f23:	6a 0c                	push   $0xc
  802f25:	e8 cd fe ff ff       	call   802df7 <syscall>
  802f2a:	83 c4 18             	add    $0x18,%esp
}
  802f2d:	c9                   	leave  
  802f2e:	c3                   	ret    

00802f2f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f2f:	55                   	push   %ebp
  802f30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f32:	6a 00                	push   $0x0
  802f34:	6a 00                	push   $0x0
  802f36:	6a 00                	push   $0x0
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 0d                	push   $0xd
  802f3e:	e8 b4 fe ff ff       	call   802df7 <syscall>
  802f43:	83 c4 18             	add    $0x18,%esp
}
  802f46:	c9                   	leave  
  802f47:	c3                   	ret    

00802f48 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802f48:	55                   	push   %ebp
  802f49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802f4b:	6a 00                	push   $0x0
  802f4d:	6a 00                	push   $0x0
  802f4f:	6a 00                	push   $0x0
  802f51:	6a 00                	push   $0x0
  802f53:	6a 00                	push   $0x0
  802f55:	6a 0e                	push   $0xe
  802f57:	e8 9b fe ff ff       	call   802df7 <syscall>
  802f5c:	83 c4 18             	add    $0x18,%esp
}
  802f5f:	c9                   	leave  
  802f60:	c3                   	ret    

00802f61 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802f61:	55                   	push   %ebp
  802f62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802f64:	6a 00                	push   $0x0
  802f66:	6a 00                	push   $0x0
  802f68:	6a 00                	push   $0x0
  802f6a:	6a 00                	push   $0x0
  802f6c:	6a 00                	push   $0x0
  802f6e:	6a 0f                	push   $0xf
  802f70:	e8 82 fe ff ff       	call   802df7 <syscall>
  802f75:	83 c4 18             	add    $0x18,%esp
}
  802f78:	c9                   	leave  
  802f79:	c3                   	ret    

00802f7a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802f7a:	55                   	push   %ebp
  802f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802f7d:	6a 00                	push   $0x0
  802f7f:	6a 00                	push   $0x0
  802f81:	6a 00                	push   $0x0
  802f83:	6a 00                	push   $0x0
  802f85:	ff 75 08             	pushl  0x8(%ebp)
  802f88:	6a 10                	push   $0x10
  802f8a:	e8 68 fe ff ff       	call   802df7 <syscall>
  802f8f:	83 c4 18             	add    $0x18,%esp
}
  802f92:	c9                   	leave  
  802f93:	c3                   	ret    

00802f94 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802f94:	55                   	push   %ebp
  802f95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802f97:	6a 00                	push   $0x0
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	6a 00                	push   $0x0
  802f9f:	6a 00                	push   $0x0
  802fa1:	6a 11                	push   $0x11
  802fa3:	e8 4f fe ff ff       	call   802df7 <syscall>
  802fa8:	83 c4 18             	add    $0x18,%esp
}
  802fab:	90                   	nop
  802fac:	c9                   	leave  
  802fad:	c3                   	ret    

00802fae <sys_cputc>:

void
sys_cputc(const char c)
{
  802fae:	55                   	push   %ebp
  802faf:	89 e5                	mov    %esp,%ebp
  802fb1:	83 ec 04             	sub    $0x4,%esp
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802fba:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802fbe:	6a 00                	push   $0x0
  802fc0:	6a 00                	push   $0x0
  802fc2:	6a 00                	push   $0x0
  802fc4:	6a 00                	push   $0x0
  802fc6:	50                   	push   %eax
  802fc7:	6a 01                	push   $0x1
  802fc9:	e8 29 fe ff ff       	call   802df7 <syscall>
  802fce:	83 c4 18             	add    $0x18,%esp
}
  802fd1:	90                   	nop
  802fd2:	c9                   	leave  
  802fd3:	c3                   	ret    

00802fd4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802fd4:	55                   	push   %ebp
  802fd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802fd7:	6a 00                	push   $0x0
  802fd9:	6a 00                	push   $0x0
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 14                	push   $0x14
  802fe3:	e8 0f fe ff ff       	call   802df7 <syscall>
  802fe8:	83 c4 18             	add    $0x18,%esp
}
  802feb:	90                   	nop
  802fec:	c9                   	leave  
  802fed:	c3                   	ret    

00802fee <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802fee:	55                   	push   %ebp
  802fef:	89 e5                	mov    %esp,%ebp
  802ff1:	83 ec 04             	sub    $0x4,%esp
  802ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  802ff7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802ffa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ffd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	6a 00                	push   $0x0
  803006:	51                   	push   %ecx
  803007:	52                   	push   %edx
  803008:	ff 75 0c             	pushl  0xc(%ebp)
  80300b:	50                   	push   %eax
  80300c:	6a 15                	push   $0x15
  80300e:	e8 e4 fd ff ff       	call   802df7 <syscall>
  803013:	83 c4 18             	add    $0x18,%esp
}
  803016:	c9                   	leave  
  803017:	c3                   	ret    

00803018 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803018:	55                   	push   %ebp
  803019:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80301b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	6a 00                	push   $0x0
  803023:	6a 00                	push   $0x0
  803025:	6a 00                	push   $0x0
  803027:	52                   	push   %edx
  803028:	50                   	push   %eax
  803029:	6a 16                	push   $0x16
  80302b:	e8 c7 fd ff ff       	call   802df7 <syscall>
  803030:	83 c4 18             	add    $0x18,%esp
}
  803033:	c9                   	leave  
  803034:	c3                   	ret    

00803035 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803035:	55                   	push   %ebp
  803036:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803038:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80303b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	6a 00                	push   $0x0
  803043:	6a 00                	push   $0x0
  803045:	51                   	push   %ecx
  803046:	52                   	push   %edx
  803047:	50                   	push   %eax
  803048:	6a 17                	push   $0x17
  80304a:	e8 a8 fd ff ff       	call   802df7 <syscall>
  80304f:	83 c4 18             	add    $0x18,%esp
}
  803052:	c9                   	leave  
  803053:	c3                   	ret    

00803054 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803054:	55                   	push   %ebp
  803055:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803057:	8b 55 0c             	mov    0xc(%ebp),%edx
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	6a 00                	push   $0x0
  80305f:	6a 00                	push   $0x0
  803061:	6a 00                	push   $0x0
  803063:	52                   	push   %edx
  803064:	50                   	push   %eax
  803065:	6a 18                	push   $0x18
  803067:	e8 8b fd ff ff       	call   802df7 <syscall>
  80306c:	83 c4 18             	add    $0x18,%esp
}
  80306f:	c9                   	leave  
  803070:	c3                   	ret    

00803071 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803071:	55                   	push   %ebp
  803072:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	6a 00                	push   $0x0
  803079:	ff 75 14             	pushl  0x14(%ebp)
  80307c:	ff 75 10             	pushl  0x10(%ebp)
  80307f:	ff 75 0c             	pushl  0xc(%ebp)
  803082:	50                   	push   %eax
  803083:	6a 19                	push   $0x19
  803085:	e8 6d fd ff ff       	call   802df7 <syscall>
  80308a:	83 c4 18             	add    $0x18,%esp
}
  80308d:	c9                   	leave  
  80308e:	c3                   	ret    

0080308f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80308f:	55                   	push   %ebp
  803090:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	6a 00                	push   $0x0
  803097:	6a 00                	push   $0x0
  803099:	6a 00                	push   $0x0
  80309b:	6a 00                	push   $0x0
  80309d:	50                   	push   %eax
  80309e:	6a 1a                	push   $0x1a
  8030a0:	e8 52 fd ff ff       	call   802df7 <syscall>
  8030a5:	83 c4 18             	add    $0x18,%esp
}
  8030a8:	90                   	nop
  8030a9:	c9                   	leave  
  8030aa:	c3                   	ret    

008030ab <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8030ab:	55                   	push   %ebp
  8030ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 00                	push   $0x0
  8030b9:	50                   	push   %eax
  8030ba:	6a 1b                	push   $0x1b
  8030bc:	e8 36 fd ff ff       	call   802df7 <syscall>
  8030c1:	83 c4 18             	add    $0x18,%esp
}
  8030c4:	c9                   	leave  
  8030c5:	c3                   	ret    

008030c6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8030c6:	55                   	push   %ebp
  8030c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8030c9:	6a 00                	push   $0x0
  8030cb:	6a 00                	push   $0x0
  8030cd:	6a 00                	push   $0x0
  8030cf:	6a 00                	push   $0x0
  8030d1:	6a 00                	push   $0x0
  8030d3:	6a 05                	push   $0x5
  8030d5:	e8 1d fd ff ff       	call   802df7 <syscall>
  8030da:	83 c4 18             	add    $0x18,%esp
}
  8030dd:	c9                   	leave  
  8030de:	c3                   	ret    

008030df <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8030df:	55                   	push   %ebp
  8030e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8030e2:	6a 00                	push   $0x0
  8030e4:	6a 00                	push   $0x0
  8030e6:	6a 00                	push   $0x0
  8030e8:	6a 00                	push   $0x0
  8030ea:	6a 00                	push   $0x0
  8030ec:	6a 06                	push   $0x6
  8030ee:	e8 04 fd ff ff       	call   802df7 <syscall>
  8030f3:	83 c4 18             	add    $0x18,%esp
}
  8030f6:	c9                   	leave  
  8030f7:	c3                   	ret    

008030f8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8030f8:	55                   	push   %ebp
  8030f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8030fb:	6a 00                	push   $0x0
  8030fd:	6a 00                	push   $0x0
  8030ff:	6a 00                	push   $0x0
  803101:	6a 00                	push   $0x0
  803103:	6a 00                	push   $0x0
  803105:	6a 07                	push   $0x7
  803107:	e8 eb fc ff ff       	call   802df7 <syscall>
  80310c:	83 c4 18             	add    $0x18,%esp
}
  80310f:	c9                   	leave  
  803110:	c3                   	ret    

00803111 <sys_exit_env>:


void sys_exit_env(void)
{
  803111:	55                   	push   %ebp
  803112:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803114:	6a 00                	push   $0x0
  803116:	6a 00                	push   $0x0
  803118:	6a 00                	push   $0x0
  80311a:	6a 00                	push   $0x0
  80311c:	6a 00                	push   $0x0
  80311e:	6a 1c                	push   $0x1c
  803120:	e8 d2 fc ff ff       	call   802df7 <syscall>
  803125:	83 c4 18             	add    $0x18,%esp
}
  803128:	90                   	nop
  803129:	c9                   	leave  
  80312a:	c3                   	ret    

0080312b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80312b:	55                   	push   %ebp
  80312c:	89 e5                	mov    %esp,%ebp
  80312e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803131:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803134:	8d 50 04             	lea    0x4(%eax),%edx
  803137:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80313a:	6a 00                	push   $0x0
  80313c:	6a 00                	push   $0x0
  80313e:	6a 00                	push   $0x0
  803140:	52                   	push   %edx
  803141:	50                   	push   %eax
  803142:	6a 1d                	push   $0x1d
  803144:	e8 ae fc ff ff       	call   802df7 <syscall>
  803149:	83 c4 18             	add    $0x18,%esp
	return result;
  80314c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80314f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803152:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803155:	89 01                	mov    %eax,(%ecx)
  803157:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	c9                   	leave  
  80315e:	c2 04 00             	ret    $0x4

00803161 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803161:	55                   	push   %ebp
  803162:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803164:	6a 00                	push   $0x0
  803166:	6a 00                	push   $0x0
  803168:	ff 75 10             	pushl  0x10(%ebp)
  80316b:	ff 75 0c             	pushl  0xc(%ebp)
  80316e:	ff 75 08             	pushl  0x8(%ebp)
  803171:	6a 13                	push   $0x13
  803173:	e8 7f fc ff ff       	call   802df7 <syscall>
  803178:	83 c4 18             	add    $0x18,%esp
	return ;
  80317b:	90                   	nop
}
  80317c:	c9                   	leave  
  80317d:	c3                   	ret    

0080317e <sys_rcr2>:
uint32 sys_rcr2()
{
  80317e:	55                   	push   %ebp
  80317f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803181:	6a 00                	push   $0x0
  803183:	6a 00                	push   $0x0
  803185:	6a 00                	push   $0x0
  803187:	6a 00                	push   $0x0
  803189:	6a 00                	push   $0x0
  80318b:	6a 1e                	push   $0x1e
  80318d:	e8 65 fc ff ff       	call   802df7 <syscall>
  803192:	83 c4 18             	add    $0x18,%esp
}
  803195:	c9                   	leave  
  803196:	c3                   	ret    

00803197 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803197:	55                   	push   %ebp
  803198:	89 e5                	mov    %esp,%ebp
  80319a:	83 ec 04             	sub    $0x4,%esp
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8031a3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8031a7:	6a 00                	push   $0x0
  8031a9:	6a 00                	push   $0x0
  8031ab:	6a 00                	push   $0x0
  8031ad:	6a 00                	push   $0x0
  8031af:	50                   	push   %eax
  8031b0:	6a 1f                	push   $0x1f
  8031b2:	e8 40 fc ff ff       	call   802df7 <syscall>
  8031b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ba:	90                   	nop
}
  8031bb:	c9                   	leave  
  8031bc:	c3                   	ret    

008031bd <rsttst>:
void rsttst()
{
  8031bd:	55                   	push   %ebp
  8031be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8031c0:	6a 00                	push   $0x0
  8031c2:	6a 00                	push   $0x0
  8031c4:	6a 00                	push   $0x0
  8031c6:	6a 00                	push   $0x0
  8031c8:	6a 00                	push   $0x0
  8031ca:	6a 21                	push   $0x21
  8031cc:	e8 26 fc ff ff       	call   802df7 <syscall>
  8031d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8031d4:	90                   	nop
}
  8031d5:	c9                   	leave  
  8031d6:	c3                   	ret    

008031d7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8031d7:	55                   	push   %ebp
  8031d8:	89 e5                	mov    %esp,%ebp
  8031da:	83 ec 04             	sub    $0x4,%esp
  8031dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8031e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8031e3:	8b 55 18             	mov    0x18(%ebp),%edx
  8031e6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8031ea:	52                   	push   %edx
  8031eb:	50                   	push   %eax
  8031ec:	ff 75 10             	pushl  0x10(%ebp)
  8031ef:	ff 75 0c             	pushl  0xc(%ebp)
  8031f2:	ff 75 08             	pushl  0x8(%ebp)
  8031f5:	6a 20                	push   $0x20
  8031f7:	e8 fb fb ff ff       	call   802df7 <syscall>
  8031fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ff:	90                   	nop
}
  803200:	c9                   	leave  
  803201:	c3                   	ret    

00803202 <chktst>:
void chktst(uint32 n)
{
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803205:	6a 00                	push   $0x0
  803207:	6a 00                	push   $0x0
  803209:	6a 00                	push   $0x0
  80320b:	6a 00                	push   $0x0
  80320d:	ff 75 08             	pushl  0x8(%ebp)
  803210:	6a 22                	push   $0x22
  803212:	e8 e0 fb ff ff       	call   802df7 <syscall>
  803217:	83 c4 18             	add    $0x18,%esp
	return ;
  80321a:	90                   	nop
}
  80321b:	c9                   	leave  
  80321c:	c3                   	ret    

0080321d <inctst>:

void inctst()
{
  80321d:	55                   	push   %ebp
  80321e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803220:	6a 00                	push   $0x0
  803222:	6a 00                	push   $0x0
  803224:	6a 00                	push   $0x0
  803226:	6a 00                	push   $0x0
  803228:	6a 00                	push   $0x0
  80322a:	6a 23                	push   $0x23
  80322c:	e8 c6 fb ff ff       	call   802df7 <syscall>
  803231:	83 c4 18             	add    $0x18,%esp
	return ;
  803234:	90                   	nop
}
  803235:	c9                   	leave  
  803236:	c3                   	ret    

00803237 <gettst>:
uint32 gettst()
{
  803237:	55                   	push   %ebp
  803238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 00                	push   $0x0
  803240:	6a 00                	push   $0x0
  803242:	6a 00                	push   $0x0
  803244:	6a 24                	push   $0x24
  803246:	e8 ac fb ff ff       	call   802df7 <syscall>
  80324b:	83 c4 18             	add    $0x18,%esp
}
  80324e:	c9                   	leave  
  80324f:	c3                   	ret    

00803250 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803250:	55                   	push   %ebp
  803251:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803253:	6a 00                	push   $0x0
  803255:	6a 00                	push   $0x0
  803257:	6a 00                	push   $0x0
  803259:	6a 00                	push   $0x0
  80325b:	6a 00                	push   $0x0
  80325d:	6a 25                	push   $0x25
  80325f:	e8 93 fb ff ff       	call   802df7 <syscall>
  803264:	83 c4 18             	add    $0x18,%esp
  803267:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  80326c:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  803271:	c9                   	leave  
  803272:	c3                   	ret    

00803273 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803273:	55                   	push   %ebp
  803274:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80327e:	6a 00                	push   $0x0
  803280:	6a 00                	push   $0x0
  803282:	6a 00                	push   $0x0
  803284:	6a 00                	push   $0x0
  803286:	ff 75 08             	pushl  0x8(%ebp)
  803289:	6a 26                	push   $0x26
  80328b:	e8 67 fb ff ff       	call   802df7 <syscall>
  803290:	83 c4 18             	add    $0x18,%esp
	return ;
  803293:	90                   	nop
}
  803294:	c9                   	leave  
  803295:	c3                   	ret    

00803296 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803296:	55                   	push   %ebp
  803297:	89 e5                	mov    %esp,%ebp
  803299:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80329a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80329d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	6a 00                	push   $0x0
  8032a8:	53                   	push   %ebx
  8032a9:	51                   	push   %ecx
  8032aa:	52                   	push   %edx
  8032ab:	50                   	push   %eax
  8032ac:	6a 27                	push   $0x27
  8032ae:	e8 44 fb ff ff       	call   802df7 <syscall>
  8032b3:	83 c4 18             	add    $0x18,%esp
}
  8032b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032b9:	c9                   	leave  
  8032ba:	c3                   	ret    

008032bb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8032bb:	55                   	push   %ebp
  8032bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8032be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	6a 00                	push   $0x0
  8032c6:	6a 00                	push   $0x0
  8032c8:	6a 00                	push   $0x0
  8032ca:	52                   	push   %edx
  8032cb:	50                   	push   %eax
  8032cc:	6a 28                	push   $0x28
  8032ce:	e8 24 fb ff ff       	call   802df7 <syscall>
  8032d3:	83 c4 18             	add    $0x18,%esp
}
  8032d6:	c9                   	leave  
  8032d7:	c3                   	ret    

008032d8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8032d8:	55                   	push   %ebp
  8032d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8032db:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8032de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	6a 00                	push   $0x0
  8032e6:	51                   	push   %ecx
  8032e7:	ff 75 10             	pushl  0x10(%ebp)
  8032ea:	52                   	push   %edx
  8032eb:	50                   	push   %eax
  8032ec:	6a 29                	push   $0x29
  8032ee:	e8 04 fb ff ff       	call   802df7 <syscall>
  8032f3:	83 c4 18             	add    $0x18,%esp
}
  8032f6:	c9                   	leave  
  8032f7:	c3                   	ret    

008032f8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8032f8:	55                   	push   %ebp
  8032f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8032fb:	6a 00                	push   $0x0
  8032fd:	6a 00                	push   $0x0
  8032ff:	ff 75 10             	pushl  0x10(%ebp)
  803302:	ff 75 0c             	pushl  0xc(%ebp)
  803305:	ff 75 08             	pushl  0x8(%ebp)
  803308:	6a 12                	push   $0x12
  80330a:	e8 e8 fa ff ff       	call   802df7 <syscall>
  80330f:	83 c4 18             	add    $0x18,%esp
	return ;
  803312:	90                   	nop
}
  803313:	c9                   	leave  
  803314:	c3                   	ret    

00803315 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803315:	55                   	push   %ebp
  803316:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803318:	8b 55 0c             	mov    0xc(%ebp),%edx
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	6a 00                	push   $0x0
  803320:	6a 00                	push   $0x0
  803322:	6a 00                	push   $0x0
  803324:	52                   	push   %edx
  803325:	50                   	push   %eax
  803326:	6a 2a                	push   $0x2a
  803328:	e8 ca fa ff ff       	call   802df7 <syscall>
  80332d:	83 c4 18             	add    $0x18,%esp
	return;
  803330:	90                   	nop
}
  803331:	c9                   	leave  
  803332:	c3                   	ret    

00803333 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803333:	55                   	push   %ebp
  803334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803336:	6a 00                	push   $0x0
  803338:	6a 00                	push   $0x0
  80333a:	6a 00                	push   $0x0
  80333c:	6a 00                	push   $0x0
  80333e:	6a 00                	push   $0x0
  803340:	6a 2b                	push   $0x2b
  803342:	e8 b0 fa ff ff       	call   802df7 <syscall>
  803347:	83 c4 18             	add    $0x18,%esp
}
  80334a:	c9                   	leave  
  80334b:	c3                   	ret    

0080334c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80334c:	55                   	push   %ebp
  80334d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80334f:	6a 00                	push   $0x0
  803351:	6a 00                	push   $0x0
  803353:	6a 00                	push   $0x0
  803355:	ff 75 0c             	pushl  0xc(%ebp)
  803358:	ff 75 08             	pushl  0x8(%ebp)
  80335b:	6a 2d                	push   $0x2d
  80335d:	e8 95 fa ff ff       	call   802df7 <syscall>
  803362:	83 c4 18             	add    $0x18,%esp
	return;
  803365:	90                   	nop
}
  803366:	c9                   	leave  
  803367:	c3                   	ret    

00803368 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803368:	55                   	push   %ebp
  803369:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80336b:	6a 00                	push   $0x0
  80336d:	6a 00                	push   $0x0
  80336f:	6a 00                	push   $0x0
  803371:	ff 75 0c             	pushl  0xc(%ebp)
  803374:	ff 75 08             	pushl  0x8(%ebp)
  803377:	6a 2c                	push   $0x2c
  803379:	e8 79 fa ff ff       	call   802df7 <syscall>
  80337e:	83 c4 18             	add    $0x18,%esp
	return ;
  803381:	90                   	nop
}
  803382:	c9                   	leave  
  803383:	c3                   	ret    

00803384 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803384:	55                   	push   %ebp
  803385:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	6a 00                	push   $0x0
  80338f:	6a 00                	push   $0x0
  803391:	6a 00                	push   $0x0
  803393:	52                   	push   %edx
  803394:	50                   	push   %eax
  803395:	6a 2e                	push   $0x2e
  803397:	e8 5b fa ff ff       	call   802df7 <syscall>
  80339c:	83 c4 18             	add    $0x18,%esp
	    return;
  80339f:	90                   	nop
}
  8033a0:	c9                   	leave  
  8033a1:	c3                   	ret    

008033a2 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8033a2:	55                   	push   %ebp
  8033a3:	89 e5                	mov    %esp,%ebp
  8033a5:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8033a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ab:	ba 60 50 80 00       	mov    $0x805060,%edx
  8033b0:	29 d0                	sub    %edx,%eax
  8033b2:	c1 f8 02             	sar    $0x2,%eax
  8033b5:	89 c2                	mov    %eax,%edx
  8033b7:	89 d0                	mov    %edx,%eax
  8033b9:	c1 e0 02             	shl    $0x2,%eax
  8033bc:	01 d0                	add    %edx,%eax
  8033be:	c1 e0 02             	shl    $0x2,%eax
  8033c1:	01 d0                	add    %edx,%eax
  8033c3:	c1 e0 02             	shl    $0x2,%eax
  8033c6:	01 d0                	add    %edx,%eax
  8033c8:	89 c1                	mov    %eax,%ecx
  8033ca:	c1 e1 08             	shl    $0x8,%ecx
  8033cd:	01 c8                	add    %ecx,%eax
  8033cf:	89 c1                	mov    %eax,%ecx
  8033d1:	c1 e1 10             	shl    $0x10,%ecx
  8033d4:	01 c8                	add    %ecx,%eax
  8033d6:	01 c0                	add    %eax,%eax
  8033d8:	01 d0                	add    %edx,%eax
  8033da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8033dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033e0:	c1 e0 0c             	shl    $0xc,%eax
  8033e3:	89 c2                	mov    %eax,%edx
  8033e5:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8033ea:	01 d0                	add    %edx,%eax
}
  8033ec:	c9                   	leave  
  8033ed:	c3                   	ret    

008033ee <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  8033ee:	55                   	push   %ebp
  8033ef:	89 e5                	mov    %esp,%ebp
  8033f1:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  8033f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8033fb:	eb 06                	jmp    803403 <log2+0x15>
			n >>=1;
  8033fd:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803400:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803403:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803407:	77 f4                	ja     8033fd <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  803409:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80340c:	c9                   	leave  
  80340d:	c3                   	ret    

0080340e <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80340e:	55                   	push   %ebp
  80340f:	89 e5                	mov    %esp,%ebp
  803411:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	05 00 00 00 02       	add    $0x2000000,%eax
  80341c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80341f:	73 16                	jae    803437 <initialize_dynamic_allocator+0x29>
  803421:	68 98 4b 80 00       	push   $0x804b98
  803426:	68 be 4b 80 00       	push   $0x804bbe
  80342b:	6a 2d                	push   $0x2d
  80342d:	68 d3 4b 80 00       	push   $0x804bd3
  803432:	e8 4d 0b 00 00       	call   803f84 <_panic>
		is_initialized = 1;
  803437:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80343e:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd= daEnd;
  803449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344c:	a3 40 50 80 00       	mov    %eax,0x805040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803451:	8b 15 40 50 80 00    	mov    0x805040,%edx
  803457:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80345c:	29 c2                	sub    %eax,%edx
  80345e:	89 d0                	mov    %edx,%eax
  803460:	c1 e8 0c             	shr    $0xc,%eax
  803463:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  803466:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80346d:	eb 2f                	jmp    80349e <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  80346f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803472:	89 d0                	mov    %edx,%eax
  803474:	01 c0                	add    %eax,%eax
  803476:	01 d0                	add    %edx,%eax
  803478:	c1 e0 02             	shl    $0x2,%eax
  80347b:	05 68 50 80 00       	add    $0x805068,%eax
  803480:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803485:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803488:	89 d0                	mov    %edx,%eax
  80348a:	01 c0                	add    %eax,%eax
  80348c:	01 d0                	add    %edx,%eax
  80348e:	c1 e0 02             	shl    $0x2,%eax
  803491:	05 6a 50 80 00       	add    $0x80506a,%eax
  803496:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  80349b:	ff 45 f4             	incl   -0xc(%ebp)
  80349e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034a4:	7c c9                	jl     80346f <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  8034a6:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8034ad:	00 00 00 
  8034b0:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8034b7:	00 00 00 
  8034ba:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8034c1:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  8034c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8034cb:	e9 9c 00 00 00       	jmp    80356c <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8034d0:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8034d6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8034d9:	89 c8                	mov    %ecx,%eax
  8034db:	01 c0                	add    %eax,%eax
  8034dd:	01 c8                	add    %ecx,%eax
  8034df:	c1 e0 02             	shl    $0x2,%eax
  8034e2:	05 64 50 80 00       	add    $0x805064,%eax
  8034e7:	89 10                	mov    %edx,(%eax)
  8034e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ec:	89 d0                	mov    %edx,%eax
  8034ee:	01 c0                	add    %eax,%eax
  8034f0:	01 d0                	add    %edx,%eax
  8034f2:	c1 e0 02             	shl    $0x2,%eax
  8034f5:	05 64 50 80 00       	add    $0x805064,%eax
  8034fa:	8b 00                	mov    (%eax),%eax
  8034fc:	85 c0                	test   %eax,%eax
  8034fe:	74 1b                	je     80351b <initialize_dynamic_allocator+0x10d>
  803500:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803506:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803509:	89 c8                	mov    %ecx,%eax
  80350b:	01 c0                	add    %eax,%eax
  80350d:	01 c8                	add    %ecx,%eax
  80350f:	c1 e0 02             	shl    $0x2,%eax
  803512:	05 60 50 80 00       	add    $0x805060,%eax
  803517:	89 02                	mov    %eax,(%edx)
  803519:	eb 16                	jmp    803531 <initialize_dynamic_allocator+0x123>
  80351b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80351e:	89 d0                	mov    %edx,%eax
  803520:	01 c0                	add    %eax,%eax
  803522:	01 d0                	add    %edx,%eax
  803524:	c1 e0 02             	shl    $0x2,%eax
  803527:	05 60 50 80 00       	add    $0x805060,%eax
  80352c:	a3 48 50 80 00       	mov    %eax,0x805048
  803531:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803534:	89 d0                	mov    %edx,%eax
  803536:	01 c0                	add    %eax,%eax
  803538:	01 d0                	add    %edx,%eax
  80353a:	c1 e0 02             	shl    $0x2,%eax
  80353d:	05 60 50 80 00       	add    $0x805060,%eax
  803542:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803547:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80354a:	89 d0                	mov    %edx,%eax
  80354c:	01 c0                	add    %eax,%eax
  80354e:	01 d0                	add    %edx,%eax
  803550:	c1 e0 02             	shl    $0x2,%eax
  803553:	05 60 50 80 00       	add    $0x805060,%eax
  803558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355e:	a1 54 50 80 00       	mov    0x805054,%eax
  803563:	40                   	inc    %eax
  803564:	a3 54 50 80 00       	mov    %eax,0x805054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803569:	ff 45 f0             	incl   -0x10(%ebp)
  80356c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803572:	0f 8c 58 ff ff ff    	jl     8034d0 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803578:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80357f:	eb 36                	jmp    8035b7 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803581:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803584:	c1 e0 04             	shl    $0x4,%eax
  803587:	05 80 d0 81 00       	add    $0x81d080,%eax
  80358c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803595:	c1 e0 04             	shl    $0x4,%eax
  803598:	05 84 d0 81 00       	add    $0x81d084,%eax
  80359d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a6:	c1 e0 04             	shl    $0x4,%eax
  8035a9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8035ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8035b4:	ff 45 ec             	incl   -0x14(%ebp)
  8035b7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8035bb:	7e c4                	jle    803581 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8035bd:	90                   	nop
  8035be:	c9                   	leave  
  8035bf:	c3                   	ret    

008035c0 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  8035c0:	55                   	push   %ebp
  8035c1:	89 e5                	mov    %esp,%ebp
  8035c3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8035c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c9:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8035ce:	29 c2                	sub    %eax,%edx
  8035d0:	89 d0                	mov    %edx,%eax
  8035d2:	c1 e8 0c             	shr    $0xc,%eax
  8035d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  8035d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8035db:	89 d0                	mov    %edx,%eax
  8035dd:	01 c0                	add    %eax,%eax
  8035df:	01 d0                	add    %edx,%eax
  8035e1:	c1 e0 02             	shl    $0x2,%eax
  8035e4:	05 68 50 80 00       	add    $0x805068,%eax
  8035e9:	8b 00                	mov    (%eax),%eax
  8035eb:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8035ee:	c9                   	leave  
  8035ef:	c3                   	ret    

008035f0 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8035f0:	55                   	push   %ebp
  8035f1:	89 e5                	mov    %esp,%ebp
  8035f3:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8035f6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8035fd:	76 16                	jbe    803615 <alloc_block+0x25>
  8035ff:	68 ec 4b 80 00       	push   $0x804bec
  803604:	68 be 4b 80 00       	push   $0x804bbe
  803609:	6a 6c                	push   $0x6c
  80360b:	68 d3 4b 80 00       	push   $0x804bd3
  803610:	e8 6f 09 00 00       	call   803f84 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  803615:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803619:	75 0a                	jne    803625 <alloc_block+0x35>
		return NULL;
  80361b:	b8 00 00 00 00       	mov    $0x0,%eax
  803620:	e9 65 04 00 00       	jmp    803a8a <alloc_block+0x49a>
	}
	else if(size<=8){
  803625:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803629:	77 09                	ja     803634 <alloc_block+0x44>
		size=8;
  80362b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803632:	eb 1f                	jmp    803653 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803634:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  80363b:	eb 08                	jmp    803645 <alloc_block+0x55>
			reqsize*=2;
  80363d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803640:	01 c0                	add    %eax,%eax
  803642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803648:	3b 45 08             	cmp    0x8(%ebp),%eax
  80364b:	72 f0                	jb     80363d <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  80364d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803650:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803653:	83 ec 0c             	sub    $0xc,%esp
  803656:	ff 75 08             	pushl  0x8(%ebp)
  803659:	e8 90 fd ff ff       	call   8033ee <log2>
  80365e:	83 c4 10             	add    $0x10,%esp
  803661:	83 e8 03             	sub    $0x3,%eax
  803664:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366a:	c1 e0 04             	shl    $0x4,%eax
  80366d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803672:	8b 00                	mov    (%eax),%eax
  803674:	85 c0                	test   %eax,%eax
  803676:	0f 84 fb 00 00 00    	je     803777 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  80367c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367f:	c1 e0 04             	shl    $0x4,%eax
  803682:	05 80 d0 81 00       	add    $0x81d080,%eax
  803687:	8b 00                	mov    (%eax),%eax
  803689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  80368c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803690:	75 17                	jne    8036a9 <alloc_block+0xb9>
  803692:	83 ec 04             	sub    $0x4,%esp
  803695:	68 0d 4c 80 00       	push   $0x804c0d
  80369a:	68 86 00 00 00       	push   $0x86
  80369f:	68 d3 4b 80 00       	push   $0x804bd3
  8036a4:	e8 db 08 00 00       	call   803f84 <_panic>
  8036a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ac:	8b 00                	mov    (%eax),%eax
  8036ae:	85 c0                	test   %eax,%eax
  8036b0:	74 10                	je     8036c2 <alloc_block+0xd2>
  8036b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ba:	8b 52 04             	mov    0x4(%edx),%edx
  8036bd:	89 50 04             	mov    %edx,0x4(%eax)
  8036c0:	eb 14                	jmp    8036d6 <alloc_block+0xe6>
  8036c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c5:	8b 40 04             	mov    0x4(%eax),%eax
  8036c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036cb:	c1 e2 04             	shl    $0x4,%edx
  8036ce:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8036d4:	89 02                	mov    %eax,(%edx)
  8036d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d9:	8b 40 04             	mov    0x4(%eax),%eax
  8036dc:	85 c0                	test   %eax,%eax
  8036de:	74 0f                	je     8036ef <alloc_block+0xff>
  8036e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e3:	8b 40 04             	mov    0x4(%eax),%eax
  8036e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036e9:	8b 12                	mov    (%edx),%edx
  8036eb:	89 10                	mov    %edx,(%eax)
  8036ed:	eb 13                	jmp    803702 <alloc_block+0x112>
  8036ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f2:	8b 00                	mov    (%eax),%eax
  8036f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f7:	c1 e2 04             	shl    $0x4,%edx
  8036fa:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803700:	89 02                	mov    %eax,(%edx)
  803702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803705:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803715:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803718:	c1 e0 04             	shl    $0x4,%eax
  80371b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803720:	8b 00                	mov    (%eax),%eax
  803722:	8d 50 ff             	lea    -0x1(%eax),%edx
  803725:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803728:	c1 e0 04             	shl    $0x4,%eax
  80372b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803730:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803732:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803735:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80373a:	29 c2                	sub    %eax,%edx
  80373c:	89 d0                	mov    %edx,%eax
  80373e:	c1 e8 0c             	shr    $0xc,%eax
  803741:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803744:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803747:	89 d0                	mov    %edx,%eax
  803749:	01 c0                	add    %eax,%eax
  80374b:	01 d0                	add    %edx,%eax
  80374d:	c1 e0 02             	shl    $0x2,%eax
  803750:	05 6a 50 80 00       	add    $0x80506a,%eax
  803755:	66 8b 00             	mov    (%eax),%ax
  803758:	8d 50 ff             	lea    -0x1(%eax),%edx
  80375b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80375e:	89 c8                	mov    %ecx,%eax
  803760:	01 c0                	add    %eax,%eax
  803762:	01 c8                	add    %ecx,%eax
  803764:	c1 e0 02             	shl    $0x2,%eax
  803767:	05 6a 50 80 00       	add    $0x80506a,%eax
  80376c:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  80376f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803772:	e9 13 03 00 00       	jmp    803a8a <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803777:	a1 48 50 80 00       	mov    0x805048,%eax
  80377c:	85 c0                	test   %eax,%eax
  80377e:	0f 84 c9 01 00 00    	je     80394d <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803784:	a1 48 50 80 00       	mov    0x805048,%eax
  803789:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  80378c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803790:	75 17                	jne    8037a9 <alloc_block+0x1b9>
  803792:	83 ec 04             	sub    $0x4,%esp
  803795:	68 0d 4c 80 00       	push   $0x804c0d
  80379a:	68 8f 00 00 00       	push   $0x8f
  80379f:	68 d3 4b 80 00       	push   $0x804bd3
  8037a4:	e8 db 07 00 00       	call   803f84 <_panic>
  8037a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ac:	8b 00                	mov    (%eax),%eax
  8037ae:	85 c0                	test   %eax,%eax
  8037b0:	74 10                	je     8037c2 <alloc_block+0x1d2>
  8037b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037b5:	8b 00                	mov    (%eax),%eax
  8037b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037ba:	8b 52 04             	mov    0x4(%edx),%edx
  8037bd:	89 50 04             	mov    %edx,0x4(%eax)
  8037c0:	eb 0b                	jmp    8037cd <alloc_block+0x1dd>
  8037c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c5:	8b 40 04             	mov    0x4(%eax),%eax
  8037c8:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8037cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d0:	8b 40 04             	mov    0x4(%eax),%eax
  8037d3:	85 c0                	test   %eax,%eax
  8037d5:	74 0f                	je     8037e6 <alloc_block+0x1f6>
  8037d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037da:	8b 40 04             	mov    0x4(%eax),%eax
  8037dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037e0:	8b 12                	mov    (%edx),%edx
  8037e2:	89 10                	mov    %edx,(%eax)
  8037e4:	eb 0a                	jmp    8037f0 <alloc_block+0x200>
  8037e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e9:	8b 00                	mov    (%eax),%eax
  8037eb:	a3 48 50 80 00       	mov    %eax,0x805048
  8037f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803803:	a1 54 50 80 00       	mov    0x805054,%eax
  803808:	48                   	dec    %eax
  803809:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  80380e:	83 ec 0c             	sub    $0xc,%esp
  803811:	ff 75 dc             	pushl  -0x24(%ebp)
  803814:	e8 89 fb ff ff       	call   8033a2 <to_page_va>
  803819:	83 c4 10             	add    $0x10,%esp
  80381c:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  80381f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803824:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803827:	29 c2                	sub    %eax,%edx
  803829:	89 d0                	mov    %edx,%eax
  80382b:	c1 e8 0c             	shr    $0xc,%eax
  80382e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803831:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803834:	83 ec 0c             	sub    $0xc,%esp
  803837:	50                   	push   %eax
  803838:	e8 fe dc ff ff       	call   80153b <get_page>
  80383d:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803840:	8b 45 08             	mov    0x8(%ebp),%eax
  803843:	89 c2                	mov    %eax,%edx
  803845:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803848:	89 c8                	mov    %ecx,%eax
  80384a:	01 c0                	add    %eax,%eax
  80384c:	01 c8                	add    %ecx,%eax
  80384e:	c1 e0 02             	shl    $0x2,%eax
  803851:	05 68 50 80 00       	add    $0x805068,%eax
  803856:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803859:	b8 00 10 00 00       	mov    $0x1000,%eax
  80385e:	ba 00 00 00 00       	mov    $0x0,%edx
  803863:	f7 75 08             	divl   0x8(%ebp)
  803866:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803869:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80386c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80386f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803872:	89 c8                	mov    %ecx,%eax
  803874:	01 c0                	add    %eax,%eax
  803876:	01 c8                	add    %ecx,%eax
  803878:	c1 e0 02             	shl    $0x2,%eax
  80387b:	05 6a 50 80 00       	add    $0x80506a,%eax
  803880:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803883:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  80388a:	e9 aa 00 00 00       	jmp    803939 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  80388f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803892:	0f af 45 08          	imul   0x8(%ebp),%eax
  803896:	89 c2                	mov    %eax,%edx
  803898:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80389b:	01 d0                	add    %edx,%eax
  80389d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  8038a0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8038a4:	75 17                	jne    8038bd <alloc_block+0x2cd>
  8038a6:	83 ec 04             	sub    $0x4,%esp
  8038a9:	68 2c 4c 80 00       	push   $0x804c2c
  8038ae:	68 9d 00 00 00       	push   $0x9d
  8038b3:	68 d3 4b 80 00       	push   $0x804bd3
  8038b8:	e8 c7 06 00 00       	call   803f84 <_panic>
  8038bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c0:	c1 e0 04             	shl    $0x4,%eax
  8038c3:	05 84 d0 81 00       	add    $0x81d084,%eax
  8038c8:	8b 10                	mov    (%eax),%edx
  8038ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038cd:	89 50 04             	mov    %edx,0x4(%eax)
  8038d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038d3:	8b 40 04             	mov    0x4(%eax),%eax
  8038d6:	85 c0                	test   %eax,%eax
  8038d8:	74 14                	je     8038ee <alloc_block+0x2fe>
  8038da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038dd:	c1 e0 04             	shl    $0x4,%eax
  8038e0:	05 84 d0 81 00       	add    $0x81d084,%eax
  8038e5:	8b 00                	mov    (%eax),%eax
  8038e7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038ea:	89 10                	mov    %edx,(%eax)
  8038ec:	eb 11                	jmp    8038ff <alloc_block+0x30f>
  8038ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f1:	c1 e0 04             	shl    $0x4,%eax
  8038f4:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8038fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038fd:	89 02                	mov    %eax,(%edx)
  8038ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803902:	c1 e0 04             	shl    $0x4,%eax
  803905:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80390b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80390e:	89 02                	mov    %eax,(%edx)
  803910:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803913:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803919:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391c:	c1 e0 04             	shl    $0x4,%eax
  80391f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803924:	8b 00                	mov    (%eax),%eax
  803926:	8d 50 01             	lea    0x1(%eax),%edx
  803929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392c:	c1 e0 04             	shl    $0x4,%eax
  80392f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803934:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803936:	ff 45 f0             	incl   -0x10(%ebp)
  803939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80393f:	0f 8c 4a ff ff ff    	jl     80388f <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803945:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803948:	e9 3d 01 00 00       	jmp    803a8a <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  80394d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803950:	40                   	inc    %eax
  803951:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803954:	e9 10 01 00 00       	jmp    803a69 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803959:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80395c:	c1 e0 04             	shl    $0x4,%eax
  80395f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803964:	8b 00                	mov    (%eax),%eax
  803966:	85 c0                	test   %eax,%eax
  803968:	0f 84 f8 00 00 00    	je     803a66 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  80396e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803971:	c1 e0 04             	shl    $0x4,%eax
  803974:	05 80 d0 81 00       	add    $0x81d080,%eax
  803979:	8b 00                	mov    (%eax),%eax
  80397b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  80397e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803982:	75 17                	jne    80399b <alloc_block+0x3ab>
  803984:	83 ec 04             	sub    $0x4,%esp
  803987:	68 0d 4c 80 00       	push   $0x804c0d
  80398c:	68 a8 00 00 00       	push   $0xa8
  803991:	68 d3 4b 80 00       	push   $0x804bd3
  803996:	e8 e9 05 00 00       	call   803f84 <_panic>
  80399b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80399e:	8b 00                	mov    (%eax),%eax
  8039a0:	85 c0                	test   %eax,%eax
  8039a2:	74 10                	je     8039b4 <alloc_block+0x3c4>
  8039a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039a7:	8b 00                	mov    (%eax),%eax
  8039a9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039ac:	8b 52 04             	mov    0x4(%edx),%edx
  8039af:	89 50 04             	mov    %edx,0x4(%eax)
  8039b2:	eb 14                	jmp    8039c8 <alloc_block+0x3d8>
  8039b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039b7:	8b 40 04             	mov    0x4(%eax),%eax
  8039ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039bd:	c1 e2 04             	shl    $0x4,%edx
  8039c0:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8039c6:	89 02                	mov    %eax,(%edx)
  8039c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039cb:	8b 40 04             	mov    0x4(%eax),%eax
  8039ce:	85 c0                	test   %eax,%eax
  8039d0:	74 0f                	je     8039e1 <alloc_block+0x3f1>
  8039d2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039d5:	8b 40 04             	mov    0x4(%eax),%eax
  8039d8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039db:	8b 12                	mov    (%edx),%edx
  8039dd:	89 10                	mov    %edx,(%eax)
  8039df:	eb 13                	jmp    8039f4 <alloc_block+0x404>
  8039e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039e4:	8b 00                	mov    (%eax),%eax
  8039e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039e9:	c1 e2 04             	shl    $0x4,%edx
  8039ec:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8039f2:	89 02                	mov    %eax,(%edx)
  8039f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a0a:	c1 e0 04             	shl    $0x4,%eax
  803a0d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a12:	8b 00                	mov    (%eax),%eax
  803a14:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a1a:	c1 e0 04             	shl    $0x4,%eax
  803a1d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a22:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803a24:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a27:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803a2c:	29 c2                	sub    %eax,%edx
  803a2e:	89 d0                	mov    %edx,%eax
  803a30:	c1 e8 0c             	shr    $0xc,%eax
  803a33:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803a36:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803a39:	89 d0                	mov    %edx,%eax
  803a3b:	01 c0                	add    %eax,%eax
  803a3d:	01 d0                	add    %edx,%eax
  803a3f:	c1 e0 02             	shl    $0x2,%eax
  803a42:	05 6a 50 80 00       	add    $0x80506a,%eax
  803a47:	66 8b 00             	mov    (%eax),%ax
  803a4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a4d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803a50:	89 c8                	mov    %ecx,%eax
  803a52:	01 c0                	add    %eax,%eax
  803a54:	01 c8                	add    %ecx,%eax
  803a56:	c1 e0 02             	shl    $0x2,%eax
  803a59:	05 6a 50 80 00       	add    $0x80506a,%eax
  803a5e:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803a61:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a64:	eb 24                	jmp    803a8a <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803a66:	ff 45 ec             	incl   -0x14(%ebp)
  803a69:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803a6d:	0f 8e e6 fe ff ff    	jle    803959 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803a73:	83 ec 04             	sub    $0x4,%esp
  803a76:	68 4f 4c 80 00       	push   $0x804c4f
  803a7b:	68 b1 00 00 00       	push   $0xb1
  803a80:	68 d3 4b 80 00       	push   $0x804bd3
  803a85:	e8 fa 04 00 00       	call   803f84 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803a8a:	c9                   	leave  
  803a8b:	c3                   	ret    

00803a8c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803a8c:	55                   	push   %ebp
  803a8d:	89 e5                	mov    %esp,%ebp
  803a8f:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803a92:	8b 55 08             	mov    0x8(%ebp),%edx
  803a95:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803a9a:	39 c2                	cmp    %eax,%edx
  803a9c:	72 0c                	jb     803aaa <free_block+0x1e>
  803a9e:	8b 55 08             	mov    0x8(%ebp),%edx
  803aa1:	a1 40 50 80 00       	mov    0x805040,%eax
  803aa6:	39 c2                	cmp    %eax,%edx
  803aa8:	72 19                	jb     803ac3 <free_block+0x37>
  803aaa:	68 6c 4c 80 00       	push   $0x804c6c
  803aaf:	68 be 4b 80 00       	push   $0x804bbe
  803ab4:	68 c3 00 00 00       	push   $0xc3
  803ab9:	68 d3 4b 80 00       	push   $0x804bd3
  803abe:	e8 c1 04 00 00       	call   803f84 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  803ac6:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803acb:	29 c2                	sub    %eax,%edx
  803acd:	89 d0                	mov    %edx,%eax
  803acf:	c1 e8 0c             	shr    $0xc,%eax
  803ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803ad5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ad8:	89 d0                	mov    %edx,%eax
  803ada:	01 c0                	add    %eax,%eax
  803adc:	01 d0                	add    %edx,%eax
  803ade:	c1 e0 02             	shl    $0x2,%eax
  803ae1:	05 68 50 80 00       	add    $0x805068,%eax
  803ae6:	8b 00                	mov    (%eax),%eax
  803ae8:	0f b7 c0             	movzwl %ax,%eax
  803aeb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803aee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803af2:	75 17                	jne    803b0b <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803af4:	83 ec 04             	sub    $0x4,%esp
  803af7:	68 a4 4c 80 00       	push   $0x804ca4
  803afc:	68 cf 00 00 00       	push   $0xcf
  803b01:	68 d3 4b 80 00       	push   $0x804bd3
  803b06:	e8 79 04 00 00       	call   803f84 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803b0b:	83 ec 0c             	sub    $0xc,%esp
  803b0e:	ff 75 ec             	pushl  -0x14(%ebp)
  803b11:	e8 d8 f8 ff ff       	call   8033ee <log2>
  803b16:	83 c4 10             	add    $0x10,%esp
  803b19:	83 e8 03             	sub    $0x3,%eax
  803b1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803b25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b29:	75 17                	jne    803b42 <free_block+0xb6>
  803b2b:	83 ec 04             	sub    $0x4,%esp
  803b2e:	68 2c 4c 80 00       	push   $0x804c2c
  803b33:	68 d5 00 00 00       	push   $0xd5
  803b38:	68 d3 4b 80 00       	push   $0x804bd3
  803b3d:	e8 42 04 00 00       	call   803f84 <_panic>
  803b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b45:	c1 e0 04             	shl    $0x4,%eax
  803b48:	05 84 d0 81 00       	add    $0x81d084,%eax
  803b4d:	8b 10                	mov    (%eax),%edx
  803b4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b52:	89 50 04             	mov    %edx,0x4(%eax)
  803b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b58:	8b 40 04             	mov    0x4(%eax),%eax
  803b5b:	85 c0                	test   %eax,%eax
  803b5d:	74 14                	je     803b73 <free_block+0xe7>
  803b5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b62:	c1 e0 04             	shl    $0x4,%eax
  803b65:	05 84 d0 81 00       	add    $0x81d084,%eax
  803b6a:	8b 00                	mov    (%eax),%eax
  803b6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b6f:	89 10                	mov    %edx,(%eax)
  803b71:	eb 11                	jmp    803b84 <free_block+0xf8>
  803b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b76:	c1 e0 04             	shl    $0x4,%eax
  803b79:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803b7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b82:	89 02                	mov    %eax,(%edx)
  803b84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b87:	c1 e0 04             	shl    $0x4,%eax
  803b8a:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803b90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b93:	89 02                	mov    %eax,(%edx)
  803b95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba1:	c1 e0 04             	shl    $0x4,%eax
  803ba4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ba9:	8b 00                	mov    (%eax),%eax
  803bab:	8d 50 01             	lea    0x1(%eax),%edx
  803bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb1:	c1 e0 04             	shl    $0x4,%eax
  803bb4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803bb9:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803bbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bbe:	89 d0                	mov    %edx,%eax
  803bc0:	01 c0                	add    %eax,%eax
  803bc2:	01 d0                	add    %edx,%eax
  803bc4:	c1 e0 02             	shl    $0x2,%eax
  803bc7:	05 6a 50 80 00       	add    $0x80506a,%eax
  803bcc:	66 8b 00             	mov    (%eax),%ax
  803bcf:	8d 50 01             	lea    0x1(%eax),%edx
  803bd2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803bd5:	89 c8                	mov    %ecx,%eax
  803bd7:	01 c0                	add    %eax,%eax
  803bd9:	01 c8                	add    %ecx,%eax
  803bdb:	c1 e0 02             	shl    $0x2,%eax
  803bde:	05 6a 50 80 00       	add    $0x80506a,%eax
  803be3:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803be6:	b8 00 10 00 00       	mov    $0x1000,%eax
  803beb:	ba 00 00 00 00       	mov    $0x0,%edx
  803bf0:	f7 75 ec             	divl   -0x14(%ebp)
  803bf3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803bf6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bf9:	89 d0                	mov    %edx,%eax
  803bfb:	01 c0                	add    %eax,%eax
  803bfd:	01 d0                	add    %edx,%eax
  803bff:	c1 e0 02             	shl    $0x2,%eax
  803c02:	05 6a 50 80 00       	add    $0x80506a,%eax
  803c07:	66 8b 00             	mov    (%eax),%ax
  803c0a:	0f b7 c0             	movzwl %ax,%eax
  803c0d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c10:	0f 85 d3 01 00 00    	jne    803de9 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803c16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c19:	c1 e0 04             	shl    $0x4,%eax
  803c1c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803c21:	8b 00                	mov    (%eax),%eax
  803c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803c26:	e9 f1 00 00 00       	jmp    803d1c <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2e:	8b 00                	mov    (%eax),%eax
  803c30:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c36:	c1 e0 0c             	shl    $0xc,%eax
  803c39:	89 c2                	mov    %eax,%edx
  803c3b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c40:	01 d0                	add    %edx,%eax
  803c42:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c48:	40                   	inc    %eax
  803c49:	c1 e0 0c             	shl    $0xc,%eax
  803c4c:	89 c2                	mov    %eax,%edx
  803c4e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c53:	01 d0                	add    %edx,%eax
  803c55:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803c5e:	0f 82 b8 00 00 00    	jb     803d1c <free_block+0x290>
  803c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c67:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c6a:	0f 83 ac 00 00 00    	jae    803d1c <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803c70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c74:	75 17                	jne    803c8d <free_block+0x201>
  803c76:	83 ec 04             	sub    $0x4,%esp
  803c79:	68 0d 4c 80 00       	push   $0x804c0d
  803c7e:	68 e2 00 00 00       	push   $0xe2
  803c83:	68 d3 4b 80 00       	push   $0x804bd3
  803c88:	e8 f7 02 00 00       	call   803f84 <_panic>
  803c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c90:	8b 00                	mov    (%eax),%eax
  803c92:	85 c0                	test   %eax,%eax
  803c94:	74 10                	je     803ca6 <free_block+0x21a>
  803c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c99:	8b 00                	mov    (%eax),%eax
  803c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c9e:	8b 52 04             	mov    0x4(%edx),%edx
  803ca1:	89 50 04             	mov    %edx,0x4(%eax)
  803ca4:	eb 14                	jmp    803cba <free_block+0x22e>
  803ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca9:	8b 40 04             	mov    0x4(%eax),%eax
  803cac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803caf:	c1 e2 04             	shl    $0x4,%edx
  803cb2:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803cb8:	89 02                	mov    %eax,(%edx)
  803cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbd:	8b 40 04             	mov    0x4(%eax),%eax
  803cc0:	85 c0                	test   %eax,%eax
  803cc2:	74 0f                	je     803cd3 <free_block+0x247>
  803cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc7:	8b 40 04             	mov    0x4(%eax),%eax
  803cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ccd:	8b 12                	mov    (%edx),%edx
  803ccf:	89 10                	mov    %edx,(%eax)
  803cd1:	eb 13                	jmp    803ce6 <free_block+0x25a>
  803cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd6:	8b 00                	mov    (%eax),%eax
  803cd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cdb:	c1 e2 04             	shl    $0x4,%edx
  803cde:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803ce4:	89 02                	mov    %eax,(%edx)
  803ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cfc:	c1 e0 04             	shl    $0x4,%eax
  803cff:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d04:	8b 00                	mov    (%eax),%eax
  803d06:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d0c:	c1 e0 04             	shl    $0x4,%eax
  803d0f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d14:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803d16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d20:	0f 85 05 ff ff ff    	jne    803c2b <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803d26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d29:	89 d0                	mov    %edx,%eax
  803d2b:	01 c0                	add    %eax,%eax
  803d2d:	01 d0                	add    %edx,%eax
  803d2f:	c1 e0 02             	shl    $0x2,%eax
  803d32:	05 68 50 80 00       	add    $0x805068,%eax
  803d37:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803d3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d3f:	89 d0                	mov    %edx,%eax
  803d41:	01 c0                	add    %eax,%eax
  803d43:	01 d0                	add    %edx,%eax
  803d45:	c1 e0 02             	shl    $0x2,%eax
  803d48:	05 6a 50 80 00       	add    $0x80506a,%eax
  803d4d:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803d52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d55:	89 d0                	mov    %edx,%eax
  803d57:	01 c0                	add    %eax,%eax
  803d59:	01 d0                	add    %edx,%eax
  803d5b:	c1 e0 02             	shl    $0x2,%eax
  803d5e:	05 60 50 80 00       	add    $0x805060,%eax
  803d63:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803d66:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803d6a:	75 17                	jne    803d83 <free_block+0x2f7>
  803d6c:	83 ec 04             	sub    $0x4,%esp
  803d6f:	68 2c 4c 80 00       	push   $0x804c2c
  803d74:	68 eb 00 00 00       	push   $0xeb
  803d79:	68 d3 4b 80 00       	push   $0x804bd3
  803d7e:	e8 01 02 00 00       	call   803f84 <_panic>
  803d83:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803d89:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d8c:	89 50 04             	mov    %edx,0x4(%eax)
  803d8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d92:	8b 40 04             	mov    0x4(%eax),%eax
  803d95:	85 c0                	test   %eax,%eax
  803d97:	74 0c                	je     803da5 <free_block+0x319>
  803d99:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803d9e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803da1:	89 10                	mov    %edx,(%eax)
  803da3:	eb 08                	jmp    803dad <free_block+0x321>
  803da5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803da8:	a3 48 50 80 00       	mov    %eax,0x805048
  803dad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803db0:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803db5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803db8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dbe:	a1 54 50 80 00       	mov    0x805054,%eax
  803dc3:	40                   	inc    %eax
  803dc4:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803dc9:	83 ec 0c             	sub    $0xc,%esp
  803dcc:	ff 75 d0             	pushl  -0x30(%ebp)
  803dcf:	e8 ce f5 ff ff       	call   8033a2 <to_page_va>
  803dd4:	83 c4 10             	add    $0x10,%esp
  803dd7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803dda:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ddd:	83 ec 0c             	sub    $0xc,%esp
  803de0:	50                   	push   %eax
  803de1:	e8 9e d7 ff ff       	call   801584 <return_page>
  803de6:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803de9:	90                   	nop
  803dea:	c9                   	leave  
  803deb:	c3                   	ret    

00803dec <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803dec:	55                   	push   %ebp
  803ded:	89 e5                	mov    %esp,%ebp
  803def:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803df2:	83 ec 04             	sub    $0x4,%esp
  803df5:	68 cc 4c 80 00       	push   $0x804ccc
  803dfa:	68 01 01 00 00       	push   $0x101
  803dff:	68 d3 4b 80 00       	push   $0x804bd3
  803e04:	e8 7b 01 00 00       	call   803f84 <_panic>

00803e09 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803e09:	55                   	push   %ebp
  803e0a:	89 e5                	mov    %esp,%ebp
  803e0c:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803e0f:	83 ec 04             	sub    $0x4,%esp
  803e12:	68 f0 4c 80 00       	push   $0x804cf0
  803e17:	6a 07                	push   $0x7
  803e19:	68 1f 4d 80 00       	push   $0x804d1f
  803e1e:	e8 61 01 00 00       	call   803f84 <_panic>

00803e23 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803e23:	55                   	push   %ebp
  803e24:	89 e5                	mov    %esp,%ebp
  803e26:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803e29:	83 ec 04             	sub    $0x4,%esp
  803e2c:	68 30 4d 80 00       	push   $0x804d30
  803e31:	6a 0b                	push   $0xb
  803e33:	68 1f 4d 80 00       	push   $0x804d1f
  803e38:	e8 47 01 00 00       	call   803f84 <_panic>

00803e3d <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803e3d:	55                   	push   %ebp
  803e3e:	89 e5                	mov    %esp,%ebp
  803e40:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803e43:	83 ec 04             	sub    $0x4,%esp
  803e46:	68 5c 4d 80 00       	push   $0x804d5c
  803e4b:	6a 10                	push   $0x10
  803e4d:	68 1f 4d 80 00       	push   $0x804d1f
  803e52:	e8 2d 01 00 00       	call   803f84 <_panic>

00803e57 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803e57:	55                   	push   %ebp
  803e58:	89 e5                	mov    %esp,%ebp
  803e5a:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803e5d:	83 ec 04             	sub    $0x4,%esp
  803e60:	68 8c 4d 80 00       	push   $0x804d8c
  803e65:	6a 15                	push   $0x15
  803e67:	68 1f 4d 80 00       	push   $0x804d1f
  803e6c:	e8 13 01 00 00       	call   803f84 <_panic>

00803e71 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803e71:	55                   	push   %ebp
  803e72:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803e74:	8b 45 08             	mov    0x8(%ebp),%eax
  803e77:	8b 40 10             	mov    0x10(%eax),%eax
}
  803e7a:	5d                   	pop    %ebp
  803e7b:	c3                   	ret    

00803e7c <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803e7c:	55                   	push   %ebp
  803e7d:	89 e5                	mov    %esp,%ebp
  803e7f:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803e82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803e86:	74 1c                	je     803ea4 <init_uspinlock+0x28>
  803e88:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803e8c:	74 16                	je     803ea4 <init_uspinlock+0x28>
  803e8e:	68 bc 4d 80 00       	push   $0x804dbc
  803e93:	68 db 4d 80 00       	push   $0x804ddb
  803e98:	6a 10                	push   $0x10
  803e9a:	68 f0 4d 80 00       	push   $0x804df0
  803e9f:	e8 e0 00 00 00       	call   803f84 <_panic>
	strcpy(lk->name, name);
  803ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea7:	83 c0 04             	add    $0x4,%eax
  803eaa:	83 ec 08             	sub    $0x8,%esp
  803ead:	ff 75 0c             	pushl  0xc(%ebp)
  803eb0:	50                   	push   %eax
  803eb1:	e8 1d ce ff ff       	call   800cd3 <strcpy>
  803eb6:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  803eb9:	b8 01 00 00 00       	mov    $0x1,%eax
  803ebe:	2b 45 10             	sub    0x10(%ebp),%eax
  803ec1:	89 c2                	mov    %eax,%edx
  803ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec6:	89 10                	mov    %edx,(%eax)
}
  803ec8:	90                   	nop
  803ec9:	c9                   	leave  
  803eca:	c3                   	ret    

00803ecb <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  803ecb:	55                   	push   %ebp
  803ecc:	89 e5                	mov    %esp,%ebp
  803ece:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803ed1:	90                   	nop
  803ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ed8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ee5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803ee8:	f0 87 02             	lock xchg %eax,(%edx)
  803eeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  803eee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ef1:	85 c0                	test   %eax,%eax
  803ef3:	75 dd                	jne    803ed2 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef8:	8d 48 04             	lea    0x4(%eax),%ecx
  803efb:	a1 20 50 80 00       	mov    0x805020,%eax
  803f00:	8d 50 20             	lea    0x20(%eax),%edx
  803f03:	a1 20 50 80 00       	mov    0x805020,%eax
  803f08:	8b 40 10             	mov    0x10(%eax),%eax
  803f0b:	51                   	push   %ecx
  803f0c:	52                   	push   %edx
  803f0d:	50                   	push   %eax
  803f0e:	68 00 4e 80 00       	push   $0x804e00
  803f13:	e8 93 c6 ff ff       	call   8005ab <cprintf>
  803f18:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  803f1b:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  803f20:	90                   	nop
  803f21:	c9                   	leave  
  803f22:	c3                   	ret    

00803f23 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  803f23:	55                   	push   %ebp
  803f24:	89 e5                	mov    %esp,%ebp
  803f26:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  803f29:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2c:	8b 00                	mov    (%eax),%eax
  803f2e:	85 c0                	test   %eax,%eax
  803f30:	75 18                	jne    803f4a <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  803f32:	8b 45 08             	mov    0x8(%ebp),%eax
  803f35:	83 c0 04             	add    $0x4,%eax
  803f38:	50                   	push   %eax
  803f39:	68 24 4e 80 00       	push   $0x804e24
  803f3e:	6a 2b                	push   $0x2b
  803f40:	68 f0 4d 80 00       	push   $0x804df0
  803f45:	e8 3a 00 00 00       	call   803f84 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  803f4a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  803f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f52:	8b 55 08             	mov    0x8(%ebp),%edx
  803f55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f5e:	8d 48 04             	lea    0x4(%eax),%ecx
  803f61:	a1 20 50 80 00       	mov    0x805020,%eax
  803f66:	8d 50 20             	lea    0x20(%eax),%edx
  803f69:	a1 20 50 80 00       	mov    0x805020,%eax
  803f6e:	8b 40 10             	mov    0x10(%eax),%eax
  803f71:	51                   	push   %ecx
  803f72:	52                   	push   %edx
  803f73:	50                   	push   %eax
  803f74:	68 44 4e 80 00       	push   $0x804e44
  803f79:	e8 2d c6 ff ff       	call   8005ab <cprintf>
  803f7e:	83 c4 10             	add    $0x10,%esp
}
  803f81:	90                   	nop
  803f82:	c9                   	leave  
  803f83:	c3                   	ret    

00803f84 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803f84:	55                   	push   %ebp
  803f85:	89 e5                	mov    %esp,%ebp
  803f87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803f8a:	8d 45 10             	lea    0x10(%ebp),%eax
  803f8d:	83 c0 04             	add    $0x4,%eax
  803f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803f93:	a1 84 d1 81 00       	mov    0x81d184,%eax
  803f98:	85 c0                	test   %eax,%eax
  803f9a:	74 16                	je     803fb2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803f9c:	a1 84 d1 81 00       	mov    0x81d184,%eax
  803fa1:	83 ec 08             	sub    $0x8,%esp
  803fa4:	50                   	push   %eax
  803fa5:	68 68 4e 80 00       	push   $0x804e68
  803faa:	e8 fc c5 ff ff       	call   8005ab <cprintf>
  803faf:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803fb2:	a1 04 50 80 00       	mov    0x805004,%eax
  803fb7:	83 ec 0c             	sub    $0xc,%esp
  803fba:	ff 75 0c             	pushl  0xc(%ebp)
  803fbd:	ff 75 08             	pushl  0x8(%ebp)
  803fc0:	50                   	push   %eax
  803fc1:	68 70 4e 80 00       	push   $0x804e70
  803fc6:	6a 74                	push   $0x74
  803fc8:	e8 0b c6 ff ff       	call   8005d8 <cprintf_colored>
  803fcd:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  803fd3:	83 ec 08             	sub    $0x8,%esp
  803fd6:	ff 75 f4             	pushl  -0xc(%ebp)
  803fd9:	50                   	push   %eax
  803fda:	e8 5d c5 ff ff       	call   80053c <vcprintf>
  803fdf:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803fe2:	83 ec 08             	sub    $0x8,%esp
  803fe5:	6a 00                	push   $0x0
  803fe7:	68 98 4e 80 00       	push   $0x804e98
  803fec:	e8 4b c5 ff ff       	call   80053c <vcprintf>
  803ff1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803ff4:	e8 c4 c4 ff ff       	call   8004bd <exit>

	// should not return here
	while (1) ;
  803ff9:	eb fe                	jmp    803ff9 <_panic+0x75>

00803ffb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803ffb:	55                   	push   %ebp
  803ffc:	89 e5                	mov    %esp,%ebp
  803ffe:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  804001:	a1 20 50 80 00       	mov    0x805020,%eax
  804006:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80400c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80400f:	39 c2                	cmp    %eax,%edx
  804011:	74 14                	je     804027 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  804013:	83 ec 04             	sub    $0x4,%esp
  804016:	68 9c 4e 80 00       	push   $0x804e9c
  80401b:	6a 26                	push   $0x26
  80401d:	68 e8 4e 80 00       	push   $0x804ee8
  804022:	e8 5d ff ff ff       	call   803f84 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  804027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80402e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804035:	e9 c5 00 00 00       	jmp    8040ff <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80403a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80403d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804044:	8b 45 08             	mov    0x8(%ebp),%eax
  804047:	01 d0                	add    %edx,%eax
  804049:	8b 00                	mov    (%eax),%eax
  80404b:	85 c0                	test   %eax,%eax
  80404d:	75 08                	jne    804057 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80404f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  804052:	e9 a5 00 00 00       	jmp    8040fc <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  804057:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80405e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804065:	eb 69                	jmp    8040d0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  804067:	a1 20 50 80 00       	mov    0x805020,%eax
  80406c:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  804072:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804075:	89 d0                	mov    %edx,%eax
  804077:	01 c0                	add    %eax,%eax
  804079:	01 d0                	add    %edx,%eax
  80407b:	c1 e0 03             	shl    $0x3,%eax
  80407e:	01 c8                	add    %ecx,%eax
  804080:	8a 40 04             	mov    0x4(%eax),%al
  804083:	84 c0                	test   %al,%al
  804085:	75 46                	jne    8040cd <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804087:	a1 20 50 80 00       	mov    0x805020,%eax
  80408c:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  804092:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804095:	89 d0                	mov    %edx,%eax
  804097:	01 c0                	add    %eax,%eax
  804099:	01 d0                	add    %edx,%eax
  80409b:	c1 e0 03             	shl    $0x3,%eax
  80409e:	01 c8                	add    %ecx,%eax
  8040a0:	8b 00                	mov    (%eax),%eax
  8040a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8040a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8040ad:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8040af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040b2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8040b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040bc:	01 c8                	add    %ecx,%eax
  8040be:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8040c0:	39 c2                	cmp    %eax,%edx
  8040c2:	75 09                	jne    8040cd <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8040c4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8040cb:	eb 15                	jmp    8040e2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8040cd:	ff 45 e8             	incl   -0x18(%ebp)
  8040d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8040d5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8040db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040de:	39 c2                	cmp    %eax,%edx
  8040e0:	77 85                	ja     804067 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8040e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8040e6:	75 14                	jne    8040fc <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8040e8:	83 ec 04             	sub    $0x4,%esp
  8040eb:	68 f4 4e 80 00       	push   $0x804ef4
  8040f0:	6a 3a                	push   $0x3a
  8040f2:	68 e8 4e 80 00       	push   $0x804ee8
  8040f7:	e8 88 fe ff ff       	call   803f84 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8040fc:	ff 45 f0             	incl   -0x10(%ebp)
  8040ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804102:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804105:	0f 8c 2f ff ff ff    	jl     80403a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80410b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804112:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  804119:	eb 26                	jmp    804141 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80411b:	a1 20 50 80 00       	mov    0x805020,%eax
  804120:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  804126:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804129:	89 d0                	mov    %edx,%eax
  80412b:	01 c0                	add    %eax,%eax
  80412d:	01 d0                	add    %edx,%eax
  80412f:	c1 e0 03             	shl    $0x3,%eax
  804132:	01 c8                	add    %ecx,%eax
  804134:	8a 40 04             	mov    0x4(%eax),%al
  804137:	3c 01                	cmp    $0x1,%al
  804139:	75 03                	jne    80413e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80413b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80413e:	ff 45 e0             	incl   -0x20(%ebp)
  804141:	a1 20 50 80 00       	mov    0x805020,%eax
  804146:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80414c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80414f:	39 c2                	cmp    %eax,%edx
  804151:	77 c8                	ja     80411b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  804153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804156:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  804159:	74 14                	je     80416f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80415b:	83 ec 04             	sub    $0x4,%esp
  80415e:	68 48 4f 80 00       	push   $0x804f48
  804163:	6a 44                	push   $0x44
  804165:	68 e8 4e 80 00       	push   $0x804ee8
  80416a:	e8 15 fe ff ff       	call   803f84 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80416f:	90                   	nop
  804170:	c9                   	leave  
  804171:	c3                   	ret    
  804172:	66 90                	xchg   %ax,%ax

00804174 <__udivdi3>:
  804174:	55                   	push   %ebp
  804175:	57                   	push   %edi
  804176:	56                   	push   %esi
  804177:	53                   	push   %ebx
  804178:	83 ec 1c             	sub    $0x1c,%esp
  80417b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80417f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804183:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804187:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80418b:	89 ca                	mov    %ecx,%edx
  80418d:	89 f8                	mov    %edi,%eax
  80418f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804193:	85 f6                	test   %esi,%esi
  804195:	75 2d                	jne    8041c4 <__udivdi3+0x50>
  804197:	39 cf                	cmp    %ecx,%edi
  804199:	77 65                	ja     804200 <__udivdi3+0x8c>
  80419b:	89 fd                	mov    %edi,%ebp
  80419d:	85 ff                	test   %edi,%edi
  80419f:	75 0b                	jne    8041ac <__udivdi3+0x38>
  8041a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8041a6:	31 d2                	xor    %edx,%edx
  8041a8:	f7 f7                	div    %edi
  8041aa:	89 c5                	mov    %eax,%ebp
  8041ac:	31 d2                	xor    %edx,%edx
  8041ae:	89 c8                	mov    %ecx,%eax
  8041b0:	f7 f5                	div    %ebp
  8041b2:	89 c1                	mov    %eax,%ecx
  8041b4:	89 d8                	mov    %ebx,%eax
  8041b6:	f7 f5                	div    %ebp
  8041b8:	89 cf                	mov    %ecx,%edi
  8041ba:	89 fa                	mov    %edi,%edx
  8041bc:	83 c4 1c             	add    $0x1c,%esp
  8041bf:	5b                   	pop    %ebx
  8041c0:	5e                   	pop    %esi
  8041c1:	5f                   	pop    %edi
  8041c2:	5d                   	pop    %ebp
  8041c3:	c3                   	ret    
  8041c4:	39 ce                	cmp    %ecx,%esi
  8041c6:	77 28                	ja     8041f0 <__udivdi3+0x7c>
  8041c8:	0f bd fe             	bsr    %esi,%edi
  8041cb:	83 f7 1f             	xor    $0x1f,%edi
  8041ce:	75 40                	jne    804210 <__udivdi3+0x9c>
  8041d0:	39 ce                	cmp    %ecx,%esi
  8041d2:	72 0a                	jb     8041de <__udivdi3+0x6a>
  8041d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8041d8:	0f 87 9e 00 00 00    	ja     80427c <__udivdi3+0x108>
  8041de:	b8 01 00 00 00       	mov    $0x1,%eax
  8041e3:	89 fa                	mov    %edi,%edx
  8041e5:	83 c4 1c             	add    $0x1c,%esp
  8041e8:	5b                   	pop    %ebx
  8041e9:	5e                   	pop    %esi
  8041ea:	5f                   	pop    %edi
  8041eb:	5d                   	pop    %ebp
  8041ec:	c3                   	ret    
  8041ed:	8d 76 00             	lea    0x0(%esi),%esi
  8041f0:	31 ff                	xor    %edi,%edi
  8041f2:	31 c0                	xor    %eax,%eax
  8041f4:	89 fa                	mov    %edi,%edx
  8041f6:	83 c4 1c             	add    $0x1c,%esp
  8041f9:	5b                   	pop    %ebx
  8041fa:	5e                   	pop    %esi
  8041fb:	5f                   	pop    %edi
  8041fc:	5d                   	pop    %ebp
  8041fd:	c3                   	ret    
  8041fe:	66 90                	xchg   %ax,%ax
  804200:	89 d8                	mov    %ebx,%eax
  804202:	f7 f7                	div    %edi
  804204:	31 ff                	xor    %edi,%edi
  804206:	89 fa                	mov    %edi,%edx
  804208:	83 c4 1c             	add    $0x1c,%esp
  80420b:	5b                   	pop    %ebx
  80420c:	5e                   	pop    %esi
  80420d:	5f                   	pop    %edi
  80420e:	5d                   	pop    %ebp
  80420f:	c3                   	ret    
  804210:	bd 20 00 00 00       	mov    $0x20,%ebp
  804215:	89 eb                	mov    %ebp,%ebx
  804217:	29 fb                	sub    %edi,%ebx
  804219:	89 f9                	mov    %edi,%ecx
  80421b:	d3 e6                	shl    %cl,%esi
  80421d:	89 c5                	mov    %eax,%ebp
  80421f:	88 d9                	mov    %bl,%cl
  804221:	d3 ed                	shr    %cl,%ebp
  804223:	89 e9                	mov    %ebp,%ecx
  804225:	09 f1                	or     %esi,%ecx
  804227:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80422b:	89 f9                	mov    %edi,%ecx
  80422d:	d3 e0                	shl    %cl,%eax
  80422f:	89 c5                	mov    %eax,%ebp
  804231:	89 d6                	mov    %edx,%esi
  804233:	88 d9                	mov    %bl,%cl
  804235:	d3 ee                	shr    %cl,%esi
  804237:	89 f9                	mov    %edi,%ecx
  804239:	d3 e2                	shl    %cl,%edx
  80423b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80423f:	88 d9                	mov    %bl,%cl
  804241:	d3 e8                	shr    %cl,%eax
  804243:	09 c2                	or     %eax,%edx
  804245:	89 d0                	mov    %edx,%eax
  804247:	89 f2                	mov    %esi,%edx
  804249:	f7 74 24 0c          	divl   0xc(%esp)
  80424d:	89 d6                	mov    %edx,%esi
  80424f:	89 c3                	mov    %eax,%ebx
  804251:	f7 e5                	mul    %ebp
  804253:	39 d6                	cmp    %edx,%esi
  804255:	72 19                	jb     804270 <__udivdi3+0xfc>
  804257:	74 0b                	je     804264 <__udivdi3+0xf0>
  804259:	89 d8                	mov    %ebx,%eax
  80425b:	31 ff                	xor    %edi,%edi
  80425d:	e9 58 ff ff ff       	jmp    8041ba <__udivdi3+0x46>
  804262:	66 90                	xchg   %ax,%ax
  804264:	8b 54 24 08          	mov    0x8(%esp),%edx
  804268:	89 f9                	mov    %edi,%ecx
  80426a:	d3 e2                	shl    %cl,%edx
  80426c:	39 c2                	cmp    %eax,%edx
  80426e:	73 e9                	jae    804259 <__udivdi3+0xe5>
  804270:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804273:	31 ff                	xor    %edi,%edi
  804275:	e9 40 ff ff ff       	jmp    8041ba <__udivdi3+0x46>
  80427a:	66 90                	xchg   %ax,%ax
  80427c:	31 c0                	xor    %eax,%eax
  80427e:	e9 37 ff ff ff       	jmp    8041ba <__udivdi3+0x46>
  804283:	90                   	nop

00804284 <__umoddi3>:
  804284:	55                   	push   %ebp
  804285:	57                   	push   %edi
  804286:	56                   	push   %esi
  804287:	53                   	push   %ebx
  804288:	83 ec 1c             	sub    $0x1c,%esp
  80428b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80428f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804293:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804297:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80429b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80429f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8042a3:	89 f3                	mov    %esi,%ebx
  8042a5:	89 fa                	mov    %edi,%edx
  8042a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042ab:	89 34 24             	mov    %esi,(%esp)
  8042ae:	85 c0                	test   %eax,%eax
  8042b0:	75 1a                	jne    8042cc <__umoddi3+0x48>
  8042b2:	39 f7                	cmp    %esi,%edi
  8042b4:	0f 86 a2 00 00 00    	jbe    80435c <__umoddi3+0xd8>
  8042ba:	89 c8                	mov    %ecx,%eax
  8042bc:	89 f2                	mov    %esi,%edx
  8042be:	f7 f7                	div    %edi
  8042c0:	89 d0                	mov    %edx,%eax
  8042c2:	31 d2                	xor    %edx,%edx
  8042c4:	83 c4 1c             	add    $0x1c,%esp
  8042c7:	5b                   	pop    %ebx
  8042c8:	5e                   	pop    %esi
  8042c9:	5f                   	pop    %edi
  8042ca:	5d                   	pop    %ebp
  8042cb:	c3                   	ret    
  8042cc:	39 f0                	cmp    %esi,%eax
  8042ce:	0f 87 ac 00 00 00    	ja     804380 <__umoddi3+0xfc>
  8042d4:	0f bd e8             	bsr    %eax,%ebp
  8042d7:	83 f5 1f             	xor    $0x1f,%ebp
  8042da:	0f 84 ac 00 00 00    	je     80438c <__umoddi3+0x108>
  8042e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8042e5:	29 ef                	sub    %ebp,%edi
  8042e7:	89 fe                	mov    %edi,%esi
  8042e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042ed:	89 e9                	mov    %ebp,%ecx
  8042ef:	d3 e0                	shl    %cl,%eax
  8042f1:	89 d7                	mov    %edx,%edi
  8042f3:	89 f1                	mov    %esi,%ecx
  8042f5:	d3 ef                	shr    %cl,%edi
  8042f7:	09 c7                	or     %eax,%edi
  8042f9:	89 e9                	mov    %ebp,%ecx
  8042fb:	d3 e2                	shl    %cl,%edx
  8042fd:	89 14 24             	mov    %edx,(%esp)
  804300:	89 d8                	mov    %ebx,%eax
  804302:	d3 e0                	shl    %cl,%eax
  804304:	89 c2                	mov    %eax,%edx
  804306:	8b 44 24 08          	mov    0x8(%esp),%eax
  80430a:	d3 e0                	shl    %cl,%eax
  80430c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804310:	8b 44 24 08          	mov    0x8(%esp),%eax
  804314:	89 f1                	mov    %esi,%ecx
  804316:	d3 e8                	shr    %cl,%eax
  804318:	09 d0                	or     %edx,%eax
  80431a:	d3 eb                	shr    %cl,%ebx
  80431c:	89 da                	mov    %ebx,%edx
  80431e:	f7 f7                	div    %edi
  804320:	89 d3                	mov    %edx,%ebx
  804322:	f7 24 24             	mull   (%esp)
  804325:	89 c6                	mov    %eax,%esi
  804327:	89 d1                	mov    %edx,%ecx
  804329:	39 d3                	cmp    %edx,%ebx
  80432b:	0f 82 87 00 00 00    	jb     8043b8 <__umoddi3+0x134>
  804331:	0f 84 91 00 00 00    	je     8043c8 <__umoddi3+0x144>
  804337:	8b 54 24 04          	mov    0x4(%esp),%edx
  80433b:	29 f2                	sub    %esi,%edx
  80433d:	19 cb                	sbb    %ecx,%ebx
  80433f:	89 d8                	mov    %ebx,%eax
  804341:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804345:	d3 e0                	shl    %cl,%eax
  804347:	89 e9                	mov    %ebp,%ecx
  804349:	d3 ea                	shr    %cl,%edx
  80434b:	09 d0                	or     %edx,%eax
  80434d:	89 e9                	mov    %ebp,%ecx
  80434f:	d3 eb                	shr    %cl,%ebx
  804351:	89 da                	mov    %ebx,%edx
  804353:	83 c4 1c             	add    $0x1c,%esp
  804356:	5b                   	pop    %ebx
  804357:	5e                   	pop    %esi
  804358:	5f                   	pop    %edi
  804359:	5d                   	pop    %ebp
  80435a:	c3                   	ret    
  80435b:	90                   	nop
  80435c:	89 fd                	mov    %edi,%ebp
  80435e:	85 ff                	test   %edi,%edi
  804360:	75 0b                	jne    80436d <__umoddi3+0xe9>
  804362:	b8 01 00 00 00       	mov    $0x1,%eax
  804367:	31 d2                	xor    %edx,%edx
  804369:	f7 f7                	div    %edi
  80436b:	89 c5                	mov    %eax,%ebp
  80436d:	89 f0                	mov    %esi,%eax
  80436f:	31 d2                	xor    %edx,%edx
  804371:	f7 f5                	div    %ebp
  804373:	89 c8                	mov    %ecx,%eax
  804375:	f7 f5                	div    %ebp
  804377:	89 d0                	mov    %edx,%eax
  804379:	e9 44 ff ff ff       	jmp    8042c2 <__umoddi3+0x3e>
  80437e:	66 90                	xchg   %ax,%ax
  804380:	89 c8                	mov    %ecx,%eax
  804382:	89 f2                	mov    %esi,%edx
  804384:	83 c4 1c             	add    $0x1c,%esp
  804387:	5b                   	pop    %ebx
  804388:	5e                   	pop    %esi
  804389:	5f                   	pop    %edi
  80438a:	5d                   	pop    %ebp
  80438b:	c3                   	ret    
  80438c:	3b 04 24             	cmp    (%esp),%eax
  80438f:	72 06                	jb     804397 <__umoddi3+0x113>
  804391:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804395:	77 0f                	ja     8043a6 <__umoddi3+0x122>
  804397:	89 f2                	mov    %esi,%edx
  804399:	29 f9                	sub    %edi,%ecx
  80439b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80439f:	89 14 24             	mov    %edx,(%esp)
  8043a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8043aa:	8b 14 24             	mov    (%esp),%edx
  8043ad:	83 c4 1c             	add    $0x1c,%esp
  8043b0:	5b                   	pop    %ebx
  8043b1:	5e                   	pop    %esi
  8043b2:	5f                   	pop    %edi
  8043b3:	5d                   	pop    %ebp
  8043b4:	c3                   	ret    
  8043b5:	8d 76 00             	lea    0x0(%esi),%esi
  8043b8:	2b 04 24             	sub    (%esp),%eax
  8043bb:	19 fa                	sbb    %edi,%edx
  8043bd:	89 d1                	mov    %edx,%ecx
  8043bf:	89 c6                	mov    %eax,%esi
  8043c1:	e9 71 ff ff ff       	jmp    804337 <__umoddi3+0xb3>
  8043c6:	66 90                	xchg   %ax,%ax
  8043c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8043cc:	72 ea                	jb     8043b8 <__umoddi3+0x134>
  8043ce:	89 d9                	mov    %ebx,%ecx
  8043d0:	e9 62 ff ff ff       	jmp    804337 <__umoddi3+0xb3>
