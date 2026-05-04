
obj/user/fos_factorial:     file format elf32-i386


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
  800031:	e8 be 00 00 00       	call   8000f4 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 factorial(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter a number:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 e0 1c 80 00       	push   $0x801ce0
  800057:	e8 09 0b 00 00       	call   800b65 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 0b 10 00 00       	call   80107d <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 res = factorial(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 22 00 00 00       	call   8000a5 <factorial>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800089:	89 55 ec             	mov    %edx,-0x14(%ebp)

	atomic_cprintf("Factorial %d = %lld\n",i1, res);
  80008c:	ff 75 ec             	pushl  -0x14(%ebp)
  80008f:	ff 75 e8             	pushl  -0x18(%ebp)
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	68 f7 1c 80 00       	push   $0x801cf7
  80009a:	e8 60 03 00 00       	call   8003ff <atomic_cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	return;
  8000a2:	90                   	nop
}
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <factorial>:


int64 factorial(int n)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	57                   	push   %edi
  8000a9:	56                   	push   %esi
  8000aa:	53                   	push   %ebx
  8000ab:	83 ec 0c             	sub    $0xc,%esp
	if (n <= 1)
  8000ae:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000b2:	7f 0c                	jg     8000c0 <factorial+0x1b>
		return 1 ;
  8000b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000be:	eb 2c                	jmp    8000ec <factorial+0x47>
	return n * factorial(n-1) ;
  8000c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000c3:	89 c3                	mov    %eax,%ebx
  8000c5:	89 c6                	mov    %eax,%esi
  8000c7:	c1 fe 1f             	sar    $0x1f,%esi
  8000ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cd:	48                   	dec    %eax
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	e8 ce ff ff ff       	call   8000a5 <factorial>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 f7                	mov    %esi,%edi
  8000dc:	0f af f8             	imul   %eax,%edi
  8000df:	89 d1                	mov    %edx,%ecx
  8000e1:	0f af cb             	imul   %ebx,%ecx
  8000e4:	01 f9                	add    %edi,%ecx
  8000e6:	f7 e3                	mul    %ebx
  8000e8:	01 d1                	add    %edx,%ecx
  8000ea:	89 ca                	mov    %ecx,%edx
}
  8000ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	57                   	push   %edi
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000fd:	e8 60 16 00 00       	call   801762 <sys_getenvindex>
  800102:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800105:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800108:	89 d0                	mov    %edx,%eax
  80010a:	c1 e0 02             	shl    $0x2,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800116:	01 d0                	add    %edx,%eax
  800118:	89 c2                	mov    %eax,%edx
  80011a:	c1 e2 04             	shl    $0x4,%edx
  80011d:	29 c2                	sub    %eax,%edx
  80011f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800126:	89 c2                	mov    %eax,%edx
  800128:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80012e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800133:	a1 20 30 80 00       	mov    0x803020,%eax
  800138:	8a 40 20             	mov    0x20(%eax),%al
  80013b:	84 c0                	test   %al,%al
  80013d:	74 0d                	je     80014c <libmain+0x58>
		binaryname = myEnv->prog_name;
  80013f:	a1 20 30 80 00       	mov    0x803020,%eax
  800144:	83 c0 20             	add    $0x20,%eax
  800147:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800150:	7e 0a                	jle    80015c <libmain+0x68>
		binaryname = argv[0];
  800152:	8b 45 0c             	mov    0xc(%ebp),%eax
  800155:	8b 00                	mov    (%eax),%eax
  800157:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	ff 75 0c             	pushl  0xc(%ebp)
  800162:	ff 75 08             	pushl  0x8(%ebp)
  800165:	e8 ce fe ff ff       	call   800038 <_main>
  80016a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80016d:	a1 00 30 80 00       	mov    0x803000,%eax
  800172:	85 c0                	test   %eax,%eax
  800174:	0f 84 01 01 00 00    	je     80027b <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80017a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800180:	bb 04 1e 80 00       	mov    $0x801e04,%ebx
  800185:	ba 0e 00 00 00       	mov    $0xe,%edx
  80018a:	89 c7                	mov    %eax,%edi
  80018c:	89 de                	mov    %ebx,%esi
  80018e:	89 d1                	mov    %edx,%ecx
  800190:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800192:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800195:	b9 56 00 00 00       	mov    $0x56,%ecx
  80019a:	b0 00                	mov    $0x0,%al
  80019c:	89 d7                	mov    %edx,%edi
  80019e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	50                   	push   %eax
  8001ae:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	e8 de 17 00 00       	call   801998 <sys_utilities>
  8001ba:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001bd:	e8 27 13 00 00       	call   8014e9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	68 24 1d 80 00       	push   $0x801d24
  8001ca:	e8 be 01 00 00       	call   80038d <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	74 18                	je     8001f1 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001d9:	e8 d8 17 00 00       	call   8019b6 <sys_get_optimal_num_faults>
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	50                   	push   %eax
  8001e2:	68 4c 1d 80 00       	push   $0x801d4c
  8001e7:	e8 a1 01 00 00       	call   80038d <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
  8001ef:	eb 59                	jmp    80024a <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f6:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8001fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800201:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	52                   	push   %edx
  80020b:	50                   	push   %eax
  80020c:	68 70 1d 80 00       	push   $0x801d70
  800211:	e8 77 01 00 00       	call   80038d <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800219:	a1 20 30 80 00       	mov    0x803020,%eax
  80021e:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800224:	a1 20 30 80 00       	mov    0x803020,%eax
  800229:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80022f:	a1 20 30 80 00       	mov    0x803020,%eax
  800234:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80023a:	51                   	push   %ecx
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 98 1d 80 00       	push   $0x801d98
  800242:	e8 46 01 00 00       	call   80038d <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 30 80 00       	mov    0x803020,%eax
  80024f:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 f0 1d 80 00       	push   $0x801df0
  80025e:	e8 2a 01 00 00       	call   80038d <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 24 1d 80 00       	push   $0x801d24
  80026e:	e8 1a 01 00 00       	call   80038d <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800276:	e8 88 12 00 00       	call   801503 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80027b:	e8 1f 00 00 00       	call   80029f <exit>
}
  800280:	90                   	nop
  800281:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800284:	5b                   	pop    %ebx
  800285:	5e                   	pop    %esi
  800286:	5f                   	pop    %edi
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    

00800289 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	6a 00                	push   $0x0
  800294:	e8 95 14 00 00       	call   80172e <sys_destroy_env>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	90                   	nop
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <exit>:

void
exit(void)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002a5:	e8 ea 14 00 00       	call   801794 <sys_exit_env>
}
  8002aa:	90                   	nop
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	53                   	push   %ebx
  8002b1:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b7:	8b 00                	mov    (%eax),%eax
  8002b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8002bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bf:	89 0a                	mov    %ecx,(%edx)
  8002c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c4:	88 d1                	mov    %dl,%cl
  8002c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d0:	8b 00                	mov    (%eax),%eax
  8002d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d7:	75 30                	jne    800309 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002d9:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002df:	a0 44 30 80 00       	mov    0x803044,%al
  8002e4:	0f b6 c0             	movzbl %al,%eax
  8002e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ea:	8b 09                	mov    (%ecx),%ecx
  8002ec:	89 cb                	mov    %ecx,%ebx
  8002ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f1:	83 c1 08             	add    $0x8,%ecx
  8002f4:	52                   	push   %edx
  8002f5:	50                   	push   %eax
  8002f6:	53                   	push   %ebx
  8002f7:	51                   	push   %ecx
  8002f8:	e8 a8 11 00 00       	call   8014a5 <sys_cputs>
  8002fd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800309:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030c:	8b 40 04             	mov    0x4(%eax),%eax
  80030f:	8d 50 01             	lea    0x1(%eax),%edx
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
  800315:	89 50 04             	mov    %edx,0x4(%eax)
}
  800318:	90                   	nop
  800319:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800327:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032e:	00 00 00 
	b.cnt = 0;
  800331:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800338:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80033b:	ff 75 0c             	pushl  0xc(%ebp)
  80033e:	ff 75 08             	pushl  0x8(%ebp)
  800341:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800347:	50                   	push   %eax
  800348:	68 ad 02 80 00       	push   $0x8002ad
  80034d:	e8 5a 02 00 00       	call   8005ac <vprintfmt>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800355:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80035b:	a0 44 30 80 00       	mov    0x803044,%al
  800360:	0f b6 c0             	movzbl %al,%eax
  800363:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800369:	52                   	push   %edx
  80036a:	50                   	push   %eax
  80036b:	51                   	push   %ecx
  80036c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800372:	83 c0 08             	add    $0x8,%eax
  800375:	50                   	push   %eax
  800376:	e8 2a 11 00 00       	call   8014a5 <sys_cputs>
  80037b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80037e:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800385:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80038b:	c9                   	leave  
  80038c:	c3                   	ret    

0080038d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80038d:	55                   	push   %ebp
  80038e:	89 e5                	mov    %esp,%ebp
  800390:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800393:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80039a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80039d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a3:	83 ec 08             	sub    $0x8,%esp
  8003a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a9:	50                   	push   %eax
  8003aa:	e8 6f ff ff ff       	call   80031e <vcprintf>
  8003af:	83 c4 10             	add    $0x10,%esp
  8003b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003b8:	c9                   	leave  
  8003b9:	c3                   	ret    

008003ba <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003ba:	55                   	push   %ebp
  8003bb:	89 e5                	mov    %esp,%ebp
  8003bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003c0:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ca:	c1 e0 08             	shl    $0x8,%eax
  8003cd:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003d2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003d5:	83 c0 04             	add    $0x4,%eax
  8003d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003de:	83 ec 08             	sub    $0x8,%esp
  8003e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e4:	50                   	push   %eax
  8003e5:	e8 34 ff ff ff       	call   80031e <vcprintf>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003f0:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003f7:	07 00 00 

	return cnt;
  8003fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003fd:	c9                   	leave  
  8003fe:	c3                   	ret    

008003ff <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
  800402:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800405:	e8 df 10 00 00       	call   8014e9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80040a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80040d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	ff 75 f4             	pushl  -0xc(%ebp)
  800419:	50                   	push   %eax
  80041a:	e8 ff fe ff ff       	call   80031e <vcprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
  800422:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800425:	e8 d9 10 00 00       	call   801503 <sys_unlock_cons>
	return cnt;
  80042a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80042d:	c9                   	leave  
  80042e:	c3                   	ret    

0080042f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	53                   	push   %ebx
  800433:	83 ec 14             	sub    $0x14,%esp
  800436:	8b 45 10             	mov    0x10(%ebp),%eax
  800439:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80043c:	8b 45 14             	mov    0x14(%ebp),%eax
  80043f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800442:	8b 45 18             	mov    0x18(%ebp),%eax
  800445:	ba 00 00 00 00       	mov    $0x0,%edx
  80044a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80044d:	77 55                	ja     8004a4 <printnum+0x75>
  80044f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800452:	72 05                	jb     800459 <printnum+0x2a>
  800454:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800457:	77 4b                	ja     8004a4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800459:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80045c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80045f:	8b 45 18             	mov    0x18(%ebp),%eax
  800462:	ba 00 00 00 00       	mov    $0x0,%edx
  800467:	52                   	push   %edx
  800468:	50                   	push   %eax
  800469:	ff 75 f4             	pushl  -0xc(%ebp)
  80046c:	ff 75 f0             	pushl  -0x10(%ebp)
  80046f:	e8 f0 15 00 00       	call   801a64 <__udivdi3>
  800474:	83 c4 10             	add    $0x10,%esp
  800477:	83 ec 04             	sub    $0x4,%esp
  80047a:	ff 75 20             	pushl  0x20(%ebp)
  80047d:	53                   	push   %ebx
  80047e:	ff 75 18             	pushl  0x18(%ebp)
  800481:	52                   	push   %edx
  800482:	50                   	push   %eax
  800483:	ff 75 0c             	pushl  0xc(%ebp)
  800486:	ff 75 08             	pushl  0x8(%ebp)
  800489:	e8 a1 ff ff ff       	call   80042f <printnum>
  80048e:	83 c4 20             	add    $0x20,%esp
  800491:	eb 1a                	jmp    8004ad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	ff 75 0c             	pushl  0xc(%ebp)
  800499:	ff 75 20             	pushl  0x20(%ebp)
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	ff d0                	call   *%eax
  8004a1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004a4:	ff 4d 1c             	decl   0x1c(%ebp)
  8004a7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004ab:	7f e6                	jg     800493 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004bb:	53                   	push   %ebx
  8004bc:	51                   	push   %ecx
  8004bd:	52                   	push   %edx
  8004be:	50                   	push   %eax
  8004bf:	e8 b0 16 00 00       	call   801b74 <__umoddi3>
  8004c4:	83 c4 10             	add    $0x10,%esp
  8004c7:	05 94 20 80 00       	add    $0x802094,%eax
  8004cc:	8a 00                	mov    (%eax),%al
  8004ce:	0f be c0             	movsbl %al,%eax
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	ff 75 0c             	pushl  0xc(%ebp)
  8004d7:	50                   	push   %eax
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	ff d0                	call   *%eax
  8004dd:	83 c4 10             	add    $0x10,%esp
}
  8004e0:	90                   	nop
  8004e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004e4:	c9                   	leave  
  8004e5:	c3                   	ret    

008004e6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004e9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ed:	7e 1c                	jle    80050b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	8d 50 08             	lea    0x8(%eax),%edx
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	89 10                	mov    %edx,(%eax)
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	83 e8 08             	sub    $0x8,%eax
  800504:	8b 50 04             	mov    0x4(%eax),%edx
  800507:	8b 00                	mov    (%eax),%eax
  800509:	eb 40                	jmp    80054b <getuint+0x65>
	else if (lflag)
  80050b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80050f:	74 1e                	je     80052f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	8d 50 04             	lea    0x4(%eax),%edx
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	89 10                	mov    %edx,(%eax)
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	83 e8 04             	sub    $0x4,%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	ba 00 00 00 00       	mov    $0x0,%edx
  80052d:	eb 1c                	jmp    80054b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	8d 50 04             	lea    0x4(%eax),%edx
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	89 10                	mov    %edx,(%eax)
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	83 e8 04             	sub    $0x4,%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80054b:	5d                   	pop    %ebp
  80054c:	c3                   	ret    

0080054d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80054d:	55                   	push   %ebp
  80054e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800550:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800554:	7e 1c                	jle    800572 <getint+0x25>
		return va_arg(*ap, long long);
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	8d 50 08             	lea    0x8(%eax),%edx
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	89 10                	mov    %edx,(%eax)
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	83 e8 08             	sub    $0x8,%eax
  80056b:	8b 50 04             	mov    0x4(%eax),%edx
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	eb 38                	jmp    8005aa <getint+0x5d>
	else if (lflag)
  800572:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800576:	74 1a                	je     800592 <getint+0x45>
		return va_arg(*ap, long);
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	8d 50 04             	lea    0x4(%eax),%edx
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	89 10                	mov    %edx,(%eax)
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	83 e8 04             	sub    $0x4,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	99                   	cltd   
  800590:	eb 18                	jmp    8005aa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800592:	8b 45 08             	mov    0x8(%ebp),%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	8d 50 04             	lea    0x4(%eax),%edx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	89 10                	mov    %edx,(%eax)
  80059f:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	83 e8 04             	sub    $0x4,%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	99                   	cltd   
}
  8005aa:	5d                   	pop    %ebp
  8005ab:	c3                   	ret    

008005ac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	56                   	push   %esi
  8005b0:	53                   	push   %ebx
  8005b1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b4:	eb 17                	jmp    8005cd <vprintfmt+0x21>
			if (ch == '\0')
  8005b6:	85 db                	test   %ebx,%ebx
  8005b8:	0f 84 c1 03 00 00    	je     80097f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	ff 75 0c             	pushl  0xc(%ebp)
  8005c4:	53                   	push   %ebx
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	ff d0                	call   *%eax
  8005ca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d0:	8d 50 01             	lea    0x1(%eax),%edx
  8005d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8005d6:	8a 00                	mov    (%eax),%al
  8005d8:	0f b6 d8             	movzbl %al,%ebx
  8005db:	83 fb 25             	cmp    $0x25,%ebx
  8005de:	75 d6                	jne    8005b6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005e0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005e4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005eb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005f2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	8d 50 01             	lea    0x1(%eax),%edx
  800606:	89 55 10             	mov    %edx,0x10(%ebp)
  800609:	8a 00                	mov    (%eax),%al
  80060b:	0f b6 d8             	movzbl %al,%ebx
  80060e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800611:	83 f8 5b             	cmp    $0x5b,%eax
  800614:	0f 87 3d 03 00 00    	ja     800957 <vprintfmt+0x3ab>
  80061a:	8b 04 85 b8 20 80 00 	mov    0x8020b8(,%eax,4),%eax
  800621:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800623:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800627:	eb d7                	jmp    800600 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800629:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80062d:	eb d1                	jmp    800600 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80062f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800636:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800639:	89 d0                	mov    %edx,%eax
  80063b:	c1 e0 02             	shl    $0x2,%eax
  80063e:	01 d0                	add    %edx,%eax
  800640:	01 c0                	add    %eax,%eax
  800642:	01 d8                	add    %ebx,%eax
  800644:	83 e8 30             	sub    $0x30,%eax
  800647:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80064a:	8b 45 10             	mov    0x10(%ebp),%eax
  80064d:	8a 00                	mov    (%eax),%al
  80064f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800652:	83 fb 2f             	cmp    $0x2f,%ebx
  800655:	7e 3e                	jle    800695 <vprintfmt+0xe9>
  800657:	83 fb 39             	cmp    $0x39,%ebx
  80065a:	7f 39                	jg     800695 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80065c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80065f:	eb d5                	jmp    800636 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	83 c0 04             	add    $0x4,%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	83 e8 04             	sub    $0x4,%eax
  800670:	8b 00                	mov    (%eax),%eax
  800672:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800675:	eb 1f                	jmp    800696 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800677:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067b:	79 83                	jns    800600 <vprintfmt+0x54>
				width = 0;
  80067d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800684:	e9 77 ff ff ff       	jmp    800600 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800689:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800690:	e9 6b ff ff ff       	jmp    800600 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800695:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800696:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069a:	0f 89 60 ff ff ff    	jns    800600 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006ad:	e9 4e ff ff ff       	jmp    800600 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006b2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006b5:	e9 46 ff ff ff       	jmp    800600 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	83 c0 04             	add    $0x4,%eax
  8006c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	83 e8 04             	sub    $0x4,%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	50                   	push   %eax
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	ff d0                	call   *%eax
  8006d7:	83 c4 10             	add    $0x10,%esp
			break;
  8006da:	e9 9b 02 00 00       	jmp    80097a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	83 c0 04             	add    $0x4,%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	83 e8 04             	sub    $0x4,%eax
  8006ee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006f0:	85 db                	test   %ebx,%ebx
  8006f2:	79 02                	jns    8006f6 <vprintfmt+0x14a>
				err = -err;
  8006f4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006f6:	83 fb 64             	cmp    $0x64,%ebx
  8006f9:	7f 0b                	jg     800706 <vprintfmt+0x15a>
  8006fb:	8b 34 9d 00 1f 80 00 	mov    0x801f00(,%ebx,4),%esi
  800702:	85 f6                	test   %esi,%esi
  800704:	75 19                	jne    80071f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800706:	53                   	push   %ebx
  800707:	68 a5 20 80 00       	push   $0x8020a5
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	ff 75 08             	pushl  0x8(%ebp)
  800712:	e8 70 02 00 00       	call   800987 <printfmt>
  800717:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80071a:	e9 5b 02 00 00       	jmp    80097a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80071f:	56                   	push   %esi
  800720:	68 ae 20 80 00       	push   $0x8020ae
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	ff 75 08             	pushl  0x8(%ebp)
  80072b:	e8 57 02 00 00       	call   800987 <printfmt>
  800730:	83 c4 10             	add    $0x10,%esp
			break;
  800733:	e9 42 02 00 00       	jmp    80097a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	83 c0 04             	add    $0x4,%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	83 e8 04             	sub    $0x4,%eax
  800747:	8b 30                	mov    (%eax),%esi
  800749:	85 f6                	test   %esi,%esi
  80074b:	75 05                	jne    800752 <vprintfmt+0x1a6>
				p = "(null)";
  80074d:	be b1 20 80 00       	mov    $0x8020b1,%esi
			if (width > 0 && padc != '-')
  800752:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800756:	7e 6d                	jle    8007c5 <vprintfmt+0x219>
  800758:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80075c:	74 67                	je     8007c5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80075e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	50                   	push   %eax
  800765:	56                   	push   %esi
  800766:	e8 26 05 00 00       	call   800c91 <strnlen>
  80076b:	83 c4 10             	add    $0x10,%esp
  80076e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800771:	eb 16                	jmp    800789 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800773:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 0c             	pushl  0xc(%ebp)
  80077d:	50                   	push   %eax
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	ff d0                	call   *%eax
  800783:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800786:	ff 4d e4             	decl   -0x1c(%ebp)
  800789:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80078d:	7f e4                	jg     800773 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80078f:	eb 34                	jmp    8007c5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800791:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800795:	74 1c                	je     8007b3 <vprintfmt+0x207>
  800797:	83 fb 1f             	cmp    $0x1f,%ebx
  80079a:	7e 05                	jle    8007a1 <vprintfmt+0x1f5>
  80079c:	83 fb 7e             	cmp    $0x7e,%ebx
  80079f:	7e 12                	jle    8007b3 <vprintfmt+0x207>
					putch('?', putdat);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	6a 3f                	push   $0x3f
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	ff d0                	call   *%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	eb 0f                	jmp    8007c2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	53                   	push   %ebx
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	ff d0                	call   *%eax
  8007bf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c2:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c5:	89 f0                	mov    %esi,%eax
  8007c7:	8d 70 01             	lea    0x1(%eax),%esi
  8007ca:	8a 00                	mov    (%eax),%al
  8007cc:	0f be d8             	movsbl %al,%ebx
  8007cf:	85 db                	test   %ebx,%ebx
  8007d1:	74 24                	je     8007f7 <vprintfmt+0x24b>
  8007d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007d7:	78 b8                	js     800791 <vprintfmt+0x1e5>
  8007d9:	ff 4d e0             	decl   -0x20(%ebp)
  8007dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007e0:	79 af                	jns    800791 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007e2:	eb 13                	jmp    8007f7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ea:	6a 20                	push   $0x20
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	ff d0                	call   *%eax
  8007f1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007f4:	ff 4d e4             	decl   -0x1c(%ebp)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fb:	7f e7                	jg     8007e4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007fd:	e9 78 01 00 00       	jmp    80097a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	ff 75 e8             	pushl  -0x18(%ebp)
  800808:	8d 45 14             	lea    0x14(%ebp),%eax
  80080b:	50                   	push   %eax
  80080c:	e8 3c fd ff ff       	call   80054d <getint>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800817:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80081a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800820:	85 d2                	test   %edx,%edx
  800822:	79 23                	jns    800847 <vprintfmt+0x29b>
				putch('-', putdat);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	6a 2d                	push   $0x2d
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	ff d0                	call   *%eax
  800831:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800837:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80083a:	f7 d8                	neg    %eax
  80083c:	83 d2 00             	adc    $0x0,%edx
  80083f:	f7 da                	neg    %edx
  800841:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800844:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800847:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80084e:	e9 bc 00 00 00       	jmp    80090f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	ff 75 e8             	pushl  -0x18(%ebp)
  800859:	8d 45 14             	lea    0x14(%ebp),%eax
  80085c:	50                   	push   %eax
  80085d:	e8 84 fc ff ff       	call   8004e6 <getuint>
  800862:	83 c4 10             	add    $0x10,%esp
  800865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800868:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80086b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800872:	e9 98 00 00 00       	jmp    80090f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	6a 58                	push   $0x58
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	ff d0                	call   *%eax
  800884:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	ff 75 0c             	pushl  0xc(%ebp)
  80088d:	6a 58                	push   $0x58
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	ff d0                	call   *%eax
  800894:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	6a 58                	push   $0x58
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	ff d0                	call   *%eax
  8008a4:	83 c4 10             	add    $0x10,%esp
			break;
  8008a7:	e9 ce 00 00 00       	jmp    80097a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	6a 30                	push   $0x30
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008bc:	83 ec 08             	sub    $0x8,%esp
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	6a 78                	push   $0x78
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	ff d0                	call   *%eax
  8008c9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	83 c0 04             	add    $0x4,%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	83 e8 04             	sub    $0x4,%eax
  8008db:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008e7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008ee:	eb 1f                	jmp    80090f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f6:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f9:	50                   	push   %eax
  8008fa:	e8 e7 fb ff ff       	call   8004e6 <getuint>
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800905:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800908:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80090f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800916:	83 ec 04             	sub    $0x4,%esp
  800919:	52                   	push   %edx
  80091a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80091d:	50                   	push   %eax
  80091e:	ff 75 f4             	pushl  -0xc(%ebp)
  800921:	ff 75 f0             	pushl  -0x10(%ebp)
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	ff 75 08             	pushl  0x8(%ebp)
  80092a:	e8 00 fb ff ff       	call   80042f <printnum>
  80092f:	83 c4 20             	add    $0x20,%esp
			break;
  800932:	eb 46                	jmp    80097a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	53                   	push   %ebx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	ff d0                	call   *%eax
  800940:	83 c4 10             	add    $0x10,%esp
			break;
  800943:	eb 35                	jmp    80097a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800945:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  80094c:	eb 2c                	jmp    80097a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80094e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800955:	eb 23                	jmp    80097a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800957:	83 ec 08             	sub    $0x8,%esp
  80095a:	ff 75 0c             	pushl  0xc(%ebp)
  80095d:	6a 25                	push   $0x25
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	ff d0                	call   *%eax
  800964:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800967:	ff 4d 10             	decl   0x10(%ebp)
  80096a:	eb 03                	jmp    80096f <vprintfmt+0x3c3>
  80096c:	ff 4d 10             	decl   0x10(%ebp)
  80096f:	8b 45 10             	mov    0x10(%ebp),%eax
  800972:	48                   	dec    %eax
  800973:	8a 00                	mov    (%eax),%al
  800975:	3c 25                	cmp    $0x25,%al
  800977:	75 f3                	jne    80096c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800979:	90                   	nop
		}
	}
  80097a:	e9 35 fc ff ff       	jmp    8005b4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80097f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800980:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800983:	5b                   	pop    %ebx
  800984:	5e                   	pop    %esi
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80098d:	8d 45 10             	lea    0x10(%ebp),%eax
  800990:	83 c0 04             	add    $0x4,%eax
  800993:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800996:	8b 45 10             	mov    0x10(%ebp),%eax
  800999:	ff 75 f4             	pushl  -0xc(%ebp)
  80099c:	50                   	push   %eax
  80099d:	ff 75 0c             	pushl  0xc(%ebp)
  8009a0:	ff 75 08             	pushl  0x8(%ebp)
  8009a3:	e8 04 fc ff ff       	call   8005ac <vprintfmt>
  8009a8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009ab:	90                   	nop
  8009ac:	c9                   	leave  
  8009ad:	c3                   	ret    

008009ae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b4:	8b 40 08             	mov    0x8(%eax),%eax
  8009b7:	8d 50 01             	lea    0x1(%eax),%edx
  8009ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	8b 10                	mov    (%eax),%edx
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	8b 40 04             	mov    0x4(%eax),%eax
  8009cb:	39 c2                	cmp    %eax,%edx
  8009cd:	73 12                	jae    8009e1 <sprintputch+0x33>
		*b->buf++ = ch;
  8009cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8009d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009da:	89 0a                	mov    %ecx,(%edx)
  8009dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8009df:	88 10                	mov    %dl,(%eax)
}
  8009e1:	90                   	nop
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	01 d0                	add    %edx,%eax
  8009fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a09:	74 06                	je     800a11 <vsnprintf+0x2d>
  800a0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a0f:	7f 07                	jg     800a18 <vsnprintf+0x34>
		return -E_INVAL;
  800a11:	b8 03 00 00 00       	mov    $0x3,%eax
  800a16:	eb 20                	jmp    800a38 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a18:	ff 75 14             	pushl  0x14(%ebp)
  800a1b:	ff 75 10             	pushl  0x10(%ebp)
  800a1e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a21:	50                   	push   %eax
  800a22:	68 ae 09 80 00       	push   $0x8009ae
  800a27:	e8 80 fb ff ff       	call   8005ac <vprintfmt>
  800a2c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a32:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a40:	8d 45 10             	lea    0x10(%ebp),%eax
  800a43:	83 c0 04             	add    $0x4,%eax
  800a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a49:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4f:	50                   	push   %eax
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	ff 75 08             	pushl  0x8(%ebp)
  800a56:	e8 89 ff ff ff       	call   8009e4 <vsnprintf>
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a64:	c9                   	leave  
  800a65:	c3                   	ret    

00800a66 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a70:	74 13                	je     800a85 <readline+0x1f>
		cprintf("%s", prompt);
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	ff 75 08             	pushl  0x8(%ebp)
  800a78:	68 28 22 80 00       	push   $0x802228
  800a7d:	e8 0b f9 ff ff       	call   80038d <cprintf>
  800a82:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a8c:	83 ec 0c             	sub    $0xc,%esp
  800a8f:	6a 00                	push   $0x0
  800a91:	e8 c1 0f 00 00       	call   801a57 <iscons>
  800a96:	83 c4 10             	add    $0x10,%esp
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a9c:	e8 a3 0f 00 00       	call   801a44 <getchar>
  800aa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800aa4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aa8:	79 22                	jns    800acc <readline+0x66>
			if (c != -E_EOF)
  800aaa:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800aae:	0f 84 ad 00 00 00    	je     800b61 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 ec             	pushl  -0x14(%ebp)
  800aba:	68 2b 22 80 00       	push   $0x80222b
  800abf:	e8 c9 f8 ff ff       	call   80038d <cprintf>
  800ac4:	83 c4 10             	add    $0x10,%esp
			break;
  800ac7:	e9 95 00 00 00       	jmp    800b61 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800acc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ad0:	7e 34                	jle    800b06 <readline+0xa0>
  800ad2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ad9:	7f 2b                	jg     800b06 <readline+0xa0>
			if (echoing)
  800adb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800adf:	74 0e                	je     800aef <readline+0x89>
				cputchar(c);
  800ae1:	83 ec 0c             	sub    $0xc,%esp
  800ae4:	ff 75 ec             	pushl  -0x14(%ebp)
  800ae7:	e8 39 0f 00 00       	call   801a25 <cputchar>
  800aec:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af2:	8d 50 01             	lea    0x1(%eax),%edx
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	01 d0                	add    %edx,%eax
  800aff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b02:	88 10                	mov    %dl,(%eax)
  800b04:	eb 56                	jmp    800b5c <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800b06:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b0a:	75 1f                	jne    800b2b <readline+0xc5>
  800b0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b10:	7e 19                	jle    800b2b <readline+0xc5>
			if (echoing)
  800b12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b16:	74 0e                	je     800b26 <readline+0xc0>
				cputchar(c);
  800b18:	83 ec 0c             	sub    $0xc,%esp
  800b1b:	ff 75 ec             	pushl  -0x14(%ebp)
  800b1e:	e8 02 0f 00 00       	call   801a25 <cputchar>
  800b23:	83 c4 10             	add    $0x10,%esp

			i--;
  800b26:	ff 4d f4             	decl   -0xc(%ebp)
  800b29:	eb 31                	jmp    800b5c <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b2b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b2f:	74 0a                	je     800b3b <readline+0xd5>
  800b31:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b35:	0f 85 61 ff ff ff    	jne    800a9c <readline+0x36>
			if (echoing)
  800b3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b3f:	74 0e                	je     800b4f <readline+0xe9>
				cputchar(c);
  800b41:	83 ec 0c             	sub    $0xc,%esp
  800b44:	ff 75 ec             	pushl  -0x14(%ebp)
  800b47:	e8 d9 0e 00 00       	call   801a25 <cputchar>
  800b4c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	01 d0                	add    %edx,%eax
  800b57:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b5a:	eb 06                	jmp    800b62 <readline+0xfc>
		}
	}
  800b5c:	e9 3b ff ff ff       	jmp    800a9c <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b61:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b62:	90                   	nop
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b6b:	e8 79 09 00 00       	call   8014e9 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b74:	74 13                	je     800b89 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	ff 75 08             	pushl  0x8(%ebp)
  800b7c:	68 28 22 80 00       	push   $0x802228
  800b81:	e8 07 f8 ff ff       	call   80038d <cprintf>
  800b86:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b90:	83 ec 0c             	sub    $0xc,%esp
  800b93:	6a 00                	push   $0x0
  800b95:	e8 bd 0e 00 00       	call   801a57 <iscons>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800ba0:	e8 9f 0e 00 00       	call   801a44 <getchar>
  800ba5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800ba8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800bac:	79 22                	jns    800bd0 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800bae:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800bb2:	0f 84 ad 00 00 00    	je     800c65 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 ec             	pushl  -0x14(%ebp)
  800bbe:	68 2b 22 80 00       	push   $0x80222b
  800bc3:	e8 c5 f7 ff ff       	call   80038d <cprintf>
  800bc8:	83 c4 10             	add    $0x10,%esp
				break;
  800bcb:	e9 95 00 00 00       	jmp    800c65 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bd0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800bd4:	7e 34                	jle    800c0a <atomic_readline+0xa5>
  800bd6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800bdd:	7f 2b                	jg     800c0a <atomic_readline+0xa5>
				if (echoing)
  800bdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800be3:	74 0e                	je     800bf3 <atomic_readline+0x8e>
					cputchar(c);
  800be5:	83 ec 0c             	sub    $0xc,%esp
  800be8:	ff 75 ec             	pushl  -0x14(%ebp)
  800beb:	e8 35 0e 00 00       	call   801a25 <cputchar>
  800bf0:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf6:	8d 50 01             	lea    0x1(%eax),%edx
  800bf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bfc:	89 c2                	mov    %eax,%edx
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	01 d0                	add    %edx,%eax
  800c03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c06:	88 10                	mov    %dl,(%eax)
  800c08:	eb 56                	jmp    800c60 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800c0a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c0e:	75 1f                	jne    800c2f <atomic_readline+0xca>
  800c10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c14:	7e 19                	jle    800c2f <atomic_readline+0xca>
				if (echoing)
  800c16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c1a:	74 0e                	je     800c2a <atomic_readline+0xc5>
					cputchar(c);
  800c1c:	83 ec 0c             	sub    $0xc,%esp
  800c1f:	ff 75 ec             	pushl  -0x14(%ebp)
  800c22:	e8 fe 0d 00 00       	call   801a25 <cputchar>
  800c27:	83 c4 10             	add    $0x10,%esp
				i--;
  800c2a:	ff 4d f4             	decl   -0xc(%ebp)
  800c2d:	eb 31                	jmp    800c60 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c2f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c33:	74 0a                	je     800c3f <atomic_readline+0xda>
  800c35:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c39:	0f 85 61 ff ff ff    	jne    800ba0 <atomic_readline+0x3b>
				if (echoing)
  800c3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c43:	74 0e                	je     800c53 <atomic_readline+0xee>
					cputchar(c);
  800c45:	83 ec 0c             	sub    $0xc,%esp
  800c48:	ff 75 ec             	pushl  -0x14(%ebp)
  800c4b:	e8 d5 0d 00 00       	call   801a25 <cputchar>
  800c50:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c5e:	eb 06                	jmp    800c66 <atomic_readline+0x101>
			}
		}
  800c60:	e9 3b ff ff ff       	jmp    800ba0 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c65:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c66:	e8 98 08 00 00       	call   801503 <sys_unlock_cons>
}
  800c6b:	90                   	nop
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7b:	eb 06                	jmp    800c83 <strlen+0x15>
		n++;
  800c7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c80:	ff 45 08             	incl   0x8(%ebp)
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	84 c0                	test   %al,%al
  800c8a:	75 f1                	jne    800c7d <strlen+0xf>
		n++;
	return n;
  800c8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9e:	eb 09                	jmp    800ca9 <strnlen+0x18>
		n++;
  800ca0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca3:	ff 45 08             	incl   0x8(%ebp)
  800ca6:	ff 4d 0c             	decl   0xc(%ebp)
  800ca9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cad:	74 09                	je     800cb8 <strnlen+0x27>
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	84 c0                	test   %al,%al
  800cb6:	75 e8                	jne    800ca0 <strnlen+0xf>
		n++;
	return n;
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc9:	90                   	nop
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8d 50 01             	lea    0x1(%eax),%edx
  800cd0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cdc:	8a 12                	mov    (%edx),%dl
  800cde:	88 10                	mov    %dl,(%eax)
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	75 e4                	jne    800cca <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce9:	c9                   	leave  
  800cea:	c3                   	ret    

00800ceb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfe:	eb 1f                	jmp    800d1f <strncpy+0x34>
		*dst++ = *src;
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 08             	mov    %edx,0x8(%ebp)
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	8a 12                	mov    (%edx),%dl
  800d0e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	74 03                	je     800d1c <strncpy+0x31>
			src++;
  800d19:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d1c:	ff 45 fc             	incl   -0x4(%ebp)
  800d1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d22:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d25:	72 d9                	jb     800d00 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d2a:	c9                   	leave  
  800d2b:	c3                   	ret    

00800d2c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3c:	74 30                	je     800d6e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d3e:	eb 16                	jmp    800d56 <strlcpy+0x2a>
			*dst++ = *src++;
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8d 50 01             	lea    0x1(%eax),%edx
  800d46:	89 55 08             	mov    %edx,0x8(%ebp)
  800d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d52:	8a 12                	mov    (%edx),%dl
  800d54:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d56:	ff 4d 10             	decl   0x10(%ebp)
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 09                	je     800d68 <strlcpy+0x3c>
  800d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 d8                	jne    800d40 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d74:	29 c2                	sub    %eax,%edx
  800d76:	89 d0                	mov    %edx,%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d7d:	eb 06                	jmp    800d85 <strcmp+0xb>
		p++, q++;
  800d7f:	ff 45 08             	incl   0x8(%ebp)
  800d82:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	84 c0                	test   %al,%al
  800d8c:	74 0e                	je     800d9c <strcmp+0x22>
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8a 10                	mov    (%eax),%dl
  800d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	38 c2                	cmp    %al,%dl
  800d9a:	74 e3                	je     800d7f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8a 00                	mov    (%eax),%al
  800da1:	0f b6 d0             	movzbl %al,%edx
  800da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	0f b6 c0             	movzbl %al,%eax
  800dac:	29 c2                	sub    %eax,%edx
  800dae:	89 d0                	mov    %edx,%eax
}
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    

00800db2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db5:	eb 09                	jmp    800dc0 <strncmp+0xe>
		n--, p++, q++;
  800db7:	ff 4d 10             	decl   0x10(%ebp)
  800dba:	ff 45 08             	incl   0x8(%ebp)
  800dbd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc4:	74 17                	je     800ddd <strncmp+0x2b>
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	84 c0                	test   %al,%al
  800dcd:	74 0e                	je     800ddd <strncmp+0x2b>
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8a 10                	mov    (%eax),%dl
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	38 c2                	cmp    %al,%dl
  800ddb:	74 da                	je     800db7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ddd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de1:	75 07                	jne    800dea <strncmp+0x38>
		return 0;
  800de3:	b8 00 00 00 00       	mov    $0x0,%eax
  800de8:	eb 14                	jmp    800dfe <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f b6 d0             	movzbl %al,%edx
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	0f b6 c0             	movzbl %al,%eax
  800dfa:	29 c2                	sub    %eax,%edx
  800dfc:	89 d0                	mov    %edx,%eax
}
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 04             	sub    $0x4,%esp
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e0c:	eb 12                	jmp    800e20 <strchr+0x20>
		if (*s == c)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e16:	75 05                	jne    800e1d <strchr+0x1d>
			return (char *) s;
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	eb 11                	jmp    800e2e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e1d:	ff 45 08             	incl   0x8(%ebp)
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	84 c0                	test   %al,%al
  800e27:	75 e5                	jne    800e0e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 04             	sub    $0x4,%esp
  800e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e39:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3c:	eb 0d                	jmp    800e4b <strfind+0x1b>
		if (*s == c)
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e46:	74 0e                	je     800e56 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e48:	ff 45 08             	incl   0x8(%ebp)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	84 c0                	test   %al,%al
  800e52:	75 ea                	jne    800e3e <strfind+0xe>
  800e54:	eb 01                	jmp    800e57 <strfind+0x27>
		if (*s == c)
			break;
  800e56:	90                   	nop
	return (char *) s;
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5a:	c9                   	leave  
  800e5b:	c3                   	ret    

00800e5c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e68:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e6c:	76 63                	jbe    800ed1 <memset+0x75>
		uint64 data_block = c;
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	99                   	cltd   
  800e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e75:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e82:	c1 e0 08             	shl    $0x8,%eax
  800e85:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e88:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e91:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e95:	c1 e0 10             	shl    $0x10,%eax
  800e98:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e9b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea4:	89 c2                	mov    %eax,%edx
  800ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  800eab:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eae:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800eb1:	eb 18                	jmp    800ecb <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800eb3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eb6:	8d 41 08             	lea    0x8(%ecx),%eax
  800eb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec2:	89 01                	mov    %eax,(%ecx)
  800ec4:	89 51 04             	mov    %edx,0x4(%ecx)
  800ec7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ecb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ecf:	77 e2                	ja     800eb3 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ed1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed5:	74 23                	je     800efa <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eda:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800edd:	eb 0e                	jmp    800eed <memset+0x91>
			*p8++ = (uint8)c;
  800edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eeb:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800eed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	75 e5                	jne    800edf <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f11:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f15:	76 24                	jbe    800f3b <memcpy+0x3c>
		while(n >= 8){
  800f17:	eb 1c                	jmp    800f35 <memcpy+0x36>
			*d64 = *s64;
  800f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1c:	8b 50 04             	mov    0x4(%eax),%edx
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f24:	89 01                	mov    %eax,(%ecx)
  800f26:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f29:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f2d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f31:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f35:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f39:	77 de                	ja     800f19 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3f:	74 31                	je     800f72 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f4d:	eb 16                	jmp    800f65 <memcpy+0x66>
			*d8++ = *s8++;
  800f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f52:	8d 50 01             	lea    0x1(%eax),%edx
  800f55:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f61:	8a 12                	mov    (%edx),%dl
  800f63:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	75 dd                	jne    800f4f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    

00800f77 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f8f:	73 50                	jae    800fe1 <memmove+0x6a>
  800f91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f94:	8b 45 10             	mov    0x10(%ebp),%eax
  800f97:	01 d0                	add    %edx,%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	76 43                	jbe    800fe1 <memmove+0x6a>
		s += n;
  800f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800faa:	eb 10                	jmp    800fbc <memmove+0x45>
			*--d = *--s;
  800fac:	ff 4d f8             	decl   -0x8(%ebp)
  800faf:	ff 4d fc             	decl   -0x4(%ebp)
  800fb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb5:	8a 10                	mov    (%eax),%dl
  800fb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fba:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	75 e3                	jne    800fac <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fc9:	eb 23                	jmp    800fee <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fce:	8d 50 01             	lea    0x1(%eax),%edx
  800fd1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fda:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fdd:	8a 12                	mov    (%edx),%dl
  800fdf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fea:	85 c0                	test   %eax,%eax
  800fec:	75 dd                	jne    800fcb <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801002:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801005:	eb 2a                	jmp    801031 <memcmp+0x3e>
		if (*s1 != *s2)
  801007:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100a:	8a 10                	mov    (%eax),%dl
  80100c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	38 c2                	cmp    %al,%dl
  801013:	74 16                	je     80102b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801015:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	0f b6 d0             	movzbl %al,%edx
  80101d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	0f b6 c0             	movzbl %al,%eax
  801025:	29 c2                	sub    %eax,%edx
  801027:	89 d0                	mov    %edx,%eax
  801029:	eb 18                	jmp    801043 <memcmp+0x50>
		s1++, s2++;
  80102b:	ff 45 fc             	incl   -0x4(%ebp)
  80102e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801031:	8b 45 10             	mov    0x10(%ebp),%eax
  801034:	8d 50 ff             	lea    -0x1(%eax),%edx
  801037:	89 55 10             	mov    %edx,0x10(%ebp)
  80103a:	85 c0                	test   %eax,%eax
  80103c:	75 c9                	jne    801007 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80103e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801043:	c9                   	leave  
  801044:	c3                   	ret    

00801045 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80104b:	8b 55 08             	mov    0x8(%ebp),%edx
  80104e:	8b 45 10             	mov    0x10(%ebp),%eax
  801051:	01 d0                	add    %edx,%eax
  801053:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801056:	eb 15                	jmp    80106d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	0f b6 d0             	movzbl %al,%edx
  801060:	8b 45 0c             	mov    0xc(%ebp),%eax
  801063:	0f b6 c0             	movzbl %al,%eax
  801066:	39 c2                	cmp    %eax,%edx
  801068:	74 0d                	je     801077 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80106a:	ff 45 08             	incl   0x8(%ebp)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801073:	72 e3                	jb     801058 <memfind+0x13>
  801075:	eb 01                	jmp    801078 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801077:	90                   	nop
	return (void *) s;
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801083:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80108a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801091:	eb 03                	jmp    801096 <strtol+0x19>
		s++;
  801093:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 20                	cmp    $0x20,%al
  80109d:	74 f4                	je     801093 <strtol+0x16>
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	3c 09                	cmp    $0x9,%al
  8010a6:	74 eb                	je     801093 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	3c 2b                	cmp    $0x2b,%al
  8010af:	75 05                	jne    8010b6 <strtol+0x39>
		s++;
  8010b1:	ff 45 08             	incl   0x8(%ebp)
  8010b4:	eb 13                	jmp    8010c9 <strtol+0x4c>
	else if (*s == '-')
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	3c 2d                	cmp    $0x2d,%al
  8010bd:	75 0a                	jne    8010c9 <strtol+0x4c>
		s++, neg = 1;
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cd:	74 06                	je     8010d5 <strtol+0x58>
  8010cf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010d3:	75 20                	jne    8010f5 <strtol+0x78>
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	3c 30                	cmp    $0x30,%al
  8010dc:	75 17                	jne    8010f5 <strtol+0x78>
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	40                   	inc    %eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	3c 78                	cmp    $0x78,%al
  8010e6:	75 0d                	jne    8010f5 <strtol+0x78>
		s += 2, base = 16;
  8010e8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010ec:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010f3:	eb 28                	jmp    80111d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f9:	75 15                	jne    801110 <strtol+0x93>
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 30                	cmp    $0x30,%al
  801102:	75 0c                	jne    801110 <strtol+0x93>
		s++, base = 8;
  801104:	ff 45 08             	incl   0x8(%ebp)
  801107:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80110e:	eb 0d                	jmp    80111d <strtol+0xa0>
	else if (base == 0)
  801110:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801114:	75 07                	jne    80111d <strtol+0xa0>
		base = 10;
  801116:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	3c 2f                	cmp    $0x2f,%al
  801124:	7e 19                	jle    80113f <strtol+0xc2>
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 39                	cmp    $0x39,%al
  80112d:	7f 10                	jg     80113f <strtol+0xc2>
			dig = *s - '0';
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	0f be c0             	movsbl %al,%eax
  801137:	83 e8 30             	sub    $0x30,%eax
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80113d:	eb 42                	jmp    801181 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	3c 60                	cmp    $0x60,%al
  801146:	7e 19                	jle    801161 <strtol+0xe4>
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 7a                	cmp    $0x7a,%al
  80114f:	7f 10                	jg     801161 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	0f be c0             	movsbl %al,%eax
  801159:	83 e8 57             	sub    $0x57,%eax
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115f:	eb 20                	jmp    801181 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	3c 40                	cmp    $0x40,%al
  801168:	7e 39                	jle    8011a3 <strtol+0x126>
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 5a                	cmp    $0x5a,%al
  801171:	7f 30                	jg     8011a3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	0f be c0             	movsbl %al,%eax
  80117b:	83 e8 37             	sub    $0x37,%eax
  80117e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801184:	3b 45 10             	cmp    0x10(%ebp),%eax
  801187:	7d 19                	jge    8011a2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801189:	ff 45 08             	incl   0x8(%ebp)
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801193:	89 c2                	mov    %eax,%edx
  801195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801198:	01 d0                	add    %edx,%eax
  80119a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80119d:	e9 7b ff ff ff       	jmp    80111d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011a2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a7:	74 08                	je     8011b1 <strtol+0x134>
		*endptr = (char *) s;
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8011af:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b5:	74 07                	je     8011be <strtol+0x141>
  8011b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ba:	f7 d8                	neg    %eax
  8011bc:	eb 03                	jmp    8011c1 <strtol+0x144>
  8011be:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

008011c3 <ltostr>:

void
ltostr(long value, char *str)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011db:	79 13                	jns    8011f0 <ltostr+0x2d>
	{
		neg = 1;
  8011dd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ea:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011ed:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011f8:	99                   	cltd   
  8011f9:	f7 f9                	idiv   %ecx
  8011fb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801201:	8d 50 01             	lea    0x1(%eax),%edx
  801204:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801207:	89 c2                	mov    %eax,%edx
  801209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120c:	01 d0                	add    %edx,%eax
  80120e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801211:	83 c2 30             	add    $0x30,%edx
  801214:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801216:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801219:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80121e:	f7 e9                	imul   %ecx
  801220:	c1 fa 02             	sar    $0x2,%edx
  801223:	89 c8                	mov    %ecx,%eax
  801225:	c1 f8 1f             	sar    $0x1f,%eax
  801228:	29 c2                	sub    %eax,%edx
  80122a:	89 d0                	mov    %edx,%eax
  80122c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80122f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801233:	75 bb                	jne    8011f0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80123c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123f:	48                   	dec    %eax
  801240:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801243:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801247:	74 3d                	je     801286 <ltostr+0xc3>
		start = 1 ;
  801249:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801250:	eb 34                	jmp    801286 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80125f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	01 c2                	add    %eax,%edx
  801267:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80126a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126d:	01 c8                	add    %ecx,%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801273:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	01 c2                	add    %eax,%edx
  80127b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80127e:	88 02                	mov    %al,(%edx)
		start++ ;
  801280:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801283:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801289:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80128c:	7c c4                	jl     801252 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80128e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	01 d0                	add    %edx,%eax
  801296:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012a2:	ff 75 08             	pushl  0x8(%ebp)
  8012a5:	e8 c4 f9 ff ff       	call   800c6e <strlen>
  8012aa:	83 c4 04             	add    $0x4,%esp
  8012ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012b0:	ff 75 0c             	pushl  0xc(%ebp)
  8012b3:	e8 b6 f9 ff ff       	call   800c6e <strlen>
  8012b8:	83 c4 04             	add    $0x4,%esp
  8012bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012cc:	eb 17                	jmp    8012e5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d4:	01 c2                	add    %eax,%edx
  8012d6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	01 c8                	add    %ecx,%eax
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012e2:	ff 45 fc             	incl   -0x4(%ebp)
  8012e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012eb:	7c e1                	jl     8012ce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012fb:	eb 1f                	jmp    80131c <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	8d 50 01             	lea    0x1(%eax),%edx
  801303:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801306:	89 c2                	mov    %eax,%edx
  801308:	8b 45 10             	mov    0x10(%ebp),%eax
  80130b:	01 c2                	add    %eax,%edx
  80130d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801310:	8b 45 0c             	mov    0xc(%ebp),%eax
  801313:	01 c8                	add    %ecx,%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801319:	ff 45 f8             	incl   -0x8(%ebp)
  80131c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801322:	7c d9                	jl     8012fd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801324:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	01 d0                	add    %edx,%eax
  80132c:	c6 00 00             	movb   $0x0,(%eax)
}
  80132f:	90                   	nop
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80133e:	8b 45 14             	mov    0x14(%ebp),%eax
  801341:	8b 00                	mov    (%eax),%eax
  801343:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80134a:	8b 45 10             	mov    0x10(%ebp),%eax
  80134d:	01 d0                	add    %edx,%eax
  80134f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801355:	eb 0c                	jmp    801363 <strsplit+0x31>
			*string++ = 0;
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8d 50 01             	lea    0x1(%eax),%edx
  80135d:	89 55 08             	mov    %edx,0x8(%ebp)
  801360:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	84 c0                	test   %al,%al
  80136a:	74 18                	je     801384 <strsplit+0x52>
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f be c0             	movsbl %al,%eax
  801374:	50                   	push   %eax
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	e8 83 fa ff ff       	call   800e00 <strchr>
  80137d:	83 c4 08             	add    $0x8,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	75 d3                	jne    801357 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	84 c0                	test   %al,%al
  80138b:	74 5a                	je     8013e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80138d:	8b 45 14             	mov    0x14(%ebp),%eax
  801390:	8b 00                	mov    (%eax),%eax
  801392:	83 f8 0f             	cmp    $0xf,%eax
  801395:	75 07                	jne    80139e <strsplit+0x6c>
		{
			return 0;
  801397:	b8 00 00 00 00       	mov    $0x0,%eax
  80139c:	eb 66                	jmp    801404 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80139e:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a1:	8b 00                	mov    (%eax),%eax
  8013a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8013a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8013a9:	89 0a                	mov    %ecx,(%edx)
  8013ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b5:	01 c2                	add    %eax,%edx
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013bc:	eb 03                	jmp    8013c1 <strsplit+0x8f>
			string++;
  8013be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	84 c0                	test   %al,%al
  8013c8:	74 8b                	je     801355 <strsplit+0x23>
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f be c0             	movsbl %al,%eax
  8013d2:	50                   	push   %eax
  8013d3:	ff 75 0c             	pushl  0xc(%ebp)
  8013d6:	e8 25 fa ff ff       	call   800e00 <strchr>
  8013db:	83 c4 08             	add    $0x8,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	74 dc                	je     8013be <strsplit+0x8c>
			string++;
	}
  8013e2:	e9 6e ff ff ff       	jmp    801355 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013eb:	8b 00                	mov    (%eax),%eax
  8013ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f7:	01 d0                	add    %edx,%eax
  8013f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801412:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801419:	eb 4a                	jmp    801465 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80141b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	01 c2                	add    %eax,%edx
  801423:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	01 c8                	add    %ecx,%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80142f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801432:	8b 45 0c             	mov    0xc(%ebp),%eax
  801435:	01 d0                	add    %edx,%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	3c 40                	cmp    $0x40,%al
  80143b:	7e 25                	jle    801462 <str2lower+0x5c>
  80143d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	01 d0                	add    %edx,%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 5a                	cmp    $0x5a,%al
  801449:	7f 17                	jg     801462 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80144b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	01 d0                	add    %edx,%eax
  801453:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801456:	8b 55 08             	mov    0x8(%ebp),%edx
  801459:	01 ca                	add    %ecx,%edx
  80145b:	8a 12                	mov    (%edx),%dl
  80145d:	83 c2 20             	add    $0x20,%edx
  801460:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801462:	ff 45 fc             	incl   -0x4(%ebp)
  801465:	ff 75 0c             	pushl  0xc(%ebp)
  801468:	e8 01 f8 ff ff       	call   800c6e <strlen>
  80146d:	83 c4 04             	add    $0x4,%esp
  801470:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801473:	7f a6                	jg     80141b <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801475:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	57                   	push   %edi
  80147e:	56                   	push   %esi
  80147f:	53                   	push   %ebx
  801480:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80148c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80148f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801492:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801495:	cd 30                	int    $0x30
  801497:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80149a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	5b                   	pop    %ebx
  8014a1:	5e                   	pop    %esi
  8014a2:	5f                   	pop    %edi
  8014a3:	5d                   	pop    %ebp
  8014a4:	c3                   	ret    

008014a5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 04             	sub    $0x4,%esp
  8014ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014b4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	6a 00                	push   $0x0
  8014bd:	51                   	push   %ecx
  8014be:	52                   	push   %edx
  8014bf:	ff 75 0c             	pushl  0xc(%ebp)
  8014c2:	50                   	push   %eax
  8014c3:	6a 00                	push   $0x0
  8014c5:	e8 b0 ff ff ff       	call   80147a <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
}
  8014cd:	90                   	nop
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 02                	push   $0x2
  8014df:	e8 96 ff ff ff       	call   80147a <syscall>
  8014e4:	83 c4 18             	add    $0x18,%esp
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 03                	push   $0x3
  8014f8:	e8 7d ff ff ff       	call   80147a <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
}
  801500:	90                   	nop
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 04                	push   $0x4
  801512:	e8 63 ff ff ff       	call   80147a <syscall>
  801517:	83 c4 18             	add    $0x18,%esp
}
  80151a:	90                   	nop
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801520:	8b 55 0c             	mov    0xc(%ebp),%edx
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	52                   	push   %edx
  80152d:	50                   	push   %eax
  80152e:	6a 08                	push   $0x8
  801530:	e8 45 ff ff ff       	call   80147a <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	56                   	push   %esi
  80153e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80153f:	8b 75 18             	mov    0x18(%ebp),%esi
  801542:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801545:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	56                   	push   %esi
  80154f:	53                   	push   %ebx
  801550:	51                   	push   %ecx
  801551:	52                   	push   %edx
  801552:	50                   	push   %eax
  801553:	6a 09                	push   $0x9
  801555:	e8 20 ff ff ff       	call   80147a <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
}
  80155d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801560:	5b                   	pop    %ebx
  801561:	5e                   	pop    %esi
  801562:	5d                   	pop    %ebp
  801563:	c3                   	ret    

00801564 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	6a 0a                	push   $0xa
  801574:	e8 01 ff ff ff       	call   80147a <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	ff 75 0c             	pushl  0xc(%ebp)
  80158a:	ff 75 08             	pushl  0x8(%ebp)
  80158d:	6a 0b                	push   $0xb
  80158f:	e8 e6 fe ff ff       	call   80147a <syscall>
  801594:	83 c4 18             	add    $0x18,%esp
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 0c                	push   $0xc
  8015a8:	e8 cd fe ff ff       	call   80147a <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 0d                	push   $0xd
  8015c1:	e8 b4 fe ff ff       	call   80147a <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 0e                	push   $0xe
  8015da:	e8 9b fe ff ff       	call   80147a <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 0f                	push   $0xf
  8015f3:	e8 82 fe ff ff       	call   80147a <syscall>
  8015f8:	83 c4 18             	add    $0x18,%esp
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	ff 75 08             	pushl  0x8(%ebp)
  80160b:	6a 10                	push   $0x10
  80160d:	e8 68 fe ff ff       	call   80147a <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 11                	push   $0x11
  801626:	e8 4f fe ff ff       	call   80147a <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
}
  80162e:	90                   	nop
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sys_cputc>:

void
sys_cputc(const char c)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 04             	sub    $0x4,%esp
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80163d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	50                   	push   %eax
  80164a:	6a 01                	push   $0x1
  80164c:	e8 29 fe ff ff       	call   80147a <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
}
  801654:	90                   	nop
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 14                	push   $0x14
  801666:	e8 0f fe ff ff       	call   80147a <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
}
  80166e:	90                   	nop
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 04             	sub    $0x4,%esp
  801677:	8b 45 10             	mov    0x10(%ebp),%eax
  80167a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80167d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801680:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	6a 00                	push   $0x0
  801689:	51                   	push   %ecx
  80168a:	52                   	push   %edx
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	50                   	push   %eax
  80168f:	6a 15                	push   $0x15
  801691:	e8 e4 fd ff ff       	call   80147a <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80169e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	52                   	push   %edx
  8016ab:	50                   	push   %eax
  8016ac:	6a 16                	push   $0x16
  8016ae:	e8 c7 fd ff ff       	call   80147a <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	51                   	push   %ecx
  8016c9:	52                   	push   %edx
  8016ca:	50                   	push   %eax
  8016cb:	6a 17                	push   $0x17
  8016cd:	e8 a8 fd ff ff       	call   80147a <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	52                   	push   %edx
  8016e7:	50                   	push   %eax
  8016e8:	6a 18                	push   $0x18
  8016ea:	e8 8b fd ff ff       	call   80147a <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	6a 00                	push   $0x0
  8016fc:	ff 75 14             	pushl  0x14(%ebp)
  8016ff:	ff 75 10             	pushl  0x10(%ebp)
  801702:	ff 75 0c             	pushl  0xc(%ebp)
  801705:	50                   	push   %eax
  801706:	6a 19                	push   $0x19
  801708:	e8 6d fd ff ff       	call   80147a <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	50                   	push   %eax
  801721:	6a 1a                	push   $0x1a
  801723:	e8 52 fd ff ff       	call   80147a <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	90                   	nop
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	50                   	push   %eax
  80173d:	6a 1b                	push   $0x1b
  80173f:	e8 36 fd ff ff       	call   80147a <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 05                	push   $0x5
  801758:	e8 1d fd ff ff       	call   80147a <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 06                	push   $0x6
  801771:	e8 04 fd ff ff       	call   80147a <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 07                	push   $0x7
  80178a:	e8 eb fc ff ff       	call   80147a <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_exit_env>:


void sys_exit_env(void)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 1c                	push   $0x1c
  8017a3:	e8 d2 fc ff ff       	call   80147a <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	90                   	nop
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017b4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017b7:	8d 50 04             	lea    0x4(%eax),%edx
  8017ba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	52                   	push   %edx
  8017c4:	50                   	push   %eax
  8017c5:	6a 1d                	push   $0x1d
  8017c7:	e8 ae fc ff ff       	call   80147a <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
	return result;
  8017cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d8:	89 01                	mov    %eax,(%ecx)
  8017da:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	c9                   	leave  
  8017e1:	c2 04 00             	ret    $0x4

008017e4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	ff 75 10             	pushl  0x10(%ebp)
  8017ee:	ff 75 0c             	pushl  0xc(%ebp)
  8017f1:	ff 75 08             	pushl  0x8(%ebp)
  8017f4:	6a 13                	push   $0x13
  8017f6:	e8 7f fc ff ff       	call   80147a <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fe:	90                   	nop
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_rcr2>:
uint32 sys_rcr2()
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 1e                	push   $0x1e
  801810:	e8 65 fc ff ff       	call   80147a <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801826:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	50                   	push   %eax
  801833:	6a 1f                	push   $0x1f
  801835:	e8 40 fc ff ff       	call   80147a <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
	return ;
  80183d:	90                   	nop
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <rsttst>:
void rsttst()
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 21                	push   $0x21
  80184f:	e8 26 fc ff ff       	call   80147a <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
	return ;
  801857:	90                   	nop
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	8b 45 14             	mov    0x14(%ebp),%eax
  801863:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801866:	8b 55 18             	mov    0x18(%ebp),%edx
  801869:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80186d:	52                   	push   %edx
  80186e:	50                   	push   %eax
  80186f:	ff 75 10             	pushl  0x10(%ebp)
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	ff 75 08             	pushl  0x8(%ebp)
  801878:	6a 20                	push   $0x20
  80187a:	e8 fb fb ff ff       	call   80147a <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
	return ;
  801882:	90                   	nop
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <chktst>:
void chktst(uint32 n)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	ff 75 08             	pushl  0x8(%ebp)
  801893:	6a 22                	push   $0x22
  801895:	e8 e0 fb ff ff       	call   80147a <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
	return ;
  80189d:	90                   	nop
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <inctst>:

void inctst()
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 23                	push   $0x23
  8018af:	e8 c6 fb ff ff       	call   80147a <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b7:	90                   	nop
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <gettst>:
uint32 gettst()
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 24                	push   $0x24
  8018c9:	e8 ac fb ff ff       	call   80147a <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 25                	push   $0x25
  8018e2:	e8 93 fb ff ff       	call   80147a <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
  8018ea:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018ef:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	ff 75 08             	pushl  0x8(%ebp)
  80190c:	6a 26                	push   $0x26
  80190e:	e8 67 fb ff ff       	call   80147a <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
	return ;
  801916:	90                   	nop
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80191d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801920:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801923:	8b 55 0c             	mov    0xc(%ebp),%edx
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	53                   	push   %ebx
  80192c:	51                   	push   %ecx
  80192d:	52                   	push   %edx
  80192e:	50                   	push   %eax
  80192f:	6a 27                	push   $0x27
  801931:	e8 44 fb ff ff       	call   80147a <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801941:	8b 55 0c             	mov    0xc(%ebp),%edx
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	52                   	push   %edx
  80194e:	50                   	push   %eax
  80194f:	6a 28                	push   $0x28
  801951:	e8 24 fb ff ff       	call   80147a <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80195e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801961:	8b 55 0c             	mov    0xc(%ebp),%edx
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	6a 00                	push   $0x0
  801969:	51                   	push   %ecx
  80196a:	ff 75 10             	pushl  0x10(%ebp)
  80196d:	52                   	push   %edx
  80196e:	50                   	push   %eax
  80196f:	6a 29                	push   $0x29
  801971:	e8 04 fb ff ff       	call   80147a <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	ff 75 10             	pushl  0x10(%ebp)
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	6a 12                	push   $0x12
  80198d:	e8 e8 fa ff ff       	call   80147a <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
	return ;
  801995:	90                   	nop
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80199b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	52                   	push   %edx
  8019a8:	50                   	push   %eax
  8019a9:	6a 2a                	push   $0x2a
  8019ab:	e8 ca fa ff ff       	call   80147a <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
	return;
  8019b3:	90                   	nop
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 2b                	push   $0x2b
  8019c5:	e8 b0 fa ff ff       	call   80147a <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	ff 75 08             	pushl  0x8(%ebp)
  8019de:	6a 2d                	push   $0x2d
  8019e0:	e8 95 fa ff ff       	call   80147a <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
	return;
  8019e8:	90                   	nop
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	ff 75 0c             	pushl  0xc(%ebp)
  8019f7:	ff 75 08             	pushl  0x8(%ebp)
  8019fa:	6a 2c                	push   $0x2c
  8019fc:	e8 79 fa ff ff       	call   80147a <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
	return ;
  801a04:	90                   	nop
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	52                   	push   %edx
  801a17:	50                   	push   %eax
  801a18:	6a 2e                	push   $0x2e
  801a1a:	e8 5b fa ff ff       	call   80147a <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
	    return;
  801a22:	90                   	nop
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a31:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a35:	83 ec 0c             	sub    $0xc,%esp
  801a38:	50                   	push   %eax
  801a39:	e8 f3 fb ff ff       	call   801631 <sys_cputc>
  801a3e:	83 c4 10             	add    $0x10,%esp
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <getchar>:


int
getchar(void)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801a4a:	e8 81 fa ff ff       	call   8014d0 <sys_cgetc>
  801a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <iscons>:

int iscons(int fdnum)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a5a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a5f:	5d                   	pop    %ebp
  801a60:	c3                   	ret    
  801a61:	66 90                	xchg   %ax,%ax
  801a63:	90                   	nop

00801a64 <__udivdi3>:
  801a64:	55                   	push   %ebp
  801a65:	57                   	push   %edi
  801a66:	56                   	push   %esi
  801a67:	53                   	push   %ebx
  801a68:	83 ec 1c             	sub    $0x1c,%esp
  801a6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a7b:	89 ca                	mov    %ecx,%edx
  801a7d:	89 f8                	mov    %edi,%eax
  801a7f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a83:	85 f6                	test   %esi,%esi
  801a85:	75 2d                	jne    801ab4 <__udivdi3+0x50>
  801a87:	39 cf                	cmp    %ecx,%edi
  801a89:	77 65                	ja     801af0 <__udivdi3+0x8c>
  801a8b:	89 fd                	mov    %edi,%ebp
  801a8d:	85 ff                	test   %edi,%edi
  801a8f:	75 0b                	jne    801a9c <__udivdi3+0x38>
  801a91:	b8 01 00 00 00       	mov    $0x1,%eax
  801a96:	31 d2                	xor    %edx,%edx
  801a98:	f7 f7                	div    %edi
  801a9a:	89 c5                	mov    %eax,%ebp
  801a9c:	31 d2                	xor    %edx,%edx
  801a9e:	89 c8                	mov    %ecx,%eax
  801aa0:	f7 f5                	div    %ebp
  801aa2:	89 c1                	mov    %eax,%ecx
  801aa4:	89 d8                	mov    %ebx,%eax
  801aa6:	f7 f5                	div    %ebp
  801aa8:	89 cf                	mov    %ecx,%edi
  801aaa:	89 fa                	mov    %edi,%edx
  801aac:	83 c4 1c             	add    $0x1c,%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5f                   	pop    %edi
  801ab2:	5d                   	pop    %ebp
  801ab3:	c3                   	ret    
  801ab4:	39 ce                	cmp    %ecx,%esi
  801ab6:	77 28                	ja     801ae0 <__udivdi3+0x7c>
  801ab8:	0f bd fe             	bsr    %esi,%edi
  801abb:	83 f7 1f             	xor    $0x1f,%edi
  801abe:	75 40                	jne    801b00 <__udivdi3+0x9c>
  801ac0:	39 ce                	cmp    %ecx,%esi
  801ac2:	72 0a                	jb     801ace <__udivdi3+0x6a>
  801ac4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ac8:	0f 87 9e 00 00 00    	ja     801b6c <__udivdi3+0x108>
  801ace:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad3:	89 fa                	mov    %edi,%edx
  801ad5:	83 c4 1c             	add    $0x1c,%esp
  801ad8:	5b                   	pop    %ebx
  801ad9:	5e                   	pop    %esi
  801ada:	5f                   	pop    %edi
  801adb:	5d                   	pop    %ebp
  801adc:	c3                   	ret    
  801add:	8d 76 00             	lea    0x0(%esi),%esi
  801ae0:	31 ff                	xor    %edi,%edi
  801ae2:	31 c0                	xor    %eax,%eax
  801ae4:	89 fa                	mov    %edi,%edx
  801ae6:	83 c4 1c             	add    $0x1c,%esp
  801ae9:	5b                   	pop    %ebx
  801aea:	5e                   	pop    %esi
  801aeb:	5f                   	pop    %edi
  801aec:	5d                   	pop    %ebp
  801aed:	c3                   	ret    
  801aee:	66 90                	xchg   %ax,%ax
  801af0:	89 d8                	mov    %ebx,%eax
  801af2:	f7 f7                	div    %edi
  801af4:	31 ff                	xor    %edi,%edi
  801af6:	89 fa                	mov    %edi,%edx
  801af8:	83 c4 1c             	add    $0x1c,%esp
  801afb:	5b                   	pop    %ebx
  801afc:	5e                   	pop    %esi
  801afd:	5f                   	pop    %edi
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    
  801b00:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b05:	89 eb                	mov    %ebp,%ebx
  801b07:	29 fb                	sub    %edi,%ebx
  801b09:	89 f9                	mov    %edi,%ecx
  801b0b:	d3 e6                	shl    %cl,%esi
  801b0d:	89 c5                	mov    %eax,%ebp
  801b0f:	88 d9                	mov    %bl,%cl
  801b11:	d3 ed                	shr    %cl,%ebp
  801b13:	89 e9                	mov    %ebp,%ecx
  801b15:	09 f1                	or     %esi,%ecx
  801b17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b1b:	89 f9                	mov    %edi,%ecx
  801b1d:	d3 e0                	shl    %cl,%eax
  801b1f:	89 c5                	mov    %eax,%ebp
  801b21:	89 d6                	mov    %edx,%esi
  801b23:	88 d9                	mov    %bl,%cl
  801b25:	d3 ee                	shr    %cl,%esi
  801b27:	89 f9                	mov    %edi,%ecx
  801b29:	d3 e2                	shl    %cl,%edx
  801b2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b2f:	88 d9                	mov    %bl,%cl
  801b31:	d3 e8                	shr    %cl,%eax
  801b33:	09 c2                	or     %eax,%edx
  801b35:	89 d0                	mov    %edx,%eax
  801b37:	89 f2                	mov    %esi,%edx
  801b39:	f7 74 24 0c          	divl   0xc(%esp)
  801b3d:	89 d6                	mov    %edx,%esi
  801b3f:	89 c3                	mov    %eax,%ebx
  801b41:	f7 e5                	mul    %ebp
  801b43:	39 d6                	cmp    %edx,%esi
  801b45:	72 19                	jb     801b60 <__udivdi3+0xfc>
  801b47:	74 0b                	je     801b54 <__udivdi3+0xf0>
  801b49:	89 d8                	mov    %ebx,%eax
  801b4b:	31 ff                	xor    %edi,%edi
  801b4d:	e9 58 ff ff ff       	jmp    801aaa <__udivdi3+0x46>
  801b52:	66 90                	xchg   %ax,%ax
  801b54:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b58:	89 f9                	mov    %edi,%ecx
  801b5a:	d3 e2                	shl    %cl,%edx
  801b5c:	39 c2                	cmp    %eax,%edx
  801b5e:	73 e9                	jae    801b49 <__udivdi3+0xe5>
  801b60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b63:	31 ff                	xor    %edi,%edi
  801b65:	e9 40 ff ff ff       	jmp    801aaa <__udivdi3+0x46>
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	31 c0                	xor    %eax,%eax
  801b6e:	e9 37 ff ff ff       	jmp    801aaa <__udivdi3+0x46>
  801b73:	90                   	nop

00801b74 <__umoddi3>:
  801b74:	55                   	push   %ebp
  801b75:	57                   	push   %edi
  801b76:	56                   	push   %esi
  801b77:	53                   	push   %ebx
  801b78:	83 ec 1c             	sub    $0x1c,%esp
  801b7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b93:	89 f3                	mov    %esi,%ebx
  801b95:	89 fa                	mov    %edi,%edx
  801b97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b9b:	89 34 24             	mov    %esi,(%esp)
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	75 1a                	jne    801bbc <__umoddi3+0x48>
  801ba2:	39 f7                	cmp    %esi,%edi
  801ba4:	0f 86 a2 00 00 00    	jbe    801c4c <__umoddi3+0xd8>
  801baa:	89 c8                	mov    %ecx,%eax
  801bac:	89 f2                	mov    %esi,%edx
  801bae:	f7 f7                	div    %edi
  801bb0:	89 d0                	mov    %edx,%eax
  801bb2:	31 d2                	xor    %edx,%edx
  801bb4:	83 c4 1c             	add    $0x1c,%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5f                   	pop    %edi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
  801bbc:	39 f0                	cmp    %esi,%eax
  801bbe:	0f 87 ac 00 00 00    	ja     801c70 <__umoddi3+0xfc>
  801bc4:	0f bd e8             	bsr    %eax,%ebp
  801bc7:	83 f5 1f             	xor    $0x1f,%ebp
  801bca:	0f 84 ac 00 00 00    	je     801c7c <__umoddi3+0x108>
  801bd0:	bf 20 00 00 00       	mov    $0x20,%edi
  801bd5:	29 ef                	sub    %ebp,%edi
  801bd7:	89 fe                	mov    %edi,%esi
  801bd9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bdd:	89 e9                	mov    %ebp,%ecx
  801bdf:	d3 e0                	shl    %cl,%eax
  801be1:	89 d7                	mov    %edx,%edi
  801be3:	89 f1                	mov    %esi,%ecx
  801be5:	d3 ef                	shr    %cl,%edi
  801be7:	09 c7                	or     %eax,%edi
  801be9:	89 e9                	mov    %ebp,%ecx
  801beb:	d3 e2                	shl    %cl,%edx
  801bed:	89 14 24             	mov    %edx,(%esp)
  801bf0:	89 d8                	mov    %ebx,%eax
  801bf2:	d3 e0                	shl    %cl,%eax
  801bf4:	89 c2                	mov    %eax,%edx
  801bf6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bfa:	d3 e0                	shl    %cl,%eax
  801bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c00:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c04:	89 f1                	mov    %esi,%ecx
  801c06:	d3 e8                	shr    %cl,%eax
  801c08:	09 d0                	or     %edx,%eax
  801c0a:	d3 eb                	shr    %cl,%ebx
  801c0c:	89 da                	mov    %ebx,%edx
  801c0e:	f7 f7                	div    %edi
  801c10:	89 d3                	mov    %edx,%ebx
  801c12:	f7 24 24             	mull   (%esp)
  801c15:	89 c6                	mov    %eax,%esi
  801c17:	89 d1                	mov    %edx,%ecx
  801c19:	39 d3                	cmp    %edx,%ebx
  801c1b:	0f 82 87 00 00 00    	jb     801ca8 <__umoddi3+0x134>
  801c21:	0f 84 91 00 00 00    	je     801cb8 <__umoddi3+0x144>
  801c27:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c2b:	29 f2                	sub    %esi,%edx
  801c2d:	19 cb                	sbb    %ecx,%ebx
  801c2f:	89 d8                	mov    %ebx,%eax
  801c31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c35:	d3 e0                	shl    %cl,%eax
  801c37:	89 e9                	mov    %ebp,%ecx
  801c39:	d3 ea                	shr    %cl,%edx
  801c3b:	09 d0                	or     %edx,%eax
  801c3d:	89 e9                	mov    %ebp,%ecx
  801c3f:	d3 eb                	shr    %cl,%ebx
  801c41:	89 da                	mov    %ebx,%edx
  801c43:	83 c4 1c             	add    $0x1c,%esp
  801c46:	5b                   	pop    %ebx
  801c47:	5e                   	pop    %esi
  801c48:	5f                   	pop    %edi
  801c49:	5d                   	pop    %ebp
  801c4a:	c3                   	ret    
  801c4b:	90                   	nop
  801c4c:	89 fd                	mov    %edi,%ebp
  801c4e:	85 ff                	test   %edi,%edi
  801c50:	75 0b                	jne    801c5d <__umoddi3+0xe9>
  801c52:	b8 01 00 00 00       	mov    $0x1,%eax
  801c57:	31 d2                	xor    %edx,%edx
  801c59:	f7 f7                	div    %edi
  801c5b:	89 c5                	mov    %eax,%ebp
  801c5d:	89 f0                	mov    %esi,%eax
  801c5f:	31 d2                	xor    %edx,%edx
  801c61:	f7 f5                	div    %ebp
  801c63:	89 c8                	mov    %ecx,%eax
  801c65:	f7 f5                	div    %ebp
  801c67:	89 d0                	mov    %edx,%eax
  801c69:	e9 44 ff ff ff       	jmp    801bb2 <__umoddi3+0x3e>
  801c6e:	66 90                	xchg   %ax,%ax
  801c70:	89 c8                	mov    %ecx,%eax
  801c72:	89 f2                	mov    %esi,%edx
  801c74:	83 c4 1c             	add    $0x1c,%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5f                   	pop    %edi
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    
  801c7c:	3b 04 24             	cmp    (%esp),%eax
  801c7f:	72 06                	jb     801c87 <__umoddi3+0x113>
  801c81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c85:	77 0f                	ja     801c96 <__umoddi3+0x122>
  801c87:	89 f2                	mov    %esi,%edx
  801c89:	29 f9                	sub    %edi,%ecx
  801c8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c8f:	89 14 24             	mov    %edx,(%esp)
  801c92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c96:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c9a:	8b 14 24             	mov    (%esp),%edx
  801c9d:	83 c4 1c             	add    $0x1c,%esp
  801ca0:	5b                   	pop    %ebx
  801ca1:	5e                   	pop    %esi
  801ca2:	5f                   	pop    %edi
  801ca3:	5d                   	pop    %ebp
  801ca4:	c3                   	ret    
  801ca5:	8d 76 00             	lea    0x0(%esi),%esi
  801ca8:	2b 04 24             	sub    (%esp),%eax
  801cab:	19 fa                	sbb    %edi,%edx
  801cad:	89 d1                	mov    %edx,%ecx
  801caf:	89 c6                	mov    %eax,%esi
  801cb1:	e9 71 ff ff ff       	jmp    801c27 <__umoddi3+0xb3>
  801cb6:	66 90                	xchg   %ax,%ax
  801cb8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cbc:	72 ea                	jb     801ca8 <__umoddi3+0x134>
  801cbe:	89 d9                	mov    %ebx,%ecx
  801cc0:	e9 62 ff ff ff       	jmp    801c27 <__umoddi3+0xb3>
