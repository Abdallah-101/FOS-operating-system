
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 7b 02 00 00       	call   8002b1 <libmain>
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
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 c0 43 80 00       	push   $0x8043c0
  800050:	e8 8a 23 00 00       	call   8023df <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb c3 45 80 00       	mov    $0x8045c3,%ebx
  80006f:	ba 05 00 00 00       	mov    $0x5,%edx
  800074:	89 c7                	mov    %eax,%edi
  800076:	89 de                	mov    %ebx,%esi
  800078:	89 d1                	mov    %edx,%ecx
  80007a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80007c:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800082:	b9 14 00 00 00       	mov    $0x14,%ecx
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
  80008c:	89 d7                	mov    %edx,%edi
  80008e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800090:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	50                   	push   %eax
  80009a:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 fc 33 00 00       	call   8034a2 <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 f5 2f 00 00       	call   8030a3 <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 38 30 00 00       	call   8030ee <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 d0 43 80 00       	push   $0x8043d0
  8000c4:	e8 6f 06 00 00       	call   800738 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 3000,100, 50);
  8000cc:	6a 32                	push   $0x32
  8000ce:	6a 64                	push   $0x64
  8000d0:	68 b8 0b 00 00       	push   $0xbb8
  8000d5:	68 03 44 80 00       	push   $0x804403
  8000da:	e8 1f 31 00 00       	call   8031fe <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 3000,100, 50);
  8000e5:	6a 32                	push   $0x32
  8000e7:	6a 64                	push   $0x64
  8000e9:	68 b8 0b 00 00       	push   $0xbb8
  8000ee:	68 0c 44 80 00       	push   $0x80440c
  8000f3:	e8 06 31 00 00       	call   8031fe <sys_create_env>
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 d8             	pushl  -0x28(%ebp)
  800104:	e8 13 31 00 00       	call   80321c <sys_run_env>
  800109:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	68 98 3a 00 00       	push   $0x3a98
  800114:	e8 7d 3e 00 00       	call   803f96 <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800122:	e8 f5 30 00 00       	call   80321c <sys_run_env>
  800127:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  80012a:	90                   	nop
  80012b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	83 f8 02             	cmp    $0x2,%eax
  800133:	75 f6                	jne    80012b <_main+0xf3>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800135:	e8 69 2f 00 00       	call   8030a3 <sys_calculate_free_frames>
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	50                   	push   %eax
  80013e:	68 18 44 80 00       	push   $0x804418
  800143:	e8 f0 05 00 00       	call   800738 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  80014b:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	50                   	push   %eax
  800155:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80015b:	50                   	push   %eax
  80015c:	e8 41 33 00 00       	call   8034a2 <sys_utilities>
  800161:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800164:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80016a:	bb 27 46 80 00       	mov    $0x804627,%ebx
  80016f:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800174:	89 c7                	mov    %eax,%edi
  800176:	89 de                	mov    %ebx,%esi
  800178:	89 d1                	mov    %edx,%ecx
  80017a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80017c:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  800182:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800187:	b0 00                	mov    $0x0,%al
  800189:	89 d7                	mov    %edx,%edi
  80018b:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	6a 00                	push   $0x0
  800192:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800198:	50                   	push   %eax
  800199:	e8 04 33 00 00       	call   8034a2 <sys_utilities>
  80019e:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001a7:	e8 8c 30 00 00       	call   803238 <sys_destroy_env>
  8001ac:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001b5:	e8 7e 30 00 00       	call   803238 <sys_destroy_env>
  8001ba:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	6a 01                	push   $0x1
  8001c2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	e8 d4 32 00 00       	call   8034a2 <sys_utilities>
  8001ce:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001d1:	e8 cd 2e 00 00       	call   8030a3 <sys_calculate_free_frames>
  8001d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001d9:	e8 10 2f 00 00       	call   8030ee <sys_pf_calculate_allocated_pages>
  8001de:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  8001e1:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8001e8:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  8001ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001f1:	01 d0                	add    %edx,%eax
  8001f3:	48                   	dec    %eax
  8001f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ff:	f7 75 c8             	divl   -0x38(%ebp)
  800202:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800205:	29 d0                	sub    %edx,%eax
  800207:	89 c1                	mov    %eax,%ecx
  800209:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800210:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800216:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800219:	01 d0                	add    %edx,%eax
  80021b:	48                   	dec    %eax
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80021f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800222:	ba 00 00 00 00       	mov    $0x0,%edx
  800227:	f7 75 c0             	divl   -0x40(%ebp)
  80022a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80022d:	29 d0                	sub    %edx,%eax
  80022f:	29 c1                	sub    %eax,%ecx
  800231:	89 c8                	mov    %ecx,%eax
  800233:	c1 e8 0c             	shr    $0xc,%eax
  800236:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 b8             	pushl  -0x48(%ebp)
  80023f:	68 4a 44 80 00       	push   $0x80444a
  800244:	e8 ef 04 00 00       	call   800738 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  80024c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800252:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800255:	74 2e                	je     800285 <_main+0x24d>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800257:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80025a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80025d:	ff 75 b8             	pushl  -0x48(%ebp)
  800260:	50                   	push   %eax
  800261:	ff 75 d0             	pushl  -0x30(%ebp)
  800264:	68 5c 44 80 00       	push   $0x80445c
  800269:	e8 ca 04 00 00       	call   800738 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800271:	83 ec 04             	sub    $0x4,%esp
  800274:	68 cc 44 80 00       	push   $0x8044cc
  800279:	6a 36                	push   $0x36
  80027b:	68 02 45 80 00       	push   $0x804502
  800280:	e8 e5 01 00 00       	call   80046a <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	ff 75 d0             	pushl  -0x30(%ebp)
  80028b:	68 18 45 80 00       	push   $0x804518
  800290:	e8 a3 04 00 00       	call   800738 <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	68 78 45 80 00       	push   $0x804578
  8002a0:	e8 93 04 00 00       	call   800738 <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	return;
  8002a8:	90                   	nop
}
  8002a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ac:	5b                   	pop    %ebx
  8002ad:	5e                   	pop    %esi
  8002ae:	5f                   	pop    %edi
  8002af:	5d                   	pop    %ebp
  8002b0:	c3                   	ret    

008002b1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002ba:	e8 ad 2f 00 00       	call   80326c <sys_getenvindex>
  8002bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002c5:	89 d0                	mov    %edx,%eax
  8002c7:	c1 e0 02             	shl    $0x2,%eax
  8002ca:	01 d0                	add    %edx,%eax
  8002cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	89 c2                	mov    %eax,%edx
  8002d7:	c1 e2 04             	shl    $0x4,%edx
  8002da:	29 c2                	sub    %eax,%edx
  8002dc:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002eb:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f0:	a1 20 60 80 00       	mov    0x806020,%eax
  8002f5:	8a 40 20             	mov    0x20(%eax),%al
  8002f8:	84 c0                	test   %al,%al
  8002fa:	74 0d                	je     800309 <libmain+0x58>
		binaryname = myEnv->prog_name;
  8002fc:	a1 20 60 80 00       	mov    0x806020,%eax
  800301:	83 c0 20             	add    $0x20,%eax
  800304:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800309:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80030d:	7e 0a                	jle    800319 <libmain+0x68>
		binaryname = argv[0];
  80030f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800319:	83 ec 08             	sub    $0x8,%esp
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	e8 11 fd ff ff       	call   800038 <_main>
  800327:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80032a:	a1 00 60 80 00       	mov    0x806000,%eax
  80032f:	85 c0                	test   %eax,%eax
  800331:	0f 84 01 01 00 00    	je     800438 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800337:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80033d:	bb 84 47 80 00       	mov    $0x804784,%ebx
  800342:	ba 0e 00 00 00       	mov    $0xe,%edx
  800347:	89 c7                	mov    %eax,%edi
  800349:	89 de                	mov    %ebx,%esi
  80034b:	89 d1                	mov    %edx,%ecx
  80034d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80034f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800352:	b9 56 00 00 00       	mov    $0x56,%ecx
  800357:	b0 00                	mov    $0x0,%al
  800359:	89 d7                	mov    %edx,%edi
  80035b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80035d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800364:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	50                   	push   %eax
  80036b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800371:	50                   	push   %eax
  800372:	e8 2b 31 00 00       	call   8034a2 <sys_utilities>
  800377:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80037a:	e8 74 2c 00 00       	call   802ff3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 a4 46 80 00       	push   $0x8046a4
  800387:	e8 ac 03 00 00       	call   800738 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80038f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800392:	85 c0                	test   %eax,%eax
  800394:	74 18                	je     8003ae <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800396:	e8 25 31 00 00       	call   8034c0 <sys_get_optimal_num_faults>
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	50                   	push   %eax
  80039f:	68 cc 46 80 00       	push   $0x8046cc
  8003a4:	e8 8f 03 00 00       	call   800738 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
  8003ac:	eb 59                	jmp    800407 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003ae:	a1 20 60 80 00       	mov    0x806020,%eax
  8003b3:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003b9:	a1 20 60 80 00       	mov    0x806020,%eax
  8003be:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003c4:	83 ec 04             	sub    $0x4,%esp
  8003c7:	52                   	push   %edx
  8003c8:	50                   	push   %eax
  8003c9:	68 f0 46 80 00       	push   $0x8046f0
  8003ce:	e8 65 03 00 00       	call   800738 <cprintf>
  8003d3:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003d6:	a1 20 60 80 00       	mov    0x806020,%eax
  8003db:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8003e1:	a1 20 60 80 00       	mov    0x806020,%eax
  8003e6:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8003ec:	a1 20 60 80 00       	mov    0x806020,%eax
  8003f1:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8003f7:	51                   	push   %ecx
  8003f8:	52                   	push   %edx
  8003f9:	50                   	push   %eax
  8003fa:	68 18 47 80 00       	push   $0x804718
  8003ff:	e8 34 03 00 00       	call   800738 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800407:	a1 20 60 80 00       	mov    0x806020,%eax
  80040c:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800412:	83 ec 08             	sub    $0x8,%esp
  800415:	50                   	push   %eax
  800416:	68 70 47 80 00       	push   $0x804770
  80041b:	e8 18 03 00 00       	call   800738 <cprintf>
  800420:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	68 a4 46 80 00       	push   $0x8046a4
  80042b:	e8 08 03 00 00       	call   800738 <cprintf>
  800430:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800433:	e8 d5 2b 00 00       	call   80300d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800438:	e8 1f 00 00 00       	call   80045c <exit>
}
  80043d:	90                   	nop
  80043e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800441:	5b                   	pop    %ebx
  800442:	5e                   	pop    %esi
  800443:	5f                   	pop    %edi
  800444:	5d                   	pop    %ebp
  800445:	c3                   	ret    

00800446 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	6a 00                	push   $0x0
  800451:	e8 e2 2d 00 00       	call   803238 <sys_destroy_env>
  800456:	83 c4 10             	add    $0x10,%esp
}
  800459:	90                   	nop
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    

0080045c <exit>:

void
exit(void)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
  80045f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800462:	e8 37 2e 00 00       	call   80329e <sys_exit_env>
}
  800467:	90                   	nop
  800468:	c9                   	leave  
  800469:	c3                   	ret    

0080046a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800470:	8d 45 10             	lea    0x10(%ebp),%eax
  800473:	83 c0 04             	add    $0x4,%eax
  800476:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800479:	a1 18 e1 81 00       	mov    0x81e118,%eax
  80047e:	85 c0                	test   %eax,%eax
  800480:	74 16                	je     800498 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800482:	a1 18 e1 81 00       	mov    0x81e118,%eax
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	50                   	push   %eax
  80048b:	68 e8 47 80 00       	push   $0x8047e8
  800490:	e8 a3 02 00 00       	call   800738 <cprintf>
  800495:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800498:	a1 04 60 80 00       	mov    0x806004,%eax
  80049d:	83 ec 0c             	sub    $0xc,%esp
  8004a0:	ff 75 0c             	pushl  0xc(%ebp)
  8004a3:	ff 75 08             	pushl  0x8(%ebp)
  8004a6:	50                   	push   %eax
  8004a7:	68 f0 47 80 00       	push   $0x8047f0
  8004ac:	6a 74                	push   $0x74
  8004ae:	e8 b2 02 00 00       	call   800765 <cprintf_colored>
  8004b3:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8004bf:	50                   	push   %eax
  8004c0:	e8 04 02 00 00       	call   8006c9 <vcprintf>
  8004c5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	6a 00                	push   $0x0
  8004cd:	68 18 48 80 00       	push   $0x804818
  8004d2:	e8 f2 01 00 00       	call   8006c9 <vcprintf>
  8004d7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004da:	e8 7d ff ff ff       	call   80045c <exit>

	// should not return here
	while (1) ;
  8004df:	eb fe                	jmp    8004df <_panic+0x75>

008004e1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004e7:	a1 20 60 80 00       	mov    0x806020,%eax
  8004ec:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	39 c2                	cmp    %eax,%edx
  8004f7:	74 14                	je     80050d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004f9:	83 ec 04             	sub    $0x4,%esp
  8004fc:	68 1c 48 80 00       	push   $0x80481c
  800501:	6a 26                	push   $0x26
  800503:	68 68 48 80 00       	push   $0x804868
  800508:	e8 5d ff ff ff       	call   80046a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80050d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800514:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051b:	e9 c5 00 00 00       	jmp    8005e5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	01 d0                	add    %edx,%eax
  80052f:	8b 00                	mov    (%eax),%eax
  800531:	85 c0                	test   %eax,%eax
  800533:	75 08                	jne    80053d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800535:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800538:	e9 a5 00 00 00       	jmp    8005e2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80053d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800544:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80054b:	eb 69                	jmp    8005b6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80054d:	a1 20 60 80 00       	mov    0x806020,%eax
  800552:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800558:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80055b:	89 d0                	mov    %edx,%eax
  80055d:	01 c0                	add    %eax,%eax
  80055f:	01 d0                	add    %edx,%eax
  800561:	c1 e0 03             	shl    $0x3,%eax
  800564:	01 c8                	add    %ecx,%eax
  800566:	8a 40 04             	mov    0x4(%eax),%al
  800569:	84 c0                	test   %al,%al
  80056b:	75 46                	jne    8005b3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80056d:	a1 20 60 80 00       	mov    0x806020,%eax
  800572:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800578:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80057b:	89 d0                	mov    %edx,%eax
  80057d:	01 c0                	add    %eax,%eax
  80057f:	01 d0                	add    %edx,%eax
  800581:	c1 e0 03             	shl    $0x3,%eax
  800584:	01 c8                	add    %ecx,%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80058b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80058e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800593:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800598:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80059f:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a2:	01 c8                	add    %ecx,%eax
  8005a4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a6:	39 c2                	cmp    %eax,%edx
  8005a8:	75 09                	jne    8005b3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005aa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005b1:	eb 15                	jmp    8005c8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b3:	ff 45 e8             	incl   -0x18(%ebp)
  8005b6:	a1 20 60 80 00       	mov    0x806020,%eax
  8005bb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c4:	39 c2                	cmp    %eax,%edx
  8005c6:	77 85                	ja     80054d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005cc:	75 14                	jne    8005e2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	68 74 48 80 00       	push   $0x804874
  8005d6:	6a 3a                	push   $0x3a
  8005d8:	68 68 48 80 00       	push   $0x804868
  8005dd:	e8 88 fe ff ff       	call   80046a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005e2:	ff 45 f0             	incl   -0x10(%ebp)
  8005e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005eb:	0f 8c 2f ff ff ff    	jl     800520 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005ff:	eb 26                	jmp    800627 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800601:	a1 20 60 80 00       	mov    0x806020,%eax
  800606:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80060c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	01 c0                	add    %eax,%eax
  800613:	01 d0                	add    %edx,%eax
  800615:	c1 e0 03             	shl    $0x3,%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8a 40 04             	mov    0x4(%eax),%al
  80061d:	3c 01                	cmp    $0x1,%al
  80061f:	75 03                	jne    800624 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800621:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800624:	ff 45 e0             	incl   -0x20(%ebp)
  800627:	a1 20 60 80 00       	mov    0x806020,%eax
  80062c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800635:	39 c2                	cmp    %eax,%edx
  800637:	77 c8                	ja     800601 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80063c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80063f:	74 14                	je     800655 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	68 c8 48 80 00       	push   $0x8048c8
  800649:	6a 44                	push   $0x44
  80064b:	68 68 48 80 00       	push   $0x804868
  800650:	e8 15 fe ff ff       	call   80046a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800655:	90                   	nop
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
  80065b:	53                   	push   %ebx
  80065c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80065f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800662:	8b 00                	mov    (%eax),%eax
  800664:	8d 48 01             	lea    0x1(%eax),%ecx
  800667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066a:	89 0a                	mov    %ecx,(%edx)
  80066c:	8b 55 08             	mov    0x8(%ebp),%edx
  80066f:	88 d1                	mov    %dl,%cl
  800671:	8b 55 0c             	mov    0xc(%ebp),%edx
  800674:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800678:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800682:	75 30                	jne    8006b4 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800684:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  80068a:	a0 44 60 80 00       	mov    0x806044,%al
  80068f:	0f b6 c0             	movzbl %al,%eax
  800692:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800695:	8b 09                	mov    (%ecx),%ecx
  800697:	89 cb                	mov    %ecx,%ebx
  800699:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80069c:	83 c1 08             	add    $0x8,%ecx
  80069f:	52                   	push   %edx
  8006a0:	50                   	push   %eax
  8006a1:	53                   	push   %ebx
  8006a2:	51                   	push   %ecx
  8006a3:	e8 07 29 00 00       	call   802faf <sys_cputs>
  8006a8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b7:	8b 40 04             	mov    0x4(%eax),%eax
  8006ba:	8d 50 01             	lea    0x1(%eax),%edx
  8006bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006c3:	90                   	nop
  8006c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006c7:	c9                   	leave  
  8006c8:	c3                   	ret    

008006c9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006c9:	55                   	push   %ebp
  8006ca:	89 e5                	mov    %esp,%ebp
  8006cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d9:	00 00 00 
	b.cnt = 0;
  8006dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f2:	50                   	push   %eax
  8006f3:	68 58 06 80 00       	push   $0x800658
  8006f8:	e8 5a 02 00 00       	call   800957 <vprintfmt>
  8006fd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800700:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800706:	a0 44 60 80 00       	mov    0x806044,%al
  80070b:	0f b6 c0             	movzbl %al,%eax
  80070e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800714:	52                   	push   %edx
  800715:	50                   	push   %eax
  800716:	51                   	push   %ecx
  800717:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071d:	83 c0 08             	add    $0x8,%eax
  800720:	50                   	push   %eax
  800721:	e8 89 28 00 00       	call   802faf <sys_cputs>
  800726:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800729:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800730:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800736:	c9                   	leave  
  800737:	c3                   	ret    

00800738 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80073e:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  800745:	8d 45 0c             	lea    0xc(%ebp),%eax
  800748:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	ff 75 f4             	pushl  -0xc(%ebp)
  800754:	50                   	push   %eax
  800755:	e8 6f ff ff ff       	call   8006c9 <vcprintf>
  80075a:	83 c4 10             	add    $0x10,%esp
  80075d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800760:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80076b:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	c1 e0 08             	shl    $0x8,%eax
  800778:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  80077d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800780:	83 c0 04             	add    $0x4,%eax
  800783:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800786:	8b 45 0c             	mov    0xc(%ebp),%eax
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 f4             	pushl  -0xc(%ebp)
  80078f:	50                   	push   %eax
  800790:	e8 34 ff ff ff       	call   8006c9 <vcprintf>
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80079b:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  8007a2:	07 00 00 

	return cnt;
  8007a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007b0:	e8 3e 28 00 00       	call   802ff3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c4:	50                   	push   %eax
  8007c5:	e8 ff fe ff ff       	call   8006c9 <vcprintf>
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007d0:	e8 38 28 00 00       	call   80300d <sys_unlock_cons>
	return cnt;
  8007d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d8:	c9                   	leave  
  8007d9:	c3                   	ret    

008007da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	53                   	push   %ebx
  8007de:	83 ec 14             	sub    $0x14,%esp
  8007e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ed:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f8:	77 55                	ja     80084f <printnum+0x75>
  8007fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007fd:	72 05                	jb     800804 <printnum+0x2a>
  8007ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800802:	77 4b                	ja     80084f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800804:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800807:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80080a:	8b 45 18             	mov    0x18(%ebp),%eax
  80080d:	ba 00 00 00 00       	mov    $0x0,%edx
  800812:	52                   	push   %edx
  800813:	50                   	push   %eax
  800814:	ff 75 f4             	pushl  -0xc(%ebp)
  800817:	ff 75 f0             	pushl  -0x10(%ebp)
  80081a:	e8 3d 39 00 00       	call   80415c <__udivdi3>
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	ff 75 20             	pushl  0x20(%ebp)
  800828:	53                   	push   %ebx
  800829:	ff 75 18             	pushl  0x18(%ebp)
  80082c:	52                   	push   %edx
  80082d:	50                   	push   %eax
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	ff 75 08             	pushl  0x8(%ebp)
  800834:	e8 a1 ff ff ff       	call   8007da <printnum>
  800839:	83 c4 20             	add    $0x20,%esp
  80083c:	eb 1a                	jmp    800858 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	ff 75 20             	pushl  0x20(%ebp)
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	ff d0                	call   *%eax
  80084c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80084f:	ff 4d 1c             	decl   0x1c(%ebp)
  800852:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800856:	7f e6                	jg     80083e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800858:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80085b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800863:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800866:	53                   	push   %ebx
  800867:	51                   	push   %ecx
  800868:	52                   	push   %edx
  800869:	50                   	push   %eax
  80086a:	e8 fd 39 00 00       	call   80426c <__umoddi3>
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	05 34 4b 80 00       	add    $0x804b34,%eax
  800877:	8a 00                	mov    (%eax),%al
  800879:	0f be c0             	movsbl %al,%eax
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	50                   	push   %eax
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	ff d0                	call   *%eax
  800888:	83 c4 10             	add    $0x10,%esp
}
  80088b:	90                   	nop
  80088c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088f:	c9                   	leave  
  800890:	c3                   	ret    

00800891 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800894:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800898:	7e 1c                	jle    8008b6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 08             	lea    0x8(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 08             	sub    $0x8,%eax
  8008af:	8b 50 04             	mov    0x4(%eax),%edx
  8008b2:	8b 00                	mov    (%eax),%eax
  8008b4:	eb 40                	jmp    8008f6 <getuint+0x65>
	else if (lflag)
  8008b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ba:	74 1e                	je     8008da <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	8d 50 04             	lea    0x4(%eax),%edx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	89 10                	mov    %edx,(%eax)
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d8:	eb 1c                	jmp    8008f6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	8d 50 04             	lea    0x4(%eax),%edx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	89 10                	mov    %edx,(%eax)
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ff:	7e 1c                	jle    80091d <getint+0x25>
		return va_arg(*ap, long long);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 08             	lea    0x8(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 08             	sub    $0x8,%eax
  800916:	8b 50 04             	mov    0x4(%eax),%edx
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	eb 38                	jmp    800955 <getint+0x5d>
	else if (lflag)
  80091d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800921:	74 1a                	je     80093d <getint+0x45>
		return va_arg(*ap, long);
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	8d 50 04             	lea    0x4(%eax),%edx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	89 10                	mov    %edx,(%eax)
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	83 e8 04             	sub    $0x4,%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	99                   	cltd   
  80093b:	eb 18                	jmp    800955 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 04             	lea    0x4(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	99                   	cltd   
}
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	56                   	push   %esi
  80095b:	53                   	push   %ebx
  80095c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80095f:	eb 17                	jmp    800978 <vprintfmt+0x21>
			if (ch == '\0')
  800961:	85 db                	test   %ebx,%ebx
  800963:	0f 84 c1 03 00 00    	je     800d2a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	53                   	push   %ebx
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	ff d0                	call   *%eax
  800975:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800978:	8b 45 10             	mov    0x10(%ebp),%eax
  80097b:	8d 50 01             	lea    0x1(%eax),%edx
  80097e:	89 55 10             	mov    %edx,0x10(%ebp)
  800981:	8a 00                	mov    (%eax),%al
  800983:	0f b6 d8             	movzbl %al,%ebx
  800986:	83 fb 25             	cmp    $0x25,%ebx
  800989:	75 d6                	jne    800961 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80098b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80098f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800996:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80099d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009a4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ae:	8d 50 01             	lea    0x1(%eax),%edx
  8009b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b4:	8a 00                	mov    (%eax),%al
  8009b6:	0f b6 d8             	movzbl %al,%ebx
  8009b9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009bc:	83 f8 5b             	cmp    $0x5b,%eax
  8009bf:	0f 87 3d 03 00 00    	ja     800d02 <vprintfmt+0x3ab>
  8009c5:	8b 04 85 58 4b 80 00 	mov    0x804b58(,%eax,4),%eax
  8009cc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ce:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009d2:	eb d7                	jmp    8009ab <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009d4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009d8:	eb d1                	jmp    8009ab <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009e4:	89 d0                	mov    %edx,%eax
  8009e6:	c1 e0 02             	shl    $0x2,%eax
  8009e9:	01 d0                	add    %edx,%eax
  8009eb:	01 c0                	add    %eax,%eax
  8009ed:	01 d8                	add    %ebx,%eax
  8009ef:	83 e8 30             	sub    $0x30,%eax
  8009f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f8:	8a 00                	mov    (%eax),%al
  8009fa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009fd:	83 fb 2f             	cmp    $0x2f,%ebx
  800a00:	7e 3e                	jle    800a40 <vprintfmt+0xe9>
  800a02:	83 fb 39             	cmp    $0x39,%ebx
  800a05:	7f 39                	jg     800a40 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a07:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a0a:	eb d5                	jmp    8009e1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	83 c0 04             	add    $0x4,%eax
  800a12:	89 45 14             	mov    %eax,0x14(%ebp)
  800a15:	8b 45 14             	mov    0x14(%ebp),%eax
  800a18:	83 e8 04             	sub    $0x4,%eax
  800a1b:	8b 00                	mov    (%eax),%eax
  800a1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a20:	eb 1f                	jmp    800a41 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a26:	79 83                	jns    8009ab <vprintfmt+0x54>
				width = 0;
  800a28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a2f:	e9 77 ff ff ff       	jmp    8009ab <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a34:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a3b:	e9 6b ff ff ff       	jmp    8009ab <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a40:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a45:	0f 89 60 ff ff ff    	jns    8009ab <vprintfmt+0x54>
				width = precision, precision = -1;
  800a4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a51:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a58:	e9 4e ff ff ff       	jmp    8009ab <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a5d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a60:	e9 46 ff ff ff       	jmp    8009ab <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a65:	8b 45 14             	mov    0x14(%ebp),%eax
  800a68:	83 c0 04             	add    $0x4,%eax
  800a6b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a71:	83 e8 04             	sub    $0x4,%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	50                   	push   %eax
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	ff d0                	call   *%eax
  800a82:	83 c4 10             	add    $0x10,%esp
			break;
  800a85:	e9 9b 02 00 00       	jmp    800d25 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	83 c0 04             	add    $0x4,%eax
  800a90:	89 45 14             	mov    %eax,0x14(%ebp)
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	83 e8 04             	sub    $0x4,%eax
  800a99:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a9b:	85 db                	test   %ebx,%ebx
  800a9d:	79 02                	jns    800aa1 <vprintfmt+0x14a>
				err = -err;
  800a9f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aa1:	83 fb 64             	cmp    $0x64,%ebx
  800aa4:	7f 0b                	jg     800ab1 <vprintfmt+0x15a>
  800aa6:	8b 34 9d a0 49 80 00 	mov    0x8049a0(,%ebx,4),%esi
  800aad:	85 f6                	test   %esi,%esi
  800aaf:	75 19                	jne    800aca <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ab1:	53                   	push   %ebx
  800ab2:	68 45 4b 80 00       	push   $0x804b45
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	ff 75 08             	pushl  0x8(%ebp)
  800abd:	e8 70 02 00 00       	call   800d32 <printfmt>
  800ac2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ac5:	e9 5b 02 00 00       	jmp    800d25 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aca:	56                   	push   %esi
  800acb:	68 4e 4b 80 00       	push   $0x804b4e
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	ff 75 08             	pushl  0x8(%ebp)
  800ad6:	e8 57 02 00 00       	call   800d32 <printfmt>
  800adb:	83 c4 10             	add    $0x10,%esp
			break;
  800ade:	e9 42 02 00 00       	jmp    800d25 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 30                	mov    (%eax),%esi
  800af4:	85 f6                	test   %esi,%esi
  800af6:	75 05                	jne    800afd <vprintfmt+0x1a6>
				p = "(null)";
  800af8:	be 51 4b 80 00       	mov    $0x804b51,%esi
			if (width > 0 && padc != '-')
  800afd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b01:	7e 6d                	jle    800b70 <vprintfmt+0x219>
  800b03:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b07:	74 67                	je     800b70 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	50                   	push   %eax
  800b10:	56                   	push   %esi
  800b11:	e8 1e 03 00 00       	call   800e34 <strnlen>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b1c:	eb 16                	jmp    800b34 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b1e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b22:	83 ec 08             	sub    $0x8,%esp
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	50                   	push   %eax
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	ff d0                	call   *%eax
  800b2e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b31:	ff 4d e4             	decl   -0x1c(%ebp)
  800b34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b38:	7f e4                	jg     800b1e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3a:	eb 34                	jmp    800b70 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b40:	74 1c                	je     800b5e <vprintfmt+0x207>
  800b42:	83 fb 1f             	cmp    $0x1f,%ebx
  800b45:	7e 05                	jle    800b4c <vprintfmt+0x1f5>
  800b47:	83 fb 7e             	cmp    $0x7e,%ebx
  800b4a:	7e 12                	jle    800b5e <vprintfmt+0x207>
					putch('?', putdat);
  800b4c:	83 ec 08             	sub    $0x8,%esp
  800b4f:	ff 75 0c             	pushl  0xc(%ebp)
  800b52:	6a 3f                	push   $0x3f
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	ff d0                	call   *%eax
  800b59:	83 c4 10             	add    $0x10,%esp
  800b5c:	eb 0f                	jmp    800b6d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	53                   	push   %ebx
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b70:	89 f0                	mov    %esi,%eax
  800b72:	8d 70 01             	lea    0x1(%eax),%esi
  800b75:	8a 00                	mov    (%eax),%al
  800b77:	0f be d8             	movsbl %al,%ebx
  800b7a:	85 db                	test   %ebx,%ebx
  800b7c:	74 24                	je     800ba2 <vprintfmt+0x24b>
  800b7e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b82:	78 b8                	js     800b3c <vprintfmt+0x1e5>
  800b84:	ff 4d e0             	decl   -0x20(%ebp)
  800b87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8b:	79 af                	jns    800b3c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b8d:	eb 13                	jmp    800ba2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 20                	push   $0x20
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9f:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba6:	7f e7                	jg     800b8f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ba8:	e9 78 01 00 00       	jmp    800d25 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb3:	8d 45 14             	lea    0x14(%ebp),%eax
  800bb6:	50                   	push   %eax
  800bb7:	e8 3c fd ff ff       	call   8008f8 <getint>
  800bbc:	83 c4 10             	add    $0x10,%esp
  800bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcb:	85 d2                	test   %edx,%edx
  800bcd:	79 23                	jns    800bf2 <vprintfmt+0x29b>
				putch('-', putdat);
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	6a 2d                	push   $0x2d
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	ff d0                	call   *%eax
  800bdc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be5:	f7 d8                	neg    %eax
  800be7:	83 d2 00             	adc    $0x0,%edx
  800bea:	f7 da                	neg    %edx
  800bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bf2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf9:	e9 bc 00 00 00       	jmp    800cba <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bfe:	83 ec 08             	sub    $0x8,%esp
  800c01:	ff 75 e8             	pushl  -0x18(%ebp)
  800c04:	8d 45 14             	lea    0x14(%ebp),%eax
  800c07:	50                   	push   %eax
  800c08:	e8 84 fc ff ff       	call   800891 <getuint>
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c13:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c16:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c1d:	e9 98 00 00 00       	jmp    800cba <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c22:	83 ec 08             	sub    $0x8,%esp
  800c25:	ff 75 0c             	pushl  0xc(%ebp)
  800c28:	6a 58                	push   $0x58
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	ff d0                	call   *%eax
  800c2f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 58                	push   $0x58
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	ff 75 0c             	pushl  0xc(%ebp)
  800c48:	6a 58                	push   $0x58
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	ff d0                	call   *%eax
  800c4f:	83 c4 10             	add    $0x10,%esp
			break;
  800c52:	e9 ce 00 00 00       	jmp    800d25 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c57:	83 ec 08             	sub    $0x8,%esp
  800c5a:	ff 75 0c             	pushl  0xc(%ebp)
  800c5d:	6a 30                	push   $0x30
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	ff d0                	call   *%eax
  800c64:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	6a 78                	push   $0x78
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	ff d0                	call   *%eax
  800c74:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c77:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7a:	83 c0 04             	add    $0x4,%eax
  800c7d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c80:	8b 45 14             	mov    0x14(%ebp),%eax
  800c83:	83 e8 04             	sub    $0x4,%eax
  800c86:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c92:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c99:	eb 1f                	jmp    800cba <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c9b:	83 ec 08             	sub    $0x8,%esp
  800c9e:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca4:	50                   	push   %eax
  800ca5:	e8 e7 fb ff ff       	call   800891 <getuint>
  800caa:	83 c4 10             	add    $0x10,%esp
  800cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cb3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cba:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc1:	83 ec 04             	sub    $0x4,%esp
  800cc4:	52                   	push   %edx
  800cc5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cc8:	50                   	push   %eax
  800cc9:	ff 75 f4             	pushl  -0xc(%ebp)
  800ccc:	ff 75 f0             	pushl  -0x10(%ebp)
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 00 fb ff ff       	call   8007da <printnum>
  800cda:	83 c4 20             	add    $0x20,%esp
			break;
  800cdd:	eb 46                	jmp    800d25 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cdf:	83 ec 08             	sub    $0x8,%esp
  800ce2:	ff 75 0c             	pushl  0xc(%ebp)
  800ce5:	53                   	push   %ebx
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	ff d0                	call   *%eax
  800ceb:	83 c4 10             	add    $0x10,%esp
			break;
  800cee:	eb 35                	jmp    800d25 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cf0:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  800cf7:	eb 2c                	jmp    800d25 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cf9:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  800d00:	eb 23                	jmp    800d25 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d02:	83 ec 08             	sub    $0x8,%esp
  800d05:	ff 75 0c             	pushl  0xc(%ebp)
  800d08:	6a 25                	push   $0x25
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	ff d0                	call   *%eax
  800d0f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d12:	ff 4d 10             	decl   0x10(%ebp)
  800d15:	eb 03                	jmp    800d1a <vprintfmt+0x3c3>
  800d17:	ff 4d 10             	decl   0x10(%ebp)
  800d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1d:	48                   	dec    %eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	3c 25                	cmp    $0x25,%al
  800d22:	75 f3                	jne    800d17 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d24:	90                   	nop
		}
	}
  800d25:	e9 35 fc ff ff       	jmp    80095f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d2a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    

00800d32 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d38:	8d 45 10             	lea    0x10(%ebp),%eax
  800d3b:	83 c0 04             	add    $0x4,%eax
  800d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d41:	8b 45 10             	mov    0x10(%ebp),%eax
  800d44:	ff 75 f4             	pushl  -0xc(%ebp)
  800d47:	50                   	push   %eax
  800d48:	ff 75 0c             	pushl  0xc(%ebp)
  800d4b:	ff 75 08             	pushl  0x8(%ebp)
  800d4e:	e8 04 fc ff ff       	call   800957 <vprintfmt>
  800d53:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d56:	90                   	nop
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    

00800d59 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8b 40 08             	mov    0x8(%eax),%eax
  800d62:	8d 50 01             	lea    0x1(%eax),%edx
  800d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d68:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 10                	mov    (%eax),%edx
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8b 40 04             	mov    0x4(%eax),%eax
  800d76:	39 c2                	cmp    %eax,%edx
  800d78:	73 12                	jae    800d8c <sprintputch+0x33>
		*b->buf++ = ch;
  800d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7d:	8b 00                	mov    (%eax),%eax
  800d7f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d85:	89 0a                	mov    %ecx,(%edx)
  800d87:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8a:	88 10                	mov    %dl,(%eax)
}
  800d8c:	90                   	nop
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	01 d0                	add    %edx,%eax
  800da6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800db0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db4:	74 06                	je     800dbc <vsnprintf+0x2d>
  800db6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dba:	7f 07                	jg     800dc3 <vsnprintf+0x34>
		return -E_INVAL;
  800dbc:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc1:	eb 20                	jmp    800de3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dc3:	ff 75 14             	pushl  0x14(%ebp)
  800dc6:	ff 75 10             	pushl  0x10(%ebp)
  800dc9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dcc:	50                   	push   %eax
  800dcd:	68 59 0d 80 00       	push   $0x800d59
  800dd2:	e8 80 fb ff ff       	call   800957 <vprintfmt>
  800dd7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ddd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800deb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dee:	83 c0 04             	add    $0x4,%eax
  800df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800df4:	8b 45 10             	mov    0x10(%ebp),%eax
  800df7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dfa:	50                   	push   %eax
  800dfb:	ff 75 0c             	pushl  0xc(%ebp)
  800dfe:	ff 75 08             	pushl  0x8(%ebp)
  800e01:	e8 89 ff ff ff       	call   800d8f <vsnprintf>
  800e06:	83 c4 10             	add    $0x10,%esp
  800e09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e1e:	eb 06                	jmp    800e26 <strlen+0x15>
		n++;
  800e20:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e23:	ff 45 08             	incl   0x8(%ebp)
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	84 c0                	test   %al,%al
  800e2d:	75 f1                	jne    800e20 <strlen+0xf>
		n++;
	return n;
  800e2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

00800e34 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e41:	eb 09                	jmp    800e4c <strnlen+0x18>
		n++;
  800e43:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e46:	ff 45 08             	incl   0x8(%ebp)
  800e49:	ff 4d 0c             	decl   0xc(%ebp)
  800e4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e50:	74 09                	je     800e5b <strnlen+0x27>
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	75 e8                	jne    800e43 <strnlen+0xf>
		n++;
	return n;
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e5e:	c9                   	leave  
  800e5f:	c3                   	ret    

00800e60 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e6c:	90                   	nop
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 08             	mov    %edx,0x8(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e7c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7f:	8a 12                	mov    (%edx),%dl
  800e81:	88 10                	mov    %dl,(%eax)
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	84 c0                	test   %al,%al
  800e87:	75 e4                	jne    800e6d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea1:	eb 1f                	jmp    800ec2 <strncpy+0x34>
		*dst++ = *src;
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8d 50 01             	lea    0x1(%eax),%edx
  800ea9:	89 55 08             	mov    %edx,0x8(%ebp)
  800eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaf:	8a 12                	mov    (%edx),%dl
  800eb1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	84 c0                	test   %al,%al
  800eba:	74 03                	je     800ebf <strncpy+0x31>
			src++;
  800ebc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ebf:	ff 45 fc             	incl   -0x4(%ebp)
  800ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec8:	72 d9                	jb     800ea3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800edb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800edf:	74 30                	je     800f11 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ee1:	eb 16                	jmp    800ef9 <strlcpy+0x2a>
			*dst++ = *src++;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	8d 50 01             	lea    0x1(%eax),%edx
  800ee9:	89 55 08             	mov    %edx,0x8(%ebp)
  800eec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eef:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef5:	8a 12                	mov    (%edx),%dl
  800ef7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef9:	ff 4d 10             	decl   0x10(%ebp)
  800efc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f00:	74 09                	je     800f0b <strlcpy+0x3c>
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	84 c0                	test   %al,%al
  800f09:	75 d8                	jne    800ee3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f17:	29 c2                	sub    %eax,%edx
  800f19:	89 d0                	mov    %edx,%eax
}
  800f1b:	c9                   	leave  
  800f1c:	c3                   	ret    

00800f1d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f20:	eb 06                	jmp    800f28 <strcmp+0xb>
		p++, q++;
  800f22:	ff 45 08             	incl   0x8(%ebp)
  800f25:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	84 c0                	test   %al,%al
  800f2f:	74 0e                	je     800f3f <strcmp+0x22>
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 10                	mov    (%eax),%dl
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	38 c2                	cmp    %al,%dl
  800f3d:	74 e3                	je     800f22 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f b6 d0             	movzbl %al,%edx
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	0f b6 c0             	movzbl %al,%eax
  800f4f:	29 c2                	sub    %eax,%edx
  800f51:	89 d0                	mov    %edx,%eax
}
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f58:	eb 09                	jmp    800f63 <strncmp+0xe>
		n--, p++, q++;
  800f5a:	ff 4d 10             	decl   0x10(%ebp)
  800f5d:	ff 45 08             	incl   0x8(%ebp)
  800f60:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f67:	74 17                	je     800f80 <strncmp+0x2b>
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	84 c0                	test   %al,%al
  800f70:	74 0e                	je     800f80 <strncmp+0x2b>
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 10                	mov    (%eax),%dl
  800f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	38 c2                	cmp    %al,%dl
  800f7e:	74 da                	je     800f5a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f84:	75 07                	jne    800f8d <strncmp+0x38>
		return 0;
  800f86:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8b:	eb 14                	jmp    800fa1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	0f b6 d0             	movzbl %al,%edx
  800f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	0f b6 c0             	movzbl %al,%eax
  800f9d:	29 c2                	sub    %eax,%edx
  800f9f:	89 d0                	mov    %edx,%eax
}
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 04             	sub    $0x4,%esp
  800fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fac:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800faf:	eb 12                	jmp    800fc3 <strchr+0x20>
		if (*s == c)
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb9:	75 05                	jne    800fc0 <strchr+0x1d>
			return (char *) s;
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	eb 11                	jmp    800fd1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fc0:	ff 45 08             	incl   0x8(%ebp)
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	84 c0                	test   %al,%al
  800fca:	75 e5                	jne    800fb1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 04             	sub    $0x4,%esp
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fdf:	eb 0d                	jmp    800fee <strfind+0x1b>
		if (*s == c)
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe9:	74 0e                	je     800ff9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	84 c0                	test   %al,%al
  800ff5:	75 ea                	jne    800fe1 <strfind+0xe>
  800ff7:	eb 01                	jmp    800ffa <strfind+0x27>
		if (*s == c)
			break;
  800ff9:	90                   	nop
	return (char *) s;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    

00800fff <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80100b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80100f:	76 63                	jbe    801074 <memset+0x75>
		uint64 data_block = c;
  801011:	8b 45 0c             	mov    0xc(%ebp),%eax
  801014:	99                   	cltd   
  801015:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801018:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80101b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801021:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801025:	c1 e0 08             	shl    $0x8,%eax
  801028:	09 45 f0             	or     %eax,-0x10(%ebp)
  80102b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80102e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801031:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801034:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801038:	c1 e0 10             	shl    $0x10,%eax
  80103b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80103e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	89 c2                	mov    %eax,%edx
  801049:	b8 00 00 00 00       	mov    $0x0,%eax
  80104e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801051:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801054:	eb 18                	jmp    80106e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801056:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801059:	8d 41 08             	lea    0x8(%ecx),%eax
  80105c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80105f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801065:	89 01                	mov    %eax,(%ecx)
  801067:	89 51 04             	mov    %edx,0x4(%ecx)
  80106a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80106e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801072:	77 e2                	ja     801056 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801074:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801078:	74 23                	je     80109d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80107a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801080:	eb 0e                	jmp    801090 <memset+0x91>
			*p8++ = (uint8)c;
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	8d 50 ff             	lea    -0x1(%eax),%edx
  801096:	89 55 10             	mov    %edx,0x10(%ebp)
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 e5                	jne    801082 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010b4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010b8:	76 24                	jbe    8010de <memcpy+0x3c>
		while(n >= 8){
  8010ba:	eb 1c                	jmp    8010d8 <memcpy+0x36>
			*d64 = *s64;
  8010bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bf:	8b 50 04             	mov    0x4(%eax),%edx
  8010c2:	8b 00                	mov    (%eax),%eax
  8010c4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010c7:	89 01                	mov    %eax,(%ecx)
  8010c9:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010cc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010d0:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010d4:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010d8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010dc:	77 de                	ja     8010bc <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e2:	74 31                	je     801115 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010f0:	eb 16                	jmp    801108 <memcpy+0x66>
			*d8++ = *s8++;
  8010f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f5:	8d 50 01             	lea    0x1(%eax),%edx
  8010f8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801101:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801104:	8a 12                	mov    (%edx),%dl
  801106:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801108:	8b 45 10             	mov    0x10(%ebp),%eax
  80110b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110e:	89 55 10             	mov    %edx,0x10(%ebp)
  801111:	85 c0                	test   %eax,%eax
  801113:	75 dd                	jne    8010f2 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80112c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801132:	73 50                	jae    801184 <memmove+0x6a>
  801134:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801137:	8b 45 10             	mov    0x10(%ebp),%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80113f:	76 43                	jbe    801184 <memmove+0x6a>
		s += n;
  801141:	8b 45 10             	mov    0x10(%ebp),%eax
  801144:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801147:	8b 45 10             	mov    0x10(%ebp),%eax
  80114a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80114d:	eb 10                	jmp    80115f <memmove+0x45>
			*--d = *--s;
  80114f:	ff 4d f8             	decl   -0x8(%ebp)
  801152:	ff 4d fc             	decl   -0x4(%ebp)
  801155:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801158:	8a 10                	mov    (%eax),%dl
  80115a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	8d 50 ff             	lea    -0x1(%eax),%edx
  801165:	89 55 10             	mov    %edx,0x10(%ebp)
  801168:	85 c0                	test   %eax,%eax
  80116a:	75 e3                	jne    80114f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80116c:	eb 23                	jmp    801191 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80116e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801171:	8d 50 01             	lea    0x1(%eax),%edx
  801174:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801177:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80117d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801180:	8a 12                	mov    (%edx),%dl
  801182:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118a:	89 55 10             	mov    %edx,0x10(%ebp)
  80118d:	85 c0                	test   %eax,%eax
  80118f:	75 dd                	jne    80116e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801194:	c9                   	leave  
  801195:	c3                   	ret    

00801196 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011a8:	eb 2a                	jmp    8011d4 <memcmp+0x3e>
		if (*s1 != *s2)
  8011aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ad:	8a 10                	mov    (%eax),%dl
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	38 c2                	cmp    %al,%dl
  8011b6:	74 16                	je     8011ce <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	0f b6 d0             	movzbl %al,%edx
  8011c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	0f b6 c0             	movzbl %al,%eax
  8011c8:	29 c2                	sub    %eax,%edx
  8011ca:	89 d0                	mov    %edx,%eax
  8011cc:	eb 18                	jmp    8011e6 <memcmp+0x50>
		s1++, s2++;
  8011ce:	ff 45 fc             	incl   -0x4(%ebp)
  8011d1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011da:	89 55 10             	mov    %edx,0x10(%ebp)
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	75 c9                	jne    8011aa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011f9:	eb 15                	jmp    801210 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	0f b6 d0             	movzbl %al,%edx
  801203:	8b 45 0c             	mov    0xc(%ebp),%eax
  801206:	0f b6 c0             	movzbl %al,%eax
  801209:	39 c2                	cmp    %eax,%edx
  80120b:	74 0d                	je     80121a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80120d:	ff 45 08             	incl   0x8(%ebp)
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801216:	72 e3                	jb     8011fb <memfind+0x13>
  801218:	eb 01                	jmp    80121b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80121a:	90                   	nop
	return (void *) s;
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801226:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80122d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801234:	eb 03                	jmp    801239 <strtol+0x19>
		s++;
  801236:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	3c 20                	cmp    $0x20,%al
  801240:	74 f4                	je     801236 <strtol+0x16>
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 09                	cmp    $0x9,%al
  801249:	74 eb                	je     801236 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	3c 2b                	cmp    $0x2b,%al
  801252:	75 05                	jne    801259 <strtol+0x39>
		s++;
  801254:	ff 45 08             	incl   0x8(%ebp)
  801257:	eb 13                	jmp    80126c <strtol+0x4c>
	else if (*s == '-')
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 2d                	cmp    $0x2d,%al
  801260:	75 0a                	jne    80126c <strtol+0x4c>
		s++, neg = 1;
  801262:	ff 45 08             	incl   0x8(%ebp)
  801265:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80126c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801270:	74 06                	je     801278 <strtol+0x58>
  801272:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801276:	75 20                	jne    801298 <strtol+0x78>
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	3c 30                	cmp    $0x30,%al
  80127f:	75 17                	jne    801298 <strtol+0x78>
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	40                   	inc    %eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	3c 78                	cmp    $0x78,%al
  801289:	75 0d                	jne    801298 <strtol+0x78>
		s += 2, base = 16;
  80128b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80128f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801296:	eb 28                	jmp    8012c0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801298:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80129c:	75 15                	jne    8012b3 <strtol+0x93>
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	3c 30                	cmp    $0x30,%al
  8012a5:	75 0c                	jne    8012b3 <strtol+0x93>
		s++, base = 8;
  8012a7:	ff 45 08             	incl   0x8(%ebp)
  8012aa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012b1:	eb 0d                	jmp    8012c0 <strtol+0xa0>
	else if (base == 0)
  8012b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b7:	75 07                	jne    8012c0 <strtol+0xa0>
		base = 10;
  8012b9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	8a 00                	mov    (%eax),%al
  8012c5:	3c 2f                	cmp    $0x2f,%al
  8012c7:	7e 19                	jle    8012e2 <strtol+0xc2>
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	8a 00                	mov    (%eax),%al
  8012ce:	3c 39                	cmp    $0x39,%al
  8012d0:	7f 10                	jg     8012e2 <strtol+0xc2>
			dig = *s - '0';
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	8a 00                	mov    (%eax),%al
  8012d7:	0f be c0             	movsbl %al,%eax
  8012da:	83 e8 30             	sub    $0x30,%eax
  8012dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012e0:	eb 42                	jmp    801324 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	3c 60                	cmp    $0x60,%al
  8012e9:	7e 19                	jle    801304 <strtol+0xe4>
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	3c 7a                	cmp    $0x7a,%al
  8012f2:	7f 10                	jg     801304 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	0f be c0             	movsbl %al,%eax
  8012fc:	83 e8 57             	sub    $0x57,%eax
  8012ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801302:	eb 20                	jmp    801324 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	3c 40                	cmp    $0x40,%al
  80130b:	7e 39                	jle    801346 <strtol+0x126>
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	3c 5a                	cmp    $0x5a,%al
  801314:	7f 30                	jg     801346 <strtol+0x126>
			dig = *s - 'A' + 10;
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	0f be c0             	movsbl %al,%eax
  80131e:	83 e8 37             	sub    $0x37,%eax
  801321:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801327:	3b 45 10             	cmp    0x10(%ebp),%eax
  80132a:	7d 19                	jge    801345 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80132c:	ff 45 08             	incl   0x8(%ebp)
  80132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801332:	0f af 45 10          	imul   0x10(%ebp),%eax
  801336:	89 c2                	mov    %eax,%edx
  801338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133b:	01 d0                	add    %edx,%eax
  80133d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801340:	e9 7b ff ff ff       	jmp    8012c0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801345:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801346:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80134a:	74 08                	je     801354 <strtol+0x134>
		*endptr = (char *) s;
  80134c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134f:	8b 55 08             	mov    0x8(%ebp),%edx
  801352:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801354:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801358:	74 07                	je     801361 <strtol+0x141>
  80135a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135d:	f7 d8                	neg    %eax
  80135f:	eb 03                	jmp    801364 <strtol+0x144>
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <ltostr>:

void
ltostr(long value, char *str)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80136c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801373:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80137a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80137e:	79 13                	jns    801393 <ltostr+0x2d>
	{
		neg = 1;
  801380:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80138d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801390:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80139b:	99                   	cltd   
  80139c:	f7 f9                	idiv   %ecx
  80139e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a4:	8d 50 01             	lea    0x1(%eax),%edx
  8013a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013aa:	89 c2                	mov    %eax,%edx
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	01 d0                	add    %edx,%eax
  8013b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013b4:	83 c2 30             	add    $0x30,%edx
  8013b7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013c1:	f7 e9                	imul   %ecx
  8013c3:	c1 fa 02             	sar    $0x2,%edx
  8013c6:	89 c8                	mov    %ecx,%eax
  8013c8:	c1 f8 1f             	sar    $0x1f,%eax
  8013cb:	29 c2                	sub    %eax,%edx
  8013cd:	89 d0                	mov    %edx,%eax
  8013cf:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d6:	75 bb                	jne    801393 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e2:	48                   	dec    %eax
  8013e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013ea:	74 3d                	je     801429 <ltostr+0xc3>
		start = 1 ;
  8013ec:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013f3:	eb 34                	jmp    801429 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801402:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801405:	8b 45 0c             	mov    0xc(%ebp),%eax
  801408:	01 c2                	add    %eax,%edx
  80140a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	01 c8                	add    %ecx,%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801416:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141c:	01 c2                	add    %eax,%edx
  80141e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801421:	88 02                	mov    %al,(%edx)
		start++ ;
  801423:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801426:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80142f:	7c c4                	jl     8013f5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801431:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	01 d0                	add    %edx,%eax
  801439:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80143c:	90                   	nop
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801445:	ff 75 08             	pushl  0x8(%ebp)
  801448:	e8 c4 f9 ff ff       	call   800e11 <strlen>
  80144d:	83 c4 04             	add    $0x4,%esp
  801450:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801453:	ff 75 0c             	pushl  0xc(%ebp)
  801456:	e8 b6 f9 ff ff       	call   800e11 <strlen>
  80145b:	83 c4 04             	add    $0x4,%esp
  80145e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801461:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801468:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146f:	eb 17                	jmp    801488 <strcconcat+0x49>
		final[s] = str1[s] ;
  801471:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 c2                	add    %eax,%edx
  801479:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	01 c8                	add    %ecx,%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801485:	ff 45 fc             	incl   -0x4(%ebp)
  801488:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80148e:	7c e1                	jl     801471 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801490:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801497:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80149e:	eb 1f                	jmp    8014bf <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a3:	8d 50 01             	lea    0x1(%eax),%edx
  8014a6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014a9:	89 c2                	mov    %eax,%edx
  8014ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ae:	01 c2                	add    %eax,%edx
  8014b0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b6:	01 c8                	add    %ecx,%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014bc:	ff 45 f8             	incl   -0x8(%ebp)
  8014bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014c5:	7c d9                	jl     8014a0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cd:	01 d0                	add    %edx,%eax
  8014cf:	c6 00 00             	movb   $0x0,(%eax)
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e4:	8b 00                	mov    (%eax),%eax
  8014e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	01 d0                	add    %edx,%eax
  8014f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014f8:	eb 0c                	jmp    801506 <strsplit+0x31>
			*string++ = 0;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8d 50 01             	lea    0x1(%eax),%edx
  801500:	89 55 08             	mov    %edx,0x8(%ebp)
  801503:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	84 c0                	test   %al,%al
  80150d:	74 18                	je     801527 <strsplit+0x52>
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f be c0             	movsbl %al,%eax
  801517:	50                   	push   %eax
  801518:	ff 75 0c             	pushl  0xc(%ebp)
  80151b:	e8 83 fa ff ff       	call   800fa3 <strchr>
  801520:	83 c4 08             	add    $0x8,%esp
  801523:	85 c0                	test   %eax,%eax
  801525:	75 d3                	jne    8014fa <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	84 c0                	test   %al,%al
  80152e:	74 5a                	je     80158a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801530:	8b 45 14             	mov    0x14(%ebp),%eax
  801533:	8b 00                	mov    (%eax),%eax
  801535:	83 f8 0f             	cmp    $0xf,%eax
  801538:	75 07                	jne    801541 <strsplit+0x6c>
		{
			return 0;
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
  80153f:	eb 66                	jmp    8015a7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801541:	8b 45 14             	mov    0x14(%ebp),%eax
  801544:	8b 00                	mov    (%eax),%eax
  801546:	8d 48 01             	lea    0x1(%eax),%ecx
  801549:	8b 55 14             	mov    0x14(%ebp),%edx
  80154c:	89 0a                	mov    %ecx,(%edx)
  80154e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801555:	8b 45 10             	mov    0x10(%ebp),%eax
  801558:	01 c2                	add    %eax,%edx
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80155f:	eb 03                	jmp    801564 <strsplit+0x8f>
			string++;
  801561:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	84 c0                	test   %al,%al
  80156b:	74 8b                	je     8014f8 <strsplit+0x23>
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	8a 00                	mov    (%eax),%al
  801572:	0f be c0             	movsbl %al,%eax
  801575:	50                   	push   %eax
  801576:	ff 75 0c             	pushl  0xc(%ebp)
  801579:	e8 25 fa ff ff       	call   800fa3 <strchr>
  80157e:	83 c4 08             	add    $0x8,%esp
  801581:	85 c0                	test   %eax,%eax
  801583:	74 dc                	je     801561 <strsplit+0x8c>
			string++;
	}
  801585:	e9 6e ff ff ff       	jmp    8014f8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80158a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80158b:	8b 45 14             	mov    0x14(%ebp),%eax
  80158e:	8b 00                	mov    (%eax),%eax
  801590:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801597:	8b 45 10             	mov    0x10(%ebp),%eax
  80159a:	01 d0                	add    %edx,%eax
  80159c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015a2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015bc:	eb 4a                	jmp    801608 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	01 c2                	add    %eax,%edx
  8015c6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cc:	01 c8                	add    %ecx,%eax
  8015ce:	8a 00                	mov    (%eax),%al
  8015d0:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	01 d0                	add    %edx,%eax
  8015da:	8a 00                	mov    (%eax),%al
  8015dc:	3c 40                	cmp    $0x40,%al
  8015de:	7e 25                	jle    801605 <str2lower+0x5c>
  8015e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e6:	01 d0                	add    %edx,%eax
  8015e8:	8a 00                	mov    (%eax),%al
  8015ea:	3c 5a                	cmp    $0x5a,%al
  8015ec:	7f 17                	jg     801605 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	01 d0                	add    %edx,%eax
  8015f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fc:	01 ca                	add    %ecx,%edx
  8015fe:	8a 12                	mov    (%edx),%dl
  801600:	83 c2 20             	add    $0x20,%edx
  801603:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801605:	ff 45 fc             	incl   -0x4(%ebp)
  801608:	ff 75 0c             	pushl  0xc(%ebp)
  80160b:	e8 01 f8 ff ff       	call   800e11 <strlen>
  801610:	83 c4 04             	add    $0x4,%esp
  801613:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801616:	7f a6                	jg     8015be <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801618:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801623:	a1 08 60 80 00       	mov    0x806008,%eax
  801628:	85 c0                	test   %eax,%eax
  80162a:	0f 84 95 00 00 00    	je     8016c5 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801630:	83 ec 08             	sub    $0x8,%esp
  801633:	68 00 00 00 82       	push   $0x82000000
  801638:	68 00 00 00 80       	push   $0x80000000
  80163d:	e8 59 1f 00 00       	call   80359b <initialize_dynamic_allocator>
  801642:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801645:	e8 93 1d 00 00       	call   8033dd <sys_get_uheap_strategy>
  80164a:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80164f:	a1 40 60 80 00       	mov    0x806040,%eax
  801654:	05 00 10 00 00       	add    $0x1000,%eax
  801659:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  80165e:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801663:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  801668:	83 ec 04             	sub    $0x4,%esp
  80166b:	6a 01                	push   $0x1
  80166d:	68 c8 4c 80 00       	push   $0x804cc8
  801672:	68 40 e1 81 00       	push   $0x81e140
  801677:	e8 d8 29 00 00       	call   804054 <init_uspinlock>
  80167c:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  80167f:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  801686:	00 00 00 
  801689:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  801690:	00 00 00 
  801693:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  80169a:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  80169d:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  8016a4:	00 00 00 
  8016a7:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  8016ae:	00 00 00 
  8016b1:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  8016b8:	00 00 00 
		__firstTimeFlag = 0;
  8016bb:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  8016c2:	00 00 00 
	}
}
  8016c5:	90                   	nop
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016dc:	83 ec 08             	sub    $0x8,%esp
  8016df:	68 06 04 00 00       	push   $0x406
  8016e4:	50                   	push   %eax
  8016e5:	e8 3d 19 00 00       	call   803027 <__sys_allocate_page>
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f4:	79 14                	jns    80170a <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	68 d0 4c 80 00       	push   $0x804cd0
  8016fe:	6a 2d                	push   $0x2d
  801700:	68 0c 4d 80 00       	push   $0x804d0c
  801705:	e8 60 ed ff ff       	call   80046a <_panic>
	return 0;
  80170a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801720:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801725:	83 ec 0c             	sub    $0xc,%esp
  801728:	50                   	push   %eax
  801729:	e8 40 19 00 00       	call   80306e <__sys_unmap_frame>
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801738:	79 14                	jns    80174e <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	68 18 4d 80 00       	push   $0x804d18
  801742:	6a 38                	push   $0x38
  801744:	68 0c 4d 80 00       	push   $0x804d0c
  801749:	e8 1c ed ff ff       	call   80046a <_panic>
}
  80174e:	90                   	nop
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801757:	e8 c1 fe ff ff       	call   80161d <uheap_init>
	if (size == 0) return NULL ;
  80175c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801760:	75 0a                	jne    80176c <malloc+0x1b>
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
  801767:	e9 e1 04 00 00       	jmp    801c4d <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	68 40 e1 81 00       	push   $0x81e140
  801774:	e8 2a 29 00 00       	call   8040a3 <acquire_uspinlock>
  801779:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  80177c:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  801783:	77 23                	ja     8017a8 <malloc+0x57>
		release_uspinlock(&ulock);
  801785:	83 ec 0c             	sub    $0xc,%esp
  801788:	68 40 e1 81 00       	push   $0x81e140
  80178d:	e8 69 29 00 00       	call   8040fb <release_uspinlock>
  801792:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  801795:	83 ec 0c             	sub    $0xc,%esp
  801798:	ff 75 08             	pushl  0x8(%ebp)
  80179b:	e8 dd 1f 00 00       	call   80377d <alloc_block>
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	e9 a5 04 00 00       	jmp    801c4d <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8017a8:	83 ec 0c             	sub    $0xc,%esp
  8017ab:	6a 10                	push   $0x10
  8017ad:	e8 cb 1f 00 00       	call   80377d <alloc_block>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  8017b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017bc:	75 0a                	jne    8017c8 <malloc+0x77>
			return NULL;
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	e9 85 04 00 00       	jmp    801c4d <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  8017c8:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8017cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d5:	01 d0                	add    %edx,%eax
  8017d7:	48                   	dec    %eax
  8017d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017de:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e3:	f7 75 e8             	divl   -0x18(%ebp)
  8017e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e9:	29 d0                	sub    %edx,%eax
  8017eb:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8017ee:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8017f3:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8017f6:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	74 0f                	je     80180e <malloc+0xbd>
  8017ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801802:	8b 40 04             	mov    0x4(%eax),%eax
  801805:	3b 45 08             	cmp    0x8(%ebp),%eax
  801808:	0f 83 ea 00 00 00    	jae    8018f8 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  80180e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801813:	2b 45 08             	sub    0x8(%ebp),%eax
  801816:	89 c2                	mov    %eax,%edx
  801818:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80181d:	39 c2                	cmp    %eax,%edx
  80181f:	0f 86 b9 00 00 00    	jbe    8018de <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801825:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80182a:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  80182d:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	01 d0                	add    %edx,%eax
  801838:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  80183d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801840:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801843:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801848:	8b 55 08             	mov    0x8(%ebp),%edx
  80184b:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80184e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801852:	75 14                	jne    801868 <malloc+0x117>
  801854:	83 ec 04             	sub    $0x4,%esp
  801857:	68 58 4d 80 00       	push   $0x804d58
  80185c:	6a 60                	push   $0x60
  80185e:	68 0c 4d 80 00       	push   $0x804d0c
  801863:	e8 02 ec ff ff       	call   80046a <_panic>
  801868:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80186e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801871:	89 50 0c             	mov    %edx,0xc(%eax)
  801874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801877:	8b 40 0c             	mov    0xc(%eax),%eax
  80187a:	85 c0                	test   %eax,%eax
  80187c:	74 0d                	je     80188b <malloc+0x13a>
  80187e:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801883:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801886:	89 50 08             	mov    %edx,0x8(%eax)
  801889:	eb 08                	jmp    801893 <malloc+0x142>
  80188b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188e:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801896:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80189b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80189e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8018a5:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8018aa:	40                   	inc    %eax
  8018ab:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  8018b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b3:	8b 00                	mov    (%eax),%eax
  8018b5:	83 ec 08             	sub    $0x8,%esp
  8018b8:	ff 75 08             	pushl  0x8(%ebp)
  8018bb:	50                   	push   %eax
  8018bc:	e8 34 1c 00 00       	call   8034f5 <sys_allocate_user_mem>
  8018c1:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  8018c4:	83 ec 0c             	sub    $0xc,%esp
  8018c7:	68 40 e1 81 00       	push   $0x81e140
  8018cc:	e8 2a 28 00 00       	call   8040fb <release_uspinlock>
  8018d1:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8018d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d7:	8b 00                	mov    (%eax),%eax
  8018d9:	e9 6f 03 00 00       	jmp    801c4d <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  8018de:	83 ec 0c             	sub    $0xc,%esp
  8018e1:	68 40 e1 81 00       	push   $0x81e140
  8018e6:	e8 10 28 00 00       	call   8040fb <release_uspinlock>
  8018eb:	83 c4 10             	add    $0x10,%esp
					return NULL;
  8018ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f3:	e9 55 03 00 00       	jmp    801c4d <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8018f8:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8018fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801900:	e9 39 03 00 00       	jmp    801c3e <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801908:	8b 40 04             	mov    0x4(%eax),%eax
  80190b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80190e:	0f 86 e7 01 00 00    	jbe    801afb <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801914:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801917:	8b 10                	mov    (%eax),%edx
  801919:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191c:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  80191e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801921:	8b 55 08             	mov    0x8(%ebp),%edx
  801924:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801927:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80192b:	75 14                	jne    801941 <malloc+0x1f0>
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	68 58 4d 80 00       	push   $0x804d58
  801935:	6a 72                	push   $0x72
  801937:	68 0c 4d 80 00       	push   $0x804d0c
  80193c:	e8 29 eb ff ff       	call   80046a <_panic>
  801941:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194a:	89 50 0c             	mov    %edx,0xc(%eax)
  80194d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801950:	8b 40 0c             	mov    0xc(%eax),%eax
  801953:	85 c0                	test   %eax,%eax
  801955:	74 0d                	je     801964 <malloc+0x213>
  801957:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80195c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80195f:	89 50 08             	mov    %edx,0x8(%eax)
  801962:	eb 08                	jmp    80196c <malloc+0x21b>
  801964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801967:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80196c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196f:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801977:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80197e:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801983:	40                   	inc    %eax
  801984:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  801989:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80198c:	8b 10                	mov    (%eax),%edx
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	01 c2                	add    %eax,%edx
  801993:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801996:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801998:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80199b:	8b 40 04             	mov    0x4(%eax),%eax
  80199e:	2b 45 08             	sub    0x8(%ebp),%eax
  8019a1:	89 c2                	mov    %eax,%edx
  8019a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a6:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8019a9:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8019ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  8019b1:	e9 0d 01 00 00       	jmp    801ac3 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  8019b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b9:	8b 50 04             	mov    0x4(%eax),%edx
  8019bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bf:	8b 40 04             	mov    0x4(%eax),%eax
  8019c2:	39 c2                	cmp    %eax,%edx
  8019c4:	0f 83 f0 00 00 00    	jae    801aba <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8019ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019ce:	75 14                	jne    8019e4 <malloc+0x293>
  8019d0:	83 ec 04             	sub    $0x4,%esp
  8019d3:	68 7b 4d 80 00       	push   $0x804d7b
  8019d8:	6a 7a                	push   $0x7a
  8019da:	68 0c 4d 80 00       	push   $0x804d0c
  8019df:	e8 86 ea ff ff       	call   80046a <_panic>
  8019e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e7:	8b 40 08             	mov    0x8(%eax),%eax
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	74 11                	je     8019ff <malloc+0x2ae>
  8019ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019f1:	8b 40 08             	mov    0x8(%eax),%eax
  8019f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019f7:	8b 52 0c             	mov    0xc(%edx),%edx
  8019fa:	89 50 0c             	mov    %edx,0xc(%eax)
  8019fd:	eb 0b                	jmp    801a0a <malloc+0x2b9>
  8019ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a02:	8b 40 0c             	mov    0xc(%eax),%eax
  801a05:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801a0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a0d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a10:	85 c0                	test   %eax,%eax
  801a12:	74 11                	je     801a25 <malloc+0x2d4>
  801a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a17:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a1d:	8b 52 08             	mov    0x8(%edx),%edx
  801a20:	89 50 08             	mov    %edx,0x8(%eax)
  801a23:	eb 0b                	jmp    801a30 <malloc+0x2df>
  801a25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a28:	8b 40 08             	mov    0x8(%eax),%eax
  801a2b:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801a30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a33:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a3d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a44:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801a49:	48                   	dec    %eax
  801a4a:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801a4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a53:	74 06                	je     801a5b <malloc+0x30a>
  801a55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a59:	75 14                	jne    801a6f <malloc+0x31e>
  801a5b:	83 ec 04             	sub    $0x4,%esp
  801a5e:	68 9c 4d 80 00       	push   $0x804d9c
  801a63:	6a 7b                	push   $0x7b
  801a65:	68 0c 4d 80 00       	push   $0x804d0c
  801a6a:	e8 fb e9 ff ff       	call   80046a <_panic>
  801a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a72:	8b 50 0c             	mov    0xc(%eax),%edx
  801a75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a78:	89 50 0c             	mov    %edx,0xc(%eax)
  801a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a81:	89 50 08             	mov    %edx,0x8(%eax)
  801a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a87:	8b 40 0c             	mov    0xc(%eax),%eax
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	74 0e                	je     801a9c <malloc+0x34b>
  801a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a91:	8b 40 0c             	mov    0xc(%eax),%eax
  801a94:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a97:	89 50 08             	mov    %edx,0x8(%eax)
  801a9a:	eb 08                	jmp    801aa4 <malloc+0x353>
  801a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a9f:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aaa:	89 50 0c             	mov    %edx,0xc(%eax)
  801aad:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801ab2:	40                   	inc    %eax
  801ab3:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  801ab8:	eb 13                	jmp    801acd <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abd:	8b 40 08             	mov    0x8(%eax),%eax
  801ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801ac3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ac7:	0f 85 e9 fe ff ff    	jne    8019b6 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad0:	8b 00                	mov    (%eax),%eax
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	ff 75 08             	pushl  0x8(%ebp)
  801ad8:	50                   	push   %eax
  801ad9:	e8 17 1a 00 00       	call   8034f5 <sys_allocate_user_mem>
  801ade:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801ae1:	83 ec 0c             	sub    $0xc,%esp
  801ae4:	68 40 e1 81 00       	push   $0x81e140
  801ae9:	e8 0d 26 00 00       	call   8040fb <release_uspinlock>
  801aee:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af4:	8b 00                	mov    (%eax),%eax
  801af6:	e9 52 01 00 00       	jmp    801c4d <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afe:	8b 40 04             	mov    0x4(%eax),%eax
  801b01:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b04:	0f 85 2b 01 00 00    	jne    801c35 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0d:	8b 10                	mov    (%eax),%edx
  801b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b12:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b17:	8b 55 08             	mov    0x8(%ebp),%edx
  801b1a:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801b1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b21:	75 17                	jne    801b3a <malloc+0x3e9>
  801b23:	83 ec 04             	sub    $0x4,%esp
  801b26:	68 58 4d 80 00       	push   $0x804d58
  801b2b:	68 89 00 00 00       	push   $0x89
  801b30:	68 0c 4d 80 00       	push   $0x804d0c
  801b35:	e8 30 e9 ff ff       	call   80046a <_panic>
  801b3a:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b43:	89 50 0c             	mov    %edx,0xc(%eax)
  801b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b49:	8b 40 0c             	mov    0xc(%eax),%eax
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	74 0d                	je     801b5d <malloc+0x40c>
  801b50:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801b55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b58:	89 50 08             	mov    %edx,0x8(%eax)
  801b5b:	eb 08                	jmp    801b65 <malloc+0x414>
  801b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b60:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b68:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801b77:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801b7c:	40                   	inc    %eax
  801b7d:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b86:	75 17                	jne    801b9f <malloc+0x44e>
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	68 7b 4d 80 00       	push   $0x804d7b
  801b90:	68 8a 00 00 00       	push   $0x8a
  801b95:	68 0c 4d 80 00       	push   $0x804d0c
  801b9a:	e8 cb e8 ff ff       	call   80046a <_panic>
  801b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba2:	8b 40 08             	mov    0x8(%eax),%eax
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	74 11                	je     801bba <malloc+0x469>
  801ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bac:	8b 40 08             	mov    0x8(%eax),%eax
  801baf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb2:	8b 52 0c             	mov    0xc(%edx),%edx
  801bb5:	89 50 0c             	mov    %edx,0xc(%eax)
  801bb8:	eb 0b                	jmp    801bc5 <malloc+0x474>
  801bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc0:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc8:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	74 11                	je     801be0 <malloc+0x48f>
  801bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd8:	8b 52 08             	mov    0x8(%edx),%edx
  801bdb:	89 50 08             	mov    %edx,0x8(%eax)
  801bde:	eb 0b                	jmp    801beb <malloc+0x49a>
  801be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be3:	8b 40 08             	mov    0x8(%eax),%eax
  801be6:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801bff:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801c04:	48                   	dec    %eax
  801c05:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801c0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c0d:	8b 00                	mov    (%eax),%eax
  801c0f:	83 ec 08             	sub    $0x8,%esp
  801c12:	ff 75 08             	pushl  0x8(%ebp)
  801c15:	50                   	push   %eax
  801c16:	e8 da 18 00 00       	call   8034f5 <sys_allocate_user_mem>
  801c1b:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	68 40 e1 81 00       	push   $0x81e140
  801c26:	e8 d0 24 00 00       	call   8040fb <release_uspinlock>
  801c2b:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c31:	8b 00                	mov    (%eax),%eax
  801c33:	eb 18                	jmp    801c4d <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c38:	8b 40 08             	mov    0x8(%eax),%eax
  801c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c42:	0f 85 bd fc ff ff    	jne    801905 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c63:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801c66:	e8 b2 f9 ff ff       	call   80161d <uheap_init>
		acquire_uspinlock(&ulock);
  801c6b:	83 ec 0c             	sub    $0xc,%esp
  801c6e:	68 40 e1 81 00       	push   $0x81e140
  801c73:	e8 2b 24 00 00       	call   8040a3 <acquire_uspinlock>
  801c78:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801c7b:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801c80:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801c83:	73 23                	jae    801ca8 <free+0x59>
			free_block(virtual_address);
  801c85:	83 ec 0c             	sub    $0xc,%esp
  801c88:	ff 75 08             	pushl  0x8(%ebp)
  801c8b:	e8 89 1f 00 00       	call   803c19 <free_block>
  801c90:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801c93:	83 ec 0c             	sub    $0xc,%esp
  801c96:	68 40 e1 81 00       	push   $0x81e140
  801c9b:	e8 5b 24 00 00       	call   8040fb <release_uspinlock>
  801ca0:	83 c4 10             	add    $0x10,%esp
			return;
  801ca3:	e9 35 07 00 00       	jmp    8023dd <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801ca8:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801cad:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801cb0:	72 30                	jb     801ce2 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801cb2:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801cb7:	83 ec 04             	sub    $0x4,%esp
  801cba:	50                   	push   %eax
  801cbb:	ff 75 d8             	pushl  -0x28(%ebp)
  801cbe:	68 d1 4d 80 00       	push   $0x804dd1
  801cc3:	e8 70 ea ff ff       	call   800738 <cprintf>
  801cc8:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801ccb:	83 ec 04             	sub    $0x4,%esp
  801cce:	68 d9 4d 80 00       	push   $0x804dd9
  801cd3:	68 a7 00 00 00       	push   $0xa7
  801cd8:	68 0c 4d 80 00       	push   $0x804d0c
  801cdd:	e8 88 e7 ff ff       	call   80046a <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801ce2:	83 ec 0c             	sub    $0xc,%esp
  801ce5:	6a 10                	push   $0x10
  801ce7:	e8 91 1a 00 00       	call   80377d <alloc_block>
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801cf2:	83 ec 0c             	sub    $0xc,%esp
  801cf5:	6a 10                	push   $0x10
  801cf7:	e8 81 1a 00 00       	call   80377d <alloc_block>
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801d02:	a1 30 e1 81 00       	mov    0x81e130,%eax
  801d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801d0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d11:	eb 1c                	jmp    801d2f <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d16:	8b 00                	mov    (%eax),%eax
  801d18:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801d1b:	75 09                	jne    801d26 <free+0xd7>
				foundVA = 1;
  801d1d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801d24:	eb 0f                	jmp    801d35 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d29:	8b 40 08             	mov    0x8(%eax),%eax
  801d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d33:	75 de                	jne    801d13 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801d35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d39:	75 17                	jne    801d52 <free+0x103>
				panic("INVALID ADDRESS!");
  801d3b:	83 ec 04             	sub    $0x4,%esp
  801d3e:	68 f6 4d 80 00       	push   $0x804df6
  801d43:	68 be 00 00 00       	push   $0xbe
  801d48:	68 0c 4d 80 00       	push   $0x804d0c
  801d4d:	e8 18 e7 ff ff       	call   80046a <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d55:	8b 10                	mov    (%eax),%edx
  801d57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d5a:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5f:	8b 50 04             	mov    0x4(%eax),%edx
  801d62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d65:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801d68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d6c:	75 17                	jne    801d85 <free+0x136>
  801d6e:	83 ec 04             	sub    $0x4,%esp
  801d71:	68 7b 4d 80 00       	push   $0x804d7b
  801d76:	68 c8 00 00 00       	push   $0xc8
  801d7b:	68 0c 4d 80 00       	push   $0x804d0c
  801d80:	e8 e5 e6 ff ff       	call   80046a <_panic>
  801d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d88:	8b 40 08             	mov    0x8(%eax),%eax
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	74 11                	je     801da0 <free+0x151>
  801d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d92:	8b 40 08             	mov    0x8(%eax),%eax
  801d95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d98:	8b 52 0c             	mov    0xc(%edx),%edx
  801d9b:	89 50 0c             	mov    %edx,0xc(%eax)
  801d9e:	eb 0b                	jmp    801dab <free+0x15c>
  801da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da3:	8b 40 0c             	mov    0xc(%eax),%eax
  801da6:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	8b 40 0c             	mov    0xc(%eax),%eax
  801db1:	85 c0                	test   %eax,%eax
  801db3:	74 11                	je     801dc6 <free+0x177>
  801db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db8:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbe:	8b 52 08             	mov    0x8(%edx),%edx
  801dc1:	89 50 08             	mov    %edx,0x8(%eax)
  801dc4:	eb 0b                	jmp    801dd1 <free+0x182>
  801dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc9:	8b 40 08             	mov    0x8(%eax),%eax
  801dcc:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dde:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801de5:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801dea:	48                   	dec    %eax
  801deb:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df3:	8b 50 04             	mov    0x4(%eax),%edx
  801df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df9:	8b 00                	mov    (%eax),%eax
  801dfb:	83 ec 08             	sub    $0x8,%esp
  801dfe:	52                   	push   %edx
  801dff:	50                   	push   %eax
  801e00:	e8 d4 16 00 00       	call   8034d9 <sys_free_user_mem>
  801e05:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801e08:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	75 7a                	jne    801e8b <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801e11:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e15:	75 17                	jne    801e2e <free+0x1df>
  801e17:	83 ec 04             	sub    $0x4,%esp
  801e1a:	68 08 4e 80 00       	push   $0x804e08
  801e1f:	68 d0 00 00 00       	push   $0xd0
  801e24:	68 0c 4d 80 00       	push   $0x804d0c
  801e29:	e8 3c e6 ff ff       	call   80046a <_panic>
  801e2e:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  801e34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e37:	89 50 08             	mov    %edx,0x8(%eax)
  801e3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e3d:	8b 40 08             	mov    0x8(%eax),%eax
  801e40:	85 c0                	test   %eax,%eax
  801e42:	74 0d                	je     801e51 <free+0x202>
  801e44:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801e49:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e4c:	89 50 0c             	mov    %edx,0xc(%eax)
  801e4f:	eb 08                	jmp    801e59 <free+0x20a>
  801e51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e54:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801e59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e5c:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801e61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e64:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e6b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801e70:	40                   	inc    %eax
  801e71:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  801e76:	83 ec 0c             	sub    $0xc,%esp
  801e79:	68 40 e1 81 00       	push   $0x81e140
  801e7e:	e8 78 22 00 00       	call   8040fb <release_uspinlock>
  801e83:	83 c4 10             	add    $0x10,%esp
			return;
  801e86:	e9 52 05 00 00       	jmp    8023dd <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801e8b:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801e90:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801e93:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801e9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801ea1:	e9 d2 00 00 00       	jmp    801f78 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801ea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea9:	8b 10                	mov    (%eax),%edx
  801eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eae:	8b 40 04             	mov    0x4(%eax),%eax
  801eb1:	01 c2                	add    %eax,%edx
  801eb3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801eb6:	8b 00                	mov    (%eax),%eax
  801eb8:	39 c2                	cmp    %eax,%edx
  801eba:	0f 85 af 00 00 00    	jne    801f6f <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801ec0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec3:	8b 10                	mov    (%eax),%edx
  801ec5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ec8:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801eca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecd:	8b 50 04             	mov    0x4(%eax),%edx
  801ed0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ed3:	8b 40 04             	mov    0x4(%eax),%eax
  801ed6:	01 c2                	add    %eax,%edx
  801ed8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801edb:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801ede:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ee2:	75 17                	jne    801efb <free+0x2ac>
  801ee4:	83 ec 04             	sub    $0x4,%esp
  801ee7:	68 7b 4d 80 00       	push   $0x804d7b
  801eec:	68 df 00 00 00       	push   $0xdf
  801ef1:	68 0c 4d 80 00       	push   $0x804d0c
  801ef6:	e8 6f e5 ff ff       	call   80046a <_panic>
  801efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efe:	8b 40 08             	mov    0x8(%eax),%eax
  801f01:	85 c0                	test   %eax,%eax
  801f03:	74 11                	je     801f16 <free+0x2c7>
  801f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f08:	8b 40 08             	mov    0x8(%eax),%eax
  801f0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f0e:	8b 52 0c             	mov    0xc(%edx),%edx
  801f11:	89 50 0c             	mov    %edx,0xc(%eax)
  801f14:	eb 0b                	jmp    801f21 <free+0x2d2>
  801f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f19:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1c:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f24:	8b 40 0c             	mov    0xc(%eax),%eax
  801f27:	85 c0                	test   %eax,%eax
  801f29:	74 11                	je     801f3c <free+0x2ed>
  801f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f31:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f34:	8b 52 08             	mov    0x8(%edx),%edx
  801f37:	89 50 08             	mov    %edx,0x8(%eax)
  801f3a:	eb 0b                	jmp    801f47 <free+0x2f8>
  801f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3f:	8b 40 08             	mov    0x8(%eax),%eax
  801f42:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f54:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f5b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f60:	48                   	dec    %eax
  801f61:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  801f66:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801f6d:	eb 13                	jmp    801f82 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f72:	8b 40 08             	mov    0x8(%eax),%eax
  801f75:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801f78:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f7c:	0f 85 24 ff ff ff    	jne    801ea6 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801f82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f85:	8b 10                	mov    (%eax),%edx
  801f87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f8a:	8b 40 04             	mov    0x4(%eax),%eax
  801f8d:	01 c2                	add    %eax,%edx
  801f8f:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801f94:	39 c2                	cmp    %eax,%edx
  801f96:	75 44                	jne    801fdc <free+0x38d>

			if(mergeprev){
  801f98:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f9c:	74 1f                	je     801fbd <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801f9e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fa1:	8b 00                	mov    (%eax),%eax
  801fa3:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  801fa8:	83 ec 0c             	sub    $0xc,%esp
  801fab:	68 40 e1 81 00       	push   $0x81e140
  801fb0:	e8 46 21 00 00       	call   8040fb <release_uspinlock>
  801fb5:	83 c4 10             	add    $0x10,%esp
				return;
  801fb8:	e9 20 04 00 00       	jmp    8023dd <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fc0:	8b 00                	mov    (%eax),%eax
  801fc2:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  801fc7:	83 ec 0c             	sub    $0xc,%esp
  801fca:	68 40 e1 81 00       	push   $0x81e140
  801fcf:	e8 27 21 00 00       	call   8040fb <release_uspinlock>
  801fd4:	83 c4 10             	add    $0x10,%esp
				return;
  801fd7:	e9 01 04 00 00       	jmp    8023dd <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  801fdc:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801fe1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  801fe4:	e9 7d 01 00 00       	jmp    802166 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  801fe9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fec:	8b 10                	mov    (%eax),%edx
  801fee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ff1:	8b 40 04             	mov    0x4(%eax),%eax
  801ff4:	01 c2                	add    %eax,%edx
  801ff6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff9:	8b 00                	mov    (%eax),%eax
  801ffb:	39 c2                	cmp    %eax,%edx
  801ffd:	0f 85 5a 01 00 00    	jne    80215d <free+0x50e>
				if (mergeprev){
  802003:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802007:	0f 84 a1 00 00 00    	je     8020ae <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  80200d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802010:	8b 50 04             	mov    0x4(%eax),%edx
  802013:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802016:	8b 40 04             	mov    0x4(%eax),%eax
  802019:	01 c2                	add    %eax,%edx
  80201b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80201e:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802021:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802025:	75 17                	jne    80203e <free+0x3ef>
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	68 7b 4d 80 00       	push   $0x804d7b
  80202f:	68 0a 01 00 00       	push   $0x10a
  802034:	68 0c 4d 80 00       	push   $0x804d0c
  802039:	e8 2c e4 ff ff       	call   80046a <_panic>
  80203e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802041:	8b 40 08             	mov    0x8(%eax),%eax
  802044:	85 c0                	test   %eax,%eax
  802046:	74 11                	je     802059 <free+0x40a>
  802048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204b:	8b 40 08             	mov    0x8(%eax),%eax
  80204e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802051:	8b 52 0c             	mov    0xc(%edx),%edx
  802054:	89 50 0c             	mov    %edx,0xc(%eax)
  802057:	eb 0b                	jmp    802064 <free+0x415>
  802059:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205c:	8b 40 0c             	mov    0xc(%eax),%eax
  80205f:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802064:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802067:	8b 40 0c             	mov    0xc(%eax),%eax
  80206a:	85 c0                	test   %eax,%eax
  80206c:	74 11                	je     80207f <free+0x430>
  80206e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802071:	8b 40 0c             	mov    0xc(%eax),%eax
  802074:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802077:	8b 52 08             	mov    0x8(%edx),%edx
  80207a:	89 50 08             	mov    %edx,0x8(%eax)
  80207d:	eb 0b                	jmp    80208a <free+0x43b>
  80207f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802082:	8b 40 08             	mov    0x8(%eax),%eax
  802085:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80208a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802097:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80209e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8020a3:	48                   	dec    %eax
  8020a4:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  8020a9:	e9 c2 00 00 00       	jmp    802170 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8020ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020b1:	8b 10                	mov    (%eax),%edx
  8020b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020b6:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  8020b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020bb:	8b 50 04             	mov    0x4(%eax),%edx
  8020be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c1:	8b 40 04             	mov    0x4(%eax),%eax
  8020c4:	01 c2                	add    %eax,%edx
  8020c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020c9:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8020cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020d0:	75 17                	jne    8020e9 <free+0x49a>
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	68 7b 4d 80 00       	push   $0x804d7b
  8020da:	68 10 01 00 00       	push   $0x110
  8020df:	68 0c 4d 80 00       	push   $0x804d0c
  8020e4:	e8 81 e3 ff ff       	call   80046a <_panic>
  8020e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ec:	8b 40 08             	mov    0x8(%eax),%eax
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	74 11                	je     802104 <free+0x4b5>
  8020f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f6:	8b 40 08             	mov    0x8(%eax),%eax
  8020f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020fc:	8b 52 0c             	mov    0xc(%edx),%edx
  8020ff:	89 50 0c             	mov    %edx,0xc(%eax)
  802102:	eb 0b                	jmp    80210f <free+0x4c0>
  802104:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802107:	8b 40 0c             	mov    0xc(%eax),%eax
  80210a:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80210f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802112:	8b 40 0c             	mov    0xc(%eax),%eax
  802115:	85 c0                	test   %eax,%eax
  802117:	74 11                	je     80212a <free+0x4db>
  802119:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211c:	8b 40 0c             	mov    0xc(%eax),%eax
  80211f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802122:	8b 52 08             	mov    0x8(%edx),%edx
  802125:	89 50 08             	mov    %edx,0x8(%eax)
  802128:	eb 0b                	jmp    802135 <free+0x4e6>
  80212a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212d:	8b 40 08             	mov    0x8(%eax),%eax
  802130:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802138:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80213f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802142:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802149:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80214e:	48                   	dec    %eax
  80214f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  802154:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  80215b:	eb 13                	jmp    802170 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  80215d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802160:	8b 40 08             	mov    0x8(%eax),%eax
  802163:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  802166:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80216a:	0f 85 79 fe ff ff    	jne    801fe9 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  802170:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802175:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  802178:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80217c:	0f 85 ad 00 00 00    	jne    80222f <free+0x5e0>
  802182:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802186:	0f 84 c3 01 00 00    	je     80234f <free+0x700>
				while(currentfree != NULL){
  80218c:	e9 9e 00 00 00       	jmp    80222f <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  802191:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802194:	8b 50 04             	mov    0x4(%eax),%edx
  802197:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80219a:	8b 40 04             	mov    0x4(%eax),%eax
  80219d:	39 c2                	cmp    %eax,%edx
  80219f:	0f 83 81 00 00 00    	jae    802226 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8021a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021a9:	74 06                	je     8021b1 <free+0x562>
  8021ab:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021af:	75 17                	jne    8021c8 <free+0x579>
  8021b1:	83 ec 04             	sub    $0x4,%esp
  8021b4:	68 9c 4d 80 00       	push   $0x804d9c
  8021b9:	68 23 01 00 00       	push   $0x123
  8021be:	68 0c 4d 80 00       	push   $0x804d0c
  8021c3:	e8 a2 e2 ff ff       	call   80046a <_panic>
  8021c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8021ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021d1:	89 50 0c             	mov    %edx,0xc(%eax)
  8021d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021da:	89 50 08             	mov    %edx,0x8(%eax)
  8021dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	74 0e                	je     8021f5 <free+0x5a6>
  8021e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8021ed:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8021f0:	89 50 08             	mov    %edx,0x8(%eax)
  8021f3:	eb 08                	jmp    8021fd <free+0x5ae>
  8021f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021f8:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8021fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802200:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802203:	89 50 0c             	mov    %edx,0xc(%eax)
  802206:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80220b:	40                   	inc    %eax
  80220c:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  802211:	83 ec 0c             	sub    $0xc,%esp
  802214:	68 40 e1 81 00       	push   $0x81e140
  802219:	e8 dd 1e 00 00       	call   8040fb <release_uspinlock>
  80221e:	83 c4 10             	add    $0x10,%esp
							return;
  802221:	e9 b7 01 00 00       	jmp    8023dd <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802226:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802229:	8b 40 08             	mov    0x8(%eax),%eax
  80222c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  80222f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802233:	0f 85 58 ff ff ff    	jne    802191 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802239:	83 ec 0c             	sub    $0xc,%esp
  80223c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80223f:	e8 d5 19 00 00       	call   803c19 <free_block>
  802244:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  802247:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80224b:	75 17                	jne    802264 <free+0x615>
  80224d:	83 ec 04             	sub    $0x4,%esp
  802250:	68 58 4d 80 00       	push   $0x804d58
  802255:	68 2a 01 00 00       	push   $0x12a
  80225a:	68 0c 4d 80 00       	push   $0x804d0c
  80225f:	e8 06 e2 ff ff       	call   80046a <_panic>
  802264:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  80226a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80226d:	89 50 0c             	mov    %edx,0xc(%eax)
  802270:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802273:	8b 40 0c             	mov    0xc(%eax),%eax
  802276:	85 c0                	test   %eax,%eax
  802278:	74 0d                	je     802287 <free+0x638>
  80227a:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80227f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802282:	89 50 08             	mov    %edx,0x8(%eax)
  802285:	eb 08                	jmp    80228f <free+0x640>
  802287:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80228a:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80228f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802292:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802297:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80229a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022a1:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8022a6:	40                   	inc    %eax
  8022a7:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  8022ac:	e9 1b 01 00 00       	jmp    8023cc <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8022b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022b4:	8b 50 04             	mov    0x4(%eax),%edx
  8022b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ba:	8b 40 04             	mov    0x4(%eax),%eax
  8022bd:	39 c2                	cmp    %eax,%edx
  8022bf:	0f 83 81 00 00 00    	jae    802346 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8022c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022c9:	74 06                	je     8022d1 <free+0x682>
  8022cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8022cf:	75 17                	jne    8022e8 <free+0x699>
  8022d1:	83 ec 04             	sub    $0x4,%esp
  8022d4:	68 9c 4d 80 00       	push   $0x804d9c
  8022d9:	68 30 01 00 00       	push   $0x130
  8022de:	68 0c 4d 80 00       	push   $0x804d0c
  8022e3:	e8 82 e1 ff ff       	call   80046a <_panic>
  8022e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8022ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022f1:	89 50 0c             	mov    %edx,0xc(%eax)
  8022f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022fa:	89 50 08             	mov    %edx,0x8(%eax)
  8022fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802300:	8b 40 0c             	mov    0xc(%eax),%eax
  802303:	85 c0                	test   %eax,%eax
  802305:	74 0e                	je     802315 <free+0x6c6>
  802307:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80230a:	8b 40 0c             	mov    0xc(%eax),%eax
  80230d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802310:	89 50 08             	mov    %edx,0x8(%eax)
  802313:	eb 08                	jmp    80231d <free+0x6ce>
  802315:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802318:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80231d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802320:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802323:	89 50 0c             	mov    %edx,0xc(%eax)
  802326:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80232b:	40                   	inc    %eax
  80232c:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  802331:	83 ec 0c             	sub    $0xc,%esp
  802334:	68 40 e1 81 00       	push   $0x81e140
  802339:	e8 bd 1d 00 00       	call   8040fb <release_uspinlock>
  80233e:	83 c4 10             	add    $0x10,%esp
							return;
  802341:	e9 97 00 00 00       	jmp    8023dd <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802349:	8b 40 08             	mov    0x8(%eax),%eax
  80234c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  80234f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802353:	0f 85 58 ff ff ff    	jne    8022b1 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  802359:	83 ec 0c             	sub    $0xc,%esp
  80235c:	ff 75 d0             	pushl  -0x30(%ebp)
  80235f:	e8 b5 18 00 00       	call   803c19 <free_block>
  802364:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  802367:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80236b:	75 17                	jne    802384 <free+0x735>
  80236d:	83 ec 04             	sub    $0x4,%esp
  802370:	68 58 4d 80 00       	push   $0x804d58
  802375:	68 37 01 00 00       	push   $0x137
  80237a:	68 0c 4d 80 00       	push   $0x804d0c
  80237f:	e8 e6 e0 ff ff       	call   80046a <_panic>
  802384:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  80238a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80238d:	89 50 0c             	mov    %edx,0xc(%eax)
  802390:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802393:	8b 40 0c             	mov    0xc(%eax),%eax
  802396:	85 c0                	test   %eax,%eax
  802398:	74 0d                	je     8023a7 <free+0x758>
  80239a:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80239f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023a2:	89 50 08             	mov    %edx,0x8(%eax)
  8023a5:	eb 08                	jmp    8023af <free+0x760>
  8023a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023aa:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8023af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b2:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8023b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023c1:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8023c6:	40                   	inc    %eax
  8023c7:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  8023cc:	83 ec 0c             	sub    $0xc,%esp
  8023cf:	68 40 e1 81 00       	push   $0x81e140
  8023d4:	e8 22 1d 00 00       	call   8040fb <release_uspinlock>
  8023d9:	83 c4 10             	add    $0x10,%esp
		return;
  8023dc:	90                   	nop
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	83 ec 48             	sub    $0x48,%esp
  8023e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e8:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023eb:	e8 2d f2 ff ff       	call   80161d <uheap_init>
	if (size == 0) return NULL;
  8023f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023f4:	75 0a                	jne    802400 <smalloc+0x21>
  8023f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fb:	e9 84 05 00 00       	jmp    802984 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802400:	83 ec 0c             	sub    $0xc,%esp
  802403:	68 40 e1 81 00       	push   $0x81e140
  802408:	e8 96 1c 00 00       	call   8040a3 <acquire_uspinlock>
  80240d:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802410:	83 ec 0c             	sub    $0xc,%esp
  802413:	6a 10                	push   $0x10
  802415:	e8 63 13 00 00       	call   80377d <alloc_block>
  80241a:	83 c4 10             	add    $0x10,%esp
  80241d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802420:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802424:	75 0a                	jne    802430 <smalloc+0x51>
				return NULL;
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
  80242b:	e9 54 05 00 00       	jmp    802984 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802430:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802437:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80243d:	01 d0                	add    %edx,%eax
  80243f:	48                   	dec    %eax
  802440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802446:	ba 00 00 00 00       	mov    $0x0,%edx
  80244b:	f7 75 e8             	divl   -0x18(%ebp)
  80244e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802451:	29 d0                	sub    %edx,%eax
  802453:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802456:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80245b:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80245e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802463:	85 c0                	test   %eax,%eax
  802465:	74 0f                	je     802476 <smalloc+0x97>
  802467:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80246a:	8b 40 04             	mov    0x4(%eax),%eax
  80246d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802470:	0f 83 25 01 00 00    	jae    80259b <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802476:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80247b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80247e:	89 c2                	mov    %eax,%edx
  802480:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802485:	39 c2                	cmp    %eax,%edx
  802487:	0f 82 f4 00 00 00    	jb     802581 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  80248d:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802492:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  802495:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80249b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249e:	01 d0                	add    %edx,%eax
  8024a0:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  8024a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024ab:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8024ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b3:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8024b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024ba:	75 17                	jne    8024d3 <smalloc+0xf4>
  8024bc:	83 ec 04             	sub    $0x4,%esp
  8024bf:	68 58 4d 80 00       	push   $0x804d58
  8024c4:	68 57 01 00 00       	push   $0x157
  8024c9:	68 0c 4d 80 00       	push   $0x804d0c
  8024ce:	e8 97 df ff ff       	call   80046a <_panic>
  8024d3:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8024d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024dc:	89 50 0c             	mov    %edx,0xc(%eax)
  8024df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	74 0d                	je     8024f6 <smalloc+0x117>
  8024e9:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8024ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024f1:	89 50 08             	mov    %edx,0x8(%eax)
  8024f4:	eb 08                	jmp    8024fe <smalloc+0x11f>
  8024f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f9:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8024fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802501:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802509:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802510:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802515:	40                   	inc    %eax
  802516:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80251b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251e:	8b 00                	mov    (%eax),%eax
  802520:	89 c2                	mov    %eax,%edx
  802522:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802526:	52                   	push   %edx
  802527:	50                   	push   %eax
  802528:	ff 75 0c             	pushl  0xc(%ebp)
  80252b:	ff 75 08             	pushl  0x8(%ebp)
  80252e:	e8 48 0c 00 00       	call   80317b <sys_create_shared_object>
  802533:	83 c4 10             	add    $0x10,%esp
  802536:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802539:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80253d:	79 28                	jns    802567 <smalloc+0x188>
							free_block(allocblock);
  80253f:	83 ec 0c             	sub    $0xc,%esp
  802542:	ff 75 ec             	pushl  -0x14(%ebp)
  802545:	e8 cf 16 00 00       	call   803c19 <free_block>
  80254a:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  80254d:	83 ec 0c             	sub    $0xc,%esp
  802550:	68 40 e1 81 00       	push   $0x81e140
  802555:	e8 a1 1b 00 00       	call   8040fb <release_uspinlock>
  80255a:	83 c4 10             	add    $0x10,%esp
							return NULL;
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
  802562:	e9 1d 04 00 00       	jmp    802984 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802567:	83 ec 0c             	sub    $0xc,%esp
  80256a:	68 40 e1 81 00       	push   $0x81e140
  80256f:	e8 87 1b 00 00       	call   8040fb <release_uspinlock>
  802574:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	e9 03 04 00 00       	jmp    802984 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  802581:	83 ec 0c             	sub    $0xc,%esp
  802584:	68 40 e1 81 00       	push   $0x81e140
  802589:	e8 6d 1b 00 00       	call   8040fb <release_uspinlock>
  80258e:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802591:	b8 00 00 00 00       	mov    $0x0,%eax
  802596:	e9 e9 03 00 00       	jmp    802984 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80259b:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8025a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8025a3:	e9 af 03 00 00       	jmp    802957 <smalloc+0x578>
				if(size<currentfreeelement->size){
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 40 04             	mov    0x4(%eax),%eax
  8025ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025b1:	0f 86 28 02 00 00    	jbe    8027df <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  8025b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ba:	8b 10                	mov    (%eax),%edx
  8025bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bf:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  8025c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c7:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8025ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025ce:	75 17                	jne    8025e7 <smalloc+0x208>
  8025d0:	83 ec 04             	sub    $0x4,%esp
  8025d3:	68 58 4d 80 00       	push   $0x804d58
  8025d8:	68 6f 01 00 00       	push   $0x16f
  8025dd:	68 0c 4d 80 00       	push   $0x804d0c
  8025e2:	e8 83 de ff ff       	call   80046a <_panic>
  8025e7:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8025ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f0:	89 50 0c             	mov    %edx,0xc(%eax)
  8025f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	74 0d                	je     80260a <smalloc+0x22b>
  8025fd:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802602:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802605:	89 50 08             	mov    %edx,0x8(%eax)
  802608:	eb 08                	jmp    802612 <smalloc+0x233>
  80260a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260d:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802615:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80261a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802624:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802629:	40                   	inc    %eax
  80262a:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  80262f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802632:	8b 10                	mov    (%eax),%edx
  802634:	8b 45 0c             	mov    0xc(%ebp),%eax
  802637:	01 c2                	add    %eax,%edx
  802639:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80263c:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  80263e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802641:	8b 40 04             	mov    0x4(%eax),%eax
  802644:	2b 45 0c             	sub    0xc(%ebp),%eax
  802647:	89 c2                	mov    %eax,%edx
  802649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80264c:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  80264f:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802654:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802657:	e9 13 01 00 00       	jmp    80276f <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  80265c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265f:	8b 50 04             	mov    0x4(%eax),%edx
  802662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802665:	8b 40 04             	mov    0x4(%eax),%eax
  802668:	39 c2                	cmp    %eax,%edx
  80266a:	0f 83 f6 00 00 00    	jae    802766 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802670:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802674:	75 17                	jne    80268d <smalloc+0x2ae>
  802676:	83 ec 04             	sub    $0x4,%esp
  802679:	68 7b 4d 80 00       	push   $0x804d7b
  80267e:	68 77 01 00 00       	push   $0x177
  802683:	68 0c 4d 80 00       	push   $0x804d0c
  802688:	e8 dd dd ff ff       	call   80046a <_panic>
  80268d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802690:	8b 40 08             	mov    0x8(%eax),%eax
  802693:	85 c0                	test   %eax,%eax
  802695:	74 11                	je     8026a8 <smalloc+0x2c9>
  802697:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269a:	8b 40 08             	mov    0x8(%eax),%eax
  80269d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026a0:	8b 52 0c             	mov    0xc(%edx),%edx
  8026a3:	89 50 0c             	mov    %edx,0xc(%eax)
  8026a6:	eb 0b                	jmp    8026b3 <smalloc+0x2d4>
  8026a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ae:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8026b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 11                	je     8026ce <smalloc+0x2ef>
  8026bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026c6:	8b 52 08             	mov    0x8(%edx),%edx
  8026c9:	89 50 08             	mov    %edx,0x8(%eax)
  8026cc:	eb 0b                	jmp    8026d9 <smalloc+0x2fa>
  8026ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d1:	8b 40 08             	mov    0x8(%eax),%eax
  8026d4:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8026d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8026e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8026ed:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8026f2:	48                   	dec    %eax
  8026f3:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8026f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026fc:	74 06                	je     802704 <smalloc+0x325>
  8026fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802702:	75 17                	jne    80271b <smalloc+0x33c>
  802704:	83 ec 04             	sub    $0x4,%esp
  802707:	68 9c 4d 80 00       	push   $0x804d9c
  80270c:	68 78 01 00 00       	push   $0x178
  802711:	68 0c 4d 80 00       	push   $0x804d0c
  802716:	e8 4f dd ff ff       	call   80046a <_panic>
  80271b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271e:	8b 50 0c             	mov    0xc(%eax),%edx
  802721:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802724:	89 50 0c             	mov    %edx,0xc(%eax)
  802727:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80272d:	89 50 08             	mov    %edx,0x8(%eax)
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	8b 40 0c             	mov    0xc(%eax),%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	74 0e                	je     802748 <smalloc+0x369>
  80273a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273d:	8b 40 0c             	mov    0xc(%eax),%eax
  802740:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802743:	89 50 08             	mov    %edx,0x8(%eax)
  802746:	eb 08                	jmp    802750 <smalloc+0x371>
  802748:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274b:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802753:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802756:	89 50 0c             	mov    %edx,0xc(%eax)
  802759:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80275e:	40                   	inc    %eax
  80275f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  802764:	eb 13                	jmp    802779 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802769:	8b 40 08             	mov    0x8(%eax),%eax
  80276c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  80276f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802773:	0f 85 e3 fe ff ff    	jne    80265c <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277c:	8b 00                	mov    (%eax),%eax
  80277e:	89 c2                	mov    %eax,%edx
  802780:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802784:	52                   	push   %edx
  802785:	50                   	push   %eax
  802786:	ff 75 0c             	pushl  0xc(%ebp)
  802789:	ff 75 08             	pushl  0x8(%ebp)
  80278c:	e8 ea 09 00 00       	call   80317b <sys_create_shared_object>
  802791:	83 c4 10             	add    $0x10,%esp
  802794:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802797:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80279b:	79 28                	jns    8027c5 <smalloc+0x3e6>
	                	free_block(allocblock);
  80279d:	83 ec 0c             	sub    $0xc,%esp
  8027a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8027a3:	e8 71 14 00 00       	call   803c19 <free_block>
  8027a8:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  8027ab:	83 ec 0c             	sub    $0xc,%esp
  8027ae:	68 40 e1 81 00       	push   $0x81e140
  8027b3:	e8 43 19 00 00       	call   8040fb <release_uspinlock>
  8027b8:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  8027bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c0:	e9 bf 01 00 00       	jmp    802984 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  8027c5:	83 ec 0c             	sub    $0xc,%esp
  8027c8:	68 40 e1 81 00       	push   $0x81e140
  8027cd:	e8 29 19 00 00       	call   8040fb <release_uspinlock>
  8027d2:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  8027d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d8:	8b 00                	mov    (%eax),%eax
  8027da:	e9 a5 01 00 00       	jmp    802984 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 40 04             	mov    0x4(%eax),%eax
  8027e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027e8:	0f 85 60 01 00 00    	jne    80294e <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 10                	mov    (%eax),%edx
  8027f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f6:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8027f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027fe:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802801:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802805:	75 17                	jne    80281e <smalloc+0x43f>
  802807:	83 ec 04             	sub    $0x4,%esp
  80280a:	68 58 4d 80 00       	push   $0x804d58
  80280f:	68 8c 01 00 00       	push   $0x18c
  802814:	68 0c 4d 80 00       	push   $0x804d0c
  802819:	e8 4c dc ff ff       	call   80046a <_panic>
  80281e:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802824:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802827:	89 50 0c             	mov    %edx,0xc(%eax)
  80282a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282d:	8b 40 0c             	mov    0xc(%eax),%eax
  802830:	85 c0                	test   %eax,%eax
  802832:	74 0d                	je     802841 <smalloc+0x462>
  802834:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802839:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80283c:	89 50 08             	mov    %edx,0x8(%eax)
  80283f:	eb 08                	jmp    802849 <smalloc+0x46a>
  802841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802844:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802849:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284c:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802851:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802854:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80285b:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802860:	40                   	inc    %eax
  802861:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286a:	75 17                	jne    802883 <smalloc+0x4a4>
  80286c:	83 ec 04             	sub    $0x4,%esp
  80286f:	68 7b 4d 80 00       	push   $0x804d7b
  802874:	68 8d 01 00 00       	push   $0x18d
  802879:	68 0c 4d 80 00       	push   $0x804d0c
  80287e:	e8 e7 db ff ff       	call   80046a <_panic>
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	8b 40 08             	mov    0x8(%eax),%eax
  802889:	85 c0                	test   %eax,%eax
  80288b:	74 11                	je     80289e <smalloc+0x4bf>
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 40 08             	mov    0x8(%eax),%eax
  802893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802896:	8b 52 0c             	mov    0xc(%edx),%edx
  802899:	89 50 0c             	mov    %edx,0xc(%eax)
  80289c:	eb 0b                	jmp    8028a9 <smalloc+0x4ca>
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a4:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 11                	je     8028c4 <smalloc+0x4e5>
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bc:	8b 52 08             	mov    0x8(%edx),%edx
  8028bf:	89 50 08             	mov    %edx,0x8(%eax)
  8028c2:	eb 0b                	jmp    8028cf <smalloc+0x4f0>
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 40 08             	mov    0x8(%eax),%eax
  8028ca:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028e3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8028e8:	48                   	dec    %eax
  8028e9:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8028ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f1:	8b 00                	mov    (%eax),%eax
  8028f3:	89 c2                	mov    %eax,%edx
  8028f5:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8028f9:	52                   	push   %edx
  8028fa:	50                   	push   %eax
  8028fb:	ff 75 0c             	pushl  0xc(%ebp)
  8028fe:	ff 75 08             	pushl  0x8(%ebp)
  802901:	e8 75 08 00 00       	call   80317b <sys_create_shared_object>
  802906:	83 c4 10             	add    $0x10,%esp
  802909:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  80290c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802910:	79 25                	jns    802937 <smalloc+0x558>
						free_block(allocblock);
  802912:	83 ec 0c             	sub    $0xc,%esp
  802915:	ff 75 ec             	pushl  -0x14(%ebp)
  802918:	e8 fc 12 00 00       	call   803c19 <free_block>
  80291d:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802920:	83 ec 0c             	sub    $0xc,%esp
  802923:	68 40 e1 81 00       	push   $0x81e140
  802928:	e8 ce 17 00 00       	call   8040fb <release_uspinlock>
  80292d:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802930:	b8 00 00 00 00       	mov    $0x0,%eax
  802935:	eb 4d                	jmp    802984 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802937:	83 ec 0c             	sub    $0xc,%esp
  80293a:	68 40 e1 81 00       	push   $0x81e140
  80293f:	e8 b7 17 00 00       	call   8040fb <release_uspinlock>
  802944:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	eb 36                	jmp    802984 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 40 08             	mov    0x8(%eax),%eax
  802954:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802957:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295b:	0f 85 47 fc ff ff    	jne    8025a8 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802961:	83 ec 0c             	sub    $0xc,%esp
  802964:	ff 75 ec             	pushl  -0x14(%ebp)
  802967:	e8 ad 12 00 00       	call   803c19 <free_block>
  80296c:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  80296f:	83 ec 0c             	sub    $0xc,%esp
  802972:	68 40 e1 81 00       	push   $0x81e140
  802977:	e8 7f 17 00 00       	call   8040fb <release_uspinlock>
  80297c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80297f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802984:	c9                   	leave  
  802985:	c3                   	ret    

00802986 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
  802989:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  80298c:	e8 8c ec ff ff       	call   80161d <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802991:	83 ec 0c             	sub    $0xc,%esp
  802994:	68 40 e1 81 00       	push   $0x81e140
  802999:	e8 05 17 00 00       	call   8040a3 <acquire_uspinlock>
  80299e:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  8029a1:	83 ec 08             	sub    $0x8,%esp
  8029a4:	ff 75 0c             	pushl  0xc(%ebp)
  8029a7:	ff 75 08             	pushl  0x8(%ebp)
  8029aa:	e8 f6 07 00 00       	call   8031a5 <sys_size_of_shared_object>
  8029af:	83 c4 10             	add    $0x10,%esp
  8029b2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  8029b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029b9:	79 1a                	jns    8029d5 <sget+0x4f>
			release_uspinlock(&ulock);
  8029bb:	83 ec 0c             	sub    $0xc,%esp
  8029be:	68 40 e1 81 00       	push   $0x81e140
  8029c3:	e8 33 17 00 00       	call   8040fb <release_uspinlock>
  8029c8:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8029cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d0:	e9 6e 05 00 00       	jmp    802f43 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  8029d5:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8029dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e2:	01 d0                	add    %edx,%eax
  8029e4:	48                   	dec    %eax
  8029e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8029e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8029f0:	f7 75 e8             	divl   -0x18(%ebp)
  8029f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f6:	29 d0                	sub    %edx,%eax
  8029f8:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8029fb:	83 ec 0c             	sub    $0xc,%esp
  8029fe:	6a 10                	push   $0x10
  802a00:	e8 78 0d 00 00       	call   80377d <alloc_block>
  802a05:	83 c4 10             	add    $0x10,%esp
  802a08:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802a0b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a0f:	75 0a                	jne    802a1b <sget+0x95>
			return NULL;
  802a11:	b8 00 00 00 00       	mov    $0x0,%eax
  802a16:	e9 28 05 00 00       	jmp    802f43 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802a1b:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802a20:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802a23:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	74 11                	je     802a3d <sget+0xb7>
  802a2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a2f:	8b 50 04             	mov    0x4(%eax),%edx
  802a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a35:	39 c2                	cmp    %eax,%edx
  802a37:	0f 83 21 01 00 00    	jae    802b5e <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a40:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802a45:	29 c2                	sub    %eax,%edx
  802a47:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802a4c:	39 c2                	cmp    %eax,%edx
  802a4e:	0f 82 f0 00 00 00    	jb     802b44 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802a54:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802a59:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802a5c:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a65:	01 d0                	add    %edx,%eax
  802a67:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802a6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a6f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802a72:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802a74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a7a:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802a7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a81:	75 17                	jne    802a9a <sget+0x114>
  802a83:	83 ec 04             	sub    $0x4,%esp
  802a86:	68 58 4d 80 00       	push   $0x804d58
  802a8b:	68 c8 01 00 00       	push   $0x1c8
  802a90:	68 0c 4d 80 00       	push   $0x804d0c
  802a95:	e8 d0 d9 ff ff       	call   80046a <_panic>
  802a9a:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa3:	89 50 0c             	mov    %edx,0xc(%eax)
  802aa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa9:	8b 40 0c             	mov    0xc(%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 0d                	je     802abd <sget+0x137>
  802ab0:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802ab5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ab8:	89 50 08             	mov    %edx,0x8(%eax)
  802abb:	eb 08                	jmp    802ac5 <sget+0x13f>
  802abd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac0:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802ac5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac8:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802acd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ad7:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802adc:	40                   	inc    %eax
  802add:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	83 ec 04             	sub    $0x4,%esp
  802aea:	50                   	push   %eax
  802aeb:	ff 75 0c             	pushl  0xc(%ebp)
  802aee:	ff 75 08             	pushl  0x8(%ebp)
  802af1:	e8 cc 06 00 00       	call   8031c2 <sys_get_shared_object>
  802af6:	83 c4 10             	add    $0x10,%esp
  802af9:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802afc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b00:	79 28                	jns    802b2a <sget+0x1a4>
							free_block(allocblock);
  802b02:	83 ec 0c             	sub    $0xc,%esp
  802b05:	ff 75 e0             	pushl  -0x20(%ebp)
  802b08:	e8 0c 11 00 00       	call   803c19 <free_block>
  802b0d:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802b10:	83 ec 0c             	sub    $0xc,%esp
  802b13:	68 40 e1 81 00       	push   $0x81e140
  802b18:	e8 de 15 00 00       	call   8040fb <release_uspinlock>
  802b1d:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802b20:	b8 00 00 00 00       	mov    $0x0,%eax
  802b25:	e9 19 04 00 00       	jmp    802f43 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802b2a:	83 ec 0c             	sub    $0xc,%esp
  802b2d:	68 40 e1 81 00       	push   $0x81e140
  802b32:	e8 c4 15 00 00       	call   8040fb <release_uspinlock>
  802b37:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802b3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	e9 ff 03 00 00       	jmp    802f43 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802b44:	83 ec 0c             	sub    $0xc,%esp
  802b47:	68 40 e1 81 00       	push   $0x81e140
  802b4c:	e8 aa 15 00 00       	call   8040fb <release_uspinlock>
  802b51:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802b54:	b8 00 00 00 00       	mov    $0x0,%eax
  802b59:	e9 e5 03 00 00       	jmp    802f43 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802b5e:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802b66:	e9 ab 03 00 00       	jmp    802f16 <sget+0x590>
				if(size<currentfreeelement->size){
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 50 04             	mov    0x4(%eax),%edx
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	39 c2                	cmp    %eax,%edx
  802b76:	0f 86 24 02 00 00    	jbe    802da0 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802b7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b7f:	8b 10                	mov    (%eax),%edx
  802b81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b84:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802b86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8c:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802b8f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b93:	75 17                	jne    802bac <sget+0x226>
  802b95:	83 ec 04             	sub    $0x4,%esp
  802b98:	68 58 4d 80 00       	push   $0x804d58
  802b9d:	68 e0 01 00 00       	push   $0x1e0
  802ba2:	68 0c 4d 80 00       	push   $0x804d0c
  802ba7:	e8 be d8 ff ff       	call   80046a <_panic>
  802bac:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802bb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb5:	89 50 0c             	mov    %edx,0xc(%eax)
  802bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbe:	85 c0                	test   %eax,%eax
  802bc0:	74 0d                	je     802bcf <sget+0x249>
  802bc2:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802bc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bca:	89 50 08             	mov    %edx,0x8(%eax)
  802bcd:	eb 08                	jmp    802bd7 <sget+0x251>
  802bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd2:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802bd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bda:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802bdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802be9:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802bee:	40                   	inc    %eax
  802bef:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  802bf4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bf7:	8b 10                	mov    (%eax),%edx
  802bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfc:	01 c2                	add    %eax,%edx
  802bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c01:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802c03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c06:	8b 50 04             	mov    0x4(%eax),%edx
  802c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0c:	29 c2                	sub    %eax,%edx
  802c0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c11:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802c14:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802c1c:	e9 13 01 00 00       	jmp    802d34 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802c21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c24:	8b 50 04             	mov    0x4(%eax),%edx
  802c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2a:	8b 40 04             	mov    0x4(%eax),%eax
  802c2d:	39 c2                	cmp    %eax,%edx
  802c2f:	0f 83 f6 00 00 00    	jae    802d2b <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802c35:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c39:	75 17                	jne    802c52 <sget+0x2cc>
  802c3b:	83 ec 04             	sub    $0x4,%esp
  802c3e:	68 7b 4d 80 00       	push   $0x804d7b
  802c43:	68 e8 01 00 00       	push   $0x1e8
  802c48:	68 0c 4d 80 00       	push   $0x804d0c
  802c4d:	e8 18 d8 ff ff       	call   80046a <_panic>
  802c52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c55:	8b 40 08             	mov    0x8(%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 11                	je     802c6d <sget+0x2e7>
  802c5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c5f:	8b 40 08             	mov    0x8(%eax),%eax
  802c62:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c65:	8b 52 0c             	mov    0xc(%edx),%edx
  802c68:	89 50 0c             	mov    %edx,0xc(%eax)
  802c6b:	eb 0b                	jmp    802c78 <sget+0x2f2>
  802c6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c70:	8b 40 0c             	mov    0xc(%eax),%eax
  802c73:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802c78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	74 11                	je     802c93 <sget+0x30d>
  802c82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c85:	8b 40 0c             	mov    0xc(%eax),%eax
  802c88:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c8b:	8b 52 08             	mov    0x8(%edx),%edx
  802c8e:	89 50 08             	mov    %edx,0x8(%eax)
  802c91:	eb 0b                	jmp    802c9e <sget+0x318>
  802c93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c96:	8b 40 08             	mov    0x8(%eax),%eax
  802c99:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802c9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ca8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802cb2:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802cb7:	48                   	dec    %eax
  802cb8:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802cbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc1:	74 06                	je     802cc9 <sget+0x343>
  802cc3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802cc7:	75 17                	jne    802ce0 <sget+0x35a>
  802cc9:	83 ec 04             	sub    $0x4,%esp
  802ccc:	68 9c 4d 80 00       	push   $0x804d9c
  802cd1:	68 e9 01 00 00       	push   $0x1e9
  802cd6:	68 0c 4d 80 00       	push   $0x804d0c
  802cdb:	e8 8a d7 ff ff       	call   80046a <_panic>
  802ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ce9:	89 50 0c             	mov    %edx,0xc(%eax)
  802cec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf2:	89 50 08             	mov    %edx,0x8(%eax)
  802cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfb:	85 c0                	test   %eax,%eax
  802cfd:	74 0e                	je     802d0d <sget+0x387>
  802cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d02:	8b 40 0c             	mov    0xc(%eax),%eax
  802d05:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d08:	89 50 08             	mov    %edx,0x8(%eax)
  802d0b:	eb 08                	jmp    802d15 <sget+0x38f>
  802d0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d10:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d18:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d1b:	89 50 0c             	mov    %edx,0xc(%eax)
  802d1e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802d23:	40                   	inc    %eax
  802d24:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  802d29:	eb 13                	jmp    802d3e <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2e:	8b 40 08             	mov    0x8(%eax),%eax
  802d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802d34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d38:	0f 85 e3 fe ff ff    	jne    802c21 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d41:	8b 00                	mov    (%eax),%eax
  802d43:	83 ec 04             	sub    $0x4,%esp
  802d46:	50                   	push   %eax
  802d47:	ff 75 0c             	pushl  0xc(%ebp)
  802d4a:	ff 75 08             	pushl  0x8(%ebp)
  802d4d:	e8 70 04 00 00       	call   8031c2 <sys_get_shared_object>
  802d52:	83 c4 10             	add    $0x10,%esp
  802d55:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802d58:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d5c:	79 28                	jns    802d86 <sget+0x400>
						free_block(allocblock);
  802d5e:	83 ec 0c             	sub    $0xc,%esp
  802d61:	ff 75 e0             	pushl  -0x20(%ebp)
  802d64:	e8 b0 0e 00 00       	call   803c19 <free_block>
  802d69:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802d6c:	83 ec 0c             	sub    $0xc,%esp
  802d6f:	68 40 e1 81 00       	push   $0x81e140
  802d74:	e8 82 13 00 00       	call   8040fb <release_uspinlock>
  802d79:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d81:	e9 bd 01 00 00       	jmp    802f43 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802d86:	83 ec 0c             	sub    $0xc,%esp
  802d89:	68 40 e1 81 00       	push   $0x81e140
  802d8e:	e8 68 13 00 00       	call   8040fb <release_uspinlock>
  802d93:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802d96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d99:	8b 00                	mov    (%eax),%eax
  802d9b:	e9 a3 01 00 00       	jmp    802f43 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 50 04             	mov    0x4(%eax),%edx
  802da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da9:	39 c2                	cmp    %eax,%edx
  802dab:	0f 85 5c 01 00 00    	jne    802f0d <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 10                	mov    (%eax),%edx
  802db6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db9:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802dbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc1:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802dc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dc8:	75 17                	jne    802de1 <sget+0x45b>
  802dca:	83 ec 04             	sub    $0x4,%esp
  802dcd:	68 58 4d 80 00       	push   $0x804d58
  802dd2:	68 fe 01 00 00       	push   $0x1fe
  802dd7:	68 0c 4d 80 00       	push   $0x804d0c
  802ddc:	e8 89 d6 ff ff       	call   80046a <_panic>
  802de1:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802de7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dea:	89 50 0c             	mov    %edx,0xc(%eax)
  802ded:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df0:	8b 40 0c             	mov    0xc(%eax),%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	74 0d                	je     802e04 <sget+0x47e>
  802df7:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802dfc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dff:	89 50 08             	mov    %edx,0x8(%eax)
  802e02:	eb 08                	jmp    802e0c <sget+0x486>
  802e04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e07:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802e0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0f:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e1e:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802e23:	40                   	inc    %eax
  802e24:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802e29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2d:	75 17                	jne    802e46 <sget+0x4c0>
  802e2f:	83 ec 04             	sub    $0x4,%esp
  802e32:	68 7b 4d 80 00       	push   $0x804d7b
  802e37:	68 ff 01 00 00       	push   $0x1ff
  802e3c:	68 0c 4d 80 00       	push   $0x804d0c
  802e41:	e8 24 d6 ff ff       	call   80046a <_panic>
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 40 08             	mov    0x8(%eax),%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 11                	je     802e61 <sget+0x4db>
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 40 08             	mov    0x8(%eax),%eax
  802e56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e59:	8b 52 0c             	mov    0xc(%edx),%edx
  802e5c:	89 50 0c             	mov    %edx,0xc(%eax)
  802e5f:	eb 0b                	jmp    802e6c <sget+0x4e6>
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 40 0c             	mov    0xc(%eax),%eax
  802e67:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 11                	je     802e87 <sget+0x501>
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7f:	8b 52 08             	mov    0x8(%edx),%edx
  802e82:	89 50 08             	mov    %edx,0x8(%eax)
  802e85:	eb 0b                	jmp    802e92 <sget+0x50c>
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 40 08             	mov    0x8(%eax),%eax
  802e8d:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ea6:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802eab:	48                   	dec    %eax
  802eac:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802eb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb4:	8b 00                	mov    (%eax),%eax
  802eb6:	83 ec 04             	sub    $0x4,%esp
  802eb9:	50                   	push   %eax
  802eba:	ff 75 0c             	pushl  0xc(%ebp)
  802ebd:	ff 75 08             	pushl  0x8(%ebp)
  802ec0:	e8 fd 02 00 00       	call   8031c2 <sys_get_shared_object>
  802ec5:	83 c4 10             	add    $0x10,%esp
  802ec8:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802ecb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802ecf:	79 25                	jns    802ef6 <sget+0x570>
						free_block(allocblock);
  802ed1:	83 ec 0c             	sub    $0xc,%esp
  802ed4:	ff 75 e0             	pushl  -0x20(%ebp)
  802ed7:	e8 3d 0d 00 00       	call   803c19 <free_block>
  802edc:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802edf:	83 ec 0c             	sub    $0xc,%esp
  802ee2:	68 40 e1 81 00       	push   $0x81e140
  802ee7:	e8 0f 12 00 00       	call   8040fb <release_uspinlock>
  802eec:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802eef:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef4:	eb 4d                	jmp    802f43 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802ef6:	83 ec 0c             	sub    $0xc,%esp
  802ef9:	68 40 e1 81 00       	push   $0x81e140
  802efe:	e8 f8 11 00 00       	call   8040fb <release_uspinlock>
  802f03:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802f06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	eb 36                	jmp    802f43 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 40 08             	mov    0x8(%eax),%eax
  802f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802f16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1a:	0f 85 4b fc ff ff    	jne    802b6b <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802f20:	83 ec 0c             	sub    $0xc,%esp
  802f23:	ff 75 e0             	pushl  -0x20(%ebp)
  802f26:	e8 ee 0c 00 00       	call   803c19 <free_block>
  802f2b:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802f2e:	83 ec 0c             	sub    $0xc,%esp
  802f31:	68 40 e1 81 00       	push   $0x81e140
  802f36:	e8 c0 11 00 00       	call   8040fb <release_uspinlock>
  802f3b:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f43:	c9                   	leave  
  802f44:	c3                   	ret    

00802f45 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802f45:	55                   	push   %ebp
  802f46:	89 e5                	mov    %esp,%ebp
  802f48:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802f4b:	e8 cd e6 ff ff       	call   80161d <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802f50:	83 ec 04             	sub    $0x4,%esp
  802f53:	68 2c 4e 80 00       	push   $0x804e2c
  802f58:	68 2d 02 00 00       	push   $0x22d
  802f5d:	68 0c 4d 80 00       	push   $0x804d0c
  802f62:	e8 03 d5 ff ff       	call   80046a <_panic>

00802f67 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802f67:	55                   	push   %ebp
  802f68:	89 e5                	mov    %esp,%ebp
  802f6a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	68 54 4e 80 00       	push   $0x804e54
  802f75:	68 40 02 00 00       	push   $0x240
  802f7a:	68 0c 4d 80 00       	push   $0x804d0c
  802f7f:	e8 e6 d4 ff ff       	call   80046a <_panic>

00802f84 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802f84:	55                   	push   %ebp
  802f85:	89 e5                	mov    %esp,%ebp
  802f87:	57                   	push   %edi
  802f88:	56                   	push   %esi
  802f89:	53                   	push   %ebx
  802f8a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f93:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f96:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f99:	8b 7d 18             	mov    0x18(%ebp),%edi
  802f9c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802f9f:	cd 30                	int    $0x30
  802fa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802fa7:	83 c4 10             	add    $0x10,%esp
  802faa:	5b                   	pop    %ebx
  802fab:	5e                   	pop    %esi
  802fac:	5f                   	pop    %edi
  802fad:	5d                   	pop    %ebp
  802fae:	c3                   	ret    

00802faf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802faf:	55                   	push   %ebp
  802fb0:	89 e5                	mov    %esp,%ebp
  802fb2:	83 ec 04             	sub    $0x4,%esp
  802fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  802fb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802fbb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802fbe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	6a 00                	push   $0x0
  802fc7:	51                   	push   %ecx
  802fc8:	52                   	push   %edx
  802fc9:	ff 75 0c             	pushl  0xc(%ebp)
  802fcc:	50                   	push   %eax
  802fcd:	6a 00                	push   $0x0
  802fcf:	e8 b0 ff ff ff       	call   802f84 <syscall>
  802fd4:	83 c4 18             	add    $0x18,%esp
}
  802fd7:	90                   	nop
  802fd8:	c9                   	leave  
  802fd9:	c3                   	ret    

00802fda <sys_cgetc>:

int
sys_cgetc(void)
{
  802fda:	55                   	push   %ebp
  802fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 00                	push   $0x0
  802fe3:	6a 00                	push   $0x0
  802fe5:	6a 00                	push   $0x0
  802fe7:	6a 02                	push   $0x2
  802fe9:	e8 96 ff ff ff       	call   802f84 <syscall>
  802fee:	83 c4 18             	add    $0x18,%esp
}
  802ff1:	c9                   	leave  
  802ff2:	c3                   	ret    

00802ff3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802ff3:	55                   	push   %ebp
  802ff4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802ff6:	6a 00                	push   $0x0
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	6a 00                	push   $0x0
  802ffe:	6a 00                	push   $0x0
  803000:	6a 03                	push   $0x3
  803002:	e8 7d ff ff ff       	call   802f84 <syscall>
  803007:	83 c4 18             	add    $0x18,%esp
}
  80300a:	90                   	nop
  80300b:	c9                   	leave  
  80300c:	c3                   	ret    

0080300d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80300d:	55                   	push   %ebp
  80300e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803010:	6a 00                	push   $0x0
  803012:	6a 00                	push   $0x0
  803014:	6a 00                	push   $0x0
  803016:	6a 00                	push   $0x0
  803018:	6a 00                	push   $0x0
  80301a:	6a 04                	push   $0x4
  80301c:	e8 63 ff ff ff       	call   802f84 <syscall>
  803021:	83 c4 18             	add    $0x18,%esp
}
  803024:	90                   	nop
  803025:	c9                   	leave  
  803026:	c3                   	ret    

00803027 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803027:	55                   	push   %ebp
  803028:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80302a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	6a 00                	push   $0x0
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	52                   	push   %edx
  803037:	50                   	push   %eax
  803038:	6a 08                	push   $0x8
  80303a:	e8 45 ff ff ff       	call   802f84 <syscall>
  80303f:	83 c4 18             	add    $0x18,%esp
}
  803042:	c9                   	leave  
  803043:	c3                   	ret    

00803044 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803044:	55                   	push   %ebp
  803045:	89 e5                	mov    %esp,%ebp
  803047:	56                   	push   %esi
  803048:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803049:	8b 75 18             	mov    0x18(%ebp),%esi
  80304c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80304f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803052:	8b 55 0c             	mov    0xc(%ebp),%edx
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	56                   	push   %esi
  803059:	53                   	push   %ebx
  80305a:	51                   	push   %ecx
  80305b:	52                   	push   %edx
  80305c:	50                   	push   %eax
  80305d:	6a 09                	push   $0x9
  80305f:	e8 20 ff ff ff       	call   802f84 <syscall>
  803064:	83 c4 18             	add    $0x18,%esp
}
  803067:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80306a:	5b                   	pop    %ebx
  80306b:	5e                   	pop    %esi
  80306c:	5d                   	pop    %ebp
  80306d:	c3                   	ret    

0080306e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80306e:	55                   	push   %ebp
  80306f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803071:	6a 00                	push   $0x0
  803073:	6a 00                	push   $0x0
  803075:	6a 00                	push   $0x0
  803077:	6a 00                	push   $0x0
  803079:	ff 75 08             	pushl  0x8(%ebp)
  80307c:	6a 0a                	push   $0xa
  80307e:	e8 01 ff ff ff       	call   802f84 <syscall>
  803083:	83 c4 18             	add    $0x18,%esp
}
  803086:	c9                   	leave  
  803087:	c3                   	ret    

00803088 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803088:	55                   	push   %ebp
  803089:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80308b:	6a 00                	push   $0x0
  80308d:	6a 00                	push   $0x0
  80308f:	6a 00                	push   $0x0
  803091:	ff 75 0c             	pushl  0xc(%ebp)
  803094:	ff 75 08             	pushl  0x8(%ebp)
  803097:	6a 0b                	push   $0xb
  803099:	e8 e6 fe ff ff       	call   802f84 <syscall>
  80309e:	83 c4 18             	add    $0x18,%esp
}
  8030a1:	c9                   	leave  
  8030a2:	c3                   	ret    

008030a3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8030a6:	6a 00                	push   $0x0
  8030a8:	6a 00                	push   $0x0
  8030aa:	6a 00                	push   $0x0
  8030ac:	6a 00                	push   $0x0
  8030ae:	6a 00                	push   $0x0
  8030b0:	6a 0c                	push   $0xc
  8030b2:	e8 cd fe ff ff       	call   802f84 <syscall>
  8030b7:	83 c4 18             	add    $0x18,%esp
}
  8030ba:	c9                   	leave  
  8030bb:	c3                   	ret    

008030bc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8030bc:	55                   	push   %ebp
  8030bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8030bf:	6a 00                	push   $0x0
  8030c1:	6a 00                	push   $0x0
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 00                	push   $0x0
  8030c7:	6a 00                	push   $0x0
  8030c9:	6a 0d                	push   $0xd
  8030cb:	e8 b4 fe ff ff       	call   802f84 <syscall>
  8030d0:	83 c4 18             	add    $0x18,%esp
}
  8030d3:	c9                   	leave  
  8030d4:	c3                   	ret    

008030d5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8030d5:	55                   	push   %ebp
  8030d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8030d8:	6a 00                	push   $0x0
  8030da:	6a 00                	push   $0x0
  8030dc:	6a 00                	push   $0x0
  8030de:	6a 00                	push   $0x0
  8030e0:	6a 00                	push   $0x0
  8030e2:	6a 0e                	push   $0xe
  8030e4:	e8 9b fe ff ff       	call   802f84 <syscall>
  8030e9:	83 c4 18             	add    $0x18,%esp
}
  8030ec:	c9                   	leave  
  8030ed:	c3                   	ret    

008030ee <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8030ee:	55                   	push   %ebp
  8030ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8030f1:	6a 00                	push   $0x0
  8030f3:	6a 00                	push   $0x0
  8030f5:	6a 00                	push   $0x0
  8030f7:	6a 00                	push   $0x0
  8030f9:	6a 00                	push   $0x0
  8030fb:	6a 0f                	push   $0xf
  8030fd:	e8 82 fe ff ff       	call   802f84 <syscall>
  803102:	83 c4 18             	add    $0x18,%esp
}
  803105:	c9                   	leave  
  803106:	c3                   	ret    

00803107 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803107:	55                   	push   %ebp
  803108:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80310a:	6a 00                	push   $0x0
  80310c:	6a 00                	push   $0x0
  80310e:	6a 00                	push   $0x0
  803110:	6a 00                	push   $0x0
  803112:	ff 75 08             	pushl  0x8(%ebp)
  803115:	6a 10                	push   $0x10
  803117:	e8 68 fe ff ff       	call   802f84 <syscall>
  80311c:	83 c4 18             	add    $0x18,%esp
}
  80311f:	c9                   	leave  
  803120:	c3                   	ret    

00803121 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803121:	55                   	push   %ebp
  803122:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803124:	6a 00                	push   $0x0
  803126:	6a 00                	push   $0x0
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	6a 00                	push   $0x0
  80312e:	6a 11                	push   $0x11
  803130:	e8 4f fe ff ff       	call   802f84 <syscall>
  803135:	83 c4 18             	add    $0x18,%esp
}
  803138:	90                   	nop
  803139:	c9                   	leave  
  80313a:	c3                   	ret    

0080313b <sys_cputc>:

void
sys_cputc(const char c)
{
  80313b:	55                   	push   %ebp
  80313c:	89 e5                	mov    %esp,%ebp
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803147:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80314b:	6a 00                	push   $0x0
  80314d:	6a 00                	push   $0x0
  80314f:	6a 00                	push   $0x0
  803151:	6a 00                	push   $0x0
  803153:	50                   	push   %eax
  803154:	6a 01                	push   $0x1
  803156:	e8 29 fe ff ff       	call   802f84 <syscall>
  80315b:	83 c4 18             	add    $0x18,%esp
}
  80315e:	90                   	nop
  80315f:	c9                   	leave  
  803160:	c3                   	ret    

00803161 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803161:	55                   	push   %ebp
  803162:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803164:	6a 00                	push   $0x0
  803166:	6a 00                	push   $0x0
  803168:	6a 00                	push   $0x0
  80316a:	6a 00                	push   $0x0
  80316c:	6a 00                	push   $0x0
  80316e:	6a 14                	push   $0x14
  803170:	e8 0f fe ff ff       	call   802f84 <syscall>
  803175:	83 c4 18             	add    $0x18,%esp
}
  803178:	90                   	nop
  803179:	c9                   	leave  
  80317a:	c3                   	ret    

0080317b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80317b:	55                   	push   %ebp
  80317c:	89 e5                	mov    %esp,%ebp
  80317e:	83 ec 04             	sub    $0x4,%esp
  803181:	8b 45 10             	mov    0x10(%ebp),%eax
  803184:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803187:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80318a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	6a 00                	push   $0x0
  803193:	51                   	push   %ecx
  803194:	52                   	push   %edx
  803195:	ff 75 0c             	pushl  0xc(%ebp)
  803198:	50                   	push   %eax
  803199:	6a 15                	push   $0x15
  80319b:	e8 e4 fd ff ff       	call   802f84 <syscall>
  8031a0:	83 c4 18             	add    $0x18,%esp
}
  8031a3:	c9                   	leave  
  8031a4:	c3                   	ret    

008031a5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8031a5:	55                   	push   %ebp
  8031a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8031a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	6a 00                	push   $0x0
  8031b0:	6a 00                	push   $0x0
  8031b2:	6a 00                	push   $0x0
  8031b4:	52                   	push   %edx
  8031b5:	50                   	push   %eax
  8031b6:	6a 16                	push   $0x16
  8031b8:	e8 c7 fd ff ff       	call   802f84 <syscall>
  8031bd:	83 c4 18             	add    $0x18,%esp
}
  8031c0:	c9                   	leave  
  8031c1:	c3                   	ret    

008031c2 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8031c2:	55                   	push   %ebp
  8031c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8031c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	6a 00                	push   $0x0
  8031d0:	6a 00                	push   $0x0
  8031d2:	51                   	push   %ecx
  8031d3:	52                   	push   %edx
  8031d4:	50                   	push   %eax
  8031d5:	6a 17                	push   $0x17
  8031d7:	e8 a8 fd ff ff       	call   802f84 <syscall>
  8031dc:	83 c4 18             	add    $0x18,%esp
}
  8031df:	c9                   	leave  
  8031e0:	c3                   	ret    

008031e1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8031e1:	55                   	push   %ebp
  8031e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8031e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	6a 00                	push   $0x0
  8031ec:	6a 00                	push   $0x0
  8031ee:	6a 00                	push   $0x0
  8031f0:	52                   	push   %edx
  8031f1:	50                   	push   %eax
  8031f2:	6a 18                	push   $0x18
  8031f4:	e8 8b fd ff ff       	call   802f84 <syscall>
  8031f9:	83 c4 18             	add    $0x18,%esp
}
  8031fc:	c9                   	leave  
  8031fd:	c3                   	ret    

008031fe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8031fe:	55                   	push   %ebp
  8031ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	6a 00                	push   $0x0
  803206:	ff 75 14             	pushl  0x14(%ebp)
  803209:	ff 75 10             	pushl  0x10(%ebp)
  80320c:	ff 75 0c             	pushl  0xc(%ebp)
  80320f:	50                   	push   %eax
  803210:	6a 19                	push   $0x19
  803212:	e8 6d fd ff ff       	call   802f84 <syscall>
  803217:	83 c4 18             	add    $0x18,%esp
}
  80321a:	c9                   	leave  
  80321b:	c3                   	ret    

0080321c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80321c:	55                   	push   %ebp
  80321d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	6a 00                	push   $0x0
  803224:	6a 00                	push   $0x0
  803226:	6a 00                	push   $0x0
  803228:	6a 00                	push   $0x0
  80322a:	50                   	push   %eax
  80322b:	6a 1a                	push   $0x1a
  80322d:	e8 52 fd ff ff       	call   802f84 <syscall>
  803232:	83 c4 18             	add    $0x18,%esp
}
  803235:	90                   	nop
  803236:	c9                   	leave  
  803237:	c3                   	ret    

00803238 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803238:	55                   	push   %ebp
  803239:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	6a 00                	push   $0x0
  803240:	6a 00                	push   $0x0
  803242:	6a 00                	push   $0x0
  803244:	6a 00                	push   $0x0
  803246:	50                   	push   %eax
  803247:	6a 1b                	push   $0x1b
  803249:	e8 36 fd ff ff       	call   802f84 <syscall>
  80324e:	83 c4 18             	add    $0x18,%esp
}
  803251:	c9                   	leave  
  803252:	c3                   	ret    

00803253 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803253:	55                   	push   %ebp
  803254:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803256:	6a 00                	push   $0x0
  803258:	6a 00                	push   $0x0
  80325a:	6a 00                	push   $0x0
  80325c:	6a 00                	push   $0x0
  80325e:	6a 00                	push   $0x0
  803260:	6a 05                	push   $0x5
  803262:	e8 1d fd ff ff       	call   802f84 <syscall>
  803267:	83 c4 18             	add    $0x18,%esp
}
  80326a:	c9                   	leave  
  80326b:	c3                   	ret    

0080326c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80326c:	55                   	push   %ebp
  80326d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80326f:	6a 00                	push   $0x0
  803271:	6a 00                	push   $0x0
  803273:	6a 00                	push   $0x0
  803275:	6a 00                	push   $0x0
  803277:	6a 00                	push   $0x0
  803279:	6a 06                	push   $0x6
  80327b:	e8 04 fd ff ff       	call   802f84 <syscall>
  803280:	83 c4 18             	add    $0x18,%esp
}
  803283:	c9                   	leave  
  803284:	c3                   	ret    

00803285 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803285:	55                   	push   %ebp
  803286:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803288:	6a 00                	push   $0x0
  80328a:	6a 00                	push   $0x0
  80328c:	6a 00                	push   $0x0
  80328e:	6a 00                	push   $0x0
  803290:	6a 00                	push   $0x0
  803292:	6a 07                	push   $0x7
  803294:	e8 eb fc ff ff       	call   802f84 <syscall>
  803299:	83 c4 18             	add    $0x18,%esp
}
  80329c:	c9                   	leave  
  80329d:	c3                   	ret    

0080329e <sys_exit_env>:


void sys_exit_env(void)
{
  80329e:	55                   	push   %ebp
  80329f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8032a1:	6a 00                	push   $0x0
  8032a3:	6a 00                	push   $0x0
  8032a5:	6a 00                	push   $0x0
  8032a7:	6a 00                	push   $0x0
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 1c                	push   $0x1c
  8032ad:	e8 d2 fc ff ff       	call   802f84 <syscall>
  8032b2:	83 c4 18             	add    $0x18,%esp
}
  8032b5:	90                   	nop
  8032b6:	c9                   	leave  
  8032b7:	c3                   	ret    

008032b8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8032b8:	55                   	push   %ebp
  8032b9:	89 e5                	mov    %esp,%ebp
  8032bb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8032be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032c1:	8d 50 04             	lea    0x4(%eax),%edx
  8032c4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032c7:	6a 00                	push   $0x0
  8032c9:	6a 00                	push   $0x0
  8032cb:	6a 00                	push   $0x0
  8032cd:	52                   	push   %edx
  8032ce:	50                   	push   %eax
  8032cf:	6a 1d                	push   $0x1d
  8032d1:	e8 ae fc ff ff       	call   802f84 <syscall>
  8032d6:	83 c4 18             	add    $0x18,%esp
	return result;
  8032d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8032df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032e2:	89 01                	mov    %eax,(%ecx)
  8032e4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	c9                   	leave  
  8032eb:	c2 04 00             	ret    $0x4

008032ee <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8032ee:	55                   	push   %ebp
  8032ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8032f1:	6a 00                	push   $0x0
  8032f3:	6a 00                	push   $0x0
  8032f5:	ff 75 10             	pushl  0x10(%ebp)
  8032f8:	ff 75 0c             	pushl  0xc(%ebp)
  8032fb:	ff 75 08             	pushl  0x8(%ebp)
  8032fe:	6a 13                	push   $0x13
  803300:	e8 7f fc ff ff       	call   802f84 <syscall>
  803305:	83 c4 18             	add    $0x18,%esp
	return ;
  803308:	90                   	nop
}
  803309:	c9                   	leave  
  80330a:	c3                   	ret    

0080330b <sys_rcr2>:
uint32 sys_rcr2()
{
  80330b:	55                   	push   %ebp
  80330c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80330e:	6a 00                	push   $0x0
  803310:	6a 00                	push   $0x0
  803312:	6a 00                	push   $0x0
  803314:	6a 00                	push   $0x0
  803316:	6a 00                	push   $0x0
  803318:	6a 1e                	push   $0x1e
  80331a:	e8 65 fc ff ff       	call   802f84 <syscall>
  80331f:	83 c4 18             	add    $0x18,%esp
}
  803322:	c9                   	leave  
  803323:	c3                   	ret    

00803324 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803324:	55                   	push   %ebp
  803325:	89 e5                	mov    %esp,%ebp
  803327:	83 ec 04             	sub    $0x4,%esp
  80332a:	8b 45 08             	mov    0x8(%ebp),%eax
  80332d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803330:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803334:	6a 00                	push   $0x0
  803336:	6a 00                	push   $0x0
  803338:	6a 00                	push   $0x0
  80333a:	6a 00                	push   $0x0
  80333c:	50                   	push   %eax
  80333d:	6a 1f                	push   $0x1f
  80333f:	e8 40 fc ff ff       	call   802f84 <syscall>
  803344:	83 c4 18             	add    $0x18,%esp
	return ;
  803347:	90                   	nop
}
  803348:	c9                   	leave  
  803349:	c3                   	ret    

0080334a <rsttst>:
void rsttst()
{
  80334a:	55                   	push   %ebp
  80334b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80334d:	6a 00                	push   $0x0
  80334f:	6a 00                	push   $0x0
  803351:	6a 00                	push   $0x0
  803353:	6a 00                	push   $0x0
  803355:	6a 00                	push   $0x0
  803357:	6a 21                	push   $0x21
  803359:	e8 26 fc ff ff       	call   802f84 <syscall>
  80335e:	83 c4 18             	add    $0x18,%esp
	return ;
  803361:	90                   	nop
}
  803362:	c9                   	leave  
  803363:	c3                   	ret    

00803364 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803364:	55                   	push   %ebp
  803365:	89 e5                	mov    %esp,%ebp
  803367:	83 ec 04             	sub    $0x4,%esp
  80336a:	8b 45 14             	mov    0x14(%ebp),%eax
  80336d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803370:	8b 55 18             	mov    0x18(%ebp),%edx
  803373:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803377:	52                   	push   %edx
  803378:	50                   	push   %eax
  803379:	ff 75 10             	pushl  0x10(%ebp)
  80337c:	ff 75 0c             	pushl  0xc(%ebp)
  80337f:	ff 75 08             	pushl  0x8(%ebp)
  803382:	6a 20                	push   $0x20
  803384:	e8 fb fb ff ff       	call   802f84 <syscall>
  803389:	83 c4 18             	add    $0x18,%esp
	return ;
  80338c:	90                   	nop
}
  80338d:	c9                   	leave  
  80338e:	c3                   	ret    

0080338f <chktst>:
void chktst(uint32 n)
{
  80338f:	55                   	push   %ebp
  803390:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803392:	6a 00                	push   $0x0
  803394:	6a 00                	push   $0x0
  803396:	6a 00                	push   $0x0
  803398:	6a 00                	push   $0x0
  80339a:	ff 75 08             	pushl  0x8(%ebp)
  80339d:	6a 22                	push   $0x22
  80339f:	e8 e0 fb ff ff       	call   802f84 <syscall>
  8033a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8033a7:	90                   	nop
}
  8033a8:	c9                   	leave  
  8033a9:	c3                   	ret    

008033aa <inctst>:

void inctst()
{
  8033aa:	55                   	push   %ebp
  8033ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8033ad:	6a 00                	push   $0x0
  8033af:	6a 00                	push   $0x0
  8033b1:	6a 00                	push   $0x0
  8033b3:	6a 00                	push   $0x0
  8033b5:	6a 00                	push   $0x0
  8033b7:	6a 23                	push   $0x23
  8033b9:	e8 c6 fb ff ff       	call   802f84 <syscall>
  8033be:	83 c4 18             	add    $0x18,%esp
	return ;
  8033c1:	90                   	nop
}
  8033c2:	c9                   	leave  
  8033c3:	c3                   	ret    

008033c4 <gettst>:
uint32 gettst()
{
  8033c4:	55                   	push   %ebp
  8033c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8033c7:	6a 00                	push   $0x0
  8033c9:	6a 00                	push   $0x0
  8033cb:	6a 00                	push   $0x0
  8033cd:	6a 00                	push   $0x0
  8033cf:	6a 00                	push   $0x0
  8033d1:	6a 24                	push   $0x24
  8033d3:	e8 ac fb ff ff       	call   802f84 <syscall>
  8033d8:	83 c4 18             	add    $0x18,%esp
}
  8033db:	c9                   	leave  
  8033dc:	c3                   	ret    

008033dd <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8033dd:	55                   	push   %ebp
  8033de:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033e0:	6a 00                	push   $0x0
  8033e2:	6a 00                	push   $0x0
  8033e4:	6a 00                	push   $0x0
  8033e6:	6a 00                	push   $0x0
  8033e8:	6a 00                	push   $0x0
  8033ea:	6a 25                	push   $0x25
  8033ec:	e8 93 fb ff ff       	call   802f84 <syscall>
  8033f1:	83 c4 18             	add    $0x18,%esp
  8033f4:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  8033f9:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  8033fe:	c9                   	leave  
  8033ff:	c3                   	ret    

00803400 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803400:	55                   	push   %ebp
  803401:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803403:	8b 45 08             	mov    0x8(%ebp),%eax
  803406:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80340b:	6a 00                	push   $0x0
  80340d:	6a 00                	push   $0x0
  80340f:	6a 00                	push   $0x0
  803411:	6a 00                	push   $0x0
  803413:	ff 75 08             	pushl  0x8(%ebp)
  803416:	6a 26                	push   $0x26
  803418:	e8 67 fb ff ff       	call   802f84 <syscall>
  80341d:	83 c4 18             	add    $0x18,%esp
	return ;
  803420:	90                   	nop
}
  803421:	c9                   	leave  
  803422:	c3                   	ret    

00803423 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803423:	55                   	push   %ebp
  803424:	89 e5                	mov    %esp,%ebp
  803426:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803427:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80342a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80342d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	6a 00                	push   $0x0
  803435:	53                   	push   %ebx
  803436:	51                   	push   %ecx
  803437:	52                   	push   %edx
  803438:	50                   	push   %eax
  803439:	6a 27                	push   $0x27
  80343b:	e8 44 fb ff ff       	call   802f84 <syscall>
  803440:	83 c4 18             	add    $0x18,%esp
}
  803443:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803446:	c9                   	leave  
  803447:	c3                   	ret    

00803448 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803448:	55                   	push   %ebp
  803449:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80344b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	6a 00                	push   $0x0
  803453:	6a 00                	push   $0x0
  803455:	6a 00                	push   $0x0
  803457:	52                   	push   %edx
  803458:	50                   	push   %eax
  803459:	6a 28                	push   $0x28
  80345b:	e8 24 fb ff ff       	call   802f84 <syscall>
  803460:	83 c4 18             	add    $0x18,%esp
}
  803463:	c9                   	leave  
  803464:	c3                   	ret    

00803465 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803465:	55                   	push   %ebp
  803466:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803468:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80346b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	6a 00                	push   $0x0
  803473:	51                   	push   %ecx
  803474:	ff 75 10             	pushl  0x10(%ebp)
  803477:	52                   	push   %edx
  803478:	50                   	push   %eax
  803479:	6a 29                	push   $0x29
  80347b:	e8 04 fb ff ff       	call   802f84 <syscall>
  803480:	83 c4 18             	add    $0x18,%esp
}
  803483:	c9                   	leave  
  803484:	c3                   	ret    

00803485 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803485:	55                   	push   %ebp
  803486:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803488:	6a 00                	push   $0x0
  80348a:	6a 00                	push   $0x0
  80348c:	ff 75 10             	pushl  0x10(%ebp)
  80348f:	ff 75 0c             	pushl  0xc(%ebp)
  803492:	ff 75 08             	pushl  0x8(%ebp)
  803495:	6a 12                	push   $0x12
  803497:	e8 e8 fa ff ff       	call   802f84 <syscall>
  80349c:	83 c4 18             	add    $0x18,%esp
	return ;
  80349f:	90                   	nop
}
  8034a0:	c9                   	leave  
  8034a1:	c3                   	ret    

008034a2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8034a2:	55                   	push   %ebp
  8034a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8034a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	6a 00                	push   $0x0
  8034ad:	6a 00                	push   $0x0
  8034af:	6a 00                	push   $0x0
  8034b1:	52                   	push   %edx
  8034b2:	50                   	push   %eax
  8034b3:	6a 2a                	push   $0x2a
  8034b5:	e8 ca fa ff ff       	call   802f84 <syscall>
  8034ba:	83 c4 18             	add    $0x18,%esp
	return;
  8034bd:	90                   	nop
}
  8034be:	c9                   	leave  
  8034bf:	c3                   	ret    

008034c0 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8034c0:	55                   	push   %ebp
  8034c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8034c3:	6a 00                	push   $0x0
  8034c5:	6a 00                	push   $0x0
  8034c7:	6a 00                	push   $0x0
  8034c9:	6a 00                	push   $0x0
  8034cb:	6a 00                	push   $0x0
  8034cd:	6a 2b                	push   $0x2b
  8034cf:	e8 b0 fa ff ff       	call   802f84 <syscall>
  8034d4:	83 c4 18             	add    $0x18,%esp
}
  8034d7:	c9                   	leave  
  8034d8:	c3                   	ret    

008034d9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8034d9:	55                   	push   %ebp
  8034da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8034dc:	6a 00                	push   $0x0
  8034de:	6a 00                	push   $0x0
  8034e0:	6a 00                	push   $0x0
  8034e2:	ff 75 0c             	pushl  0xc(%ebp)
  8034e5:	ff 75 08             	pushl  0x8(%ebp)
  8034e8:	6a 2d                	push   $0x2d
  8034ea:	e8 95 fa ff ff       	call   802f84 <syscall>
  8034ef:	83 c4 18             	add    $0x18,%esp
	return;
  8034f2:	90                   	nop
}
  8034f3:	c9                   	leave  
  8034f4:	c3                   	ret    

008034f5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8034f5:	55                   	push   %ebp
  8034f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8034f8:	6a 00                	push   $0x0
  8034fa:	6a 00                	push   $0x0
  8034fc:	6a 00                	push   $0x0
  8034fe:	ff 75 0c             	pushl  0xc(%ebp)
  803501:	ff 75 08             	pushl  0x8(%ebp)
  803504:	6a 2c                	push   $0x2c
  803506:	e8 79 fa ff ff       	call   802f84 <syscall>
  80350b:	83 c4 18             	add    $0x18,%esp
	return ;
  80350e:	90                   	nop
}
  80350f:	c9                   	leave  
  803510:	c3                   	ret    

00803511 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803511:	55                   	push   %ebp
  803512:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803514:	8b 55 0c             	mov    0xc(%ebp),%edx
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	6a 00                	push   $0x0
  80351c:	6a 00                	push   $0x0
  80351e:	6a 00                	push   $0x0
  803520:	52                   	push   %edx
  803521:	50                   	push   %eax
  803522:	6a 2e                	push   $0x2e
  803524:	e8 5b fa ff ff       	call   802f84 <syscall>
  803529:	83 c4 18             	add    $0x18,%esp
	    return;
  80352c:	90                   	nop
}
  80352d:	c9                   	leave  
  80352e:	c3                   	ret    

0080352f <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80352f:	55                   	push   %ebp
  803530:	89 e5                	mov    %esp,%ebp
  803532:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	ba 60 60 80 00       	mov    $0x806060,%edx
  80353d:	29 d0                	sub    %edx,%eax
  80353f:	c1 f8 02             	sar    $0x2,%eax
  803542:	89 c2                	mov    %eax,%edx
  803544:	89 d0                	mov    %edx,%eax
  803546:	c1 e0 02             	shl    $0x2,%eax
  803549:	01 d0                	add    %edx,%eax
  80354b:	c1 e0 02             	shl    $0x2,%eax
  80354e:	01 d0                	add    %edx,%eax
  803550:	c1 e0 02             	shl    $0x2,%eax
  803553:	01 d0                	add    %edx,%eax
  803555:	89 c1                	mov    %eax,%ecx
  803557:	c1 e1 08             	shl    $0x8,%ecx
  80355a:	01 c8                	add    %ecx,%eax
  80355c:	89 c1                	mov    %eax,%ecx
  80355e:	c1 e1 10             	shl    $0x10,%ecx
  803561:	01 c8                	add    %ecx,%eax
  803563:	01 c0                	add    %eax,%eax
  803565:	01 d0                	add    %edx,%eax
  803567:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80356a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80356d:	c1 e0 0c             	shl    $0xc,%eax
  803570:	89 c2                	mov    %eax,%edx
  803572:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803577:	01 d0                	add    %edx,%eax
}
  803579:	c9                   	leave  
  80357a:	c3                   	ret    

0080357b <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  80357b:	55                   	push   %ebp
  80357c:	89 e5                	mov    %esp,%ebp
  80357e:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  803581:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803588:	eb 06                	jmp    803590 <log2+0x15>
			n >>=1;
  80358a:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  80358d:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803590:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803594:	77 f4                	ja     80358a <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  803596:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803599:	c9                   	leave  
  80359a:	c3                   	ret    

0080359b <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80359b:	55                   	push   %ebp
  80359c:	89 e5                	mov    %esp,%ebp
  80359e:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	05 00 00 00 02       	add    $0x2000000,%eax
  8035a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035ac:	73 16                	jae    8035c4 <initialize_dynamic_allocator+0x29>
  8035ae:	68 78 4e 80 00       	push   $0x804e78
  8035b3:	68 9e 4e 80 00       	push   $0x804e9e
  8035b8:	6a 2d                	push   $0x2d
  8035ba:	68 b3 4e 80 00       	push   $0x804eb3
  8035bf:	e8 a6 ce ff ff       	call   80046a <_panic>
		is_initialized = 1;
  8035c4:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8035cb:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  8035d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d9:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  8035de:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8035e4:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8035e9:	29 c2                	sub    %eax,%edx
  8035eb:	89 d0                	mov    %edx,%eax
  8035ed:	c1 e8 0c             	shr    $0xc,%eax
  8035f0:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  8035f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035fa:	eb 2f                	jmp    80362b <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  8035fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ff:	89 d0                	mov    %edx,%eax
  803601:	01 c0                	add    %eax,%eax
  803603:	01 d0                	add    %edx,%eax
  803605:	c1 e0 02             	shl    $0x2,%eax
  803608:	05 68 60 80 00       	add    $0x806068,%eax
  80360d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803612:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803615:	89 d0                	mov    %edx,%eax
  803617:	01 c0                	add    %eax,%eax
  803619:	01 d0                	add    %edx,%eax
  80361b:	c1 e0 02             	shl    $0x2,%eax
  80361e:	05 6a 60 80 00       	add    $0x80606a,%eax
  803623:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803628:	ff 45 f4             	incl   -0xc(%ebp)
  80362b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803631:	7c c9                	jl     8035fc <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  803633:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  80363a:	00 00 00 
  80363d:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  803644:	00 00 00 
  803647:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  80364e:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803651:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803658:	e9 9c 00 00 00       	jmp    8036f9 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80365d:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803663:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803666:	89 c8                	mov    %ecx,%eax
  803668:	01 c0                	add    %eax,%eax
  80366a:	01 c8                	add    %ecx,%eax
  80366c:	c1 e0 02             	shl    $0x2,%eax
  80366f:	05 64 60 80 00       	add    $0x806064,%eax
  803674:	89 10                	mov    %edx,(%eax)
  803676:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803679:	89 d0                	mov    %edx,%eax
  80367b:	01 c0                	add    %eax,%eax
  80367d:	01 d0                	add    %edx,%eax
  80367f:	c1 e0 02             	shl    $0x2,%eax
  803682:	05 64 60 80 00       	add    $0x806064,%eax
  803687:	8b 00                	mov    (%eax),%eax
  803689:	85 c0                	test   %eax,%eax
  80368b:	74 1b                	je     8036a8 <initialize_dynamic_allocator+0x10d>
  80368d:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803693:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803696:	89 c8                	mov    %ecx,%eax
  803698:	01 c0                	add    %eax,%eax
  80369a:	01 c8                	add    %ecx,%eax
  80369c:	c1 e0 02             	shl    $0x2,%eax
  80369f:	05 60 60 80 00       	add    $0x806060,%eax
  8036a4:	89 02                	mov    %eax,(%edx)
  8036a6:	eb 16                	jmp    8036be <initialize_dynamic_allocator+0x123>
  8036a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ab:	89 d0                	mov    %edx,%eax
  8036ad:	01 c0                	add    %eax,%eax
  8036af:	01 d0                	add    %edx,%eax
  8036b1:	c1 e0 02             	shl    $0x2,%eax
  8036b4:	05 60 60 80 00       	add    $0x806060,%eax
  8036b9:	a3 48 60 80 00       	mov    %eax,0x806048
  8036be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036c1:	89 d0                	mov    %edx,%eax
  8036c3:	01 c0                	add    %eax,%eax
  8036c5:	01 d0                	add    %edx,%eax
  8036c7:	c1 e0 02             	shl    $0x2,%eax
  8036ca:	05 60 60 80 00       	add    $0x806060,%eax
  8036cf:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8036d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036d7:	89 d0                	mov    %edx,%eax
  8036d9:	01 c0                	add    %eax,%eax
  8036db:	01 d0                	add    %edx,%eax
  8036dd:	c1 e0 02             	shl    $0x2,%eax
  8036e0:	05 60 60 80 00       	add    $0x806060,%eax
  8036e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036eb:	a1 54 60 80 00       	mov    0x806054,%eax
  8036f0:	40                   	inc    %eax
  8036f1:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  8036f6:	ff 45 f0             	incl   -0x10(%ebp)
  8036f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036fc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036ff:	0f 8c 58 ff ff ff    	jl     80365d <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803705:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80370c:	eb 36                	jmp    803744 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  80370e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803711:	c1 e0 04             	shl    $0x4,%eax
  803714:	05 80 e0 81 00       	add    $0x81e080,%eax
  803719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80371f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803722:	c1 e0 04             	shl    $0x4,%eax
  803725:	05 84 e0 81 00       	add    $0x81e084,%eax
  80372a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803733:	c1 e0 04             	shl    $0x4,%eax
  803736:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80373b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803741:	ff 45 ec             	incl   -0x14(%ebp)
  803744:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803748:	7e c4                	jle    80370e <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80374a:	90                   	nop
  80374b:	c9                   	leave  
  80374c:	c3                   	ret    

0080374d <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  80374d:	55                   	push   %ebp
  80374e:	89 e5                	mov    %esp,%ebp
  803750:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803753:	8b 55 08             	mov    0x8(%ebp),%edx
  803756:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80375b:	29 c2                	sub    %eax,%edx
  80375d:	89 d0                	mov    %edx,%eax
  80375f:	c1 e8 0c             	shr    $0xc,%eax
  803762:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803765:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803768:	89 d0                	mov    %edx,%eax
  80376a:	01 c0                	add    %eax,%eax
  80376c:	01 d0                	add    %edx,%eax
  80376e:	c1 e0 02             	shl    $0x2,%eax
  803771:	05 68 60 80 00       	add    $0x806068,%eax
  803776:	8b 00                	mov    (%eax),%eax
  803778:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80377b:	c9                   	leave  
  80377c:	c3                   	ret    

0080377d <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80377d:	55                   	push   %ebp
  80377e:	89 e5                	mov    %esp,%ebp
  803780:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803783:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80378a:	76 16                	jbe    8037a2 <alloc_block+0x25>
  80378c:	68 cc 4e 80 00       	push   $0x804ecc
  803791:	68 9e 4e 80 00       	push   $0x804e9e
  803796:	6a 6c                	push   $0x6c
  803798:	68 b3 4e 80 00       	push   $0x804eb3
  80379d:	e8 c8 cc ff ff       	call   80046a <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  8037a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037a6:	75 0a                	jne    8037b2 <alloc_block+0x35>
		return NULL;
  8037a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ad:	e9 65 04 00 00       	jmp    803c17 <alloc_block+0x49a>
	}
	else if(size<=8){
  8037b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  8037b6:	77 09                	ja     8037c1 <alloc_block+0x44>
		size=8;
  8037b8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  8037bf:	eb 1f                	jmp    8037e0 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  8037c1:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  8037c8:	eb 08                	jmp    8037d2 <alloc_block+0x55>
			reqsize*=2;
  8037ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cd:	01 c0                	add    %eax,%eax
  8037cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  8037d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d8:	72 f0                	jb     8037ca <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  8037da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037dd:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  8037e0:	83 ec 0c             	sub    $0xc,%esp
  8037e3:	ff 75 08             	pushl  0x8(%ebp)
  8037e6:	e8 90 fd ff ff       	call   80357b <log2>
  8037eb:	83 c4 10             	add    $0x10,%esp
  8037ee:	83 e8 03             	sub    $0x3,%eax
  8037f1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  8037f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f7:	c1 e0 04             	shl    $0x4,%eax
  8037fa:	05 80 e0 81 00       	add    $0x81e080,%eax
  8037ff:	8b 00                	mov    (%eax),%eax
  803801:	85 c0                	test   %eax,%eax
  803803:	0f 84 fb 00 00 00    	je     803904 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803809:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380c:	c1 e0 04             	shl    $0x4,%eax
  80380f:	05 80 e0 81 00       	add    $0x81e080,%eax
  803814:	8b 00                	mov    (%eax),%eax
  803816:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803819:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80381d:	75 17                	jne    803836 <alloc_block+0xb9>
  80381f:	83 ec 04             	sub    $0x4,%esp
  803822:	68 ed 4e 80 00       	push   $0x804eed
  803827:	68 86 00 00 00       	push   $0x86
  80382c:	68 b3 4e 80 00       	push   $0x804eb3
  803831:	e8 34 cc ff ff       	call   80046a <_panic>
  803836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803839:	8b 00                	mov    (%eax),%eax
  80383b:	85 c0                	test   %eax,%eax
  80383d:	74 10                	je     80384f <alloc_block+0xd2>
  80383f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803847:	8b 52 04             	mov    0x4(%edx),%edx
  80384a:	89 50 04             	mov    %edx,0x4(%eax)
  80384d:	eb 14                	jmp    803863 <alloc_block+0xe6>
  80384f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803852:	8b 40 04             	mov    0x4(%eax),%eax
  803855:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803858:	c1 e2 04             	shl    $0x4,%edx
  80385b:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803861:	89 02                	mov    %eax,(%edx)
  803863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803866:	8b 40 04             	mov    0x4(%eax),%eax
  803869:	85 c0                	test   %eax,%eax
  80386b:	74 0f                	je     80387c <alloc_block+0xff>
  80386d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803870:	8b 40 04             	mov    0x4(%eax),%eax
  803873:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803876:	8b 12                	mov    (%edx),%edx
  803878:	89 10                	mov    %edx,(%eax)
  80387a:	eb 13                	jmp    80388f <alloc_block+0x112>
  80387c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387f:	8b 00                	mov    (%eax),%eax
  803881:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803884:	c1 e2 04             	shl    $0x4,%edx
  803887:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  80388d:	89 02                	mov    %eax,(%edx)
  80388f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803892:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a5:	c1 e0 04             	shl    $0x4,%eax
  8038a8:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8038ad:	8b 00                	mov    (%eax),%eax
  8038af:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b5:	c1 e0 04             	shl    $0x4,%eax
  8038b8:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8038bd:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  8038bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c2:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8038c7:	29 c2                	sub    %eax,%edx
  8038c9:	89 d0                	mov    %edx,%eax
  8038cb:	c1 e8 0c             	shr    $0xc,%eax
  8038ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  8038d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038d4:	89 d0                	mov    %edx,%eax
  8038d6:	01 c0                	add    %eax,%eax
  8038d8:	01 d0                	add    %edx,%eax
  8038da:	c1 e0 02             	shl    $0x2,%eax
  8038dd:	05 6a 60 80 00       	add    $0x80606a,%eax
  8038e2:	66 8b 00             	mov    (%eax),%ax
  8038e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8038eb:	89 c8                	mov    %ecx,%eax
  8038ed:	01 c0                	add    %eax,%eax
  8038ef:	01 c8                	add    %ecx,%eax
  8038f1:	c1 e0 02             	shl    $0x2,%eax
  8038f4:	05 6a 60 80 00       	add    $0x80606a,%eax
  8038f9:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  8038fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ff:	e9 13 03 00 00       	jmp    803c17 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803904:	a1 48 60 80 00       	mov    0x806048,%eax
  803909:	85 c0                	test   %eax,%eax
  80390b:	0f 84 c9 01 00 00    	je     803ada <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803911:	a1 48 60 80 00       	mov    0x806048,%eax
  803916:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803919:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80391d:	75 17                	jne    803936 <alloc_block+0x1b9>
  80391f:	83 ec 04             	sub    $0x4,%esp
  803922:	68 ed 4e 80 00       	push   $0x804eed
  803927:	68 8f 00 00 00       	push   $0x8f
  80392c:	68 b3 4e 80 00       	push   $0x804eb3
  803931:	e8 34 cb ff ff       	call   80046a <_panic>
  803936:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803939:	8b 00                	mov    (%eax),%eax
  80393b:	85 c0                	test   %eax,%eax
  80393d:	74 10                	je     80394f <alloc_block+0x1d2>
  80393f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803942:	8b 00                	mov    (%eax),%eax
  803944:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803947:	8b 52 04             	mov    0x4(%edx),%edx
  80394a:	89 50 04             	mov    %edx,0x4(%eax)
  80394d:	eb 0b                	jmp    80395a <alloc_block+0x1dd>
  80394f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803952:	8b 40 04             	mov    0x4(%eax),%eax
  803955:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80395a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80395d:	8b 40 04             	mov    0x4(%eax),%eax
  803960:	85 c0                	test   %eax,%eax
  803962:	74 0f                	je     803973 <alloc_block+0x1f6>
  803964:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803967:	8b 40 04             	mov    0x4(%eax),%eax
  80396a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80396d:	8b 12                	mov    (%edx),%edx
  80396f:	89 10                	mov    %edx,(%eax)
  803971:	eb 0a                	jmp    80397d <alloc_block+0x200>
  803973:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803976:	8b 00                	mov    (%eax),%eax
  803978:	a3 48 60 80 00       	mov    %eax,0x806048
  80397d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803986:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803989:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803990:	a1 54 60 80 00       	mov    0x806054,%eax
  803995:	48                   	dec    %eax
  803996:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  80399b:	83 ec 0c             	sub    $0xc,%esp
  80399e:	ff 75 dc             	pushl  -0x24(%ebp)
  8039a1:	e8 89 fb ff ff       	call   80352f <to_page_va>
  8039a6:	83 c4 10             	add    $0x10,%esp
  8039a9:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  8039ac:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8039b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039b4:	29 c2                	sub    %eax,%edx
  8039b6:	89 d0                	mov    %edx,%eax
  8039b8:	c1 e8 0c             	shr    $0xc,%eax
  8039bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  8039be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039c1:	83 ec 0c             	sub    $0xc,%esp
  8039c4:	50                   	push   %eax
  8039c5:	e8 fe dc ff ff       	call   8016c8 <get_page>
  8039ca:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  8039cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d0:	89 c2                	mov    %eax,%edx
  8039d2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8039d5:	89 c8                	mov    %ecx,%eax
  8039d7:	01 c0                	add    %eax,%eax
  8039d9:	01 c8                	add    %ecx,%eax
  8039db:	c1 e0 02             	shl    $0x2,%eax
  8039de:	05 68 60 80 00       	add    $0x806068,%eax
  8039e3:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  8039e6:	b8 00 10 00 00       	mov    $0x1000,%eax
  8039eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8039f0:	f7 75 08             	divl   0x8(%ebp)
  8039f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  8039f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039fc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8039ff:	89 c8                	mov    %ecx,%eax
  803a01:	01 c0                	add    %eax,%eax
  803a03:	01 c8                	add    %ecx,%eax
  803a05:	c1 e0 02             	shl    $0x2,%eax
  803a08:	05 6a 60 80 00       	add    $0x80606a,%eax
  803a0d:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803a10:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803a17:	e9 aa 00 00 00       	jmp    803ac6 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1f:	0f af 45 08          	imul   0x8(%ebp),%eax
  803a23:	89 c2                	mov    %eax,%edx
  803a25:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a28:	01 d0                	add    %edx,%eax
  803a2a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803a2d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803a31:	75 17                	jne    803a4a <alloc_block+0x2cd>
  803a33:	83 ec 04             	sub    $0x4,%esp
  803a36:	68 0c 4f 80 00       	push   $0x804f0c
  803a3b:	68 9d 00 00 00       	push   $0x9d
  803a40:	68 b3 4e 80 00       	push   $0x804eb3
  803a45:	e8 20 ca ff ff       	call   80046a <_panic>
  803a4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4d:	c1 e0 04             	shl    $0x4,%eax
  803a50:	05 84 e0 81 00       	add    $0x81e084,%eax
  803a55:	8b 10                	mov    (%eax),%edx
  803a57:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a5a:	89 50 04             	mov    %edx,0x4(%eax)
  803a5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a60:	8b 40 04             	mov    0x4(%eax),%eax
  803a63:	85 c0                	test   %eax,%eax
  803a65:	74 14                	je     803a7b <alloc_block+0x2fe>
  803a67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6a:	c1 e0 04             	shl    $0x4,%eax
  803a6d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803a72:	8b 00                	mov    (%eax),%eax
  803a74:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803a77:	89 10                	mov    %edx,(%eax)
  803a79:	eb 11                	jmp    803a8c <alloc_block+0x30f>
  803a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7e:	c1 e0 04             	shl    $0x4,%eax
  803a81:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803a87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a8a:	89 02                	mov    %eax,(%edx)
  803a8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8f:	c1 e0 04             	shl    $0x4,%eax
  803a92:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803a98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a9b:	89 02                	mov    %eax,(%edx)
  803a9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa9:	c1 e0 04             	shl    $0x4,%eax
  803aac:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ab1:	8b 00                	mov    (%eax),%eax
  803ab3:	8d 50 01             	lea    0x1(%eax),%edx
  803ab6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab9:	c1 e0 04             	shl    $0x4,%eax
  803abc:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ac1:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803ac3:	ff 45 f0             	incl   -0x10(%ebp)
  803ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803acc:	0f 8c 4a ff ff ff    	jl     803a1c <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803ad2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ad5:	e9 3d 01 00 00       	jmp    803c17 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803ada:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803add:	40                   	inc    %eax
  803ade:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803ae1:	e9 10 01 00 00       	jmp    803bf6 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ae9:	c1 e0 04             	shl    $0x4,%eax
  803aec:	05 80 e0 81 00       	add    $0x81e080,%eax
  803af1:	8b 00                	mov    (%eax),%eax
  803af3:	85 c0                	test   %eax,%eax
  803af5:	0f 84 f8 00 00 00    	je     803bf3 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803afe:	c1 e0 04             	shl    $0x4,%eax
  803b01:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b06:	8b 00                	mov    (%eax),%eax
  803b08:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803b0b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b0f:	75 17                	jne    803b28 <alloc_block+0x3ab>
  803b11:	83 ec 04             	sub    $0x4,%esp
  803b14:	68 ed 4e 80 00       	push   $0x804eed
  803b19:	68 a8 00 00 00       	push   $0xa8
  803b1e:	68 b3 4e 80 00       	push   $0x804eb3
  803b23:	e8 42 c9 ff ff       	call   80046a <_panic>
  803b28:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b2b:	8b 00                	mov    (%eax),%eax
  803b2d:	85 c0                	test   %eax,%eax
  803b2f:	74 10                	je     803b41 <alloc_block+0x3c4>
  803b31:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b34:	8b 00                	mov    (%eax),%eax
  803b36:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b39:	8b 52 04             	mov    0x4(%edx),%edx
  803b3c:	89 50 04             	mov    %edx,0x4(%eax)
  803b3f:	eb 14                	jmp    803b55 <alloc_block+0x3d8>
  803b41:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b44:	8b 40 04             	mov    0x4(%eax),%eax
  803b47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b4a:	c1 e2 04             	shl    $0x4,%edx
  803b4d:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803b53:	89 02                	mov    %eax,(%edx)
  803b55:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b58:	8b 40 04             	mov    0x4(%eax),%eax
  803b5b:	85 c0                	test   %eax,%eax
  803b5d:	74 0f                	je     803b6e <alloc_block+0x3f1>
  803b5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b62:	8b 40 04             	mov    0x4(%eax),%eax
  803b65:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b68:	8b 12                	mov    (%edx),%edx
  803b6a:	89 10                	mov    %edx,(%eax)
  803b6c:	eb 13                	jmp    803b81 <alloc_block+0x404>
  803b6e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b71:	8b 00                	mov    (%eax),%eax
  803b73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b76:	c1 e2 04             	shl    $0x4,%edx
  803b79:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803b7f:	89 02                	mov    %eax,(%edx)
  803b81:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b8a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b97:	c1 e0 04             	shl    $0x4,%eax
  803b9a:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803b9f:	8b 00                	mov    (%eax),%eax
  803ba1:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ba7:	c1 e0 04             	shl    $0x4,%eax
  803baa:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803baf:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803bb1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bb4:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803bb9:	29 c2                	sub    %eax,%edx
  803bbb:	89 d0                	mov    %edx,%eax
  803bbd:	c1 e8 0c             	shr    $0xc,%eax
  803bc0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803bc3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803bc6:	89 d0                	mov    %edx,%eax
  803bc8:	01 c0                	add    %eax,%eax
  803bca:	01 d0                	add    %edx,%eax
  803bcc:	c1 e0 02             	shl    $0x2,%eax
  803bcf:	05 6a 60 80 00       	add    $0x80606a,%eax
  803bd4:	66 8b 00             	mov    (%eax),%ax
  803bd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  803bda:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803bdd:	89 c8                	mov    %ecx,%eax
  803bdf:	01 c0                	add    %eax,%eax
  803be1:	01 c8                	add    %ecx,%eax
  803be3:	c1 e0 02             	shl    $0x2,%eax
  803be6:	05 6a 60 80 00       	add    $0x80606a,%eax
  803beb:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803bee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bf1:	eb 24                	jmp    803c17 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803bf3:	ff 45 ec             	incl   -0x14(%ebp)
  803bf6:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803bfa:	0f 8e e6 fe ff ff    	jle    803ae6 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803c00:	83 ec 04             	sub    $0x4,%esp
  803c03:	68 2f 4f 80 00       	push   $0x804f2f
  803c08:	68 b1 00 00 00       	push   $0xb1
  803c0d:	68 b3 4e 80 00       	push   $0x804eb3
  803c12:	e8 53 c8 ff ff       	call   80046a <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803c17:	c9                   	leave  
  803c18:	c3                   	ret    

00803c19 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803c19:	55                   	push   %ebp
  803c1a:	89 e5                	mov    %esp,%ebp
  803c1c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803c1f:	8b 55 08             	mov    0x8(%ebp),%edx
  803c22:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c27:	39 c2                	cmp    %eax,%edx
  803c29:	72 0c                	jb     803c37 <free_block+0x1e>
  803c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  803c2e:	a1 40 60 80 00       	mov    0x806040,%eax
  803c33:	39 c2                	cmp    %eax,%edx
  803c35:	72 19                	jb     803c50 <free_block+0x37>
  803c37:	68 4c 4f 80 00       	push   $0x804f4c
  803c3c:	68 9e 4e 80 00       	push   $0x804e9e
  803c41:	68 c3 00 00 00       	push   $0xc3
  803c46:	68 b3 4e 80 00       	push   $0x804eb3
  803c4b:	e8 1a c8 ff ff       	call   80046a <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803c50:	8b 55 08             	mov    0x8(%ebp),%edx
  803c53:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c58:	29 c2                	sub    %eax,%edx
  803c5a:	89 d0                	mov    %edx,%eax
  803c5c:	c1 e8 0c             	shr    $0xc,%eax
  803c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803c62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c65:	89 d0                	mov    %edx,%eax
  803c67:	01 c0                	add    %eax,%eax
  803c69:	01 d0                	add    %edx,%eax
  803c6b:	c1 e0 02             	shl    $0x2,%eax
  803c6e:	05 68 60 80 00       	add    $0x806068,%eax
  803c73:	8b 00                	mov    (%eax),%eax
  803c75:	0f b7 c0             	movzwl %ax,%eax
  803c78:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803c7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c7f:	75 17                	jne    803c98 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803c81:	83 ec 04             	sub    $0x4,%esp
  803c84:	68 84 4f 80 00       	push   $0x804f84
  803c89:	68 cf 00 00 00       	push   $0xcf
  803c8e:	68 b3 4e 80 00       	push   $0x804eb3
  803c93:	e8 d2 c7 ff ff       	call   80046a <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803c98:	83 ec 0c             	sub    $0xc,%esp
  803c9b:	ff 75 ec             	pushl  -0x14(%ebp)
  803c9e:	e8 d8 f8 ff ff       	call   80357b <log2>
  803ca3:	83 c4 10             	add    $0x10,%esp
  803ca6:	83 e8 03             	sub    $0x3,%eax
  803ca9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803cac:	8b 45 08             	mov    0x8(%ebp),%eax
  803caf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803cb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cb6:	75 17                	jne    803ccf <free_block+0xb6>
  803cb8:	83 ec 04             	sub    $0x4,%esp
  803cbb:	68 0c 4f 80 00       	push   $0x804f0c
  803cc0:	68 d5 00 00 00       	push   $0xd5
  803cc5:	68 b3 4e 80 00       	push   $0x804eb3
  803cca:	e8 9b c7 ff ff       	call   80046a <_panic>
  803ccf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd2:	c1 e0 04             	shl    $0x4,%eax
  803cd5:	05 84 e0 81 00       	add    $0x81e084,%eax
  803cda:	8b 10                	mov    (%eax),%edx
  803cdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cdf:	89 50 04             	mov    %edx,0x4(%eax)
  803ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce5:	8b 40 04             	mov    0x4(%eax),%eax
  803ce8:	85 c0                	test   %eax,%eax
  803cea:	74 14                	je     803d00 <free_block+0xe7>
  803cec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cef:	c1 e0 04             	shl    $0x4,%eax
  803cf2:	05 84 e0 81 00       	add    $0x81e084,%eax
  803cf7:	8b 00                	mov    (%eax),%eax
  803cf9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cfc:	89 10                	mov    %edx,(%eax)
  803cfe:	eb 11                	jmp    803d11 <free_block+0xf8>
  803d00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d03:	c1 e0 04             	shl    $0x4,%eax
  803d06:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803d0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0f:	89 02                	mov    %eax,(%edx)
  803d11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d14:	c1 e0 04             	shl    $0x4,%eax
  803d17:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803d1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d20:	89 02                	mov    %eax,(%edx)
  803d22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d2e:	c1 e0 04             	shl    $0x4,%eax
  803d31:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d36:	8b 00                	mov    (%eax),%eax
  803d38:	8d 50 01             	lea    0x1(%eax),%edx
  803d3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3e:	c1 e0 04             	shl    $0x4,%eax
  803d41:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d46:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803d48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d4b:	89 d0                	mov    %edx,%eax
  803d4d:	01 c0                	add    %eax,%eax
  803d4f:	01 d0                	add    %edx,%eax
  803d51:	c1 e0 02             	shl    $0x2,%eax
  803d54:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d59:	66 8b 00             	mov    (%eax),%ax
  803d5c:	8d 50 01             	lea    0x1(%eax),%edx
  803d5f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803d62:	89 c8                	mov    %ecx,%eax
  803d64:	01 c0                	add    %eax,%eax
  803d66:	01 c8                	add    %ecx,%eax
  803d68:	c1 e0 02             	shl    $0x2,%eax
  803d6b:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d70:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803d73:	b8 00 10 00 00       	mov    $0x1000,%eax
  803d78:	ba 00 00 00 00       	mov    $0x0,%edx
  803d7d:	f7 75 ec             	divl   -0x14(%ebp)
  803d80:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803d83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d86:	89 d0                	mov    %edx,%eax
  803d88:	01 c0                	add    %eax,%eax
  803d8a:	01 d0                	add    %edx,%eax
  803d8c:	c1 e0 02             	shl    $0x2,%eax
  803d8f:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d94:	66 8b 00             	mov    (%eax),%ax
  803d97:	0f b7 c0             	movzwl %ax,%eax
  803d9a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d9d:	0f 85 d3 01 00 00    	jne    803f76 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803da6:	c1 e0 04             	shl    $0x4,%eax
  803da9:	05 80 e0 81 00       	add    $0x81e080,%eax
  803dae:	8b 00                	mov    (%eax),%eax
  803db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803db3:	e9 f1 00 00 00       	jmp    803ea9 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbb:	8b 00                	mov    (%eax),%eax
  803dbd:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc3:	c1 e0 0c             	shl    $0xc,%eax
  803dc6:	89 c2                	mov    %eax,%edx
  803dc8:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803dcd:	01 d0                	add    %edx,%eax
  803dcf:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd5:	40                   	inc    %eax
  803dd6:	c1 e0 0c             	shl    $0xc,%eax
  803dd9:	89 c2                	mov    %eax,%edx
  803ddb:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803de0:	01 d0                	add    %edx,%eax
  803de2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803deb:	0f 82 b8 00 00 00    	jb     803ea9 <free_block+0x290>
  803df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803df7:	0f 83 ac 00 00 00    	jae    803ea9 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e01:	75 17                	jne    803e1a <free_block+0x201>
  803e03:	83 ec 04             	sub    $0x4,%esp
  803e06:	68 ed 4e 80 00       	push   $0x804eed
  803e0b:	68 e2 00 00 00       	push   $0xe2
  803e10:	68 b3 4e 80 00       	push   $0x804eb3
  803e15:	e8 50 c6 ff ff       	call   80046a <_panic>
  803e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1d:	8b 00                	mov    (%eax),%eax
  803e1f:	85 c0                	test   %eax,%eax
  803e21:	74 10                	je     803e33 <free_block+0x21a>
  803e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e26:	8b 00                	mov    (%eax),%eax
  803e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e2b:	8b 52 04             	mov    0x4(%edx),%edx
  803e2e:	89 50 04             	mov    %edx,0x4(%eax)
  803e31:	eb 14                	jmp    803e47 <free_block+0x22e>
  803e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e36:	8b 40 04             	mov    0x4(%eax),%eax
  803e39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e3c:	c1 e2 04             	shl    $0x4,%edx
  803e3f:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803e45:	89 02                	mov    %eax,(%edx)
  803e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4a:	8b 40 04             	mov    0x4(%eax),%eax
  803e4d:	85 c0                	test   %eax,%eax
  803e4f:	74 0f                	je     803e60 <free_block+0x247>
  803e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e54:	8b 40 04             	mov    0x4(%eax),%eax
  803e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e5a:	8b 12                	mov    (%edx),%edx
  803e5c:	89 10                	mov    %edx,(%eax)
  803e5e:	eb 13                	jmp    803e73 <free_block+0x25a>
  803e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e63:	8b 00                	mov    (%eax),%eax
  803e65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e68:	c1 e2 04             	shl    $0x4,%edx
  803e6b:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803e71:	89 02                	mov    %eax,(%edx)
  803e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e89:	c1 e0 04             	shl    $0x4,%eax
  803e8c:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803e91:	8b 00                	mov    (%eax),%eax
  803e93:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e99:	c1 e0 04             	shl    $0x4,%eax
  803e9c:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ea1:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803ea3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803ea9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ead:	0f 85 05 ff ff ff    	jne    803db8 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803eb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803eb6:	89 d0                	mov    %edx,%eax
  803eb8:	01 c0                	add    %eax,%eax
  803eba:	01 d0                	add    %edx,%eax
  803ebc:	c1 e0 02             	shl    $0x2,%eax
  803ebf:	05 68 60 80 00       	add    $0x806068,%eax
  803ec4:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803ec9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ecc:	89 d0                	mov    %edx,%eax
  803ece:	01 c0                	add    %eax,%eax
  803ed0:	01 d0                	add    %edx,%eax
  803ed2:	c1 e0 02             	shl    $0x2,%eax
  803ed5:	05 6a 60 80 00       	add    $0x80606a,%eax
  803eda:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803edf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ee2:	89 d0                	mov    %edx,%eax
  803ee4:	01 c0                	add    %eax,%eax
  803ee6:	01 d0                	add    %edx,%eax
  803ee8:	c1 e0 02             	shl    $0x2,%eax
  803eeb:	05 60 60 80 00       	add    $0x806060,%eax
  803ef0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803ef3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ef7:	75 17                	jne    803f10 <free_block+0x2f7>
  803ef9:	83 ec 04             	sub    $0x4,%esp
  803efc:	68 0c 4f 80 00       	push   $0x804f0c
  803f01:	68 eb 00 00 00       	push   $0xeb
  803f06:	68 b3 4e 80 00       	push   $0x804eb3
  803f0b:	e8 5a c5 ff ff       	call   80046a <_panic>
  803f10:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803f16:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f19:	89 50 04             	mov    %edx,0x4(%eax)
  803f1c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f1f:	8b 40 04             	mov    0x4(%eax),%eax
  803f22:	85 c0                	test   %eax,%eax
  803f24:	74 0c                	je     803f32 <free_block+0x319>
  803f26:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803f2b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f2e:	89 10                	mov    %edx,(%eax)
  803f30:	eb 08                	jmp    803f3a <free_block+0x321>
  803f32:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f35:	a3 48 60 80 00       	mov    %eax,0x806048
  803f3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f3d:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803f42:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f4b:	a1 54 60 80 00       	mov    0x806054,%eax
  803f50:	40                   	inc    %eax
  803f51:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803f56:	83 ec 0c             	sub    $0xc,%esp
  803f59:	ff 75 d0             	pushl  -0x30(%ebp)
  803f5c:	e8 ce f5 ff ff       	call   80352f <to_page_va>
  803f61:	83 c4 10             	add    $0x10,%esp
  803f64:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803f67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f6a:	83 ec 0c             	sub    $0xc,%esp
  803f6d:	50                   	push   %eax
  803f6e:	e8 9e d7 ff ff       	call   801711 <return_page>
  803f73:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803f76:	90                   	nop
  803f77:	c9                   	leave  
  803f78:	c3                   	ret    

00803f79 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803f79:	55                   	push   %ebp
  803f7a:	89 e5                	mov    %esp,%ebp
  803f7c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803f7f:	83 ec 04             	sub    $0x4,%esp
  803f82:	68 ac 4f 80 00       	push   $0x804fac
  803f87:	68 01 01 00 00       	push   $0x101
  803f8c:	68 b3 4e 80 00       	push   $0x804eb3
  803f91:	e8 d4 c4 ff ff       	call   80046a <_panic>

00803f96 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803f96:	55                   	push   %ebp
  803f97:	89 e5                	mov    %esp,%ebp
  803f99:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  803f9f:	89 d0                	mov    %edx,%eax
  803fa1:	c1 e0 02             	shl    $0x2,%eax
  803fa4:	01 d0                	add    %edx,%eax
  803fa6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803fad:	01 d0                	add    %edx,%eax
  803faf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803fb6:	01 d0                	add    %edx,%eax
  803fb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803fbf:	01 d0                	add    %edx,%eax
  803fc1:	c1 e0 04             	shl    $0x4,%eax
  803fc4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803fc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803fce:	0f 31                	rdtsc  
  803fd0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803fd3:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803fd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803fdf:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803fe2:	eb 46                	jmp    80402a <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803fe4:	0f 31                	rdtsc  
  803fe6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803fe9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803fec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ff2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  803ff5:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803ff8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ffe:	29 c2                	sub    %eax,%edx
  804000:	89 d0                	mov    %edx,%eax
  804002:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804005:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80400b:	89 d1                	mov    %edx,%ecx
  80400d:	29 c1                	sub    %eax,%ecx
  80400f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804012:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804015:	39 c2                	cmp    %eax,%edx
  804017:	0f 97 c0             	seta   %al
  80401a:	0f b6 c0             	movzbl %al,%eax
  80401d:	29 c1                	sub    %eax,%ecx
  80401f:	89 c8                	mov    %ecx,%eax
  804021:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804024:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804027:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80402a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80402d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804030:	72 b2                	jb     803fe4 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804032:	90                   	nop
  804033:	c9                   	leave  
  804034:	c3                   	ret    

00804035 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804035:	55                   	push   %ebp
  804036:	89 e5                	mov    %esp,%ebp
  804038:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80403b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804042:	eb 03                	jmp    804047 <busy_wait+0x12>
  804044:	ff 45 fc             	incl   -0x4(%ebp)
  804047:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80404a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80404d:	72 f5                	jb     804044 <busy_wait+0xf>
	return i;
  80404f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804052:	c9                   	leave  
  804053:	c3                   	ret    

00804054 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  804054:	55                   	push   %ebp
  804055:	89 e5                	mov    %esp,%ebp
  804057:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  80405a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80405e:	74 1c                	je     80407c <init_uspinlock+0x28>
  804060:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  804064:	74 16                	je     80407c <init_uspinlock+0x28>
  804066:	68 d0 4f 80 00       	push   $0x804fd0
  80406b:	68 ef 4f 80 00       	push   $0x804fef
  804070:	6a 10                	push   $0x10
  804072:	68 04 50 80 00       	push   $0x805004
  804077:	e8 ee c3 ff ff       	call   80046a <_panic>
	strcpy(lk->name, name);
  80407c:	8b 45 08             	mov    0x8(%ebp),%eax
  80407f:	83 c0 04             	add    $0x4,%eax
  804082:	83 ec 08             	sub    $0x8,%esp
  804085:	ff 75 0c             	pushl  0xc(%ebp)
  804088:	50                   	push   %eax
  804089:	e8 d2 cd ff ff       	call   800e60 <strcpy>
  80408e:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  804091:	b8 01 00 00 00       	mov    $0x1,%eax
  804096:	2b 45 10             	sub    0x10(%ebp),%eax
  804099:	89 c2                	mov    %eax,%edx
  80409b:	8b 45 08             	mov    0x8(%ebp),%eax
  80409e:	89 10                	mov    %edx,(%eax)
}
  8040a0:	90                   	nop
  8040a1:	c9                   	leave  
  8040a2:	c3                   	ret    

008040a3 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8040a3:	55                   	push   %ebp
  8040a4:	89 e5                	mov    %esp,%ebp
  8040a6:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  8040a9:	90                   	nop
  8040aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8040b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040bd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8040c0:	f0 87 02             	lock xchg %eax,(%edx)
  8040c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  8040c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040c9:	85 c0                	test   %eax,%eax
  8040cb:	75 dd                	jne    8040aa <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8040cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d0:	8d 48 04             	lea    0x4(%eax),%ecx
  8040d3:	a1 20 60 80 00       	mov    0x806020,%eax
  8040d8:	8d 50 20             	lea    0x20(%eax),%edx
  8040db:	a1 20 60 80 00       	mov    0x806020,%eax
  8040e0:	8b 40 10             	mov    0x10(%eax),%eax
  8040e3:	51                   	push   %ecx
  8040e4:	52                   	push   %edx
  8040e5:	50                   	push   %eax
  8040e6:	68 14 50 80 00       	push   $0x805014
  8040eb:	e8 48 c6 ff ff       	call   800738 <cprintf>
  8040f0:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8040f3:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8040f8:	90                   	nop
  8040f9:	c9                   	leave  
  8040fa:	c3                   	ret    

008040fb <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8040fb:	55                   	push   %ebp
  8040fc:	89 e5                	mov    %esp,%ebp
  8040fe:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  804101:	8b 45 08             	mov    0x8(%ebp),%eax
  804104:	8b 00                	mov    (%eax),%eax
  804106:	85 c0                	test   %eax,%eax
  804108:	75 18                	jne    804122 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  80410a:	8b 45 08             	mov    0x8(%ebp),%eax
  80410d:	83 c0 04             	add    $0x4,%eax
  804110:	50                   	push   %eax
  804111:	68 38 50 80 00       	push   $0x805038
  804116:	6a 2b                	push   $0x2b
  804118:	68 04 50 80 00       	push   $0x805004
  80411d:	e8 48 c3 ff ff       	call   80046a <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  804122:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  804127:	8b 45 08             	mov    0x8(%ebp),%eax
  80412a:	8b 55 08             	mov    0x8(%ebp),%edx
  80412d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804133:	8b 45 08             	mov    0x8(%ebp),%eax
  804136:	8d 48 04             	lea    0x4(%eax),%ecx
  804139:	a1 20 60 80 00       	mov    0x806020,%eax
  80413e:	8d 50 20             	lea    0x20(%eax),%edx
  804141:	a1 20 60 80 00       	mov    0x806020,%eax
  804146:	8b 40 10             	mov    0x10(%eax),%eax
  804149:	51                   	push   %ecx
  80414a:	52                   	push   %edx
  80414b:	50                   	push   %eax
  80414c:	68 58 50 80 00       	push   $0x805058
  804151:	e8 e2 c5 ff ff       	call   800738 <cprintf>
  804156:	83 c4 10             	add    $0x10,%esp
}
  804159:	90                   	nop
  80415a:	c9                   	leave  
  80415b:	c3                   	ret    

0080415c <__udivdi3>:
  80415c:	55                   	push   %ebp
  80415d:	57                   	push   %edi
  80415e:	56                   	push   %esi
  80415f:	53                   	push   %ebx
  804160:	83 ec 1c             	sub    $0x1c,%esp
  804163:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804167:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80416b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80416f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804173:	89 ca                	mov    %ecx,%edx
  804175:	89 f8                	mov    %edi,%eax
  804177:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80417b:	85 f6                	test   %esi,%esi
  80417d:	75 2d                	jne    8041ac <__udivdi3+0x50>
  80417f:	39 cf                	cmp    %ecx,%edi
  804181:	77 65                	ja     8041e8 <__udivdi3+0x8c>
  804183:	89 fd                	mov    %edi,%ebp
  804185:	85 ff                	test   %edi,%edi
  804187:	75 0b                	jne    804194 <__udivdi3+0x38>
  804189:	b8 01 00 00 00       	mov    $0x1,%eax
  80418e:	31 d2                	xor    %edx,%edx
  804190:	f7 f7                	div    %edi
  804192:	89 c5                	mov    %eax,%ebp
  804194:	31 d2                	xor    %edx,%edx
  804196:	89 c8                	mov    %ecx,%eax
  804198:	f7 f5                	div    %ebp
  80419a:	89 c1                	mov    %eax,%ecx
  80419c:	89 d8                	mov    %ebx,%eax
  80419e:	f7 f5                	div    %ebp
  8041a0:	89 cf                	mov    %ecx,%edi
  8041a2:	89 fa                	mov    %edi,%edx
  8041a4:	83 c4 1c             	add    $0x1c,%esp
  8041a7:	5b                   	pop    %ebx
  8041a8:	5e                   	pop    %esi
  8041a9:	5f                   	pop    %edi
  8041aa:	5d                   	pop    %ebp
  8041ab:	c3                   	ret    
  8041ac:	39 ce                	cmp    %ecx,%esi
  8041ae:	77 28                	ja     8041d8 <__udivdi3+0x7c>
  8041b0:	0f bd fe             	bsr    %esi,%edi
  8041b3:	83 f7 1f             	xor    $0x1f,%edi
  8041b6:	75 40                	jne    8041f8 <__udivdi3+0x9c>
  8041b8:	39 ce                	cmp    %ecx,%esi
  8041ba:	72 0a                	jb     8041c6 <__udivdi3+0x6a>
  8041bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8041c0:	0f 87 9e 00 00 00    	ja     804264 <__udivdi3+0x108>
  8041c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8041cb:	89 fa                	mov    %edi,%edx
  8041cd:	83 c4 1c             	add    $0x1c,%esp
  8041d0:	5b                   	pop    %ebx
  8041d1:	5e                   	pop    %esi
  8041d2:	5f                   	pop    %edi
  8041d3:	5d                   	pop    %ebp
  8041d4:	c3                   	ret    
  8041d5:	8d 76 00             	lea    0x0(%esi),%esi
  8041d8:	31 ff                	xor    %edi,%edi
  8041da:	31 c0                	xor    %eax,%eax
  8041dc:	89 fa                	mov    %edi,%edx
  8041de:	83 c4 1c             	add    $0x1c,%esp
  8041e1:	5b                   	pop    %ebx
  8041e2:	5e                   	pop    %esi
  8041e3:	5f                   	pop    %edi
  8041e4:	5d                   	pop    %ebp
  8041e5:	c3                   	ret    
  8041e6:	66 90                	xchg   %ax,%ax
  8041e8:	89 d8                	mov    %ebx,%eax
  8041ea:	f7 f7                	div    %edi
  8041ec:	31 ff                	xor    %edi,%edi
  8041ee:	89 fa                	mov    %edi,%edx
  8041f0:	83 c4 1c             	add    $0x1c,%esp
  8041f3:	5b                   	pop    %ebx
  8041f4:	5e                   	pop    %esi
  8041f5:	5f                   	pop    %edi
  8041f6:	5d                   	pop    %ebp
  8041f7:	c3                   	ret    
  8041f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8041fd:	89 eb                	mov    %ebp,%ebx
  8041ff:	29 fb                	sub    %edi,%ebx
  804201:	89 f9                	mov    %edi,%ecx
  804203:	d3 e6                	shl    %cl,%esi
  804205:	89 c5                	mov    %eax,%ebp
  804207:	88 d9                	mov    %bl,%cl
  804209:	d3 ed                	shr    %cl,%ebp
  80420b:	89 e9                	mov    %ebp,%ecx
  80420d:	09 f1                	or     %esi,%ecx
  80420f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804213:	89 f9                	mov    %edi,%ecx
  804215:	d3 e0                	shl    %cl,%eax
  804217:	89 c5                	mov    %eax,%ebp
  804219:	89 d6                	mov    %edx,%esi
  80421b:	88 d9                	mov    %bl,%cl
  80421d:	d3 ee                	shr    %cl,%esi
  80421f:	89 f9                	mov    %edi,%ecx
  804221:	d3 e2                	shl    %cl,%edx
  804223:	8b 44 24 08          	mov    0x8(%esp),%eax
  804227:	88 d9                	mov    %bl,%cl
  804229:	d3 e8                	shr    %cl,%eax
  80422b:	09 c2                	or     %eax,%edx
  80422d:	89 d0                	mov    %edx,%eax
  80422f:	89 f2                	mov    %esi,%edx
  804231:	f7 74 24 0c          	divl   0xc(%esp)
  804235:	89 d6                	mov    %edx,%esi
  804237:	89 c3                	mov    %eax,%ebx
  804239:	f7 e5                	mul    %ebp
  80423b:	39 d6                	cmp    %edx,%esi
  80423d:	72 19                	jb     804258 <__udivdi3+0xfc>
  80423f:	74 0b                	je     80424c <__udivdi3+0xf0>
  804241:	89 d8                	mov    %ebx,%eax
  804243:	31 ff                	xor    %edi,%edi
  804245:	e9 58 ff ff ff       	jmp    8041a2 <__udivdi3+0x46>
  80424a:	66 90                	xchg   %ax,%ax
  80424c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804250:	89 f9                	mov    %edi,%ecx
  804252:	d3 e2                	shl    %cl,%edx
  804254:	39 c2                	cmp    %eax,%edx
  804256:	73 e9                	jae    804241 <__udivdi3+0xe5>
  804258:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80425b:	31 ff                	xor    %edi,%edi
  80425d:	e9 40 ff ff ff       	jmp    8041a2 <__udivdi3+0x46>
  804262:	66 90                	xchg   %ax,%ax
  804264:	31 c0                	xor    %eax,%eax
  804266:	e9 37 ff ff ff       	jmp    8041a2 <__udivdi3+0x46>
  80426b:	90                   	nop

0080426c <__umoddi3>:
  80426c:	55                   	push   %ebp
  80426d:	57                   	push   %edi
  80426e:	56                   	push   %esi
  80426f:	53                   	push   %ebx
  804270:	83 ec 1c             	sub    $0x1c,%esp
  804273:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804277:	8b 74 24 34          	mov    0x34(%esp),%esi
  80427b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80427f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804283:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804287:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80428b:	89 f3                	mov    %esi,%ebx
  80428d:	89 fa                	mov    %edi,%edx
  80428f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804293:	89 34 24             	mov    %esi,(%esp)
  804296:	85 c0                	test   %eax,%eax
  804298:	75 1a                	jne    8042b4 <__umoddi3+0x48>
  80429a:	39 f7                	cmp    %esi,%edi
  80429c:	0f 86 a2 00 00 00    	jbe    804344 <__umoddi3+0xd8>
  8042a2:	89 c8                	mov    %ecx,%eax
  8042a4:	89 f2                	mov    %esi,%edx
  8042a6:	f7 f7                	div    %edi
  8042a8:	89 d0                	mov    %edx,%eax
  8042aa:	31 d2                	xor    %edx,%edx
  8042ac:	83 c4 1c             	add    $0x1c,%esp
  8042af:	5b                   	pop    %ebx
  8042b0:	5e                   	pop    %esi
  8042b1:	5f                   	pop    %edi
  8042b2:	5d                   	pop    %ebp
  8042b3:	c3                   	ret    
  8042b4:	39 f0                	cmp    %esi,%eax
  8042b6:	0f 87 ac 00 00 00    	ja     804368 <__umoddi3+0xfc>
  8042bc:	0f bd e8             	bsr    %eax,%ebp
  8042bf:	83 f5 1f             	xor    $0x1f,%ebp
  8042c2:	0f 84 ac 00 00 00    	je     804374 <__umoddi3+0x108>
  8042c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8042cd:	29 ef                	sub    %ebp,%edi
  8042cf:	89 fe                	mov    %edi,%esi
  8042d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042d5:	89 e9                	mov    %ebp,%ecx
  8042d7:	d3 e0                	shl    %cl,%eax
  8042d9:	89 d7                	mov    %edx,%edi
  8042db:	89 f1                	mov    %esi,%ecx
  8042dd:	d3 ef                	shr    %cl,%edi
  8042df:	09 c7                	or     %eax,%edi
  8042e1:	89 e9                	mov    %ebp,%ecx
  8042e3:	d3 e2                	shl    %cl,%edx
  8042e5:	89 14 24             	mov    %edx,(%esp)
  8042e8:	89 d8                	mov    %ebx,%eax
  8042ea:	d3 e0                	shl    %cl,%eax
  8042ec:	89 c2                	mov    %eax,%edx
  8042ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042f2:	d3 e0                	shl    %cl,%eax
  8042f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042fc:	89 f1                	mov    %esi,%ecx
  8042fe:	d3 e8                	shr    %cl,%eax
  804300:	09 d0                	or     %edx,%eax
  804302:	d3 eb                	shr    %cl,%ebx
  804304:	89 da                	mov    %ebx,%edx
  804306:	f7 f7                	div    %edi
  804308:	89 d3                	mov    %edx,%ebx
  80430a:	f7 24 24             	mull   (%esp)
  80430d:	89 c6                	mov    %eax,%esi
  80430f:	89 d1                	mov    %edx,%ecx
  804311:	39 d3                	cmp    %edx,%ebx
  804313:	0f 82 87 00 00 00    	jb     8043a0 <__umoddi3+0x134>
  804319:	0f 84 91 00 00 00    	je     8043b0 <__umoddi3+0x144>
  80431f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804323:	29 f2                	sub    %esi,%edx
  804325:	19 cb                	sbb    %ecx,%ebx
  804327:	89 d8                	mov    %ebx,%eax
  804329:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80432d:	d3 e0                	shl    %cl,%eax
  80432f:	89 e9                	mov    %ebp,%ecx
  804331:	d3 ea                	shr    %cl,%edx
  804333:	09 d0                	or     %edx,%eax
  804335:	89 e9                	mov    %ebp,%ecx
  804337:	d3 eb                	shr    %cl,%ebx
  804339:	89 da                	mov    %ebx,%edx
  80433b:	83 c4 1c             	add    $0x1c,%esp
  80433e:	5b                   	pop    %ebx
  80433f:	5e                   	pop    %esi
  804340:	5f                   	pop    %edi
  804341:	5d                   	pop    %ebp
  804342:	c3                   	ret    
  804343:	90                   	nop
  804344:	89 fd                	mov    %edi,%ebp
  804346:	85 ff                	test   %edi,%edi
  804348:	75 0b                	jne    804355 <__umoddi3+0xe9>
  80434a:	b8 01 00 00 00       	mov    $0x1,%eax
  80434f:	31 d2                	xor    %edx,%edx
  804351:	f7 f7                	div    %edi
  804353:	89 c5                	mov    %eax,%ebp
  804355:	89 f0                	mov    %esi,%eax
  804357:	31 d2                	xor    %edx,%edx
  804359:	f7 f5                	div    %ebp
  80435b:	89 c8                	mov    %ecx,%eax
  80435d:	f7 f5                	div    %ebp
  80435f:	89 d0                	mov    %edx,%eax
  804361:	e9 44 ff ff ff       	jmp    8042aa <__umoddi3+0x3e>
  804366:	66 90                	xchg   %ax,%ax
  804368:	89 c8                	mov    %ecx,%eax
  80436a:	89 f2                	mov    %esi,%edx
  80436c:	83 c4 1c             	add    $0x1c,%esp
  80436f:	5b                   	pop    %ebx
  804370:	5e                   	pop    %esi
  804371:	5f                   	pop    %edi
  804372:	5d                   	pop    %ebp
  804373:	c3                   	ret    
  804374:	3b 04 24             	cmp    (%esp),%eax
  804377:	72 06                	jb     80437f <__umoddi3+0x113>
  804379:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80437d:	77 0f                	ja     80438e <__umoddi3+0x122>
  80437f:	89 f2                	mov    %esi,%edx
  804381:	29 f9                	sub    %edi,%ecx
  804383:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804387:	89 14 24             	mov    %edx,(%esp)
  80438a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80438e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804392:	8b 14 24             	mov    (%esp),%edx
  804395:	83 c4 1c             	add    $0x1c,%esp
  804398:	5b                   	pop    %ebx
  804399:	5e                   	pop    %esi
  80439a:	5f                   	pop    %edi
  80439b:	5d                   	pop    %ebp
  80439c:	c3                   	ret    
  80439d:	8d 76 00             	lea    0x0(%esi),%esi
  8043a0:	2b 04 24             	sub    (%esp),%eax
  8043a3:	19 fa                	sbb    %edi,%edx
  8043a5:	89 d1                	mov    %edx,%ecx
  8043a7:	89 c6                	mov    %eax,%esi
  8043a9:	e9 71 ff ff ff       	jmp    80431f <__umoddi3+0xb3>
  8043ae:	66 90                	xchg   %ax,%ax
  8043b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8043b4:	72 ea                	jb     8043a0 <__umoddi3+0x134>
  8043b6:	89 d9                	mov    %ebx,%ecx
  8043b8:	e9 62 ff ff ff       	jmp    80431f <__umoddi3+0xb3>
