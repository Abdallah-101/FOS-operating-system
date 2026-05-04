
obj/user/fos_static_data_section:     file format elf32-i386


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
  800031:	e8 1b 00 00 00       	call   800051 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

/// Adding array of 20000 integer on user data section
int arr[20000];

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	atomic_cprintf("user data section contains 20,000 integer\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 e0 19 80 00       	push   $0x8019e0
  800046:	e8 11 03 00 00       	call   80035c <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	
	return;	
  80004e:	90                   	nop
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	57                   	push   %edi
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005a:	e8 58 14 00 00       	call   8014b7 <sys_getenvindex>
  80005f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800062:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800065:	89 d0                	mov    %edx,%eax
  800067:	c1 e0 02             	shl    $0x2,%eax
  80006a:	01 d0                	add    %edx,%eax
  80006c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800073:	01 d0                	add    %edx,%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	c1 e2 04             	shl    $0x4,%edx
  80007a:	29 c2                	sub    %eax,%edx
  80007c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800083:	89 c2                	mov    %eax,%edx
  800085:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80008b:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800090:	a1 20 20 80 00       	mov    0x802020,%eax
  800095:	8a 40 20             	mov    0x20(%eax),%al
  800098:	84 c0                	test   %al,%al
  80009a:	74 0d                	je     8000a9 <libmain+0x58>
		binaryname = myEnv->prog_name;
  80009c:	a1 20 20 80 00       	mov    0x802020,%eax
  8000a1:	83 c0 20             	add    $0x20,%eax
  8000a4:	a3 04 20 80 00       	mov    %eax,0x802004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ad:	7e 0a                	jle    8000b9 <libmain+0x68>
		binaryname = argv[0];
  8000af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b2:	8b 00                	mov    (%eax),%eax
  8000b4:	a3 04 20 80 00       	mov    %eax,0x802004

	// call user main routine
	_main(argc, argv);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 0c             	pushl  0xc(%ebp)
  8000bf:	ff 75 08             	pushl  0x8(%ebp)
  8000c2:	e8 71 ff ff ff       	call   800038 <_main>
  8000c7:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000ca:	a1 00 20 80 00       	mov    0x802000,%eax
  8000cf:	85 c0                	test   %eax,%eax
  8000d1:	0f 84 01 01 00 00    	je     8001d8 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000d7:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000dd:	bb 04 1b 80 00       	mov    $0x801b04,%ebx
  8000e2:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000e7:	89 c7                	mov    %eax,%edi
  8000e9:	89 de                	mov    %ebx,%esi
  8000eb:	89 d1                	mov    %edx,%ecx
  8000ed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000ef:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000f2:	b9 56 00 00 00       	mov    $0x56,%ecx
  8000f7:	b0 00                	mov    $0x0,%al
  8000f9:	89 d7                	mov    %edx,%edi
  8000fb:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8000fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800104:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	50                   	push   %eax
  80010b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800111:	50                   	push   %eax
  800112:	e8 d6 15 00 00       	call   8016ed <sys_utilities>
  800117:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80011a:	e8 1f 11 00 00       	call   80123e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 24 1a 80 00       	push   $0x801a24
  800127:	e8 be 01 00 00       	call   8002ea <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80012f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800132:	85 c0                	test   %eax,%eax
  800134:	74 18                	je     80014e <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800136:	e8 d0 15 00 00       	call   80170b <sys_get_optimal_num_faults>
  80013b:	83 ec 08             	sub    $0x8,%esp
  80013e:	50                   	push   %eax
  80013f:	68 4c 1a 80 00       	push   $0x801a4c
  800144:	e8 a1 01 00 00       	call   8002ea <cprintf>
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	eb 59                	jmp    8001a7 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80014e:	a1 20 20 80 00       	mov    0x802020,%eax
  800153:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800159:	a1 20 20 80 00       	mov    0x802020,%eax
  80015e:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800164:	83 ec 04             	sub    $0x4,%esp
  800167:	52                   	push   %edx
  800168:	50                   	push   %eax
  800169:	68 70 1a 80 00       	push   $0x801a70
  80016e:	e8 77 01 00 00       	call   8002ea <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800176:	a1 20 20 80 00       	mov    0x802020,%eax
  80017b:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800181:	a1 20 20 80 00       	mov    0x802020,%eax
  800186:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80018c:	a1 20 20 80 00       	mov    0x802020,%eax
  800191:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800197:	51                   	push   %ecx
  800198:	52                   	push   %edx
  800199:	50                   	push   %eax
  80019a:	68 98 1a 80 00       	push   $0x801a98
  80019f:	e8 46 01 00 00       	call   8002ea <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001a7:	a1 20 20 80 00       	mov    0x802020,%eax
  8001ac:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8001b2:	83 ec 08             	sub    $0x8,%esp
  8001b5:	50                   	push   %eax
  8001b6:	68 f0 1a 80 00       	push   $0x801af0
  8001bb:	e8 2a 01 00 00       	call   8002ea <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001c3:	83 ec 0c             	sub    $0xc,%esp
  8001c6:	68 24 1a 80 00       	push   $0x801a24
  8001cb:	e8 1a 01 00 00       	call   8002ea <cprintf>
  8001d0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001d3:	e8 80 10 00 00       	call   801258 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001d8:	e8 1f 00 00 00       	call   8001fc <exit>
}
  8001dd:	90                   	nop
  8001de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e1:	5b                   	pop    %ebx
  8001e2:	5e                   	pop    %esi
  8001e3:	5f                   	pop    %edi
  8001e4:	5d                   	pop    %ebp
  8001e5:	c3                   	ret    

008001e6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	6a 00                	push   $0x0
  8001f1:	e8 8d 12 00 00       	call   801483 <sys_destroy_env>
  8001f6:	83 c4 10             	add    $0x10,%esp
}
  8001f9:	90                   	nop
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <exit>:

void
exit(void)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800202:	e8 e2 12 00 00       	call   8014e9 <sys_exit_env>
}
  800207:	90                   	nop
  800208:	c9                   	leave  
  800209:	c3                   	ret    

0080020a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80020a:	55                   	push   %ebp
  80020b:	89 e5                	mov    %esp,%ebp
  80020d:	53                   	push   %ebx
  80020e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800211:	8b 45 0c             	mov    0xc(%ebp),%eax
  800214:	8b 00                	mov    (%eax),%eax
  800216:	8d 48 01             	lea    0x1(%eax),%ecx
  800219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021c:	89 0a                	mov    %ecx,(%edx)
  80021e:	8b 55 08             	mov    0x8(%ebp),%edx
  800221:	88 d1                	mov    %dl,%cl
  800223:	8b 55 0c             	mov    0xc(%ebp),%edx
  800226:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80022a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022d:	8b 00                	mov    (%eax),%eax
  80022f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800234:	75 30                	jne    800266 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800236:	8b 15 b8 d9 82 00    	mov    0x82d9b8,%edx
  80023c:	a0 e0 58 81 00       	mov    0x8158e0,%al
  800241:	0f b6 c0             	movzbl %al,%eax
  800244:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800247:	8b 09                	mov    (%ecx),%ecx
  800249:	89 cb                	mov    %ecx,%ebx
  80024b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80024e:	83 c1 08             	add    $0x8,%ecx
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	53                   	push   %ebx
  800254:	51                   	push   %ecx
  800255:	e8 a0 0f 00 00       	call   8011fa <sys_cputs>
  80025a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800266:	8b 45 0c             	mov    0xc(%ebp),%eax
  800269:	8b 40 04             	mov    0x4(%eax),%eax
  80026c:	8d 50 01             	lea    0x1(%eax),%edx
  80026f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800272:	89 50 04             	mov    %edx,0x4(%eax)
}
  800275:	90                   	nop
  800276:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800284:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80028b:	00 00 00 
	b.cnt = 0;
  80028e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800295:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800298:	ff 75 0c             	pushl  0xc(%ebp)
  80029b:	ff 75 08             	pushl  0x8(%ebp)
  80029e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a4:	50                   	push   %eax
  8002a5:	68 0a 02 80 00       	push   $0x80020a
  8002aa:	e8 5a 02 00 00       	call   800509 <vprintfmt>
  8002af:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002b2:	8b 15 b8 d9 82 00    	mov    0x82d9b8,%edx
  8002b8:	a0 e0 58 81 00       	mov    0x8158e0,%al
  8002bd:	0f b6 c0             	movzbl %al,%eax
  8002c0:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8002c6:	52                   	push   %edx
  8002c7:	50                   	push   %eax
  8002c8:	51                   	push   %ecx
  8002c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002cf:	83 c0 08             	add    $0x8,%eax
  8002d2:	50                   	push   %eax
  8002d3:	e8 22 0f 00 00       	call   8011fa <sys_cputs>
  8002d8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002db:	c6 05 e0 58 81 00 00 	movb   $0x0,0x8158e0
	return b.cnt;
  8002e2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002e8:	c9                   	leave  
  8002e9:	c3                   	ret    

008002ea <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002f0:	c6 05 e0 58 81 00 01 	movb   $0x1,0x8158e0
	va_start(ap, fmt);
  8002f7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 f4             	pushl  -0xc(%ebp)
  800306:	50                   	push   %eax
  800307:	e8 6f ff ff ff       	call   80027b <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800315:	c9                   	leave  
  800316:	c3                   	ret    

00800317 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80031d:	c6 05 e0 58 81 00 01 	movb   $0x1,0x8158e0
	curTextClr = (textClr << 8) ; //set text color by the given value
  800324:	8b 45 08             	mov    0x8(%ebp),%eax
  800327:	c1 e0 08             	shl    $0x8,%eax
  80032a:	a3 b8 d9 82 00       	mov    %eax,0x82d9b8
	va_start(ap, fmt);
  80032f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800332:	83 c0 04             	add    $0x4,%eax
  800335:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800338:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	ff 75 f4             	pushl  -0xc(%ebp)
  800341:	50                   	push   %eax
  800342:	e8 34 ff ff ff       	call   80027b <vcprintf>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80034d:	c7 05 b8 d9 82 00 00 	movl   $0x700,0x82d9b8
  800354:	07 00 00 

	return cnt;
  800357:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800362:	e8 d7 0e 00 00       	call   80123e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800367:	8d 45 0c             	lea    0xc(%ebp),%eax
  80036a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	ff 75 f4             	pushl  -0xc(%ebp)
  800376:	50                   	push   %eax
  800377:	e8 ff fe ff ff       	call   80027b <vcprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800382:	e8 d1 0e 00 00       	call   801258 <sys_unlock_cons>
	return cnt;
  800387:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	53                   	push   %ebx
  800390:	83 ec 14             	sub    $0x14,%esp
  800393:	8b 45 10             	mov    0x10(%ebp),%eax
  800396:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800399:	8b 45 14             	mov    0x14(%ebp),%eax
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80039f:	8b 45 18             	mov    0x18(%ebp),%eax
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003aa:	77 55                	ja     800401 <printnum+0x75>
  8003ac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003af:	72 05                	jb     8003b6 <printnum+0x2a>
  8003b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b4:	77 4b                	ja     800401 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003b9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003bc:	8b 45 18             	mov    0x18(%ebp),%eax
  8003bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c4:	52                   	push   %edx
  8003c5:	50                   	push   %eax
  8003c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8003cc:	e8 ab 13 00 00       	call   80177c <__udivdi3>
  8003d1:	83 c4 10             	add    $0x10,%esp
  8003d4:	83 ec 04             	sub    $0x4,%esp
  8003d7:	ff 75 20             	pushl  0x20(%ebp)
  8003da:	53                   	push   %ebx
  8003db:	ff 75 18             	pushl  0x18(%ebp)
  8003de:	52                   	push   %edx
  8003df:	50                   	push   %eax
  8003e0:	ff 75 0c             	pushl  0xc(%ebp)
  8003e3:	ff 75 08             	pushl  0x8(%ebp)
  8003e6:	e8 a1 ff ff ff       	call   80038c <printnum>
  8003eb:	83 c4 20             	add    $0x20,%esp
  8003ee:	eb 1a                	jmp    80040a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003f0:	83 ec 08             	sub    $0x8,%esp
  8003f3:	ff 75 0c             	pushl  0xc(%ebp)
  8003f6:	ff 75 20             	pushl  0x20(%ebp)
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	ff d0                	call   *%eax
  8003fe:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800401:	ff 4d 1c             	decl   0x1c(%ebp)
  800404:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800408:	7f e6                	jg     8003f0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80040a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80040d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800415:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800418:	53                   	push   %ebx
  800419:	51                   	push   %ecx
  80041a:	52                   	push   %edx
  80041b:	50                   	push   %eax
  80041c:	e8 6b 14 00 00       	call   80188c <__umoddi3>
  800421:	83 c4 10             	add    $0x10,%esp
  800424:	05 94 1d 80 00       	add    $0x801d94,%eax
  800429:	8a 00                	mov    (%eax),%al
  80042b:	0f be c0             	movsbl %al,%eax
  80042e:	83 ec 08             	sub    $0x8,%esp
  800431:	ff 75 0c             	pushl  0xc(%ebp)
  800434:	50                   	push   %eax
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	ff d0                	call   *%eax
  80043a:	83 c4 10             	add    $0x10,%esp
}
  80043d:	90                   	nop
  80043e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800446:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80044a:	7e 1c                	jle    800468 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	8d 50 08             	lea    0x8(%eax),%edx
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	89 10                	mov    %edx,(%eax)
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	83 e8 08             	sub    $0x8,%eax
  800461:	8b 50 04             	mov    0x4(%eax),%edx
  800464:	8b 00                	mov    (%eax),%eax
  800466:	eb 40                	jmp    8004a8 <getuint+0x65>
	else if (lflag)
  800468:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80046c:	74 1e                	je     80048c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	8d 50 04             	lea    0x4(%eax),%edx
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	89 10                	mov    %edx,(%eax)
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	83 e8 04             	sub    $0x4,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	ba 00 00 00 00       	mov    $0x0,%edx
  80048a:	eb 1c                	jmp    8004a8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	8d 50 04             	lea    0x4(%eax),%edx
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	89 10                	mov    %edx,(%eax)
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	83 e8 04             	sub    $0x4,%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004a8:	5d                   	pop    %ebp
  8004a9:	c3                   	ret    

008004aa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ad:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004b1:	7e 1c                	jle    8004cf <getint+0x25>
		return va_arg(*ap, long long);
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	8d 50 08             	lea    0x8(%eax),%edx
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	89 10                	mov    %edx,(%eax)
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	83 e8 08             	sub    $0x8,%eax
  8004c8:	8b 50 04             	mov    0x4(%eax),%edx
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	eb 38                	jmp    800507 <getint+0x5d>
	else if (lflag)
  8004cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d3:	74 1a                	je     8004ef <getint+0x45>
		return va_arg(*ap, long);
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	8d 50 04             	lea    0x4(%eax),%edx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	89 10                	mov    %edx,(%eax)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	83 e8 04             	sub    $0x4,%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	99                   	cltd   
  8004ed:	eb 18                	jmp    800507 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	8d 50 04             	lea    0x4(%eax),%edx
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	89 10                	mov    %edx,(%eax)
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	83 e8 04             	sub    $0x4,%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	99                   	cltd   
}
  800507:	5d                   	pop    %ebp
  800508:	c3                   	ret    

00800509 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	56                   	push   %esi
  80050d:	53                   	push   %ebx
  80050e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800511:	eb 17                	jmp    80052a <vprintfmt+0x21>
			if (ch == '\0')
  800513:	85 db                	test   %ebx,%ebx
  800515:	0f 84 c1 03 00 00    	je     8008dc <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	ff 75 0c             	pushl  0xc(%ebp)
  800521:	53                   	push   %ebx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	ff d0                	call   *%eax
  800527:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052a:	8b 45 10             	mov    0x10(%ebp),%eax
  80052d:	8d 50 01             	lea    0x1(%eax),%edx
  800530:	89 55 10             	mov    %edx,0x10(%ebp)
  800533:	8a 00                	mov    (%eax),%al
  800535:	0f b6 d8             	movzbl %al,%ebx
  800538:	83 fb 25             	cmp    $0x25,%ebx
  80053b:	75 d6                	jne    800513 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80053d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800541:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800548:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80054f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800556:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055d:	8b 45 10             	mov    0x10(%ebp),%eax
  800560:	8d 50 01             	lea    0x1(%eax),%edx
  800563:	89 55 10             	mov    %edx,0x10(%ebp)
  800566:	8a 00                	mov    (%eax),%al
  800568:	0f b6 d8             	movzbl %al,%ebx
  80056b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80056e:	83 f8 5b             	cmp    $0x5b,%eax
  800571:	0f 87 3d 03 00 00    	ja     8008b4 <vprintfmt+0x3ab>
  800577:	8b 04 85 b8 1d 80 00 	mov    0x801db8(,%eax,4),%eax
  80057e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800580:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800584:	eb d7                	jmp    80055d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800586:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80058a:	eb d1                	jmp    80055d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80058c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800593:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	c1 e0 02             	shl    $0x2,%eax
  80059b:	01 d0                	add    %edx,%eax
  80059d:	01 c0                	add    %eax,%eax
  80059f:	01 d8                	add    %ebx,%eax
  8005a1:	83 e8 30             	sub    $0x30,%eax
  8005a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005aa:	8a 00                	mov    (%eax),%al
  8005ac:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005af:	83 fb 2f             	cmp    $0x2f,%ebx
  8005b2:	7e 3e                	jle    8005f2 <vprintfmt+0xe9>
  8005b4:	83 fb 39             	cmp    $0x39,%ebx
  8005b7:	7f 39                	jg     8005f2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005bc:	eb d5                	jmp    800593 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	83 c0 04             	add    $0x4,%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	83 e8 04             	sub    $0x4,%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005d2:	eb 1f                	jmp    8005f3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005d8:	79 83                	jns    80055d <vprintfmt+0x54>
				width = 0;
  8005da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005e1:	e9 77 ff ff ff       	jmp    80055d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005e6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005ed:	e9 6b ff ff ff       	jmp    80055d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005f2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f7:	0f 89 60 ff ff ff    	jns    80055d <vprintfmt+0x54>
				width = precision, precision = -1;
  8005fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800603:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80060a:	e9 4e ff ff ff       	jmp    80055d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80060f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800612:	e9 46 ff ff ff       	jmp    80055d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	83 c0 04             	add    $0x4,%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	83 e8 04             	sub    $0x4,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	ff 75 0c             	pushl  0xc(%ebp)
  80062e:	50                   	push   %eax
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	ff d0                	call   *%eax
  800634:	83 c4 10             	add    $0x10,%esp
			break;
  800637:	e9 9b 02 00 00       	jmp    8008d7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	83 c0 04             	add    $0x4,%eax
  800642:	89 45 14             	mov    %eax,0x14(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	83 e8 04             	sub    $0x4,%eax
  80064b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80064d:	85 db                	test   %ebx,%ebx
  80064f:	79 02                	jns    800653 <vprintfmt+0x14a>
				err = -err;
  800651:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800653:	83 fb 64             	cmp    $0x64,%ebx
  800656:	7f 0b                	jg     800663 <vprintfmt+0x15a>
  800658:	8b 34 9d 00 1c 80 00 	mov    0x801c00(,%ebx,4),%esi
  80065f:	85 f6                	test   %esi,%esi
  800661:	75 19                	jne    80067c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800663:	53                   	push   %ebx
  800664:	68 a5 1d 80 00       	push   $0x801da5
  800669:	ff 75 0c             	pushl  0xc(%ebp)
  80066c:	ff 75 08             	pushl  0x8(%ebp)
  80066f:	e8 70 02 00 00       	call   8008e4 <printfmt>
  800674:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800677:	e9 5b 02 00 00       	jmp    8008d7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80067c:	56                   	push   %esi
  80067d:	68 ae 1d 80 00       	push   $0x801dae
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	ff 75 08             	pushl  0x8(%ebp)
  800688:	e8 57 02 00 00       	call   8008e4 <printfmt>
  80068d:	83 c4 10             	add    $0x10,%esp
			break;
  800690:	e9 42 02 00 00       	jmp    8008d7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	83 c0 04             	add    $0x4,%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	83 e8 04             	sub    $0x4,%eax
  8006a4:	8b 30                	mov    (%eax),%esi
  8006a6:	85 f6                	test   %esi,%esi
  8006a8:	75 05                	jne    8006af <vprintfmt+0x1a6>
				p = "(null)";
  8006aa:	be b1 1d 80 00       	mov    $0x801db1,%esi
			if (width > 0 && padc != '-')
  8006af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b3:	7e 6d                	jle    800722 <vprintfmt+0x219>
  8006b5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006b9:	74 67                	je     800722 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	50                   	push   %eax
  8006c2:	56                   	push   %esi
  8006c3:	e8 1e 03 00 00       	call   8009e6 <strnlen>
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006ce:	eb 16                	jmp    8006e6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006d0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	50                   	push   %eax
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	ff d0                	call   *%eax
  8006e0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e3:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ea:	7f e4                	jg     8006d0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ec:	eb 34                	jmp    800722 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f2:	74 1c                	je     800710 <vprintfmt+0x207>
  8006f4:	83 fb 1f             	cmp    $0x1f,%ebx
  8006f7:	7e 05                	jle    8006fe <vprintfmt+0x1f5>
  8006f9:	83 fb 7e             	cmp    $0x7e,%ebx
  8006fc:	7e 12                	jle    800710 <vprintfmt+0x207>
					putch('?', putdat);
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	ff 75 0c             	pushl  0xc(%ebp)
  800704:	6a 3f                	push   $0x3f
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	ff d0                	call   *%eax
  80070b:	83 c4 10             	add    $0x10,%esp
  80070e:	eb 0f                	jmp    80071f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	ff 75 0c             	pushl  0xc(%ebp)
  800716:	53                   	push   %ebx
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	ff d0                	call   *%eax
  80071c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80071f:	ff 4d e4             	decl   -0x1c(%ebp)
  800722:	89 f0                	mov    %esi,%eax
  800724:	8d 70 01             	lea    0x1(%eax),%esi
  800727:	8a 00                	mov    (%eax),%al
  800729:	0f be d8             	movsbl %al,%ebx
  80072c:	85 db                	test   %ebx,%ebx
  80072e:	74 24                	je     800754 <vprintfmt+0x24b>
  800730:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800734:	78 b8                	js     8006ee <vprintfmt+0x1e5>
  800736:	ff 4d e0             	decl   -0x20(%ebp)
  800739:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80073d:	79 af                	jns    8006ee <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80073f:	eb 13                	jmp    800754 <vprintfmt+0x24b>
				putch(' ', putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	6a 20                	push   $0x20
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	ff d0                	call   *%eax
  80074e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800751:	ff 4d e4             	decl   -0x1c(%ebp)
  800754:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800758:	7f e7                	jg     800741 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80075a:	e9 78 01 00 00       	jmp    8008d7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	ff 75 e8             	pushl  -0x18(%ebp)
  800765:	8d 45 14             	lea    0x14(%ebp),%eax
  800768:	50                   	push   %eax
  800769:	e8 3c fd ff ff       	call   8004aa <getint>
  80076e:	83 c4 10             	add    $0x10,%esp
  800771:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800774:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80077d:	85 d2                	test   %edx,%edx
  80077f:	79 23                	jns    8007a4 <vprintfmt+0x29b>
				putch('-', putdat);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 0c             	pushl  0xc(%ebp)
  800787:	6a 2d                	push   $0x2d
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	ff d0                	call   *%eax
  80078e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800794:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800797:	f7 d8                	neg    %eax
  800799:	83 d2 00             	adc    $0x0,%edx
  80079c:	f7 da                	neg    %edx
  80079e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007a4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007ab:	e9 bc 00 00 00       	jmp    80086c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b9:	50                   	push   %eax
  8007ba:	e8 84 fc ff ff       	call   800443 <getuint>
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007c8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007cf:	e9 98 00 00 00       	jmp    80086c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	6a 58                	push   $0x58
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ea:	6a 58                	push   $0x58
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	ff d0                	call   *%eax
  8007f1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	ff 75 0c             	pushl  0xc(%ebp)
  8007fa:	6a 58                	push   $0x58
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	ff d0                	call   *%eax
  800801:	83 c4 10             	add    $0x10,%esp
			break;
  800804:	e9 ce 00 00 00       	jmp    8008d7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	6a 30                	push   $0x30
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	ff 75 0c             	pushl  0xc(%ebp)
  80081f:	6a 78                	push   $0x78
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	ff d0                	call   *%eax
  800826:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	83 c0 04             	add    $0x4,%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 e8 04             	sub    $0x4,%eax
  800838:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80083a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80083d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800844:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80084b:	eb 1f                	jmp    80086c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 e8             	pushl  -0x18(%ebp)
  800853:	8d 45 14             	lea    0x14(%ebp),%eax
  800856:	50                   	push   %eax
  800857:	e8 e7 fb ff ff       	call   800443 <getuint>
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800862:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800865:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80086c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800870:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800873:	83 ec 04             	sub    $0x4,%esp
  800876:	52                   	push   %edx
  800877:	ff 75 e4             	pushl  -0x1c(%ebp)
  80087a:	50                   	push   %eax
  80087b:	ff 75 f4             	pushl  -0xc(%ebp)
  80087e:	ff 75 f0             	pushl  -0x10(%ebp)
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	ff 75 08             	pushl  0x8(%ebp)
  800887:	e8 00 fb ff ff       	call   80038c <printnum>
  80088c:	83 c4 20             	add    $0x20,%esp
			break;
  80088f:	eb 46                	jmp    8008d7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	53                   	push   %ebx
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	ff d0                	call   *%eax
  80089d:	83 c4 10             	add    $0x10,%esp
			break;
  8008a0:	eb 35                	jmp    8008d7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008a2:	c6 05 e0 58 81 00 00 	movb   $0x0,0x8158e0
			break;
  8008a9:	eb 2c                	jmp    8008d7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008ab:	c6 05 e0 58 81 00 01 	movb   $0x1,0x8158e0
			break;
  8008b2:	eb 23                	jmp    8008d7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	6a 25                	push   $0x25
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	ff d0                	call   *%eax
  8008c1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c4:	ff 4d 10             	decl   0x10(%ebp)
  8008c7:	eb 03                	jmp    8008cc <vprintfmt+0x3c3>
  8008c9:	ff 4d 10             	decl   0x10(%ebp)
  8008cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cf:	48                   	dec    %eax
  8008d0:	8a 00                	mov    (%eax),%al
  8008d2:	3c 25                	cmp    $0x25,%al
  8008d4:	75 f3                	jne    8008c9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008d6:	90                   	nop
		}
	}
  8008d7:	e9 35 fc ff ff       	jmp    800511 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008dc:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e0:	5b                   	pop    %ebx
  8008e1:	5e                   	pop    %esi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008ea:	8d 45 10             	lea    0x10(%ebp),%eax
  8008ed:	83 c0 04             	add    $0x4,%eax
  8008f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f9:	50                   	push   %eax
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	ff 75 08             	pushl  0x8(%ebp)
  800900:	e8 04 fc ff ff       	call   800509 <vprintfmt>
  800905:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800908:	90                   	nop
  800909:	c9                   	leave  
  80090a:	c3                   	ret    

0080090b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80090e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800911:	8b 40 08             	mov    0x8(%eax),%eax
  800914:	8d 50 01             	lea    0x1(%eax),%edx
  800917:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8b 10                	mov    (%eax),%edx
  800922:	8b 45 0c             	mov    0xc(%ebp),%eax
  800925:	8b 40 04             	mov    0x4(%eax),%eax
  800928:	39 c2                	cmp    %eax,%edx
  80092a:	73 12                	jae    80093e <sprintputch+0x33>
		*b->buf++ = ch;
  80092c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	8d 48 01             	lea    0x1(%eax),%ecx
  800934:	8b 55 0c             	mov    0xc(%ebp),%edx
  800937:	89 0a                	mov    %ecx,(%edx)
  800939:	8b 55 08             	mov    0x8(%ebp),%edx
  80093c:	88 10                	mov    %dl,(%eax)
}
  80093e:	90                   	nop
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80094d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800950:	8d 50 ff             	lea    -0x1(%eax),%edx
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	01 d0                	add    %edx,%eax
  800958:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800962:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800966:	74 06                	je     80096e <vsnprintf+0x2d>
  800968:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80096c:	7f 07                	jg     800975 <vsnprintf+0x34>
		return -E_INVAL;
  80096e:	b8 03 00 00 00       	mov    $0x3,%eax
  800973:	eb 20                	jmp    800995 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800975:	ff 75 14             	pushl  0x14(%ebp)
  800978:	ff 75 10             	pushl  0x10(%ebp)
  80097b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80097e:	50                   	push   %eax
  80097f:	68 0b 09 80 00       	push   $0x80090b
  800984:	e8 80 fb ff ff       	call   800509 <vprintfmt>
  800989:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80098c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80098f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800992:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800995:	c9                   	leave  
  800996:	c3                   	ret    

00800997 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80099d:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a0:	83 c0 04             	add    $0x4,%eax
  8009a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ac:	50                   	push   %eax
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	ff 75 08             	pushl  0x8(%ebp)
  8009b3:	e8 89 ff ff ff       	call   800941 <vsnprintf>
  8009b8:	83 c4 10             	add    $0x10,%esp
  8009bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c1:	c9                   	leave  
  8009c2:	c3                   	ret    

008009c3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d0:	eb 06                	jmp    8009d8 <strlen+0x15>
		n++;
  8009d2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d5:	ff 45 08             	incl   0x8(%ebp)
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8a 00                	mov    (%eax),%al
  8009dd:	84 c0                	test   %al,%al
  8009df:	75 f1                	jne    8009d2 <strlen+0xf>
		n++;
	return n;
  8009e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009e4:	c9                   	leave  
  8009e5:	c3                   	ret    

008009e6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009f3:	eb 09                	jmp    8009fe <strnlen+0x18>
		n++;
  8009f5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f8:	ff 45 08             	incl   0x8(%ebp)
  8009fb:	ff 4d 0c             	decl   0xc(%ebp)
  8009fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a02:	74 09                	je     800a0d <strnlen+0x27>
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	8a 00                	mov    (%eax),%al
  800a09:	84 c0                	test   %al,%al
  800a0b:	75 e8                	jne    8009f5 <strnlen+0xf>
		n++;
	return n;
  800a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a10:	c9                   	leave  
  800a11:	c3                   	ret    

00800a12 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a1e:	90                   	nop
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8d 50 01             	lea    0x1(%eax),%edx
  800a25:	89 55 08             	mov    %edx,0x8(%ebp)
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a2e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a31:	8a 12                	mov    (%edx),%dl
  800a33:	88 10                	mov    %dl,(%eax)
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	84 c0                	test   %al,%al
  800a39:	75 e4                	jne    800a1f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a3e:	c9                   	leave  
  800a3f:	c3                   	ret    

00800a40 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a53:	eb 1f                	jmp    800a74 <strncpy+0x34>
		*dst++ = *src;
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8d 50 01             	lea    0x1(%eax),%edx
  800a5b:	89 55 08             	mov    %edx,0x8(%ebp)
  800a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a61:	8a 12                	mov    (%edx),%dl
  800a63:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a68:	8a 00                	mov    (%eax),%al
  800a6a:	84 c0                	test   %al,%al
  800a6c:	74 03                	je     800a71 <strncpy+0x31>
			src++;
  800a6e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a71:	ff 45 fc             	incl   -0x4(%ebp)
  800a74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a77:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a7a:	72 d9                	jb     800a55 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a7f:	c9                   	leave  
  800a80:	c3                   	ret    

00800a81 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a91:	74 30                	je     800ac3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a93:	eb 16                	jmp    800aab <strlcpy+0x2a>
			*dst++ = *src++;
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	8d 50 01             	lea    0x1(%eax),%edx
  800a9b:	89 55 08             	mov    %edx,0x8(%ebp)
  800a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aa4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aa7:	8a 12                	mov    (%edx),%dl
  800aa9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aab:	ff 4d 10             	decl   0x10(%ebp)
  800aae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab2:	74 09                	je     800abd <strlcpy+0x3c>
  800ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab7:	8a 00                	mov    (%eax),%al
  800ab9:	84 c0                	test   %al,%al
  800abb:	75 d8                	jne    800a95 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ac9:	29 c2                	sub    %eax,%edx
  800acb:	89 d0                	mov    %edx,%eax
}
  800acd:	c9                   	leave  
  800ace:	c3                   	ret    

00800acf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ad2:	eb 06                	jmp    800ada <strcmp+0xb>
		p++, q++;
  800ad4:	ff 45 08             	incl   0x8(%ebp)
  800ad7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	8a 00                	mov    (%eax),%al
  800adf:	84 c0                	test   %al,%al
  800ae1:	74 0e                	je     800af1 <strcmp+0x22>
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	8a 10                	mov    (%eax),%dl
  800ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aeb:	8a 00                	mov    (%eax),%al
  800aed:	38 c2                	cmp    %al,%dl
  800aef:	74 e3                	je     800ad4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	0f b6 d0             	movzbl %al,%edx
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	8a 00                	mov    (%eax),%al
  800afe:	0f b6 c0             	movzbl %al,%eax
  800b01:	29 c2                	sub    %eax,%edx
  800b03:	89 d0                	mov    %edx,%eax
}
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b0a:	eb 09                	jmp    800b15 <strncmp+0xe>
		n--, p++, q++;
  800b0c:	ff 4d 10             	decl   0x10(%ebp)
  800b0f:	ff 45 08             	incl   0x8(%ebp)
  800b12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b19:	74 17                	je     800b32 <strncmp+0x2b>
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8a 00                	mov    (%eax),%al
  800b20:	84 c0                	test   %al,%al
  800b22:	74 0e                	je     800b32 <strncmp+0x2b>
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8a 10                	mov    (%eax),%dl
  800b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	38 c2                	cmp    %al,%dl
  800b30:	74 da                	je     800b0c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b36:	75 07                	jne    800b3f <strncmp+0x38>
		return 0;
  800b38:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3d:	eb 14                	jmp    800b53 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8a 00                	mov    (%eax),%al
  800b44:	0f b6 d0             	movzbl %al,%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8a 00                	mov    (%eax),%al
  800b4c:	0f b6 c0             	movzbl %al,%eax
  800b4f:	29 c2                	sub    %eax,%edx
  800b51:	89 d0                	mov    %edx,%eax
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 04             	sub    $0x4,%esp
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b61:	eb 12                	jmp    800b75 <strchr+0x20>
		if (*s == c)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b6b:	75 05                	jne    800b72 <strchr+0x1d>
			return (char *) s;
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	eb 11                	jmp    800b83 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b72:	ff 45 08             	incl   0x8(%ebp)
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	84 c0                	test   %al,%al
  800b7c:	75 e5                	jne    800b63 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b83:	c9                   	leave  
  800b84:	c3                   	ret    

00800b85 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b91:	eb 0d                	jmp    800ba0 <strfind+0x1b>
		if (*s == c)
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	8a 00                	mov    (%eax),%al
  800b98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b9b:	74 0e                	je     800bab <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b9d:	ff 45 08             	incl   0x8(%ebp)
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	8a 00                	mov    (%eax),%al
  800ba5:	84 c0                	test   %al,%al
  800ba7:	75 ea                	jne    800b93 <strfind+0xe>
  800ba9:	eb 01                	jmp    800bac <strfind+0x27>
		if (*s == c)
			break;
  800bab:	90                   	nop
	return (char *) s;
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800bbd:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800bc1:	76 63                	jbe    800c26 <memset+0x75>
		uint64 data_block = c;
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	99                   	cltd   
  800bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bca:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd3:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800bd7:	c1 e0 08             	shl    $0x8,%eax
  800bda:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bdd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be6:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800bea:	c1 e0 10             	shl    $0x10,%eax
  800bed:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bf0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf9:	89 c2                	mov    %eax,%edx
  800bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800c00:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c03:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c06:	eb 18                	jmp    800c20 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c08:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c0b:	8d 41 08             	lea    0x8(%ecx),%eax
  800c0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c17:	89 01                	mov    %eax,(%ecx)
  800c19:	89 51 04             	mov    %edx,0x4(%ecx)
  800c1c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c20:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c24:	77 e2                	ja     800c08 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c2a:	74 23                	je     800c4f <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c32:	eb 0e                	jmp    800c42 <memset+0x91>
			*p8++ = (uint8)c;
  800c34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c37:	8d 50 01             	lea    0x1(%eax),%edx
  800c3a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c40:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c42:	8b 45 10             	mov    0x10(%ebp),%eax
  800c45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c48:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	75 e5                	jne    800c34 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800c66:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c6a:	76 24                	jbe    800c90 <memcpy+0x3c>
		while(n >= 8){
  800c6c:	eb 1c                	jmp    800c8a <memcpy+0x36>
			*d64 = *s64;
  800c6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c71:	8b 50 04             	mov    0x4(%eax),%edx
  800c74:	8b 00                	mov    (%eax),%eax
  800c76:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800c79:	89 01                	mov    %eax,(%ecx)
  800c7b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800c7e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800c82:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800c86:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800c8a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c8e:	77 de                	ja     800c6e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800c90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c94:	74 31                	je     800cc7 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c99:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800c9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ca2:	eb 16                	jmp    800cba <memcpy+0x66>
			*d8++ = *s8++;
  800ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca7:	8d 50 01             	lea    0x1(%eax),%edx
  800caa:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800cad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb3:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800cb6:	8a 12                	mov    (%edx),%dl
  800cb8:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800cba:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc3:	85 c0                	test   %eax,%eax
  800cc5:	75 dd                	jne    800ca4 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ce4:	73 50                	jae    800d36 <memmove+0x6a>
  800ce6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ce9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cec:	01 d0                	add    %edx,%eax
  800cee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cf1:	76 43                	jbe    800d36 <memmove+0x6a>
		s += n;
  800cf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cff:	eb 10                	jmp    800d11 <memmove+0x45>
			*--d = *--s;
  800d01:	ff 4d f8             	decl   -0x8(%ebp)
  800d04:	ff 4d fc             	decl   -0x4(%ebp)
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	8a 10                	mov    (%eax),%dl
  800d0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d0f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d17:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	75 e3                	jne    800d01 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d1e:	eb 23                	jmp    800d43 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d23:	8d 50 01             	lea    0x1(%eax),%edx
  800d26:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d2c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d32:	8a 12                	mov    (%edx),%dl
  800d34:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d36:	8b 45 10             	mov    0x10(%ebp),%eax
  800d39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	75 dd                	jne    800d20 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d5a:	eb 2a                	jmp    800d86 <memcmp+0x3e>
		if (*s1 != *s2)
  800d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5f:	8a 10                	mov    (%eax),%dl
  800d61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	38 c2                	cmp    %al,%dl
  800d68:	74 16                	je     800d80 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	0f b6 d0             	movzbl %al,%edx
  800d72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	0f b6 c0             	movzbl %al,%eax
  800d7a:	29 c2                	sub    %eax,%edx
  800d7c:	89 d0                	mov    %edx,%eax
  800d7e:	eb 18                	jmp    800d98 <memcmp+0x50>
		s1++, s2++;
  800d80:	ff 45 fc             	incl   -0x4(%ebp)
  800d83:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	75 c9                	jne    800d5c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d98:	c9                   	leave  
  800d99:	c3                   	ret    

00800d9a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 45 10             	mov    0x10(%ebp),%eax
  800da6:	01 d0                	add    %edx,%eax
  800da8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dab:	eb 15                	jmp    800dc2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8a 00                	mov    (%eax),%al
  800db2:	0f b6 d0             	movzbl %al,%edx
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	0f b6 c0             	movzbl %al,%eax
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	74 0d                	je     800dcc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dbf:	ff 45 08             	incl   0x8(%ebp)
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dc8:	72 e3                	jb     800dad <memfind+0x13>
  800dca:	eb 01                	jmp    800dcd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800dcc:	90                   	nop
	return (void *) s;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800dd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ddf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800de6:	eb 03                	jmp    800deb <strtol+0x19>
		s++;
  800de8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3c 20                	cmp    $0x20,%al
  800df2:	74 f4                	je     800de8 <strtol+0x16>
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	3c 09                	cmp    $0x9,%al
  800dfb:	74 eb                	je     800de8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	3c 2b                	cmp    $0x2b,%al
  800e04:	75 05                	jne    800e0b <strtol+0x39>
		s++;
  800e06:	ff 45 08             	incl   0x8(%ebp)
  800e09:	eb 13                	jmp    800e1e <strtol+0x4c>
	else if (*s == '-')
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	3c 2d                	cmp    $0x2d,%al
  800e12:	75 0a                	jne    800e1e <strtol+0x4c>
		s++, neg = 1;
  800e14:	ff 45 08             	incl   0x8(%ebp)
  800e17:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e22:	74 06                	je     800e2a <strtol+0x58>
  800e24:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e28:	75 20                	jne    800e4a <strtol+0x78>
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	3c 30                	cmp    $0x30,%al
  800e31:	75 17                	jne    800e4a <strtol+0x78>
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	40                   	inc    %eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	3c 78                	cmp    $0x78,%al
  800e3b:	75 0d                	jne    800e4a <strtol+0x78>
		s += 2, base = 16;
  800e3d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e41:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e48:	eb 28                	jmp    800e72 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e4e:	75 15                	jne    800e65 <strtol+0x93>
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	3c 30                	cmp    $0x30,%al
  800e57:	75 0c                	jne    800e65 <strtol+0x93>
		s++, base = 8;
  800e59:	ff 45 08             	incl   0x8(%ebp)
  800e5c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e63:	eb 0d                	jmp    800e72 <strtol+0xa0>
	else if (base == 0)
  800e65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e69:	75 07                	jne    800e72 <strtol+0xa0>
		base = 10;
  800e6b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	3c 2f                	cmp    $0x2f,%al
  800e79:	7e 19                	jle    800e94 <strtol+0xc2>
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	3c 39                	cmp    $0x39,%al
  800e82:	7f 10                	jg     800e94 <strtol+0xc2>
			dig = *s - '0';
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	0f be c0             	movsbl %al,%eax
  800e8c:	83 e8 30             	sub    $0x30,%eax
  800e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e92:	eb 42                	jmp    800ed6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 60                	cmp    $0x60,%al
  800e9b:	7e 19                	jle    800eb6 <strtol+0xe4>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	3c 7a                	cmp    $0x7a,%al
  800ea4:	7f 10                	jg     800eb6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f be c0             	movsbl %al,%eax
  800eae:	83 e8 57             	sub    $0x57,%eax
  800eb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eb4:	eb 20                	jmp    800ed6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	3c 40                	cmp    $0x40,%al
  800ebd:	7e 39                	jle    800ef8 <strtol+0x126>
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	3c 5a                	cmp    $0x5a,%al
  800ec6:	7f 30                	jg     800ef8 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	0f be c0             	movsbl %al,%eax
  800ed0:	83 e8 37             	sub    $0x37,%eax
  800ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edc:	7d 19                	jge    800ef7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ee8:	89 c2                	mov    %eax,%edx
  800eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eed:	01 d0                	add    %edx,%eax
  800eef:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ef2:	e9 7b ff ff ff       	jmp    800e72 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ef7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ef8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800efc:	74 08                	je     800f06 <strtol+0x134>
		*endptr = (char *) s;
  800efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f01:	8b 55 08             	mov    0x8(%ebp),%edx
  800f04:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f06:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f0a:	74 07                	je     800f13 <strtol+0x141>
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0f:	f7 d8                	neg    %eax
  800f11:	eb 03                	jmp    800f16 <strtol+0x144>
  800f13:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <ltostr>:

void
ltostr(long value, char *str)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f30:	79 13                	jns    800f45 <ltostr+0x2d>
	{
		neg = 1;
  800f32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f3f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f42:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f4d:	99                   	cltd   
  800f4e:	f7 f9                	idiv   %ecx
  800f50:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f56:	8d 50 01             	lea    0x1(%eax),%edx
  800f59:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5c:	89 c2                	mov    %eax,%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	01 d0                	add    %edx,%eax
  800f63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f66:	83 c2 30             	add    $0x30,%edx
  800f69:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f6e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f73:	f7 e9                	imul   %ecx
  800f75:	c1 fa 02             	sar    $0x2,%edx
  800f78:	89 c8                	mov    %ecx,%eax
  800f7a:	c1 f8 1f             	sar    $0x1f,%eax
  800f7d:	29 c2                	sub    %eax,%edx
  800f7f:	89 d0                	mov    %edx,%eax
  800f81:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f88:	75 bb                	jne    800f45 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f94:	48                   	dec    %eax
  800f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f98:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f9c:	74 3d                	je     800fdb <ltostr+0xc3>
		start = 1 ;
  800f9e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fa5:	eb 34                	jmp    800fdb <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fad:	01 d0                	add    %edx,%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	01 c2                	add    %eax,%edx
  800fbc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc2:	01 c8                	add    %ecx,%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	01 c2                	add    %eax,%edx
  800fd0:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fd3:	88 02                	mov    %al,(%edx)
		start++ ;
  800fd5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fd8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fde:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe1:	7c c4                	jl     800fa7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fe3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	01 d0                	add    %edx,%eax
  800feb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fee:	90                   	nop
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ff7:	ff 75 08             	pushl  0x8(%ebp)
  800ffa:	e8 c4 f9 ff ff       	call   8009c3 <strlen>
  800fff:	83 c4 04             	add    $0x4,%esp
  801002:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801005:	ff 75 0c             	pushl  0xc(%ebp)
  801008:	e8 b6 f9 ff ff       	call   8009c3 <strlen>
  80100d:	83 c4 04             	add    $0x4,%esp
  801010:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801013:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801021:	eb 17                	jmp    80103a <strcconcat+0x49>
		final[s] = str1[s] ;
  801023:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 c2                	add    %eax,%edx
  80102b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	01 c8                	add    %ecx,%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801037:	ff 45 fc             	incl   -0x4(%ebp)
  80103a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801040:	7c e1                	jl     801023 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801042:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801049:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801050:	eb 1f                	jmp    801071 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801052:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801055:	8d 50 01             	lea    0x1(%eax),%edx
  801058:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80105b:	89 c2                	mov    %eax,%edx
  80105d:	8b 45 10             	mov    0x10(%ebp),%eax
  801060:	01 c2                	add    %eax,%edx
  801062:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801065:	8b 45 0c             	mov    0xc(%ebp),%eax
  801068:	01 c8                	add    %ecx,%eax
  80106a:	8a 00                	mov    (%eax),%al
  80106c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80106e:	ff 45 f8             	incl   -0x8(%ebp)
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801077:	7c d9                	jl     801052 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801079:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	01 d0                	add    %edx,%eax
  801081:	c6 00 00             	movb   $0x0,(%eax)
}
  801084:	90                   	nop
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80108a:	8b 45 14             	mov    0x14(%ebp),%eax
  80108d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801093:	8b 45 14             	mov    0x14(%ebp),%eax
  801096:	8b 00                	mov    (%eax),%eax
  801098:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010aa:	eb 0c                	jmp    8010b8 <strsplit+0x31>
			*string++ = 0;
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8d 50 01             	lea    0x1(%eax),%edx
  8010b2:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	84 c0                	test   %al,%al
  8010bf:	74 18                	je     8010d9 <strsplit+0x52>
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	0f be c0             	movsbl %al,%eax
  8010c9:	50                   	push   %eax
  8010ca:	ff 75 0c             	pushl  0xc(%ebp)
  8010cd:	e8 83 fa ff ff       	call   800b55 <strchr>
  8010d2:	83 c4 08             	add    $0x8,%esp
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	75 d3                	jne    8010ac <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	84 c0                	test   %al,%al
  8010e0:	74 5a                	je     80113c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e5:	8b 00                	mov    (%eax),%eax
  8010e7:	83 f8 0f             	cmp    $0xf,%eax
  8010ea:	75 07                	jne    8010f3 <strsplit+0x6c>
		{
			return 0;
  8010ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f1:	eb 66                	jmp    801159 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f6:	8b 00                	mov    (%eax),%eax
  8010f8:	8d 48 01             	lea    0x1(%eax),%ecx
  8010fb:	8b 55 14             	mov    0x14(%ebp),%edx
  8010fe:	89 0a                	mov    %ecx,(%edx)
  801100:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 c2                	add    %eax,%edx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801111:	eb 03                	jmp    801116 <strsplit+0x8f>
			string++;
  801113:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	84 c0                	test   %al,%al
  80111d:	74 8b                	je     8010aa <strsplit+0x23>
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f be c0             	movsbl %al,%eax
  801127:	50                   	push   %eax
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	e8 25 fa ff ff       	call   800b55 <strchr>
  801130:	83 c4 08             	add    $0x8,%esp
  801133:	85 c0                	test   %eax,%eax
  801135:	74 dc                	je     801113 <strsplit+0x8c>
			string++;
	}
  801137:	e9 6e ff ff ff       	jmp    8010aa <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80113c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80113d:	8b 45 14             	mov    0x14(%ebp),%eax
  801140:	8b 00                	mov    (%eax),%eax
  801142:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801149:	8b 45 10             	mov    0x10(%ebp),%eax
  80114c:	01 d0                	add    %edx,%eax
  80114e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801154:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801159:	c9                   	leave  
  80115a:	c3                   	ret    

0080115b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80116e:	eb 4a                	jmp    8011ba <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801170:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	01 c2                	add    %eax,%edx
  801178:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	01 c8                	add    %ecx,%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801184:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	01 d0                	add    %edx,%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	3c 40                	cmp    $0x40,%al
  801190:	7e 25                	jle    8011b7 <str2lower+0x5c>
  801192:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801195:	8b 45 0c             	mov    0xc(%ebp),%eax
  801198:	01 d0                	add    %edx,%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 5a                	cmp    $0x5a,%al
  80119e:	7f 17                	jg     8011b7 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8011a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	01 d0                	add    %edx,%eax
  8011a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ae:	01 ca                	add    %ecx,%edx
  8011b0:	8a 12                	mov    (%edx),%dl
  8011b2:	83 c2 20             	add    $0x20,%edx
  8011b5:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8011b7:	ff 45 fc             	incl   -0x4(%ebp)
  8011ba:	ff 75 0c             	pushl  0xc(%ebp)
  8011bd:	e8 01 f8 ff ff       	call   8009c3 <strlen>
  8011c2:	83 c4 04             	add    $0x4,%esp
  8011c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011c8:	7f a6                	jg     801170 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	57                   	push   %edi
  8011d3:	56                   	push   %esi
  8011d4:	53                   	push   %ebx
  8011d5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011e4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011e7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011ea:	cd 30                	int    $0x30
  8011ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8011ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011f2:	83 c4 10             	add    $0x10,%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5f                   	pop    %edi
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    

008011fa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 04             	sub    $0x4,%esp
  801200:	8b 45 10             	mov    0x10(%ebp),%eax
  801203:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801206:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801209:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	6a 00                	push   $0x0
  801212:	51                   	push   %ecx
  801213:	52                   	push   %edx
  801214:	ff 75 0c             	pushl  0xc(%ebp)
  801217:	50                   	push   %eax
  801218:	6a 00                	push   $0x0
  80121a:	e8 b0 ff ff ff       	call   8011cf <syscall>
  80121f:	83 c4 18             	add    $0x18,%esp
}
  801222:	90                   	nop
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <sys_cgetc>:

int
sys_cgetc(void)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801228:	6a 00                	push   $0x0
  80122a:	6a 00                	push   $0x0
  80122c:	6a 00                	push   $0x0
  80122e:	6a 00                	push   $0x0
  801230:	6a 00                	push   $0x0
  801232:	6a 02                	push   $0x2
  801234:	e8 96 ff ff ff       	call   8011cf <syscall>
  801239:	83 c4 18             	add    $0x18,%esp
}
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 03                	push   $0x3
  80124d:	e8 7d ff ff ff       	call   8011cf <syscall>
  801252:	83 c4 18             	add    $0x18,%esp
}
  801255:	90                   	nop
  801256:	c9                   	leave  
  801257:	c3                   	ret    

00801258 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	6a 00                	push   $0x0
  801265:	6a 04                	push   $0x4
  801267:	e8 63 ff ff ff       	call   8011cf <syscall>
  80126c:	83 c4 18             	add    $0x18,%esp
}
  80126f:	90                   	nop
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801275:	8b 55 0c             	mov    0xc(%ebp),%edx
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	52                   	push   %edx
  801282:	50                   	push   %eax
  801283:	6a 08                	push   $0x8
  801285:	e8 45 ff ff ff       	call   8011cf <syscall>
  80128a:	83 c4 18             	add    $0x18,%esp
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	56                   	push   %esi
  801293:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801294:	8b 75 18             	mov    0x18(%ebp),%esi
  801297:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80129a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80129d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	56                   	push   %esi
  8012a4:	53                   	push   %ebx
  8012a5:	51                   	push   %ecx
  8012a6:	52                   	push   %edx
  8012a7:	50                   	push   %eax
  8012a8:	6a 09                	push   $0x9
  8012aa:	e8 20 ff ff ff       	call   8011cf <syscall>
  8012af:	83 c4 18             	add    $0x18,%esp
}
  8012b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b5:	5b                   	pop    %ebx
  8012b6:	5e                   	pop    %esi
  8012b7:	5d                   	pop    %ebp
  8012b8:	c3                   	ret    

008012b9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 00                	push   $0x0
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	ff 75 08             	pushl  0x8(%ebp)
  8012c7:	6a 0a                	push   $0xa
  8012c9:	e8 01 ff ff ff       	call   8011cf <syscall>
  8012ce:	83 c4 18             	add    $0x18,%esp
}
  8012d1:	c9                   	leave  
  8012d2:	c3                   	ret    

008012d3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	ff 75 08             	pushl  0x8(%ebp)
  8012e2:	6a 0b                	push   $0xb
  8012e4:	e8 e6 fe ff ff       	call   8011cf <syscall>
  8012e9:	83 c4 18             	add    $0x18,%esp
}
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 0c                	push   $0xc
  8012fd:	e8 cd fe ff ff       	call   8011cf <syscall>
  801302:	83 c4 18             	add    $0x18,%esp
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 0d                	push   $0xd
  801316:	e8 b4 fe ff ff       	call   8011cf <syscall>
  80131b:	83 c4 18             	add    $0x18,%esp
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 0e                	push   $0xe
  80132f:	e8 9b fe ff ff       	call   8011cf <syscall>
  801334:	83 c4 18             	add    $0x18,%esp
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 0f                	push   $0xf
  801348:	e8 82 fe ff ff       	call   8011cf <syscall>
  80134d:	83 c4 18             	add    $0x18,%esp
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	ff 75 08             	pushl  0x8(%ebp)
  801360:	6a 10                	push   $0x10
  801362:	e8 68 fe ff ff       	call   8011cf <syscall>
  801367:	83 c4 18             	add    $0x18,%esp
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 11                	push   $0x11
  80137b:	e8 4f fe ff ff       	call   8011cf <syscall>
  801380:	83 c4 18             	add    $0x18,%esp
}
  801383:	90                   	nop
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <sys_cputc>:

void
sys_cputc(const char c)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801392:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	50                   	push   %eax
  80139f:	6a 01                	push   $0x1
  8013a1:	e8 29 fe ff ff       	call   8011cf <syscall>
  8013a6:	83 c4 18             	add    $0x18,%esp
}
  8013a9:	90                   	nop
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 14                	push   $0x14
  8013bb:	e8 0f fe ff ff       	call   8011cf <syscall>
  8013c0:	83 c4 18             	add    $0x18,%esp
}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 04             	sub    $0x4,%esp
  8013cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013d5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	6a 00                	push   $0x0
  8013de:	51                   	push   %ecx
  8013df:	52                   	push   %edx
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	50                   	push   %eax
  8013e4:	6a 15                	push   $0x15
  8013e6:	e8 e4 fd ff ff       	call   8011cf <syscall>
  8013eb:	83 c4 18             	add    $0x18,%esp
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	52                   	push   %edx
  801400:	50                   	push   %eax
  801401:	6a 16                	push   $0x16
  801403:	e8 c7 fd ff ff       	call   8011cf <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801410:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801413:	8b 55 0c             	mov    0xc(%ebp),%edx
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	51                   	push   %ecx
  80141e:	52                   	push   %edx
  80141f:	50                   	push   %eax
  801420:	6a 17                	push   $0x17
  801422:	e8 a8 fd ff ff       	call   8011cf <syscall>
  801427:	83 c4 18             	add    $0x18,%esp
}
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80142f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	52                   	push   %edx
  80143c:	50                   	push   %eax
  80143d:	6a 18                	push   $0x18
  80143f:	e8 8b fd ff ff       	call   8011cf <syscall>
  801444:	83 c4 18             	add    $0x18,%esp
}
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	6a 00                	push   $0x0
  801451:	ff 75 14             	pushl  0x14(%ebp)
  801454:	ff 75 10             	pushl  0x10(%ebp)
  801457:	ff 75 0c             	pushl  0xc(%ebp)
  80145a:	50                   	push   %eax
  80145b:	6a 19                	push   $0x19
  80145d:	e8 6d fd ff ff       	call   8011cf <syscall>
  801462:	83 c4 18             	add    $0x18,%esp
}
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	50                   	push   %eax
  801476:	6a 1a                	push   $0x1a
  801478:	e8 52 fd ff ff       	call   8011cf <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	50                   	push   %eax
  801492:	6a 1b                	push   $0x1b
  801494:	e8 36 fd ff ff       	call   8011cf <syscall>
  801499:	83 c4 18             	add    $0x18,%esp
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 05                	push   $0x5
  8014ad:	e8 1d fd ff ff       	call   8011cf <syscall>
  8014b2:	83 c4 18             	add    $0x18,%esp
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 06                	push   $0x6
  8014c6:	e8 04 fd ff ff       	call   8011cf <syscall>
  8014cb:	83 c4 18             	add    $0x18,%esp
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 07                	push   $0x7
  8014df:	e8 eb fc ff ff       	call   8011cf <syscall>
  8014e4:	83 c4 18             	add    $0x18,%esp
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <sys_exit_env>:


void sys_exit_env(void)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 1c                	push   $0x1c
  8014f8:	e8 d2 fc ff ff       	call   8011cf <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
}
  801500:	90                   	nop
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801509:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80150c:	8d 50 04             	lea    0x4(%eax),%edx
  80150f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	52                   	push   %edx
  801519:	50                   	push   %eax
  80151a:	6a 1d                	push   $0x1d
  80151c:	e8 ae fc ff ff       	call   8011cf <syscall>
  801521:	83 c4 18             	add    $0x18,%esp
	return result;
  801524:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801527:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152d:	89 01                	mov    %eax,(%ecx)
  80152f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	c9                   	leave  
  801536:	c2 04 00             	ret    $0x4

00801539 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	ff 75 10             	pushl  0x10(%ebp)
  801543:	ff 75 0c             	pushl  0xc(%ebp)
  801546:	ff 75 08             	pushl  0x8(%ebp)
  801549:	6a 13                	push   $0x13
  80154b:	e8 7f fc ff ff       	call   8011cf <syscall>
  801550:	83 c4 18             	add    $0x18,%esp
	return ;
  801553:	90                   	nop
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_rcr2>:
uint32 sys_rcr2()
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 1e                	push   $0x1e
  801565:	e8 65 fc ff ff       	call   8011cf <syscall>
  80156a:	83 c4 18             	add    $0x18,%esp
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 04             	sub    $0x4,%esp
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80157b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	50                   	push   %eax
  801588:	6a 1f                	push   $0x1f
  80158a:	e8 40 fc ff ff       	call   8011cf <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
	return ;
  801592:	90                   	nop
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <rsttst>:
void rsttst()
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 21                	push   $0x21
  8015a4:	e8 26 fc ff ff       	call   8011cf <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ac:	90                   	nop
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015bb:	8b 55 18             	mov    0x18(%ebp),%edx
  8015be:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015c2:	52                   	push   %edx
  8015c3:	50                   	push   %eax
  8015c4:	ff 75 10             	pushl  0x10(%ebp)
  8015c7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ca:	ff 75 08             	pushl  0x8(%ebp)
  8015cd:	6a 20                	push   $0x20
  8015cf:	e8 fb fb ff ff       	call   8011cf <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d7:	90                   	nop
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <chktst>:
void chktst(uint32 n)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	ff 75 08             	pushl  0x8(%ebp)
  8015e8:	6a 22                	push   $0x22
  8015ea:	e8 e0 fb ff ff       	call   8011cf <syscall>
  8015ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f2:	90                   	nop
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <inctst>:

void inctst()
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 23                	push   $0x23
  801604:	e8 c6 fb ff ff       	call   8011cf <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
	return ;
  80160c:	90                   	nop
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <gettst>:
uint32 gettst()
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 24                	push   $0x24
  80161e:	e8 ac fb ff ff       	call   8011cf <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 25                	push   $0x25
  801637:	e8 93 fb ff ff       	call   8011cf <syscall>
  80163c:	83 c4 18             	add    $0x18,%esp
  80163f:	a3 00 d9 82 00       	mov    %eax,0x82d900
	return uheapPlaceStrategy ;
  801644:	a1 00 d9 82 00       	mov    0x82d900,%eax
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	a3 00 d9 82 00       	mov    %eax,0x82d900
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	ff 75 08             	pushl  0x8(%ebp)
  801661:	6a 26                	push   $0x26
  801663:	e8 67 fb ff ff       	call   8011cf <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
	return ;
  80166b:	90                   	nop
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801672:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801675:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	6a 00                	push   $0x0
  801680:	53                   	push   %ebx
  801681:	51                   	push   %ecx
  801682:	52                   	push   %edx
  801683:	50                   	push   %eax
  801684:	6a 27                	push   $0x27
  801686:	e8 44 fb ff ff       	call   8011cf <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801696:	8b 55 0c             	mov    0xc(%ebp),%edx
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	52                   	push   %edx
  8016a3:	50                   	push   %eax
  8016a4:	6a 28                	push   $0x28
  8016a6:	e8 24 fb ff ff       	call   8011cf <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	6a 00                	push   $0x0
  8016be:	51                   	push   %ecx
  8016bf:	ff 75 10             	pushl  0x10(%ebp)
  8016c2:	52                   	push   %edx
  8016c3:	50                   	push   %eax
  8016c4:	6a 29                	push   $0x29
  8016c6:	e8 04 fb ff ff       	call   8011cf <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
}
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	ff 75 10             	pushl  0x10(%ebp)
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	6a 12                	push   $0x12
  8016e2:	e8 e8 fa ff ff       	call   8011cf <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ea:	90                   	nop
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8016f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	52                   	push   %edx
  8016fd:	50                   	push   %eax
  8016fe:	6a 2a                	push   $0x2a
  801700:	e8 ca fa ff ff       	call   8011cf <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
	return;
  801708:	90                   	nop
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 2b                	push   $0x2b
  80171a:	e8 b0 fa ff ff       	call   8011cf <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	ff 75 0c             	pushl  0xc(%ebp)
  801730:	ff 75 08             	pushl  0x8(%ebp)
  801733:	6a 2d                	push   $0x2d
  801735:	e8 95 fa ff ff       	call   8011cf <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
	return;
  80173d:	90                   	nop
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	ff 75 0c             	pushl  0xc(%ebp)
  80174c:	ff 75 08             	pushl  0x8(%ebp)
  80174f:	6a 2c                	push   $0x2c
  801751:	e8 79 fa ff ff       	call   8011cf <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
	return ;
  801759:	90                   	nop
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80175f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	52                   	push   %edx
  80176c:	50                   	push   %eax
  80176d:	6a 2e                	push   $0x2e
  80176f:	e8 5b fa ff ff       	call   8011cf <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
	    return;
  801777:	90                   	nop
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    
  80177a:	66 90                	xchg   %ax,%ax

0080177c <__udivdi3>:
  80177c:	55                   	push   %ebp
  80177d:	57                   	push   %edi
  80177e:	56                   	push   %esi
  80177f:	53                   	push   %ebx
  801780:	83 ec 1c             	sub    $0x1c,%esp
  801783:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801787:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80178b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80178f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801793:	89 ca                	mov    %ecx,%edx
  801795:	89 f8                	mov    %edi,%eax
  801797:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80179b:	85 f6                	test   %esi,%esi
  80179d:	75 2d                	jne    8017cc <__udivdi3+0x50>
  80179f:	39 cf                	cmp    %ecx,%edi
  8017a1:	77 65                	ja     801808 <__udivdi3+0x8c>
  8017a3:	89 fd                	mov    %edi,%ebp
  8017a5:	85 ff                	test   %edi,%edi
  8017a7:	75 0b                	jne    8017b4 <__udivdi3+0x38>
  8017a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ae:	31 d2                	xor    %edx,%edx
  8017b0:	f7 f7                	div    %edi
  8017b2:	89 c5                	mov    %eax,%ebp
  8017b4:	31 d2                	xor    %edx,%edx
  8017b6:	89 c8                	mov    %ecx,%eax
  8017b8:	f7 f5                	div    %ebp
  8017ba:	89 c1                	mov    %eax,%ecx
  8017bc:	89 d8                	mov    %ebx,%eax
  8017be:	f7 f5                	div    %ebp
  8017c0:	89 cf                	mov    %ecx,%edi
  8017c2:	89 fa                	mov    %edi,%edx
  8017c4:	83 c4 1c             	add    $0x1c,%esp
  8017c7:	5b                   	pop    %ebx
  8017c8:	5e                   	pop    %esi
  8017c9:	5f                   	pop    %edi
  8017ca:	5d                   	pop    %ebp
  8017cb:	c3                   	ret    
  8017cc:	39 ce                	cmp    %ecx,%esi
  8017ce:	77 28                	ja     8017f8 <__udivdi3+0x7c>
  8017d0:	0f bd fe             	bsr    %esi,%edi
  8017d3:	83 f7 1f             	xor    $0x1f,%edi
  8017d6:	75 40                	jne    801818 <__udivdi3+0x9c>
  8017d8:	39 ce                	cmp    %ecx,%esi
  8017da:	72 0a                	jb     8017e6 <__udivdi3+0x6a>
  8017dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017e0:	0f 87 9e 00 00 00    	ja     801884 <__udivdi3+0x108>
  8017e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017eb:	89 fa                	mov    %edi,%edx
  8017ed:	83 c4 1c             	add    $0x1c,%esp
  8017f0:	5b                   	pop    %ebx
  8017f1:	5e                   	pop    %esi
  8017f2:	5f                   	pop    %edi
  8017f3:	5d                   	pop    %ebp
  8017f4:	c3                   	ret    
  8017f5:	8d 76 00             	lea    0x0(%esi),%esi
  8017f8:	31 ff                	xor    %edi,%edi
  8017fa:	31 c0                	xor    %eax,%eax
  8017fc:	89 fa                	mov    %edi,%edx
  8017fe:	83 c4 1c             	add    $0x1c,%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5f                   	pop    %edi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    
  801806:	66 90                	xchg   %ax,%ax
  801808:	89 d8                	mov    %ebx,%eax
  80180a:	f7 f7                	div    %edi
  80180c:	31 ff                	xor    %edi,%edi
  80180e:	89 fa                	mov    %edi,%edx
  801810:	83 c4 1c             	add    $0x1c,%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5f                   	pop    %edi
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    
  801818:	bd 20 00 00 00       	mov    $0x20,%ebp
  80181d:	89 eb                	mov    %ebp,%ebx
  80181f:	29 fb                	sub    %edi,%ebx
  801821:	89 f9                	mov    %edi,%ecx
  801823:	d3 e6                	shl    %cl,%esi
  801825:	89 c5                	mov    %eax,%ebp
  801827:	88 d9                	mov    %bl,%cl
  801829:	d3 ed                	shr    %cl,%ebp
  80182b:	89 e9                	mov    %ebp,%ecx
  80182d:	09 f1                	or     %esi,%ecx
  80182f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801833:	89 f9                	mov    %edi,%ecx
  801835:	d3 e0                	shl    %cl,%eax
  801837:	89 c5                	mov    %eax,%ebp
  801839:	89 d6                	mov    %edx,%esi
  80183b:	88 d9                	mov    %bl,%cl
  80183d:	d3 ee                	shr    %cl,%esi
  80183f:	89 f9                	mov    %edi,%ecx
  801841:	d3 e2                	shl    %cl,%edx
  801843:	8b 44 24 08          	mov    0x8(%esp),%eax
  801847:	88 d9                	mov    %bl,%cl
  801849:	d3 e8                	shr    %cl,%eax
  80184b:	09 c2                	or     %eax,%edx
  80184d:	89 d0                	mov    %edx,%eax
  80184f:	89 f2                	mov    %esi,%edx
  801851:	f7 74 24 0c          	divl   0xc(%esp)
  801855:	89 d6                	mov    %edx,%esi
  801857:	89 c3                	mov    %eax,%ebx
  801859:	f7 e5                	mul    %ebp
  80185b:	39 d6                	cmp    %edx,%esi
  80185d:	72 19                	jb     801878 <__udivdi3+0xfc>
  80185f:	74 0b                	je     80186c <__udivdi3+0xf0>
  801861:	89 d8                	mov    %ebx,%eax
  801863:	31 ff                	xor    %edi,%edi
  801865:	e9 58 ff ff ff       	jmp    8017c2 <__udivdi3+0x46>
  80186a:	66 90                	xchg   %ax,%ax
  80186c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801870:	89 f9                	mov    %edi,%ecx
  801872:	d3 e2                	shl    %cl,%edx
  801874:	39 c2                	cmp    %eax,%edx
  801876:	73 e9                	jae    801861 <__udivdi3+0xe5>
  801878:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80187b:	31 ff                	xor    %edi,%edi
  80187d:	e9 40 ff ff ff       	jmp    8017c2 <__udivdi3+0x46>
  801882:	66 90                	xchg   %ax,%ax
  801884:	31 c0                	xor    %eax,%eax
  801886:	e9 37 ff ff ff       	jmp    8017c2 <__udivdi3+0x46>
  80188b:	90                   	nop

0080188c <__umoddi3>:
  80188c:	55                   	push   %ebp
  80188d:	57                   	push   %edi
  80188e:	56                   	push   %esi
  80188f:	53                   	push   %ebx
  801890:	83 ec 1c             	sub    $0x1c,%esp
  801893:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801897:	8b 74 24 34          	mov    0x34(%esp),%esi
  80189b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80189f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8018a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018ab:	89 f3                	mov    %esi,%ebx
  8018ad:	89 fa                	mov    %edi,%edx
  8018af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018b3:	89 34 24             	mov    %esi,(%esp)
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	75 1a                	jne    8018d4 <__umoddi3+0x48>
  8018ba:	39 f7                	cmp    %esi,%edi
  8018bc:	0f 86 a2 00 00 00    	jbe    801964 <__umoddi3+0xd8>
  8018c2:	89 c8                	mov    %ecx,%eax
  8018c4:	89 f2                	mov    %esi,%edx
  8018c6:	f7 f7                	div    %edi
  8018c8:	89 d0                	mov    %edx,%eax
  8018ca:	31 d2                	xor    %edx,%edx
  8018cc:	83 c4 1c             	add    $0x1c,%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5f                   	pop    %edi
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    
  8018d4:	39 f0                	cmp    %esi,%eax
  8018d6:	0f 87 ac 00 00 00    	ja     801988 <__umoddi3+0xfc>
  8018dc:	0f bd e8             	bsr    %eax,%ebp
  8018df:	83 f5 1f             	xor    $0x1f,%ebp
  8018e2:	0f 84 ac 00 00 00    	je     801994 <__umoddi3+0x108>
  8018e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8018ed:	29 ef                	sub    %ebp,%edi
  8018ef:	89 fe                	mov    %edi,%esi
  8018f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018f5:	89 e9                	mov    %ebp,%ecx
  8018f7:	d3 e0                	shl    %cl,%eax
  8018f9:	89 d7                	mov    %edx,%edi
  8018fb:	89 f1                	mov    %esi,%ecx
  8018fd:	d3 ef                	shr    %cl,%edi
  8018ff:	09 c7                	or     %eax,%edi
  801901:	89 e9                	mov    %ebp,%ecx
  801903:	d3 e2                	shl    %cl,%edx
  801905:	89 14 24             	mov    %edx,(%esp)
  801908:	89 d8                	mov    %ebx,%eax
  80190a:	d3 e0                	shl    %cl,%eax
  80190c:	89 c2                	mov    %eax,%edx
  80190e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801912:	d3 e0                	shl    %cl,%eax
  801914:	89 44 24 04          	mov    %eax,0x4(%esp)
  801918:	8b 44 24 08          	mov    0x8(%esp),%eax
  80191c:	89 f1                	mov    %esi,%ecx
  80191e:	d3 e8                	shr    %cl,%eax
  801920:	09 d0                	or     %edx,%eax
  801922:	d3 eb                	shr    %cl,%ebx
  801924:	89 da                	mov    %ebx,%edx
  801926:	f7 f7                	div    %edi
  801928:	89 d3                	mov    %edx,%ebx
  80192a:	f7 24 24             	mull   (%esp)
  80192d:	89 c6                	mov    %eax,%esi
  80192f:	89 d1                	mov    %edx,%ecx
  801931:	39 d3                	cmp    %edx,%ebx
  801933:	0f 82 87 00 00 00    	jb     8019c0 <__umoddi3+0x134>
  801939:	0f 84 91 00 00 00    	je     8019d0 <__umoddi3+0x144>
  80193f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801943:	29 f2                	sub    %esi,%edx
  801945:	19 cb                	sbb    %ecx,%ebx
  801947:	89 d8                	mov    %ebx,%eax
  801949:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80194d:	d3 e0                	shl    %cl,%eax
  80194f:	89 e9                	mov    %ebp,%ecx
  801951:	d3 ea                	shr    %cl,%edx
  801953:	09 d0                	or     %edx,%eax
  801955:	89 e9                	mov    %ebp,%ecx
  801957:	d3 eb                	shr    %cl,%ebx
  801959:	89 da                	mov    %ebx,%edx
  80195b:	83 c4 1c             	add    $0x1c,%esp
  80195e:	5b                   	pop    %ebx
  80195f:	5e                   	pop    %esi
  801960:	5f                   	pop    %edi
  801961:	5d                   	pop    %ebp
  801962:	c3                   	ret    
  801963:	90                   	nop
  801964:	89 fd                	mov    %edi,%ebp
  801966:	85 ff                	test   %edi,%edi
  801968:	75 0b                	jne    801975 <__umoddi3+0xe9>
  80196a:	b8 01 00 00 00       	mov    $0x1,%eax
  80196f:	31 d2                	xor    %edx,%edx
  801971:	f7 f7                	div    %edi
  801973:	89 c5                	mov    %eax,%ebp
  801975:	89 f0                	mov    %esi,%eax
  801977:	31 d2                	xor    %edx,%edx
  801979:	f7 f5                	div    %ebp
  80197b:	89 c8                	mov    %ecx,%eax
  80197d:	f7 f5                	div    %ebp
  80197f:	89 d0                	mov    %edx,%eax
  801981:	e9 44 ff ff ff       	jmp    8018ca <__umoddi3+0x3e>
  801986:	66 90                	xchg   %ax,%ax
  801988:	89 c8                	mov    %ecx,%eax
  80198a:	89 f2                	mov    %esi,%edx
  80198c:	83 c4 1c             	add    $0x1c,%esp
  80198f:	5b                   	pop    %ebx
  801990:	5e                   	pop    %esi
  801991:	5f                   	pop    %edi
  801992:	5d                   	pop    %ebp
  801993:	c3                   	ret    
  801994:	3b 04 24             	cmp    (%esp),%eax
  801997:	72 06                	jb     80199f <__umoddi3+0x113>
  801999:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80199d:	77 0f                	ja     8019ae <__umoddi3+0x122>
  80199f:	89 f2                	mov    %esi,%edx
  8019a1:	29 f9                	sub    %edi,%ecx
  8019a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8019a7:	89 14 24             	mov    %edx,(%esp)
  8019aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8019b2:	8b 14 24             	mov    (%esp),%edx
  8019b5:	83 c4 1c             	add    $0x1c,%esp
  8019b8:	5b                   	pop    %ebx
  8019b9:	5e                   	pop    %esi
  8019ba:	5f                   	pop    %edi
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    
  8019bd:	8d 76 00             	lea    0x0(%esi),%esi
  8019c0:	2b 04 24             	sub    (%esp),%eax
  8019c3:	19 fa                	sbb    %edi,%edx
  8019c5:	89 d1                	mov    %edx,%ecx
  8019c7:	89 c6                	mov    %eax,%esi
  8019c9:	e9 71 ff ff ff       	jmp    80193f <__umoddi3+0xb3>
  8019ce:	66 90                	xchg   %ax,%ax
  8019d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019d4:	72 ea                	jb     8019c0 <__umoddi3+0x134>
  8019d6:	89 d9                	mov    %ebx,%ecx
  8019d8:	e9 62 ff ff ff       	jmp    80193f <__umoddi3+0xb3>
