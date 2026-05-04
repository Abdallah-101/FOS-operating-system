
obj/user/fos_data_on_stack:     file format elf32-i386


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
  800031:	e8 1e 00 00 00       	call   800054 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 27 00 00    	sub    $0x2748,%esp
	/// Adding array of 512 integer on user stack
	int arr[2512];

	atomic_cprintf("user stack contains 512 integer\n");
  800041:	83 ec 0c             	sub    $0xc,%esp
  800044:	68 00 1a 80 00       	push   $0x801a00
  800049:	e8 11 03 00 00       	call   80035f <atomic_cprintf>
  80004e:	83 c4 10             	add    $0x10,%esp

	return;	
  800051:	90                   	nop
}
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	57                   	push   %edi
  800058:	56                   	push   %esi
  800059:	53                   	push   %ebx
  80005a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005d:	e8 58 14 00 00       	call   8014ba <sys_getenvindex>
  800062:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800065:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	c1 e0 02             	shl    $0x2,%eax
  80006d:	01 d0                	add    %edx,%eax
  80006f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800076:	01 d0                	add    %edx,%eax
  800078:	89 c2                	mov    %eax,%edx
  80007a:	c1 e2 04             	shl    $0x4,%edx
  80007d:	29 c2                	sub    %eax,%edx
  80007f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800086:	89 c2                	mov    %eax,%edx
  800088:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80008e:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800093:	a1 20 20 80 00       	mov    0x802020,%eax
  800098:	8a 40 20             	mov    0x20(%eax),%al
  80009b:	84 c0                	test   %al,%al
  80009d:	74 0d                	je     8000ac <libmain+0x58>
		binaryname = myEnv->prog_name;
  80009f:	a1 20 20 80 00       	mov    0x802020,%eax
  8000a4:	83 c0 20             	add    $0x20,%eax
  8000a7:	a3 04 20 80 00       	mov    %eax,0x802004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b0:	7e 0a                	jle    8000bc <libmain+0x68>
		binaryname = argv[0];
  8000b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b5:	8b 00                	mov    (%eax),%eax
  8000b7:	a3 04 20 80 00       	mov    %eax,0x802004

	// call user main routine
	_main(argc, argv);
  8000bc:	83 ec 08             	sub    $0x8,%esp
  8000bf:	ff 75 0c             	pushl  0xc(%ebp)
  8000c2:	ff 75 08             	pushl  0x8(%ebp)
  8000c5:	e8 6e ff ff ff       	call   800038 <_main>
  8000ca:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000cd:	a1 00 20 80 00       	mov    0x802000,%eax
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	0f 84 01 01 00 00    	je     8001db <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000da:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000e0:	bb 1c 1b 80 00       	mov    $0x801b1c,%ebx
  8000e5:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000ea:	89 c7                	mov    %eax,%edi
  8000ec:	89 de                	mov    %ebx,%esi
  8000ee:	89 d1                	mov    %edx,%ecx
  8000f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000f2:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000f5:	b9 56 00 00 00       	mov    $0x56,%ecx
  8000fa:	b0 00                	mov    $0x0,%al
  8000fc:	89 d7                	mov    %edx,%edi
  8000fe:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800100:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800107:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80010a:	83 ec 08             	sub    $0x8,%esp
  80010d:	50                   	push   %eax
  80010e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800114:	50                   	push   %eax
  800115:	e8 d6 15 00 00       	call   8016f0 <sys_utilities>
  80011a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80011d:	e8 1f 11 00 00       	call   801241 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	68 3c 1a 80 00       	push   $0x801a3c
  80012a:	e8 be 01 00 00       	call   8002ed <cprintf>
  80012f:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800132:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800135:	85 c0                	test   %eax,%eax
  800137:	74 18                	je     800151 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800139:	e8 d0 15 00 00       	call   80170e <sys_get_optimal_num_faults>
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	50                   	push   %eax
  800142:	68 64 1a 80 00       	push   $0x801a64
  800147:	e8 a1 01 00 00       	call   8002ed <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	eb 59                	jmp    8001aa <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800151:	a1 20 20 80 00       	mov    0x802020,%eax
  800156:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80015c:	a1 20 20 80 00       	mov    0x802020,%eax
  800161:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800167:	83 ec 04             	sub    $0x4,%esp
  80016a:	52                   	push   %edx
  80016b:	50                   	push   %eax
  80016c:	68 88 1a 80 00       	push   $0x801a88
  800171:	e8 77 01 00 00       	call   8002ed <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800179:	a1 20 20 80 00       	mov    0x802020,%eax
  80017e:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800184:	a1 20 20 80 00       	mov    0x802020,%eax
  800189:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80018f:	a1 20 20 80 00       	mov    0x802020,%eax
  800194:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80019a:	51                   	push   %ecx
  80019b:	52                   	push   %edx
  80019c:	50                   	push   %eax
  80019d:	68 b0 1a 80 00       	push   $0x801ab0
  8001a2:	e8 46 01 00 00       	call   8002ed <cprintf>
  8001a7:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001aa:	a1 20 20 80 00       	mov    0x802020,%eax
  8001af:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	50                   	push   %eax
  8001b9:	68 08 1b 80 00       	push   $0x801b08
  8001be:	e8 2a 01 00 00       	call   8002ed <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 3c 1a 80 00       	push   $0x801a3c
  8001ce:	e8 1a 01 00 00       	call   8002ed <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001d6:	e8 80 10 00 00       	call   80125b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001db:	e8 1f 00 00 00       	call   8001ff <exit>
}
  8001e0:	90                   	nop
  8001e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e4:	5b                   	pop    %ebx
  8001e5:	5e                   	pop    %esi
  8001e6:	5f                   	pop    %edi
  8001e7:	5d                   	pop    %ebp
  8001e8:	c3                   	ret    

008001e9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e9:	55                   	push   %ebp
  8001ea:	89 e5                	mov    %esp,%ebp
  8001ec:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	6a 00                	push   $0x0
  8001f4:	e8 8d 12 00 00       	call   801486 <sys_destroy_env>
  8001f9:	83 c4 10             	add    $0x10,%esp
}
  8001fc:	90                   	nop
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <exit>:

void
exit(void)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800205:	e8 e2 12 00 00       	call   8014ec <sys_exit_env>
}
  80020a:	90                   	nop
  80020b:	c9                   	leave  
  80020c:	c3                   	ret    

0080020d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80020d:	55                   	push   %ebp
  80020e:	89 e5                	mov    %esp,%ebp
  800210:	53                   	push   %ebx
  800211:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800214:	8b 45 0c             	mov    0xc(%ebp),%eax
  800217:	8b 00                	mov    (%eax),%eax
  800219:	8d 48 01             	lea    0x1(%eax),%ecx
  80021c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021f:	89 0a                	mov    %ecx,(%edx)
  800221:	8b 55 08             	mov    0x8(%ebp),%edx
  800224:	88 d1                	mov    %dl,%cl
  800226:	8b 55 0c             	mov    0xc(%ebp),%edx
  800229:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80022d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800230:	8b 00                	mov    (%eax),%eax
  800232:	3d ff 00 00 00       	cmp    $0xff,%eax
  800237:	75 30                	jne    800269 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800239:	8b 15 18 a1 81 00    	mov    0x81a118,%edx
  80023f:	a0 44 20 80 00       	mov    0x802044,%al
  800244:	0f b6 c0             	movzbl %al,%eax
  800247:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80024a:	8b 09                	mov    (%ecx),%ecx
  80024c:	89 cb                	mov    %ecx,%ebx
  80024e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800251:	83 c1 08             	add    $0x8,%ecx
  800254:	52                   	push   %edx
  800255:	50                   	push   %eax
  800256:	53                   	push   %ebx
  800257:	51                   	push   %ecx
  800258:	e8 a0 0f 00 00       	call   8011fd <sys_cputs>
  80025d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026c:	8b 40 04             	mov    0x4(%eax),%eax
  80026f:	8d 50 01             	lea    0x1(%eax),%edx
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
  800275:	89 50 04             	mov    %edx,0x4(%eax)
}
  800278:	90                   	nop
  800279:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800287:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80028e:	00 00 00 
	b.cnt = 0;
  800291:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800298:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80029b:	ff 75 0c             	pushl  0xc(%ebp)
  80029e:	ff 75 08             	pushl  0x8(%ebp)
  8002a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a7:	50                   	push   %eax
  8002a8:	68 0d 02 80 00       	push   $0x80020d
  8002ad:	e8 5a 02 00 00       	call   80050c <vprintfmt>
  8002b2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002b5:	8b 15 18 a1 81 00    	mov    0x81a118,%edx
  8002bb:	a0 44 20 80 00       	mov    0x802044,%al
  8002c0:	0f b6 c0             	movzbl %al,%eax
  8002c3:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8002c9:	52                   	push   %edx
  8002ca:	50                   	push   %eax
  8002cb:	51                   	push   %ecx
  8002cc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d2:	83 c0 08             	add    $0x8,%eax
  8002d5:	50                   	push   %eax
  8002d6:	e8 22 0f 00 00       	call   8011fd <sys_cputs>
  8002db:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002de:	c6 05 44 20 80 00 00 	movb   $0x0,0x802044
	return b.cnt;
  8002e5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002eb:	c9                   	leave  
  8002ec:	c3                   	ret    

008002ed <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002f3:	c6 05 44 20 80 00 01 	movb   $0x1,0x802044
	va_start(ap, fmt);
  8002fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800300:	8b 45 08             	mov    0x8(%ebp),%eax
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	ff 75 f4             	pushl  -0xc(%ebp)
  800309:	50                   	push   %eax
  80030a:	e8 6f ff ff ff       	call   80027e <vcprintf>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800315:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800318:	c9                   	leave  
  800319:	c3                   	ret    

0080031a <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800320:	c6 05 44 20 80 00 01 	movb   $0x1,0x802044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	c1 e0 08             	shl    $0x8,%eax
  80032d:	a3 18 a1 81 00       	mov    %eax,0x81a118
	va_start(ap, fmt);
  800332:	8d 45 0c             	lea    0xc(%ebp),%eax
  800335:	83 c0 04             	add    $0x4,%eax
  800338:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80033b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	ff 75 f4             	pushl  -0xc(%ebp)
  800344:	50                   	push   %eax
  800345:	e8 34 ff ff ff       	call   80027e <vcprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
  80034d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800350:	c7 05 18 a1 81 00 00 	movl   $0x700,0x81a118
  800357:	07 00 00 

	return cnt;
  80035a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80035d:	c9                   	leave  
  80035e:	c3                   	ret    

0080035f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800365:	e8 d7 0e 00 00       	call   801241 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80036a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80036d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	50                   	push   %eax
  80037a:	e8 ff fe ff ff       	call   80027e <vcprintf>
  80037f:	83 c4 10             	add    $0x10,%esp
  800382:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800385:	e8 d1 0e 00 00       	call   80125b <sys_unlock_cons>
	return cnt;
  80038a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	53                   	push   %ebx
  800393:	83 ec 14             	sub    $0x14,%esp
  800396:	8b 45 10             	mov    0x10(%ebp),%eax
  800399:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80039c:	8b 45 14             	mov    0x14(%ebp),%eax
  80039f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003ad:	77 55                	ja     800404 <printnum+0x75>
  8003af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003b2:	72 05                	jb     8003b9 <printnum+0x2a>
  8003b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b7:	77 4b                	ja     800404 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c7:	52                   	push   %edx
  8003c8:	50                   	push   %eax
  8003c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8003cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003cf:	e8 ac 13 00 00       	call   801780 <__udivdi3>
  8003d4:	83 c4 10             	add    $0x10,%esp
  8003d7:	83 ec 04             	sub    $0x4,%esp
  8003da:	ff 75 20             	pushl  0x20(%ebp)
  8003dd:	53                   	push   %ebx
  8003de:	ff 75 18             	pushl  0x18(%ebp)
  8003e1:	52                   	push   %edx
  8003e2:	50                   	push   %eax
  8003e3:	ff 75 0c             	pushl  0xc(%ebp)
  8003e6:	ff 75 08             	pushl  0x8(%ebp)
  8003e9:	e8 a1 ff ff ff       	call   80038f <printnum>
  8003ee:	83 c4 20             	add    $0x20,%esp
  8003f1:	eb 1a                	jmp    80040d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	ff 75 0c             	pushl  0xc(%ebp)
  8003f9:	ff 75 20             	pushl  0x20(%ebp)
  8003fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ff:	ff d0                	call   *%eax
  800401:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800404:	ff 4d 1c             	decl   0x1c(%ebp)
  800407:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80040b:	7f e6                	jg     8003f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80040d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800410:	bb 00 00 00 00       	mov    $0x0,%ebx
  800415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800418:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041b:	53                   	push   %ebx
  80041c:	51                   	push   %ecx
  80041d:	52                   	push   %edx
  80041e:	50                   	push   %eax
  80041f:	e8 6c 14 00 00       	call   801890 <__umoddi3>
  800424:	83 c4 10             	add    $0x10,%esp
  800427:	05 94 1d 80 00       	add    $0x801d94,%eax
  80042c:	8a 00                	mov    (%eax),%al
  80042e:	0f be c0             	movsbl %al,%eax
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	ff 75 0c             	pushl  0xc(%ebp)
  800437:	50                   	push   %eax
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	ff d0                	call   *%eax
  80043d:	83 c4 10             	add    $0x10,%esp
}
  800440:	90                   	nop
  800441:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800444:	c9                   	leave  
  800445:	c3                   	ret    

00800446 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800449:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80044d:	7e 1c                	jle    80046b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	8d 50 08             	lea    0x8(%eax),%edx
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	89 10                	mov    %edx,(%eax)
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	83 e8 08             	sub    $0x8,%eax
  800464:	8b 50 04             	mov    0x4(%eax),%edx
  800467:	8b 00                	mov    (%eax),%eax
  800469:	eb 40                	jmp    8004ab <getuint+0x65>
	else if (lflag)
  80046b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80046f:	74 1e                	je     80048f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800471:	8b 45 08             	mov    0x8(%ebp),%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	8d 50 04             	lea    0x4(%eax),%edx
  800479:	8b 45 08             	mov    0x8(%ebp),%eax
  80047c:	89 10                	mov    %edx,(%eax)
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	83 e8 04             	sub    $0x4,%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	ba 00 00 00 00       	mov    $0x0,%edx
  80048d:	eb 1c                	jmp    8004ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	8d 50 04             	lea    0x4(%eax),%edx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	89 10                	mov    %edx,(%eax)
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	83 e8 04             	sub    $0x4,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ab:	5d                   	pop    %ebp
  8004ac:	c3                   	ret    

008004ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004b4:	7e 1c                	jle    8004d2 <getint+0x25>
		return va_arg(*ap, long long);
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	8d 50 08             	lea    0x8(%eax),%edx
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	89 10                	mov    %edx,(%eax)
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	83 e8 08             	sub    $0x8,%eax
  8004cb:	8b 50 04             	mov    0x4(%eax),%edx
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	eb 38                	jmp    80050a <getint+0x5d>
	else if (lflag)
  8004d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d6:	74 1a                	je     8004f2 <getint+0x45>
		return va_arg(*ap, long);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 04             	sub    $0x4,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	99                   	cltd   
  8004f0:	eb 18                	jmp    80050a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	8d 50 04             	lea    0x4(%eax),%edx
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	89 10                	mov    %edx,(%eax)
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	83 e8 04             	sub    $0x4,%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	99                   	cltd   
}
  80050a:	5d                   	pop    %ebp
  80050b:	c3                   	ret    

0080050c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	56                   	push   %esi
  800510:	53                   	push   %ebx
  800511:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800514:	eb 17                	jmp    80052d <vprintfmt+0x21>
			if (ch == '\0')
  800516:	85 db                	test   %ebx,%ebx
  800518:	0f 84 c1 03 00 00    	je     8008df <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	ff 75 0c             	pushl  0xc(%ebp)
  800524:	53                   	push   %ebx
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	ff d0                	call   *%eax
  80052a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052d:	8b 45 10             	mov    0x10(%ebp),%eax
  800530:	8d 50 01             	lea    0x1(%eax),%edx
  800533:	89 55 10             	mov    %edx,0x10(%ebp)
  800536:	8a 00                	mov    (%eax),%al
  800538:	0f b6 d8             	movzbl %al,%ebx
  80053b:	83 fb 25             	cmp    $0x25,%ebx
  80053e:	75 d6                	jne    800516 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800540:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800544:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80054b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800552:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800559:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800560:	8b 45 10             	mov    0x10(%ebp),%eax
  800563:	8d 50 01             	lea    0x1(%eax),%edx
  800566:	89 55 10             	mov    %edx,0x10(%ebp)
  800569:	8a 00                	mov    (%eax),%al
  80056b:	0f b6 d8             	movzbl %al,%ebx
  80056e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800571:	83 f8 5b             	cmp    $0x5b,%eax
  800574:	0f 87 3d 03 00 00    	ja     8008b7 <vprintfmt+0x3ab>
  80057a:	8b 04 85 b8 1d 80 00 	mov    0x801db8(,%eax,4),%eax
  800581:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800583:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800587:	eb d7                	jmp    800560 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800589:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80058d:	eb d1                	jmp    800560 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80058f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800596:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800599:	89 d0                	mov    %edx,%eax
  80059b:	c1 e0 02             	shl    $0x2,%eax
  80059e:	01 d0                	add    %edx,%eax
  8005a0:	01 c0                	add    %eax,%eax
  8005a2:	01 d8                	add    %ebx,%eax
  8005a4:	83 e8 30             	sub    $0x30,%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	8a 00                	mov    (%eax),%al
  8005af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8005b5:	7e 3e                	jle    8005f5 <vprintfmt+0xe9>
  8005b7:	83 fb 39             	cmp    $0x39,%ebx
  8005ba:	7f 39                	jg     8005f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005bf:	eb d5                	jmp    800596 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	83 c0 04             	add    $0x4,%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	83 e8 04             	sub    $0x4,%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005d5:	eb 1f                	jmp    8005f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005db:	79 83                	jns    800560 <vprintfmt+0x54>
				width = 0;
  8005dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005e4:	e9 77 ff ff ff       	jmp    800560 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005f0:	e9 6b ff ff ff       	jmp    800560 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fa:	0f 89 60 ff ff ff    	jns    800560 <vprintfmt+0x54>
				width = precision, precision = -1;
  800600:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800603:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800606:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80060d:	e9 4e ff ff ff       	jmp    800560 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800612:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800615:	e9 46 ff ff ff       	jmp    800560 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	83 c0 04             	add    $0x4,%eax
  800620:	89 45 14             	mov    %eax,0x14(%ebp)
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	83 e8 04             	sub    $0x4,%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	50                   	push   %eax
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	ff d0                	call   *%eax
  800637:	83 c4 10             	add    $0x10,%esp
			break;
  80063a:	e9 9b 02 00 00       	jmp    8008da <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	83 c0 04             	add    $0x4,%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	83 e8 04             	sub    $0x4,%eax
  80064e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800650:	85 db                	test   %ebx,%ebx
  800652:	79 02                	jns    800656 <vprintfmt+0x14a>
				err = -err;
  800654:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800656:	83 fb 64             	cmp    $0x64,%ebx
  800659:	7f 0b                	jg     800666 <vprintfmt+0x15a>
  80065b:	8b 34 9d 00 1c 80 00 	mov    0x801c00(,%ebx,4),%esi
  800662:	85 f6                	test   %esi,%esi
  800664:	75 19                	jne    80067f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800666:	53                   	push   %ebx
  800667:	68 a5 1d 80 00       	push   $0x801da5
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	ff 75 08             	pushl  0x8(%ebp)
  800672:	e8 70 02 00 00       	call   8008e7 <printfmt>
  800677:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80067a:	e9 5b 02 00 00       	jmp    8008da <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80067f:	56                   	push   %esi
  800680:	68 ae 1d 80 00       	push   $0x801dae
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	ff 75 08             	pushl  0x8(%ebp)
  80068b:	e8 57 02 00 00       	call   8008e7 <printfmt>
  800690:	83 c4 10             	add    $0x10,%esp
			break;
  800693:	e9 42 02 00 00       	jmp    8008da <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	83 c0 04             	add    $0x4,%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	83 e8 04             	sub    $0x4,%eax
  8006a7:	8b 30                	mov    (%eax),%esi
  8006a9:	85 f6                	test   %esi,%esi
  8006ab:	75 05                	jne    8006b2 <vprintfmt+0x1a6>
				p = "(null)";
  8006ad:	be b1 1d 80 00       	mov    $0x801db1,%esi
			if (width > 0 && padc != '-')
  8006b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b6:	7e 6d                	jle    800725 <vprintfmt+0x219>
  8006b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006bc:	74 67                	je     800725 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	50                   	push   %eax
  8006c5:	56                   	push   %esi
  8006c6:	e8 1e 03 00 00       	call   8009e9 <strnlen>
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006d1:	eb 16                	jmp    8006e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	ff 75 0c             	pushl  0xc(%ebp)
  8006dd:	50                   	push   %eax
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	ff d0                	call   *%eax
  8006e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ed:	7f e4                	jg     8006d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ef:	eb 34                	jmp    800725 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f5:	74 1c                	je     800713 <vprintfmt+0x207>
  8006f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8006fa:	7e 05                	jle    800701 <vprintfmt+0x1f5>
  8006fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8006ff:	7e 12                	jle    800713 <vprintfmt+0x207>
					putch('?', putdat);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	6a 3f                	push   $0x3f
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	ff d0                	call   *%eax
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	eb 0f                	jmp    800722 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	ff 75 0c             	pushl  0xc(%ebp)
  800719:	53                   	push   %ebx
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	ff d0                	call   *%eax
  80071f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800722:	ff 4d e4             	decl   -0x1c(%ebp)
  800725:	89 f0                	mov    %esi,%eax
  800727:	8d 70 01             	lea    0x1(%eax),%esi
  80072a:	8a 00                	mov    (%eax),%al
  80072c:	0f be d8             	movsbl %al,%ebx
  80072f:	85 db                	test   %ebx,%ebx
  800731:	74 24                	je     800757 <vprintfmt+0x24b>
  800733:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800737:	78 b8                	js     8006f1 <vprintfmt+0x1e5>
  800739:	ff 4d e0             	decl   -0x20(%ebp)
  80073c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800740:	79 af                	jns    8006f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800742:	eb 13                	jmp    800757 <vprintfmt+0x24b>
				putch(' ', putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	6a 20                	push   $0x20
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	ff d0                	call   *%eax
  800751:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800754:	ff 4d e4             	decl   -0x1c(%ebp)
  800757:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075b:	7f e7                	jg     800744 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80075d:	e9 78 01 00 00       	jmp    8008da <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	ff 75 e8             	pushl  -0x18(%ebp)
  800768:	8d 45 14             	lea    0x14(%ebp),%eax
  80076b:	50                   	push   %eax
  80076c:	e8 3c fd ff ff       	call   8004ad <getint>
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800777:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80077a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800780:	85 d2                	test   %edx,%edx
  800782:	79 23                	jns    8007a7 <vprintfmt+0x29b>
				putch('-', putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 0c             	pushl  0xc(%ebp)
  80078a:	6a 2d                	push   $0x2d
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	ff d0                	call   *%eax
  800791:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079a:	f7 d8                	neg    %eax
  80079c:	83 d2 00             	adc    $0x0,%edx
  80079f:	f7 da                	neg    %edx
  8007a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007ae:	e9 bc 00 00 00       	jmp    80086f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	e8 84 fc ff ff       	call   800446 <getuint>
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007d2:	e9 98 00 00 00       	jmp    80086f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	6a 58                	push   $0x58
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	ff d0                	call   *%eax
  8007e4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	6a 58                	push   $0x58
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	ff d0                	call   *%eax
  8007f4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	6a 58                	push   $0x58
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	ff d0                	call   *%eax
  800804:	83 c4 10             	add    $0x10,%esp
			break;
  800807:	e9 ce 00 00 00       	jmp    8008da <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	ff 75 0c             	pushl  0xc(%ebp)
  800812:	6a 30                	push   $0x30
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	ff d0                	call   *%eax
  800819:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	6a 78                	push   $0x78
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	ff d0                	call   *%eax
  800829:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80083d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800840:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800847:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80084e:	eb 1f                	jmp    80086f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 e8             	pushl  -0x18(%ebp)
  800856:	8d 45 14             	lea    0x14(%ebp),%eax
  800859:	50                   	push   %eax
  80085a:	e8 e7 fb ff ff       	call   800446 <getuint>
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800865:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800868:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80086f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800876:	83 ec 04             	sub    $0x4,%esp
  800879:	52                   	push   %edx
  80087a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80087d:	50                   	push   %eax
  80087e:	ff 75 f4             	pushl  -0xc(%ebp)
  800881:	ff 75 f0             	pushl  -0x10(%ebp)
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	ff 75 08             	pushl  0x8(%ebp)
  80088a:	e8 00 fb ff ff       	call   80038f <printnum>
  80088f:	83 c4 20             	add    $0x20,%esp
			break;
  800892:	eb 46                	jmp    8008da <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
			break;
  8008a3:	eb 35                	jmp    8008da <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008a5:	c6 05 44 20 80 00 00 	movb   $0x0,0x802044
			break;
  8008ac:	eb 2c                	jmp    8008da <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008ae:	c6 05 44 20 80 00 01 	movb   $0x1,0x802044
			break;
  8008b5:	eb 23                	jmp    8008da <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	6a 25                	push   $0x25
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	ff d0                	call   *%eax
  8008c4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c7:	ff 4d 10             	decl   0x10(%ebp)
  8008ca:	eb 03                	jmp    8008cf <vprintfmt+0x3c3>
  8008cc:	ff 4d 10             	decl   0x10(%ebp)
  8008cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d2:	48                   	dec    %eax
  8008d3:	8a 00                	mov    (%eax),%al
  8008d5:	3c 25                	cmp    $0x25,%al
  8008d7:	75 f3                	jne    8008cc <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008d9:	90                   	nop
		}
	}
  8008da:	e9 35 fc ff ff       	jmp    800514 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008df:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e3:	5b                   	pop    %ebx
  8008e4:	5e                   	pop    %esi
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008ed:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f0:	83 c0 04             	add    $0x4,%eax
  8008f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fc:	50                   	push   %eax
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	ff 75 08             	pushl  0x8(%ebp)
  800903:	e8 04 fc ff ff       	call   80050c <vprintfmt>
  800908:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090b:	90                   	nop
  80090c:	c9                   	leave  
  80090d:	c3                   	ret    

0080090e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800911:	8b 45 0c             	mov    0xc(%ebp),%eax
  800914:	8b 40 08             	mov    0x8(%eax),%eax
  800917:	8d 50 01             	lea    0x1(%eax),%edx
  80091a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800920:	8b 45 0c             	mov    0xc(%ebp),%eax
  800923:	8b 10                	mov    (%eax),%edx
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8b 40 04             	mov    0x4(%eax),%eax
  80092b:	39 c2                	cmp    %eax,%edx
  80092d:	73 12                	jae    800941 <sprintputch+0x33>
		*b->buf++ = ch;
  80092f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 48 01             	lea    0x1(%eax),%ecx
  800937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093a:	89 0a                	mov    %ecx,(%edx)
  80093c:	8b 55 08             	mov    0x8(%ebp),%edx
  80093f:	88 10                	mov    %dl,(%eax)
}
  800941:	90                   	nop
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800950:	8b 45 0c             	mov    0xc(%ebp),%eax
  800953:	8d 50 ff             	lea    -0x1(%eax),%edx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	01 d0                	add    %edx,%eax
  80095b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800965:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800969:	74 06                	je     800971 <vsnprintf+0x2d>
  80096b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80096f:	7f 07                	jg     800978 <vsnprintf+0x34>
		return -E_INVAL;
  800971:	b8 03 00 00 00       	mov    $0x3,%eax
  800976:	eb 20                	jmp    800998 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800978:	ff 75 14             	pushl  0x14(%ebp)
  80097b:	ff 75 10             	pushl  0x10(%ebp)
  80097e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	68 0e 09 80 00       	push   $0x80090e
  800987:	e8 80 fb ff ff       	call   80050c <vprintfmt>
  80098c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80098f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800992:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800995:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a0:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a3:	83 c0 04             	add    $0x4,%eax
  8009a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	ff 75 0c             	pushl  0xc(%ebp)
  8009b3:	ff 75 08             	pushl  0x8(%ebp)
  8009b6:	e8 89 ff ff ff       	call   800944 <vsnprintf>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c4:	c9                   	leave  
  8009c5:	c3                   	ret    

008009c6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d3:	eb 06                	jmp    8009db <strlen+0x15>
		n++;
  8009d5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d8:	ff 45 08             	incl   0x8(%ebp)
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8a 00                	mov    (%eax),%al
  8009e0:	84 c0                	test   %al,%al
  8009e2:	75 f1                	jne    8009d5 <strlen+0xf>
		n++;
	return n;
  8009e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    

008009e9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009f6:	eb 09                	jmp    800a01 <strnlen+0x18>
		n++;
  8009f8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fb:	ff 45 08             	incl   0x8(%ebp)
  8009fe:	ff 4d 0c             	decl   0xc(%ebp)
  800a01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a05:	74 09                	je     800a10 <strnlen+0x27>
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8a 00                	mov    (%eax),%al
  800a0c:	84 c0                	test   %al,%al
  800a0e:	75 e8                	jne    8009f8 <strnlen+0xf>
		n++;
	return n;
  800a10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a13:	c9                   	leave  
  800a14:	c3                   	ret    

00800a15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a21:	90                   	nop
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8d 50 01             	lea    0x1(%eax),%edx
  800a28:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a34:	8a 12                	mov    (%edx),%dl
  800a36:	88 10                	mov    %dl,(%eax)
  800a38:	8a 00                	mov    (%eax),%al
  800a3a:	84 c0                	test   %al,%al
  800a3c:	75 e4                	jne    800a22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a41:	c9                   	leave  
  800a42:	c3                   	ret    

00800a43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a56:	eb 1f                	jmp    800a77 <strncpy+0x34>
		*dst++ = *src;
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8d 50 01             	lea    0x1(%eax),%edx
  800a5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a64:	8a 12                	mov    (%edx),%dl
  800a66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6b:	8a 00                	mov    (%eax),%al
  800a6d:	84 c0                	test   %al,%al
  800a6f:	74 03                	je     800a74 <strncpy+0x31>
			src++;
  800a71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a74:	ff 45 fc             	incl   -0x4(%ebp)
  800a77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a7d:	72 d9                	jb     800a58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a82:	c9                   	leave  
  800a83:	c3                   	ret    

00800a84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a94:	74 30                	je     800ac6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a96:	eb 16                	jmp    800aae <strlcpy+0x2a>
			*dst++ = *src++;
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8d 50 01             	lea    0x1(%eax),%edx
  800a9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aa7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aaa:	8a 12                	mov    (%edx),%dl
  800aac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aae:	ff 4d 10             	decl   0x10(%ebp)
  800ab1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab5:	74 09                	je     800ac0 <strlcpy+0x3c>
  800ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aba:	8a 00                	mov    (%eax),%al
  800abc:	84 c0                	test   %al,%al
  800abe:	75 d8                	jne    800a98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ac6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800acc:	29 c2                	sub    %eax,%edx
  800ace:	89 d0                	mov    %edx,%eax
}
  800ad0:	c9                   	leave  
  800ad1:	c3                   	ret    

00800ad2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ad5:	eb 06                	jmp    800add <strcmp+0xb>
		p++, q++;
  800ad7:	ff 45 08             	incl   0x8(%ebp)
  800ada:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	8a 00                	mov    (%eax),%al
  800ae2:	84 c0                	test   %al,%al
  800ae4:	74 0e                	je     800af4 <strcmp+0x22>
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8a 10                	mov    (%eax),%dl
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8a 00                	mov    (%eax),%al
  800af0:	38 c2                	cmp    %al,%dl
  800af2:	74 e3                	je     800ad7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	8a 00                	mov    (%eax),%al
  800af9:	0f b6 d0             	movzbl %al,%edx
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	8a 00                	mov    (%eax),%al
  800b01:	0f b6 c0             	movzbl %al,%eax
  800b04:	29 c2                	sub    %eax,%edx
  800b06:	89 d0                	mov    %edx,%eax
}
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b0d:	eb 09                	jmp    800b18 <strncmp+0xe>
		n--, p++, q++;
  800b0f:	ff 4d 10             	decl   0x10(%ebp)
  800b12:	ff 45 08             	incl   0x8(%ebp)
  800b15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b1c:	74 17                	je     800b35 <strncmp+0x2b>
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 00                	mov    (%eax),%al
  800b23:	84 c0                	test   %al,%al
  800b25:	74 0e                	je     800b35 <strncmp+0x2b>
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8a 10                	mov    (%eax),%dl
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	8a 00                	mov    (%eax),%al
  800b31:	38 c2                	cmp    %al,%dl
  800b33:	74 da                	je     800b0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b39:	75 07                	jne    800b42 <strncmp+0x38>
		return 0;
  800b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b40:	eb 14                	jmp    800b56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	0f b6 d0             	movzbl %al,%edx
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	8a 00                	mov    (%eax),%al
  800b4f:	0f b6 c0             	movzbl %al,%eax
  800b52:	29 c2                	sub    %eax,%edx
  800b54:	89 d0                	mov    %edx,%eax
}
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	83 ec 04             	sub    $0x4,%esp
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b64:	eb 12                	jmp    800b78 <strchr+0x20>
		if (*s == c)
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b6e:	75 05                	jne    800b75 <strchr+0x1d>
			return (char *) s;
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	eb 11                	jmp    800b86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b75:	ff 45 08             	incl   0x8(%ebp)
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8a 00                	mov    (%eax),%al
  800b7d:	84 c0                	test   %al,%al
  800b7f:	75 e5                	jne    800b66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	83 ec 04             	sub    $0x4,%esp
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b94:	eb 0d                	jmp    800ba3 <strfind+0x1b>
		if (*s == c)
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b9e:	74 0e                	je     800bae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ba0:	ff 45 08             	incl   0x8(%ebp)
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	8a 00                	mov    (%eax),%al
  800ba8:	84 c0                	test   %al,%al
  800baa:	75 ea                	jne    800b96 <strfind+0xe>
  800bac:	eb 01                	jmp    800baf <strfind+0x27>
		if (*s == c)
			break;
  800bae:	90                   	nop
	return (char *) s;
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800bc0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800bc4:	76 63                	jbe    800c29 <memset+0x75>
		uint64 data_block = c;
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	99                   	cltd   
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd6:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800bda:	c1 e0 08             	shl    $0x8,%eax
  800bdd:	09 45 f0             	or     %eax,-0x10(%ebp)
  800be0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be9:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800bed:	c1 e0 10             	shl    $0x10,%eax
  800bf0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bf3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfc:	89 c2                	mov    %eax,%edx
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800c03:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c06:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c09:	eb 18                	jmp    800c23 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c0b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c0e:	8d 41 08             	lea    0x8(%ecx),%eax
  800c11:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1a:	89 01                	mov    %eax,(%ecx)
  800c1c:	89 51 04             	mov    %edx,0x4(%ecx)
  800c1f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c23:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c27:	77 e2                	ja     800c0b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c2d:	74 23                	je     800c52 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c32:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c35:	eb 0e                	jmp    800c45 <memset+0x91>
			*p8++ = (uint8)c;
  800c37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c3a:	8d 50 01             	lea    0x1(%eax),%edx
  800c3d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c43:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	75 e5                	jne    800c37 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800c69:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c6d:	76 24                	jbe    800c93 <memcpy+0x3c>
		while(n >= 8){
  800c6f:	eb 1c                	jmp    800c8d <memcpy+0x36>
			*d64 = *s64;
  800c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c74:	8b 50 04             	mov    0x4(%eax),%edx
  800c77:	8b 00                	mov    (%eax),%eax
  800c79:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800c7c:	89 01                	mov    %eax,(%ecx)
  800c7e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800c81:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800c85:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800c89:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800c8d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c91:	77 de                	ja     800c71 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800c93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c97:	74 31                	je     800cca <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800c9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ca5:	eb 16                	jmp    800cbd <memcpy+0x66>
			*d8++ = *s8++;
  800ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800caa:	8d 50 01             	lea    0x1(%eax),%edx
  800cad:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800cb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb6:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800cb9:	8a 12                	mov    (%edx),%dl
  800cbb:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc3:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc6:	85 c0                	test   %eax,%eax
  800cc8:	75 dd                	jne    800ca7 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ccd:	c9                   	leave  
  800cce:	c3                   	ret    

00800ccf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ce7:	73 50                	jae    800d39 <memmove+0x6a>
  800ce9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cec:	8b 45 10             	mov    0x10(%ebp),%eax
  800cef:	01 d0                	add    %edx,%eax
  800cf1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cf4:	76 43                	jbe    800d39 <memmove+0x6a>
		s += n;
  800cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cff:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d02:	eb 10                	jmp    800d14 <memmove+0x45>
			*--d = *--s;
  800d04:	ff 4d f8             	decl   -0x8(%ebp)
  800d07:	ff 4d fc             	decl   -0x4(%ebp)
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	8a 10                	mov    (%eax),%dl
  800d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d12:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d14:	8b 45 10             	mov    0x10(%ebp),%eax
  800d17:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d1a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	75 e3                	jne    800d04 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d21:	eb 23                	jmp    800d46 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d26:	8d 50 01             	lea    0x1(%eax),%edx
  800d29:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d2f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d32:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d35:	8a 12                	mov    (%edx),%dl
  800d37:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d42:	85 c0                	test   %eax,%eax
  800d44:	75 dd                	jne    800d23 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d49:	c9                   	leave  
  800d4a:	c3                   	ret    

00800d4b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d5d:	eb 2a                	jmp    800d89 <memcmp+0x3e>
		if (*s1 != *s2)
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d62:	8a 10                	mov    (%eax),%dl
  800d64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	38 c2                	cmp    %al,%dl
  800d6b:	74 16                	je     800d83 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	0f b6 d0             	movzbl %al,%edx
  800d75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	0f b6 c0             	movzbl %al,%eax
  800d7d:	29 c2                	sub    %eax,%edx
  800d7f:	89 d0                	mov    %edx,%eax
  800d81:	eb 18                	jmp    800d9b <memcmp+0x50>
		s1++, s2++;
  800d83:	ff 45 fc             	incl   -0x4(%ebp)
  800d86:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d92:	85 c0                	test   %eax,%eax
  800d94:	75 c9                	jne    800d5f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	8b 45 10             	mov    0x10(%ebp),%eax
  800da9:	01 d0                	add    %edx,%eax
  800dab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dae:	eb 15                	jmp    800dc5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	0f b6 d0             	movzbl %al,%edx
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	0f b6 c0             	movzbl %al,%eax
  800dbe:	39 c2                	cmp    %eax,%edx
  800dc0:	74 0d                	je     800dcf <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dcb:	72 e3                	jb     800db0 <memfind+0x13>
  800dcd:	eb 01                	jmp    800dd0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800dcf:	90                   	nop
	return (void *) s;
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd3:	c9                   	leave  
  800dd4:	c3                   	ret    

00800dd5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ddb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800de2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800de9:	eb 03                	jmp    800dee <strtol+0x19>
		s++;
  800deb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	3c 20                	cmp    $0x20,%al
  800df5:	74 f4                	je     800deb <strtol+0x16>
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	3c 09                	cmp    $0x9,%al
  800dfe:	74 eb                	je     800deb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	3c 2b                	cmp    $0x2b,%al
  800e07:	75 05                	jne    800e0e <strtol+0x39>
		s++;
  800e09:	ff 45 08             	incl   0x8(%ebp)
  800e0c:	eb 13                	jmp    800e21 <strtol+0x4c>
	else if (*s == '-')
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	3c 2d                	cmp    $0x2d,%al
  800e15:	75 0a                	jne    800e21 <strtol+0x4c>
		s++, neg = 1;
  800e17:	ff 45 08             	incl   0x8(%ebp)
  800e1a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e25:	74 06                	je     800e2d <strtol+0x58>
  800e27:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e2b:	75 20                	jne    800e4d <strtol+0x78>
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	3c 30                	cmp    $0x30,%al
  800e34:	75 17                	jne    800e4d <strtol+0x78>
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	40                   	inc    %eax
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	3c 78                	cmp    $0x78,%al
  800e3e:	75 0d                	jne    800e4d <strtol+0x78>
		s += 2, base = 16;
  800e40:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e44:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e4b:	eb 28                	jmp    800e75 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e51:	75 15                	jne    800e68 <strtol+0x93>
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	3c 30                	cmp    $0x30,%al
  800e5a:	75 0c                	jne    800e68 <strtol+0x93>
		s++, base = 8;
  800e5c:	ff 45 08             	incl   0x8(%ebp)
  800e5f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e66:	eb 0d                	jmp    800e75 <strtol+0xa0>
	else if (base == 0)
  800e68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6c:	75 07                	jne    800e75 <strtol+0xa0>
		base = 10;
  800e6e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 2f                	cmp    $0x2f,%al
  800e7c:	7e 19                	jle    800e97 <strtol+0xc2>
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	3c 39                	cmp    $0x39,%al
  800e85:	7f 10                	jg     800e97 <strtol+0xc2>
			dig = *s - '0';
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	0f be c0             	movsbl %al,%eax
  800e8f:	83 e8 30             	sub    $0x30,%eax
  800e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e95:	eb 42                	jmp    800ed9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	3c 60                	cmp    $0x60,%al
  800e9e:	7e 19                	jle    800eb9 <strtol+0xe4>
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	3c 7a                	cmp    $0x7a,%al
  800ea7:	7f 10                	jg     800eb9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	0f be c0             	movsbl %al,%eax
  800eb1:	83 e8 57             	sub    $0x57,%eax
  800eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eb7:	eb 20                	jmp    800ed9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	3c 40                	cmp    $0x40,%al
  800ec0:	7e 39                	jle    800efb <strtol+0x126>
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	3c 5a                	cmp    $0x5a,%al
  800ec9:	7f 30                	jg     800efb <strtol+0x126>
			dig = *s - 'A' + 10;
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	0f be c0             	movsbl %al,%eax
  800ed3:	83 e8 37             	sub    $0x37,%eax
  800ed6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800edc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edf:	7d 19                	jge    800efa <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eeb:	89 c2                	mov    %eax,%edx
  800eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef0:	01 d0                	add    %edx,%eax
  800ef2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ef5:	e9 7b ff ff ff       	jmp    800e75 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800efa:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800efb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eff:	74 08                	je     800f09 <strtol+0x134>
		*endptr = (char *) s;
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	8b 55 08             	mov    0x8(%ebp),%edx
  800f07:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f09:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f0d:	74 07                	je     800f16 <strtol+0x141>
  800f0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f12:	f7 d8                	neg    %eax
  800f14:	eb 03                	jmp    800f19 <strtol+0x144>
  800f16:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <ltostr>:

void
ltostr(long value, char *str)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f28:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f33:	79 13                	jns    800f48 <ltostr+0x2d>
	{
		neg = 1;
  800f35:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f42:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f45:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f50:	99                   	cltd   
  800f51:	f7 f9                	idiv   %ecx
  800f53:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f59:	8d 50 01             	lea    0x1(%eax),%edx
  800f5c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5f:	89 c2                	mov    %eax,%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	01 d0                	add    %edx,%eax
  800f66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f69:	83 c2 30             	add    $0x30,%edx
  800f6c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f71:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f76:	f7 e9                	imul   %ecx
  800f78:	c1 fa 02             	sar    $0x2,%edx
  800f7b:	89 c8                	mov    %ecx,%eax
  800f7d:	c1 f8 1f             	sar    $0x1f,%eax
  800f80:	29 c2                	sub    %eax,%edx
  800f82:	89 d0                	mov    %edx,%eax
  800f84:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f8b:	75 bb                	jne    800f48 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f97:	48                   	dec    %eax
  800f98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f9f:	74 3d                	je     800fde <ltostr+0xc3>
		start = 1 ;
  800fa1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fa8:	eb 34                	jmp    800fde <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800faa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	01 d0                	add    %edx,%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbd:	01 c2                	add    %eax,%edx
  800fbf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	01 c8                	add    %ecx,%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fcb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	01 c2                	add    %eax,%edx
  800fd3:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fd6:	88 02                	mov    %al,(%edx)
		start++ ;
  800fd8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fdb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe4:	7c c4                	jl     800faa <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fe6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	01 d0                	add    %edx,%eax
  800fee:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ff1:	90                   	nop
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ffa:	ff 75 08             	pushl  0x8(%ebp)
  800ffd:	e8 c4 f9 ff ff       	call   8009c6 <strlen>
  801002:	83 c4 04             	add    $0x4,%esp
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801008:	ff 75 0c             	pushl  0xc(%ebp)
  80100b:	e8 b6 f9 ff ff       	call   8009c6 <strlen>
  801010:	83 c4 04             	add    $0x4,%esp
  801013:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801016:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80101d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801024:	eb 17                	jmp    80103d <strcconcat+0x49>
		final[s] = str1[s] ;
  801026:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801029:	8b 45 10             	mov    0x10(%ebp),%eax
  80102c:	01 c2                	add    %eax,%edx
  80102e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	01 c8                	add    %ecx,%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80103a:	ff 45 fc             	incl   -0x4(%ebp)
  80103d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801040:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801043:	7c e1                	jl     801026 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801045:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80104c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801053:	eb 1f                	jmp    801074 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801055:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801058:	8d 50 01             	lea    0x1(%eax),%edx
  80105b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80105e:	89 c2                	mov    %eax,%edx
  801060:	8b 45 10             	mov    0x10(%ebp),%eax
  801063:	01 c2                	add    %eax,%edx
  801065:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	01 c8                	add    %ecx,%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801071:	ff 45 f8             	incl   -0x8(%ebp)
  801074:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801077:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107a:	7c d9                	jl     801055 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80107c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80107f:	8b 45 10             	mov    0x10(%ebp),%eax
  801082:	01 d0                	add    %edx,%eax
  801084:	c6 00 00             	movb   $0x0,(%eax)
}
  801087:	90                   	nop
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80108d:	8b 45 14             	mov    0x14(%ebp),%eax
  801090:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801096:	8b 45 14             	mov    0x14(%ebp),%eax
  801099:	8b 00                	mov    (%eax),%eax
  80109b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a5:	01 d0                	add    %edx,%eax
  8010a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010ad:	eb 0c                	jmp    8010bb <strsplit+0x31>
			*string++ = 0;
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8d 50 01             	lea    0x1(%eax),%edx
  8010b5:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	84 c0                	test   %al,%al
  8010c2:	74 18                	je     8010dc <strsplit+0x52>
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	0f be c0             	movsbl %al,%eax
  8010cc:	50                   	push   %eax
  8010cd:	ff 75 0c             	pushl  0xc(%ebp)
  8010d0:	e8 83 fa ff ff       	call   800b58 <strchr>
  8010d5:	83 c4 08             	add    $0x8,%esp
  8010d8:	85 c0                	test   %eax,%eax
  8010da:	75 d3                	jne    8010af <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	84 c0                	test   %al,%al
  8010e3:	74 5a                	je     80113f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e8:	8b 00                	mov    (%eax),%eax
  8010ea:	83 f8 0f             	cmp    $0xf,%eax
  8010ed:	75 07                	jne    8010f6 <strsplit+0x6c>
		{
			return 0;
  8010ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f4:	eb 66                	jmp    80115c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f9:	8b 00                	mov    (%eax),%eax
  8010fb:	8d 48 01             	lea    0x1(%eax),%ecx
  8010fe:	8b 55 14             	mov    0x14(%ebp),%edx
  801101:	89 0a                	mov    %ecx,(%edx)
  801103:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80110a:	8b 45 10             	mov    0x10(%ebp),%eax
  80110d:	01 c2                	add    %eax,%edx
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801114:	eb 03                	jmp    801119 <strsplit+0x8f>
			string++;
  801116:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	84 c0                	test   %al,%al
  801120:	74 8b                	je     8010ad <strsplit+0x23>
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	0f be c0             	movsbl %al,%eax
  80112a:	50                   	push   %eax
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	e8 25 fa ff ff       	call   800b58 <strchr>
  801133:	83 c4 08             	add    $0x8,%esp
  801136:	85 c0                	test   %eax,%eax
  801138:	74 dc                	je     801116 <strsplit+0x8c>
			string++;
	}
  80113a:	e9 6e ff ff ff       	jmp    8010ad <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80113f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801140:	8b 45 14             	mov    0x14(%ebp),%eax
  801143:	8b 00                	mov    (%eax),%eax
  801145:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114c:	8b 45 10             	mov    0x10(%ebp),%eax
  80114f:	01 d0                	add    %edx,%eax
  801151:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801157:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80115c:	c9                   	leave  
  80115d:	c3                   	ret    

0080115e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80116a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801171:	eb 4a                	jmp    8011bd <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801173:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	01 c2                	add    %eax,%edx
  80117b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	01 c8                	add    %ecx,%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801187:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	01 d0                	add    %edx,%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 40                	cmp    $0x40,%al
  801193:	7e 25                	jle    8011ba <str2lower+0x5c>
  801195:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	01 d0                	add    %edx,%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	3c 5a                	cmp    $0x5a,%al
  8011a1:	7f 17                	jg     8011ba <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8011a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	01 d0                	add    %edx,%eax
  8011ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b1:	01 ca                	add    %ecx,%edx
  8011b3:	8a 12                	mov    (%edx),%dl
  8011b5:	83 c2 20             	add    $0x20,%edx
  8011b8:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8011ba:	ff 45 fc             	incl   -0x4(%ebp)
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	e8 01 f8 ff ff       	call   8009c6 <strlen>
  8011c5:	83 c4 04             	add    $0x4,%esp
  8011c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011cb:	7f a6                	jg     801173 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8011cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	57                   	push   %edi
  8011d6:	56                   	push   %esi
  8011d7:	53                   	push   %ebx
  8011d8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011e4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011e7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011ea:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011ed:	cd 30                	int    $0x30
  8011ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8011f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011f5:	83 c4 10             	add    $0x10,%esp
  8011f8:	5b                   	pop    %ebx
  8011f9:	5e                   	pop    %esi
  8011fa:	5f                   	pop    %edi
  8011fb:	5d                   	pop    %ebp
  8011fc:	c3                   	ret    

008011fd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 04             	sub    $0x4,%esp
  801203:	8b 45 10             	mov    0x10(%ebp),%eax
  801206:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801209:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80120c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	6a 00                	push   $0x0
  801215:	51                   	push   %ecx
  801216:	52                   	push   %edx
  801217:	ff 75 0c             	pushl  0xc(%ebp)
  80121a:	50                   	push   %eax
  80121b:	6a 00                	push   $0x0
  80121d:	e8 b0 ff ff ff       	call   8011d2 <syscall>
  801222:	83 c4 18             	add    $0x18,%esp
}
  801225:	90                   	nop
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <sys_cgetc>:

int
sys_cgetc(void)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80122b:	6a 00                	push   $0x0
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 02                	push   $0x2
  801237:	e8 96 ff ff ff       	call   8011d2 <syscall>
  80123c:	83 c4 18             	add    $0x18,%esp
}
  80123f:	c9                   	leave  
  801240:	c3                   	ret    

00801241 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801244:	6a 00                	push   $0x0
  801246:	6a 00                	push   $0x0
  801248:	6a 00                	push   $0x0
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	6a 03                	push   $0x3
  801250:	e8 7d ff ff ff       	call   8011d2 <syscall>
  801255:	83 c4 18             	add    $0x18,%esp
}
  801258:	90                   	nop
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 04                	push   $0x4
  80126a:	e8 63 ff ff ff       	call   8011d2 <syscall>
  80126f:	83 c4 18             	add    $0x18,%esp
}
  801272:	90                   	nop
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801278:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	52                   	push   %edx
  801285:	50                   	push   %eax
  801286:	6a 08                	push   $0x8
  801288:	e8 45 ff ff ff       	call   8011d2 <syscall>
  80128d:	83 c4 18             	add    $0x18,%esp
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	56                   	push   %esi
  801296:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801297:	8b 75 18             	mov    0x18(%ebp),%esi
  80129a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80129d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	56                   	push   %esi
  8012a7:	53                   	push   %ebx
  8012a8:	51                   	push   %ecx
  8012a9:	52                   	push   %edx
  8012aa:	50                   	push   %eax
  8012ab:	6a 09                	push   $0x9
  8012ad:	e8 20 ff ff ff       	call   8011d2 <syscall>
  8012b2:	83 c4 18             	add    $0x18,%esp
}
  8012b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b8:	5b                   	pop    %ebx
  8012b9:	5e                   	pop    %esi
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	ff 75 08             	pushl  0x8(%ebp)
  8012ca:	6a 0a                	push   $0xa
  8012cc:	e8 01 ff ff ff       	call   8011d2 <syscall>
  8012d1:	83 c4 18             	add    $0x18,%esp
}
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    

008012d6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	6a 00                	push   $0x0
  8012df:	ff 75 0c             	pushl  0xc(%ebp)
  8012e2:	ff 75 08             	pushl  0x8(%ebp)
  8012e5:	6a 0b                	push   $0xb
  8012e7:	e8 e6 fe ff ff       	call   8011d2 <syscall>
  8012ec:	83 c4 18             	add    $0x18,%esp
}
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 0c                	push   $0xc
  801300:	e8 cd fe ff ff       	call   8011d2 <syscall>
  801305:	83 c4 18             	add    $0x18,%esp
}
  801308:	c9                   	leave  
  801309:	c3                   	ret    

0080130a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 0d                	push   $0xd
  801319:	e8 b4 fe ff ff       	call   8011d2 <syscall>
  80131e:	83 c4 18             	add    $0x18,%esp
}
  801321:	c9                   	leave  
  801322:	c3                   	ret    

00801323 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 0e                	push   $0xe
  801332:	e8 9b fe ff ff       	call   8011d2 <syscall>
  801337:	83 c4 18             	add    $0x18,%esp
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 0f                	push   $0xf
  80134b:	e8 82 fe ff ff       	call   8011d2 <syscall>
  801350:	83 c4 18             	add    $0x18,%esp
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	ff 75 08             	pushl  0x8(%ebp)
  801363:	6a 10                	push   $0x10
  801365:	e8 68 fe ff ff       	call   8011d2 <syscall>
  80136a:	83 c4 18             	add    $0x18,%esp
}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 11                	push   $0x11
  80137e:	e8 4f fe ff ff       	call   8011d2 <syscall>
  801383:	83 c4 18             	add    $0x18,%esp
}
  801386:	90                   	nop
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <sys_cputc>:

void
sys_cputc(const char c)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 04             	sub    $0x4,%esp
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801395:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	50                   	push   %eax
  8013a2:	6a 01                	push   $0x1
  8013a4:	e8 29 fe ff ff       	call   8011d2 <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
}
  8013ac:	90                   	nop
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 14                	push   $0x14
  8013be:	e8 0f fe ff ff       	call   8011d2 <syscall>
  8013c3:	83 c4 18             	add    $0x18,%esp
}
  8013c6:	90                   	nop
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	83 ec 04             	sub    $0x4,%esp
  8013cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013d5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	6a 00                	push   $0x0
  8013e1:	51                   	push   %ecx
  8013e2:	52                   	push   %edx
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	50                   	push   %eax
  8013e7:	6a 15                	push   $0x15
  8013e9:	e8 e4 fd ff ff       	call   8011d2 <syscall>
  8013ee:	83 c4 18             	add    $0x18,%esp
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	52                   	push   %edx
  801403:	50                   	push   %eax
  801404:	6a 16                	push   $0x16
  801406:	e8 c7 fd ff ff       	call   8011d2 <syscall>
  80140b:	83 c4 18             	add    $0x18,%esp
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801413:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801416:	8b 55 0c             	mov    0xc(%ebp),%edx
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	51                   	push   %ecx
  801421:	52                   	push   %edx
  801422:	50                   	push   %eax
  801423:	6a 17                	push   $0x17
  801425:	e8 a8 fd ff ff       	call   8011d2 <syscall>
  80142a:	83 c4 18             	add    $0x18,%esp
}
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801432:	8b 55 0c             	mov    0xc(%ebp),%edx
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	52                   	push   %edx
  80143f:	50                   	push   %eax
  801440:	6a 18                	push   $0x18
  801442:	e8 8b fd ff ff       	call   8011d2 <syscall>
  801447:	83 c4 18             	add    $0x18,%esp
}
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	6a 00                	push   $0x0
  801454:	ff 75 14             	pushl  0x14(%ebp)
  801457:	ff 75 10             	pushl  0x10(%ebp)
  80145a:	ff 75 0c             	pushl  0xc(%ebp)
  80145d:	50                   	push   %eax
  80145e:	6a 19                	push   $0x19
  801460:	e8 6d fd ff ff       	call   8011d2 <syscall>
  801465:	83 c4 18             	add    $0x18,%esp
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	50                   	push   %eax
  801479:	6a 1a                	push   $0x1a
  80147b:	e8 52 fd ff ff       	call   8011d2 <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
}
  801483:	90                   	nop
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	50                   	push   %eax
  801495:	6a 1b                	push   $0x1b
  801497:	e8 36 fd ff ff       	call   8011d2 <syscall>
  80149c:	83 c4 18             	add    $0x18,%esp
}
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 05                	push   $0x5
  8014b0:	e8 1d fd ff ff       	call   8011d2 <syscall>
  8014b5:	83 c4 18             	add    $0x18,%esp
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 06                	push   $0x6
  8014c9:	e8 04 fd ff ff       	call   8011d2 <syscall>
  8014ce:	83 c4 18             	add    $0x18,%esp
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 07                	push   $0x7
  8014e2:	e8 eb fc ff ff       	call   8011d2 <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_exit_env>:


void sys_exit_env(void)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 1c                	push   $0x1c
  8014fb:	e8 d2 fc ff ff       	call   8011d2 <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	90                   	nop
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80150c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80150f:	8d 50 04             	lea    0x4(%eax),%edx
  801512:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	52                   	push   %edx
  80151c:	50                   	push   %eax
  80151d:	6a 1d                	push   $0x1d
  80151f:	e8 ae fc ff ff       	call   8011d2 <syscall>
  801524:	83 c4 18             	add    $0x18,%esp
	return result;
  801527:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801530:	89 01                	mov    %eax,(%ecx)
  801532:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	c9                   	leave  
  801539:	c2 04 00             	ret    $0x4

0080153c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	ff 75 10             	pushl  0x10(%ebp)
  801546:	ff 75 0c             	pushl  0xc(%ebp)
  801549:	ff 75 08             	pushl  0x8(%ebp)
  80154c:	6a 13                	push   $0x13
  80154e:	e8 7f fc ff ff       	call   8011d2 <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
	return ;
  801556:	90                   	nop
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <sys_rcr2>:
uint32 sys_rcr2()
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 1e                	push   $0x1e
  801568:	e8 65 fc ff ff       	call   8011d2 <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	83 ec 04             	sub    $0x4,%esp
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80157e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	50                   	push   %eax
  80158b:	6a 1f                	push   $0x1f
  80158d:	e8 40 fc ff ff       	call   8011d2 <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
	return ;
  801595:	90                   	nop
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <rsttst>:
void rsttst()
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 21                	push   $0x21
  8015a7:	e8 26 fc ff ff       	call   8011d2 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8015af:	90                   	nop
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 04             	sub    $0x4,%esp
  8015b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015be:	8b 55 18             	mov    0x18(%ebp),%edx
  8015c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015c5:	52                   	push   %edx
  8015c6:	50                   	push   %eax
  8015c7:	ff 75 10             	pushl  0x10(%ebp)
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	6a 20                	push   $0x20
  8015d2:	e8 fb fb ff ff       	call   8011d2 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8015da:	90                   	nop
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <chktst>:
void chktst(uint32 n)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	ff 75 08             	pushl  0x8(%ebp)
  8015eb:	6a 22                	push   $0x22
  8015ed:	e8 e0 fb ff ff       	call   8011d2 <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f5:	90                   	nop
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <inctst>:

void inctst()
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 23                	push   $0x23
  801607:	e8 c6 fb ff ff       	call   8011d2 <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
	return ;
  80160f:	90                   	nop
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <gettst>:
uint32 gettst()
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 24                	push   $0x24
  801621:	e8 ac fb ff ff       	call   8011d2 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 25                	push   $0x25
  80163a:	e8 93 fb ff ff       	call   8011d2 <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
  801642:	a3 60 a0 81 00       	mov    %eax,0x81a060
	return uheapPlaceStrategy ;
  801647:	a1 60 a0 81 00       	mov    0x81a060,%eax
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	a3 60 a0 81 00       	mov    %eax,0x81a060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	ff 75 08             	pushl  0x8(%ebp)
  801664:	6a 26                	push   $0x26
  801666:	e8 67 fb ff ff       	call   8011d2 <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
	return ;
  80166e:	90                   	nop
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801675:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801678:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	6a 00                	push   $0x0
  801683:	53                   	push   %ebx
  801684:	51                   	push   %ecx
  801685:	52                   	push   %edx
  801686:	50                   	push   %eax
  801687:	6a 27                	push   $0x27
  801689:	e8 44 fb ff ff       	call   8011d2 <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	52                   	push   %edx
  8016a6:	50                   	push   %eax
  8016a7:	6a 28                	push   $0x28
  8016a9:	e8 24 fb ff ff       	call   8011d2 <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016b6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	6a 00                	push   $0x0
  8016c1:	51                   	push   %ecx
  8016c2:	ff 75 10             	pushl  0x10(%ebp)
  8016c5:	52                   	push   %edx
  8016c6:	50                   	push   %eax
  8016c7:	6a 29                	push   $0x29
  8016c9:	e8 04 fb ff ff       	call   8011d2 <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	ff 75 10             	pushl  0x10(%ebp)
  8016dd:	ff 75 0c             	pushl  0xc(%ebp)
  8016e0:	ff 75 08             	pushl  0x8(%ebp)
  8016e3:	6a 12                	push   $0x12
  8016e5:	e8 e8 fa ff ff       	call   8011d2 <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ed:	90                   	nop
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8016f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	52                   	push   %edx
  801700:	50                   	push   %eax
  801701:	6a 2a                	push   $0x2a
  801703:	e8 ca fa ff ff       	call   8011d2 <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
	return;
  80170b:	90                   	nop
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 2b                	push   $0x2b
  80171d:	e8 b0 fa ff ff       	call   8011d2 <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	ff 75 0c             	pushl  0xc(%ebp)
  801733:	ff 75 08             	pushl  0x8(%ebp)
  801736:	6a 2d                	push   $0x2d
  801738:	e8 95 fa ff ff       	call   8011d2 <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
	return;
  801740:	90                   	nop
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	ff 75 0c             	pushl  0xc(%ebp)
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	6a 2c                	push   $0x2c
  801754:	e8 79 fa ff ff       	call   8011d2 <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
	return ;
  80175c:	90                   	nop
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801762:	8b 55 0c             	mov    0xc(%ebp),%edx
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	52                   	push   %edx
  80176f:	50                   	push   %eax
  801770:	6a 2e                	push   $0x2e
  801772:	e8 5b fa ff ff       	call   8011d2 <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
	    return;
  80177a:	90                   	nop
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    
  80177d:	66 90                	xchg   %ax,%ax
  80177f:	90                   	nop

00801780 <__udivdi3>:
  801780:	55                   	push   %ebp
  801781:	57                   	push   %edi
  801782:	56                   	push   %esi
  801783:	53                   	push   %ebx
  801784:	83 ec 1c             	sub    $0x1c,%esp
  801787:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80178b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80178f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801793:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801797:	89 ca                	mov    %ecx,%edx
  801799:	89 f8                	mov    %edi,%eax
  80179b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80179f:	85 f6                	test   %esi,%esi
  8017a1:	75 2d                	jne    8017d0 <__udivdi3+0x50>
  8017a3:	39 cf                	cmp    %ecx,%edi
  8017a5:	77 65                	ja     80180c <__udivdi3+0x8c>
  8017a7:	89 fd                	mov    %edi,%ebp
  8017a9:	85 ff                	test   %edi,%edi
  8017ab:	75 0b                	jne    8017b8 <__udivdi3+0x38>
  8017ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b2:	31 d2                	xor    %edx,%edx
  8017b4:	f7 f7                	div    %edi
  8017b6:	89 c5                	mov    %eax,%ebp
  8017b8:	31 d2                	xor    %edx,%edx
  8017ba:	89 c8                	mov    %ecx,%eax
  8017bc:	f7 f5                	div    %ebp
  8017be:	89 c1                	mov    %eax,%ecx
  8017c0:	89 d8                	mov    %ebx,%eax
  8017c2:	f7 f5                	div    %ebp
  8017c4:	89 cf                	mov    %ecx,%edi
  8017c6:	89 fa                	mov    %edi,%edx
  8017c8:	83 c4 1c             	add    $0x1c,%esp
  8017cb:	5b                   	pop    %ebx
  8017cc:	5e                   	pop    %esi
  8017cd:	5f                   	pop    %edi
  8017ce:	5d                   	pop    %ebp
  8017cf:	c3                   	ret    
  8017d0:	39 ce                	cmp    %ecx,%esi
  8017d2:	77 28                	ja     8017fc <__udivdi3+0x7c>
  8017d4:	0f bd fe             	bsr    %esi,%edi
  8017d7:	83 f7 1f             	xor    $0x1f,%edi
  8017da:	75 40                	jne    80181c <__udivdi3+0x9c>
  8017dc:	39 ce                	cmp    %ecx,%esi
  8017de:	72 0a                	jb     8017ea <__udivdi3+0x6a>
  8017e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017e4:	0f 87 9e 00 00 00    	ja     801888 <__udivdi3+0x108>
  8017ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ef:	89 fa                	mov    %edi,%edx
  8017f1:	83 c4 1c             	add    $0x1c,%esp
  8017f4:	5b                   	pop    %ebx
  8017f5:	5e                   	pop    %esi
  8017f6:	5f                   	pop    %edi
  8017f7:	5d                   	pop    %ebp
  8017f8:	c3                   	ret    
  8017f9:	8d 76 00             	lea    0x0(%esi),%esi
  8017fc:	31 ff                	xor    %edi,%edi
  8017fe:	31 c0                	xor    %eax,%eax
  801800:	89 fa                	mov    %edi,%edx
  801802:	83 c4 1c             	add    $0x1c,%esp
  801805:	5b                   	pop    %ebx
  801806:	5e                   	pop    %esi
  801807:	5f                   	pop    %edi
  801808:	5d                   	pop    %ebp
  801809:	c3                   	ret    
  80180a:	66 90                	xchg   %ax,%ax
  80180c:	89 d8                	mov    %ebx,%eax
  80180e:	f7 f7                	div    %edi
  801810:	31 ff                	xor    %edi,%edi
  801812:	89 fa                	mov    %edi,%edx
  801814:	83 c4 1c             	add    $0x1c,%esp
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5f                   	pop    %edi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    
  80181c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801821:	89 eb                	mov    %ebp,%ebx
  801823:	29 fb                	sub    %edi,%ebx
  801825:	89 f9                	mov    %edi,%ecx
  801827:	d3 e6                	shl    %cl,%esi
  801829:	89 c5                	mov    %eax,%ebp
  80182b:	88 d9                	mov    %bl,%cl
  80182d:	d3 ed                	shr    %cl,%ebp
  80182f:	89 e9                	mov    %ebp,%ecx
  801831:	09 f1                	or     %esi,%ecx
  801833:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801837:	89 f9                	mov    %edi,%ecx
  801839:	d3 e0                	shl    %cl,%eax
  80183b:	89 c5                	mov    %eax,%ebp
  80183d:	89 d6                	mov    %edx,%esi
  80183f:	88 d9                	mov    %bl,%cl
  801841:	d3 ee                	shr    %cl,%esi
  801843:	89 f9                	mov    %edi,%ecx
  801845:	d3 e2                	shl    %cl,%edx
  801847:	8b 44 24 08          	mov    0x8(%esp),%eax
  80184b:	88 d9                	mov    %bl,%cl
  80184d:	d3 e8                	shr    %cl,%eax
  80184f:	09 c2                	or     %eax,%edx
  801851:	89 d0                	mov    %edx,%eax
  801853:	89 f2                	mov    %esi,%edx
  801855:	f7 74 24 0c          	divl   0xc(%esp)
  801859:	89 d6                	mov    %edx,%esi
  80185b:	89 c3                	mov    %eax,%ebx
  80185d:	f7 e5                	mul    %ebp
  80185f:	39 d6                	cmp    %edx,%esi
  801861:	72 19                	jb     80187c <__udivdi3+0xfc>
  801863:	74 0b                	je     801870 <__udivdi3+0xf0>
  801865:	89 d8                	mov    %ebx,%eax
  801867:	31 ff                	xor    %edi,%edi
  801869:	e9 58 ff ff ff       	jmp    8017c6 <__udivdi3+0x46>
  80186e:	66 90                	xchg   %ax,%ax
  801870:	8b 54 24 08          	mov    0x8(%esp),%edx
  801874:	89 f9                	mov    %edi,%ecx
  801876:	d3 e2                	shl    %cl,%edx
  801878:	39 c2                	cmp    %eax,%edx
  80187a:	73 e9                	jae    801865 <__udivdi3+0xe5>
  80187c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80187f:	31 ff                	xor    %edi,%edi
  801881:	e9 40 ff ff ff       	jmp    8017c6 <__udivdi3+0x46>
  801886:	66 90                	xchg   %ax,%ax
  801888:	31 c0                	xor    %eax,%eax
  80188a:	e9 37 ff ff ff       	jmp    8017c6 <__udivdi3+0x46>
  80188f:	90                   	nop

00801890 <__umoddi3>:
  801890:	55                   	push   %ebp
  801891:	57                   	push   %edi
  801892:	56                   	push   %esi
  801893:	53                   	push   %ebx
  801894:	83 ec 1c             	sub    $0x1c,%esp
  801897:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80189b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80189f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8018a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018af:	89 f3                	mov    %esi,%ebx
  8018b1:	89 fa                	mov    %edi,%edx
  8018b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018b7:	89 34 24             	mov    %esi,(%esp)
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	75 1a                	jne    8018d8 <__umoddi3+0x48>
  8018be:	39 f7                	cmp    %esi,%edi
  8018c0:	0f 86 a2 00 00 00    	jbe    801968 <__umoddi3+0xd8>
  8018c6:	89 c8                	mov    %ecx,%eax
  8018c8:	89 f2                	mov    %esi,%edx
  8018ca:	f7 f7                	div    %edi
  8018cc:	89 d0                	mov    %edx,%eax
  8018ce:	31 d2                	xor    %edx,%edx
  8018d0:	83 c4 1c             	add    $0x1c,%esp
  8018d3:	5b                   	pop    %ebx
  8018d4:	5e                   	pop    %esi
  8018d5:	5f                   	pop    %edi
  8018d6:	5d                   	pop    %ebp
  8018d7:	c3                   	ret    
  8018d8:	39 f0                	cmp    %esi,%eax
  8018da:	0f 87 ac 00 00 00    	ja     80198c <__umoddi3+0xfc>
  8018e0:	0f bd e8             	bsr    %eax,%ebp
  8018e3:	83 f5 1f             	xor    $0x1f,%ebp
  8018e6:	0f 84 ac 00 00 00    	je     801998 <__umoddi3+0x108>
  8018ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8018f1:	29 ef                	sub    %ebp,%edi
  8018f3:	89 fe                	mov    %edi,%esi
  8018f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018f9:	89 e9                	mov    %ebp,%ecx
  8018fb:	d3 e0                	shl    %cl,%eax
  8018fd:	89 d7                	mov    %edx,%edi
  8018ff:	89 f1                	mov    %esi,%ecx
  801901:	d3 ef                	shr    %cl,%edi
  801903:	09 c7                	or     %eax,%edi
  801905:	89 e9                	mov    %ebp,%ecx
  801907:	d3 e2                	shl    %cl,%edx
  801909:	89 14 24             	mov    %edx,(%esp)
  80190c:	89 d8                	mov    %ebx,%eax
  80190e:	d3 e0                	shl    %cl,%eax
  801910:	89 c2                	mov    %eax,%edx
  801912:	8b 44 24 08          	mov    0x8(%esp),%eax
  801916:	d3 e0                	shl    %cl,%eax
  801918:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801920:	89 f1                	mov    %esi,%ecx
  801922:	d3 e8                	shr    %cl,%eax
  801924:	09 d0                	or     %edx,%eax
  801926:	d3 eb                	shr    %cl,%ebx
  801928:	89 da                	mov    %ebx,%edx
  80192a:	f7 f7                	div    %edi
  80192c:	89 d3                	mov    %edx,%ebx
  80192e:	f7 24 24             	mull   (%esp)
  801931:	89 c6                	mov    %eax,%esi
  801933:	89 d1                	mov    %edx,%ecx
  801935:	39 d3                	cmp    %edx,%ebx
  801937:	0f 82 87 00 00 00    	jb     8019c4 <__umoddi3+0x134>
  80193d:	0f 84 91 00 00 00    	je     8019d4 <__umoddi3+0x144>
  801943:	8b 54 24 04          	mov    0x4(%esp),%edx
  801947:	29 f2                	sub    %esi,%edx
  801949:	19 cb                	sbb    %ecx,%ebx
  80194b:	89 d8                	mov    %ebx,%eax
  80194d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801951:	d3 e0                	shl    %cl,%eax
  801953:	89 e9                	mov    %ebp,%ecx
  801955:	d3 ea                	shr    %cl,%edx
  801957:	09 d0                	or     %edx,%eax
  801959:	89 e9                	mov    %ebp,%ecx
  80195b:	d3 eb                	shr    %cl,%ebx
  80195d:	89 da                	mov    %ebx,%edx
  80195f:	83 c4 1c             	add    $0x1c,%esp
  801962:	5b                   	pop    %ebx
  801963:	5e                   	pop    %esi
  801964:	5f                   	pop    %edi
  801965:	5d                   	pop    %ebp
  801966:	c3                   	ret    
  801967:	90                   	nop
  801968:	89 fd                	mov    %edi,%ebp
  80196a:	85 ff                	test   %edi,%edi
  80196c:	75 0b                	jne    801979 <__umoddi3+0xe9>
  80196e:	b8 01 00 00 00       	mov    $0x1,%eax
  801973:	31 d2                	xor    %edx,%edx
  801975:	f7 f7                	div    %edi
  801977:	89 c5                	mov    %eax,%ebp
  801979:	89 f0                	mov    %esi,%eax
  80197b:	31 d2                	xor    %edx,%edx
  80197d:	f7 f5                	div    %ebp
  80197f:	89 c8                	mov    %ecx,%eax
  801981:	f7 f5                	div    %ebp
  801983:	89 d0                	mov    %edx,%eax
  801985:	e9 44 ff ff ff       	jmp    8018ce <__umoddi3+0x3e>
  80198a:	66 90                	xchg   %ax,%ax
  80198c:	89 c8                	mov    %ecx,%eax
  80198e:	89 f2                	mov    %esi,%edx
  801990:	83 c4 1c             	add    $0x1c,%esp
  801993:	5b                   	pop    %ebx
  801994:	5e                   	pop    %esi
  801995:	5f                   	pop    %edi
  801996:	5d                   	pop    %ebp
  801997:	c3                   	ret    
  801998:	3b 04 24             	cmp    (%esp),%eax
  80199b:	72 06                	jb     8019a3 <__umoddi3+0x113>
  80199d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8019a1:	77 0f                	ja     8019b2 <__umoddi3+0x122>
  8019a3:	89 f2                	mov    %esi,%edx
  8019a5:	29 f9                	sub    %edi,%ecx
  8019a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8019ab:	89 14 24             	mov    %edx,(%esp)
  8019ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8019b6:	8b 14 24             	mov    (%esp),%edx
  8019b9:	83 c4 1c             	add    $0x1c,%esp
  8019bc:	5b                   	pop    %ebx
  8019bd:	5e                   	pop    %esi
  8019be:	5f                   	pop    %edi
  8019bf:	5d                   	pop    %ebp
  8019c0:	c3                   	ret    
  8019c1:	8d 76 00             	lea    0x0(%esi),%esi
  8019c4:	2b 04 24             	sub    (%esp),%eax
  8019c7:	19 fa                	sbb    %edi,%edx
  8019c9:	89 d1                	mov    %edx,%ecx
  8019cb:	89 c6                	mov    %eax,%esi
  8019cd:	e9 71 ff ff ff       	jmp    801943 <__umoddi3+0xb3>
  8019d2:	66 90                	xchg   %ax,%ax
  8019d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019d8:	72 ea                	jb     8019c4 <__umoddi3+0x134>
  8019da:	89 d9                	mov    %ebx,%ecx
  8019dc:	e9 62 ff ff ff       	jmp    801943 <__umoddi3+0xb3>
