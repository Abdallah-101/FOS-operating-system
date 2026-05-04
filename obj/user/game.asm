
obj/user/game:     file format elf32-i386


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
  800031:	e8 98 00 00 00       	call   8000ce <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int i=28;
  80003e:	c7 45 f4 1c 00 00 00 	movl   $0x1c,-0xc(%ebp)
	int txtClr = TEXT_black;
  800045:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for(;i<128; i++)
  80004c:	eb 77                	jmp    8000c5 <_main+0x8d>
	{
		txtClr = (txtClr + 1) % 16;
  80004e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800051:	40                   	inc    %eax
  800052:	25 0f 00 00 80       	and    $0x8000000f,%eax
  800057:	85 c0                	test   %eax,%eax
  800059:	79 05                	jns    800060 <_main+0x28>
  80005b:	48                   	dec    %eax
  80005c:	83 c8 f0             	or     $0xfffffff0,%eax
  80005f:	40                   	inc    %eax
  800060:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int c=0;
  800063:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;c<10; c++)
  80006a:	eb 19                	jmp    800085 <_main+0x4d>
		{
			cprintf_colored(txtClr, "%~%c",i);
  80006c:	83 ec 04             	sub    $0x4,%esp
  80006f:	ff 75 f4             	pushl  -0xc(%ebp)
  800072:	68 60 1a 80 00       	push   $0x801a60
  800077:	ff 75 f0             	pushl  -0x10(%ebp)
  80007a:	e8 15 03 00 00       	call   800394 <cprintf_colored>
  80007f:	83 c4 10             	add    $0x10,%esp
	int txtClr = TEXT_black;
	for(;i<128; i++)
	{
		txtClr = (txtClr + 1) % 16;
		int c=0;
		for(;c<10; c++)
  800082:	ff 45 ec             	incl   -0x14(%ebp)
  800085:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
  800089:	7e e1                	jle    80006c <_main+0x34>
		{
			cprintf_colored(txtClr, "%~%c",i);
		}
		int d=0;
  80008b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for(; d< 5000000; d++);
  800092:	eb 03                	jmp    800097 <_main+0x5f>
  800094:	ff 45 e8             	incl   -0x18(%ebp)
  800097:	81 7d e8 3f 4b 4c 00 	cmpl   $0x4c4b3f,-0x18(%ebp)
  80009e:	7e f4                	jle    800094 <_main+0x5c>
		c=0;
  8000a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;c<10; c++)
  8000a7:	eb 13                	jmp    8000bc <_main+0x84>
		{
			cprintf("%~\b");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 65 1a 80 00       	push   $0x801a65
  8000b1:	e8 b1 02 00 00       	call   800367 <cprintf>
  8000b6:	83 c4 10             	add    $0x10,%esp
			cprintf_colored(txtClr, "%~%c",i);
		}
		int d=0;
		for(; d< 5000000; d++);
		c=0;
		for(;c<10; c++)
  8000b9:	ff 45 ec             	incl   -0x14(%ebp)
  8000bc:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
  8000c0:	7e e7                	jle    8000a9 <_main+0x71>
void
_main(void)
{
	int i=28;
	int txtClr = TEXT_black;
	for(;i<128; i++)
  8000c2:	ff 45 f4             	incl   -0xc(%ebp)
  8000c5:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  8000c9:	7e 83                	jle    80004e <_main+0x16>
		{
			cprintf("%~\b");
		}
	}

	return;
  8000cb:	90                   	nop
}
  8000cc:	c9                   	leave  
  8000cd:	c3                   	ret    

008000ce <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	57                   	push   %edi
  8000d2:	56                   	push   %esi
  8000d3:	53                   	push   %ebx
  8000d4:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000d7:	e8 58 14 00 00       	call   801534 <sys_getenvindex>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000e2:	89 d0                	mov    %edx,%eax
  8000e4:	c1 e0 02             	shl    $0x2,%eax
  8000e7:	01 d0                	add    %edx,%eax
  8000e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000f0:	01 d0                	add    %edx,%eax
  8000f2:	89 c2                	mov    %eax,%edx
  8000f4:	c1 e2 04             	shl    $0x4,%edx
  8000f7:	29 c2                	sub    %eax,%edx
  8000f9:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800100:	89 c2                	mov    %eax,%edx
  800102:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800108:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80010d:	a1 20 20 80 00       	mov    0x802020,%eax
  800112:	8a 40 20             	mov    0x20(%eax),%al
  800115:	84 c0                	test   %al,%al
  800117:	74 0d                	je     800126 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800119:	a1 20 20 80 00       	mov    0x802020,%eax
  80011e:	83 c0 20             	add    $0x20,%eax
  800121:	a3 04 20 80 00       	mov    %eax,0x802004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800126:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012a:	7e 0a                	jle    800136 <libmain+0x68>
		binaryname = argv[0];
  80012c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012f:	8b 00                	mov    (%eax),%eax
  800131:	a3 04 20 80 00       	mov    %eax,0x802004

	// call user main routine
	_main(argc, argv);
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	ff 75 0c             	pushl  0xc(%ebp)
  80013c:	ff 75 08             	pushl  0x8(%ebp)
  80013f:	e8 f4 fe ff ff       	call   800038 <_main>
  800144:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800147:	a1 00 20 80 00       	mov    0x802000,%eax
  80014c:	85 c0                	test   %eax,%eax
  80014e:	0f 84 01 01 00 00    	je     800255 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800154:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80015a:	bb 64 1b 80 00       	mov    $0x801b64,%ebx
  80015f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800164:	89 c7                	mov    %eax,%edi
  800166:	89 de                	mov    %ebx,%esi
  800168:	89 d1                	mov    %edx,%ecx
  80016a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80016c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80016f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800174:	b0 00                	mov    $0x0,%al
  800176:	89 d7                	mov    %edx,%edi
  800178:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80017a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800181:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	50                   	push   %eax
  800188:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 d6 15 00 00       	call   80176a <sys_utilities>
  800194:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800197:	e8 1f 11 00 00       	call   8012bb <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	68 84 1a 80 00       	push   $0x801a84
  8001a4:	e8 be 01 00 00       	call   800367 <cprintf>
  8001a9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001af:	85 c0                	test   %eax,%eax
  8001b1:	74 18                	je     8001cb <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001b3:	e8 d0 15 00 00       	call   801788 <sys_get_optimal_num_faults>
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	50                   	push   %eax
  8001bc:	68 ac 1a 80 00       	push   $0x801aac
  8001c1:	e8 a1 01 00 00       	call   800367 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	eb 59                	jmp    800224 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cb:	a1 20 20 80 00       	mov    0x802020,%eax
  8001d0:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8001d6:	a1 20 20 80 00       	mov    0x802020,%eax
  8001db:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001e1:	83 ec 04             	sub    $0x4,%esp
  8001e4:	52                   	push   %edx
  8001e5:	50                   	push   %eax
  8001e6:	68 d0 1a 80 00       	push   $0x801ad0
  8001eb:	e8 77 01 00 00       	call   800367 <cprintf>
  8001f0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f3:	a1 20 20 80 00       	mov    0x802020,%eax
  8001f8:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8001fe:	a1 20 20 80 00       	mov    0x802020,%eax
  800203:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800209:	a1 20 20 80 00       	mov    0x802020,%eax
  80020e:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800214:	51                   	push   %ecx
  800215:	52                   	push   %edx
  800216:	50                   	push   %eax
  800217:	68 f8 1a 80 00       	push   $0x801af8
  80021c:	e8 46 01 00 00       	call   800367 <cprintf>
  800221:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800224:	a1 20 20 80 00       	mov    0x802020,%eax
  800229:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80022f:	83 ec 08             	sub    $0x8,%esp
  800232:	50                   	push   %eax
  800233:	68 50 1b 80 00       	push   $0x801b50
  800238:	e8 2a 01 00 00       	call   800367 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	68 84 1a 80 00       	push   $0x801a84
  800248:	e8 1a 01 00 00       	call   800367 <cprintf>
  80024d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800250:	e8 80 10 00 00       	call   8012d5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800255:	e8 1f 00 00 00       	call   800279 <exit>
}
  80025a:	90                   	nop
  80025b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025e:	5b                   	pop    %ebx
  80025f:	5e                   	pop    %esi
  800260:	5f                   	pop    %edi
  800261:	5d                   	pop    %ebp
  800262:	c3                   	ret    

00800263 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	6a 00                	push   $0x0
  80026e:	e8 8d 12 00 00       	call   801500 <sys_destroy_env>
  800273:	83 c4 10             	add    $0x10,%esp
}
  800276:	90                   	nop
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <exit>:

void
exit(void)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027f:	e8 e2 12 00 00       	call   801566 <sys_exit_env>
}
  800284:	90                   	nop
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	53                   	push   %ebx
  80028b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80028e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800291:	8b 00                	mov    (%eax),%eax
  800293:	8d 48 01             	lea    0x1(%eax),%ecx
  800296:	8b 55 0c             	mov    0xc(%ebp),%edx
  800299:	89 0a                	mov    %ecx,(%edx)
  80029b:	8b 55 08             	mov    0x8(%ebp),%edx
  80029e:	88 d1                	mov    %dl,%cl
  8002a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b1:	75 30                	jne    8002e3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002b3:	8b 15 18 a1 81 00    	mov    0x81a118,%edx
  8002b9:	a0 44 20 80 00       	mov    0x802044,%al
  8002be:	0f b6 c0             	movzbl %al,%eax
  8002c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c4:	8b 09                	mov    (%ecx),%ecx
  8002c6:	89 cb                	mov    %ecx,%ebx
  8002c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002cb:	83 c1 08             	add    $0x8,%ecx
  8002ce:	52                   	push   %edx
  8002cf:	50                   	push   %eax
  8002d0:	53                   	push   %ebx
  8002d1:	51                   	push   %ecx
  8002d2:	e8 a0 0f 00 00       	call   801277 <sys_cputs>
  8002d7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e6:	8b 40 04             	mov    0x4(%eax),%eax
  8002e9:	8d 50 01             	lea    0x1(%eax),%edx
  8002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ef:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002f2:	90                   	nop
  8002f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002f6:	c9                   	leave  
  8002f7:	c3                   	ret    

008002f8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800301:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800308:	00 00 00 
	b.cnt = 0;
  80030b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800312:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800315:	ff 75 0c             	pushl  0xc(%ebp)
  800318:	ff 75 08             	pushl  0x8(%ebp)
  80031b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800321:	50                   	push   %eax
  800322:	68 87 02 80 00       	push   $0x800287
  800327:	e8 5a 02 00 00       	call   800586 <vprintfmt>
  80032c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80032f:	8b 15 18 a1 81 00    	mov    0x81a118,%edx
  800335:	a0 44 20 80 00       	mov    0x802044,%al
  80033a:	0f b6 c0             	movzbl %al,%eax
  80033d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800343:	52                   	push   %edx
  800344:	50                   	push   %eax
  800345:	51                   	push   %ecx
  800346:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034c:	83 c0 08             	add    $0x8,%eax
  80034f:	50                   	push   %eax
  800350:	e8 22 0f 00 00       	call   801277 <sys_cputs>
  800355:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800358:	c6 05 44 20 80 00 00 	movb   $0x0,0x802044
	return b.cnt;
  80035f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80036d:	c6 05 44 20 80 00 01 	movb   $0x1,0x802044
	va_start(ap, fmt);
  800374:	8d 45 0c             	lea    0xc(%ebp),%eax
  800377:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80037a:	8b 45 08             	mov    0x8(%ebp),%eax
  80037d:	83 ec 08             	sub    $0x8,%esp
  800380:	ff 75 f4             	pushl  -0xc(%ebp)
  800383:	50                   	push   %eax
  800384:	e8 6f ff ff ff       	call   8002f8 <vcprintf>
  800389:	83 c4 10             	add    $0x10,%esp
  80038c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80038f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800392:	c9                   	leave  
  800393:	c3                   	ret    

00800394 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80039a:	c6 05 44 20 80 00 01 	movb   $0x1,0x802044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	c1 e0 08             	shl    $0x8,%eax
  8003a7:	a3 18 a1 81 00       	mov    %eax,0x81a118
	va_start(ap, fmt);
  8003ac:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003af:	83 c0 04             	add    $0x4,%eax
  8003b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003be:	50                   	push   %eax
  8003bf:	e8 34 ff ff ff       	call   8002f8 <vcprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
  8003c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003ca:	c7 05 18 a1 81 00 00 	movl   $0x700,0x81a118
  8003d1:	07 00 00 

	return cnt;
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003df:	e8 d7 0e 00 00       	call   8012bb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003e4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	83 ec 08             	sub    $0x8,%esp
  8003f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f3:	50                   	push   %eax
  8003f4:	e8 ff fe ff ff       	call   8002f8 <vcprintf>
  8003f9:	83 c4 10             	add    $0x10,%esp
  8003fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003ff:	e8 d1 0e 00 00       	call   8012d5 <sys_unlock_cons>
	return cnt;
  800404:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	53                   	push   %ebx
  80040d:	83 ec 14             	sub    $0x14,%esp
  800410:	8b 45 10             	mov    0x10(%ebp),%eax
  800413:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80041c:	8b 45 18             	mov    0x18(%ebp),%eax
  80041f:	ba 00 00 00 00       	mov    $0x0,%edx
  800424:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800427:	77 55                	ja     80047e <printnum+0x75>
  800429:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80042c:	72 05                	jb     800433 <printnum+0x2a>
  80042e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800431:	77 4b                	ja     80047e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800433:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800436:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800439:	8b 45 18             	mov    0x18(%ebp),%eax
  80043c:	ba 00 00 00 00       	mov    $0x0,%edx
  800441:	52                   	push   %edx
  800442:	50                   	push   %eax
  800443:	ff 75 f4             	pushl  -0xc(%ebp)
  800446:	ff 75 f0             	pushl  -0x10(%ebp)
  800449:	e8 aa 13 00 00       	call   8017f8 <__udivdi3>
  80044e:	83 c4 10             	add    $0x10,%esp
  800451:	83 ec 04             	sub    $0x4,%esp
  800454:	ff 75 20             	pushl  0x20(%ebp)
  800457:	53                   	push   %ebx
  800458:	ff 75 18             	pushl  0x18(%ebp)
  80045b:	52                   	push   %edx
  80045c:	50                   	push   %eax
  80045d:	ff 75 0c             	pushl  0xc(%ebp)
  800460:	ff 75 08             	pushl  0x8(%ebp)
  800463:	e8 a1 ff ff ff       	call   800409 <printnum>
  800468:	83 c4 20             	add    $0x20,%esp
  80046b:	eb 1a                	jmp    800487 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 0c             	pushl  0xc(%ebp)
  800473:	ff 75 20             	pushl  0x20(%ebp)
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	ff d0                	call   *%eax
  80047b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80047e:	ff 4d 1c             	decl   0x1c(%ebp)
  800481:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800485:	7f e6                	jg     80046d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800487:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80048a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80048f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800492:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800495:	53                   	push   %ebx
  800496:	51                   	push   %ecx
  800497:	52                   	push   %edx
  800498:	50                   	push   %eax
  800499:	e8 6a 14 00 00       	call   801908 <__umoddi3>
  80049e:	83 c4 10             	add    $0x10,%esp
  8004a1:	05 f4 1d 80 00       	add    $0x801df4,%eax
  8004a6:	8a 00                	mov    (%eax),%al
  8004a8:	0f be c0             	movsbl %al,%eax
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	ff 75 0c             	pushl  0xc(%ebp)
  8004b1:	50                   	push   %eax
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	ff d0                	call   *%eax
  8004b7:	83 c4 10             	add    $0x10,%esp
}
  8004ba:	90                   	nop
  8004bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004c7:	7e 1c                	jle    8004e5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	8d 50 08             	lea    0x8(%eax),%edx
  8004d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d4:	89 10                	mov    %edx,(%eax)
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	83 e8 08             	sub    $0x8,%eax
  8004de:	8b 50 04             	mov    0x4(%eax),%edx
  8004e1:	8b 00                	mov    (%eax),%eax
  8004e3:	eb 40                	jmp    800525 <getuint+0x65>
	else if (lflag)
  8004e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004e9:	74 1e                	je     800509 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	8d 50 04             	lea    0x4(%eax),%edx
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	89 10                	mov    %edx,(%eax)
  8004f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	83 e8 04             	sub    $0x4,%eax
  800500:	8b 00                	mov    (%eax),%eax
  800502:	ba 00 00 00 00       	mov    $0x0,%edx
  800507:	eb 1c                	jmp    800525 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800509:	8b 45 08             	mov    0x8(%ebp),%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	8d 50 04             	lea    0x4(%eax),%edx
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	89 10                	mov    %edx,(%eax)
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	83 e8 04             	sub    $0x4,%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800525:	5d                   	pop    %ebp
  800526:	c3                   	ret    

00800527 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80052a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80052e:	7e 1c                	jle    80054c <getint+0x25>
		return va_arg(*ap, long long);
  800530:	8b 45 08             	mov    0x8(%ebp),%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	8d 50 08             	lea    0x8(%eax),%edx
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	89 10                	mov    %edx,(%eax)
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	83 e8 08             	sub    $0x8,%eax
  800545:	8b 50 04             	mov    0x4(%eax),%edx
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	eb 38                	jmp    800584 <getint+0x5d>
	else if (lflag)
  80054c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800550:	74 1a                	je     80056c <getint+0x45>
		return va_arg(*ap, long);
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	8d 50 04             	lea    0x4(%eax),%edx
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	89 10                	mov    %edx,(%eax)
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	83 e8 04             	sub    $0x4,%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	99                   	cltd   
  80056a:	eb 18                	jmp    800584 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	8d 50 04             	lea    0x4(%eax),%edx
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	89 10                	mov    %edx,(%eax)
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	83 e8 04             	sub    $0x4,%eax
  800581:	8b 00                	mov    (%eax),%eax
  800583:	99                   	cltd   
}
  800584:	5d                   	pop    %ebp
  800585:	c3                   	ret    

00800586 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800586:	55                   	push   %ebp
  800587:	89 e5                	mov    %esp,%ebp
  800589:	56                   	push   %esi
  80058a:	53                   	push   %ebx
  80058b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80058e:	eb 17                	jmp    8005a7 <vprintfmt+0x21>
			if (ch == '\0')
  800590:	85 db                	test   %ebx,%ebx
  800592:	0f 84 c1 03 00 00    	je     800959 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	53                   	push   %ebx
  80059f:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a2:	ff d0                	call   *%eax
  8005a4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005aa:	8d 50 01             	lea    0x1(%eax),%edx
  8005ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b0:	8a 00                	mov    (%eax),%al
  8005b2:	0f b6 d8             	movzbl %al,%ebx
  8005b5:	83 fb 25             	cmp    $0x25,%ebx
  8005b8:	75 d6                	jne    800590 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005ba:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005be:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005c5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005d3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	8b 45 10             	mov    0x10(%ebp),%eax
  8005dd:	8d 50 01             	lea    0x1(%eax),%edx
  8005e0:	89 55 10             	mov    %edx,0x10(%ebp)
  8005e3:	8a 00                	mov    (%eax),%al
  8005e5:	0f b6 d8             	movzbl %al,%ebx
  8005e8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005eb:	83 f8 5b             	cmp    $0x5b,%eax
  8005ee:	0f 87 3d 03 00 00    	ja     800931 <vprintfmt+0x3ab>
  8005f4:	8b 04 85 18 1e 80 00 	mov    0x801e18(,%eax,4),%eax
  8005fb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005fd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800601:	eb d7                	jmp    8005da <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800603:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800607:	eb d1                	jmp    8005da <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800609:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800610:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800613:	89 d0                	mov    %edx,%eax
  800615:	c1 e0 02             	shl    $0x2,%eax
  800618:	01 d0                	add    %edx,%eax
  80061a:	01 c0                	add    %eax,%eax
  80061c:	01 d8                	add    %ebx,%eax
  80061e:	83 e8 30             	sub    $0x30,%eax
  800621:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800624:	8b 45 10             	mov    0x10(%ebp),%eax
  800627:	8a 00                	mov    (%eax),%al
  800629:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80062c:	83 fb 2f             	cmp    $0x2f,%ebx
  80062f:	7e 3e                	jle    80066f <vprintfmt+0xe9>
  800631:	83 fb 39             	cmp    $0x39,%ebx
  800634:	7f 39                	jg     80066f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800636:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800639:	eb d5                	jmp    800610 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	83 c0 04             	add    $0x4,%eax
  800641:	89 45 14             	mov    %eax,0x14(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	83 e8 04             	sub    $0x4,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80064f:	eb 1f                	jmp    800670 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800651:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800655:	79 83                	jns    8005da <vprintfmt+0x54>
				width = 0;
  800657:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80065e:	e9 77 ff ff ff       	jmp    8005da <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800663:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80066a:	e9 6b ff ff ff       	jmp    8005da <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80066f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800670:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800674:	0f 89 60 ff ff ff    	jns    8005da <vprintfmt+0x54>
				width = precision, precision = -1;
  80067a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800680:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800687:	e9 4e ff ff ff       	jmp    8005da <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80068c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80068f:	e9 46 ff ff ff       	jmp    8005da <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	83 c0 04             	add    $0x4,%eax
  80069a:	89 45 14             	mov    %eax,0x14(%ebp)
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	83 e8 04             	sub    $0x4,%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	50                   	push   %eax
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	ff d0                	call   *%eax
  8006b1:	83 c4 10             	add    $0x10,%esp
			break;
  8006b4:	e9 9b 02 00 00       	jmp    800954 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	83 c0 04             	add    $0x4,%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	83 e8 04             	sub    $0x4,%eax
  8006c8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006ca:	85 db                	test   %ebx,%ebx
  8006cc:	79 02                	jns    8006d0 <vprintfmt+0x14a>
				err = -err;
  8006ce:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006d0:	83 fb 64             	cmp    $0x64,%ebx
  8006d3:	7f 0b                	jg     8006e0 <vprintfmt+0x15a>
  8006d5:	8b 34 9d 60 1c 80 00 	mov    0x801c60(,%ebx,4),%esi
  8006dc:	85 f6                	test   %esi,%esi
  8006de:	75 19                	jne    8006f9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006e0:	53                   	push   %ebx
  8006e1:	68 05 1e 80 00       	push   $0x801e05
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	e8 70 02 00 00       	call   800961 <printfmt>
  8006f1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006f4:	e9 5b 02 00 00       	jmp    800954 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006f9:	56                   	push   %esi
  8006fa:	68 0e 1e 80 00       	push   $0x801e0e
  8006ff:	ff 75 0c             	pushl  0xc(%ebp)
  800702:	ff 75 08             	pushl  0x8(%ebp)
  800705:	e8 57 02 00 00       	call   800961 <printfmt>
  80070a:	83 c4 10             	add    $0x10,%esp
			break;
  80070d:	e9 42 02 00 00       	jmp    800954 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	83 c0 04             	add    $0x4,%eax
  800718:	89 45 14             	mov    %eax,0x14(%ebp)
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	83 e8 04             	sub    $0x4,%eax
  800721:	8b 30                	mov    (%eax),%esi
  800723:	85 f6                	test   %esi,%esi
  800725:	75 05                	jne    80072c <vprintfmt+0x1a6>
				p = "(null)";
  800727:	be 11 1e 80 00       	mov    $0x801e11,%esi
			if (width > 0 && padc != '-')
  80072c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800730:	7e 6d                	jle    80079f <vprintfmt+0x219>
  800732:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800736:	74 67                	je     80079f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800738:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	50                   	push   %eax
  80073f:	56                   	push   %esi
  800740:	e8 1e 03 00 00       	call   800a63 <strnlen>
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80074b:	eb 16                	jmp    800763 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80074d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	ff 75 0c             	pushl  0xc(%ebp)
  800757:	50                   	push   %eax
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	ff d0                	call   *%eax
  80075d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800760:	ff 4d e4             	decl   -0x1c(%ebp)
  800763:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800767:	7f e4                	jg     80074d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800769:	eb 34                	jmp    80079f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80076b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80076f:	74 1c                	je     80078d <vprintfmt+0x207>
  800771:	83 fb 1f             	cmp    $0x1f,%ebx
  800774:	7e 05                	jle    80077b <vprintfmt+0x1f5>
  800776:	83 fb 7e             	cmp    $0x7e,%ebx
  800779:	7e 12                	jle    80078d <vprintfmt+0x207>
					putch('?', putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	6a 3f                	push   $0x3f
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	ff d0                	call   *%eax
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	eb 0f                	jmp    80079c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	53                   	push   %ebx
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	ff d0                	call   *%eax
  800799:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80079c:	ff 4d e4             	decl   -0x1c(%ebp)
  80079f:	89 f0                	mov    %esi,%eax
  8007a1:	8d 70 01             	lea    0x1(%eax),%esi
  8007a4:	8a 00                	mov    (%eax),%al
  8007a6:	0f be d8             	movsbl %al,%ebx
  8007a9:	85 db                	test   %ebx,%ebx
  8007ab:	74 24                	je     8007d1 <vprintfmt+0x24b>
  8007ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007b1:	78 b8                	js     80076b <vprintfmt+0x1e5>
  8007b3:	ff 4d e0             	decl   -0x20(%ebp)
  8007b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007ba:	79 af                	jns    80076b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007bc:	eb 13                	jmp    8007d1 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	6a 20                	push   $0x20
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	ff d0                	call   *%eax
  8007cb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007ce:	ff 4d e4             	decl   -0x1c(%ebp)
  8007d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d5:	7f e7                	jg     8007be <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007d7:	e9 78 01 00 00       	jmp    800954 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 e8             	pushl  -0x18(%ebp)
  8007e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e5:	50                   	push   %eax
  8007e6:	e8 3c fd ff ff       	call   800527 <getint>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007fa:	85 d2                	test   %edx,%edx
  8007fc:	79 23                	jns    800821 <vprintfmt+0x29b>
				putch('-', putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	6a 2d                	push   $0x2d
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80080e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800811:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800814:	f7 d8                	neg    %eax
  800816:	83 d2 00             	adc    $0x0,%edx
  800819:	f7 da                	neg    %edx
  80081b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800821:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800828:	e9 bc 00 00 00       	jmp    8008e9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 e8             	pushl  -0x18(%ebp)
  800833:	8d 45 14             	lea    0x14(%ebp),%eax
  800836:	50                   	push   %eax
  800837:	e8 84 fc ff ff       	call   8004c0 <getuint>
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800842:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800845:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80084c:	e9 98 00 00 00       	jmp    8008e9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	ff 75 0c             	pushl  0xc(%ebp)
  800857:	6a 58                	push   $0x58
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	ff d0                	call   *%eax
  80085e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	6a 58                	push   $0x58
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	ff d0                	call   *%eax
  80086e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	6a 58                	push   $0x58
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	ff d0                	call   *%eax
  80087e:	83 c4 10             	add    $0x10,%esp
			break;
  800881:	e9 ce 00 00 00       	jmp    800954 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800886:	83 ec 08             	sub    $0x8,%esp
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	6a 30                	push   $0x30
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	ff d0                	call   *%eax
  800893:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	6a 78                	push   $0x78
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	ff d0                	call   *%eax
  8008a3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	83 c0 04             	add    $0x4,%eax
  8008ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8008af:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b2:	83 e8 04             	sub    $0x4,%eax
  8008b5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008c1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008c8:	eb 1f                	jmp    8008e9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d3:	50                   	push   %eax
  8008d4:	e8 e7 fb ff ff       	call   8004c0 <getuint>
  8008d9:	83 c4 10             	add    $0x10,%esp
  8008dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008df:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008e2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008e9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f0:	83 ec 04             	sub    $0x4,%esp
  8008f3:	52                   	push   %edx
  8008f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008f7:	50                   	push   %eax
  8008f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	ff 75 08             	pushl  0x8(%ebp)
  800904:	e8 00 fb ff ff       	call   800409 <printnum>
  800909:	83 c4 20             	add    $0x20,%esp
			break;
  80090c:	eb 46                	jmp    800954 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	53                   	push   %ebx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
			break;
  80091d:	eb 35                	jmp    800954 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80091f:	c6 05 44 20 80 00 00 	movb   $0x0,0x802044
			break;
  800926:	eb 2c                	jmp    800954 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800928:	c6 05 44 20 80 00 01 	movb   $0x1,0x802044
			break;
  80092f:	eb 23                	jmp    800954 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800931:	83 ec 08             	sub    $0x8,%esp
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	6a 25                	push   $0x25
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	ff d0                	call   *%eax
  80093e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800941:	ff 4d 10             	decl   0x10(%ebp)
  800944:	eb 03                	jmp    800949 <vprintfmt+0x3c3>
  800946:	ff 4d 10             	decl   0x10(%ebp)
  800949:	8b 45 10             	mov    0x10(%ebp),%eax
  80094c:	48                   	dec    %eax
  80094d:	8a 00                	mov    (%eax),%al
  80094f:	3c 25                	cmp    $0x25,%al
  800951:	75 f3                	jne    800946 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800953:	90                   	nop
		}
	}
  800954:	e9 35 fc ff ff       	jmp    80058e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800959:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80095a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80095d:	5b                   	pop    %ebx
  80095e:	5e                   	pop    %esi
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800967:	8d 45 10             	lea    0x10(%ebp),%eax
  80096a:	83 c0 04             	add    $0x4,%eax
  80096d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800970:	8b 45 10             	mov    0x10(%ebp),%eax
  800973:	ff 75 f4             	pushl  -0xc(%ebp)
  800976:	50                   	push   %eax
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	ff 75 08             	pushl  0x8(%ebp)
  80097d:	e8 04 fc ff ff       	call   800586 <vprintfmt>
  800982:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800985:	90                   	nop
  800986:	c9                   	leave  
  800987:	c3                   	ret    

00800988 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80098b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098e:	8b 40 08             	mov    0x8(%eax),%eax
  800991:	8d 50 01             	lea    0x1(%eax),%edx
  800994:	8b 45 0c             	mov    0xc(%ebp),%eax
  800997:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	8b 10                	mov    (%eax),%edx
  80099f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a2:	8b 40 04             	mov    0x4(%eax),%eax
  8009a5:	39 c2                	cmp    %eax,%edx
  8009a7:	73 12                	jae    8009bb <sprintputch+0x33>
		*b->buf++ = ch;
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	8d 48 01             	lea    0x1(%eax),%ecx
  8009b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b4:	89 0a                	mov    %ecx,(%edx)
  8009b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b9:	88 10                	mov    %dl,(%eax)
}
  8009bb:	90                   	nop
  8009bc:	5d                   	pop    %ebp
  8009bd:	c3                   	ret    

008009be <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	01 d0                	add    %edx,%eax
  8009d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009e3:	74 06                	je     8009eb <vsnprintf+0x2d>
  8009e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009e9:	7f 07                	jg     8009f2 <vsnprintf+0x34>
		return -E_INVAL;
  8009eb:	b8 03 00 00 00       	mov    $0x3,%eax
  8009f0:	eb 20                	jmp    800a12 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009f2:	ff 75 14             	pushl  0x14(%ebp)
  8009f5:	ff 75 10             	pushl  0x10(%ebp)
  8009f8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009fb:	50                   	push   %eax
  8009fc:	68 88 09 80 00       	push   $0x800988
  800a01:	e8 80 fb ff ff       	call   800586 <vprintfmt>
  800a06:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a0c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a12:	c9                   	leave  
  800a13:	c3                   	ret    

00800a14 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800a1d:	83 c0 04             	add    $0x4,%eax
  800a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a23:	8b 45 10             	mov    0x10(%ebp),%eax
  800a26:	ff 75 f4             	pushl  -0xc(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	ff 75 08             	pushl  0x8(%ebp)
  800a30:	e8 89 ff ff ff       	call   8009be <vsnprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a3e:	c9                   	leave  
  800a3f:	c3                   	ret    

00800a40 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a4d:	eb 06                	jmp    800a55 <strlen+0x15>
		n++;
  800a4f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a52:	ff 45 08             	incl   0x8(%ebp)
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8a 00                	mov    (%eax),%al
  800a5a:	84 c0                	test   %al,%al
  800a5c:	75 f1                	jne    800a4f <strlen+0xf>
		n++;
	return n;
  800a5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a61:	c9                   	leave  
  800a62:	c3                   	ret    

00800a63 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a70:	eb 09                	jmp    800a7b <strnlen+0x18>
		n++;
  800a72:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a75:	ff 45 08             	incl   0x8(%ebp)
  800a78:	ff 4d 0c             	decl   0xc(%ebp)
  800a7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a7f:	74 09                	je     800a8a <strnlen+0x27>
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	8a 00                	mov    (%eax),%al
  800a86:	84 c0                	test   %al,%al
  800a88:	75 e8                	jne    800a72 <strnlen+0xf>
		n++;
	return n;
  800a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a9b:	90                   	nop
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8d 50 01             	lea    0x1(%eax),%edx
  800aa2:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aae:	8a 12                	mov    (%edx),%dl
  800ab0:	88 10                	mov    %dl,(%eax)
  800ab2:	8a 00                	mov    (%eax),%al
  800ab4:	84 c0                	test   %al,%al
  800ab6:	75 e4                	jne    800a9c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ab8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800abb:	c9                   	leave  
  800abc:	c3                   	ret    

00800abd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ac9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ad0:	eb 1f                	jmp    800af1 <strncpy+0x34>
		*dst++ = *src;
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8d 50 01             	lea    0x1(%eax),%edx
  800ad8:	89 55 08             	mov    %edx,0x8(%ebp)
  800adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ade:	8a 12                	mov    (%edx),%dl
  800ae0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae5:	8a 00                	mov    (%eax),%al
  800ae7:	84 c0                	test   %al,%al
  800ae9:	74 03                	je     800aee <strncpy+0x31>
			src++;
  800aeb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aee:	ff 45 fc             	incl   -0x4(%ebp)
  800af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800af4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800af7:	72 d9                	jb     800ad2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800af9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800afc:	c9                   	leave  
  800afd:	c3                   	ret    

00800afe <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b0e:	74 30                	je     800b40 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b10:	eb 16                	jmp    800b28 <strlcpy+0x2a>
			*dst++ = *src++;
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8d 50 01             	lea    0x1(%eax),%edx
  800b18:	89 55 08             	mov    %edx,0x8(%ebp)
  800b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b21:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b24:	8a 12                	mov    (%edx),%dl
  800b26:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b28:	ff 4d 10             	decl   0x10(%ebp)
  800b2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b2f:	74 09                	je     800b3a <strlcpy+0x3c>
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8a 00                	mov    (%eax),%al
  800b36:	84 c0                	test   %al,%al
  800b38:	75 d8                	jne    800b12 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b40:	8b 55 08             	mov    0x8(%ebp),%edx
  800b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b46:	29 c2                	sub    %eax,%edx
  800b48:	89 d0                	mov    %edx,%eax
}
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b4f:	eb 06                	jmp    800b57 <strcmp+0xb>
		p++, q++;
  800b51:	ff 45 08             	incl   0x8(%ebp)
  800b54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	8a 00                	mov    (%eax),%al
  800b5c:	84 c0                	test   %al,%al
  800b5e:	74 0e                	je     800b6e <strcmp+0x22>
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8a 10                	mov    (%eax),%dl
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	8a 00                	mov    (%eax),%al
  800b6a:	38 c2                	cmp    %al,%dl
  800b6c:	74 e3                	je     800b51 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8a 00                	mov    (%eax),%al
  800b73:	0f b6 d0             	movzbl %al,%edx
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	8a 00                	mov    (%eax),%al
  800b7b:	0f b6 c0             	movzbl %al,%eax
  800b7e:	29 c2                	sub    %eax,%edx
  800b80:	89 d0                	mov    %edx,%eax
}
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b87:	eb 09                	jmp    800b92 <strncmp+0xe>
		n--, p++, q++;
  800b89:	ff 4d 10             	decl   0x10(%ebp)
  800b8c:	ff 45 08             	incl   0x8(%ebp)
  800b8f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b96:	74 17                	je     800baf <strncmp+0x2b>
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8a 00                	mov    (%eax),%al
  800b9d:	84 c0                	test   %al,%al
  800b9f:	74 0e                	je     800baf <strncmp+0x2b>
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8a 10                	mov    (%eax),%dl
  800ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	38 c2                	cmp    %al,%dl
  800bad:	74 da                	je     800b89 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800baf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bb3:	75 07                	jne    800bbc <strncmp+0x38>
		return 0;
  800bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bba:	eb 14                	jmp    800bd0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	0f b6 d0             	movzbl %al,%edx
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8a 00                	mov    (%eax),%al
  800bc9:	0f b6 c0             	movzbl %al,%eax
  800bcc:	29 c2                	sub    %eax,%edx
  800bce:	89 d0                	mov    %edx,%eax
}
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	83 ec 04             	sub    $0x4,%esp
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bde:	eb 12                	jmp    800bf2 <strchr+0x20>
		if (*s == c)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8a 00                	mov    (%eax),%al
  800be5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800be8:	75 05                	jne    800bef <strchr+0x1d>
			return (char *) s;
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	eb 11                	jmp    800c00 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bef:	ff 45 08             	incl   0x8(%ebp)
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	8a 00                	mov    (%eax),%al
  800bf7:	84 c0                	test   %al,%al
  800bf9:	75 e5                	jne    800be0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 04             	sub    $0x4,%esp
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c0e:	eb 0d                	jmp    800c1d <strfind+0x1b>
		if (*s == c)
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c18:	74 0e                	je     800c28 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c1a:	ff 45 08             	incl   0x8(%ebp)
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	8a 00                	mov    (%eax),%al
  800c22:	84 c0                	test   %al,%al
  800c24:	75 ea                	jne    800c10 <strfind+0xe>
  800c26:	eb 01                	jmp    800c29 <strfind+0x27>
		if (*s == c)
			break;
  800c28:	90                   	nop
	return (char *) s;
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c2c:	c9                   	leave  
  800c2d:	c3                   	ret    

00800c2e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c3a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c3e:	76 63                	jbe    800ca3 <memset+0x75>
		uint64 data_block = c;
  800c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c43:	99                   	cltd   
  800c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c47:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c50:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800c54:	c1 e0 08             	shl    $0x8,%eax
  800c57:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c5a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c63:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800c67:	c1 e0 10             	shl    $0x10,%eax
  800c6a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c6d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c76:	89 c2                	mov    %eax,%edx
  800c78:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c80:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c83:	eb 18                	jmp    800c9d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c85:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c88:	8d 41 08             	lea    0x8(%ecx),%eax
  800c8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c94:	89 01                	mov    %eax,(%ecx)
  800c96:	89 51 04             	mov    %edx,0x4(%ecx)
  800c99:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c9d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ca1:	77 e2                	ja     800c85 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 23                	je     800ccc <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ca9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cac:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800caf:	eb 0e                	jmp    800cbf <memset+0x91>
			*p8++ = (uint8)c;
  800cb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cb4:	8d 50 01             	lea    0x1(%eax),%edx
  800cb7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbd:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800cbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc8:	85 c0                	test   %eax,%eax
  800cca:	75 e5                	jne    800cb1 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ce3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ce7:	76 24                	jbe    800d0d <memcpy+0x3c>
		while(n >= 8){
  800ce9:	eb 1c                	jmp    800d07 <memcpy+0x36>
			*d64 = *s64;
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cee:	8b 50 04             	mov    0x4(%eax),%edx
  800cf1:	8b 00                	mov    (%eax),%eax
  800cf3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800cf6:	89 01                	mov    %eax,(%ecx)
  800cf8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800cfb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800cff:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800d03:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800d07:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d0b:	77 de                	ja     800ceb <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d11:	74 31                	je     800d44 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d1f:	eb 16                	jmp    800d37 <memcpy+0x66>
			*d8++ = *s8++;
  800d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d24:	8d 50 01             	lea    0x1(%eax),%edx
  800d27:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d30:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d33:	8a 12                	mov    (%edx),%dl
  800d35:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d37:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d40:	85 c0                	test   %eax,%eax
  800d42:	75 dd                	jne    800d21 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d61:	73 50                	jae    800db3 <memmove+0x6a>
  800d63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d66:	8b 45 10             	mov    0x10(%ebp),%eax
  800d69:	01 d0                	add    %edx,%eax
  800d6b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6e:	76 43                	jbe    800db3 <memmove+0x6a>
		s += n;
  800d70:	8b 45 10             	mov    0x10(%ebp),%eax
  800d73:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d76:	8b 45 10             	mov    0x10(%ebp),%eax
  800d79:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d7c:	eb 10                	jmp    800d8e <memmove+0x45>
			*--d = *--s;
  800d7e:	ff 4d f8             	decl   -0x8(%ebp)
  800d81:	ff 4d fc             	decl   -0x4(%ebp)
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	8a 10                	mov    (%eax),%dl
  800d89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d94:	89 55 10             	mov    %edx,0x10(%ebp)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	75 e3                	jne    800d7e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d9b:	eb 23                	jmp    800dc0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da0:	8d 50 01             	lea    0x1(%eax),%edx
  800da3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800da6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800daf:	8a 12                	mov    (%edx),%dl
  800db1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800db3:	8b 45 10             	mov    0x10(%ebp),%eax
  800db6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	75 dd                	jne    800d9d <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dd7:	eb 2a                	jmp    800e03 <memcmp+0x3e>
		if (*s1 != *s2)
  800dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddc:	8a 10                	mov    (%eax),%dl
  800dde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	38 c2                	cmp    %al,%dl
  800de5:	74 16                	je     800dfd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800de7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f b6 d0             	movzbl %al,%edx
  800def:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
  800dfb:	eb 18                	jmp    800e15 <memcmp+0x50>
		s1++, s2++;
  800dfd:	ff 45 fc             	incl   -0x4(%ebp)
  800e00:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e09:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	75 c9                	jne    800dd9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e20:	8b 45 10             	mov    0x10(%ebp),%eax
  800e23:	01 d0                	add    %edx,%eax
  800e25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e28:	eb 15                	jmp    800e3f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	0f b6 d0             	movzbl %al,%edx
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	0f b6 c0             	movzbl %al,%eax
  800e38:	39 c2                	cmp    %eax,%edx
  800e3a:	74 0d                	je     800e49 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e3c:	ff 45 08             	incl   0x8(%ebp)
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e45:	72 e3                	jb     800e2a <memfind+0x13>
  800e47:	eb 01                	jmp    800e4a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e49:	90                   	nop
	return (void *) s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e5c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e63:	eb 03                	jmp    800e68 <strtol+0x19>
		s++;
  800e65:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	3c 20                	cmp    $0x20,%al
  800e6f:	74 f4                	je     800e65 <strtol+0x16>
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	3c 09                	cmp    $0x9,%al
  800e78:	74 eb                	je     800e65 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	3c 2b                	cmp    $0x2b,%al
  800e81:	75 05                	jne    800e88 <strtol+0x39>
		s++;
  800e83:	ff 45 08             	incl   0x8(%ebp)
  800e86:	eb 13                	jmp    800e9b <strtol+0x4c>
	else if (*s == '-')
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	3c 2d                	cmp    $0x2d,%al
  800e8f:	75 0a                	jne    800e9b <strtol+0x4c>
		s++, neg = 1;
  800e91:	ff 45 08             	incl   0x8(%ebp)
  800e94:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9f:	74 06                	je     800ea7 <strtol+0x58>
  800ea1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ea5:	75 20                	jne    800ec7 <strtol+0x78>
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	3c 30                	cmp    $0x30,%al
  800eae:	75 17                	jne    800ec7 <strtol+0x78>
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	40                   	inc    %eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	3c 78                	cmp    $0x78,%al
  800eb8:	75 0d                	jne    800ec7 <strtol+0x78>
		s += 2, base = 16;
  800eba:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ebe:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ec5:	eb 28                	jmp    800eef <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ec7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecb:	75 15                	jne    800ee2 <strtol+0x93>
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	3c 30                	cmp    $0x30,%al
  800ed4:	75 0c                	jne    800ee2 <strtol+0x93>
		s++, base = 8;
  800ed6:	ff 45 08             	incl   0x8(%ebp)
  800ed9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ee0:	eb 0d                	jmp    800eef <strtol+0xa0>
	else if (base == 0)
  800ee2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee6:	75 07                	jne    800eef <strtol+0xa0>
		base = 10;
  800ee8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	3c 2f                	cmp    $0x2f,%al
  800ef6:	7e 19                	jle    800f11 <strtol+0xc2>
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	3c 39                	cmp    $0x39,%al
  800eff:	7f 10                	jg     800f11 <strtol+0xc2>
			dig = *s - '0';
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f be c0             	movsbl %al,%eax
  800f09:	83 e8 30             	sub    $0x30,%eax
  800f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f0f:	eb 42                	jmp    800f53 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	3c 60                	cmp    $0x60,%al
  800f18:	7e 19                	jle    800f33 <strtol+0xe4>
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	3c 7a                	cmp    $0x7a,%al
  800f21:	7f 10                	jg     800f33 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	0f be c0             	movsbl %al,%eax
  800f2b:	83 e8 57             	sub    $0x57,%eax
  800f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f31:	eb 20                	jmp    800f53 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	3c 40                	cmp    $0x40,%al
  800f3a:	7e 39                	jle    800f75 <strtol+0x126>
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	3c 5a                	cmp    $0x5a,%al
  800f43:	7f 30                	jg     800f75 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	0f be c0             	movsbl %al,%eax
  800f4d:	83 e8 37             	sub    $0x37,%eax
  800f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f56:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f59:	7d 19                	jge    800f74 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f5b:	ff 45 08             	incl   0x8(%ebp)
  800f5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f61:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f65:	89 c2                	mov    %eax,%edx
  800f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6a:	01 d0                	add    %edx,%eax
  800f6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f6f:	e9 7b ff ff ff       	jmp    800eef <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f74:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f79:	74 08                	je     800f83 <strtol+0x134>
		*endptr = (char *) s;
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f81:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f83:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f87:	74 07                	je     800f90 <strtol+0x141>
  800f89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8c:	f7 d8                	neg    %eax
  800f8e:	eb 03                	jmp    800f93 <strtol+0x144>
  800f90:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    

00800f95 <ltostr>:

void
ltostr(long value, char *str)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fa2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fad:	79 13                	jns    800fc2 <ltostr+0x2d>
	{
		neg = 1;
  800faf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fbc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fbf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fca:	99                   	cltd   
  800fcb:	f7 f9                	idiv   %ecx
  800fcd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd3:	8d 50 01             	lea    0x1(%eax),%edx
  800fd6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd9:	89 c2                	mov    %eax,%edx
  800fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fde:	01 d0                	add    %edx,%eax
  800fe0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fe3:	83 c2 30             	add    $0x30,%edx
  800fe6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fe8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800feb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff0:	f7 e9                	imul   %ecx
  800ff2:	c1 fa 02             	sar    $0x2,%edx
  800ff5:	89 c8                	mov    %ecx,%eax
  800ff7:	c1 f8 1f             	sar    $0x1f,%eax
  800ffa:	29 c2                	sub    %eax,%edx
  800ffc:	89 d0                	mov    %edx,%eax
  800ffe:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801001:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801005:	75 bb                	jne    800fc2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801007:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80100e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801011:	48                   	dec    %eax
  801012:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801015:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801019:	74 3d                	je     801058 <ltostr+0xc3>
		start = 1 ;
  80101b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801022:	eb 34                	jmp    801058 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801024:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801031:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	01 c2                	add    %eax,%edx
  801039:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	01 c8                	add    %ecx,%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801045:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	01 c2                	add    %eax,%edx
  80104d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801050:	88 02                	mov    %al,(%edx)
		start++ ;
  801052:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801055:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80105e:	7c c4                	jl     801024 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801060:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80106b:	90                   	nop
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801074:	ff 75 08             	pushl  0x8(%ebp)
  801077:	e8 c4 f9 ff ff       	call   800a40 <strlen>
  80107c:	83 c4 04             	add    $0x4,%esp
  80107f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	e8 b6 f9 ff ff       	call   800a40 <strlen>
  80108a:	83 c4 04             	add    $0x4,%esp
  80108d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801097:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109e:	eb 17                	jmp    8010b7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a6:	01 c2                	add    %eax,%edx
  8010a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	01 c8                	add    %ecx,%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010b4:	ff 45 fc             	incl   -0x4(%ebp)
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010bd:	7c e1                	jl     8010a0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010cd:	eb 1f                	jmp    8010ee <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d2:	8d 50 01             	lea    0x1(%eax),%edx
  8010d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010d8:	89 c2                	mov    %eax,%edx
  8010da:	8b 45 10             	mov    0x10(%ebp),%eax
  8010dd:	01 c2                	add    %eax,%edx
  8010df:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e5:	01 c8                	add    %ecx,%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010eb:	ff 45 f8             	incl   -0x8(%ebp)
  8010ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f4:	7c d9                	jl     8010cf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fc:	01 d0                	add    %edx,%eax
  8010fe:	c6 00 00             	movb   $0x0,(%eax)
}
  801101:	90                   	nop
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801107:	8b 45 14             	mov    0x14(%ebp),%eax
  80110a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801110:	8b 45 14             	mov    0x14(%ebp),%eax
  801113:	8b 00                	mov    (%eax),%eax
  801115:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80111c:	8b 45 10             	mov    0x10(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801127:	eb 0c                	jmp    801135 <strsplit+0x31>
			*string++ = 0;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8d 50 01             	lea    0x1(%eax),%edx
  80112f:	89 55 08             	mov    %edx,0x8(%ebp)
  801132:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	84 c0                	test   %al,%al
  80113c:	74 18                	je     801156 <strsplit+0x52>
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	0f be c0             	movsbl %al,%eax
  801146:	50                   	push   %eax
  801147:	ff 75 0c             	pushl  0xc(%ebp)
  80114a:	e8 83 fa ff ff       	call   800bd2 <strchr>
  80114f:	83 c4 08             	add    $0x8,%esp
  801152:	85 c0                	test   %eax,%eax
  801154:	75 d3                	jne    801129 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	84 c0                	test   %al,%al
  80115d:	74 5a                	je     8011b9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80115f:	8b 45 14             	mov    0x14(%ebp),%eax
  801162:	8b 00                	mov    (%eax),%eax
  801164:	83 f8 0f             	cmp    $0xf,%eax
  801167:	75 07                	jne    801170 <strsplit+0x6c>
		{
			return 0;
  801169:	b8 00 00 00 00       	mov    $0x0,%eax
  80116e:	eb 66                	jmp    8011d6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801170:	8b 45 14             	mov    0x14(%ebp),%eax
  801173:	8b 00                	mov    (%eax),%eax
  801175:	8d 48 01             	lea    0x1(%eax),%ecx
  801178:	8b 55 14             	mov    0x14(%ebp),%edx
  80117b:	89 0a                	mov    %ecx,(%edx)
  80117d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	01 c2                	add    %eax,%edx
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80118e:	eb 03                	jmp    801193 <strsplit+0x8f>
			string++;
  801190:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	84 c0                	test   %al,%al
  80119a:	74 8b                	je     801127 <strsplit+0x23>
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	0f be c0             	movsbl %al,%eax
  8011a4:	50                   	push   %eax
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	e8 25 fa ff ff       	call   800bd2 <strchr>
  8011ad:	83 c4 08             	add    $0x8,%esp
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	74 dc                	je     801190 <strsplit+0x8c>
			string++;
	}
  8011b4:	e9 6e ff ff ff       	jmp    801127 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011b9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bd:	8b 00                	mov    (%eax),%eax
  8011bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 d0                	add    %edx,%eax
  8011cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8011e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011eb:	eb 4a                	jmp    801237 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8011ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	01 c2                	add    %eax,%edx
  8011f5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fb:	01 c8                	add    %ecx,%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801201:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 40                	cmp    $0x40,%al
  80120d:	7e 25                	jle    801234 <str2lower+0x5c>
  80120f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801212:	8b 45 0c             	mov    0xc(%ebp),%eax
  801215:	01 d0                	add    %edx,%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	3c 5a                	cmp    $0x5a,%al
  80121b:	7f 17                	jg     801234 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80121d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	01 d0                	add    %edx,%eax
  801225:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801228:	8b 55 08             	mov    0x8(%ebp),%edx
  80122b:	01 ca                	add    %ecx,%edx
  80122d:	8a 12                	mov    (%edx),%dl
  80122f:	83 c2 20             	add    $0x20,%edx
  801232:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801234:	ff 45 fc             	incl   -0x4(%ebp)
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	e8 01 f8 ff ff       	call   800a40 <strlen>
  80123f:	83 c4 04             	add    $0x4,%esp
  801242:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801245:	7f a6                	jg     8011ed <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801247:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	57                   	push   %edi
  801250:	56                   	push   %esi
  801251:	53                   	push   %ebx
  801252:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80125e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801261:	8b 7d 18             	mov    0x18(%ebp),%edi
  801264:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801267:	cd 30                	int    $0x30
  801269:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80126c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	5b                   	pop    %ebx
  801273:	5e                   	pop    %esi
  801274:	5f                   	pop    %edi
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    

00801277 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 04             	sub    $0x4,%esp
  80127d:	8b 45 10             	mov    0x10(%ebp),%eax
  801280:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801283:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801286:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	6a 00                	push   $0x0
  80128f:	51                   	push   %ecx
  801290:	52                   	push   %edx
  801291:	ff 75 0c             	pushl  0xc(%ebp)
  801294:	50                   	push   %eax
  801295:	6a 00                	push   $0x0
  801297:	e8 b0 ff ff ff       	call   80124c <syscall>
  80129c:	83 c4 18             	add    $0x18,%esp
}
  80129f:	90                   	nop
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 02                	push   $0x2
  8012b1:	e8 96 ff ff ff       	call   80124c <syscall>
  8012b6:	83 c4 18             	add    $0x18,%esp
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012be:	6a 00                	push   $0x0
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 03                	push   $0x3
  8012ca:	e8 7d ff ff ff       	call   80124c <syscall>
  8012cf:	83 c4 18             	add    $0x18,%esp
}
  8012d2:	90                   	nop
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 04                	push   $0x4
  8012e4:	e8 63 ff ff ff       	call   80124c <syscall>
  8012e9:	83 c4 18             	add    $0x18,%esp
}
  8012ec:	90                   	nop
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	52                   	push   %edx
  8012ff:	50                   	push   %eax
  801300:	6a 08                	push   $0x8
  801302:	e8 45 ff ff ff       	call   80124c <syscall>
  801307:	83 c4 18             	add    $0x18,%esp
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	56                   	push   %esi
  801310:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801311:	8b 75 18             	mov    0x18(%ebp),%esi
  801314:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801317:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80131a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	56                   	push   %esi
  801321:	53                   	push   %ebx
  801322:	51                   	push   %ecx
  801323:	52                   	push   %edx
  801324:	50                   	push   %eax
  801325:	6a 09                	push   $0x9
  801327:	e8 20 ff ff ff       	call   80124c <syscall>
  80132c:	83 c4 18             	add    $0x18,%esp
}
  80132f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801332:	5b                   	pop    %ebx
  801333:	5e                   	pop    %esi
  801334:	5d                   	pop    %ebp
  801335:	c3                   	ret    

00801336 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	ff 75 08             	pushl  0x8(%ebp)
  801344:	6a 0a                	push   $0xa
  801346:	e8 01 ff ff ff       	call   80124c <syscall>
  80134b:	83 c4 18             	add    $0x18,%esp
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	ff 75 0c             	pushl  0xc(%ebp)
  80135c:	ff 75 08             	pushl  0x8(%ebp)
  80135f:	6a 0b                	push   $0xb
  801361:	e8 e6 fe ff ff       	call   80124c <syscall>
  801366:	83 c4 18             	add    $0x18,%esp
}
  801369:	c9                   	leave  
  80136a:	c3                   	ret    

0080136b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 0c                	push   $0xc
  80137a:	e8 cd fe ff ff       	call   80124c <syscall>
  80137f:	83 c4 18             	add    $0x18,%esp
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 0d                	push   $0xd
  801393:	e8 b4 fe ff ff       	call   80124c <syscall>
  801398:	83 c4 18             	add    $0x18,%esp
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 0e                	push   $0xe
  8013ac:	e8 9b fe ff ff       	call   80124c <syscall>
  8013b1:	83 c4 18             	add    $0x18,%esp
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 0f                	push   $0xf
  8013c5:	e8 82 fe ff ff       	call   80124c <syscall>
  8013ca:	83 c4 18             	add    $0x18,%esp
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	6a 10                	push   $0x10
  8013df:	e8 68 fe ff ff       	call   80124c <syscall>
  8013e4:	83 c4 18             	add    $0x18,%esp
}
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 11                	push   $0x11
  8013f8:	e8 4f fe ff ff       	call   80124c <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
}
  801400:	90                   	nop
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <sys_cputc>:

void
sys_cputc(const char c)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 04             	sub    $0x4,%esp
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80140f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	50                   	push   %eax
  80141c:	6a 01                	push   $0x1
  80141e:	e8 29 fe ff ff       	call   80124c <syscall>
  801423:	83 c4 18             	add    $0x18,%esp
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 14                	push   $0x14
  801438:	e8 0f fe ff ff       	call   80124c <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
}
  801440:	90                   	nop
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	8b 45 10             	mov    0x10(%ebp),%eax
  80144c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80144f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801452:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	6a 00                	push   $0x0
  80145b:	51                   	push   %ecx
  80145c:	52                   	push   %edx
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	50                   	push   %eax
  801461:	6a 15                	push   $0x15
  801463:	e8 e4 fd ff ff       	call   80124c <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801470:	8b 55 0c             	mov    0xc(%ebp),%edx
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	52                   	push   %edx
  80147d:	50                   	push   %eax
  80147e:	6a 16                	push   $0x16
  801480:	e8 c7 fd ff ff       	call   80124c <syscall>
  801485:	83 c4 18             	add    $0x18,%esp
}
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80148d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801490:	8b 55 0c             	mov    0xc(%ebp),%edx
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	51                   	push   %ecx
  80149b:	52                   	push   %edx
  80149c:	50                   	push   %eax
  80149d:	6a 17                	push   $0x17
  80149f:	e8 a8 fd ff ff       	call   80124c <syscall>
  8014a4:	83 c4 18             	add    $0x18,%esp
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	52                   	push   %edx
  8014b9:	50                   	push   %eax
  8014ba:	6a 18                	push   $0x18
  8014bc:	e8 8b fd ff ff       	call   80124c <syscall>
  8014c1:	83 c4 18             	add    $0x18,%esp
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	6a 00                	push   $0x0
  8014ce:	ff 75 14             	pushl  0x14(%ebp)
  8014d1:	ff 75 10             	pushl  0x10(%ebp)
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	50                   	push   %eax
  8014d8:	6a 19                	push   $0x19
  8014da:	e8 6d fd ff ff       	call   80124c <syscall>
  8014df:	83 c4 18             	add    $0x18,%esp
}
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	50                   	push   %eax
  8014f3:	6a 1a                	push   $0x1a
  8014f5:	e8 52 fd ff ff       	call   80124c <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	90                   	nop
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	50                   	push   %eax
  80150f:	6a 1b                	push   $0x1b
  801511:	e8 36 fd ff ff       	call   80124c <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 05                	push   $0x5
  80152a:	e8 1d fd ff ff       	call   80124c <syscall>
  80152f:	83 c4 18             	add    $0x18,%esp
}
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 06                	push   $0x6
  801543:	e8 04 fd ff ff       	call   80124c <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 07                	push   $0x7
  80155c:	e8 eb fc ff ff       	call   80124c <syscall>
  801561:	83 c4 18             	add    $0x18,%esp
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <sys_exit_env>:


void sys_exit_env(void)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 1c                	push   $0x1c
  801575:	e8 d2 fc ff ff       	call   80124c <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
}
  80157d:	90                   	nop
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801586:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801589:	8d 50 04             	lea    0x4(%eax),%edx
  80158c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	52                   	push   %edx
  801596:	50                   	push   %eax
  801597:	6a 1d                	push   $0x1d
  801599:	e8 ae fc ff ff       	call   80124c <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
	return result;
  8015a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015aa:	89 01                	mov    %eax,(%ecx)
  8015ac:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	c9                   	leave  
  8015b3:	c2 04 00             	ret    $0x4

008015b6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	ff 75 10             	pushl  0x10(%ebp)
  8015c0:	ff 75 0c             	pushl  0xc(%ebp)
  8015c3:	ff 75 08             	pushl  0x8(%ebp)
  8015c6:	6a 13                	push   $0x13
  8015c8:	e8 7f fc ff ff       	call   80124c <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d0:	90                   	nop
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 1e                	push   $0x1e
  8015e2:	e8 65 fc ff ff       	call   80124c <syscall>
  8015e7:	83 c4 18             	add    $0x18,%esp
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015f8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	50                   	push   %eax
  801605:	6a 1f                	push   $0x1f
  801607:	e8 40 fc ff ff       	call   80124c <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
	return ;
  80160f:	90                   	nop
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <rsttst>:
void rsttst()
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 21                	push   $0x21
  801621:	e8 26 fc ff ff       	call   80124c <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
	return ;
  801629:	90                   	nop
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	8b 45 14             	mov    0x14(%ebp),%eax
  801635:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801638:	8b 55 18             	mov    0x18(%ebp),%edx
  80163b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80163f:	52                   	push   %edx
  801640:	50                   	push   %eax
  801641:	ff 75 10             	pushl  0x10(%ebp)
  801644:	ff 75 0c             	pushl  0xc(%ebp)
  801647:	ff 75 08             	pushl  0x8(%ebp)
  80164a:	6a 20                	push   $0x20
  80164c:	e8 fb fb ff ff       	call   80124c <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
	return ;
  801654:	90                   	nop
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <chktst>:
void chktst(uint32 n)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	ff 75 08             	pushl  0x8(%ebp)
  801665:	6a 22                	push   $0x22
  801667:	e8 e0 fb ff ff       	call   80124c <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
	return ;
  80166f:	90                   	nop
}
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <inctst>:

void inctst()
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 23                	push   $0x23
  801681:	e8 c6 fb ff ff       	call   80124c <syscall>
  801686:	83 c4 18             	add    $0x18,%esp
	return ;
  801689:	90                   	nop
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <gettst>:
uint32 gettst()
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 24                	push   $0x24
  80169b:	e8 ac fb ff ff       	call   80124c <syscall>
  8016a0:	83 c4 18             	add    $0x18,%esp
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 25                	push   $0x25
  8016b4:	e8 93 fb ff ff       	call   80124c <syscall>
  8016b9:	83 c4 18             	add    $0x18,%esp
  8016bc:	a3 60 a0 81 00       	mov    %eax,0x81a060
	return uheapPlaceStrategy ;
  8016c1:	a1 60 a0 81 00       	mov    0x81a060,%eax
}
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	a3 60 a0 81 00       	mov    %eax,0x81a060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	ff 75 08             	pushl  0x8(%ebp)
  8016de:	6a 26                	push   $0x26
  8016e0:	e8 67 fb ff ff       	call   80124c <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e8:	90                   	nop
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8016ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	6a 00                	push   $0x0
  8016fd:	53                   	push   %ebx
  8016fe:	51                   	push   %ecx
  8016ff:	52                   	push   %edx
  801700:	50                   	push   %eax
  801701:	6a 27                	push   $0x27
  801703:	e8 44 fb ff ff       	call   80124c <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801713:	8b 55 0c             	mov    0xc(%ebp),%edx
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	52                   	push   %edx
  801720:	50                   	push   %eax
  801721:	6a 28                	push   $0x28
  801723:	e8 24 fb ff ff       	call   80124c <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801730:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801733:	8b 55 0c             	mov    0xc(%ebp),%edx
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	6a 00                	push   $0x0
  80173b:	51                   	push   %ecx
  80173c:	ff 75 10             	pushl  0x10(%ebp)
  80173f:	52                   	push   %edx
  801740:	50                   	push   %eax
  801741:	6a 29                	push   $0x29
  801743:	e8 04 fb ff ff       	call   80124c <syscall>
  801748:	83 c4 18             	add    $0x18,%esp
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	ff 75 10             	pushl  0x10(%ebp)
  801757:	ff 75 0c             	pushl  0xc(%ebp)
  80175a:	ff 75 08             	pushl  0x8(%ebp)
  80175d:	6a 12                	push   $0x12
  80175f:	e8 e8 fa ff ff       	call   80124c <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
	return ;
  801767:	90                   	nop
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80176d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	52                   	push   %edx
  80177a:	50                   	push   %eax
  80177b:	6a 2a                	push   $0x2a
  80177d:	e8 ca fa ff ff       	call   80124c <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
	return;
  801785:	90                   	nop
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 2b                	push   $0x2b
  801797:	e8 b0 fa ff ff       	call   80124c <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	ff 75 0c             	pushl  0xc(%ebp)
  8017ad:	ff 75 08             	pushl  0x8(%ebp)
  8017b0:	6a 2d                	push   $0x2d
  8017b2:	e8 95 fa ff ff       	call   80124c <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
	return;
  8017ba:	90                   	nop
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	ff 75 0c             	pushl  0xc(%ebp)
  8017c9:	ff 75 08             	pushl  0x8(%ebp)
  8017cc:	6a 2c                	push   $0x2c
  8017ce:	e8 79 fa ff ff       	call   80124c <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d6:	90                   	nop
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8017dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	52                   	push   %edx
  8017e9:	50                   	push   %eax
  8017ea:	6a 2e                	push   $0x2e
  8017ec:	e8 5b fa ff ff       	call   80124c <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
	    return;
  8017f4:	90                   	nop
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    
  8017f7:	90                   	nop

008017f8 <__udivdi3>:
  8017f8:	55                   	push   %ebp
  8017f9:	57                   	push   %edi
  8017fa:	56                   	push   %esi
  8017fb:	53                   	push   %ebx
  8017fc:	83 ec 1c             	sub    $0x1c,%esp
  8017ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801803:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801807:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80180b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80180f:	89 ca                	mov    %ecx,%edx
  801811:	89 f8                	mov    %edi,%eax
  801813:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801817:	85 f6                	test   %esi,%esi
  801819:	75 2d                	jne    801848 <__udivdi3+0x50>
  80181b:	39 cf                	cmp    %ecx,%edi
  80181d:	77 65                	ja     801884 <__udivdi3+0x8c>
  80181f:	89 fd                	mov    %edi,%ebp
  801821:	85 ff                	test   %edi,%edi
  801823:	75 0b                	jne    801830 <__udivdi3+0x38>
  801825:	b8 01 00 00 00       	mov    $0x1,%eax
  80182a:	31 d2                	xor    %edx,%edx
  80182c:	f7 f7                	div    %edi
  80182e:	89 c5                	mov    %eax,%ebp
  801830:	31 d2                	xor    %edx,%edx
  801832:	89 c8                	mov    %ecx,%eax
  801834:	f7 f5                	div    %ebp
  801836:	89 c1                	mov    %eax,%ecx
  801838:	89 d8                	mov    %ebx,%eax
  80183a:	f7 f5                	div    %ebp
  80183c:	89 cf                	mov    %ecx,%edi
  80183e:	89 fa                	mov    %edi,%edx
  801840:	83 c4 1c             	add    $0x1c,%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	5f                   	pop    %edi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    
  801848:	39 ce                	cmp    %ecx,%esi
  80184a:	77 28                	ja     801874 <__udivdi3+0x7c>
  80184c:	0f bd fe             	bsr    %esi,%edi
  80184f:	83 f7 1f             	xor    $0x1f,%edi
  801852:	75 40                	jne    801894 <__udivdi3+0x9c>
  801854:	39 ce                	cmp    %ecx,%esi
  801856:	72 0a                	jb     801862 <__udivdi3+0x6a>
  801858:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80185c:	0f 87 9e 00 00 00    	ja     801900 <__udivdi3+0x108>
  801862:	b8 01 00 00 00       	mov    $0x1,%eax
  801867:	89 fa                	mov    %edi,%edx
  801869:	83 c4 1c             	add    $0x1c,%esp
  80186c:	5b                   	pop    %ebx
  80186d:	5e                   	pop    %esi
  80186e:	5f                   	pop    %edi
  80186f:	5d                   	pop    %ebp
  801870:	c3                   	ret    
  801871:	8d 76 00             	lea    0x0(%esi),%esi
  801874:	31 ff                	xor    %edi,%edi
  801876:	31 c0                	xor    %eax,%eax
  801878:	89 fa                	mov    %edi,%edx
  80187a:	83 c4 1c             	add    $0x1c,%esp
  80187d:	5b                   	pop    %ebx
  80187e:	5e                   	pop    %esi
  80187f:	5f                   	pop    %edi
  801880:	5d                   	pop    %ebp
  801881:	c3                   	ret    
  801882:	66 90                	xchg   %ax,%ax
  801884:	89 d8                	mov    %ebx,%eax
  801886:	f7 f7                	div    %edi
  801888:	31 ff                	xor    %edi,%edi
  80188a:	89 fa                	mov    %edi,%edx
  80188c:	83 c4 1c             	add    $0x1c,%esp
  80188f:	5b                   	pop    %ebx
  801890:	5e                   	pop    %esi
  801891:	5f                   	pop    %edi
  801892:	5d                   	pop    %ebp
  801893:	c3                   	ret    
  801894:	bd 20 00 00 00       	mov    $0x20,%ebp
  801899:	89 eb                	mov    %ebp,%ebx
  80189b:	29 fb                	sub    %edi,%ebx
  80189d:	89 f9                	mov    %edi,%ecx
  80189f:	d3 e6                	shl    %cl,%esi
  8018a1:	89 c5                	mov    %eax,%ebp
  8018a3:	88 d9                	mov    %bl,%cl
  8018a5:	d3 ed                	shr    %cl,%ebp
  8018a7:	89 e9                	mov    %ebp,%ecx
  8018a9:	09 f1                	or     %esi,%ecx
  8018ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018af:	89 f9                	mov    %edi,%ecx
  8018b1:	d3 e0                	shl    %cl,%eax
  8018b3:	89 c5                	mov    %eax,%ebp
  8018b5:	89 d6                	mov    %edx,%esi
  8018b7:	88 d9                	mov    %bl,%cl
  8018b9:	d3 ee                	shr    %cl,%esi
  8018bb:	89 f9                	mov    %edi,%ecx
  8018bd:	d3 e2                	shl    %cl,%edx
  8018bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018c3:	88 d9                	mov    %bl,%cl
  8018c5:	d3 e8                	shr    %cl,%eax
  8018c7:	09 c2                	or     %eax,%edx
  8018c9:	89 d0                	mov    %edx,%eax
  8018cb:	89 f2                	mov    %esi,%edx
  8018cd:	f7 74 24 0c          	divl   0xc(%esp)
  8018d1:	89 d6                	mov    %edx,%esi
  8018d3:	89 c3                	mov    %eax,%ebx
  8018d5:	f7 e5                	mul    %ebp
  8018d7:	39 d6                	cmp    %edx,%esi
  8018d9:	72 19                	jb     8018f4 <__udivdi3+0xfc>
  8018db:	74 0b                	je     8018e8 <__udivdi3+0xf0>
  8018dd:	89 d8                	mov    %ebx,%eax
  8018df:	31 ff                	xor    %edi,%edi
  8018e1:	e9 58 ff ff ff       	jmp    80183e <__udivdi3+0x46>
  8018e6:	66 90                	xchg   %ax,%ax
  8018e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8018ec:	89 f9                	mov    %edi,%ecx
  8018ee:	d3 e2                	shl    %cl,%edx
  8018f0:	39 c2                	cmp    %eax,%edx
  8018f2:	73 e9                	jae    8018dd <__udivdi3+0xe5>
  8018f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8018f7:	31 ff                	xor    %edi,%edi
  8018f9:	e9 40 ff ff ff       	jmp    80183e <__udivdi3+0x46>
  8018fe:	66 90                	xchg   %ax,%ax
  801900:	31 c0                	xor    %eax,%eax
  801902:	e9 37 ff ff ff       	jmp    80183e <__udivdi3+0x46>
  801907:	90                   	nop

00801908 <__umoddi3>:
  801908:	55                   	push   %ebp
  801909:	57                   	push   %edi
  80190a:	56                   	push   %esi
  80190b:	53                   	push   %ebx
  80190c:	83 ec 1c             	sub    $0x1c,%esp
  80190f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801913:	8b 74 24 34          	mov    0x34(%esp),%esi
  801917:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80191b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80191f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801923:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801927:	89 f3                	mov    %esi,%ebx
  801929:	89 fa                	mov    %edi,%edx
  80192b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80192f:	89 34 24             	mov    %esi,(%esp)
  801932:	85 c0                	test   %eax,%eax
  801934:	75 1a                	jne    801950 <__umoddi3+0x48>
  801936:	39 f7                	cmp    %esi,%edi
  801938:	0f 86 a2 00 00 00    	jbe    8019e0 <__umoddi3+0xd8>
  80193e:	89 c8                	mov    %ecx,%eax
  801940:	89 f2                	mov    %esi,%edx
  801942:	f7 f7                	div    %edi
  801944:	89 d0                	mov    %edx,%eax
  801946:	31 d2                	xor    %edx,%edx
  801948:	83 c4 1c             	add    $0x1c,%esp
  80194b:	5b                   	pop    %ebx
  80194c:	5e                   	pop    %esi
  80194d:	5f                   	pop    %edi
  80194e:	5d                   	pop    %ebp
  80194f:	c3                   	ret    
  801950:	39 f0                	cmp    %esi,%eax
  801952:	0f 87 ac 00 00 00    	ja     801a04 <__umoddi3+0xfc>
  801958:	0f bd e8             	bsr    %eax,%ebp
  80195b:	83 f5 1f             	xor    $0x1f,%ebp
  80195e:	0f 84 ac 00 00 00    	je     801a10 <__umoddi3+0x108>
  801964:	bf 20 00 00 00       	mov    $0x20,%edi
  801969:	29 ef                	sub    %ebp,%edi
  80196b:	89 fe                	mov    %edi,%esi
  80196d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801971:	89 e9                	mov    %ebp,%ecx
  801973:	d3 e0                	shl    %cl,%eax
  801975:	89 d7                	mov    %edx,%edi
  801977:	89 f1                	mov    %esi,%ecx
  801979:	d3 ef                	shr    %cl,%edi
  80197b:	09 c7                	or     %eax,%edi
  80197d:	89 e9                	mov    %ebp,%ecx
  80197f:	d3 e2                	shl    %cl,%edx
  801981:	89 14 24             	mov    %edx,(%esp)
  801984:	89 d8                	mov    %ebx,%eax
  801986:	d3 e0                	shl    %cl,%eax
  801988:	89 c2                	mov    %eax,%edx
  80198a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80198e:	d3 e0                	shl    %cl,%eax
  801990:	89 44 24 04          	mov    %eax,0x4(%esp)
  801994:	8b 44 24 08          	mov    0x8(%esp),%eax
  801998:	89 f1                	mov    %esi,%ecx
  80199a:	d3 e8                	shr    %cl,%eax
  80199c:	09 d0                	or     %edx,%eax
  80199e:	d3 eb                	shr    %cl,%ebx
  8019a0:	89 da                	mov    %ebx,%edx
  8019a2:	f7 f7                	div    %edi
  8019a4:	89 d3                	mov    %edx,%ebx
  8019a6:	f7 24 24             	mull   (%esp)
  8019a9:	89 c6                	mov    %eax,%esi
  8019ab:	89 d1                	mov    %edx,%ecx
  8019ad:	39 d3                	cmp    %edx,%ebx
  8019af:	0f 82 87 00 00 00    	jb     801a3c <__umoddi3+0x134>
  8019b5:	0f 84 91 00 00 00    	je     801a4c <__umoddi3+0x144>
  8019bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019bf:	29 f2                	sub    %esi,%edx
  8019c1:	19 cb                	sbb    %ecx,%ebx
  8019c3:	89 d8                	mov    %ebx,%eax
  8019c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019c9:	d3 e0                	shl    %cl,%eax
  8019cb:	89 e9                	mov    %ebp,%ecx
  8019cd:	d3 ea                	shr    %cl,%edx
  8019cf:	09 d0                	or     %edx,%eax
  8019d1:	89 e9                	mov    %ebp,%ecx
  8019d3:	d3 eb                	shr    %cl,%ebx
  8019d5:	89 da                	mov    %ebx,%edx
  8019d7:	83 c4 1c             	add    $0x1c,%esp
  8019da:	5b                   	pop    %ebx
  8019db:	5e                   	pop    %esi
  8019dc:	5f                   	pop    %edi
  8019dd:	5d                   	pop    %ebp
  8019de:	c3                   	ret    
  8019df:	90                   	nop
  8019e0:	89 fd                	mov    %edi,%ebp
  8019e2:	85 ff                	test   %edi,%edi
  8019e4:	75 0b                	jne    8019f1 <__umoddi3+0xe9>
  8019e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019eb:	31 d2                	xor    %edx,%edx
  8019ed:	f7 f7                	div    %edi
  8019ef:	89 c5                	mov    %eax,%ebp
  8019f1:	89 f0                	mov    %esi,%eax
  8019f3:	31 d2                	xor    %edx,%edx
  8019f5:	f7 f5                	div    %ebp
  8019f7:	89 c8                	mov    %ecx,%eax
  8019f9:	f7 f5                	div    %ebp
  8019fb:	89 d0                	mov    %edx,%eax
  8019fd:	e9 44 ff ff ff       	jmp    801946 <__umoddi3+0x3e>
  801a02:	66 90                	xchg   %ax,%ax
  801a04:	89 c8                	mov    %ecx,%eax
  801a06:	89 f2                	mov    %esi,%edx
  801a08:	83 c4 1c             	add    $0x1c,%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5f                   	pop    %edi
  801a0e:	5d                   	pop    %ebp
  801a0f:	c3                   	ret    
  801a10:	3b 04 24             	cmp    (%esp),%eax
  801a13:	72 06                	jb     801a1b <__umoddi3+0x113>
  801a15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a19:	77 0f                	ja     801a2a <__umoddi3+0x122>
  801a1b:	89 f2                	mov    %esi,%edx
  801a1d:	29 f9                	sub    %edi,%ecx
  801a1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a23:	89 14 24             	mov    %edx,(%esp)
  801a26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a2e:	8b 14 24             	mov    (%esp),%edx
  801a31:	83 c4 1c             	add    $0x1c,%esp
  801a34:	5b                   	pop    %ebx
  801a35:	5e                   	pop    %esi
  801a36:	5f                   	pop    %edi
  801a37:	5d                   	pop    %ebp
  801a38:	c3                   	ret    
  801a39:	8d 76 00             	lea    0x0(%esi),%esi
  801a3c:	2b 04 24             	sub    (%esp),%eax
  801a3f:	19 fa                	sbb    %edi,%edx
  801a41:	89 d1                	mov    %edx,%ecx
  801a43:	89 c6                	mov    %eax,%esi
  801a45:	e9 71 ff ff ff       	jmp    8019bb <__umoddi3+0xb3>
  801a4a:	66 90                	xchg   %ax,%ax
  801a4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a50:	72 ea                	jb     801a3c <__umoddi3+0x134>
  801a52:	89 d9                	mov    %ebx,%ecx
  801a54:	e9 62 ff ff ff       	jmp    8019bb <__umoddi3+0xb3>
