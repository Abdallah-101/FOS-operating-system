
obj/user/tst_ksemaphore_2master:     file format elf32-i386


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
  800031:	e8 a8 02 00 00       	call   8002de <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: take user input, create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 6c 02 00 00    	sub    $0x26c,%esp
	int envID = sys_getenvid();
  800044:	e8 d8 1a 00 00       	call   801b21 <sys_getenvid>
  800049:	89 45 e0             	mov    %eax,-0x20(%ebp)
	char line[256] ;
	readline("Enter total number of customers: ", line) ;
  80004c:	83 ec 08             	sub    $0x8,%esp
  80004f:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800055:	50                   	push   %eax
  800056:	68 60 21 80 00       	push   $0x802160
  80005b:	e8 de 0d 00 00       	call   800e3e <readline>
  800060:	83 c4 10             	add    $0x10,%esp
	int totalNumOfCusts = strtol(line, NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800070:	50                   	push   %eax
  800071:	e8 df 13 00 00       	call   801455 <strtol>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 dc             	mov    %eax,-0x24(%ebp)
	readline("Enter shop capacity: ", line) ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800085:	50                   	push   %eax
  800086:	68 82 21 80 00       	push   $0x802182
  80008b:	e8 ae 0d 00 00       	call   800e3e <readline>
  800090:	83 c4 10             	add    $0x10,%esp
	int shopCapacity = strtol(line, NULL, 10);
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 0a                	push   $0xa
  800098:	6a 00                	push   $0x0
  80009a:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 af 13 00 00       	call   801455 <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int semVal ;
	//Initialize the kernel semaphores
	char initCmd1[64] = "__KSem@0@Init";
  8000ac:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  8000b2:	bb a5 22 80 00       	mov    $0x8022a5,%ebx
  8000b7:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000bc:	89 c7                	mov    %eax,%edi
  8000be:	89 de                	mov    %ebx,%esi
  8000c0:	89 d1                	mov    %edx,%ecx
  8000c2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000c4:	8d 95 9e fe ff ff    	lea    -0x162(%ebp),%edx
  8000ca:	b9 32 00 00 00       	mov    $0x32,%ecx
  8000cf:	b0 00                	mov    $0x0,%al
  8000d1:	89 d7                	mov    %edx,%edi
  8000d3:	f3 aa                	rep stos %al,%es:(%edi)
	char initCmd2[64] = "__KSem@1@Init";
  8000d5:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  8000db:	bb e5 22 80 00       	mov    $0x8022e5,%ebx
  8000e0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000e5:	89 c7                	mov    %eax,%edi
  8000e7:	89 de                	mov    %ebx,%esi
  8000e9:	89 d1                	mov    %edx,%ecx
  8000eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000ed:	8d 95 5e fe ff ff    	lea    -0x1a2(%ebp),%edx
  8000f3:	b9 32 00 00 00       	mov    $0x32,%ecx
  8000f8:	b0 00                	mov    $0x0,%al
  8000fa:	89 d7                	mov    %edx,%edi
  8000fc:	f3 aa                	rep stos %al,%es:(%edi)
	semVal = shopCapacity;
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
	sys_utilities(initCmd1, (uint32)(&semVal));
  800107:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	50                   	push   %eax
  800111:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  800117:	50                   	push   %eax
  800118:	e8 53 1c 00 00       	call   801d70 <sys_utilities>
  80011d:	83 c4 10             	add    $0x10,%esp
	semVal = 0;
  800120:	c7 85 d0 fe ff ff 00 	movl   $0x0,-0x130(%ebp)
  800127:	00 00 00 
	sys_utilities(initCmd2, (uint32)(&semVal));
  80012a:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	50                   	push   %eax
  800134:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	e8 30 1c 00 00       	call   801d70 <sys_utilities>
  800140:	83 c4 10             	add    $0x10,%esp

	int i = 0 ;
  800143:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int id ;
	for (; i<totalNumOfCusts; i++)
  80014a:	eb 61                	jmp    8001ad <_main+0x175>
	{
		id = sys_create_env("ksem2Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800157:	a1 20 30 80 00       	mov    0x803020,%eax
  80015c:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800162:	89 c1                	mov    %eax,%ecx
  800164:	a1 20 30 80 00       	mov    0x803020,%eax
  800169:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80016f:	52                   	push   %edx
  800170:	51                   	push   %ecx
  800171:	50                   	push   %eax
  800172:	68 98 21 80 00       	push   $0x802198
  800177:	e8 50 19 00 00       	call   801acc <sys_create_env>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (id == E_ENV_CREATION_ERROR)
  800182:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  800186:	75 14                	jne    80019c <_main+0x164>
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	68 a4 21 80 00       	push   $0x8021a4
  800190:	6a 1e                	push   $0x1e
  800192:	68 f0 21 80 00       	push   $0x8021f0
  800197:	e8 fb 02 00 00       	call   800497 <_panic>
		sys_run_env(id) ;
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001a2:	e8 43 19 00 00       	call   801aea <sys_run_env>
  8001a7:	83 c4 10             	add    $0x10,%esp
	semVal = 0;
	sys_utilities(initCmd2, (uint32)(&semVal));

	int i = 0 ;
	int id ;
	for (; i<totalNumOfCusts; i++)
  8001aa:	ff 45 e4             	incl   -0x1c(%ebp)
  8001ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001b0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001b3:	7c 97                	jl     80014c <_main+0x114>
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	//Wait until all finished
	for (i = 0 ; i<totalNumOfCusts; i++)
  8001b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001bc:	eb 40                	jmp    8001fe <_main+0x1c6>
	{
		char waitCmd[64] = "__KSem@1@Wait";
  8001be:	8d 85 88 fd ff ff    	lea    -0x278(%ebp),%eax
  8001c4:	bb 25 23 80 00       	mov    $0x802325,%ebx
  8001c9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ce:	89 c7                	mov    %eax,%edi
  8001d0:	89 de                	mov    %ebx,%esi
  8001d2:	89 d1                	mov    %edx,%ecx
  8001d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001d6:	8d 95 96 fd ff ff    	lea    -0x26a(%ebp),%edx
  8001dc:	b9 32 00 00 00       	mov    $0x32,%ecx
  8001e1:	b0 00                	mov    $0x0,%al
  8001e3:	89 d7                	mov    %edx,%edi
  8001e5:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(waitCmd, 0);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	6a 00                	push   $0x0
  8001ec:	8d 85 88 fd ff ff    	lea    -0x278(%ebp),%eax
  8001f2:	50                   	push   %eax
  8001f3:	e8 78 1b 00 00       	call   801d70 <sys_utilities>
  8001f8:	83 c4 10             	add    $0x10,%esp
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	//Wait until all finished
	for (i = 0 ; i<totalNumOfCusts; i++)
  8001fb:	ff 45 e4             	incl   -0x1c(%ebp)
  8001fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800201:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800204:	7c b8                	jl     8001be <_main+0x186>
	}

	//Check semaphore values
	int sem1val ;
	int sem2val ;
	char getCmd1[64] = "__KSem@0@Get";
  800206:	8d 85 08 fe ff ff    	lea    -0x1f8(%ebp),%eax
  80020c:	bb 65 23 80 00       	mov    $0x802365,%ebx
  800211:	ba 0d 00 00 00       	mov    $0xd,%edx
  800216:	89 c7                	mov    %eax,%edi
  800218:	89 de                	mov    %ebx,%esi
  80021a:	89 d1                	mov    %edx,%ecx
  80021c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80021e:	8d 95 15 fe ff ff    	lea    -0x1eb(%ebp),%edx
  800224:	b9 33 00 00 00       	mov    $0x33,%ecx
  800229:	b0 00                	mov    $0x0,%al
  80022b:	89 d7                	mov    %edx,%edi
  80022d:	f3 aa                	rep stos %al,%es:(%edi)
	char getCmd2[64] = "__KSem@1@Get";
  80022f:	8d 85 c8 fd ff ff    	lea    -0x238(%ebp),%eax
  800235:	bb a5 23 80 00       	mov    $0x8023a5,%ebx
  80023a:	ba 0d 00 00 00       	mov    $0xd,%edx
  80023f:	89 c7                	mov    %eax,%edi
  800241:	89 de                	mov    %ebx,%esi
  800243:	89 d1                	mov    %edx,%ecx
  800245:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800247:	8d 95 d5 fd ff ff    	lea    -0x22b(%ebp),%edx
  80024d:	b9 33 00 00 00       	mov    $0x33,%ecx
  800252:	b0 00                	mov    $0x0,%al
  800254:	89 d7                	mov    %edx,%edi
  800256:	f3 aa                	rep stos %al,%es:(%edi)

	sys_utilities(getCmd1, (uint32)(&sem1val));
  800258:	8d 85 4c fe ff ff    	lea    -0x1b4(%ebp),%eax
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	50                   	push   %eax
  800262:	8d 85 08 fe ff ff    	lea    -0x1f8(%ebp),%eax
  800268:	50                   	push   %eax
  800269:	e8 02 1b 00 00       	call   801d70 <sys_utilities>
  80026e:	83 c4 10             	add    $0x10,%esp
	sys_utilities(getCmd2, (uint32)(&sem2val));
  800271:	8d 85 48 fe ff ff    	lea    -0x1b8(%ebp),%eax
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	50                   	push   %eax
  80027b:	8d 85 c8 fd ff ff    	lea    -0x238(%ebp),%eax
  800281:	50                   	push   %eax
  800282:	e8 e9 1a 00 00       	call   801d70 <sys_utilities>
  800287:	83 c4 10             	add    $0x10,%esp

	//wait a while to allow the slaves to finish printing their closing messages
	env_sleep(10000);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	68 10 27 00 00       	push   $0x2710
  800292:	e8 66 1b 00 00       	call   801dfd <env_sleep>
  800297:	83 c4 10             	add    $0x10,%esp
	if (sem2val == 0 && sem1val == shopCapacity)
  80029a:	8b 85 48 fe ff ff    	mov    -0x1b8(%ebp),%eax
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	75 1f                	jne    8002c3 <_main+0x28b>
  8002a4:	8b 85 4c fe ff ff    	mov    -0x1b4(%ebp),%eax
  8002aa:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002ad:	75 14                	jne    8002c3 <_main+0x28b>
		cprintf_colored(TEXT_light_green,"\nCongratulations!! Test of Semaphores [2] completed successfully!!\n\n\n");
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	68 10 22 80 00       	push   $0x802210
  8002b7:	6a 0a                	push   $0xa
  8002b9:	e8 d4 04 00 00       	call   800792 <cprintf_colored>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	eb 12                	jmp    8002d5 <_main+0x29d>
	else
		cprintf_colored(TEXT_TESTERR_CLR,"\nError: wrong semaphore value... please review your semaphore code again...\n");
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	68 58 22 80 00       	push   $0x802258
  8002cb:	6a 0c                	push   $0xc
  8002cd:	e8 c0 04 00 00       	call   800792 <cprintf_colored>
  8002d2:	83 c4 10             	add    $0x10,%esp

	return;
  8002d5:	90                   	nop
}
  8002d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    

008002de <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002e7:	e8 4e 18 00 00       	call   801b3a <sys_getenvindex>
  8002ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002f2:	89 d0                	mov    %edx,%eax
  8002f4:	c1 e0 02             	shl    $0x2,%eax
  8002f7:	01 d0                	add    %edx,%eax
  8002f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800300:	01 d0                	add    %edx,%eax
  800302:	89 c2                	mov    %eax,%edx
  800304:	c1 e2 04             	shl    $0x4,%edx
  800307:	29 c2                	sub    %eax,%edx
  800309:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800310:	89 c2                	mov    %eax,%edx
  800312:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800318:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80031d:	a1 20 30 80 00       	mov    0x803020,%eax
  800322:	8a 40 20             	mov    0x20(%eax),%al
  800325:	84 c0                	test   %al,%al
  800327:	74 0d                	je     800336 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800329:	a1 20 30 80 00       	mov    0x803020,%eax
  80032e:	83 c0 20             	add    $0x20,%eax
  800331:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800336:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80033a:	7e 0a                	jle    800346 <libmain+0x68>
		binaryname = argv[0];
  80033c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 e4 fc ff ff       	call   800038 <_main>
  800354:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800357:	a1 00 30 80 00       	mov    0x803000,%eax
  80035c:	85 c0                	test   %eax,%eax
  80035e:	0f 84 01 01 00 00    	je     800465 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800364:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80036a:	bb e0 24 80 00       	mov    $0x8024e0,%ebx
  80036f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800374:	89 c7                	mov    %eax,%edi
  800376:	89 de                	mov    %ebx,%esi
  800378:	89 d1                	mov    %edx,%ecx
  80037a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80037c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80037f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800384:	b0 00                	mov    $0x0,%al
  800386:	89 d7                	mov    %edx,%edi
  800388:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80038a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800391:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	50                   	push   %eax
  800398:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80039e:	50                   	push   %eax
  80039f:	e8 cc 19 00 00       	call   801d70 <sys_utilities>
  8003a4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003a7:	e8 15 15 00 00       	call   8018c1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	68 00 24 80 00       	push   $0x802400
  8003b4:	e8 ac 03 00 00       	call   800765 <cprintf>
  8003b9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bf:	85 c0                	test   %eax,%eax
  8003c1:	74 18                	je     8003db <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003c3:	e8 c6 19 00 00       	call   801d8e <sys_get_optimal_num_faults>
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	50                   	push   %eax
  8003cc:	68 28 24 80 00       	push   $0x802428
  8003d1:	e8 8f 03 00 00       	call   800765 <cprintf>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	eb 59                	jmp    800434 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003db:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e0:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003eb:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	52                   	push   %edx
  8003f5:	50                   	push   %eax
  8003f6:	68 4c 24 80 00       	push   $0x80244c
  8003fb:	e8 65 03 00 00       	call   800765 <cprintf>
  800400:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800403:	a1 20 30 80 00       	mov    0x803020,%eax
  800408:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80040e:	a1 20 30 80 00       	mov    0x803020,%eax
  800413:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800419:	a1 20 30 80 00       	mov    0x803020,%eax
  80041e:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800424:	51                   	push   %ecx
  800425:	52                   	push   %edx
  800426:	50                   	push   %eax
  800427:	68 74 24 80 00       	push   $0x802474
  80042c:	e8 34 03 00 00       	call   800765 <cprintf>
  800431:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800434:	a1 20 30 80 00       	mov    0x803020,%eax
  800439:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	50                   	push   %eax
  800443:	68 cc 24 80 00       	push   $0x8024cc
  800448:	e8 18 03 00 00       	call   800765 <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800450:	83 ec 0c             	sub    $0xc,%esp
  800453:	68 00 24 80 00       	push   $0x802400
  800458:	e8 08 03 00 00       	call   800765 <cprintf>
  80045d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800460:	e8 76 14 00 00       	call   8018db <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800465:	e8 1f 00 00 00       	call   800489 <exit>
}
  80046a:	90                   	nop
  80046b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80046e:	5b                   	pop    %ebx
  80046f:	5e                   	pop    %esi
  800470:	5f                   	pop    %edi
  800471:	5d                   	pop    %ebp
  800472:	c3                   	ret    

00800473 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	6a 00                	push   $0x0
  80047e:	e8 83 16 00 00       	call   801b06 <sys_destroy_env>
  800483:	83 c4 10             	add    $0x10,%esp
}
  800486:	90                   	nop
  800487:	c9                   	leave  
  800488:	c3                   	ret    

00800489 <exit>:

void
exit(void)
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048f:	e8 d8 16 00 00       	call   801b6c <sys_exit_env>
}
  800494:	90                   	nop
  800495:	c9                   	leave  
  800496:	c3                   	ret    

00800497 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80049d:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a0:	83 c0 04             	add    $0x4,%eax
  8004a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a6:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	74 16                	je     8004c5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004af:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	50                   	push   %eax
  8004b8:	68 44 25 80 00       	push   $0x802544
  8004bd:	e8 a3 02 00 00       	call   800765 <cprintf>
  8004c2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004c5:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ca:	83 ec 0c             	sub    $0xc,%esp
  8004cd:	ff 75 0c             	pushl  0xc(%ebp)
  8004d0:	ff 75 08             	pushl  0x8(%ebp)
  8004d3:	50                   	push   %eax
  8004d4:	68 4c 25 80 00       	push   $0x80254c
  8004d9:	6a 74                	push   $0x74
  8004db:	e8 b2 02 00 00       	call   800792 <cprintf_colored>
  8004e0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ec:	50                   	push   %eax
  8004ed:	e8 04 02 00 00       	call   8006f6 <vcprintf>
  8004f2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	6a 00                	push   $0x0
  8004fa:	68 74 25 80 00       	push   $0x802574
  8004ff:	e8 f2 01 00 00       	call   8006f6 <vcprintf>
  800504:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800507:	e8 7d ff ff ff       	call   800489 <exit>

	// should not return here
	while (1) ;
  80050c:	eb fe                	jmp    80050c <_panic+0x75>

0080050e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800514:	a1 20 30 80 00       	mov    0x803020,%eax
  800519:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80051f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800522:	39 c2                	cmp    %eax,%edx
  800524:	74 14                	je     80053a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800526:	83 ec 04             	sub    $0x4,%esp
  800529:	68 78 25 80 00       	push   $0x802578
  80052e:	6a 26                	push   $0x26
  800530:	68 c4 25 80 00       	push   $0x8025c4
  800535:	e8 5d ff ff ff       	call   800497 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80053a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800541:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800548:	e9 c5 00 00 00       	jmp    800612 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80054d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800550:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	01 d0                	add    %edx,%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	85 c0                	test   %eax,%eax
  800560:	75 08                	jne    80056a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800562:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800565:	e9 a5 00 00 00       	jmp    80060f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800571:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800578:	eb 69                	jmp    8005e3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80057a:	a1 20 30 80 00       	mov    0x803020,%eax
  80057f:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800585:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800588:	89 d0                	mov    %edx,%eax
  80058a:	01 c0                	add    %eax,%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	c1 e0 03             	shl    $0x3,%eax
  800591:	01 c8                	add    %ecx,%eax
  800593:	8a 40 04             	mov    0x4(%eax),%al
  800596:	84 c0                	test   %al,%al
  800598:	75 46                	jne    8005e0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80059a:	a1 20 30 80 00       	mov    0x803020,%eax
  80059f:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8005a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a8:	89 d0                	mov    %edx,%eax
  8005aa:	01 c0                	add    %eax,%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	c1 e0 03             	shl    $0x3,%eax
  8005b1:	01 c8                	add    %ecx,%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cf:	01 c8                	add    %ecx,%eax
  8005d1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d3:	39 c2                	cmp    %eax,%edx
  8005d5:	75 09                	jne    8005e0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005d7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005de:	eb 15                	jmp    8005f5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e0:	ff 45 e8             	incl   -0x18(%ebp)
  8005e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f1:	39 c2                	cmp    %eax,%edx
  8005f3:	77 85                	ja     80057a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f9:	75 14                	jne    80060f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 d0 25 80 00       	push   $0x8025d0
  800603:	6a 3a                	push   $0x3a
  800605:	68 c4 25 80 00       	push   $0x8025c4
  80060a:	e8 88 fe ff ff       	call   800497 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80060f:	ff 45 f0             	incl   -0x10(%ebp)
  800612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800615:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800618:	0f 8c 2f ff ff ff    	jl     80054d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80061e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800625:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80062c:	eb 26                	jmp    800654 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80062e:	a1 20 30 80 00       	mov    0x803020,%eax
  800633:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800639:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80063c:	89 d0                	mov    %edx,%eax
  80063e:	01 c0                	add    %eax,%eax
  800640:	01 d0                	add    %edx,%eax
  800642:	c1 e0 03             	shl    $0x3,%eax
  800645:	01 c8                	add    %ecx,%eax
  800647:	8a 40 04             	mov    0x4(%eax),%al
  80064a:	3c 01                	cmp    $0x1,%al
  80064c:	75 03                	jne    800651 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80064e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800651:	ff 45 e0             	incl   -0x20(%ebp)
  800654:	a1 20 30 80 00       	mov    0x803020,%eax
  800659:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80065f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800662:	39 c2                	cmp    %eax,%edx
  800664:	77 c8                	ja     80062e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800669:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80066c:	74 14                	je     800682 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	68 24 26 80 00       	push   $0x802624
  800676:	6a 44                	push   $0x44
  800678:	68 c4 25 80 00       	push   $0x8025c4
  80067d:	e8 15 fe ff ff       	call   800497 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800682:	90                   	nop
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	53                   	push   %ebx
  800689:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80068c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	8d 48 01             	lea    0x1(%eax),%ecx
  800694:	8b 55 0c             	mov    0xc(%ebp),%edx
  800697:	89 0a                	mov    %ecx,(%edx)
  800699:	8b 55 08             	mov    0x8(%ebp),%edx
  80069c:	88 d1                	mov    %dl,%cl
  80069e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006af:	75 30                	jne    8006e1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006b1:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006b7:	a0 44 30 80 00       	mov    0x803044,%al
  8006bc:	0f b6 c0             	movzbl %al,%eax
  8006bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c2:	8b 09                	mov    (%ecx),%ecx
  8006c4:	89 cb                	mov    %ecx,%ebx
  8006c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c9:	83 c1 08             	add    $0x8,%ecx
  8006cc:	52                   	push   %edx
  8006cd:	50                   	push   %eax
  8006ce:	53                   	push   %ebx
  8006cf:	51                   	push   %ecx
  8006d0:	e8 a8 11 00 00       	call   80187d <sys_cputs>
  8006d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e4:	8b 40 04             	mov    0x4(%eax),%eax
  8006e7:	8d 50 01             	lea    0x1(%eax),%edx
  8006ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f0:	90                   	nop
  8006f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f4:	c9                   	leave  
  8006f5:	c3                   	ret    

008006f6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800706:	00 00 00 
	b.cnt = 0;
  800709:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800710:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800713:	ff 75 0c             	pushl  0xc(%ebp)
  800716:	ff 75 08             	pushl  0x8(%ebp)
  800719:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071f:	50                   	push   %eax
  800720:	68 85 06 80 00       	push   $0x800685
  800725:	e8 5a 02 00 00       	call   800984 <vprintfmt>
  80072a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80072d:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800733:	a0 44 30 80 00       	mov    0x803044,%al
  800738:	0f b6 c0             	movzbl %al,%eax
  80073b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800741:	52                   	push   %edx
  800742:	50                   	push   %eax
  800743:	51                   	push   %ecx
  800744:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80074a:	83 c0 08             	add    $0x8,%eax
  80074d:	50                   	push   %eax
  80074e:	e8 2a 11 00 00       	call   80187d <sys_cputs>
  800753:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800756:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80075d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80076b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800772:	8d 45 0c             	lea    0xc(%ebp),%eax
  800775:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 f4             	pushl  -0xc(%ebp)
  800781:	50                   	push   %eax
  800782:	e8 6f ff ff ff       	call   8006f6 <vcprintf>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80078d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800790:	c9                   	leave  
  800791:	c3                   	ret    

00800792 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800798:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	c1 e0 08             	shl    $0x8,%eax
  8007a5:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8007aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ad:	83 c0 04             	add    $0x4,%eax
  8007b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bc:	50                   	push   %eax
  8007bd:	e8 34 ff ff ff       	call   8006f6 <vcprintf>
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007c8:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007cf:	07 00 00 

	return cnt;
  8007d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d5:	c9                   	leave  
  8007d6:	c3                   	ret    

008007d7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007dd:	e8 df 10 00 00       	call   8018c1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007e2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f1:	50                   	push   %eax
  8007f2:	e8 ff fe ff ff       	call   8006f6 <vcprintf>
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007fd:	e8 d9 10 00 00       	call   8018db <sys_unlock_cons>
	return cnt;
  800802:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800805:	c9                   	leave  
  800806:	c3                   	ret    

00800807 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	53                   	push   %ebx
  80080b:	83 ec 14             	sub    $0x14,%esp
  80080e:	8b 45 10             	mov    0x10(%ebp),%eax
  800811:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80081a:	8b 45 18             	mov    0x18(%ebp),%eax
  80081d:	ba 00 00 00 00       	mov    $0x0,%edx
  800822:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800825:	77 55                	ja     80087c <printnum+0x75>
  800827:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082a:	72 05                	jb     800831 <printnum+0x2a>
  80082c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082f:	77 4b                	ja     80087c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800831:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800834:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800837:	8b 45 18             	mov    0x18(%ebp),%eax
  80083a:	ba 00 00 00 00       	mov    $0x0,%edx
  80083f:	52                   	push   %edx
  800840:	50                   	push   %eax
  800841:	ff 75 f4             	pushl  -0xc(%ebp)
  800844:	ff 75 f0             	pushl  -0x10(%ebp)
  800847:	e8 ac 16 00 00       	call   801ef8 <__udivdi3>
  80084c:	83 c4 10             	add    $0x10,%esp
  80084f:	83 ec 04             	sub    $0x4,%esp
  800852:	ff 75 20             	pushl  0x20(%ebp)
  800855:	53                   	push   %ebx
  800856:	ff 75 18             	pushl  0x18(%ebp)
  800859:	52                   	push   %edx
  80085a:	50                   	push   %eax
  80085b:	ff 75 0c             	pushl  0xc(%ebp)
  80085e:	ff 75 08             	pushl  0x8(%ebp)
  800861:	e8 a1 ff ff ff       	call   800807 <printnum>
  800866:	83 c4 20             	add    $0x20,%esp
  800869:	eb 1a                	jmp    800885 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	ff 75 20             	pushl  0x20(%ebp)
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80087c:	ff 4d 1c             	decl   0x1c(%ebp)
  80087f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800883:	7f e6                	jg     80086b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800885:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800888:	bb 00 00 00 00       	mov    $0x0,%ebx
  80088d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800890:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800893:	53                   	push   %ebx
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	e8 6c 17 00 00       	call   802008 <__umoddi3>
  80089c:	83 c4 10             	add    $0x10,%esp
  80089f:	05 94 28 80 00       	add    $0x802894,%eax
  8008a4:	8a 00                	mov    (%eax),%al
  8008a6:	0f be c0             	movsbl %al,%eax
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	50                   	push   %eax
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	ff d0                	call   *%eax
  8008b5:	83 c4 10             	add    $0x10,%esp
}
  8008b8:	90                   	nop
  8008b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008bc:	c9                   	leave  
  8008bd:	c3                   	ret    

008008be <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c5:	7e 1c                	jle    8008e3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 50 08             	lea    0x8(%eax),%edx
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	89 10                	mov    %edx,(%eax)
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	83 e8 08             	sub    $0x8,%eax
  8008dc:	8b 50 04             	mov    0x4(%eax),%edx
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	eb 40                	jmp    800923 <getuint+0x65>
	else if (lflag)
  8008e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e7:	74 1e                	je     800907 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	8d 50 04             	lea    0x4(%eax),%edx
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	89 10                	mov    %edx,(%eax)
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	83 e8 04             	sub    $0x4,%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	ba 00 00 00 00       	mov    $0x0,%edx
  800905:	eb 1c                	jmp    800923 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	8d 50 04             	lea    0x4(%eax),%edx
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	89 10                	mov    %edx,(%eax)
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	83 e8 04             	sub    $0x4,%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800928:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80092c:	7e 1c                	jle    80094a <getint+0x25>
		return va_arg(*ap, long long);
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	8d 50 08             	lea    0x8(%eax),%edx
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	89 10                	mov    %edx,(%eax)
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	83 e8 08             	sub    $0x8,%eax
  800943:	8b 50 04             	mov    0x4(%eax),%edx
  800946:	8b 00                	mov    (%eax),%eax
  800948:	eb 38                	jmp    800982 <getint+0x5d>
	else if (lflag)
  80094a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094e:	74 1a                	je     80096a <getint+0x45>
		return va_arg(*ap, long);
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8b 00                	mov    (%eax),%eax
  800955:	8d 50 04             	lea    0x4(%eax),%edx
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	89 10                	mov    %edx,(%eax)
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	8b 00                	mov    (%eax),%eax
  800962:	83 e8 04             	sub    $0x4,%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	99                   	cltd   
  800968:	eb 18                	jmp    800982 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	8d 50 04             	lea    0x4(%eax),%edx
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	89 10                	mov    %edx,(%eax)
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	83 e8 04             	sub    $0x4,%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	99                   	cltd   
}
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80098c:	eb 17                	jmp    8009a5 <vprintfmt+0x21>
			if (ch == '\0')
  80098e:	85 db                	test   %ebx,%ebx
  800990:	0f 84 c1 03 00 00    	je     800d57 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	53                   	push   %ebx
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	ff d0                	call   *%eax
  8009a2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a8:	8d 50 01             	lea    0x1(%eax),%edx
  8009ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ae:	8a 00                	mov    (%eax),%al
  8009b0:	0f b6 d8             	movzbl %al,%ebx
  8009b3:	83 fb 25             	cmp    $0x25,%ebx
  8009b6:	75 d6                	jne    80098e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009bc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009db:	8d 50 01             	lea    0x1(%eax),%edx
  8009de:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f b6 d8             	movzbl %al,%ebx
  8009e6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e9:	83 f8 5b             	cmp    $0x5b,%eax
  8009ec:	0f 87 3d 03 00 00    	ja     800d2f <vprintfmt+0x3ab>
  8009f2:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  8009f9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009fb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ff:	eb d7                	jmp    8009d8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a01:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a05:	eb d1                	jmp    8009d8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a11:	89 d0                	mov    %edx,%eax
  800a13:	c1 e0 02             	shl    $0x2,%eax
  800a16:	01 d0                	add    %edx,%eax
  800a18:	01 c0                	add    %eax,%eax
  800a1a:	01 d8                	add    %ebx,%eax
  800a1c:	83 e8 30             	sub    $0x30,%eax
  800a1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a22:	8b 45 10             	mov    0x10(%ebp),%eax
  800a25:	8a 00                	mov    (%eax),%al
  800a27:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a2a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a2d:	7e 3e                	jle    800a6d <vprintfmt+0xe9>
  800a2f:	83 fb 39             	cmp    $0x39,%ebx
  800a32:	7f 39                	jg     800a6d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a34:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a37:	eb d5                	jmp    800a0e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 c0 04             	add    $0x4,%eax
  800a3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a42:	8b 45 14             	mov    0x14(%ebp),%eax
  800a45:	83 e8 04             	sub    $0x4,%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a4d:	eb 1f                	jmp    800a6e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a53:	79 83                	jns    8009d8 <vprintfmt+0x54>
				width = 0;
  800a55:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a5c:	e9 77 ff ff ff       	jmp    8009d8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a61:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a68:	e9 6b ff ff ff       	jmp    8009d8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a6d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a72:	0f 89 60 ff ff ff    	jns    8009d8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a85:	e9 4e ff ff ff       	jmp    8009d8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a8a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a8d:	e9 46 ff ff ff       	jmp    8009d8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a92:	8b 45 14             	mov    0x14(%ebp),%eax
  800a95:	83 c0 04             	add    $0x4,%eax
  800a98:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9e:	83 e8 04             	sub    $0x4,%eax
  800aa1:	8b 00                	mov    (%eax),%eax
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	50                   	push   %eax
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	ff d0                	call   *%eax
  800aaf:	83 c4 10             	add    $0x10,%esp
			break;
  800ab2:	e9 9b 02 00 00       	jmp    800d52 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	83 c0 04             	add    $0x4,%eax
  800abd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	83 e8 04             	sub    $0x4,%eax
  800ac6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac8:	85 db                	test   %ebx,%ebx
  800aca:	79 02                	jns    800ace <vprintfmt+0x14a>
				err = -err;
  800acc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ace:	83 fb 64             	cmp    $0x64,%ebx
  800ad1:	7f 0b                	jg     800ade <vprintfmt+0x15a>
  800ad3:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  800ada:	85 f6                	test   %esi,%esi
  800adc:	75 19                	jne    800af7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ade:	53                   	push   %ebx
  800adf:	68 a5 28 80 00       	push   $0x8028a5
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	ff 75 08             	pushl  0x8(%ebp)
  800aea:	e8 70 02 00 00       	call   800d5f <printfmt>
  800aef:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af2:	e9 5b 02 00 00       	jmp    800d52 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af7:	56                   	push   %esi
  800af8:	68 ae 28 80 00       	push   $0x8028ae
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 57 02 00 00       	call   800d5f <printfmt>
  800b08:	83 c4 10             	add    $0x10,%esp
			break;
  800b0b:	e9 42 02 00 00       	jmp    800d52 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b10:	8b 45 14             	mov    0x14(%ebp),%eax
  800b13:	83 c0 04             	add    $0x4,%eax
  800b16:	89 45 14             	mov    %eax,0x14(%ebp)
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	83 e8 04             	sub    $0x4,%eax
  800b1f:	8b 30                	mov    (%eax),%esi
  800b21:	85 f6                	test   %esi,%esi
  800b23:	75 05                	jne    800b2a <vprintfmt+0x1a6>
				p = "(null)";
  800b25:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  800b2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2e:	7e 6d                	jle    800b9d <vprintfmt+0x219>
  800b30:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b34:	74 67                	je     800b9d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b39:	83 ec 08             	sub    $0x8,%esp
  800b3c:	50                   	push   %eax
  800b3d:	56                   	push   %esi
  800b3e:	e8 26 05 00 00       	call   801069 <strnlen>
  800b43:	83 c4 10             	add    $0x10,%esp
  800b46:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b49:	eb 16                	jmp    800b61 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b4b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	50                   	push   %eax
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	ff d0                	call   *%eax
  800b5b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b65:	7f e4                	jg     800b4b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b67:	eb 34                	jmp    800b9d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b69:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b6d:	74 1c                	je     800b8b <vprintfmt+0x207>
  800b6f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b72:	7e 05                	jle    800b79 <vprintfmt+0x1f5>
  800b74:	83 fb 7e             	cmp    $0x7e,%ebx
  800b77:	7e 12                	jle    800b8b <vprintfmt+0x207>
					putch('?', putdat);
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	ff 75 0c             	pushl  0xc(%ebp)
  800b7f:	6a 3f                	push   $0x3f
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	eb 0f                	jmp    800b9a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	ff 75 0c             	pushl  0xc(%ebp)
  800b91:	53                   	push   %ebx
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9d:	89 f0                	mov    %esi,%eax
  800b9f:	8d 70 01             	lea    0x1(%eax),%esi
  800ba2:	8a 00                	mov    (%eax),%al
  800ba4:	0f be d8             	movsbl %al,%ebx
  800ba7:	85 db                	test   %ebx,%ebx
  800ba9:	74 24                	je     800bcf <vprintfmt+0x24b>
  800bab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800baf:	78 b8                	js     800b69 <vprintfmt+0x1e5>
  800bb1:	ff 4d e0             	decl   -0x20(%ebp)
  800bb4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb8:	79 af                	jns    800b69 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bba:	eb 13                	jmp    800bcf <vprintfmt+0x24b>
				putch(' ', putdat);
  800bbc:	83 ec 08             	sub    $0x8,%esp
  800bbf:	ff 75 0c             	pushl  0xc(%ebp)
  800bc2:	6a 20                	push   $0x20
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	ff d0                	call   *%eax
  800bc9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcc:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd3:	7f e7                	jg     800bbc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd5:	e9 78 01 00 00       	jmp    800d52 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 e8             	pushl  -0x18(%ebp)
  800be0:	8d 45 14             	lea    0x14(%ebp),%eax
  800be3:	50                   	push   %eax
  800be4:	e8 3c fd ff ff       	call   800925 <getint>
  800be9:	83 c4 10             	add    $0x10,%esp
  800bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf8:	85 d2                	test   %edx,%edx
  800bfa:	79 23                	jns    800c1f <vprintfmt+0x29b>
				putch('-', putdat);
  800bfc:	83 ec 08             	sub    $0x8,%esp
  800bff:	ff 75 0c             	pushl  0xc(%ebp)
  800c02:	6a 2d                	push   $0x2d
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	ff d0                	call   *%eax
  800c09:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c12:	f7 d8                	neg    %eax
  800c14:	83 d2 00             	adc    $0x0,%edx
  800c17:	f7 da                	neg    %edx
  800c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c26:	e9 bc 00 00 00       	jmp    800ce7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c2b:	83 ec 08             	sub    $0x8,%esp
  800c2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c31:	8d 45 14             	lea    0x14(%ebp),%eax
  800c34:	50                   	push   %eax
  800c35:	e8 84 fc ff ff       	call   8008be <getuint>
  800c3a:	83 c4 10             	add    $0x10,%esp
  800c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c43:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c4a:	e9 98 00 00 00       	jmp    800ce7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	6a 58                	push   $0x58
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6f:	83 ec 08             	sub    $0x8,%esp
  800c72:	ff 75 0c             	pushl  0xc(%ebp)
  800c75:	6a 58                	push   $0x58
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	ff d0                	call   *%eax
  800c7c:	83 c4 10             	add    $0x10,%esp
			break;
  800c7f:	e9 ce 00 00 00       	jmp    800d52 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c84:	83 ec 08             	sub    $0x8,%esp
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	6a 30                	push   $0x30
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	ff d0                	call   *%eax
  800c91:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c94:	83 ec 08             	sub    $0x8,%esp
  800c97:	ff 75 0c             	pushl  0xc(%ebp)
  800c9a:	6a 78                	push   $0x78
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	ff d0                	call   *%eax
  800ca1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca7:	83 c0 04             	add    $0x4,%eax
  800caa:	89 45 14             	mov    %eax,0x14(%ebp)
  800cad:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb0:	83 e8 04             	sub    $0x4,%eax
  800cb3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc6:	eb 1f                	jmp    800ce7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc8:	83 ec 08             	sub    $0x8,%esp
  800ccb:	ff 75 e8             	pushl  -0x18(%ebp)
  800cce:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd1:	50                   	push   %eax
  800cd2:	e8 e7 fb ff ff       	call   8008be <getuint>
  800cd7:	83 c4 10             	add    $0x10,%esp
  800cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cdd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ceb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cee:	83 ec 04             	sub    $0x4,%esp
  800cf1:	52                   	push   %edx
  800cf2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf5:	50                   	push   %eax
  800cf6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	ff 75 08             	pushl  0x8(%ebp)
  800d02:	e8 00 fb ff ff       	call   800807 <printnum>
  800d07:	83 c4 20             	add    $0x20,%esp
			break;
  800d0a:	eb 46                	jmp    800d52 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	53                   	push   %ebx
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	ff d0                	call   *%eax
  800d18:	83 c4 10             	add    $0x10,%esp
			break;
  800d1b:	eb 35                	jmp    800d52 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d1d:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d24:	eb 2c                	jmp    800d52 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d26:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d2d:	eb 23                	jmp    800d52 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2f:	83 ec 08             	sub    $0x8,%esp
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	6a 25                	push   $0x25
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	ff d0                	call   *%eax
  800d3c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d3f:	ff 4d 10             	decl   0x10(%ebp)
  800d42:	eb 03                	jmp    800d47 <vprintfmt+0x3c3>
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	48                   	dec    %eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	3c 25                	cmp    $0x25,%al
  800d4f:	75 f3                	jne    800d44 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d51:	90                   	nop
		}
	}
  800d52:	e9 35 fc ff ff       	jmp    80098c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d57:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d65:	8d 45 10             	lea    0x10(%ebp),%eax
  800d68:	83 c0 04             	add    $0x4,%eax
  800d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d71:	ff 75 f4             	pushl  -0xc(%ebp)
  800d74:	50                   	push   %eax
  800d75:	ff 75 0c             	pushl  0xc(%ebp)
  800d78:	ff 75 08             	pushl  0x8(%ebp)
  800d7b:	e8 04 fc ff ff       	call   800984 <vprintfmt>
  800d80:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d83:	90                   	nop
  800d84:	c9                   	leave  
  800d85:	c3                   	ret    

00800d86 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8b 40 08             	mov    0x8(%eax),%eax
  800d8f:	8d 50 01             	lea    0x1(%eax),%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8b 10                	mov    (%eax),%edx
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	8b 40 04             	mov    0x4(%eax),%eax
  800da3:	39 c2                	cmp    %eax,%edx
  800da5:	73 12                	jae    800db9 <sprintputch+0x33>
		*b->buf++ = ch;
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	8d 48 01             	lea    0x1(%eax),%ecx
  800daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db2:	89 0a                	mov    %ecx,(%edx)
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	88 10                	mov    %dl,(%eax)
}
  800db9:	90                   	nop
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	01 d0                	add    %edx,%eax
  800dd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ddd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de1:	74 06                	je     800de9 <vsnprintf+0x2d>
  800de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de7:	7f 07                	jg     800df0 <vsnprintf+0x34>
		return -E_INVAL;
  800de9:	b8 03 00 00 00       	mov    $0x3,%eax
  800dee:	eb 20                	jmp    800e10 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df0:	ff 75 14             	pushl  0x14(%ebp)
  800df3:	ff 75 10             	pushl  0x10(%ebp)
  800df6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df9:	50                   	push   %eax
  800dfa:	68 86 0d 80 00       	push   $0x800d86
  800dff:	e8 80 fb ff ff       	call   800984 <vprintfmt>
  800e04:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e0a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e18:	8d 45 10             	lea    0x10(%ebp),%eax
  800e1b:	83 c0 04             	add    $0x4,%eax
  800e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	ff 75 f4             	pushl  -0xc(%ebp)
  800e27:	50                   	push   %eax
  800e28:	ff 75 0c             	pushl  0xc(%ebp)
  800e2b:	ff 75 08             	pushl  0x8(%ebp)
  800e2e:	e8 89 ff ff ff       	call   800dbc <vsnprintf>
  800e33:	83 c4 10             	add    $0x10,%esp
  800e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e48:	74 13                	je     800e5d <readline+0x1f>
		cprintf("%s", prompt);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 08             	pushl  0x8(%ebp)
  800e50:	68 28 2a 80 00       	push   $0x802a28
  800e55:	e8 0b f9 ff ff       	call   800765 <cprintf>
  800e5a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	6a 00                	push   $0x0
  800e69:	e8 7f 10 00 00       	call   801eed <iscons>
  800e6e:	83 c4 10             	add    $0x10,%esp
  800e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e74:	e8 61 10 00 00       	call   801eda <getchar>
  800e79:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e80:	79 22                	jns    800ea4 <readline+0x66>
			if (c != -E_EOF)
  800e82:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e86:	0f 84 ad 00 00 00    	je     800f39 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800e8c:	83 ec 08             	sub    $0x8,%esp
  800e8f:	ff 75 ec             	pushl  -0x14(%ebp)
  800e92:	68 2b 2a 80 00       	push   $0x802a2b
  800e97:	e8 c9 f8 ff ff       	call   800765 <cprintf>
  800e9c:	83 c4 10             	add    $0x10,%esp
			break;
  800e9f:	e9 95 00 00 00       	jmp    800f39 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ea4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ea8:	7e 34                	jle    800ede <readline+0xa0>
  800eaa:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800eb1:	7f 2b                	jg     800ede <readline+0xa0>
			if (echoing)
  800eb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eb7:	74 0e                	je     800ec7 <readline+0x89>
				cputchar(c);
  800eb9:	83 ec 0c             	sub    $0xc,%esp
  800ebc:	ff 75 ec             	pushl  -0x14(%ebp)
  800ebf:	e8 f7 0f 00 00       	call   801ebb <cputchar>
  800ec4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eca:	8d 50 01             	lea    0x1(%eax),%edx
  800ecd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ed0:	89 c2                	mov    %eax,%edx
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	01 d0                	add    %edx,%eax
  800ed7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800eda:	88 10                	mov    %dl,(%eax)
  800edc:	eb 56                	jmp    800f34 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ede:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ee2:	75 1f                	jne    800f03 <readline+0xc5>
  800ee4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ee8:	7e 19                	jle    800f03 <readline+0xc5>
			if (echoing)
  800eea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eee:	74 0e                	je     800efe <readline+0xc0>
				cputchar(c);
  800ef0:	83 ec 0c             	sub    $0xc,%esp
  800ef3:	ff 75 ec             	pushl  -0x14(%ebp)
  800ef6:	e8 c0 0f 00 00       	call   801ebb <cputchar>
  800efb:	83 c4 10             	add    $0x10,%esp

			i--;
  800efe:	ff 4d f4             	decl   -0xc(%ebp)
  800f01:	eb 31                	jmp    800f34 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800f03:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800f07:	74 0a                	je     800f13 <readline+0xd5>
  800f09:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800f0d:	0f 85 61 ff ff ff    	jne    800e74 <readline+0x36>
			if (echoing)
  800f13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f17:	74 0e                	je     800f27 <readline+0xe9>
				cputchar(c);
  800f19:	83 ec 0c             	sub    $0xc,%esp
  800f1c:	ff 75 ec             	pushl  -0x14(%ebp)
  800f1f:	e8 97 0f 00 00       	call   801ebb <cputchar>
  800f24:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	01 d0                	add    %edx,%eax
  800f2f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800f32:	eb 06                	jmp    800f3a <readline+0xfc>
		}
	}
  800f34:	e9 3b ff ff ff       	jmp    800e74 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800f39:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800f3a:	90                   	nop
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f43:	e8 79 09 00 00       	call   8018c1 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f4c:	74 13                	je     800f61 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f4e:	83 ec 08             	sub    $0x8,%esp
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	68 28 2a 80 00       	push   $0x802a28
  800f59:	e8 07 f8 ff ff       	call   800765 <cprintf>
  800f5e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	6a 00                	push   $0x0
  800f6d:	e8 7b 0f 00 00       	call   801eed <iscons>
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f78:	e8 5d 0f 00 00       	call   801eda <getchar>
  800f7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f84:	79 22                	jns    800fa8 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f86:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800f8a:	0f 84 ad 00 00 00    	je     80103d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800f90:	83 ec 08             	sub    $0x8,%esp
  800f93:	ff 75 ec             	pushl  -0x14(%ebp)
  800f96:	68 2b 2a 80 00       	push   $0x802a2b
  800f9b:	e8 c5 f7 ff ff       	call   800765 <cprintf>
  800fa0:	83 c4 10             	add    $0x10,%esp
				break;
  800fa3:	e9 95 00 00 00       	jmp    80103d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800fa8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800fac:	7e 34                	jle    800fe2 <atomic_readline+0xa5>
  800fae:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800fb5:	7f 2b                	jg     800fe2 <atomic_readline+0xa5>
				if (echoing)
  800fb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fbb:	74 0e                	je     800fcb <atomic_readline+0x8e>
					cputchar(c);
  800fbd:	83 ec 0c             	sub    $0xc,%esp
  800fc0:	ff 75 ec             	pushl  -0x14(%ebp)
  800fc3:	e8 f3 0e 00 00       	call   801ebb <cputchar>
  800fc8:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fce:	8d 50 01             	lea    0x1(%eax),%edx
  800fd1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800fd4:	89 c2                	mov    %eax,%edx
  800fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd9:	01 d0                	add    %edx,%eax
  800fdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fde:	88 10                	mov    %dl,(%eax)
  800fe0:	eb 56                	jmp    801038 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800fe2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800fe6:	75 1f                	jne    801007 <atomic_readline+0xca>
  800fe8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fec:	7e 19                	jle    801007 <atomic_readline+0xca>
				if (echoing)
  800fee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ff2:	74 0e                	je     801002 <atomic_readline+0xc5>
					cputchar(c);
  800ff4:	83 ec 0c             	sub    $0xc,%esp
  800ff7:	ff 75 ec             	pushl  -0x14(%ebp)
  800ffa:	e8 bc 0e 00 00       	call   801ebb <cputchar>
  800fff:	83 c4 10             	add    $0x10,%esp
				i--;
  801002:	ff 4d f4             	decl   -0xc(%ebp)
  801005:	eb 31                	jmp    801038 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801007:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80100b:	74 0a                	je     801017 <atomic_readline+0xda>
  80100d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801011:	0f 85 61 ff ff ff    	jne    800f78 <atomic_readline+0x3b>
				if (echoing)
  801017:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80101b:	74 0e                	je     80102b <atomic_readline+0xee>
					cputchar(c);
  80101d:	83 ec 0c             	sub    $0xc,%esp
  801020:	ff 75 ec             	pushl  -0x14(%ebp)
  801023:	e8 93 0e 00 00       	call   801ebb <cputchar>
  801028:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80102b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	01 d0                	add    %edx,%eax
  801033:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801036:	eb 06                	jmp    80103e <atomic_readline+0x101>
			}
		}
  801038:	e9 3b ff ff ff       	jmp    800f78 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80103d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80103e:	e8 98 08 00 00       	call   8018db <sys_unlock_cons>
}
  801043:	90                   	nop
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80104c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801053:	eb 06                	jmp    80105b <strlen+0x15>
		n++;
  801055:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8a 00                	mov    (%eax),%al
  801060:	84 c0                	test   %al,%al
  801062:	75 f1                	jne    801055 <strlen+0xf>
		n++;
	return n;
  801064:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801067:	c9                   	leave  
  801068:	c3                   	ret    

00801069 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801076:	eb 09                	jmp    801081 <strnlen+0x18>
		n++;
  801078:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107b:	ff 45 08             	incl   0x8(%ebp)
  80107e:	ff 4d 0c             	decl   0xc(%ebp)
  801081:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801085:	74 09                	je     801090 <strnlen+0x27>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	84 c0                	test   %al,%al
  80108e:	75 e8                	jne    801078 <strnlen+0xf>
		n++;
	return n;
  801090:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010a1:	90                   	nop
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8d 50 01             	lea    0x1(%eax),%edx
  8010a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010b4:	8a 12                	mov    (%edx),%dl
  8010b6:	88 10                	mov    %dl,(%eax)
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	84 c0                	test   %al,%al
  8010bc:	75 e4                	jne    8010a2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d6:	eb 1f                	jmp    8010f7 <strncpy+0x34>
		*dst++ = *src;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8d 50 01             	lea    0x1(%eax),%edx
  8010de:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e4:	8a 12                	mov    (%edx),%dl
  8010e6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	84 c0                	test   %al,%al
  8010ef:	74 03                	je     8010f4 <strncpy+0x31>
			src++;
  8010f1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010f4:	ff 45 fc             	incl   -0x4(%ebp)
  8010f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010fd:	72 d9                	jb     8010d8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801110:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801114:	74 30                	je     801146 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801116:	eb 16                	jmp    80112e <strlcpy+0x2a>
			*dst++ = *src++;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8d 50 01             	lea    0x1(%eax),%edx
  80111e:	89 55 08             	mov    %edx,0x8(%ebp)
  801121:	8b 55 0c             	mov    0xc(%ebp),%edx
  801124:	8d 4a 01             	lea    0x1(%edx),%ecx
  801127:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80112a:	8a 12                	mov    (%edx),%dl
  80112c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80112e:	ff 4d 10             	decl   0x10(%ebp)
  801131:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801135:	74 09                	je     801140 <strlcpy+0x3c>
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	84 c0                	test   %al,%al
  80113e:	75 d8                	jne    801118 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801146:	8b 55 08             	mov    0x8(%ebp),%edx
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114c:	29 c2                	sub    %eax,%edx
  80114e:	89 d0                	mov    %edx,%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801155:	eb 06                	jmp    80115d <strcmp+0xb>
		p++, q++;
  801157:	ff 45 08             	incl   0x8(%ebp)
  80115a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	74 0e                	je     801174 <strcmp+0x22>
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 10                	mov    (%eax),%dl
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	38 c2                	cmp    %al,%dl
  801172:	74 e3                	je     801157 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	0f b6 d0             	movzbl %al,%edx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	0f b6 c0             	movzbl %al,%eax
  801184:	29 c2                	sub    %eax,%edx
  801186:	89 d0                	mov    %edx,%eax
}
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    

0080118a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80118d:	eb 09                	jmp    801198 <strncmp+0xe>
		n--, p++, q++;
  80118f:	ff 4d 10             	decl   0x10(%ebp)
  801192:	ff 45 08             	incl   0x8(%ebp)
  801195:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801198:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119c:	74 17                	je     8011b5 <strncmp+0x2b>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	84 c0                	test   %al,%al
  8011a5:	74 0e                	je     8011b5 <strncmp+0x2b>
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	8a 10                	mov    (%eax),%dl
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	38 c2                	cmp    %al,%dl
  8011b3:	74 da                	je     80118f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b9:	75 07                	jne    8011c2 <strncmp+0x38>
		return 0;
  8011bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c0:	eb 14                	jmp    8011d6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	0f b6 d0             	movzbl %al,%edx
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	0f b6 c0             	movzbl %al,%eax
  8011d2:	29 c2                	sub    %eax,%edx
  8011d4:	89 d0                	mov    %edx,%eax
}
  8011d6:	5d                   	pop    %ebp
  8011d7:	c3                   	ret    

008011d8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 04             	sub    $0x4,%esp
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e4:	eb 12                	jmp    8011f8 <strchr+0x20>
		if (*s == c)
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ee:	75 05                	jne    8011f5 <strchr+0x1d>
			return (char *) s;
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	eb 11                	jmp    801206 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011f5:	ff 45 08             	incl   0x8(%ebp)
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	84 c0                	test   %al,%al
  8011ff:	75 e5                	jne    8011e6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801201:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801214:	eb 0d                	jmp    801223 <strfind+0x1b>
		if (*s == c)
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80121e:	74 0e                	je     80122e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801220:	ff 45 08             	incl   0x8(%ebp)
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	84 c0                	test   %al,%al
  80122a:	75 ea                	jne    801216 <strfind+0xe>
  80122c:	eb 01                	jmp    80122f <strfind+0x27>
		if (*s == c)
			break;
  80122e:	90                   	nop
	return (char *) s;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801232:	c9                   	leave  
  801233:	c3                   	ret    

00801234 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801240:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801244:	76 63                	jbe    8012a9 <memset+0x75>
		uint64 data_block = c;
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	99                   	cltd   
  80124a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80124d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801256:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80125a:	c1 e0 08             	shl    $0x8,%eax
  80125d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801260:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801269:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80126d:	c1 e0 10             	shl    $0x10,%eax
  801270:	09 45 f0             	or     %eax,-0x10(%ebp)
  801273:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801279:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127c:	89 c2                	mov    %eax,%edx
  80127e:	b8 00 00 00 00       	mov    $0x0,%eax
  801283:	09 45 f0             	or     %eax,-0x10(%ebp)
  801286:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801289:	eb 18                	jmp    8012a3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80128b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80128e:	8d 41 08             	lea    0x8(%ecx),%eax
  801291:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129a:	89 01                	mov    %eax,(%ecx)
  80129c:	89 51 04             	mov    %edx,0x4(%ecx)
  80129f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8012a3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012a7:	77 e2                	ja     80128b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8012a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ad:	74 23                	je     8012d2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8012af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012b5:	eb 0e                	jmp    8012c5 <memset+0x91>
			*p8++ = (uint8)c;
  8012b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ba:	8d 50 01             	lea    0x1(%eax),%edx
  8012bd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8012c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ce:	85 c0                	test   %eax,%eax
  8012d0:	75 e5                	jne    8012b7 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8012e9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012ed:	76 24                	jbe    801313 <memcpy+0x3c>
		while(n >= 8){
  8012ef:	eb 1c                	jmp    80130d <memcpy+0x36>
			*d64 = *s64;
  8012f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f4:	8b 50 04             	mov    0x4(%eax),%edx
  8012f7:	8b 00                	mov    (%eax),%eax
  8012f9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012fc:	89 01                	mov    %eax,(%ecx)
  8012fe:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801301:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801305:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801309:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80130d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801311:	77 de                	ja     8012f1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801313:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801317:	74 31                	je     80134a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801319:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80131f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801322:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801325:	eb 16                	jmp    80133d <memcpy+0x66>
			*d8++ = *s8++;
  801327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80132a:	8d 50 01             	lea    0x1(%eax),%edx
  80132d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801333:	8d 4a 01             	lea    0x1(%edx),%ecx
  801336:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801339:	8a 12                	mov    (%edx),%dl
  80133b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80133d:	8b 45 10             	mov    0x10(%ebp),%eax
  801340:	8d 50 ff             	lea    -0x1(%eax),%edx
  801343:	89 55 10             	mov    %edx,0x10(%ebp)
  801346:	85 c0                	test   %eax,%eax
  801348:	75 dd                	jne    801327 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801361:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801364:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801367:	73 50                	jae    8013b9 <memmove+0x6a>
  801369:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136c:	8b 45 10             	mov    0x10(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801374:	76 43                	jbe    8013b9 <memmove+0x6a>
		s += n;
  801376:	8b 45 10             	mov    0x10(%ebp),%eax
  801379:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80137c:	8b 45 10             	mov    0x10(%ebp),%eax
  80137f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801382:	eb 10                	jmp    801394 <memmove+0x45>
			*--d = *--s;
  801384:	ff 4d f8             	decl   -0x8(%ebp)
  801387:	ff 4d fc             	decl   -0x4(%ebp)
  80138a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138d:	8a 10                	mov    (%eax),%dl
  80138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801392:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801394:	8b 45 10             	mov    0x10(%ebp),%eax
  801397:	8d 50 ff             	lea    -0x1(%eax),%edx
  80139a:	89 55 10             	mov    %edx,0x10(%ebp)
  80139d:	85 c0                	test   %eax,%eax
  80139f:	75 e3                	jne    801384 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013a1:	eb 23                	jmp    8013c6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a6:	8d 50 01             	lea    0x1(%eax),%edx
  8013a9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013b2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013b5:	8a 12                	mov    (%edx),%dl
  8013b7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	75 dd                	jne    8013a3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013dd:	eb 2a                	jmp    801409 <memcmp+0x3e>
		if (*s1 != *s2)
  8013df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e2:	8a 10                	mov    (%eax),%dl
  8013e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	38 c2                	cmp    %al,%dl
  8013eb:	74 16                	je     801403 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	0f b6 d0             	movzbl %al,%edx
  8013f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	0f b6 c0             	movzbl %al,%eax
  8013fd:	29 c2                	sub    %eax,%edx
  8013ff:	89 d0                	mov    %edx,%eax
  801401:	eb 18                	jmp    80141b <memcmp+0x50>
		s1++, s2++;
  801403:	ff 45 fc             	incl   -0x4(%ebp)
  801406:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801409:	8b 45 10             	mov    0x10(%ebp),%eax
  80140c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80140f:	89 55 10             	mov    %edx,0x10(%ebp)
  801412:	85 c0                	test   %eax,%eax
  801414:	75 c9                	jne    8013df <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801416:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801423:	8b 55 08             	mov    0x8(%ebp),%edx
  801426:	8b 45 10             	mov    0x10(%ebp),%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80142e:	eb 15                	jmp    801445 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	0f b6 d0             	movzbl %al,%edx
  801438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143b:	0f b6 c0             	movzbl %al,%eax
  80143e:	39 c2                	cmp    %eax,%edx
  801440:	74 0d                	je     80144f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801442:	ff 45 08             	incl   0x8(%ebp)
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80144b:	72 e3                	jb     801430 <memfind+0x13>
  80144d:	eb 01                	jmp    801450 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80144f:	90                   	nop
	return (void *) s;
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80145b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801462:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801469:	eb 03                	jmp    80146e <strtol+0x19>
		s++;
  80146b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	3c 20                	cmp    $0x20,%al
  801475:	74 f4                	je     80146b <strtol+0x16>
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	3c 09                	cmp    $0x9,%al
  80147e:	74 eb                	je     80146b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	8a 00                	mov    (%eax),%al
  801485:	3c 2b                	cmp    $0x2b,%al
  801487:	75 05                	jne    80148e <strtol+0x39>
		s++;
  801489:	ff 45 08             	incl   0x8(%ebp)
  80148c:	eb 13                	jmp    8014a1 <strtol+0x4c>
	else if (*s == '-')
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	3c 2d                	cmp    $0x2d,%al
  801495:	75 0a                	jne    8014a1 <strtol+0x4c>
		s++, neg = 1;
  801497:	ff 45 08             	incl   0x8(%ebp)
  80149a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a5:	74 06                	je     8014ad <strtol+0x58>
  8014a7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014ab:	75 20                	jne    8014cd <strtol+0x78>
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	8a 00                	mov    (%eax),%al
  8014b2:	3c 30                	cmp    $0x30,%al
  8014b4:	75 17                	jne    8014cd <strtol+0x78>
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	40                   	inc    %eax
  8014ba:	8a 00                	mov    (%eax),%al
  8014bc:	3c 78                	cmp    $0x78,%al
  8014be:	75 0d                	jne    8014cd <strtol+0x78>
		s += 2, base = 16;
  8014c0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014c4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014cb:	eb 28                	jmp    8014f5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d1:	75 15                	jne    8014e8 <strtol+0x93>
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 30                	cmp    $0x30,%al
  8014da:	75 0c                	jne    8014e8 <strtol+0x93>
		s++, base = 8;
  8014dc:	ff 45 08             	incl   0x8(%ebp)
  8014df:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014e6:	eb 0d                	jmp    8014f5 <strtol+0xa0>
	else if (base == 0)
  8014e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ec:	75 07                	jne    8014f5 <strtol+0xa0>
		base = 10;
  8014ee:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	3c 2f                	cmp    $0x2f,%al
  8014fc:	7e 19                	jle    801517 <strtol+0xc2>
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	3c 39                	cmp    $0x39,%al
  801505:	7f 10                	jg     801517 <strtol+0xc2>
			dig = *s - '0';
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f be c0             	movsbl %al,%eax
  80150f:	83 e8 30             	sub    $0x30,%eax
  801512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801515:	eb 42                	jmp    801559 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	8a 00                	mov    (%eax),%al
  80151c:	3c 60                	cmp    $0x60,%al
  80151e:	7e 19                	jle    801539 <strtol+0xe4>
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	8a 00                	mov    (%eax),%al
  801525:	3c 7a                	cmp    $0x7a,%al
  801527:	7f 10                	jg     801539 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	0f be c0             	movsbl %al,%eax
  801531:	83 e8 57             	sub    $0x57,%eax
  801534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801537:	eb 20                	jmp    801559 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	3c 40                	cmp    $0x40,%al
  801540:	7e 39                	jle    80157b <strtol+0x126>
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	3c 5a                	cmp    $0x5a,%al
  801549:	7f 30                	jg     80157b <strtol+0x126>
			dig = *s - 'A' + 10;
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	0f be c0             	movsbl %al,%eax
  801553:	83 e8 37             	sub    $0x37,%eax
  801556:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80155f:	7d 19                	jge    80157a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801561:	ff 45 08             	incl   0x8(%ebp)
  801564:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801567:	0f af 45 10          	imul   0x10(%ebp),%eax
  80156b:	89 c2                	mov    %eax,%edx
  80156d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801570:	01 d0                	add    %edx,%eax
  801572:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801575:	e9 7b ff ff ff       	jmp    8014f5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80157a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80157b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80157f:	74 08                	je     801589 <strtol+0x134>
		*endptr = (char *) s;
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	8b 55 08             	mov    0x8(%ebp),%edx
  801587:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801589:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80158d:	74 07                	je     801596 <strtol+0x141>
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	f7 d8                	neg    %eax
  801594:	eb 03                	jmp    801599 <strtol+0x144>
  801596:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <ltostr>:

void
ltostr(long value, char *str)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b3:	79 13                	jns    8015c8 <ltostr+0x2d>
	{
		neg = 1;
  8015b5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015c2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015c5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015d0:	99                   	cltd   
  8015d1:	f7 f9                	idiv   %ecx
  8015d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d9:	8d 50 01             	lea    0x1(%eax),%edx
  8015dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015df:	89 c2                	mov    %eax,%edx
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	01 d0                	add    %edx,%eax
  8015e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e9:	83 c2 30             	add    $0x30,%edx
  8015ec:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015f1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015f6:	f7 e9                	imul   %ecx
  8015f8:	c1 fa 02             	sar    $0x2,%edx
  8015fb:	89 c8                	mov    %ecx,%eax
  8015fd:	c1 f8 1f             	sar    $0x1f,%eax
  801600:	29 c2                	sub    %eax,%edx
  801602:	89 d0                	mov    %edx,%eax
  801604:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801607:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80160b:	75 bb                	jne    8015c8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80160d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801614:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801617:	48                   	dec    %eax
  801618:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80161b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80161f:	74 3d                	je     80165e <ltostr+0xc3>
		start = 1 ;
  801621:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801628:	eb 34                	jmp    80165e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80162a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801630:	01 d0                	add    %edx,%eax
  801632:	8a 00                	mov    (%eax),%al
  801634:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801637:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	01 c2                	add    %eax,%edx
  80163f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801642:	8b 45 0c             	mov    0xc(%ebp),%eax
  801645:	01 c8                	add    %ecx,%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80164b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80164e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801651:	01 c2                	add    %eax,%edx
  801653:	8a 45 eb             	mov    -0x15(%ebp),%al
  801656:	88 02                	mov    %al,(%edx)
		start++ ;
  801658:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80165b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80165e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801661:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801664:	7c c4                	jl     80162a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801666:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166c:	01 d0                	add    %edx,%eax
  80166e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801671:	90                   	nop
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80167a:	ff 75 08             	pushl  0x8(%ebp)
  80167d:	e8 c4 f9 ff ff       	call   801046 <strlen>
  801682:	83 c4 04             	add    $0x4,%esp
  801685:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	e8 b6 f9 ff ff       	call   801046 <strlen>
  801690:	83 c4 04             	add    $0x4,%esp
  801693:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801696:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80169d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016a4:	eb 17                	jmp    8016bd <strcconcat+0x49>
		final[s] = str1[s] ;
  8016a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ac:	01 c2                	add    %eax,%edx
  8016ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	01 c8                	add    %ecx,%eax
  8016b6:	8a 00                	mov    (%eax),%al
  8016b8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016ba:	ff 45 fc             	incl   -0x4(%ebp)
  8016bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016c3:	7c e1                	jl     8016a6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016d3:	eb 1f                	jmp    8016f4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d8:	8d 50 01             	lea    0x1(%eax),%edx
  8016db:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016de:	89 c2                	mov    %eax,%edx
  8016e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e3:	01 c2                	add    %eax,%edx
  8016e5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016eb:	01 c8                	add    %ecx,%eax
  8016ed:	8a 00                	mov    (%eax),%al
  8016ef:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016f1:	ff 45 f8             	incl   -0x8(%ebp)
  8016f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016fa:	7c d9                	jl     8016d5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	01 d0                	add    %edx,%eax
  801704:	c6 00 00             	movb   $0x0,(%eax)
}
  801707:	90                   	nop
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80170d:	8b 45 14             	mov    0x14(%ebp),%eax
  801710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801716:	8b 45 14             	mov    0x14(%ebp),%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801722:	8b 45 10             	mov    0x10(%ebp),%eax
  801725:	01 d0                	add    %edx,%eax
  801727:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80172d:	eb 0c                	jmp    80173b <strsplit+0x31>
			*string++ = 0;
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	8d 50 01             	lea    0x1(%eax),%edx
  801735:	89 55 08             	mov    %edx,0x8(%ebp)
  801738:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	84 c0                	test   %al,%al
  801742:	74 18                	je     80175c <strsplit+0x52>
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	8a 00                	mov    (%eax),%al
  801749:	0f be c0             	movsbl %al,%eax
  80174c:	50                   	push   %eax
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	e8 83 fa ff ff       	call   8011d8 <strchr>
  801755:	83 c4 08             	add    $0x8,%esp
  801758:	85 c0                	test   %eax,%eax
  80175a:	75 d3                	jne    80172f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	84 c0                	test   %al,%al
  801763:	74 5a                	je     8017bf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801765:	8b 45 14             	mov    0x14(%ebp),%eax
  801768:	8b 00                	mov    (%eax),%eax
  80176a:	83 f8 0f             	cmp    $0xf,%eax
  80176d:	75 07                	jne    801776 <strsplit+0x6c>
		{
			return 0;
  80176f:	b8 00 00 00 00       	mov    $0x0,%eax
  801774:	eb 66                	jmp    8017dc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801776:	8b 45 14             	mov    0x14(%ebp),%eax
  801779:	8b 00                	mov    (%eax),%eax
  80177b:	8d 48 01             	lea    0x1(%eax),%ecx
  80177e:	8b 55 14             	mov    0x14(%ebp),%edx
  801781:	89 0a                	mov    %ecx,(%edx)
  801783:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80178a:	8b 45 10             	mov    0x10(%ebp),%eax
  80178d:	01 c2                	add    %eax,%edx
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801794:	eb 03                	jmp    801799 <strsplit+0x8f>
			string++;
  801796:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	8a 00                	mov    (%eax),%al
  80179e:	84 c0                	test   %al,%al
  8017a0:	74 8b                	je     80172d <strsplit+0x23>
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	8a 00                	mov    (%eax),%al
  8017a7:	0f be c0             	movsbl %al,%eax
  8017aa:	50                   	push   %eax
  8017ab:	ff 75 0c             	pushl  0xc(%ebp)
  8017ae:	e8 25 fa ff ff       	call   8011d8 <strchr>
  8017b3:	83 c4 08             	add    $0x8,%esp
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	74 dc                	je     801796 <strsplit+0x8c>
			string++;
	}
  8017ba:	e9 6e ff ff ff       	jmp    80172d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017bf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c3:	8b 00                	mov    (%eax),%eax
  8017c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cf:	01 d0                	add    %edx,%eax
  8017d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017d7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8017ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017f1:	eb 4a                	jmp    80183d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8017f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	01 c2                	add    %eax,%edx
  8017fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801801:	01 c8                	add    %ecx,%eax
  801803:	8a 00                	mov    (%eax),%al
  801805:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801807:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80180a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180d:	01 d0                	add    %edx,%eax
  80180f:	8a 00                	mov    (%eax),%al
  801811:	3c 40                	cmp    $0x40,%al
  801813:	7e 25                	jle    80183a <str2lower+0x5c>
  801815:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801818:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181b:	01 d0                	add    %edx,%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	3c 5a                	cmp    $0x5a,%al
  801821:	7f 17                	jg     80183a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801823:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	01 d0                	add    %edx,%eax
  80182b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80182e:	8b 55 08             	mov    0x8(%ebp),%edx
  801831:	01 ca                	add    %ecx,%edx
  801833:	8a 12                	mov    (%edx),%dl
  801835:	83 c2 20             	add    $0x20,%edx
  801838:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80183a:	ff 45 fc             	incl   -0x4(%ebp)
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	e8 01 f8 ff ff       	call   801046 <strlen>
  801845:	83 c4 04             	add    $0x4,%esp
  801848:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80184b:	7f a6                	jg     8017f3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80184d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	57                   	push   %edi
  801856:	56                   	push   %esi
  801857:	53                   	push   %ebx
  801858:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801861:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801864:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801867:	8b 7d 18             	mov    0x18(%ebp),%edi
  80186a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80186d:	cd 30                	int    $0x30
  80186f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801872:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	5b                   	pop    %ebx
  801879:	5e                   	pop    %esi
  80187a:	5f                   	pop    %edi
  80187b:	5d                   	pop    %ebp
  80187c:	c3                   	ret    

0080187d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 04             	sub    $0x4,%esp
  801883:	8b 45 10             	mov    0x10(%ebp),%eax
  801886:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801889:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80188c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	6a 00                	push   $0x0
  801895:	51                   	push   %ecx
  801896:	52                   	push   %edx
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	50                   	push   %eax
  80189b:	6a 00                	push   $0x0
  80189d:	e8 b0 ff ff ff       	call   801852 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	90                   	nop
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 02                	push   $0x2
  8018b7:	e8 96 ff ff ff       	call   801852 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 03                	push   $0x3
  8018d0:	e8 7d ff ff ff       	call   801852 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	90                   	nop
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 04                	push   $0x4
  8018ea:	e8 63 ff ff ff       	call   801852 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	90                   	nop
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	52                   	push   %edx
  801905:	50                   	push   %eax
  801906:	6a 08                	push   $0x8
  801908:	e8 45 ff ff ff       	call   801852 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	56                   	push   %esi
  801916:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801917:	8b 75 18             	mov    0x18(%ebp),%esi
  80191a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80191d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801920:	8b 55 0c             	mov    0xc(%ebp),%edx
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	56                   	push   %esi
  801927:	53                   	push   %ebx
  801928:	51                   	push   %ecx
  801929:	52                   	push   %edx
  80192a:	50                   	push   %eax
  80192b:	6a 09                	push   $0x9
  80192d:	e8 20 ff ff ff       	call   801852 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801938:	5b                   	pop    %ebx
  801939:	5e                   	pop    %esi
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	ff 75 08             	pushl  0x8(%ebp)
  80194a:	6a 0a                	push   $0xa
  80194c:	e8 01 ff ff ff       	call   801852 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	ff 75 0c             	pushl  0xc(%ebp)
  801962:	ff 75 08             	pushl  0x8(%ebp)
  801965:	6a 0b                	push   $0xb
  801967:	e8 e6 fe ff ff       	call   801852 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 0c                	push   $0xc
  801980:	e8 cd fe ff ff       	call   801852 <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 0d                	push   $0xd
  801999:	e8 b4 fe ff ff       	call   801852 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 0e                	push   $0xe
  8019b2:	e8 9b fe ff ff       	call   801852 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 0f                	push   $0xf
  8019cb:	e8 82 fe ff ff       	call   801852 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	ff 75 08             	pushl  0x8(%ebp)
  8019e3:	6a 10                	push   $0x10
  8019e5:	e8 68 fe ff ff       	call   801852 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 11                	push   $0x11
  8019fe:	e8 4f fe ff ff       	call   801852 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	90                   	nop
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a15:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	50                   	push   %eax
  801a22:	6a 01                	push   $0x1
  801a24:	e8 29 fe ff ff       	call   801852 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	90                   	nop
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 14                	push   $0x14
  801a3e:	e8 0f fe ff ff       	call   801852 <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	90                   	nop
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 04             	sub    $0x4,%esp
  801a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a52:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a55:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a58:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	51                   	push   %ecx
  801a62:	52                   	push   %edx
  801a63:	ff 75 0c             	pushl  0xc(%ebp)
  801a66:	50                   	push   %eax
  801a67:	6a 15                	push   $0x15
  801a69:	e8 e4 fd ff ff       	call   801852 <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	52                   	push   %edx
  801a83:	50                   	push   %eax
  801a84:	6a 16                	push   $0x16
  801a86:	e8 c7 fd ff ff       	call   801852 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a93:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	51                   	push   %ecx
  801aa1:	52                   	push   %edx
  801aa2:	50                   	push   %eax
  801aa3:	6a 17                	push   $0x17
  801aa5:	e8 a8 fd ff ff       	call   801852 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	52                   	push   %edx
  801abf:	50                   	push   %eax
  801ac0:	6a 18                	push   $0x18
  801ac2:	e8 8b fd ff ff       	call   801852 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	ff 75 14             	pushl  0x14(%ebp)
  801ad7:	ff 75 10             	pushl  0x10(%ebp)
  801ada:	ff 75 0c             	pushl  0xc(%ebp)
  801add:	50                   	push   %eax
  801ade:	6a 19                	push   $0x19
  801ae0:	e8 6d fd ff ff       	call   801852 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_run_env>:

void sys_run_env(int32 envId)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	50                   	push   %eax
  801af9:	6a 1a                	push   $0x1a
  801afb:	e8 52 fd ff ff       	call   801852 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	90                   	nop
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	50                   	push   %eax
  801b15:	6a 1b                	push   $0x1b
  801b17:	e8 36 fd ff ff       	call   801852 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 05                	push   $0x5
  801b30:	e8 1d fd ff ff       	call   801852 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 06                	push   $0x6
  801b49:	e8 04 fd ff ff       	call   801852 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 07                	push   $0x7
  801b62:	e8 eb fc ff ff       	call   801852 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_exit_env>:


void sys_exit_env(void)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 1c                	push   $0x1c
  801b7b:	e8 d2 fc ff ff       	call   801852 <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	90                   	nop
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b8c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8f:	8d 50 04             	lea    0x4(%eax),%edx
  801b92:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	52                   	push   %edx
  801b9c:	50                   	push   %eax
  801b9d:	6a 1d                	push   $0x1d
  801b9f:	e8 ae fc ff ff       	call   801852 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801baa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb0:	89 01                	mov    %eax,(%ecx)
  801bb2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	c9                   	leave  
  801bb9:	c2 04 00             	ret    $0x4

00801bbc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	ff 75 10             	pushl  0x10(%ebp)
  801bc6:	ff 75 0c             	pushl  0xc(%ebp)
  801bc9:	ff 75 08             	pushl  0x8(%ebp)
  801bcc:	6a 13                	push   $0x13
  801bce:	e8 7f fc ff ff       	call   801852 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd6:	90                   	nop
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 1e                	push   $0x1e
  801be8:	e8 65 fc ff ff       	call   801852 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bfe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	50                   	push   %eax
  801c0b:	6a 1f                	push   $0x1f
  801c0d:	e8 40 fc ff ff       	call   801852 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
	return ;
  801c15:	90                   	nop
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <rsttst>:
void rsttst()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 21                	push   $0x21
  801c27:	e8 26 fc ff ff       	call   801852 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2f:	90                   	nop
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 04             	sub    $0x4,%esp
  801c38:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c3e:	8b 55 18             	mov    0x18(%ebp),%edx
  801c41:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c45:	52                   	push   %edx
  801c46:	50                   	push   %eax
  801c47:	ff 75 10             	pushl  0x10(%ebp)
  801c4a:	ff 75 0c             	pushl  0xc(%ebp)
  801c4d:	ff 75 08             	pushl  0x8(%ebp)
  801c50:	6a 20                	push   $0x20
  801c52:	e8 fb fb ff ff       	call   801852 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5a:	90                   	nop
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <chktst>:
void chktst(uint32 n)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	ff 75 08             	pushl  0x8(%ebp)
  801c6b:	6a 22                	push   $0x22
  801c6d:	e8 e0 fb ff ff       	call   801852 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
	return ;
  801c75:	90                   	nop
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <inctst>:

void inctst()
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 23                	push   $0x23
  801c87:	e8 c6 fb ff ff       	call   801852 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8f:	90                   	nop
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <gettst>:
uint32 gettst()
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 24                	push   $0x24
  801ca1:	e8 ac fb ff ff       	call   801852 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 25                	push   $0x25
  801cba:	e8 93 fb ff ff       	call   801852 <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
  801cc2:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801cc7:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	ff 75 08             	pushl  0x8(%ebp)
  801ce4:	6a 26                	push   $0x26
  801ce6:	e8 67 fb ff ff       	call   801852 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cee:	90                   	nop
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cf5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	6a 00                	push   $0x0
  801d03:	53                   	push   %ebx
  801d04:	51                   	push   %ecx
  801d05:	52                   	push   %edx
  801d06:	50                   	push   %eax
  801d07:	6a 27                	push   $0x27
  801d09:	e8 44 fb ff ff       	call   801852 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	52                   	push   %edx
  801d26:	50                   	push   %eax
  801d27:	6a 28                	push   $0x28
  801d29:	e8 24 fb ff ff       	call   801852 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d36:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	6a 00                	push   $0x0
  801d41:	51                   	push   %ecx
  801d42:	ff 75 10             	pushl  0x10(%ebp)
  801d45:	52                   	push   %edx
  801d46:	50                   	push   %eax
  801d47:	6a 29                	push   $0x29
  801d49:	e8 04 fb ff ff       	call   801852 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	ff 75 10             	pushl  0x10(%ebp)
  801d5d:	ff 75 0c             	pushl  0xc(%ebp)
  801d60:	ff 75 08             	pushl  0x8(%ebp)
  801d63:	6a 12                	push   $0x12
  801d65:	e8 e8 fa ff ff       	call   801852 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6d:	90                   	nop
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	52                   	push   %edx
  801d80:	50                   	push   %eax
  801d81:	6a 2a                	push   $0x2a
  801d83:	e8 ca fa ff ff       	call   801852 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
	return;
  801d8b:	90                   	nop
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 2b                	push   $0x2b
  801d9d:	e8 b0 fa ff ff       	call   801852 <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	6a 2d                	push   $0x2d
  801db8:	e8 95 fa ff ff       	call   801852 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
	return;
  801dc0:	90                   	nop
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	ff 75 0c             	pushl  0xc(%ebp)
  801dcf:	ff 75 08             	pushl  0x8(%ebp)
  801dd2:	6a 2c                	push   $0x2c
  801dd4:	e8 79 fa ff ff       	call   801852 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddc:	90                   	nop
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	52                   	push   %edx
  801def:	50                   	push   %eax
  801df0:	6a 2e                	push   $0x2e
  801df2:	e8 5b fa ff ff       	call   801852 <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
	    return;
  801dfa:	90                   	nop
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801e03:	8b 55 08             	mov    0x8(%ebp),%edx
  801e06:	89 d0                	mov    %edx,%eax
  801e08:	c1 e0 02             	shl    $0x2,%eax
  801e0b:	01 d0                	add    %edx,%eax
  801e0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e14:	01 d0                	add    %edx,%eax
  801e16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e1d:	01 d0                	add    %edx,%eax
  801e1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e26:	01 d0                	add    %edx,%eax
  801e28:	c1 e0 04             	shl    $0x4,%eax
  801e2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e35:	0f 31                	rdtsc  
  801e37:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e3a:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e46:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e49:	eb 46                	jmp    801e91 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e4b:	0f 31                	rdtsc  
  801e4d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e50:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e53:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e56:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e5c:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e65:	29 c2                	sub    %eax,%edx
  801e67:	89 d0                	mov    %edx,%eax
  801e69:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e72:	89 d1                	mov    %edx,%ecx
  801e74:	29 c1                	sub    %eax,%ecx
  801e76:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e7c:	39 c2                	cmp    %eax,%edx
  801e7e:	0f 97 c0             	seta   %al
  801e81:	0f b6 c0             	movzbl %al,%eax
  801e84:	29 c1                	sub    %eax,%ecx
  801e86:	89 c8                	mov    %ecx,%eax
  801e88:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e8b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e94:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e97:	72 b2                	jb     801e4b <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e99:	90                   	nop
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801ea2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801ea9:	eb 03                	jmp    801eae <busy_wait+0x12>
  801eab:	ff 45 fc             	incl   -0x4(%ebp)
  801eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eb4:	72 f5                	jb     801eab <busy_wait+0xf>
	return i;
  801eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ec7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ecb:	83 ec 0c             	sub    $0xc,%esp
  801ece:	50                   	push   %eax
  801ecf:	e8 35 fb ff ff       	call   801a09 <sys_cputc>
  801ed4:	83 c4 10             	add    $0x10,%esp
}
  801ed7:	90                   	nop
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <getchar>:


int
getchar(void)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ee0:	e8 c3 f9 ff ff       	call   8018a8 <sys_cgetc>
  801ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <iscons>:

int iscons(int fdnum)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801ef0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    
  801ef7:	90                   	nop

00801ef8 <__udivdi3>:
  801ef8:	55                   	push   %ebp
  801ef9:	57                   	push   %edi
  801efa:	56                   	push   %esi
  801efb:	53                   	push   %ebx
  801efc:	83 ec 1c             	sub    $0x1c,%esp
  801eff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f0f:	89 ca                	mov    %ecx,%edx
  801f11:	89 f8                	mov    %edi,%eax
  801f13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f17:	85 f6                	test   %esi,%esi
  801f19:	75 2d                	jne    801f48 <__udivdi3+0x50>
  801f1b:	39 cf                	cmp    %ecx,%edi
  801f1d:	77 65                	ja     801f84 <__udivdi3+0x8c>
  801f1f:	89 fd                	mov    %edi,%ebp
  801f21:	85 ff                	test   %edi,%edi
  801f23:	75 0b                	jne    801f30 <__udivdi3+0x38>
  801f25:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2a:	31 d2                	xor    %edx,%edx
  801f2c:	f7 f7                	div    %edi
  801f2e:	89 c5                	mov    %eax,%ebp
  801f30:	31 d2                	xor    %edx,%edx
  801f32:	89 c8                	mov    %ecx,%eax
  801f34:	f7 f5                	div    %ebp
  801f36:	89 c1                	mov    %eax,%ecx
  801f38:	89 d8                	mov    %ebx,%eax
  801f3a:	f7 f5                	div    %ebp
  801f3c:	89 cf                	mov    %ecx,%edi
  801f3e:	89 fa                	mov    %edi,%edx
  801f40:	83 c4 1c             	add    $0x1c,%esp
  801f43:	5b                   	pop    %ebx
  801f44:	5e                   	pop    %esi
  801f45:	5f                   	pop    %edi
  801f46:	5d                   	pop    %ebp
  801f47:	c3                   	ret    
  801f48:	39 ce                	cmp    %ecx,%esi
  801f4a:	77 28                	ja     801f74 <__udivdi3+0x7c>
  801f4c:	0f bd fe             	bsr    %esi,%edi
  801f4f:	83 f7 1f             	xor    $0x1f,%edi
  801f52:	75 40                	jne    801f94 <__udivdi3+0x9c>
  801f54:	39 ce                	cmp    %ecx,%esi
  801f56:	72 0a                	jb     801f62 <__udivdi3+0x6a>
  801f58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f5c:	0f 87 9e 00 00 00    	ja     802000 <__udivdi3+0x108>
  801f62:	b8 01 00 00 00       	mov    $0x1,%eax
  801f67:	89 fa                	mov    %edi,%edx
  801f69:	83 c4 1c             	add    $0x1c,%esp
  801f6c:	5b                   	pop    %ebx
  801f6d:	5e                   	pop    %esi
  801f6e:	5f                   	pop    %edi
  801f6f:	5d                   	pop    %ebp
  801f70:	c3                   	ret    
  801f71:	8d 76 00             	lea    0x0(%esi),%esi
  801f74:	31 ff                	xor    %edi,%edi
  801f76:	31 c0                	xor    %eax,%eax
  801f78:	89 fa                	mov    %edi,%edx
  801f7a:	83 c4 1c             	add    $0x1c,%esp
  801f7d:	5b                   	pop    %ebx
  801f7e:	5e                   	pop    %esi
  801f7f:	5f                   	pop    %edi
  801f80:	5d                   	pop    %ebp
  801f81:	c3                   	ret    
  801f82:	66 90                	xchg   %ax,%ax
  801f84:	89 d8                	mov    %ebx,%eax
  801f86:	f7 f7                	div    %edi
  801f88:	31 ff                	xor    %edi,%edi
  801f8a:	89 fa                	mov    %edi,%edx
  801f8c:	83 c4 1c             	add    $0x1c,%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5f                   	pop    %edi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    
  801f94:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f99:	89 eb                	mov    %ebp,%ebx
  801f9b:	29 fb                	sub    %edi,%ebx
  801f9d:	89 f9                	mov    %edi,%ecx
  801f9f:	d3 e6                	shl    %cl,%esi
  801fa1:	89 c5                	mov    %eax,%ebp
  801fa3:	88 d9                	mov    %bl,%cl
  801fa5:	d3 ed                	shr    %cl,%ebp
  801fa7:	89 e9                	mov    %ebp,%ecx
  801fa9:	09 f1                	or     %esi,%ecx
  801fab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801faf:	89 f9                	mov    %edi,%ecx
  801fb1:	d3 e0                	shl    %cl,%eax
  801fb3:	89 c5                	mov    %eax,%ebp
  801fb5:	89 d6                	mov    %edx,%esi
  801fb7:	88 d9                	mov    %bl,%cl
  801fb9:	d3 ee                	shr    %cl,%esi
  801fbb:	89 f9                	mov    %edi,%ecx
  801fbd:	d3 e2                	shl    %cl,%edx
  801fbf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fc3:	88 d9                	mov    %bl,%cl
  801fc5:	d3 e8                	shr    %cl,%eax
  801fc7:	09 c2                	or     %eax,%edx
  801fc9:	89 d0                	mov    %edx,%eax
  801fcb:	89 f2                	mov    %esi,%edx
  801fcd:	f7 74 24 0c          	divl   0xc(%esp)
  801fd1:	89 d6                	mov    %edx,%esi
  801fd3:	89 c3                	mov    %eax,%ebx
  801fd5:	f7 e5                	mul    %ebp
  801fd7:	39 d6                	cmp    %edx,%esi
  801fd9:	72 19                	jb     801ff4 <__udivdi3+0xfc>
  801fdb:	74 0b                	je     801fe8 <__udivdi3+0xf0>
  801fdd:	89 d8                	mov    %ebx,%eax
  801fdf:	31 ff                	xor    %edi,%edi
  801fe1:	e9 58 ff ff ff       	jmp    801f3e <__udivdi3+0x46>
  801fe6:	66 90                	xchg   %ax,%ax
  801fe8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fec:	89 f9                	mov    %edi,%ecx
  801fee:	d3 e2                	shl    %cl,%edx
  801ff0:	39 c2                	cmp    %eax,%edx
  801ff2:	73 e9                	jae    801fdd <__udivdi3+0xe5>
  801ff4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ff7:	31 ff                	xor    %edi,%edi
  801ff9:	e9 40 ff ff ff       	jmp    801f3e <__udivdi3+0x46>
  801ffe:	66 90                	xchg   %ax,%ax
  802000:	31 c0                	xor    %eax,%eax
  802002:	e9 37 ff ff ff       	jmp    801f3e <__udivdi3+0x46>
  802007:	90                   	nop

00802008 <__umoddi3>:
  802008:	55                   	push   %ebp
  802009:	57                   	push   %edi
  80200a:	56                   	push   %esi
  80200b:	53                   	push   %ebx
  80200c:	83 ec 1c             	sub    $0x1c,%esp
  80200f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802013:	8b 74 24 34          	mov    0x34(%esp),%esi
  802017:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80201b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80201f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802023:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802027:	89 f3                	mov    %esi,%ebx
  802029:	89 fa                	mov    %edi,%edx
  80202b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80202f:	89 34 24             	mov    %esi,(%esp)
  802032:	85 c0                	test   %eax,%eax
  802034:	75 1a                	jne    802050 <__umoddi3+0x48>
  802036:	39 f7                	cmp    %esi,%edi
  802038:	0f 86 a2 00 00 00    	jbe    8020e0 <__umoddi3+0xd8>
  80203e:	89 c8                	mov    %ecx,%eax
  802040:	89 f2                	mov    %esi,%edx
  802042:	f7 f7                	div    %edi
  802044:	89 d0                	mov    %edx,%eax
  802046:	31 d2                	xor    %edx,%edx
  802048:	83 c4 1c             	add    $0x1c,%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5f                   	pop    %edi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    
  802050:	39 f0                	cmp    %esi,%eax
  802052:	0f 87 ac 00 00 00    	ja     802104 <__umoddi3+0xfc>
  802058:	0f bd e8             	bsr    %eax,%ebp
  80205b:	83 f5 1f             	xor    $0x1f,%ebp
  80205e:	0f 84 ac 00 00 00    	je     802110 <__umoddi3+0x108>
  802064:	bf 20 00 00 00       	mov    $0x20,%edi
  802069:	29 ef                	sub    %ebp,%edi
  80206b:	89 fe                	mov    %edi,%esi
  80206d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802071:	89 e9                	mov    %ebp,%ecx
  802073:	d3 e0                	shl    %cl,%eax
  802075:	89 d7                	mov    %edx,%edi
  802077:	89 f1                	mov    %esi,%ecx
  802079:	d3 ef                	shr    %cl,%edi
  80207b:	09 c7                	or     %eax,%edi
  80207d:	89 e9                	mov    %ebp,%ecx
  80207f:	d3 e2                	shl    %cl,%edx
  802081:	89 14 24             	mov    %edx,(%esp)
  802084:	89 d8                	mov    %ebx,%eax
  802086:	d3 e0                	shl    %cl,%eax
  802088:	89 c2                	mov    %eax,%edx
  80208a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80208e:	d3 e0                	shl    %cl,%eax
  802090:	89 44 24 04          	mov    %eax,0x4(%esp)
  802094:	8b 44 24 08          	mov    0x8(%esp),%eax
  802098:	89 f1                	mov    %esi,%ecx
  80209a:	d3 e8                	shr    %cl,%eax
  80209c:	09 d0                	or     %edx,%eax
  80209e:	d3 eb                	shr    %cl,%ebx
  8020a0:	89 da                	mov    %ebx,%edx
  8020a2:	f7 f7                	div    %edi
  8020a4:	89 d3                	mov    %edx,%ebx
  8020a6:	f7 24 24             	mull   (%esp)
  8020a9:	89 c6                	mov    %eax,%esi
  8020ab:	89 d1                	mov    %edx,%ecx
  8020ad:	39 d3                	cmp    %edx,%ebx
  8020af:	0f 82 87 00 00 00    	jb     80213c <__umoddi3+0x134>
  8020b5:	0f 84 91 00 00 00    	je     80214c <__umoddi3+0x144>
  8020bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020bf:	29 f2                	sub    %esi,%edx
  8020c1:	19 cb                	sbb    %ecx,%ebx
  8020c3:	89 d8                	mov    %ebx,%eax
  8020c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020c9:	d3 e0                	shl    %cl,%eax
  8020cb:	89 e9                	mov    %ebp,%ecx
  8020cd:	d3 ea                	shr    %cl,%edx
  8020cf:	09 d0                	or     %edx,%eax
  8020d1:	89 e9                	mov    %ebp,%ecx
  8020d3:	d3 eb                	shr    %cl,%ebx
  8020d5:	89 da                	mov    %ebx,%edx
  8020d7:	83 c4 1c             	add    $0x1c,%esp
  8020da:	5b                   	pop    %ebx
  8020db:	5e                   	pop    %esi
  8020dc:	5f                   	pop    %edi
  8020dd:	5d                   	pop    %ebp
  8020de:	c3                   	ret    
  8020df:	90                   	nop
  8020e0:	89 fd                	mov    %edi,%ebp
  8020e2:	85 ff                	test   %edi,%edi
  8020e4:	75 0b                	jne    8020f1 <__umoddi3+0xe9>
  8020e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020eb:	31 d2                	xor    %edx,%edx
  8020ed:	f7 f7                	div    %edi
  8020ef:	89 c5                	mov    %eax,%ebp
  8020f1:	89 f0                	mov    %esi,%eax
  8020f3:	31 d2                	xor    %edx,%edx
  8020f5:	f7 f5                	div    %ebp
  8020f7:	89 c8                	mov    %ecx,%eax
  8020f9:	f7 f5                	div    %ebp
  8020fb:	89 d0                	mov    %edx,%eax
  8020fd:	e9 44 ff ff ff       	jmp    802046 <__umoddi3+0x3e>
  802102:	66 90                	xchg   %ax,%ax
  802104:	89 c8                	mov    %ecx,%eax
  802106:	89 f2                	mov    %esi,%edx
  802108:	83 c4 1c             	add    $0x1c,%esp
  80210b:	5b                   	pop    %ebx
  80210c:	5e                   	pop    %esi
  80210d:	5f                   	pop    %edi
  80210e:	5d                   	pop    %ebp
  80210f:	c3                   	ret    
  802110:	3b 04 24             	cmp    (%esp),%eax
  802113:	72 06                	jb     80211b <__umoddi3+0x113>
  802115:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802119:	77 0f                	ja     80212a <__umoddi3+0x122>
  80211b:	89 f2                	mov    %esi,%edx
  80211d:	29 f9                	sub    %edi,%ecx
  80211f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802123:	89 14 24             	mov    %edx,(%esp)
  802126:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80212a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80212e:	8b 14 24             	mov    (%esp),%edx
  802131:	83 c4 1c             	add    $0x1c,%esp
  802134:	5b                   	pop    %ebx
  802135:	5e                   	pop    %esi
  802136:	5f                   	pop    %edi
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    
  802139:	8d 76 00             	lea    0x0(%esi),%esi
  80213c:	2b 04 24             	sub    (%esp),%eax
  80213f:	19 fa                	sbb    %edi,%edx
  802141:	89 d1                	mov    %edx,%ecx
  802143:	89 c6                	mov    %eax,%esi
  802145:	e9 71 ff ff ff       	jmp    8020bb <__umoddi3+0xb3>
  80214a:	66 90                	xchg   %ax,%ax
  80214c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802150:	72 ea                	jb     80213c <__umoddi3+0x134>
  802152:	89 d9                	mov    %ebx,%ecx
  802154:	e9 62 ff ff ff       	jmp    8020bb <__umoddi3+0xb3>
