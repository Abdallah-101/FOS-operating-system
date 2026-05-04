
obj/user/fos_helloWorld:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	extern unsigned char * etext;
	//cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D %d\n",4);
	atomic_cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D \n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 00 1a 80 00       	push   $0x801a00
  800046:	e8 27 03 00 00       	call   800372 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("end of code = %x\n",etext);
  80004e:	a1 f1 19 80 00       	mov    0x8019f1,%eax
  800053:	83 ec 08             	sub    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 28 1a 80 00       	push   $0x801a28
  80005c:	e8 11 03 00 00       	call   800372 <atomic_cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
}
  800064:	90                   	nop
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	57                   	push   %edi
  80006b:	56                   	push   %esi
  80006c:	53                   	push   %ebx
  80006d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800070:	e8 58 14 00 00       	call   8014cd <sys_getenvindex>
  800075:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800078:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80007b:	89 d0                	mov    %edx,%eax
  80007d:	c1 e0 02             	shl    $0x2,%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800089:	01 d0                	add    %edx,%eax
  80008b:	89 c2                	mov    %eax,%edx
  80008d:	c1 e2 04             	shl    $0x4,%edx
  800090:	29 c2                	sub    %eax,%edx
  800092:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800099:	89 c2                	mov    %eax,%edx
  80009b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000a1:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000a6:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ab:	8a 40 20             	mov    0x20(%eax),%al
  8000ae:	84 c0                	test   %al,%al
  8000b0:	74 0d                	je     8000bf <libmain+0x58>
		binaryname = myEnv->prog_name;
  8000b2:	a1 20 20 80 00       	mov    0x802020,%eax
  8000b7:	83 c0 20             	add    $0x20,%eax
  8000ba:	a3 04 20 80 00       	mov    %eax,0x802004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c3:	7e 0a                	jle    8000cf <libmain+0x68>
		binaryname = argv[0];
  8000c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c8:	8b 00                	mov    (%eax),%eax
  8000ca:	a3 04 20 80 00       	mov    %eax,0x802004

	// call user main routine
	_main(argc, argv);
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	ff 75 0c             	pushl  0xc(%ebp)
  8000d5:	ff 75 08             	pushl  0x8(%ebp)
  8000d8:	e8 5b ff ff ff       	call   800038 <_main>
  8000dd:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000e0:	a1 00 20 80 00       	mov    0x802000,%eax
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 84 01 01 00 00    	je     8001ee <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000ed:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000f3:	bb 34 1b 80 00       	mov    $0x801b34,%ebx
  8000f8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000fd:	89 c7                	mov    %eax,%edi
  8000ff:	89 de                	mov    %ebx,%esi
  800101:	89 d1                	mov    %edx,%ecx
  800103:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800105:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800108:	b9 56 00 00 00       	mov    $0x56,%ecx
  80010d:	b0 00                	mov    $0x0,%al
  80010f:	89 d7                	mov    %edx,%edi
  800111:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800113:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80011a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	50                   	push   %eax
  800121:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800127:	50                   	push   %eax
  800128:	e8 d6 15 00 00       	call   801703 <sys_utilities>
  80012d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800130:	e8 1f 11 00 00       	call   801254 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	68 54 1a 80 00       	push   $0x801a54
  80013d:	e8 be 01 00 00       	call   800300 <cprintf>
  800142:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800145:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800148:	85 c0                	test   %eax,%eax
  80014a:	74 18                	je     800164 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80014c:	e8 d0 15 00 00       	call   801721 <sys_get_optimal_num_faults>
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	50                   	push   %eax
  800155:	68 7c 1a 80 00       	push   $0x801a7c
  80015a:	e8 a1 01 00 00       	call   800300 <cprintf>
  80015f:	83 c4 10             	add    $0x10,%esp
  800162:	eb 59                	jmp    8001bd <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800164:	a1 20 20 80 00       	mov    0x802020,%eax
  800169:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80016f:	a1 20 20 80 00       	mov    0x802020,%eax
  800174:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80017a:	83 ec 04             	sub    $0x4,%esp
  80017d:	52                   	push   %edx
  80017e:	50                   	push   %eax
  80017f:	68 a0 1a 80 00       	push   $0x801aa0
  800184:	e8 77 01 00 00       	call   800300 <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80018c:	a1 20 20 80 00       	mov    0x802020,%eax
  800191:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800197:	a1 20 20 80 00       	mov    0x802020,%eax
  80019c:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8001a2:	a1 20 20 80 00       	mov    0x802020,%eax
  8001a7:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8001ad:	51                   	push   %ecx
  8001ae:	52                   	push   %edx
  8001af:	50                   	push   %eax
  8001b0:	68 c8 1a 80 00       	push   $0x801ac8
  8001b5:	e8 46 01 00 00       	call   800300 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001bd:	a1 20 20 80 00       	mov    0x802020,%eax
  8001c2:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	50                   	push   %eax
  8001cc:	68 20 1b 80 00       	push   $0x801b20
  8001d1:	e8 2a 01 00 00       	call   800300 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	68 54 1a 80 00       	push   $0x801a54
  8001e1:	e8 1a 01 00 00       	call   800300 <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001e9:	e8 80 10 00 00       	call   80126e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001ee:	e8 1f 00 00 00       	call   800212 <exit>
}
  8001f3:	90                   	nop
  8001f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f7:	5b                   	pop    %ebx
  8001f8:	5e                   	pop    %esi
  8001f9:	5f                   	pop    %edi
  8001fa:	5d                   	pop    %ebp
  8001fb:	c3                   	ret    

008001fc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	6a 00                	push   $0x0
  800207:	e8 8d 12 00 00       	call   801499 <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
}
  80020f:	90                   	nop
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <exit>:

void
exit(void)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800218:	e8 e2 12 00 00       	call   8014ff <sys_exit_env>
}
  80021d:	90                   	nop
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	53                   	push   %ebx
  800224:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022a:	8b 00                	mov    (%eax),%eax
  80022c:	8d 48 01             	lea    0x1(%eax),%ecx
  80022f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800232:	89 0a                	mov    %ecx,(%edx)
  800234:	8b 55 08             	mov    0x8(%ebp),%edx
  800237:	88 d1                	mov    %dl,%cl
  800239:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
  800243:	8b 00                	mov    (%eax),%eax
  800245:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024a:	75 30                	jne    80027c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80024c:	8b 15 18 a1 81 00    	mov    0x81a118,%edx
  800252:	a0 44 20 80 00       	mov    0x802044,%al
  800257:	0f b6 c0             	movzbl %al,%eax
  80025a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025d:	8b 09                	mov    (%ecx),%ecx
  80025f:	89 cb                	mov    %ecx,%ebx
  800261:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800264:	83 c1 08             	add    $0x8,%ecx
  800267:	52                   	push   %edx
  800268:	50                   	push   %eax
  800269:	53                   	push   %ebx
  80026a:	51                   	push   %ecx
  80026b:	e8 a0 0f 00 00       	call   801210 <sys_cputs>
  800270:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800273:	8b 45 0c             	mov    0xc(%ebp),%eax
  800276:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80027c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027f:	8b 40 04             	mov    0x4(%eax),%eax
  800282:	8d 50 01             	lea    0x1(%eax),%edx
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	89 50 04             	mov    %edx,0x4(%eax)
}
  80028b:	90                   	nop
  80028c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80028f:	c9                   	leave  
  800290:	c3                   	ret    

00800291 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80029a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a1:	00 00 00 
	b.cnt = 0;
  8002a4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ab:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002ae:	ff 75 0c             	pushl  0xc(%ebp)
  8002b1:	ff 75 08             	pushl  0x8(%ebp)
  8002b4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	68 20 02 80 00       	push   $0x800220
  8002c0:	e8 5a 02 00 00       	call   80051f <vprintfmt>
  8002c5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002c8:	8b 15 18 a1 81 00    	mov    0x81a118,%edx
  8002ce:	a0 44 20 80 00       	mov    0x802044,%al
  8002d3:	0f b6 c0             	movzbl %al,%eax
  8002d6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8002dc:	52                   	push   %edx
  8002dd:	50                   	push   %eax
  8002de:	51                   	push   %ecx
  8002df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e5:	83 c0 08             	add    $0x8,%eax
  8002e8:	50                   	push   %eax
  8002e9:	e8 22 0f 00 00       	call   801210 <sys_cputs>
  8002ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002f1:	c6 05 44 20 80 00 00 	movb   $0x0,0x802044
	return b.cnt;
  8002f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800306:	c6 05 44 20 80 00 01 	movb   $0x1,0x802044
	va_start(ap, fmt);
  80030d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800310:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	ff 75 f4             	pushl  -0xc(%ebp)
  80031c:	50                   	push   %eax
  80031d:	e8 6f ff ff ff       	call   800291 <vcprintf>
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800328:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800333:	c6 05 44 20 80 00 01 	movb   $0x1,0x802044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	c1 e0 08             	shl    $0x8,%eax
  800340:	a3 18 a1 81 00       	mov    %eax,0x81a118
	va_start(ap, fmt);
  800345:	8d 45 0c             	lea    0xc(%ebp),%eax
  800348:	83 c0 04             	add    $0x4,%eax
  80034b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80034e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	ff 75 f4             	pushl  -0xc(%ebp)
  800357:	50                   	push   %eax
  800358:	e8 34 ff ff ff       	call   800291 <vcprintf>
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800363:	c7 05 18 a1 81 00 00 	movl   $0x700,0x81a118
  80036a:	07 00 00 

	return cnt;
  80036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800378:	e8 d7 0e 00 00       	call   801254 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80037d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800380:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	ff 75 f4             	pushl  -0xc(%ebp)
  80038c:	50                   	push   %eax
  80038d:	e8 ff fe ff ff       	call   800291 <vcprintf>
  800392:	83 c4 10             	add    $0x10,%esp
  800395:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800398:	e8 d1 0e 00 00       	call   80126e <sys_unlock_cons>
	return cnt;
  80039d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a0:	c9                   	leave  
  8003a1:	c3                   	ret    

008003a2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a2:	55                   	push   %ebp
  8003a3:	89 e5                	mov    %esp,%ebp
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 14             	sub    $0x14,%esp
  8003a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003af:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c0:	77 55                	ja     800417 <printnum+0x75>
  8003c2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c5:	72 05                	jb     8003cc <printnum+0x2a>
  8003c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003ca:	77 4b                	ja     800417 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003cf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003da:	52                   	push   %edx
  8003db:	50                   	push   %eax
  8003dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8003df:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e2:	e8 a9 13 00 00       	call   801790 <__udivdi3>
  8003e7:	83 c4 10             	add    $0x10,%esp
  8003ea:	83 ec 04             	sub    $0x4,%esp
  8003ed:	ff 75 20             	pushl  0x20(%ebp)
  8003f0:	53                   	push   %ebx
  8003f1:	ff 75 18             	pushl  0x18(%ebp)
  8003f4:	52                   	push   %edx
  8003f5:	50                   	push   %eax
  8003f6:	ff 75 0c             	pushl  0xc(%ebp)
  8003f9:	ff 75 08             	pushl  0x8(%ebp)
  8003fc:	e8 a1 ff ff ff       	call   8003a2 <printnum>
  800401:	83 c4 20             	add    $0x20,%esp
  800404:	eb 1a                	jmp    800420 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	ff 75 20             	pushl  0x20(%ebp)
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	ff d0                	call   *%eax
  800414:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800417:	ff 4d 1c             	decl   0x1c(%ebp)
  80041a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80041e:	7f e6                	jg     800406 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800420:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800423:	bb 00 00 00 00       	mov    $0x0,%ebx
  800428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80042e:	53                   	push   %ebx
  80042f:	51                   	push   %ecx
  800430:	52                   	push   %edx
  800431:	50                   	push   %eax
  800432:	e8 69 14 00 00       	call   8018a0 <__umoddi3>
  800437:	83 c4 10             	add    $0x10,%esp
  80043a:	05 b4 1d 80 00       	add    $0x801db4,%eax
  80043f:	8a 00                	mov    (%eax),%al
  800441:	0f be c0             	movsbl %al,%eax
  800444:	83 ec 08             	sub    $0x8,%esp
  800447:	ff 75 0c             	pushl  0xc(%ebp)
  80044a:	50                   	push   %eax
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	ff d0                	call   *%eax
  800450:	83 c4 10             	add    $0x10,%esp
}
  800453:	90                   	nop
  800454:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800460:	7e 1c                	jle    80047e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	8b 00                	mov    (%eax),%eax
  800467:	8d 50 08             	lea    0x8(%eax),%edx
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	89 10                	mov    %edx,(%eax)
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	8b 00                	mov    (%eax),%eax
  800474:	83 e8 08             	sub    $0x8,%eax
  800477:	8b 50 04             	mov    0x4(%eax),%edx
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	eb 40                	jmp    8004be <getuint+0x65>
	else if (lflag)
  80047e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800482:	74 1e                	je     8004a2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	8b 00                	mov    (%eax),%eax
  800489:	8d 50 04             	lea    0x4(%eax),%edx
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	89 10                	mov    %edx,(%eax)
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	83 e8 04             	sub    $0x4,%eax
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a0:	eb 1c                	jmp    8004be <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	8d 50 04             	lea    0x4(%eax),%edx
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	89 10                	mov    %edx,(%eax)
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	83 e8 04             	sub    $0x4,%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004be:	5d                   	pop    %ebp
  8004bf:	c3                   	ret    

008004c0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004c7:	7e 1c                	jle    8004e5 <getint+0x25>
		return va_arg(*ap, long long);
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
  8004e3:	eb 38                	jmp    80051d <getint+0x5d>
	else if (lflag)
  8004e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004e9:	74 1a                	je     800505 <getint+0x45>
		return va_arg(*ap, long);
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	8d 50 04             	lea    0x4(%eax),%edx
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	89 10                	mov    %edx,(%eax)
  8004f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	83 e8 04             	sub    $0x4,%eax
  800500:	8b 00                	mov    (%eax),%eax
  800502:	99                   	cltd   
  800503:	eb 18                	jmp    80051d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800505:	8b 45 08             	mov    0x8(%ebp),%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	8d 50 04             	lea    0x4(%eax),%edx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	89 10                	mov    %edx,(%eax)
  800512:	8b 45 08             	mov    0x8(%ebp),%eax
  800515:	8b 00                	mov    (%eax),%eax
  800517:	83 e8 04             	sub    $0x4,%eax
  80051a:	8b 00                	mov    (%eax),%eax
  80051c:	99                   	cltd   
}
  80051d:	5d                   	pop    %ebp
  80051e:	c3                   	ret    

0080051f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	56                   	push   %esi
  800523:	53                   	push   %ebx
  800524:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800527:	eb 17                	jmp    800540 <vprintfmt+0x21>
			if (ch == '\0')
  800529:	85 db                	test   %ebx,%ebx
  80052b:	0f 84 c1 03 00 00    	je     8008f2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	53                   	push   %ebx
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	ff d0                	call   *%eax
  80053d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800540:	8b 45 10             	mov    0x10(%ebp),%eax
  800543:	8d 50 01             	lea    0x1(%eax),%edx
  800546:	89 55 10             	mov    %edx,0x10(%ebp)
  800549:	8a 00                	mov    (%eax),%al
  80054b:	0f b6 d8             	movzbl %al,%ebx
  80054e:	83 fb 25             	cmp    $0x25,%ebx
  800551:	75 d6                	jne    800529 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800553:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800557:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80055e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800565:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80056c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800573:	8b 45 10             	mov    0x10(%ebp),%eax
  800576:	8d 50 01             	lea    0x1(%eax),%edx
  800579:	89 55 10             	mov    %edx,0x10(%ebp)
  80057c:	8a 00                	mov    (%eax),%al
  80057e:	0f b6 d8             	movzbl %al,%ebx
  800581:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800584:	83 f8 5b             	cmp    $0x5b,%eax
  800587:	0f 87 3d 03 00 00    	ja     8008ca <vprintfmt+0x3ab>
  80058d:	8b 04 85 d8 1d 80 00 	mov    0x801dd8(,%eax,4),%eax
  800594:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800596:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80059a:	eb d7                	jmp    800573 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005a0:	eb d1                	jmp    800573 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ac:	89 d0                	mov    %edx,%eax
  8005ae:	c1 e0 02             	shl    $0x2,%eax
  8005b1:	01 d0                	add    %edx,%eax
  8005b3:	01 c0                	add    %eax,%eax
  8005b5:	01 d8                	add    %ebx,%eax
  8005b7:	83 e8 30             	sub    $0x30,%eax
  8005ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c0:	8a 00                	mov    (%eax),%al
  8005c2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c5:	83 fb 2f             	cmp    $0x2f,%ebx
  8005c8:	7e 3e                	jle    800608 <vprintfmt+0xe9>
  8005ca:	83 fb 39             	cmp    $0x39,%ebx
  8005cd:	7f 39                	jg     800608 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005cf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d2:	eb d5                	jmp    8005a9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	83 c0 04             	add    $0x4,%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	83 e8 04             	sub    $0x4,%eax
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005e8:	eb 1f                	jmp    800609 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ee:	79 83                	jns    800573 <vprintfmt+0x54>
				width = 0;
  8005f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005f7:	e9 77 ff ff ff       	jmp    800573 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005fc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800603:	e9 6b ff ff ff       	jmp    800573 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800608:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800609:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80060d:	0f 89 60 ff ff ff    	jns    800573 <vprintfmt+0x54>
				width = precision, precision = -1;
  800613:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800616:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800619:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800620:	e9 4e ff ff ff       	jmp    800573 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800625:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800628:	e9 46 ff ff ff       	jmp    800573 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	83 c0 04             	add    $0x4,%eax
  800633:	89 45 14             	mov    %eax,0x14(%ebp)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	83 e8 04             	sub    $0x4,%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	ff 75 0c             	pushl  0xc(%ebp)
  800644:	50                   	push   %eax
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	ff d0                	call   *%eax
  80064a:	83 c4 10             	add    $0x10,%esp
			break;
  80064d:	e9 9b 02 00 00       	jmp    8008ed <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	83 c0 04             	add    $0x4,%eax
  800658:	89 45 14             	mov    %eax,0x14(%ebp)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	83 e8 04             	sub    $0x4,%eax
  800661:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800663:	85 db                	test   %ebx,%ebx
  800665:	79 02                	jns    800669 <vprintfmt+0x14a>
				err = -err;
  800667:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800669:	83 fb 64             	cmp    $0x64,%ebx
  80066c:	7f 0b                	jg     800679 <vprintfmt+0x15a>
  80066e:	8b 34 9d 20 1c 80 00 	mov    0x801c20(,%ebx,4),%esi
  800675:	85 f6                	test   %esi,%esi
  800677:	75 19                	jne    800692 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800679:	53                   	push   %ebx
  80067a:	68 c5 1d 80 00       	push   $0x801dc5
  80067f:	ff 75 0c             	pushl  0xc(%ebp)
  800682:	ff 75 08             	pushl  0x8(%ebp)
  800685:	e8 70 02 00 00       	call   8008fa <printfmt>
  80068a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80068d:	e9 5b 02 00 00       	jmp    8008ed <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800692:	56                   	push   %esi
  800693:	68 ce 1d 80 00       	push   $0x801dce
  800698:	ff 75 0c             	pushl  0xc(%ebp)
  80069b:	ff 75 08             	pushl  0x8(%ebp)
  80069e:	e8 57 02 00 00       	call   8008fa <printfmt>
  8006a3:	83 c4 10             	add    $0x10,%esp
			break;
  8006a6:	e9 42 02 00 00       	jmp    8008ed <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	83 c0 04             	add    $0x4,%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	83 e8 04             	sub    $0x4,%eax
  8006ba:	8b 30                	mov    (%eax),%esi
  8006bc:	85 f6                	test   %esi,%esi
  8006be:	75 05                	jne    8006c5 <vprintfmt+0x1a6>
				p = "(null)";
  8006c0:	be d1 1d 80 00       	mov    $0x801dd1,%esi
			if (width > 0 && padc != '-')
  8006c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c9:	7e 6d                	jle    800738 <vprintfmt+0x219>
  8006cb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006cf:	74 67                	je     800738 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	56                   	push   %esi
  8006d9:	e8 1e 03 00 00       	call   8009fc <strnlen>
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e4:	eb 16                	jmp    8006fc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006e6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	ff 75 0c             	pushl  0xc(%ebp)
  8006f0:	50                   	push   %eax
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	ff d0                	call   *%eax
  8006f6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f9:	ff 4d e4             	decl   -0x1c(%ebp)
  8006fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800700:	7f e4                	jg     8006e6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800702:	eb 34                	jmp    800738 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800704:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800708:	74 1c                	je     800726 <vprintfmt+0x207>
  80070a:	83 fb 1f             	cmp    $0x1f,%ebx
  80070d:	7e 05                	jle    800714 <vprintfmt+0x1f5>
  80070f:	83 fb 7e             	cmp    $0x7e,%ebx
  800712:	7e 12                	jle    800726 <vprintfmt+0x207>
					putch('?', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	ff 75 0c             	pushl  0xc(%ebp)
  80071a:	6a 3f                	push   $0x3f
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	ff d0                	call   *%eax
  800721:	83 c4 10             	add    $0x10,%esp
  800724:	eb 0f                	jmp    800735 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	ff 75 0c             	pushl  0xc(%ebp)
  80072c:	53                   	push   %ebx
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	ff d0                	call   *%eax
  800732:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800735:	ff 4d e4             	decl   -0x1c(%ebp)
  800738:	89 f0                	mov    %esi,%eax
  80073a:	8d 70 01             	lea    0x1(%eax),%esi
  80073d:	8a 00                	mov    (%eax),%al
  80073f:	0f be d8             	movsbl %al,%ebx
  800742:	85 db                	test   %ebx,%ebx
  800744:	74 24                	je     80076a <vprintfmt+0x24b>
  800746:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074a:	78 b8                	js     800704 <vprintfmt+0x1e5>
  80074c:	ff 4d e0             	decl   -0x20(%ebp)
  80074f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800753:	79 af                	jns    800704 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800755:	eb 13                	jmp    80076a <vprintfmt+0x24b>
				putch(' ', putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	6a 20                	push   $0x20
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	ff d0                	call   *%eax
  800764:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800767:	ff 4d e4             	decl   -0x1c(%ebp)
  80076a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80076e:	7f e7                	jg     800757 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800770:	e9 78 01 00 00       	jmp    8008ed <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 e8             	pushl  -0x18(%ebp)
  80077b:	8d 45 14             	lea    0x14(%ebp),%eax
  80077e:	50                   	push   %eax
  80077f:	e8 3c fd ff ff       	call   8004c0 <getint>
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80078d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800790:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800793:	85 d2                	test   %edx,%edx
  800795:	79 23                	jns    8007ba <vprintfmt+0x29b>
				putch('-', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	ff 75 0c             	pushl  0xc(%ebp)
  80079d:	6a 2d                	push   $0x2d
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	ff d0                	call   *%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ad:	f7 d8                	neg    %eax
  8007af:	83 d2 00             	adc    $0x0,%edx
  8007b2:	f7 da                	neg    %edx
  8007b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007ba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c1:	e9 bc 00 00 00       	jmp    800882 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 e8             	pushl  -0x18(%ebp)
  8007cc:	8d 45 14             	lea    0x14(%ebp),%eax
  8007cf:	50                   	push   %eax
  8007d0:	e8 84 fc ff ff       	call   800459 <getuint>
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e5:	e9 98 00 00 00       	jmp    800882 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	6a 58                	push   $0x58
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 0c             	pushl  0xc(%ebp)
  800800:	6a 58                	push   $0x58
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	ff d0                	call   *%eax
  800807:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	6a 58                	push   $0x58
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	ff d0                	call   *%eax
  800817:	83 c4 10             	add    $0x10,%esp
			break;
  80081a:	e9 ce 00 00 00       	jmp    8008ed <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	6a 30                	push   $0x30
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	ff d0                	call   *%eax
  80082c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	6a 78                	push   $0x78
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	83 c0 04             	add    $0x4,%eax
  800845:	89 45 14             	mov    %eax,0x14(%ebp)
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	83 e8 04             	sub    $0x4,%eax
  80084e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800850:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800853:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80085a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800861:	eb 1f                	jmp    800882 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 e8             	pushl  -0x18(%ebp)
  800869:	8d 45 14             	lea    0x14(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	e8 e7 fb ff ff       	call   800459 <getuint>
  800872:	83 c4 10             	add    $0x10,%esp
  800875:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800878:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80087b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800882:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800886:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800889:	83 ec 04             	sub    $0x4,%esp
  80088c:	52                   	push   %edx
  80088d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800890:	50                   	push   %eax
  800891:	ff 75 f4             	pushl  -0xc(%ebp)
  800894:	ff 75 f0             	pushl  -0x10(%ebp)
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	ff 75 08             	pushl  0x8(%ebp)
  80089d:	e8 00 fb ff ff       	call   8003a2 <printnum>
  8008a2:	83 c4 20             	add    $0x20,%esp
			break;
  8008a5:	eb 46                	jmp    8008ed <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	ff 75 0c             	pushl  0xc(%ebp)
  8008ad:	53                   	push   %ebx
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	ff d0                	call   *%eax
  8008b3:	83 c4 10             	add    $0x10,%esp
			break;
  8008b6:	eb 35                	jmp    8008ed <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008b8:	c6 05 44 20 80 00 00 	movb   $0x0,0x802044
			break;
  8008bf:	eb 2c                	jmp    8008ed <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008c1:	c6 05 44 20 80 00 01 	movb   $0x1,0x802044
			break;
  8008c8:	eb 23                	jmp    8008ed <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	6a 25                	push   $0x25
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	ff d0                	call   *%eax
  8008d7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008da:	ff 4d 10             	decl   0x10(%ebp)
  8008dd:	eb 03                	jmp    8008e2 <vprintfmt+0x3c3>
  8008df:	ff 4d 10             	decl   0x10(%ebp)
  8008e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e5:	48                   	dec    %eax
  8008e6:	8a 00                	mov    (%eax),%al
  8008e8:	3c 25                	cmp    $0x25,%al
  8008ea:	75 f3                	jne    8008df <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008ec:	90                   	nop
		}
	}
  8008ed:	e9 35 fc ff ff       	jmp    800527 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008f2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f6:	5b                   	pop    %ebx
  8008f7:	5e                   	pop    %esi
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800900:	8d 45 10             	lea    0x10(%ebp),%eax
  800903:	83 c0 04             	add    $0x4,%eax
  800906:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800909:	8b 45 10             	mov    0x10(%ebp),%eax
  80090c:	ff 75 f4             	pushl  -0xc(%ebp)
  80090f:	50                   	push   %eax
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	ff 75 08             	pushl  0x8(%ebp)
  800916:	e8 04 fc ff ff       	call   80051f <vprintfmt>
  80091b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80091e:	90                   	nop
  80091f:	c9                   	leave  
  800920:	c3                   	ret    

00800921 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8b 40 08             	mov    0x8(%eax),%eax
  80092a:	8d 50 01             	lea    0x1(%eax),%edx
  80092d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800930:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8b 10                	mov    (%eax),%edx
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	8b 40 04             	mov    0x4(%eax),%eax
  80093e:	39 c2                	cmp    %eax,%edx
  800940:	73 12                	jae    800954 <sprintputch+0x33>
		*b->buf++ = ch;
  800942:	8b 45 0c             	mov    0xc(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	8d 48 01             	lea    0x1(%eax),%ecx
  80094a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094d:	89 0a                	mov    %ecx,(%edx)
  80094f:	8b 55 08             	mov    0x8(%ebp),%edx
  800952:	88 10                	mov    %dl,(%eax)
}
  800954:	90                   	nop
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800963:	8b 45 0c             	mov    0xc(%ebp),%eax
  800966:	8d 50 ff             	lea    -0x1(%eax),%edx
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	01 d0                	add    %edx,%eax
  80096e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800971:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800978:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80097c:	74 06                	je     800984 <vsnprintf+0x2d>
  80097e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800982:	7f 07                	jg     80098b <vsnprintf+0x34>
		return -E_INVAL;
  800984:	b8 03 00 00 00       	mov    $0x3,%eax
  800989:	eb 20                	jmp    8009ab <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80098b:	ff 75 14             	pushl  0x14(%ebp)
  80098e:	ff 75 10             	pushl  0x10(%ebp)
  800991:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800994:	50                   	push   %eax
  800995:	68 21 09 80 00       	push   $0x800921
  80099a:	e8 80 fb ff ff       	call   80051f <vprintfmt>
  80099f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    

008009ad <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009b3:	8d 45 10             	lea    0x10(%ebp),%eax
  8009b6:	83 c0 04             	add    $0x4,%eax
  8009b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c2:	50                   	push   %eax
  8009c3:	ff 75 0c             	pushl  0xc(%ebp)
  8009c6:	ff 75 08             	pushl  0x8(%ebp)
  8009c9:	e8 89 ff ff ff       	call   800957 <vsnprintf>
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009d7:	c9                   	leave  
  8009d8:	c3                   	ret    

008009d9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009e6:	eb 06                	jmp    8009ee <strlen+0x15>
		n++;
  8009e8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009eb:	ff 45 08             	incl   0x8(%ebp)
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8a 00                	mov    (%eax),%al
  8009f3:	84 c0                	test   %al,%al
  8009f5:	75 f1                	jne    8009e8 <strlen+0xf>
		n++;
	return n;
  8009f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009fa:	c9                   	leave  
  8009fb:	c3                   	ret    

008009fc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a09:	eb 09                	jmp    800a14 <strnlen+0x18>
		n++;
  800a0b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0e:	ff 45 08             	incl   0x8(%ebp)
  800a11:	ff 4d 0c             	decl   0xc(%ebp)
  800a14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a18:	74 09                	je     800a23 <strnlen+0x27>
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8a 00                	mov    (%eax),%al
  800a1f:	84 c0                	test   %al,%al
  800a21:	75 e8                	jne    800a0b <strnlen+0xf>
		n++;
	return n;
  800a23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a26:	c9                   	leave  
  800a27:	c3                   	ret    

00800a28 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a34:	90                   	nop
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	8d 50 01             	lea    0x1(%eax),%edx
  800a3b:	89 55 08             	mov    %edx,0x8(%ebp)
  800a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a41:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a44:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a47:	8a 12                	mov    (%edx),%dl
  800a49:	88 10                	mov    %dl,(%eax)
  800a4b:	8a 00                	mov    (%eax),%al
  800a4d:	84 c0                	test   %al,%al
  800a4f:	75 e4                	jne    800a35 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    

00800a56 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a69:	eb 1f                	jmp    800a8a <strncpy+0x34>
		*dst++ = *src;
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	8d 50 01             	lea    0x1(%eax),%edx
  800a71:	89 55 08             	mov    %edx,0x8(%ebp)
  800a74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a77:	8a 12                	mov    (%edx),%dl
  800a79:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	8a 00                	mov    (%eax),%al
  800a80:	84 c0                	test   %al,%al
  800a82:	74 03                	je     800a87 <strncpy+0x31>
			src++;
  800a84:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a87:	ff 45 fc             	incl   -0x4(%ebp)
  800a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a8d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a90:	72 d9                	jb     800a6b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a92:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aa3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa7:	74 30                	je     800ad9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aa9:	eb 16                	jmp    800ac1 <strlcpy+0x2a>
			*dst++ = *src++;
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8d 50 01             	lea    0x1(%eax),%edx
  800ab1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800abd:	8a 12                	mov    (%edx),%dl
  800abf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ac1:	ff 4d 10             	decl   0x10(%ebp)
  800ac4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac8:	74 09                	je     800ad3 <strlcpy+0x3c>
  800aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acd:	8a 00                	mov    (%eax),%al
  800acf:	84 c0                	test   %al,%al
  800ad1:	75 d8                	jne    800aab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad9:	8b 55 08             	mov    0x8(%ebp),%edx
  800adc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800adf:	29 c2                	sub    %eax,%edx
  800ae1:	89 d0                	mov    %edx,%eax
}
  800ae3:	c9                   	leave  
  800ae4:	c3                   	ret    

00800ae5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ae8:	eb 06                	jmp    800af0 <strcmp+0xb>
		p++, q++;
  800aea:	ff 45 08             	incl   0x8(%ebp)
  800aed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	8a 00                	mov    (%eax),%al
  800af5:	84 c0                	test   %al,%al
  800af7:	74 0e                	je     800b07 <strcmp+0x22>
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8a 10                	mov    (%eax),%dl
  800afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b01:	8a 00                	mov    (%eax),%al
  800b03:	38 c2                	cmp    %al,%dl
  800b05:	74 e3                	je     800aea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8a 00                	mov    (%eax),%al
  800b0c:	0f b6 d0             	movzbl %al,%edx
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	8a 00                	mov    (%eax),%al
  800b14:	0f b6 c0             	movzbl %al,%eax
  800b17:	29 c2                	sub    %eax,%edx
  800b19:	89 d0                	mov    %edx,%eax
}
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b20:	eb 09                	jmp    800b2b <strncmp+0xe>
		n--, p++, q++;
  800b22:	ff 4d 10             	decl   0x10(%ebp)
  800b25:	ff 45 08             	incl   0x8(%ebp)
  800b28:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b2f:	74 17                	je     800b48 <strncmp+0x2b>
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8a 00                	mov    (%eax),%al
  800b36:	84 c0                	test   %al,%al
  800b38:	74 0e                	je     800b48 <strncmp+0x2b>
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8a 10                	mov    (%eax),%dl
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	8a 00                	mov    (%eax),%al
  800b44:	38 c2                	cmp    %al,%dl
  800b46:	74 da                	je     800b22 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b4c:	75 07                	jne    800b55 <strncmp+0x38>
		return 0;
  800b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b53:	eb 14                	jmp    800b69 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	0f b6 d0             	movzbl %al,%edx
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	8a 00                	mov    (%eax),%al
  800b62:	0f b6 c0             	movzbl %al,%eax
  800b65:	29 c2                	sub    %eax,%edx
  800b67:	89 d0                	mov    %edx,%eax
}
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	83 ec 04             	sub    $0x4,%esp
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b77:	eb 12                	jmp    800b8b <strchr+0x20>
		if (*s == c)
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b81:	75 05                	jne    800b88 <strchr+0x1d>
			return (char *) s;
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	eb 11                	jmp    800b99 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b88:	ff 45 08             	incl   0x8(%ebp)
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8a 00                	mov    (%eax),%al
  800b90:	84 c0                	test   %al,%al
  800b92:	75 e5                	jne    800b79 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 04             	sub    $0x4,%esp
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ba7:	eb 0d                	jmp    800bb6 <strfind+0x1b>
		if (*s == c)
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	8a 00                	mov    (%eax),%al
  800bae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bb1:	74 0e                	je     800bc1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bb3:	ff 45 08             	incl   0x8(%ebp)
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	8a 00                	mov    (%eax),%al
  800bbb:	84 c0                	test   %al,%al
  800bbd:	75 ea                	jne    800ba9 <strfind+0xe>
  800bbf:	eb 01                	jmp    800bc2 <strfind+0x27>
		if (*s == c)
			break;
  800bc1:	90                   	nop
	return (char *) s;
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800bd3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800bd7:	76 63                	jbe    800c3c <memset+0x75>
		uint64 data_block = c;
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	99                   	cltd   
  800bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800bed:	c1 e0 08             	shl    $0x8,%eax
  800bf0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bf3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfc:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800c00:	c1 e0 10             	shl    $0x10,%eax
  800c03:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c06:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0f:	89 c2                	mov    %eax,%edx
  800c11:	b8 00 00 00 00       	mov    $0x0,%eax
  800c16:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c19:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c1c:	eb 18                	jmp    800c36 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c1e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c21:	8d 41 08             	lea    0x8(%ecx),%eax
  800c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c2d:	89 01                	mov    %eax,(%ecx)
  800c2f:	89 51 04             	mov    %edx,0x4(%ecx)
  800c32:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c36:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c3a:	77 e2                	ja     800c1e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c40:	74 23                	je     800c65 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c45:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c48:	eb 0e                	jmp    800c58 <memset+0x91>
			*p8++ = (uint8)c;
  800c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c58:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c5e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c61:	85 c0                	test   %eax,%eax
  800c63:	75 e5                	jne    800c4a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800c7c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c80:	76 24                	jbe    800ca6 <memcpy+0x3c>
		while(n >= 8){
  800c82:	eb 1c                	jmp    800ca0 <memcpy+0x36>
			*d64 = *s64;
  800c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c87:	8b 50 04             	mov    0x4(%eax),%edx
  800c8a:	8b 00                	mov    (%eax),%eax
  800c8c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800c8f:	89 01                	mov    %eax,(%ecx)
  800c91:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800c94:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800c98:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800c9c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ca0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ca4:	77 de                	ja     800c84 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ca6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800caa:	74 31                	je     800cdd <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800cb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800cb8:	eb 16                	jmp    800cd0 <memcpy+0x66>
			*d8++ = *s8++;
  800cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ccc:	8a 12                	mov    (%edx),%dl
  800cce:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd6:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd9:	85 c0                	test   %eax,%eax
  800cdb:	75 dd                	jne    800cba <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce0:	c9                   	leave  
  800ce1:	c3                   	ret    

00800ce2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800cf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cfa:	73 50                	jae    800d4c <memmove+0x6a>
  800cfc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cff:	8b 45 10             	mov    0x10(%ebp),%eax
  800d02:	01 d0                	add    %edx,%eax
  800d04:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d07:	76 43                	jbe    800d4c <memmove+0x6a>
		s += n;
  800d09:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d12:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d15:	eb 10                	jmp    800d27 <memmove+0x45>
			*--d = *--s;
  800d17:	ff 4d f8             	decl   -0x8(%ebp)
  800d1a:	ff 4d fc             	decl   -0x4(%ebp)
  800d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d20:	8a 10                	mov    (%eax),%dl
  800d22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d25:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d27:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d30:	85 c0                	test   %eax,%eax
  800d32:	75 e3                	jne    800d17 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d34:	eb 23                	jmp    800d59 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d48:	8a 12                	mov    (%edx),%dl
  800d4a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d52:	89 55 10             	mov    %edx,0x10(%ebp)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	75 dd                	jne    800d36 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d70:	eb 2a                	jmp    800d9c <memcmp+0x3e>
		if (*s1 != *s2)
  800d72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d75:	8a 10                	mov    (%eax),%dl
  800d77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	38 c2                	cmp    %al,%dl
  800d7e:	74 16                	je     800d96 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 d0             	movzbl %al,%edx
  800d88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f b6 c0             	movzbl %al,%eax
  800d90:	29 c2                	sub    %eax,%edx
  800d92:	89 d0                	mov    %edx,%eax
  800d94:	eb 18                	jmp    800dae <memcmp+0x50>
		s1++, s2++;
  800d96:	ff 45 fc             	incl   -0x4(%ebp)
  800d99:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da2:	89 55 10             	mov    %edx,0x10(%ebp)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	75 c9                	jne    800d72 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800da9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800db6:	8b 55 08             	mov    0x8(%ebp),%edx
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	01 d0                	add    %edx,%eax
  800dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dc1:	eb 15                	jmp    800dd8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	0f b6 d0             	movzbl %al,%edx
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	0f b6 c0             	movzbl %al,%eax
  800dd1:	39 c2                	cmp    %eax,%edx
  800dd3:	74 0d                	je     800de2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dd5:	ff 45 08             	incl   0x8(%ebp)
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dde:	72 e3                	jb     800dc3 <memfind+0x13>
  800de0:	eb 01                	jmp    800de3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800de2:	90                   	nop
	return (void *) s;
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800dee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800df5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dfc:	eb 03                	jmp    800e01 <strtol+0x19>
		s++;
  800dfe:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	3c 20                	cmp    $0x20,%al
  800e08:	74 f4                	je     800dfe <strtol+0x16>
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	3c 09                	cmp    $0x9,%al
  800e11:	74 eb                	je     800dfe <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	3c 2b                	cmp    $0x2b,%al
  800e1a:	75 05                	jne    800e21 <strtol+0x39>
		s++;
  800e1c:	ff 45 08             	incl   0x8(%ebp)
  800e1f:	eb 13                	jmp    800e34 <strtol+0x4c>
	else if (*s == '-')
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	3c 2d                	cmp    $0x2d,%al
  800e28:	75 0a                	jne    800e34 <strtol+0x4c>
		s++, neg = 1;
  800e2a:	ff 45 08             	incl   0x8(%ebp)
  800e2d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e38:	74 06                	je     800e40 <strtol+0x58>
  800e3a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e3e:	75 20                	jne    800e60 <strtol+0x78>
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	3c 30                	cmp    $0x30,%al
  800e47:	75 17                	jne    800e60 <strtol+0x78>
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	40                   	inc    %eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 78                	cmp    $0x78,%al
  800e51:	75 0d                	jne    800e60 <strtol+0x78>
		s += 2, base = 16;
  800e53:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e57:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e5e:	eb 28                	jmp    800e88 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e64:	75 15                	jne    800e7b <strtol+0x93>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	3c 30                	cmp    $0x30,%al
  800e6d:	75 0c                	jne    800e7b <strtol+0x93>
		s++, base = 8;
  800e6f:	ff 45 08             	incl   0x8(%ebp)
  800e72:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e79:	eb 0d                	jmp    800e88 <strtol+0xa0>
	else if (base == 0)
  800e7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7f:	75 07                	jne    800e88 <strtol+0xa0>
		base = 10;
  800e81:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	3c 2f                	cmp    $0x2f,%al
  800e8f:	7e 19                	jle    800eaa <strtol+0xc2>
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	3c 39                	cmp    $0x39,%al
  800e98:	7f 10                	jg     800eaa <strtol+0xc2>
			dig = *s - '0';
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	0f be c0             	movsbl %al,%eax
  800ea2:	83 e8 30             	sub    $0x30,%eax
  800ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ea8:	eb 42                	jmp    800eec <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	3c 60                	cmp    $0x60,%al
  800eb1:	7e 19                	jle    800ecc <strtol+0xe4>
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	3c 7a                	cmp    $0x7a,%al
  800eba:	7f 10                	jg     800ecc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	0f be c0             	movsbl %al,%eax
  800ec4:	83 e8 57             	sub    $0x57,%eax
  800ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eca:	eb 20                	jmp    800eec <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	3c 40                	cmp    $0x40,%al
  800ed3:	7e 39                	jle    800f0e <strtol+0x126>
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	3c 5a                	cmp    $0x5a,%al
  800edc:	7f 30                	jg     800f0e <strtol+0x126>
			dig = *s - 'A' + 10;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	0f be c0             	movsbl %al,%eax
  800ee6:	83 e8 37             	sub    $0x37,%eax
  800ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eef:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef2:	7d 19                	jge    800f0d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ef4:	ff 45 08             	incl   0x8(%ebp)
  800ef7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800efe:	89 c2                	mov    %eax,%edx
  800f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f03:	01 d0                	add    %edx,%eax
  800f05:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f08:	e9 7b ff ff ff       	jmp    800e88 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f0d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f12:	74 08                	je     800f1c <strtol+0x134>
		*endptr = (char *) s;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f20:	74 07                	je     800f29 <strtol+0x141>
  800f22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f25:	f7 d8                	neg    %eax
  800f27:	eb 03                	jmp    800f2c <strtol+0x144>
  800f29:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <ltostr>:

void
ltostr(long value, char *str)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f3b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f46:	79 13                	jns    800f5b <ltostr+0x2d>
	{
		neg = 1;
  800f48:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f52:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f55:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f58:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f63:	99                   	cltd   
  800f64:	f7 f9                	idiv   %ecx
  800f66:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6c:	8d 50 01             	lea    0x1(%eax),%edx
  800f6f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f72:	89 c2                	mov    %eax,%edx
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	01 d0                	add    %edx,%eax
  800f79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f7c:	83 c2 30             	add    $0x30,%edx
  800f7f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f84:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f89:	f7 e9                	imul   %ecx
  800f8b:	c1 fa 02             	sar    $0x2,%edx
  800f8e:	89 c8                	mov    %ecx,%eax
  800f90:	c1 f8 1f             	sar    $0x1f,%eax
  800f93:	29 c2                	sub    %eax,%edx
  800f95:	89 d0                	mov    %edx,%eax
  800f97:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9e:	75 bb                	jne    800f5b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fa0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800faa:	48                   	dec    %eax
  800fab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fb2:	74 3d                	je     800ff1 <ltostr+0xc3>
		start = 1 ;
  800fb4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fbb:	eb 34                	jmp    800ff1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	01 d0                	add    %edx,%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd0:	01 c2                	add    %eax,%edx
  800fd2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd8:	01 c8                	add    %ecx,%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fde:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe4:	01 c2                	add    %eax,%edx
  800fe6:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fe9:	88 02                	mov    %al,(%edx)
		start++ ;
  800feb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fee:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ff7:	7c c4                	jl     800fbd <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ff9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fff:	01 d0                	add    %edx,%eax
  801001:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801004:	90                   	nop
  801005:	c9                   	leave  
  801006:	c3                   	ret    

00801007 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80100d:	ff 75 08             	pushl  0x8(%ebp)
  801010:	e8 c4 f9 ff ff       	call   8009d9 <strlen>
  801015:	83 c4 04             	add    $0x4,%esp
  801018:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80101b:	ff 75 0c             	pushl  0xc(%ebp)
  80101e:	e8 b6 f9 ff ff       	call   8009d9 <strlen>
  801023:	83 c4 04             	add    $0x4,%esp
  801026:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801029:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801030:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801037:	eb 17                	jmp    801050 <strcconcat+0x49>
		final[s] = str1[s] ;
  801039:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103c:	8b 45 10             	mov    0x10(%ebp),%eax
  80103f:	01 c2                	add    %eax,%edx
  801041:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	01 c8                	add    %ecx,%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80104d:	ff 45 fc             	incl   -0x4(%ebp)
  801050:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801053:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801056:	7c e1                	jl     801039 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801058:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80105f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801066:	eb 1f                	jmp    801087 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801068:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106b:	8d 50 01             	lea    0x1(%eax),%edx
  80106e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801071:	89 c2                	mov    %eax,%edx
  801073:	8b 45 10             	mov    0x10(%ebp),%eax
  801076:	01 c2                	add    %eax,%edx
  801078:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	01 c8                	add    %ecx,%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801084:	ff 45 f8             	incl   -0x8(%ebp)
  801087:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80108d:	7c d9                	jl     801068 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80108f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801092:	8b 45 10             	mov    0x10(%ebp),%eax
  801095:	01 d0                	add    %edx,%eax
  801097:	c6 00 00             	movb   $0x0,(%eax)
}
  80109a:	90                   	nop
  80109b:	c9                   	leave  
  80109c:	c3                   	ret    

0080109d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ac:	8b 00                	mov    (%eax),%eax
  8010ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	01 d0                	add    %edx,%eax
  8010ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010c0:	eb 0c                	jmp    8010ce <strsplit+0x31>
			*string++ = 0;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8d 50 01             	lea    0x1(%eax),%edx
  8010c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8010cb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	84 c0                	test   %al,%al
  8010d5:	74 18                	je     8010ef <strsplit+0x52>
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	0f be c0             	movsbl %al,%eax
  8010df:	50                   	push   %eax
  8010e0:	ff 75 0c             	pushl  0xc(%ebp)
  8010e3:	e8 83 fa ff ff       	call   800b6b <strchr>
  8010e8:	83 c4 08             	add    $0x8,%esp
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	75 d3                	jne    8010c2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	84 c0                	test   %al,%al
  8010f6:	74 5a                	je     801152 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fb:	8b 00                	mov    (%eax),%eax
  8010fd:	83 f8 0f             	cmp    $0xf,%eax
  801100:	75 07                	jne    801109 <strsplit+0x6c>
		{
			return 0;
  801102:	b8 00 00 00 00       	mov    $0x0,%eax
  801107:	eb 66                	jmp    80116f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801109:	8b 45 14             	mov    0x14(%ebp),%eax
  80110c:	8b 00                	mov    (%eax),%eax
  80110e:	8d 48 01             	lea    0x1(%eax),%ecx
  801111:	8b 55 14             	mov    0x14(%ebp),%edx
  801114:	89 0a                	mov    %ecx,(%edx)
  801116:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80111d:	8b 45 10             	mov    0x10(%ebp),%eax
  801120:	01 c2                	add    %eax,%edx
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801127:	eb 03                	jmp    80112c <strsplit+0x8f>
			string++;
  801129:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	84 c0                	test   %al,%al
  801133:	74 8b                	je     8010c0 <strsplit+0x23>
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	0f be c0             	movsbl %al,%eax
  80113d:	50                   	push   %eax
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	e8 25 fa ff ff       	call   800b6b <strchr>
  801146:	83 c4 08             	add    $0x8,%esp
  801149:	85 c0                	test   %eax,%eax
  80114b:	74 dc                	je     801129 <strsplit+0x8c>
			string++;
	}
  80114d:	e9 6e ff ff ff       	jmp    8010c0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801152:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801153:	8b 45 14             	mov    0x14(%ebp),%eax
  801156:	8b 00                	mov    (%eax),%eax
  801158:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	01 d0                	add    %edx,%eax
  801164:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80116a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80117d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801184:	eb 4a                	jmp    8011d0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801186:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	01 c2                	add    %eax,%edx
  80118e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	01 c8                	add    %ecx,%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80119a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	01 d0                	add    %edx,%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 40                	cmp    $0x40,%al
  8011a6:	7e 25                	jle    8011cd <str2lower+0x5c>
  8011a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	01 d0                	add    %edx,%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	3c 5a                	cmp    $0x5a,%al
  8011b4:	7f 17                	jg     8011cd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8011b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	01 ca                	add    %ecx,%edx
  8011c6:	8a 12                	mov    (%edx),%dl
  8011c8:	83 c2 20             	add    $0x20,%edx
  8011cb:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8011cd:	ff 45 fc             	incl   -0x4(%ebp)
  8011d0:	ff 75 0c             	pushl  0xc(%ebp)
  8011d3:	e8 01 f8 ff ff       	call   8009d9 <strlen>
  8011d8:	83 c4 04             	add    $0x4,%esp
  8011db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011de:	7f a6                	jg     801186 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8011e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	57                   	push   %edi
  8011e9:	56                   	push   %esi
  8011ea:	53                   	push   %ebx
  8011eb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011fa:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011fd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801200:	cd 30                	int    $0x30
  801202:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801205:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	5b                   	pop    %ebx
  80120c:	5e                   	pop    %esi
  80120d:	5f                   	pop    %edi
  80120e:	5d                   	pop    %ebp
  80120f:	c3                   	ret    

00801210 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	83 ec 04             	sub    $0x4,%esp
  801216:	8b 45 10             	mov    0x10(%ebp),%eax
  801219:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80121c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80121f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	6a 00                	push   $0x0
  801228:	51                   	push   %ecx
  801229:	52                   	push   %edx
  80122a:	ff 75 0c             	pushl  0xc(%ebp)
  80122d:	50                   	push   %eax
  80122e:	6a 00                	push   $0x0
  801230:	e8 b0 ff ff ff       	call   8011e5 <syscall>
  801235:	83 c4 18             	add    $0x18,%esp
}
  801238:	90                   	nop
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <sys_cgetc>:

int
sys_cgetc(void)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80123e:	6a 00                	push   $0x0
  801240:	6a 00                	push   $0x0
  801242:	6a 00                	push   $0x0
  801244:	6a 00                	push   $0x0
  801246:	6a 00                	push   $0x0
  801248:	6a 02                	push   $0x2
  80124a:	e8 96 ff ff ff       	call   8011e5 <syscall>
  80124f:	83 c4 18             	add    $0x18,%esp
}
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	6a 03                	push   $0x3
  801263:	e8 7d ff ff ff       	call   8011e5 <syscall>
  801268:	83 c4 18             	add    $0x18,%esp
}
  80126b:	90                   	nop
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801271:	6a 00                	push   $0x0
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 04                	push   $0x4
  80127d:	e8 63 ff ff ff       	call   8011e5 <syscall>
  801282:	83 c4 18             	add    $0x18,%esp
}
  801285:	90                   	nop
  801286:	c9                   	leave  
  801287:	c3                   	ret    

00801288 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80128b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	52                   	push   %edx
  801298:	50                   	push   %eax
  801299:	6a 08                	push   $0x8
  80129b:	e8 45 ff ff ff       	call   8011e5 <syscall>
  8012a0:	83 c4 18             	add    $0x18,%esp
}
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	56                   	push   %esi
  8012a9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012aa:	8b 75 18             	mov    0x18(%ebp),%esi
  8012ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
  8012bb:	51                   	push   %ecx
  8012bc:	52                   	push   %edx
  8012bd:	50                   	push   %eax
  8012be:	6a 09                	push   $0x9
  8012c0:	e8 20 ff ff ff       	call   8011e5 <syscall>
  8012c5:	83 c4 18             	add    $0x18,%esp
}
  8012c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012cb:	5b                   	pop    %ebx
  8012cc:	5e                   	pop    %esi
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    

008012cf <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	ff 75 08             	pushl  0x8(%ebp)
  8012dd:	6a 0a                	push   $0xa
  8012df:	e8 01 ff ff ff       	call   8011e5 <syscall>
  8012e4:	83 c4 18             	add    $0x18,%esp
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	ff 75 0c             	pushl  0xc(%ebp)
  8012f5:	ff 75 08             	pushl  0x8(%ebp)
  8012f8:	6a 0b                	push   $0xb
  8012fa:	e8 e6 fe ff ff       	call   8011e5 <syscall>
  8012ff:	83 c4 18             	add    $0x18,%esp
}
  801302:	c9                   	leave  
  801303:	c3                   	ret    

00801304 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	6a 0c                	push   $0xc
  801313:	e8 cd fe ff ff       	call   8011e5 <syscall>
  801318:	83 c4 18             	add    $0x18,%esp
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 0d                	push   $0xd
  80132c:	e8 b4 fe ff ff       	call   8011e5 <syscall>
  801331:	83 c4 18             	add    $0x18,%esp
}
  801334:	c9                   	leave  
  801335:	c3                   	ret    

00801336 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 0e                	push   $0xe
  801345:	e8 9b fe ff ff       	call   8011e5 <syscall>
  80134a:	83 c4 18             	add    $0x18,%esp
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 0f                	push   $0xf
  80135e:	e8 82 fe ff ff       	call   8011e5 <syscall>
  801363:	83 c4 18             	add    $0x18,%esp
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	6a 10                	push   $0x10
  801378:	e8 68 fe ff ff       	call   8011e5 <syscall>
  80137d:	83 c4 18             	add    $0x18,%esp
}
  801380:	c9                   	leave  
  801381:	c3                   	ret    

00801382 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 11                	push   $0x11
  801391:	e8 4f fe ff ff       	call   8011e5 <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	90                   	nop
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <sys_cputc>:

void
sys_cputc(const char c)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	83 ec 04             	sub    $0x4,%esp
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013a8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	50                   	push   %eax
  8013b5:	6a 01                	push   $0x1
  8013b7:	e8 29 fe ff ff       	call   8011e5 <syscall>
  8013bc:	83 c4 18             	add    $0x18,%esp
}
  8013bf:	90                   	nop
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 14                	push   $0x14
  8013d1:	e8 0f fe ff ff       	call   8011e5 <syscall>
  8013d6:	83 c4 18             	add    $0x18,%esp
}
  8013d9:	90                   	nop
  8013da:	c9                   	leave  
  8013db:	c3                   	ret    

008013dc <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	83 ec 04             	sub    $0x4,%esp
  8013e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013e8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013eb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	6a 00                	push   $0x0
  8013f4:	51                   	push   %ecx
  8013f5:	52                   	push   %edx
  8013f6:	ff 75 0c             	pushl  0xc(%ebp)
  8013f9:	50                   	push   %eax
  8013fa:	6a 15                	push   $0x15
  8013fc:	e8 e4 fd ff ff       	call   8011e5 <syscall>
  801401:	83 c4 18             	add    $0x18,%esp
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801409:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	52                   	push   %edx
  801416:	50                   	push   %eax
  801417:	6a 16                	push   $0x16
  801419:	e8 c7 fd ff ff       	call   8011e5 <syscall>
  80141e:	83 c4 18             	add    $0x18,%esp
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801426:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801429:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	51                   	push   %ecx
  801434:	52                   	push   %edx
  801435:	50                   	push   %eax
  801436:	6a 17                	push   $0x17
  801438:	e8 a8 fd ff ff       	call   8011e5 <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
}
  801440:	c9                   	leave  
  801441:	c3                   	ret    

00801442 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801445:	8b 55 0c             	mov    0xc(%ebp),%edx
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	52                   	push   %edx
  801452:	50                   	push   %eax
  801453:	6a 18                	push   $0x18
  801455:	e8 8b fd ff ff       	call   8011e5 <syscall>
  80145a:	83 c4 18             	add    $0x18,%esp
}
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	6a 00                	push   $0x0
  801467:	ff 75 14             	pushl  0x14(%ebp)
  80146a:	ff 75 10             	pushl  0x10(%ebp)
  80146d:	ff 75 0c             	pushl  0xc(%ebp)
  801470:	50                   	push   %eax
  801471:	6a 19                	push   $0x19
  801473:	e8 6d fd ff ff       	call   8011e5 <syscall>
  801478:	83 c4 18             	add    $0x18,%esp
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	50                   	push   %eax
  80148c:	6a 1a                	push   $0x1a
  80148e:	e8 52 fd ff ff       	call   8011e5 <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	90                   	nop
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	50                   	push   %eax
  8014a8:	6a 1b                	push   $0x1b
  8014aa:	e8 36 fd ff ff       	call   8011e5 <syscall>
  8014af:	83 c4 18             	add    $0x18,%esp
}
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 05                	push   $0x5
  8014c3:	e8 1d fd ff ff       	call   8011e5 <syscall>
  8014c8:	83 c4 18             	add    $0x18,%esp
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 06                	push   $0x6
  8014dc:	e8 04 fd ff ff       	call   8011e5 <syscall>
  8014e1:	83 c4 18             	add    $0x18,%esp
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 07                	push   $0x7
  8014f5:	e8 eb fc ff ff       	call   8011e5 <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <sys_exit_env>:


void sys_exit_env(void)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 1c                	push   $0x1c
  80150e:	e8 d2 fc ff ff       	call   8011e5 <syscall>
  801513:	83 c4 18             	add    $0x18,%esp
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80151f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801522:	8d 50 04             	lea    0x4(%eax),%edx
  801525:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	52                   	push   %edx
  80152f:	50                   	push   %eax
  801530:	6a 1d                	push   $0x1d
  801532:	e8 ae fc ff ff       	call   8011e5 <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
	return result;
  80153a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801540:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801543:	89 01                	mov    %eax,(%ecx)
  801545:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	c9                   	leave  
  80154c:	c2 04 00             	ret    $0x4

0080154f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	ff 75 10             	pushl  0x10(%ebp)
  801559:	ff 75 0c             	pushl  0xc(%ebp)
  80155c:	ff 75 08             	pushl  0x8(%ebp)
  80155f:	6a 13                	push   $0x13
  801561:	e8 7f fc ff ff       	call   8011e5 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
	return ;
  801569:	90                   	nop
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_rcr2>:
uint32 sys_rcr2()
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 1e                	push   $0x1e
  80157b:	e8 65 fc ff ff       	call   8011e5 <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 04             	sub    $0x4,%esp
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801591:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	50                   	push   %eax
  80159e:	6a 1f                	push   $0x1f
  8015a0:	e8 40 fc ff ff       	call   8011e5 <syscall>
  8015a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a8:	90                   	nop
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <rsttst>:
void rsttst()
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 21                	push   $0x21
  8015ba:	e8 26 fc ff ff       	call   8011e5 <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c2:	90                   	nop
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 04             	sub    $0x4,%esp
  8015cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015d1:	8b 55 18             	mov    0x18(%ebp),%edx
  8015d4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015d8:	52                   	push   %edx
  8015d9:	50                   	push   %eax
  8015da:	ff 75 10             	pushl  0x10(%ebp)
  8015dd:	ff 75 0c             	pushl  0xc(%ebp)
  8015e0:	ff 75 08             	pushl  0x8(%ebp)
  8015e3:	6a 20                	push   $0x20
  8015e5:	e8 fb fb ff ff       	call   8011e5 <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ed:	90                   	nop
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <chktst>:
void chktst(uint32 n)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	ff 75 08             	pushl  0x8(%ebp)
  8015fe:	6a 22                	push   $0x22
  801600:	e8 e0 fb ff ff       	call   8011e5 <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
	return ;
  801608:	90                   	nop
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <inctst>:

void inctst()
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 23                	push   $0x23
  80161a:	e8 c6 fb ff ff       	call   8011e5 <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
	return ;
  801622:	90                   	nop
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <gettst>:
uint32 gettst()
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 24                	push   $0x24
  801634:	e8 ac fb ff ff       	call   8011e5 <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 25                	push   $0x25
  80164d:	e8 93 fb ff ff       	call   8011e5 <syscall>
  801652:	83 c4 18             	add    $0x18,%esp
  801655:	a3 60 a0 81 00       	mov    %eax,0x81a060
	return uheapPlaceStrategy ;
  80165a:	a1 60 a0 81 00       	mov    0x81a060,%eax
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	a3 60 a0 81 00       	mov    %eax,0x81a060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	ff 75 08             	pushl  0x8(%ebp)
  801677:	6a 26                	push   $0x26
  801679:	e8 67 fb ff ff       	call   8011e5 <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
	return ;
  801681:	90                   	nop
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801688:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	6a 00                	push   $0x0
  801696:	53                   	push   %ebx
  801697:	51                   	push   %ecx
  801698:	52                   	push   %edx
  801699:	50                   	push   %eax
  80169a:	6a 27                	push   $0x27
  80169c:	e8 44 fb ff ff       	call   8011e5 <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	52                   	push   %edx
  8016b9:	50                   	push   %eax
  8016ba:	6a 28                	push   $0x28
  8016bc:	e8 24 fb ff ff       	call   8011e5 <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016c9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	6a 00                	push   $0x0
  8016d4:	51                   	push   %ecx
  8016d5:	ff 75 10             	pushl  0x10(%ebp)
  8016d8:	52                   	push   %edx
  8016d9:	50                   	push   %eax
  8016da:	6a 29                	push   $0x29
  8016dc:	e8 04 fb ff ff       	call   8011e5 <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	ff 75 10             	pushl  0x10(%ebp)
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	ff 75 08             	pushl  0x8(%ebp)
  8016f6:	6a 12                	push   $0x12
  8016f8:	e8 e8 fa ff ff       	call   8011e5 <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801700:	90                   	nop
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801706:	8b 55 0c             	mov    0xc(%ebp),%edx
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	52                   	push   %edx
  801713:	50                   	push   %eax
  801714:	6a 2a                	push   $0x2a
  801716:	e8 ca fa ff ff       	call   8011e5 <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
	return;
  80171e:	90                   	nop
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 2b                	push   $0x2b
  801730:	e8 b0 fa ff ff       	call   8011e5 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	ff 75 08             	pushl  0x8(%ebp)
  801749:	6a 2d                	push   $0x2d
  80174b:	e8 95 fa ff ff       	call   8011e5 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
	return;
  801753:	90                   	nop
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	ff 75 0c             	pushl  0xc(%ebp)
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	6a 2c                	push   $0x2c
  801767:	e8 79 fa ff ff       	call   8011e5 <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
	return ;
  80176f:	90                   	nop
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801775:	8b 55 0c             	mov    0xc(%ebp),%edx
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	52                   	push   %edx
  801782:	50                   	push   %eax
  801783:	6a 2e                	push   $0x2e
  801785:	e8 5b fa ff ff       	call   8011e5 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
	    return;
  80178d:	90                   	nop
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <__udivdi3>:
  801790:	55                   	push   %ebp
  801791:	57                   	push   %edi
  801792:	56                   	push   %esi
  801793:	53                   	push   %ebx
  801794:	83 ec 1c             	sub    $0x1c,%esp
  801797:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80179b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80179f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8017a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017a7:	89 ca                	mov    %ecx,%edx
  8017a9:	89 f8                	mov    %edi,%eax
  8017ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8017af:	85 f6                	test   %esi,%esi
  8017b1:	75 2d                	jne    8017e0 <__udivdi3+0x50>
  8017b3:	39 cf                	cmp    %ecx,%edi
  8017b5:	77 65                	ja     80181c <__udivdi3+0x8c>
  8017b7:	89 fd                	mov    %edi,%ebp
  8017b9:	85 ff                	test   %edi,%edi
  8017bb:	75 0b                	jne    8017c8 <__udivdi3+0x38>
  8017bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c2:	31 d2                	xor    %edx,%edx
  8017c4:	f7 f7                	div    %edi
  8017c6:	89 c5                	mov    %eax,%ebp
  8017c8:	31 d2                	xor    %edx,%edx
  8017ca:	89 c8                	mov    %ecx,%eax
  8017cc:	f7 f5                	div    %ebp
  8017ce:	89 c1                	mov    %eax,%ecx
  8017d0:	89 d8                	mov    %ebx,%eax
  8017d2:	f7 f5                	div    %ebp
  8017d4:	89 cf                	mov    %ecx,%edi
  8017d6:	89 fa                	mov    %edi,%edx
  8017d8:	83 c4 1c             	add    $0x1c,%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5e                   	pop    %esi
  8017dd:	5f                   	pop    %edi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    
  8017e0:	39 ce                	cmp    %ecx,%esi
  8017e2:	77 28                	ja     80180c <__udivdi3+0x7c>
  8017e4:	0f bd fe             	bsr    %esi,%edi
  8017e7:	83 f7 1f             	xor    $0x1f,%edi
  8017ea:	75 40                	jne    80182c <__udivdi3+0x9c>
  8017ec:	39 ce                	cmp    %ecx,%esi
  8017ee:	72 0a                	jb     8017fa <__udivdi3+0x6a>
  8017f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017f4:	0f 87 9e 00 00 00    	ja     801898 <__udivdi3+0x108>
  8017fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ff:	89 fa                	mov    %edi,%edx
  801801:	83 c4 1c             	add    $0x1c,%esp
  801804:	5b                   	pop    %ebx
  801805:	5e                   	pop    %esi
  801806:	5f                   	pop    %edi
  801807:	5d                   	pop    %ebp
  801808:	c3                   	ret    
  801809:	8d 76 00             	lea    0x0(%esi),%esi
  80180c:	31 ff                	xor    %edi,%edi
  80180e:	31 c0                	xor    %eax,%eax
  801810:	89 fa                	mov    %edi,%edx
  801812:	83 c4 1c             	add    $0x1c,%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5f                   	pop    %edi
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    
  80181a:	66 90                	xchg   %ax,%ax
  80181c:	89 d8                	mov    %ebx,%eax
  80181e:	f7 f7                	div    %edi
  801820:	31 ff                	xor    %edi,%edi
  801822:	89 fa                	mov    %edi,%edx
  801824:	83 c4 1c             	add    $0x1c,%esp
  801827:	5b                   	pop    %ebx
  801828:	5e                   	pop    %esi
  801829:	5f                   	pop    %edi
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    
  80182c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801831:	89 eb                	mov    %ebp,%ebx
  801833:	29 fb                	sub    %edi,%ebx
  801835:	89 f9                	mov    %edi,%ecx
  801837:	d3 e6                	shl    %cl,%esi
  801839:	89 c5                	mov    %eax,%ebp
  80183b:	88 d9                	mov    %bl,%cl
  80183d:	d3 ed                	shr    %cl,%ebp
  80183f:	89 e9                	mov    %ebp,%ecx
  801841:	09 f1                	or     %esi,%ecx
  801843:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801847:	89 f9                	mov    %edi,%ecx
  801849:	d3 e0                	shl    %cl,%eax
  80184b:	89 c5                	mov    %eax,%ebp
  80184d:	89 d6                	mov    %edx,%esi
  80184f:	88 d9                	mov    %bl,%cl
  801851:	d3 ee                	shr    %cl,%esi
  801853:	89 f9                	mov    %edi,%ecx
  801855:	d3 e2                	shl    %cl,%edx
  801857:	8b 44 24 08          	mov    0x8(%esp),%eax
  80185b:	88 d9                	mov    %bl,%cl
  80185d:	d3 e8                	shr    %cl,%eax
  80185f:	09 c2                	or     %eax,%edx
  801861:	89 d0                	mov    %edx,%eax
  801863:	89 f2                	mov    %esi,%edx
  801865:	f7 74 24 0c          	divl   0xc(%esp)
  801869:	89 d6                	mov    %edx,%esi
  80186b:	89 c3                	mov    %eax,%ebx
  80186d:	f7 e5                	mul    %ebp
  80186f:	39 d6                	cmp    %edx,%esi
  801871:	72 19                	jb     80188c <__udivdi3+0xfc>
  801873:	74 0b                	je     801880 <__udivdi3+0xf0>
  801875:	89 d8                	mov    %ebx,%eax
  801877:	31 ff                	xor    %edi,%edi
  801879:	e9 58 ff ff ff       	jmp    8017d6 <__udivdi3+0x46>
  80187e:	66 90                	xchg   %ax,%ax
  801880:	8b 54 24 08          	mov    0x8(%esp),%edx
  801884:	89 f9                	mov    %edi,%ecx
  801886:	d3 e2                	shl    %cl,%edx
  801888:	39 c2                	cmp    %eax,%edx
  80188a:	73 e9                	jae    801875 <__udivdi3+0xe5>
  80188c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80188f:	31 ff                	xor    %edi,%edi
  801891:	e9 40 ff ff ff       	jmp    8017d6 <__udivdi3+0x46>
  801896:	66 90                	xchg   %ax,%ax
  801898:	31 c0                	xor    %eax,%eax
  80189a:	e9 37 ff ff ff       	jmp    8017d6 <__udivdi3+0x46>
  80189f:	90                   	nop

008018a0 <__umoddi3>:
  8018a0:	55                   	push   %ebp
  8018a1:	57                   	push   %edi
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 1c             	sub    $0x1c,%esp
  8018a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8018ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8018af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8018b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018bf:	89 f3                	mov    %esi,%ebx
  8018c1:	89 fa                	mov    %edi,%edx
  8018c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018c7:	89 34 24             	mov    %esi,(%esp)
  8018ca:	85 c0                	test   %eax,%eax
  8018cc:	75 1a                	jne    8018e8 <__umoddi3+0x48>
  8018ce:	39 f7                	cmp    %esi,%edi
  8018d0:	0f 86 a2 00 00 00    	jbe    801978 <__umoddi3+0xd8>
  8018d6:	89 c8                	mov    %ecx,%eax
  8018d8:	89 f2                	mov    %esi,%edx
  8018da:	f7 f7                	div    %edi
  8018dc:	89 d0                	mov    %edx,%eax
  8018de:	31 d2                	xor    %edx,%edx
  8018e0:	83 c4 1c             	add    $0x1c,%esp
  8018e3:	5b                   	pop    %ebx
  8018e4:	5e                   	pop    %esi
  8018e5:	5f                   	pop    %edi
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    
  8018e8:	39 f0                	cmp    %esi,%eax
  8018ea:	0f 87 ac 00 00 00    	ja     80199c <__umoddi3+0xfc>
  8018f0:	0f bd e8             	bsr    %eax,%ebp
  8018f3:	83 f5 1f             	xor    $0x1f,%ebp
  8018f6:	0f 84 ac 00 00 00    	je     8019a8 <__umoddi3+0x108>
  8018fc:	bf 20 00 00 00       	mov    $0x20,%edi
  801901:	29 ef                	sub    %ebp,%edi
  801903:	89 fe                	mov    %edi,%esi
  801905:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801909:	89 e9                	mov    %ebp,%ecx
  80190b:	d3 e0                	shl    %cl,%eax
  80190d:	89 d7                	mov    %edx,%edi
  80190f:	89 f1                	mov    %esi,%ecx
  801911:	d3 ef                	shr    %cl,%edi
  801913:	09 c7                	or     %eax,%edi
  801915:	89 e9                	mov    %ebp,%ecx
  801917:	d3 e2                	shl    %cl,%edx
  801919:	89 14 24             	mov    %edx,(%esp)
  80191c:	89 d8                	mov    %ebx,%eax
  80191e:	d3 e0                	shl    %cl,%eax
  801920:	89 c2                	mov    %eax,%edx
  801922:	8b 44 24 08          	mov    0x8(%esp),%eax
  801926:	d3 e0                	shl    %cl,%eax
  801928:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801930:	89 f1                	mov    %esi,%ecx
  801932:	d3 e8                	shr    %cl,%eax
  801934:	09 d0                	or     %edx,%eax
  801936:	d3 eb                	shr    %cl,%ebx
  801938:	89 da                	mov    %ebx,%edx
  80193a:	f7 f7                	div    %edi
  80193c:	89 d3                	mov    %edx,%ebx
  80193e:	f7 24 24             	mull   (%esp)
  801941:	89 c6                	mov    %eax,%esi
  801943:	89 d1                	mov    %edx,%ecx
  801945:	39 d3                	cmp    %edx,%ebx
  801947:	0f 82 87 00 00 00    	jb     8019d4 <__umoddi3+0x134>
  80194d:	0f 84 91 00 00 00    	je     8019e4 <__umoddi3+0x144>
  801953:	8b 54 24 04          	mov    0x4(%esp),%edx
  801957:	29 f2                	sub    %esi,%edx
  801959:	19 cb                	sbb    %ecx,%ebx
  80195b:	89 d8                	mov    %ebx,%eax
  80195d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801961:	d3 e0                	shl    %cl,%eax
  801963:	89 e9                	mov    %ebp,%ecx
  801965:	d3 ea                	shr    %cl,%edx
  801967:	09 d0                	or     %edx,%eax
  801969:	89 e9                	mov    %ebp,%ecx
  80196b:	d3 eb                	shr    %cl,%ebx
  80196d:	89 da                	mov    %ebx,%edx
  80196f:	83 c4 1c             	add    $0x1c,%esp
  801972:	5b                   	pop    %ebx
  801973:	5e                   	pop    %esi
  801974:	5f                   	pop    %edi
  801975:	5d                   	pop    %ebp
  801976:	c3                   	ret    
  801977:	90                   	nop
  801978:	89 fd                	mov    %edi,%ebp
  80197a:	85 ff                	test   %edi,%edi
  80197c:	75 0b                	jne    801989 <__umoddi3+0xe9>
  80197e:	b8 01 00 00 00       	mov    $0x1,%eax
  801983:	31 d2                	xor    %edx,%edx
  801985:	f7 f7                	div    %edi
  801987:	89 c5                	mov    %eax,%ebp
  801989:	89 f0                	mov    %esi,%eax
  80198b:	31 d2                	xor    %edx,%edx
  80198d:	f7 f5                	div    %ebp
  80198f:	89 c8                	mov    %ecx,%eax
  801991:	f7 f5                	div    %ebp
  801993:	89 d0                	mov    %edx,%eax
  801995:	e9 44 ff ff ff       	jmp    8018de <__umoddi3+0x3e>
  80199a:	66 90                	xchg   %ax,%ax
  80199c:	89 c8                	mov    %ecx,%eax
  80199e:	89 f2                	mov    %esi,%edx
  8019a0:	83 c4 1c             	add    $0x1c,%esp
  8019a3:	5b                   	pop    %ebx
  8019a4:	5e                   	pop    %esi
  8019a5:	5f                   	pop    %edi
  8019a6:	5d                   	pop    %ebp
  8019a7:	c3                   	ret    
  8019a8:	3b 04 24             	cmp    (%esp),%eax
  8019ab:	72 06                	jb     8019b3 <__umoddi3+0x113>
  8019ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8019b1:	77 0f                	ja     8019c2 <__umoddi3+0x122>
  8019b3:	89 f2                	mov    %esi,%edx
  8019b5:	29 f9                	sub    %edi,%ecx
  8019b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8019bb:	89 14 24             	mov    %edx,(%esp)
  8019be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8019c6:	8b 14 24             	mov    (%esp),%edx
  8019c9:	83 c4 1c             	add    $0x1c,%esp
  8019cc:	5b                   	pop    %ebx
  8019cd:	5e                   	pop    %esi
  8019ce:	5f                   	pop    %edi
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    
  8019d1:	8d 76 00             	lea    0x0(%esi),%esi
  8019d4:	2b 04 24             	sub    (%esp),%eax
  8019d7:	19 fa                	sbb    %edi,%edx
  8019d9:	89 d1                	mov    %edx,%ecx
  8019db:	89 c6                	mov    %eax,%esi
  8019dd:	e9 71 ff ff ff       	jmp    801953 <__umoddi3+0xb3>
  8019e2:	66 90                	xchg   %ax,%ax
  8019e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019e8:	72 ea                	jb     8019d4 <__umoddi3+0x134>
  8019ea:	89 d9                	mov    %ebx,%ecx
  8019ec:	e9 62 ff ff ff       	jmp    801953 <__umoddi3+0xb3>
