
obj/user/tst_envfree3:     file format elf32-i386


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
  800031:	e8 3b 02 00 00       	call   800271 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	// Testing scenario 3: using dynamic allocation and free. Kill itself!
	// Testing removing the allocated pages (static & dynamic) in mem, WS, mapped page tables, env's directory and env's page file

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800044:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  80004a:	bb bd 1f 80 00       	mov    $0x801fbd,%ebx
  80004f:	ba 05 00 00 00       	mov    $0x5,%edx
  800054:	89 c7                	mov    %eax,%edi
  800056:	89 de                	mov    %ebx,%esi
  800058:	89 d1                	mov    %edx,%ecx
  80005a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80005c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  800062:	b9 14 00 00 00       	mov    $0x14,%ecx
  800067:	b8 00 00 00 00       	mov    $0x0,%eax
  80006c:	89 d7                	mov    %edx,%edi
  80006e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800070:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800076:	83 ec 08             	sub    $0x8,%esp
  800079:	50                   	push   %eax
  80007a:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  800080:	50                   	push   %eax
  800081:	e8 75 1a 00 00       	call   801afb <sys_utilities>
  800086:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  800089:	e8 6e 16 00 00       	call   8016fc <sys_calculate_free_frames>
  80008e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800091:	e8 b1 16 00 00       	call   801747 <sys_pf_calculate_allocated_pages>
  800096:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  800099:	83 ec 08             	sub    $0x8,%esp
  80009c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80009f:	68 00 1e 80 00       	push   $0x801e00
  8000a4:	e8 4f 06 00 00       	call   8006f8 <cprintf>
  8000a9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcess = sys_create_env("tef3_slave", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b1:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8000b7:	89 c2                	mov    %eax,%edx
  8000b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000be:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000c4:	6a 32                	push   $0x32
  8000c6:	52                   	push   %edx
  8000c7:	50                   	push   %eax
  8000c8:	68 33 1e 80 00       	push   $0x801e33
  8000cd:	e8 85 17 00 00       	call   801857 <sys_create_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 45 dc             	mov    %eax,-0x24(%ebp)

	sys_run_env(envIdProcess);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	ff 75 dc             	pushl  -0x24(%ebp)
  8000de:	e8 92 17 00 00       	call   801875 <sys_run_env>
  8000e3:	83 c4 10             	add    $0x10,%esp

	char getProcStateCmd[100] = "__getProcState@";
  8000e6:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  8000ec:	bb 21 20 80 00       	mov    $0x802021,%ebx
  8000f1:	ba 04 00 00 00       	mov    $0x4,%edx
  8000f6:	89 c7                	mov    %eax,%edi
  8000f8:	89 de                	mov    %ebx,%esi
  8000fa:	89 d1                	mov    %edx,%ecx
  8000fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8000fe:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
  800104:	b9 15 00 00 00       	mov    $0x15,%ecx
  800109:	b8 00 00 00 00       	mov    $0x0,%eax
  80010e:	89 d7                	mov    %edx,%edi
  800110:	f3 ab                	rep stos %eax,%es:(%edi)
	int procState = 0;
  800112:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800119:	00 00 00 
	do
	{
		char id[20] ;
		ltostr(envIdProcess, id);
  80011c:	83 ec 08             	sub    $0x8,%esp
  80011f:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  800125:	50                   	push   %eax
  800126:	ff 75 dc             	pushl  -0x24(%ebp)
  800129:	e8 f8 11 00 00       	call   801326 <ltostr>
  80012e:	83 c4 10             	add    $0x10,%esp
		char getProcStateWithIDCmd[100] ;
		strcconcat(getProcStateCmd, id, getProcStateWithIDCmd);
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  800141:	50                   	push   %eax
  800142:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800148:	50                   	push   %eax
  800149:	e8 b1 12 00 00       	call   8013ff <strcconcat>
  80014e:	83 c4 10             	add    $0x10,%esp

		sys_utilities(getProcStateWithIDCmd, (uint32)&procState) ;
  800151:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	50                   	push   %eax
  80015b:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  800161:	50                   	push   %eax
  800162:	e8 94 19 00 00       	call   801afb <sys_utilities>
  800167:	83 c4 10             	add    $0x10,%esp
		//cprintf("status of env %d = %d\n", envIdProcess, procState);
	}
	while (procState != E_BAD_ENV) ;
  80016a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800170:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800173:	75 a7                	jne    80011c <_main+0xe4>

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800175:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	50                   	push   %eax
  80017f:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	e8 70 19 00 00       	call   801afb <sys_utilities>
  80018b:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80018e:	e8 69 15 00 00       	call   8016fc <sys_calculate_free_frames>
  800193:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800196:	e8 ac 15 00 00       	call   801747 <sys_pf_calculate_allocated_pages>
  80019b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  80019e:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8001a5:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
  8001ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001ae:	01 d0                	add    %edx,%eax
  8001b0:	48                   	dec    %eax
  8001b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bc:	f7 75 d0             	divl   -0x30(%ebp)
  8001bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001c2:	29 d0                	sub    %edx,%eax
  8001c4:	89 c1                	mov    %eax,%ecx
  8001c6:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8001cd:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  8001d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	48                   	dec    %eax
  8001d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001df:	ba 00 00 00 00       	mov    $0x0,%edx
  8001e4:	f7 75 c8             	divl   -0x38(%ebp)
  8001e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001ea:	29 d0                	sub    %edx,%eax
  8001ec:	29 c1                	sub    %eax,%ecx
  8001ee:	89 c8                	mov    %ecx,%eax
  8001f0:	c1 e8 0c             	shr    $0xc,%eax
  8001f3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	cprintf("expected = %d\n",expected);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	ff 75 c0             	pushl  -0x40(%ebp)
  8001fc:	68 3e 1e 80 00       	push   $0x801e3e
  800201:	e8 f2 04 00 00       	call   8006f8 <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  800209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80020f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800212:	74 2e                	je     800242 <_main+0x20a>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800214:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800217:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80021a:	ff 75 c0             	pushl  -0x40(%ebp)
  80021d:	50                   	push   %eax
  80021e:	ff 75 d8             	pushl  -0x28(%ebp)
  800221:	68 50 1e 80 00       	push   $0x801e50
  800226:	e8 cd 04 00 00       	call   8006f8 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 c0 1e 80 00       	push   $0x801ec0
  800236:	6a 2f                	push   $0x2f
  800238:	68 f6 1e 80 00       	push   $0x801ef6
  80023d:	e8 e8 01 00 00       	call   80042a <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back as expected = %d + kbreak pages (%d)\n", freeFrames_after, expected);
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	ff 75 c0             	pushl  -0x40(%ebp)
  800248:	ff 75 d8             	pushl  -0x28(%ebp)
  80024b:	68 0c 1f 80 00       	push   $0x801f0c
  800250:	e8 a3 04 00 00       	call   8006f8 <cprintf>
  800255:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	68 74 1f 80 00       	push   $0x801f74
  800260:	e8 93 04 00 00       	call   8006f8 <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp
	return;
  800268:	90                   	nop
}
  800269:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026c:	5b                   	pop    %ebx
  80026d:	5e                   	pop    %esi
  80026e:	5f                   	pop    %edi
  80026f:	5d                   	pop    %ebp
  800270:	c3                   	ret    

00800271 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	57                   	push   %edi
  800275:	56                   	push   %esi
  800276:	53                   	push   %ebx
  800277:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80027a:	e8 46 16 00 00       	call   8018c5 <sys_getenvindex>
  80027f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800282:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800285:	89 d0                	mov    %edx,%eax
  800287:	c1 e0 02             	shl    $0x2,%eax
  80028a:	01 d0                	add    %edx,%eax
  80028c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800293:	01 d0                	add    %edx,%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	c1 e2 04             	shl    $0x4,%edx
  80029a:	29 c2                	sub    %eax,%edx
  80029c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002a3:	89 c2                	mov    %eax,%edx
  8002a5:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002ab:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b5:	8a 40 20             	mov    0x20(%eax),%al
  8002b8:	84 c0                	test   %al,%al
  8002ba:	74 0d                	je     8002c9 <libmain+0x58>
		binaryname = myEnv->prog_name;
  8002bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c1:	83 c0 20             	add    $0x20,%eax
  8002c4:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002cd:	7e 0a                	jle    8002d9 <libmain+0x68>
		binaryname = argv[0];
  8002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d2:	8b 00                	mov    (%eax),%eax
  8002d4:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	ff 75 0c             	pushl  0xc(%ebp)
  8002df:	ff 75 08             	pushl  0x8(%ebp)
  8002e2:	e8 51 fd ff ff       	call   800038 <_main>
  8002e7:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002ea:	a1 00 30 80 00       	mov    0x803000,%eax
  8002ef:	85 c0                	test   %eax,%eax
  8002f1:	0f 84 01 01 00 00    	je     8003f8 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002f7:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002fd:	bb 80 21 80 00       	mov    $0x802180,%ebx
  800302:	ba 0e 00 00 00       	mov    $0xe,%edx
  800307:	89 c7                	mov    %eax,%edi
  800309:	89 de                	mov    %ebx,%esi
  80030b:	89 d1                	mov    %edx,%ecx
  80030d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80030f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800312:	b9 56 00 00 00       	mov    $0x56,%ecx
  800317:	b0 00                	mov    $0x0,%al
  800319:	89 d7                	mov    %edx,%edi
  80031b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80031d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800324:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	50                   	push   %eax
  80032b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800331:	50                   	push   %eax
  800332:	e8 c4 17 00 00       	call   801afb <sys_utilities>
  800337:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80033a:	e8 0d 13 00 00       	call   80164c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	68 a0 20 80 00       	push   $0x8020a0
  800347:	e8 ac 03 00 00       	call   8006f8 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80034f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800352:	85 c0                	test   %eax,%eax
  800354:	74 18                	je     80036e <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800356:	e8 be 17 00 00       	call   801b19 <sys_get_optimal_num_faults>
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	50                   	push   %eax
  80035f:	68 c8 20 80 00       	push   $0x8020c8
  800364:	e8 8f 03 00 00       	call   8006f8 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	eb 59                	jmp    8003c7 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80036e:	a1 20 30 80 00       	mov    0x803020,%eax
  800373:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800379:	a1 20 30 80 00       	mov    0x803020,%eax
  80037e:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800384:	83 ec 04             	sub    $0x4,%esp
  800387:	52                   	push   %edx
  800388:	50                   	push   %eax
  800389:	68 ec 20 80 00       	push   $0x8020ec
  80038e:	e8 65 03 00 00       	call   8006f8 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800396:	a1 20 30 80 00       	mov    0x803020,%eax
  80039b:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8003a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a6:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8003ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b1:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8003b7:	51                   	push   %ecx
  8003b8:	52                   	push   %edx
  8003b9:	50                   	push   %eax
  8003ba:	68 14 21 80 00       	push   $0x802114
  8003bf:	e8 34 03 00 00       	call   8006f8 <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cc:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8003d2:	83 ec 08             	sub    $0x8,%esp
  8003d5:	50                   	push   %eax
  8003d6:	68 6c 21 80 00       	push   $0x80216c
  8003db:	e8 18 03 00 00       	call   8006f8 <cprintf>
  8003e0:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003e3:	83 ec 0c             	sub    $0xc,%esp
  8003e6:	68 a0 20 80 00       	push   $0x8020a0
  8003eb:	e8 08 03 00 00       	call   8006f8 <cprintf>
  8003f0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003f3:	e8 6e 12 00 00       	call   801666 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003f8:	e8 1f 00 00 00       	call   80041c <exit>
}
  8003fd:	90                   	nop
  8003fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800401:	5b                   	pop    %ebx
  800402:	5e                   	pop    %esi
  800403:	5f                   	pop    %edi
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80040c:	83 ec 0c             	sub    $0xc,%esp
  80040f:	6a 00                	push   $0x0
  800411:	e8 7b 14 00 00       	call   801891 <sys_destroy_env>
  800416:	83 c4 10             	add    $0x10,%esp
}
  800419:	90                   	nop
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <exit>:

void
exit(void)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800422:	e8 d0 14 00 00       	call   8018f7 <sys_exit_env>
}
  800427:	90                   	nop
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800430:	8d 45 10             	lea    0x10(%ebp),%eax
  800433:	83 c0 04             	add    $0x4,%eax
  800436:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800439:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80043e:	85 c0                	test   %eax,%eax
  800440:	74 16                	je     800458 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800442:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	50                   	push   %eax
  80044b:	68 e4 21 80 00       	push   $0x8021e4
  800450:	e8 a3 02 00 00       	call   8006f8 <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800458:	a1 04 30 80 00       	mov    0x803004,%eax
  80045d:	83 ec 0c             	sub    $0xc,%esp
  800460:	ff 75 0c             	pushl  0xc(%ebp)
  800463:	ff 75 08             	pushl  0x8(%ebp)
  800466:	50                   	push   %eax
  800467:	68 ec 21 80 00       	push   $0x8021ec
  80046c:	6a 74                	push   $0x74
  80046e:	e8 b2 02 00 00       	call   800725 <cprintf_colored>
  800473:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800476:	8b 45 10             	mov    0x10(%ebp),%eax
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	ff 75 f4             	pushl  -0xc(%ebp)
  80047f:	50                   	push   %eax
  800480:	e8 04 02 00 00       	call   800689 <vcprintf>
  800485:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800488:	83 ec 08             	sub    $0x8,%esp
  80048b:	6a 00                	push   $0x0
  80048d:	68 14 22 80 00       	push   $0x802214
  800492:	e8 f2 01 00 00       	call   800689 <vcprintf>
  800497:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80049a:	e8 7d ff ff ff       	call   80041c <exit>

	// should not return here
	while (1) ;
  80049f:	eb fe                	jmp    80049f <_panic+0x75>

008004a1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004a1:	55                   	push   %ebp
  8004a2:	89 e5                	mov    %esp,%ebp
  8004a4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ac:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b5:	39 c2                	cmp    %eax,%edx
  8004b7:	74 14                	je     8004cd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004b9:	83 ec 04             	sub    $0x4,%esp
  8004bc:	68 18 22 80 00       	push   $0x802218
  8004c1:	6a 26                	push   $0x26
  8004c3:	68 64 22 80 00       	push   $0x802264
  8004c8:	e8 5d ff ff ff       	call   80042a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004db:	e9 c5 00 00 00       	jmp    8005a5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	85 c0                	test   %eax,%eax
  8004f3:	75 08                	jne    8004fd <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004f5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004f8:	e9 a5 00 00 00       	jmp    8005a2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800504:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80050b:	eb 69                	jmp    800576 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80050d:	a1 20 30 80 00       	mov    0x803020,%eax
  800512:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800518:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80051b:	89 d0                	mov    %edx,%eax
  80051d:	01 c0                	add    %eax,%eax
  80051f:	01 d0                	add    %edx,%eax
  800521:	c1 e0 03             	shl    $0x3,%eax
  800524:	01 c8                	add    %ecx,%eax
  800526:	8a 40 04             	mov    0x4(%eax),%al
  800529:	84 c0                	test   %al,%al
  80052b:	75 46                	jne    800573 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80052d:	a1 20 30 80 00       	mov    0x803020,%eax
  800532:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800538:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	01 c0                	add    %eax,%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	c1 e0 03             	shl    $0x3,%eax
  800544:	01 c8                	add    %ecx,%eax
  800546:	8b 00                	mov    (%eax),%eax
  800548:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80054b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800553:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800558:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	01 c8                	add    %ecx,%eax
  800564:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800566:	39 c2                	cmp    %eax,%edx
  800568:	75 09                	jne    800573 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80056a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800571:	eb 15                	jmp    800588 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800573:	ff 45 e8             	incl   -0x18(%ebp)
  800576:	a1 20 30 80 00       	mov    0x803020,%eax
  80057b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800581:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800584:	39 c2                	cmp    %eax,%edx
  800586:	77 85                	ja     80050d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800588:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80058c:	75 14                	jne    8005a2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80058e:	83 ec 04             	sub    $0x4,%esp
  800591:	68 70 22 80 00       	push   $0x802270
  800596:	6a 3a                	push   $0x3a
  800598:	68 64 22 80 00       	push   $0x802264
  80059d:	e8 88 fe ff ff       	call   80042a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005a2:	ff 45 f0             	incl   -0x10(%ebp)
  8005a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005ab:	0f 8c 2f ff ff ff    	jl     8004e0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005bf:	eb 26                	jmp    8005e7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c6:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8005cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005cf:	89 d0                	mov    %edx,%eax
  8005d1:	01 c0                	add    %eax,%eax
  8005d3:	01 d0                	add    %edx,%eax
  8005d5:	c1 e0 03             	shl    $0x3,%eax
  8005d8:	01 c8                	add    %ecx,%eax
  8005da:	8a 40 04             	mov    0x4(%eax),%al
  8005dd:	3c 01                	cmp    $0x1,%al
  8005df:	75 03                	jne    8005e4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005e1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e4:	ff 45 e0             	incl   -0x20(%ebp)
  8005e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ec:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f5:	39 c2                	cmp    %eax,%edx
  8005f7:	77 c8                	ja     8005c1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005ff:	74 14                	je     800615 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800601:	83 ec 04             	sub    $0x4,%esp
  800604:	68 c4 22 80 00       	push   $0x8022c4
  800609:	6a 44                	push   $0x44
  80060b:	68 64 22 80 00       	push   $0x802264
  800610:	e8 15 fe ff ff       	call   80042a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800615:	90                   	nop
  800616:	c9                   	leave  
  800617:	c3                   	ret    

00800618 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	53                   	push   %ebx
  80061c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80061f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	8d 48 01             	lea    0x1(%eax),%ecx
  800627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062a:	89 0a                	mov    %ecx,(%edx)
  80062c:	8b 55 08             	mov    0x8(%ebp),%edx
  80062f:	88 d1                	mov    %dl,%cl
  800631:	8b 55 0c             	mov    0xc(%ebp),%edx
  800634:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800642:	75 30                	jne    800674 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800644:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80064a:	a0 44 30 80 00       	mov    0x803044,%al
  80064f:	0f b6 c0             	movzbl %al,%eax
  800652:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800655:	8b 09                	mov    (%ecx),%ecx
  800657:	89 cb                	mov    %ecx,%ebx
  800659:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80065c:	83 c1 08             	add    $0x8,%ecx
  80065f:	52                   	push   %edx
  800660:	50                   	push   %eax
  800661:	53                   	push   %ebx
  800662:	51                   	push   %ecx
  800663:	e8 a0 0f 00 00       	call   801608 <sys_cputs>
  800668:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80066b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800674:	8b 45 0c             	mov    0xc(%ebp),%eax
  800677:	8b 40 04             	mov    0x4(%eax),%eax
  80067a:	8d 50 01             	lea    0x1(%eax),%edx
  80067d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800680:	89 50 04             	mov    %edx,0x4(%eax)
}
  800683:	90                   	nop
  800684:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800692:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800699:	00 00 00 
	b.cnt = 0;
  80069c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006a3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006a6:	ff 75 0c             	pushl  0xc(%ebp)
  8006a9:	ff 75 08             	pushl  0x8(%ebp)
  8006ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	68 18 06 80 00       	push   $0x800618
  8006b8:	e8 5a 02 00 00       	call   800917 <vprintfmt>
  8006bd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006c0:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006c6:	a0 44 30 80 00       	mov    0x803044,%al
  8006cb:	0f b6 c0             	movzbl %al,%eax
  8006ce:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	51                   	push   %ecx
  8006d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006dd:	83 c0 08             	add    $0x8,%eax
  8006e0:	50                   	push   %eax
  8006e1:	e8 22 0f 00 00       	call   801608 <sys_cputs>
  8006e6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006e9:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006f6:	c9                   	leave  
  8006f7:	c3                   	ret    

008006f8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
  8006fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006fe:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800705:	8d 45 0c             	lea    0xc(%ebp),%eax
  800708:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	ff 75 f4             	pushl  -0xc(%ebp)
  800714:	50                   	push   %eax
  800715:	e8 6f ff ff ff       	call   800689 <vcprintf>
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800720:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80072b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	c1 e0 08             	shl    $0x8,%eax
  800738:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80073d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800740:	83 c0 04             	add    $0x4,%eax
  800743:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800746:	8b 45 0c             	mov    0xc(%ebp),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	ff 75 f4             	pushl  -0xc(%ebp)
  80074f:	50                   	push   %eax
  800750:	e8 34 ff ff ff       	call   800689 <vcprintf>
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80075b:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800762:	07 00 00 

	return cnt;
  800765:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800770:	e8 d7 0e 00 00       	call   80164c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800775:	8d 45 0c             	lea    0xc(%ebp),%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	ff 75 f4             	pushl  -0xc(%ebp)
  800784:	50                   	push   %eax
  800785:	e8 ff fe ff ff       	call   800689 <vcprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800790:	e8 d1 0e 00 00       	call   801666 <sys_unlock_cons>
	return cnt;
  800795:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	53                   	push   %ebx
  80079e:	83 ec 14             	sub    $0x14,%esp
  8007a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b8:	77 55                	ja     80080f <printnum+0x75>
  8007ba:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bd:	72 05                	jb     8007c4 <printnum+0x2a>
  8007bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c2:	77 4b                	ja     80080f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	52                   	push   %edx
  8007d3:	50                   	push   %eax
  8007d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007da:	e8 a9 13 00 00       	call   801b88 <__udivdi3>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	83 ec 04             	sub    $0x4,%esp
  8007e5:	ff 75 20             	pushl  0x20(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	ff 75 18             	pushl  0x18(%ebp)
  8007ec:	52                   	push   %edx
  8007ed:	50                   	push   %eax
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	e8 a1 ff ff ff       	call   80079a <printnum>
  8007f9:	83 c4 20             	add    $0x20,%esp
  8007fc:	eb 1a                	jmp    800818 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	ff 75 20             	pushl  0x20(%ebp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080f:	ff 4d 1c             	decl   0x1c(%ebp)
  800812:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800816:	7f e6                	jg     8007fe <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800818:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800826:	53                   	push   %ebx
  800827:	51                   	push   %ecx
  800828:	52                   	push   %edx
  800829:	50                   	push   %eax
  80082a:	e8 69 14 00 00       	call   801c98 <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 34 25 80 00       	add    $0x802534,%eax
  800837:	8a 00                	mov    (%eax),%al
  800839:	0f be c0             	movsbl %al,%eax
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	50                   	push   %eax
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
}
  80084b:	90                   	nop
  80084c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800854:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800858:	7e 1c                	jle    800876 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 08             	lea    0x8(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 08             	sub    $0x8,%eax
  80086f:	8b 50 04             	mov    0x4(%eax),%edx
  800872:	8b 00                	mov    (%eax),%eax
  800874:	eb 40                	jmp    8008b6 <getuint+0x65>
	else if (lflag)
  800876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087a:	74 1e                	je     80089a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	eb 1c                	jmp    8008b6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008bf:	7e 1c                	jle    8008dd <getint+0x25>
		return va_arg(*ap, long long);
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	8d 50 08             	lea    0x8(%eax),%edx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	89 10                	mov    %edx,(%eax)
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 e8 08             	sub    $0x8,%eax
  8008d6:	8b 50 04             	mov    0x4(%eax),%edx
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	eb 38                	jmp    800915 <getint+0x5d>
	else if (lflag)
  8008dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e1:	74 1a                	je     8008fd <getint+0x45>
		return va_arg(*ap, long);
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 50 04             	lea    0x4(%eax),%edx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 10                	mov    %edx,(%eax)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 e8 04             	sub    $0x4,%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	99                   	cltd   
  8008fb:	eb 18                	jmp    800915 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	8d 50 04             	lea    0x4(%eax),%edx
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	89 10                	mov    %edx,(%eax)
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	99                   	cltd   
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091f:	eb 17                	jmp    800938 <vprintfmt+0x21>
			if (ch == '\0')
  800921:	85 db                	test   %ebx,%ebx
  800923:	0f 84 c1 03 00 00    	je     800cea <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	53                   	push   %ebx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800938:	8b 45 10             	mov    0x10(%ebp),%eax
  80093b:	8d 50 01             	lea    0x1(%eax),%edx
  80093e:	89 55 10             	mov    %edx,0x10(%ebp)
  800941:	8a 00                	mov    (%eax),%al
  800943:	0f b6 d8             	movzbl %al,%ebx
  800946:	83 fb 25             	cmp    $0x25,%ebx
  800949:	75 d6                	jne    800921 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80094f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800956:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800964:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096b:	8b 45 10             	mov    0x10(%ebp),%eax
  80096e:	8d 50 01             	lea    0x1(%eax),%edx
  800971:	89 55 10             	mov    %edx,0x10(%ebp)
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f b6 d8             	movzbl %al,%ebx
  800979:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097c:	83 f8 5b             	cmp    $0x5b,%eax
  80097f:	0f 87 3d 03 00 00    	ja     800cc2 <vprintfmt+0x3ab>
  800985:	8b 04 85 58 25 80 00 	mov    0x802558(,%eax,4),%eax
  80098c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80098e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800992:	eb d7                	jmp    80096b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800994:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800998:	eb d1                	jmp    80096b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	c1 e0 02             	shl    $0x2,%eax
  8009a9:	01 d0                	add    %edx,%eax
  8009ab:	01 c0                	add    %eax,%eax
  8009ad:	01 d8                	add    %ebx,%eax
  8009af:	83 e8 30             	sub    $0x30,%eax
  8009b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	8a 00                	mov    (%eax),%al
  8009ba:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c0:	7e 3e                	jle    800a00 <vprintfmt+0xe9>
  8009c2:	83 fb 39             	cmp    $0x39,%ebx
  8009c5:	7f 39                	jg     800a00 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ca:	eb d5                	jmp    8009a1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 e8 04             	sub    $0x4,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e0:	eb 1f                	jmp    800a01 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e6:	79 83                	jns    80096b <vprintfmt+0x54>
				width = 0;
  8009e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ef:	e9 77 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fb:	e9 6b ff ff ff       	jmp    80096b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a00:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a05:	0f 89 60 ff ff ff    	jns    80096b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a18:	e9 4e ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a20:	e9 46 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	50                   	push   %eax
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	ff d0                	call   *%eax
  800a42:	83 c4 10             	add    $0x10,%esp
			break;
  800a45:	e9 9b 02 00 00       	jmp    800ce5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 c0 04             	add    $0x4,%eax
  800a50:	89 45 14             	mov    %eax,0x14(%ebp)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 e8 04             	sub    $0x4,%eax
  800a59:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	79 02                	jns    800a61 <vprintfmt+0x14a>
				err = -err;
  800a5f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a61:	83 fb 64             	cmp    $0x64,%ebx
  800a64:	7f 0b                	jg     800a71 <vprintfmt+0x15a>
  800a66:	8b 34 9d a0 23 80 00 	mov    0x8023a0(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 45 25 80 00       	push   $0x802545
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 70 02 00 00       	call   800cf2 <printfmt>
  800a82:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a85:	e9 5b 02 00 00       	jmp    800ce5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8a:	56                   	push   %esi
  800a8b:	68 4e 25 80 00       	push   $0x80254e
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	ff 75 08             	pushl  0x8(%ebp)
  800a96:	e8 57 02 00 00       	call   800cf2 <printfmt>
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 42 02 00 00       	jmp    800ce5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 e8 04             	sub    $0x4,%eax
  800ab2:	8b 30                	mov    (%eax),%esi
  800ab4:	85 f6                	test   %esi,%esi
  800ab6:	75 05                	jne    800abd <vprintfmt+0x1a6>
				p = "(null)";
  800ab8:	be 51 25 80 00       	mov    $0x802551,%esi
			if (width > 0 && padc != '-')
  800abd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac1:	7e 6d                	jle    800b30 <vprintfmt+0x219>
  800ac3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac7:	74 67                	je     800b30 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	50                   	push   %eax
  800ad0:	56                   	push   %esi
  800ad1:	e8 1e 03 00 00       	call   800df4 <strnlen>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800adc:	eb 16                	jmp    800af4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ade:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af1:	ff 4d e4             	decl   -0x1c(%ebp)
  800af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af8:	7f e4                	jg     800ade <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afa:	eb 34                	jmp    800b30 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b00:	74 1c                	je     800b1e <vprintfmt+0x207>
  800b02:	83 fb 1f             	cmp    $0x1f,%ebx
  800b05:	7e 05                	jle    800b0c <vprintfmt+0x1f5>
  800b07:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0a:	7e 12                	jle    800b1e <vprintfmt+0x207>
					putch('?', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 3f                	push   $0x3f
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	eb 0f                	jmp    800b2d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	53                   	push   %ebx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b30:	89 f0                	mov    %esi,%eax
  800b32:	8d 70 01             	lea    0x1(%eax),%esi
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	0f be d8             	movsbl %al,%ebx
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	74 24                	je     800b62 <vprintfmt+0x24b>
  800b3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b42:	78 b8                	js     800afc <vprintfmt+0x1e5>
  800b44:	ff 4d e0             	decl   -0x20(%ebp)
  800b47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4b:	79 af                	jns    800afc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4d:	eb 13                	jmp    800b62 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	6a 20                	push   $0x20
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b66:	7f e7                	jg     800b4f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b68:	e9 78 01 00 00       	jmp    800ce5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 e8             	pushl  -0x18(%ebp)
  800b73:	8d 45 14             	lea    0x14(%ebp),%eax
  800b76:	50                   	push   %eax
  800b77:	e8 3c fd ff ff       	call   8008b8 <getint>
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8b:	85 d2                	test   %edx,%edx
  800b8d:	79 23                	jns    800bb2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 2d                	push   $0x2d
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba5:	f7 d8                	neg    %eax
  800ba7:	83 d2 00             	adc    $0x0,%edx
  800baa:	f7 da                	neg    %edx
  800bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb9:	e9 bc 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc7:	50                   	push   %eax
  800bc8:	e8 84 fc ff ff       	call   800851 <getuint>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdd:	e9 98 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	6a 58                	push   $0x58
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			break;
  800c12:	e9 ce 00 00 00       	jmp    800ce5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 30                	push   $0x30
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 78                	push   $0x78
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	83 c0 04             	add    $0x4,%eax
  800c3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c40:	8b 45 14             	mov    0x14(%ebp),%eax
  800c43:	83 e8 04             	sub    $0x4,%eax
  800c46:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c59:	eb 1f                	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c61:	8d 45 14             	lea    0x14(%ebp),%eax
  800c64:	50                   	push   %eax
  800c65:	e8 e7 fb ff ff       	call   800851 <getuint>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c81:	83 ec 04             	sub    $0x4,%esp
  800c84:	52                   	push   %edx
  800c85:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c88:	50                   	push   %eax
  800c89:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	ff 75 08             	pushl  0x8(%ebp)
  800c95:	e8 00 fb ff ff       	call   80079a <printnum>
  800c9a:	83 c4 20             	add    $0x20,%esp
			break;
  800c9d:	eb 46                	jmp    800ce5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	53                   	push   %ebx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	ff d0                	call   *%eax
  800cab:	83 c4 10             	add    $0x10,%esp
			break;
  800cae:	eb 35                	jmp    800ce5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cb0:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cb7:	eb 2c                	jmp    800ce5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cb9:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cc0:	eb 23                	jmp    800ce5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc2:	83 ec 08             	sub    $0x8,%esp
  800cc5:	ff 75 0c             	pushl  0xc(%ebp)
  800cc8:	6a 25                	push   $0x25
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	ff d0                	call   *%eax
  800ccf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd2:	ff 4d 10             	decl   0x10(%ebp)
  800cd5:	eb 03                	jmp    800cda <vprintfmt+0x3c3>
  800cd7:	ff 4d 10             	decl   0x10(%ebp)
  800cda:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdd:	48                   	dec    %eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	3c 25                	cmp    $0x25,%al
  800ce2:	75 f3                	jne    800cd7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ce4:	90                   	nop
		}
	}
  800ce5:	e9 35 fc ff ff       	jmp    80091f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cea:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ceb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    

00800cf2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf8:	8d 45 10             	lea    0x10(%ebp),%eax
  800cfb:	83 c0 04             	add    $0x4,%eax
  800cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d01:	8b 45 10             	mov    0x10(%ebp),%eax
  800d04:	ff 75 f4             	pushl  -0xc(%ebp)
  800d07:	50                   	push   %eax
  800d08:	ff 75 0c             	pushl  0xc(%ebp)
  800d0b:	ff 75 08             	pushl  0x8(%ebp)
  800d0e:	e8 04 fc ff ff       	call   800917 <vprintfmt>
  800d13:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d16:	90                   	nop
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1f:	8b 40 08             	mov    0x8(%eax),%eax
  800d22:	8d 50 01             	lea    0x1(%eax),%edx
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8b 10                	mov    (%eax),%edx
  800d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d33:	8b 40 04             	mov    0x4(%eax),%eax
  800d36:	39 c2                	cmp    %eax,%edx
  800d38:	73 12                	jae    800d4c <sprintputch+0x33>
		*b->buf++ = ch;
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8b 00                	mov    (%eax),%eax
  800d3f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d45:	89 0a                	mov    %ecx,(%edx)
  800d47:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4a:	88 10                	mov    %dl,(%eax)
}
  800d4c:	90                   	nop
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	01 d0                	add    %edx,%eax
  800d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d74:	74 06                	je     800d7c <vsnprintf+0x2d>
  800d76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7a:	7f 07                	jg     800d83 <vsnprintf+0x34>
		return -E_INVAL;
  800d7c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d81:	eb 20                	jmp    800da3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d83:	ff 75 14             	pushl  0x14(%ebp)
  800d86:	ff 75 10             	pushl  0x10(%ebp)
  800d89:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8c:	50                   	push   %eax
  800d8d:	68 19 0d 80 00       	push   $0x800d19
  800d92:	e8 80 fb ff ff       	call   800917 <vprintfmt>
  800d97:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da3:	c9                   	leave  
  800da4:	c3                   	ret    

00800da5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dab:	8d 45 10             	lea    0x10(%ebp),%eax
  800dae:	83 c0 04             	add    $0x4,%eax
  800db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db4:	8b 45 10             	mov    0x10(%ebp),%eax
  800db7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dba:	50                   	push   %eax
  800dbb:	ff 75 0c             	pushl  0xc(%ebp)
  800dbe:	ff 75 08             	pushl  0x8(%ebp)
  800dc1:	e8 89 ff ff ff       	call   800d4f <vsnprintf>
  800dc6:	83 c4 10             	add    $0x10,%esp
  800dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dcf:	c9                   	leave  
  800dd0:	c3                   	ret    

00800dd1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dde:	eb 06                	jmp    800de6 <strlen+0x15>
		n++;
  800de0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de3:	ff 45 08             	incl   0x8(%ebp)
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	84 c0                	test   %al,%al
  800ded:	75 f1                	jne    800de0 <strlen+0xf>
		n++;
	return n;
  800def:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e01:	eb 09                	jmp    800e0c <strnlen+0x18>
		n++;
  800e03:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	ff 45 08             	incl   0x8(%ebp)
  800e09:	ff 4d 0c             	decl   0xc(%ebp)
  800e0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e10:	74 09                	je     800e1b <strnlen+0x27>
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	84 c0                	test   %al,%al
  800e19:	75 e8                	jne    800e03 <strnlen+0xf>
		n++;
	return n;
  800e1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2c:	90                   	nop
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8d 50 01             	lea    0x1(%eax),%edx
  800e33:	89 55 08             	mov    %edx,0x8(%ebp)
  800e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e39:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e3f:	8a 12                	mov    (%edx),%dl
  800e41:	88 10                	mov    %dl,(%eax)
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	84 c0                	test   %al,%al
  800e47:	75 e4                	jne    800e2d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e61:	eb 1f                	jmp    800e82 <strncpy+0x34>
		*dst++ = *src;
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6f:	8a 12                	mov    (%edx),%dl
  800e71:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	84 c0                	test   %al,%al
  800e7a:	74 03                	je     800e7f <strncpy+0x31>
			src++;
  800e7c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e7f:	ff 45 fc             	incl   -0x4(%ebp)
  800e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e85:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e88:	72 d9                	jb     800e63 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8d:	c9                   	leave  
  800e8e:	c3                   	ret    

00800e8f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9f:	74 30                	je     800ed1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ea1:	eb 16                	jmp    800eb9 <strlcpy+0x2a>
			*dst++ = *src++;
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8d 50 01             	lea    0x1(%eax),%edx
  800ea9:	89 55 08             	mov    %edx,0x8(%ebp)
  800eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb5:	8a 12                	mov    (%edx),%dl
  800eb7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb9:	ff 4d 10             	decl   0x10(%ebp)
  800ebc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec0:	74 09                	je     800ecb <strlcpy+0x3c>
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	84 c0                	test   %al,%al
  800ec9:	75 d8                	jne    800ea3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed7:	29 c2                	sub    %eax,%edx
  800ed9:	89 d0                	mov    %edx,%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ee0:	eb 06                	jmp    800ee8 <strcmp+0xb>
		p++, q++;
  800ee2:	ff 45 08             	incl   0x8(%ebp)
  800ee5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	84 c0                	test   %al,%al
  800eef:	74 0e                	je     800eff <strcmp+0x22>
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	38 c2                	cmp    %al,%dl
  800efd:	74 e3                	je     800ee2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	0f b6 d0             	movzbl %al,%edx
  800f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	29 c2                	sub    %eax,%edx
  800f11:	89 d0                	mov    %edx,%eax
}
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    

00800f15 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f18:	eb 09                	jmp    800f23 <strncmp+0xe>
		n--, p++, q++;
  800f1a:	ff 4d 10             	decl   0x10(%ebp)
  800f1d:	ff 45 08             	incl   0x8(%ebp)
  800f20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f27:	74 17                	je     800f40 <strncmp+0x2b>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	84 c0                	test   %al,%al
  800f30:	74 0e                	je     800f40 <strncmp+0x2b>
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 10                	mov    (%eax),%dl
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	38 c2                	cmp    %al,%dl
  800f3e:	74 da                	je     800f1a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f44:	75 07                	jne    800f4d <strncmp+0x38>
		return 0;
  800f46:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4b:	eb 14                	jmp    800f61 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	0f b6 d0             	movzbl %al,%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	0f b6 c0             	movzbl %al,%eax
  800f5d:	29 c2                	sub    %eax,%edx
  800f5f:	89 d0                	mov    %edx,%eax
}
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	83 ec 04             	sub    $0x4,%esp
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6f:	eb 12                	jmp    800f83 <strchr+0x20>
		if (*s == c)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f79:	75 05                	jne    800f80 <strchr+0x1d>
			return (char *) s;
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	eb 11                	jmp    800f91 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f80:	ff 45 08             	incl   0x8(%ebp)
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	84 c0                	test   %al,%al
  800f8a:	75 e5                	jne    800f71 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 04             	sub    $0x4,%esp
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9f:	eb 0d                	jmp    800fae <strfind+0x1b>
		if (*s == c)
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa9:	74 0e                	je     800fb9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fab:	ff 45 08             	incl   0x8(%ebp)
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	84 c0                	test   %al,%al
  800fb5:	75 ea                	jne    800fa1 <strfind+0xe>
  800fb7:	eb 01                	jmp    800fba <strfind+0x27>
		if (*s == c)
			break;
  800fb9:	90                   	nop
	return (char *) s;
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbd:	c9                   	leave  
  800fbe:	c3                   	ret    

00800fbf <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fcb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fcf:	76 63                	jbe    801034 <memset+0x75>
		uint64 data_block = c;
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	99                   	cltd   
  800fd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe1:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fe5:	c1 e0 08             	shl    $0x8,%eax
  800fe8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800feb:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff4:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ff8:	c1 e0 10             	shl    $0x10,%eax
  800ffb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ffe:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801004:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801007:	89 c2                	mov    %eax,%edx
  801009:	b8 00 00 00 00       	mov    $0x0,%eax
  80100e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801011:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801014:	eb 18                	jmp    80102e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801016:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801019:	8d 41 08             	lea    0x8(%ecx),%eax
  80101c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80101f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801022:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801025:	89 01                	mov    %eax,(%ecx)
  801027:	89 51 04             	mov    %edx,0x4(%ecx)
  80102a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80102e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801032:	77 e2                	ja     801016 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801038:	74 23                	je     80105d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80103a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801040:	eb 0e                	jmp    801050 <memset+0x91>
			*p8++ = (uint8)c;
  801042:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801045:	8d 50 01             	lea    0x1(%eax),%edx
  801048:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801050:	8b 45 10             	mov    0x10(%ebp),%eax
  801053:	8d 50 ff             	lea    -0x1(%eax),%edx
  801056:	89 55 10             	mov    %edx,0x10(%ebp)
  801059:	85 c0                	test   %eax,%eax
  80105b:	75 e5                	jne    801042 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801060:	c9                   	leave  
  801061:	c3                   	ret    

00801062 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801074:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801078:	76 24                	jbe    80109e <memcpy+0x3c>
		while(n >= 8){
  80107a:	eb 1c                	jmp    801098 <memcpy+0x36>
			*d64 = *s64;
  80107c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107f:	8b 50 04             	mov    0x4(%eax),%edx
  801082:	8b 00                	mov    (%eax),%eax
  801084:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801087:	89 01                	mov    %eax,(%ecx)
  801089:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80108c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801090:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801094:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801098:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80109c:	77 de                	ja     80107c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	74 31                	je     8010d5 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010b0:	eb 16                	jmp    8010c8 <memcpy+0x66>
			*d8++ = *s8++;
  8010b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b5:	8d 50 01             	lea    0x1(%eax),%edx
  8010b8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c1:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010c4:	8a 12                	mov    (%edx),%dl
  8010c6:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	75 dd                	jne    8010b2 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f2:	73 50                	jae    801144 <memmove+0x6a>
  8010f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	01 d0                	add    %edx,%eax
  8010fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ff:	76 43                	jbe    801144 <memmove+0x6a>
		s += n;
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110d:	eb 10                	jmp    80111f <memmove+0x45>
			*--d = *--s;
  80110f:	ff 4d f8             	decl   -0x8(%ebp)
  801112:	ff 4d fc             	decl   -0x4(%ebp)
  801115:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801118:	8a 10                	mov    (%eax),%dl
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80111f:	8b 45 10             	mov    0x10(%ebp),%eax
  801122:	8d 50 ff             	lea    -0x1(%eax),%edx
  801125:	89 55 10             	mov    %edx,0x10(%ebp)
  801128:	85 c0                	test   %eax,%eax
  80112a:	75 e3                	jne    80110f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80112c:	eb 23                	jmp    801151 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801137:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801140:	8a 12                	mov    (%edx),%dl
  801142:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114a:	89 55 10             	mov    %edx,0x10(%ebp)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	75 dd                	jne    80112e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801168:	eb 2a                	jmp    801194 <memcmp+0x3e>
		if (*s1 != *s2)
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	8a 10                	mov    (%eax),%dl
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	38 c2                	cmp    %al,%dl
  801176:	74 16                	je     80118e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	0f b6 d0             	movzbl %al,%edx
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f b6 c0             	movzbl %al,%eax
  801188:	29 c2                	sub    %eax,%edx
  80118a:	89 d0                	mov    %edx,%eax
  80118c:	eb 18                	jmp    8011a6 <memcmp+0x50>
		s1++, s2++;
  80118e:	ff 45 fc             	incl   -0x4(%ebp)
  801191:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119a:	89 55 10             	mov    %edx,0x10(%ebp)
  80119d:	85 c0                	test   %eax,%eax
  80119f:	75 c9                	jne    80116a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    

008011a8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b9:	eb 15                	jmp    8011d0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	0f b6 d0             	movzbl %al,%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	0f b6 c0             	movzbl %al,%eax
  8011c9:	39 c2                	cmp    %eax,%edx
  8011cb:	74 0d                	je     8011da <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011cd:	ff 45 08             	incl   0x8(%ebp)
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d6:	72 e3                	jb     8011bb <memfind+0x13>
  8011d8:	eb 01                	jmp    8011db <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011da:	90                   	nop
	return (void *) s;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f4:	eb 03                	jmp    8011f9 <strtol+0x19>
		s++;
  8011f6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 20                	cmp    $0x20,%al
  801200:	74 f4                	je     8011f6 <strtol+0x16>
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 09                	cmp    $0x9,%al
  801209:	74 eb                	je     8011f6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 2b                	cmp    $0x2b,%al
  801212:	75 05                	jne    801219 <strtol+0x39>
		s++;
  801214:	ff 45 08             	incl   0x8(%ebp)
  801217:	eb 13                	jmp    80122c <strtol+0x4c>
	else if (*s == '-')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 2d                	cmp    $0x2d,%al
  801220:	75 0a                	jne    80122c <strtol+0x4c>
		s++, neg = 1;
  801222:	ff 45 08             	incl   0x8(%ebp)
  801225:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80122c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801230:	74 06                	je     801238 <strtol+0x58>
  801232:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801236:	75 20                	jne    801258 <strtol+0x78>
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	3c 30                	cmp    $0x30,%al
  80123f:	75 17                	jne    801258 <strtol+0x78>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	40                   	inc    %eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 78                	cmp    $0x78,%al
  801249:	75 0d                	jne    801258 <strtol+0x78>
		s += 2, base = 16;
  80124b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80124f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801256:	eb 28                	jmp    801280 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125c:	75 15                	jne    801273 <strtol+0x93>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 30                	cmp    $0x30,%al
  801265:	75 0c                	jne    801273 <strtol+0x93>
		s++, base = 8;
  801267:	ff 45 08             	incl   0x8(%ebp)
  80126a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801271:	eb 0d                	jmp    801280 <strtol+0xa0>
	else if (base == 0)
  801273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801277:	75 07                	jne    801280 <strtol+0xa0>
		base = 10;
  801279:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 2f                	cmp    $0x2f,%al
  801287:	7e 19                	jle    8012a2 <strtol+0xc2>
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 39                	cmp    $0x39,%al
  801290:	7f 10                	jg     8012a2 <strtol+0xc2>
			dig = *s - '0';
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	83 e8 30             	sub    $0x30,%eax
  80129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a0:	eb 42                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 60                	cmp    $0x60,%al
  8012a9:	7e 19                	jle    8012c4 <strtol+0xe4>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 7a                	cmp    $0x7a,%al
  8012b2:	7f 10                	jg     8012c4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	83 e8 57             	sub    $0x57,%eax
  8012bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c2:	eb 20                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 40                	cmp    $0x40,%al
  8012cb:	7e 39                	jle    801306 <strtol+0x126>
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	3c 5a                	cmp    $0x5a,%al
  8012d4:	7f 30                	jg     801306 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	0f be c0             	movsbl %al,%eax
  8012de:	83 e8 37             	sub    $0x37,%eax
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ea:	7d 19                	jge    801305 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ec:	ff 45 08             	incl   0x8(%ebp)
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801300:	e9 7b ff ff ff       	jmp    801280 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801305:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801306:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130a:	74 08                	je     801314 <strtol+0x134>
		*endptr = (char *) s;
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	8b 55 08             	mov    0x8(%ebp),%edx
  801312:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 07                	je     801321 <strtol+0x141>
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131d:	f7 d8                	neg    %eax
  80131f:	eb 03                	jmp    801324 <strtol+0x144>
  801321:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <ltostr>:

void
ltostr(long value, char *str)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80132c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801333:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80133a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133e:	79 13                	jns    801353 <ltostr+0x2d>
	{
		neg = 1;
  801340:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801350:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80135b:	99                   	cltd   
  80135c:	f7 f9                	idiv   %ecx
  80135e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	83 c2 30             	add    $0x30,%edx
  801377:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801381:	f7 e9                	imul   %ecx
  801383:	c1 fa 02             	sar    $0x2,%edx
  801386:	89 c8                	mov    %ecx,%eax
  801388:	c1 f8 1f             	sar    $0x1f,%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
  80138f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801392:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801396:	75 bb                	jne    801353 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801398:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80139f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a2:	48                   	dec    %eax
  8013a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013aa:	74 3d                	je     8013e9 <ltostr+0xc3>
		start = 1 ;
  8013ac:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013b3:	eb 34                	jmp    8013e9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	01 d0                	add    %edx,%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c8:	01 c2                	add    %eax,%edx
  8013ca:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d0:	01 c8                	add    %ecx,%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	01 c2                	add    %eax,%edx
  8013de:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013e1:	88 02                	mov    %al,(%edx)
		start++ ;
  8013e3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013e6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ef:	7c c4                	jl     8013b5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	01 d0                	add    %edx,%eax
  8013f9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801405:	ff 75 08             	pushl  0x8(%ebp)
  801408:	e8 c4 f9 ff ff       	call   800dd1 <strlen>
  80140d:	83 c4 04             	add    $0x4,%esp
  801410:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801413:	ff 75 0c             	pushl  0xc(%ebp)
  801416:	e8 b6 f9 ff ff       	call   800dd1 <strlen>
  80141b:	83 c4 04             	add    $0x4,%esp
  80141e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801421:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801428:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80142f:	eb 17                	jmp    801448 <strcconcat+0x49>
		final[s] = str1[s] ;
  801431:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801434:	8b 45 10             	mov    0x10(%ebp),%eax
  801437:	01 c2                	add    %eax,%edx
  801439:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	01 c8                	add    %ecx,%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801445:	ff 45 fc             	incl   -0x4(%ebp)
  801448:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80144e:	7c e1                	jl     801431 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801450:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801457:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80145e:	eb 1f                	jmp    80147f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	8d 50 01             	lea    0x1(%eax),%edx
  801466:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801469:	89 c2                	mov    %eax,%edx
  80146b:	8b 45 10             	mov    0x10(%ebp),%eax
  80146e:	01 c2                	add    %eax,%edx
  801470:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801473:	8b 45 0c             	mov    0xc(%ebp),%eax
  801476:	01 c8                	add    %ecx,%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80147c:	ff 45 f8             	incl   -0x8(%ebp)
  80147f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801482:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801485:	7c d9                	jl     801460 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801487:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	01 d0                	add    %edx,%eax
  80148f:	c6 00 00             	movb   $0x0,(%eax)
}
  801492:	90                   	nop
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801498:	8b 45 14             	mov    0x14(%ebp),%eax
  80149b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a4:	8b 00                	mov    (%eax),%eax
  8014a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b0:	01 d0                	add    %edx,%eax
  8014b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b8:	eb 0c                	jmp    8014c6 <strsplit+0x31>
			*string++ = 0;
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8d 50 01             	lea    0x1(%eax),%edx
  8014c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8a 00                	mov    (%eax),%al
  8014cb:	84 c0                	test   %al,%al
  8014cd:	74 18                	je     8014e7 <strsplit+0x52>
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	0f be c0             	movsbl %al,%eax
  8014d7:	50                   	push   %eax
  8014d8:	ff 75 0c             	pushl  0xc(%ebp)
  8014db:	e8 83 fa ff ff       	call   800f63 <strchr>
  8014e0:	83 c4 08             	add    $0x8,%esp
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	75 d3                	jne    8014ba <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	84 c0                	test   %al,%al
  8014ee:	74 5a                	je     80154a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f3:	8b 00                	mov    (%eax),%eax
  8014f5:	83 f8 0f             	cmp    $0xf,%eax
  8014f8:	75 07                	jne    801501 <strsplit+0x6c>
		{
			return 0;
  8014fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ff:	eb 66                	jmp    801567 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801501:	8b 45 14             	mov    0x14(%ebp),%eax
  801504:	8b 00                	mov    (%eax),%eax
  801506:	8d 48 01             	lea    0x1(%eax),%ecx
  801509:	8b 55 14             	mov    0x14(%ebp),%edx
  80150c:	89 0a                	mov    %ecx,(%edx)
  80150e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	01 c2                	add    %eax,%edx
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80151f:	eb 03                	jmp    801524 <strsplit+0x8f>
			string++;
  801521:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	84 c0                	test   %al,%al
  80152b:	74 8b                	je     8014b8 <strsplit+0x23>
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	0f be c0             	movsbl %al,%eax
  801535:	50                   	push   %eax
  801536:	ff 75 0c             	pushl  0xc(%ebp)
  801539:	e8 25 fa ff ff       	call   800f63 <strchr>
  80153e:	83 c4 08             	add    $0x8,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	74 dc                	je     801521 <strsplit+0x8c>
			string++;
	}
  801545:	e9 6e ff ff ff       	jmp    8014b8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80154a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80154b:	8b 45 14             	mov    0x14(%ebp),%eax
  80154e:	8b 00                	mov    (%eax),%eax
  801550:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	01 d0                	add    %edx,%eax
  80155c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801562:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801575:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80157c:	eb 4a                	jmp    8015c8 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80157e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	01 c2                	add    %eax,%edx
  801586:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158c:	01 c8                	add    %ecx,%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801592:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801595:	8b 45 0c             	mov    0xc(%ebp),%eax
  801598:	01 d0                	add    %edx,%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	3c 40                	cmp    $0x40,%al
  80159e:	7e 25                	jle    8015c5 <str2lower+0x5c>
  8015a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a6:	01 d0                	add    %edx,%eax
  8015a8:	8a 00                	mov    (%eax),%al
  8015aa:	3c 5a                	cmp    $0x5a,%al
  8015ac:	7f 17                	jg     8015c5 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	01 d0                	add    %edx,%eax
  8015b6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bc:	01 ca                	add    %ecx,%edx
  8015be:	8a 12                	mov    (%edx),%dl
  8015c0:	83 c2 20             	add    $0x20,%edx
  8015c3:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015c5:	ff 45 fc             	incl   -0x4(%ebp)
  8015c8:	ff 75 0c             	pushl  0xc(%ebp)
  8015cb:	e8 01 f8 ff ff       	call   800dd1 <strlen>
  8015d0:	83 c4 04             	add    $0x4,%esp
  8015d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015d6:	7f a6                	jg     80157e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	57                   	push   %edi
  8015e1:	56                   	push   %esi
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015f2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015f5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015f8:	cd 30                	int    $0x30
  8015fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	5b                   	pop    %ebx
  801604:	5e                   	pop    %esi
  801605:	5f                   	pop    %edi
  801606:	5d                   	pop    %ebp
  801607:	c3                   	ret    

00801608 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	83 ec 04             	sub    $0x4,%esp
  80160e:	8b 45 10             	mov    0x10(%ebp),%eax
  801611:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801614:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801617:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	6a 00                	push   $0x0
  801620:	51                   	push   %ecx
  801621:	52                   	push   %edx
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	50                   	push   %eax
  801626:	6a 00                	push   $0x0
  801628:	e8 b0 ff ff ff       	call   8015dd <syscall>
  80162d:	83 c4 18             	add    $0x18,%esp
}
  801630:	90                   	nop
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <sys_cgetc>:

int
sys_cgetc(void)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 02                	push   $0x2
  801642:	e8 96 ff ff ff       	call   8015dd <syscall>
  801647:	83 c4 18             	add    $0x18,%esp
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 03                	push   $0x3
  80165b:	e8 7d ff ff ff       	call   8015dd <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
}
  801663:	90                   	nop
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 04                	push   $0x4
  801675:	e8 63 ff ff ff       	call   8015dd <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
}
  80167d:	90                   	nop
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801683:	8b 55 0c             	mov    0xc(%ebp),%edx
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	52                   	push   %edx
  801690:	50                   	push   %eax
  801691:	6a 08                	push   $0x8
  801693:	e8 45 ff ff ff       	call   8015dd <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	56                   	push   %esi
  8016a1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016a2:	8b 75 18             	mov    0x18(%ebp),%esi
  8016a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	56                   	push   %esi
  8016b2:	53                   	push   %ebx
  8016b3:	51                   	push   %ecx
  8016b4:	52                   	push   %edx
  8016b5:	50                   	push   %eax
  8016b6:	6a 09                	push   $0x9
  8016b8:	e8 20 ff ff ff       	call   8015dd <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
}
  8016c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c3:	5b                   	pop    %ebx
  8016c4:	5e                   	pop    %esi
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    

008016c7 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	ff 75 08             	pushl  0x8(%ebp)
  8016d5:	6a 0a                	push   $0xa
  8016d7:	e8 01 ff ff ff       	call   8015dd <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	ff 75 08             	pushl  0x8(%ebp)
  8016f0:	6a 0b                	push   $0xb
  8016f2:	e8 e6 fe ff ff       	call   8015dd <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 0c                	push   $0xc
  80170b:	e8 cd fe ff ff       	call   8015dd <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 0d                	push   $0xd
  801724:	e8 b4 fe ff ff       	call   8015dd <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 0e                	push   $0xe
  80173d:	e8 9b fe ff ff       	call   8015dd <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 0f                	push   $0xf
  801756:	e8 82 fe ff ff       	call   8015dd <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	ff 75 08             	pushl  0x8(%ebp)
  80176e:	6a 10                	push   $0x10
  801770:	e8 68 fe ff ff       	call   8015dd <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 11                	push   $0x11
  801789:	e8 4f fe ff ff       	call   8015dd <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	90                   	nop
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_cputc>:

void
sys_cputc(const char c)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 04             	sub    $0x4,%esp
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017a0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	50                   	push   %eax
  8017ad:	6a 01                	push   $0x1
  8017af:	e8 29 fe ff ff       	call   8015dd <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	90                   	nop
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 14                	push   $0x14
  8017c9:	e8 0f fe ff ff       	call   8015dd <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	90                   	nop
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017e0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017e3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	51                   	push   %ecx
  8017ed:	52                   	push   %edx
  8017ee:	ff 75 0c             	pushl  0xc(%ebp)
  8017f1:	50                   	push   %eax
  8017f2:	6a 15                	push   $0x15
  8017f4:	e8 e4 fd ff ff       	call   8015dd <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801801:	8b 55 0c             	mov    0xc(%ebp),%edx
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	52                   	push   %edx
  80180e:	50                   	push   %eax
  80180f:	6a 16                	push   $0x16
  801811:	e8 c7 fd ff ff       	call   8015dd <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80181e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801821:	8b 55 0c             	mov    0xc(%ebp),%edx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	51                   	push   %ecx
  80182c:	52                   	push   %edx
  80182d:	50                   	push   %eax
  80182e:	6a 17                	push   $0x17
  801830:	e8 a8 fd ff ff       	call   8015dd <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80183d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	52                   	push   %edx
  80184a:	50                   	push   %eax
  80184b:	6a 18                	push   $0x18
  80184d:	e8 8b fd ff ff       	call   8015dd <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	6a 00                	push   $0x0
  80185f:	ff 75 14             	pushl  0x14(%ebp)
  801862:	ff 75 10             	pushl  0x10(%ebp)
  801865:	ff 75 0c             	pushl  0xc(%ebp)
  801868:	50                   	push   %eax
  801869:	6a 19                	push   $0x19
  80186b:	e8 6d fd ff ff       	call   8015dd <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	50                   	push   %eax
  801884:	6a 1a                	push   $0x1a
  801886:	e8 52 fd ff ff       	call   8015dd <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	90                   	nop
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	50                   	push   %eax
  8018a0:	6a 1b                	push   $0x1b
  8018a2:	e8 36 fd ff ff       	call   8015dd <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 05                	push   $0x5
  8018bb:	e8 1d fd ff ff       	call   8015dd <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 06                	push   $0x6
  8018d4:	e8 04 fd ff ff       	call   8015dd <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 07                	push   $0x7
  8018ed:	e8 eb fc ff ff       	call   8015dd <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_exit_env>:


void sys_exit_env(void)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 1c                	push   $0x1c
  801906:	e8 d2 fc ff ff       	call   8015dd <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	90                   	nop
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801917:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80191a:	8d 50 04             	lea    0x4(%eax),%edx
  80191d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	52                   	push   %edx
  801927:	50                   	push   %eax
  801928:	6a 1d                	push   $0x1d
  80192a:	e8 ae fc ff ff       	call   8015dd <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
	return result;
  801932:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801935:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801938:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80193b:	89 01                	mov    %eax,(%ecx)
  80193d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	c9                   	leave  
  801944:	c2 04 00             	ret    $0x4

00801947 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	ff 75 10             	pushl  0x10(%ebp)
  801951:	ff 75 0c             	pushl  0xc(%ebp)
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	6a 13                	push   $0x13
  801959:	e8 7f fc ff ff       	call   8015dd <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
	return ;
  801961:	90                   	nop
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_rcr2>:
uint32 sys_rcr2()
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 1e                	push   $0x1e
  801973:	e8 65 fc ff ff       	call   8015dd <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 04             	sub    $0x4,%esp
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801989:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	50                   	push   %eax
  801996:	6a 1f                	push   $0x1f
  801998:	e8 40 fc ff ff       	call   8015dd <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a0:	90                   	nop
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <rsttst>:
void rsttst()
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 21                	push   $0x21
  8019b2:	e8 26 fc ff ff       	call   8015dd <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ba:	90                   	nop
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 04             	sub    $0x4,%esp
  8019c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019c9:	8b 55 18             	mov    0x18(%ebp),%edx
  8019cc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019d0:	52                   	push   %edx
  8019d1:	50                   	push   %eax
  8019d2:	ff 75 10             	pushl  0x10(%ebp)
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	6a 20                	push   $0x20
  8019dd:	e8 fb fb ff ff       	call   8015dd <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e5:	90                   	nop
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <chktst>:
void chktst(uint32 n)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	ff 75 08             	pushl  0x8(%ebp)
  8019f6:	6a 22                	push   $0x22
  8019f8:	e8 e0 fb ff ff       	call   8015dd <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801a00:	90                   	nop
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <inctst>:

void inctst()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 23                	push   $0x23
  801a12:	e8 c6 fb ff ff       	call   8015dd <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1a:	90                   	nop
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <gettst>:
uint32 gettst()
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 24                	push   $0x24
  801a2c:	e8 ac fb ff ff       	call   8015dd <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 25                	push   $0x25
  801a45:	e8 93 fb ff ff       	call   8015dd <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
  801a4d:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a52:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	ff 75 08             	pushl  0x8(%ebp)
  801a6f:	6a 26                	push   $0x26
  801a71:	e8 67 fb ff ff       	call   8015dd <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
	return ;
  801a79:	90                   	nop
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	53                   	push   %ebx
  801a8f:	51                   	push   %ecx
  801a90:	52                   	push   %edx
  801a91:	50                   	push   %eax
  801a92:	6a 27                	push   $0x27
  801a94:	e8 44 fb ff ff       	call   8015dd <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	52                   	push   %edx
  801ab1:	50                   	push   %eax
  801ab2:	6a 28                	push   $0x28
  801ab4:	e8 24 fb ff ff       	call   8015dd <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ac1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	6a 00                	push   $0x0
  801acc:	51                   	push   %ecx
  801acd:	ff 75 10             	pushl  0x10(%ebp)
  801ad0:	52                   	push   %edx
  801ad1:	50                   	push   %eax
  801ad2:	6a 29                	push   $0x29
  801ad4:	e8 04 fb ff ff       	call   8015dd <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	ff 75 10             	pushl  0x10(%ebp)
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	ff 75 08             	pushl  0x8(%ebp)
  801aee:	6a 12                	push   $0x12
  801af0:	e8 e8 fa ff ff       	call   8015dd <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
	return ;
  801af8:	90                   	nop
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	6a 2a                	push   $0x2a
  801b0e:	e8 ca fa ff ff       	call   8015dd <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
	return;
  801b16:	90                   	nop
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 2b                	push   $0x2b
  801b28:	e8 b0 fa ff ff       	call   8015dd <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	ff 75 08             	pushl  0x8(%ebp)
  801b41:	6a 2d                	push   $0x2d
  801b43:	e8 95 fa ff ff       	call   8015dd <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
	return;
  801b4b:	90                   	nop
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	ff 75 0c             	pushl  0xc(%ebp)
  801b5a:	ff 75 08             	pushl  0x8(%ebp)
  801b5d:	6a 2c                	push   $0x2c
  801b5f:	e8 79 fa ff ff       	call   8015dd <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
	return ;
  801b67:	90                   	nop
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	52                   	push   %edx
  801b7a:	50                   	push   %eax
  801b7b:	6a 2e                	push   $0x2e
  801b7d:	e8 5b fa ff ff       	call   8015dd <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	    return;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <__udivdi3>:
  801b88:	55                   	push   %ebp
  801b89:	57                   	push   %edi
  801b8a:	56                   	push   %esi
  801b8b:	53                   	push   %ebx
  801b8c:	83 ec 1c             	sub    $0x1c,%esp
  801b8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b9f:	89 ca                	mov    %ecx,%edx
  801ba1:	89 f8                	mov    %edi,%eax
  801ba3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ba7:	85 f6                	test   %esi,%esi
  801ba9:	75 2d                	jne    801bd8 <__udivdi3+0x50>
  801bab:	39 cf                	cmp    %ecx,%edi
  801bad:	77 65                	ja     801c14 <__udivdi3+0x8c>
  801baf:	89 fd                	mov    %edi,%ebp
  801bb1:	85 ff                	test   %edi,%edi
  801bb3:	75 0b                	jne    801bc0 <__udivdi3+0x38>
  801bb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bba:	31 d2                	xor    %edx,%edx
  801bbc:	f7 f7                	div    %edi
  801bbe:	89 c5                	mov    %eax,%ebp
  801bc0:	31 d2                	xor    %edx,%edx
  801bc2:	89 c8                	mov    %ecx,%eax
  801bc4:	f7 f5                	div    %ebp
  801bc6:	89 c1                	mov    %eax,%ecx
  801bc8:	89 d8                	mov    %ebx,%eax
  801bca:	f7 f5                	div    %ebp
  801bcc:	89 cf                	mov    %ecx,%edi
  801bce:	89 fa                	mov    %edi,%edx
  801bd0:	83 c4 1c             	add    $0x1c,%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    
  801bd8:	39 ce                	cmp    %ecx,%esi
  801bda:	77 28                	ja     801c04 <__udivdi3+0x7c>
  801bdc:	0f bd fe             	bsr    %esi,%edi
  801bdf:	83 f7 1f             	xor    $0x1f,%edi
  801be2:	75 40                	jne    801c24 <__udivdi3+0x9c>
  801be4:	39 ce                	cmp    %ecx,%esi
  801be6:	72 0a                	jb     801bf2 <__udivdi3+0x6a>
  801be8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bec:	0f 87 9e 00 00 00    	ja     801c90 <__udivdi3+0x108>
  801bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf7:	89 fa                	mov    %edi,%edx
  801bf9:	83 c4 1c             	add    $0x1c,%esp
  801bfc:	5b                   	pop    %ebx
  801bfd:	5e                   	pop    %esi
  801bfe:	5f                   	pop    %edi
  801bff:	5d                   	pop    %ebp
  801c00:	c3                   	ret    
  801c01:	8d 76 00             	lea    0x0(%esi),%esi
  801c04:	31 ff                	xor    %edi,%edi
  801c06:	31 c0                	xor    %eax,%eax
  801c08:	89 fa                	mov    %edi,%edx
  801c0a:	83 c4 1c             	add    $0x1c,%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5e                   	pop    %esi
  801c0f:	5f                   	pop    %edi
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    
  801c12:	66 90                	xchg   %ax,%ax
  801c14:	89 d8                	mov    %ebx,%eax
  801c16:	f7 f7                	div    %edi
  801c18:	31 ff                	xor    %edi,%edi
  801c1a:	89 fa                	mov    %edi,%edx
  801c1c:	83 c4 1c             	add    $0x1c,%esp
  801c1f:	5b                   	pop    %ebx
  801c20:	5e                   	pop    %esi
  801c21:	5f                   	pop    %edi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    
  801c24:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c29:	89 eb                	mov    %ebp,%ebx
  801c2b:	29 fb                	sub    %edi,%ebx
  801c2d:	89 f9                	mov    %edi,%ecx
  801c2f:	d3 e6                	shl    %cl,%esi
  801c31:	89 c5                	mov    %eax,%ebp
  801c33:	88 d9                	mov    %bl,%cl
  801c35:	d3 ed                	shr    %cl,%ebp
  801c37:	89 e9                	mov    %ebp,%ecx
  801c39:	09 f1                	or     %esi,%ecx
  801c3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c3f:	89 f9                	mov    %edi,%ecx
  801c41:	d3 e0                	shl    %cl,%eax
  801c43:	89 c5                	mov    %eax,%ebp
  801c45:	89 d6                	mov    %edx,%esi
  801c47:	88 d9                	mov    %bl,%cl
  801c49:	d3 ee                	shr    %cl,%esi
  801c4b:	89 f9                	mov    %edi,%ecx
  801c4d:	d3 e2                	shl    %cl,%edx
  801c4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c53:	88 d9                	mov    %bl,%cl
  801c55:	d3 e8                	shr    %cl,%eax
  801c57:	09 c2                	or     %eax,%edx
  801c59:	89 d0                	mov    %edx,%eax
  801c5b:	89 f2                	mov    %esi,%edx
  801c5d:	f7 74 24 0c          	divl   0xc(%esp)
  801c61:	89 d6                	mov    %edx,%esi
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	f7 e5                	mul    %ebp
  801c67:	39 d6                	cmp    %edx,%esi
  801c69:	72 19                	jb     801c84 <__udivdi3+0xfc>
  801c6b:	74 0b                	je     801c78 <__udivdi3+0xf0>
  801c6d:	89 d8                	mov    %ebx,%eax
  801c6f:	31 ff                	xor    %edi,%edi
  801c71:	e9 58 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c7c:	89 f9                	mov    %edi,%ecx
  801c7e:	d3 e2                	shl    %cl,%edx
  801c80:	39 c2                	cmp    %eax,%edx
  801c82:	73 e9                	jae    801c6d <__udivdi3+0xe5>
  801c84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c87:	31 ff                	xor    %edi,%edi
  801c89:	e9 40 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c8e:	66 90                	xchg   %ax,%ax
  801c90:	31 c0                	xor    %eax,%eax
  801c92:	e9 37 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c97:	90                   	nop

00801c98 <__umoddi3>:
  801c98:	55                   	push   %ebp
  801c99:	57                   	push   %edi
  801c9a:	56                   	push   %esi
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 1c             	sub    $0x1c,%esp
  801c9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ca3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ca7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801caf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cb7:	89 f3                	mov    %esi,%ebx
  801cb9:	89 fa                	mov    %edi,%edx
  801cbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cbf:	89 34 24             	mov    %esi,(%esp)
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	75 1a                	jne    801ce0 <__umoddi3+0x48>
  801cc6:	39 f7                	cmp    %esi,%edi
  801cc8:	0f 86 a2 00 00 00    	jbe    801d70 <__umoddi3+0xd8>
  801cce:	89 c8                	mov    %ecx,%eax
  801cd0:	89 f2                	mov    %esi,%edx
  801cd2:	f7 f7                	div    %edi
  801cd4:	89 d0                	mov    %edx,%eax
  801cd6:	31 d2                	xor    %edx,%edx
  801cd8:	83 c4 1c             	add    $0x1c,%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5f                   	pop    %edi
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    
  801ce0:	39 f0                	cmp    %esi,%eax
  801ce2:	0f 87 ac 00 00 00    	ja     801d94 <__umoddi3+0xfc>
  801ce8:	0f bd e8             	bsr    %eax,%ebp
  801ceb:	83 f5 1f             	xor    $0x1f,%ebp
  801cee:	0f 84 ac 00 00 00    	je     801da0 <__umoddi3+0x108>
  801cf4:	bf 20 00 00 00       	mov    $0x20,%edi
  801cf9:	29 ef                	sub    %ebp,%edi
  801cfb:	89 fe                	mov    %edi,%esi
  801cfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d01:	89 e9                	mov    %ebp,%ecx
  801d03:	d3 e0                	shl    %cl,%eax
  801d05:	89 d7                	mov    %edx,%edi
  801d07:	89 f1                	mov    %esi,%ecx
  801d09:	d3 ef                	shr    %cl,%edi
  801d0b:	09 c7                	or     %eax,%edi
  801d0d:	89 e9                	mov    %ebp,%ecx
  801d0f:	d3 e2                	shl    %cl,%edx
  801d11:	89 14 24             	mov    %edx,(%esp)
  801d14:	89 d8                	mov    %ebx,%eax
  801d16:	d3 e0                	shl    %cl,%eax
  801d18:	89 c2                	mov    %eax,%edx
  801d1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1e:	d3 e0                	shl    %cl,%eax
  801d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d24:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d28:	89 f1                	mov    %esi,%ecx
  801d2a:	d3 e8                	shr    %cl,%eax
  801d2c:	09 d0                	or     %edx,%eax
  801d2e:	d3 eb                	shr    %cl,%ebx
  801d30:	89 da                	mov    %ebx,%edx
  801d32:	f7 f7                	div    %edi
  801d34:	89 d3                	mov    %edx,%ebx
  801d36:	f7 24 24             	mull   (%esp)
  801d39:	89 c6                	mov    %eax,%esi
  801d3b:	89 d1                	mov    %edx,%ecx
  801d3d:	39 d3                	cmp    %edx,%ebx
  801d3f:	0f 82 87 00 00 00    	jb     801dcc <__umoddi3+0x134>
  801d45:	0f 84 91 00 00 00    	je     801ddc <__umoddi3+0x144>
  801d4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d4f:	29 f2                	sub    %esi,%edx
  801d51:	19 cb                	sbb    %ecx,%ebx
  801d53:	89 d8                	mov    %ebx,%eax
  801d55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d59:	d3 e0                	shl    %cl,%eax
  801d5b:	89 e9                	mov    %ebp,%ecx
  801d5d:	d3 ea                	shr    %cl,%edx
  801d5f:	09 d0                	or     %edx,%eax
  801d61:	89 e9                	mov    %ebp,%ecx
  801d63:	d3 eb                	shr    %cl,%ebx
  801d65:	89 da                	mov    %ebx,%edx
  801d67:	83 c4 1c             	add    $0x1c,%esp
  801d6a:	5b                   	pop    %ebx
  801d6b:	5e                   	pop    %esi
  801d6c:	5f                   	pop    %edi
  801d6d:	5d                   	pop    %ebp
  801d6e:	c3                   	ret    
  801d6f:	90                   	nop
  801d70:	89 fd                	mov    %edi,%ebp
  801d72:	85 ff                	test   %edi,%edi
  801d74:	75 0b                	jne    801d81 <__umoddi3+0xe9>
  801d76:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7b:	31 d2                	xor    %edx,%edx
  801d7d:	f7 f7                	div    %edi
  801d7f:	89 c5                	mov    %eax,%ebp
  801d81:	89 f0                	mov    %esi,%eax
  801d83:	31 d2                	xor    %edx,%edx
  801d85:	f7 f5                	div    %ebp
  801d87:	89 c8                	mov    %ecx,%eax
  801d89:	f7 f5                	div    %ebp
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	e9 44 ff ff ff       	jmp    801cd6 <__umoddi3+0x3e>
  801d92:	66 90                	xchg   %ax,%ax
  801d94:	89 c8                	mov    %ecx,%eax
  801d96:	89 f2                	mov    %esi,%edx
  801d98:	83 c4 1c             	add    $0x1c,%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5f                   	pop    %edi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    
  801da0:	3b 04 24             	cmp    (%esp),%eax
  801da3:	72 06                	jb     801dab <__umoddi3+0x113>
  801da5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801da9:	77 0f                	ja     801dba <__umoddi3+0x122>
  801dab:	89 f2                	mov    %esi,%edx
  801dad:	29 f9                	sub    %edi,%ecx
  801daf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801db3:	89 14 24             	mov    %edx,(%esp)
  801db6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dba:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dbe:	8b 14 24             	mov    (%esp),%edx
  801dc1:	83 c4 1c             	add    $0x1c,%esp
  801dc4:	5b                   	pop    %ebx
  801dc5:	5e                   	pop    %esi
  801dc6:	5f                   	pop    %edi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    
  801dc9:	8d 76 00             	lea    0x0(%esi),%esi
  801dcc:	2b 04 24             	sub    (%esp),%eax
  801dcf:	19 fa                	sbb    %edi,%edx
  801dd1:	89 d1                	mov    %edx,%ecx
  801dd3:	89 c6                	mov    %eax,%esi
  801dd5:	e9 71 ff ff ff       	jmp    801d4b <__umoddi3+0xb3>
  801dda:	66 90                	xchg   %ax,%ax
  801ddc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801de0:	72 ea                	jb     801dcc <__umoddi3+0x134>
  801de2:	89 d9                	mov    %ebx,%ecx
  801de4:	e9 62 ff ff ff       	jmp    801d4b <__umoddi3+0xb3>
