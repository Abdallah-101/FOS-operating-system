
obj/user/tst_invalid_access:     file format elf32-i386


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
  800031:	e8 0f 02 00 00       	call   800245 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int eval = 0;
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	cprintf_colored(TEXT_cyan, "%~PART I: Test the Pointer Validation inside fault_handler(): [70%]\n");
  800045:	83 ec 08             	sub    $0x8,%esp
  800048:	68 a0 1c 80 00       	push   $0x801ca0
  80004d:	6a 03                	push   $0x3
  80004f:	e8 b7 04 00 00       	call   80050b <cprintf_colored>
  800054:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_cyan, "%~=================================================================\n");
  800057:	83 ec 08             	sub    $0x8,%esp
  80005a:	68 e8 1c 80 00       	push   $0x801ce8
  80005f:	6a 03                	push   $0x3
  800061:	e8 a5 04 00 00       	call   80050b <cprintf_colored>
  800066:	83 c4 10             	add    $0x10,%esp
	rsttst();
  800069:	e8 1b 17 00 00       	call   801789 <rsttst>
	int ID1 = sys_create_env("tia_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800079:	a1 20 30 80 00       	mov    0x803020,%eax
  80007e:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800084:	89 c1                	mov    %eax,%ecx
  800086:	a1 20 30 80 00       	mov    0x803020,%eax
  80008b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800091:	52                   	push   %edx
  800092:	51                   	push   %ecx
  800093:	50                   	push   %eax
  800094:	68 2d 1d 80 00       	push   $0x801d2d
  800099:	e8 9f 15 00 00       	call   80163d <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID1);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000aa:	e8 ac 15 00 00       	call   80165b <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tia_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b7:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8000bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c2:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8000c8:	89 c1                	mov    %eax,%ecx
  8000ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8000cf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d5:	52                   	push   %edx
  8000d6:	51                   	push   %ecx
  8000d7:	50                   	push   %eax
  8000d8:	68 38 1d 80 00       	push   $0x801d38
  8000dd:	e8 5b 15 00 00       	call   80163d <sys_create_env>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID2);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ee:	e8 68 15 00 00       	call   80165b <sys_run_env>
  8000f3:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tia_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fb:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800101:	a1 20 30 80 00       	mov    0x803020,%eax
  800106:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80010c:	89 c1                	mov    %eax,%ecx
  80010e:	a1 20 30 80 00       	mov    0x803020,%eax
  800113:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800119:	52                   	push   %edx
  80011a:	51                   	push   %ecx
  80011b:	50                   	push   %eax
  80011c:	68 43 1d 80 00       	push   $0x801d43
  800121:	e8 17 15 00 00       	call   80163d <sys_create_env>
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_run_env(ID3);
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	ff 75 e8             	pushl  -0x18(%ebp)
  800132:	e8 24 15 00 00       	call   80165b <sys_run_env>
  800137:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 98 3a 00 00       	push   $0x3a98
  800142:	e8 27 18 00 00       	call   80196e <env_sleep>
  800147:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  80014a:	e8 b4 16 00 00       	call   801803 <gettst>
  80014f:	85 c0                	test   %eax,%eax
  800151:	74 14                	je     800167 <_main+0x12f>
		cprintf_colored(TEXT_TESTERR_CLR, "\n%~PART I... Failed.\n");
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	68 4e 1d 80 00       	push   $0x801d4e
  80015b:	6a 0c                	push   $0xc
  80015d:	e8 a9 03 00 00       	call   80050b <cprintf_colored>
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	eb 16                	jmp    80017d <_main+0x145>
	else
	{
		cprintf_colored(TEXT_green, "\n%~PART I... completed successfully\n\n");
  800167:	83 ec 08             	sub    $0x8,%esp
  80016a:	68 64 1d 80 00       	push   $0x801d64
  80016f:	6a 02                	push   $0x2
  800171:	e8 95 03 00 00       	call   80050b <cprintf_colored>
  800176:	83 c4 10             	add    $0x10,%esp
		eval += 70;
  800179:	83 45 f4 46          	addl   $0x46,-0xc(%ebp)
	}

	cprintf_colored(TEXT_cyan, "%~PART II: PLACEMENT: Test the Invalid Access to a NON-EXIST page in Page File, Stack & Heap: [30%]\n");
  80017d:	83 ec 08             	sub    $0x8,%esp
  800180:	68 8c 1d 80 00       	push   $0x801d8c
  800185:	6a 03                	push   $0x3
  800187:	e8 7f 03 00 00       	call   80050b <cprintf_colored>
  80018c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_cyan, "%~=================================================================================================\n");
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	68 f4 1d 80 00       	push   $0x801df4
  800197:	6a 03                	push   $0x3
  800199:	e8 6d 03 00 00       	call   80050b <cprintf_colored>
  80019e:	83 c4 10             	add    $0x10,%esp

	rsttst();
  8001a1:	e8 e3 15 00 00       	call   801789 <rsttst>
	int ID4 = sys_create_env("tia_slave4", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8001a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ab:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b6:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8001bc:	89 c1                	mov    %eax,%ecx
  8001be:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8001c9:	52                   	push   %edx
  8001ca:	51                   	push   %ecx
  8001cb:	50                   	push   %eax
  8001cc:	68 59 1e 80 00       	push   $0x801e59
  8001d1:	e8 67 14 00 00       	call   80163d <sys_create_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_run_env(ID4);
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e2:	e8 74 14 00 00       	call   80165b <sys_run_env>
  8001e7:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000);
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	68 98 3a 00 00       	push   $0x3a98
  8001f2:	e8 77 17 00 00       	call   80196e <env_sleep>
  8001f7:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  8001fa:	e8 04 16 00 00       	call   801803 <gettst>
  8001ff:	85 c0                	test   %eax,%eax
  800201:	74 14                	je     800217 <_main+0x1df>
		cprintf_colored(TEXT_TESTERR_CLR, "\n%~PART II... Failed.\n");
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	68 64 1e 80 00       	push   $0x801e64
  80020b:	6a 0c                	push   $0xc
  80020d:	e8 f9 02 00 00       	call   80050b <cprintf_colored>
  800212:	83 c4 10             	add    $0x10,%esp
  800215:	eb 16                	jmp    80022d <_main+0x1f5>
	else
	{
		cprintf_colored(TEXT_green, "\n%~PART II... completed successfully\n\n");
  800217:	83 ec 08             	sub    $0x8,%esp
  80021a:	68 7c 1e 80 00       	push   $0x801e7c
  80021f:	6a 02                	push   $0x2
  800221:	e8 e5 02 00 00       	call   80050b <cprintf_colored>
  800226:	83 c4 10             	add    $0x10,%esp
		eval += 30;
  800229:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	cprintf_colored(TEXT_light_green, "%~\ntest invalid access completed. Eval = %d%\n\n", eval);
  80022d:	83 ec 04             	sub    $0x4,%esp
  800230:	ff 75 f4             	pushl  -0xc(%ebp)
  800233:	68 a4 1e 80 00       	push   $0x801ea4
  800238:	6a 0a                	push   $0xa
  80023a:	e8 cc 02 00 00       	call   80050b <cprintf_colored>
  80023f:	83 c4 10             	add    $0x10,%esp

}
  800242:	90                   	nop
  800243:	c9                   	leave  
  800244:	c3                   	ret    

00800245 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800245:	55                   	push   %ebp
  800246:	89 e5                	mov    %esp,%ebp
  800248:	57                   	push   %edi
  800249:	56                   	push   %esi
  80024a:	53                   	push   %ebx
  80024b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80024e:	e8 58 14 00 00       	call   8016ab <sys_getenvindex>
  800253:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800256:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800259:	89 d0                	mov    %edx,%eax
  80025b:	c1 e0 02             	shl    $0x2,%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800267:	01 d0                	add    %edx,%eax
  800269:	89 c2                	mov    %eax,%edx
  80026b:	c1 e2 04             	shl    $0x4,%edx
  80026e:	29 c2                	sub    %eax,%edx
  800270:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800277:	89 c2                	mov    %eax,%edx
  800279:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80027f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800284:	a1 20 30 80 00       	mov    0x803020,%eax
  800289:	8a 40 20             	mov    0x20(%eax),%al
  80028c:	84 c0                	test   %al,%al
  80028e:	74 0d                	je     80029d <libmain+0x58>
		binaryname = myEnv->prog_name;
  800290:	a1 20 30 80 00       	mov    0x803020,%eax
  800295:	83 c0 20             	add    $0x20,%eax
  800298:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a1:	7e 0a                	jle    8002ad <libmain+0x68>
		binaryname = argv[0];
  8002a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a6:	8b 00                	mov    (%eax),%eax
  8002a8:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	ff 75 0c             	pushl  0xc(%ebp)
  8002b3:	ff 75 08             	pushl  0x8(%ebp)
  8002b6:	e8 7d fd ff ff       	call   800038 <_main>
  8002bb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002be:	a1 00 30 80 00       	mov    0x803000,%eax
  8002c3:	85 c0                	test   %eax,%eax
  8002c5:	0f 84 01 01 00 00    	je     8003cc <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002cb:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002d1:	bb cc 1f 80 00       	mov    $0x801fcc,%ebx
  8002d6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002db:	89 c7                	mov    %eax,%edi
  8002dd:	89 de                	mov    %ebx,%esi
  8002df:	89 d1                	mov    %edx,%ecx
  8002e1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002e3:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002e6:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002eb:	b0 00                	mov    $0x0,%al
  8002ed:	89 d7                	mov    %edx,%edi
  8002ef:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002fb:	83 ec 08             	sub    $0x8,%esp
  8002fe:	50                   	push   %eax
  8002ff:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800305:	50                   	push   %eax
  800306:	e8 d6 15 00 00       	call   8018e1 <sys_utilities>
  80030b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80030e:	e8 1f 11 00 00       	call   801432 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800313:	83 ec 0c             	sub    $0xc,%esp
  800316:	68 ec 1e 80 00       	push   $0x801eec
  80031b:	e8 be 01 00 00       	call   8004de <cprintf>
  800320:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800323:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800326:	85 c0                	test   %eax,%eax
  800328:	74 18                	je     800342 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80032a:	e8 d0 15 00 00       	call   8018ff <sys_get_optimal_num_faults>
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	50                   	push   %eax
  800333:	68 14 1f 80 00       	push   $0x801f14
  800338:	e8 a1 01 00 00       	call   8004de <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
  800340:	eb 59                	jmp    80039b <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800342:	a1 20 30 80 00       	mov    0x803020,%eax
  800347:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80034d:	a1 20 30 80 00       	mov    0x803020,%eax
  800352:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	52                   	push   %edx
  80035c:	50                   	push   %eax
  80035d:	68 38 1f 80 00       	push   $0x801f38
  800362:	e8 77 01 00 00       	call   8004de <cprintf>
  800367:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80036a:	a1 20 30 80 00       	mov    0x803020,%eax
  80036f:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800375:	a1 20 30 80 00       	mov    0x803020,%eax
  80037a:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800380:	a1 20 30 80 00       	mov    0x803020,%eax
  800385:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80038b:	51                   	push   %ecx
  80038c:	52                   	push   %edx
  80038d:	50                   	push   %eax
  80038e:	68 60 1f 80 00       	push   $0x801f60
  800393:	e8 46 01 00 00       	call   8004de <cprintf>
  800398:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039b:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a0:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	50                   	push   %eax
  8003aa:	68 b8 1f 80 00       	push   $0x801fb8
  8003af:	e8 2a 01 00 00       	call   8004de <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003b7:	83 ec 0c             	sub    $0xc,%esp
  8003ba:	68 ec 1e 80 00       	push   $0x801eec
  8003bf:	e8 1a 01 00 00       	call   8004de <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003c7:	e8 80 10 00 00       	call   80144c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003cc:	e8 1f 00 00 00       	call   8003f0 <exit>
}
  8003d1:	90                   	nop
  8003d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d5:	5b                   	pop    %ebx
  8003d6:	5e                   	pop    %esi
  8003d7:	5f                   	pop    %edi
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003e0:	83 ec 0c             	sub    $0xc,%esp
  8003e3:	6a 00                	push   $0x0
  8003e5:	e8 8d 12 00 00       	call   801677 <sys_destroy_env>
  8003ea:	83 c4 10             	add    $0x10,%esp
}
  8003ed:	90                   	nop
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    

008003f0 <exit>:

void
exit(void)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f6:	e8 e2 12 00 00       	call   8016dd <sys_exit_env>
}
  8003fb:	90                   	nop
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	53                   	push   %ebx
  800402:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800405:	8b 45 0c             	mov    0xc(%ebp),%eax
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	8d 48 01             	lea    0x1(%eax),%ecx
  80040d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800410:	89 0a                	mov    %ecx,(%edx)
  800412:	8b 55 08             	mov    0x8(%ebp),%edx
  800415:	88 d1                	mov    %dl,%cl
  800417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80041a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80041e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800421:	8b 00                	mov    (%eax),%eax
  800423:	3d ff 00 00 00       	cmp    $0xff,%eax
  800428:	75 30                	jne    80045a <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80042a:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800430:	a0 44 30 80 00       	mov    0x803044,%al
  800435:	0f b6 c0             	movzbl %al,%eax
  800438:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80043b:	8b 09                	mov    (%ecx),%ecx
  80043d:	89 cb                	mov    %ecx,%ebx
  80043f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800442:	83 c1 08             	add    $0x8,%ecx
  800445:	52                   	push   %edx
  800446:	50                   	push   %eax
  800447:	53                   	push   %ebx
  800448:	51                   	push   %ecx
  800449:	e8 a0 0f 00 00       	call   8013ee <sys_cputs>
  80044e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800451:	8b 45 0c             	mov    0xc(%ebp),%eax
  800454:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045d:	8b 40 04             	mov    0x4(%eax),%eax
  800460:	8d 50 01             	lea    0x1(%eax),%edx
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
  800466:	89 50 04             	mov    %edx,0x4(%eax)
}
  800469:	90                   	nop
  80046a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80046d:	c9                   	leave  
  80046e:	c3                   	ret    

0080046f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800478:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80047f:	00 00 00 
	b.cnt = 0;
  800482:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800489:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80048c:	ff 75 0c             	pushl  0xc(%ebp)
  80048f:	ff 75 08             	pushl  0x8(%ebp)
  800492:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	68 fe 03 80 00       	push   $0x8003fe
  80049e:	e8 5a 02 00 00       	call   8006fd <vprintfmt>
  8004a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004a6:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8004ac:	a0 44 30 80 00       	mov    0x803044,%al
  8004b1:	0f b6 c0             	movzbl %al,%eax
  8004b4:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004ba:	52                   	push   %edx
  8004bb:	50                   	push   %eax
  8004bc:	51                   	push   %ecx
  8004bd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004c3:	83 c0 08             	add    $0x8,%eax
  8004c6:	50                   	push   %eax
  8004c7:	e8 22 0f 00 00       	call   8013ee <sys_cputs>
  8004cc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004cf:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004d6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004dc:	c9                   	leave  
  8004dd:	c3                   	ret    

008004de <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004e4:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004eb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	83 ec 08             	sub    $0x8,%esp
  8004f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fa:	50                   	push   %eax
  8004fb:	e8 6f ff ff ff       	call   80046f <vcprintf>
  800500:	83 c4 10             	add    $0x10,%esp
  800503:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800506:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800511:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	c1 e0 08             	shl    $0x8,%eax
  80051e:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  800523:	8d 45 0c             	lea    0xc(%ebp),%eax
  800526:	83 c0 04             	add    $0x4,%eax
  800529:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	ff 75 f4             	pushl  -0xc(%ebp)
  800535:	50                   	push   %eax
  800536:	e8 34 ff ff ff       	call   80046f <vcprintf>
  80053b:	83 c4 10             	add    $0x10,%esp
  80053e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800541:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800548:	07 00 00 

	return cnt;
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800556:	e8 d7 0e 00 00       	call   801432 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80055b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80055e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800561:	8b 45 08             	mov    0x8(%ebp),%eax
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	ff 75 f4             	pushl  -0xc(%ebp)
  80056a:	50                   	push   %eax
  80056b:	e8 ff fe ff ff       	call   80046f <vcprintf>
  800570:	83 c4 10             	add    $0x10,%esp
  800573:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800576:	e8 d1 0e 00 00       	call   80144c <sys_unlock_cons>
	return cnt;
  80057b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80057e:	c9                   	leave  
  80057f:	c3                   	ret    

00800580 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	53                   	push   %ebx
  800584:	83 ec 14             	sub    $0x14,%esp
  800587:	8b 45 10             	mov    0x10(%ebp),%eax
  80058a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800593:	8b 45 18             	mov    0x18(%ebp),%eax
  800596:	ba 00 00 00 00       	mov    $0x0,%edx
  80059b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059e:	77 55                	ja     8005f5 <printnum+0x75>
  8005a0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a3:	72 05                	jb     8005aa <printnum+0x2a>
  8005a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a8:	77 4b                	ja     8005f5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005aa:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ad:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b8:	52                   	push   %edx
  8005b9:	50                   	push   %eax
  8005ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c0:	e8 67 14 00 00       	call   801a2c <__udivdi3>
  8005c5:	83 c4 10             	add    $0x10,%esp
  8005c8:	83 ec 04             	sub    $0x4,%esp
  8005cb:	ff 75 20             	pushl  0x20(%ebp)
  8005ce:	53                   	push   %ebx
  8005cf:	ff 75 18             	pushl  0x18(%ebp)
  8005d2:	52                   	push   %edx
  8005d3:	50                   	push   %eax
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	e8 a1 ff ff ff       	call   800580 <printnum>
  8005df:	83 c4 20             	add    $0x20,%esp
  8005e2:	eb 1a                	jmp    8005fe <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 20             	pushl  0x20(%ebp)
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	ff d0                	call   *%eax
  8005f2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f5:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fc:	7f e6                	jg     8005e4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005fe:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800601:	bb 00 00 00 00       	mov    $0x0,%ebx
  800606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800609:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060c:	53                   	push   %ebx
  80060d:	51                   	push   %ecx
  80060e:	52                   	push   %edx
  80060f:	50                   	push   %eax
  800610:	e8 27 15 00 00       	call   801b3c <__umoddi3>
  800615:	83 c4 10             	add    $0x10,%esp
  800618:	05 54 22 80 00       	add    $0x802254,%eax
  80061d:	8a 00                	mov    (%eax),%al
  80061f:	0f be c0             	movsbl %al,%eax
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	ff 75 0c             	pushl  0xc(%ebp)
  800628:	50                   	push   %eax
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	ff d0                	call   *%eax
  80062e:	83 c4 10             	add    $0x10,%esp
}
  800631:	90                   	nop
  800632:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80063e:	7e 1c                	jle    80065c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	8d 50 08             	lea    0x8(%eax),%edx
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	89 10                	mov    %edx,(%eax)
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	83 e8 08             	sub    $0x8,%eax
  800655:	8b 50 04             	mov    0x4(%eax),%edx
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	eb 40                	jmp    80069c <getuint+0x65>
	else if (lflag)
  80065c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800660:	74 1e                	je     800680 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	8d 50 04             	lea    0x4(%eax),%edx
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	89 10                	mov    %edx,(%eax)
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 e8 04             	sub    $0x4,%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	eb 1c                	jmp    80069c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800680:	8b 45 08             	mov    0x8(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	8d 50 04             	lea    0x4(%eax),%edx
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	89 10                	mov    %edx,(%eax)
  80068d:	8b 45 08             	mov    0x8(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	83 e8 04             	sub    $0x4,%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069c:	5d                   	pop    %ebp
  80069d:	c3                   	ret    

0080069e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80069e:	55                   	push   %ebp
  80069f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a5:	7e 1c                	jle    8006c3 <getint+0x25>
		return va_arg(*ap, long long);
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	8d 50 08             	lea    0x8(%eax),%edx
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	89 10                	mov    %edx,(%eax)
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	83 e8 08             	sub    $0x8,%eax
  8006bc:	8b 50 04             	mov    0x4(%eax),%edx
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	eb 38                	jmp    8006fb <getint+0x5d>
	else if (lflag)
  8006c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c7:	74 1a                	je     8006e3 <getint+0x45>
		return va_arg(*ap, long);
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	8d 50 04             	lea    0x4(%eax),%edx
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	89 10                	mov    %edx,(%eax)
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	83 e8 04             	sub    $0x4,%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	99                   	cltd   
  8006e1:	eb 18                	jmp    8006fb <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	8d 50 04             	lea    0x4(%eax),%edx
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	89 10                	mov    %edx,(%eax)
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	83 e8 04             	sub    $0x4,%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	99                   	cltd   
}
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	56                   	push   %esi
  800701:	53                   	push   %ebx
  800702:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800705:	eb 17                	jmp    80071e <vprintfmt+0x21>
			if (ch == '\0')
  800707:	85 db                	test   %ebx,%ebx
  800709:	0f 84 c1 03 00 00    	je     800ad0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	53                   	push   %ebx
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	ff d0                	call   *%eax
  80071b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071e:	8b 45 10             	mov    0x10(%ebp),%eax
  800721:	8d 50 01             	lea    0x1(%eax),%edx
  800724:	89 55 10             	mov    %edx,0x10(%ebp)
  800727:	8a 00                	mov    (%eax),%al
  800729:	0f b6 d8             	movzbl %al,%ebx
  80072c:	83 fb 25             	cmp    $0x25,%ebx
  80072f:	75 d6                	jne    800707 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800731:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800735:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800743:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800751:	8b 45 10             	mov    0x10(%ebp),%eax
  800754:	8d 50 01             	lea    0x1(%eax),%edx
  800757:	89 55 10             	mov    %edx,0x10(%ebp)
  80075a:	8a 00                	mov    (%eax),%al
  80075c:	0f b6 d8             	movzbl %al,%ebx
  80075f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800762:	83 f8 5b             	cmp    $0x5b,%eax
  800765:	0f 87 3d 03 00 00    	ja     800aa8 <vprintfmt+0x3ab>
  80076b:	8b 04 85 78 22 80 00 	mov    0x802278(,%eax,4),%eax
  800772:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800774:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800778:	eb d7                	jmp    800751 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80077e:	eb d1                	jmp    800751 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800780:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800787:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078a:	89 d0                	mov    %edx,%eax
  80078c:	c1 e0 02             	shl    $0x2,%eax
  80078f:	01 d0                	add    %edx,%eax
  800791:	01 c0                	add    %eax,%eax
  800793:	01 d8                	add    %ebx,%eax
  800795:	83 e8 30             	sub    $0x30,%eax
  800798:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079b:	8b 45 10             	mov    0x10(%ebp),%eax
  80079e:	8a 00                	mov    (%eax),%al
  8007a0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a6:	7e 3e                	jle    8007e6 <vprintfmt+0xe9>
  8007a8:	83 fb 39             	cmp    $0x39,%ebx
  8007ab:	7f 39                	jg     8007e6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ad:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b0:	eb d5                	jmp    800787 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	83 c0 04             	add    $0x4,%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	83 e8 04             	sub    $0x4,%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c6:	eb 1f                	jmp    8007e7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007cc:	79 83                	jns    800751 <vprintfmt+0x54>
				width = 0;
  8007ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d5:	e9 77 ff ff ff       	jmp    800751 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007da:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e1:	e9 6b ff ff ff       	jmp    800751 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007eb:	0f 89 60 ff ff ff    	jns    800751 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007fe:	e9 4e ff ff ff       	jmp    800751 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800803:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800806:	e9 46 ff ff ff       	jmp    800751 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	83 c0 04             	add    $0x4,%eax
  800811:	89 45 14             	mov    %eax,0x14(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 e8 04             	sub    $0x4,%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	50                   	push   %eax
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
			break;
  80082b:	e9 9b 02 00 00       	jmp    800acb <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	83 c0 04             	add    $0x4,%eax
  800836:	89 45 14             	mov    %eax,0x14(%ebp)
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	83 e8 04             	sub    $0x4,%eax
  80083f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800841:	85 db                	test   %ebx,%ebx
  800843:	79 02                	jns    800847 <vprintfmt+0x14a>
				err = -err;
  800845:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800847:	83 fb 64             	cmp    $0x64,%ebx
  80084a:	7f 0b                	jg     800857 <vprintfmt+0x15a>
  80084c:	8b 34 9d c0 20 80 00 	mov    0x8020c0(,%ebx,4),%esi
  800853:	85 f6                	test   %esi,%esi
  800855:	75 19                	jne    800870 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800857:	53                   	push   %ebx
  800858:	68 65 22 80 00       	push   $0x802265
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	ff 75 08             	pushl  0x8(%ebp)
  800863:	e8 70 02 00 00       	call   800ad8 <printfmt>
  800868:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086b:	e9 5b 02 00 00       	jmp    800acb <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800870:	56                   	push   %esi
  800871:	68 6e 22 80 00       	push   $0x80226e
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	ff 75 08             	pushl  0x8(%ebp)
  80087c:	e8 57 02 00 00       	call   800ad8 <printfmt>
  800881:	83 c4 10             	add    $0x10,%esp
			break;
  800884:	e9 42 02 00 00       	jmp    800acb <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	83 c0 04             	add    $0x4,%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 e8 04             	sub    $0x4,%eax
  800898:	8b 30                	mov    (%eax),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 05                	jne    8008a3 <vprintfmt+0x1a6>
				p = "(null)";
  80089e:	be 71 22 80 00       	mov    $0x802271,%esi
			if (width > 0 && padc != '-')
  8008a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a7:	7e 6d                	jle    800916 <vprintfmt+0x219>
  8008a9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ad:	74 67                	je     800916 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	50                   	push   %eax
  8008b6:	56                   	push   %esi
  8008b7:	e8 1e 03 00 00       	call   800bda <strnlen>
  8008bc:	83 c4 10             	add    $0x10,%esp
  8008bf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c2:	eb 16                	jmp    8008da <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	50                   	push   %eax
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	ff d0                	call   *%eax
  8008d4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008de:	7f e4                	jg     8008c4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e0:	eb 34                	jmp    800916 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e6:	74 1c                	je     800904 <vprintfmt+0x207>
  8008e8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008eb:	7e 05                	jle    8008f2 <vprintfmt+0x1f5>
  8008ed:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f0:	7e 12                	jle    800904 <vprintfmt+0x207>
					putch('?', putdat);
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 0c             	pushl  0xc(%ebp)
  8008f8:	6a 3f                	push   $0x3f
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	ff d0                	call   *%eax
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	eb 0f                	jmp    800913 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	53                   	push   %ebx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800913:	ff 4d e4             	decl   -0x1c(%ebp)
  800916:	89 f0                	mov    %esi,%eax
  800918:	8d 70 01             	lea    0x1(%eax),%esi
  80091b:	8a 00                	mov    (%eax),%al
  80091d:	0f be d8             	movsbl %al,%ebx
  800920:	85 db                	test   %ebx,%ebx
  800922:	74 24                	je     800948 <vprintfmt+0x24b>
  800924:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800928:	78 b8                	js     8008e2 <vprintfmt+0x1e5>
  80092a:	ff 4d e0             	decl   -0x20(%ebp)
  80092d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800931:	79 af                	jns    8008e2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800933:	eb 13                	jmp    800948 <vprintfmt+0x24b>
				putch(' ', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 20                	push   $0x20
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800945:	ff 4d e4             	decl   -0x1c(%ebp)
  800948:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094c:	7f e7                	jg     800935 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80094e:	e9 78 01 00 00       	jmp    800acb <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	ff 75 e8             	pushl  -0x18(%ebp)
  800959:	8d 45 14             	lea    0x14(%ebp),%eax
  80095c:	50                   	push   %eax
  80095d:	e8 3c fd ff ff       	call   80069e <getint>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800971:	85 d2                	test   %edx,%edx
  800973:	79 23                	jns    800998 <vprintfmt+0x29b>
				putch('-', putdat);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	6a 2d                	push   $0x2d
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800988:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098b:	f7 d8                	neg    %eax
  80098d:	83 d2 00             	adc    $0x0,%edx
  800990:	f7 da                	neg    %edx
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800998:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80099f:	e9 bc 00 00 00       	jmp    800a60 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009aa:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ad:	50                   	push   %eax
  8009ae:	e8 84 fc ff ff       	call   800637 <getuint>
  8009b3:	83 c4 10             	add    $0x10,%esp
  8009b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009bc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c3:	e9 98 00 00 00       	jmp    800a60 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ce:	6a 58                	push   $0x58
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	ff d0                	call   *%eax
  8009d5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	6a 58                	push   $0x58
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			break;
  8009f8:	e9 ce 00 00 00       	jmp    800acb <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	6a 30                	push   $0x30
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	ff d0                	call   *%eax
  800a0a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 78                	push   $0x78
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	83 c0 04             	add    $0x4,%eax
  800a23:	89 45 14             	mov    %eax,0x14(%ebp)
  800a26:	8b 45 14             	mov    0x14(%ebp),%eax
  800a29:	83 e8 04             	sub    $0x4,%eax
  800a2c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a38:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a3f:	eb 1f                	jmp    800a60 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 e8             	pushl  -0x18(%ebp)
  800a47:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4a:	50                   	push   %eax
  800a4b:	e8 e7 fb ff ff       	call   800637 <getuint>
  800a50:	83 c4 10             	add    $0x10,%esp
  800a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a56:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a60:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a67:	83 ec 04             	sub    $0x4,%esp
  800a6a:	52                   	push   %edx
  800a6b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a6e:	50                   	push   %eax
  800a6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a72:	ff 75 f0             	pushl  -0x10(%ebp)
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	ff 75 08             	pushl  0x8(%ebp)
  800a7b:	e8 00 fb ff ff       	call   800580 <printnum>
  800a80:	83 c4 20             	add    $0x20,%esp
			break;
  800a83:	eb 46                	jmp    800acb <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	53                   	push   %ebx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
			break;
  800a94:	eb 35                	jmp    800acb <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a96:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800a9d:	eb 2c                	jmp    800acb <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a9f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800aa6:	eb 23                	jmp    800acb <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	6a 25                	push   $0x25
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab8:	ff 4d 10             	decl   0x10(%ebp)
  800abb:	eb 03                	jmp    800ac0 <vprintfmt+0x3c3>
  800abd:	ff 4d 10             	decl   0x10(%ebp)
  800ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac3:	48                   	dec    %eax
  800ac4:	8a 00                	mov    (%eax),%al
  800ac6:	3c 25                	cmp    $0x25,%al
  800ac8:	75 f3                	jne    800abd <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800aca:	90                   	nop
		}
	}
  800acb:	e9 35 fc ff ff       	jmp    800705 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad4:	5b                   	pop    %ebx
  800ad5:	5e                   	pop    %esi
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ade:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae1:	83 c0 04             	add    $0x4,%eax
  800ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aea:	ff 75 f4             	pushl  -0xc(%ebp)
  800aed:	50                   	push   %eax
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	ff 75 08             	pushl  0x8(%ebp)
  800af4:	e8 04 fc ff ff       	call   8006fd <vprintfmt>
  800af9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afc:	90                   	nop
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	8b 40 08             	mov    0x8(%eax),%eax
  800b08:	8d 50 01             	lea    0x1(%eax),%edx
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 10                	mov    (%eax),%edx
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 40 04             	mov    0x4(%eax),%eax
  800b1c:	39 c2                	cmp    %eax,%edx
  800b1e:	73 12                	jae    800b32 <sprintputch+0x33>
		*b->buf++ = ch;
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	8d 48 01             	lea    0x1(%eax),%ecx
  800b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2b:	89 0a                	mov    %ecx,(%edx)
  800b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b30:	88 10                	mov    %dl,(%eax)
}
  800b32:	90                   	nop
  800b33:	5d                   	pop    %ebp
  800b34:	c3                   	ret    

00800b35 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	01 d0                	add    %edx,%eax
  800b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5a:	74 06                	je     800b62 <vsnprintf+0x2d>
  800b5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b60:	7f 07                	jg     800b69 <vsnprintf+0x34>
		return -E_INVAL;
  800b62:	b8 03 00 00 00       	mov    $0x3,%eax
  800b67:	eb 20                	jmp    800b89 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b69:	ff 75 14             	pushl  0x14(%ebp)
  800b6c:	ff 75 10             	pushl  0x10(%ebp)
  800b6f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b72:	50                   	push   %eax
  800b73:	68 ff 0a 80 00       	push   $0x800aff
  800b78:	e8 80 fb ff ff       	call   8006fd <vprintfmt>
  800b7d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b83:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b91:	8d 45 10             	lea    0x10(%ebp),%eax
  800b94:	83 c0 04             	add    $0x4,%eax
  800b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba0:	50                   	push   %eax
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	ff 75 08             	pushl  0x8(%ebp)
  800ba7:	e8 89 ff ff ff       	call   800b35 <vsnprintf>
  800bac:	83 c4 10             	add    $0x10,%esp
  800baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb5:	c9                   	leave  
  800bb6:	c3                   	ret    

00800bb7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc4:	eb 06                	jmp    800bcc <strlen+0x15>
		n++;
  800bc6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc9:	ff 45 08             	incl   0x8(%ebp)
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	8a 00                	mov    (%eax),%al
  800bd1:	84 c0                	test   %al,%al
  800bd3:	75 f1                	jne    800bc6 <strlen+0xf>
		n++;
	return n;
  800bd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd8:	c9                   	leave  
  800bd9:	c3                   	ret    

00800bda <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be7:	eb 09                	jmp    800bf2 <strnlen+0x18>
		n++;
  800be9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bec:	ff 45 08             	incl   0x8(%ebp)
  800bef:	ff 4d 0c             	decl   0xc(%ebp)
  800bf2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf6:	74 09                	je     800c01 <strnlen+0x27>
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8a 00                	mov    (%eax),%al
  800bfd:	84 c0                	test   %al,%al
  800bff:	75 e8                	jne    800be9 <strnlen+0xf>
		n++;
	return n;
  800c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c12:	90                   	nop
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8d 50 01             	lea    0x1(%eax),%edx
  800c19:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c22:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c25:	8a 12                	mov    (%edx),%dl
  800c27:	88 10                	mov    %dl,(%eax)
  800c29:	8a 00                	mov    (%eax),%al
  800c2b:	84 c0                	test   %al,%al
  800c2d:	75 e4                	jne    800c13 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c47:	eb 1f                	jmp    800c68 <strncpy+0x34>
		*dst++ = *src;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8d 50 01             	lea    0x1(%eax),%edx
  800c4f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c55:	8a 12                	mov    (%edx),%dl
  800c57:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	8a 00                	mov    (%eax),%al
  800c5e:	84 c0                	test   %al,%al
  800c60:	74 03                	je     800c65 <strncpy+0x31>
			src++;
  800c62:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c65:	ff 45 fc             	incl   -0x4(%ebp)
  800c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6e:	72 d9                	jb     800c49 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c70:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c85:	74 30                	je     800cb7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c87:	eb 16                	jmp    800c9f <strlcpy+0x2a>
			*dst++ = *src++;
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8d 50 01             	lea    0x1(%eax),%edx
  800c8f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c95:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c98:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9b:	8a 12                	mov    (%edx),%dl
  800c9d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c9f:	ff 4d 10             	decl   0x10(%ebp)
  800ca2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca6:	74 09                	je     800cb1 <strlcpy+0x3c>
  800ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	75 d8                	jne    800c89 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbd:	29 c2                	sub    %eax,%edx
  800cbf:	89 d0                	mov    %edx,%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc6:	eb 06                	jmp    800cce <strcmp+0xb>
		p++, q++;
  800cc8:	ff 45 08             	incl   0x8(%ebp)
  800ccb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	84 c0                	test   %al,%al
  800cd5:	74 0e                	je     800ce5 <strcmp+0x22>
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8a 10                	mov    (%eax),%dl
  800cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	38 c2                	cmp    %al,%dl
  800ce3:	74 e3                	je     800cc8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	0f b6 d0             	movzbl %al,%edx
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	0f b6 c0             	movzbl %al,%eax
  800cf5:	29 c2                	sub    %eax,%edx
  800cf7:	89 d0                	mov    %edx,%eax
}
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cfe:	eb 09                	jmp    800d09 <strncmp+0xe>
		n--, p++, q++;
  800d00:	ff 4d 10             	decl   0x10(%ebp)
  800d03:	ff 45 08             	incl   0x8(%ebp)
  800d06:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0d:	74 17                	je     800d26 <strncmp+0x2b>
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	74 0e                	je     800d26 <strncmp+0x2b>
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 10                	mov    (%eax),%dl
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	38 c2                	cmp    %al,%dl
  800d24:	74 da                	je     800d00 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	75 07                	jne    800d33 <strncmp+0x38>
		return 0;
  800d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d31:	eb 14                	jmp    800d47 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	0f b6 d0             	movzbl %al,%edx
  800d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	0f b6 c0             	movzbl %al,%eax
  800d43:	29 c2                	sub    %eax,%edx
  800d45:	89 d0                	mov    %edx,%eax
}
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 04             	sub    $0x4,%esp
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d55:	eb 12                	jmp    800d69 <strchr+0x20>
		if (*s == c)
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5f:	75 05                	jne    800d66 <strchr+0x1d>
			return (char *) s;
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	eb 11                	jmp    800d77 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d66:	ff 45 08             	incl   0x8(%ebp)
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	84 c0                	test   %al,%al
  800d70:	75 e5                	jne    800d57 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 04             	sub    $0x4,%esp
  800d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d82:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d85:	eb 0d                	jmp    800d94 <strfind+0x1b>
		if (*s == c)
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8f:	74 0e                	je     800d9f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d91:	ff 45 08             	incl   0x8(%ebp)
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	84 c0                	test   %al,%al
  800d9b:	75 ea                	jne    800d87 <strfind+0xe>
  800d9d:	eb 01                	jmp    800da0 <strfind+0x27>
		if (*s == c)
			break;
  800d9f:	90                   	nop
	return (char *) s;
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da3:	c9                   	leave  
  800da4:	c3                   	ret    

00800da5 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800db1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800db5:	76 63                	jbe    800e1a <memset+0x75>
		uint64 data_block = c;
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	99                   	cltd   
  800dbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dbe:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc7:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800dcb:	c1 e0 08             	shl    $0x8,%eax
  800dce:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dd1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dda:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800dde:	c1 e0 10             	shl    $0x10,%eax
  800de1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800de4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ded:	89 c2                	mov    %eax,%edx
  800def:	b8 00 00 00 00       	mov    $0x0,%eax
  800df4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800df7:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800dfa:	eb 18                	jmp    800e14 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800dfc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800dff:	8d 41 08             	lea    0x8(%ecx),%eax
  800e02:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0b:	89 01                	mov    %eax,(%ecx)
  800e0d:	89 51 04             	mov    %edx,0x4(%ecx)
  800e10:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e14:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e18:	77 e2                	ja     800dfc <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1e:	74 23                	je     800e43 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e23:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e26:	eb 0e                	jmp    800e36 <memset+0x91>
			*p8++ = (uint8)c;
  800e28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2b:	8d 50 01             	lea    0x1(%eax),%edx
  800e2e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e34:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3f:	85 c0                	test   %eax,%eax
  800e41:	75 e5                	jne    800e28 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e46:	c9                   	leave  
  800e47:	c3                   	ret    

00800e48 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e5a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e5e:	76 24                	jbe    800e84 <memcpy+0x3c>
		while(n >= 8){
  800e60:	eb 1c                	jmp    800e7e <memcpy+0x36>
			*d64 = *s64;
  800e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e65:	8b 50 04             	mov    0x4(%eax),%edx
  800e68:	8b 00                	mov    (%eax),%eax
  800e6a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e6d:	89 01                	mov    %eax,(%ecx)
  800e6f:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e72:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e76:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e7a:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e7e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e82:	77 de                	ja     800e62 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e88:	74 31                	je     800ebb <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800e90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800e96:	eb 16                	jmp    800eae <memcpy+0x66>
			*d8++ = *s8++;
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	8d 50 01             	lea    0x1(%eax),%edx
  800e9e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ea1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea7:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800eae:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb4:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	75 dd                	jne    800e98 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebe:	c9                   	leave  
  800ebf:	c3                   	ret    

00800ec0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ed8:	73 50                	jae    800f2a <memmove+0x6a>
  800eda:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee5:	76 43                	jbe    800f2a <memmove+0x6a>
		s += n;
  800ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eea:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef3:	eb 10                	jmp    800f05 <memmove+0x45>
			*--d = *--s;
  800ef5:	ff 4d f8             	decl   -0x8(%ebp)
  800ef8:	ff 4d fc             	decl   -0x4(%ebp)
  800efb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efe:	8a 10                	mov    (%eax),%dl
  800f00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f03:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f05:	8b 45 10             	mov    0x10(%ebp),%eax
  800f08:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	75 e3                	jne    800ef5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f12:	eb 23                	jmp    800f37 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f17:	8d 50 01             	lea    0x1(%eax),%edx
  800f1a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f23:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f26:	8a 12                	mov    (%edx),%dl
  800f28:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f30:	89 55 10             	mov    %edx,0x10(%ebp)
  800f33:	85 c0                	test   %eax,%eax
  800f35:	75 dd                	jne    800f14 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    

00800f3c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f4e:	eb 2a                	jmp    800f7a <memcmp+0x3e>
		if (*s1 != *s2)
  800f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f53:	8a 10                	mov    (%eax),%dl
  800f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	38 c2                	cmp    %al,%dl
  800f5c:	74 16                	je     800f74 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 d0             	movzbl %al,%edx
  800f66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	0f b6 c0             	movzbl %al,%eax
  800f6e:	29 c2                	sub    %eax,%edx
  800f70:	89 d0                	mov    %edx,%eax
  800f72:	eb 18                	jmp    800f8c <memcmp+0x50>
		s1++, s2++;
  800f74:	ff 45 fc             	incl   -0x4(%ebp)
  800f77:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f80:	89 55 10             	mov    %edx,0x10(%ebp)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	75 c9                	jne    800f50 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f94:	8b 55 08             	mov    0x8(%ebp),%edx
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	01 d0                	add    %edx,%eax
  800f9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f9f:	eb 15                	jmp    800fb6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	0f b6 d0             	movzbl %al,%edx
  800fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fac:	0f b6 c0             	movzbl %al,%eax
  800faf:	39 c2                	cmp    %eax,%edx
  800fb1:	74 0d                	je     800fc0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fbc:	72 e3                	jb     800fa1 <memfind+0x13>
  800fbe:	eb 01                	jmp    800fc1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fc0:	90                   	nop
	return (void *) s;
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc4:	c9                   	leave  
  800fc5:	c3                   	ret    

00800fc6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fd3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fda:	eb 03                	jmp    800fdf <strtol+0x19>
		s++;
  800fdc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	3c 20                	cmp    $0x20,%al
  800fe6:	74 f4                	je     800fdc <strtol+0x16>
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 09                	cmp    $0x9,%al
  800fef:	74 eb                	je     800fdc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 2b                	cmp    $0x2b,%al
  800ff8:	75 05                	jne    800fff <strtol+0x39>
		s++;
  800ffa:	ff 45 08             	incl   0x8(%ebp)
  800ffd:	eb 13                	jmp    801012 <strtol+0x4c>
	else if (*s == '-')
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	3c 2d                	cmp    $0x2d,%al
  801006:	75 0a                	jne    801012 <strtol+0x4c>
		s++, neg = 1;
  801008:	ff 45 08             	incl   0x8(%ebp)
  80100b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801012:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801016:	74 06                	je     80101e <strtol+0x58>
  801018:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80101c:	75 20                	jne    80103e <strtol+0x78>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 30                	cmp    $0x30,%al
  801025:	75 17                	jne    80103e <strtol+0x78>
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	40                   	inc    %eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 78                	cmp    $0x78,%al
  80102f:	75 0d                	jne    80103e <strtol+0x78>
		s += 2, base = 16;
  801031:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801035:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80103c:	eb 28                	jmp    801066 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80103e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801042:	75 15                	jne    801059 <strtol+0x93>
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	3c 30                	cmp    $0x30,%al
  80104b:	75 0c                	jne    801059 <strtol+0x93>
		s++, base = 8;
  80104d:	ff 45 08             	incl   0x8(%ebp)
  801050:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801057:	eb 0d                	jmp    801066 <strtol+0xa0>
	else if (base == 0)
  801059:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105d:	75 07                	jne    801066 <strtol+0xa0>
		base = 10;
  80105f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 2f                	cmp    $0x2f,%al
  80106d:	7e 19                	jle    801088 <strtol+0xc2>
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	8a 00                	mov    (%eax),%al
  801074:	3c 39                	cmp    $0x39,%al
  801076:	7f 10                	jg     801088 <strtol+0xc2>
			dig = *s - '0';
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	0f be c0             	movsbl %al,%eax
  801080:	83 e8 30             	sub    $0x30,%eax
  801083:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801086:	eb 42                	jmp    8010ca <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 60                	cmp    $0x60,%al
  80108f:	7e 19                	jle    8010aa <strtol+0xe4>
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	3c 7a                	cmp    $0x7a,%al
  801098:	7f 10                	jg     8010aa <strtol+0xe4>
			dig = *s - 'a' + 10;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	0f be c0             	movsbl %al,%eax
  8010a2:	83 e8 57             	sub    $0x57,%eax
  8010a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010a8:	eb 20                	jmp    8010ca <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	3c 40                	cmp    $0x40,%al
  8010b1:	7e 39                	jle    8010ec <strtol+0x126>
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	3c 5a                	cmp    $0x5a,%al
  8010ba:	7f 30                	jg     8010ec <strtol+0x126>
			dig = *s - 'A' + 10;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	0f be c0             	movsbl %al,%eax
  8010c4:	83 e8 37             	sub    $0x37,%eax
  8010c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010cd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d0:	7d 19                	jge    8010eb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d2:	ff 45 08             	incl   0x8(%ebp)
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010dc:	89 c2                	mov    %eax,%edx
  8010de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e1:	01 d0                	add    %edx,%eax
  8010e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010e6:	e9 7b ff ff ff       	jmp    801066 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010eb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f0:	74 08                	je     8010fa <strtol+0x134>
		*endptr = (char *) s;
  8010f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fe:	74 07                	je     801107 <strtol+0x141>
  801100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801103:	f7 d8                	neg    %eax
  801105:	eb 03                	jmp    80110a <strtol+0x144>
  801107:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <ltostr>:

void
ltostr(long value, char *str)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801112:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801119:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801120:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801124:	79 13                	jns    801139 <ltostr+0x2d>
	{
		neg = 1;
  801126:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801133:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801136:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801141:	99                   	cltd   
  801142:	f7 f9                	idiv   %ecx
  801144:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801147:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114a:	8d 50 01             	lea    0x1(%eax),%edx
  80114d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801150:	89 c2                	mov    %eax,%edx
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	01 d0                	add    %edx,%eax
  801157:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80115a:	83 c2 30             	add    $0x30,%edx
  80115d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80115f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801162:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801167:	f7 e9                	imul   %ecx
  801169:	c1 fa 02             	sar    $0x2,%edx
  80116c:	89 c8                	mov    %ecx,%eax
  80116e:	c1 f8 1f             	sar    $0x1f,%eax
  801171:	29 c2                	sub    %eax,%edx
  801173:	89 d0                	mov    %edx,%eax
  801175:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801178:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80117c:	75 bb                	jne    801139 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80117e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	48                   	dec    %eax
  801189:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80118c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801190:	74 3d                	je     8011cf <ltostr+0xc3>
		start = 1 ;
  801192:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801199:	eb 34                	jmp    8011cf <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80119b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	01 d0                	add    %edx,%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	01 c2                	add    %eax,%edx
  8011b0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 c8                	add    %ecx,%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011c7:	88 02                	mov    %al,(%edx)
		start++ ;
  8011c9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011cc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d5:	7c c4                	jl     80119b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011d7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dd:	01 d0                	add    %edx,%eax
  8011df:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e2:	90                   	nop
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011eb:	ff 75 08             	pushl  0x8(%ebp)
  8011ee:	e8 c4 f9 ff ff       	call   800bb7 <strlen>
  8011f3:	83 c4 04             	add    $0x4,%esp
  8011f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011f9:	ff 75 0c             	pushl  0xc(%ebp)
  8011fc:	e8 b6 f9 ff ff       	call   800bb7 <strlen>
  801201:	83 c4 04             	add    $0x4,%esp
  801204:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801207:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80120e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801215:	eb 17                	jmp    80122e <strcconcat+0x49>
		final[s] = str1[s] ;
  801217:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	01 c2                	add    %eax,%edx
  80121f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	01 c8                	add    %ecx,%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80122b:	ff 45 fc             	incl   -0x4(%ebp)
  80122e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801231:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801234:	7c e1                	jl     801217 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801236:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80123d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801244:	eb 1f                	jmp    801265 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801246:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801249:	8d 50 01             	lea    0x1(%eax),%edx
  80124c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80124f:	89 c2                	mov    %eax,%edx
  801251:	8b 45 10             	mov    0x10(%ebp),%eax
  801254:	01 c2                	add    %eax,%edx
  801256:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 c8                	add    %ecx,%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801262:	ff 45 f8             	incl   -0x8(%ebp)
  801265:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801268:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126b:	7c d9                	jl     801246 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80126d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 d0                	add    %edx,%eax
  801275:	c6 00 00             	movb   $0x0,(%eax)
}
  801278:	90                   	nop
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80127e:	8b 45 14             	mov    0x14(%ebp),%eax
  801281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801287:	8b 45 14             	mov    0x14(%ebp),%eax
  80128a:	8b 00                	mov    (%eax),%eax
  80128c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801293:	8b 45 10             	mov    0x10(%ebp),%eax
  801296:	01 d0                	add    %edx,%eax
  801298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80129e:	eb 0c                	jmp    8012ac <strsplit+0x31>
			*string++ = 0;
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8d 50 01             	lea    0x1(%eax),%edx
  8012a6:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	84 c0                	test   %al,%al
  8012b3:	74 18                	je     8012cd <strsplit+0x52>
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f be c0             	movsbl %al,%eax
  8012bd:	50                   	push   %eax
  8012be:	ff 75 0c             	pushl  0xc(%ebp)
  8012c1:	e8 83 fa ff ff       	call   800d49 <strchr>
  8012c6:	83 c4 08             	add    $0x8,%esp
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	75 d3                	jne    8012a0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	84 c0                	test   %al,%al
  8012d4:	74 5a                	je     801330 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	83 f8 0f             	cmp    $0xf,%eax
  8012de:	75 07                	jne    8012e7 <strsplit+0x6c>
		{
			return 0;
  8012e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e5:	eb 66                	jmp    80134d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ea:	8b 00                	mov    (%eax),%eax
  8012ec:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ef:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f2:	89 0a                	mov    %ecx,(%edx)
  8012f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fe:	01 c2                	add    %eax,%edx
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801305:	eb 03                	jmp    80130a <strsplit+0x8f>
			string++;
  801307:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	84 c0                	test   %al,%al
  801311:	74 8b                	je     80129e <strsplit+0x23>
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	50                   	push   %eax
  80131c:	ff 75 0c             	pushl  0xc(%ebp)
  80131f:	e8 25 fa ff ff       	call   800d49 <strchr>
  801324:	83 c4 08             	add    $0x8,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	74 dc                	je     801307 <strsplit+0x8c>
			string++;
	}
  80132b:	e9 6e ff ff ff       	jmp    80129e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801330:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801331:	8b 45 14             	mov    0x14(%ebp),%eax
  801334:	8b 00                	mov    (%eax),%eax
  801336:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80133d:	8b 45 10             	mov    0x10(%ebp),%eax
  801340:	01 d0                	add    %edx,%eax
  801342:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801348:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80135b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801362:	eb 4a                	jmp    8013ae <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801364:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	01 c2                	add    %eax,%edx
  80136c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	01 c8                	add    %ecx,%eax
  801374:	8a 00                	mov    (%eax),%al
  801376:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801378:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	8a 00                	mov    (%eax),%al
  801382:	3c 40                	cmp    $0x40,%al
  801384:	7e 25                	jle    8013ab <str2lower+0x5c>
  801386:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138c:	01 d0                	add    %edx,%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	3c 5a                	cmp    $0x5a,%al
  801392:	7f 17                	jg     8013ab <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801394:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	01 d0                	add    %edx,%eax
  80139c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139f:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a2:	01 ca                	add    %ecx,%edx
  8013a4:	8a 12                	mov    (%edx),%dl
  8013a6:	83 c2 20             	add    $0x20,%edx
  8013a9:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013ab:	ff 45 fc             	incl   -0x4(%ebp)
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	e8 01 f8 ff ff       	call   800bb7 <strlen>
  8013b6:	83 c4 04             	add    $0x4,%esp
  8013b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013bc:	7f a6                	jg     801364 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013be:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	57                   	push   %edi
  8013c7:	56                   	push   %esi
  8013c8:	53                   	push   %ebx
  8013c9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013d8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013db:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013de:	cd 30                	int    $0x30
  8013e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013e6:	83 c4 10             	add    $0x10,%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5f                   	pop    %edi
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    

008013ee <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 04             	sub    $0x4,%esp
  8013f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8013fa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	6a 00                	push   $0x0
  801406:	51                   	push   %ecx
  801407:	52                   	push   %edx
  801408:	ff 75 0c             	pushl  0xc(%ebp)
  80140b:	50                   	push   %eax
  80140c:	6a 00                	push   $0x0
  80140e:	e8 b0 ff ff ff       	call   8013c3 <syscall>
  801413:	83 c4 18             	add    $0x18,%esp
}
  801416:	90                   	nop
  801417:	c9                   	leave  
  801418:	c3                   	ret    

00801419 <sys_cgetc>:

int
sys_cgetc(void)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 02                	push   $0x2
  801428:	e8 96 ff ff ff       	call   8013c3 <syscall>
  80142d:	83 c4 18             	add    $0x18,%esp
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 03                	push   $0x3
  801441:	e8 7d ff ff ff       	call   8013c3 <syscall>
  801446:	83 c4 18             	add    $0x18,%esp
}
  801449:	90                   	nop
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 04                	push   $0x4
  80145b:	e8 63 ff ff ff       	call   8013c3 <syscall>
  801460:	83 c4 18             	add    $0x18,%esp
}
  801463:	90                   	nop
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	52                   	push   %edx
  801476:	50                   	push   %eax
  801477:	6a 08                	push   $0x8
  801479:	e8 45 ff ff ff       	call   8013c3 <syscall>
  80147e:	83 c4 18             	add    $0x18,%esp
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	56                   	push   %esi
  801487:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801488:	8b 75 18             	mov    0x18(%ebp),%esi
  80148b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80148e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801491:	8b 55 0c             	mov    0xc(%ebp),%edx
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	56                   	push   %esi
  801498:	53                   	push   %ebx
  801499:	51                   	push   %ecx
  80149a:	52                   	push   %edx
  80149b:	50                   	push   %eax
  80149c:	6a 09                	push   $0x9
  80149e:	e8 20 ff ff ff       	call   8013c3 <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
}
  8014a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a9:	5b                   	pop    %ebx
  8014aa:	5e                   	pop    %esi
  8014ab:	5d                   	pop    %ebp
  8014ac:	c3                   	ret    

008014ad <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	ff 75 08             	pushl  0x8(%ebp)
  8014bb:	6a 0a                	push   $0xa
  8014bd:	e8 01 ff ff ff       	call   8013c3 <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	ff 75 0c             	pushl  0xc(%ebp)
  8014d3:	ff 75 08             	pushl  0x8(%ebp)
  8014d6:	6a 0b                	push   $0xb
  8014d8:	e8 e6 fe ff ff       	call   8013c3 <syscall>
  8014dd:	83 c4 18             	add    $0x18,%esp
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 0c                	push   $0xc
  8014f1:	e8 cd fe ff ff       	call   8013c3 <syscall>
  8014f6:	83 c4 18             	add    $0x18,%esp
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 0d                	push   $0xd
  80150a:	e8 b4 fe ff ff       	call   8013c3 <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 0e                	push   $0xe
  801523:	e8 9b fe ff ff       	call   8013c3 <syscall>
  801528:	83 c4 18             	add    $0x18,%esp
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 0f                	push   $0xf
  80153c:	e8 82 fe ff ff       	call   8013c3 <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	ff 75 08             	pushl  0x8(%ebp)
  801554:	6a 10                	push   $0x10
  801556:	e8 68 fe ff ff       	call   8013c3 <syscall>
  80155b:	83 c4 18             	add    $0x18,%esp
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 11                	push   $0x11
  80156f:	e8 4f fe ff ff       	call   8013c3 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
}
  801577:	90                   	nop
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_cputc>:

void
sys_cputc(const char c)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 04             	sub    $0x4,%esp
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801586:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	50                   	push   %eax
  801593:	6a 01                	push   $0x1
  801595:	e8 29 fe ff ff       	call   8013c3 <syscall>
  80159a:	83 c4 18             	add    $0x18,%esp
}
  80159d:	90                   	nop
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 14                	push   $0x14
  8015af:	e8 0f fe ff ff       	call   8013c3 <syscall>
  8015b4:	83 c4 18             	add    $0x18,%esp
}
  8015b7:	90                   	nop
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015c6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015c9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	6a 00                	push   $0x0
  8015d2:	51                   	push   %ecx
  8015d3:	52                   	push   %edx
  8015d4:	ff 75 0c             	pushl  0xc(%ebp)
  8015d7:	50                   	push   %eax
  8015d8:	6a 15                	push   $0x15
  8015da:	e8 e4 fd ff ff       	call   8013c3 <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	52                   	push   %edx
  8015f4:	50                   	push   %eax
  8015f5:	6a 16                	push   $0x16
  8015f7:	e8 c7 fd ff ff       	call   8013c3 <syscall>
  8015fc:	83 c4 18             	add    $0x18,%esp
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801604:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	51                   	push   %ecx
  801612:	52                   	push   %edx
  801613:	50                   	push   %eax
  801614:	6a 17                	push   $0x17
  801616:	e8 a8 fd ff ff       	call   8013c3 <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801623:	8b 55 0c             	mov    0xc(%ebp),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	52                   	push   %edx
  801630:	50                   	push   %eax
  801631:	6a 18                	push   $0x18
  801633:	e8 8b fd ff ff       	call   8013c3 <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	6a 00                	push   $0x0
  801645:	ff 75 14             	pushl  0x14(%ebp)
  801648:	ff 75 10             	pushl  0x10(%ebp)
  80164b:	ff 75 0c             	pushl  0xc(%ebp)
  80164e:	50                   	push   %eax
  80164f:	6a 19                	push   $0x19
  801651:	e8 6d fd ff ff       	call   8013c3 <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	50                   	push   %eax
  80166a:	6a 1a                	push   $0x1a
  80166c:	e8 52 fd ff ff       	call   8013c3 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	90                   	nop
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	50                   	push   %eax
  801686:	6a 1b                	push   $0x1b
  801688:	e8 36 fd ff ff       	call   8013c3 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 05                	push   $0x5
  8016a1:	e8 1d fd ff ff       	call   8013c3 <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 06                	push   $0x6
  8016ba:	e8 04 fd ff ff       	call   8013c3 <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 07                	push   $0x7
  8016d3:	e8 eb fc ff ff       	call   8013c3 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_exit_env>:


void sys_exit_env(void)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 1c                	push   $0x1c
  8016ec:	e8 d2 fc ff ff       	call   8013c3 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	90                   	nop
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016fd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801700:	8d 50 04             	lea    0x4(%eax),%edx
  801703:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	52                   	push   %edx
  80170d:	50                   	push   %eax
  80170e:	6a 1d                	push   $0x1d
  801710:	e8 ae fc ff ff       	call   8013c3 <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
	return result;
  801718:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80171b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801721:	89 01                	mov    %eax,(%ecx)
  801723:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	c9                   	leave  
  80172a:	c2 04 00             	ret    $0x4

0080172d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	ff 75 10             	pushl  0x10(%ebp)
  801737:	ff 75 0c             	pushl  0xc(%ebp)
  80173a:	ff 75 08             	pushl  0x8(%ebp)
  80173d:	6a 13                	push   $0x13
  80173f:	e8 7f fc ff ff       	call   8013c3 <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
	return ;
  801747:	90                   	nop
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_rcr2>:
uint32 sys_rcr2()
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 1e                	push   $0x1e
  801759:	e8 65 fc ff ff       	call   8013c3 <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80176f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	50                   	push   %eax
  80177c:	6a 1f                	push   $0x1f
  80177e:	e8 40 fc ff ff       	call   8013c3 <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
	return ;
  801786:	90                   	nop
}
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <rsttst>:
void rsttst()
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 21                	push   $0x21
  801798:	e8 26 fc ff ff       	call   8013c3 <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a0:	90                   	nop
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017af:	8b 55 18             	mov    0x18(%ebp),%edx
  8017b2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017b6:	52                   	push   %edx
  8017b7:	50                   	push   %eax
  8017b8:	ff 75 10             	pushl  0x10(%ebp)
  8017bb:	ff 75 0c             	pushl  0xc(%ebp)
  8017be:	ff 75 08             	pushl  0x8(%ebp)
  8017c1:	6a 20                	push   $0x20
  8017c3:	e8 fb fb ff ff       	call   8013c3 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017cb:	90                   	nop
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <chktst>:
void chktst(uint32 n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	6a 22                	push   $0x22
  8017de:	e8 e0 fb ff ff       	call   8013c3 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e6:	90                   	nop
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <inctst>:

void inctst()
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 23                	push   $0x23
  8017f8:	e8 c6 fb ff ff       	call   8013c3 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801800:	90                   	nop
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <gettst>:
uint32 gettst()
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 24                	push   $0x24
  801812:	e8 ac fb ff ff       	call   8013c3 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 25                	push   $0x25
  80182b:	e8 93 fb ff ff       	call   8013c3 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
  801833:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801838:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	ff 75 08             	pushl  0x8(%ebp)
  801855:	6a 26                	push   $0x26
  801857:	e8 67 fb ff ff       	call   8013c3 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
	return ;
  80185f:	90                   	nop
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801866:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801869:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	53                   	push   %ebx
  801875:	51                   	push   %ecx
  801876:	52                   	push   %edx
  801877:	50                   	push   %eax
  801878:	6a 27                	push   $0x27
  80187a:	e8 44 fb ff ff       	call   8013c3 <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	52                   	push   %edx
  801897:	50                   	push   %eax
  801898:	6a 28                	push   $0x28
  80189a:	e8 24 fb ff ff       	call   8013c3 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018a7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	51                   	push   %ecx
  8018b3:	ff 75 10             	pushl  0x10(%ebp)
  8018b6:	52                   	push   %edx
  8018b7:	50                   	push   %eax
  8018b8:	6a 29                	push   $0x29
  8018ba:	e8 04 fb ff ff       	call   8013c3 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	ff 75 10             	pushl  0x10(%ebp)
  8018ce:	ff 75 0c             	pushl  0xc(%ebp)
  8018d1:	ff 75 08             	pushl  0x8(%ebp)
  8018d4:	6a 12                	push   $0x12
  8018d6:	e8 e8 fa ff ff       	call   8013c3 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
	return ;
  8018de:	90                   	nop
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	52                   	push   %edx
  8018f1:	50                   	push   %eax
  8018f2:	6a 2a                	push   $0x2a
  8018f4:	e8 ca fa ff ff       	call   8013c3 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
	return;
  8018fc:	90                   	nop
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 2b                	push   $0x2b
  80190e:	e8 b0 fa ff ff       	call   8013c3 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	ff 75 0c             	pushl  0xc(%ebp)
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	6a 2d                	push   $0x2d
  801929:	e8 95 fa ff ff       	call   8013c3 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
	return;
  801931:	90                   	nop
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	ff 75 0c             	pushl  0xc(%ebp)
  801940:	ff 75 08             	pushl  0x8(%ebp)
  801943:	6a 2c                	push   $0x2c
  801945:	e8 79 fa ff ff       	call   8013c3 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
	return ;
  80194d:	90                   	nop
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801953:	8b 55 0c             	mov    0xc(%ebp),%edx
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	52                   	push   %edx
  801960:	50                   	push   %eax
  801961:	6a 2e                	push   $0x2e
  801963:	e8 5b fa ff ff       	call   8013c3 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
	    return;
  80196b:	90                   	nop
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801974:	8b 55 08             	mov    0x8(%ebp),%edx
  801977:	89 d0                	mov    %edx,%eax
  801979:	c1 e0 02             	shl    $0x2,%eax
  80197c:	01 d0                	add    %edx,%eax
  80197e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801985:	01 d0                	add    %edx,%eax
  801987:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80198e:	01 d0                	add    %edx,%eax
  801990:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801997:	01 d0                	add    %edx,%eax
  801999:	c1 e0 04             	shl    $0x4,%eax
  80199c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  80199f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8019a6:	0f 31                	rdtsc  
  8019a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8019ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019b7:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8019ba:	eb 46                	jmp    801a02 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8019bc:	0f 31                	rdtsc  
  8019be:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8019c1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8019c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8019ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d6:	29 c2                	sub    %eax,%edx
  8019d8:	89 d0                	mov    %edx,%eax
  8019da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e3:	89 d1                	mov    %edx,%ecx
  8019e5:	29 c1                	sub    %eax,%ecx
  8019e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ed:	39 c2                	cmp    %eax,%edx
  8019ef:	0f 97 c0             	seta   %al
  8019f2:	0f b6 c0             	movzbl %al,%eax
  8019f5:	29 c1                	sub    %eax,%ecx
  8019f7:	89 c8                	mov    %ecx,%eax
  8019f9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a05:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a08:	72 b2                	jb     8019bc <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a1a:	eb 03                	jmp    801a1f <busy_wait+0x12>
  801a1c:	ff 45 fc             	incl   -0x4(%ebp)
  801a1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a22:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a25:	72 f5                	jb     801a1c <busy_wait+0xf>
	return i;
  801a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <__udivdi3>:
  801a2c:	55                   	push   %ebp
  801a2d:	57                   	push   %edi
  801a2e:	56                   	push   %esi
  801a2f:	53                   	push   %ebx
  801a30:	83 ec 1c             	sub    $0x1c,%esp
  801a33:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a37:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a43:	89 ca                	mov    %ecx,%edx
  801a45:	89 f8                	mov    %edi,%eax
  801a47:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a4b:	85 f6                	test   %esi,%esi
  801a4d:	75 2d                	jne    801a7c <__udivdi3+0x50>
  801a4f:	39 cf                	cmp    %ecx,%edi
  801a51:	77 65                	ja     801ab8 <__udivdi3+0x8c>
  801a53:	89 fd                	mov    %edi,%ebp
  801a55:	85 ff                	test   %edi,%edi
  801a57:	75 0b                	jne    801a64 <__udivdi3+0x38>
  801a59:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5e:	31 d2                	xor    %edx,%edx
  801a60:	f7 f7                	div    %edi
  801a62:	89 c5                	mov    %eax,%ebp
  801a64:	31 d2                	xor    %edx,%edx
  801a66:	89 c8                	mov    %ecx,%eax
  801a68:	f7 f5                	div    %ebp
  801a6a:	89 c1                	mov    %eax,%ecx
  801a6c:	89 d8                	mov    %ebx,%eax
  801a6e:	f7 f5                	div    %ebp
  801a70:	89 cf                	mov    %ecx,%edi
  801a72:	89 fa                	mov    %edi,%edx
  801a74:	83 c4 1c             	add    $0x1c,%esp
  801a77:	5b                   	pop    %ebx
  801a78:	5e                   	pop    %esi
  801a79:	5f                   	pop    %edi
  801a7a:	5d                   	pop    %ebp
  801a7b:	c3                   	ret    
  801a7c:	39 ce                	cmp    %ecx,%esi
  801a7e:	77 28                	ja     801aa8 <__udivdi3+0x7c>
  801a80:	0f bd fe             	bsr    %esi,%edi
  801a83:	83 f7 1f             	xor    $0x1f,%edi
  801a86:	75 40                	jne    801ac8 <__udivdi3+0x9c>
  801a88:	39 ce                	cmp    %ecx,%esi
  801a8a:	72 0a                	jb     801a96 <__udivdi3+0x6a>
  801a8c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a90:	0f 87 9e 00 00 00    	ja     801b34 <__udivdi3+0x108>
  801a96:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9b:	89 fa                	mov    %edi,%edx
  801a9d:	83 c4 1c             	add    $0x1c,%esp
  801aa0:	5b                   	pop    %ebx
  801aa1:	5e                   	pop    %esi
  801aa2:	5f                   	pop    %edi
  801aa3:	5d                   	pop    %ebp
  801aa4:	c3                   	ret    
  801aa5:	8d 76 00             	lea    0x0(%esi),%esi
  801aa8:	31 ff                	xor    %edi,%edi
  801aaa:	31 c0                	xor    %eax,%eax
  801aac:	89 fa                	mov    %edi,%edx
  801aae:	83 c4 1c             	add    $0x1c,%esp
  801ab1:	5b                   	pop    %ebx
  801ab2:	5e                   	pop    %esi
  801ab3:	5f                   	pop    %edi
  801ab4:	5d                   	pop    %ebp
  801ab5:	c3                   	ret    
  801ab6:	66 90                	xchg   %ax,%ax
  801ab8:	89 d8                	mov    %ebx,%eax
  801aba:	f7 f7                	div    %edi
  801abc:	31 ff                	xor    %edi,%edi
  801abe:	89 fa                	mov    %edi,%edx
  801ac0:	83 c4 1c             	add    $0x1c,%esp
  801ac3:	5b                   	pop    %ebx
  801ac4:	5e                   	pop    %esi
  801ac5:	5f                   	pop    %edi
  801ac6:	5d                   	pop    %ebp
  801ac7:	c3                   	ret    
  801ac8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801acd:	89 eb                	mov    %ebp,%ebx
  801acf:	29 fb                	sub    %edi,%ebx
  801ad1:	89 f9                	mov    %edi,%ecx
  801ad3:	d3 e6                	shl    %cl,%esi
  801ad5:	89 c5                	mov    %eax,%ebp
  801ad7:	88 d9                	mov    %bl,%cl
  801ad9:	d3 ed                	shr    %cl,%ebp
  801adb:	89 e9                	mov    %ebp,%ecx
  801add:	09 f1                	or     %esi,%ecx
  801adf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ae3:	89 f9                	mov    %edi,%ecx
  801ae5:	d3 e0                	shl    %cl,%eax
  801ae7:	89 c5                	mov    %eax,%ebp
  801ae9:	89 d6                	mov    %edx,%esi
  801aeb:	88 d9                	mov    %bl,%cl
  801aed:	d3 ee                	shr    %cl,%esi
  801aef:	89 f9                	mov    %edi,%ecx
  801af1:	d3 e2                	shl    %cl,%edx
  801af3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801af7:	88 d9                	mov    %bl,%cl
  801af9:	d3 e8                	shr    %cl,%eax
  801afb:	09 c2                	or     %eax,%edx
  801afd:	89 d0                	mov    %edx,%eax
  801aff:	89 f2                	mov    %esi,%edx
  801b01:	f7 74 24 0c          	divl   0xc(%esp)
  801b05:	89 d6                	mov    %edx,%esi
  801b07:	89 c3                	mov    %eax,%ebx
  801b09:	f7 e5                	mul    %ebp
  801b0b:	39 d6                	cmp    %edx,%esi
  801b0d:	72 19                	jb     801b28 <__udivdi3+0xfc>
  801b0f:	74 0b                	je     801b1c <__udivdi3+0xf0>
  801b11:	89 d8                	mov    %ebx,%eax
  801b13:	31 ff                	xor    %edi,%edi
  801b15:	e9 58 ff ff ff       	jmp    801a72 <__udivdi3+0x46>
  801b1a:	66 90                	xchg   %ax,%ax
  801b1c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b20:	89 f9                	mov    %edi,%ecx
  801b22:	d3 e2                	shl    %cl,%edx
  801b24:	39 c2                	cmp    %eax,%edx
  801b26:	73 e9                	jae    801b11 <__udivdi3+0xe5>
  801b28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b2b:	31 ff                	xor    %edi,%edi
  801b2d:	e9 40 ff ff ff       	jmp    801a72 <__udivdi3+0x46>
  801b32:	66 90                	xchg   %ax,%ax
  801b34:	31 c0                	xor    %eax,%eax
  801b36:	e9 37 ff ff ff       	jmp    801a72 <__udivdi3+0x46>
  801b3b:	90                   	nop

00801b3c <__umoddi3>:
  801b3c:	55                   	push   %ebp
  801b3d:	57                   	push   %edi
  801b3e:	56                   	push   %esi
  801b3f:	53                   	push   %ebx
  801b40:	83 ec 1c             	sub    $0x1c,%esp
  801b43:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b47:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b5b:	89 f3                	mov    %esi,%ebx
  801b5d:	89 fa                	mov    %edi,%edx
  801b5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b63:	89 34 24             	mov    %esi,(%esp)
  801b66:	85 c0                	test   %eax,%eax
  801b68:	75 1a                	jne    801b84 <__umoddi3+0x48>
  801b6a:	39 f7                	cmp    %esi,%edi
  801b6c:	0f 86 a2 00 00 00    	jbe    801c14 <__umoddi3+0xd8>
  801b72:	89 c8                	mov    %ecx,%eax
  801b74:	89 f2                	mov    %esi,%edx
  801b76:	f7 f7                	div    %edi
  801b78:	89 d0                	mov    %edx,%eax
  801b7a:	31 d2                	xor    %edx,%edx
  801b7c:	83 c4 1c             	add    $0x1c,%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5f                   	pop    %edi
  801b82:	5d                   	pop    %ebp
  801b83:	c3                   	ret    
  801b84:	39 f0                	cmp    %esi,%eax
  801b86:	0f 87 ac 00 00 00    	ja     801c38 <__umoddi3+0xfc>
  801b8c:	0f bd e8             	bsr    %eax,%ebp
  801b8f:	83 f5 1f             	xor    $0x1f,%ebp
  801b92:	0f 84 ac 00 00 00    	je     801c44 <__umoddi3+0x108>
  801b98:	bf 20 00 00 00       	mov    $0x20,%edi
  801b9d:	29 ef                	sub    %ebp,%edi
  801b9f:	89 fe                	mov    %edi,%esi
  801ba1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ba5:	89 e9                	mov    %ebp,%ecx
  801ba7:	d3 e0                	shl    %cl,%eax
  801ba9:	89 d7                	mov    %edx,%edi
  801bab:	89 f1                	mov    %esi,%ecx
  801bad:	d3 ef                	shr    %cl,%edi
  801baf:	09 c7                	or     %eax,%edi
  801bb1:	89 e9                	mov    %ebp,%ecx
  801bb3:	d3 e2                	shl    %cl,%edx
  801bb5:	89 14 24             	mov    %edx,(%esp)
  801bb8:	89 d8                	mov    %ebx,%eax
  801bba:	d3 e0                	shl    %cl,%eax
  801bbc:	89 c2                	mov    %eax,%edx
  801bbe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bc2:	d3 e0                	shl    %cl,%eax
  801bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bcc:	89 f1                	mov    %esi,%ecx
  801bce:	d3 e8                	shr    %cl,%eax
  801bd0:	09 d0                	or     %edx,%eax
  801bd2:	d3 eb                	shr    %cl,%ebx
  801bd4:	89 da                	mov    %ebx,%edx
  801bd6:	f7 f7                	div    %edi
  801bd8:	89 d3                	mov    %edx,%ebx
  801bda:	f7 24 24             	mull   (%esp)
  801bdd:	89 c6                	mov    %eax,%esi
  801bdf:	89 d1                	mov    %edx,%ecx
  801be1:	39 d3                	cmp    %edx,%ebx
  801be3:	0f 82 87 00 00 00    	jb     801c70 <__umoddi3+0x134>
  801be9:	0f 84 91 00 00 00    	je     801c80 <__umoddi3+0x144>
  801bef:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bf3:	29 f2                	sub    %esi,%edx
  801bf5:	19 cb                	sbb    %ecx,%ebx
  801bf7:	89 d8                	mov    %ebx,%eax
  801bf9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bfd:	d3 e0                	shl    %cl,%eax
  801bff:	89 e9                	mov    %ebp,%ecx
  801c01:	d3 ea                	shr    %cl,%edx
  801c03:	09 d0                	or     %edx,%eax
  801c05:	89 e9                	mov    %ebp,%ecx
  801c07:	d3 eb                	shr    %cl,%ebx
  801c09:	89 da                	mov    %ebx,%edx
  801c0b:	83 c4 1c             	add    $0x1c,%esp
  801c0e:	5b                   	pop    %ebx
  801c0f:	5e                   	pop    %esi
  801c10:	5f                   	pop    %edi
  801c11:	5d                   	pop    %ebp
  801c12:	c3                   	ret    
  801c13:	90                   	nop
  801c14:	89 fd                	mov    %edi,%ebp
  801c16:	85 ff                	test   %edi,%edi
  801c18:	75 0b                	jne    801c25 <__umoddi3+0xe9>
  801c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1f:	31 d2                	xor    %edx,%edx
  801c21:	f7 f7                	div    %edi
  801c23:	89 c5                	mov    %eax,%ebp
  801c25:	89 f0                	mov    %esi,%eax
  801c27:	31 d2                	xor    %edx,%edx
  801c29:	f7 f5                	div    %ebp
  801c2b:	89 c8                	mov    %ecx,%eax
  801c2d:	f7 f5                	div    %ebp
  801c2f:	89 d0                	mov    %edx,%eax
  801c31:	e9 44 ff ff ff       	jmp    801b7a <__umoddi3+0x3e>
  801c36:	66 90                	xchg   %ax,%ax
  801c38:	89 c8                	mov    %ecx,%eax
  801c3a:	89 f2                	mov    %esi,%edx
  801c3c:	83 c4 1c             	add    $0x1c,%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5f                   	pop    %edi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    
  801c44:	3b 04 24             	cmp    (%esp),%eax
  801c47:	72 06                	jb     801c4f <__umoddi3+0x113>
  801c49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c4d:	77 0f                	ja     801c5e <__umoddi3+0x122>
  801c4f:	89 f2                	mov    %esi,%edx
  801c51:	29 f9                	sub    %edi,%ecx
  801c53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c57:	89 14 24             	mov    %edx,(%esp)
  801c5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c62:	8b 14 24             	mov    (%esp),%edx
  801c65:	83 c4 1c             	add    $0x1c,%esp
  801c68:	5b                   	pop    %ebx
  801c69:	5e                   	pop    %esi
  801c6a:	5f                   	pop    %edi
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    
  801c6d:	8d 76 00             	lea    0x0(%esi),%esi
  801c70:	2b 04 24             	sub    (%esp),%eax
  801c73:	19 fa                	sbb    %edi,%edx
  801c75:	89 d1                	mov    %edx,%ecx
  801c77:	89 c6                	mov    %eax,%esi
  801c79:	e9 71 ff ff ff       	jmp    801bef <__umoddi3+0xb3>
  801c7e:	66 90                	xchg   %ax,%ax
  801c80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c84:	72 ea                	jb     801c70 <__umoddi3+0x134>
  801c86:	89 d9                	mov    %ebx,%ecx
  801c88:	e9 62 ff ff ff       	jmp    801bef <__umoddi3+0xb3>
