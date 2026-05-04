
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 80 1d 80 00       	push   $0x801d80
  80005e:	e8 e9 0a 00 00       	call   800b4c <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 eb 0f 00 00       	call   801064 <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 80 19 00 00       	call   801a0c <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 9c 1d 80 00       	push   $0x801d9c
  80009e:	e8 a9 0a 00 00       	call   800b4c <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 ab 0f 00 00       	call   801064 <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 b9 1d 80 00       	push   $0x801db9
  8000d0:	e8 11 03 00 00       	call   8003e6 <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e4:	e8 60 16 00 00       	call   801749 <sys_getenvindex>
  8000e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000ef:	89 d0                	mov    %edx,%eax
  8000f1:	c1 e0 02             	shl    $0x2,%eax
  8000f4:	01 d0                	add    %edx,%eax
  8000f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000fd:	01 d0                	add    %edx,%eax
  8000ff:	89 c2                	mov    %eax,%edx
  800101:	c1 e2 04             	shl    $0x4,%edx
  800104:	29 c2                	sub    %eax,%edx
  800106:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80010d:	89 c2                	mov    %eax,%edx
  80010f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800115:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80011a:	a1 20 30 80 00       	mov    0x803020,%eax
  80011f:	8a 40 20             	mov    0x20(%eax),%al
  800122:	84 c0                	test   %al,%al
  800124:	74 0d                	je     800133 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800126:	a1 20 30 80 00       	mov    0x803020,%eax
  80012b:	83 c0 20             	add    $0x20,%eax
  80012e:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800133:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800137:	7e 0a                	jle    800143 <libmain+0x68>
		binaryname = argv[0];
  800139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013c:	8b 00                	mov    (%eax),%eax
  80013e:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800143:	83 ec 08             	sub    $0x8,%esp
  800146:	ff 75 0c             	pushl  0xc(%ebp)
  800149:	ff 75 08             	pushl  0x8(%ebp)
  80014c:	e8 e7 fe ff ff       	call   800038 <_main>
  800151:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800154:	a1 00 30 80 00       	mov    0x803000,%eax
  800159:	85 c0                	test   %eax,%eax
  80015b:	0f 84 01 01 00 00    	je     800262 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800161:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800167:	bb cc 1e 80 00       	mov    $0x801ecc,%ebx
  80016c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800171:	89 c7                	mov    %eax,%edi
  800173:	89 de                	mov    %ebx,%esi
  800175:	89 d1                	mov    %edx,%ecx
  800177:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800179:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80017c:	b9 56 00 00 00       	mov    $0x56,%ecx
  800181:	b0 00                	mov    $0x0,%al
  800183:	89 d7                	mov    %edx,%edi
  800185:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800187:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80018e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	50                   	push   %eax
  800195:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80019b:	50                   	push   %eax
  80019c:	e8 de 17 00 00       	call   80197f <sys_utilities>
  8001a1:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001a4:	e8 27 13 00 00       	call   8014d0 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001a9:	83 ec 0c             	sub    $0xc,%esp
  8001ac:	68 ec 1d 80 00       	push   $0x801dec
  8001b1:	e8 be 01 00 00       	call   800374 <cprintf>
  8001b6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bc:	85 c0                	test   %eax,%eax
  8001be:	74 18                	je     8001d8 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001c0:	e8 d8 17 00 00       	call   80199d <sys_get_optimal_num_faults>
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	50                   	push   %eax
  8001c9:	68 14 1e 80 00       	push   $0x801e14
  8001ce:	e8 a1 01 00 00       	call   800374 <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp
  8001d6:	eb 59                	jmp    800231 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001dd:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8001e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e8:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	68 38 1e 80 00       	push   $0x801e38
  8001f8:	e8 77 01 00 00       	call   800374 <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800200:	a1 20 30 80 00       	mov    0x803020,%eax
  800205:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80020b:	a1 20 30 80 00       	mov    0x803020,%eax
  800210:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800216:	a1 20 30 80 00       	mov    0x803020,%eax
  80021b:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800221:	51                   	push   %ecx
  800222:	52                   	push   %edx
  800223:	50                   	push   %eax
  800224:	68 60 1e 80 00       	push   $0x801e60
  800229:	e8 46 01 00 00       	call   800374 <cprintf>
  80022e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800231:	a1 20 30 80 00       	mov    0x803020,%eax
  800236:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	50                   	push   %eax
  800240:	68 b8 1e 80 00       	push   $0x801eb8
  800245:	e8 2a 01 00 00       	call   800374 <cprintf>
  80024a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	68 ec 1d 80 00       	push   $0x801dec
  800255:	e8 1a 01 00 00       	call   800374 <cprintf>
  80025a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80025d:	e8 88 12 00 00       	call   8014ea <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800262:	e8 1f 00 00 00       	call   800286 <exit>
}
  800267:	90                   	nop
  800268:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026b:	5b                   	pop    %ebx
  80026c:	5e                   	pop    %esi
  80026d:	5f                   	pop    %edi
  80026e:	5d                   	pop    %ebp
  80026f:	c3                   	ret    

00800270 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	6a 00                	push   $0x0
  80027b:	e8 95 14 00 00       	call   801715 <sys_destroy_env>
  800280:	83 c4 10             	add    $0x10,%esp
}
  800283:	90                   	nop
  800284:	c9                   	leave  
  800285:	c3                   	ret    

00800286 <exit>:

void
exit(void)
{
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80028c:	e8 ea 14 00 00       	call   80177b <sys_exit_env>
}
  800291:	90                   	nop
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	53                   	push   %ebx
  800298:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80029b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029e:	8b 00                	mov    (%eax),%eax
  8002a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8002a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a6:	89 0a                	mov    %ecx,(%edx)
  8002a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ab:	88 d1                	mov    %dl,%cl
  8002ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b7:	8b 00                	mov    (%eax),%eax
  8002b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002be:	75 30                	jne    8002f0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002c0:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002c6:	a0 44 30 80 00       	mov    0x803044,%al
  8002cb:	0f b6 c0             	movzbl %al,%eax
  8002ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d1:	8b 09                	mov    (%ecx),%ecx
  8002d3:	89 cb                	mov    %ecx,%ebx
  8002d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d8:	83 c1 08             	add    $0x8,%ecx
  8002db:	52                   	push   %edx
  8002dc:	50                   	push   %eax
  8002dd:	53                   	push   %ebx
  8002de:	51                   	push   %ecx
  8002df:	e8 a8 11 00 00       	call   80148c <sys_cputs>
  8002e4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f3:	8b 40 04             	mov    0x4(%eax),%eax
  8002f6:	8d 50 01             	lea    0x1(%eax),%edx
  8002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002ff:	90                   	nop
  800300:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800303:	c9                   	leave  
  800304:	c3                   	ret    

00800305 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80030e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800315:	00 00 00 
	b.cnt = 0;
  800318:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80031f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	ff 75 08             	pushl  0x8(%ebp)
  800328:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032e:	50                   	push   %eax
  80032f:	68 94 02 80 00       	push   $0x800294
  800334:	e8 5a 02 00 00       	call   800593 <vprintfmt>
  800339:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80033c:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800342:	a0 44 30 80 00       	mov    0x803044,%al
  800347:	0f b6 c0             	movzbl %al,%eax
  80034a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800350:	52                   	push   %edx
  800351:	50                   	push   %eax
  800352:	51                   	push   %ecx
  800353:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800359:	83 c0 08             	add    $0x8,%eax
  80035c:	50                   	push   %eax
  80035d:	e8 2a 11 00 00       	call   80148c <sys_cputs>
  800362:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800365:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80036c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800372:	c9                   	leave  
  800373:	c3                   	ret    

00800374 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80037a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800381:	8d 45 0c             	lea    0xc(%ebp),%eax
  800384:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	ff 75 f4             	pushl  -0xc(%ebp)
  800390:	50                   	push   %eax
  800391:	e8 6f ff ff ff       	call   800305 <vcprintf>
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80039c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80039f:	c9                   	leave  
  8003a0:	c3                   	ret    

008003a1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003a7:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	c1 e0 08             	shl    $0x8,%eax
  8003b4:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003b9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003bc:	83 c0 04             	add    $0x4,%eax
  8003bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c5:	83 ec 08             	sub    $0x8,%esp
  8003c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003cb:	50                   	push   %eax
  8003cc:	e8 34 ff ff ff       	call   800305 <vcprintf>
  8003d1:	83 c4 10             	add    $0x10,%esp
  8003d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003d7:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003de:	07 00 00 

	return cnt;
  8003e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003ec:	e8 df 10 00 00       	call   8014d0 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800400:	50                   	push   %eax
  800401:	e8 ff fe ff ff       	call   800305 <vcprintf>
  800406:	83 c4 10             	add    $0x10,%esp
  800409:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80040c:	e8 d9 10 00 00       	call   8014ea <sys_unlock_cons>
	return cnt;
  800411:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800414:	c9                   	leave  
  800415:	c3                   	ret    

00800416 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800416:	55                   	push   %ebp
  800417:	89 e5                	mov    %esp,%ebp
  800419:	53                   	push   %ebx
  80041a:	83 ec 14             	sub    $0x14,%esp
  80041d:	8b 45 10             	mov    0x10(%ebp),%eax
  800420:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800423:	8b 45 14             	mov    0x14(%ebp),%eax
  800426:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800429:	8b 45 18             	mov    0x18(%ebp),%eax
  80042c:	ba 00 00 00 00       	mov    $0x0,%edx
  800431:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800434:	77 55                	ja     80048b <printnum+0x75>
  800436:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800439:	72 05                	jb     800440 <printnum+0x2a>
  80043b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80043e:	77 4b                	ja     80048b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800440:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800443:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800446:	8b 45 18             	mov    0x18(%ebp),%eax
  800449:	ba 00 00 00 00       	mov    $0x0,%edx
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	ff 75 f4             	pushl  -0xc(%ebp)
  800453:	ff 75 f0             	pushl  -0x10(%ebp)
  800456:	e8 ad 16 00 00       	call   801b08 <__udivdi3>
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	ff 75 20             	pushl  0x20(%ebp)
  800464:	53                   	push   %ebx
  800465:	ff 75 18             	pushl  0x18(%ebp)
  800468:	52                   	push   %edx
  800469:	50                   	push   %eax
  80046a:	ff 75 0c             	pushl  0xc(%ebp)
  80046d:	ff 75 08             	pushl  0x8(%ebp)
  800470:	e8 a1 ff ff ff       	call   800416 <printnum>
  800475:	83 c4 20             	add    $0x20,%esp
  800478:	eb 1a                	jmp    800494 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 0c             	pushl  0xc(%ebp)
  800480:	ff 75 20             	pushl  0x20(%ebp)
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	ff d0                	call   *%eax
  800488:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80048b:	ff 4d 1c             	decl   0x1c(%ebp)
  80048e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800492:	7f e6                	jg     80047a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800494:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800497:	bb 00 00 00 00       	mov    $0x0,%ebx
  80049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004a2:	53                   	push   %ebx
  8004a3:	51                   	push   %ecx
  8004a4:	52                   	push   %edx
  8004a5:	50                   	push   %eax
  8004a6:	e8 6d 17 00 00       	call   801c18 <__umoddi3>
  8004ab:	83 c4 10             	add    $0x10,%esp
  8004ae:	05 54 21 80 00       	add    $0x802154,%eax
  8004b3:	8a 00                	mov    (%eax),%al
  8004b5:	0f be c0             	movsbl %al,%eax
  8004b8:	83 ec 08             	sub    $0x8,%esp
  8004bb:	ff 75 0c             	pushl  0xc(%ebp)
  8004be:	50                   	push   %eax
  8004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c2:	ff d0                	call   *%eax
  8004c4:	83 c4 10             	add    $0x10,%esp
}
  8004c7:	90                   	nop
  8004c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004cb:	c9                   	leave  
  8004cc:	c3                   	ret    

008004cd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004cd:	55                   	push   %ebp
  8004ce:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d4:	7e 1c                	jle    8004f2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	8d 50 08             	lea    0x8(%eax),%edx
  8004de:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e1:	89 10                	mov    %edx,(%eax)
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	8b 00                	mov    (%eax),%eax
  8004e8:	83 e8 08             	sub    $0x8,%eax
  8004eb:	8b 50 04             	mov    0x4(%eax),%edx
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	eb 40                	jmp    800532 <getuint+0x65>
	else if (lflag)
  8004f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f6:	74 1e                	je     800516 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	8d 50 04             	lea    0x4(%eax),%edx
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	89 10                	mov    %edx,(%eax)
  800505:	8b 45 08             	mov    0x8(%ebp),%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	83 e8 04             	sub    $0x4,%eax
  80050d:	8b 00                	mov    (%eax),%eax
  80050f:	ba 00 00 00 00       	mov    $0x0,%edx
  800514:	eb 1c                	jmp    800532 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	8d 50 04             	lea    0x4(%eax),%edx
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	89 10                	mov    %edx,(%eax)
  800523:	8b 45 08             	mov    0x8(%ebp),%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	83 e8 04             	sub    $0x4,%eax
  80052b:	8b 00                	mov    (%eax),%eax
  80052d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800532:	5d                   	pop    %ebp
  800533:	c3                   	ret    

00800534 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800534:	55                   	push   %ebp
  800535:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800537:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80053b:	7e 1c                	jle    800559 <getint+0x25>
		return va_arg(*ap, long long);
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	8d 50 08             	lea    0x8(%eax),%edx
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	89 10                	mov    %edx,(%eax)
  80054a:	8b 45 08             	mov    0x8(%ebp),%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	83 e8 08             	sub    $0x8,%eax
  800552:	8b 50 04             	mov    0x4(%eax),%edx
  800555:	8b 00                	mov    (%eax),%eax
  800557:	eb 38                	jmp    800591 <getint+0x5d>
	else if (lflag)
  800559:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80055d:	74 1a                	je     800579 <getint+0x45>
		return va_arg(*ap, long);
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	8d 50 04             	lea    0x4(%eax),%edx
  800567:	8b 45 08             	mov    0x8(%ebp),%eax
  80056a:	89 10                	mov    %edx,(%eax)
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	83 e8 04             	sub    $0x4,%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	99                   	cltd   
  800577:	eb 18                	jmp    800591 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	8d 50 04             	lea    0x4(%eax),%edx
  800581:	8b 45 08             	mov    0x8(%ebp),%eax
  800584:	89 10                	mov    %edx,(%eax)
  800586:	8b 45 08             	mov    0x8(%ebp),%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	83 e8 04             	sub    $0x4,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	99                   	cltd   
}
  800591:	5d                   	pop    %ebp
  800592:	c3                   	ret    

00800593 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	56                   	push   %esi
  800597:	53                   	push   %ebx
  800598:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80059b:	eb 17                	jmp    8005b4 <vprintfmt+0x21>
			if (ch == '\0')
  80059d:	85 db                	test   %ebx,%ebx
  80059f:	0f 84 c1 03 00 00    	je     800966 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005a5:	83 ec 08             	sub    $0x8,%esp
  8005a8:	ff 75 0c             	pushl  0xc(%ebp)
  8005ab:	53                   	push   %ebx
  8005ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8005af:	ff d0                	call   *%eax
  8005b1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b7:	8d 50 01             	lea    0x1(%eax),%edx
  8005ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8005bd:	8a 00                	mov    (%eax),%al
  8005bf:	0f b6 d8             	movzbl %al,%ebx
  8005c2:	83 fb 25             	cmp    $0x25,%ebx
  8005c5:	75 d6                	jne    80059d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005c7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005cb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005d2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005e0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ea:	8d 50 01             	lea    0x1(%eax),%edx
  8005ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8005f0:	8a 00                	mov    (%eax),%al
  8005f2:	0f b6 d8             	movzbl %al,%ebx
  8005f5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005f8:	83 f8 5b             	cmp    $0x5b,%eax
  8005fb:	0f 87 3d 03 00 00    	ja     80093e <vprintfmt+0x3ab>
  800601:	8b 04 85 78 21 80 00 	mov    0x802178(,%eax,4),%eax
  800608:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80060a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80060e:	eb d7                	jmp    8005e7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800610:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800614:	eb d1                	jmp    8005e7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800616:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80061d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800620:	89 d0                	mov    %edx,%eax
  800622:	c1 e0 02             	shl    $0x2,%eax
  800625:	01 d0                	add    %edx,%eax
  800627:	01 c0                	add    %eax,%eax
  800629:	01 d8                	add    %ebx,%eax
  80062b:	83 e8 30             	sub    $0x30,%eax
  80062e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800631:	8b 45 10             	mov    0x10(%ebp),%eax
  800634:	8a 00                	mov    (%eax),%al
  800636:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800639:	83 fb 2f             	cmp    $0x2f,%ebx
  80063c:	7e 3e                	jle    80067c <vprintfmt+0xe9>
  80063e:	83 fb 39             	cmp    $0x39,%ebx
  800641:	7f 39                	jg     80067c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800643:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800646:	eb d5                	jmp    80061d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	83 c0 04             	add    $0x4,%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	83 e8 04             	sub    $0x4,%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80065c:	eb 1f                	jmp    80067d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80065e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800662:	79 83                	jns    8005e7 <vprintfmt+0x54>
				width = 0;
  800664:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80066b:	e9 77 ff ff ff       	jmp    8005e7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800670:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800677:	e9 6b ff ff ff       	jmp    8005e7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80067c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80067d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800681:	0f 89 60 ff ff ff    	jns    8005e7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800687:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80068d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800694:	e9 4e ff ff ff       	jmp    8005e7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800699:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80069c:	e9 46 ff ff ff       	jmp    8005e7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	83 c0 04             	add    $0x4,%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	83 e8 04             	sub    $0x4,%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	50                   	push   %eax
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	ff d0                	call   *%eax
  8006be:	83 c4 10             	add    $0x10,%esp
			break;
  8006c1:	e9 9b 02 00 00       	jmp    800961 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	83 c0 04             	add    $0x4,%eax
  8006cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	83 e8 04             	sub    $0x4,%eax
  8006d5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006d7:	85 db                	test   %ebx,%ebx
  8006d9:	79 02                	jns    8006dd <vprintfmt+0x14a>
				err = -err;
  8006db:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006dd:	83 fb 64             	cmp    $0x64,%ebx
  8006e0:	7f 0b                	jg     8006ed <vprintfmt+0x15a>
  8006e2:	8b 34 9d c0 1f 80 00 	mov    0x801fc0(,%ebx,4),%esi
  8006e9:	85 f6                	test   %esi,%esi
  8006eb:	75 19                	jne    800706 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006ed:	53                   	push   %ebx
  8006ee:	68 65 21 80 00       	push   $0x802165
  8006f3:	ff 75 0c             	pushl  0xc(%ebp)
  8006f6:	ff 75 08             	pushl  0x8(%ebp)
  8006f9:	e8 70 02 00 00       	call   80096e <printfmt>
  8006fe:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800701:	e9 5b 02 00 00       	jmp    800961 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800706:	56                   	push   %esi
  800707:	68 6e 21 80 00       	push   $0x80216e
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	ff 75 08             	pushl  0x8(%ebp)
  800712:	e8 57 02 00 00       	call   80096e <printfmt>
  800717:	83 c4 10             	add    $0x10,%esp
			break;
  80071a:	e9 42 02 00 00       	jmp    800961 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	83 c0 04             	add    $0x4,%eax
  800725:	89 45 14             	mov    %eax,0x14(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	83 e8 04             	sub    $0x4,%eax
  80072e:	8b 30                	mov    (%eax),%esi
  800730:	85 f6                	test   %esi,%esi
  800732:	75 05                	jne    800739 <vprintfmt+0x1a6>
				p = "(null)";
  800734:	be 71 21 80 00       	mov    $0x802171,%esi
			if (width > 0 && padc != '-')
  800739:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073d:	7e 6d                	jle    8007ac <vprintfmt+0x219>
  80073f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800743:	74 67                	je     8007ac <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	50                   	push   %eax
  80074c:	56                   	push   %esi
  80074d:	e8 26 05 00 00       	call   800c78 <strnlen>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800758:	eb 16                	jmp    800770 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80075a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	50                   	push   %eax
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	ff d0                	call   *%eax
  80076a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80076d:	ff 4d e4             	decl   -0x1c(%ebp)
  800770:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800774:	7f e4                	jg     80075a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800776:	eb 34                	jmp    8007ac <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800778:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80077c:	74 1c                	je     80079a <vprintfmt+0x207>
  80077e:	83 fb 1f             	cmp    $0x1f,%ebx
  800781:	7e 05                	jle    800788 <vprintfmt+0x1f5>
  800783:	83 fb 7e             	cmp    $0x7e,%ebx
  800786:	7e 12                	jle    80079a <vprintfmt+0x207>
					putch('?', putdat);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	ff 75 0c             	pushl  0xc(%ebp)
  80078e:	6a 3f                	push   $0x3f
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	eb 0f                	jmp    8007a9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	53                   	push   %ebx
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	ff d0                	call   *%eax
  8007a6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007a9:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ac:	89 f0                	mov    %esi,%eax
  8007ae:	8d 70 01             	lea    0x1(%eax),%esi
  8007b1:	8a 00                	mov    (%eax),%al
  8007b3:	0f be d8             	movsbl %al,%ebx
  8007b6:	85 db                	test   %ebx,%ebx
  8007b8:	74 24                	je     8007de <vprintfmt+0x24b>
  8007ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007be:	78 b8                	js     800778 <vprintfmt+0x1e5>
  8007c0:	ff 4d e0             	decl   -0x20(%ebp)
  8007c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007c7:	79 af                	jns    800778 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c9:	eb 13                	jmp    8007de <vprintfmt+0x24b>
				putch(' ', putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	6a 20                	push   $0x20
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	ff d0                	call   *%eax
  8007d8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007db:	ff 4d e4             	decl   -0x1c(%ebp)
  8007de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e2:	7f e7                	jg     8007cb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007e4:	e9 78 01 00 00       	jmp    800961 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f2:	50                   	push   %eax
  8007f3:	e8 3c fd ff ff       	call   800534 <getint>
  8007f8:	83 c4 10             	add    $0x10,%esp
  8007fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800804:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800807:	85 d2                	test   %edx,%edx
  800809:	79 23                	jns    80082e <vprintfmt+0x29b>
				putch('-', putdat);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 0c             	pushl  0xc(%ebp)
  800811:	6a 2d                	push   $0x2d
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	ff d0                	call   *%eax
  800818:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80081b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800821:	f7 d8                	neg    %eax
  800823:	83 d2 00             	adc    $0x0,%edx
  800826:	f7 da                	neg    %edx
  800828:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80082e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800835:	e9 bc 00 00 00       	jmp    8008f6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80083a:	83 ec 08             	sub    $0x8,%esp
  80083d:	ff 75 e8             	pushl  -0x18(%ebp)
  800840:	8d 45 14             	lea    0x14(%ebp),%eax
  800843:	50                   	push   %eax
  800844:	e8 84 fc ff ff       	call   8004cd <getuint>
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800852:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800859:	e9 98 00 00 00       	jmp    8008f6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	6a 58                	push   $0x58
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	6a 58                	push   $0x58
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	6a 58                	push   $0x58
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	ff d0                	call   *%eax
  80088b:	83 c4 10             	add    $0x10,%esp
			break;
  80088e:	e9 ce 00 00 00       	jmp    800961 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	6a 30                	push   $0x30
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	6a 78                	push   $0x78
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	ff d0                	call   *%eax
  8008b0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 c0 04             	add    $0x4,%eax
  8008b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	83 e8 04             	sub    $0x4,%eax
  8008c2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008ce:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008d5:	eb 1f                	jmp    8008f6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008d7:	83 ec 08             	sub    $0x8,%esp
  8008da:	ff 75 e8             	pushl  -0x18(%ebp)
  8008dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e0:	50                   	push   %eax
  8008e1:	e8 e7 fb ff ff       	call   8004cd <getuint>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008ef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008f6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fd:	83 ec 04             	sub    $0x4,%esp
  800900:	52                   	push   %edx
  800901:	ff 75 e4             	pushl  -0x1c(%ebp)
  800904:	50                   	push   %eax
  800905:	ff 75 f4             	pushl  -0xc(%ebp)
  800908:	ff 75 f0             	pushl  -0x10(%ebp)
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	ff 75 08             	pushl  0x8(%ebp)
  800911:	e8 00 fb ff ff       	call   800416 <printnum>
  800916:	83 c4 20             	add    $0x20,%esp
			break;
  800919:	eb 46                	jmp    800961 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	53                   	push   %ebx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	eb 35                	jmp    800961 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80092c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800933:	eb 2c                	jmp    800961 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800935:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  80093c:	eb 23                	jmp    800961 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	6a 25                	push   $0x25
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	ff d0                	call   *%eax
  80094b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80094e:	ff 4d 10             	decl   0x10(%ebp)
  800951:	eb 03                	jmp    800956 <vprintfmt+0x3c3>
  800953:	ff 4d 10             	decl   0x10(%ebp)
  800956:	8b 45 10             	mov    0x10(%ebp),%eax
  800959:	48                   	dec    %eax
  80095a:	8a 00                	mov    (%eax),%al
  80095c:	3c 25                	cmp    $0x25,%al
  80095e:	75 f3                	jne    800953 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800960:	90                   	nop
		}
	}
  800961:	e9 35 fc ff ff       	jmp    80059b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800966:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800967:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80096a:	5b                   	pop    %ebx
  80096b:	5e                   	pop    %esi
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800974:	8d 45 10             	lea    0x10(%ebp),%eax
  800977:	83 c0 04             	add    $0x4,%eax
  80097a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80097d:	8b 45 10             	mov    0x10(%ebp),%eax
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	e8 04 fc ff ff       	call   800593 <vprintfmt>
  80098f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800992:	90                   	nop
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099b:	8b 40 08             	mov    0x8(%eax),%eax
  80099e:	8d 50 01             	lea    0x1(%eax),%edx
  8009a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009aa:	8b 10                	mov    (%eax),%edx
  8009ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009af:	8b 40 04             	mov    0x4(%eax),%eax
  8009b2:	39 c2                	cmp    %eax,%edx
  8009b4:	73 12                	jae    8009c8 <sprintputch+0x33>
		*b->buf++ = ch;
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	8d 48 01             	lea    0x1(%eax),%ecx
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c1:	89 0a                	mov    %ecx,(%edx)
  8009c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c6:	88 10                	mov    %dl,(%eax)
}
  8009c8:	90                   	nop
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009f0:	74 06                	je     8009f8 <vsnprintf+0x2d>
  8009f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f6:	7f 07                	jg     8009ff <vsnprintf+0x34>
		return -E_INVAL;
  8009f8:	b8 03 00 00 00       	mov    $0x3,%eax
  8009fd:	eb 20                	jmp    800a1f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ff:	ff 75 14             	pushl  0x14(%ebp)
  800a02:	ff 75 10             	pushl  0x10(%ebp)
  800a05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a08:	50                   	push   %eax
  800a09:	68 95 09 80 00       	push   $0x800995
  800a0e:	e8 80 fb ff ff       	call   800593 <vprintfmt>
  800a13:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a19:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a27:	8d 45 10             	lea    0x10(%ebp),%eax
  800a2a:	83 c0 04             	add    $0x4,%eax
  800a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a30:	8b 45 10             	mov    0x10(%ebp),%eax
  800a33:	ff 75 f4             	pushl  -0xc(%ebp)
  800a36:	50                   	push   %eax
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	ff 75 08             	pushl  0x8(%ebp)
  800a3d:	e8 89 ff ff ff       	call   8009cb <vsnprintf>
  800a42:	83 c4 10             	add    $0x10,%esp
  800a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a57:	74 13                	je     800a6c <readline+0x1f>
		cprintf("%s", prompt);
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 08             	pushl  0x8(%ebp)
  800a5f:	68 e8 22 80 00       	push   $0x8022e8
  800a64:	e8 0b f9 ff ff       	call   800374 <cprintf>
  800a69:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a73:	83 ec 0c             	sub    $0xc,%esp
  800a76:	6a 00                	push   $0x0
  800a78:	e8 7f 10 00 00       	call   801afc <iscons>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a83:	e8 61 10 00 00       	call   801ae9 <getchar>
  800a88:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a8f:	79 22                	jns    800ab3 <readline+0x66>
			if (c != -E_EOF)
  800a91:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a95:	0f 84 ad 00 00 00    	je     800b48 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 ec             	pushl  -0x14(%ebp)
  800aa1:	68 eb 22 80 00       	push   $0x8022eb
  800aa6:	e8 c9 f8 ff ff       	call   800374 <cprintf>
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 95 00 00 00       	jmp    800b48 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ab3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ab7:	7e 34                	jle    800aed <readline+0xa0>
  800ab9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ac0:	7f 2b                	jg     800aed <readline+0xa0>
			if (echoing)
  800ac2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ac6:	74 0e                	je     800ad6 <readline+0x89>
				cputchar(c);
  800ac8:	83 ec 0c             	sub    $0xc,%esp
  800acb:	ff 75 ec             	pushl  -0x14(%ebp)
  800ace:	e8 f7 0f 00 00       	call   801aca <cputchar>
  800ad3:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad9:	8d 50 01             	lea    0x1(%eax),%edx
  800adc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800adf:	89 c2                	mov    %eax,%edx
  800ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae4:	01 d0                	add    %edx,%eax
  800ae6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ae9:	88 10                	mov    %dl,(%eax)
  800aeb:	eb 56                	jmp    800b43 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800aed:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800af1:	75 1f                	jne    800b12 <readline+0xc5>
  800af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800af7:	7e 19                	jle    800b12 <readline+0xc5>
			if (echoing)
  800af9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800afd:	74 0e                	je     800b0d <readline+0xc0>
				cputchar(c);
  800aff:	83 ec 0c             	sub    $0xc,%esp
  800b02:	ff 75 ec             	pushl  -0x14(%ebp)
  800b05:	e8 c0 0f 00 00       	call   801aca <cputchar>
  800b0a:	83 c4 10             	add    $0x10,%esp

			i--;
  800b0d:	ff 4d f4             	decl   -0xc(%ebp)
  800b10:	eb 31                	jmp    800b43 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b12:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b16:	74 0a                	je     800b22 <readline+0xd5>
  800b18:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b1c:	0f 85 61 ff ff ff    	jne    800a83 <readline+0x36>
			if (echoing)
  800b22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b26:	74 0e                	je     800b36 <readline+0xe9>
				cputchar(c);
  800b28:	83 ec 0c             	sub    $0xc,%esp
  800b2b:	ff 75 ec             	pushl  -0x14(%ebp)
  800b2e:	e8 97 0f 00 00       	call   801aca <cputchar>
  800b33:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	01 d0                	add    %edx,%eax
  800b3e:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b41:	eb 06                	jmp    800b49 <readline+0xfc>
		}
	}
  800b43:	e9 3b ff ff ff       	jmp    800a83 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b48:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b49:	90                   	nop
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b52:	e8 79 09 00 00       	call   8014d0 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5b:	74 13                	je     800b70 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 08             	pushl  0x8(%ebp)
  800b63:	68 e8 22 80 00       	push   $0x8022e8
  800b68:	e8 07 f8 ff ff       	call   800374 <cprintf>
  800b6d:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b77:	83 ec 0c             	sub    $0xc,%esp
  800b7a:	6a 00                	push   $0x0
  800b7c:	e8 7b 0f 00 00       	call   801afc <iscons>
  800b81:	83 c4 10             	add    $0x10,%esp
  800b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b87:	e8 5d 0f 00 00       	call   801ae9 <getchar>
  800b8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800b8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b93:	79 22                	jns    800bb7 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800b95:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b99:	0f 84 ad 00 00 00    	je     800c4c <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 ec             	pushl  -0x14(%ebp)
  800ba5:	68 eb 22 80 00       	push   $0x8022eb
  800baa:	e8 c5 f7 ff ff       	call   800374 <cprintf>
  800baf:	83 c4 10             	add    $0x10,%esp
				break;
  800bb2:	e9 95 00 00 00       	jmp    800c4c <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bb7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800bbb:	7e 34                	jle    800bf1 <atomic_readline+0xa5>
  800bbd:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800bc4:	7f 2b                	jg     800bf1 <atomic_readline+0xa5>
				if (echoing)
  800bc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bca:	74 0e                	je     800bda <atomic_readline+0x8e>
					cputchar(c);
  800bcc:	83 ec 0c             	sub    $0xc,%esp
  800bcf:	ff 75 ec             	pushl  -0x14(%ebp)
  800bd2:	e8 f3 0e 00 00       	call   801aca <cputchar>
  800bd7:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bdd:	8d 50 01             	lea    0x1(%eax),%edx
  800be0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800be3:	89 c2                	mov    %eax,%edx
  800be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be8:	01 d0                	add    %edx,%eax
  800bea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bed:	88 10                	mov    %dl,(%eax)
  800bef:	eb 56                	jmp    800c47 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800bf1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bf5:	75 1f                	jne    800c16 <atomic_readline+0xca>
  800bf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bfb:	7e 19                	jle    800c16 <atomic_readline+0xca>
				if (echoing)
  800bfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c01:	74 0e                	je     800c11 <atomic_readline+0xc5>
					cputchar(c);
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	ff 75 ec             	pushl  -0x14(%ebp)
  800c09:	e8 bc 0e 00 00       	call   801aca <cputchar>
  800c0e:	83 c4 10             	add    $0x10,%esp
				i--;
  800c11:	ff 4d f4             	decl   -0xc(%ebp)
  800c14:	eb 31                	jmp    800c47 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c16:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c1a:	74 0a                	je     800c26 <atomic_readline+0xda>
  800c1c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c20:	0f 85 61 ff ff ff    	jne    800b87 <atomic_readline+0x3b>
				if (echoing)
  800c26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c2a:	74 0e                	je     800c3a <atomic_readline+0xee>
					cputchar(c);
  800c2c:	83 ec 0c             	sub    $0xc,%esp
  800c2f:	ff 75 ec             	pushl  -0x14(%ebp)
  800c32:	e8 93 0e 00 00       	call   801aca <cputchar>
  800c37:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c40:	01 d0                	add    %edx,%eax
  800c42:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c45:	eb 06                	jmp    800c4d <atomic_readline+0x101>
			}
		}
  800c47:	e9 3b ff ff ff       	jmp    800b87 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c4c:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c4d:	e8 98 08 00 00       	call   8014ea <sys_unlock_cons>
}
  800c52:	90                   	nop
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c62:	eb 06                	jmp    800c6a <strlen+0x15>
		n++;
  800c64:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c67:	ff 45 08             	incl   0x8(%ebp)
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	84 c0                	test   %al,%al
  800c71:	75 f1                	jne    800c64 <strlen+0xf>
		n++;
	return n;
  800c73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c85:	eb 09                	jmp    800c90 <strnlen+0x18>
		n++;
  800c87:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8a:	ff 45 08             	incl   0x8(%ebp)
  800c8d:	ff 4d 0c             	decl   0xc(%ebp)
  800c90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c94:	74 09                	je     800c9f <strnlen+0x27>
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	84 c0                	test   %al,%al
  800c9d:	75 e8                	jne    800c87 <strnlen+0xf>
		n++;
	return n;
  800c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb0:	90                   	nop
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8d 50 01             	lea    0x1(%eax),%edx
  800cb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cc3:	8a 12                	mov    (%edx),%dl
  800cc5:	88 10                	mov    %dl,(%eax)
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	75 e4                	jne    800cb1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ccd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce5:	eb 1f                	jmp    800d06 <strncpy+0x34>
		*dst++ = *src;
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8d 50 01             	lea    0x1(%eax),%edx
  800ced:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf3:	8a 12                	mov    (%edx),%dl
  800cf5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	84 c0                	test   %al,%al
  800cfe:	74 03                	je     800d03 <strncpy+0x31>
			src++;
  800d00:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d03:	ff 45 fc             	incl   -0x4(%ebp)
  800d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d09:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d0c:	72 d9                	jb     800ce7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d23:	74 30                	je     800d55 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d25:	eb 16                	jmp    800d3d <strlcpy+0x2a>
			*dst++ = *src++;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8d 50 01             	lea    0x1(%eax),%edx
  800d2d:	89 55 08             	mov    %edx,0x8(%ebp)
  800d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d33:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d36:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d39:	8a 12                	mov    (%edx),%dl
  800d3b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d3d:	ff 4d 10             	decl   0x10(%ebp)
  800d40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d44:	74 09                	je     800d4f <strlcpy+0x3c>
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	75 d8                	jne    800d27 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d55:	8b 55 08             	mov    0x8(%ebp),%edx
  800d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5b:	29 c2                	sub    %eax,%edx
  800d5d:	89 d0                	mov    %edx,%eax
}
  800d5f:	c9                   	leave  
  800d60:	c3                   	ret    

00800d61 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d64:	eb 06                	jmp    800d6c <strcmp+0xb>
		p++, q++;
  800d66:	ff 45 08             	incl   0x8(%ebp)
  800d69:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	84 c0                	test   %al,%al
  800d73:	74 0e                	je     800d83 <strcmp+0x22>
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 10                	mov    (%eax),%dl
  800d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	38 c2                	cmp    %al,%dl
  800d81:	74 e3                	je     800d66 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	0f b6 d0             	movzbl %al,%edx
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	0f b6 c0             	movzbl %al,%eax
  800d93:	29 c2                	sub    %eax,%edx
  800d95:	89 d0                	mov    %edx,%eax
}
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d9c:	eb 09                	jmp    800da7 <strncmp+0xe>
		n--, p++, q++;
  800d9e:	ff 4d 10             	decl   0x10(%ebp)
  800da1:	ff 45 08             	incl   0x8(%ebp)
  800da4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800da7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dab:	74 17                	je     800dc4 <strncmp+0x2b>
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8a 00                	mov    (%eax),%al
  800db2:	84 c0                	test   %al,%al
  800db4:	74 0e                	je     800dc4 <strncmp+0x2b>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 10                	mov    (%eax),%dl
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	38 c2                	cmp    %al,%dl
  800dc2:	74 da                	je     800d9e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc8:	75 07                	jne    800dd1 <strncmp+0x38>
		return 0;
  800dca:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcf:	eb 14                	jmp    800de5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	0f b6 d0             	movzbl %al,%edx
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	0f b6 c0             	movzbl %al,%eax
  800de1:	29 c2                	sub    %eax,%edx
  800de3:	89 d0                	mov    %edx,%eax
}
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	83 ec 04             	sub    $0x4,%esp
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800df3:	eb 12                	jmp    800e07 <strchr+0x20>
		if (*s == c)
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dfd:	75 05                	jne    800e04 <strchr+0x1d>
			return (char *) s;
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	eb 11                	jmp    800e15 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e04:	ff 45 08             	incl   0x8(%ebp)
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	84 c0                	test   %al,%al
  800e0e:	75 e5                	jne    800df5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 04             	sub    $0x4,%esp
  800e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e20:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e23:	eb 0d                	jmp    800e32 <strfind+0x1b>
		if (*s == c)
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e2d:	74 0e                	je     800e3d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e2f:	ff 45 08             	incl   0x8(%ebp)
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	84 c0                	test   %al,%al
  800e39:	75 ea                	jne    800e25 <strfind+0xe>
  800e3b:	eb 01                	jmp    800e3e <strfind+0x27>
		if (*s == c)
			break;
  800e3d:	90                   	nop
	return (char *) s;
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e41:	c9                   	leave  
  800e42:	c3                   	ret    

00800e43 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e4f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e53:	76 63                	jbe    800eb8 <memset+0x75>
		uint64 data_block = c;
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	99                   	cltd   
  800e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e65:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e69:	c1 e0 08             	shl    $0x8,%eax
  800e6c:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e6f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e78:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e7c:	c1 e0 10             	shl    $0x10,%eax
  800e7f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e82:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8b:	89 c2                	mov    %eax,%edx
  800e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e92:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e95:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e98:	eb 18                	jmp    800eb2 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e9a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e9d:	8d 41 08             	lea    0x8(%ecx),%eax
  800ea0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea9:	89 01                	mov    %eax,(%ecx)
  800eab:	89 51 04             	mov    %edx,0x4(%ecx)
  800eae:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eb2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb6:	77 e2                	ja     800e9a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebc:	74 23                	je     800ee1 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ec4:	eb 0e                	jmp    800ed4 <memset+0x91>
			*p8++ = (uint8)c;
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8d 50 01             	lea    0x1(%eax),%edx
  800ecc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed2:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eda:	89 55 10             	mov    %edx,0x10(%ebp)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	75 e5                	jne    800ec6 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ef8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800efc:	76 24                	jbe    800f22 <memcpy+0x3c>
		while(n >= 8){
  800efe:	eb 1c                	jmp    800f1c <memcpy+0x36>
			*d64 = *s64;
  800f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f03:	8b 50 04             	mov    0x4(%eax),%edx
  800f06:	8b 00                	mov    (%eax),%eax
  800f08:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f0b:	89 01                	mov    %eax,(%ecx)
  800f0d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f10:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f14:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f18:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f1c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f20:	77 de                	ja     800f00 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f26:	74 31                	je     800f59 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f34:	eb 16                	jmp    800f4c <memcpy+0x66>
			*d8++ = *s8++;
  800f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f39:	8d 50 01             	lea    0x1(%eax),%edx
  800f3c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f45:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f48:	8a 12                	mov    (%edx),%dl
  800f4a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f52:	89 55 10             	mov    %edx,0x10(%ebp)
  800f55:	85 c0                	test   %eax,%eax
  800f57:	75 dd                	jne    800f36 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f76:	73 50                	jae    800fc8 <memmove+0x6a>
  800f78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7e:	01 d0                	add    %edx,%eax
  800f80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f83:	76 43                	jbe    800fc8 <memmove+0x6a>
		s += n;
  800f85:	8b 45 10             	mov    0x10(%ebp),%eax
  800f88:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f91:	eb 10                	jmp    800fa3 <memmove+0x45>
			*--d = *--s;
  800f93:	ff 4d f8             	decl   -0x8(%ebp)
  800f96:	ff 4d fc             	decl   -0x4(%ebp)
  800f99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9c:	8a 10                	mov    (%eax),%dl
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa9:	89 55 10             	mov    %edx,0x10(%ebp)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	75 e3                	jne    800f93 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb0:	eb 23                	jmp    800fd5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb5:	8d 50 01             	lea    0x1(%eax),%edx
  800fb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc4:	8a 12                	mov    (%edx),%dl
  800fc6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fce:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	75 dd                	jne    800fb2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd8:	c9                   	leave  
  800fd9:	c3                   	ret    

00800fda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fec:	eb 2a                	jmp    801018 <memcmp+0x3e>
		if (*s1 != *s2)
  800fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff1:	8a 10                	mov    (%eax),%dl
  800ff3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	38 c2                	cmp    %al,%dl
  800ffa:	74 16                	je     801012 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f b6 d0             	movzbl %al,%edx
  801004:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f b6 c0             	movzbl %al,%eax
  80100c:	29 c2                	sub    %eax,%edx
  80100e:	89 d0                	mov    %edx,%eax
  801010:	eb 18                	jmp    80102a <memcmp+0x50>
		s1++, s2++;
  801012:	ff 45 fc             	incl   -0x4(%ebp)
  801015:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801018:	8b 45 10             	mov    0x10(%ebp),%eax
  80101b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101e:	89 55 10             	mov    %edx,0x10(%ebp)
  801021:	85 c0                	test   %eax,%eax
  801023:	75 c9                	jne    800fee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801025:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801032:	8b 55 08             	mov    0x8(%ebp),%edx
  801035:	8b 45 10             	mov    0x10(%ebp),%eax
  801038:	01 d0                	add    %edx,%eax
  80103a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103d:	eb 15                	jmp    801054 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	0f b6 d0             	movzbl %al,%edx
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	0f b6 c0             	movzbl %al,%eax
  80104d:	39 c2                	cmp    %eax,%edx
  80104f:	74 0d                	je     80105e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801051:	ff 45 08             	incl   0x8(%ebp)
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105a:	72 e3                	jb     80103f <memfind+0x13>
  80105c:	eb 01                	jmp    80105f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105e:	90                   	nop
	return (void *) s;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80106a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801071:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801078:	eb 03                	jmp    80107d <strtol+0x19>
		s++;
  80107a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	3c 20                	cmp    $0x20,%al
  801084:	74 f4                	je     80107a <strtol+0x16>
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	3c 09                	cmp    $0x9,%al
  80108d:	74 eb                	je     80107a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 2b                	cmp    $0x2b,%al
  801096:	75 05                	jne    80109d <strtol+0x39>
		s++;
  801098:	ff 45 08             	incl   0x8(%ebp)
  80109b:	eb 13                	jmp    8010b0 <strtol+0x4c>
	else if (*s == '-')
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	3c 2d                	cmp    $0x2d,%al
  8010a4:	75 0a                	jne    8010b0 <strtol+0x4c>
		s++, neg = 1;
  8010a6:	ff 45 08             	incl   0x8(%ebp)
  8010a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b4:	74 06                	je     8010bc <strtol+0x58>
  8010b6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ba:	75 20                	jne    8010dc <strtol+0x78>
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	3c 30                	cmp    $0x30,%al
  8010c3:	75 17                	jne    8010dc <strtol+0x78>
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	40                   	inc    %eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 78                	cmp    $0x78,%al
  8010cd:	75 0d                	jne    8010dc <strtol+0x78>
		s += 2, base = 16;
  8010cf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010da:	eb 28                	jmp    801104 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e0:	75 15                	jne    8010f7 <strtol+0x93>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 0c                	jne    8010f7 <strtol+0x93>
		s++, base = 8;
  8010eb:	ff 45 08             	incl   0x8(%ebp)
  8010ee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f5:	eb 0d                	jmp    801104 <strtol+0xa0>
	else if (base == 0)
  8010f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fb:	75 07                	jne    801104 <strtol+0xa0>
		base = 10;
  8010fd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 2f                	cmp    $0x2f,%al
  80110b:	7e 19                	jle    801126 <strtol+0xc2>
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	3c 39                	cmp    $0x39,%al
  801114:	7f 10                	jg     801126 <strtol+0xc2>
			dig = *s - '0';
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	0f be c0             	movsbl %al,%eax
  80111e:	83 e8 30             	sub    $0x30,%eax
  801121:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801124:	eb 42                	jmp    801168 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 60                	cmp    $0x60,%al
  80112d:	7e 19                	jle    801148 <strtol+0xe4>
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	3c 7a                	cmp    $0x7a,%al
  801136:	7f 10                	jg     801148 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	0f be c0             	movsbl %al,%eax
  801140:	83 e8 57             	sub    $0x57,%eax
  801143:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801146:	eb 20                	jmp    801168 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 40                	cmp    $0x40,%al
  80114f:	7e 39                	jle    80118a <strtol+0x126>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 5a                	cmp    $0x5a,%al
  801158:	7f 30                	jg     80118a <strtol+0x126>
			dig = *s - 'A' + 10;
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	0f be c0             	movsbl %al,%eax
  801162:	83 e8 37             	sub    $0x37,%eax
  801165:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116e:	7d 19                	jge    801189 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801170:	ff 45 08             	incl   0x8(%ebp)
  801173:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801176:	0f af 45 10          	imul   0x10(%ebp),%eax
  80117a:	89 c2                	mov    %eax,%edx
  80117c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117f:	01 d0                	add    %edx,%eax
  801181:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801184:	e9 7b ff ff ff       	jmp    801104 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801189:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80118a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118e:	74 08                	je     801198 <strtol+0x134>
		*endptr = (char *) s;
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	8b 55 08             	mov    0x8(%ebp),%edx
  801196:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801198:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119c:	74 07                	je     8011a5 <strtol+0x141>
  80119e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a1:	f7 d8                	neg    %eax
  8011a3:	eb 03                	jmp    8011a8 <strtol+0x144>
  8011a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <ltostr>:

void
ltostr(long value, char *str)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	79 13                	jns    8011d7 <ltostr+0x2d>
	{
		neg = 1;
  8011c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011df:	99                   	cltd   
  8011e0:	f7 f9                	idiv   %ecx
  8011e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e8:	8d 50 01             	lea    0x1(%eax),%edx
  8011eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ee:	89 c2                	mov    %eax,%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	01 d0                	add    %edx,%eax
  8011f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f8:	83 c2 30             	add    $0x30,%edx
  8011fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801200:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801205:	f7 e9                	imul   %ecx
  801207:	c1 fa 02             	sar    $0x2,%edx
  80120a:	89 c8                	mov    %ecx,%eax
  80120c:	c1 f8 1f             	sar    $0x1f,%eax
  80120f:	29 c2                	sub    %eax,%edx
  801211:	89 d0                	mov    %edx,%eax
  801213:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801216:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80121a:	75 bb                	jne    8011d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80121c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801223:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801226:	48                   	dec    %eax
  801227:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80122a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122e:	74 3d                	je     80126d <ltostr+0xc3>
		start = 1 ;
  801230:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801237:	eb 34                	jmp    80126d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801239:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	01 d0                	add    %edx,%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	01 c2                	add    %eax,%edx
  80124e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	01 c8                	add    %ecx,%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80125a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c2                	add    %eax,%edx
  801262:	8a 45 eb             	mov    -0x15(%ebp),%al
  801265:	88 02                	mov    %al,(%edx)
		start++ ;
  801267:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80126a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80126d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801270:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801273:	7c c4                	jl     801239 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801275:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801280:	90                   	nop
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801289:	ff 75 08             	pushl  0x8(%ebp)
  80128c:	e8 c4 f9 ff ff       	call   800c55 <strlen>
  801291:	83 c4 04             	add    $0x4,%esp
  801294:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801297:	ff 75 0c             	pushl  0xc(%ebp)
  80129a:	e8 b6 f9 ff ff       	call   800c55 <strlen>
  80129f:	83 c4 04             	add    $0x4,%esp
  8012a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b3:	eb 17                	jmp    8012cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8012b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	01 c8                	add    %ecx,%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012c9:	ff 45 fc             	incl   -0x4(%ebp)
  8012cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012d2:	7c e1                	jl     8012b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012e2:	eb 1f                	jmp    801303 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e7:	8d 50 01             	lea    0x1(%eax),%edx
  8012ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ed:	89 c2                	mov    %eax,%edx
  8012ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f2:	01 c2                	add    %eax,%edx
  8012f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fa:	01 c8                	add    %ecx,%eax
  8012fc:	8a 00                	mov    (%eax),%al
  8012fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801300:	ff 45 f8             	incl   -0x8(%ebp)
  801303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801306:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801309:	7c d9                	jl     8012e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80130b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130e:	8b 45 10             	mov    0x10(%ebp),%eax
  801311:	01 d0                	add    %edx,%eax
  801313:	c6 00 00             	movb   $0x0,(%eax)
}
  801316:	90                   	nop
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80131c:	8b 45 14             	mov    0x14(%ebp),%eax
  80131f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801325:	8b 45 14             	mov    0x14(%ebp),%eax
  801328:	8b 00                	mov    (%eax),%eax
  80132a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801331:	8b 45 10             	mov    0x10(%ebp),%eax
  801334:	01 d0                	add    %edx,%eax
  801336:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80133c:	eb 0c                	jmp    80134a <strsplit+0x31>
			*string++ = 0;
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	8d 50 01             	lea    0x1(%eax),%edx
  801344:	89 55 08             	mov    %edx,0x8(%ebp)
  801347:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	84 c0                	test   %al,%al
  801351:	74 18                	je     80136b <strsplit+0x52>
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f be c0             	movsbl %al,%eax
  80135b:	50                   	push   %eax
  80135c:	ff 75 0c             	pushl  0xc(%ebp)
  80135f:	e8 83 fa ff ff       	call   800de7 <strchr>
  801364:	83 c4 08             	add    $0x8,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	75 d3                	jne    80133e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	84 c0                	test   %al,%al
  801372:	74 5a                	je     8013ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801374:	8b 45 14             	mov    0x14(%ebp),%eax
  801377:	8b 00                	mov    (%eax),%eax
  801379:	83 f8 0f             	cmp    $0xf,%eax
  80137c:	75 07                	jne    801385 <strsplit+0x6c>
		{
			return 0;
  80137e:	b8 00 00 00 00       	mov    $0x0,%eax
  801383:	eb 66                	jmp    8013eb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801385:	8b 45 14             	mov    0x14(%ebp),%eax
  801388:	8b 00                	mov    (%eax),%eax
  80138a:	8d 48 01             	lea    0x1(%eax),%ecx
  80138d:	8b 55 14             	mov    0x14(%ebp),%edx
  801390:	89 0a                	mov    %ecx,(%edx)
  801392:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801399:	8b 45 10             	mov    0x10(%ebp),%eax
  80139c:	01 c2                	add    %eax,%edx
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a3:	eb 03                	jmp    8013a8 <strsplit+0x8f>
			string++;
  8013a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	84 c0                	test   %al,%al
  8013af:	74 8b                	je     80133c <strsplit+0x23>
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	0f be c0             	movsbl %al,%eax
  8013b9:	50                   	push   %eax
  8013ba:	ff 75 0c             	pushl  0xc(%ebp)
  8013bd:	e8 25 fa ff ff       	call   800de7 <strchr>
  8013c2:	83 c4 08             	add    $0x8,%esp
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	74 dc                	je     8013a5 <strsplit+0x8c>
			string++;
	}
  8013c9:	e9 6e ff ff ff       	jmp    80133c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013db:	8b 45 10             	mov    0x10(%ebp),%eax
  8013de:	01 d0                	add    %edx,%eax
  8013e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801400:	eb 4a                	jmp    80144c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	01 c2                	add    %eax,%edx
  80140a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	01 c8                	add    %ecx,%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801416:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141c:	01 d0                	add    %edx,%eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	3c 40                	cmp    $0x40,%al
  801422:	7e 25                	jle    801449 <str2lower+0x5c>
  801424:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	3c 5a                	cmp    $0x5a,%al
  801430:	7f 17                	jg     801449 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143d:	8b 55 08             	mov    0x8(%ebp),%edx
  801440:	01 ca                	add    %ecx,%edx
  801442:	8a 12                	mov    (%edx),%dl
  801444:	83 c2 20             	add    $0x20,%edx
  801447:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801449:	ff 45 fc             	incl   -0x4(%ebp)
  80144c:	ff 75 0c             	pushl  0xc(%ebp)
  80144f:	e8 01 f8 ff ff       	call   800c55 <strlen>
  801454:	83 c4 04             	add    $0x4,%esp
  801457:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80145a:	7f a6                	jg     801402 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80145c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	57                   	push   %edi
  801465:	56                   	push   %esi
  801466:	53                   	push   %ebx
  801467:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801470:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801473:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801476:	8b 7d 18             	mov    0x18(%ebp),%edi
  801479:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80147c:	cd 30                	int    $0x30
  80147e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801481:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	5b                   	pop    %ebx
  801488:	5e                   	pop    %esi
  801489:	5f                   	pop    %edi
  80148a:	5d                   	pop    %ebp
  80148b:	c3                   	ret    

0080148c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	8b 45 10             	mov    0x10(%ebp),%eax
  801495:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801498:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80149b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	6a 00                	push   $0x0
  8014a4:	51                   	push   %ecx
  8014a5:	52                   	push   %edx
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	6a 00                	push   $0x0
  8014ac:	e8 b0 ff ff ff       	call   801461 <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
}
  8014b4:	90                   	nop
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 02                	push   $0x2
  8014c6:	e8 96 ff ff ff       	call   801461 <syscall>
  8014cb:	83 c4 18             	add    $0x18,%esp
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 03                	push   $0x3
  8014df:	e8 7d ff ff ff       	call   801461 <syscall>
  8014e4:	83 c4 18             	add    $0x18,%esp
}
  8014e7:	90                   	nop
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 04                	push   $0x4
  8014f9:	e8 63 ff ff ff       	call   801461 <syscall>
  8014fe:	83 c4 18             	add    $0x18,%esp
}
  801501:	90                   	nop
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	52                   	push   %edx
  801514:	50                   	push   %eax
  801515:	6a 08                	push   $0x8
  801517:	e8 45 ff ff ff       	call   801461 <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	56                   	push   %esi
  801525:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801526:	8b 75 18             	mov    0x18(%ebp),%esi
  801529:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80152c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80152f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	56                   	push   %esi
  801536:	53                   	push   %ebx
  801537:	51                   	push   %ecx
  801538:	52                   	push   %edx
  801539:	50                   	push   %eax
  80153a:	6a 09                	push   $0x9
  80153c:	e8 20 ff ff ff       	call   801461 <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
}
  801544:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801547:	5b                   	pop    %ebx
  801548:	5e                   	pop    %esi
  801549:	5d                   	pop    %ebp
  80154a:	c3                   	ret    

0080154b <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	ff 75 08             	pushl  0x8(%ebp)
  801559:	6a 0a                	push   $0xa
  80155b:	e8 01 ff ff ff       	call   801461 <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	ff 75 0c             	pushl  0xc(%ebp)
  801571:	ff 75 08             	pushl  0x8(%ebp)
  801574:	6a 0b                	push   $0xb
  801576:	e8 e6 fe ff ff       	call   801461 <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 0c                	push   $0xc
  80158f:	e8 cd fe ff ff       	call   801461 <syscall>
  801594:	83 c4 18             	add    $0x18,%esp
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 0d                	push   $0xd
  8015a8:	e8 b4 fe ff ff       	call   801461 <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 0e                	push   $0xe
  8015c1:	e8 9b fe ff ff       	call   801461 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 0f                	push   $0xf
  8015da:	e8 82 fe ff ff       	call   801461 <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	ff 75 08             	pushl  0x8(%ebp)
  8015f2:	6a 10                	push   $0x10
  8015f4:	e8 68 fe ff ff       	call   801461 <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 11                	push   $0x11
  80160d:	e8 4f fe ff ff       	call   801461 <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
}
  801615:	90                   	nop
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <sys_cputc>:

void
sys_cputc(const char c)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801624:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	50                   	push   %eax
  801631:	6a 01                	push   $0x1
  801633:	e8 29 fe ff ff       	call   801461 <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
}
  80163b:	90                   	nop
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 14                	push   $0x14
  80164d:	e8 0f fe ff ff       	call   801461 <syscall>
  801652:	83 c4 18             	add    $0x18,%esp
}
  801655:	90                   	nop
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 04             	sub    $0x4,%esp
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801664:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801667:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	6a 00                	push   $0x0
  801670:	51                   	push   %ecx
  801671:	52                   	push   %edx
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	50                   	push   %eax
  801676:	6a 15                	push   $0x15
  801678:	e8 e4 fd ff ff       	call   801461 <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801685:	8b 55 0c             	mov    0xc(%ebp),%edx
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	6a 16                	push   $0x16
  801695:	e8 c7 fd ff ff       	call   801461 <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	51                   	push   %ecx
  8016b0:	52                   	push   %edx
  8016b1:	50                   	push   %eax
  8016b2:	6a 17                	push   $0x17
  8016b4:	e8 a8 fd ff ff       	call   801461 <syscall>
  8016b9:	83 c4 18             	add    $0x18,%esp
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	52                   	push   %edx
  8016ce:	50                   	push   %eax
  8016cf:	6a 18                	push   $0x18
  8016d1:	e8 8b fd ff ff       	call   801461 <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	6a 00                	push   $0x0
  8016e3:	ff 75 14             	pushl  0x14(%ebp)
  8016e6:	ff 75 10             	pushl  0x10(%ebp)
  8016e9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ec:	50                   	push   %eax
  8016ed:	6a 19                	push   $0x19
  8016ef:	e8 6d fd ff ff       	call   801461 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	50                   	push   %eax
  801708:	6a 1a                	push   $0x1a
  80170a:	e8 52 fd ff ff       	call   801461 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	90                   	nop
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	50                   	push   %eax
  801724:	6a 1b                	push   $0x1b
  801726:	e8 36 fd ff ff       	call   801461 <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 05                	push   $0x5
  80173f:	e8 1d fd ff ff       	call   801461 <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 06                	push   $0x6
  801758:	e8 04 fd ff ff       	call   801461 <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 07                	push   $0x7
  801771:	e8 eb fc ff ff       	call   801461 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_exit_env>:


void sys_exit_env(void)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 1c                	push   $0x1c
  80178a:	e8 d2 fc ff ff       	call   801461 <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	90                   	nop
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80179b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80179e:	8d 50 04             	lea    0x4(%eax),%edx
  8017a1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	52                   	push   %edx
  8017ab:	50                   	push   %eax
  8017ac:	6a 1d                	push   $0x1d
  8017ae:	e8 ae fc ff ff       	call   801461 <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
	return result;
  8017b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017bf:	89 01                	mov    %eax,(%ecx)
  8017c1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	c9                   	leave  
  8017c8:	c2 04 00             	ret    $0x4

008017cb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	ff 75 10             	pushl  0x10(%ebp)
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	6a 13                	push   $0x13
  8017dd:	e8 7f fc ff ff       	call   801461 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e5:	90                   	nop
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 1e                	push   $0x1e
  8017f7:	e8 65 fc ff ff       	call   801461 <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 04             	sub    $0x4,%esp
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80180d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	50                   	push   %eax
  80181a:	6a 1f                	push   $0x1f
  80181c:	e8 40 fc ff ff       	call   801461 <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
	return ;
  801824:	90                   	nop
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <rsttst>:
void rsttst()
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 21                	push   $0x21
  801836:	e8 26 fc ff ff       	call   801461 <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
	return ;
  80183e:	90                   	nop
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	8b 45 14             	mov    0x14(%ebp),%eax
  80184a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80184d:	8b 55 18             	mov    0x18(%ebp),%edx
  801850:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801854:	52                   	push   %edx
  801855:	50                   	push   %eax
  801856:	ff 75 10             	pushl  0x10(%ebp)
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	ff 75 08             	pushl  0x8(%ebp)
  80185f:	6a 20                	push   $0x20
  801861:	e8 fb fb ff ff       	call   801461 <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
	return ;
  801869:	90                   	nop
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <chktst>:
void chktst(uint32 n)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	ff 75 08             	pushl  0x8(%ebp)
  80187a:	6a 22                	push   $0x22
  80187c:	e8 e0 fb ff ff       	call   801461 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
	return ;
  801884:	90                   	nop
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <inctst>:

void inctst()
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 23                	push   $0x23
  801896:	e8 c6 fb ff ff       	call   801461 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
	return ;
  80189e:	90                   	nop
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <gettst>:
uint32 gettst()
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 24                	push   $0x24
  8018b0:	e8 ac fb ff ff       	call   801461 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 25                	push   $0x25
  8018c9:	e8 93 fb ff ff       	call   801461 <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
  8018d1:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018d6:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	6a 26                	push   $0x26
  8018f5:	e8 67 fb ff ff       	call   801461 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fd:	90                   	nop
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801904:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801907:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	6a 00                	push   $0x0
  801912:	53                   	push   %ebx
  801913:	51                   	push   %ecx
  801914:	52                   	push   %edx
  801915:	50                   	push   %eax
  801916:	6a 27                	push   $0x27
  801918:	e8 44 fb ff ff       	call   801461 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801928:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	52                   	push   %edx
  801935:	50                   	push   %eax
  801936:	6a 28                	push   $0x28
  801938:	e8 24 fb ff ff       	call   801461 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801945:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	6a 00                	push   $0x0
  801950:	51                   	push   %ecx
  801951:	ff 75 10             	pushl  0x10(%ebp)
  801954:	52                   	push   %edx
  801955:	50                   	push   %eax
  801956:	6a 29                	push   $0x29
  801958:	e8 04 fb ff ff       	call   801461 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	ff 75 10             	pushl  0x10(%ebp)
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	6a 12                	push   $0x12
  801974:	e8 e8 fa ff ff       	call   801461 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
	return ;
  80197c:	90                   	nop
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801982:	8b 55 0c             	mov    0xc(%ebp),%edx
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	52                   	push   %edx
  80198f:	50                   	push   %eax
  801990:	6a 2a                	push   $0x2a
  801992:	e8 ca fa ff ff       	call   801461 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
	return;
  80199a:	90                   	nop
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 2b                	push   $0x2b
  8019ac:	e8 b0 fa ff ff       	call   801461 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	ff 75 08             	pushl  0x8(%ebp)
  8019c5:	6a 2d                	push   $0x2d
  8019c7:	e8 95 fa ff ff       	call   801461 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
	return;
  8019cf:	90                   	nop
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	6a 2c                	push   $0x2c
  8019e3:	e8 79 fa ff ff       	call   801461 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019eb:	90                   	nop
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8019f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	52                   	push   %edx
  8019fe:	50                   	push   %eax
  8019ff:	6a 2e                	push   $0x2e
  801a01:	e8 5b fa ff ff       	call   801461 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
	    return;
  801a09:	90                   	nop
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801a12:	8b 55 08             	mov    0x8(%ebp),%edx
  801a15:	89 d0                	mov    %edx,%eax
  801a17:	c1 e0 02             	shl    $0x2,%eax
  801a1a:	01 d0                	add    %edx,%eax
  801a1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a23:	01 d0                	add    %edx,%eax
  801a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a2c:	01 d0                	add    %edx,%eax
  801a2e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a35:	01 d0                	add    %edx,%eax
  801a37:	c1 e0 04             	shl    $0x4,%eax
  801a3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801a3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801a44:	0f 31                	rdtsc  
  801a46:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a49:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801a4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a55:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801a58:	eb 46                	jmp    801aa0 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801a5a:	0f 31                	rdtsc  
  801a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801a5f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801a62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801a68:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a6b:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a74:	29 c2                	sub    %eax,%edx
  801a76:	89 d0                	mov    %edx,%eax
  801a78:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a81:	89 d1                	mov    %edx,%ecx
  801a83:	29 c1                	sub    %eax,%ecx
  801a85:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8b:	39 c2                	cmp    %eax,%edx
  801a8d:	0f 97 c0             	seta   %al
  801a90:	0f b6 c0             	movzbl %al,%eax
  801a93:	29 c1                	sub    %eax,%ecx
  801a95:	89 c8                	mov    %ecx,%eax
  801a97:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801aa6:	72 b2                	jb     801a5a <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801aa8:	90                   	nop
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801ab1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801ab8:	eb 03                	jmp    801abd <busy_wait+0x12>
  801aba:	ff 45 fc             	incl   -0x4(%ebp)
  801abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ac3:	72 f5                	jb     801aba <busy_wait+0xf>
	return i;
  801ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ad6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ada:	83 ec 0c             	sub    $0xc,%esp
  801add:	50                   	push   %eax
  801ade:	e8 35 fb ff ff       	call   801618 <sys_cputc>
  801ae3:	83 c4 10             	add    $0x10,%esp
}
  801ae6:	90                   	nop
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <getchar>:


int
getchar(void)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801aef:	e8 c3 f9 ff ff       	call   8014b7 <sys_cgetc>
  801af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <iscons>:

int iscons(int fdnum)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801aff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b04:	5d                   	pop    %ebp
  801b05:	c3                   	ret    
  801b06:	66 90                	xchg   %ax,%ax

00801b08 <__udivdi3>:
  801b08:	55                   	push   %ebp
  801b09:	57                   	push   %edi
  801b0a:	56                   	push   %esi
  801b0b:	53                   	push   %ebx
  801b0c:	83 ec 1c             	sub    $0x1c,%esp
  801b0f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b13:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b1f:	89 ca                	mov    %ecx,%edx
  801b21:	89 f8                	mov    %edi,%eax
  801b23:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b27:	85 f6                	test   %esi,%esi
  801b29:	75 2d                	jne    801b58 <__udivdi3+0x50>
  801b2b:	39 cf                	cmp    %ecx,%edi
  801b2d:	77 65                	ja     801b94 <__udivdi3+0x8c>
  801b2f:	89 fd                	mov    %edi,%ebp
  801b31:	85 ff                	test   %edi,%edi
  801b33:	75 0b                	jne    801b40 <__udivdi3+0x38>
  801b35:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3a:	31 d2                	xor    %edx,%edx
  801b3c:	f7 f7                	div    %edi
  801b3e:	89 c5                	mov    %eax,%ebp
  801b40:	31 d2                	xor    %edx,%edx
  801b42:	89 c8                	mov    %ecx,%eax
  801b44:	f7 f5                	div    %ebp
  801b46:	89 c1                	mov    %eax,%ecx
  801b48:	89 d8                	mov    %ebx,%eax
  801b4a:	f7 f5                	div    %ebp
  801b4c:	89 cf                	mov    %ecx,%edi
  801b4e:	89 fa                	mov    %edi,%edx
  801b50:	83 c4 1c             	add    $0x1c,%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5f                   	pop    %edi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    
  801b58:	39 ce                	cmp    %ecx,%esi
  801b5a:	77 28                	ja     801b84 <__udivdi3+0x7c>
  801b5c:	0f bd fe             	bsr    %esi,%edi
  801b5f:	83 f7 1f             	xor    $0x1f,%edi
  801b62:	75 40                	jne    801ba4 <__udivdi3+0x9c>
  801b64:	39 ce                	cmp    %ecx,%esi
  801b66:	72 0a                	jb     801b72 <__udivdi3+0x6a>
  801b68:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b6c:	0f 87 9e 00 00 00    	ja     801c10 <__udivdi3+0x108>
  801b72:	b8 01 00 00 00       	mov    $0x1,%eax
  801b77:	89 fa                	mov    %edi,%edx
  801b79:	83 c4 1c             	add    $0x1c,%esp
  801b7c:	5b                   	pop    %ebx
  801b7d:	5e                   	pop    %esi
  801b7e:	5f                   	pop    %edi
  801b7f:	5d                   	pop    %ebp
  801b80:	c3                   	ret    
  801b81:	8d 76 00             	lea    0x0(%esi),%esi
  801b84:	31 ff                	xor    %edi,%edi
  801b86:	31 c0                	xor    %eax,%eax
  801b88:	89 fa                	mov    %edi,%edx
  801b8a:	83 c4 1c             	add    $0x1c,%esp
  801b8d:	5b                   	pop    %ebx
  801b8e:	5e                   	pop    %esi
  801b8f:	5f                   	pop    %edi
  801b90:	5d                   	pop    %ebp
  801b91:	c3                   	ret    
  801b92:	66 90                	xchg   %ax,%ax
  801b94:	89 d8                	mov    %ebx,%eax
  801b96:	f7 f7                	div    %edi
  801b98:	31 ff                	xor    %edi,%edi
  801b9a:	89 fa                	mov    %edi,%edx
  801b9c:	83 c4 1c             	add    $0x1c,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    
  801ba4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ba9:	89 eb                	mov    %ebp,%ebx
  801bab:	29 fb                	sub    %edi,%ebx
  801bad:	89 f9                	mov    %edi,%ecx
  801baf:	d3 e6                	shl    %cl,%esi
  801bb1:	89 c5                	mov    %eax,%ebp
  801bb3:	88 d9                	mov    %bl,%cl
  801bb5:	d3 ed                	shr    %cl,%ebp
  801bb7:	89 e9                	mov    %ebp,%ecx
  801bb9:	09 f1                	or     %esi,%ecx
  801bbb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bbf:	89 f9                	mov    %edi,%ecx
  801bc1:	d3 e0                	shl    %cl,%eax
  801bc3:	89 c5                	mov    %eax,%ebp
  801bc5:	89 d6                	mov    %edx,%esi
  801bc7:	88 d9                	mov    %bl,%cl
  801bc9:	d3 ee                	shr    %cl,%esi
  801bcb:	89 f9                	mov    %edi,%ecx
  801bcd:	d3 e2                	shl    %cl,%edx
  801bcf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd3:	88 d9                	mov    %bl,%cl
  801bd5:	d3 e8                	shr    %cl,%eax
  801bd7:	09 c2                	or     %eax,%edx
  801bd9:	89 d0                	mov    %edx,%eax
  801bdb:	89 f2                	mov    %esi,%edx
  801bdd:	f7 74 24 0c          	divl   0xc(%esp)
  801be1:	89 d6                	mov    %edx,%esi
  801be3:	89 c3                	mov    %eax,%ebx
  801be5:	f7 e5                	mul    %ebp
  801be7:	39 d6                	cmp    %edx,%esi
  801be9:	72 19                	jb     801c04 <__udivdi3+0xfc>
  801beb:	74 0b                	je     801bf8 <__udivdi3+0xf0>
  801bed:	89 d8                	mov    %ebx,%eax
  801bef:	31 ff                	xor    %edi,%edi
  801bf1:	e9 58 ff ff ff       	jmp    801b4e <__udivdi3+0x46>
  801bf6:	66 90                	xchg   %ax,%ax
  801bf8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bfc:	89 f9                	mov    %edi,%ecx
  801bfe:	d3 e2                	shl    %cl,%edx
  801c00:	39 c2                	cmp    %eax,%edx
  801c02:	73 e9                	jae    801bed <__udivdi3+0xe5>
  801c04:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c07:	31 ff                	xor    %edi,%edi
  801c09:	e9 40 ff ff ff       	jmp    801b4e <__udivdi3+0x46>
  801c0e:	66 90                	xchg   %ax,%ax
  801c10:	31 c0                	xor    %eax,%eax
  801c12:	e9 37 ff ff ff       	jmp    801b4e <__udivdi3+0x46>
  801c17:	90                   	nop

00801c18 <__umoddi3>:
  801c18:	55                   	push   %ebp
  801c19:	57                   	push   %edi
  801c1a:	56                   	push   %esi
  801c1b:	53                   	push   %ebx
  801c1c:	83 ec 1c             	sub    $0x1c,%esp
  801c1f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c23:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c37:	89 f3                	mov    %esi,%ebx
  801c39:	89 fa                	mov    %edi,%edx
  801c3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c3f:	89 34 24             	mov    %esi,(%esp)
  801c42:	85 c0                	test   %eax,%eax
  801c44:	75 1a                	jne    801c60 <__umoddi3+0x48>
  801c46:	39 f7                	cmp    %esi,%edi
  801c48:	0f 86 a2 00 00 00    	jbe    801cf0 <__umoddi3+0xd8>
  801c4e:	89 c8                	mov    %ecx,%eax
  801c50:	89 f2                	mov    %esi,%edx
  801c52:	f7 f7                	div    %edi
  801c54:	89 d0                	mov    %edx,%eax
  801c56:	31 d2                	xor    %edx,%edx
  801c58:	83 c4 1c             	add    $0x1c,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5f                   	pop    %edi
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    
  801c60:	39 f0                	cmp    %esi,%eax
  801c62:	0f 87 ac 00 00 00    	ja     801d14 <__umoddi3+0xfc>
  801c68:	0f bd e8             	bsr    %eax,%ebp
  801c6b:	83 f5 1f             	xor    $0x1f,%ebp
  801c6e:	0f 84 ac 00 00 00    	je     801d20 <__umoddi3+0x108>
  801c74:	bf 20 00 00 00       	mov    $0x20,%edi
  801c79:	29 ef                	sub    %ebp,%edi
  801c7b:	89 fe                	mov    %edi,%esi
  801c7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c81:	89 e9                	mov    %ebp,%ecx
  801c83:	d3 e0                	shl    %cl,%eax
  801c85:	89 d7                	mov    %edx,%edi
  801c87:	89 f1                	mov    %esi,%ecx
  801c89:	d3 ef                	shr    %cl,%edi
  801c8b:	09 c7                	or     %eax,%edi
  801c8d:	89 e9                	mov    %ebp,%ecx
  801c8f:	d3 e2                	shl    %cl,%edx
  801c91:	89 14 24             	mov    %edx,(%esp)
  801c94:	89 d8                	mov    %ebx,%eax
  801c96:	d3 e0                	shl    %cl,%eax
  801c98:	89 c2                	mov    %eax,%edx
  801c9a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c9e:	d3 e0                	shl    %cl,%eax
  801ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ca8:	89 f1                	mov    %esi,%ecx
  801caa:	d3 e8                	shr    %cl,%eax
  801cac:	09 d0                	or     %edx,%eax
  801cae:	d3 eb                	shr    %cl,%ebx
  801cb0:	89 da                	mov    %ebx,%edx
  801cb2:	f7 f7                	div    %edi
  801cb4:	89 d3                	mov    %edx,%ebx
  801cb6:	f7 24 24             	mull   (%esp)
  801cb9:	89 c6                	mov    %eax,%esi
  801cbb:	89 d1                	mov    %edx,%ecx
  801cbd:	39 d3                	cmp    %edx,%ebx
  801cbf:	0f 82 87 00 00 00    	jb     801d4c <__umoddi3+0x134>
  801cc5:	0f 84 91 00 00 00    	je     801d5c <__umoddi3+0x144>
  801ccb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ccf:	29 f2                	sub    %esi,%edx
  801cd1:	19 cb                	sbb    %ecx,%ebx
  801cd3:	89 d8                	mov    %ebx,%eax
  801cd5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cd9:	d3 e0                	shl    %cl,%eax
  801cdb:	89 e9                	mov    %ebp,%ecx
  801cdd:	d3 ea                	shr    %cl,%edx
  801cdf:	09 d0                	or     %edx,%eax
  801ce1:	89 e9                	mov    %ebp,%ecx
  801ce3:	d3 eb                	shr    %cl,%ebx
  801ce5:	89 da                	mov    %ebx,%edx
  801ce7:	83 c4 1c             	add    $0x1c,%esp
  801cea:	5b                   	pop    %ebx
  801ceb:	5e                   	pop    %esi
  801cec:	5f                   	pop    %edi
  801ced:	5d                   	pop    %ebp
  801cee:	c3                   	ret    
  801cef:	90                   	nop
  801cf0:	89 fd                	mov    %edi,%ebp
  801cf2:	85 ff                	test   %edi,%edi
  801cf4:	75 0b                	jne    801d01 <__umoddi3+0xe9>
  801cf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfb:	31 d2                	xor    %edx,%edx
  801cfd:	f7 f7                	div    %edi
  801cff:	89 c5                	mov    %eax,%ebp
  801d01:	89 f0                	mov    %esi,%eax
  801d03:	31 d2                	xor    %edx,%edx
  801d05:	f7 f5                	div    %ebp
  801d07:	89 c8                	mov    %ecx,%eax
  801d09:	f7 f5                	div    %ebp
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	e9 44 ff ff ff       	jmp    801c56 <__umoddi3+0x3e>
  801d12:	66 90                	xchg   %ax,%ax
  801d14:	89 c8                	mov    %ecx,%eax
  801d16:	89 f2                	mov    %esi,%edx
  801d18:	83 c4 1c             	add    $0x1c,%esp
  801d1b:	5b                   	pop    %ebx
  801d1c:	5e                   	pop    %esi
  801d1d:	5f                   	pop    %edi
  801d1e:	5d                   	pop    %ebp
  801d1f:	c3                   	ret    
  801d20:	3b 04 24             	cmp    (%esp),%eax
  801d23:	72 06                	jb     801d2b <__umoddi3+0x113>
  801d25:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d29:	77 0f                	ja     801d3a <__umoddi3+0x122>
  801d2b:	89 f2                	mov    %esi,%edx
  801d2d:	29 f9                	sub    %edi,%ecx
  801d2f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d33:	89 14 24             	mov    %edx,(%esp)
  801d36:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d3a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d3e:	8b 14 24             	mov    (%esp),%edx
  801d41:	83 c4 1c             	add    $0x1c,%esp
  801d44:	5b                   	pop    %ebx
  801d45:	5e                   	pop    %esi
  801d46:	5f                   	pop    %edi
  801d47:	5d                   	pop    %ebp
  801d48:	c3                   	ret    
  801d49:	8d 76 00             	lea    0x0(%esi),%esi
  801d4c:	2b 04 24             	sub    (%esp),%eax
  801d4f:	19 fa                	sbb    %edi,%edx
  801d51:	89 d1                	mov    %edx,%ecx
  801d53:	89 c6                	mov    %eax,%esi
  801d55:	e9 71 ff ff ff       	jmp    801ccb <__umoddi3+0xb3>
  801d5a:	66 90                	xchg   %ax,%ax
  801d5c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d60:	72 ea                	jb     801d4c <__umoddi3+0x134>
  801d62:	89 d9                	mov    %ebx,%ecx
  801d64:	e9 62 ff ff ff       	jmp    801ccb <__umoddi3+0xb3>
