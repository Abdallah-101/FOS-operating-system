
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 9a 13 00 00       	call   8013ea <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 a0 41 80 00       	push   $0x8041a0
  800061:	e8 dd 03 00 00       	call   800443 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 b3 41 80 00       	push   $0x8041b3
  8000be:	e8 80 03 00 00       	call   800443 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 0c 18 00 00       	call   8018e8 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 00 13 00 00       	call   8013ea <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 b3 41 80 00       	push   $0x8041b3
  800114:	e8 2a 03 00 00       	call   800443 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 b6 17 00 00       	call   8018e8 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	57                   	push   %edi
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
  80013e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800141:	e8 bf 2d 00 00       	call   802f05 <sys_getenvindex>
  800146:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 02             	shl    $0x2,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015a:	01 d0                	add    %edx,%eax
  80015c:	89 c2                	mov    %eax,%edx
  80015e:	c1 e2 04             	shl    $0x4,%edx
  800161:	29 c2                	sub    %eax,%edx
  800163:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80016a:	89 c2                	mov    %eax,%edx
  80016c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800172:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800177:	a1 20 50 80 00       	mov    0x805020,%eax
  80017c:	8a 40 20             	mov    0x20(%eax),%al
  80017f:	84 c0                	test   %al,%al
  800181:	74 0d                	je     800190 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800183:	a1 20 50 80 00       	mov    0x805020,%eax
  800188:	83 c0 20             	add    $0x20,%eax
  80018b:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800190:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800194:	7e 0a                	jle    8001a0 <libmain+0x68>
		binaryname = argv[0];
  800196:	8b 45 0c             	mov    0xc(%ebp),%eax
  800199:	8b 00                	mov    (%eax),%eax
  80019b:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 0c             	pushl  0xc(%ebp)
  8001a6:	ff 75 08             	pushl  0x8(%ebp)
  8001a9:	e8 8a fe ff ff       	call   800038 <_main>
  8001ae:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001b1:	a1 00 50 80 00       	mov    0x805000,%eax
  8001b6:	85 c0                	test   %eax,%eax
  8001b8:	0f 84 01 01 00 00    	je     8002bf <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001be:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c4:	bb b8 42 80 00       	mov    $0x8042b8,%ebx
  8001c9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ce:	89 c7                	mov    %eax,%edi
  8001d0:	89 de                	mov    %ebx,%esi
  8001d2:	89 d1                	mov    %edx,%ecx
  8001d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001d6:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001d9:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001de:	b0 00                	mov    $0x0,%al
  8001e0:	89 d7                	mov    %edx,%edi
  8001e2:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001e4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001eb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001f8:	50                   	push   %eax
  8001f9:	e8 3d 2f 00 00       	call   80313b <sys_utilities>
  8001fe:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800201:	e8 86 2a 00 00       	call   802c8c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	68 d8 41 80 00       	push   $0x8041d8
  80020e:	e8 be 01 00 00       	call   8003d1 <cprintf>
  800213:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800216:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800219:	85 c0                	test   %eax,%eax
  80021b:	74 18                	je     800235 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80021d:	e8 37 2f 00 00       	call   803159 <sys_get_optimal_num_faults>
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 00 42 80 00       	push   $0x804200
  80022b:	e8 a1 01 00 00       	call   8003d1 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	eb 59                	jmp    80028e <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800235:	a1 20 50 80 00       	mov    0x805020,%eax
  80023a:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800240:	a1 20 50 80 00       	mov    0x805020,%eax
  800245:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	52                   	push   %edx
  80024f:	50                   	push   %eax
  800250:	68 24 42 80 00       	push   $0x804224
  800255:	e8 77 01 00 00       	call   8003d1 <cprintf>
  80025a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025d:	a1 20 50 80 00       	mov    0x805020,%eax
  800262:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800268:	a1 20 50 80 00       	mov    0x805020,%eax
  80026d:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800273:	a1 20 50 80 00       	mov    0x805020,%eax
  800278:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80027e:	51                   	push   %ecx
  80027f:	52                   	push   %edx
  800280:	50                   	push   %eax
  800281:	68 4c 42 80 00       	push   $0x80424c
  800286:	e8 46 01 00 00       	call   8003d1 <cprintf>
  80028b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028e:	a1 20 50 80 00       	mov    0x805020,%eax
  800293:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800299:	83 ec 08             	sub    $0x8,%esp
  80029c:	50                   	push   %eax
  80029d:	68 a4 42 80 00       	push   $0x8042a4
  8002a2:	e8 2a 01 00 00       	call   8003d1 <cprintf>
  8002a7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002aa:	83 ec 0c             	sub    $0xc,%esp
  8002ad:	68 d8 41 80 00       	push   $0x8041d8
  8002b2:	e8 1a 01 00 00       	call   8003d1 <cprintf>
  8002b7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002ba:	e8 e7 29 00 00       	call   802ca6 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002bf:	e8 1f 00 00 00       	call   8002e3 <exit>
}
  8002c4:	90                   	nop
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	6a 00                	push   $0x0
  8002d8:	e8 f4 2b 00 00       	call   802ed1 <sys_destroy_env>
  8002dd:	83 c4 10             	add    $0x10,%esp
}
  8002e0:	90                   	nop
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <exit>:

void
exit(void)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e9:	e8 49 2c 00 00       	call   802f37 <sys_exit_env>
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	53                   	push   %ebx
  8002f5:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	8d 48 01             	lea    0x1(%eax),%ecx
  800300:	8b 55 0c             	mov    0xc(%ebp),%edx
  800303:	89 0a                	mov    %ecx,(%edx)
  800305:	8b 55 08             	mov    0x8(%ebp),%edx
  800308:	88 d1                	mov    %dl,%cl
  80030a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80030d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	8b 00                	mov    (%eax),%eax
  800316:	3d ff 00 00 00       	cmp    $0xff,%eax
  80031b:	75 30                	jne    80034d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80031d:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  800323:	a0 44 50 80 00       	mov    0x805044,%al
  800328:	0f b6 c0             	movzbl %al,%eax
  80032b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032e:	8b 09                	mov    (%ecx),%ecx
  800330:	89 cb                	mov    %ecx,%ebx
  800332:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800335:	83 c1 08             	add    $0x8,%ecx
  800338:	52                   	push   %edx
  800339:	50                   	push   %eax
  80033a:	53                   	push   %ebx
  80033b:	51                   	push   %ecx
  80033c:	e8 07 29 00 00       	call   802c48 <sys_cputs>
  800341:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800344:	8b 45 0c             	mov    0xc(%ebp),%eax
  800347:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80034d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800350:	8b 40 04             	mov    0x4(%eax),%eax
  800353:	8d 50 01             	lea    0x1(%eax),%edx
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
  800359:	89 50 04             	mov    %edx,0x4(%eax)
}
  80035c:	90                   	nop
  80035d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80036b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800372:	00 00 00 
	b.cnt = 0;
  800375:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80037c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80037f:	ff 75 0c             	pushl  0xc(%ebp)
  800382:	ff 75 08             	pushl  0x8(%ebp)
  800385:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80038b:	50                   	push   %eax
  80038c:	68 f1 02 80 00       	push   $0x8002f1
  800391:	e8 5a 02 00 00       	call   8005f0 <vprintfmt>
  800396:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800399:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  80039f:	a0 44 50 80 00       	mov    0x805044,%al
  8003a4:	0f b6 c0             	movzbl %al,%eax
  8003a7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003ad:	52                   	push   %edx
  8003ae:	50                   	push   %eax
  8003af:	51                   	push   %ecx
  8003b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003b6:	83 c0 08             	add    $0x8,%eax
  8003b9:	50                   	push   %eax
  8003ba:	e8 89 28 00 00       	call   802c48 <sys_cputs>
  8003bf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003c2:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8003c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003cf:	c9                   	leave  
  8003d0:	c3                   	ret    

008003d1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003d7:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8003de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ed:	50                   	push   %eax
  8003ee:	e8 6f ff ff ff       	call   800362 <vcprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800404:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	c1 e0 08             	shl    $0x8,%eax
  800411:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  800416:	8d 45 0c             	lea    0xc(%ebp),%eax
  800419:	83 c0 04             	add    $0x4,%eax
  80041c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	83 ec 08             	sub    $0x8,%esp
  800425:	ff 75 f4             	pushl  -0xc(%ebp)
  800428:	50                   	push   %eax
  800429:	e8 34 ff ff ff       	call   800362 <vcprintf>
  80042e:	83 c4 10             	add    $0x10,%esp
  800431:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800434:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  80043b:	07 00 00 

	return cnt;
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800449:	e8 3e 28 00 00       	call   802c8c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80044e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800451:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	ff 75 f4             	pushl  -0xc(%ebp)
  80045d:	50                   	push   %eax
  80045e:	e8 ff fe ff ff       	call   800362 <vcprintf>
  800463:	83 c4 10             	add    $0x10,%esp
  800466:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800469:	e8 38 28 00 00       	call   802ca6 <sys_unlock_cons>
	return cnt;
  80046e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	53                   	push   %ebx
  800477:	83 ec 14             	sub    $0x14,%esp
  80047a:	8b 45 10             	mov    0x10(%ebp),%eax
  80047d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800480:	8b 45 14             	mov    0x14(%ebp),%eax
  800483:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800486:	8b 45 18             	mov    0x18(%ebp),%eax
  800489:	ba 00 00 00 00       	mov    $0x0,%edx
  80048e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800491:	77 55                	ja     8004e8 <printnum+0x75>
  800493:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800496:	72 05                	jb     80049d <printnum+0x2a>
  800498:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80049b:	77 4b                	ja     8004e8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80049d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004a0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8004a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ab:	52                   	push   %edx
  8004ac:	50                   	push   %eax
  8004ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8004b3:	e8 70 3a 00 00       	call   803f28 <__udivdi3>
  8004b8:	83 c4 10             	add    $0x10,%esp
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	ff 75 20             	pushl  0x20(%ebp)
  8004c1:	53                   	push   %ebx
  8004c2:	ff 75 18             	pushl  0x18(%ebp)
  8004c5:	52                   	push   %edx
  8004c6:	50                   	push   %eax
  8004c7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ca:	ff 75 08             	pushl  0x8(%ebp)
  8004cd:	e8 a1 ff ff ff       	call   800473 <printnum>
  8004d2:	83 c4 20             	add    $0x20,%esp
  8004d5:	eb 1a                	jmp    8004f1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 20             	pushl  0x20(%ebp)
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	ff d0                	call   *%eax
  8004e5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e8:	ff 4d 1c             	decl   0x1c(%ebp)
  8004eb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004ef:	7f e6                	jg     8004d7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004f1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004ff:	53                   	push   %ebx
  800500:	51                   	push   %ecx
  800501:	52                   	push   %edx
  800502:	50                   	push   %eax
  800503:	e8 30 3b 00 00       	call   804038 <__umoddi3>
  800508:	83 c4 10             	add    $0x10,%esp
  80050b:	05 34 45 80 00       	add    $0x804534,%eax
  800510:	8a 00                	mov    (%eax),%al
  800512:	0f be c0             	movsbl %al,%eax
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	50                   	push   %eax
  80051c:	8b 45 08             	mov    0x8(%ebp),%eax
  80051f:	ff d0                	call   *%eax
  800521:	83 c4 10             	add    $0x10,%esp
}
  800524:	90                   	nop
  800525:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800528:	c9                   	leave  
  800529:	c3                   	ret    

0080052a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80052d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800531:	7e 1c                	jle    80054f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800533:	8b 45 08             	mov    0x8(%ebp),%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	8d 50 08             	lea    0x8(%eax),%edx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	89 10                	mov    %edx,(%eax)
  800540:	8b 45 08             	mov    0x8(%ebp),%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	83 e8 08             	sub    $0x8,%eax
  800548:	8b 50 04             	mov    0x4(%eax),%edx
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	eb 40                	jmp    80058f <getuint+0x65>
	else if (lflag)
  80054f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800553:	74 1e                	je     800573 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800555:	8b 45 08             	mov    0x8(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	8d 50 04             	lea    0x4(%eax),%edx
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	89 10                	mov    %edx,(%eax)
  800562:	8b 45 08             	mov    0x8(%ebp),%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	83 e8 04             	sub    $0x4,%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	ba 00 00 00 00       	mov    $0x0,%edx
  800571:	eb 1c                	jmp    80058f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	8d 50 04             	lea    0x4(%eax),%edx
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	89 10                	mov    %edx,(%eax)
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	83 e8 04             	sub    $0x4,%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80058f:	5d                   	pop    %ebp
  800590:	c3                   	ret    

00800591 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800591:	55                   	push   %ebp
  800592:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800594:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800598:	7e 1c                	jle    8005b6 <getint+0x25>
		return va_arg(*ap, long long);
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	8d 50 08             	lea    0x8(%eax),%edx
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	89 10                	mov    %edx,(%eax)
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	83 e8 08             	sub    $0x8,%eax
  8005af:	8b 50 04             	mov    0x4(%eax),%edx
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	eb 38                	jmp    8005ee <getint+0x5d>
	else if (lflag)
  8005b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ba:	74 1a                	je     8005d6 <getint+0x45>
		return va_arg(*ap, long);
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	8d 50 04             	lea    0x4(%eax),%edx
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	89 10                	mov    %edx,(%eax)
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	83 e8 04             	sub    $0x4,%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	99                   	cltd   
  8005d4:	eb 18                	jmp    8005ee <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	8d 50 04             	lea    0x4(%eax),%edx
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	89 10                	mov    %edx,(%eax)
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	83 e8 04             	sub    $0x4,%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	99                   	cltd   
}
  8005ee:	5d                   	pop    %ebp
  8005ef:	c3                   	ret    

008005f0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005f0:	55                   	push   %ebp
  8005f1:	89 e5                	mov    %esp,%ebp
  8005f3:	56                   	push   %esi
  8005f4:	53                   	push   %ebx
  8005f5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005f8:	eb 17                	jmp    800611 <vprintfmt+0x21>
			if (ch == '\0')
  8005fa:	85 db                	test   %ebx,%ebx
  8005fc:	0f 84 c1 03 00 00    	je     8009c3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 0c             	pushl  0xc(%ebp)
  800608:	53                   	push   %ebx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	ff d0                	call   *%eax
  80060e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800611:	8b 45 10             	mov    0x10(%ebp),%eax
  800614:	8d 50 01             	lea    0x1(%eax),%edx
  800617:	89 55 10             	mov    %edx,0x10(%ebp)
  80061a:	8a 00                	mov    (%eax),%al
  80061c:	0f b6 d8             	movzbl %al,%ebx
  80061f:	83 fb 25             	cmp    $0x25,%ebx
  800622:	75 d6                	jne    8005fa <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800624:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800628:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80062f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800636:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80063d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800644:	8b 45 10             	mov    0x10(%ebp),%eax
  800647:	8d 50 01             	lea    0x1(%eax),%edx
  80064a:	89 55 10             	mov    %edx,0x10(%ebp)
  80064d:	8a 00                	mov    (%eax),%al
  80064f:	0f b6 d8             	movzbl %al,%ebx
  800652:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800655:	83 f8 5b             	cmp    $0x5b,%eax
  800658:	0f 87 3d 03 00 00    	ja     80099b <vprintfmt+0x3ab>
  80065e:	8b 04 85 58 45 80 00 	mov    0x804558(,%eax,4),%eax
  800665:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800667:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80066b:	eb d7                	jmp    800644 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80066d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800671:	eb d1                	jmp    800644 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800673:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80067a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067d:	89 d0                	mov    %edx,%eax
  80067f:	c1 e0 02             	shl    $0x2,%eax
  800682:	01 d0                	add    %edx,%eax
  800684:	01 c0                	add    %eax,%eax
  800686:	01 d8                	add    %ebx,%eax
  800688:	83 e8 30             	sub    $0x30,%eax
  80068b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80068e:	8b 45 10             	mov    0x10(%ebp),%eax
  800691:	8a 00                	mov    (%eax),%al
  800693:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800696:	83 fb 2f             	cmp    $0x2f,%ebx
  800699:	7e 3e                	jle    8006d9 <vprintfmt+0xe9>
  80069b:	83 fb 39             	cmp    $0x39,%ebx
  80069e:	7f 39                	jg     8006d9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006a0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006a3:	eb d5                	jmp    80067a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	83 c0 04             	add    $0x4,%eax
  8006ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	83 e8 04             	sub    $0x4,%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006b9:	eb 1f                	jmp    8006da <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bf:	79 83                	jns    800644 <vprintfmt+0x54>
				width = 0;
  8006c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006c8:	e9 77 ff ff ff       	jmp    800644 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006cd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006d4:	e9 6b ff ff ff       	jmp    800644 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006d9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006de:	0f 89 60 ff ff ff    	jns    800644 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006f1:	e9 4e ff ff ff       	jmp    800644 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006f6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006f9:	e9 46 ff ff ff       	jmp    800644 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	83 c0 04             	add    $0x4,%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	83 e8 04             	sub    $0x4,%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	50                   	push   %eax
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	ff d0                	call   *%eax
  80071b:	83 c4 10             	add    $0x10,%esp
			break;
  80071e:	e9 9b 02 00 00       	jmp    8009be <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	83 c0 04             	add    $0x4,%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	83 e8 04             	sub    $0x4,%eax
  800732:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800734:	85 db                	test   %ebx,%ebx
  800736:	79 02                	jns    80073a <vprintfmt+0x14a>
				err = -err;
  800738:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80073a:	83 fb 64             	cmp    $0x64,%ebx
  80073d:	7f 0b                	jg     80074a <vprintfmt+0x15a>
  80073f:	8b 34 9d a0 43 80 00 	mov    0x8043a0(,%ebx,4),%esi
  800746:	85 f6                	test   %esi,%esi
  800748:	75 19                	jne    800763 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80074a:	53                   	push   %ebx
  80074b:	68 45 45 80 00       	push   $0x804545
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	ff 75 08             	pushl  0x8(%ebp)
  800756:	e8 70 02 00 00       	call   8009cb <printfmt>
  80075b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80075e:	e9 5b 02 00 00       	jmp    8009be <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800763:	56                   	push   %esi
  800764:	68 4e 45 80 00       	push   $0x80454e
  800769:	ff 75 0c             	pushl  0xc(%ebp)
  80076c:	ff 75 08             	pushl  0x8(%ebp)
  80076f:	e8 57 02 00 00       	call   8009cb <printfmt>
  800774:	83 c4 10             	add    $0x10,%esp
			break;
  800777:	e9 42 02 00 00       	jmp    8009be <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	83 c0 04             	add    $0x4,%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	83 e8 04             	sub    $0x4,%eax
  80078b:	8b 30                	mov    (%eax),%esi
  80078d:	85 f6                	test   %esi,%esi
  80078f:	75 05                	jne    800796 <vprintfmt+0x1a6>
				p = "(null)";
  800791:	be 51 45 80 00       	mov    $0x804551,%esi
			if (width > 0 && padc != '-')
  800796:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80079a:	7e 6d                	jle    800809 <vprintfmt+0x219>
  80079c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007a0:	74 67                	je     800809 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	50                   	push   %eax
  8007a9:	56                   	push   %esi
  8007aa:	e8 1e 03 00 00       	call   800acd <strnlen>
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007b5:	eb 16                	jmp    8007cd <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007b7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	50                   	push   %eax
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	ff d0                	call   *%eax
  8007c7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ca:	ff 4d e4             	decl   -0x1c(%ebp)
  8007cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d1:	7f e4                	jg     8007b7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007d3:	eb 34                	jmp    800809 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007d9:	74 1c                	je     8007f7 <vprintfmt+0x207>
  8007db:	83 fb 1f             	cmp    $0x1f,%ebx
  8007de:	7e 05                	jle    8007e5 <vprintfmt+0x1f5>
  8007e0:	83 fb 7e             	cmp    $0x7e,%ebx
  8007e3:	7e 12                	jle    8007f7 <vprintfmt+0x207>
					putch('?', putdat);
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 0c             	pushl  0xc(%ebp)
  8007eb:	6a 3f                	push   $0x3f
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	ff d0                	call   *%eax
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	eb 0f                	jmp    800806 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	53                   	push   %ebx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	ff d0                	call   *%eax
  800803:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800806:	ff 4d e4             	decl   -0x1c(%ebp)
  800809:	89 f0                	mov    %esi,%eax
  80080b:	8d 70 01             	lea    0x1(%eax),%esi
  80080e:	8a 00                	mov    (%eax),%al
  800810:	0f be d8             	movsbl %al,%ebx
  800813:	85 db                	test   %ebx,%ebx
  800815:	74 24                	je     80083b <vprintfmt+0x24b>
  800817:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80081b:	78 b8                	js     8007d5 <vprintfmt+0x1e5>
  80081d:	ff 4d e0             	decl   -0x20(%ebp)
  800820:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800824:	79 af                	jns    8007d5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800826:	eb 13                	jmp    80083b <vprintfmt+0x24b>
				putch(' ', putdat);
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	6a 20                	push   $0x20
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	ff d0                	call   *%eax
  800835:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800838:	ff 4d e4             	decl   -0x1c(%ebp)
  80083b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083f:	7f e7                	jg     800828 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800841:	e9 78 01 00 00       	jmp    8009be <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	ff 75 e8             	pushl  -0x18(%ebp)
  80084c:	8d 45 14             	lea    0x14(%ebp),%eax
  80084f:	50                   	push   %eax
  800850:	e8 3c fd ff ff       	call   800591 <getint>
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80085e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800861:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800864:	85 d2                	test   %edx,%edx
  800866:	79 23                	jns    80088b <vprintfmt+0x29b>
				putch('-', putdat);
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	6a 2d                	push   $0x2d
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80087e:	f7 d8                	neg    %eax
  800880:	83 d2 00             	adc    $0x0,%edx
  800883:	f7 da                	neg    %edx
  800885:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800888:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80088b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800892:	e9 bc 00 00 00       	jmp    800953 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	ff 75 e8             	pushl  -0x18(%ebp)
  80089d:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a0:	50                   	push   %eax
  8008a1:	e8 84 fc ff ff       	call   80052a <getuint>
  8008a6:	83 c4 10             	add    $0x10,%esp
  8008a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008af:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008b6:	e9 98 00 00 00       	jmp    800953 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	6a 58                	push   $0x58
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	6a 58                	push   $0x58
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	ff d0                	call   *%eax
  8008d8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	6a 58                	push   $0x58
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	ff d0                	call   *%eax
  8008e8:	83 c4 10             	add    $0x10,%esp
			break;
  8008eb:	e9 ce 00 00 00       	jmp    8009be <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	6a 30                	push   $0x30
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	ff d0                	call   *%eax
  8008fd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	6a 78                	push   $0x78
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	ff d0                	call   *%eax
  80090d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800910:	8b 45 14             	mov    0x14(%ebp),%eax
  800913:	83 c0 04             	add    $0x4,%eax
  800916:	89 45 14             	mov    %eax,0x14(%ebp)
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	83 e8 04             	sub    $0x4,%eax
  80091f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800921:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800924:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80092b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800932:	eb 1f                	jmp    800953 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 e8             	pushl  -0x18(%ebp)
  80093a:	8d 45 14             	lea    0x14(%ebp),%eax
  80093d:	50                   	push   %eax
  80093e:	e8 e7 fb ff ff       	call   80052a <getuint>
  800943:	83 c4 10             	add    $0x10,%esp
  800946:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800949:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80094c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800953:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800957:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	52                   	push   %edx
  80095e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800961:	50                   	push   %eax
  800962:	ff 75 f4             	pushl  -0xc(%ebp)
  800965:	ff 75 f0             	pushl  -0x10(%ebp)
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	ff 75 08             	pushl  0x8(%ebp)
  80096e:	e8 00 fb ff ff       	call   800473 <printnum>
  800973:	83 c4 20             	add    $0x20,%esp
			break;
  800976:	eb 46                	jmp    8009be <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	53                   	push   %ebx
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
			break;
  800987:	eb 35                	jmp    8009be <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800989:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800990:	eb 2c                	jmp    8009be <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800992:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800999:	eb 23                	jmp    8009be <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	6a 25                	push   $0x25
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	ff d0                	call   *%eax
  8009a8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009ab:	ff 4d 10             	decl   0x10(%ebp)
  8009ae:	eb 03                	jmp    8009b3 <vprintfmt+0x3c3>
  8009b0:	ff 4d 10             	decl   0x10(%ebp)
  8009b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b6:	48                   	dec    %eax
  8009b7:	8a 00                	mov    (%eax),%al
  8009b9:	3c 25                	cmp    $0x25,%al
  8009bb:	75 f3                	jne    8009b0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009bd:	90                   	nop
		}
	}
  8009be:	e9 35 fc ff ff       	jmp    8005f8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009c3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009d1:	8d 45 10             	lea    0x10(%ebp),%eax
  8009d4:	83 c0 04             	add    $0x4,%eax
  8009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009da:	8b 45 10             	mov    0x10(%ebp),%eax
  8009dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e0:	50                   	push   %eax
  8009e1:	ff 75 0c             	pushl  0xc(%ebp)
  8009e4:	ff 75 08             	pushl  0x8(%ebp)
  8009e7:	e8 04 fc ff ff       	call   8005f0 <vprintfmt>
  8009ec:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009ef:	90                   	nop
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	8b 40 08             	mov    0x8(%eax),%eax
  8009fb:	8d 50 01             	lea    0x1(%eax),%edx
  8009fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a01:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a07:	8b 10                	mov    (%eax),%edx
  800a09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0c:	8b 40 04             	mov    0x4(%eax),%eax
  800a0f:	39 c2                	cmp    %eax,%edx
  800a11:	73 12                	jae    800a25 <sprintputch+0x33>
		*b->buf++ = ch;
  800a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a16:	8b 00                	mov    (%eax),%eax
  800a18:	8d 48 01             	lea    0x1(%eax),%ecx
  800a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1e:	89 0a                	mov    %ecx,(%edx)
  800a20:	8b 55 08             	mov    0x8(%ebp),%edx
  800a23:	88 10                	mov    %dl,(%eax)
}
  800a25:	90                   	nop
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	01 d0                	add    %edx,%eax
  800a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a4d:	74 06                	je     800a55 <vsnprintf+0x2d>
  800a4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a53:	7f 07                	jg     800a5c <vsnprintf+0x34>
		return -E_INVAL;
  800a55:	b8 03 00 00 00       	mov    $0x3,%eax
  800a5a:	eb 20                	jmp    800a7c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a5c:	ff 75 14             	pushl  0x14(%ebp)
  800a5f:	ff 75 10             	pushl  0x10(%ebp)
  800a62:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a65:	50                   	push   %eax
  800a66:	68 f2 09 80 00       	push   $0x8009f2
  800a6b:	e8 80 fb ff ff       	call   8005f0 <vprintfmt>
  800a70:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a76:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    

00800a7e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a84:	8d 45 10             	lea    0x10(%ebp),%eax
  800a87:	83 c0 04             	add    $0x4,%eax
  800a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a90:	ff 75 f4             	pushl  -0xc(%ebp)
  800a93:	50                   	push   %eax
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	ff 75 08             	pushl  0x8(%ebp)
  800a9a:	e8 89 ff ff ff       	call   800a28 <vsnprintf>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa8:	c9                   	leave  
  800aa9:	c3                   	ret    

00800aaa <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ab7:	eb 06                	jmp    800abf <strlen+0x15>
		n++;
  800ab9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800abc:	ff 45 08             	incl   0x8(%ebp)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	84 c0                	test   %al,%al
  800ac6:	75 f1                	jne    800ab9 <strlen+0xf>
		n++;
	return n;
  800ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ada:	eb 09                	jmp    800ae5 <strnlen+0x18>
		n++;
  800adc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800adf:	ff 45 08             	incl   0x8(%ebp)
  800ae2:	ff 4d 0c             	decl   0xc(%ebp)
  800ae5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae9:	74 09                	je     800af4 <strnlen+0x27>
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8a 00                	mov    (%eax),%al
  800af0:	84 c0                	test   %al,%al
  800af2:	75 e8                	jne    800adc <strnlen+0xf>
		n++;
	return n;
  800af4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800af7:	c9                   	leave  
  800af8:	c3                   	ret    

00800af9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b05:	90                   	nop
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	8d 50 01             	lea    0x1(%eax),%edx
  800b0c:	89 55 08             	mov    %edx,0x8(%ebp)
  800b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b12:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b15:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b18:	8a 12                	mov    (%edx),%dl
  800b1a:	88 10                	mov    %dl,(%eax)
  800b1c:	8a 00                	mov    (%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 e4                	jne    800b06 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    

00800b27 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b3a:	eb 1f                	jmp    800b5b <strncpy+0x34>
		*dst++ = *src;
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8d 50 01             	lea    0x1(%eax),%edx
  800b42:	89 55 08             	mov    %edx,0x8(%ebp)
  800b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b48:	8a 12                	mov    (%edx),%dl
  800b4a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	8a 00                	mov    (%eax),%al
  800b51:	84 c0                	test   %al,%al
  800b53:	74 03                	je     800b58 <strncpy+0x31>
			src++;
  800b55:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b58:	ff 45 fc             	incl   -0x4(%ebp)
  800b5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b5e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b61:	72 d9                	jb     800b3c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b63:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b66:	c9                   	leave  
  800b67:	c3                   	ret    

00800b68 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b78:	74 30                	je     800baa <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b7a:	eb 16                	jmp    800b92 <strlcpy+0x2a>
			*dst++ = *src++;
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8d 50 01             	lea    0x1(%eax),%edx
  800b82:	89 55 08             	mov    %edx,0x8(%ebp)
  800b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b8b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b8e:	8a 12                	mov    (%edx),%dl
  800b90:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b92:	ff 4d 10             	decl   0x10(%ebp)
  800b95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b99:	74 09                	je     800ba4 <strlcpy+0x3c>
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	84 c0                	test   %al,%al
  800ba2:	75 d8                	jne    800b7c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800baa:	8b 55 08             	mov    0x8(%ebp),%edx
  800bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb0:	29 c2                	sub    %eax,%edx
  800bb2:	89 d0                	mov    %edx,%eax
}
  800bb4:	c9                   	leave  
  800bb5:	c3                   	ret    

00800bb6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bb9:	eb 06                	jmp    800bc1 <strcmp+0xb>
		p++, q++;
  800bbb:	ff 45 08             	incl   0x8(%ebp)
  800bbe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8a 00                	mov    (%eax),%al
  800bc6:	84 c0                	test   %al,%al
  800bc8:	74 0e                	je     800bd8 <strcmp+0x22>
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8a 10                	mov    (%eax),%dl
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	8a 00                	mov    (%eax),%al
  800bd4:	38 c2                	cmp    %al,%dl
  800bd6:	74 e3                	je     800bbb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8a 00                	mov    (%eax),%al
  800bdd:	0f b6 d0             	movzbl %al,%edx
  800be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be3:	8a 00                	mov    (%eax),%al
  800be5:	0f b6 c0             	movzbl %al,%eax
  800be8:	29 c2                	sub    %eax,%edx
  800bea:	89 d0                	mov    %edx,%eax
}
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800bf1:	eb 09                	jmp    800bfc <strncmp+0xe>
		n--, p++, q++;
  800bf3:	ff 4d 10             	decl   0x10(%ebp)
  800bf6:	ff 45 08             	incl   0x8(%ebp)
  800bf9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800bfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c00:	74 17                	je     800c19 <strncmp+0x2b>
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8a 00                	mov    (%eax),%al
  800c07:	84 c0                	test   %al,%al
  800c09:	74 0e                	je     800c19 <strncmp+0x2b>
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8a 10                	mov    (%eax),%dl
  800c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	38 c2                	cmp    %al,%dl
  800c17:	74 da                	je     800bf3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c1d:	75 07                	jne    800c26 <strncmp+0x38>
		return 0;
  800c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c24:	eb 14                	jmp    800c3a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8a 00                	mov    (%eax),%al
  800c2b:	0f b6 d0             	movzbl %al,%edx
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8a 00                	mov    (%eax),%al
  800c33:	0f b6 c0             	movzbl %al,%eax
  800c36:	29 c2                	sub    %eax,%edx
  800c38:	89 d0                	mov    %edx,%eax
}
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	83 ec 04             	sub    $0x4,%esp
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c48:	eb 12                	jmp    800c5c <strchr+0x20>
		if (*s == c)
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c52:	75 05                	jne    800c59 <strchr+0x1d>
			return (char *) s;
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	eb 11                	jmp    800c6a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c59:	ff 45 08             	incl   0x8(%ebp)
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	8a 00                	mov    (%eax),%al
  800c61:	84 c0                	test   %al,%al
  800c63:	75 e5                	jne    800c4a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 04             	sub    $0x4,%esp
  800c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c75:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c78:	eb 0d                	jmp    800c87 <strfind+0x1b>
		if (*s == c)
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c82:	74 0e                	je     800c92 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c84:	ff 45 08             	incl   0x8(%ebp)
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8a 00                	mov    (%eax),%al
  800c8c:	84 c0                	test   %al,%al
  800c8e:	75 ea                	jne    800c7a <strfind+0xe>
  800c90:	eb 01                	jmp    800c93 <strfind+0x27>
		if (*s == c)
			break;
  800c92:	90                   	nop
	return (char *) s;
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ca4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ca8:	76 63                	jbe    800d0d <memset+0x75>
		uint64 data_block = c;
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	99                   	cltd   
  800cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cba:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800cbe:	c1 e0 08             	shl    $0x8,%eax
  800cc1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cc4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccd:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800cd1:	c1 e0 10             	shl    $0x10,%eax
  800cd4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cd7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce0:	89 c2                	mov    %eax,%edx
  800ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cea:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ced:	eb 18                	jmp    800d07 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800cef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800cf2:	8d 41 08             	lea    0x8(%ecx),%eax
  800cf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cfe:	89 01                	mov    %eax,(%ecx)
  800d00:	89 51 04             	mov    %edx,0x4(%ecx)
  800d03:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800d07:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d0b:	77 e2                	ja     800cef <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800d0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d11:	74 23                	je     800d36 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d16:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d19:	eb 0e                	jmp    800d29 <memset+0x91>
			*p8++ = (uint8)c;
  800d1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1e:	8d 50 01             	lea    0x1(%eax),%edx
  800d21:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d27:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800d29:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	75 e5                	jne    800d1b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d39:	c9                   	leave  
  800d3a:	c3                   	ret    

00800d3b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800d4d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d51:	76 24                	jbe    800d77 <memcpy+0x3c>
		while(n >= 8){
  800d53:	eb 1c                	jmp    800d71 <memcpy+0x36>
			*d64 = *s64;
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	8b 50 04             	mov    0x4(%eax),%edx
  800d5b:	8b 00                	mov    (%eax),%eax
  800d5d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800d60:	89 01                	mov    %eax,(%ecx)
  800d62:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800d65:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800d69:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800d6d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800d71:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d75:	77 de                	ja     800d55 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7b:	74 31                	je     800dae <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d89:	eb 16                	jmp    800da1 <memcpy+0x66>
			*d8++ = *s8++;
  800d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d8e:	8d 50 01             	lea    0x1(%eax),%edx
  800d91:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d97:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d9d:	8a 12                	mov    (%edx),%dl
  800d9f:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da7:	89 55 10             	mov    %edx,0x10(%ebp)
  800daa:	85 c0                	test   %eax,%eax
  800dac:	75 dd                	jne    800d8b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dcb:	73 50                	jae    800e1d <memmove+0x6a>
  800dcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd3:	01 d0                	add    %edx,%eax
  800dd5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dd8:	76 43                	jbe    800e1d <memmove+0x6a>
		s += n;
  800dda:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800de0:	8b 45 10             	mov    0x10(%ebp),%eax
  800de3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800de6:	eb 10                	jmp    800df8 <memmove+0x45>
			*--d = *--s;
  800de8:	ff 4d f8             	decl   -0x8(%ebp)
  800deb:	ff 4d fc             	decl   -0x4(%ebp)
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	8a 10                	mov    (%eax),%dl
  800df3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800df8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfe:	89 55 10             	mov    %edx,0x10(%ebp)
  800e01:	85 c0                	test   %eax,%eax
  800e03:	75 e3                	jne    800de8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e05:	eb 23                	jmp    800e2a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0a:	8d 50 01             	lea    0x1(%eax),%edx
  800e0d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e10:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e13:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e16:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e19:	8a 12                	mov    (%edx),%dl
  800e1b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e20:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e23:	89 55 10             	mov    %edx,0x10(%ebp)
  800e26:	85 c0                	test   %eax,%eax
  800e28:	75 dd                	jne    800e07 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e41:	eb 2a                	jmp    800e6d <memcmp+0x3e>
		if (*s1 != *s2)
  800e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e46:	8a 10                	mov    (%eax),%dl
  800e48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	38 c2                	cmp    %al,%dl
  800e4f:	74 16                	je     800e67 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	0f b6 d0             	movzbl %al,%edx
  800e59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	0f b6 c0             	movzbl %al,%eax
  800e61:	29 c2                	sub    %eax,%edx
  800e63:	89 d0                	mov    %edx,%eax
  800e65:	eb 18                	jmp    800e7f <memcmp+0x50>
		s1++, s2++;
  800e67:	ff 45 fc             	incl   -0x4(%ebp)
  800e6a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e73:	89 55 10             	mov    %edx,0x10(%ebp)
  800e76:	85 c0                	test   %eax,%eax
  800e78:	75 c9                	jne    800e43 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e7f:	c9                   	leave  
  800e80:	c3                   	ret    

00800e81 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e87:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8d:	01 d0                	add    %edx,%eax
  800e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e92:	eb 15                	jmp    800ea9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	0f b6 d0             	movzbl %al,%edx
  800e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9f:	0f b6 c0             	movzbl %al,%eax
  800ea2:	39 c2                	cmp    %eax,%edx
  800ea4:	74 0d                	je     800eb3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ea6:	ff 45 08             	incl   0x8(%ebp)
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eaf:	72 e3                	jb     800e94 <memfind+0x13>
  800eb1:	eb 01                	jmp    800eb4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eb3:	90                   	nop
	return (void *) s;
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ebf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ec6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ecd:	eb 03                	jmp    800ed2 <strtol+0x19>
		s++;
  800ecf:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3c 20                	cmp    $0x20,%al
  800ed9:	74 f4                	je     800ecf <strtol+0x16>
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	3c 09                	cmp    $0x9,%al
  800ee2:	74 eb                	je     800ecf <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	3c 2b                	cmp    $0x2b,%al
  800eeb:	75 05                	jne    800ef2 <strtol+0x39>
		s++;
  800eed:	ff 45 08             	incl   0x8(%ebp)
  800ef0:	eb 13                	jmp    800f05 <strtol+0x4c>
	else if (*s == '-')
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	3c 2d                	cmp    $0x2d,%al
  800ef9:	75 0a                	jne    800f05 <strtol+0x4c>
		s++, neg = 1;
  800efb:	ff 45 08             	incl   0x8(%ebp)
  800efe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f09:	74 06                	je     800f11 <strtol+0x58>
  800f0b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f0f:	75 20                	jne    800f31 <strtol+0x78>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	3c 30                	cmp    $0x30,%al
  800f18:	75 17                	jne    800f31 <strtol+0x78>
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	40                   	inc    %eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 78                	cmp    $0x78,%al
  800f22:	75 0d                	jne    800f31 <strtol+0x78>
		s += 2, base = 16;
  800f24:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f28:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f2f:	eb 28                	jmp    800f59 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f35:	75 15                	jne    800f4c <strtol+0x93>
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 30                	cmp    $0x30,%al
  800f3e:	75 0c                	jne    800f4c <strtol+0x93>
		s++, base = 8;
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f4a:	eb 0d                	jmp    800f59 <strtol+0xa0>
	else if (base == 0)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	75 07                	jne    800f59 <strtol+0xa0>
		base = 10;
  800f52:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 2f                	cmp    $0x2f,%al
  800f60:	7e 19                	jle    800f7b <strtol+0xc2>
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	3c 39                	cmp    $0x39,%al
  800f69:	7f 10                	jg     800f7b <strtol+0xc2>
			dig = *s - '0';
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	0f be c0             	movsbl %al,%eax
  800f73:	83 e8 30             	sub    $0x30,%eax
  800f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f79:	eb 42                	jmp    800fbd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	3c 60                	cmp    $0x60,%al
  800f82:	7e 19                	jle    800f9d <strtol+0xe4>
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	3c 7a                	cmp    $0x7a,%al
  800f8b:	7f 10                	jg     800f9d <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	0f be c0             	movsbl %al,%eax
  800f95:	83 e8 57             	sub    $0x57,%eax
  800f98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f9b:	eb 20                	jmp    800fbd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 40                	cmp    $0x40,%al
  800fa4:	7e 39                	jle    800fdf <strtol+0x126>
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	3c 5a                	cmp    $0x5a,%al
  800fad:	7f 30                	jg     800fdf <strtol+0x126>
			dig = *s - 'A' + 10;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	0f be c0             	movsbl %al,%eax
  800fb7:	83 e8 37             	sub    $0x37,%eax
  800fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fc3:	7d 19                	jge    800fde <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fc5:	ff 45 08             	incl   0x8(%ebp)
  800fc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fd9:	e9 7b ff ff ff       	jmp    800f59 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fde:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fe3:	74 08                	je     800fed <strtol+0x134>
		*endptr = (char *) s;
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	8b 55 08             	mov    0x8(%ebp),%edx
  800feb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ff1:	74 07                	je     800ffa <strtol+0x141>
  800ff3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff6:	f7 d8                	neg    %eax
  800ff8:	eb 03                	jmp    800ffd <strtol+0x144>
  800ffa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    

00800fff <ltostr>:

void
ltostr(long value, char *str)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801005:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80100c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801013:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801017:	79 13                	jns    80102c <ltostr+0x2d>
	{
		neg = 1;
  801019:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801026:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801029:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801034:	99                   	cltd   
  801035:	f7 f9                	idiv   %ecx
  801037:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80103a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103d:	8d 50 01             	lea    0x1(%eax),%edx
  801040:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801043:	89 c2                	mov    %eax,%edx
  801045:	8b 45 0c             	mov    0xc(%ebp),%eax
  801048:	01 d0                	add    %edx,%eax
  80104a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80104d:	83 c2 30             	add    $0x30,%edx
  801050:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801052:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801055:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80105a:	f7 e9                	imul   %ecx
  80105c:	c1 fa 02             	sar    $0x2,%edx
  80105f:	89 c8                	mov    %ecx,%eax
  801061:	c1 f8 1f             	sar    $0x1f,%eax
  801064:	29 c2                	sub    %eax,%edx
  801066:	89 d0                	mov    %edx,%eax
  801068:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80106b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106f:	75 bb                	jne    80102c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801071:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801078:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107b:	48                   	dec    %eax
  80107c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80107f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801083:	74 3d                	je     8010c2 <ltostr+0xc3>
		start = 1 ;
  801085:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80108c:	eb 34                	jmp    8010c2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80108e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	01 d0                	add    %edx,%eax
  801096:	8a 00                	mov    (%eax),%al
  801098:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80109b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80109e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a1:	01 c2                	add    %eax,%edx
  8010a3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a9:	01 c8                	add    %ecx,%eax
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	01 c2                	add    %eax,%edx
  8010b7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010ba:	88 02                	mov    %al,(%edx)
		start++ ;
  8010bc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010bf:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010c8:	7c c4                	jl     80108e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	01 d0                	add    %edx,%eax
  8010d2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010d5:	90                   	nop
  8010d6:	c9                   	leave  
  8010d7:	c3                   	ret    

008010d8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010de:	ff 75 08             	pushl  0x8(%ebp)
  8010e1:	e8 c4 f9 ff ff       	call   800aaa <strlen>
  8010e6:	83 c4 04             	add    $0x4,%esp
  8010e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010ec:	ff 75 0c             	pushl  0xc(%ebp)
  8010ef:	e8 b6 f9 ff ff       	call   800aaa <strlen>
  8010f4:	83 c4 04             	add    $0x4,%esp
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801108:	eb 17                	jmp    801121 <strcconcat+0x49>
		final[s] = str1[s] ;
  80110a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110d:	8b 45 10             	mov    0x10(%ebp),%eax
  801110:	01 c2                	add    %eax,%edx
  801112:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	01 c8                	add    %ecx,%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80111e:	ff 45 fc             	incl   -0x4(%ebp)
  801121:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801124:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801127:	7c e1                	jl     80110a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801129:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801130:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801137:	eb 1f                	jmp    801158 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801139:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113c:	8d 50 01             	lea    0x1(%eax),%edx
  80113f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801142:	89 c2                	mov    %eax,%edx
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	01 c2                	add    %eax,%edx
  801149:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	01 c8                	add    %ecx,%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801155:	ff 45 f8             	incl   -0x8(%ebp)
  801158:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80115e:	7c d9                	jl     801139 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801160:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801163:	8b 45 10             	mov    0x10(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	c6 00 00             	movb   $0x0,(%eax)
}
  80116b:	90                   	nop
  80116c:	c9                   	leave  
  80116d:	c3                   	ret    

0080116e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801171:	8b 45 14             	mov    0x14(%ebp),%eax
  801174:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80117a:	8b 45 14             	mov    0x14(%ebp),%eax
  80117d:	8b 00                	mov    (%eax),%eax
  80117f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801186:	8b 45 10             	mov    0x10(%ebp),%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801191:	eb 0c                	jmp    80119f <strsplit+0x31>
			*string++ = 0;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8d 50 01             	lea    0x1(%eax),%edx
  801199:	89 55 08             	mov    %edx,0x8(%ebp)
  80119c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 18                	je     8011c0 <strsplit+0x52>
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f be c0             	movsbl %al,%eax
  8011b0:	50                   	push   %eax
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 83 fa ff ff       	call   800c3c <strchr>
  8011b9:	83 c4 08             	add    $0x8,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	75 d3                	jne    801193 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	84 c0                	test   %al,%al
  8011c7:	74 5a                	je     801223 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cc:	8b 00                	mov    (%eax),%eax
  8011ce:	83 f8 0f             	cmp    $0xf,%eax
  8011d1:	75 07                	jne    8011da <strsplit+0x6c>
		{
			return 0;
  8011d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d8:	eb 66                	jmp    801240 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011da:	8b 45 14             	mov    0x14(%ebp),%eax
  8011dd:	8b 00                	mov    (%eax),%eax
  8011df:	8d 48 01             	lea    0x1(%eax),%ecx
  8011e2:	8b 55 14             	mov    0x14(%ebp),%edx
  8011e5:	89 0a                	mov    %ecx,(%edx)
  8011e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f1:	01 c2                	add    %eax,%edx
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011f8:	eb 03                	jmp    8011fd <strsplit+0x8f>
			string++;
  8011fa:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	84 c0                	test   %al,%al
  801204:	74 8b                	je     801191 <strsplit+0x23>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	0f be c0             	movsbl %al,%eax
  80120e:	50                   	push   %eax
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	e8 25 fa ff ff       	call   800c3c <strchr>
  801217:	83 c4 08             	add    $0x8,%esp
  80121a:	85 c0                	test   %eax,%eax
  80121c:	74 dc                	je     8011fa <strsplit+0x8c>
			string++;
	}
  80121e:	e9 6e ff ff ff       	jmp    801191 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801223:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801224:	8b 45 14             	mov    0x14(%ebp),%eax
  801227:	8b 00                	mov    (%eax),%eax
  801229:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80123b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80124e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801255:	eb 4a                	jmp    8012a1 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801257:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	01 c2                	add    %eax,%edx
  80125f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	01 c8                	add    %ecx,%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80126b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 d0                	add    %edx,%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 40                	cmp    $0x40,%al
  801277:	7e 25                	jle    80129e <str2lower+0x5c>
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 5a                	cmp    $0x5a,%al
  801285:	7f 17                	jg     80129e <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801287:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	01 d0                	add    %edx,%eax
  80128f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801292:	8b 55 08             	mov    0x8(%ebp),%edx
  801295:	01 ca                	add    %ecx,%edx
  801297:	8a 12                	mov    (%edx),%dl
  801299:	83 c2 20             	add    $0x20,%edx
  80129c:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80129e:	ff 45 fc             	incl   -0x4(%ebp)
  8012a1:	ff 75 0c             	pushl  0xc(%ebp)
  8012a4:	e8 01 f8 ff ff       	call   800aaa <strlen>
  8012a9:	83 c4 04             	add    $0x4,%esp
  8012ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012af:	7f a6                	jg     801257 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8012b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8012bc:	a1 08 50 80 00       	mov    0x805008,%eax
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	0f 84 95 00 00 00    	je     80135e <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8012c9:	83 ec 08             	sub    $0x8,%esp
  8012cc:	68 00 00 00 82       	push   $0x82000000
  8012d1:	68 00 00 00 80       	push   $0x80000000
  8012d6:	e8 59 1f 00 00       	call   803234 <initialize_dynamic_allocator>
  8012db:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8012de:	e8 93 1d 00 00       	call   803076 <sys_get_uheap_strategy>
  8012e3:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8012e8:	a1 40 50 80 00       	mov    0x805040,%eax
  8012ed:	05 00 10 00 00       	add    $0x1000,%eax
  8012f2:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  8012f7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8012fc:	a3 68 d0 81 00       	mov    %eax,0x81d068
		init_uspinlock(&ulock,"malloc",1);
  801301:	83 ec 04             	sub    $0x4,%esp
  801304:	6a 01                	push   $0x1
  801306:	68 c8 46 80 00       	push   $0x8046c8
  80130b:	68 40 d1 81 00       	push   $0x81d140
  801310:	e8 1a 29 00 00       	call   803c2f <init_uspinlock>
  801315:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801318:	c7 05 20 d1 81 00 00 	movl   $0x0,0x81d120
  80131f:	00 00 00 
  801322:	c7 05 24 d1 81 00 00 	movl   $0x0,0x81d124
  801329:	00 00 00 
  80132c:	c7 05 2c d1 81 00 00 	movl   $0x0,0x81d12c
  801333:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801336:	c7 05 30 d1 81 00 00 	movl   $0x0,0x81d130
  80133d:	00 00 00 
  801340:	c7 05 34 d1 81 00 00 	movl   $0x0,0x81d134
  801347:	00 00 00 
  80134a:	c7 05 3c d1 81 00 00 	movl   $0x0,0x81d13c
  801351:	00 00 00 
		__firstTimeFlag = 0;
  801354:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80135b:	00 00 00 
	}
}
  80135e:	90                   	nop
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80136d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801370:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801375:	83 ec 08             	sub    $0x8,%esp
  801378:	68 06 04 00 00       	push   $0x406
  80137d:	50                   	push   %eax
  80137e:	e8 3d 19 00 00       	call   802cc0 <__sys_allocate_page>
  801383:	83 c4 10             	add    $0x10,%esp
  801386:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801389:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138d:	79 14                	jns    8013a3 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80138f:	83 ec 04             	sub    $0x4,%esp
  801392:	68 d0 46 80 00       	push   $0x8046d0
  801397:	6a 2d                	push   $0x2d
  801399:	68 0c 47 80 00       	push   $0x80470c
  80139e:	e8 94 29 00 00       	call   803d37 <_panic>
	return 0;
  8013a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013be:	83 ec 0c             	sub    $0xc,%esp
  8013c1:	50                   	push   %eax
  8013c2:	e8 40 19 00 00       	call   802d07 <__sys_unmap_frame>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8013cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013d1:	79 14                	jns    8013e7 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	68 18 47 80 00       	push   $0x804718
  8013db:	6a 38                	push   $0x38
  8013dd:	68 0c 47 80 00       	push   $0x80470c
  8013e2:	e8 50 29 00 00       	call   803d37 <_panic>
}
  8013e7:	90                   	nop
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8013f0:	e8 c1 fe ff ff       	call   8012b6 <uheap_init>
	if (size == 0) return NULL ;
  8013f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f9:	75 0a                	jne    801405 <malloc+0x1b>
  8013fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801400:	e9 e1 04 00 00       	jmp    8018e6 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801405:	83 ec 0c             	sub    $0xc,%esp
  801408:	68 40 d1 81 00       	push   $0x81d140
  80140d:	e8 6c 28 00 00       	call   803c7e <acquire_uspinlock>
  801412:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801415:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  80141c:	77 23                	ja     801441 <malloc+0x57>
		release_uspinlock(&ulock);
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	68 40 d1 81 00       	push   $0x81d140
  801426:	e8 ab 28 00 00       	call   803cd6 <release_uspinlock>
  80142b:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  80142e:	83 ec 0c             	sub    $0xc,%esp
  801431:	ff 75 08             	pushl  0x8(%ebp)
  801434:	e8 dd 1f 00 00       	call   803416 <alloc_block>
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	e9 a5 04 00 00       	jmp    8018e6 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	6a 10                	push   $0x10
  801446:	e8 cb 1f 00 00       	call   803416 <alloc_block>
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801451:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801455:	75 0a                	jne    801461 <malloc+0x77>
			return NULL;
  801457:	b8 00 00 00 00       	mov    $0x0,%eax
  80145c:	e9 85 04 00 00       	jmp    8018e6 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801461:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801468:	8b 55 08             	mov    0x8(%ebp),%edx
  80146b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80146e:	01 d0                	add    %edx,%eax
  801470:	48                   	dec    %eax
  801471:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801477:	ba 00 00 00 00       	mov    $0x0,%edx
  80147c:	f7 75 e8             	divl   -0x18(%ebp)
  80147f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801482:	29 d0                	sub    %edx,%eax
  801484:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801487:	a1 24 d1 81 00       	mov    0x81d124,%eax
  80148c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80148f:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801494:	85 c0                	test   %eax,%eax
  801496:	74 0f                	je     8014a7 <malloc+0xbd>
  801498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149b:	8b 40 04             	mov    0x4(%eax),%eax
  80149e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014a1:	0f 83 ea 00 00 00    	jae    801591 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  8014a7:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8014ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8014af:	89 c2                	mov    %eax,%edx
  8014b1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8014b6:	39 c2                	cmp    %eax,%edx
  8014b8:	0f 86 b9 00 00 00    	jbe    801577 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  8014be:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8014c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  8014c6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	a3 68 d0 81 00       	mov    %eax,0x81d068
					allocblock->startva = requestedblockva;
  8014d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014dc:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8014de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e4:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8014e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014eb:	75 14                	jne    801501 <malloc+0x117>
  8014ed:	83 ec 04             	sub    $0x4,%esp
  8014f0:	68 58 47 80 00       	push   $0x804758
  8014f5:	6a 60                	push   $0x60
  8014f7:	68 0c 47 80 00       	push   $0x80470c
  8014fc:	e8 36 28 00 00       	call   803d37 <_panic>
  801501:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801507:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80150a:	89 50 0c             	mov    %edx,0xc(%eax)
  80150d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801510:	8b 40 0c             	mov    0xc(%eax),%eax
  801513:	85 c0                	test   %eax,%eax
  801515:	74 0d                	je     801524 <malloc+0x13a>
  801517:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80151c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80151f:	89 50 08             	mov    %edx,0x8(%eax)
  801522:	eb 08                	jmp    80152c <malloc+0x142>
  801524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801527:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80152c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152f:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801537:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80153e:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801543:	40                   	inc    %eax
  801544:	a3 3c d1 81 00       	mov    %eax,0x81d13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801549:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	83 ec 08             	sub    $0x8,%esp
  801551:	ff 75 08             	pushl  0x8(%ebp)
  801554:	50                   	push   %eax
  801555:	e8 34 1c 00 00       	call   80318e <sys_allocate_user_mem>
  80155a:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  80155d:	83 ec 0c             	sub    $0xc,%esp
  801560:	68 40 d1 81 00       	push   $0x81d140
  801565:	e8 6c 27 00 00       	call   803cd6 <release_uspinlock>
  80156a:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80156d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801570:	8b 00                	mov    (%eax),%eax
  801572:	e9 6f 03 00 00       	jmp    8018e6 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801577:	83 ec 0c             	sub    $0xc,%esp
  80157a:	68 40 d1 81 00       	push   $0x81d140
  80157f:	e8 52 27 00 00       	call   803cd6 <release_uspinlock>
  801584:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801587:	b8 00 00 00 00       	mov    $0x0,%eax
  80158c:	e9 55 03 00 00       	jmp    8018e6 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801591:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801596:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801599:	e9 39 03 00 00       	jmp    8018d7 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  80159e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a1:	8b 40 04             	mov    0x4(%eax),%eax
  8015a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8015a7:	0f 86 e7 01 00 00    	jbe    801794 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  8015ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b0:	8b 10                	mov    (%eax),%edx
  8015b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b5:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  8015b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bd:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8015c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015c4:	75 14                	jne    8015da <malloc+0x1f0>
  8015c6:	83 ec 04             	sub    $0x4,%esp
  8015c9:	68 58 47 80 00       	push   $0x804758
  8015ce:	6a 72                	push   $0x72
  8015d0:	68 0c 47 80 00       	push   $0x80470c
  8015d5:	e8 5d 27 00 00       	call   803d37 <_panic>
  8015da:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8015e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e3:	89 50 0c             	mov    %edx,0xc(%eax)
  8015e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	74 0d                	je     8015fd <malloc+0x213>
  8015f0:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8015f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015f8:	89 50 08             	mov    %edx,0x8(%eax)
  8015fb:	eb 08                	jmp    801605 <malloc+0x21b>
  8015fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801600:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801608:	a3 34 d1 81 00       	mov    %eax,0x81d134
  80160d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801610:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801617:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80161c:	40                   	inc    %eax
  80161d:	a3 3c d1 81 00       	mov    %eax,0x81d13c
                lastfreeelement->startva += size;
  801622:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801625:	8b 10                	mov    (%eax),%edx
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	01 c2                	add    %eax,%edx
  80162c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80162f:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801631:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801634:	8b 40 04             	mov    0x4(%eax),%eax
  801637:	2b 45 08             	sub    0x8(%ebp),%eax
  80163a:	89 c2                	mov    %eax,%edx
  80163c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163f:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801642:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801647:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  80164a:	e9 0d 01 00 00       	jmp    80175c <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  80164f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801652:	8b 50 04             	mov    0x4(%eax),%edx
  801655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801658:	8b 40 04             	mov    0x4(%eax),%eax
  80165b:	39 c2                	cmp    %eax,%edx
  80165d:	0f 83 f0 00 00 00    	jae    801753 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801663:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801667:	75 14                	jne    80167d <malloc+0x293>
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	68 7b 47 80 00       	push   $0x80477b
  801671:	6a 7a                	push   $0x7a
  801673:	68 0c 47 80 00       	push   $0x80470c
  801678:	e8 ba 26 00 00       	call   803d37 <_panic>
  80167d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801680:	8b 40 08             	mov    0x8(%eax),%eax
  801683:	85 c0                	test   %eax,%eax
  801685:	74 11                	je     801698 <malloc+0x2ae>
  801687:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80168a:	8b 40 08             	mov    0x8(%eax),%eax
  80168d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801690:	8b 52 0c             	mov    0xc(%edx),%edx
  801693:	89 50 0c             	mov    %edx,0xc(%eax)
  801696:	eb 0b                	jmp    8016a3 <malloc+0x2b9>
  801698:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80169b:	8b 40 0c             	mov    0xc(%eax),%eax
  80169e:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8016a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	74 11                	je     8016be <malloc+0x2d4>
  8016ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016b6:	8b 52 08             	mov    0x8(%edx),%edx
  8016b9:	89 50 08             	mov    %edx,0x8(%eax)
  8016bc:	eb 0b                	jmp    8016c9 <malloc+0x2df>
  8016be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c1:	8b 40 08             	mov    0x8(%eax),%eax
  8016c4:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8016c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8016d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8016dd:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8016e2:	48                   	dec    %eax
  8016e3:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8016e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016ec:	74 06                	je     8016f4 <malloc+0x30a>
  8016ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016f2:	75 14                	jne    801708 <malloc+0x31e>
  8016f4:	83 ec 04             	sub    $0x4,%esp
  8016f7:	68 9c 47 80 00       	push   $0x80479c
  8016fc:	6a 7b                	push   $0x7b
  8016fe:	68 0c 47 80 00       	push   $0x80470c
  801703:	e8 2f 26 00 00       	call   803d37 <_panic>
  801708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170b:	8b 50 0c             	mov    0xc(%eax),%edx
  80170e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801711:	89 50 0c             	mov    %edx,0xc(%eax)
  801714:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801717:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80171a:	89 50 08             	mov    %edx,0x8(%eax)
  80171d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801720:	8b 40 0c             	mov    0xc(%eax),%eax
  801723:	85 c0                	test   %eax,%eax
  801725:	74 0e                	je     801735 <malloc+0x34b>
  801727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172a:	8b 40 0c             	mov    0xc(%eax),%eax
  80172d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801730:	89 50 08             	mov    %edx,0x8(%eax)
  801733:	eb 08                	jmp    80173d <malloc+0x353>
  801735:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801738:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80173d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801740:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801743:	89 50 0c             	mov    %edx,0xc(%eax)
  801746:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80174b:	40                   	inc    %eax
  80174c:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		break;
  801751:	eb 13                	jmp    801766 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801756:	8b 40 08             	mov    0x8(%eax),%eax
  801759:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  80175c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801760:	0f 85 e9 fe ff ff    	jne    80164f <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801769:	8b 00                	mov    (%eax),%eax
  80176b:	83 ec 08             	sub    $0x8,%esp
  80176e:	ff 75 08             	pushl  0x8(%ebp)
  801771:	50                   	push   %eax
  801772:	e8 17 1a 00 00       	call   80318e <sys_allocate_user_mem>
  801777:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  80177a:	83 ec 0c             	sub    $0xc,%esp
  80177d:	68 40 d1 81 00       	push   $0x81d140
  801782:	e8 4f 25 00 00       	call   803cd6 <release_uspinlock>
  801787:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  80178a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178d:	8b 00                	mov    (%eax),%eax
  80178f:	e9 52 01 00 00       	jmp    8018e6 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801797:	8b 40 04             	mov    0x4(%eax),%eax
  80179a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80179d:	0f 85 2b 01 00 00    	jne    8018ce <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  8017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a6:	8b 10                	mov    (%eax),%edx
  8017a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ab:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  8017ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b3:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  8017b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ba:	75 17                	jne    8017d3 <malloc+0x3e9>
  8017bc:	83 ec 04             	sub    $0x4,%esp
  8017bf:	68 58 47 80 00       	push   $0x804758
  8017c4:	68 89 00 00 00       	push   $0x89
  8017c9:	68 0c 47 80 00       	push   $0x80470c
  8017ce:	e8 64 25 00 00       	call   803d37 <_panic>
  8017d3:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8017d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017dc:	89 50 0c             	mov    %edx,0xc(%eax)
  8017df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e5:	85 c0                	test   %eax,%eax
  8017e7:	74 0d                	je     8017f6 <malloc+0x40c>
  8017e9:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8017ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017f1:	89 50 08             	mov    %edx,0x8(%eax)
  8017f4:	eb 08                	jmp    8017fe <malloc+0x414>
  8017f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f9:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8017fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801801:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801809:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801810:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801815:	40                   	inc    %eax
  801816:	a3 3c d1 81 00       	mov    %eax,0x81d13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  80181b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80181f:	75 17                	jne    801838 <malloc+0x44e>
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	68 7b 47 80 00       	push   $0x80477b
  801829:	68 8a 00 00 00       	push   $0x8a
  80182e:	68 0c 47 80 00       	push   $0x80470c
  801833:	e8 ff 24 00 00       	call   803d37 <_panic>
  801838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183b:	8b 40 08             	mov    0x8(%eax),%eax
  80183e:	85 c0                	test   %eax,%eax
  801840:	74 11                	je     801853 <malloc+0x469>
  801842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801845:	8b 40 08             	mov    0x8(%eax),%eax
  801848:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184b:	8b 52 0c             	mov    0xc(%edx),%edx
  80184e:	89 50 0c             	mov    %edx,0xc(%eax)
  801851:	eb 0b                	jmp    80185e <malloc+0x474>
  801853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801856:	8b 40 0c             	mov    0xc(%eax),%eax
  801859:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80185e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801861:	8b 40 0c             	mov    0xc(%eax),%eax
  801864:	85 c0                	test   %eax,%eax
  801866:	74 11                	je     801879 <malloc+0x48f>
  801868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186b:	8b 40 0c             	mov    0xc(%eax),%eax
  80186e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801871:	8b 52 08             	mov    0x8(%edx),%edx
  801874:	89 50 08             	mov    %edx,0x8(%eax)
  801877:	eb 0b                	jmp    801884 <malloc+0x49a>
  801879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187c:	8b 40 08             	mov    0x8(%eax),%eax
  80187f:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801887:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801891:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801898:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80189d:	48                   	dec    %eax
  80189e:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				sys_allocate_user_mem(allocblock->startva ,size);
  8018a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a6:	8b 00                	mov    (%eax),%eax
  8018a8:	83 ec 08             	sub    $0x8,%esp
  8018ab:	ff 75 08             	pushl  0x8(%ebp)
  8018ae:	50                   	push   %eax
  8018af:	e8 da 18 00 00       	call   80318e <sys_allocate_user_mem>
  8018b4:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	68 40 d1 81 00       	push   $0x81d140
  8018bf:	e8 12 24 00 00       	call   803cd6 <release_uspinlock>
  8018c4:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  8018c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ca:	8b 00                	mov    (%eax),%eax
  8018cc:	eb 18                	jmp    8018e6 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8018ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d1:	8b 40 08             	mov    0x8(%eax),%eax
  8018d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  8018d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018db:	0f 85 bd fc ff ff    	jne    80159e <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  8018e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018fc:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  8018ff:	e8 b2 f9 ff ff       	call   8012b6 <uheap_init>
		acquire_uspinlock(&ulock);
  801904:	83 ec 0c             	sub    $0xc,%esp
  801907:	68 40 d1 81 00       	push   $0x81d140
  80190c:	e8 6d 23 00 00       	call   803c7e <acquire_uspinlock>
  801911:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801914:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801919:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80191c:	73 23                	jae    801941 <free+0x59>
			free_block(virtual_address);
  80191e:	83 ec 0c             	sub    $0xc,%esp
  801921:	ff 75 08             	pushl  0x8(%ebp)
  801924:	e8 89 1f 00 00       	call   8038b2 <free_block>
  801929:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  80192c:	83 ec 0c             	sub    $0xc,%esp
  80192f:	68 40 d1 81 00       	push   $0x81d140
  801934:	e8 9d 23 00 00       	call   803cd6 <release_uspinlock>
  801939:	83 c4 10             	add    $0x10,%esp
			return;
  80193c:	e9 35 07 00 00       	jmp    802076 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801941:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801946:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801949:	72 30                	jb     80197b <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  80194b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	50                   	push   %eax
  801954:	ff 75 d8             	pushl  -0x28(%ebp)
  801957:	68 d1 47 80 00       	push   $0x8047d1
  80195c:	e8 70 ea ff ff       	call   8003d1 <cprintf>
  801961:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801964:	83 ec 04             	sub    $0x4,%esp
  801967:	68 d9 47 80 00       	push   $0x8047d9
  80196c:	68 a7 00 00 00       	push   $0xa7
  801971:	68 0c 47 80 00       	push   $0x80470c
  801976:	e8 bc 23 00 00       	call   803d37 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80197b:	83 ec 0c             	sub    $0xc,%esp
  80197e:	6a 10                	push   $0x10
  801980:	e8 91 1a 00 00       	call   803416 <alloc_block>
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  80198b:	83 ec 0c             	sub    $0xc,%esp
  80198e:	6a 10                	push   $0x10
  801990:	e8 81 1a 00 00       	call   803416 <alloc_block>
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  80199b:	a1 30 d1 81 00       	mov    0x81d130,%eax
  8019a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  8019a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  8019aa:	eb 1c                	jmp    8019c8 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  8019ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019af:	8b 00                	mov    (%eax),%eax
  8019b1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8019b4:	75 09                	jne    8019bf <free+0xd7>
				foundVA = 1;
  8019b6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  8019bd:	eb 0f                	jmp    8019ce <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  8019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c2:	8b 40 08             	mov    0x8(%eax),%eax
  8019c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  8019c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019cc:	75 de                	jne    8019ac <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  8019ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019d2:	75 17                	jne    8019eb <free+0x103>
				panic("INVALID ADDRESS!");
  8019d4:	83 ec 04             	sub    $0x4,%esp
  8019d7:	68 f6 47 80 00       	push   $0x8047f6
  8019dc:	68 be 00 00 00       	push   $0xbe
  8019e1:	68 0c 47 80 00       	push   $0x80470c
  8019e6:	e8 4c 23 00 00       	call   803d37 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  8019eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ee:	8b 10                	mov    (%eax),%edx
  8019f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019f3:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  8019f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f8:	8b 50 04             	mov    0x4(%eax),%edx
  8019fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019fe:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801a01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a05:	75 17                	jne    801a1e <free+0x136>
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	68 7b 47 80 00       	push   $0x80477b
  801a0f:	68 c8 00 00 00       	push   $0xc8
  801a14:	68 0c 47 80 00       	push   $0x80470c
  801a19:	e8 19 23 00 00       	call   803d37 <_panic>
  801a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a21:	8b 40 08             	mov    0x8(%eax),%eax
  801a24:	85 c0                	test   %eax,%eax
  801a26:	74 11                	je     801a39 <free+0x151>
  801a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2b:	8b 40 08             	mov    0x8(%eax),%eax
  801a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a31:	8b 52 0c             	mov    0xc(%edx),%edx
  801a34:	89 50 0c             	mov    %edx,0xc(%eax)
  801a37:	eb 0b                	jmp    801a44 <free+0x15c>
  801a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a3f:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	74 11                	je     801a5f <free+0x177>
  801a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a51:	8b 40 0c             	mov    0xc(%eax),%eax
  801a54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a57:	8b 52 08             	mov    0x8(%edx),%edx
  801a5a:	89 50 08             	mov    %edx,0x8(%eax)
  801a5d:	eb 0b                	jmp    801a6a <free+0x182>
  801a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a62:	8b 40 08             	mov    0x8(%eax),%eax
  801a65:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a77:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a7e:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801a83:	48                   	dec    %eax
  801a84:	a3 3c d1 81 00       	mov    %eax,0x81d13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8c:	8b 50 04             	mov    0x4(%eax),%edx
  801a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a92:	8b 00                	mov    (%eax),%eax
  801a94:	83 ec 08             	sub    $0x8,%esp
  801a97:	52                   	push   %edx
  801a98:	50                   	push   %eax
  801a99:	e8 d4 16 00 00       	call   803172 <sys_free_user_mem>
  801a9e:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801aa1:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	75 7a                	jne    801b24 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801aaa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801aae:	75 17                	jne    801ac7 <free+0x1df>
  801ab0:	83 ec 04             	sub    $0x4,%esp
  801ab3:	68 08 48 80 00       	push   $0x804808
  801ab8:	68 d0 00 00 00       	push   $0xd0
  801abd:	68 0c 47 80 00       	push   $0x80470c
  801ac2:	e8 70 22 00 00       	call   803d37 <_panic>
  801ac7:	8b 15 20 d1 81 00    	mov    0x81d120,%edx
  801acd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ad0:	89 50 08             	mov    %edx,0x8(%eax)
  801ad3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ad6:	8b 40 08             	mov    0x8(%eax),%eax
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	74 0d                	je     801aea <free+0x202>
  801add:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801ae2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801ae5:	89 50 0c             	mov    %edx,0xc(%eax)
  801ae8:	eb 08                	jmp    801af2 <free+0x20a>
  801aea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801aed:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801af2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801af5:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801afa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801afd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801b04:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801b09:	40                   	inc    %eax
  801b0a:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			release_uspinlock(&ulock);
  801b0f:	83 ec 0c             	sub    $0xc,%esp
  801b12:	68 40 d1 81 00       	push   $0x81d140
  801b17:	e8 ba 21 00 00       	call   803cd6 <release_uspinlock>
  801b1c:	83 c4 10             	add    $0x10,%esp
			return;
  801b1f:	e9 52 05 00 00       	jmp    802076 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801b24:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801b29:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801b2c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801b33:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801b3a:	e9 d2 00 00 00       	jmp    801c11 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b42:	8b 10                	mov    (%eax),%edx
  801b44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b47:	8b 40 04             	mov    0x4(%eax),%eax
  801b4a:	01 c2                	add    %eax,%edx
  801b4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b4f:	8b 00                	mov    (%eax),%eax
  801b51:	39 c2                	cmp    %eax,%edx
  801b53:	0f 85 af 00 00 00    	jne    801c08 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b5c:	8b 10                	mov    (%eax),%edx
  801b5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b61:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b66:	8b 50 04             	mov    0x4(%eax),%edx
  801b69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b6c:	8b 40 04             	mov    0x4(%eax),%eax
  801b6f:	01 c2                	add    %eax,%edx
  801b71:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b74:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801b77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b7b:	75 17                	jne    801b94 <free+0x2ac>
  801b7d:	83 ec 04             	sub    $0x4,%esp
  801b80:	68 7b 47 80 00       	push   $0x80477b
  801b85:	68 df 00 00 00       	push   $0xdf
  801b8a:	68 0c 47 80 00       	push   $0x80470c
  801b8f:	e8 a3 21 00 00       	call   803d37 <_panic>
  801b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b97:	8b 40 08             	mov    0x8(%eax),%eax
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	74 11                	je     801baf <free+0x2c7>
  801b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba1:	8b 40 08             	mov    0x8(%eax),%eax
  801ba4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ba7:	8b 52 0c             	mov    0xc(%edx),%edx
  801baa:	89 50 0c             	mov    %edx,0xc(%eax)
  801bad:	eb 0b                	jmp    801bba <free+0x2d2>
  801baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb5:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	74 11                	je     801bd5 <free+0x2ed>
  801bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc7:	8b 40 0c             	mov    0xc(%eax),%eax
  801bca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bcd:	8b 52 08             	mov    0x8(%edx),%edx
  801bd0:	89 50 08             	mov    %edx,0x8(%eax)
  801bd3:	eb 0b                	jmp    801be0 <free+0x2f8>
  801bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd8:	8b 40 08             	mov    0x8(%eax),%eax
  801bdb:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801bf4:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801bf9:	48                   	dec    %eax
  801bfa:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				mergeprev = 1;
  801bff:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801c06:	eb 13                	jmp    801c1b <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c0b:	8b 40 08             	mov    0x8(%eax),%eax
  801c0e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801c11:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c15:	0f 85 24 ff ff ff    	jne    801b3f <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801c1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c1e:	8b 10                	mov    (%eax),%edx
  801c20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c23:	8b 40 04             	mov    0x4(%eax),%eax
  801c26:	01 c2                	add    %eax,%edx
  801c28:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c2d:	39 c2                	cmp    %eax,%edx
  801c2f:	75 44                	jne    801c75 <free+0x38d>

			if(mergeprev){
  801c31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c35:	74 1f                	je     801c56 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801c37:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c3a:	8b 00                	mov    (%eax),%eax
  801c3c:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801c41:	83 ec 0c             	sub    $0xc,%esp
  801c44:	68 40 d1 81 00       	push   $0x81d140
  801c49:	e8 88 20 00 00       	call   803cd6 <release_uspinlock>
  801c4e:	83 c4 10             	add    $0x10,%esp
				return;
  801c51:	e9 20 04 00 00       	jmp    802076 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801c56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c59:	8b 00                	mov    (%eax),%eax
  801c5b:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801c60:	83 ec 0c             	sub    $0xc,%esp
  801c63:	68 40 d1 81 00       	push   $0x81d140
  801c68:	e8 69 20 00 00       	call   803cd6 <release_uspinlock>
  801c6d:	83 c4 10             	add    $0x10,%esp
				return;
  801c70:	e9 01 04 00 00       	jmp    802076 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  801c75:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801c7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  801c7d:	e9 7d 01 00 00       	jmp    801dff <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  801c82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c85:	8b 10                	mov    (%eax),%edx
  801c87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c8a:	8b 40 04             	mov    0x4(%eax),%eax
  801c8d:	01 c2                	add    %eax,%edx
  801c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c92:	8b 00                	mov    (%eax),%eax
  801c94:	39 c2                	cmp    %eax,%edx
  801c96:	0f 85 5a 01 00 00    	jne    801df6 <free+0x50e>
				if (mergeprev){
  801c9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ca0:	0f 84 a1 00 00 00    	je     801d47 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  801ca6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ca9:	8b 50 04             	mov    0x4(%eax),%edx
  801cac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801caf:	8b 40 04             	mov    0x4(%eax),%eax
  801cb2:	01 c2                	add    %eax,%edx
  801cb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cb7:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  801cba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cbe:	75 17                	jne    801cd7 <free+0x3ef>
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	68 7b 47 80 00       	push   $0x80477b
  801cc8:	68 0a 01 00 00       	push   $0x10a
  801ccd:	68 0c 47 80 00       	push   $0x80470c
  801cd2:	e8 60 20 00 00       	call   803d37 <_panic>
  801cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cda:	8b 40 08             	mov    0x8(%eax),%eax
  801cdd:	85 c0                	test   %eax,%eax
  801cdf:	74 11                	je     801cf2 <free+0x40a>
  801ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce4:	8b 40 08             	mov    0x8(%eax),%eax
  801ce7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cea:	8b 52 0c             	mov    0xc(%edx),%edx
  801ced:	89 50 0c             	mov    %edx,0xc(%eax)
  801cf0:	eb 0b                	jmp    801cfd <free+0x415>
  801cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf5:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf8:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d00:	8b 40 0c             	mov    0xc(%eax),%eax
  801d03:	85 c0                	test   %eax,%eax
  801d05:	74 11                	je     801d18 <free+0x430>
  801d07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d10:	8b 52 08             	mov    0x8(%edx),%edx
  801d13:	89 50 08             	mov    %edx,0x8(%eax)
  801d16:	eb 0b                	jmp    801d23 <free+0x43b>
  801d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d1b:	8b 40 08             	mov    0x8(%eax),%eax
  801d1e:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d26:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d30:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801d37:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801d3c:	48                   	dec    %eax
  801d3d:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					break;
  801d42:	e9 c2 00 00 00       	jmp    801e09 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  801d47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d4a:	8b 10                	mov    (%eax),%edx
  801d4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d4f:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  801d51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d54:	8b 50 04             	mov    0x4(%eax),%edx
  801d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5a:	8b 40 04             	mov    0x4(%eax),%eax
  801d5d:	01 c2                	add    %eax,%edx
  801d5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d62:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  801d65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d69:	75 17                	jne    801d82 <free+0x49a>
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	68 7b 47 80 00       	push   $0x80477b
  801d73:	68 10 01 00 00       	push   $0x110
  801d78:	68 0c 47 80 00       	push   $0x80470c
  801d7d:	e8 b5 1f 00 00       	call   803d37 <_panic>
  801d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d85:	8b 40 08             	mov    0x8(%eax),%eax
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	74 11                	je     801d9d <free+0x4b5>
  801d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8f:	8b 40 08             	mov    0x8(%eax),%eax
  801d92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d95:	8b 52 0c             	mov    0xc(%edx),%edx
  801d98:	89 50 0c             	mov    %edx,0xc(%eax)
  801d9b:	eb 0b                	jmp    801da8 <free+0x4c0>
  801d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da0:	8b 40 0c             	mov    0xc(%eax),%eax
  801da3:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801da8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dab:	8b 40 0c             	mov    0xc(%eax),%eax
  801dae:	85 c0                	test   %eax,%eax
  801db0:	74 11                	je     801dc3 <free+0x4db>
  801db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db5:	8b 40 0c             	mov    0xc(%eax),%eax
  801db8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dbb:	8b 52 08             	mov    0x8(%edx),%edx
  801dbe:	89 50 08             	mov    %edx,0x8(%eax)
  801dc1:	eb 0b                	jmp    801dce <free+0x4e6>
  801dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc6:	8b 40 08             	mov    0x8(%eax),%eax
  801dc9:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ddb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801de2:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801de7:	48                   	dec    %eax
  801de8:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					mergenext = 1;
  801ded:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801df4:	eb 13                	jmp    801e09 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df9:	8b 40 08             	mov    0x8(%eax),%eax
  801dfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  801dff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e03:	0f 85 79 fe ff ff    	jne    801c82 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  801e09:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801e0e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  801e11:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e15:	0f 85 ad 00 00 00    	jne    801ec8 <free+0x5e0>
  801e1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e1f:	0f 84 c3 01 00 00    	je     801fe8 <free+0x700>
				while(currentfree != NULL){
  801e25:	e9 9e 00 00 00       	jmp    801ec8 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  801e2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e2d:	8b 50 04             	mov    0x4(%eax),%edx
  801e30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e33:	8b 40 04             	mov    0x4(%eax),%eax
  801e36:	39 c2                	cmp    %eax,%edx
  801e38:	0f 83 81 00 00 00    	jae    801ebf <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  801e3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e42:	74 06                	je     801e4a <free+0x562>
  801e44:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801e48:	75 17                	jne    801e61 <free+0x579>
  801e4a:	83 ec 04             	sub    $0x4,%esp
  801e4d:	68 9c 47 80 00       	push   $0x80479c
  801e52:	68 23 01 00 00       	push   $0x123
  801e57:	68 0c 47 80 00       	push   $0x80470c
  801e5c:	e8 d6 1e 00 00       	call   803d37 <_panic>
  801e61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e64:	8b 50 0c             	mov    0xc(%eax),%edx
  801e67:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e6a:	89 50 0c             	mov    %edx,0xc(%eax)
  801e6d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e73:	89 50 08             	mov    %edx,0x8(%eax)
  801e76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e79:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	74 0e                	je     801e8e <free+0x5a6>
  801e80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e83:	8b 40 0c             	mov    0xc(%eax),%eax
  801e86:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801e89:	89 50 08             	mov    %edx,0x8(%eax)
  801e8c:	eb 08                	jmp    801e96 <free+0x5ae>
  801e8e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e91:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801e96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e99:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801e9c:	89 50 0c             	mov    %edx,0xc(%eax)
  801e9f:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801ea4:	40                   	inc    %eax
  801ea5:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  801eaa:	83 ec 0c             	sub    $0xc,%esp
  801ead:	68 40 d1 81 00       	push   $0x81d140
  801eb2:	e8 1f 1e 00 00       	call   803cd6 <release_uspinlock>
  801eb7:	83 c4 10             	add    $0x10,%esp
							return;
  801eba:	e9 b7 01 00 00       	jmp    802076 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  801ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec2:	8b 40 08             	mov    0x8(%eax),%eax
  801ec5:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  801ec8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ecc:	0f 85 58 ff ff ff    	jne    801e2a <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  801ed2:	83 ec 0c             	sub    $0xc,%esp
  801ed5:	ff 75 d4             	pushl  -0x2c(%ebp)
  801ed8:	e8 d5 19 00 00       	call   8038b2 <free_block>
  801edd:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  801ee0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801ee4:	75 17                	jne    801efd <free+0x615>
  801ee6:	83 ec 04             	sub    $0x4,%esp
  801ee9:	68 58 47 80 00       	push   $0x804758
  801eee:	68 2a 01 00 00       	push   $0x12a
  801ef3:	68 0c 47 80 00       	push   $0x80470c
  801ef8:	e8 3a 1e 00 00       	call   803d37 <_panic>
  801efd:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  801f03:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f06:	89 50 0c             	mov    %edx,0xc(%eax)
  801f09:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	74 0d                	je     801f20 <free+0x638>
  801f13:	a1 24 d1 81 00       	mov    0x81d124,%eax
  801f18:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801f1b:	89 50 08             	mov    %edx,0x8(%eax)
  801f1e:	eb 08                	jmp    801f28 <free+0x640>
  801f20:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f23:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801f28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f2b:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801f30:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f33:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f3a:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801f3f:	40                   	inc    %eax
  801f40:	a3 2c d1 81 00       	mov    %eax,0x81d12c
  801f45:	e9 1b 01 00 00       	jmp    802065 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  801f4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f4d:	8b 50 04             	mov    0x4(%eax),%edx
  801f50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f53:	8b 40 04             	mov    0x4(%eax),%eax
  801f56:	39 c2                	cmp    %eax,%edx
  801f58:	0f 83 81 00 00 00    	jae    801fdf <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  801f5e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f62:	74 06                	je     801f6a <free+0x682>
  801f64:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801f68:	75 17                	jne    801f81 <free+0x699>
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	68 9c 47 80 00       	push   $0x80479c
  801f72:	68 30 01 00 00       	push   $0x130
  801f77:	68 0c 47 80 00       	push   $0x80470c
  801f7c:	e8 b6 1d 00 00       	call   803d37 <_panic>
  801f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f84:	8b 50 0c             	mov    0xc(%eax),%edx
  801f87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f8a:	89 50 0c             	mov    %edx,0xc(%eax)
  801f8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f93:	89 50 08             	mov    %edx,0x8(%eax)
  801f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f99:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	74 0e                	je     801fae <free+0x6c6>
  801fa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fa3:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801fa9:	89 50 08             	mov    %edx,0x8(%eax)
  801fac:	eb 08                	jmp    801fb6 <free+0x6ce>
  801fae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fb1:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801fb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fb9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801fbc:	89 50 0c             	mov    %edx,0xc(%eax)
  801fbf:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801fc4:	40                   	inc    %eax
  801fc5:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  801fca:	83 ec 0c             	sub    $0xc,%esp
  801fcd:	68 40 d1 81 00       	push   $0x81d140
  801fd2:	e8 ff 1c 00 00       	call   803cd6 <release_uspinlock>
  801fd7:	83 c4 10             	add    $0x10,%esp
							return;
  801fda:	e9 97 00 00 00       	jmp    802076 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  801fdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fe2:	8b 40 08             	mov    0x8(%eax),%eax
  801fe5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  801fe8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fec:	0f 85 58 ff ff ff    	jne    801f4a <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	ff 75 d0             	pushl  -0x30(%ebp)
  801ff8:	e8 b5 18 00 00       	call   8038b2 <free_block>
  801ffd:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  802000:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802004:	75 17                	jne    80201d <free+0x735>
  802006:	83 ec 04             	sub    $0x4,%esp
  802009:	68 58 47 80 00       	push   $0x804758
  80200e:	68 37 01 00 00       	push   $0x137
  802013:	68 0c 47 80 00       	push   $0x80470c
  802018:	e8 1a 1d 00 00       	call   803d37 <_panic>
  80201d:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  802023:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802026:	89 50 0c             	mov    %edx,0xc(%eax)
  802029:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80202c:	8b 40 0c             	mov    0xc(%eax),%eax
  80202f:	85 c0                	test   %eax,%eax
  802031:	74 0d                	je     802040 <free+0x758>
  802033:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802038:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80203b:	89 50 08             	mov    %edx,0x8(%eax)
  80203e:	eb 08                	jmp    802048 <free+0x760>
  802040:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802043:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802048:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80204b:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802050:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802053:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80205a:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80205f:	40                   	inc    %eax
  802060:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			}
		release_uspinlock(&ulock);
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	68 40 d1 81 00       	push   $0x81d140
  80206d:	e8 64 1c 00 00       	call   803cd6 <release_uspinlock>
  802072:	83 c4 10             	add    $0x10,%esp
		return;
  802075:	90                   	nop
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 48             	sub    $0x48,%esp
  80207e:	8b 45 10             	mov    0x10(%ebp),%eax
  802081:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802084:	e8 2d f2 ff ff       	call   8012b6 <uheap_init>
	if (size == 0) return NULL;
  802089:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80208d:	75 0a                	jne    802099 <smalloc+0x21>
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
  802094:	e9 84 05 00 00       	jmp    80261d <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802099:	83 ec 0c             	sub    $0xc,%esp
  80209c:	68 40 d1 81 00       	push   $0x81d140
  8020a1:	e8 d8 1b 00 00       	call   803c7e <acquire_uspinlock>
  8020a6:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8020a9:	83 ec 0c             	sub    $0xc,%esp
  8020ac:	6a 10                	push   $0x10
  8020ae:	e8 63 13 00 00       	call   803416 <alloc_block>
  8020b3:	83 c4 10             	add    $0x10,%esp
  8020b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  8020b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020bd:	75 0a                	jne    8020c9 <smalloc+0x51>
				return NULL;
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c4:	e9 54 05 00 00       	jmp    80261d <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  8020c9:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8020d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020d6:	01 d0                	add    %edx,%eax
  8020d8:	48                   	dec    %eax
  8020d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020df:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e4:	f7 75 e8             	divl   -0x18(%ebp)
  8020e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ea:	29 d0                	sub    %edx,%eax
  8020ec:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8020ef:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8020f4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8020f7:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	74 0f                	je     80210f <smalloc+0x97>
  802100:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802103:	8b 40 04             	mov    0x4(%eax),%eax
  802106:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802109:	0f 83 25 01 00 00    	jae    802234 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  80210f:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802114:	2b 45 0c             	sub    0xc(%ebp),%eax
  802117:	89 c2                	mov    %eax,%edx
  802119:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80211e:	39 c2                	cmp    %eax,%edx
  802120:	0f 82 f4 00 00 00    	jb     80221a <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802126:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80212b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  80212e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802134:	8b 45 0c             	mov    0xc(%ebp),%eax
  802137:	01 d0                	add    %edx,%eax
  802139:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  80213e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802141:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802144:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802149:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214c:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80214f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802153:	75 17                	jne    80216c <smalloc+0xf4>
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	68 58 47 80 00       	push   $0x804758
  80215d:	68 57 01 00 00       	push   $0x157
  802162:	68 0c 47 80 00       	push   $0x80470c
  802167:	e8 cb 1b 00 00       	call   803d37 <_panic>
  80216c:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802172:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802175:	89 50 0c             	mov    %edx,0xc(%eax)
  802178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217b:	8b 40 0c             	mov    0xc(%eax),%eax
  80217e:	85 c0                	test   %eax,%eax
  802180:	74 0d                	je     80218f <smalloc+0x117>
  802182:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802187:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80218a:	89 50 08             	mov    %edx,0x8(%eax)
  80218d:	eb 08                	jmp    802197 <smalloc+0x11f>
  80218f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802192:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219a:	a3 34 d1 81 00       	mov    %eax,0x81d134
  80219f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8021a9:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8021ae:	40                   	inc    %eax
  8021af:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8021b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b7:	8b 00                	mov    (%eax),%eax
  8021b9:	89 c2                	mov    %eax,%edx
  8021bb:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8021bf:	52                   	push   %edx
  8021c0:	50                   	push   %eax
  8021c1:	ff 75 0c             	pushl  0xc(%ebp)
  8021c4:	ff 75 08             	pushl  0x8(%ebp)
  8021c7:	e8 48 0c 00 00       	call   802e14 <sys_create_shared_object>
  8021cc:	83 c4 10             	add    $0x10,%esp
  8021cf:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  8021d2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021d6:	79 28                	jns    802200 <smalloc+0x188>
							free_block(allocblock);
  8021d8:	83 ec 0c             	sub    $0xc,%esp
  8021db:	ff 75 ec             	pushl  -0x14(%ebp)
  8021de:	e8 cf 16 00 00       	call   8038b2 <free_block>
  8021e3:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8021e6:	83 ec 0c             	sub    $0xc,%esp
  8021e9:	68 40 d1 81 00       	push   $0x81d140
  8021ee:	e8 e3 1a 00 00       	call   803cd6 <release_uspinlock>
  8021f3:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8021f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fb:	e9 1d 04 00 00       	jmp    80261d <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802200:	83 ec 0c             	sub    $0xc,%esp
  802203:	68 40 d1 81 00       	push   $0x81d140
  802208:	e8 c9 1a 00 00       	call   803cd6 <release_uspinlock>
  80220d:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802210:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802213:	8b 00                	mov    (%eax),%eax
  802215:	e9 03 04 00 00       	jmp    80261d <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  80221a:	83 ec 0c             	sub    $0xc,%esp
  80221d:	68 40 d1 81 00       	push   $0x81d140
  802222:	e8 af 1a 00 00       	call   803cd6 <release_uspinlock>
  802227:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80222a:	b8 00 00 00 00       	mov    $0x0,%eax
  80222f:	e9 e9 03 00 00       	jmp    80261d <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802234:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802239:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  80223c:	e9 af 03 00 00       	jmp    8025f0 <smalloc+0x578>
				if(size<currentfreeelement->size){
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 40 04             	mov    0x4(%eax),%eax
  802247:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80224a:	0f 86 28 02 00 00    	jbe    802478 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802250:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802253:	8b 10                	mov    (%eax),%edx
  802255:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802258:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  80225a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802260:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802263:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802267:	75 17                	jne    802280 <smalloc+0x208>
  802269:	83 ec 04             	sub    $0x4,%esp
  80226c:	68 58 47 80 00       	push   $0x804758
  802271:	68 6f 01 00 00       	push   $0x16f
  802276:	68 0c 47 80 00       	push   $0x80470c
  80227b:	e8 b7 1a 00 00       	call   803d37 <_panic>
  802280:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802289:	89 50 0c             	mov    %edx,0xc(%eax)
  80228c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228f:	8b 40 0c             	mov    0xc(%eax),%eax
  802292:	85 c0                	test   %eax,%eax
  802294:	74 0d                	je     8022a3 <smalloc+0x22b>
  802296:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80229b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80229e:	89 50 08             	mov    %edx,0x8(%eax)
  8022a1:	eb 08                	jmp    8022ab <smalloc+0x233>
  8022a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a6:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8022ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ae:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8022b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022bd:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8022c2:	40                   	inc    %eax
  8022c3:	a3 3c d1 81 00       	mov    %eax,0x81d13c
	                lastfreeelement->startva += size;
  8022c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022cb:	8b 10                	mov    (%eax),%edx
  8022cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d0:	01 c2                	add    %eax,%edx
  8022d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d5:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  8022d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022da:	8b 40 04             	mov    0x4(%eax),%eax
  8022dd:	2b 45 0c             	sub    0xc(%ebp),%eax
  8022e0:	89 c2                	mov    %eax,%edx
  8022e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e5:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8022e8:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8022ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  8022f0:	e9 13 01 00 00       	jmp    802408 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  8022f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022f8:	8b 50 04             	mov    0x4(%eax),%edx
  8022fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fe:	8b 40 04             	mov    0x4(%eax),%eax
  802301:	39 c2                	cmp    %eax,%edx
  802303:	0f 83 f6 00 00 00    	jae    8023ff <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802309:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80230d:	75 17                	jne    802326 <smalloc+0x2ae>
  80230f:	83 ec 04             	sub    $0x4,%esp
  802312:	68 7b 47 80 00       	push   $0x80477b
  802317:	68 77 01 00 00       	push   $0x177
  80231c:	68 0c 47 80 00       	push   $0x80470c
  802321:	e8 11 1a 00 00       	call   803d37 <_panic>
  802326:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802329:	8b 40 08             	mov    0x8(%eax),%eax
  80232c:	85 c0                	test   %eax,%eax
  80232e:	74 11                	je     802341 <smalloc+0x2c9>
  802330:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802333:	8b 40 08             	mov    0x8(%eax),%eax
  802336:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802339:	8b 52 0c             	mov    0xc(%edx),%edx
  80233c:	89 50 0c             	mov    %edx,0xc(%eax)
  80233f:	eb 0b                	jmp    80234c <smalloc+0x2d4>
  802341:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802344:	8b 40 0c             	mov    0xc(%eax),%eax
  802347:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80234c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80234f:	8b 40 0c             	mov    0xc(%eax),%eax
  802352:	85 c0                	test   %eax,%eax
  802354:	74 11                	je     802367 <smalloc+0x2ef>
  802356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802359:	8b 40 0c             	mov    0xc(%eax),%eax
  80235c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80235f:	8b 52 08             	mov    0x8(%edx),%edx
  802362:	89 50 08             	mov    %edx,0x8(%eax)
  802365:	eb 0b                	jmp    802372 <smalloc+0x2fa>
  802367:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236a:	8b 40 08             	mov    0x8(%eax),%eax
  80236d:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802372:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802375:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80237c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80237f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802386:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80238b:	48                   	dec    %eax
  80238c:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802391:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802395:	74 06                	je     80239d <smalloc+0x325>
  802397:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80239b:	75 17                	jne    8023b4 <smalloc+0x33c>
  80239d:	83 ec 04             	sub    $0x4,%esp
  8023a0:	68 9c 47 80 00       	push   $0x80479c
  8023a5:	68 78 01 00 00       	push   $0x178
  8023aa:	68 0c 47 80 00       	push   $0x80470c
  8023af:	e8 83 19 00 00       	call   803d37 <_panic>
  8023b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8023ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023bd:	89 50 0c             	mov    %edx,0xc(%eax)
  8023c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c6:	89 50 08             	mov    %edx,0x8(%eax)
  8023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	74 0e                	je     8023e1 <smalloc+0x369>
  8023d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023dc:	89 50 08             	mov    %edx,0x8(%eax)
  8023df:	eb 08                	jmp    8023e9 <smalloc+0x371>
  8023e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023e4:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8023e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023ef:	89 50 0c             	mov    %edx,0xc(%eax)
  8023f2:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8023f7:	40                   	inc    %eax
  8023f8:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		break;
  8023fd:	eb 13                	jmp    802412 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  8023ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802402:	8b 40 08             	mov    0x8(%eax),%eax
  802405:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802408:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80240c:	0f 85 e3 fe ff ff    	jne    8022f5 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802412:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802415:	8b 00                	mov    (%eax),%eax
  802417:	89 c2                	mov    %eax,%edx
  802419:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80241d:	52                   	push   %edx
  80241e:	50                   	push   %eax
  80241f:	ff 75 0c             	pushl  0xc(%ebp)
  802422:	ff 75 08             	pushl  0x8(%ebp)
  802425:	e8 ea 09 00 00       	call   802e14 <sys_create_shared_object>
  80242a:	83 c4 10             	add    $0x10,%esp
  80242d:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802430:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802434:	79 28                	jns    80245e <smalloc+0x3e6>
	                	free_block(allocblock);
  802436:	83 ec 0c             	sub    $0xc,%esp
  802439:	ff 75 ec             	pushl  -0x14(%ebp)
  80243c:	e8 71 14 00 00       	call   8038b2 <free_block>
  802441:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802444:	83 ec 0c             	sub    $0xc,%esp
  802447:	68 40 d1 81 00       	push   $0x81d140
  80244c:	e8 85 18 00 00       	call   803cd6 <release_uspinlock>
  802451:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802454:	b8 00 00 00 00       	mov    $0x0,%eax
  802459:	e9 bf 01 00 00       	jmp    80261d <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  80245e:	83 ec 0c             	sub    $0xc,%esp
  802461:	68 40 d1 81 00       	push   $0x81d140
  802466:	e8 6b 18 00 00       	call   803cd6 <release_uspinlock>
  80246b:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  80246e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802471:	8b 00                	mov    (%eax),%eax
  802473:	e9 a5 01 00 00       	jmp    80261d <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 40 04             	mov    0x4(%eax),%eax
  80247e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802481:	0f 85 60 01 00 00    	jne    8025e7 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 10                	mov    (%eax),%edx
  80248c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248f:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802494:	8b 55 0c             	mov    0xc(%ebp),%edx
  802497:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  80249a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80249e:	75 17                	jne    8024b7 <smalloc+0x43f>
  8024a0:	83 ec 04             	sub    $0x4,%esp
  8024a3:	68 58 47 80 00       	push   $0x804758
  8024a8:	68 8c 01 00 00       	push   $0x18c
  8024ad:	68 0c 47 80 00       	push   $0x80470c
  8024b2:	e8 80 18 00 00       	call   803d37 <_panic>
  8024b7:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8024bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c0:	89 50 0c             	mov    %edx,0xc(%eax)
  8024c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	74 0d                	je     8024da <smalloc+0x462>
  8024cd:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8024d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024d5:	89 50 08             	mov    %edx,0x8(%eax)
  8024d8:	eb 08                	jmp    8024e2 <smalloc+0x46a>
  8024da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024dd:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8024e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e5:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8024ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8024f4:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8024f9:	40                   	inc    %eax
  8024fa:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8024ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802503:	75 17                	jne    80251c <smalloc+0x4a4>
  802505:	83 ec 04             	sub    $0x4,%esp
  802508:	68 7b 47 80 00       	push   $0x80477b
  80250d:	68 8d 01 00 00       	push   $0x18d
  802512:	68 0c 47 80 00       	push   $0x80470c
  802517:	e8 1b 18 00 00       	call   803d37 <_panic>
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 40 08             	mov    0x8(%eax),%eax
  802522:	85 c0                	test   %eax,%eax
  802524:	74 11                	je     802537 <smalloc+0x4bf>
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 40 08             	mov    0x8(%eax),%eax
  80252c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252f:	8b 52 0c             	mov    0xc(%edx),%edx
  802532:	89 50 0c             	mov    %edx,0xc(%eax)
  802535:	eb 0b                	jmp    802542 <smalloc+0x4ca>
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 0c             	mov    0xc(%eax),%eax
  80253d:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 40 0c             	mov    0xc(%eax),%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	74 11                	je     80255d <smalloc+0x4e5>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 40 0c             	mov    0xc(%eax),%eax
  802552:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802555:	8b 52 08             	mov    0x8(%edx),%edx
  802558:	89 50 08             	mov    %edx,0x8(%eax)
  80255b:	eb 0b                	jmp    802568 <smalloc+0x4f0>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 40 08             	mov    0x8(%eax),%eax
  802563:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80257c:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802581:	48                   	dec    %eax
  802582:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	89 c2                	mov    %eax,%edx
  80258e:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802592:	52                   	push   %edx
  802593:	50                   	push   %eax
  802594:	ff 75 0c             	pushl  0xc(%ebp)
  802597:	ff 75 08             	pushl  0x8(%ebp)
  80259a:	e8 75 08 00 00       	call   802e14 <sys_create_shared_object>
  80259f:	83 c4 10             	add    $0x10,%esp
  8025a2:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  8025a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8025a9:	79 25                	jns    8025d0 <smalloc+0x558>
						free_block(allocblock);
  8025ab:	83 ec 0c             	sub    $0xc,%esp
  8025ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8025b1:	e8 fc 12 00 00       	call   8038b2 <free_block>
  8025b6:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8025b9:	83 ec 0c             	sub    $0xc,%esp
  8025bc:	68 40 d1 81 00       	push   $0x81d140
  8025c1:	e8 10 17 00 00       	call   803cd6 <release_uspinlock>
  8025c6:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8025c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ce:	eb 4d                	jmp    80261d <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  8025d0:	83 ec 0c             	sub    $0xc,%esp
  8025d3:	68 40 d1 81 00       	push   $0x81d140
  8025d8:	e8 f9 16 00 00       	call   803cd6 <release_uspinlock>
  8025dd:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8025e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e3:	8b 00                	mov    (%eax),%eax
  8025e5:	eb 36                	jmp    80261d <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 40 08             	mov    0x8(%eax),%eax
  8025ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8025f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f4:	0f 85 47 fc ff ff    	jne    802241 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8025fa:	83 ec 0c             	sub    $0xc,%esp
  8025fd:	ff 75 ec             	pushl  -0x14(%ebp)
  802600:	e8 ad 12 00 00       	call   8038b2 <free_block>
  802605:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802608:	83 ec 0c             	sub    $0xc,%esp
  80260b:	68 40 d1 81 00       	push   $0x81d140
  802610:	e8 c1 16 00 00       	call   803cd6 <release_uspinlock>
  802615:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
  802622:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802625:	e8 8c ec ff ff       	call   8012b6 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  80262a:	83 ec 0c             	sub    $0xc,%esp
  80262d:	68 40 d1 81 00       	push   $0x81d140
  802632:	e8 47 16 00 00       	call   803c7e <acquire_uspinlock>
  802637:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  80263a:	83 ec 08             	sub    $0x8,%esp
  80263d:	ff 75 0c             	pushl  0xc(%ebp)
  802640:	ff 75 08             	pushl  0x8(%ebp)
  802643:	e8 f6 07 00 00       	call   802e3e <sys_size_of_shared_object>
  802648:	83 c4 10             	add    $0x10,%esp
  80264b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  80264e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802652:	79 1a                	jns    80266e <sget+0x4f>
			release_uspinlock(&ulock);
  802654:	83 ec 0c             	sub    $0xc,%esp
  802657:	68 40 d1 81 00       	push   $0x81d140
  80265c:	e8 75 16 00 00       	call   803cd6 <release_uspinlock>
  802661:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802664:	b8 00 00 00 00       	mov    $0x0,%eax
  802669:	e9 6e 05 00 00       	jmp    802bdc <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  80266e:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802675:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802678:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267b:	01 d0                	add    %edx,%eax
  80267d:	48                   	dec    %eax
  80267e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802684:	ba 00 00 00 00       	mov    $0x0,%edx
  802689:	f7 75 e8             	divl   -0x18(%ebp)
  80268c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268f:	29 d0                	sub    %edx,%eax
  802691:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802694:	83 ec 0c             	sub    $0xc,%esp
  802697:	6a 10                	push   $0x10
  802699:	e8 78 0d 00 00       	call   803416 <alloc_block>
  80269e:	83 c4 10             	add    $0x10,%esp
  8026a1:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  8026a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026a8:	75 0a                	jne    8026b4 <sget+0x95>
			return NULL;
  8026aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8026af:	e9 28 05 00 00       	jmp    802bdc <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8026b4:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8026b9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8026bc:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	74 11                	je     8026d6 <sget+0xb7>
  8026c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026c8:	8b 50 04             	mov    0x4(%eax),%edx
  8026cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ce:	39 c2                	cmp    %eax,%edx
  8026d0:	0f 83 21 01 00 00    	jae    8027f7 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8026d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d9:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  8026de:	29 c2                	sub    %eax,%edx
  8026e0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026e5:	39 c2                	cmp    %eax,%edx
  8026e7:	0f 82 f0 00 00 00    	jb     8027dd <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  8026ed:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  8026f5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8026fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fe:	01 d0                	add    %edx,%eax
  802700:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  802705:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802708:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80270b:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  80270d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802710:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802713:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802716:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80271a:	75 17                	jne    802733 <sget+0x114>
  80271c:	83 ec 04             	sub    $0x4,%esp
  80271f:	68 58 47 80 00       	push   $0x804758
  802724:	68 c8 01 00 00       	push   $0x1c8
  802729:	68 0c 47 80 00       	push   $0x80470c
  80272e:	e8 04 16 00 00       	call   803d37 <_panic>
  802733:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802739:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273c:	89 50 0c             	mov    %edx,0xc(%eax)
  80273f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802742:	8b 40 0c             	mov    0xc(%eax),%eax
  802745:	85 c0                	test   %eax,%eax
  802747:	74 0d                	je     802756 <sget+0x137>
  802749:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80274e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802751:	89 50 08             	mov    %edx,0x8(%eax)
  802754:	eb 08                	jmp    80275e <sget+0x13f>
  802756:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802759:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80275e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802761:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802766:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802769:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802770:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802775:	40                   	inc    %eax
  802776:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80277b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	83 ec 04             	sub    $0x4,%esp
  802783:	50                   	push   %eax
  802784:	ff 75 0c             	pushl  0xc(%ebp)
  802787:	ff 75 08             	pushl  0x8(%ebp)
  80278a:	e8 cc 06 00 00       	call   802e5b <sys_get_shared_object>
  80278f:	83 c4 10             	add    $0x10,%esp
  802792:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802795:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802799:	79 28                	jns    8027c3 <sget+0x1a4>
							free_block(allocblock);
  80279b:	83 ec 0c             	sub    $0xc,%esp
  80279e:	ff 75 e0             	pushl  -0x20(%ebp)
  8027a1:	e8 0c 11 00 00       	call   8038b2 <free_block>
  8027a6:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8027a9:	83 ec 0c             	sub    $0xc,%esp
  8027ac:	68 40 d1 81 00       	push   $0x81d140
  8027b1:	e8 20 15 00 00       	call   803cd6 <release_uspinlock>
  8027b6:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8027b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027be:	e9 19 04 00 00       	jmp    802bdc <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  8027c3:	83 ec 0c             	sub    $0xc,%esp
  8027c6:	68 40 d1 81 00       	push   $0x81d140
  8027cb:	e8 06 15 00 00       	call   803cd6 <release_uspinlock>
  8027d0:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8027d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	e9 ff 03 00 00       	jmp    802bdc <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  8027dd:	83 ec 0c             	sub    $0xc,%esp
  8027e0:	68 40 d1 81 00       	push   $0x81d140
  8027e5:	e8 ec 14 00 00       	call   803cd6 <release_uspinlock>
  8027ea:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8027ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f2:	e9 e5 03 00 00       	jmp    802bdc <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8027f7:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8027fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8027ff:	e9 ab 03 00 00       	jmp    802baf <sget+0x590>
				if(size<currentfreeelement->size){
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 50 04             	mov    0x4(%eax),%edx
  80280a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280d:	39 c2                	cmp    %eax,%edx
  80280f:	0f 86 24 02 00 00    	jbe    802a39 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802815:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802818:	8b 10                	mov    (%eax),%edx
  80281a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281d:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80281f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802822:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802825:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802828:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80282c:	75 17                	jne    802845 <sget+0x226>
  80282e:	83 ec 04             	sub    $0x4,%esp
  802831:	68 58 47 80 00       	push   $0x804758
  802836:	68 e0 01 00 00       	push   $0x1e0
  80283b:	68 0c 47 80 00       	push   $0x80470c
  802840:	e8 f2 14 00 00       	call   803d37 <_panic>
  802845:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  80284b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80284e:	89 50 0c             	mov    %edx,0xc(%eax)
  802851:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802854:	8b 40 0c             	mov    0xc(%eax),%eax
  802857:	85 c0                	test   %eax,%eax
  802859:	74 0d                	je     802868 <sget+0x249>
  80285b:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802860:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802863:	89 50 08             	mov    %edx,0x8(%eax)
  802866:	eb 08                	jmp    802870 <sget+0x251>
  802868:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286b:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802870:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802873:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802878:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802882:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802887:	40                   	inc    %eax
  802888:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					lastfreeelement->startva += size;
  80288d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802890:	8b 10                	mov    (%eax),%edx
  802892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802895:	01 c2                	add    %eax,%edx
  802897:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80289a:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  80289c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80289f:	8b 50 04             	mov    0x4(%eax),%edx
  8028a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a5:	29 c2                	sub    %eax,%edx
  8028a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028aa:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8028ad:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8028b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  8028b5:	e9 13 01 00 00       	jmp    8029cd <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  8028ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028bd:	8b 50 04             	mov    0x4(%eax),%edx
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	8b 40 04             	mov    0x4(%eax),%eax
  8028c6:	39 c2                	cmp    %eax,%edx
  8028c8:	0f 83 f6 00 00 00    	jae    8029c4 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  8028ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8028d2:	75 17                	jne    8028eb <sget+0x2cc>
  8028d4:	83 ec 04             	sub    $0x4,%esp
  8028d7:	68 7b 47 80 00       	push   $0x80477b
  8028dc:	68 e8 01 00 00       	push   $0x1e8
  8028e1:	68 0c 47 80 00       	push   $0x80470c
  8028e6:	e8 4c 14 00 00       	call   803d37 <_panic>
  8028eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028ee:	8b 40 08             	mov    0x8(%eax),%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	74 11                	je     802906 <sget+0x2e7>
  8028f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028f8:	8b 40 08             	mov    0x8(%eax),%eax
  8028fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028fe:	8b 52 0c             	mov    0xc(%edx),%edx
  802901:	89 50 0c             	mov    %edx,0xc(%eax)
  802904:	eb 0b                	jmp    802911 <sget+0x2f2>
  802906:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802909:	8b 40 0c             	mov    0xc(%eax),%eax
  80290c:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802911:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802914:	8b 40 0c             	mov    0xc(%eax),%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	74 11                	je     80292c <sget+0x30d>
  80291b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80291e:	8b 40 0c             	mov    0xc(%eax),%eax
  802921:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802924:	8b 52 08             	mov    0x8(%edx),%edx
  802927:	89 50 08             	mov    %edx,0x8(%eax)
  80292a:	eb 0b                	jmp    802937 <sget+0x318>
  80292c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80292f:	8b 40 08             	mov    0x8(%eax),%eax
  802932:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802937:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80293a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802941:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802944:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80294b:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802950:	48                   	dec    %eax
  802951:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802956:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80295a:	74 06                	je     802962 <sget+0x343>
  80295c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802960:	75 17                	jne    802979 <sget+0x35a>
  802962:	83 ec 04             	sub    $0x4,%esp
  802965:	68 9c 47 80 00       	push   $0x80479c
  80296a:	68 e9 01 00 00       	push   $0x1e9
  80296f:	68 0c 47 80 00       	push   $0x80470c
  802974:	e8 be 13 00 00       	call   803d37 <_panic>
  802979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297c:	8b 50 0c             	mov    0xc(%eax),%edx
  80297f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802982:	89 50 0c             	mov    %edx,0xc(%eax)
  802985:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802988:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298b:	89 50 08             	mov    %edx,0x8(%eax)
  80298e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802991:	8b 40 0c             	mov    0xc(%eax),%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	74 0e                	je     8029a6 <sget+0x387>
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	8b 40 0c             	mov    0xc(%eax),%eax
  80299e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029a1:	89 50 08             	mov    %edx,0x8(%eax)
  8029a4:	eb 08                	jmp    8029ae <sget+0x38f>
  8029a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029a9:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8029ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029b4:	89 50 0c             	mov    %edx,0xc(%eax)
  8029b7:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8029bc:	40                   	inc    %eax
  8029bd:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							break;
  8029c2:	eb 13                	jmp    8029d7 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  8029cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d1:	0f 85 e3 fe ff ff    	jne    8028ba <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  8029d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029da:	8b 00                	mov    (%eax),%eax
  8029dc:	83 ec 04             	sub    $0x4,%esp
  8029df:	50                   	push   %eax
  8029e0:	ff 75 0c             	pushl  0xc(%ebp)
  8029e3:	ff 75 08             	pushl  0x8(%ebp)
  8029e6:	e8 70 04 00 00       	call   802e5b <sys_get_shared_object>
  8029eb:	83 c4 10             	add    $0x10,%esp
  8029ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  8029f1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8029f5:	79 28                	jns    802a1f <sget+0x400>
						free_block(allocblock);
  8029f7:	83 ec 0c             	sub    $0xc,%esp
  8029fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8029fd:	e8 b0 0e 00 00       	call   8038b2 <free_block>
  802a02:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802a05:	83 ec 0c             	sub    $0xc,%esp
  802a08:	68 40 d1 81 00       	push   $0x81d140
  802a0d:	e8 c4 12 00 00       	call   803cd6 <release_uspinlock>
  802a12:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802a15:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1a:	e9 bd 01 00 00       	jmp    802bdc <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802a1f:	83 ec 0c             	sub    $0xc,%esp
  802a22:	68 40 d1 81 00       	push   $0x81d140
  802a27:	e8 aa 12 00 00       	call   803cd6 <release_uspinlock>
  802a2c:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802a2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a32:	8b 00                	mov    (%eax),%eax
  802a34:	e9 a3 01 00 00       	jmp    802bdc <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 50 04             	mov    0x4(%eax),%edx
  802a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a42:	39 c2                	cmp    %eax,%edx
  802a44:	0f 85 5c 01 00 00    	jne    802ba6 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 10                	mov    (%eax),%edx
  802a4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a52:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802a54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802a5d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a61:	75 17                	jne    802a7a <sget+0x45b>
  802a63:	83 ec 04             	sub    $0x4,%esp
  802a66:	68 58 47 80 00       	push   $0x804758
  802a6b:	68 fe 01 00 00       	push   $0x1fe
  802a70:	68 0c 47 80 00       	push   $0x80470c
  802a75:	e8 bd 12 00 00       	call   803d37 <_panic>
  802a7a:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a83:	89 50 0c             	mov    %edx,0xc(%eax)
  802a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a89:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	74 0d                	je     802a9d <sget+0x47e>
  802a90:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802a95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a98:	89 50 08             	mov    %edx,0x8(%eax)
  802a9b:	eb 08                	jmp    802aa5 <sget+0x486>
  802a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa0:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802aa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa8:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ab7:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802abc:	40                   	inc    %eax
  802abd:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac6:	75 17                	jne    802adf <sget+0x4c0>
  802ac8:	83 ec 04             	sub    $0x4,%esp
  802acb:	68 7b 47 80 00       	push   $0x80477b
  802ad0:	68 ff 01 00 00       	push   $0x1ff
  802ad5:	68 0c 47 80 00       	push   $0x80470c
  802ada:	e8 58 12 00 00       	call   803d37 <_panic>
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 40 08             	mov    0x8(%eax),%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 11                	je     802afa <sget+0x4db>
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 40 08             	mov    0x8(%eax),%eax
  802aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af2:	8b 52 0c             	mov    0xc(%edx),%edx
  802af5:	89 50 0c             	mov    %edx,0xc(%eax)
  802af8:	eb 0b                	jmp    802b05 <sget+0x4e6>
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	8b 40 0c             	mov    0xc(%eax),%eax
  802b00:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	74 11                	je     802b20 <sget+0x501>
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 0c             	mov    0xc(%eax),%eax
  802b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b18:	8b 52 08             	mov    0x8(%edx),%edx
  802b1b:	89 50 08             	mov    %edx,0x8(%eax)
  802b1e:	eb 0b                	jmp    802b2b <sget+0x50c>
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 40 08             	mov    0x8(%eax),%eax
  802b26:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b3f:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802b44:	48                   	dec    %eax
  802b45:	a3 2c d1 81 00       	mov    %eax,0x81d12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802b4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	83 ec 04             	sub    $0x4,%esp
  802b52:	50                   	push   %eax
  802b53:	ff 75 0c             	pushl  0xc(%ebp)
  802b56:	ff 75 08             	pushl  0x8(%ebp)
  802b59:	e8 fd 02 00 00       	call   802e5b <sys_get_shared_object>
  802b5e:	83 c4 10             	add    $0x10,%esp
  802b61:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802b64:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802b68:	79 25                	jns    802b8f <sget+0x570>
						free_block(allocblock);
  802b6a:	83 ec 0c             	sub    $0xc,%esp
  802b6d:	ff 75 e0             	pushl  -0x20(%ebp)
  802b70:	e8 3d 0d 00 00       	call   8038b2 <free_block>
  802b75:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802b78:	83 ec 0c             	sub    $0xc,%esp
  802b7b:	68 40 d1 81 00       	push   $0x81d140
  802b80:	e8 51 11 00 00       	call   803cd6 <release_uspinlock>
  802b85:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802b88:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8d:	eb 4d                	jmp    802bdc <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802b8f:	83 ec 0c             	sub    $0xc,%esp
  802b92:	68 40 d1 81 00       	push   $0x81d140
  802b97:	e8 3a 11 00 00       	call   803cd6 <release_uspinlock>
  802b9c:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802b9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	eb 36                	jmp    802bdc <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 40 08             	mov    0x8(%eax),%eax
  802bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802baf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb3:	0f 85 4b fc ff ff    	jne    802804 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802bb9:	83 ec 0c             	sub    $0xc,%esp
  802bbc:	ff 75 e0             	pushl  -0x20(%ebp)
  802bbf:	e8 ee 0c 00 00       	call   8038b2 <free_block>
  802bc4:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802bc7:	83 ec 0c             	sub    $0xc,%esp
  802bca:	68 40 d1 81 00       	push   $0x81d140
  802bcf:	e8 02 11 00 00       	call   803cd6 <release_uspinlock>
  802bd4:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bdc:	c9                   	leave  
  802bdd:	c3                   	ret    

00802bde <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802bde:	55                   	push   %ebp
  802bdf:	89 e5                	mov    %esp,%ebp
  802be1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802be4:	e8 cd e6 ff ff       	call   8012b6 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802be9:	83 ec 04             	sub    $0x4,%esp
  802bec:	68 2c 48 80 00       	push   $0x80482c
  802bf1:	68 2d 02 00 00       	push   $0x22d
  802bf6:	68 0c 47 80 00       	push   $0x80470c
  802bfb:	e8 37 11 00 00       	call   803d37 <_panic>

00802c00 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802c00:	55                   	push   %ebp
  802c01:	89 e5                	mov    %esp,%ebp
  802c03:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802c06:	83 ec 04             	sub    $0x4,%esp
  802c09:	68 54 48 80 00       	push   $0x804854
  802c0e:	68 40 02 00 00       	push   $0x240
  802c13:	68 0c 47 80 00       	push   $0x80470c
  802c18:	e8 1a 11 00 00       	call   803d37 <_panic>

00802c1d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802c1d:	55                   	push   %ebp
  802c1e:	89 e5                	mov    %esp,%ebp
  802c20:	57                   	push   %edi
  802c21:	56                   	push   %esi
  802c22:	53                   	push   %ebx
  802c23:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c2f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c32:	8b 7d 18             	mov    0x18(%ebp),%edi
  802c35:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802c38:	cd 30                	int    $0x30
  802c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802c40:	83 c4 10             	add    $0x10,%esp
  802c43:	5b                   	pop    %ebx
  802c44:	5e                   	pop    %esi
  802c45:	5f                   	pop    %edi
  802c46:	5d                   	pop    %ebp
  802c47:	c3                   	ret    

00802c48 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802c48:	55                   	push   %ebp
  802c49:	89 e5                	mov    %esp,%ebp
  802c4b:	83 ec 04             	sub    $0x4,%esp
  802c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  802c51:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802c54:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c57:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	6a 00                	push   $0x0
  802c60:	51                   	push   %ecx
  802c61:	52                   	push   %edx
  802c62:	ff 75 0c             	pushl  0xc(%ebp)
  802c65:	50                   	push   %eax
  802c66:	6a 00                	push   $0x0
  802c68:	e8 b0 ff ff ff       	call   802c1d <syscall>
  802c6d:	83 c4 18             	add    $0x18,%esp
}
  802c70:	90                   	nop
  802c71:	c9                   	leave  
  802c72:	c3                   	ret    

00802c73 <sys_cgetc>:

int
sys_cgetc(void)
{
  802c73:	55                   	push   %ebp
  802c74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802c76:	6a 00                	push   $0x0
  802c78:	6a 00                	push   $0x0
  802c7a:	6a 00                	push   $0x0
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 02                	push   $0x2
  802c82:	e8 96 ff ff ff       	call   802c1d <syscall>
  802c87:	83 c4 18             	add    $0x18,%esp
}
  802c8a:	c9                   	leave  
  802c8b:	c3                   	ret    

00802c8c <sys_lock_cons>:

void sys_lock_cons(void)
{
  802c8c:	55                   	push   %ebp
  802c8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802c8f:	6a 00                	push   $0x0
  802c91:	6a 00                	push   $0x0
  802c93:	6a 00                	push   $0x0
  802c95:	6a 00                	push   $0x0
  802c97:	6a 00                	push   $0x0
  802c99:	6a 03                	push   $0x3
  802c9b:	e8 7d ff ff ff       	call   802c1d <syscall>
  802ca0:	83 c4 18             	add    $0x18,%esp
}
  802ca3:	90                   	nop
  802ca4:	c9                   	leave  
  802ca5:	c3                   	ret    

00802ca6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802ca6:	55                   	push   %ebp
  802ca7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802ca9:	6a 00                	push   $0x0
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 00                	push   $0x0
  802cb3:	6a 04                	push   $0x4
  802cb5:	e8 63 ff ff ff       	call   802c1d <syscall>
  802cba:	83 c4 18             	add    $0x18,%esp
}
  802cbd:	90                   	nop
  802cbe:	c9                   	leave  
  802cbf:	c3                   	ret    

00802cc0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	6a 00                	push   $0x0
  802ccb:	6a 00                	push   $0x0
  802ccd:	6a 00                	push   $0x0
  802ccf:	52                   	push   %edx
  802cd0:	50                   	push   %eax
  802cd1:	6a 08                	push   $0x8
  802cd3:	e8 45 ff ff ff       	call   802c1d <syscall>
  802cd8:	83 c4 18             	add    $0x18,%esp
}
  802cdb:	c9                   	leave  
  802cdc:	c3                   	ret    

00802cdd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802cdd:	55                   	push   %ebp
  802cde:	89 e5                	mov    %esp,%ebp
  802ce0:	56                   	push   %esi
  802ce1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802ce2:	8b 75 18             	mov    0x18(%ebp),%esi
  802ce5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ce8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	56                   	push   %esi
  802cf2:	53                   	push   %ebx
  802cf3:	51                   	push   %ecx
  802cf4:	52                   	push   %edx
  802cf5:	50                   	push   %eax
  802cf6:	6a 09                	push   $0x9
  802cf8:	e8 20 ff ff ff       	call   802c1d <syscall>
  802cfd:	83 c4 18             	add    $0x18,%esp
}
  802d00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d03:	5b                   	pop    %ebx
  802d04:	5e                   	pop    %esi
  802d05:	5d                   	pop    %ebp
  802d06:	c3                   	ret    

00802d07 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802d07:	55                   	push   %ebp
  802d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802d0a:	6a 00                	push   $0x0
  802d0c:	6a 00                	push   $0x0
  802d0e:	6a 00                	push   $0x0
  802d10:	6a 00                	push   $0x0
  802d12:	ff 75 08             	pushl  0x8(%ebp)
  802d15:	6a 0a                	push   $0xa
  802d17:	e8 01 ff ff ff       	call   802c1d <syscall>
  802d1c:	83 c4 18             	add    $0x18,%esp
}
  802d1f:	c9                   	leave  
  802d20:	c3                   	ret    

00802d21 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802d21:	55                   	push   %ebp
  802d22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802d24:	6a 00                	push   $0x0
  802d26:	6a 00                	push   $0x0
  802d28:	6a 00                	push   $0x0
  802d2a:	ff 75 0c             	pushl  0xc(%ebp)
  802d2d:	ff 75 08             	pushl  0x8(%ebp)
  802d30:	6a 0b                	push   $0xb
  802d32:	e8 e6 fe ff ff       	call   802c1d <syscall>
  802d37:	83 c4 18             	add    $0x18,%esp
}
  802d3a:	c9                   	leave  
  802d3b:	c3                   	ret    

00802d3c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802d3c:	55                   	push   %ebp
  802d3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802d3f:	6a 00                	push   $0x0
  802d41:	6a 00                	push   $0x0
  802d43:	6a 00                	push   $0x0
  802d45:	6a 00                	push   $0x0
  802d47:	6a 00                	push   $0x0
  802d49:	6a 0c                	push   $0xc
  802d4b:	e8 cd fe ff ff       	call   802c1d <syscall>
  802d50:	83 c4 18             	add    $0x18,%esp
}
  802d53:	c9                   	leave  
  802d54:	c3                   	ret    

00802d55 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802d55:	55                   	push   %ebp
  802d56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802d58:	6a 00                	push   $0x0
  802d5a:	6a 00                	push   $0x0
  802d5c:	6a 00                	push   $0x0
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 00                	push   $0x0
  802d62:	6a 0d                	push   $0xd
  802d64:	e8 b4 fe ff ff       	call   802c1d <syscall>
  802d69:	83 c4 18             	add    $0x18,%esp
}
  802d6c:	c9                   	leave  
  802d6d:	c3                   	ret    

00802d6e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802d6e:	55                   	push   %ebp
  802d6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802d71:	6a 00                	push   $0x0
  802d73:	6a 00                	push   $0x0
  802d75:	6a 00                	push   $0x0
  802d77:	6a 00                	push   $0x0
  802d79:	6a 00                	push   $0x0
  802d7b:	6a 0e                	push   $0xe
  802d7d:	e8 9b fe ff ff       	call   802c1d <syscall>
  802d82:	83 c4 18             	add    $0x18,%esp
}
  802d85:	c9                   	leave  
  802d86:	c3                   	ret    

00802d87 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802d87:	55                   	push   %ebp
  802d88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802d8a:	6a 00                	push   $0x0
  802d8c:	6a 00                	push   $0x0
  802d8e:	6a 00                	push   $0x0
  802d90:	6a 00                	push   $0x0
  802d92:	6a 00                	push   $0x0
  802d94:	6a 0f                	push   $0xf
  802d96:	e8 82 fe ff ff       	call   802c1d <syscall>
  802d9b:	83 c4 18             	add    $0x18,%esp
}
  802d9e:	c9                   	leave  
  802d9f:	c3                   	ret    

00802da0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802da3:	6a 00                	push   $0x0
  802da5:	6a 00                	push   $0x0
  802da7:	6a 00                	push   $0x0
  802da9:	6a 00                	push   $0x0
  802dab:	ff 75 08             	pushl  0x8(%ebp)
  802dae:	6a 10                	push   $0x10
  802db0:	e8 68 fe ff ff       	call   802c1d <syscall>
  802db5:	83 c4 18             	add    $0x18,%esp
}
  802db8:	c9                   	leave  
  802db9:	c3                   	ret    

00802dba <sys_scarce_memory>:

void sys_scarce_memory()
{
  802dba:	55                   	push   %ebp
  802dbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802dbd:	6a 00                	push   $0x0
  802dbf:	6a 00                	push   $0x0
  802dc1:	6a 00                	push   $0x0
  802dc3:	6a 00                	push   $0x0
  802dc5:	6a 00                	push   $0x0
  802dc7:	6a 11                	push   $0x11
  802dc9:	e8 4f fe ff ff       	call   802c1d <syscall>
  802dce:	83 c4 18             	add    $0x18,%esp
}
  802dd1:	90                   	nop
  802dd2:	c9                   	leave  
  802dd3:	c3                   	ret    

00802dd4 <sys_cputc>:

void
sys_cputc(const char c)
{
  802dd4:	55                   	push   %ebp
  802dd5:	89 e5                	mov    %esp,%ebp
  802dd7:	83 ec 04             	sub    $0x4,%esp
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802de0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802de4:	6a 00                	push   $0x0
  802de6:	6a 00                	push   $0x0
  802de8:	6a 00                	push   $0x0
  802dea:	6a 00                	push   $0x0
  802dec:	50                   	push   %eax
  802ded:	6a 01                	push   $0x1
  802def:	e8 29 fe ff ff       	call   802c1d <syscall>
  802df4:	83 c4 18             	add    $0x18,%esp
}
  802df7:	90                   	nop
  802df8:	c9                   	leave  
  802df9:	c3                   	ret    

00802dfa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802dfa:	55                   	push   %ebp
  802dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802dfd:	6a 00                	push   $0x0
  802dff:	6a 00                	push   $0x0
  802e01:	6a 00                	push   $0x0
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 14                	push   $0x14
  802e09:	e8 0f fe ff ff       	call   802c1d <syscall>
  802e0e:	83 c4 18             	add    $0x18,%esp
}
  802e11:	90                   	nop
  802e12:	c9                   	leave  
  802e13:	c3                   	ret    

00802e14 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802e14:	55                   	push   %ebp
  802e15:	89 e5                	mov    %esp,%ebp
  802e17:	83 ec 04             	sub    $0x4,%esp
  802e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  802e1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802e20:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e23:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	6a 00                	push   $0x0
  802e2c:	51                   	push   %ecx
  802e2d:	52                   	push   %edx
  802e2e:	ff 75 0c             	pushl  0xc(%ebp)
  802e31:	50                   	push   %eax
  802e32:	6a 15                	push   $0x15
  802e34:	e8 e4 fd ff ff       	call   802c1d <syscall>
  802e39:	83 c4 18             	add    $0x18,%esp
}
  802e3c:	c9                   	leave  
  802e3d:	c3                   	ret    

00802e3e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802e3e:	55                   	push   %ebp
  802e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802e41:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	6a 00                	push   $0x0
  802e49:	6a 00                	push   $0x0
  802e4b:	6a 00                	push   $0x0
  802e4d:	52                   	push   %edx
  802e4e:	50                   	push   %eax
  802e4f:	6a 16                	push   $0x16
  802e51:	e8 c7 fd ff ff       	call   802c1d <syscall>
  802e56:	83 c4 18             	add    $0x18,%esp
}
  802e59:	c9                   	leave  
  802e5a:	c3                   	ret    

00802e5b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802e5b:	55                   	push   %ebp
  802e5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802e5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e61:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	6a 00                	push   $0x0
  802e69:	6a 00                	push   $0x0
  802e6b:	51                   	push   %ecx
  802e6c:	52                   	push   %edx
  802e6d:	50                   	push   %eax
  802e6e:	6a 17                	push   $0x17
  802e70:	e8 a8 fd ff ff       	call   802c1d <syscall>
  802e75:	83 c4 18             	add    $0x18,%esp
}
  802e78:	c9                   	leave  
  802e79:	c3                   	ret    

00802e7a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802e7a:	55                   	push   %ebp
  802e7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	6a 00                	push   $0x0
  802e85:	6a 00                	push   $0x0
  802e87:	6a 00                	push   $0x0
  802e89:	52                   	push   %edx
  802e8a:	50                   	push   %eax
  802e8b:	6a 18                	push   $0x18
  802e8d:	e8 8b fd ff ff       	call   802c1d <syscall>
  802e92:	83 c4 18             	add    $0x18,%esp
}
  802e95:	c9                   	leave  
  802e96:	c3                   	ret    

00802e97 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802e97:	55                   	push   %ebp
  802e98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9d:	6a 00                	push   $0x0
  802e9f:	ff 75 14             	pushl  0x14(%ebp)
  802ea2:	ff 75 10             	pushl  0x10(%ebp)
  802ea5:	ff 75 0c             	pushl  0xc(%ebp)
  802ea8:	50                   	push   %eax
  802ea9:	6a 19                	push   $0x19
  802eab:	e8 6d fd ff ff       	call   802c1d <syscall>
  802eb0:	83 c4 18             	add    $0x18,%esp
}
  802eb3:	c9                   	leave  
  802eb4:	c3                   	ret    

00802eb5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802eb5:	55                   	push   %ebp
  802eb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	6a 00                	push   $0x0
  802ebd:	6a 00                	push   $0x0
  802ebf:	6a 00                	push   $0x0
  802ec1:	6a 00                	push   $0x0
  802ec3:	50                   	push   %eax
  802ec4:	6a 1a                	push   $0x1a
  802ec6:	e8 52 fd ff ff       	call   802c1d <syscall>
  802ecb:	83 c4 18             	add    $0x18,%esp
}
  802ece:	90                   	nop
  802ecf:	c9                   	leave  
  802ed0:	c3                   	ret    

00802ed1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802ed1:	55                   	push   %ebp
  802ed2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	6a 00                	push   $0x0
  802ed9:	6a 00                	push   $0x0
  802edb:	6a 00                	push   $0x0
  802edd:	6a 00                	push   $0x0
  802edf:	50                   	push   %eax
  802ee0:	6a 1b                	push   $0x1b
  802ee2:	e8 36 fd ff ff       	call   802c1d <syscall>
  802ee7:	83 c4 18             	add    $0x18,%esp
}
  802eea:	c9                   	leave  
  802eeb:	c3                   	ret    

00802eec <sys_getenvid>:

int32 sys_getenvid(void)
{
  802eec:	55                   	push   %ebp
  802eed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802eef:	6a 00                	push   $0x0
  802ef1:	6a 00                	push   $0x0
  802ef3:	6a 00                	push   $0x0
  802ef5:	6a 00                	push   $0x0
  802ef7:	6a 00                	push   $0x0
  802ef9:	6a 05                	push   $0x5
  802efb:	e8 1d fd ff ff       	call   802c1d <syscall>
  802f00:	83 c4 18             	add    $0x18,%esp
}
  802f03:	c9                   	leave  
  802f04:	c3                   	ret    

00802f05 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802f05:	55                   	push   %ebp
  802f06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802f08:	6a 00                	push   $0x0
  802f0a:	6a 00                	push   $0x0
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 00                	push   $0x0
  802f12:	6a 06                	push   $0x6
  802f14:	e8 04 fd ff ff       	call   802c1d <syscall>
  802f19:	83 c4 18             	add    $0x18,%esp
}
  802f1c:	c9                   	leave  
  802f1d:	c3                   	ret    

00802f1e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802f1e:	55                   	push   %ebp
  802f1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802f21:	6a 00                	push   $0x0
  802f23:	6a 00                	push   $0x0
  802f25:	6a 00                	push   $0x0
  802f27:	6a 00                	push   $0x0
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 07                	push   $0x7
  802f2d:	e8 eb fc ff ff       	call   802c1d <syscall>
  802f32:	83 c4 18             	add    $0x18,%esp
}
  802f35:	c9                   	leave  
  802f36:	c3                   	ret    

00802f37 <sys_exit_env>:


void sys_exit_env(void)
{
  802f37:	55                   	push   %ebp
  802f38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 00                	push   $0x0
  802f3e:	6a 00                	push   $0x0
  802f40:	6a 00                	push   $0x0
  802f42:	6a 00                	push   $0x0
  802f44:	6a 1c                	push   $0x1c
  802f46:	e8 d2 fc ff ff       	call   802c1d <syscall>
  802f4b:	83 c4 18             	add    $0x18,%esp
}
  802f4e:	90                   	nop
  802f4f:	c9                   	leave  
  802f50:	c3                   	ret    

00802f51 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802f51:	55                   	push   %ebp
  802f52:	89 e5                	mov    %esp,%ebp
  802f54:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802f57:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f5a:	8d 50 04             	lea    0x4(%eax),%edx
  802f5d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f60:	6a 00                	push   $0x0
  802f62:	6a 00                	push   $0x0
  802f64:	6a 00                	push   $0x0
  802f66:	52                   	push   %edx
  802f67:	50                   	push   %eax
  802f68:	6a 1d                	push   $0x1d
  802f6a:	e8 ae fc ff ff       	call   802c1d <syscall>
  802f6f:	83 c4 18             	add    $0x18,%esp
	return result;
  802f72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802f78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f7b:	89 01                	mov    %eax,(%ecx)
  802f7d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	c9                   	leave  
  802f84:	c2 04 00             	ret    $0x4

00802f87 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802f87:	55                   	push   %ebp
  802f88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802f8a:	6a 00                	push   $0x0
  802f8c:	6a 00                	push   $0x0
  802f8e:	ff 75 10             	pushl  0x10(%ebp)
  802f91:	ff 75 0c             	pushl  0xc(%ebp)
  802f94:	ff 75 08             	pushl  0x8(%ebp)
  802f97:	6a 13                	push   $0x13
  802f99:	e8 7f fc ff ff       	call   802c1d <syscall>
  802f9e:	83 c4 18             	add    $0x18,%esp
	return ;
  802fa1:	90                   	nop
}
  802fa2:	c9                   	leave  
  802fa3:	c3                   	ret    

00802fa4 <sys_rcr2>:
uint32 sys_rcr2()
{
  802fa4:	55                   	push   %ebp
  802fa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802fa7:	6a 00                	push   $0x0
  802fa9:	6a 00                	push   $0x0
  802fab:	6a 00                	push   $0x0
  802fad:	6a 00                	push   $0x0
  802faf:	6a 00                	push   $0x0
  802fb1:	6a 1e                	push   $0x1e
  802fb3:	e8 65 fc ff ff       	call   802c1d <syscall>
  802fb8:	83 c4 18             	add    $0x18,%esp
}
  802fbb:	c9                   	leave  
  802fbc:	c3                   	ret    

00802fbd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802fbd:	55                   	push   %ebp
  802fbe:	89 e5                	mov    %esp,%ebp
  802fc0:	83 ec 04             	sub    $0x4,%esp
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802fc9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802fcd:	6a 00                	push   $0x0
  802fcf:	6a 00                	push   $0x0
  802fd1:	6a 00                	push   $0x0
  802fd3:	6a 00                	push   $0x0
  802fd5:	50                   	push   %eax
  802fd6:	6a 1f                	push   $0x1f
  802fd8:	e8 40 fc ff ff       	call   802c1d <syscall>
  802fdd:	83 c4 18             	add    $0x18,%esp
	return ;
  802fe0:	90                   	nop
}
  802fe1:	c9                   	leave  
  802fe2:	c3                   	ret    

00802fe3 <rsttst>:
void rsttst()
{
  802fe3:	55                   	push   %ebp
  802fe4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802fe6:	6a 00                	push   $0x0
  802fe8:	6a 00                	push   $0x0
  802fea:	6a 00                	push   $0x0
  802fec:	6a 00                	push   $0x0
  802fee:	6a 00                	push   $0x0
  802ff0:	6a 21                	push   $0x21
  802ff2:	e8 26 fc ff ff       	call   802c1d <syscall>
  802ff7:	83 c4 18             	add    $0x18,%esp
	return ;
  802ffa:	90                   	nop
}
  802ffb:	c9                   	leave  
  802ffc:	c3                   	ret    

00802ffd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ffd:	55                   	push   %ebp
  802ffe:	89 e5                	mov    %esp,%ebp
  803000:	83 ec 04             	sub    $0x4,%esp
  803003:	8b 45 14             	mov    0x14(%ebp),%eax
  803006:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803009:	8b 55 18             	mov    0x18(%ebp),%edx
  80300c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803010:	52                   	push   %edx
  803011:	50                   	push   %eax
  803012:	ff 75 10             	pushl  0x10(%ebp)
  803015:	ff 75 0c             	pushl  0xc(%ebp)
  803018:	ff 75 08             	pushl  0x8(%ebp)
  80301b:	6a 20                	push   $0x20
  80301d:	e8 fb fb ff ff       	call   802c1d <syscall>
  803022:	83 c4 18             	add    $0x18,%esp
	return ;
  803025:	90                   	nop
}
  803026:	c9                   	leave  
  803027:	c3                   	ret    

00803028 <chktst>:
void chktst(uint32 n)
{
  803028:	55                   	push   %ebp
  803029:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80302b:	6a 00                	push   $0x0
  80302d:	6a 00                	push   $0x0
  80302f:	6a 00                	push   $0x0
  803031:	6a 00                	push   $0x0
  803033:	ff 75 08             	pushl  0x8(%ebp)
  803036:	6a 22                	push   $0x22
  803038:	e8 e0 fb ff ff       	call   802c1d <syscall>
  80303d:	83 c4 18             	add    $0x18,%esp
	return ;
  803040:	90                   	nop
}
  803041:	c9                   	leave  
  803042:	c3                   	ret    

00803043 <inctst>:

void inctst()
{
  803043:	55                   	push   %ebp
  803044:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	6a 00                	push   $0x0
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 23                	push   $0x23
  803052:	e8 c6 fb ff ff       	call   802c1d <syscall>
  803057:	83 c4 18             	add    $0x18,%esp
	return ;
  80305a:	90                   	nop
}
  80305b:	c9                   	leave  
  80305c:	c3                   	ret    

0080305d <gettst>:
uint32 gettst()
{
  80305d:	55                   	push   %ebp
  80305e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803060:	6a 00                	push   $0x0
  803062:	6a 00                	push   $0x0
  803064:	6a 00                	push   $0x0
  803066:	6a 00                	push   $0x0
  803068:	6a 00                	push   $0x0
  80306a:	6a 24                	push   $0x24
  80306c:	e8 ac fb ff ff       	call   802c1d <syscall>
  803071:	83 c4 18             	add    $0x18,%esp
}
  803074:	c9                   	leave  
  803075:	c3                   	ret    

00803076 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803076:	55                   	push   %ebp
  803077:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803079:	6a 00                	push   $0x0
  80307b:	6a 00                	push   $0x0
  80307d:	6a 00                	push   $0x0
  80307f:	6a 00                	push   $0x0
  803081:	6a 00                	push   $0x0
  803083:	6a 25                	push   $0x25
  803085:	e8 93 fb ff ff       	call   802c1d <syscall>
  80308a:	83 c4 18             	add    $0x18,%esp
  80308d:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  803092:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  803097:	c9                   	leave  
  803098:	c3                   	ret    

00803099 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803099:	55                   	push   %ebp
  80309a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8030a4:	6a 00                	push   $0x0
  8030a6:	6a 00                	push   $0x0
  8030a8:	6a 00                	push   $0x0
  8030aa:	6a 00                	push   $0x0
  8030ac:	ff 75 08             	pushl  0x8(%ebp)
  8030af:	6a 26                	push   $0x26
  8030b1:	e8 67 fb ff ff       	call   802c1d <syscall>
  8030b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8030b9:	90                   	nop
}
  8030ba:	c9                   	leave  
  8030bb:	c3                   	ret    

008030bc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8030bc:	55                   	push   %ebp
  8030bd:	89 e5                	mov    %esp,%ebp
  8030bf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8030c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8030c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	6a 00                	push   $0x0
  8030ce:	53                   	push   %ebx
  8030cf:	51                   	push   %ecx
  8030d0:	52                   	push   %edx
  8030d1:	50                   	push   %eax
  8030d2:	6a 27                	push   $0x27
  8030d4:	e8 44 fb ff ff       	call   802c1d <syscall>
  8030d9:	83 c4 18             	add    $0x18,%esp
}
  8030dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030df:	c9                   	leave  
  8030e0:	c3                   	ret    

008030e1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8030e1:	55                   	push   %ebp
  8030e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8030e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	6a 00                	push   $0x0
  8030ec:	6a 00                	push   $0x0
  8030ee:	6a 00                	push   $0x0
  8030f0:	52                   	push   %edx
  8030f1:	50                   	push   %eax
  8030f2:	6a 28                	push   $0x28
  8030f4:	e8 24 fb ff ff       	call   802c1d <syscall>
  8030f9:	83 c4 18             	add    $0x18,%esp
}
  8030fc:	c9                   	leave  
  8030fd:	c3                   	ret    

008030fe <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8030fe:	55                   	push   %ebp
  8030ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803101:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803104:	8b 55 0c             	mov    0xc(%ebp),%edx
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	6a 00                	push   $0x0
  80310c:	51                   	push   %ecx
  80310d:	ff 75 10             	pushl  0x10(%ebp)
  803110:	52                   	push   %edx
  803111:	50                   	push   %eax
  803112:	6a 29                	push   $0x29
  803114:	e8 04 fb ff ff       	call   802c1d <syscall>
  803119:	83 c4 18             	add    $0x18,%esp
}
  80311c:	c9                   	leave  
  80311d:	c3                   	ret    

0080311e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80311e:	55                   	push   %ebp
  80311f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803121:	6a 00                	push   $0x0
  803123:	6a 00                	push   $0x0
  803125:	ff 75 10             	pushl  0x10(%ebp)
  803128:	ff 75 0c             	pushl  0xc(%ebp)
  80312b:	ff 75 08             	pushl  0x8(%ebp)
  80312e:	6a 12                	push   $0x12
  803130:	e8 e8 fa ff ff       	call   802c1d <syscall>
  803135:	83 c4 18             	add    $0x18,%esp
	return ;
  803138:	90                   	nop
}
  803139:	c9                   	leave  
  80313a:	c3                   	ret    

0080313b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80313b:	55                   	push   %ebp
  80313c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80313e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	6a 00                	push   $0x0
  803146:	6a 00                	push   $0x0
  803148:	6a 00                	push   $0x0
  80314a:	52                   	push   %edx
  80314b:	50                   	push   %eax
  80314c:	6a 2a                	push   $0x2a
  80314e:	e8 ca fa ff ff       	call   802c1d <syscall>
  803153:	83 c4 18             	add    $0x18,%esp
	return;
  803156:	90                   	nop
}
  803157:	c9                   	leave  
  803158:	c3                   	ret    

00803159 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803159:	55                   	push   %ebp
  80315a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80315c:	6a 00                	push   $0x0
  80315e:	6a 00                	push   $0x0
  803160:	6a 00                	push   $0x0
  803162:	6a 00                	push   $0x0
  803164:	6a 00                	push   $0x0
  803166:	6a 2b                	push   $0x2b
  803168:	e8 b0 fa ff ff       	call   802c1d <syscall>
  80316d:	83 c4 18             	add    $0x18,%esp
}
  803170:	c9                   	leave  
  803171:	c3                   	ret    

00803172 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803172:	55                   	push   %ebp
  803173:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803175:	6a 00                	push   $0x0
  803177:	6a 00                	push   $0x0
  803179:	6a 00                	push   $0x0
  80317b:	ff 75 0c             	pushl  0xc(%ebp)
  80317e:	ff 75 08             	pushl  0x8(%ebp)
  803181:	6a 2d                	push   $0x2d
  803183:	e8 95 fa ff ff       	call   802c1d <syscall>
  803188:	83 c4 18             	add    $0x18,%esp
	return;
  80318b:	90                   	nop
}
  80318c:	c9                   	leave  
  80318d:	c3                   	ret    

0080318e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80318e:	55                   	push   %ebp
  80318f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803191:	6a 00                	push   $0x0
  803193:	6a 00                	push   $0x0
  803195:	6a 00                	push   $0x0
  803197:	ff 75 0c             	pushl  0xc(%ebp)
  80319a:	ff 75 08             	pushl  0x8(%ebp)
  80319d:	6a 2c                	push   $0x2c
  80319f:	e8 79 fa ff ff       	call   802c1d <syscall>
  8031a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8031a7:	90                   	nop
}
  8031a8:	c9                   	leave  
  8031a9:	c3                   	ret    

008031aa <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8031aa:	55                   	push   %ebp
  8031ab:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8031ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	6a 00                	push   $0x0
  8031b5:	6a 00                	push   $0x0
  8031b7:	6a 00                	push   $0x0
  8031b9:	52                   	push   %edx
  8031ba:	50                   	push   %eax
  8031bb:	6a 2e                	push   $0x2e
  8031bd:	e8 5b fa ff ff       	call   802c1d <syscall>
  8031c2:	83 c4 18             	add    $0x18,%esp
	    return;
  8031c5:	90                   	nop
}
  8031c6:	c9                   	leave  
  8031c7:	c3                   	ret    

008031c8 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8031c8:	55                   	push   %ebp
  8031c9:	89 e5                	mov    %esp,%ebp
  8031cb:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	ba 60 50 80 00       	mov    $0x805060,%edx
  8031d6:	29 d0                	sub    %edx,%eax
  8031d8:	c1 f8 02             	sar    $0x2,%eax
  8031db:	89 c2                	mov    %eax,%edx
  8031dd:	89 d0                	mov    %edx,%eax
  8031df:	c1 e0 02             	shl    $0x2,%eax
  8031e2:	01 d0                	add    %edx,%eax
  8031e4:	c1 e0 02             	shl    $0x2,%eax
  8031e7:	01 d0                	add    %edx,%eax
  8031e9:	c1 e0 02             	shl    $0x2,%eax
  8031ec:	01 d0                	add    %edx,%eax
  8031ee:	89 c1                	mov    %eax,%ecx
  8031f0:	c1 e1 08             	shl    $0x8,%ecx
  8031f3:	01 c8                	add    %ecx,%eax
  8031f5:	89 c1                	mov    %eax,%ecx
  8031f7:	c1 e1 10             	shl    $0x10,%ecx
  8031fa:	01 c8                	add    %ecx,%eax
  8031fc:	01 c0                	add    %eax,%eax
  8031fe:	01 d0                	add    %edx,%eax
  803200:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803206:	c1 e0 0c             	shl    $0xc,%eax
  803209:	89 c2                	mov    %eax,%edx
  80320b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803210:	01 d0                	add    %edx,%eax
}
  803212:	c9                   	leave  
  803213:	c3                   	ret    

00803214 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803214:	55                   	push   %ebp
  803215:	89 e5                	mov    %esp,%ebp
  803217:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  80321a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803221:	eb 06                	jmp    803229 <log2+0x15>
			n >>=1;
  803223:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803226:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803229:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80322d:	77 f4                	ja     803223 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  80322f:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803232:	c9                   	leave  
  803233:	c3                   	ret    

00803234 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803234:	55                   	push   %ebp
  803235:	89 e5                	mov    %esp,%ebp
  803237:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	05 00 00 00 02       	add    $0x2000000,%eax
  803242:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803245:	73 16                	jae    80325d <initialize_dynamic_allocator+0x29>
  803247:	68 78 48 80 00       	push   $0x804878
  80324c:	68 9e 48 80 00       	push   $0x80489e
  803251:	6a 2d                	push   $0x2d
  803253:	68 b3 48 80 00       	push   $0x8048b3
  803258:	e8 da 0a 00 00       	call   803d37 <_panic>
		is_initialized = 1;
  80325d:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  803264:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd= daEnd;
  80326f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803272:	a3 40 50 80 00       	mov    %eax,0x805040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803277:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80327d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803282:	29 c2                	sub    %eax,%edx
  803284:	89 d0                	mov    %edx,%eax
  803286:	c1 e8 0c             	shr    $0xc,%eax
  803289:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  80328c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803293:	eb 2f                	jmp    8032c4 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803298:	89 d0                	mov    %edx,%eax
  80329a:	01 c0                	add    %eax,%eax
  80329c:	01 d0                	add    %edx,%eax
  80329e:	c1 e0 02             	shl    $0x2,%eax
  8032a1:	05 68 50 80 00       	add    $0x805068,%eax
  8032a6:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  8032ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ae:	89 d0                	mov    %edx,%eax
  8032b0:	01 c0                	add    %eax,%eax
  8032b2:	01 d0                	add    %edx,%eax
  8032b4:	c1 e0 02             	shl    $0x2,%eax
  8032b7:	05 6a 50 80 00       	add    $0x80506a,%eax
  8032bc:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  8032c1:	ff 45 f4             	incl   -0xc(%ebp)
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032ca:	7c c9                	jl     803295 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  8032cc:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8032d3:	00 00 00 
  8032d6:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8032dd:	00 00 00 
  8032e0:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8032e7:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  8032ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032f1:	e9 9c 00 00 00       	jmp    803392 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8032f6:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8032fc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8032ff:	89 c8                	mov    %ecx,%eax
  803301:	01 c0                	add    %eax,%eax
  803303:	01 c8                	add    %ecx,%eax
  803305:	c1 e0 02             	shl    $0x2,%eax
  803308:	05 64 50 80 00       	add    $0x805064,%eax
  80330d:	89 10                	mov    %edx,(%eax)
  80330f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803312:	89 d0                	mov    %edx,%eax
  803314:	01 c0                	add    %eax,%eax
  803316:	01 d0                	add    %edx,%eax
  803318:	c1 e0 02             	shl    $0x2,%eax
  80331b:	05 64 50 80 00       	add    $0x805064,%eax
  803320:	8b 00                	mov    (%eax),%eax
  803322:	85 c0                	test   %eax,%eax
  803324:	74 1b                	je     803341 <initialize_dynamic_allocator+0x10d>
  803326:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80332c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80332f:	89 c8                	mov    %ecx,%eax
  803331:	01 c0                	add    %eax,%eax
  803333:	01 c8                	add    %ecx,%eax
  803335:	c1 e0 02             	shl    $0x2,%eax
  803338:	05 60 50 80 00       	add    $0x805060,%eax
  80333d:	89 02                	mov    %eax,(%edx)
  80333f:	eb 16                	jmp    803357 <initialize_dynamic_allocator+0x123>
  803341:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803344:	89 d0                	mov    %edx,%eax
  803346:	01 c0                	add    %eax,%eax
  803348:	01 d0                	add    %edx,%eax
  80334a:	c1 e0 02             	shl    $0x2,%eax
  80334d:	05 60 50 80 00       	add    $0x805060,%eax
  803352:	a3 48 50 80 00       	mov    %eax,0x805048
  803357:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80335a:	89 d0                	mov    %edx,%eax
  80335c:	01 c0                	add    %eax,%eax
  80335e:	01 d0                	add    %edx,%eax
  803360:	c1 e0 02             	shl    $0x2,%eax
  803363:	05 60 50 80 00       	add    $0x805060,%eax
  803368:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80336d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803370:	89 d0                	mov    %edx,%eax
  803372:	01 c0                	add    %eax,%eax
  803374:	01 d0                	add    %edx,%eax
  803376:	c1 e0 02             	shl    $0x2,%eax
  803379:	05 60 50 80 00       	add    $0x805060,%eax
  80337e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803384:	a1 54 50 80 00       	mov    0x805054,%eax
  803389:	40                   	inc    %eax
  80338a:	a3 54 50 80 00       	mov    %eax,0x805054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  80338f:	ff 45 f0             	incl   -0x10(%ebp)
  803392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803395:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803398:	0f 8c 58 ff ff ff    	jl     8032f6 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80339e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8033a5:	eb 36                	jmp    8033dd <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  8033a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033aa:	c1 e0 04             	shl    $0x4,%eax
  8033ad:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033bb:	c1 e0 04             	shl    $0x4,%eax
  8033be:	05 84 d0 81 00       	add    $0x81d084,%eax
  8033c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033cc:	c1 e0 04             	shl    $0x4,%eax
  8033cf:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8033da:	ff 45 ec             	incl   -0x14(%ebp)
  8033dd:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8033e1:	7e c4                	jle    8033a7 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8033e3:	90                   	nop
  8033e4:	c9                   	leave  
  8033e5:	c3                   	ret    

008033e6 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  8033e6:	55                   	push   %ebp
  8033e7:	89 e5                	mov    %esp,%ebp
  8033e9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8033ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ef:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8033f4:	29 c2                	sub    %eax,%edx
  8033f6:	89 d0                	mov    %edx,%eax
  8033f8:	c1 e8 0c             	shr    $0xc,%eax
  8033fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  8033fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803401:	89 d0                	mov    %edx,%eax
  803403:	01 c0                	add    %eax,%eax
  803405:	01 d0                	add    %edx,%eax
  803407:	c1 e0 02             	shl    $0x2,%eax
  80340a:	05 68 50 80 00       	add    $0x805068,%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803414:	c9                   	leave  
  803415:	c3                   	ret    

00803416 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803416:	55                   	push   %ebp
  803417:	89 e5                	mov    %esp,%ebp
  803419:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80341c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803423:	76 16                	jbe    80343b <alloc_block+0x25>
  803425:	68 cc 48 80 00       	push   $0x8048cc
  80342a:	68 9e 48 80 00       	push   $0x80489e
  80342f:	6a 6c                	push   $0x6c
  803431:	68 b3 48 80 00       	push   $0x8048b3
  803436:	e8 fc 08 00 00       	call   803d37 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  80343b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80343f:	75 0a                	jne    80344b <alloc_block+0x35>
		return NULL;
  803441:	b8 00 00 00 00       	mov    $0x0,%eax
  803446:	e9 65 04 00 00       	jmp    8038b0 <alloc_block+0x49a>
	}
	else if(size<=8){
  80344b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  80344f:	77 09                	ja     80345a <alloc_block+0x44>
		size=8;
  803451:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803458:	eb 1f                	jmp    803479 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  80345a:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803461:	eb 08                	jmp    80346b <alloc_block+0x55>
			reqsize*=2;
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	01 c0                	add    %eax,%eax
  803468:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  80346b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803471:	72 f0                	jb     803463 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803479:	83 ec 0c             	sub    $0xc,%esp
  80347c:	ff 75 08             	pushl  0x8(%ebp)
  80347f:	e8 90 fd ff ff       	call   803214 <log2>
  803484:	83 c4 10             	add    $0x10,%esp
  803487:	83 e8 03             	sub    $0x3,%eax
  80348a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  80348d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803490:	c1 e0 04             	shl    $0x4,%eax
  803493:	05 80 d0 81 00       	add    $0x81d080,%eax
  803498:	8b 00                	mov    (%eax),%eax
  80349a:	85 c0                	test   %eax,%eax
  80349c:	0f 84 fb 00 00 00    	je     80359d <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  8034a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a5:	c1 e0 04             	shl    $0x4,%eax
  8034a8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  8034b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034b6:	75 17                	jne    8034cf <alloc_block+0xb9>
  8034b8:	83 ec 04             	sub    $0x4,%esp
  8034bb:	68 ed 48 80 00       	push   $0x8048ed
  8034c0:	68 86 00 00 00       	push   $0x86
  8034c5:	68 b3 48 80 00       	push   $0x8048b3
  8034ca:	e8 68 08 00 00       	call   803d37 <_panic>
  8034cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d2:	8b 00                	mov    (%eax),%eax
  8034d4:	85 c0                	test   %eax,%eax
  8034d6:	74 10                	je     8034e8 <alloc_block+0xd2>
  8034d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034db:	8b 00                	mov    (%eax),%eax
  8034dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034e0:	8b 52 04             	mov    0x4(%edx),%edx
  8034e3:	89 50 04             	mov    %edx,0x4(%eax)
  8034e6:	eb 14                	jmp    8034fc <alloc_block+0xe6>
  8034e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034eb:	8b 40 04             	mov    0x4(%eax),%eax
  8034ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034f1:	c1 e2 04             	shl    $0x4,%edx
  8034f4:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8034fa:	89 02                	mov    %eax,(%edx)
  8034fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ff:	8b 40 04             	mov    0x4(%eax),%eax
  803502:	85 c0                	test   %eax,%eax
  803504:	74 0f                	je     803515 <alloc_block+0xff>
  803506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803509:	8b 40 04             	mov    0x4(%eax),%eax
  80350c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80350f:	8b 12                	mov    (%edx),%edx
  803511:	89 10                	mov    %edx,(%eax)
  803513:	eb 13                	jmp    803528 <alloc_block+0x112>
  803515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803518:	8b 00                	mov    (%eax),%eax
  80351a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80351d:	c1 e2 04             	shl    $0x4,%edx
  803520:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803526:	89 02                	mov    %eax,(%edx)
  803528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803534:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353e:	c1 e0 04             	shl    $0x4,%eax
  803541:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803546:	8b 00                	mov    (%eax),%eax
  803548:	8d 50 ff             	lea    -0x1(%eax),%edx
  80354b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354e:	c1 e0 04             	shl    $0x4,%eax
  803551:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803556:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803558:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80355b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803560:	29 c2                	sub    %eax,%edx
  803562:	89 d0                	mov    %edx,%eax
  803564:	c1 e8 0c             	shr    $0xc,%eax
  803567:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  80356a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80356d:	89 d0                	mov    %edx,%eax
  80356f:	01 c0                	add    %eax,%eax
  803571:	01 d0                	add    %edx,%eax
  803573:	c1 e0 02             	shl    $0x2,%eax
  803576:	05 6a 50 80 00       	add    $0x80506a,%eax
  80357b:	66 8b 00             	mov    (%eax),%ax
  80357e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803581:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803584:	89 c8                	mov    %ecx,%eax
  803586:	01 c0                	add    %eax,%eax
  803588:	01 c8                	add    %ecx,%eax
  80358a:	c1 e0 02             	shl    $0x2,%eax
  80358d:	05 6a 50 80 00       	add    $0x80506a,%eax
  803592:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803598:	e9 13 03 00 00       	jmp    8038b0 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  80359d:	a1 48 50 80 00       	mov    0x805048,%eax
  8035a2:	85 c0                	test   %eax,%eax
  8035a4:	0f 84 c9 01 00 00    	je     803773 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  8035aa:	a1 48 50 80 00       	mov    0x805048,%eax
  8035af:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  8035b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035b6:	75 17                	jne    8035cf <alloc_block+0x1b9>
  8035b8:	83 ec 04             	sub    $0x4,%esp
  8035bb:	68 ed 48 80 00       	push   $0x8048ed
  8035c0:	68 8f 00 00 00       	push   $0x8f
  8035c5:	68 b3 48 80 00       	push   $0x8048b3
  8035ca:	e8 68 07 00 00       	call   803d37 <_panic>
  8035cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035d2:	8b 00                	mov    (%eax),%eax
  8035d4:	85 c0                	test   %eax,%eax
  8035d6:	74 10                	je     8035e8 <alloc_block+0x1d2>
  8035d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035db:	8b 00                	mov    (%eax),%eax
  8035dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035e0:	8b 52 04             	mov    0x4(%edx),%edx
  8035e3:	89 50 04             	mov    %edx,0x4(%eax)
  8035e6:	eb 0b                	jmp    8035f3 <alloc_block+0x1dd>
  8035e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035eb:	8b 40 04             	mov    0x4(%eax),%eax
  8035ee:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8035f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035f6:	8b 40 04             	mov    0x4(%eax),%eax
  8035f9:	85 c0                	test   %eax,%eax
  8035fb:	74 0f                	je     80360c <alloc_block+0x1f6>
  8035fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803600:	8b 40 04             	mov    0x4(%eax),%eax
  803603:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803606:	8b 12                	mov    (%edx),%edx
  803608:	89 10                	mov    %edx,(%eax)
  80360a:	eb 0a                	jmp    803616 <alloc_block+0x200>
  80360c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80360f:	8b 00                	mov    (%eax),%eax
  803611:	a3 48 50 80 00       	mov    %eax,0x805048
  803616:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80361f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803622:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803629:	a1 54 50 80 00       	mov    0x805054,%eax
  80362e:	48                   	dec    %eax
  80362f:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803634:	83 ec 0c             	sub    $0xc,%esp
  803637:	ff 75 dc             	pushl  -0x24(%ebp)
  80363a:	e8 89 fb ff ff       	call   8031c8 <to_page_va>
  80363f:	83 c4 10             	add    $0x10,%esp
  803642:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803645:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80364a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80364d:	29 c2                	sub    %eax,%edx
  80364f:	89 d0                	mov    %edx,%eax
  803651:	c1 e8 0c             	shr    $0xc,%eax
  803654:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803657:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80365a:	83 ec 0c             	sub    $0xc,%esp
  80365d:	50                   	push   %eax
  80365e:	e8 fe dc ff ff       	call   801361 <get_page>
  803663:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803666:	8b 45 08             	mov    0x8(%ebp),%eax
  803669:	89 c2                	mov    %eax,%edx
  80366b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80366e:	89 c8                	mov    %ecx,%eax
  803670:	01 c0                	add    %eax,%eax
  803672:	01 c8                	add    %ecx,%eax
  803674:	c1 e0 02             	shl    $0x2,%eax
  803677:	05 68 50 80 00       	add    $0x805068,%eax
  80367c:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  80367f:	b8 00 10 00 00       	mov    $0x1000,%eax
  803684:	ba 00 00 00 00       	mov    $0x0,%edx
  803689:	f7 75 08             	divl   0x8(%ebp)
  80368c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  80368f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803692:	8d 50 ff             	lea    -0x1(%eax),%edx
  803695:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803698:	89 c8                	mov    %ecx,%eax
  80369a:	01 c0                	add    %eax,%eax
  80369c:	01 c8                	add    %ecx,%eax
  80369e:	c1 e0 02             	shl    $0x2,%eax
  8036a1:	05 6a 50 80 00       	add    $0x80506a,%eax
  8036a6:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  8036a9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  8036b0:	e9 aa 00 00 00       	jmp    80375f <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  8036b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b8:	0f af 45 08          	imul   0x8(%ebp),%eax
  8036bc:	89 c2                	mov    %eax,%edx
  8036be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8036c1:	01 d0                	add    %edx,%eax
  8036c3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  8036c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8036ca:	75 17                	jne    8036e3 <alloc_block+0x2cd>
  8036cc:	83 ec 04             	sub    $0x4,%esp
  8036cf:	68 0c 49 80 00       	push   $0x80490c
  8036d4:	68 9d 00 00 00       	push   $0x9d
  8036d9:	68 b3 48 80 00       	push   $0x8048b3
  8036de:	e8 54 06 00 00       	call   803d37 <_panic>
  8036e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e6:	c1 e0 04             	shl    $0x4,%eax
  8036e9:	05 84 d0 81 00       	add    $0x81d084,%eax
  8036ee:	8b 10                	mov    (%eax),%edx
  8036f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036f3:	89 50 04             	mov    %edx,0x4(%eax)
  8036f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8036f9:	8b 40 04             	mov    0x4(%eax),%eax
  8036fc:	85 c0                	test   %eax,%eax
  8036fe:	74 14                	je     803714 <alloc_block+0x2fe>
  803700:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803703:	c1 e0 04             	shl    $0x4,%eax
  803706:	05 84 d0 81 00       	add    $0x81d084,%eax
  80370b:	8b 00                	mov    (%eax),%eax
  80370d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803710:	89 10                	mov    %edx,(%eax)
  803712:	eb 11                	jmp    803725 <alloc_block+0x30f>
  803714:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803717:	c1 e0 04             	shl    $0x4,%eax
  80371a:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803720:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803723:	89 02                	mov    %eax,(%edx)
  803725:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803728:	c1 e0 04             	shl    $0x4,%eax
  80372b:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803731:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803734:	89 02                	mov    %eax,(%edx)
  803736:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803739:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80373f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803742:	c1 e0 04             	shl    $0x4,%eax
  803745:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80374a:	8b 00                	mov    (%eax),%eax
  80374c:	8d 50 01             	lea    0x1(%eax),%edx
  80374f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803752:	c1 e0 04             	shl    $0x4,%eax
  803755:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80375a:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  80375c:	ff 45 f0             	incl   -0x10(%ebp)
  80375f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803762:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803765:	0f 8c 4a ff ff ff    	jl     8036b5 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  80376b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80376e:	e9 3d 01 00 00       	jmp    8038b0 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803773:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803776:	40                   	inc    %eax
  803777:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80377a:	e9 10 01 00 00       	jmp    80388f <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  80377f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803782:	c1 e0 04             	shl    $0x4,%eax
  803785:	05 80 d0 81 00       	add    $0x81d080,%eax
  80378a:	8b 00                	mov    (%eax),%eax
  80378c:	85 c0                	test   %eax,%eax
  80378e:	0f 84 f8 00 00 00    	je     80388c <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803797:	c1 e0 04             	shl    $0x4,%eax
  80379a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80379f:	8b 00                	mov    (%eax),%eax
  8037a1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  8037a4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8037a8:	75 17                	jne    8037c1 <alloc_block+0x3ab>
  8037aa:	83 ec 04             	sub    $0x4,%esp
  8037ad:	68 ed 48 80 00       	push   $0x8048ed
  8037b2:	68 a8 00 00 00       	push   $0xa8
  8037b7:	68 b3 48 80 00       	push   $0x8048b3
  8037bc:	e8 76 05 00 00       	call   803d37 <_panic>
  8037c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037c4:	8b 00                	mov    (%eax),%eax
  8037c6:	85 c0                	test   %eax,%eax
  8037c8:	74 10                	je     8037da <alloc_block+0x3c4>
  8037ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037cd:	8b 00                	mov    (%eax),%eax
  8037cf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8037d2:	8b 52 04             	mov    0x4(%edx),%edx
  8037d5:	89 50 04             	mov    %edx,0x4(%eax)
  8037d8:	eb 14                	jmp    8037ee <alloc_block+0x3d8>
  8037da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037dd:	8b 40 04             	mov    0x4(%eax),%eax
  8037e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037e3:	c1 e2 04             	shl    $0x4,%edx
  8037e6:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8037ec:	89 02                	mov    %eax,(%edx)
  8037ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037f1:	8b 40 04             	mov    0x4(%eax),%eax
  8037f4:	85 c0                	test   %eax,%eax
  8037f6:	74 0f                	je     803807 <alloc_block+0x3f1>
  8037f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037fb:	8b 40 04             	mov    0x4(%eax),%eax
  8037fe:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803801:	8b 12                	mov    (%edx),%edx
  803803:	89 10                	mov    %edx,(%eax)
  803805:	eb 13                	jmp    80381a <alloc_block+0x404>
  803807:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80380f:	c1 e2 04             	shl    $0x4,%edx
  803812:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803818:	89 02                	mov    %eax,(%edx)
  80381a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80381d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803823:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803826:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803830:	c1 e0 04             	shl    $0x4,%eax
  803833:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803838:	8b 00                	mov    (%eax),%eax
  80383a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80383d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803840:	c1 e0 04             	shl    $0x4,%eax
  803843:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803848:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  80384a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80384d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803852:	29 c2                	sub    %eax,%edx
  803854:	89 d0                	mov    %edx,%eax
  803856:	c1 e8 0c             	shr    $0xc,%eax
  803859:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  80385c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80385f:	89 d0                	mov    %edx,%eax
  803861:	01 c0                	add    %eax,%eax
  803863:	01 d0                	add    %edx,%eax
  803865:	c1 e0 02             	shl    $0x2,%eax
  803868:	05 6a 50 80 00       	add    $0x80506a,%eax
  80386d:	66 8b 00             	mov    (%eax),%ax
  803870:	8d 50 ff             	lea    -0x1(%eax),%edx
  803873:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803876:	89 c8                	mov    %ecx,%eax
  803878:	01 c0                	add    %eax,%eax
  80387a:	01 c8                	add    %ecx,%eax
  80387c:	c1 e0 02             	shl    $0x2,%eax
  80387f:	05 6a 50 80 00       	add    $0x80506a,%eax
  803884:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803887:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80388a:	eb 24                	jmp    8038b0 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  80388c:	ff 45 ec             	incl   -0x14(%ebp)
  80388f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803893:	0f 8e e6 fe ff ff    	jle    80377f <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803899:	83 ec 04             	sub    $0x4,%esp
  80389c:	68 2f 49 80 00       	push   $0x80492f
  8038a1:	68 b1 00 00 00       	push   $0xb1
  8038a6:	68 b3 48 80 00       	push   $0x8048b3
  8038ab:	e8 87 04 00 00       	call   803d37 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8038b0:	c9                   	leave  
  8038b1:	c3                   	ret    

008038b2 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8038b2:	55                   	push   %ebp
  8038b3:	89 e5                	mov    %esp,%ebp
  8038b5:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8038b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8038bb:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8038c0:	39 c2                	cmp    %eax,%edx
  8038c2:	72 0c                	jb     8038d0 <free_block+0x1e>
  8038c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c7:	a1 40 50 80 00       	mov    0x805040,%eax
  8038cc:	39 c2                	cmp    %eax,%edx
  8038ce:	72 19                	jb     8038e9 <free_block+0x37>
  8038d0:	68 4c 49 80 00       	push   $0x80494c
  8038d5:	68 9e 48 80 00       	push   $0x80489e
  8038da:	68 c3 00 00 00       	push   $0xc3
  8038df:	68 b3 48 80 00       	push   $0x8048b3
  8038e4:	e8 4e 04 00 00       	call   803d37 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8038e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ec:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8038f1:	29 c2                	sub    %eax,%edx
  8038f3:	89 d0                	mov    %edx,%eax
  8038f5:	c1 e8 0c             	shr    $0xc,%eax
  8038f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  8038fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038fe:	89 d0                	mov    %edx,%eax
  803900:	01 c0                	add    %eax,%eax
  803902:	01 d0                	add    %edx,%eax
  803904:	c1 e0 02             	shl    $0x2,%eax
  803907:	05 68 50 80 00       	add    $0x805068,%eax
  80390c:	8b 00                	mov    (%eax),%eax
  80390e:	0f b7 c0             	movzwl %ax,%eax
  803911:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803914:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803918:	75 17                	jne    803931 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  80391a:	83 ec 04             	sub    $0x4,%esp
  80391d:	68 84 49 80 00       	push   $0x804984
  803922:	68 cf 00 00 00       	push   $0xcf
  803927:	68 b3 48 80 00       	push   $0x8048b3
  80392c:	e8 06 04 00 00       	call   803d37 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803931:	83 ec 0c             	sub    $0xc,%esp
  803934:	ff 75 ec             	pushl  -0x14(%ebp)
  803937:	e8 d8 f8 ff ff       	call   803214 <log2>
  80393c:	83 c4 10             	add    $0x10,%esp
  80393f:	83 e8 03             	sub    $0x3,%eax
  803942:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803945:	8b 45 08             	mov    0x8(%ebp),%eax
  803948:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  80394b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80394f:	75 17                	jne    803968 <free_block+0xb6>
  803951:	83 ec 04             	sub    $0x4,%esp
  803954:	68 0c 49 80 00       	push   $0x80490c
  803959:	68 d5 00 00 00       	push   $0xd5
  80395e:	68 b3 48 80 00       	push   $0x8048b3
  803963:	e8 cf 03 00 00       	call   803d37 <_panic>
  803968:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396b:	c1 e0 04             	shl    $0x4,%eax
  80396e:	05 84 d0 81 00       	add    $0x81d084,%eax
  803973:	8b 10                	mov    (%eax),%edx
  803975:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803978:	89 50 04             	mov    %edx,0x4(%eax)
  80397b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397e:	8b 40 04             	mov    0x4(%eax),%eax
  803981:	85 c0                	test   %eax,%eax
  803983:	74 14                	je     803999 <free_block+0xe7>
  803985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803988:	c1 e0 04             	shl    $0x4,%eax
  80398b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803990:	8b 00                	mov    (%eax),%eax
  803992:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803995:	89 10                	mov    %edx,(%eax)
  803997:	eb 11                	jmp    8039aa <free_block+0xf8>
  803999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399c:	c1 e0 04             	shl    $0x4,%eax
  80399f:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8039a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a8:	89 02                	mov    %eax,(%edx)
  8039aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ad:	c1 e0 04             	shl    $0x4,%eax
  8039b0:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8039b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b9:	89 02                	mov    %eax,(%edx)
  8039bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c7:	c1 e0 04             	shl    $0x4,%eax
  8039ca:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8039cf:	8b 00                	mov    (%eax),%eax
  8039d1:	8d 50 01             	lea    0x1(%eax),%edx
  8039d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d7:	c1 e0 04             	shl    $0x4,%eax
  8039da:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8039df:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  8039e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039e4:	89 d0                	mov    %edx,%eax
  8039e6:	01 c0                	add    %eax,%eax
  8039e8:	01 d0                	add    %edx,%eax
  8039ea:	c1 e0 02             	shl    $0x2,%eax
  8039ed:	05 6a 50 80 00       	add    $0x80506a,%eax
  8039f2:	66 8b 00             	mov    (%eax),%ax
  8039f5:	8d 50 01             	lea    0x1(%eax),%edx
  8039f8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8039fb:	89 c8                	mov    %ecx,%eax
  8039fd:	01 c0                	add    %eax,%eax
  8039ff:	01 c8                	add    %ecx,%eax
  803a01:	c1 e0 02             	shl    $0x2,%eax
  803a04:	05 6a 50 80 00       	add    $0x80506a,%eax
  803a09:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803a0c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a11:	ba 00 00 00 00       	mov    $0x0,%edx
  803a16:	f7 75 ec             	divl   -0x14(%ebp)
  803a19:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803a1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a1f:	89 d0                	mov    %edx,%eax
  803a21:	01 c0                	add    %eax,%eax
  803a23:	01 d0                	add    %edx,%eax
  803a25:	c1 e0 02             	shl    $0x2,%eax
  803a28:	05 6a 50 80 00       	add    $0x80506a,%eax
  803a2d:	66 8b 00             	mov    (%eax),%ax
  803a30:	0f b7 c0             	movzwl %ax,%eax
  803a33:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803a36:	0f 85 d3 01 00 00    	jne    803c0f <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803a3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3f:	c1 e0 04             	shl    $0x4,%eax
  803a42:	05 80 d0 81 00       	add    $0x81d080,%eax
  803a47:	8b 00                	mov    (%eax),%eax
  803a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803a4c:	e9 f1 00 00 00       	jmp    803b42 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a54:	8b 00                	mov    (%eax),%eax
  803a56:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5c:	c1 e0 0c             	shl    $0xc,%eax
  803a5f:	89 c2                	mov    %eax,%edx
  803a61:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803a66:	01 d0                	add    %edx,%eax
  803a68:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6e:	40                   	inc    %eax
  803a6f:	c1 e0 0c             	shl    $0xc,%eax
  803a72:	89 c2                	mov    %eax,%edx
  803a74:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803a79:	01 d0                	add    %edx,%eax
  803a7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a81:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803a84:	0f 82 b8 00 00 00    	jb     803b42 <free_block+0x290>
  803a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a90:	0f 83 ac 00 00 00    	jae    803b42 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803a96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a9a:	75 17                	jne    803ab3 <free_block+0x201>
  803a9c:	83 ec 04             	sub    $0x4,%esp
  803a9f:	68 ed 48 80 00       	push   $0x8048ed
  803aa4:	68 e2 00 00 00       	push   $0xe2
  803aa9:	68 b3 48 80 00       	push   $0x8048b3
  803aae:	e8 84 02 00 00       	call   803d37 <_panic>
  803ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab6:	8b 00                	mov    (%eax),%eax
  803ab8:	85 c0                	test   %eax,%eax
  803aba:	74 10                	je     803acc <free_block+0x21a>
  803abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abf:	8b 00                	mov    (%eax),%eax
  803ac1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ac4:	8b 52 04             	mov    0x4(%edx),%edx
  803ac7:	89 50 04             	mov    %edx,0x4(%eax)
  803aca:	eb 14                	jmp    803ae0 <free_block+0x22e>
  803acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acf:	8b 40 04             	mov    0x4(%eax),%eax
  803ad2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ad5:	c1 e2 04             	shl    $0x4,%edx
  803ad8:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803ade:	89 02                	mov    %eax,(%edx)
  803ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae3:	8b 40 04             	mov    0x4(%eax),%eax
  803ae6:	85 c0                	test   %eax,%eax
  803ae8:	74 0f                	je     803af9 <free_block+0x247>
  803aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aed:	8b 40 04             	mov    0x4(%eax),%eax
  803af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803af3:	8b 12                	mov    (%edx),%edx
  803af5:	89 10                	mov    %edx,(%eax)
  803af7:	eb 13                	jmp    803b0c <free_block+0x25a>
  803af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afc:	8b 00                	mov    (%eax),%eax
  803afe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b01:	c1 e2 04             	shl    $0x4,%edx
  803b04:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803b0a:	89 02                	mov    %eax,(%edx)
  803b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b22:	c1 e0 04             	shl    $0x4,%eax
  803b25:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803b2a:	8b 00                	mov    (%eax),%eax
  803b2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b32:	c1 e0 04             	shl    $0x4,%eax
  803b35:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803b3a:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803b3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803b42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b46:	0f 85 05 ff ff ff    	jne    803a51 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803b4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b4f:	89 d0                	mov    %edx,%eax
  803b51:	01 c0                	add    %eax,%eax
  803b53:	01 d0                	add    %edx,%eax
  803b55:	c1 e0 02             	shl    $0x2,%eax
  803b58:	05 68 50 80 00       	add    $0x805068,%eax
  803b5d:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803b62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b65:	89 d0                	mov    %edx,%eax
  803b67:	01 c0                	add    %eax,%eax
  803b69:	01 d0                	add    %edx,%eax
  803b6b:	c1 e0 02             	shl    $0x2,%eax
  803b6e:	05 6a 50 80 00       	add    $0x80506a,%eax
  803b73:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803b78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b7b:	89 d0                	mov    %edx,%eax
  803b7d:	01 c0                	add    %eax,%eax
  803b7f:	01 d0                	add    %edx,%eax
  803b81:	c1 e0 02             	shl    $0x2,%eax
  803b84:	05 60 50 80 00       	add    $0x805060,%eax
  803b89:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803b8c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b90:	75 17                	jne    803ba9 <free_block+0x2f7>
  803b92:	83 ec 04             	sub    $0x4,%esp
  803b95:	68 0c 49 80 00       	push   $0x80490c
  803b9a:	68 eb 00 00 00       	push   $0xeb
  803b9f:	68 b3 48 80 00       	push   $0x8048b3
  803ba4:	e8 8e 01 00 00       	call   803d37 <_panic>
  803ba9:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803baf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803bb2:	89 50 04             	mov    %edx,0x4(%eax)
  803bb5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803bb8:	8b 40 04             	mov    0x4(%eax),%eax
  803bbb:	85 c0                	test   %eax,%eax
  803bbd:	74 0c                	je     803bcb <free_block+0x319>
  803bbf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803bc4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803bc7:	89 10                	mov    %edx,(%eax)
  803bc9:	eb 08                	jmp    803bd3 <free_block+0x321>
  803bcb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803bce:	a3 48 50 80 00       	mov    %eax,0x805048
  803bd3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803bd6:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803bdb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803bde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be4:	a1 54 50 80 00       	mov    0x805054,%eax
  803be9:	40                   	inc    %eax
  803bea:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803bef:	83 ec 0c             	sub    $0xc,%esp
  803bf2:	ff 75 d0             	pushl  -0x30(%ebp)
  803bf5:	e8 ce f5 ff ff       	call   8031c8 <to_page_va>
  803bfa:	83 c4 10             	add    $0x10,%esp
  803bfd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803c00:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c03:	83 ec 0c             	sub    $0xc,%esp
  803c06:	50                   	push   %eax
  803c07:	e8 9e d7 ff ff       	call   8013aa <return_page>
  803c0c:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803c0f:	90                   	nop
  803c10:	c9                   	leave  
  803c11:	c3                   	ret    

00803c12 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803c12:	55                   	push   %ebp
  803c13:	89 e5                	mov    %esp,%ebp
  803c15:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803c18:	83 ec 04             	sub    $0x4,%esp
  803c1b:	68 ac 49 80 00       	push   $0x8049ac
  803c20:	68 01 01 00 00       	push   $0x101
  803c25:	68 b3 48 80 00       	push   $0x8048b3
  803c2a:	e8 08 01 00 00       	call   803d37 <_panic>

00803c2f <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803c2f:	55                   	push   %ebp
  803c30:	89 e5                	mov    %esp,%ebp
  803c32:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803c35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803c39:	74 1c                	je     803c57 <init_uspinlock+0x28>
  803c3b:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803c3f:	74 16                	je     803c57 <init_uspinlock+0x28>
  803c41:	68 d0 49 80 00       	push   $0x8049d0
  803c46:	68 ef 49 80 00       	push   $0x8049ef
  803c4b:	6a 10                	push   $0x10
  803c4d:	68 04 4a 80 00       	push   $0x804a04
  803c52:	e8 e0 00 00 00       	call   803d37 <_panic>
	strcpy(lk->name, name);
  803c57:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5a:	83 c0 04             	add    $0x4,%eax
  803c5d:	83 ec 08             	sub    $0x8,%esp
  803c60:	ff 75 0c             	pushl  0xc(%ebp)
  803c63:	50                   	push   %eax
  803c64:	e8 90 ce ff ff       	call   800af9 <strcpy>
  803c69:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  803c6c:	b8 01 00 00 00       	mov    $0x1,%eax
  803c71:	2b 45 10             	sub    0x10(%ebp),%eax
  803c74:	89 c2                	mov    %eax,%edx
  803c76:	8b 45 08             	mov    0x8(%ebp),%eax
  803c79:	89 10                	mov    %edx,(%eax)
}
  803c7b:	90                   	nop
  803c7c:	c9                   	leave  
  803c7d:	c3                   	ret    

00803c7e <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  803c7e:	55                   	push   %ebp
  803c7f:	89 e5                	mov    %esp,%ebp
  803c81:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803c84:	90                   	nop
  803c85:	8b 45 08             	mov    0x8(%ebp),%eax
  803c88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c8b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803c92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c98:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803c9b:	f0 87 02             	lock xchg %eax,(%edx)
  803c9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  803ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ca4:	85 c0                	test   %eax,%eax
  803ca6:	75 dd                	jne    803c85 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cab:	8d 48 04             	lea    0x4(%eax),%ecx
  803cae:	a1 20 50 80 00       	mov    0x805020,%eax
  803cb3:	8d 50 20             	lea    0x20(%eax),%edx
  803cb6:	a1 20 50 80 00       	mov    0x805020,%eax
  803cbb:	8b 40 10             	mov    0x10(%eax),%eax
  803cbe:	51                   	push   %ecx
  803cbf:	52                   	push   %edx
  803cc0:	50                   	push   %eax
  803cc1:	68 14 4a 80 00       	push   $0x804a14
  803cc6:	e8 06 c7 ff ff       	call   8003d1 <cprintf>
  803ccb:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  803cce:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  803cd3:	90                   	nop
  803cd4:	c9                   	leave  
  803cd5:	c3                   	ret    

00803cd6 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  803cd6:	55                   	push   %ebp
  803cd7:	89 e5                	mov    %esp,%ebp
  803cd9:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  803cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdf:	8b 00                	mov    (%eax),%eax
  803ce1:	85 c0                	test   %eax,%eax
  803ce3:	75 18                	jne    803cfd <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  803ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce8:	83 c0 04             	add    $0x4,%eax
  803ceb:	50                   	push   %eax
  803cec:	68 38 4a 80 00       	push   $0x804a38
  803cf1:	6a 2b                	push   $0x2b
  803cf3:	68 04 4a 80 00       	push   $0x804a04
  803cf8:	e8 3a 00 00 00       	call   803d37 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  803cfd:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  803d02:	8b 45 08             	mov    0x8(%ebp),%eax
  803d05:	8b 55 08             	mov    0x8(%ebp),%edx
  803d08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d11:	8d 48 04             	lea    0x4(%eax),%ecx
  803d14:	a1 20 50 80 00       	mov    0x805020,%eax
  803d19:	8d 50 20             	lea    0x20(%eax),%edx
  803d1c:	a1 20 50 80 00       	mov    0x805020,%eax
  803d21:	8b 40 10             	mov    0x10(%eax),%eax
  803d24:	51                   	push   %ecx
  803d25:	52                   	push   %edx
  803d26:	50                   	push   %eax
  803d27:	68 58 4a 80 00       	push   $0x804a58
  803d2c:	e8 a0 c6 ff ff       	call   8003d1 <cprintf>
  803d31:	83 c4 10             	add    $0x10,%esp
}
  803d34:	90                   	nop
  803d35:	c9                   	leave  
  803d36:	c3                   	ret    

00803d37 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803d37:	55                   	push   %ebp
  803d38:	89 e5                	mov    %esp,%ebp
  803d3a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803d3d:	8d 45 10             	lea    0x10(%ebp),%eax
  803d40:	83 c0 04             	add    $0x4,%eax
  803d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803d46:	a1 84 d1 81 00       	mov    0x81d184,%eax
  803d4b:	85 c0                	test   %eax,%eax
  803d4d:	74 16                	je     803d65 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803d4f:	a1 84 d1 81 00       	mov    0x81d184,%eax
  803d54:	83 ec 08             	sub    $0x8,%esp
  803d57:	50                   	push   %eax
  803d58:	68 7c 4a 80 00       	push   $0x804a7c
  803d5d:	e8 6f c6 ff ff       	call   8003d1 <cprintf>
  803d62:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803d65:	a1 04 50 80 00       	mov    0x805004,%eax
  803d6a:	83 ec 0c             	sub    $0xc,%esp
  803d6d:	ff 75 0c             	pushl  0xc(%ebp)
  803d70:	ff 75 08             	pushl  0x8(%ebp)
  803d73:	50                   	push   %eax
  803d74:	68 84 4a 80 00       	push   $0x804a84
  803d79:	6a 74                	push   $0x74
  803d7b:	e8 7e c6 ff ff       	call   8003fe <cprintf_colored>
  803d80:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803d83:	8b 45 10             	mov    0x10(%ebp),%eax
  803d86:	83 ec 08             	sub    $0x8,%esp
  803d89:	ff 75 f4             	pushl  -0xc(%ebp)
  803d8c:	50                   	push   %eax
  803d8d:	e8 d0 c5 ff ff       	call   800362 <vcprintf>
  803d92:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803d95:	83 ec 08             	sub    $0x8,%esp
  803d98:	6a 00                	push   $0x0
  803d9a:	68 ac 4a 80 00       	push   $0x804aac
  803d9f:	e8 be c5 ff ff       	call   800362 <vcprintf>
  803da4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803da7:	e8 37 c5 ff ff       	call   8002e3 <exit>

	// should not return here
	while (1) ;
  803dac:	eb fe                	jmp    803dac <_panic+0x75>

00803dae <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803dae:	55                   	push   %ebp
  803daf:	89 e5                	mov    %esp,%ebp
  803db1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803db4:	a1 20 50 80 00       	mov    0x805020,%eax
  803db9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dc2:	39 c2                	cmp    %eax,%edx
  803dc4:	74 14                	je     803dda <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803dc6:	83 ec 04             	sub    $0x4,%esp
  803dc9:	68 b0 4a 80 00       	push   $0x804ab0
  803dce:	6a 26                	push   $0x26
  803dd0:	68 fc 4a 80 00       	push   $0x804afc
  803dd5:	e8 5d ff ff ff       	call   803d37 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803dda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803de1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803de8:	e9 c5 00 00 00       	jmp    803eb2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803df7:	8b 45 08             	mov    0x8(%ebp),%eax
  803dfa:	01 d0                	add    %edx,%eax
  803dfc:	8b 00                	mov    (%eax),%eax
  803dfe:	85 c0                	test   %eax,%eax
  803e00:	75 08                	jne    803e0a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803e02:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803e05:	e9 a5 00 00 00       	jmp    803eaf <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803e0a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803e11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803e18:	eb 69                	jmp    803e83 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803e1a:	a1 20 50 80 00       	mov    0x805020,%eax
  803e1f:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  803e25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e28:	89 d0                	mov    %edx,%eax
  803e2a:	01 c0                	add    %eax,%eax
  803e2c:	01 d0                	add    %edx,%eax
  803e2e:	c1 e0 03             	shl    $0x3,%eax
  803e31:	01 c8                	add    %ecx,%eax
  803e33:	8a 40 04             	mov    0x4(%eax),%al
  803e36:	84 c0                	test   %al,%al
  803e38:	75 46                	jne    803e80 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803e3a:	a1 20 50 80 00       	mov    0x805020,%eax
  803e3f:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  803e45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e48:	89 d0                	mov    %edx,%eax
  803e4a:	01 c0                	add    %eax,%eax
  803e4c:	01 d0                	add    %edx,%eax
  803e4e:	c1 e0 03             	shl    $0x3,%eax
  803e51:	01 c8                	add    %ecx,%eax
  803e53:	8b 00                	mov    (%eax),%eax
  803e55:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803e58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803e60:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e65:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e6f:	01 c8                	add    %ecx,%eax
  803e71:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803e73:	39 c2                	cmp    %eax,%edx
  803e75:	75 09                	jne    803e80 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803e77:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803e7e:	eb 15                	jmp    803e95 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803e80:	ff 45 e8             	incl   -0x18(%ebp)
  803e83:	a1 20 50 80 00       	mov    0x805020,%eax
  803e88:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803e8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e91:	39 c2                	cmp    %eax,%edx
  803e93:	77 85                	ja     803e1a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803e95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e99:	75 14                	jne    803eaf <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803e9b:	83 ec 04             	sub    $0x4,%esp
  803e9e:	68 08 4b 80 00       	push   $0x804b08
  803ea3:	6a 3a                	push   $0x3a
  803ea5:	68 fc 4a 80 00       	push   $0x804afc
  803eaa:	e8 88 fe ff ff       	call   803d37 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803eaf:	ff 45 f0             	incl   -0x10(%ebp)
  803eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eb5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803eb8:	0f 8c 2f ff ff ff    	jl     803ded <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803ebe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ec5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803ecc:	eb 26                	jmp    803ef4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803ece:	a1 20 50 80 00       	mov    0x805020,%eax
  803ed3:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  803ed9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803edc:	89 d0                	mov    %edx,%eax
  803ede:	01 c0                	add    %eax,%eax
  803ee0:	01 d0                	add    %edx,%eax
  803ee2:	c1 e0 03             	shl    $0x3,%eax
  803ee5:	01 c8                	add    %ecx,%eax
  803ee7:	8a 40 04             	mov    0x4(%eax),%al
  803eea:	3c 01                	cmp    $0x1,%al
  803eec:	75 03                	jne    803ef1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803eee:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ef1:	ff 45 e0             	incl   -0x20(%ebp)
  803ef4:	a1 20 50 80 00       	mov    0x805020,%eax
  803ef9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803eff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f02:	39 c2                	cmp    %eax,%edx
  803f04:	77 c8                	ja     803ece <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f09:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803f0c:	74 14                	je     803f22 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803f0e:	83 ec 04             	sub    $0x4,%esp
  803f11:	68 5c 4b 80 00       	push   $0x804b5c
  803f16:	6a 44                	push   $0x44
  803f18:	68 fc 4a 80 00       	push   $0x804afc
  803f1d:	e8 15 fe ff ff       	call   803d37 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803f22:	90                   	nop
  803f23:	c9                   	leave  
  803f24:	c3                   	ret    
  803f25:	66 90                	xchg   %ax,%ax
  803f27:	90                   	nop

00803f28 <__udivdi3>:
  803f28:	55                   	push   %ebp
  803f29:	57                   	push   %edi
  803f2a:	56                   	push   %esi
  803f2b:	53                   	push   %ebx
  803f2c:	83 ec 1c             	sub    $0x1c,%esp
  803f2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f3f:	89 ca                	mov    %ecx,%edx
  803f41:	89 f8                	mov    %edi,%eax
  803f43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f47:	85 f6                	test   %esi,%esi
  803f49:	75 2d                	jne    803f78 <__udivdi3+0x50>
  803f4b:	39 cf                	cmp    %ecx,%edi
  803f4d:	77 65                	ja     803fb4 <__udivdi3+0x8c>
  803f4f:	89 fd                	mov    %edi,%ebp
  803f51:	85 ff                	test   %edi,%edi
  803f53:	75 0b                	jne    803f60 <__udivdi3+0x38>
  803f55:	b8 01 00 00 00       	mov    $0x1,%eax
  803f5a:	31 d2                	xor    %edx,%edx
  803f5c:	f7 f7                	div    %edi
  803f5e:	89 c5                	mov    %eax,%ebp
  803f60:	31 d2                	xor    %edx,%edx
  803f62:	89 c8                	mov    %ecx,%eax
  803f64:	f7 f5                	div    %ebp
  803f66:	89 c1                	mov    %eax,%ecx
  803f68:	89 d8                	mov    %ebx,%eax
  803f6a:	f7 f5                	div    %ebp
  803f6c:	89 cf                	mov    %ecx,%edi
  803f6e:	89 fa                	mov    %edi,%edx
  803f70:	83 c4 1c             	add    $0x1c,%esp
  803f73:	5b                   	pop    %ebx
  803f74:	5e                   	pop    %esi
  803f75:	5f                   	pop    %edi
  803f76:	5d                   	pop    %ebp
  803f77:	c3                   	ret    
  803f78:	39 ce                	cmp    %ecx,%esi
  803f7a:	77 28                	ja     803fa4 <__udivdi3+0x7c>
  803f7c:	0f bd fe             	bsr    %esi,%edi
  803f7f:	83 f7 1f             	xor    $0x1f,%edi
  803f82:	75 40                	jne    803fc4 <__udivdi3+0x9c>
  803f84:	39 ce                	cmp    %ecx,%esi
  803f86:	72 0a                	jb     803f92 <__udivdi3+0x6a>
  803f88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f8c:	0f 87 9e 00 00 00    	ja     804030 <__udivdi3+0x108>
  803f92:	b8 01 00 00 00       	mov    $0x1,%eax
  803f97:	89 fa                	mov    %edi,%edx
  803f99:	83 c4 1c             	add    $0x1c,%esp
  803f9c:	5b                   	pop    %ebx
  803f9d:	5e                   	pop    %esi
  803f9e:	5f                   	pop    %edi
  803f9f:	5d                   	pop    %ebp
  803fa0:	c3                   	ret    
  803fa1:	8d 76 00             	lea    0x0(%esi),%esi
  803fa4:	31 ff                	xor    %edi,%edi
  803fa6:	31 c0                	xor    %eax,%eax
  803fa8:	89 fa                	mov    %edi,%edx
  803faa:	83 c4 1c             	add    $0x1c,%esp
  803fad:	5b                   	pop    %ebx
  803fae:	5e                   	pop    %esi
  803faf:	5f                   	pop    %edi
  803fb0:	5d                   	pop    %ebp
  803fb1:	c3                   	ret    
  803fb2:	66 90                	xchg   %ax,%ax
  803fb4:	89 d8                	mov    %ebx,%eax
  803fb6:	f7 f7                	div    %edi
  803fb8:	31 ff                	xor    %edi,%edi
  803fba:	89 fa                	mov    %edi,%edx
  803fbc:	83 c4 1c             	add    $0x1c,%esp
  803fbf:	5b                   	pop    %ebx
  803fc0:	5e                   	pop    %esi
  803fc1:	5f                   	pop    %edi
  803fc2:	5d                   	pop    %ebp
  803fc3:	c3                   	ret    
  803fc4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803fc9:	89 eb                	mov    %ebp,%ebx
  803fcb:	29 fb                	sub    %edi,%ebx
  803fcd:	89 f9                	mov    %edi,%ecx
  803fcf:	d3 e6                	shl    %cl,%esi
  803fd1:	89 c5                	mov    %eax,%ebp
  803fd3:	88 d9                	mov    %bl,%cl
  803fd5:	d3 ed                	shr    %cl,%ebp
  803fd7:	89 e9                	mov    %ebp,%ecx
  803fd9:	09 f1                	or     %esi,%ecx
  803fdb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803fdf:	89 f9                	mov    %edi,%ecx
  803fe1:	d3 e0                	shl    %cl,%eax
  803fe3:	89 c5                	mov    %eax,%ebp
  803fe5:	89 d6                	mov    %edx,%esi
  803fe7:	88 d9                	mov    %bl,%cl
  803fe9:	d3 ee                	shr    %cl,%esi
  803feb:	89 f9                	mov    %edi,%ecx
  803fed:	d3 e2                	shl    %cl,%edx
  803fef:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ff3:	88 d9                	mov    %bl,%cl
  803ff5:	d3 e8                	shr    %cl,%eax
  803ff7:	09 c2                	or     %eax,%edx
  803ff9:	89 d0                	mov    %edx,%eax
  803ffb:	89 f2                	mov    %esi,%edx
  803ffd:	f7 74 24 0c          	divl   0xc(%esp)
  804001:	89 d6                	mov    %edx,%esi
  804003:	89 c3                	mov    %eax,%ebx
  804005:	f7 e5                	mul    %ebp
  804007:	39 d6                	cmp    %edx,%esi
  804009:	72 19                	jb     804024 <__udivdi3+0xfc>
  80400b:	74 0b                	je     804018 <__udivdi3+0xf0>
  80400d:	89 d8                	mov    %ebx,%eax
  80400f:	31 ff                	xor    %edi,%edi
  804011:	e9 58 ff ff ff       	jmp    803f6e <__udivdi3+0x46>
  804016:	66 90                	xchg   %ax,%ax
  804018:	8b 54 24 08          	mov    0x8(%esp),%edx
  80401c:	89 f9                	mov    %edi,%ecx
  80401e:	d3 e2                	shl    %cl,%edx
  804020:	39 c2                	cmp    %eax,%edx
  804022:	73 e9                	jae    80400d <__udivdi3+0xe5>
  804024:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804027:	31 ff                	xor    %edi,%edi
  804029:	e9 40 ff ff ff       	jmp    803f6e <__udivdi3+0x46>
  80402e:	66 90                	xchg   %ax,%ax
  804030:	31 c0                	xor    %eax,%eax
  804032:	e9 37 ff ff ff       	jmp    803f6e <__udivdi3+0x46>
  804037:	90                   	nop

00804038 <__umoddi3>:
  804038:	55                   	push   %ebp
  804039:	57                   	push   %edi
  80403a:	56                   	push   %esi
  80403b:	53                   	push   %ebx
  80403c:	83 ec 1c             	sub    $0x1c,%esp
  80403f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804043:	8b 74 24 34          	mov    0x34(%esp),%esi
  804047:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80404b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80404f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804053:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804057:	89 f3                	mov    %esi,%ebx
  804059:	89 fa                	mov    %edi,%edx
  80405b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80405f:	89 34 24             	mov    %esi,(%esp)
  804062:	85 c0                	test   %eax,%eax
  804064:	75 1a                	jne    804080 <__umoddi3+0x48>
  804066:	39 f7                	cmp    %esi,%edi
  804068:	0f 86 a2 00 00 00    	jbe    804110 <__umoddi3+0xd8>
  80406e:	89 c8                	mov    %ecx,%eax
  804070:	89 f2                	mov    %esi,%edx
  804072:	f7 f7                	div    %edi
  804074:	89 d0                	mov    %edx,%eax
  804076:	31 d2                	xor    %edx,%edx
  804078:	83 c4 1c             	add    $0x1c,%esp
  80407b:	5b                   	pop    %ebx
  80407c:	5e                   	pop    %esi
  80407d:	5f                   	pop    %edi
  80407e:	5d                   	pop    %ebp
  80407f:	c3                   	ret    
  804080:	39 f0                	cmp    %esi,%eax
  804082:	0f 87 ac 00 00 00    	ja     804134 <__umoddi3+0xfc>
  804088:	0f bd e8             	bsr    %eax,%ebp
  80408b:	83 f5 1f             	xor    $0x1f,%ebp
  80408e:	0f 84 ac 00 00 00    	je     804140 <__umoddi3+0x108>
  804094:	bf 20 00 00 00       	mov    $0x20,%edi
  804099:	29 ef                	sub    %ebp,%edi
  80409b:	89 fe                	mov    %edi,%esi
  80409d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040a1:	89 e9                	mov    %ebp,%ecx
  8040a3:	d3 e0                	shl    %cl,%eax
  8040a5:	89 d7                	mov    %edx,%edi
  8040a7:	89 f1                	mov    %esi,%ecx
  8040a9:	d3 ef                	shr    %cl,%edi
  8040ab:	09 c7                	or     %eax,%edi
  8040ad:	89 e9                	mov    %ebp,%ecx
  8040af:	d3 e2                	shl    %cl,%edx
  8040b1:	89 14 24             	mov    %edx,(%esp)
  8040b4:	89 d8                	mov    %ebx,%eax
  8040b6:	d3 e0                	shl    %cl,%eax
  8040b8:	89 c2                	mov    %eax,%edx
  8040ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040be:	d3 e0                	shl    %cl,%eax
  8040c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040c8:	89 f1                	mov    %esi,%ecx
  8040ca:	d3 e8                	shr    %cl,%eax
  8040cc:	09 d0                	or     %edx,%eax
  8040ce:	d3 eb                	shr    %cl,%ebx
  8040d0:	89 da                	mov    %ebx,%edx
  8040d2:	f7 f7                	div    %edi
  8040d4:	89 d3                	mov    %edx,%ebx
  8040d6:	f7 24 24             	mull   (%esp)
  8040d9:	89 c6                	mov    %eax,%esi
  8040db:	89 d1                	mov    %edx,%ecx
  8040dd:	39 d3                	cmp    %edx,%ebx
  8040df:	0f 82 87 00 00 00    	jb     80416c <__umoddi3+0x134>
  8040e5:	0f 84 91 00 00 00    	je     80417c <__umoddi3+0x144>
  8040eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040ef:	29 f2                	sub    %esi,%edx
  8040f1:	19 cb                	sbb    %ecx,%ebx
  8040f3:	89 d8                	mov    %ebx,%eax
  8040f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8040f9:	d3 e0                	shl    %cl,%eax
  8040fb:	89 e9                	mov    %ebp,%ecx
  8040fd:	d3 ea                	shr    %cl,%edx
  8040ff:	09 d0                	or     %edx,%eax
  804101:	89 e9                	mov    %ebp,%ecx
  804103:	d3 eb                	shr    %cl,%ebx
  804105:	89 da                	mov    %ebx,%edx
  804107:	83 c4 1c             	add    $0x1c,%esp
  80410a:	5b                   	pop    %ebx
  80410b:	5e                   	pop    %esi
  80410c:	5f                   	pop    %edi
  80410d:	5d                   	pop    %ebp
  80410e:	c3                   	ret    
  80410f:	90                   	nop
  804110:	89 fd                	mov    %edi,%ebp
  804112:	85 ff                	test   %edi,%edi
  804114:	75 0b                	jne    804121 <__umoddi3+0xe9>
  804116:	b8 01 00 00 00       	mov    $0x1,%eax
  80411b:	31 d2                	xor    %edx,%edx
  80411d:	f7 f7                	div    %edi
  80411f:	89 c5                	mov    %eax,%ebp
  804121:	89 f0                	mov    %esi,%eax
  804123:	31 d2                	xor    %edx,%edx
  804125:	f7 f5                	div    %ebp
  804127:	89 c8                	mov    %ecx,%eax
  804129:	f7 f5                	div    %ebp
  80412b:	89 d0                	mov    %edx,%eax
  80412d:	e9 44 ff ff ff       	jmp    804076 <__umoddi3+0x3e>
  804132:	66 90                	xchg   %ax,%ax
  804134:	89 c8                	mov    %ecx,%eax
  804136:	89 f2                	mov    %esi,%edx
  804138:	83 c4 1c             	add    $0x1c,%esp
  80413b:	5b                   	pop    %ebx
  80413c:	5e                   	pop    %esi
  80413d:	5f                   	pop    %edi
  80413e:	5d                   	pop    %ebp
  80413f:	c3                   	ret    
  804140:	3b 04 24             	cmp    (%esp),%eax
  804143:	72 06                	jb     80414b <__umoddi3+0x113>
  804145:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804149:	77 0f                	ja     80415a <__umoddi3+0x122>
  80414b:	89 f2                	mov    %esi,%edx
  80414d:	29 f9                	sub    %edi,%ecx
  80414f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804153:	89 14 24             	mov    %edx,(%esp)
  804156:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80415a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80415e:	8b 14 24             	mov    (%esp),%edx
  804161:	83 c4 1c             	add    $0x1c,%esp
  804164:	5b                   	pop    %ebx
  804165:	5e                   	pop    %esi
  804166:	5f                   	pop    %edi
  804167:	5d                   	pop    %ebp
  804168:	c3                   	ret    
  804169:	8d 76 00             	lea    0x0(%esi),%esi
  80416c:	2b 04 24             	sub    (%esp),%eax
  80416f:	19 fa                	sbb    %edi,%edx
  804171:	89 d1                	mov    %edx,%ecx
  804173:	89 c6                	mov    %eax,%esi
  804175:	e9 71 ff ff ff       	jmp    8040eb <__umoddi3+0xb3>
  80417a:	66 90                	xchg   %ax,%ax
  80417c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804180:	72 ea                	jb     80416c <__umoddi3+0x134>
  804182:	89 d9                	mov    %ebx,%ecx
  804184:	e9 62 ff ff ff       	jmp    8040eb <__umoddi3+0xb3>
