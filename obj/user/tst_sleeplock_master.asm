
obj/user/tst_sleeplock_master:     file format elf32-i386


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
  800031:	e8 73 02 00 00       	call   8002a9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create and run slaves, wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 00 00 00    	sub    $0xfc,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800044:	83 ec 08             	sub    $0x8,%esp
  800047:	68 40 21 80 00       	push   $0x802140
  80004c:	6a 0e                	push   $0xe
  80004e:	e8 0a 07 00 00       	call   80075d <cprintf_colored>
  800053:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	68 70 21 80 00       	push   $0x802170
  80005e:	6a 0e                	push   $0xe
  800060:	e8 f8 06 00 00       	call   80075d <cprintf_colored>
  800065:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	68 40 21 80 00       	push   $0x802140
  800070:	6a 0e                	push   $0xe
  800072:	e8 e6 06 00 00       	call   80075d <cprintf_colored>
  800077:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80007a:	e8 6d 1a 00 00       	call   801aec <sys_getenvid>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	8d 45 ce             	lea    -0x32(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 cc 21 80 00       	push   $0x8021cc
  80008e:	e8 76 0d 00 00       	call   800e09 <readline>
  800093:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 45 ce             	lea    -0x32(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 7a 13 00 00       	call   801420 <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//Save number of slaved to be checked later
	char cmd1[64] = "__NumOfSlaves@Set";
  8000ac:	8d 45 88             	lea    -0x78(%ebp),%eax
  8000af:	bb 64 23 80 00       	mov    $0x802364,%ebx
  8000b4:	ba 12 00 00 00       	mov    $0x12,%edx
  8000b9:	89 c7                	mov    %eax,%edi
  8000bb:	89 de                	mov    %ebx,%esi
  8000bd:	89 d1                	mov    %edx,%ecx
  8000bf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000c1:	8d 55 9a             	lea    -0x66(%ebp),%edx
  8000c4:	b9 2e 00 00 00       	mov    $0x2e,%ecx
  8000c9:	b0 00                	mov    $0x0,%al
  8000cb:	89 d7                	mov    %edx,%edi
  8000cd:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd1, (uint32)(&numOfSlaves));
  8000cf:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	50                   	push   %eax
  8000d6:	8d 45 88             	lea    -0x78(%ebp),%eax
  8000d9:	50                   	push   %eax
  8000da:	e8 5c 1c 00 00       	call   801d3b <sys_utilities>
  8000df:	83 c4 10             	add    $0x10,%esp

	rsttst();
  8000e2:	e8 fc 1a 00 00       	call   801be3 <rsttst>

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000ee:	eb 6a                	jmp    80015a <_main+0x122>
	{
		id = sys_create_env("tstSleepLockSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f5:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8000fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800100:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800106:	89 c1                	mov    %eax,%ecx
  800108:	a1 20 30 80 00       	mov    0x803020,%eax
  80010d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800113:	52                   	push   %edx
  800114:	51                   	push   %ecx
  800115:	50                   	push   %eax
  800116:	68 f1 21 80 00       	push   $0x8021f1
  80011b:	e8 77 19 00 00       	call   801a97 <sys_create_env>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  800126:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  80012a:	75 1d                	jne    800149 <_main+0x111>
		{
			cprintf_colored(TEXT_TESTERR_CLR,"\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800132:	68 04 22 80 00       	push   $0x802204
  800137:	6a 0c                	push   $0xc
  800139:	e8 1f 06 00 00       	call   80075d <cprintf_colored>
  80013e:	83 c4 10             	add    $0x10,%esp
			numOfSlaves = i;
  800141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800144:	89 45 c8             	mov    %eax,-0x38(%ebp)
			break;
  800147:	eb 19                	jmp    800162 <_main+0x12a>
		}
		sys_run_env(id);
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	ff 75 d8             	pushl  -0x28(%ebp)
  80014f:	e8 61 19 00 00       	call   801ab5 <sys_run_env>
  800154:	83 c4 10             	add    $0x10,%esp

	rsttst();

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  800157:	ff 45 e4             	incl   -0x1c(%ebp)
  80015a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80015d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800160:	7c 8e                	jl     8000f0 <_main+0xb8>
		}
		sys_run_env(id);
	}

	//Wait until all slaves, except the one inside C.S., are blocked
	int numOfBlockedProcesses = 0;
  800162:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
	char cmd2[64] = "__GetLockQueueSize__";
  800169:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  80016f:	bb a4 23 80 00       	mov    $0x8023a4,%ebx
  800174:	ba 15 00 00 00       	mov    $0x15,%edx
  800179:	89 c7                	mov    %eax,%edi
  80017b:	89 de                	mov    %ebx,%esi
  80017d:	89 d1                	mov    %edx,%ecx
  80017f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800181:	8d 95 59 ff ff ff    	lea    -0xa7(%ebp),%edx
  800187:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  80018c:	b0 00                	mov    $0x0,%al
  80018e:	89 d7                	mov    %edx,%edi
  800190:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
  800192:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	50                   	push   %eax
  800199:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  80019f:	50                   	push   %eax
  8001a0:	e8 96 1b 00 00       	call   801d3b <sys_utilities>
  8001a5:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  8001a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (numOfBlockedProcesses != numOfSlaves-1)
  8001af:	eb 77                	jmp    800228 <_main+0x1f0>
	{
		env_sleep(5000);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 88 13 00 00       	push   $0x1388
  8001b9:	e8 0a 1c 00 00       	call   801dc8 <env_sleep>
  8001be:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  8001c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8001c7:	75 1d                	jne    8001e6 <_main+0x1ae>
		{
			panic("%~test sleeplock failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves-1, numOfBlockedProcesses);
  8001c9:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8001cc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8001cf:	4a                   	dec    %edx
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	50                   	push   %eax
  8001d4:	52                   	push   %edx
  8001d5:	68 5c 22 80 00       	push   $0x80225c
  8001da:	6a 2f                	push   $0x2f
  8001dc:	68 b6 22 80 00       	push   $0x8022b6
  8001e1:	e8 7c 02 00 00       	call   800462 <_panic>
		}
		char cmd3[64] = "__GetLockQueueSize__";
  8001e6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001ec:	bb a4 23 80 00       	mov    $0x8023a4,%ebx
  8001f1:	ba 15 00 00 00       	mov    $0x15,%edx
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	89 de                	mov    %ebx,%esi
  8001fa:	89 d1                	mov    %edx,%ecx
  8001fc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001fe:	8d 95 19 ff ff ff    	lea    -0xe7(%ebp),%edx
  800204:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  800209:	b0 00                	mov    $0x0,%al
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd3, (uint32)(&numOfBlockedProcesses));
  80020f:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800212:	83 ec 08             	sub    $0x8,%esp
  800215:	50                   	push   %eax
  800216:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  80021c:	50                   	push   %eax
  80021d:	e8 19 1b 00 00       	call   801d3b <sys_utilities>
  800222:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  800225:	ff 45 e0             	incl   -0x20(%ebp)
	//Wait until all slaves, except the one inside C.S., are blocked
	int numOfBlockedProcesses = 0;
	char cmd2[64] = "__GetLockQueueSize__";
	sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
	int cnt = 0;
	while (numOfBlockedProcesses != numOfSlaves-1)
  800228:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80022b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80022e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800231:	39 c2                	cmp    %eax,%edx
  800233:	0f 85 78 ff ff ff    	jne    8001b1 <_main+0x179>
		cnt++ ;
	}
	//cprintf("\numOfBlockedProcesses = %d\n", numOfBlockedProcesses);

	//signal the slave inside the critical section to leave it
	inctst();
  800239:	e8 05 1a 00 00       	call   801c43 <inctst>

	//Wait until all slave finished
	cnt = 0;
  80023e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	while (gettst() != numOfSlaves +1/*since master already increment it by 1*/)
  800245:	eb 3a                	jmp    800281 <_main+0x249>
	{
		env_sleep(15000);
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	68 98 3a 00 00       	push   $0x3a98
  80024f:	e8 74 1b 00 00       	call   801dc8 <env_sleep>
  800254:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800257:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80025a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  80025d:	75 1f                	jne    80027e <_main+0x246>
		{
			panic("%~test sleeplock failed! not all processes finished. Expected %d, Actual %d", numOfSlaves +1, gettst());
  80025f:	e8 f9 19 00 00       	call   801c5d <gettst>
  800264:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800267:	42                   	inc    %edx
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	50                   	push   %eax
  80026c:	52                   	push   %edx
  80026d:	68 d4 22 80 00       	push   $0x8022d4
  800272:	6a 41                	push   $0x41
  800274:	68 b6 22 80 00       	push   $0x8022b6
  800279:	e8 e4 01 00 00       	call   800462 <_panic>
		}
		cnt++ ;
  80027e:	ff 45 e0             	incl   -0x20(%ebp)
	//signal the slave inside the critical section to leave it
	inctst();

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves +1/*since master already increment it by 1*/)
  800281:	e8 d7 19 00 00       	call   801c5d <gettst>
  800286:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800289:	42                   	inc    %edx
  80028a:	39 d0                	cmp    %edx,%eax
  80028c:	75 b9                	jne    800247 <_main+0x20f>
			panic("%~test sleeplock failed! not all processes finished. Expected %d, Actual %d", numOfSlaves +1, gettst());
		}
		cnt++ ;
	}

	cprintf_colored(TEXT_light_green, "%~\n\nCongratulations!! Test of Sleep Lock completed successfully!!\n\n");
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	68 20 23 80 00       	push   $0x802320
  800296:	6a 0a                	push   $0xa
  800298:	e8 c0 04 00 00       	call   80075d <cprintf_colored>
  80029d:	83 c4 10             	add    $0x10,%esp
}
  8002a0:	90                   	nop
  8002a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a4:	5b                   	pop    %ebx
  8002a5:	5e                   	pop    %esi
  8002a6:	5f                   	pop    %edi
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002b2:	e8 4e 18 00 00       	call   801b05 <sys_getenvindex>
  8002b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002bd:	89 d0                	mov    %edx,%eax
  8002bf:	c1 e0 02             	shl    $0x2,%eax
  8002c2:	01 d0                	add    %edx,%eax
  8002c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cb:	01 d0                	add    %edx,%eax
  8002cd:	89 c2                	mov    %eax,%edx
  8002cf:	c1 e2 04             	shl    $0x4,%edx
  8002d2:	29 c2                	sub    %eax,%edx
  8002d4:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002db:	89 c2                	mov    %eax,%edx
  8002dd:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002e3:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ed:	8a 40 20             	mov    0x20(%eax),%al
  8002f0:	84 c0                	test   %al,%al
  8002f2:	74 0d                	je     800301 <libmain+0x58>
		binaryname = myEnv->prog_name;
  8002f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f9:	83 c0 20             	add    $0x20,%eax
  8002fc:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800301:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800305:	7e 0a                	jle    800311 <libmain+0x68>
		binaryname = argv[0];
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	8b 00                	mov    (%eax),%eax
  80030c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800311:	83 ec 08             	sub    $0x8,%esp
  800314:	ff 75 0c             	pushl  0xc(%ebp)
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 19 fd ff ff       	call   800038 <_main>
  80031f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800322:	a1 00 30 80 00       	mov    0x803000,%eax
  800327:	85 c0                	test   %eax,%eax
  800329:	0f 84 01 01 00 00    	je     800430 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80032f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800335:	bb dc 24 80 00       	mov    $0x8024dc,%ebx
  80033a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80033f:	89 c7                	mov    %eax,%edi
  800341:	89 de                	mov    %ebx,%esi
  800343:	89 d1                	mov    %edx,%ecx
  800345:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800347:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80034a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80034f:	b0 00                	mov    $0x0,%al
  800351:	89 d7                	mov    %edx,%edi
  800353:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800355:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80035c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	50                   	push   %eax
  800363:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800369:	50                   	push   %eax
  80036a:	e8 cc 19 00 00       	call   801d3b <sys_utilities>
  80036f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800372:	e8 15 15 00 00       	call   80188c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800377:	83 ec 0c             	sub    $0xc,%esp
  80037a:	68 fc 23 80 00       	push   $0x8023fc
  80037f:	e8 ac 03 00 00       	call   800730 <cprintf>
  800384:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800387:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038a:	85 c0                	test   %eax,%eax
  80038c:	74 18                	je     8003a6 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80038e:	e8 c6 19 00 00       	call   801d59 <sys_get_optimal_num_faults>
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	50                   	push   %eax
  800397:	68 24 24 80 00       	push   $0x802424
  80039c:	e8 8f 03 00 00       	call   800730 <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
  8003a4:	eb 59                	jmp    8003ff <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ab:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b6:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	52                   	push   %edx
  8003c0:	50                   	push   %eax
  8003c1:	68 48 24 80 00       	push   $0x802448
  8003c6:	e8 65 03 00 00       	call   800730 <cprintf>
  8003cb:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d3:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8003d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003de:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8003e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e9:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8003ef:	51                   	push   %ecx
  8003f0:	52                   	push   %edx
  8003f1:	50                   	push   %eax
  8003f2:	68 70 24 80 00       	push   $0x802470
  8003f7:	e8 34 03 00 00       	call   800730 <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800404:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80040a:	83 ec 08             	sub    $0x8,%esp
  80040d:	50                   	push   %eax
  80040e:	68 c8 24 80 00       	push   $0x8024c8
  800413:	e8 18 03 00 00       	call   800730 <cprintf>
  800418:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80041b:	83 ec 0c             	sub    $0xc,%esp
  80041e:	68 fc 23 80 00       	push   $0x8023fc
  800423:	e8 08 03 00 00       	call   800730 <cprintf>
  800428:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80042b:	e8 76 14 00 00       	call   8018a6 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800430:	e8 1f 00 00 00       	call   800454 <exit>
}
  800435:	90                   	nop
  800436:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800439:	5b                   	pop    %ebx
  80043a:	5e                   	pop    %esi
  80043b:	5f                   	pop    %edi
  80043c:	5d                   	pop    %ebp
  80043d:	c3                   	ret    

0080043e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800444:	83 ec 0c             	sub    $0xc,%esp
  800447:	6a 00                	push   $0x0
  800449:	e8 83 16 00 00       	call   801ad1 <sys_destroy_env>
  80044e:	83 c4 10             	add    $0x10,%esp
}
  800451:	90                   	nop
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <exit>:

void
exit(void)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80045a:	e8 d8 16 00 00       	call   801b37 <sys_exit_env>
}
  80045f:	90                   	nop
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800468:	8d 45 10             	lea    0x10(%ebp),%eax
  80046b:	83 c0 04             	add    $0x4,%eax
  80046e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800471:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800476:	85 c0                	test   %eax,%eax
  800478:	74 16                	je     800490 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80047a:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	50                   	push   %eax
  800483:	68 40 25 80 00       	push   $0x802540
  800488:	e8 a3 02 00 00       	call   800730 <cprintf>
  80048d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800490:	a1 04 30 80 00       	mov    0x803004,%eax
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	ff 75 0c             	pushl  0xc(%ebp)
  80049b:	ff 75 08             	pushl  0x8(%ebp)
  80049e:	50                   	push   %eax
  80049f:	68 48 25 80 00       	push   $0x802548
  8004a4:	6a 74                	push   $0x74
  8004a6:	e8 b2 02 00 00       	call   80075d <cprintf_colored>
  8004ab:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b7:	50                   	push   %eax
  8004b8:	e8 04 02 00 00       	call   8006c1 <vcprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	6a 00                	push   $0x0
  8004c5:	68 70 25 80 00       	push   $0x802570
  8004ca:	e8 f2 01 00 00       	call   8006c1 <vcprintf>
  8004cf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004d2:	e8 7d ff ff ff       	call   800454 <exit>

	// should not return here
	while (1) ;
  8004d7:	eb fe                	jmp    8004d7 <_panic+0x75>

008004d9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004df:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ed:	39 c2                	cmp    %eax,%edx
  8004ef:	74 14                	je     800505 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	68 74 25 80 00       	push   $0x802574
  8004f9:	6a 26                	push   $0x26
  8004fb:	68 c0 25 80 00       	push   $0x8025c0
  800500:	e8 5d ff ff ff       	call   800462 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800505:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80050c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800513:	e9 c5 00 00 00       	jmp    8005dd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 d0                	add    %edx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	85 c0                	test   %eax,%eax
  80052b:	75 08                	jne    800535 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80052d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800530:	e9 a5 00 00 00       	jmp    8005da <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800535:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800543:	eb 69                	jmp    8005ae <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800545:	a1 20 30 80 00       	mov    0x803020,%eax
  80054a:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800550:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800553:	89 d0                	mov    %edx,%eax
  800555:	01 c0                	add    %eax,%eax
  800557:	01 d0                	add    %edx,%eax
  800559:	c1 e0 03             	shl    $0x3,%eax
  80055c:	01 c8                	add    %ecx,%eax
  80055e:	8a 40 04             	mov    0x4(%eax),%al
  800561:	84 c0                	test   %al,%al
  800563:	75 46                	jne    8005ab <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800565:	a1 20 30 80 00       	mov    0x803020,%eax
  80056a:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800570:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800573:	89 d0                	mov    %edx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	c1 e0 03             	shl    $0x3,%eax
  80057c:	01 c8                	add    %ecx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800583:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800586:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80058b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80058d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800590:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	01 c8                	add    %ecx,%eax
  80059c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80059e:	39 c2                	cmp    %eax,%edx
  8005a0:	75 09                	jne    8005ab <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005a9:	eb 15                	jmp    8005c0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	ff 45 e8             	incl   -0x18(%ebp)
  8005ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005bc:	39 c2                	cmp    %eax,%edx
  8005be:	77 85                	ja     800545 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005c4:	75 14                	jne    8005da <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005c6:	83 ec 04             	sub    $0x4,%esp
  8005c9:	68 cc 25 80 00       	push   $0x8025cc
  8005ce:	6a 3a                	push   $0x3a
  8005d0:	68 c0 25 80 00       	push   $0x8025c0
  8005d5:	e8 88 fe ff ff       	call   800462 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005da:	ff 45 f0             	incl   -0x10(%ebp)
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005e3:	0f 8c 2f ff ff ff    	jl     800518 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005f7:	eb 26                	jmp    80061f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fe:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800604:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800607:	89 d0                	mov    %edx,%eax
  800609:	01 c0                	add    %eax,%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	c1 e0 03             	shl    $0x3,%eax
  800610:	01 c8                	add    %ecx,%eax
  800612:	8a 40 04             	mov    0x4(%eax),%al
  800615:	3c 01                	cmp    $0x1,%al
  800617:	75 03                	jne    80061c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800619:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	ff 45 e0             	incl   -0x20(%ebp)
  80061f:	a1 20 30 80 00       	mov    0x803020,%eax
  800624:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80062a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062d:	39 c2                	cmp    %eax,%edx
  80062f:	77 c8                	ja     8005f9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800634:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800637:	74 14                	je     80064d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800639:	83 ec 04             	sub    $0x4,%esp
  80063c:	68 20 26 80 00       	push   $0x802620
  800641:	6a 44                	push   $0x44
  800643:	68 c0 25 80 00       	push   $0x8025c0
  800648:	e8 15 fe ff ff       	call   800462 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80064d:	90                   	nop
  80064e:	c9                   	leave  
  80064f:	c3                   	ret    

00800650 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	53                   	push   %ebx
  800654:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	8d 48 01             	lea    0x1(%eax),%ecx
  80065f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800662:	89 0a                	mov    %ecx,(%edx)
  800664:	8b 55 08             	mov    0x8(%ebp),%edx
  800667:	88 d1                	mov    %dl,%cl
  800669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800670:	8b 45 0c             	mov    0xc(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	3d ff 00 00 00       	cmp    $0xff,%eax
  80067a:	75 30                	jne    8006ac <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80067c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800682:	a0 44 30 80 00       	mov    0x803044,%al
  800687:	0f b6 c0             	movzbl %al,%eax
  80068a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80068d:	8b 09                	mov    (%ecx),%ecx
  80068f:	89 cb                	mov    %ecx,%ebx
  800691:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800694:	83 c1 08             	add    $0x8,%ecx
  800697:	52                   	push   %edx
  800698:	50                   	push   %eax
  800699:	53                   	push   %ebx
  80069a:	51                   	push   %ecx
  80069b:	e8 a8 11 00 00       	call   801848 <sys_cputs>
  8006a0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	8b 40 04             	mov    0x4(%eax),%eax
  8006b2:	8d 50 01             	lea    0x1(%eax),%edx
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006bb:	90                   	nop
  8006bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d1:	00 00 00 
	b.cnt = 0;
  8006d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006db:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006de:	ff 75 0c             	pushl  0xc(%ebp)
  8006e1:	ff 75 08             	pushl  0x8(%ebp)
  8006e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ea:	50                   	push   %eax
  8006eb:	68 50 06 80 00       	push   $0x800650
  8006f0:	e8 5a 02 00 00       	call   80094f <vprintfmt>
  8006f5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006f8:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006fe:	a0 44 30 80 00       	mov    0x803044,%al
  800703:	0f b6 c0             	movzbl %al,%eax
  800706:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80070c:	52                   	push   %edx
  80070d:	50                   	push   %eax
  80070e:	51                   	push   %ecx
  80070f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800715:	83 c0 08             	add    $0x8,%eax
  800718:	50                   	push   %eax
  800719:	e8 2a 11 00 00       	call   801848 <sys_cputs>
  80071e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800721:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800728:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800736:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80073d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800740:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 f4             	pushl  -0xc(%ebp)
  80074c:	50                   	push   %eax
  80074d:	e8 6f ff ff ff       	call   8006c1 <vcprintf>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800758:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80075b:	c9                   	leave  
  80075c:	c3                   	ret    

0080075d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
  800760:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800763:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	c1 e0 08             	shl    $0x8,%eax
  800770:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800775:	8d 45 0c             	lea    0xc(%ebp),%eax
  800778:	83 c0 04             	add    $0x4,%eax
  80077b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 f4             	pushl  -0xc(%ebp)
  800787:	50                   	push   %eax
  800788:	e8 34 ff ff ff       	call   8006c1 <vcprintf>
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800793:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80079a:	07 00 00 

	return cnt;
  80079d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    

008007a2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007a8:	e8 df 10 00 00       	call   80188c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007ad:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bc:	50                   	push   %eax
  8007bd:	e8 ff fe ff ff       	call   8006c1 <vcprintf>
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007c8:	e8 d9 10 00 00       	call   8018a6 <sys_unlock_cons>
	return cnt;
  8007cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    

008007d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	53                   	push   %ebx
  8007d6:	83 ec 14             	sub    $0x14,%esp
  8007d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f0:	77 55                	ja     800847 <printnum+0x75>
  8007f2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f5:	72 05                	jb     8007fc <printnum+0x2a>
  8007f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007fa:	77 4b                	ja     800847 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007fc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007ff:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800802:	8b 45 18             	mov    0x18(%ebp),%eax
  800805:	ba 00 00 00 00       	mov    $0x0,%edx
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	ff 75 f4             	pushl  -0xc(%ebp)
  80080f:	ff 75 f0             	pushl  -0x10(%ebp)
  800812:	e8 ad 16 00 00       	call   801ec4 <__udivdi3>
  800817:	83 c4 10             	add    $0x10,%esp
  80081a:	83 ec 04             	sub    $0x4,%esp
  80081d:	ff 75 20             	pushl  0x20(%ebp)
  800820:	53                   	push   %ebx
  800821:	ff 75 18             	pushl  0x18(%ebp)
  800824:	52                   	push   %edx
  800825:	50                   	push   %eax
  800826:	ff 75 0c             	pushl  0xc(%ebp)
  800829:	ff 75 08             	pushl  0x8(%ebp)
  80082c:	e8 a1 ff ff ff       	call   8007d2 <printnum>
  800831:	83 c4 20             	add    $0x20,%esp
  800834:	eb 1a                	jmp    800850 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	ff 75 20             	pushl  0x20(%ebp)
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800847:	ff 4d 1c             	decl   0x1c(%ebp)
  80084a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80084e:	7f e6                	jg     800836 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800850:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800853:	bb 00 00 00 00       	mov    $0x0,%ebx
  800858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085e:	53                   	push   %ebx
  80085f:	51                   	push   %ecx
  800860:	52                   	push   %edx
  800861:	50                   	push   %eax
  800862:	e8 6d 17 00 00       	call   801fd4 <__umoddi3>
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	05 94 28 80 00       	add    $0x802894,%eax
  80086f:	8a 00                	mov    (%eax),%al
  800871:	0f be c0             	movsbl %al,%eax
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	50                   	push   %eax
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	ff d0                	call   *%eax
  800880:	83 c4 10             	add    $0x10,%esp
}
  800883:	90                   	nop
  800884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800887:	c9                   	leave  
  800888:	c3                   	ret    

00800889 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80088c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800890:	7e 1c                	jle    8008ae <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	8d 50 08             	lea    0x8(%eax),%edx
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	89 10                	mov    %edx,(%eax)
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	83 e8 08             	sub    $0x8,%eax
  8008a7:	8b 50 04             	mov    0x4(%eax),%edx
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	eb 40                	jmp    8008ee <getuint+0x65>
	else if (lflag)
  8008ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b2:	74 1e                	je     8008d2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	8d 50 04             	lea    0x4(%eax),%edx
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	89 10                	mov    %edx,(%eax)
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	83 e8 04             	sub    $0x4,%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d0:	eb 1c                	jmp    8008ee <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	8d 50 04             	lea    0x4(%eax),%edx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	89 10                	mov    %edx,(%eax)
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	83 e8 04             	sub    $0x4,%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f7:	7e 1c                	jle    800915 <getint+0x25>
		return va_arg(*ap, long long);
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	8d 50 08             	lea    0x8(%eax),%edx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	89 10                	mov    %edx,(%eax)
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	83 e8 08             	sub    $0x8,%eax
  80090e:	8b 50 04             	mov    0x4(%eax),%edx
  800911:	8b 00                	mov    (%eax),%eax
  800913:	eb 38                	jmp    80094d <getint+0x5d>
	else if (lflag)
  800915:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800919:	74 1a                	je     800935 <getint+0x45>
		return va_arg(*ap, long);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 04             	lea    0x4(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	99                   	cltd   
  800933:	eb 18                	jmp    80094d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	8d 50 04             	lea    0x4(%eax),%edx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	89 10                	mov    %edx,(%eax)
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	83 e8 04             	sub    $0x4,%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	99                   	cltd   
}
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
  800954:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800957:	eb 17                	jmp    800970 <vprintfmt+0x21>
			if (ch == '\0')
  800959:	85 db                	test   %ebx,%ebx
  80095b:	0f 84 c1 03 00 00    	je     800d22 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	53                   	push   %ebx
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	ff d0                	call   *%eax
  80096d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800970:	8b 45 10             	mov    0x10(%ebp),%eax
  800973:	8d 50 01             	lea    0x1(%eax),%edx
  800976:	89 55 10             	mov    %edx,0x10(%ebp)
  800979:	8a 00                	mov    (%eax),%al
  80097b:	0f b6 d8             	movzbl %al,%ebx
  80097e:	83 fb 25             	cmp    $0x25,%ebx
  800981:	75 d6                	jne    800959 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800983:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800987:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80098e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800995:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80099c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a6:	8d 50 01             	lea    0x1(%eax),%edx
  8009a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ac:	8a 00                	mov    (%eax),%al
  8009ae:	0f b6 d8             	movzbl %al,%ebx
  8009b1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009b4:	83 f8 5b             	cmp    $0x5b,%eax
  8009b7:	0f 87 3d 03 00 00    	ja     800cfa <vprintfmt+0x3ab>
  8009bd:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  8009c4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ca:	eb d7                	jmp    8009a3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009cc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009d0:	eb d1                	jmp    8009a3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	c1 e0 02             	shl    $0x2,%eax
  8009e1:	01 d0                	add    %edx,%eax
  8009e3:	01 c0                	add    %eax,%eax
  8009e5:	01 d8                	add    %ebx,%eax
  8009e7:	83 e8 30             	sub    $0x30,%eax
  8009ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f0:	8a 00                	mov    (%eax),%al
  8009f2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f5:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f8:	7e 3e                	jle    800a38 <vprintfmt+0xe9>
  8009fa:	83 fb 39             	cmp    $0x39,%ebx
  8009fd:	7f 39                	jg     800a38 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ff:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a02:	eb d5                	jmp    8009d9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	83 c0 04             	add    $0x4,%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	83 e8 04             	sub    $0x4,%eax
  800a13:	8b 00                	mov    (%eax),%eax
  800a15:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a18:	eb 1f                	jmp    800a39 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1e:	79 83                	jns    8009a3 <vprintfmt+0x54>
				width = 0;
  800a20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a27:	e9 77 ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a2c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a33:	e9 6b ff ff ff       	jmp    8009a3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a38:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3d:	0f 89 60 ff ff ff    	jns    8009a3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a49:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a50:	e9 4e ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a55:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a58:	e9 46 ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	83 c0 04             	add    $0x4,%eax
  800a63:	89 45 14             	mov    %eax,0x14(%ebp)
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	83 e8 04             	sub    $0x4,%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	50                   	push   %eax
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	ff d0                	call   *%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
			break;
  800a7d:	e9 9b 02 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 c0 04             	add    $0x4,%eax
  800a88:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	83 e8 04             	sub    $0x4,%eax
  800a91:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a93:	85 db                	test   %ebx,%ebx
  800a95:	79 02                	jns    800a99 <vprintfmt+0x14a>
				err = -err;
  800a97:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a99:	83 fb 64             	cmp    $0x64,%ebx
  800a9c:	7f 0b                	jg     800aa9 <vprintfmt+0x15a>
  800a9e:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  800aa5:	85 f6                	test   %esi,%esi
  800aa7:	75 19                	jne    800ac2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa9:	53                   	push   %ebx
  800aaa:	68 a5 28 80 00       	push   $0x8028a5
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	ff 75 08             	pushl  0x8(%ebp)
  800ab5:	e8 70 02 00 00       	call   800d2a <printfmt>
  800aba:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800abd:	e9 5b 02 00 00       	jmp    800d1d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac2:	56                   	push   %esi
  800ac3:	68 ae 28 80 00       	push   $0x8028ae
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 57 02 00 00       	call   800d2a <printfmt>
  800ad3:	83 c4 10             	add    $0x10,%esp
			break;
  800ad6:	e9 42 02 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800adb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ade:	83 c0 04             	add    $0x4,%eax
  800ae1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae7:	83 e8 04             	sub    $0x4,%eax
  800aea:	8b 30                	mov    (%eax),%esi
  800aec:	85 f6                	test   %esi,%esi
  800aee:	75 05                	jne    800af5 <vprintfmt+0x1a6>
				p = "(null)";
  800af0:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  800af5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af9:	7e 6d                	jle    800b68 <vprintfmt+0x219>
  800afb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aff:	74 67                	je     800b68 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	50                   	push   %eax
  800b08:	56                   	push   %esi
  800b09:	e8 26 05 00 00       	call   801034 <strnlen>
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b14:	eb 16                	jmp    800b2c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b16:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	ff 75 0c             	pushl  0xc(%ebp)
  800b20:	50                   	push   %eax
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	ff d0                	call   *%eax
  800b26:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b29:	ff 4d e4             	decl   -0x1c(%ebp)
  800b2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b30:	7f e4                	jg     800b16 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b32:	eb 34                	jmp    800b68 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b34:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b38:	74 1c                	je     800b56 <vprintfmt+0x207>
  800b3a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b3d:	7e 05                	jle    800b44 <vprintfmt+0x1f5>
  800b3f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b42:	7e 12                	jle    800b56 <vprintfmt+0x207>
					putch('?', putdat);
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	6a 3f                	push   $0x3f
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	ff d0                	call   *%eax
  800b51:	83 c4 10             	add    $0x10,%esp
  800b54:	eb 0f                	jmp    800b65 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b56:	83 ec 08             	sub    $0x8,%esp
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	53                   	push   %ebx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b65:	ff 4d e4             	decl   -0x1c(%ebp)
  800b68:	89 f0                	mov    %esi,%eax
  800b6a:	8d 70 01             	lea    0x1(%eax),%esi
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	0f be d8             	movsbl %al,%ebx
  800b72:	85 db                	test   %ebx,%ebx
  800b74:	74 24                	je     800b9a <vprintfmt+0x24b>
  800b76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7a:	78 b8                	js     800b34 <vprintfmt+0x1e5>
  800b7c:	ff 4d e0             	decl   -0x20(%ebp)
  800b7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b83:	79 af                	jns    800b34 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b85:	eb 13                	jmp    800b9a <vprintfmt+0x24b>
				putch(' ', putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	6a 20                	push   $0x20
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	ff d0                	call   *%eax
  800b94:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b97:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9e:	7f e7                	jg     800b87 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ba0:	e9 78 01 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bab:	8d 45 14             	lea    0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	e8 3c fd ff ff       	call   8008f0 <getint>
  800bb4:	83 c4 10             	add    $0x10,%esp
  800bb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	85 d2                	test   %edx,%edx
  800bc5:	79 23                	jns    800bea <vprintfmt+0x29b>
				putch('-', putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	6a 2d                	push   $0x2d
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	ff d0                	call   *%eax
  800bd4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdd:	f7 d8                	neg    %eax
  800bdf:	83 d2 00             	adc    $0x0,%edx
  800be2:	f7 da                	neg    %edx
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf1:	e9 bc 00 00 00       	jmp    800cb2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bfc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bff:	50                   	push   %eax
  800c00:	e8 84 fc ff ff       	call   800889 <getuint>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c0e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c15:	e9 98 00 00 00       	jmp    800cb2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	6a 58                	push   $0x58
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	ff d0                	call   *%eax
  800c27:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	6a 58                	push   $0x58
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	ff d0                	call   *%eax
  800c37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	6a 58                	push   $0x58
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
			break;
  800c4a:	e9 ce 00 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 30                	push   $0x30
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	6a 78                	push   $0x78
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c72:	83 c0 04             	add    $0x4,%eax
  800c75:	89 45 14             	mov    %eax,0x14(%ebp)
  800c78:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7b:	83 e8 04             	sub    $0x4,%eax
  800c7e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c8a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c91:	eb 1f                	jmp    800cb2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 e8             	pushl  -0x18(%ebp)
  800c99:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 e7 fb ff ff       	call   800889 <getuint>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb9:	83 ec 04             	sub    $0x4,%esp
  800cbc:	52                   	push   %edx
  800cbd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc4:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	ff 75 08             	pushl  0x8(%ebp)
  800ccd:	e8 00 fb ff ff       	call   8007d2 <printnum>
  800cd2:	83 c4 20             	add    $0x20,%esp
			break;
  800cd5:	eb 46                	jmp    800d1d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd7:	83 ec 08             	sub    $0x8,%esp
  800cda:	ff 75 0c             	pushl  0xc(%ebp)
  800cdd:	53                   	push   %ebx
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	ff d0                	call   *%eax
  800ce3:	83 c4 10             	add    $0x10,%esp
			break;
  800ce6:	eb 35                	jmp    800d1d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ce8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cef:	eb 2c                	jmp    800d1d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cf1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cf8:	eb 23                	jmp    800d1d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfa:	83 ec 08             	sub    $0x8,%esp
  800cfd:	ff 75 0c             	pushl  0xc(%ebp)
  800d00:	6a 25                	push   $0x25
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	ff d0                	call   *%eax
  800d07:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0a:	ff 4d 10             	decl   0x10(%ebp)
  800d0d:	eb 03                	jmp    800d12 <vprintfmt+0x3c3>
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	48                   	dec    %eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	3c 25                	cmp    $0x25,%al
  800d1a:	75 f3                	jne    800d0f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d1c:	90                   	nop
		}
	}
  800d1d:	e9 35 fc ff ff       	jmp    800957 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d22:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d30:	8d 45 10             	lea    0x10(%ebp),%eax
  800d33:	83 c0 04             	add    $0x4,%eax
  800d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3f:	50                   	push   %eax
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	ff 75 08             	pushl  0x8(%ebp)
  800d46:	e8 04 fc ff ff       	call   80094f <vprintfmt>
  800d4b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d4e:	90                   	nop
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	8b 40 08             	mov    0x8(%eax),%eax
  800d5a:	8d 50 01             	lea    0x1(%eax),%edx
  800d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d60:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8b 10                	mov    (%eax),%edx
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8b 40 04             	mov    0x4(%eax),%eax
  800d6e:	39 c2                	cmp    %eax,%edx
  800d70:	73 12                	jae    800d84 <sprintputch+0x33>
		*b->buf++ = ch;
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7d:	89 0a                	mov    %ecx,(%edx)
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	88 10                	mov    %dl,(%eax)
}
  800d84:	90                   	nop
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	01 d0                	add    %edx,%eax
  800d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dac:	74 06                	je     800db4 <vsnprintf+0x2d>
  800dae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db2:	7f 07                	jg     800dbb <vsnprintf+0x34>
		return -E_INVAL;
  800db4:	b8 03 00 00 00       	mov    $0x3,%eax
  800db9:	eb 20                	jmp    800ddb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbb:	ff 75 14             	pushl  0x14(%ebp)
  800dbe:	ff 75 10             	pushl  0x10(%ebp)
  800dc1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc4:	50                   	push   %eax
  800dc5:	68 51 0d 80 00       	push   $0x800d51
  800dca:	e8 80 fb ff ff       	call   80094f <vprintfmt>
  800dcf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de3:	8d 45 10             	lea    0x10(%ebp),%eax
  800de6:	83 c0 04             	add    $0x4,%eax
  800de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	ff 75 f4             	pushl  -0xc(%ebp)
  800df2:	50                   	push   %eax
  800df3:	ff 75 0c             	pushl  0xc(%ebp)
  800df6:	ff 75 08             	pushl  0x8(%ebp)
  800df9:	e8 89 ff ff ff       	call   800d87 <vsnprintf>
  800dfe:	83 c4 10             	add    $0x10,%esp
  800e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e07:	c9                   	leave  
  800e08:	c3                   	ret    

00800e09 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e13:	74 13                	je     800e28 <readline+0x1f>
		cprintf("%s", prompt);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 08             	pushl  0x8(%ebp)
  800e1b:	68 28 2a 80 00       	push   $0x802a28
  800e20:	e8 0b f9 ff ff       	call   800730 <cprintf>
  800e25:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	6a 00                	push   $0x0
  800e34:	e8 7f 10 00 00       	call   801eb8 <iscons>
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e3f:	e8 61 10 00 00       	call   801ea5 <getchar>
  800e44:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e47:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e4b:	79 22                	jns    800e6f <readline+0x66>
			if (c != -E_EOF)
  800e4d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e51:	0f 84 ad 00 00 00    	je     800f04 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 ec             	pushl  -0x14(%ebp)
  800e5d:	68 2b 2a 80 00       	push   $0x802a2b
  800e62:	e8 c9 f8 ff ff       	call   800730 <cprintf>
  800e67:	83 c4 10             	add    $0x10,%esp
			break;
  800e6a:	e9 95 00 00 00       	jmp    800f04 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e6f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e73:	7e 34                	jle    800ea9 <readline+0xa0>
  800e75:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800e7c:	7f 2b                	jg     800ea9 <readline+0xa0>
			if (echoing)
  800e7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e82:	74 0e                	je     800e92 <readline+0x89>
				cputchar(c);
  800e84:	83 ec 0c             	sub    $0xc,%esp
  800e87:	ff 75 ec             	pushl  -0x14(%ebp)
  800e8a:	e8 f7 0f 00 00       	call   801e86 <cputchar>
  800e8f:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e95:	8d 50 01             	lea    0x1(%eax),%edx
  800e98:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800e9b:	89 c2                	mov    %eax,%edx
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	01 d0                	add    %edx,%eax
  800ea2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ea5:	88 10                	mov    %dl,(%eax)
  800ea7:	eb 56                	jmp    800eff <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ea9:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ead:	75 1f                	jne    800ece <readline+0xc5>
  800eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800eb3:	7e 19                	jle    800ece <readline+0xc5>
			if (echoing)
  800eb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eb9:	74 0e                	je     800ec9 <readline+0xc0>
				cputchar(c);
  800ebb:	83 ec 0c             	sub    $0xc,%esp
  800ebe:	ff 75 ec             	pushl  -0x14(%ebp)
  800ec1:	e8 c0 0f 00 00       	call   801e86 <cputchar>
  800ec6:	83 c4 10             	add    $0x10,%esp

			i--;
  800ec9:	ff 4d f4             	decl   -0xc(%ebp)
  800ecc:	eb 31                	jmp    800eff <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ece:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ed2:	74 0a                	je     800ede <readline+0xd5>
  800ed4:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800ed8:	0f 85 61 ff ff ff    	jne    800e3f <readline+0x36>
			if (echoing)
  800ede:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ee2:	74 0e                	je     800ef2 <readline+0xe9>
				cputchar(c);
  800ee4:	83 ec 0c             	sub    $0xc,%esp
  800ee7:	ff 75 ec             	pushl  -0x14(%ebp)
  800eea:	e8 97 0f 00 00       	call   801e86 <cputchar>
  800eef:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800ef2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	01 d0                	add    %edx,%eax
  800efa:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800efd:	eb 06                	jmp    800f05 <readline+0xfc>
		}
	}
  800eff:	e9 3b ff ff ff       	jmp    800e3f <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800f04:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800f05:	90                   	nop
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f0e:	e8 79 09 00 00       	call   80188c <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f17:	74 13                	je     800f2c <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f19:	83 ec 08             	sub    $0x8,%esp
  800f1c:	ff 75 08             	pushl  0x8(%ebp)
  800f1f:	68 28 2a 80 00       	push   $0x802a28
  800f24:	e8 07 f8 ff ff       	call   800730 <cprintf>
  800f29:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f33:	83 ec 0c             	sub    $0xc,%esp
  800f36:	6a 00                	push   $0x0
  800f38:	e8 7b 0f 00 00       	call   801eb8 <iscons>
  800f3d:	83 c4 10             	add    $0x10,%esp
  800f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f43:	e8 5d 0f 00 00       	call   801ea5 <getchar>
  800f48:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f4f:	79 22                	jns    800f73 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f51:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f55:	0f 84 ad 00 00 00    	je     801008 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f5b:	83 ec 08             	sub    $0x8,%esp
  800f5e:	ff 75 ec             	pushl  -0x14(%ebp)
  800f61:	68 2b 2a 80 00       	push   $0x802a2b
  800f66:	e8 c5 f7 ff ff       	call   800730 <cprintf>
  800f6b:	83 c4 10             	add    $0x10,%esp
				break;
  800f6e:	e9 95 00 00 00       	jmp    801008 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800f73:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f77:	7e 34                	jle    800fad <atomic_readline+0xa5>
  800f79:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f80:	7f 2b                	jg     800fad <atomic_readline+0xa5>
				if (echoing)
  800f82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f86:	74 0e                	je     800f96 <atomic_readline+0x8e>
					cputchar(c);
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	ff 75 ec             	pushl  -0x14(%ebp)
  800f8e:	e8 f3 0e 00 00       	call   801e86 <cputchar>
  800f93:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f99:	8d 50 01             	lea    0x1(%eax),%edx
  800f9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800f9f:	89 c2                	mov    %eax,%edx
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fa9:	88 10                	mov    %dl,(%eax)
  800fab:	eb 56                	jmp    801003 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800fad:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fb1:	75 1f                	jne    800fd2 <atomic_readline+0xca>
  800fb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fb7:	7e 19                	jle    800fd2 <atomic_readline+0xca>
				if (echoing)
  800fb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fbd:	74 0e                	je     800fcd <atomic_readline+0xc5>
					cputchar(c);
  800fbf:	83 ec 0c             	sub    $0xc,%esp
  800fc2:	ff 75 ec             	pushl  -0x14(%ebp)
  800fc5:	e8 bc 0e 00 00       	call   801e86 <cputchar>
  800fca:	83 c4 10             	add    $0x10,%esp
				i--;
  800fcd:	ff 4d f4             	decl   -0xc(%ebp)
  800fd0:	eb 31                	jmp    801003 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800fd2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800fd6:	74 0a                	je     800fe2 <atomic_readline+0xda>
  800fd8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800fdc:	0f 85 61 ff ff ff    	jne    800f43 <atomic_readline+0x3b>
				if (echoing)
  800fe2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fe6:	74 0e                	je     800ff6 <atomic_readline+0xee>
					cputchar(c);
  800fe8:	83 ec 0c             	sub    $0xc,%esp
  800feb:	ff 75 ec             	pushl  -0x14(%ebp)
  800fee:	e8 93 0e 00 00       	call   801e86 <cputchar>
  800ff3:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffc:	01 d0                	add    %edx,%eax
  800ffe:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801001:	eb 06                	jmp    801009 <atomic_readline+0x101>
			}
		}
  801003:	e9 3b ff ff ff       	jmp    800f43 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801008:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801009:	e8 98 08 00 00       	call   8018a6 <sys_unlock_cons>
}
  80100e:	90                   	nop
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80101e:	eb 06                	jmp    801026 <strlen+0x15>
		n++;
  801020:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801023:	ff 45 08             	incl   0x8(%ebp)
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	84 c0                	test   %al,%al
  80102d:	75 f1                	jne    801020 <strlen+0xf>
		n++;
	return n;
  80102f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801032:	c9                   	leave  
  801033:	c3                   	ret    

00801034 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801041:	eb 09                	jmp    80104c <strnlen+0x18>
		n++;
  801043:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801046:	ff 45 08             	incl   0x8(%ebp)
  801049:	ff 4d 0c             	decl   0xc(%ebp)
  80104c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801050:	74 09                	je     80105b <strnlen+0x27>
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	84 c0                	test   %al,%al
  801059:	75 e8                	jne    801043 <strnlen+0xf>
		n++;
	return n;
  80105b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80105e:	c9                   	leave  
  80105f:	c3                   	ret    

00801060 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80106c:	90                   	nop
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 08             	mov    %edx,0x8(%ebp)
  801076:	8b 55 0c             	mov    0xc(%ebp),%edx
  801079:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80107f:	8a 12                	mov    (%edx),%dl
  801081:	88 10                	mov    %dl,(%eax)
  801083:	8a 00                	mov    (%eax),%al
  801085:	84 c0                	test   %al,%al
  801087:	75 e4                	jne    80106d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801089:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80109a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a1:	eb 1f                	jmp    8010c2 <strncpy+0x34>
		*dst++ = *src;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8d 50 01             	lea    0x1(%eax),%edx
  8010a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010af:	8a 12                	mov    (%edx),%dl
  8010b1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	84 c0                	test   %al,%al
  8010ba:	74 03                	je     8010bf <strncpy+0x31>
			src++;
  8010bc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010bf:	ff 45 fc             	incl   -0x4(%ebp)
  8010c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c8:	72 d9                	jb     8010a3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010df:	74 30                	je     801111 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010e1:	eb 16                	jmp    8010f9 <strlcpy+0x2a>
			*dst++ = *src++;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8d 50 01             	lea    0x1(%eax),%edx
  8010e9:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010f5:	8a 12                	mov    (%edx),%dl
  8010f7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010f9:	ff 4d 10             	decl   0x10(%ebp)
  8010fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801100:	74 09                	je     80110b <strlcpy+0x3c>
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	84 c0                	test   %al,%al
  801109:	75 d8                	jne    8010e3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801111:	8b 55 08             	mov    0x8(%ebp),%edx
  801114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
}
  80111b:	c9                   	leave  
  80111c:	c3                   	ret    

0080111d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801120:	eb 06                	jmp    801128 <strcmp+0xb>
		p++, q++;
  801122:	ff 45 08             	incl   0x8(%ebp)
  801125:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	84 c0                	test   %al,%al
  80112f:	74 0e                	je     80113f <strcmp+0x22>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 10                	mov    (%eax),%dl
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	38 c2                	cmp    %al,%dl
  80113d:	74 e3                	je     801122 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	0f b6 d0             	movzbl %al,%edx
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 c0             	movzbl %al,%eax
  80114f:	29 c2                	sub    %eax,%edx
  801151:	89 d0                	mov    %edx,%eax
}
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    

00801155 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801158:	eb 09                	jmp    801163 <strncmp+0xe>
		n--, p++, q++;
  80115a:	ff 4d 10             	decl   0x10(%ebp)
  80115d:	ff 45 08             	incl   0x8(%ebp)
  801160:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801163:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801167:	74 17                	je     801180 <strncmp+0x2b>
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	84 c0                	test   %al,%al
  801170:	74 0e                	je     801180 <strncmp+0x2b>
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 10                	mov    (%eax),%dl
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	38 c2                	cmp    %al,%dl
  80117e:	74 da                	je     80115a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801180:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801184:	75 07                	jne    80118d <strncmp+0x38>
		return 0;
  801186:	b8 00 00 00 00       	mov    $0x0,%eax
  80118b:	eb 14                	jmp    8011a1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	0f b6 d0             	movzbl %al,%edx
  801195:	8b 45 0c             	mov    0xc(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	0f b6 c0             	movzbl %al,%eax
  80119d:	29 c2                	sub    %eax,%edx
  80119f:	89 d0                	mov    %edx,%eax
}
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	83 ec 04             	sub    $0x4,%esp
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011af:	eb 12                	jmp    8011c3 <strchr+0x20>
		if (*s == c)
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011b9:	75 05                	jne    8011c0 <strchr+0x1d>
			return (char *) s;
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	eb 11                	jmp    8011d1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c0:	ff 45 08             	incl   0x8(%ebp)
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	84 c0                	test   %al,%al
  8011ca:	75 e5                	jne    8011b1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 04             	sub    $0x4,%esp
  8011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011df:	eb 0d                	jmp    8011ee <strfind+0x1b>
		if (*s == c)
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011e9:	74 0e                	je     8011f9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011eb:	ff 45 08             	incl   0x8(%ebp)
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	8a 00                	mov    (%eax),%al
  8011f3:	84 c0                	test   %al,%al
  8011f5:	75 ea                	jne    8011e1 <strfind+0xe>
  8011f7:	eb 01                	jmp    8011fa <strfind+0x27>
		if (*s == c)
			break;
  8011f9:	90                   	nop
	return (char *) s;
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80120b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80120f:	76 63                	jbe    801274 <memset+0x75>
		uint64 data_block = c;
  801211:	8b 45 0c             	mov    0xc(%ebp),%eax
  801214:	99                   	cltd   
  801215:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801218:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80121b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80121e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801221:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801225:	c1 e0 08             	shl    $0x8,%eax
  801228:	09 45 f0             	or     %eax,-0x10(%ebp)
  80122b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80122e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801231:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801234:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801238:	c1 e0 10             	shl    $0x10,%eax
  80123b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80123e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801241:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801244:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801247:	89 c2                	mov    %eax,%edx
  801249:	b8 00 00 00 00       	mov    $0x0,%eax
  80124e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801251:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801254:	eb 18                	jmp    80126e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801256:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801259:	8d 41 08             	lea    0x8(%ecx),%eax
  80125c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80125f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801265:	89 01                	mov    %eax,(%ecx)
  801267:	89 51 04             	mov    %edx,0x4(%ecx)
  80126a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80126e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801272:	77 e2                	ja     801256 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801274:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801278:	74 23                	je     80129d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80127a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80127d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801280:	eb 0e                	jmp    801290 <memset+0x91>
			*p8++ = (uint8)c;
  801282:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801285:	8d 50 01             	lea    0x1(%eax),%edx
  801288:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80128b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801290:	8b 45 10             	mov    0x10(%ebp),%eax
  801293:	8d 50 ff             	lea    -0x1(%eax),%edx
  801296:	89 55 10             	mov    %edx,0x10(%ebp)
  801299:	85 c0                	test   %eax,%eax
  80129b:	75 e5                	jne    801282 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012b4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012b8:	76 24                	jbe    8012de <memcpy+0x3c>
		while(n >= 8){
  8012ba:	eb 1c                	jmp    8012d8 <memcpy+0x36>
			*d64 = *s64;
  8012bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bf:	8b 50 04             	mov    0x4(%eax),%edx
  8012c2:	8b 00                	mov    (%eax),%eax
  8012c4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c7:	89 01                	mov    %eax,(%ecx)
  8012c9:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012cc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012d0:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8012d4:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012d8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012dc:	77 de                	ja     8012bc <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012e2:	74 31                	je     801315 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012f0:	eb 16                	jmp    801308 <memcpy+0x66>
			*d8++ = *s8++;
  8012f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f5:	8d 50 01             	lea    0x1(%eax),%edx
  8012f8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801301:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801304:	8a 12                	mov    (%edx),%dl
  801306:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801308:	8b 45 10             	mov    0x10(%ebp),%eax
  80130b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80130e:	89 55 10             	mov    %edx,0x10(%ebp)
  801311:	85 c0                	test   %eax,%eax
  801313:	75 dd                	jne    8012f2 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801320:	8b 45 0c             	mov    0xc(%ebp),%eax
  801323:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80132c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801332:	73 50                	jae    801384 <memmove+0x6a>
  801334:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801337:	8b 45 10             	mov    0x10(%ebp),%eax
  80133a:	01 d0                	add    %edx,%eax
  80133c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80133f:	76 43                	jbe    801384 <memmove+0x6a>
		s += n;
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801347:	8b 45 10             	mov    0x10(%ebp),%eax
  80134a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80134d:	eb 10                	jmp    80135f <memmove+0x45>
			*--d = *--s;
  80134f:	ff 4d f8             	decl   -0x8(%ebp)
  801352:	ff 4d fc             	decl   -0x4(%ebp)
  801355:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801358:	8a 10                	mov    (%eax),%dl
  80135a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80135f:	8b 45 10             	mov    0x10(%ebp),%eax
  801362:	8d 50 ff             	lea    -0x1(%eax),%edx
  801365:	89 55 10             	mov    %edx,0x10(%ebp)
  801368:	85 c0                	test   %eax,%eax
  80136a:	75 e3                	jne    80134f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80136c:	eb 23                	jmp    801391 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80136e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801371:	8d 50 01             	lea    0x1(%eax),%edx
  801374:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801377:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80137d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801380:	8a 12                	mov    (%edx),%dl
  801382:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801384:	8b 45 10             	mov    0x10(%ebp),%eax
  801387:	8d 50 ff             	lea    -0x1(%eax),%edx
  80138a:	89 55 10             	mov    %edx,0x10(%ebp)
  80138d:	85 c0                	test   %eax,%eax
  80138f:	75 dd                	jne    80136e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013a8:	eb 2a                	jmp    8013d4 <memcmp+0x3e>
		if (*s1 != *s2)
  8013aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ad:	8a 10                	mov    (%eax),%dl
  8013af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	38 c2                	cmp    %al,%dl
  8013b6:	74 16                	je     8013ce <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	0f b6 d0             	movzbl %al,%edx
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	0f b6 c0             	movzbl %al,%eax
  8013c8:	29 c2                	sub    %eax,%edx
  8013ca:	89 d0                	mov    %edx,%eax
  8013cc:	eb 18                	jmp    8013e6 <memcmp+0x50>
		s1++, s2++;
  8013ce:	ff 45 fc             	incl   -0x4(%ebp)
  8013d1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013da:	89 55 10             	mov    %edx,0x10(%ebp)
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	75 c9                	jne    8013aa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	01 d0                	add    %edx,%eax
  8013f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013f9:	eb 15                	jmp    801410 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f b6 d0             	movzbl %al,%edx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	0f b6 c0             	movzbl %al,%eax
  801409:	39 c2                	cmp    %eax,%edx
  80140b:	74 0d                	je     80141a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80140d:	ff 45 08             	incl   0x8(%ebp)
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801416:	72 e3                	jb     8013fb <memfind+0x13>
  801418:	eb 01                	jmp    80141b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80141a:	90                   	nop
	return (void *) s;
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801426:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80142d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801434:	eb 03                	jmp    801439 <strtol+0x19>
		s++;
  801436:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 20                	cmp    $0x20,%al
  801440:	74 f4                	je     801436 <strtol+0x16>
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 09                	cmp    $0x9,%al
  801449:	74 eb                	je     801436 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	3c 2b                	cmp    $0x2b,%al
  801452:	75 05                	jne    801459 <strtol+0x39>
		s++;
  801454:	ff 45 08             	incl   0x8(%ebp)
  801457:	eb 13                	jmp    80146c <strtol+0x4c>
	else if (*s == '-')
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	3c 2d                	cmp    $0x2d,%al
  801460:	75 0a                	jne    80146c <strtol+0x4c>
		s++, neg = 1;
  801462:	ff 45 08             	incl   0x8(%ebp)
  801465:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80146c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801470:	74 06                	je     801478 <strtol+0x58>
  801472:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801476:	75 20                	jne    801498 <strtol+0x78>
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8a 00                	mov    (%eax),%al
  80147d:	3c 30                	cmp    $0x30,%al
  80147f:	75 17                	jne    801498 <strtol+0x78>
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	40                   	inc    %eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	3c 78                	cmp    $0x78,%al
  801489:	75 0d                	jne    801498 <strtol+0x78>
		s += 2, base = 16;
  80148b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80148f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801496:	eb 28                	jmp    8014c0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801498:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80149c:	75 15                	jne    8014b3 <strtol+0x93>
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	8a 00                	mov    (%eax),%al
  8014a3:	3c 30                	cmp    $0x30,%al
  8014a5:	75 0c                	jne    8014b3 <strtol+0x93>
		s++, base = 8;
  8014a7:	ff 45 08             	incl   0x8(%ebp)
  8014aa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014b1:	eb 0d                	jmp    8014c0 <strtol+0xa0>
	else if (base == 0)
  8014b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b7:	75 07                	jne    8014c0 <strtol+0xa0>
		base = 10;
  8014b9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	8a 00                	mov    (%eax),%al
  8014c5:	3c 2f                	cmp    $0x2f,%al
  8014c7:	7e 19                	jle    8014e2 <strtol+0xc2>
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	8a 00                	mov    (%eax),%al
  8014ce:	3c 39                	cmp    $0x39,%al
  8014d0:	7f 10                	jg     8014e2 <strtol+0xc2>
			dig = *s - '0';
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	8a 00                	mov    (%eax),%al
  8014d7:	0f be c0             	movsbl %al,%eax
  8014da:	83 e8 30             	sub    $0x30,%eax
  8014dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e0:	eb 42                	jmp    801524 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	8a 00                	mov    (%eax),%al
  8014e7:	3c 60                	cmp    $0x60,%al
  8014e9:	7e 19                	jle    801504 <strtol+0xe4>
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	3c 7a                	cmp    $0x7a,%al
  8014f2:	7f 10                	jg     801504 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	83 e8 57             	sub    $0x57,%eax
  8014ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801502:	eb 20                	jmp    801524 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	3c 40                	cmp    $0x40,%al
  80150b:	7e 39                	jle    801546 <strtol+0x126>
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8a 00                	mov    (%eax),%al
  801512:	3c 5a                	cmp    $0x5a,%al
  801514:	7f 30                	jg     801546 <strtol+0x126>
			dig = *s - 'A' + 10;
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	0f be c0             	movsbl %al,%eax
  80151e:	83 e8 37             	sub    $0x37,%eax
  801521:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801527:	3b 45 10             	cmp    0x10(%ebp),%eax
  80152a:	7d 19                	jge    801545 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80152c:	ff 45 08             	incl   0x8(%ebp)
  80152f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801532:	0f af 45 10          	imul   0x10(%ebp),%eax
  801536:	89 c2                	mov    %eax,%edx
  801538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153b:	01 d0                	add    %edx,%eax
  80153d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801540:	e9 7b ff ff ff       	jmp    8014c0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801545:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801546:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80154a:	74 08                	je     801554 <strtol+0x134>
		*endptr = (char *) s;
  80154c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154f:	8b 55 08             	mov    0x8(%ebp),%edx
  801552:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801554:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801558:	74 07                	je     801561 <strtol+0x141>
  80155a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155d:	f7 d8                	neg    %eax
  80155f:	eb 03                	jmp    801564 <strtol+0x144>
  801561:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <ltostr>:

void
ltostr(long value, char *str)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80156c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801573:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80157a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80157e:	79 13                	jns    801593 <ltostr+0x2d>
	{
		neg = 1;
  801580:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80158d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801590:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80159b:	99                   	cltd   
  80159c:	f7 f9                	idiv   %ecx
  80159e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a4:	8d 50 01             	lea    0x1(%eax),%edx
  8015a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015aa:	89 c2                	mov    %eax,%edx
  8015ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015af:	01 d0                	add    %edx,%eax
  8015b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015b4:	83 c2 30             	add    $0x30,%edx
  8015b7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015c1:	f7 e9                	imul   %ecx
  8015c3:	c1 fa 02             	sar    $0x2,%edx
  8015c6:	89 c8                	mov    %ecx,%eax
  8015c8:	c1 f8 1f             	sar    $0x1f,%eax
  8015cb:	29 c2                	sub    %eax,%edx
  8015cd:	89 d0                	mov    %edx,%eax
  8015cf:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015d6:	75 bb                	jne    801593 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e2:	48                   	dec    %eax
  8015e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015ea:	74 3d                	je     801629 <ltostr+0xc3>
		start = 1 ;
  8015ec:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015f3:	eb 34                	jmp    801629 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fb:	01 d0                	add    %edx,%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801602:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	01 c2                	add    %eax,%edx
  80160a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	01 c8                	add    %ecx,%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801616:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801619:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161c:	01 c2                	add    %eax,%edx
  80161e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801621:	88 02                	mov    %al,(%edx)
		start++ ;
  801623:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801626:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80162f:	7c c4                	jl     8015f5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801631:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801634:	8b 45 0c             	mov    0xc(%ebp),%eax
  801637:	01 d0                	add    %edx,%eax
  801639:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80163c:	90                   	nop
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801645:	ff 75 08             	pushl  0x8(%ebp)
  801648:	e8 c4 f9 ff ff       	call   801011 <strlen>
  80164d:	83 c4 04             	add    $0x4,%esp
  801650:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	e8 b6 f9 ff ff       	call   801011 <strlen>
  80165b:	83 c4 04             	add    $0x4,%esp
  80165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801661:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801668:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166f:	eb 17                	jmp    801688 <strcconcat+0x49>
		final[s] = str1[s] ;
  801671:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801674:	8b 45 10             	mov    0x10(%ebp),%eax
  801677:	01 c2                	add    %eax,%edx
  801679:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	01 c8                	add    %ecx,%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801685:	ff 45 fc             	incl   -0x4(%ebp)
  801688:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80168e:	7c e1                	jl     801671 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801690:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801697:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80169e:	eb 1f                	jmp    8016bf <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a3:	8d 50 01             	lea    0x1(%eax),%edx
  8016a6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016a9:	89 c2                	mov    %eax,%edx
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	01 c2                	add    %eax,%edx
  8016b0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	01 c8                	add    %ecx,%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016bc:	ff 45 f8             	incl   -0x8(%ebp)
  8016bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016c5:	7c d9                	jl     8016a0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cd:	01 d0                	add    %edx,%eax
  8016cf:	c6 00 00             	movb   $0x0,(%eax)
}
  8016d2:	90                   	nop
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e4:	8b 00                	mov    (%eax),%eax
  8016e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f0:	01 d0                	add    %edx,%eax
  8016f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f8:	eb 0c                	jmp    801706 <strsplit+0x31>
			*string++ = 0;
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	8d 50 01             	lea    0x1(%eax),%edx
  801700:	89 55 08             	mov    %edx,0x8(%ebp)
  801703:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	84 c0                	test   %al,%al
  80170d:	74 18                	je     801727 <strsplit+0x52>
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8a 00                	mov    (%eax),%al
  801714:	0f be c0             	movsbl %al,%eax
  801717:	50                   	push   %eax
  801718:	ff 75 0c             	pushl  0xc(%ebp)
  80171b:	e8 83 fa ff ff       	call   8011a3 <strchr>
  801720:	83 c4 08             	add    $0x8,%esp
  801723:	85 c0                	test   %eax,%eax
  801725:	75 d3                	jne    8016fa <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801727:	8b 45 08             	mov    0x8(%ebp),%eax
  80172a:	8a 00                	mov    (%eax),%al
  80172c:	84 c0                	test   %al,%al
  80172e:	74 5a                	je     80178a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801730:	8b 45 14             	mov    0x14(%ebp),%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	83 f8 0f             	cmp    $0xf,%eax
  801738:	75 07                	jne    801741 <strsplit+0x6c>
		{
			return 0;
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
  80173f:	eb 66                	jmp    8017a7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801741:	8b 45 14             	mov    0x14(%ebp),%eax
  801744:	8b 00                	mov    (%eax),%eax
  801746:	8d 48 01             	lea    0x1(%eax),%ecx
  801749:	8b 55 14             	mov    0x14(%ebp),%edx
  80174c:	89 0a                	mov    %ecx,(%edx)
  80174e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	01 c2                	add    %eax,%edx
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80175f:	eb 03                	jmp    801764 <strsplit+0x8f>
			string++;
  801761:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	84 c0                	test   %al,%al
  80176b:	74 8b                	je     8016f8 <strsplit+0x23>
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	0f be c0             	movsbl %al,%eax
  801775:	50                   	push   %eax
  801776:	ff 75 0c             	pushl  0xc(%ebp)
  801779:	e8 25 fa ff ff       	call   8011a3 <strchr>
  80177e:	83 c4 08             	add    $0x8,%esp
  801781:	85 c0                	test   %eax,%eax
  801783:	74 dc                	je     801761 <strsplit+0x8c>
			string++;
	}
  801785:	e9 6e ff ff ff       	jmp    8016f8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80178a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80178b:	8b 45 14             	mov    0x14(%ebp),%eax
  80178e:	8b 00                	mov    (%eax),%eax
  801790:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801797:	8b 45 10             	mov    0x10(%ebp),%eax
  80179a:	01 d0                	add    %edx,%eax
  80179c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017a2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017bc:	eb 4a                	jmp    801808 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	01 c2                	add    %eax,%edx
  8017c6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cc:	01 c8                	add    %ecx,%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	8a 00                	mov    (%eax),%al
  8017dc:	3c 40                	cmp    $0x40,%al
  8017de:	7e 25                	jle    801805 <str2lower+0x5c>
  8017e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	8a 00                	mov    (%eax),%al
  8017ea:	3c 5a                	cmp    $0x5a,%al
  8017ec:	7f 17                	jg     801805 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	01 d0                	add    %edx,%eax
  8017f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fc:	01 ca                	add    %ecx,%edx
  8017fe:	8a 12                	mov    (%edx),%dl
  801800:	83 c2 20             	add    $0x20,%edx
  801803:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801805:	ff 45 fc             	incl   -0x4(%ebp)
  801808:	ff 75 0c             	pushl  0xc(%ebp)
  80180b:	e8 01 f8 ff ff       	call   801011 <strlen>
  801810:	83 c4 04             	add    $0x4,%esp
  801813:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801816:	7f a6                	jg     8017be <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801818:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	57                   	push   %edi
  801821:	56                   	push   %esi
  801822:	53                   	push   %ebx
  801823:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801832:	8b 7d 18             	mov    0x18(%ebp),%edi
  801835:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801838:	cd 30                	int    $0x30
  80183a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80183d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	5f                   	pop    %edi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    

00801848 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	8b 45 10             	mov    0x10(%ebp),%eax
  801851:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801854:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801857:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	6a 00                	push   $0x0
  801860:	51                   	push   %ecx
  801861:	52                   	push   %edx
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	50                   	push   %eax
  801866:	6a 00                	push   $0x0
  801868:	e8 b0 ff ff ff       	call   80181d <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	90                   	nop
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_cgetc>:

int
sys_cgetc(void)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 02                	push   $0x2
  801882:	e8 96 ff ff ff       	call   80181d <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 03                	push   $0x3
  80189b:	e8 7d ff ff ff       	call   80181d <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	90                   	nop
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 04                	push   $0x4
  8018b5:	e8 63 ff ff ff       	call   80181d <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	90                   	nop
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	52                   	push   %edx
  8018d0:	50                   	push   %eax
  8018d1:	6a 08                	push   $0x8
  8018d3:	e8 45 ff ff ff       	call   80181d <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	56                   	push   %esi
  8018e1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018e2:	8b 75 18             	mov    0x18(%ebp),%esi
  8018e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	56                   	push   %esi
  8018f2:	53                   	push   %ebx
  8018f3:	51                   	push   %ecx
  8018f4:	52                   	push   %edx
  8018f5:	50                   	push   %eax
  8018f6:	6a 09                	push   $0x9
  8018f8:	e8 20 ff ff ff       	call   80181d <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801903:	5b                   	pop    %ebx
  801904:	5e                   	pop    %esi
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    

00801907 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	6a 0a                	push   $0xa
  801917:	e8 01 ff ff ff       	call   80181d <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	6a 0b                	push   $0xb
  801932:	e8 e6 fe ff ff       	call   80181d <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 0c                	push   $0xc
  80194b:	e8 cd fe ff ff       	call   80181d <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 0d                	push   $0xd
  801964:	e8 b4 fe ff ff       	call   80181d <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 0e                	push   $0xe
  80197d:	e8 9b fe ff ff       	call   80181d <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 0f                	push   $0xf
  801996:	e8 82 fe ff ff       	call   80181d <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	ff 75 08             	pushl  0x8(%ebp)
  8019ae:	6a 10                	push   $0x10
  8019b0:	e8 68 fe ff ff       	call   80181d <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 11                	push   $0x11
  8019c9:	e8 4f fe ff ff       	call   80181d <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	90                   	nop
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019e0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	50                   	push   %eax
  8019ed:	6a 01                	push   $0x1
  8019ef:	e8 29 fe ff ff       	call   80181d <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 14                	push   $0x14
  801a09:	e8 0f fe ff ff       	call   80181d <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	90                   	nop
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 04             	sub    $0x4,%esp
  801a1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a20:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a23:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	6a 00                	push   $0x0
  801a2c:	51                   	push   %ecx
  801a2d:	52                   	push   %edx
  801a2e:	ff 75 0c             	pushl  0xc(%ebp)
  801a31:	50                   	push   %eax
  801a32:	6a 15                	push   $0x15
  801a34:	e8 e4 fd ff ff       	call   80181d <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	52                   	push   %edx
  801a4e:	50                   	push   %eax
  801a4f:	6a 16                	push   $0x16
  801a51:	e8 c7 fd ff ff       	call   80181d <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	51                   	push   %ecx
  801a6c:	52                   	push   %edx
  801a6d:	50                   	push   %eax
  801a6e:	6a 17                	push   $0x17
  801a70:	e8 a8 fd ff ff       	call   80181d <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	52                   	push   %edx
  801a8a:	50                   	push   %eax
  801a8b:	6a 18                	push   $0x18
  801a8d:	e8 8b fd ff ff       	call   80181d <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	ff 75 14             	pushl  0x14(%ebp)
  801aa2:	ff 75 10             	pushl  0x10(%ebp)
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	50                   	push   %eax
  801aa9:	6a 19                	push   $0x19
  801aab:	e8 6d fd ff ff       	call   80181d <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	50                   	push   %eax
  801ac4:	6a 1a                	push   $0x1a
  801ac6:	e8 52 fd ff ff       	call   80181d <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	90                   	nop
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	50                   	push   %eax
  801ae0:	6a 1b                	push   $0x1b
  801ae2:	e8 36 fd ff ff       	call   80181d <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 05                	push   $0x5
  801afb:	e8 1d fd ff ff       	call   80181d <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 06                	push   $0x6
  801b14:	e8 04 fd ff ff       	call   80181d <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 07                	push   $0x7
  801b2d:	e8 eb fc ff ff       	call   80181d <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_exit_env>:


void sys_exit_env(void)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 1c                	push   $0x1c
  801b46:	e8 d2 fc ff ff       	call   80181d <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	90                   	nop
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b57:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b5a:	8d 50 04             	lea    0x4(%eax),%edx
  801b5d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	52                   	push   %edx
  801b67:	50                   	push   %eax
  801b68:	6a 1d                	push   $0x1d
  801b6a:	e8 ae fc ff ff       	call   80181d <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
	return result;
  801b72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b7b:	89 01                	mov    %eax,(%ecx)
  801b7d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	c9                   	leave  
  801b84:	c2 04 00             	ret    $0x4

00801b87 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	ff 75 10             	pushl  0x10(%ebp)
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	ff 75 08             	pushl  0x8(%ebp)
  801b97:	6a 13                	push   $0x13
  801b99:	e8 7f fc ff ff       	call   80181d <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba1:	90                   	nop
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 1e                	push   $0x1e
  801bb3:	e8 65 fc ff ff       	call   80181d <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 04             	sub    $0x4,%esp
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bc9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	50                   	push   %eax
  801bd6:	6a 1f                	push   $0x1f
  801bd8:	e8 40 fc ff ff       	call   80181d <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801be0:	90                   	nop
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <rsttst>:
void rsttst()
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 21                	push   $0x21
  801bf2:	e8 26 fc ff ff       	call   80181d <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfa:	90                   	nop
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	8b 45 14             	mov    0x14(%ebp),%eax
  801c06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c09:	8b 55 18             	mov    0x18(%ebp),%edx
  801c0c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c10:	52                   	push   %edx
  801c11:	50                   	push   %eax
  801c12:	ff 75 10             	pushl  0x10(%ebp)
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	ff 75 08             	pushl  0x8(%ebp)
  801c1b:	6a 20                	push   $0x20
  801c1d:	e8 fb fb ff ff       	call   80181d <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
	return ;
  801c25:	90                   	nop
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <chktst>:
void chktst(uint32 n)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	ff 75 08             	pushl  0x8(%ebp)
  801c36:	6a 22                	push   $0x22
  801c38:	e8 e0 fb ff ff       	call   80181d <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c40:	90                   	nop
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <inctst>:

void inctst()
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 23                	push   $0x23
  801c52:	e8 c6 fb ff ff       	call   80181d <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5a:	90                   	nop
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <gettst>:
uint32 gettst()
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 24                	push   $0x24
  801c6c:	e8 ac fb ff ff       	call   80181d <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 25                	push   $0x25
  801c85:	e8 93 fb ff ff       	call   80181d <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
  801c8d:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c92:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	ff 75 08             	pushl  0x8(%ebp)
  801caf:	6a 26                	push   $0x26
  801cb1:	e8 67 fb ff ff       	call   80181d <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb9:	90                   	nop
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cc0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	6a 00                	push   $0x0
  801cce:	53                   	push   %ebx
  801ccf:	51                   	push   %ecx
  801cd0:	52                   	push   %edx
  801cd1:	50                   	push   %eax
  801cd2:	6a 27                	push   $0x27
  801cd4:	e8 44 fb ff ff       	call   80181d <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ce4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	52                   	push   %edx
  801cf1:	50                   	push   %eax
  801cf2:	6a 28                	push   $0x28
  801cf4:	e8 24 fb ff ff       	call   80181d <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d01:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	6a 00                	push   $0x0
  801d0c:	51                   	push   %ecx
  801d0d:	ff 75 10             	pushl  0x10(%ebp)
  801d10:	52                   	push   %edx
  801d11:	50                   	push   %eax
  801d12:	6a 29                	push   $0x29
  801d14:	e8 04 fb ff ff       	call   80181d <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	ff 75 10             	pushl  0x10(%ebp)
  801d28:	ff 75 0c             	pushl  0xc(%ebp)
  801d2b:	ff 75 08             	pushl  0x8(%ebp)
  801d2e:	6a 12                	push   $0x12
  801d30:	e8 e8 fa ff ff       	call   80181d <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
	return ;
  801d38:	90                   	nop
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	52                   	push   %edx
  801d4b:	50                   	push   %eax
  801d4c:	6a 2a                	push   $0x2a
  801d4e:	e8 ca fa ff ff       	call   80181d <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 2b                	push   $0x2b
  801d68:	e8 b0 fa ff ff       	call   80181d <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	ff 75 08             	pushl  0x8(%ebp)
  801d81:	6a 2d                	push   $0x2d
  801d83:	e8 95 fa ff ff       	call   80181d <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
	return;
  801d8b:	90                   	nop
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	ff 75 0c             	pushl  0xc(%ebp)
  801d9a:	ff 75 08             	pushl  0x8(%ebp)
  801d9d:	6a 2c                	push   $0x2c
  801d9f:	e8 79 fa ff ff       	call   80181d <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
	return ;
  801da7:	90                   	nop
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	52                   	push   %edx
  801dba:	50                   	push   %eax
  801dbb:	6a 2e                	push   $0x2e
  801dbd:	e8 5b fa ff ff       	call   80181d <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
	    return;
  801dc5:	90                   	nop
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801dce:	8b 55 08             	mov    0x8(%ebp),%edx
  801dd1:	89 d0                	mov    %edx,%eax
  801dd3:	c1 e0 02             	shl    $0x2,%eax
  801dd6:	01 d0                	add    %edx,%eax
  801dd8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ddf:	01 d0                	add    %edx,%eax
  801de1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801de8:	01 d0                	add    %edx,%eax
  801dea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801df1:	01 d0                	add    %edx,%eax
  801df3:	c1 e0 04             	shl    $0x4,%eax
  801df6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801df9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e00:	0f 31                	rdtsc  
  801e02:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e05:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e11:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e14:	eb 46                	jmp    801e5c <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e16:	0f 31                	rdtsc  
  801e18:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e1b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e1e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e21:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e24:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e27:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e2a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e30:	29 c2                	sub    %eax,%edx
  801e32:	89 d0                	mov    %edx,%eax
  801e34:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	89 d1                	mov    %edx,%ecx
  801e3f:	29 c1                	sub    %eax,%ecx
  801e41:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e47:	39 c2                	cmp    %eax,%edx
  801e49:	0f 97 c0             	seta   %al
  801e4c:	0f b6 c0             	movzbl %al,%eax
  801e4f:	29 c1                	sub    %eax,%ecx
  801e51:	89 c8                	mov    %ecx,%eax
  801e53:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e56:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e5f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e62:	72 b2                	jb     801e16 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e64:	90                   	nop
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e74:	eb 03                	jmp    801e79 <busy_wait+0x12>
  801e76:	ff 45 fc             	incl   -0x4(%ebp)
  801e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e7f:	72 f5                	jb     801e76 <busy_wait+0xf>
	return i;
  801e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8f:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801e92:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	50                   	push   %eax
  801e9a:	e8 35 fb ff ff       	call   8019d4 <sys_cputc>
  801e9f:	83 c4 10             	add    $0x10,%esp
}
  801ea2:	90                   	nop
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <getchar>:


int
getchar(void)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801eab:	e8 c3 f9 ff ff       	call   801873 <sys_cgetc>
  801eb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <iscons>:

int iscons(int fdnum)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801ebb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ec0:	5d                   	pop    %ebp
  801ec1:	c3                   	ret    
  801ec2:	66 90                	xchg   %ax,%ax

00801ec4 <__udivdi3>:
  801ec4:	55                   	push   %ebp
  801ec5:	57                   	push   %edi
  801ec6:	56                   	push   %esi
  801ec7:	53                   	push   %ebx
  801ec8:	83 ec 1c             	sub    $0x1c,%esp
  801ecb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ecf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ed3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ed7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801edb:	89 ca                	mov    %ecx,%edx
  801edd:	89 f8                	mov    %edi,%eax
  801edf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ee3:	85 f6                	test   %esi,%esi
  801ee5:	75 2d                	jne    801f14 <__udivdi3+0x50>
  801ee7:	39 cf                	cmp    %ecx,%edi
  801ee9:	77 65                	ja     801f50 <__udivdi3+0x8c>
  801eeb:	89 fd                	mov    %edi,%ebp
  801eed:	85 ff                	test   %edi,%edi
  801eef:	75 0b                	jne    801efc <__udivdi3+0x38>
  801ef1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef6:	31 d2                	xor    %edx,%edx
  801ef8:	f7 f7                	div    %edi
  801efa:	89 c5                	mov    %eax,%ebp
  801efc:	31 d2                	xor    %edx,%edx
  801efe:	89 c8                	mov    %ecx,%eax
  801f00:	f7 f5                	div    %ebp
  801f02:	89 c1                	mov    %eax,%ecx
  801f04:	89 d8                	mov    %ebx,%eax
  801f06:	f7 f5                	div    %ebp
  801f08:	89 cf                	mov    %ecx,%edi
  801f0a:	89 fa                	mov    %edi,%edx
  801f0c:	83 c4 1c             	add    $0x1c,%esp
  801f0f:	5b                   	pop    %ebx
  801f10:	5e                   	pop    %esi
  801f11:	5f                   	pop    %edi
  801f12:	5d                   	pop    %ebp
  801f13:	c3                   	ret    
  801f14:	39 ce                	cmp    %ecx,%esi
  801f16:	77 28                	ja     801f40 <__udivdi3+0x7c>
  801f18:	0f bd fe             	bsr    %esi,%edi
  801f1b:	83 f7 1f             	xor    $0x1f,%edi
  801f1e:	75 40                	jne    801f60 <__udivdi3+0x9c>
  801f20:	39 ce                	cmp    %ecx,%esi
  801f22:	72 0a                	jb     801f2e <__udivdi3+0x6a>
  801f24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f28:	0f 87 9e 00 00 00    	ja     801fcc <__udivdi3+0x108>
  801f2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f33:	89 fa                	mov    %edi,%edx
  801f35:	83 c4 1c             	add    $0x1c,%esp
  801f38:	5b                   	pop    %ebx
  801f39:	5e                   	pop    %esi
  801f3a:	5f                   	pop    %edi
  801f3b:	5d                   	pop    %ebp
  801f3c:	c3                   	ret    
  801f3d:	8d 76 00             	lea    0x0(%esi),%esi
  801f40:	31 ff                	xor    %edi,%edi
  801f42:	31 c0                	xor    %eax,%eax
  801f44:	89 fa                	mov    %edi,%edx
  801f46:	83 c4 1c             	add    $0x1c,%esp
  801f49:	5b                   	pop    %ebx
  801f4a:	5e                   	pop    %esi
  801f4b:	5f                   	pop    %edi
  801f4c:	5d                   	pop    %ebp
  801f4d:	c3                   	ret    
  801f4e:	66 90                	xchg   %ax,%ax
  801f50:	89 d8                	mov    %ebx,%eax
  801f52:	f7 f7                	div    %edi
  801f54:	31 ff                	xor    %edi,%edi
  801f56:	89 fa                	mov    %edi,%edx
  801f58:	83 c4 1c             	add    $0x1c,%esp
  801f5b:	5b                   	pop    %ebx
  801f5c:	5e                   	pop    %esi
  801f5d:	5f                   	pop    %edi
  801f5e:	5d                   	pop    %ebp
  801f5f:	c3                   	ret    
  801f60:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f65:	89 eb                	mov    %ebp,%ebx
  801f67:	29 fb                	sub    %edi,%ebx
  801f69:	89 f9                	mov    %edi,%ecx
  801f6b:	d3 e6                	shl    %cl,%esi
  801f6d:	89 c5                	mov    %eax,%ebp
  801f6f:	88 d9                	mov    %bl,%cl
  801f71:	d3 ed                	shr    %cl,%ebp
  801f73:	89 e9                	mov    %ebp,%ecx
  801f75:	09 f1                	or     %esi,%ecx
  801f77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f7b:	89 f9                	mov    %edi,%ecx
  801f7d:	d3 e0                	shl    %cl,%eax
  801f7f:	89 c5                	mov    %eax,%ebp
  801f81:	89 d6                	mov    %edx,%esi
  801f83:	88 d9                	mov    %bl,%cl
  801f85:	d3 ee                	shr    %cl,%esi
  801f87:	89 f9                	mov    %edi,%ecx
  801f89:	d3 e2                	shl    %cl,%edx
  801f8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f8f:	88 d9                	mov    %bl,%cl
  801f91:	d3 e8                	shr    %cl,%eax
  801f93:	09 c2                	or     %eax,%edx
  801f95:	89 d0                	mov    %edx,%eax
  801f97:	89 f2                	mov    %esi,%edx
  801f99:	f7 74 24 0c          	divl   0xc(%esp)
  801f9d:	89 d6                	mov    %edx,%esi
  801f9f:	89 c3                	mov    %eax,%ebx
  801fa1:	f7 e5                	mul    %ebp
  801fa3:	39 d6                	cmp    %edx,%esi
  801fa5:	72 19                	jb     801fc0 <__udivdi3+0xfc>
  801fa7:	74 0b                	je     801fb4 <__udivdi3+0xf0>
  801fa9:	89 d8                	mov    %ebx,%eax
  801fab:	31 ff                	xor    %edi,%edi
  801fad:	e9 58 ff ff ff       	jmp    801f0a <__udivdi3+0x46>
  801fb2:	66 90                	xchg   %ax,%ax
  801fb4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fb8:	89 f9                	mov    %edi,%ecx
  801fba:	d3 e2                	shl    %cl,%edx
  801fbc:	39 c2                	cmp    %eax,%edx
  801fbe:	73 e9                	jae    801fa9 <__udivdi3+0xe5>
  801fc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fc3:	31 ff                	xor    %edi,%edi
  801fc5:	e9 40 ff ff ff       	jmp    801f0a <__udivdi3+0x46>
  801fca:	66 90                	xchg   %ax,%ax
  801fcc:	31 c0                	xor    %eax,%eax
  801fce:	e9 37 ff ff ff       	jmp    801f0a <__udivdi3+0x46>
  801fd3:	90                   	nop

00801fd4 <__umoddi3>:
  801fd4:	55                   	push   %ebp
  801fd5:	57                   	push   %edi
  801fd6:	56                   	push   %esi
  801fd7:	53                   	push   %ebx
  801fd8:	83 ec 1c             	sub    $0x1c,%esp
  801fdb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fe3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fe7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801feb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ff3:	89 f3                	mov    %esi,%ebx
  801ff5:	89 fa                	mov    %edi,%edx
  801ff7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ffb:	89 34 24             	mov    %esi,(%esp)
  801ffe:	85 c0                	test   %eax,%eax
  802000:	75 1a                	jne    80201c <__umoddi3+0x48>
  802002:	39 f7                	cmp    %esi,%edi
  802004:	0f 86 a2 00 00 00    	jbe    8020ac <__umoddi3+0xd8>
  80200a:	89 c8                	mov    %ecx,%eax
  80200c:	89 f2                	mov    %esi,%edx
  80200e:	f7 f7                	div    %edi
  802010:	89 d0                	mov    %edx,%eax
  802012:	31 d2                	xor    %edx,%edx
  802014:	83 c4 1c             	add    $0x1c,%esp
  802017:	5b                   	pop    %ebx
  802018:	5e                   	pop    %esi
  802019:	5f                   	pop    %edi
  80201a:	5d                   	pop    %ebp
  80201b:	c3                   	ret    
  80201c:	39 f0                	cmp    %esi,%eax
  80201e:	0f 87 ac 00 00 00    	ja     8020d0 <__umoddi3+0xfc>
  802024:	0f bd e8             	bsr    %eax,%ebp
  802027:	83 f5 1f             	xor    $0x1f,%ebp
  80202a:	0f 84 ac 00 00 00    	je     8020dc <__umoddi3+0x108>
  802030:	bf 20 00 00 00       	mov    $0x20,%edi
  802035:	29 ef                	sub    %ebp,%edi
  802037:	89 fe                	mov    %edi,%esi
  802039:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80203d:	89 e9                	mov    %ebp,%ecx
  80203f:	d3 e0                	shl    %cl,%eax
  802041:	89 d7                	mov    %edx,%edi
  802043:	89 f1                	mov    %esi,%ecx
  802045:	d3 ef                	shr    %cl,%edi
  802047:	09 c7                	or     %eax,%edi
  802049:	89 e9                	mov    %ebp,%ecx
  80204b:	d3 e2                	shl    %cl,%edx
  80204d:	89 14 24             	mov    %edx,(%esp)
  802050:	89 d8                	mov    %ebx,%eax
  802052:	d3 e0                	shl    %cl,%eax
  802054:	89 c2                	mov    %eax,%edx
  802056:	8b 44 24 08          	mov    0x8(%esp),%eax
  80205a:	d3 e0                	shl    %cl,%eax
  80205c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802060:	8b 44 24 08          	mov    0x8(%esp),%eax
  802064:	89 f1                	mov    %esi,%ecx
  802066:	d3 e8                	shr    %cl,%eax
  802068:	09 d0                	or     %edx,%eax
  80206a:	d3 eb                	shr    %cl,%ebx
  80206c:	89 da                	mov    %ebx,%edx
  80206e:	f7 f7                	div    %edi
  802070:	89 d3                	mov    %edx,%ebx
  802072:	f7 24 24             	mull   (%esp)
  802075:	89 c6                	mov    %eax,%esi
  802077:	89 d1                	mov    %edx,%ecx
  802079:	39 d3                	cmp    %edx,%ebx
  80207b:	0f 82 87 00 00 00    	jb     802108 <__umoddi3+0x134>
  802081:	0f 84 91 00 00 00    	je     802118 <__umoddi3+0x144>
  802087:	8b 54 24 04          	mov    0x4(%esp),%edx
  80208b:	29 f2                	sub    %esi,%edx
  80208d:	19 cb                	sbb    %ecx,%ebx
  80208f:	89 d8                	mov    %ebx,%eax
  802091:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802095:	d3 e0                	shl    %cl,%eax
  802097:	89 e9                	mov    %ebp,%ecx
  802099:	d3 ea                	shr    %cl,%edx
  80209b:	09 d0                	or     %edx,%eax
  80209d:	89 e9                	mov    %ebp,%ecx
  80209f:	d3 eb                	shr    %cl,%ebx
  8020a1:	89 da                	mov    %ebx,%edx
  8020a3:	83 c4 1c             	add    $0x1c,%esp
  8020a6:	5b                   	pop    %ebx
  8020a7:	5e                   	pop    %esi
  8020a8:	5f                   	pop    %edi
  8020a9:	5d                   	pop    %ebp
  8020aa:	c3                   	ret    
  8020ab:	90                   	nop
  8020ac:	89 fd                	mov    %edi,%ebp
  8020ae:	85 ff                	test   %edi,%edi
  8020b0:	75 0b                	jne    8020bd <__umoddi3+0xe9>
  8020b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b7:	31 d2                	xor    %edx,%edx
  8020b9:	f7 f7                	div    %edi
  8020bb:	89 c5                	mov    %eax,%ebp
  8020bd:	89 f0                	mov    %esi,%eax
  8020bf:	31 d2                	xor    %edx,%edx
  8020c1:	f7 f5                	div    %ebp
  8020c3:	89 c8                	mov    %ecx,%eax
  8020c5:	f7 f5                	div    %ebp
  8020c7:	89 d0                	mov    %edx,%eax
  8020c9:	e9 44 ff ff ff       	jmp    802012 <__umoddi3+0x3e>
  8020ce:	66 90                	xchg   %ax,%ax
  8020d0:	89 c8                	mov    %ecx,%eax
  8020d2:	89 f2                	mov    %esi,%edx
  8020d4:	83 c4 1c             	add    $0x1c,%esp
  8020d7:	5b                   	pop    %ebx
  8020d8:	5e                   	pop    %esi
  8020d9:	5f                   	pop    %edi
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    
  8020dc:	3b 04 24             	cmp    (%esp),%eax
  8020df:	72 06                	jb     8020e7 <__umoddi3+0x113>
  8020e1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020e5:	77 0f                	ja     8020f6 <__umoddi3+0x122>
  8020e7:	89 f2                	mov    %esi,%edx
  8020e9:	29 f9                	sub    %edi,%ecx
  8020eb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020ef:	89 14 24             	mov    %edx,(%esp)
  8020f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020f6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020fa:	8b 14 24             	mov    (%esp),%edx
  8020fd:	83 c4 1c             	add    $0x1c,%esp
  802100:	5b                   	pop    %ebx
  802101:	5e                   	pop    %esi
  802102:	5f                   	pop    %edi
  802103:	5d                   	pop    %ebp
  802104:	c3                   	ret    
  802105:	8d 76 00             	lea    0x0(%esi),%esi
  802108:	2b 04 24             	sub    (%esp),%eax
  80210b:	19 fa                	sbb    %edi,%edx
  80210d:	89 d1                	mov    %edx,%ecx
  80210f:	89 c6                	mov    %eax,%esi
  802111:	e9 71 ff ff ff       	jmp    802087 <__umoddi3+0xb3>
  802116:	66 90                	xchg   %ax,%ax
  802118:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80211c:	72 ea                	jb     802108 <__umoddi3+0x134>
  80211e:	89 d9                	mov    %ebx,%ecx
  802120:	e9 62 ff ff ff       	jmp    802087 <__umoddi3+0xb3>
