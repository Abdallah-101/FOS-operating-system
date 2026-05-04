
obj/user/tst_chan_all_master:     file format elf32-i386


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
  800031:	e8 57 02 00 00       	call   80028d <libmain>
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
  800047:	68 20 21 80 00       	push   $0x802120
  80004c:	6a 0e                	push   $0xe
  80004e:	e8 ee 06 00 00       	call   800741 <cprintf_colored>
  800053:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	68 50 21 80 00       	push   $0x802150
  80005e:	6a 0e                	push   $0xe
  800060:	e8 dc 06 00 00       	call   800741 <cprintf_colored>
  800065:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow,"==============================================\n");
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	68 20 21 80 00       	push   $0x802120
  800070:	6a 0e                	push   $0xe
  800072:	e8 ca 06 00 00       	call   800741 <cprintf_colored>
  800077:	83 c4 10             	add    $0x10,%esp


	int envID = sys_getenvid();
  80007a:	e8 51 1a 00 00       	call   801ad0 <sys_getenvid>
  80007f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	8d 45 ca             	lea    -0x36(%ebp),%eax
  800088:	50                   	push   %eax
  800089:	68 ac 21 80 00       	push   $0x8021ac
  80008e:	e8 5a 0d 00 00       	call   800ded <readline>
  800093:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	6a 00                	push   $0x0
  80009d:	8d 45 ca             	lea    -0x36(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 5e 13 00 00       	call   801404 <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8000b3:	eb 6a                	jmp    80011f <_main+0xe7>
	{
		id = sys_create_env("tstChanAllSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ba:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8000c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c5:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8000cb:	89 c1                	mov    %eax,%ecx
  8000cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d8:	52                   	push   %edx
  8000d9:	51                   	push   %ecx
  8000da:	50                   	push   %eax
  8000db:	68 d1 21 80 00       	push   $0x8021d1
  8000e0:	e8 96 19 00 00       	call   801a7b <sys_create_env>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  8000eb:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8000ef:	75 1d                	jne    80010e <_main+0xd6>
		{
			cprintf_colored(TEXT_TESTERR_CLR, "\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	68 e4 21 80 00       	push   $0x8021e4
  8000fc:	6a 0c                	push   $0xc
  8000fe:	e8 3e 06 00 00       	call   800741 <cprintf_colored>
  800103:	83 c4 10             	add    $0x10,%esp
			numOfSlaves = i;
  800106:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			break;
  80010c:	eb 19                	jmp    800127 <_main+0xef>
		}
		sys_run_env(id);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 d4             	pushl  -0x2c(%ebp)
  800114:	e8 80 19 00 00       	call   801a99 <sys_run_env>
  800119:	83 c4 10             	add    $0x10,%esp
	readline("Enter the number of Slave Programs: ", slavesCnt);
	int numOfSlaves = strtol(slavesCnt, NULL, 10);

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  80011c:	ff 45 e0             	incl   -0x20(%ebp)
  80011f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800122:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800125:	7c 8e                	jl     8000b5 <_main+0x7d>
		}
		sys_run_env(id);
	}

	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
  800127:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	char cmd1[64] = "__GetChanQueueSize__";
  80012e:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800131:	bb 36 23 80 00       	mov    $0x802336,%ebx
  800136:	ba 15 00 00 00       	mov    $0x15,%edx
  80013b:	89 c7                	mov    %eax,%edi
  80013d:	89 de                	mov    %ebx,%esi
  80013f:	89 d1                	mov    %edx,%ecx
  800141:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800143:	8d 55 99             	lea    -0x67(%ebp),%edx
  800146:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  80014b:	b0 00                	mov    $0x0,%al
  80014d:	89 d7                	mov    %edx,%edi
  80014f:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd1, (uint32)(&numOfBlockedProcesses));
  800151:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800154:	83 ec 08             	sub    $0x8,%esp
  800157:	50                   	push   %eax
  800158:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80015b:	50                   	push   %eax
  80015c:	e8 be 1b 00 00       	call   801d1f <sys_utilities>
  800161:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  800164:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	while (numOfBlockedProcesses != numOfSlaves)
  80016b:	eb 75                	jmp    8001e2 <_main+0x1aa>
	{
		env_sleep(5000);
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 88 13 00 00       	push   $0x1388
  800175:	e8 32 1c 00 00       	call   801dac <env_sleep>
  80017a:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  80017d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800180:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800183:	75 1b                	jne    8001a0 <_main+0x168>
		{
			panic("%~test channels failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves, numOfBlockedProcesses);
  800185:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	50                   	push   %eax
  80018c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80018f:	68 3c 22 80 00       	push   $0x80223c
  800194:	6a 2a                	push   $0x2a
  800196:	68 95 22 80 00       	push   $0x802295
  80019b:	e8 a6 02 00 00       	call   800446 <_panic>
		}
		char cmd2[64] = "__GetChanQueueSize__";
  8001a0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001a6:	bb 36 23 80 00       	mov    $0x802336,%ebx
  8001ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8001b0:	89 c7                	mov    %eax,%edi
  8001b2:	89 de                	mov    %ebx,%esi
  8001b4:	89 d1                	mov    %edx,%ecx
  8001b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001b8:	8d 95 19 ff ff ff    	lea    -0xe7(%ebp),%edx
  8001be:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  8001c3:	b0 00                	mov    $0x0,%al
  8001c5:	89 d7                	mov    %edx,%edi
  8001c7:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
  8001c9:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	50                   	push   %eax
  8001d0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001d6:	50                   	push   %eax
  8001d7:	e8 43 1b 00 00       	call   801d1f <sys_utilities>
  8001dc:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  8001df:	ff 45 dc             	incl   -0x24(%ebp)
	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
	char cmd1[64] = "__GetChanQueueSize__";
	sys_utilities(cmd1, (uint32)(&numOfBlockedProcesses));
	int cnt = 0;
	while (numOfBlockedProcesses != numOfSlaves)
  8001e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001e5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001e8:	75 83                	jne    80016d <_main+0x135>
		char cmd2[64] = "__GetChanQueueSize__";
		sys_utilities(cmd2, (uint32)(&numOfBlockedProcesses));
		cnt++ ;
	}

	rsttst();
  8001ea:	e8 d8 19 00 00       	call   801bc7 <rsttst>

	//Wakeup all
	char cmd3[64] = "__WakeupAll__";
  8001ef:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  8001f5:	bb 76 23 80 00       	mov    $0x802376,%ebx
  8001fa:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ff:	89 c7                	mov    %eax,%edi
  800201:	89 de                	mov    %ebx,%esi
  800203:	89 d1                	mov    %edx,%ecx
  800205:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800207:	8d 95 52 ff ff ff    	lea    -0xae(%ebp),%edx
  80020d:	b9 32 00 00 00       	mov    $0x32,%ecx
  800212:	b0 00                	mov    $0x0,%al
  800214:	89 d7                	mov    %edx,%edi
  800216:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(cmd3, 0);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	6a 00                	push   $0x0
  80021d:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  800223:	50                   	push   %eax
  800224:	e8 f6 1a 00 00       	call   801d1f <sys_utilities>
  800229:	83 c4 10             	add    $0x10,%esp

	//Wait until all slave finished
	cnt = 0;
  80022c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	while (gettst() != numOfSlaves)
  800233:	eb 2f                	jmp    800264 <_main+0x22c>
	{
		env_sleep(5000);
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	68 88 13 00 00       	push   $0x1388
  80023d:	e8 6a 1b 00 00       	call   801dac <env_sleep>
  800242:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800245:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800248:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80024b:	75 14                	jne    800261 <_main+0x229>
		{
			panic("%~test channels failed! not all slaves finished");
  80024d:	83 ec 04             	sub    $0x4,%esp
  800250:	68 b0 22 80 00       	push   $0x8022b0
  800255:	6a 3e                	push   $0x3e
  800257:	68 95 22 80 00       	push   $0x802295
  80025c:	e8 e5 01 00 00       	call   800446 <_panic>
		}
		cnt++ ;
  800261:	ff 45 dc             	incl   -0x24(%ebp)
	char cmd3[64] = "__WakeupAll__";
	sys_utilities(cmd3, 0);

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves)
  800264:	e8 d8 19 00 00       	call   801c41 <gettst>
  800269:	89 c2                	mov    %eax,%edx
  80026b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80026e:	39 c2                	cmp    %eax,%edx
  800270:	75 c3                	jne    800235 <_main+0x1fd>
			panic("%~test channels failed! not all slaves finished");
		}
		cnt++ ;
	}

	cprintf_colored(TEXT_light_green, "%~\n\nCongratulations!! Test of Channel (sleep & wakeup ALL) completed successfully!!\n\n");
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	68 e0 22 80 00       	push   $0x8022e0
  80027a:	6a 0a                	push   $0xa
  80027c:	e8 c0 04 00 00       	call   800741 <cprintf_colored>
  800281:	83 c4 10             	add    $0x10,%esp

	return;
  800284:	90                   	nop
}
  800285:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800288:	5b                   	pop    %ebx
  800289:	5e                   	pop    %esi
  80028a:	5f                   	pop    %edi
  80028b:	5d                   	pop    %ebp
  80028c:	c3                   	ret    

0080028d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	57                   	push   %edi
  800291:	56                   	push   %esi
  800292:	53                   	push   %ebx
  800293:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800296:	e8 4e 18 00 00       	call   801ae9 <sys_getenvindex>
  80029b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80029e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a1:	89 d0                	mov    %edx,%eax
  8002a3:	c1 e0 02             	shl    $0x2,%eax
  8002a6:	01 d0                	add    %edx,%eax
  8002a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002af:	01 d0                	add    %edx,%eax
  8002b1:	89 c2                	mov    %eax,%edx
  8002b3:	c1 e2 04             	shl    $0x4,%edx
  8002b6:	29 c2                	sub    %eax,%edx
  8002b8:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002bf:	89 c2                	mov    %eax,%edx
  8002c1:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002c7:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d1:	8a 40 20             	mov    0x20(%eax),%al
  8002d4:	84 c0                	test   %al,%al
  8002d6:	74 0d                	je     8002e5 <libmain+0x58>
		binaryname = myEnv->prog_name;
  8002d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002dd:	83 c0 20             	add    $0x20,%eax
  8002e0:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e9:	7e 0a                	jle    8002f5 <libmain+0x68>
		binaryname = argv[0];
  8002eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ee:	8b 00                	mov    (%eax),%eax
  8002f0:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	ff 75 0c             	pushl  0xc(%ebp)
  8002fb:	ff 75 08             	pushl  0x8(%ebp)
  8002fe:	e8 35 fd ff ff       	call   800038 <_main>
  800303:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800306:	a1 00 30 80 00       	mov    0x803000,%eax
  80030b:	85 c0                	test   %eax,%eax
  80030d:	0f 84 01 01 00 00    	je     800414 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800313:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800319:	bb b0 24 80 00       	mov    $0x8024b0,%ebx
  80031e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800323:	89 c7                	mov    %eax,%edi
  800325:	89 de                	mov    %ebx,%esi
  800327:	89 d1                	mov    %edx,%ecx
  800329:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80032b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80032e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800333:	b0 00                	mov    $0x0,%al
  800335:	89 d7                	mov    %edx,%edi
  800337:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800339:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800340:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	50                   	push   %eax
  800347:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	e8 cc 19 00 00       	call   801d1f <sys_utilities>
  800353:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800356:	e8 15 15 00 00       	call   801870 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80035b:	83 ec 0c             	sub    $0xc,%esp
  80035e:	68 d0 23 80 00       	push   $0x8023d0
  800363:	e8 ac 03 00 00       	call   800714 <cprintf>
  800368:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80036b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036e:	85 c0                	test   %eax,%eax
  800370:	74 18                	je     80038a <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800372:	e8 c6 19 00 00       	call   801d3d <sys_get_optimal_num_faults>
  800377:	83 ec 08             	sub    $0x8,%esp
  80037a:	50                   	push   %eax
  80037b:	68 f8 23 80 00       	push   $0x8023f8
  800380:	e8 8f 03 00 00       	call   800714 <cprintf>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	eb 59                	jmp    8003e3 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80038a:	a1 20 30 80 00       	mov    0x803020,%eax
  80038f:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800395:	a1 20 30 80 00       	mov    0x803020,%eax
  80039a:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003a0:	83 ec 04             	sub    $0x4,%esp
  8003a3:	52                   	push   %edx
  8003a4:	50                   	push   %eax
  8003a5:	68 1c 24 80 00       	push   $0x80241c
  8003aa:	e8 65 03 00 00       	call   800714 <cprintf>
  8003af:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b7:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8003bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c2:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8003c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cd:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8003d3:	51                   	push   %ecx
  8003d4:	52                   	push   %edx
  8003d5:	50                   	push   %eax
  8003d6:	68 44 24 80 00       	push   $0x802444
  8003db:	e8 34 03 00 00       	call   800714 <cprintf>
  8003e0:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e8:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	50                   	push   %eax
  8003f2:	68 9c 24 80 00       	push   $0x80249c
  8003f7:	e8 18 03 00 00       	call   800714 <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003ff:	83 ec 0c             	sub    $0xc,%esp
  800402:	68 d0 23 80 00       	push   $0x8023d0
  800407:	e8 08 03 00 00       	call   800714 <cprintf>
  80040c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80040f:	e8 76 14 00 00       	call   80188a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800414:	e8 1f 00 00 00       	call   800438 <exit>
}
  800419:	90                   	nop
  80041a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041d:	5b                   	pop    %ebx
  80041e:	5e                   	pop    %esi
  80041f:	5f                   	pop    %edi
  800420:	5d                   	pop    %ebp
  800421:	c3                   	ret    

00800422 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800428:	83 ec 0c             	sub    $0xc,%esp
  80042b:	6a 00                	push   $0x0
  80042d:	e8 83 16 00 00       	call   801ab5 <sys_destroy_env>
  800432:	83 c4 10             	add    $0x10,%esp
}
  800435:	90                   	nop
  800436:	c9                   	leave  
  800437:	c3                   	ret    

00800438 <exit>:

void
exit(void)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80043e:	e8 d8 16 00 00       	call   801b1b <sys_exit_env>
}
  800443:	90                   	nop
  800444:	c9                   	leave  
  800445:	c3                   	ret    

00800446 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80044c:	8d 45 10             	lea    0x10(%ebp),%eax
  80044f:	83 c0 04             	add    $0x4,%eax
  800452:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800455:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80045a:	85 c0                	test   %eax,%eax
  80045c:	74 16                	je     800474 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80045e:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	50                   	push   %eax
  800467:	68 14 25 80 00       	push   $0x802514
  80046c:	e8 a3 02 00 00       	call   800714 <cprintf>
  800471:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800474:	a1 04 30 80 00       	mov    0x803004,%eax
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	ff 75 0c             	pushl  0xc(%ebp)
  80047f:	ff 75 08             	pushl  0x8(%ebp)
  800482:	50                   	push   %eax
  800483:	68 1c 25 80 00       	push   $0x80251c
  800488:	6a 74                	push   $0x74
  80048a:	e8 b2 02 00 00       	call   800741 <cprintf_colored>
  80048f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800492:	8b 45 10             	mov    0x10(%ebp),%eax
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	ff 75 f4             	pushl  -0xc(%ebp)
  80049b:	50                   	push   %eax
  80049c:	e8 04 02 00 00       	call   8006a5 <vcprintf>
  8004a1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	6a 00                	push   $0x0
  8004a9:	68 44 25 80 00       	push   $0x802544
  8004ae:	e8 f2 01 00 00       	call   8006a5 <vcprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004b6:	e8 7d ff ff ff       	call   800438 <exit>

	// should not return here
	while (1) ;
  8004bb:	eb fe                	jmp    8004bb <_panic+0x75>

008004bd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	74 14                	je     8004e9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004d5:	83 ec 04             	sub    $0x4,%esp
  8004d8:	68 48 25 80 00       	push   $0x802548
  8004dd:	6a 26                	push   $0x26
  8004df:	68 94 25 80 00       	push   $0x802594
  8004e4:	e8 5d ff ff ff       	call   800446 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004f7:	e9 c5 00 00 00       	jmp    8005c1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800506:	8b 45 08             	mov    0x8(%ebp),%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	85 c0                	test   %eax,%eax
  80050f:	75 08                	jne    800519 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800511:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800514:	e9 a5 00 00 00       	jmp    8005be <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800519:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800520:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800527:	eb 69                	jmp    800592 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800529:	a1 20 30 80 00       	mov    0x803020,%eax
  80052e:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800534:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800537:	89 d0                	mov    %edx,%eax
  800539:	01 c0                	add    %eax,%eax
  80053b:	01 d0                	add    %edx,%eax
  80053d:	c1 e0 03             	shl    $0x3,%eax
  800540:	01 c8                	add    %ecx,%eax
  800542:	8a 40 04             	mov    0x4(%eax),%al
  800545:	84 c0                	test   %al,%al
  800547:	75 46                	jne    80058f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800549:	a1 20 30 80 00       	mov    0x803020,%eax
  80054e:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800554:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800557:	89 d0                	mov    %edx,%eax
  800559:	01 c0                	add    %eax,%eax
  80055b:	01 d0                	add    %edx,%eax
  80055d:	c1 e0 03             	shl    $0x3,%eax
  800560:	01 c8                	add    %ecx,%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800567:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80056a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80056f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800574:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	01 c8                	add    %ecx,%eax
  800580:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800582:	39 c2                	cmp    %eax,%edx
  800584:	75 09                	jne    80058f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800586:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80058d:	eb 15                	jmp    8005a4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058f:	ff 45 e8             	incl   -0x18(%ebp)
  800592:	a1 20 30 80 00       	mov    0x803020,%eax
  800597:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80059d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a0:	39 c2                	cmp    %eax,%edx
  8005a2:	77 85                	ja     800529 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005a8:	75 14                	jne    8005be <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005aa:	83 ec 04             	sub    $0x4,%esp
  8005ad:	68 a0 25 80 00       	push   $0x8025a0
  8005b2:	6a 3a                	push   $0x3a
  8005b4:	68 94 25 80 00       	push   $0x802594
  8005b9:	e8 88 fe ff ff       	call   800446 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005be:	ff 45 f0             	incl   -0x10(%ebp)
  8005c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005c7:	0f 8c 2f ff ff ff    	jl     8004fc <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005db:	eb 26                	jmp    800603 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e2:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8005e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005eb:	89 d0                	mov    %edx,%eax
  8005ed:	01 c0                	add    %eax,%eax
  8005ef:	01 d0                	add    %edx,%eax
  8005f1:	c1 e0 03             	shl    $0x3,%eax
  8005f4:	01 c8                	add    %ecx,%eax
  8005f6:	8a 40 04             	mov    0x4(%eax),%al
  8005f9:	3c 01                	cmp    $0x1,%al
  8005fb:	75 03                	jne    800600 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005fd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800600:	ff 45 e0             	incl   -0x20(%ebp)
  800603:	a1 20 30 80 00       	mov    0x803020,%eax
  800608:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80060e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800611:	39 c2                	cmp    %eax,%edx
  800613:	77 c8                	ja     8005dd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800618:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80061b:	74 14                	je     800631 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80061d:	83 ec 04             	sub    $0x4,%esp
  800620:	68 f4 25 80 00       	push   $0x8025f4
  800625:	6a 44                	push   $0x44
  800627:	68 94 25 80 00       	push   $0x802594
  80062c:	e8 15 fe ff ff       	call   800446 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800631:	90                   	nop
  800632:	c9                   	leave  
  800633:	c3                   	ret    

00800634 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	53                   	push   %ebx
  800638:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80063b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	8d 48 01             	lea    0x1(%eax),%ecx
  800643:	8b 55 0c             	mov    0xc(%ebp),%edx
  800646:	89 0a                	mov    %ecx,(%edx)
  800648:	8b 55 08             	mov    0x8(%ebp),%edx
  80064b:	88 d1                	mov    %dl,%cl
  80064d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800650:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800654:	8b 45 0c             	mov    0xc(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	3d ff 00 00 00       	cmp    $0xff,%eax
  80065e:	75 30                	jne    800690 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800660:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800666:	a0 44 30 80 00       	mov    0x803044,%al
  80066b:	0f b6 c0             	movzbl %al,%eax
  80066e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800671:	8b 09                	mov    (%ecx),%ecx
  800673:	89 cb                	mov    %ecx,%ebx
  800675:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800678:	83 c1 08             	add    $0x8,%ecx
  80067b:	52                   	push   %edx
  80067c:	50                   	push   %eax
  80067d:	53                   	push   %ebx
  80067e:	51                   	push   %ecx
  80067f:	e8 a8 11 00 00       	call   80182c <sys_cputs>
  800684:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800690:	8b 45 0c             	mov    0xc(%ebp),%eax
  800693:	8b 40 04             	mov    0x4(%eax),%eax
  800696:	8d 50 01             	lea    0x1(%eax),%edx
  800699:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80069f:	90                   	nop
  8006a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006b5:	00 00 00 
	b.cnt = 0;
  8006b8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006bf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	ff 75 08             	pushl  0x8(%ebp)
  8006c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ce:	50                   	push   %eax
  8006cf:	68 34 06 80 00       	push   $0x800634
  8006d4:	e8 5a 02 00 00       	call   800933 <vprintfmt>
  8006d9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006dc:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006e2:	a0 44 30 80 00       	mov    0x803044,%al
  8006e7:	0f b6 c0             	movzbl %al,%eax
  8006ea:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006f0:	52                   	push   %edx
  8006f1:	50                   	push   %eax
  8006f2:	51                   	push   %ecx
  8006f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f9:	83 c0 08             	add    $0x8,%eax
  8006fc:	50                   	push   %eax
  8006fd:	e8 2a 11 00 00       	call   80182c <sys_cputs>
  800702:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800705:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80070c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800712:	c9                   	leave  
  800713:	c3                   	ret    

00800714 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80071a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800721:	8d 45 0c             	lea    0xc(%ebp),%eax
  800724:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	ff 75 f4             	pushl  -0xc(%ebp)
  800730:	50                   	push   %eax
  800731:	e8 6f ff ff ff       	call   8006a5 <vcprintf>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80073c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80073f:	c9                   	leave  
  800740:	c3                   	ret    

00800741 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800747:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	c1 e0 08             	shl    $0x8,%eax
  800754:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800759:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075c:	83 c0 04             	add    $0x4,%eax
  80075f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800762:	8b 45 0c             	mov    0xc(%ebp),%eax
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 f4             	pushl  -0xc(%ebp)
  80076b:	50                   	push   %eax
  80076c:	e8 34 ff ff ff       	call   8006a5 <vcprintf>
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800777:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80077e:	07 00 00 

	return cnt;
  800781:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800784:	c9                   	leave  
  800785:	c3                   	ret    

00800786 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80078c:	e8 df 10 00 00       	call   801870 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800791:	8d 45 0c             	lea    0xc(%ebp),%eax
  800794:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a0:	50                   	push   %eax
  8007a1:	e8 ff fe ff ff       	call   8006a5 <vcprintf>
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007ac:	e8 d9 10 00 00       	call   80188a <sys_unlock_cons>
	return cnt;
  8007b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    

008007b6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	53                   	push   %ebx
  8007ba:	83 ec 14             	sub    $0x14,%esp
  8007bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007c9:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d4:	77 55                	ja     80082b <printnum+0x75>
  8007d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d9:	72 05                	jb     8007e0 <printnum+0x2a>
  8007db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007de:	77 4b                	ja     80082b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007e3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ee:	52                   	push   %edx
  8007ef:	50                   	push   %eax
  8007f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8007f6:	e8 ad 16 00 00       	call   801ea8 <__udivdi3>
  8007fb:	83 c4 10             	add    $0x10,%esp
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	ff 75 20             	pushl  0x20(%ebp)
  800804:	53                   	push   %ebx
  800805:	ff 75 18             	pushl  0x18(%ebp)
  800808:	52                   	push   %edx
  800809:	50                   	push   %eax
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	ff 75 08             	pushl  0x8(%ebp)
  800810:	e8 a1 ff ff ff       	call   8007b6 <printnum>
  800815:	83 c4 20             	add    $0x20,%esp
  800818:	eb 1a                	jmp    800834 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	ff 75 0c             	pushl  0xc(%ebp)
  800820:	ff 75 20             	pushl  0x20(%ebp)
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80082b:	ff 4d 1c             	decl   0x1c(%ebp)
  80082e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800832:	7f e6                	jg     80081a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800834:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800837:	bb 00 00 00 00       	mov    $0x0,%ebx
  80083c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800842:	53                   	push   %ebx
  800843:	51                   	push   %ecx
  800844:	52                   	push   %edx
  800845:	50                   	push   %eax
  800846:	e8 6d 17 00 00       	call   801fb8 <__umoddi3>
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	05 54 28 80 00       	add    $0x802854,%eax
  800853:	8a 00                	mov    (%eax),%al
  800855:	0f be c0             	movsbl %al,%eax
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	ff 75 0c             	pushl  0xc(%ebp)
  80085e:	50                   	push   %eax
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	ff d0                	call   *%eax
  800864:	83 c4 10             	add    $0x10,%esp
}
  800867:	90                   	nop
  800868:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086b:	c9                   	leave  
  80086c:	c3                   	ret    

0080086d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800870:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800874:	7e 1c                	jle    800892 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	8d 50 08             	lea    0x8(%eax),%edx
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	89 10                	mov    %edx,(%eax)
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	8b 00                	mov    (%eax),%eax
  800888:	83 e8 08             	sub    $0x8,%eax
  80088b:	8b 50 04             	mov    0x4(%eax),%edx
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	eb 40                	jmp    8008d2 <getuint+0x65>
	else if (lflag)
  800892:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800896:	74 1e                	je     8008b6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	8b 00                	mov    (%eax),%eax
  80089d:	8d 50 04             	lea    0x4(%eax),%edx
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	89 10                	mov    %edx,(%eax)
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	83 e8 04             	sub    $0x4,%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b4:	eb 1c                	jmp    8008d2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	8d 50 04             	lea    0x4(%eax),%edx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	89 10                	mov    %edx,(%eax)
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	83 e8 04             	sub    $0x4,%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    

008008d4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008db:	7e 1c                	jle    8008f9 <getint+0x25>
		return va_arg(*ap, long long);
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	8d 50 08             	lea    0x8(%eax),%edx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	89 10                	mov    %edx,(%eax)
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	83 e8 08             	sub    $0x8,%eax
  8008f2:	8b 50 04             	mov    0x4(%eax),%edx
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	eb 38                	jmp    800931 <getint+0x5d>
	else if (lflag)
  8008f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008fd:	74 1a                	je     800919 <getint+0x45>
		return va_arg(*ap, long);
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	8d 50 04             	lea    0x4(%eax),%edx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	89 10                	mov    %edx,(%eax)
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	83 e8 04             	sub    $0x4,%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	99                   	cltd   
  800917:	eb 18                	jmp    800931 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	8d 50 04             	lea    0x4(%eax),%edx
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	89 10                	mov    %edx,(%eax)
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 e8 04             	sub    $0x4,%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	99                   	cltd   
}
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    

00800933 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	56                   	push   %esi
  800937:	53                   	push   %ebx
  800938:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093b:	eb 17                	jmp    800954 <vprintfmt+0x21>
			if (ch == '\0')
  80093d:	85 db                	test   %ebx,%ebx
  80093f:	0f 84 c1 03 00 00    	je     800d06 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	53                   	push   %ebx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800954:	8b 45 10             	mov    0x10(%ebp),%eax
  800957:	8d 50 01             	lea    0x1(%eax),%edx
  80095a:	89 55 10             	mov    %edx,0x10(%ebp)
  80095d:	8a 00                	mov    (%eax),%al
  80095f:	0f b6 d8             	movzbl %al,%ebx
  800962:	83 fb 25             	cmp    $0x25,%ebx
  800965:	75 d6                	jne    80093d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800967:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80096b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800972:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800979:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800980:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800987:	8b 45 10             	mov    0x10(%ebp),%eax
  80098a:	8d 50 01             	lea    0x1(%eax),%edx
  80098d:	89 55 10             	mov    %edx,0x10(%ebp)
  800990:	8a 00                	mov    (%eax),%al
  800992:	0f b6 d8             	movzbl %al,%ebx
  800995:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800998:	83 f8 5b             	cmp    $0x5b,%eax
  80099b:	0f 87 3d 03 00 00    	ja     800cde <vprintfmt+0x3ab>
  8009a1:	8b 04 85 78 28 80 00 	mov    0x802878(,%eax,4),%eax
  8009a8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009aa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ae:	eb d7                	jmp    800987 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009b4:	eb d1                	jmp    800987 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	c1 e0 02             	shl    $0x2,%eax
  8009c5:	01 d0                	add    %edx,%eax
  8009c7:	01 c0                	add    %eax,%eax
  8009c9:	01 d8                	add    %ebx,%eax
  8009cb:	83 e8 30             	sub    $0x30,%eax
  8009ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d4:	8a 00                	mov    (%eax),%al
  8009d6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009d9:	83 fb 2f             	cmp    $0x2f,%ebx
  8009dc:	7e 3e                	jle    800a1c <vprintfmt+0xe9>
  8009de:	83 fb 39             	cmp    $0x39,%ebx
  8009e1:	7f 39                	jg     800a1c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e6:	eb d5                	jmp    8009bd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009eb:	83 c0 04             	add    $0x4,%eax
  8009ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f4:	83 e8 04             	sub    $0x4,%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009fc:	eb 1f                	jmp    800a1d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a02:	79 83                	jns    800987 <vprintfmt+0x54>
				width = 0;
  800a04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a0b:	e9 77 ff ff ff       	jmp    800987 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a10:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a17:	e9 6b ff ff ff       	jmp    800987 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a1c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a21:	0f 89 60 ff ff ff    	jns    800987 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a34:	e9 4e ff ff ff       	jmp    800987 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a39:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a3c:	e9 46 ff ff ff       	jmp    800987 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a41:	8b 45 14             	mov    0x14(%ebp),%eax
  800a44:	83 c0 04             	add    $0x4,%eax
  800a47:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 e8 04             	sub    $0x4,%eax
  800a50:	8b 00                	mov    (%eax),%eax
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	50                   	push   %eax
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	ff d0                	call   *%eax
  800a5e:	83 c4 10             	add    $0x10,%esp
			break;
  800a61:	e9 9b 02 00 00       	jmp    800d01 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	83 c0 04             	add    $0x4,%eax
  800a6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a72:	83 e8 04             	sub    $0x4,%eax
  800a75:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a77:	85 db                	test   %ebx,%ebx
  800a79:	79 02                	jns    800a7d <vprintfmt+0x14a>
				err = -err;
  800a7b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a7d:	83 fb 64             	cmp    $0x64,%ebx
  800a80:	7f 0b                	jg     800a8d <vprintfmt+0x15a>
  800a82:	8b 34 9d c0 26 80 00 	mov    0x8026c0(,%ebx,4),%esi
  800a89:	85 f6                	test   %esi,%esi
  800a8b:	75 19                	jne    800aa6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8d:	53                   	push   %ebx
  800a8e:	68 65 28 80 00       	push   $0x802865
  800a93:	ff 75 0c             	pushl  0xc(%ebp)
  800a96:	ff 75 08             	pushl  0x8(%ebp)
  800a99:	e8 70 02 00 00       	call   800d0e <printfmt>
  800a9e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa1:	e9 5b 02 00 00       	jmp    800d01 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa6:	56                   	push   %esi
  800aa7:	68 6e 28 80 00       	push   $0x80286e
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	ff 75 08             	pushl  0x8(%ebp)
  800ab2:	e8 57 02 00 00       	call   800d0e <printfmt>
  800ab7:	83 c4 10             	add    $0x10,%esp
			break;
  800aba:	e9 42 02 00 00       	jmp    800d01 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	83 c0 04             	add    $0x4,%eax
  800ac5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  800acb:	83 e8 04             	sub    $0x4,%eax
  800ace:	8b 30                	mov    (%eax),%esi
  800ad0:	85 f6                	test   %esi,%esi
  800ad2:	75 05                	jne    800ad9 <vprintfmt+0x1a6>
				p = "(null)";
  800ad4:	be 71 28 80 00       	mov    $0x802871,%esi
			if (width > 0 && padc != '-')
  800ad9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800add:	7e 6d                	jle    800b4c <vprintfmt+0x219>
  800adf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ae3:	74 67                	je     800b4c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae8:	83 ec 08             	sub    $0x8,%esp
  800aeb:	50                   	push   %eax
  800aec:	56                   	push   %esi
  800aed:	e8 26 05 00 00       	call   801018 <strnlen>
  800af2:	83 c4 10             	add    $0x10,%esp
  800af5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800af8:	eb 16                	jmp    800b10 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800afa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	ff 75 0c             	pushl  0xc(%ebp)
  800b04:	50                   	push   %eax
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	ff d0                	call   *%eax
  800b0a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b14:	7f e4                	jg     800afa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b16:	eb 34                	jmp    800b4c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b18:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b1c:	74 1c                	je     800b3a <vprintfmt+0x207>
  800b1e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b21:	7e 05                	jle    800b28 <vprintfmt+0x1f5>
  800b23:	83 fb 7e             	cmp    $0x7e,%ebx
  800b26:	7e 12                	jle    800b3a <vprintfmt+0x207>
					putch('?', putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	6a 3f                	push   $0x3f
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
  800b38:	eb 0f                	jmp    800b49 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	53                   	push   %ebx
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	ff d0                	call   *%eax
  800b46:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b49:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4c:	89 f0                	mov    %esi,%eax
  800b4e:	8d 70 01             	lea    0x1(%eax),%esi
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	0f be d8             	movsbl %al,%ebx
  800b56:	85 db                	test   %ebx,%ebx
  800b58:	74 24                	je     800b7e <vprintfmt+0x24b>
  800b5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5e:	78 b8                	js     800b18 <vprintfmt+0x1e5>
  800b60:	ff 4d e0             	decl   -0x20(%ebp)
  800b63:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b67:	79 af                	jns    800b18 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b69:	eb 13                	jmp    800b7e <vprintfmt+0x24b>
				putch(' ', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	6a 20                	push   $0x20
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	ff d0                	call   *%eax
  800b78:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b82:	7f e7                	jg     800b6b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b84:	e9 78 01 00 00       	jmp    800d01 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b89:	83 ec 08             	sub    $0x8,%esp
  800b8c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b8f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b92:	50                   	push   %eax
  800b93:	e8 3c fd ff ff       	call   8008d4 <getint>
  800b98:	83 c4 10             	add    $0x10,%esp
  800b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba7:	85 d2                	test   %edx,%edx
  800ba9:	79 23                	jns    800bce <vprintfmt+0x29b>
				putch('-', putdat);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	6a 2d                	push   $0x2d
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	ff d0                	call   *%eax
  800bb8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc1:	f7 d8                	neg    %eax
  800bc3:	83 d2 00             	adc    $0x0,%edx
  800bc6:	f7 da                	neg    %edx
  800bc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd5:	e9 bc 00 00 00       	jmp    800c96 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 e8             	pushl  -0x18(%ebp)
  800be0:	8d 45 14             	lea    0x14(%ebp),%eax
  800be3:	50                   	push   %eax
  800be4:	e8 84 fc ff ff       	call   80086d <getuint>
  800be9:	83 c4 10             	add    $0x10,%esp
  800bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bf2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf9:	e9 98 00 00 00       	jmp    800c96 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bfe:	83 ec 08             	sub    $0x8,%esp
  800c01:	ff 75 0c             	pushl  0xc(%ebp)
  800c04:	6a 58                	push   $0x58
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	ff d0                	call   *%eax
  800c0b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c0e:	83 ec 08             	sub    $0x8,%esp
  800c11:	ff 75 0c             	pushl  0xc(%ebp)
  800c14:	6a 58                	push   $0x58
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c1e:	83 ec 08             	sub    $0x8,%esp
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	6a 58                	push   $0x58
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	ff d0                	call   *%eax
  800c2b:	83 c4 10             	add    $0x10,%esp
			break;
  800c2e:	e9 ce 00 00 00       	jmp    800d01 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c33:	83 ec 08             	sub    $0x8,%esp
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	6a 30                	push   $0x30
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	ff d0                	call   *%eax
  800c40:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c43:	83 ec 08             	sub    $0x8,%esp
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	6a 78                	push   $0x78
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	ff d0                	call   *%eax
  800c50:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c53:	8b 45 14             	mov    0x14(%ebp),%eax
  800c56:	83 c0 04             	add    $0x4,%eax
  800c59:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5f:	83 e8 04             	sub    $0x4,%eax
  800c62:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c6e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c75:	eb 1f                	jmp    800c96 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c77:	83 ec 08             	sub    $0x8,%esp
  800c7a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c80:	50                   	push   %eax
  800c81:	e8 e7 fb ff ff       	call   80086d <getuint>
  800c86:	83 c4 10             	add    $0x10,%esp
  800c89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c8f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c96:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9d:	83 ec 04             	sub    $0x4,%esp
  800ca0:	52                   	push   %edx
  800ca1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ca4:	50                   	push   %eax
  800ca5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca8:	ff 75 f0             	pushl  -0x10(%ebp)
  800cab:	ff 75 0c             	pushl  0xc(%ebp)
  800cae:	ff 75 08             	pushl  0x8(%ebp)
  800cb1:	e8 00 fb ff ff       	call   8007b6 <printnum>
  800cb6:	83 c4 20             	add    $0x20,%esp
			break;
  800cb9:	eb 46                	jmp    800d01 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	ff 75 0c             	pushl  0xc(%ebp)
  800cc1:	53                   	push   %ebx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	ff d0                	call   *%eax
  800cc7:	83 c4 10             	add    $0x10,%esp
			break;
  800cca:	eb 35                	jmp    800d01 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ccc:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cd3:	eb 2c                	jmp    800d01 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cd5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cdc:	eb 23                	jmp    800d01 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cde:	83 ec 08             	sub    $0x8,%esp
  800ce1:	ff 75 0c             	pushl  0xc(%ebp)
  800ce4:	6a 25                	push   $0x25
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	ff d0                	call   *%eax
  800ceb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cee:	ff 4d 10             	decl   0x10(%ebp)
  800cf1:	eb 03                	jmp    800cf6 <vprintfmt+0x3c3>
  800cf3:	ff 4d 10             	decl   0x10(%ebp)
  800cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf9:	48                   	dec    %eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	3c 25                	cmp    $0x25,%al
  800cfe:	75 f3                	jne    800cf3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d00:	90                   	nop
		}
	}
  800d01:	e9 35 fc ff ff       	jmp    80093b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d06:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d14:	8d 45 10             	lea    0x10(%ebp),%eax
  800d17:	83 c0 04             	add    $0x4,%eax
  800d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d20:	ff 75 f4             	pushl  -0xc(%ebp)
  800d23:	50                   	push   %eax
  800d24:	ff 75 0c             	pushl  0xc(%ebp)
  800d27:	ff 75 08             	pushl  0x8(%ebp)
  800d2a:	e8 04 fc ff ff       	call   800933 <vprintfmt>
  800d2f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d32:	90                   	nop
  800d33:	c9                   	leave  
  800d34:	c3                   	ret    

00800d35 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	8b 40 08             	mov    0x8(%eax),%eax
  800d3e:	8d 50 01             	lea    0x1(%eax),%edx
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4a:	8b 10                	mov    (%eax),%edx
  800d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4f:	8b 40 04             	mov    0x4(%eax),%eax
  800d52:	39 c2                	cmp    %eax,%edx
  800d54:	73 12                	jae    800d68 <sprintputch+0x33>
		*b->buf++ = ch;
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8b 00                	mov    (%eax),%eax
  800d5b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d61:	89 0a                	mov    %ecx,(%edx)
  800d63:	8b 55 08             	mov    0x8(%ebp),%edx
  800d66:	88 10                	mov    %dl,(%eax)
}
  800d68:	90                   	nop
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    

00800d6b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	01 d0                	add    %edx,%eax
  800d82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d90:	74 06                	je     800d98 <vsnprintf+0x2d>
  800d92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d96:	7f 07                	jg     800d9f <vsnprintf+0x34>
		return -E_INVAL;
  800d98:	b8 03 00 00 00       	mov    $0x3,%eax
  800d9d:	eb 20                	jmp    800dbf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d9f:	ff 75 14             	pushl  0x14(%ebp)
  800da2:	ff 75 10             	pushl  0x10(%ebp)
  800da5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800da8:	50                   	push   %eax
  800da9:	68 35 0d 80 00       	push   $0x800d35
  800dae:	e8 80 fb ff ff       	call   800933 <vprintfmt>
  800db3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dbf:	c9                   	leave  
  800dc0:	c3                   	ret    

00800dc1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dc7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dca:	83 c0 04             	add    $0x4,%eax
  800dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd6:	50                   	push   %eax
  800dd7:	ff 75 0c             	pushl  0xc(%ebp)
  800dda:	ff 75 08             	pushl  0x8(%ebp)
  800ddd:	e8 89 ff ff ff       	call   800d6b <vsnprintf>
  800de2:	83 c4 10             	add    $0x10,%esp
  800de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800deb:	c9                   	leave  
  800dec:	c3                   	ret    

00800ded <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800df3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df7:	74 13                	je     800e0c <readline+0x1f>
		cprintf("%s", prompt);
  800df9:	83 ec 08             	sub    $0x8,%esp
  800dfc:	ff 75 08             	pushl  0x8(%ebp)
  800dff:	68 e8 29 80 00       	push   $0x8029e8
  800e04:	e8 0b f9 ff ff       	call   800714 <cprintf>
  800e09:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	6a 00                	push   $0x0
  800e18:	e8 7f 10 00 00       	call   801e9c <iscons>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e23:	e8 61 10 00 00       	call   801e89 <getchar>
  800e28:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e2f:	79 22                	jns    800e53 <readline+0x66>
			if (c != -E_EOF)
  800e31:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e35:	0f 84 ad 00 00 00    	je     800ee8 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e3b:	83 ec 08             	sub    $0x8,%esp
  800e3e:	ff 75 ec             	pushl  -0x14(%ebp)
  800e41:	68 eb 29 80 00       	push   $0x8029eb
  800e46:	e8 c9 f8 ff ff       	call   800714 <cprintf>
  800e4b:	83 c4 10             	add    $0x10,%esp
			break;
  800e4e:	e9 95 00 00 00       	jmp    800ee8 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800e53:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e57:	7e 34                	jle    800e8d <readline+0xa0>
  800e59:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800e60:	7f 2b                	jg     800e8d <readline+0xa0>
			if (echoing)
  800e62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e66:	74 0e                	je     800e76 <readline+0x89>
				cputchar(c);
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	ff 75 ec             	pushl  -0x14(%ebp)
  800e6e:	e8 f7 0f 00 00       	call   801e6a <cputchar>
  800e73:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e79:	8d 50 01             	lea    0x1(%eax),%edx
  800e7c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800e7f:	89 c2                	mov    %eax,%edx
  800e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e84:	01 d0                	add    %edx,%eax
  800e86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e89:	88 10                	mov    %dl,(%eax)
  800e8b:	eb 56                	jmp    800ee3 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800e8d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800e91:	75 1f                	jne    800eb2 <readline+0xc5>
  800e93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800e97:	7e 19                	jle    800eb2 <readline+0xc5>
			if (echoing)
  800e99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e9d:	74 0e                	je     800ead <readline+0xc0>
				cputchar(c);
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	ff 75 ec             	pushl  -0x14(%ebp)
  800ea5:	e8 c0 0f 00 00       	call   801e6a <cputchar>
  800eaa:	83 c4 10             	add    $0x10,%esp

			i--;
  800ead:	ff 4d f4             	decl   -0xc(%ebp)
  800eb0:	eb 31                	jmp    800ee3 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800eb2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800eb6:	74 0a                	je     800ec2 <readline+0xd5>
  800eb8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800ebc:	0f 85 61 ff ff ff    	jne    800e23 <readline+0x36>
			if (echoing)
  800ec2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ec6:	74 0e                	je     800ed6 <readline+0xe9>
				cputchar(c);
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	ff 75 ec             	pushl  -0x14(%ebp)
  800ece:	e8 97 0f 00 00       	call   801e6a <cputchar>
  800ed3:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800ed6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	01 d0                	add    %edx,%eax
  800ede:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800ee1:	eb 06                	jmp    800ee9 <readline+0xfc>
		}
	}
  800ee3:	e9 3b ff ff ff       	jmp    800e23 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800ee8:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800ee9:	90                   	nop
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800ef2:	e8 79 09 00 00       	call   801870 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800ef7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800efb:	74 13                	je     800f10 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800efd:	83 ec 08             	sub    $0x8,%esp
  800f00:	ff 75 08             	pushl  0x8(%ebp)
  800f03:	68 e8 29 80 00       	push   $0x8029e8
  800f08:	e8 07 f8 ff ff       	call   800714 <cprintf>
  800f0d:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f17:	83 ec 0c             	sub    $0xc,%esp
  800f1a:	6a 00                	push   $0x0
  800f1c:	e8 7b 0f 00 00       	call   801e9c <iscons>
  800f21:	83 c4 10             	add    $0x10,%esp
  800f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f27:	e8 5d 0f 00 00       	call   801e89 <getchar>
  800f2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f33:	79 22                	jns    800f57 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f35:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f39:	0f 84 ad 00 00 00    	je     800fec <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	ff 75 ec             	pushl  -0x14(%ebp)
  800f45:	68 eb 29 80 00       	push   $0x8029eb
  800f4a:	e8 c5 f7 ff ff       	call   800714 <cprintf>
  800f4f:	83 c4 10             	add    $0x10,%esp
				break;
  800f52:	e9 95 00 00 00       	jmp    800fec <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800f57:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800f5b:	7e 34                	jle    800f91 <atomic_readline+0xa5>
  800f5d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800f64:	7f 2b                	jg     800f91 <atomic_readline+0xa5>
				if (echoing)
  800f66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f6a:	74 0e                	je     800f7a <atomic_readline+0x8e>
					cputchar(c);
  800f6c:	83 ec 0c             	sub    $0xc,%esp
  800f6f:	ff 75 ec             	pushl  -0x14(%ebp)
  800f72:	e8 f3 0e 00 00       	call   801e6a <cputchar>
  800f77:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7d:	8d 50 01             	lea    0x1(%eax),%edx
  800f80:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800f83:	89 c2                	mov    %eax,%edx
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	01 d0                	add    %edx,%eax
  800f8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f8d:	88 10                	mov    %dl,(%eax)
  800f8f:	eb 56                	jmp    800fe7 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800f91:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800f95:	75 1f                	jne    800fb6 <atomic_readline+0xca>
  800f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800f9b:	7e 19                	jle    800fb6 <atomic_readline+0xca>
				if (echoing)
  800f9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fa1:	74 0e                	je     800fb1 <atomic_readline+0xc5>
					cputchar(c);
  800fa3:	83 ec 0c             	sub    $0xc,%esp
  800fa6:	ff 75 ec             	pushl  -0x14(%ebp)
  800fa9:	e8 bc 0e 00 00       	call   801e6a <cputchar>
  800fae:	83 c4 10             	add    $0x10,%esp
				i--;
  800fb1:	ff 4d f4             	decl   -0xc(%ebp)
  800fb4:	eb 31                	jmp    800fe7 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800fb6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800fba:	74 0a                	je     800fc6 <atomic_readline+0xda>
  800fbc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800fc0:	0f 85 61 ff ff ff    	jne    800f27 <atomic_readline+0x3b>
				if (echoing)
  800fc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fca:	74 0e                	je     800fda <atomic_readline+0xee>
					cputchar(c);
  800fcc:	83 ec 0c             	sub    $0xc,%esp
  800fcf:	ff 75 ec             	pushl  -0x14(%ebp)
  800fd2:	e8 93 0e 00 00       	call   801e6a <cputchar>
  800fd7:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800fe5:	eb 06                	jmp    800fed <atomic_readline+0x101>
			}
		}
  800fe7:	e9 3b ff ff ff       	jmp    800f27 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800fec:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800fed:	e8 98 08 00 00       	call   80188a <sys_unlock_cons>
}
  800ff2:	90                   	nop
  800ff3:	c9                   	leave  
  800ff4:	c3                   	ret    

00800ff5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801002:	eb 06                	jmp    80100a <strlen+0x15>
		n++;
  801004:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801007:	ff 45 08             	incl   0x8(%ebp)
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	84 c0                	test   %al,%al
  801011:	75 f1                	jne    801004 <strlen+0xf>
		n++;
	return n;
  801013:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801025:	eb 09                	jmp    801030 <strnlen+0x18>
		n++;
  801027:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102a:	ff 45 08             	incl   0x8(%ebp)
  80102d:	ff 4d 0c             	decl   0xc(%ebp)
  801030:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801034:	74 09                	je     80103f <strnlen+0x27>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	84 c0                	test   %al,%al
  80103d:	75 e8                	jne    801027 <strnlen+0xf>
		n++;
	return n;
  80103f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801050:	90                   	nop
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8d 50 01             	lea    0x1(%eax),%edx
  801057:	89 55 08             	mov    %edx,0x8(%ebp)
  80105a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801060:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801063:	8a 12                	mov    (%edx),%dl
  801065:	88 10                	mov    %dl,(%eax)
  801067:	8a 00                	mov    (%eax),%al
  801069:	84 c0                	test   %al,%al
  80106b:	75 e4                	jne    801051 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80106d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80107e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801085:	eb 1f                	jmp    8010a6 <strncpy+0x34>
		*dst++ = *src;
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8d 50 01             	lea    0x1(%eax),%edx
  80108d:	89 55 08             	mov    %edx,0x8(%ebp)
  801090:	8b 55 0c             	mov    0xc(%ebp),%edx
  801093:	8a 12                	mov    (%edx),%dl
  801095:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	84 c0                	test   %al,%al
  80109e:	74 03                	je     8010a3 <strncpy+0x31>
			src++;
  8010a0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010a3:	ff 45 fc             	incl   -0x4(%ebp)
  8010a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ac:	72 d9                	jb     801087 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c3:	74 30                	je     8010f5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010c5:	eb 16                	jmp    8010dd <strlcpy+0x2a>
			*dst++ = *src++;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8d 50 01             	lea    0x1(%eax),%edx
  8010cd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010d9:	8a 12                	mov    (%edx),%dl
  8010db:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010dd:	ff 4d 10             	decl   0x10(%ebp)
  8010e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e4:	74 09                	je     8010ef <strlcpy+0x3c>
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	84 c0                	test   %al,%al
  8010ed:	75 d8                	jne    8010c7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fb:	29 c2                	sub    %eax,%edx
  8010fd:	89 d0                	mov    %edx,%eax
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801104:	eb 06                	jmp    80110c <strcmp+0xb>
		p++, q++;
  801106:	ff 45 08             	incl   0x8(%ebp)
  801109:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	84 c0                	test   %al,%al
  801113:	74 0e                	je     801123 <strcmp+0x22>
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8a 10                	mov    (%eax),%dl
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	38 c2                	cmp    %al,%dl
  801121:	74 e3                	je     801106 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	0f b6 d0             	movzbl %al,%edx
  80112b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	0f b6 c0             	movzbl %al,%eax
  801133:	29 c2                	sub    %eax,%edx
  801135:	89 d0                	mov    %edx,%eax
}
  801137:	5d                   	pop    %ebp
  801138:	c3                   	ret    

00801139 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80113c:	eb 09                	jmp    801147 <strncmp+0xe>
		n--, p++, q++;
  80113e:	ff 4d 10             	decl   0x10(%ebp)
  801141:	ff 45 08             	incl   0x8(%ebp)
  801144:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801147:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114b:	74 17                	je     801164 <strncmp+0x2b>
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	84 c0                	test   %al,%al
  801154:	74 0e                	je     801164 <strncmp+0x2b>
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 10                	mov    (%eax),%dl
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	38 c2                	cmp    %al,%dl
  801162:	74 da                	je     80113e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801164:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801168:	75 07                	jne    801171 <strncmp+0x38>
		return 0;
  80116a:	b8 00 00 00 00       	mov    $0x0,%eax
  80116f:	eb 14                	jmp    801185 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	0f b6 d0             	movzbl %al,%edx
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	0f b6 c0             	movzbl %al,%eax
  801181:	29 c2                	sub    %eax,%edx
  801183:	89 d0                	mov    %edx,%eax
}
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    

00801187 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 04             	sub    $0x4,%esp
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801193:	eb 12                	jmp    8011a7 <strchr+0x20>
		if (*s == c)
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80119d:	75 05                	jne    8011a4 <strchr+0x1d>
			return (char *) s;
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	eb 11                	jmp    8011b5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011a4:	ff 45 08             	incl   0x8(%ebp)
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	84 c0                	test   %al,%al
  8011ae:	75 e5                	jne    801195 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011c3:	eb 0d                	jmp    8011d2 <strfind+0x1b>
		if (*s == c)
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011cd:	74 0e                	je     8011dd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011cf:	ff 45 08             	incl   0x8(%ebp)
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	84 c0                	test   %al,%al
  8011d9:	75 ea                	jne    8011c5 <strfind+0xe>
  8011db:	eb 01                	jmp    8011de <strfind+0x27>
		if (*s == c)
			break;
  8011dd:	90                   	nop
	return (char *) s;
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011ef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011f3:	76 63                	jbe    801258 <memset+0x75>
		uint64 data_block = c;
  8011f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f8:	99                   	cltd   
  8011f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8011ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801202:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801205:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801209:	c1 e0 08             	shl    $0x8,%eax
  80120c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80120f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80121c:	c1 e0 10             	shl    $0x10,%eax
  80121f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801222:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801228:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122b:	89 c2                	mov    %eax,%edx
  80122d:	b8 00 00 00 00       	mov    $0x0,%eax
  801232:	09 45 f0             	or     %eax,-0x10(%ebp)
  801235:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801238:	eb 18                	jmp    801252 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80123a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80123d:	8d 41 08             	lea    0x8(%ecx),%eax
  801240:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801249:	89 01                	mov    %eax,(%ecx)
  80124b:	89 51 04             	mov    %edx,0x4(%ecx)
  80124e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801252:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801256:	77 e2                	ja     80123a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125c:	74 23                	je     801281 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80125e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801261:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801264:	eb 0e                	jmp    801274 <memset+0x91>
			*p8++ = (uint8)c;
  801266:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801269:	8d 50 01             	lea    0x1(%eax),%edx
  80126c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80126f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801272:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	8d 50 ff             	lea    -0x1(%eax),%edx
  80127a:	89 55 10             	mov    %edx,0x10(%ebp)
  80127d:	85 c0                	test   %eax,%eax
  80127f:	75 e5                	jne    801266 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801298:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80129c:	76 24                	jbe    8012c2 <memcpy+0x3c>
		while(n >= 8){
  80129e:	eb 1c                	jmp    8012bc <memcpy+0x36>
			*d64 = *s64;
  8012a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a3:	8b 50 04             	mov    0x4(%eax),%edx
  8012a6:	8b 00                	mov    (%eax),%eax
  8012a8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012ab:	89 01                	mov    %eax,(%ecx)
  8012ad:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8012b0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8012b4:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8012b8:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012bc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012c0:	77 de                	ja     8012a0 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c6:	74 31                	je     8012f9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012d4:	eb 16                	jmp    8012ec <memcpy+0x66>
			*d8++ = *s8++;
  8012d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d9:	8d 50 01             	lea    0x1(%eax),%edx
  8012dc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012e8:	8a 12                	mov    (%edx),%dl
  8012ea:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	75 dd                	jne    8012d6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801313:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801316:	73 50                	jae    801368 <memmove+0x6a>
  801318:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	01 d0                	add    %edx,%eax
  801320:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801323:	76 43                	jbe    801368 <memmove+0x6a>
		s += n;
  801325:	8b 45 10             	mov    0x10(%ebp),%eax
  801328:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80132b:	8b 45 10             	mov    0x10(%ebp),%eax
  80132e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801331:	eb 10                	jmp    801343 <memmove+0x45>
			*--d = *--s;
  801333:	ff 4d f8             	decl   -0x8(%ebp)
  801336:	ff 4d fc             	decl   -0x4(%ebp)
  801339:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133c:	8a 10                	mov    (%eax),%dl
  80133e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801341:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801343:	8b 45 10             	mov    0x10(%ebp),%eax
  801346:	8d 50 ff             	lea    -0x1(%eax),%edx
  801349:	89 55 10             	mov    %edx,0x10(%ebp)
  80134c:	85 c0                	test   %eax,%eax
  80134e:	75 e3                	jne    801333 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801350:	eb 23                	jmp    801375 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801352:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801355:	8d 50 01             	lea    0x1(%eax),%edx
  801358:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80135b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801361:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801364:	8a 12                	mov    (%edx),%dl
  801366:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136e:	89 55 10             	mov    %edx,0x10(%ebp)
  801371:	85 c0                	test   %eax,%eax
  801373:	75 dd                	jne    801352 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801386:	8b 45 0c             	mov    0xc(%ebp),%eax
  801389:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80138c:	eb 2a                	jmp    8013b8 <memcmp+0x3e>
		if (*s1 != *s2)
  80138e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801391:	8a 10                	mov    (%eax),%dl
  801393:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	38 c2                	cmp    %al,%dl
  80139a:	74 16                	je     8013b2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80139c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	0f b6 d0             	movzbl %al,%edx
  8013a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	0f b6 c0             	movzbl %al,%eax
  8013ac:	29 c2                	sub    %eax,%edx
  8013ae:	89 d0                	mov    %edx,%eax
  8013b0:	eb 18                	jmp    8013ca <memcmp+0x50>
		s1++, s2++;
  8013b2:	ff 45 fc             	incl   -0x4(%ebp)
  8013b5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013be:	89 55 10             	mov    %edx,0x10(%ebp)
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	75 c9                	jne    80138e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    

008013cc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d8:	01 d0                	add    %edx,%eax
  8013da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013dd:	eb 15                	jmp    8013f4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	0f b6 d0             	movzbl %al,%edx
  8013e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ea:	0f b6 c0             	movzbl %al,%eax
  8013ed:	39 c2                	cmp    %eax,%edx
  8013ef:	74 0d                	je     8013fe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013f1:	ff 45 08             	incl   0x8(%ebp)
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013fa:	72 e3                	jb     8013df <memfind+0x13>
  8013fc:	eb 01                	jmp    8013ff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013fe:	90                   	nop
	return (void *) s;
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80140a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801411:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801418:	eb 03                	jmp    80141d <strtol+0x19>
		s++;
  80141a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	3c 20                	cmp    $0x20,%al
  801424:	74 f4                	je     80141a <strtol+0x16>
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	3c 09                	cmp    $0x9,%al
  80142d:	74 eb                	je     80141a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	3c 2b                	cmp    $0x2b,%al
  801436:	75 05                	jne    80143d <strtol+0x39>
		s++;
  801438:	ff 45 08             	incl   0x8(%ebp)
  80143b:	eb 13                	jmp    801450 <strtol+0x4c>
	else if (*s == '-')
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	3c 2d                	cmp    $0x2d,%al
  801444:	75 0a                	jne    801450 <strtol+0x4c>
		s++, neg = 1;
  801446:	ff 45 08             	incl   0x8(%ebp)
  801449:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801450:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801454:	74 06                	je     80145c <strtol+0x58>
  801456:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80145a:	75 20                	jne    80147c <strtol+0x78>
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 30                	cmp    $0x30,%al
  801463:	75 17                	jne    80147c <strtol+0x78>
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	40                   	inc    %eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	3c 78                	cmp    $0x78,%al
  80146d:	75 0d                	jne    80147c <strtol+0x78>
		s += 2, base = 16;
  80146f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801473:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80147a:	eb 28                	jmp    8014a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80147c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801480:	75 15                	jne    801497 <strtol+0x93>
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	3c 30                	cmp    $0x30,%al
  801489:	75 0c                	jne    801497 <strtol+0x93>
		s++, base = 8;
  80148b:	ff 45 08             	incl   0x8(%ebp)
  80148e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801495:	eb 0d                	jmp    8014a4 <strtol+0xa0>
	else if (base == 0)
  801497:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80149b:	75 07                	jne    8014a4 <strtol+0xa0>
		base = 10;
  80149d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	3c 2f                	cmp    $0x2f,%al
  8014ab:	7e 19                	jle    8014c6 <strtol+0xc2>
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	8a 00                	mov    (%eax),%al
  8014b2:	3c 39                	cmp    $0x39,%al
  8014b4:	7f 10                	jg     8014c6 <strtol+0xc2>
			dig = *s - '0';
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	8a 00                	mov    (%eax),%al
  8014bb:	0f be c0             	movsbl %al,%eax
  8014be:	83 e8 30             	sub    $0x30,%eax
  8014c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c4:	eb 42                	jmp    801508 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8a 00                	mov    (%eax),%al
  8014cb:	3c 60                	cmp    $0x60,%al
  8014cd:	7e 19                	jle    8014e8 <strtol+0xe4>
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	3c 7a                	cmp    $0x7a,%al
  8014d6:	7f 10                	jg     8014e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	0f be c0             	movsbl %al,%eax
  8014e0:	83 e8 57             	sub    $0x57,%eax
  8014e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e6:	eb 20                	jmp    801508 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	3c 40                	cmp    $0x40,%al
  8014ef:	7e 39                	jle    80152a <strtol+0x126>
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	3c 5a                	cmp    $0x5a,%al
  8014f8:	7f 30                	jg     80152a <strtol+0x126>
			dig = *s - 'A' + 10;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	0f be c0             	movsbl %al,%eax
  801502:	83 e8 37             	sub    $0x37,%eax
  801505:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80150e:	7d 19                	jge    801529 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801510:	ff 45 08             	incl   0x8(%ebp)
  801513:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801516:	0f af 45 10          	imul   0x10(%ebp),%eax
  80151a:	89 c2                	mov    %eax,%edx
  80151c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151f:	01 d0                	add    %edx,%eax
  801521:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801524:	e9 7b ff ff ff       	jmp    8014a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801529:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80152a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80152e:	74 08                	je     801538 <strtol+0x134>
		*endptr = (char *) s;
  801530:	8b 45 0c             	mov    0xc(%ebp),%eax
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801538:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80153c:	74 07                	je     801545 <strtol+0x141>
  80153e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801541:	f7 d8                	neg    %eax
  801543:	eb 03                	jmp    801548 <strtol+0x144>
  801545:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <ltostr>:

void
ltostr(long value, char *str)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801550:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801557:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80155e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801562:	79 13                	jns    801577 <ltostr+0x2d>
	{
		neg = 1;
  801564:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80156b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801571:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801574:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80157f:	99                   	cltd   
  801580:	f7 f9                	idiv   %ecx
  801582:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801585:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801588:	8d 50 01             	lea    0x1(%eax),%edx
  80158b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80158e:	89 c2                	mov    %eax,%edx
  801590:	8b 45 0c             	mov    0xc(%ebp),%eax
  801593:	01 d0                	add    %edx,%eax
  801595:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801598:	83 c2 30             	add    $0x30,%edx
  80159b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80159d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015a5:	f7 e9                	imul   %ecx
  8015a7:	c1 fa 02             	sar    $0x2,%edx
  8015aa:	89 c8                	mov    %ecx,%eax
  8015ac:	c1 f8 1f             	sar    $0x1f,%eax
  8015af:	29 c2                	sub    %eax,%edx
  8015b1:	89 d0                	mov    %edx,%eax
  8015b3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8015b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015ba:	75 bb                	jne    801577 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c6:	48                   	dec    %eax
  8015c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015ce:	74 3d                	je     80160d <ltostr+0xc3>
		start = 1 ;
  8015d0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015d7:	eb 34                	jmp    80160d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	8a 00                	mov    (%eax),%al
  8015e3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ec:	01 c2                	add    %eax,%edx
  8015ee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f4:	01 c8                	add    %ecx,%eax
  8015f6:	8a 00                	mov    (%eax),%al
  8015f8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	01 c2                	add    %eax,%edx
  801602:	8a 45 eb             	mov    -0x15(%ebp),%al
  801605:	88 02                	mov    %al,(%edx)
		start++ ;
  801607:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80160a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801610:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801613:	7c c4                	jl     8015d9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801615:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161b:	01 d0                	add    %edx,%eax
  80161d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801620:	90                   	nop
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801629:	ff 75 08             	pushl  0x8(%ebp)
  80162c:	e8 c4 f9 ff ff       	call   800ff5 <strlen>
  801631:	83 c4 04             	add    $0x4,%esp
  801634:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801637:	ff 75 0c             	pushl  0xc(%ebp)
  80163a:	e8 b6 f9 ff ff       	call   800ff5 <strlen>
  80163f:	83 c4 04             	add    $0x4,%esp
  801642:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801645:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80164c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801653:	eb 17                	jmp    80166c <strcconcat+0x49>
		final[s] = str1[s] ;
  801655:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801658:	8b 45 10             	mov    0x10(%ebp),%eax
  80165b:	01 c2                	add    %eax,%edx
  80165d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	01 c8                	add    %ecx,%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801669:	ff 45 fc             	incl   -0x4(%ebp)
  80166c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801672:	7c e1                	jl     801655 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801674:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80167b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801682:	eb 1f                	jmp    8016a3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801684:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801687:	8d 50 01             	lea    0x1(%eax),%edx
  80168a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80168d:	89 c2                	mov    %eax,%edx
  80168f:	8b 45 10             	mov    0x10(%ebp),%eax
  801692:	01 c2                	add    %eax,%edx
  801694:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169a:	01 c8                	add    %ecx,%eax
  80169c:	8a 00                	mov    (%eax),%al
  80169e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016a0:	ff 45 f8             	incl   -0x8(%ebp)
  8016a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016a9:	7c d9                	jl     801684 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b1:	01 d0                	add    %edx,%eax
  8016b3:	c6 00 00             	movb   $0x0,(%eax)
}
  8016b6:	90                   	nop
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c8:	8b 00                	mov    (%eax),%eax
  8016ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d4:	01 d0                	add    %edx,%eax
  8016d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016dc:	eb 0c                	jmp    8016ea <strsplit+0x31>
			*string++ = 0;
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8d 50 01             	lea    0x1(%eax),%edx
  8016e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8016e7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	8a 00                	mov    (%eax),%al
  8016ef:	84 c0                	test   %al,%al
  8016f1:	74 18                	je     80170b <strsplit+0x52>
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	0f be c0             	movsbl %al,%eax
  8016fb:	50                   	push   %eax
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	e8 83 fa ff ff       	call   801187 <strchr>
  801704:	83 c4 08             	add    $0x8,%esp
  801707:	85 c0                	test   %eax,%eax
  801709:	75 d3                	jne    8016de <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	84 c0                	test   %al,%al
  801712:	74 5a                	je     80176e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801714:	8b 45 14             	mov    0x14(%ebp),%eax
  801717:	8b 00                	mov    (%eax),%eax
  801719:	83 f8 0f             	cmp    $0xf,%eax
  80171c:	75 07                	jne    801725 <strsplit+0x6c>
		{
			return 0;
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
  801723:	eb 66                	jmp    80178b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801725:	8b 45 14             	mov    0x14(%ebp),%eax
  801728:	8b 00                	mov    (%eax),%eax
  80172a:	8d 48 01             	lea    0x1(%eax),%ecx
  80172d:	8b 55 14             	mov    0x14(%ebp),%edx
  801730:	89 0a                	mov    %ecx,(%edx)
  801732:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801739:	8b 45 10             	mov    0x10(%ebp),%eax
  80173c:	01 c2                	add    %eax,%edx
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801743:	eb 03                	jmp    801748 <strsplit+0x8f>
			string++;
  801745:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	8a 00                	mov    (%eax),%al
  80174d:	84 c0                	test   %al,%al
  80174f:	74 8b                	je     8016dc <strsplit+0x23>
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8a 00                	mov    (%eax),%al
  801756:	0f be c0             	movsbl %al,%eax
  801759:	50                   	push   %eax
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	e8 25 fa ff ff       	call   801187 <strchr>
  801762:	83 c4 08             	add    $0x8,%esp
  801765:	85 c0                	test   %eax,%eax
  801767:	74 dc                	je     801745 <strsplit+0x8c>
			string++;
	}
  801769:	e9 6e ff ff ff       	jmp    8016dc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80176e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80176f:	8b 45 14             	mov    0x14(%ebp),%eax
  801772:	8b 00                	mov    (%eax),%eax
  801774:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80177b:	8b 45 10             	mov    0x10(%ebp),%eax
  80177e:	01 d0                	add    %edx,%eax
  801780:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801786:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801799:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017a0:	eb 4a                	jmp    8017ec <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	01 c2                	add    %eax,%edx
  8017aa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b0:	01 c8                	add    %ecx,%eax
  8017b2:	8a 00                	mov    (%eax),%al
  8017b4:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8017b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	3c 40                	cmp    $0x40,%al
  8017c2:	7e 25                	jle    8017e9 <str2lower+0x5c>
  8017c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 5a                	cmp    $0x5a,%al
  8017d0:	7f 17                	jg     8017e9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e0:	01 ca                	add    %ecx,%edx
  8017e2:	8a 12                	mov    (%edx),%dl
  8017e4:	83 c2 20             	add    $0x20,%edx
  8017e7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8017e9:	ff 45 fc             	incl   -0x4(%ebp)
  8017ec:	ff 75 0c             	pushl  0xc(%ebp)
  8017ef:	e8 01 f8 ff ff       	call   800ff5 <strlen>
  8017f4:	83 c4 04             	add    $0x4,%esp
  8017f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017fa:	7f a6                	jg     8017a2 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8017fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	57                   	push   %edi
  801805:	56                   	push   %esi
  801806:	53                   	push   %ebx
  801807:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801810:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801813:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801816:	8b 7d 18             	mov    0x18(%ebp),%edi
  801819:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80181c:	cd 30                	int    $0x30
  80181e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801821:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	5b                   	pop    %ebx
  801828:	5e                   	pop    %esi
  801829:	5f                   	pop    %edi
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    

0080182c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	8b 45 10             	mov    0x10(%ebp),%eax
  801835:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801838:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80183b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	6a 00                	push   $0x0
  801844:	51                   	push   %ecx
  801845:	52                   	push   %edx
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	50                   	push   %eax
  80184a:	6a 00                	push   $0x0
  80184c:	e8 b0 ff ff ff       	call   801801 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	90                   	nop
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_cgetc>:

int
sys_cgetc(void)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 02                	push   $0x2
  801866:	e8 96 ff ff ff       	call   801801 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 03                	push   $0x3
  80187f:	e8 7d ff ff ff       	call   801801 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	90                   	nop
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 04                	push   $0x4
  801899:	e8 63 ff ff ff       	call   801801 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	90                   	nop
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	52                   	push   %edx
  8018b4:	50                   	push   %eax
  8018b5:	6a 08                	push   $0x8
  8018b7:	e8 45 ff ff ff       	call   801801 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c6:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	56                   	push   %esi
  8018d6:	53                   	push   %ebx
  8018d7:	51                   	push   %ecx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	6a 09                	push   $0x9
  8018dc:	e8 20 ff ff ff       	call   801801 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e7:	5b                   	pop    %ebx
  8018e8:	5e                   	pop    %esi
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    

008018eb <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	ff 75 08             	pushl  0x8(%ebp)
  8018f9:	6a 0a                	push   $0xa
  8018fb:	e8 01 ff ff ff       	call   801801 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	ff 75 0c             	pushl  0xc(%ebp)
  801911:	ff 75 08             	pushl  0x8(%ebp)
  801914:	6a 0b                	push   $0xb
  801916:	e8 e6 fe ff ff       	call   801801 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 0c                	push   $0xc
  80192f:	e8 cd fe ff ff       	call   801801 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 0d                	push   $0xd
  801948:	e8 b4 fe ff ff       	call   801801 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 0e                	push   $0xe
  801961:	e8 9b fe ff ff       	call   801801 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 0f                	push   $0xf
  80197a:	e8 82 fe ff ff       	call   801801 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	6a 10                	push   $0x10
  801994:	e8 68 fe ff ff       	call   801801 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 11                	push   $0x11
  8019ad:	e8 4f fe ff ff       	call   801801 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	90                   	nop
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	50                   	push   %eax
  8019d1:	6a 01                	push   $0x1
  8019d3:	e8 29 fe ff ff       	call   801801 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	90                   	nop
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 14                	push   $0x14
  8019ed:	e8 0f fe ff ff       	call   801801 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	90                   	nop
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 04             	sub    $0x4,%esp
  8019fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801a01:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a04:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a07:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	6a 00                	push   $0x0
  801a10:	51                   	push   %ecx
  801a11:	52                   	push   %edx
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	50                   	push   %eax
  801a16:	6a 15                	push   $0x15
  801a18:	e8 e4 fd ff ff       	call   801801 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	52                   	push   %edx
  801a32:	50                   	push   %eax
  801a33:	6a 16                	push   $0x16
  801a35:	e8 c7 fd ff ff       	call   801801 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	51                   	push   %ecx
  801a50:	52                   	push   %edx
  801a51:	50                   	push   %eax
  801a52:	6a 17                	push   $0x17
  801a54:	e8 a8 fd ff ff       	call   801801 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	52                   	push   %edx
  801a6e:	50                   	push   %eax
  801a6f:	6a 18                	push   $0x18
  801a71:	e8 8b fd ff ff       	call   801801 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 14             	pushl  0x14(%ebp)
  801a86:	ff 75 10             	pushl  0x10(%ebp)
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	50                   	push   %eax
  801a8d:	6a 19                	push   $0x19
  801a8f:	e8 6d fd ff ff       	call   801801 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	50                   	push   %eax
  801aa8:	6a 1a                	push   $0x1a
  801aaa:	e8 52 fd ff ff       	call   801801 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	90                   	nop
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	50                   	push   %eax
  801ac4:	6a 1b                	push   $0x1b
  801ac6:	e8 36 fd ff ff       	call   801801 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 05                	push   $0x5
  801adf:	e8 1d fd ff ff       	call   801801 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 06                	push   $0x6
  801af8:	e8 04 fd ff ff       	call   801801 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 07                	push   $0x7
  801b11:	e8 eb fc ff ff       	call   801801 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_exit_env>:


void sys_exit_env(void)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 1c                	push   $0x1c
  801b2a:	e8 d2 fc ff ff       	call   801801 <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	90                   	nop
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b3b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b3e:	8d 50 04             	lea    0x4(%eax),%edx
  801b41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	52                   	push   %edx
  801b4b:	50                   	push   %eax
  801b4c:	6a 1d                	push   $0x1d
  801b4e:	e8 ae fc ff ff       	call   801801 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return result;
  801b56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5f:	89 01                	mov    %eax,(%ecx)
  801b61:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	c9                   	leave  
  801b68:	c2 04 00             	ret    $0x4

00801b6b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	ff 75 10             	pushl  0x10(%ebp)
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 13                	push   $0x13
  801b7d:	e8 7f fc ff ff       	call   801801 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 1e                	push   $0x1e
  801b97:	e8 65 fc ff ff       	call   801801 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bad:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	50                   	push   %eax
  801bba:	6a 1f                	push   $0x1f
  801bbc:	e8 40 fc ff ff       	call   801801 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc4:	90                   	nop
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <rsttst>:
void rsttst()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 21                	push   $0x21
  801bd6:	e8 26 fc ff ff       	call   801801 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bde:	90                   	nop
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bed:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf4:	52                   	push   %edx
  801bf5:	50                   	push   %eax
  801bf6:	ff 75 10             	pushl  0x10(%ebp)
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	6a 20                	push   $0x20
  801c01:	e8 fb fb ff ff       	call   801801 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return ;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <chktst>:
void chktst(uint32 n)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	ff 75 08             	pushl  0x8(%ebp)
  801c1a:	6a 22                	push   $0x22
  801c1c:	e8 e0 fb ff ff       	call   801801 <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
	return ;
  801c24:	90                   	nop
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <inctst>:

void inctst()
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 23                	push   $0x23
  801c36:	e8 c6 fb ff ff       	call   801801 <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3e:	90                   	nop
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <gettst>:
uint32 gettst()
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 24                	push   $0x24
  801c50:	e8 ac fb ff ff       	call   801801 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 25                	push   $0x25
  801c69:	e8 93 fb ff ff       	call   801801 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
  801c71:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c76:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	6a 26                	push   $0x26
  801c95:	e8 67 fb ff ff       	call   801801 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ca4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801caa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	6a 00                	push   $0x0
  801cb2:	53                   	push   %ebx
  801cb3:	51                   	push   %ecx
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	6a 27                	push   $0x27
  801cb8:	e8 44 fb ff ff       	call   801801 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 28                	push   $0x28
  801cd8:	e8 24 fb ff ff       	call   801801 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ce5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	51                   	push   %ecx
  801cf1:	ff 75 10             	pushl  0x10(%ebp)
  801cf4:	52                   	push   %edx
  801cf5:	50                   	push   %eax
  801cf6:	6a 29                	push   $0x29
  801cf8:	e8 04 fb ff ff       	call   801801 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	ff 75 10             	pushl  0x10(%ebp)
  801d0c:	ff 75 0c             	pushl  0xc(%ebp)
  801d0f:	ff 75 08             	pushl  0x8(%ebp)
  801d12:	6a 12                	push   $0x12
  801d14:	e8 e8 fa ff ff       	call   801801 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1c:	90                   	nop
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	6a 2a                	push   $0x2a
  801d32:	e8 ca fa ff ff       	call   801801 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return;
  801d3a:	90                   	nop
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 2b                	push   $0x2b
  801d4c:	e8 b0 fa ff ff       	call   801801 <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	ff 75 08             	pushl  0x8(%ebp)
  801d65:	6a 2d                	push   $0x2d
  801d67:	e8 95 fa ff ff       	call   801801 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
	return;
  801d6f:	90                   	nop
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	ff 75 08             	pushl  0x8(%ebp)
  801d81:	6a 2c                	push   $0x2c
  801d83:	e8 79 fa ff ff       	call   801801 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8b:	90                   	nop
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	52                   	push   %edx
  801d9e:	50                   	push   %eax
  801d9f:	6a 2e                	push   $0x2e
  801da1:	e8 5b fa ff ff       	call   801801 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
	    return;
  801da9:	90                   	nop
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801db2:	8b 55 08             	mov    0x8(%ebp),%edx
  801db5:	89 d0                	mov    %edx,%eax
  801db7:	c1 e0 02             	shl    $0x2,%eax
  801dba:	01 d0                	add    %edx,%eax
  801dbc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dc3:	01 d0                	add    %edx,%eax
  801dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dcc:	01 d0                	add    %edx,%eax
  801dce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dd5:	01 d0                	add    %edx,%eax
  801dd7:	c1 e0 04             	shl    $0x4,%eax
  801dda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801ddd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801de4:	0f 31                	rdtsc  
  801de6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801de9:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801def:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801df5:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801df8:	eb 46                	jmp    801e40 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801dfa:	0f 31                	rdtsc  
  801dfc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801dff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e02:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e05:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e08:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e14:	29 c2                	sub    %eax,%edx
  801e16:	89 d0                	mov    %edx,%eax
  801e18:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	89 d1                	mov    %edx,%ecx
  801e23:	29 c1                	sub    %eax,%ecx
  801e25:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e2b:	39 c2                	cmp    %eax,%edx
  801e2d:	0f 97 c0             	seta   %al
  801e30:	0f b6 c0             	movzbl %al,%eax
  801e33:	29 c1                	sub    %eax,%ecx
  801e35:	89 c8                	mov    %ecx,%eax
  801e37:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e43:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e46:	72 b2                	jb     801dfa <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e48:	90                   	nop
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e58:	eb 03                	jmp    801e5d <busy_wait+0x12>
  801e5a:	ff 45 fc             	incl   -0x4(%ebp)
  801e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e60:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e63:	72 f5                	jb     801e5a <busy_wait+0xf>
	return i;
  801e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801e76:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801e7a:	83 ec 0c             	sub    $0xc,%esp
  801e7d:	50                   	push   %eax
  801e7e:	e8 35 fb ff ff       	call   8019b8 <sys_cputc>
  801e83:	83 c4 10             	add    $0x10,%esp
}
  801e86:	90                   	nop
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <getchar>:


int
getchar(void)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801e8f:	e8 c3 f9 ff ff       	call   801857 <sys_cgetc>
  801e94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <iscons>:

int iscons(int fdnum)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801e9f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ea4:	5d                   	pop    %ebp
  801ea5:	c3                   	ret    
  801ea6:	66 90                	xchg   %ax,%ax

00801ea8 <__udivdi3>:
  801ea8:	55                   	push   %ebp
  801ea9:	57                   	push   %edi
  801eaa:	56                   	push   %esi
  801eab:	53                   	push   %ebx
  801eac:	83 ec 1c             	sub    $0x1c,%esp
  801eaf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801eb3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801eb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ebb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ebf:	89 ca                	mov    %ecx,%edx
  801ec1:	89 f8                	mov    %edi,%eax
  801ec3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ec7:	85 f6                	test   %esi,%esi
  801ec9:	75 2d                	jne    801ef8 <__udivdi3+0x50>
  801ecb:	39 cf                	cmp    %ecx,%edi
  801ecd:	77 65                	ja     801f34 <__udivdi3+0x8c>
  801ecf:	89 fd                	mov    %edi,%ebp
  801ed1:	85 ff                	test   %edi,%edi
  801ed3:	75 0b                	jne    801ee0 <__udivdi3+0x38>
  801ed5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eda:	31 d2                	xor    %edx,%edx
  801edc:	f7 f7                	div    %edi
  801ede:	89 c5                	mov    %eax,%ebp
  801ee0:	31 d2                	xor    %edx,%edx
  801ee2:	89 c8                	mov    %ecx,%eax
  801ee4:	f7 f5                	div    %ebp
  801ee6:	89 c1                	mov    %eax,%ecx
  801ee8:	89 d8                	mov    %ebx,%eax
  801eea:	f7 f5                	div    %ebp
  801eec:	89 cf                	mov    %ecx,%edi
  801eee:	89 fa                	mov    %edi,%edx
  801ef0:	83 c4 1c             	add    $0x1c,%esp
  801ef3:	5b                   	pop    %ebx
  801ef4:	5e                   	pop    %esi
  801ef5:	5f                   	pop    %edi
  801ef6:	5d                   	pop    %ebp
  801ef7:	c3                   	ret    
  801ef8:	39 ce                	cmp    %ecx,%esi
  801efa:	77 28                	ja     801f24 <__udivdi3+0x7c>
  801efc:	0f bd fe             	bsr    %esi,%edi
  801eff:	83 f7 1f             	xor    $0x1f,%edi
  801f02:	75 40                	jne    801f44 <__udivdi3+0x9c>
  801f04:	39 ce                	cmp    %ecx,%esi
  801f06:	72 0a                	jb     801f12 <__udivdi3+0x6a>
  801f08:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f0c:	0f 87 9e 00 00 00    	ja     801fb0 <__udivdi3+0x108>
  801f12:	b8 01 00 00 00       	mov    $0x1,%eax
  801f17:	89 fa                	mov    %edi,%edx
  801f19:	83 c4 1c             	add    $0x1c,%esp
  801f1c:	5b                   	pop    %ebx
  801f1d:	5e                   	pop    %esi
  801f1e:	5f                   	pop    %edi
  801f1f:	5d                   	pop    %ebp
  801f20:	c3                   	ret    
  801f21:	8d 76 00             	lea    0x0(%esi),%esi
  801f24:	31 ff                	xor    %edi,%edi
  801f26:	31 c0                	xor    %eax,%eax
  801f28:	89 fa                	mov    %edi,%edx
  801f2a:	83 c4 1c             	add    $0x1c,%esp
  801f2d:	5b                   	pop    %ebx
  801f2e:	5e                   	pop    %esi
  801f2f:	5f                   	pop    %edi
  801f30:	5d                   	pop    %ebp
  801f31:	c3                   	ret    
  801f32:	66 90                	xchg   %ax,%ax
  801f34:	89 d8                	mov    %ebx,%eax
  801f36:	f7 f7                	div    %edi
  801f38:	31 ff                	xor    %edi,%edi
  801f3a:	89 fa                	mov    %edi,%edx
  801f3c:	83 c4 1c             	add    $0x1c,%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5e                   	pop    %esi
  801f41:	5f                   	pop    %edi
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    
  801f44:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f49:	89 eb                	mov    %ebp,%ebx
  801f4b:	29 fb                	sub    %edi,%ebx
  801f4d:	89 f9                	mov    %edi,%ecx
  801f4f:	d3 e6                	shl    %cl,%esi
  801f51:	89 c5                	mov    %eax,%ebp
  801f53:	88 d9                	mov    %bl,%cl
  801f55:	d3 ed                	shr    %cl,%ebp
  801f57:	89 e9                	mov    %ebp,%ecx
  801f59:	09 f1                	or     %esi,%ecx
  801f5b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f5f:	89 f9                	mov    %edi,%ecx
  801f61:	d3 e0                	shl    %cl,%eax
  801f63:	89 c5                	mov    %eax,%ebp
  801f65:	89 d6                	mov    %edx,%esi
  801f67:	88 d9                	mov    %bl,%cl
  801f69:	d3 ee                	shr    %cl,%esi
  801f6b:	89 f9                	mov    %edi,%ecx
  801f6d:	d3 e2                	shl    %cl,%edx
  801f6f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f73:	88 d9                	mov    %bl,%cl
  801f75:	d3 e8                	shr    %cl,%eax
  801f77:	09 c2                	or     %eax,%edx
  801f79:	89 d0                	mov    %edx,%eax
  801f7b:	89 f2                	mov    %esi,%edx
  801f7d:	f7 74 24 0c          	divl   0xc(%esp)
  801f81:	89 d6                	mov    %edx,%esi
  801f83:	89 c3                	mov    %eax,%ebx
  801f85:	f7 e5                	mul    %ebp
  801f87:	39 d6                	cmp    %edx,%esi
  801f89:	72 19                	jb     801fa4 <__udivdi3+0xfc>
  801f8b:	74 0b                	je     801f98 <__udivdi3+0xf0>
  801f8d:	89 d8                	mov    %ebx,%eax
  801f8f:	31 ff                	xor    %edi,%edi
  801f91:	e9 58 ff ff ff       	jmp    801eee <__udivdi3+0x46>
  801f96:	66 90                	xchg   %ax,%ax
  801f98:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f9c:	89 f9                	mov    %edi,%ecx
  801f9e:	d3 e2                	shl    %cl,%edx
  801fa0:	39 c2                	cmp    %eax,%edx
  801fa2:	73 e9                	jae    801f8d <__udivdi3+0xe5>
  801fa4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fa7:	31 ff                	xor    %edi,%edi
  801fa9:	e9 40 ff ff ff       	jmp    801eee <__udivdi3+0x46>
  801fae:	66 90                	xchg   %ax,%ax
  801fb0:	31 c0                	xor    %eax,%eax
  801fb2:	e9 37 ff ff ff       	jmp    801eee <__udivdi3+0x46>
  801fb7:	90                   	nop

00801fb8 <__umoddi3>:
  801fb8:	55                   	push   %ebp
  801fb9:	57                   	push   %edi
  801fba:	56                   	push   %esi
  801fbb:	53                   	push   %ebx
  801fbc:	83 ec 1c             	sub    $0x1c,%esp
  801fbf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fcb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fcf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fd7:	89 f3                	mov    %esi,%ebx
  801fd9:	89 fa                	mov    %edi,%edx
  801fdb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fdf:	89 34 24             	mov    %esi,(%esp)
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	75 1a                	jne    802000 <__umoddi3+0x48>
  801fe6:	39 f7                	cmp    %esi,%edi
  801fe8:	0f 86 a2 00 00 00    	jbe    802090 <__umoddi3+0xd8>
  801fee:	89 c8                	mov    %ecx,%eax
  801ff0:	89 f2                	mov    %esi,%edx
  801ff2:	f7 f7                	div    %edi
  801ff4:	89 d0                	mov    %edx,%eax
  801ff6:	31 d2                	xor    %edx,%edx
  801ff8:	83 c4 1c             	add    $0x1c,%esp
  801ffb:	5b                   	pop    %ebx
  801ffc:	5e                   	pop    %esi
  801ffd:	5f                   	pop    %edi
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    
  802000:	39 f0                	cmp    %esi,%eax
  802002:	0f 87 ac 00 00 00    	ja     8020b4 <__umoddi3+0xfc>
  802008:	0f bd e8             	bsr    %eax,%ebp
  80200b:	83 f5 1f             	xor    $0x1f,%ebp
  80200e:	0f 84 ac 00 00 00    	je     8020c0 <__umoddi3+0x108>
  802014:	bf 20 00 00 00       	mov    $0x20,%edi
  802019:	29 ef                	sub    %ebp,%edi
  80201b:	89 fe                	mov    %edi,%esi
  80201d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802021:	89 e9                	mov    %ebp,%ecx
  802023:	d3 e0                	shl    %cl,%eax
  802025:	89 d7                	mov    %edx,%edi
  802027:	89 f1                	mov    %esi,%ecx
  802029:	d3 ef                	shr    %cl,%edi
  80202b:	09 c7                	or     %eax,%edi
  80202d:	89 e9                	mov    %ebp,%ecx
  80202f:	d3 e2                	shl    %cl,%edx
  802031:	89 14 24             	mov    %edx,(%esp)
  802034:	89 d8                	mov    %ebx,%eax
  802036:	d3 e0                	shl    %cl,%eax
  802038:	89 c2                	mov    %eax,%edx
  80203a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80203e:	d3 e0                	shl    %cl,%eax
  802040:	89 44 24 04          	mov    %eax,0x4(%esp)
  802044:	8b 44 24 08          	mov    0x8(%esp),%eax
  802048:	89 f1                	mov    %esi,%ecx
  80204a:	d3 e8                	shr    %cl,%eax
  80204c:	09 d0                	or     %edx,%eax
  80204e:	d3 eb                	shr    %cl,%ebx
  802050:	89 da                	mov    %ebx,%edx
  802052:	f7 f7                	div    %edi
  802054:	89 d3                	mov    %edx,%ebx
  802056:	f7 24 24             	mull   (%esp)
  802059:	89 c6                	mov    %eax,%esi
  80205b:	89 d1                	mov    %edx,%ecx
  80205d:	39 d3                	cmp    %edx,%ebx
  80205f:	0f 82 87 00 00 00    	jb     8020ec <__umoddi3+0x134>
  802065:	0f 84 91 00 00 00    	je     8020fc <__umoddi3+0x144>
  80206b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80206f:	29 f2                	sub    %esi,%edx
  802071:	19 cb                	sbb    %ecx,%ebx
  802073:	89 d8                	mov    %ebx,%eax
  802075:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802079:	d3 e0                	shl    %cl,%eax
  80207b:	89 e9                	mov    %ebp,%ecx
  80207d:	d3 ea                	shr    %cl,%edx
  80207f:	09 d0                	or     %edx,%eax
  802081:	89 e9                	mov    %ebp,%ecx
  802083:	d3 eb                	shr    %cl,%ebx
  802085:	89 da                	mov    %ebx,%edx
  802087:	83 c4 1c             	add    $0x1c,%esp
  80208a:	5b                   	pop    %ebx
  80208b:	5e                   	pop    %esi
  80208c:	5f                   	pop    %edi
  80208d:	5d                   	pop    %ebp
  80208e:	c3                   	ret    
  80208f:	90                   	nop
  802090:	89 fd                	mov    %edi,%ebp
  802092:	85 ff                	test   %edi,%edi
  802094:	75 0b                	jne    8020a1 <__umoddi3+0xe9>
  802096:	b8 01 00 00 00       	mov    $0x1,%eax
  80209b:	31 d2                	xor    %edx,%edx
  80209d:	f7 f7                	div    %edi
  80209f:	89 c5                	mov    %eax,%ebp
  8020a1:	89 f0                	mov    %esi,%eax
  8020a3:	31 d2                	xor    %edx,%edx
  8020a5:	f7 f5                	div    %ebp
  8020a7:	89 c8                	mov    %ecx,%eax
  8020a9:	f7 f5                	div    %ebp
  8020ab:	89 d0                	mov    %edx,%eax
  8020ad:	e9 44 ff ff ff       	jmp    801ff6 <__umoddi3+0x3e>
  8020b2:	66 90                	xchg   %ax,%ax
  8020b4:	89 c8                	mov    %ecx,%eax
  8020b6:	89 f2                	mov    %esi,%edx
  8020b8:	83 c4 1c             	add    $0x1c,%esp
  8020bb:	5b                   	pop    %ebx
  8020bc:	5e                   	pop    %esi
  8020bd:	5f                   	pop    %edi
  8020be:	5d                   	pop    %ebp
  8020bf:	c3                   	ret    
  8020c0:	3b 04 24             	cmp    (%esp),%eax
  8020c3:	72 06                	jb     8020cb <__umoddi3+0x113>
  8020c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020c9:	77 0f                	ja     8020da <__umoddi3+0x122>
  8020cb:	89 f2                	mov    %esi,%edx
  8020cd:	29 f9                	sub    %edi,%ecx
  8020cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020d3:	89 14 24             	mov    %edx,(%esp)
  8020d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020de:	8b 14 24             	mov    (%esp),%edx
  8020e1:	83 c4 1c             	add    $0x1c,%esp
  8020e4:	5b                   	pop    %ebx
  8020e5:	5e                   	pop    %esi
  8020e6:	5f                   	pop    %edi
  8020e7:	5d                   	pop    %ebp
  8020e8:	c3                   	ret    
  8020e9:	8d 76 00             	lea    0x0(%esi),%esi
  8020ec:	2b 04 24             	sub    (%esp),%eax
  8020ef:	19 fa                	sbb    %edi,%edx
  8020f1:	89 d1                	mov    %edx,%ecx
  8020f3:	89 c6                	mov    %eax,%esi
  8020f5:	e9 71 ff ff ff       	jmp    80206b <__umoddi3+0xb3>
  8020fa:	66 90                	xchg   %ax,%ax
  8020fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802100:	72 ea                	jb     8020ec <__umoddi3+0x134>
  802102:	89 d9                	mov    %ebx,%ecx
  802104:	e9 62 ff ff ff       	jmp    80206b <__umoddi3+0xb3>
