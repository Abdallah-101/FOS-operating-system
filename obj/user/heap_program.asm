
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 12 02 00 00       	call   800248 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 7d 16 00 00       	call   8016e8 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 6c 16 00 00       	call   8016e8 <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 fe 2f 00 00       	call   803085 <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 f5 1a 00 00       	call   801be6 <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 e7 1a 00 00       	call   801be6 <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 33 2f 00 00       	call   80303a <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 d3 15 00 00       	call   8016e8 <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb 9c 43 80 00       	mov    $0x80439c,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	e9 81 00 00 00       	jmp    8001f1 <_main+0x1b9>
		{
			int found = 0 ;
  800170:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800177:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017e:	eb 3d                	jmp    8001bd <_main+0x185>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  800180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800183:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800187:	a1 20 50 80 00       	mov    0x805020,%eax
  80018c:	8b 98 a4 05 00 00    	mov    0x5a4(%eax),%ebx
  800192:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800195:	89 d0                	mov    %edx,%eax
  800197:	01 c0                	add    %eax,%eax
  800199:	01 d0                	add    %edx,%eax
  80019b:	c1 e0 03             	shl    $0x3,%eax
  80019e:	01 d8                	add    %ebx,%eax
  8001a0:	8b 00                	mov    (%eax),%eax
  8001a2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ad:	39 c1                	cmp    %eax,%ecx
  8001af:	75 09                	jne    8001ba <_main+0x182>
				{
					found = 1 ;
  8001b1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001b8:	eb 15                	jmp    8001cf <_main+0x197>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001ba:	ff 45 e0             	incl   -0x20(%ebp)
  8001bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8001c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001cb:	39 c2                	cmp    %eax,%edx
  8001cd:	77 b1                	ja     800180 <_main+0x148>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d3:	75 19                	jne    8001ee <_main+0x1b6>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d8:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001dc:	50                   	push   %eax
  8001dd:	68 a0 42 80 00       	push   $0x8042a0
  8001e2:	6a 4c                	push   $0x4c
  8001e4:	68 01 43 80 00       	push   $0x804301
  8001e9:	e8 13 02 00 00       	call   800401 <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001ee:	ff 45 e4             	incl   -0x1c(%ebp)
  8001f1:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001f5:	0f 8e 75 ff ff ff    	jle    800170 <_main+0x138>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  8001fb:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8001fe:	e8 37 2e 00 00       	call   80303a <sys_calculate_free_frames>
  800203:	29 c3                	sub    %eax,%ebx
  800205:	89 d8                	mov    %ebx,%eax
  800207:	83 f8 06             	cmp    $0x6,%eax
  80020a:	74 23                	je     80022f <_main+0x1f7>
  80020c:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  80020f:	e8 26 2e 00 00       	call   80303a <sys_calculate_free_frames>
  800214:	29 c3                	sub    %eax,%ebx
  800216:	89 d8                	mov    %ebx,%eax
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	6a 08                	push   $0x8
  80021d:	50                   	push   %eax
  80021e:	68 18 43 80 00       	push   $0x804318
  800223:	6a 4f                	push   $0x4f
  800225:	68 01 43 80 00       	push   $0x804301
  80022a:	e8 d2 01 00 00       	call   800401 <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	68 5c 43 80 00       	push   $0x80435c
  800237:	e8 93 04 00 00       	call   8006cf <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp


	return;
  80023f:	90                   	nop
}
  800240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800243:	5b                   	pop    %ebx
  800244:	5e                   	pop    %esi
  800245:	5f                   	pop    %edi
  800246:	5d                   	pop    %ebp
  800247:	c3                   	ret    

00800248 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	57                   	push   %edi
  80024c:	56                   	push   %esi
  80024d:	53                   	push   %ebx
  80024e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800251:	e8 ad 2f 00 00       	call   803203 <sys_getenvindex>
  800256:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800259:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80025c:	89 d0                	mov    %edx,%eax
  80025e:	c1 e0 02             	shl    $0x2,%eax
  800261:	01 d0                	add    %edx,%eax
  800263:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026a:	01 d0                	add    %edx,%eax
  80026c:	89 c2                	mov    %eax,%edx
  80026e:	c1 e2 04             	shl    $0x4,%edx
  800271:	29 c2                	sub    %eax,%edx
  800273:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80027a:	89 c2                	mov    %eax,%edx
  80027c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800282:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800287:	a1 20 50 80 00       	mov    0x805020,%eax
  80028c:	8a 40 20             	mov    0x20(%eax),%al
  80028f:	84 c0                	test   %al,%al
  800291:	74 0d                	je     8002a0 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800293:	a1 20 50 80 00       	mov    0x805020,%eax
  800298:	83 c0 20             	add    $0x20,%eax
  80029b:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a4:	7e 0a                	jle    8002b0 <libmain+0x68>
		binaryname = argv[0];
  8002a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a9:	8b 00                	mov    (%eax),%eax
  8002ab:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	ff 75 0c             	pushl  0xc(%ebp)
  8002b6:	ff 75 08             	pushl  0x8(%ebp)
  8002b9:	e8 7a fd ff ff       	call   800038 <_main>
  8002be:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002c1:	a1 00 50 80 00       	mov    0x805000,%eax
  8002c6:	85 c0                	test   %eax,%eax
  8002c8:	0f 84 01 01 00 00    	je     8003cf <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002ce:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002d4:	bb b0 44 80 00       	mov    $0x8044b0,%ebx
  8002d9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002de:	89 c7                	mov    %eax,%edi
  8002e0:	89 de                	mov    %ebx,%esi
  8002e2:	89 d1                	mov    %edx,%ecx
  8002e4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002e6:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002e9:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002ee:	b0 00                	mov    $0x0,%al
  8002f0:	89 d7                	mov    %edx,%edi
  8002f2:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002fe:	83 ec 08             	sub    $0x8,%esp
  800301:	50                   	push   %eax
  800302:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	e8 2b 31 00 00       	call   803439 <sys_utilities>
  80030e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800311:	e8 74 2c 00 00       	call   802f8a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800316:	83 ec 0c             	sub    $0xc,%esp
  800319:	68 d0 43 80 00       	push   $0x8043d0
  80031e:	e8 ac 03 00 00       	call   8006cf <cprintf>
  800323:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800326:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800329:	85 c0                	test   %eax,%eax
  80032b:	74 18                	je     800345 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80032d:	e8 25 31 00 00       	call   803457 <sys_get_optimal_num_faults>
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	50                   	push   %eax
  800336:	68 f8 43 80 00       	push   $0x8043f8
  80033b:	e8 8f 03 00 00       	call   8006cf <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
  800343:	eb 59                	jmp    80039e <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800345:	a1 20 50 80 00       	mov    0x805020,%eax
  80034a:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800350:	a1 20 50 80 00       	mov    0x805020,%eax
  800355:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80035b:	83 ec 04             	sub    $0x4,%esp
  80035e:	52                   	push   %edx
  80035f:	50                   	push   %eax
  800360:	68 1c 44 80 00       	push   $0x80441c
  800365:	e8 65 03 00 00       	call   8006cf <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80036d:	a1 20 50 80 00       	mov    0x805020,%eax
  800372:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800378:	a1 20 50 80 00       	mov    0x805020,%eax
  80037d:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800383:	a1 20 50 80 00       	mov    0x805020,%eax
  800388:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80038e:	51                   	push   %ecx
  80038f:	52                   	push   %edx
  800390:	50                   	push   %eax
  800391:	68 44 44 80 00       	push   $0x804444
  800396:	e8 34 03 00 00       	call   8006cf <cprintf>
  80039b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039e:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a3:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8003a9:	83 ec 08             	sub    $0x8,%esp
  8003ac:	50                   	push   %eax
  8003ad:	68 9c 44 80 00       	push   $0x80449c
  8003b2:	e8 18 03 00 00       	call   8006cf <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	68 d0 43 80 00       	push   $0x8043d0
  8003c2:	e8 08 03 00 00       	call   8006cf <cprintf>
  8003c7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003ca:	e8 d5 2b 00 00       	call   802fa4 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003cf:	e8 1f 00 00 00       	call   8003f3 <exit>
}
  8003d4:	90                   	nop
  8003d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d8:	5b                   	pop    %ebx
  8003d9:	5e                   	pop    %esi
  8003da:	5f                   	pop    %edi
  8003db:	5d                   	pop    %ebp
  8003dc:	c3                   	ret    

008003dd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003e3:	83 ec 0c             	sub    $0xc,%esp
  8003e6:	6a 00                	push   $0x0
  8003e8:	e8 e2 2d 00 00       	call   8031cf <sys_destroy_env>
  8003ed:	83 c4 10             	add    $0x10,%esp
}
  8003f0:	90                   	nop
  8003f1:	c9                   	leave  
  8003f2:	c3                   	ret    

008003f3 <exit>:

void
exit(void)
{
  8003f3:	55                   	push   %ebp
  8003f4:	89 e5                	mov    %esp,%ebp
  8003f6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f9:	e8 37 2e 00 00       	call   803235 <sys_exit_env>
}
  8003fe:	90                   	nop
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    

00800401 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800407:	8d 45 10             	lea    0x10(%ebp),%eax
  80040a:	83 c0 04             	add    $0x4,%eax
  80040d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800410:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800415:	85 c0                	test   %eax,%eax
  800417:	74 16                	je     80042f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800419:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80041e:	83 ec 08             	sub    $0x8,%esp
  800421:	50                   	push   %eax
  800422:	68 14 45 80 00       	push   $0x804514
  800427:	e8 a3 02 00 00       	call   8006cf <cprintf>
  80042c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80042f:	a1 04 50 80 00       	mov    0x805004,%eax
  800434:	83 ec 0c             	sub    $0xc,%esp
  800437:	ff 75 0c             	pushl  0xc(%ebp)
  80043a:	ff 75 08             	pushl  0x8(%ebp)
  80043d:	50                   	push   %eax
  80043e:	68 1c 45 80 00       	push   $0x80451c
  800443:	6a 74                	push   $0x74
  800445:	e8 b2 02 00 00       	call   8006fc <cprintf_colored>
  80044a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80044d:	8b 45 10             	mov    0x10(%ebp),%eax
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	ff 75 f4             	pushl  -0xc(%ebp)
  800456:	50                   	push   %eax
  800457:	e8 04 02 00 00       	call   800660 <vcprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	6a 00                	push   $0x0
  800464:	68 44 45 80 00       	push   $0x804544
  800469:	e8 f2 01 00 00       	call   800660 <vcprintf>
  80046e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800471:	e8 7d ff ff ff       	call   8003f3 <exit>

	// should not return here
	while (1) ;
  800476:	eb fe                	jmp    800476 <_panic+0x75>

00800478 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80047e:	a1 20 50 80 00       	mov    0x805020,%eax
  800483:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	39 c2                	cmp    %eax,%edx
  80048e:	74 14                	je     8004a4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 48 45 80 00       	push   $0x804548
  800498:	6a 26                	push   $0x26
  80049a:	68 94 45 80 00       	push   $0x804594
  80049f:	e8 5d ff ff ff       	call   800401 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004b2:	e9 c5 00 00 00       	jmp    80057c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	01 d0                	add    %edx,%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	85 c0                	test   %eax,%eax
  8004ca:	75 08                	jne    8004d4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004cc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004cf:	e9 a5 00 00 00       	jmp    800579 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004e2:	eb 69                	jmp    80054d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e9:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8004ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004f2:	89 d0                	mov    %edx,%eax
  8004f4:	01 c0                	add    %eax,%eax
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	c1 e0 03             	shl    $0x3,%eax
  8004fb:	01 c8                	add    %ecx,%eax
  8004fd:	8a 40 04             	mov    0x4(%eax),%al
  800500:	84 c0                	test   %al,%al
  800502:	75 46                	jne    80054a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800504:	a1 20 50 80 00       	mov    0x805020,%eax
  800509:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80050f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800512:	89 d0                	mov    %edx,%eax
  800514:	01 c0                	add    %eax,%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	c1 e0 03             	shl    $0x3,%eax
  80051b:	01 c8                	add    %ecx,%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800522:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800525:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80052a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80052c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	01 c8                	add    %ecx,%eax
  80053b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80053d:	39 c2                	cmp    %eax,%edx
  80053f:	75 09                	jne    80054a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800541:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800548:	eb 15                	jmp    80055f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054a:	ff 45 e8             	incl   -0x18(%ebp)
  80054d:	a1 20 50 80 00       	mov    0x805020,%eax
  800552:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800558:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80055b:	39 c2                	cmp    %eax,%edx
  80055d:	77 85                	ja     8004e4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80055f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800563:	75 14                	jne    800579 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800565:	83 ec 04             	sub    $0x4,%esp
  800568:	68 a0 45 80 00       	push   $0x8045a0
  80056d:	6a 3a                	push   $0x3a
  80056f:	68 94 45 80 00       	push   $0x804594
  800574:	e8 88 fe ff ff       	call   800401 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800579:	ff 45 f0             	incl   -0x10(%ebp)
  80057c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800582:	0f 8c 2f ff ff ff    	jl     8004b7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800588:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800596:	eb 26                	jmp    8005be <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800598:	a1 20 50 80 00       	mov    0x805020,%eax
  80059d:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8005a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a6:	89 d0                	mov    %edx,%eax
  8005a8:	01 c0                	add    %eax,%eax
  8005aa:	01 d0                	add    %edx,%eax
  8005ac:	c1 e0 03             	shl    $0x3,%eax
  8005af:	01 c8                	add    %ecx,%eax
  8005b1:	8a 40 04             	mov    0x4(%eax),%al
  8005b4:	3c 01                	cmp    $0x1,%al
  8005b6:	75 03                	jne    8005bb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005b8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005bb:	ff 45 e0             	incl   -0x20(%ebp)
  8005be:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005cc:	39 c2                	cmp    %eax,%edx
  8005ce:	77 c8                	ja     800598 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005d6:	74 14                	je     8005ec <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005d8:	83 ec 04             	sub    $0x4,%esp
  8005db:	68 f4 45 80 00       	push   $0x8045f4
  8005e0:	6a 44                	push   $0x44
  8005e2:	68 94 45 80 00       	push   $0x804594
  8005e7:	e8 15 fe ff ff       	call   800401 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005ec:	90                   	nop
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	53                   	push   %ebx
  8005f3:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f9:	8b 00                	mov    (%eax),%eax
  8005fb:	8d 48 01             	lea    0x1(%eax),%ecx
  8005fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800601:	89 0a                	mov    %ecx,(%edx)
  800603:	8b 55 08             	mov    0x8(%ebp),%edx
  800606:	88 d1                	mov    %dl,%cl
  800608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80060f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800612:	8b 00                	mov    (%eax),%eax
  800614:	3d ff 00 00 00       	cmp    $0xff,%eax
  800619:	75 30                	jne    80064b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80061b:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800621:	a0 44 50 80 00       	mov    0x805044,%al
  800626:	0f b6 c0             	movzbl %al,%eax
  800629:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80062c:	8b 09                	mov    (%ecx),%ecx
  80062e:	89 cb                	mov    %ecx,%ebx
  800630:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800633:	83 c1 08             	add    $0x8,%ecx
  800636:	52                   	push   %edx
  800637:	50                   	push   %eax
  800638:	53                   	push   %ebx
  800639:	51                   	push   %ecx
  80063a:	e8 07 29 00 00       	call   802f46 <sys_cputs>
  80063f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800642:	8b 45 0c             	mov    0xc(%ebp),%eax
  800645:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80064b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064e:	8b 40 04             	mov    0x4(%eax),%eax
  800651:	8d 50 01             	lea    0x1(%eax),%edx
  800654:	8b 45 0c             	mov    0xc(%ebp),%eax
  800657:	89 50 04             	mov    %edx,0x4(%eax)
}
  80065a:	90                   	nop
  80065b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80065e:	c9                   	leave  
  80065f:	c3                   	ret    

00800660 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800660:	55                   	push   %ebp
  800661:	89 e5                	mov    %esp,%ebp
  800663:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800669:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800670:	00 00 00 
	b.cnt = 0;
  800673:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80067a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80067d:	ff 75 0c             	pushl  0xc(%ebp)
  800680:	ff 75 08             	pushl  0x8(%ebp)
  800683:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800689:	50                   	push   %eax
  80068a:	68 ef 05 80 00       	push   $0x8005ef
  80068f:	e8 5a 02 00 00       	call   8008ee <vprintfmt>
  800694:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800697:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  80069d:	a0 44 50 80 00       	mov    0x805044,%al
  8006a2:	0f b6 c0             	movzbl %al,%eax
  8006a5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006ab:	52                   	push   %edx
  8006ac:	50                   	push   %eax
  8006ad:	51                   	push   %ecx
  8006ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006b4:	83 c0 08             	add    $0x8,%eax
  8006b7:	50                   	push   %eax
  8006b8:	e8 89 28 00 00       	call   802f46 <sys_cputs>
  8006bd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006c0:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8006c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006d5:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8006dc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006eb:	50                   	push   %eax
  8006ec:	e8 6f ff ff ff       	call   800660 <vcprintf>
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006fa:	c9                   	leave  
  8006fb:	c3                   	ret    

008006fc <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800702:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	c1 e0 08             	shl    $0x8,%eax
  80070f:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800714:	8d 45 0c             	lea    0xc(%ebp),%eax
  800717:	83 c0 04             	add    $0x4,%eax
  80071a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80071d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 f4             	pushl  -0xc(%ebp)
  800726:	50                   	push   %eax
  800727:	e8 34 ff ff ff       	call   800660 <vcprintf>
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800732:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800739:	07 00 00 

	return cnt;
  80073c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80073f:	c9                   	leave  
  800740:	c3                   	ret    

00800741 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800747:	e8 3e 28 00 00       	call   802f8a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80074c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 f4             	pushl  -0xc(%ebp)
  80075b:	50                   	push   %eax
  80075c:	e8 ff fe ff ff       	call   800660 <vcprintf>
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800767:	e8 38 28 00 00       	call   802fa4 <sys_unlock_cons>
	return cnt;
  80076c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80076f:	c9                   	leave  
  800770:	c3                   	ret    

00800771 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800771:	55                   	push   %ebp
  800772:	89 e5                	mov    %esp,%ebp
  800774:	53                   	push   %ebx
  800775:	83 ec 14             	sub    $0x14,%esp
  800778:	8b 45 10             	mov    0x10(%ebp),%eax
  80077b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800784:	8b 45 18             	mov    0x18(%ebp),%eax
  800787:	ba 00 00 00 00       	mov    $0x0,%edx
  80078c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80078f:	77 55                	ja     8007e6 <printnum+0x75>
  800791:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800794:	72 05                	jb     80079b <printnum+0x2a>
  800796:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800799:	77 4b                	ja     8007e6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80079b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80079e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007a1:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a9:	52                   	push   %edx
  8007aa:	50                   	push   %eax
  8007ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b1:	e8 82 38 00 00       	call   804038 <__udivdi3>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	83 ec 04             	sub    $0x4,%esp
  8007bc:	ff 75 20             	pushl  0x20(%ebp)
  8007bf:	53                   	push   %ebx
  8007c0:	ff 75 18             	pushl  0x18(%ebp)
  8007c3:	52                   	push   %edx
  8007c4:	50                   	push   %eax
  8007c5:	ff 75 0c             	pushl  0xc(%ebp)
  8007c8:	ff 75 08             	pushl  0x8(%ebp)
  8007cb:	e8 a1 ff ff ff       	call   800771 <printnum>
  8007d0:	83 c4 20             	add    $0x20,%esp
  8007d3:	eb 1a                	jmp    8007ef <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	ff 75 20             	pushl  0x20(%ebp)
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	ff d0                	call   *%eax
  8007e3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007e6:	ff 4d 1c             	decl   0x1c(%ebp)
  8007e9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007ed:	7f e6                	jg     8007d5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007ef:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007fd:	53                   	push   %ebx
  8007fe:	51                   	push   %ecx
  8007ff:	52                   	push   %edx
  800800:	50                   	push   %eax
  800801:	e8 42 39 00 00       	call   804148 <__umoddi3>
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	05 54 48 80 00       	add    $0x804854,%eax
  80080e:	8a 00                	mov    (%eax),%al
  800810:	0f be c0             	movsbl %al,%eax
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	ff 75 0c             	pushl  0xc(%ebp)
  800819:	50                   	push   %eax
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
}
  800822:	90                   	nop
  800823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800826:	c9                   	leave  
  800827:	c3                   	ret    

00800828 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80082f:	7e 1c                	jle    80084d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	8b 00                	mov    (%eax),%eax
  800836:	8d 50 08             	lea    0x8(%eax),%edx
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	89 10                	mov    %edx,(%eax)
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	83 e8 08             	sub    $0x8,%eax
  800846:	8b 50 04             	mov    0x4(%eax),%edx
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	eb 40                	jmp    80088d <getuint+0x65>
	else if (lflag)
  80084d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800851:	74 1e                	je     800871 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	8d 50 04             	lea    0x4(%eax),%edx
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	89 10                	mov    %edx,(%eax)
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	83 e8 04             	sub    $0x4,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	ba 00 00 00 00       	mov    $0x0,%edx
  80086f:	eb 1c                	jmp    80088d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	8d 50 04             	lea    0x4(%eax),%edx
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	89 10                	mov    %edx,(%eax)
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	83 e8 04             	sub    $0x4,%eax
  800886:	8b 00                	mov    (%eax),%eax
  800888:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800892:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800896:	7e 1c                	jle    8008b4 <getint+0x25>
		return va_arg(*ap, long long);
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	8b 00                	mov    (%eax),%eax
  80089d:	8d 50 08             	lea    0x8(%eax),%edx
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	89 10                	mov    %edx,(%eax)
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	83 e8 08             	sub    $0x8,%eax
  8008ad:	8b 50 04             	mov    0x4(%eax),%edx
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	eb 38                	jmp    8008ec <getint+0x5d>
	else if (lflag)
  8008b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b8:	74 1a                	je     8008d4 <getint+0x45>
		return va_arg(*ap, long);
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	8d 50 04             	lea    0x4(%eax),%edx
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	89 10                	mov    %edx,(%eax)
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	83 e8 04             	sub    $0x4,%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	99                   	cltd   
  8008d2:	eb 18                	jmp    8008ec <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	8d 50 04             	lea    0x4(%eax),%edx
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	89 10                	mov    %edx,(%eax)
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	83 e8 04             	sub    $0x4,%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	99                   	cltd   
}
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    

008008ee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	56                   	push   %esi
  8008f2:	53                   	push   %ebx
  8008f3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f6:	eb 17                	jmp    80090f <vprintfmt+0x21>
			if (ch == '\0')
  8008f8:	85 db                	test   %ebx,%ebx
  8008fa:	0f 84 c1 03 00 00    	je     800cc1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	53                   	push   %ebx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80090f:	8b 45 10             	mov    0x10(%ebp),%eax
  800912:	8d 50 01             	lea    0x1(%eax),%edx
  800915:	89 55 10             	mov    %edx,0x10(%ebp)
  800918:	8a 00                	mov    (%eax),%al
  80091a:	0f b6 d8             	movzbl %al,%ebx
  80091d:	83 fb 25             	cmp    $0x25,%ebx
  800920:	75 d6                	jne    8008f8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800922:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800926:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80092d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800934:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80093b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800942:	8b 45 10             	mov    0x10(%ebp),%eax
  800945:	8d 50 01             	lea    0x1(%eax),%edx
  800948:	89 55 10             	mov    %edx,0x10(%ebp)
  80094b:	8a 00                	mov    (%eax),%al
  80094d:	0f b6 d8             	movzbl %al,%ebx
  800950:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800953:	83 f8 5b             	cmp    $0x5b,%eax
  800956:	0f 87 3d 03 00 00    	ja     800c99 <vprintfmt+0x3ab>
  80095c:	8b 04 85 78 48 80 00 	mov    0x804878(,%eax,4),%eax
  800963:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800965:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800969:	eb d7                	jmp    800942 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80096b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80096f:	eb d1                	jmp    800942 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800971:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800978:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80097b:	89 d0                	mov    %edx,%eax
  80097d:	c1 e0 02             	shl    $0x2,%eax
  800980:	01 d0                	add    %edx,%eax
  800982:	01 c0                	add    %eax,%eax
  800984:	01 d8                	add    %ebx,%eax
  800986:	83 e8 30             	sub    $0x30,%eax
  800989:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80098c:	8b 45 10             	mov    0x10(%ebp),%eax
  80098f:	8a 00                	mov    (%eax),%al
  800991:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800994:	83 fb 2f             	cmp    $0x2f,%ebx
  800997:	7e 3e                	jle    8009d7 <vprintfmt+0xe9>
  800999:	83 fb 39             	cmp    $0x39,%ebx
  80099c:	7f 39                	jg     8009d7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009a1:	eb d5                	jmp    800978 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	83 c0 04             	add    $0x4,%eax
  8009a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	83 e8 04             	sub    $0x4,%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009b7:	eb 1f                	jmp    8009d8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009bd:	79 83                	jns    800942 <vprintfmt+0x54>
				width = 0;
  8009bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009c6:	e9 77 ff ff ff       	jmp    800942 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009cb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009d2:	e9 6b ff ff ff       	jmp    800942 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009d7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dc:	0f 89 60 ff ff ff    	jns    800942 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009e8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009ef:	e9 4e ff ff ff       	jmp    800942 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009f4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009f7:	e9 46 ff ff ff       	jmp    800942 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	83 c0 04             	add    $0x4,%eax
  800a02:	89 45 14             	mov    %eax,0x14(%ebp)
  800a05:	8b 45 14             	mov    0x14(%ebp),%eax
  800a08:	83 e8 04             	sub    $0x4,%eax
  800a0b:	8b 00                	mov    (%eax),%eax
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	50                   	push   %eax
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	ff d0                	call   *%eax
  800a19:	83 c4 10             	add    $0x10,%esp
			break;
  800a1c:	e9 9b 02 00 00       	jmp    800cbc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	83 c0 04             	add    $0x4,%eax
  800a27:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2d:	83 e8 04             	sub    $0x4,%eax
  800a30:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a32:	85 db                	test   %ebx,%ebx
  800a34:	79 02                	jns    800a38 <vprintfmt+0x14a>
				err = -err;
  800a36:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a38:	83 fb 64             	cmp    $0x64,%ebx
  800a3b:	7f 0b                	jg     800a48 <vprintfmt+0x15a>
  800a3d:	8b 34 9d c0 46 80 00 	mov    0x8046c0(,%ebx,4),%esi
  800a44:	85 f6                	test   %esi,%esi
  800a46:	75 19                	jne    800a61 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a48:	53                   	push   %ebx
  800a49:	68 65 48 80 00       	push   $0x804865
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	ff 75 08             	pushl  0x8(%ebp)
  800a54:	e8 70 02 00 00       	call   800cc9 <printfmt>
  800a59:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a5c:	e9 5b 02 00 00       	jmp    800cbc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a61:	56                   	push   %esi
  800a62:	68 6e 48 80 00       	push   $0x80486e
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	ff 75 08             	pushl  0x8(%ebp)
  800a6d:	e8 57 02 00 00       	call   800cc9 <printfmt>
  800a72:	83 c4 10             	add    $0x10,%esp
			break;
  800a75:	e9 42 02 00 00       	jmp    800cbc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	83 c0 04             	add    $0x4,%eax
  800a80:	89 45 14             	mov    %eax,0x14(%ebp)
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	83 e8 04             	sub    $0x4,%eax
  800a89:	8b 30                	mov    (%eax),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 05                	jne    800a94 <vprintfmt+0x1a6>
				p = "(null)";
  800a8f:	be 71 48 80 00       	mov    $0x804871,%esi
			if (width > 0 && padc != '-')
  800a94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a98:	7e 6d                	jle    800b07 <vprintfmt+0x219>
  800a9a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a9e:	74 67                	je     800b07 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	50                   	push   %eax
  800aa7:	56                   	push   %esi
  800aa8:	e8 1e 03 00 00       	call   800dcb <strnlen>
  800aad:	83 c4 10             	add    $0x10,%esp
  800ab0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ab3:	eb 16                	jmp    800acb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ab5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ab9:	83 ec 08             	sub    $0x8,%esp
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	50                   	push   %eax
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	ff d0                	call   *%eax
  800ac5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac8:	ff 4d e4             	decl   -0x1c(%ebp)
  800acb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800acf:	7f e4                	jg     800ab5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad1:	eb 34                	jmp    800b07 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ad3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ad7:	74 1c                	je     800af5 <vprintfmt+0x207>
  800ad9:	83 fb 1f             	cmp    $0x1f,%ebx
  800adc:	7e 05                	jle    800ae3 <vprintfmt+0x1f5>
  800ade:	83 fb 7e             	cmp    $0x7e,%ebx
  800ae1:	7e 12                	jle    800af5 <vprintfmt+0x207>
					putch('?', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 3f                	push   $0x3f
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
  800af3:	eb 0f                	jmp    800b04 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	53                   	push   %ebx
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	ff d0                	call   *%eax
  800b01:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b04:	ff 4d e4             	decl   -0x1c(%ebp)
  800b07:	89 f0                	mov    %esi,%eax
  800b09:	8d 70 01             	lea    0x1(%eax),%esi
  800b0c:	8a 00                	mov    (%eax),%al
  800b0e:	0f be d8             	movsbl %al,%ebx
  800b11:	85 db                	test   %ebx,%ebx
  800b13:	74 24                	je     800b39 <vprintfmt+0x24b>
  800b15:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b19:	78 b8                	js     800ad3 <vprintfmt+0x1e5>
  800b1b:	ff 4d e0             	decl   -0x20(%ebp)
  800b1e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b22:	79 af                	jns    800ad3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b24:	eb 13                	jmp    800b39 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 0c             	pushl  0xc(%ebp)
  800b2c:	6a 20                	push   $0x20
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	ff d0                	call   *%eax
  800b33:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b36:	ff 4d e4             	decl   -0x1c(%ebp)
  800b39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3d:	7f e7                	jg     800b26 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b3f:	e9 78 01 00 00       	jmp    800cbc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 e8             	pushl  -0x18(%ebp)
  800b4a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b4d:	50                   	push   %eax
  800b4e:	e8 3c fd ff ff       	call   80088f <getint>
  800b53:	83 c4 10             	add    $0x10,%esp
  800b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b59:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b62:	85 d2                	test   %edx,%edx
  800b64:	79 23                	jns    800b89 <vprintfmt+0x29b>
				putch('-', putdat);
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	ff 75 0c             	pushl  0xc(%ebp)
  800b6c:	6a 2d                	push   $0x2d
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	ff d0                	call   *%eax
  800b73:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7c:	f7 d8                	neg    %eax
  800b7e:	83 d2 00             	adc    $0x0,%edx
  800b81:	f7 da                	neg    %edx
  800b83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b86:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b89:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b90:	e9 bc 00 00 00       	jmp    800c51 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 e8             	pushl  -0x18(%ebp)
  800b9b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b9e:	50                   	push   %eax
  800b9f:	e8 84 fc ff ff       	call   800828 <getuint>
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bad:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb4:	e9 98 00 00 00       	jmp    800c51 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 0c             	pushl  0xc(%ebp)
  800bbf:	6a 58                	push   $0x58
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	ff d0                	call   *%eax
  800bc6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	6a 58                	push   $0x58
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	ff d0                	call   *%eax
  800bd6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	6a 58                	push   $0x58
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	ff d0                	call   *%eax
  800be6:	83 c4 10             	add    $0x10,%esp
			break;
  800be9:	e9 ce 00 00 00       	jmp    800cbc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	6a 30                	push   $0x30
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	ff d0                	call   *%eax
  800bfb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bfe:	83 ec 08             	sub    $0x8,%esp
  800c01:	ff 75 0c             	pushl  0xc(%ebp)
  800c04:	6a 78                	push   $0x78
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	ff d0                	call   *%eax
  800c0b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c11:	83 c0 04             	add    $0x4,%eax
  800c14:	89 45 14             	mov    %eax,0x14(%ebp)
  800c17:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1a:	83 e8 04             	sub    $0x4,%eax
  800c1d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c29:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c30:	eb 1f                	jmp    800c51 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 e8             	pushl  -0x18(%ebp)
  800c38:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3b:	50                   	push   %eax
  800c3c:	e8 e7 fb ff ff       	call   800828 <getuint>
  800c41:	83 c4 10             	add    $0x10,%esp
  800c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c47:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c4a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c51:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c58:	83 ec 04             	sub    $0x4,%esp
  800c5b:	52                   	push   %edx
  800c5c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c5f:	50                   	push   %eax
  800c60:	ff 75 f4             	pushl  -0xc(%ebp)
  800c63:	ff 75 f0             	pushl  -0x10(%ebp)
  800c66:	ff 75 0c             	pushl  0xc(%ebp)
  800c69:	ff 75 08             	pushl  0x8(%ebp)
  800c6c:	e8 00 fb ff ff       	call   800771 <printnum>
  800c71:	83 c4 20             	add    $0x20,%esp
			break;
  800c74:	eb 46                	jmp    800cbc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	53                   	push   %ebx
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			break;
  800c85:	eb 35                	jmp    800cbc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c87:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800c8e:	eb 2c                	jmp    800cbc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c90:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800c97:	eb 23                	jmp    800cbc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	ff 75 0c             	pushl  0xc(%ebp)
  800c9f:	6a 25                	push   $0x25
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	ff d0                	call   *%eax
  800ca6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ca9:	ff 4d 10             	decl   0x10(%ebp)
  800cac:	eb 03                	jmp    800cb1 <vprintfmt+0x3c3>
  800cae:	ff 4d 10             	decl   0x10(%ebp)
  800cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb4:	48                   	dec    %eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	3c 25                	cmp    $0x25,%al
  800cb9:	75 f3                	jne    800cae <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cbb:	90                   	nop
		}
	}
  800cbc:	e9 35 fc ff ff       	jmp    8008f6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cc1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cc5:	5b                   	pop    %ebx
  800cc6:	5e                   	pop    %esi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ccf:	8d 45 10             	lea    0x10(%ebp),%eax
  800cd2:	83 c0 04             	add    $0x4,%eax
  800cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cde:	50                   	push   %eax
  800cdf:	ff 75 0c             	pushl  0xc(%ebp)
  800ce2:	ff 75 08             	pushl  0x8(%ebp)
  800ce5:	e8 04 fc ff ff       	call   8008ee <vprintfmt>
  800cea:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ced:	90                   	nop
  800cee:	c9                   	leave  
  800cef:	c3                   	ret    

00800cf0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf6:	8b 40 08             	mov    0x8(%eax),%eax
  800cf9:	8d 50 01             	lea    0x1(%eax),%edx
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d05:	8b 10                	mov    (%eax),%edx
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	8b 40 04             	mov    0x4(%eax),%eax
  800d0d:	39 c2                	cmp    %eax,%edx
  800d0f:	73 12                	jae    800d23 <sprintputch+0x33>
		*b->buf++ = ch;
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	8d 48 01             	lea    0x1(%eax),%ecx
  800d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1c:	89 0a                	mov    %ecx,(%edx)
  800d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d21:	88 10                	mov    %dl,(%eax)
}
  800d23:	90                   	nop
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	01 d0                	add    %edx,%eax
  800d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d4b:	74 06                	je     800d53 <vsnprintf+0x2d>
  800d4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d51:	7f 07                	jg     800d5a <vsnprintf+0x34>
		return -E_INVAL;
  800d53:	b8 03 00 00 00       	mov    $0x3,%eax
  800d58:	eb 20                	jmp    800d7a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d5a:	ff 75 14             	pushl  0x14(%ebp)
  800d5d:	ff 75 10             	pushl  0x10(%ebp)
  800d60:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d63:	50                   	push   %eax
  800d64:	68 f0 0c 80 00       	push   $0x800cf0
  800d69:	e8 80 fb ff ff       	call   8008ee <vprintfmt>
  800d6e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d74:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d7a:	c9                   	leave  
  800d7b:	c3                   	ret    

00800d7c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d82:	8d 45 10             	lea    0x10(%ebp),%eax
  800d85:	83 c0 04             	add    $0x4,%eax
  800d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d91:	50                   	push   %eax
  800d92:	ff 75 0c             	pushl  0xc(%ebp)
  800d95:	ff 75 08             	pushl  0x8(%ebp)
  800d98:	e8 89 ff ff ff       	call   800d26 <vsnprintf>
  800d9d:	83 c4 10             	add    $0x10,%esp
  800da0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db5:	eb 06                	jmp    800dbd <strlen+0x15>
		n++;
  800db7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dba:	ff 45 08             	incl   0x8(%ebp)
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	84 c0                	test   %al,%al
  800dc4:	75 f1                	jne    800db7 <strlen+0xf>
		n++;
	return n;
  800dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd8:	eb 09                	jmp    800de3 <strnlen+0x18>
		n++;
  800dda:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ddd:	ff 45 08             	incl   0x8(%ebp)
  800de0:	ff 4d 0c             	decl   0xc(%ebp)
  800de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de7:	74 09                	je     800df2 <strnlen+0x27>
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	84 c0                	test   %al,%al
  800df0:	75 e8                	jne    800dda <strnlen+0xf>
		n++;
	return n;
  800df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df5:	c9                   	leave  
  800df6:	c3                   	ret    

00800df7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e03:	90                   	nop
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8d 50 01             	lea    0x1(%eax),%edx
  800e0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e16:	8a 12                	mov    (%edx),%dl
  800e18:	88 10                	mov    %dl,(%eax)
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	84 c0                	test   %al,%al
  800e1e:	75 e4                	jne    800e04 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e38:	eb 1f                	jmp    800e59 <strncpy+0x34>
		*dst++ = *src;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8d 50 01             	lea    0x1(%eax),%edx
  800e40:	89 55 08             	mov    %edx,0x8(%ebp)
  800e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e46:	8a 12                	mov    (%edx),%dl
  800e48:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	84 c0                	test   %al,%al
  800e51:	74 03                	je     800e56 <strncpy+0x31>
			src++;
  800e53:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e56:	ff 45 fc             	incl   -0x4(%ebp)
  800e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e5f:	72 d9                	jb     800e3a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e61:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e76:	74 30                	je     800ea8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e78:	eb 16                	jmp    800e90 <strlcpy+0x2a>
			*dst++ = *src++;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8d 50 01             	lea    0x1(%eax),%edx
  800e80:	89 55 08             	mov    %edx,0x8(%ebp)
  800e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e89:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e8c:	8a 12                	mov    (%edx),%dl
  800e8e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e90:	ff 4d 10             	decl   0x10(%ebp)
  800e93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e97:	74 09                	je     800ea2 <strlcpy+0x3c>
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	84 c0                	test   %al,%al
  800ea0:	75 d8                	jne    800e7a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eae:	29 c2                	sub    %eax,%edx
  800eb0:	89 d0                	mov    %edx,%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eb7:	eb 06                	jmp    800ebf <strcmp+0xb>
		p++, q++;
  800eb9:	ff 45 08             	incl   0x8(%ebp)
  800ebc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	84 c0                	test   %al,%al
  800ec6:	74 0e                	je     800ed6 <strcmp+0x22>
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	8a 10                	mov    (%eax),%dl
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	38 c2                	cmp    %al,%dl
  800ed4:	74 e3                	je     800eb9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	0f b6 d0             	movzbl %al,%edx
  800ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	0f b6 c0             	movzbl %al,%eax
  800ee6:	29 c2                	sub    %eax,%edx
  800ee8:	89 d0                	mov    %edx,%eax
}
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    

00800eec <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800eef:	eb 09                	jmp    800efa <strncmp+0xe>
		n--, p++, q++;
  800ef1:	ff 4d 10             	decl   0x10(%ebp)
  800ef4:	ff 45 08             	incl   0x8(%ebp)
  800ef7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800efa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efe:	74 17                	je     800f17 <strncmp+0x2b>
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	84 c0                	test   %al,%al
  800f07:	74 0e                	je     800f17 <strncmp+0x2b>
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8a 10                	mov    (%eax),%dl
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	38 c2                	cmp    %al,%dl
  800f15:	74 da                	je     800ef1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1b:	75 07                	jne    800f24 <strncmp+0x38>
		return 0;
  800f1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f22:	eb 14                	jmp    800f38 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	0f b6 d0             	movzbl %al,%edx
  800f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	0f b6 c0             	movzbl %al,%eax
  800f34:	29 c2                	sub    %eax,%edx
  800f36:	89 d0                	mov    %edx,%eax
}
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	83 ec 04             	sub    $0x4,%esp
  800f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f43:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f46:	eb 12                	jmp    800f5a <strchr+0x20>
		if (*s == c)
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f50:	75 05                	jne    800f57 <strchr+0x1d>
			return (char *) s;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	eb 11                	jmp    800f68 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f57:	ff 45 08             	incl   0x8(%ebp)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	84 c0                	test   %al,%al
  800f61:	75 e5                	jne    800f48 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f68:	c9                   	leave  
  800f69:	c3                   	ret    

00800f6a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	83 ec 04             	sub    $0x4,%esp
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f76:	eb 0d                	jmp    800f85 <strfind+0x1b>
		if (*s == c)
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f80:	74 0e                	je     800f90 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f82:	ff 45 08             	incl   0x8(%ebp)
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	84 c0                	test   %al,%al
  800f8c:	75 ea                	jne    800f78 <strfind+0xe>
  800f8e:	eb 01                	jmp    800f91 <strfind+0x27>
		if (*s == c)
			break;
  800f90:	90                   	nop
	return (char *) s;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f94:	c9                   	leave  
  800f95:	c3                   	ret    

00800f96 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fa2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fa6:	76 63                	jbe    80100b <memset+0x75>
		uint64 data_block = c;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	99                   	cltd   
  800fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800faf:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fbc:	c1 e0 08             	shl    $0x8,%eax
  800fbf:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fc2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fcb:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fcf:	c1 e0 10             	shl    $0x10,%eax
  800fd2:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fd5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fde:	89 c2                	mov    %eax,%edx
  800fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fe8:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800feb:	eb 18                	jmp    801005 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800fed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ff0:	8d 41 08             	lea    0x8(%ecx),%eax
  800ff3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ffc:	89 01                	mov    %eax,(%ecx)
  800ffe:	89 51 04             	mov    %edx,0x4(%ecx)
  801001:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801005:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801009:	77 e2                	ja     800fed <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80100b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100f:	74 23                	je     801034 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801011:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801014:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801017:	eb 0e                	jmp    801027 <memset+0x91>
			*p8++ = (uint8)c;
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8d 50 01             	lea    0x1(%eax),%edx
  80101f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801022:	8b 55 0c             	mov    0xc(%ebp),%edx
  801025:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102d:	89 55 10             	mov    %edx,0x10(%ebp)
  801030:	85 c0                	test   %eax,%eax
  801032:	75 e5                	jne    801019 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80103f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801042:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80104b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80104f:	76 24                	jbe    801075 <memcpy+0x3c>
		while(n >= 8){
  801051:	eb 1c                	jmp    80106f <memcpy+0x36>
			*d64 = *s64;
  801053:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801056:	8b 50 04             	mov    0x4(%eax),%edx
  801059:	8b 00                	mov    (%eax),%eax
  80105b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80105e:	89 01                	mov    %eax,(%ecx)
  801060:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801063:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801067:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80106b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80106f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801073:	77 de                	ja     801053 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801075:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801079:	74 31                	je     8010ac <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80107b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801081:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801084:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801087:	eb 16                	jmp    80109f <memcpy+0x66>
			*d8++ = *s8++;
  801089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108c:	8d 50 01             	lea    0x1(%eax),%edx
  80108f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801092:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801095:	8d 4a 01             	lea    0x1(%edx),%ecx
  801098:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80109b:	8a 12                	mov    (%edx),%dl
  80109d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	75 dd                	jne    801089 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010af:	c9                   	leave  
  8010b0:	c3                   	ret    

008010b1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010c9:	73 50                	jae    80111b <memmove+0x6a>
  8010cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d1:	01 d0                	add    %edx,%eax
  8010d3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010d6:	76 43                	jbe    80111b <memmove+0x6a>
		s += n;
  8010d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010db:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010e4:	eb 10                	jmp    8010f6 <memmove+0x45>
			*--d = *--s;
  8010e6:	ff 4d f8             	decl   -0x8(%ebp)
  8010e9:	ff 4d fc             	decl   -0x4(%ebp)
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	8a 10                	mov    (%eax),%dl
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ff:	85 c0                	test   %eax,%eax
  801101:	75 e3                	jne    8010e6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801103:	eb 23                	jmp    801128 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801105:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801108:	8d 50 01             	lea    0x1(%eax),%edx
  80110b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80110e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801111:	8d 4a 01             	lea    0x1(%edx),%ecx
  801114:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801117:	8a 12                	mov    (%edx),%dl
  801119:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80111b:	8b 45 10             	mov    0x10(%ebp),%eax
  80111e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801121:	89 55 10             	mov    %edx,0x10(%ebp)
  801124:	85 c0                	test   %eax,%eax
  801126:	75 dd                	jne    801105 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112b:	c9                   	leave  
  80112c:	c3                   	ret    

0080112d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80113f:	eb 2a                	jmp    80116b <memcmp+0x3e>
		if (*s1 != *s2)
  801141:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801144:	8a 10                	mov    (%eax),%dl
  801146:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	38 c2                	cmp    %al,%dl
  80114d:	74 16                	je     801165 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80114f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	0f b6 d0             	movzbl %al,%edx
  801157:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	0f b6 c0             	movzbl %al,%eax
  80115f:	29 c2                	sub    %eax,%edx
  801161:	89 d0                	mov    %edx,%eax
  801163:	eb 18                	jmp    80117d <memcmp+0x50>
		s1++, s2++;
  801165:	ff 45 fc             	incl   -0x4(%ebp)
  801168:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80116b:	8b 45 10             	mov    0x10(%ebp),%eax
  80116e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801171:	89 55 10             	mov    %edx,0x10(%ebp)
  801174:	85 c0                	test   %eax,%eax
  801176:	75 c9                	jne    801141 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801178:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801185:	8b 55 08             	mov    0x8(%ebp),%edx
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	01 d0                	add    %edx,%eax
  80118d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801190:	eb 15                	jmp    8011a7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	0f b6 d0             	movzbl %al,%edx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	0f b6 c0             	movzbl %al,%eax
  8011a0:	39 c2                	cmp    %eax,%edx
  8011a2:	74 0d                	je     8011b1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011a4:	ff 45 08             	incl   0x8(%ebp)
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011ad:	72 e3                	jb     801192 <memfind+0x13>
  8011af:	eb 01                	jmp    8011b2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011b1:	90                   	nop
	return (void *) s;
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011cb:	eb 03                	jmp    8011d0 <strtol+0x19>
		s++;
  8011cd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	3c 20                	cmp    $0x20,%al
  8011d7:	74 f4                	je     8011cd <strtol+0x16>
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	3c 09                	cmp    $0x9,%al
  8011e0:	74 eb                	je     8011cd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 2b                	cmp    $0x2b,%al
  8011e9:	75 05                	jne    8011f0 <strtol+0x39>
		s++;
  8011eb:	ff 45 08             	incl   0x8(%ebp)
  8011ee:	eb 13                	jmp    801203 <strtol+0x4c>
	else if (*s == '-')
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	3c 2d                	cmp    $0x2d,%al
  8011f7:	75 0a                	jne    801203 <strtol+0x4c>
		s++, neg = 1;
  8011f9:	ff 45 08             	incl   0x8(%ebp)
  8011fc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801203:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801207:	74 06                	je     80120f <strtol+0x58>
  801209:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80120d:	75 20                	jne    80122f <strtol+0x78>
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	3c 30                	cmp    $0x30,%al
  801216:	75 17                	jne    80122f <strtol+0x78>
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	40                   	inc    %eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 78                	cmp    $0x78,%al
  801220:	75 0d                	jne    80122f <strtol+0x78>
		s += 2, base = 16;
  801222:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801226:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80122d:	eb 28                	jmp    801257 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80122f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801233:	75 15                	jne    80124a <strtol+0x93>
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 30                	cmp    $0x30,%al
  80123c:	75 0c                	jne    80124a <strtol+0x93>
		s++, base = 8;
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801248:	eb 0d                	jmp    801257 <strtol+0xa0>
	else if (base == 0)
  80124a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124e:	75 07                	jne    801257 <strtol+0xa0>
		base = 10;
  801250:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	3c 2f                	cmp    $0x2f,%al
  80125e:	7e 19                	jle    801279 <strtol+0xc2>
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	3c 39                	cmp    $0x39,%al
  801267:	7f 10                	jg     801279 <strtol+0xc2>
			dig = *s - '0';
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	0f be c0             	movsbl %al,%eax
  801271:	83 e8 30             	sub    $0x30,%eax
  801274:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801277:	eb 42                	jmp    8012bb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	3c 60                	cmp    $0x60,%al
  801280:	7e 19                	jle    80129b <strtol+0xe4>
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	3c 7a                	cmp    $0x7a,%al
  801289:	7f 10                	jg     80129b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	0f be c0             	movsbl %al,%eax
  801293:	83 e8 57             	sub    $0x57,%eax
  801296:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801299:	eb 20                	jmp    8012bb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8a 00                	mov    (%eax),%al
  8012a0:	3c 40                	cmp    $0x40,%al
  8012a2:	7e 39                	jle    8012dd <strtol+0x126>
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	3c 5a                	cmp    $0x5a,%al
  8012ab:	7f 30                	jg     8012dd <strtol+0x126>
			dig = *s - 'A' + 10;
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	0f be c0             	movsbl %al,%eax
  8012b5:	83 e8 37             	sub    $0x37,%eax
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012be:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012c1:	7d 19                	jge    8012dc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012c3:	ff 45 08             	incl   0x8(%ebp)
  8012c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012cd:	89 c2                	mov    %eax,%edx
  8012cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d2:	01 d0                	add    %edx,%eax
  8012d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012d7:	e9 7b ff ff ff       	jmp    801257 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012dc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012e1:	74 08                	je     8012eb <strtol+0x134>
		*endptr = (char *) s;
  8012e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ef:	74 07                	je     8012f8 <strtol+0x141>
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f4:	f7 d8                	neg    %eax
  8012f6:	eb 03                	jmp    8012fb <strtol+0x144>
  8012f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <ltostr>:

void
ltostr(long value, char *str)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801303:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80130a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801315:	79 13                	jns    80132a <ltostr+0x2d>
	{
		neg = 1;
  801317:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80131e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801321:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801324:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801327:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801332:	99                   	cltd   
  801333:	f7 f9                	idiv   %ecx
  801335:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801338:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133b:	8d 50 01             	lea    0x1(%eax),%edx
  80133e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801341:	89 c2                	mov    %eax,%edx
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	01 d0                	add    %edx,%eax
  801348:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80134b:	83 c2 30             	add    $0x30,%edx
  80134e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801350:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801353:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801358:	f7 e9                	imul   %ecx
  80135a:	c1 fa 02             	sar    $0x2,%edx
  80135d:	89 c8                	mov    %ecx,%eax
  80135f:	c1 f8 1f             	sar    $0x1f,%eax
  801362:	29 c2                	sub    %eax,%edx
  801364:	89 d0                	mov    %edx,%eax
  801366:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801369:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80136d:	75 bb                	jne    80132a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80136f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801376:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801379:	48                   	dec    %eax
  80137a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80137d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801381:	74 3d                	je     8013c0 <ltostr+0xc3>
		start = 1 ;
  801383:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80138a:	eb 34                	jmp    8013c0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80138c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	01 d0                	add    %edx,%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801399:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139f:	01 c2                	add    %eax,%edx
  8013a1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	01 c8                	add    %ecx,%eax
  8013a9:	8a 00                	mov    (%eax),%al
  8013ab:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	01 c2                	add    %eax,%edx
  8013b5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013b8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013ba:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013bd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013c6:	7c c4                	jl     80138c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	01 d0                	add    %edx,%eax
  8013d0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013d3:	90                   	nop
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013dc:	ff 75 08             	pushl  0x8(%ebp)
  8013df:	e8 c4 f9 ff ff       	call   800da8 <strlen>
  8013e4:	83 c4 04             	add    $0x4,%esp
  8013e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013ea:	ff 75 0c             	pushl  0xc(%ebp)
  8013ed:	e8 b6 f9 ff ff       	call   800da8 <strlen>
  8013f2:	83 c4 04             	add    $0x4,%esp
  8013f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801406:	eb 17                	jmp    80141f <strcconcat+0x49>
		final[s] = str1[s] ;
  801408:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140b:	8b 45 10             	mov    0x10(%ebp),%eax
  80140e:	01 c2                	add    %eax,%edx
  801410:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	01 c8                	add    %ecx,%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80141c:	ff 45 fc             	incl   -0x4(%ebp)
  80141f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801422:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801425:	7c e1                	jl     801408 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801427:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80142e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801435:	eb 1f                	jmp    801456 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801437:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80143a:	8d 50 01             	lea    0x1(%eax),%edx
  80143d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801440:	89 c2                	mov    %eax,%edx
  801442:	8b 45 10             	mov    0x10(%ebp),%eax
  801445:	01 c2                	add    %eax,%edx
  801447:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80144a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144d:	01 c8                	add    %ecx,%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801453:	ff 45 f8             	incl   -0x8(%ebp)
  801456:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801459:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80145c:	7c d9                	jl     801437 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80145e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801461:	8b 45 10             	mov    0x10(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	c6 00 00             	movb   $0x0,(%eax)
}
  801469:	90                   	nop
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801478:	8b 45 14             	mov    0x14(%ebp),%eax
  80147b:	8b 00                	mov    (%eax),%eax
  80147d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801484:	8b 45 10             	mov    0x10(%ebp),%eax
  801487:	01 d0                	add    %edx,%eax
  801489:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148f:	eb 0c                	jmp    80149d <strsplit+0x31>
			*string++ = 0;
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8d 50 01             	lea    0x1(%eax),%edx
  801497:	89 55 08             	mov    %edx,0x8(%ebp)
  80149a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	84 c0                	test   %al,%al
  8014a4:	74 18                	je     8014be <strsplit+0x52>
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	0f be c0             	movsbl %al,%eax
  8014ae:	50                   	push   %eax
  8014af:	ff 75 0c             	pushl  0xc(%ebp)
  8014b2:	e8 83 fa ff ff       	call   800f3a <strchr>
  8014b7:	83 c4 08             	add    $0x8,%esp
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	75 d3                	jne    801491 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 00                	mov    (%eax),%al
  8014c3:	84 c0                	test   %al,%al
  8014c5:	74 5a                	je     801521 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	83 f8 0f             	cmp    $0xf,%eax
  8014cf:	75 07                	jne    8014d8 <strsplit+0x6c>
		{
			return 0;
  8014d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d6:	eb 66                	jmp    80153e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014db:	8b 00                	mov    (%eax),%eax
  8014dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014e0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014e3:	89 0a                	mov    %ecx,(%edx)
  8014e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ef:	01 c2                	add    %eax,%edx
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014f6:	eb 03                	jmp    8014fb <strsplit+0x8f>
			string++;
  8014f8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	84 c0                	test   %al,%al
  801502:	74 8b                	je     80148f <strsplit+0x23>
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	0f be c0             	movsbl %al,%eax
  80150c:	50                   	push   %eax
  80150d:	ff 75 0c             	pushl  0xc(%ebp)
  801510:	e8 25 fa ff ff       	call   800f3a <strchr>
  801515:	83 c4 08             	add    $0x8,%esp
  801518:	85 c0                	test   %eax,%eax
  80151a:	74 dc                	je     8014f8 <strsplit+0x8c>
			string++;
	}
  80151c:	e9 6e ff ff ff       	jmp    80148f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801521:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801522:	8b 45 14             	mov    0x14(%ebp),%eax
  801525:	8b 00                	mov    (%eax),%eax
  801527:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80152e:	8b 45 10             	mov    0x10(%ebp),%eax
  801531:	01 d0                	add    %edx,%eax
  801533:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801539:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80154c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801553:	eb 4a                	jmp    80159f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801555:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	01 c2                	add    %eax,%edx
  80155d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801560:	8b 45 0c             	mov    0xc(%ebp),%eax
  801563:	01 c8                	add    %ecx,%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801569:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	01 d0                	add    %edx,%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	3c 40                	cmp    $0x40,%al
  801575:	7e 25                	jle    80159c <str2lower+0x5c>
  801577:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80157a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157d:	01 d0                	add    %edx,%eax
  80157f:	8a 00                	mov    (%eax),%al
  801581:	3c 5a                	cmp    $0x5a,%al
  801583:	7f 17                	jg     80159c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801585:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	01 d0                	add    %edx,%eax
  80158d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	01 ca                	add    %ecx,%edx
  801595:	8a 12                	mov    (%edx),%dl
  801597:	83 c2 20             	add    $0x20,%edx
  80159a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80159c:	ff 45 fc             	incl   -0x4(%ebp)
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	e8 01 f8 ff ff       	call   800da8 <strlen>
  8015a7:	83 c4 04             	add    $0x4,%esp
  8015aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015ad:	7f a6                	jg     801555 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015af:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8015ba:	a1 08 50 80 00       	mov    0x805008,%eax
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	0f 84 95 00 00 00    	je     80165c <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8015c7:	83 ec 08             	sub    $0x8,%esp
  8015ca:	68 00 00 00 82       	push   $0x82000000
  8015cf:	68 00 00 00 80       	push   $0x80000000
  8015d4:	e8 59 1f 00 00       	call   803532 <initialize_dynamic_allocator>
  8015d9:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8015dc:	e8 93 1d 00 00       	call   803374 <sys_get_uheap_strategy>
  8015e1:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8015e6:	a1 40 50 80 00       	mov    0x805040,%eax
  8015eb:	05 00 10 00 00       	add    $0x1000,%eax
  8015f0:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  8015f5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8015fa:	a3 68 d0 81 00       	mov    %eax,0x81d068
		init_uspinlock(&ulock,"malloc",1);
  8015ff:	83 ec 04             	sub    $0x4,%esp
  801602:	6a 01                	push   $0x1
  801604:	68 e8 49 80 00       	push   $0x8049e8
  801609:	68 40 d1 81 00       	push   $0x81d140
  80160e:	e8 1a 29 00 00       	call   803f2d <init_uspinlock>
  801613:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801616:	c7 05 20 d1 81 00 00 	movl   $0x0,0x81d120
  80161d:	00 00 00 
  801620:	c7 05 24 d1 81 00 00 	movl   $0x0,0x81d124
  801627:	00 00 00 
  80162a:	c7 05 2c d1 81 00 00 	movl   $0x0,0x81d12c
  801631:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801634:	c7 05 30 d1 81 00 00 	movl   $0x0,0x81d130
  80163b:	00 00 00 
  80163e:	c7 05 34 d1 81 00 00 	movl   $0x0,0x81d134
  801645:	00 00 00 
  801648:	c7 05 3c d1 81 00 00 	movl   $0x0,0x81d13c
  80164f:	00 00 00 
		__firstTimeFlag = 0;
  801652:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801659:	00 00 00 
	}
}
  80165c:	90                   	nop
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80166b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801673:	83 ec 08             	sub    $0x8,%esp
  801676:	68 06 04 00 00       	push   $0x406
  80167b:	50                   	push   %eax
  80167c:	e8 3d 19 00 00       	call   802fbe <__sys_allocate_page>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801687:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80168b:	79 14                	jns    8016a1 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	68 f0 49 80 00       	push   $0x8049f0
  801695:	6a 2d                	push   $0x2d
  801697:	68 2c 4a 80 00       	push   $0x804a2c
  80169c:	e8 60 ed ff ff       	call   800401 <_panic>
	return 0;
  8016a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016bc:	83 ec 0c             	sub    $0xc,%esp
  8016bf:	50                   	push   %eax
  8016c0:	e8 40 19 00 00       	call   803005 <__sys_unmap_frame>
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016cf:	79 14                	jns    8016e5 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	68 38 4a 80 00       	push   $0x804a38
  8016d9:	6a 38                	push   $0x38
  8016db:	68 2c 4a 80 00       	push   $0x804a2c
  8016e0:	e8 1c ed ff ff       	call   800401 <_panic>
}
  8016e5:	90                   	nop
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016ee:	e8 c1 fe ff ff       	call   8015b4 <uheap_init>
	if (size == 0) return NULL ;
  8016f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016f7:	75 0a                	jne    801703 <malloc+0x1b>
  8016f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fe:	e9 e1 04 00 00       	jmp    801be4 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801703:	83 ec 0c             	sub    $0xc,%esp
  801706:	68 40 d1 81 00       	push   $0x81d140
  80170b:	e8 6c 28 00 00       	call   803f7c <acquire_uspinlock>
  801710:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801713:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  80171a:	77 23                	ja     80173f <malloc+0x57>
		release_uspinlock(&ulock);
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	68 40 d1 81 00       	push   $0x81d140
  801724:	e8 ab 28 00 00       	call   803fd4 <release_uspinlock>
  801729:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  80172c:	83 ec 0c             	sub    $0xc,%esp
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	e8 dd 1f 00 00       	call   803714 <alloc_block>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	e9 a5 04 00 00       	jmp    801be4 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80173f:	83 ec 0c             	sub    $0xc,%esp
  801742:	6a 10                	push   $0x10
  801744:	e8 cb 1f 00 00       	call   803714 <alloc_block>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  80174f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801753:	75 0a                	jne    80175f <malloc+0x77>
			return NULL;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	e9 85 04 00 00       	jmp    801be4 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  80175f:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801766:	8b 55 08             	mov    0x8(%ebp),%edx
  801769:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80176c:	01 d0                	add    %edx,%eax
  80176e:	48                   	dec    %eax
  80176f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801775:	ba 00 00 00 00       	mov    $0x0,%edx
  80177a:	f7 75 e8             	divl   -0x18(%ebp)
  80177d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801780:	29 d0                	sub    %edx,%eax
  801782:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801785:	a1 24 d1 81 00       	mov    0x81d124,%eax
  80178a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80178d:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801792:	85 c0                	test   %eax,%eax
  801794:	74 0f                	je     8017a5 <malloc+0xbd>
  801796:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801799:	8b 40 04             	mov    0x4(%eax),%eax
  80179c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80179f:	0f 83 ea 00 00 00    	jae    80188f <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  8017a5:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8017aa:	2b 45 08             	sub    0x8(%ebp),%eax
  8017ad:	89 c2                	mov    %eax,%edx
  8017af:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8017b4:	39 c2                	cmp    %eax,%edx
  8017b6:	0f 86 b9 00 00 00    	jbe    801875 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  8017bc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8017c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  8017c4:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	01 d0                	add    %edx,%eax
  8017cf:	a3 68 d0 81 00       	mov    %eax,0x81d068
					allocblock->startva = requestedblockva;
  8017d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8017da:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8017dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017df:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e2:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8017e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017e9:	75 14                	jne    8017ff <malloc+0x117>
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	68 78 4a 80 00       	push   $0x804a78
  8017f3:	6a 60                	push   $0x60
  8017f5:	68 2c 4a 80 00       	push   $0x804a2c
  8017fa:	e8 02 ec ff ff       	call   800401 <_panic>
  8017ff:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801805:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801808:	89 50 0c             	mov    %edx,0xc(%eax)
  80180b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180e:	8b 40 0c             	mov    0xc(%eax),%eax
  801811:	85 c0                	test   %eax,%eax
  801813:	74 0d                	je     801822 <malloc+0x13a>
  801815:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80181a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80181d:	89 50 08             	mov    %edx,0x8(%eax)
  801820:	eb 08                	jmp    80182a <malloc+0x142>
  801822:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801825:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80182a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80182d:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801832:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801835:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80183c:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801841:	40                   	inc    %eax
  801842:	a3 3c d1 81 00       	mov    %eax,0x81d13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184a:	8b 00                	mov    (%eax),%eax
  80184c:	83 ec 08             	sub    $0x8,%esp
  80184f:	ff 75 08             	pushl  0x8(%ebp)
  801852:	50                   	push   %eax
  801853:	e8 34 1c 00 00       	call   80348c <sys_allocate_user_mem>
  801858:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	68 40 d1 81 00       	push   $0x81d140
  801863:	e8 6c 27 00 00       	call   803fd4 <release_uspinlock>
  801868:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80186b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186e:	8b 00                	mov    (%eax),%eax
  801870:	e9 6f 03 00 00       	jmp    801be4 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	68 40 d1 81 00       	push   $0x81d140
  80187d:	e8 52 27 00 00       	call   803fd4 <release_uspinlock>
  801882:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801885:	b8 00 00 00 00       	mov    $0x0,%eax
  80188a:	e9 55 03 00 00       	jmp    801be4 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80188f:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801894:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801897:	e9 39 03 00 00       	jmp    801bd5 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  80189c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189f:	8b 40 04             	mov    0x4(%eax),%eax
  8018a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018a5:	0f 86 e7 01 00 00    	jbe    801a92 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  8018ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ae:	8b 10                	mov    (%eax),%edx
  8018b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b3:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  8018b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018bb:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8018be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018c2:	75 14                	jne    8018d8 <malloc+0x1f0>
  8018c4:	83 ec 04             	sub    $0x4,%esp
  8018c7:	68 78 4a 80 00       	push   $0x804a78
  8018cc:	6a 72                	push   $0x72
  8018ce:	68 2c 4a 80 00       	push   $0x804a2c
  8018d3:	e8 29 eb ff ff       	call   800401 <_panic>
  8018d8:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8018de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e1:	89 50 0c             	mov    %edx,0xc(%eax)
  8018e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	74 0d                	je     8018fb <malloc+0x213>
  8018ee:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8018f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018f6:	89 50 08             	mov    %edx,0x8(%eax)
  8018f9:	eb 08                	jmp    801903 <malloc+0x21b>
  8018fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018fe:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801903:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801906:	a3 34 d1 81 00       	mov    %eax,0x81d134
  80190b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80190e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801915:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80191a:	40                   	inc    %eax
  80191b:	a3 3c d1 81 00       	mov    %eax,0x81d13c
                lastfreeelement->startva += size;
  801920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801923:	8b 10                	mov    (%eax),%edx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	01 c2                	add    %eax,%edx
  80192a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80192d:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  80192f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801932:	8b 40 04             	mov    0x4(%eax),%eax
  801935:	2b 45 08             	sub    0x8(%ebp),%eax
  801938:	89 c2                	mov    %eax,%edx
  80193a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193d:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801940:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801945:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801948:	e9 0d 01 00 00       	jmp    801a5a <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  80194d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801950:	8b 50 04             	mov    0x4(%eax),%edx
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801956:	8b 40 04             	mov    0x4(%eax),%eax
  801959:	39 c2                	cmp    %eax,%edx
  80195b:	0f 83 f0 00 00 00    	jae    801a51 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801961:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801965:	75 14                	jne    80197b <malloc+0x293>
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	68 9b 4a 80 00       	push   $0x804a9b
  80196f:	6a 7a                	push   $0x7a
  801971:	68 2c 4a 80 00       	push   $0x804a2c
  801976:	e8 86 ea ff ff       	call   800401 <_panic>
  80197b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80197e:	8b 40 08             	mov    0x8(%eax),%eax
  801981:	85 c0                	test   %eax,%eax
  801983:	74 11                	je     801996 <malloc+0x2ae>
  801985:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801988:	8b 40 08             	mov    0x8(%eax),%eax
  80198b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80198e:	8b 52 0c             	mov    0xc(%edx),%edx
  801991:	89 50 0c             	mov    %edx,0xc(%eax)
  801994:	eb 0b                	jmp    8019a1 <malloc+0x2b9>
  801996:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801999:	8b 40 0c             	mov    0xc(%eax),%eax
  80199c:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8019a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	74 11                	je     8019bc <malloc+0x2d4>
  8019ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019b4:	8b 52 08             	mov    0x8(%edx),%edx
  8019b7:	89 50 08             	mov    %edx,0x8(%eax)
  8019ba:	eb 0b                	jmp    8019c7 <malloc+0x2df>
  8019bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019bf:	8b 40 08             	mov    0x8(%eax),%eax
  8019c2:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8019c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8019d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8019db:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8019e0:	48                   	dec    %eax
  8019e1:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8019e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019ea:	74 06                	je     8019f2 <malloc+0x30a>
  8019ec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019f0:	75 14                	jne    801a06 <malloc+0x31e>
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	68 bc 4a 80 00       	push   $0x804abc
  8019fa:	6a 7b                	push   $0x7b
  8019fc:	68 2c 4a 80 00       	push   $0x804a2c
  801a01:	e8 fb e9 ff ff       	call   800401 <_panic>
  801a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a09:	8b 50 0c             	mov    0xc(%eax),%edx
  801a0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a0f:	89 50 0c             	mov    %edx,0xc(%eax)
  801a12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a18:	89 50 08             	mov    %edx,0x8(%eax)
  801a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a21:	85 c0                	test   %eax,%eax
  801a23:	74 0e                	je     801a33 <malloc+0x34b>
  801a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a28:	8b 40 0c             	mov    0xc(%eax),%eax
  801a2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a2e:	89 50 08             	mov    %edx,0x8(%eax)
  801a31:	eb 08                	jmp    801a3b <malloc+0x353>
  801a33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a36:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a41:	89 50 0c             	mov    %edx,0xc(%eax)
  801a44:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801a49:	40                   	inc    %eax
  801a4a:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		break;
  801a4f:	eb 13                	jmp    801a64 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a54:	8b 40 08             	mov    0x8(%eax),%eax
  801a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801a5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a5e:	0f 85 e9 fe ff ff    	jne    80194d <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a67:	8b 00                	mov    (%eax),%eax
  801a69:	83 ec 08             	sub    $0x8,%esp
  801a6c:	ff 75 08             	pushl  0x8(%ebp)
  801a6f:	50                   	push   %eax
  801a70:	e8 17 1a 00 00       	call   80348c <sys_allocate_user_mem>
  801a75:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	68 40 d1 81 00       	push   $0x81d140
  801a80:	e8 4f 25 00 00       	call   803fd4 <release_uspinlock>
  801a85:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a8b:	8b 00                	mov    (%eax),%eax
  801a8d:	e9 52 01 00 00       	jmp    801be4 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a95:	8b 40 04             	mov    0x4(%eax),%eax
  801a98:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a9b:	0f 85 2b 01 00 00    	jne    801bcc <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa4:	8b 10                	mov    (%eax),%edx
  801aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa9:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aae:	8b 55 08             	mov    0x8(%ebp),%edx
  801ab1:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801ab4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ab8:	75 17                	jne    801ad1 <malloc+0x3e9>
  801aba:	83 ec 04             	sub    $0x4,%esp
  801abd:	68 78 4a 80 00       	push   $0x804a78
  801ac2:	68 89 00 00 00       	push   $0x89
  801ac7:	68 2c 4a 80 00       	push   $0x804a2c
  801acc:	e8 30 e9 ff ff       	call   800401 <_panic>
  801ad1:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801ad7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ada:	89 50 0c             	mov    %edx,0xc(%eax)
  801add:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ae0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	74 0d                	je     801af4 <malloc+0x40c>
  801ae7:	a1 34 d1 81 00       	mov    0x81d134,%eax
  801aec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aef:	89 50 08             	mov    %edx,0x8(%eax)
  801af2:	eb 08                	jmp    801afc <malloc+0x414>
  801af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af7:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aff:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801b0e:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801b13:	40                   	inc    %eax
  801b14:	a3 3c d1 81 00       	mov    %eax,0x81d13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801b19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b1d:	75 17                	jne    801b36 <malloc+0x44e>
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	68 9b 4a 80 00       	push   $0x804a9b
  801b27:	68 8a 00 00 00       	push   $0x8a
  801b2c:	68 2c 4a 80 00       	push   $0x804a2c
  801b31:	e8 cb e8 ff ff       	call   800401 <_panic>
  801b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b39:	8b 40 08             	mov    0x8(%eax),%eax
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	74 11                	je     801b51 <malloc+0x469>
  801b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b43:	8b 40 08             	mov    0x8(%eax),%eax
  801b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b49:	8b 52 0c             	mov    0xc(%edx),%edx
  801b4c:	89 50 0c             	mov    %edx,0xc(%eax)
  801b4f:	eb 0b                	jmp    801b5c <malloc+0x474>
  801b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b54:	8b 40 0c             	mov    0xc(%eax),%eax
  801b57:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b62:	85 c0                	test   %eax,%eax
  801b64:	74 11                	je     801b77 <malloc+0x48f>
  801b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b69:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6f:	8b 52 08             	mov    0x8(%edx),%edx
  801b72:	89 50 08             	mov    %edx,0x8(%eax)
  801b75:	eb 0b                	jmp    801b82 <malloc+0x49a>
  801b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7a:	8b 40 08             	mov    0x8(%eax),%eax
  801b7d:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b85:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801b96:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801b9b:	48                   	dec    %eax
  801b9c:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba4:	8b 00                	mov    (%eax),%eax
  801ba6:	83 ec 08             	sub    $0x8,%esp
  801ba9:	ff 75 08             	pushl  0x8(%ebp)
  801bac:	50                   	push   %eax
  801bad:	e8 da 18 00 00       	call   80348c <sys_allocate_user_mem>
  801bb2:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801bb5:	83 ec 0c             	sub    $0xc,%esp
  801bb8:	68 40 d1 81 00       	push   $0x81d140
  801bbd:	e8 12 24 00 00       	call   803fd4 <release_uspinlock>
  801bc2:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc8:	8b 00                	mov    (%eax),%eax
  801bca:	eb 18                	jmp    801be4 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcf:	8b 40 08             	mov    0x8(%eax),%eax
  801bd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801bd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bd9:	0f 85 bd fc ff ff    	jne    80189c <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801bf2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bf5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bfa:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801bfd:	e8 b2 f9 ff ff       	call   8015b4 <uheap_init>
		acquire_uspinlock(&ulock);
  801c02:	83 ec 0c             	sub    $0xc,%esp
  801c05:	68 40 d1 81 00       	push   $0x81d140
  801c0a:	e8 6d 23 00 00       	call   803f7c <acquire_uspinlock>
  801c0f:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801c12:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c17:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801c1a:	73 23                	jae    801c3f <free+0x59>
			free_block(virtual_address);
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	e8 89 1f 00 00       	call   803bb0 <free_block>
  801c27:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801c2a:	83 ec 0c             	sub    $0xc,%esp
  801c2d:	68 40 d1 81 00       	push   $0x81d140
  801c32:	e8 9d 23 00 00       	call   803fd4 <release_uspinlock>
  801c37:	83 c4 10             	add    $0x10,%esp
			return;
  801c3a:	e9 35 07 00 00       	jmp    802374 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801c3f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c44:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801c47:	72 30                	jb     801c79 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801c49:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c4e:	83 ec 04             	sub    $0x4,%esp
  801c51:	50                   	push   %eax
  801c52:	ff 75 d8             	pushl  -0x28(%ebp)
  801c55:	68 f1 4a 80 00       	push   $0x804af1
  801c5a:	e8 70 ea ff ff       	call   8006cf <cprintf>
  801c5f:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801c62:	83 ec 04             	sub    $0x4,%esp
  801c65:	68 f9 4a 80 00       	push   $0x804af9
  801c6a:	68 a7 00 00 00       	push   $0xa7
  801c6f:	68 2c 4a 80 00       	push   $0x804a2c
  801c74:	e8 88 e7 ff ff       	call   800401 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801c79:	83 ec 0c             	sub    $0xc,%esp
  801c7c:	6a 10                	push   $0x10
  801c7e:	e8 91 1a 00 00       	call   803714 <alloc_block>
  801c83:	83 c4 10             	add    $0x10,%esp
  801c86:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801c89:	83 ec 0c             	sub    $0xc,%esp
  801c8c:	6a 10                	push   $0x10
  801c8e:	e8 81 1a 00 00       	call   803714 <alloc_block>
  801c93:	83 c4 10             	add    $0x10,%esp
  801c96:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801c99:	a1 30 d1 81 00       	mov    0x81d130,%eax
  801c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801ca1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801ca8:	eb 1c                	jmp    801cc6 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cad:	8b 00                	mov    (%eax),%eax
  801caf:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801cb2:	75 09                	jne    801cbd <free+0xd7>
				foundVA = 1;
  801cb4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801cbb:	eb 0f                	jmp    801ccc <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc0:	8b 40 08             	mov    0x8(%eax),%eax
  801cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cca:	75 de                	jne    801caa <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801ccc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cd0:	75 17                	jne    801ce9 <free+0x103>
				panic("INVALID ADDRESS!");
  801cd2:	83 ec 04             	sub    $0x4,%esp
  801cd5:	68 16 4b 80 00       	push   $0x804b16
  801cda:	68 be 00 00 00       	push   $0xbe
  801cdf:	68 2c 4a 80 00       	push   $0x804a2c
  801ce4:	e8 18 e7 ff ff       	call   800401 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cec:	8b 10                	mov    (%eax),%edx
  801cee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cf1:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf6:	8b 50 04             	mov    0x4(%eax),%edx
  801cf9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cfc:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801cff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d03:	75 17                	jne    801d1c <free+0x136>
  801d05:	83 ec 04             	sub    $0x4,%esp
  801d08:	68 9b 4a 80 00       	push   $0x804a9b
  801d0d:	68 c8 00 00 00       	push   $0xc8
  801d12:	68 2c 4a 80 00       	push   $0x804a2c
  801d17:	e8 e5 e6 ff ff       	call   800401 <_panic>
  801d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1f:	8b 40 08             	mov    0x8(%eax),%eax
  801d22:	85 c0                	test   %eax,%eax
  801d24:	74 11                	je     801d37 <free+0x151>
  801d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d29:	8b 40 08             	mov    0x8(%eax),%eax
  801d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d2f:	8b 52 0c             	mov    0xc(%edx),%edx
  801d32:	89 50 0c             	mov    %edx,0xc(%eax)
  801d35:	eb 0b                	jmp    801d42 <free+0x15c>
  801d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3d:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d45:	8b 40 0c             	mov    0xc(%eax),%eax
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	74 11                	je     801d5d <free+0x177>
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d55:	8b 52 08             	mov    0x8(%edx),%edx
  801d58:	89 50 08             	mov    %edx,0x8(%eax)
  801d5b:	eb 0b                	jmp    801d68 <free+0x182>
  801d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d60:	8b 40 08             	mov    0x8(%eax),%eax
  801d63:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d75:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801d7c:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801d81:	48                   	dec    %eax
  801d82:	a3 3c d1 81 00       	mov    %eax,0x81d13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8a:	8b 50 04             	mov    0x4(%eax),%edx
  801d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d90:	8b 00                	mov    (%eax),%eax
  801d92:	83 ec 08             	sub    $0x8,%esp
  801d95:	52                   	push   %edx
  801d96:	50                   	push   %eax
  801d97:	e8 d4 16 00 00       	call   803470 <sys_free_user_mem>
  801d9c:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801d9f:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801da4:	85 c0                	test   %eax,%eax
  801da6:	75 7a                	jne    801e22 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801da8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801dac:	75 17                	jne    801dc5 <free+0x1df>
  801dae:	83 ec 04             	sub    $0x4,%esp
  801db1:	68 28 4b 80 00       	push   $0x804b28
  801db6:	68 d0 00 00 00       	push   $0xd0
  801dbb:	68 2c 4a 80 00       	push   $0x804a2c
  801dc0:	e8 3c e6 ff ff       	call   800401 <_panic>
  801dc5:	8b 15 20 d1 81 00    	mov    0x81d120,%edx
  801dcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dce:	89 50 08             	mov    %edx,0x8(%eax)
  801dd1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dd4:	8b 40 08             	mov    0x8(%eax),%eax
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	74 0d                	je     801de8 <free+0x202>
  801ddb:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801de0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801de3:	89 50 0c             	mov    %edx,0xc(%eax)
  801de6:	eb 08                	jmp    801df0 <free+0x20a>
  801de8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801deb:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801df0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801df3:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801df8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dfb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e02:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801e07:	40                   	inc    %eax
  801e08:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			release_uspinlock(&ulock);
  801e0d:	83 ec 0c             	sub    $0xc,%esp
  801e10:	68 40 d1 81 00       	push   $0x81d140
  801e15:	e8 ba 21 00 00       	call   803fd4 <release_uspinlock>
  801e1a:	83 c4 10             	add    $0x10,%esp
			return;
  801e1d:	e9 52 05 00 00       	jmp    802374 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801e22:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801e27:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801e2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801e31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801e38:	e9 d2 00 00 00       	jmp    801f0f <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e40:	8b 10                	mov    (%eax),%edx
  801e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e45:	8b 40 04             	mov    0x4(%eax),%eax
  801e48:	01 c2                	add    %eax,%edx
  801e4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e4d:	8b 00                	mov    (%eax),%eax
  801e4f:	39 c2                	cmp    %eax,%edx
  801e51:	0f 85 af 00 00 00    	jne    801f06 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e5a:	8b 10                	mov    (%eax),%edx
  801e5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e5f:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e64:	8b 50 04             	mov    0x4(%eax),%edx
  801e67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e6a:	8b 40 04             	mov    0x4(%eax),%eax
  801e6d:	01 c2                	add    %eax,%edx
  801e6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e72:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801e75:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e79:	75 17                	jne    801e92 <free+0x2ac>
  801e7b:	83 ec 04             	sub    $0x4,%esp
  801e7e:	68 9b 4a 80 00       	push   $0x804a9b
  801e83:	68 df 00 00 00       	push   $0xdf
  801e88:	68 2c 4a 80 00       	push   $0x804a2c
  801e8d:	e8 6f e5 ff ff       	call   800401 <_panic>
  801e92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e95:	8b 40 08             	mov    0x8(%eax),%eax
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	74 11                	je     801ead <free+0x2c7>
  801e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9f:	8b 40 08             	mov    0x8(%eax),%eax
  801ea2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ea5:	8b 52 0c             	mov    0xc(%edx),%edx
  801ea8:	89 50 0c             	mov    %edx,0xc(%eax)
  801eab:	eb 0b                	jmp    801eb8 <free+0x2d2>
  801ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb3:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	74 11                	je     801ed3 <free+0x2ed>
  801ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ecb:	8b 52 08             	mov    0x8(%edx),%edx
  801ece:	89 50 08             	mov    %edx,0x8(%eax)
  801ed1:	eb 0b                	jmp    801ede <free+0x2f8>
  801ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed6:	8b 40 08             	mov    0x8(%eax),%eax
  801ed9:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801ede:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eeb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801ef2:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801ef7:	48                   	dec    %eax
  801ef8:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				mergeprev = 1;
  801efd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801f04:	eb 13                	jmp    801f19 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f09:	8b 40 08             	mov    0x8(%eax),%eax
  801f0c:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801f0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f13:	0f 85 24 ff ff ff    	jne    801e3d <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801f19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f1c:	8b 10                	mov    (%eax),%edx
  801f1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f21:	8b 40 04             	mov    0x4(%eax),%eax
  801f24:	01 c2                	add    %eax,%edx
  801f26:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f2b:	39 c2                	cmp    %eax,%edx
  801f2d:	75 44                	jne    801f73 <free+0x38d>

			if(mergeprev){
  801f2f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f33:	74 1f                	je     801f54 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801f35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f38:	8b 00                	mov    (%eax),%eax
  801f3a:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801f3f:	83 ec 0c             	sub    $0xc,%esp
  801f42:	68 40 d1 81 00       	push   $0x81d140
  801f47:	e8 88 20 00 00       	call   803fd4 <release_uspinlock>
  801f4c:	83 c4 10             	add    $0x10,%esp
				return;
  801f4f:	e9 20 04 00 00       	jmp    802374 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801f54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f57:	8b 00                	mov    (%eax),%eax
  801f59:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801f5e:	83 ec 0c             	sub    $0xc,%esp
  801f61:	68 40 d1 81 00       	push   $0x81d140
  801f66:	e8 69 20 00 00       	call   803fd4 <release_uspinlock>
  801f6b:	83 c4 10             	add    $0x10,%esp
				return;
  801f6e:	e9 01 04 00 00       	jmp    802374 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  801f73:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801f78:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  801f7b:	e9 7d 01 00 00       	jmp    8020fd <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  801f80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f83:	8b 10                	mov    (%eax),%edx
  801f85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f88:	8b 40 04             	mov    0x4(%eax),%eax
  801f8b:	01 c2                	add    %eax,%edx
  801f8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f90:	8b 00                	mov    (%eax),%eax
  801f92:	39 c2                	cmp    %eax,%edx
  801f94:	0f 85 5a 01 00 00    	jne    8020f4 <free+0x50e>
				if (mergeprev){
  801f9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f9e:	0f 84 a1 00 00 00    	je     802045 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  801fa4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fa7:	8b 50 04             	mov    0x4(%eax),%edx
  801faa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fad:	8b 40 04             	mov    0x4(%eax),%eax
  801fb0:	01 c2                	add    %eax,%edx
  801fb2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fb5:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  801fb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fbc:	75 17                	jne    801fd5 <free+0x3ef>
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	68 9b 4a 80 00       	push   $0x804a9b
  801fc6:	68 0a 01 00 00       	push   $0x10a
  801fcb:	68 2c 4a 80 00       	push   $0x804a2c
  801fd0:	e8 2c e4 ff ff       	call   800401 <_panic>
  801fd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd8:	8b 40 08             	mov    0x8(%eax),%eax
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	74 11                	je     801ff0 <free+0x40a>
  801fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe2:	8b 40 08             	mov    0x8(%eax),%eax
  801fe5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fe8:	8b 52 0c             	mov    0xc(%edx),%edx
  801feb:	89 50 0c             	mov    %edx,0xc(%eax)
  801fee:	eb 0b                	jmp    801ffb <free+0x415>
  801ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff6:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801ffb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  802001:	85 c0                	test   %eax,%eax
  802003:	74 11                	je     802016 <free+0x430>
  802005:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802008:	8b 40 0c             	mov    0xc(%eax),%eax
  80200b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80200e:	8b 52 08             	mov    0x8(%edx),%edx
  802011:	89 50 08             	mov    %edx,0x8(%eax)
  802014:	eb 0b                	jmp    802021 <free+0x43b>
  802016:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802019:	8b 40 08             	mov    0x8(%eax),%eax
  80201c:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802021:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802024:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80202b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802035:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80203a:	48                   	dec    %eax
  80203b:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					break;
  802040:	e9 c2 00 00 00       	jmp    802107 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  802045:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802048:	8b 10                	mov    (%eax),%edx
  80204a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80204d:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  80204f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802052:	8b 50 04             	mov    0x4(%eax),%edx
  802055:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802058:	8b 40 04             	mov    0x4(%eax),%eax
  80205b:	01 c2                	add    %eax,%edx
  80205d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802060:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802063:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802067:	75 17                	jne    802080 <free+0x49a>
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	68 9b 4a 80 00       	push   $0x804a9b
  802071:	68 10 01 00 00       	push   $0x110
  802076:	68 2c 4a 80 00       	push   $0x804a2c
  80207b:	e8 81 e3 ff ff       	call   800401 <_panic>
  802080:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802083:	8b 40 08             	mov    0x8(%eax),%eax
  802086:	85 c0                	test   %eax,%eax
  802088:	74 11                	je     80209b <free+0x4b5>
  80208a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208d:	8b 40 08             	mov    0x8(%eax),%eax
  802090:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802093:	8b 52 0c             	mov    0xc(%edx),%edx
  802096:	89 50 0c             	mov    %edx,0xc(%eax)
  802099:	eb 0b                	jmp    8020a6 <free+0x4c0>
  80209b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209e:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a1:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8020a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	74 11                	je     8020c1 <free+0x4db>
  8020b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020b9:	8b 52 08             	mov    0x8(%edx),%edx
  8020bc:	89 50 08             	mov    %edx,0x8(%eax)
  8020bf:	eb 0b                	jmp    8020cc <free+0x4e6>
  8020c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c4:	8b 40 08             	mov    0x8(%eax),%eax
  8020c7:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8020cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020e0:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8020e5:	48                   	dec    %eax
  8020e6:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					mergenext = 1;
  8020eb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8020f2:	eb 13                	jmp    802107 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8020f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f7:	8b 40 08             	mov    0x8(%eax),%eax
  8020fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  8020fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802101:	0f 85 79 fe ff ff    	jne    801f80 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  802107:	a1 20 d1 81 00       	mov    0x81d120,%eax
  80210c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  80210f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802113:	0f 85 ad 00 00 00    	jne    8021c6 <free+0x5e0>
  802119:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80211d:	0f 84 c3 01 00 00    	je     8022e6 <free+0x700>
				while(currentfree != NULL){
  802123:	e9 9e 00 00 00       	jmp    8021c6 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  802128:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80212b:	8b 50 04             	mov    0x4(%eax),%edx
  80212e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802131:	8b 40 04             	mov    0x4(%eax),%eax
  802134:	39 c2                	cmp    %eax,%edx
  802136:	0f 83 81 00 00 00    	jae    8021bd <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  80213c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802140:	74 06                	je     802148 <free+0x562>
  802142:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802146:	75 17                	jne    80215f <free+0x579>
  802148:	83 ec 04             	sub    $0x4,%esp
  80214b:	68 bc 4a 80 00       	push   $0x804abc
  802150:	68 23 01 00 00       	push   $0x123
  802155:	68 2c 4a 80 00       	push   $0x804a2c
  80215a:	e8 a2 e2 ff ff       	call   800401 <_panic>
  80215f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802162:	8b 50 0c             	mov    0xc(%eax),%edx
  802165:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802168:	89 50 0c             	mov    %edx,0xc(%eax)
  80216b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80216e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802171:	89 50 08             	mov    %edx,0x8(%eax)
  802174:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802177:	8b 40 0c             	mov    0xc(%eax),%eax
  80217a:	85 c0                	test   %eax,%eax
  80217c:	74 0e                	je     80218c <free+0x5a6>
  80217e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802181:	8b 40 0c             	mov    0xc(%eax),%eax
  802184:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802187:	89 50 08             	mov    %edx,0x8(%eax)
  80218a:	eb 08                	jmp    802194 <free+0x5ae>
  80218c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80218f:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802194:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802197:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80219a:	89 50 0c             	mov    %edx,0xc(%eax)
  80219d:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8021a2:	40                   	inc    %eax
  8021a3:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  8021a8:	83 ec 0c             	sub    $0xc,%esp
  8021ab:	68 40 d1 81 00       	push   $0x81d140
  8021b0:	e8 1f 1e 00 00       	call   803fd4 <release_uspinlock>
  8021b5:	83 c4 10             	add    $0x10,%esp
							return;
  8021b8:	e9 b7 01 00 00       	jmp    802374 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8021bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c0:	8b 40 08             	mov    0x8(%eax),%eax
  8021c3:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  8021c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021ca:	0f 85 58 ff ff ff    	jne    802128 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  8021d0:	83 ec 0c             	sub    $0xc,%esp
  8021d3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8021d6:	e8 d5 19 00 00       	call   803bb0 <free_block>
  8021db:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8021de:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021e2:	75 17                	jne    8021fb <free+0x615>
  8021e4:	83 ec 04             	sub    $0x4,%esp
  8021e7:	68 78 4a 80 00       	push   $0x804a78
  8021ec:	68 2a 01 00 00       	push   $0x12a
  8021f1:	68 2c 4a 80 00       	push   $0x804a2c
  8021f6:	e8 06 e2 ff ff       	call   800401 <_panic>
  8021fb:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  802201:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802204:	89 50 0c             	mov    %edx,0xc(%eax)
  802207:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80220a:	8b 40 0c             	mov    0xc(%eax),%eax
  80220d:	85 c0                	test   %eax,%eax
  80220f:	74 0d                	je     80221e <free+0x638>
  802211:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802216:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802219:	89 50 08             	mov    %edx,0x8(%eax)
  80221c:	eb 08                	jmp    802226 <free+0x640>
  80221e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802221:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802226:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802229:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80222e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802231:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802238:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80223d:	40                   	inc    %eax
  80223e:	a3 2c d1 81 00       	mov    %eax,0x81d12c
  802243:	e9 1b 01 00 00       	jmp    802363 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  802248:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80224b:	8b 50 04             	mov    0x4(%eax),%edx
  80224e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802251:	8b 40 04             	mov    0x4(%eax),%eax
  802254:	39 c2                	cmp    %eax,%edx
  802256:	0f 83 81 00 00 00    	jae    8022dd <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  80225c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802260:	74 06                	je     802268 <free+0x682>
  802262:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802266:	75 17                	jne    80227f <free+0x699>
  802268:	83 ec 04             	sub    $0x4,%esp
  80226b:	68 bc 4a 80 00       	push   $0x804abc
  802270:	68 30 01 00 00       	push   $0x130
  802275:	68 2c 4a 80 00       	push   $0x804a2c
  80227a:	e8 82 e1 ff ff       	call   800401 <_panic>
  80227f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802282:	8b 50 0c             	mov    0xc(%eax),%edx
  802285:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802288:	89 50 0c             	mov    %edx,0xc(%eax)
  80228b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80228e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802291:	89 50 08             	mov    %edx,0x8(%eax)
  802294:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802297:	8b 40 0c             	mov    0xc(%eax),%eax
  80229a:	85 c0                	test   %eax,%eax
  80229c:	74 0e                	je     8022ac <free+0x6c6>
  80229e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8022a7:	89 50 08             	mov    %edx,0x8(%eax)
  8022aa:	eb 08                	jmp    8022b4 <free+0x6ce>
  8022ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022af:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8022b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8022ba:	89 50 0c             	mov    %edx,0xc(%eax)
  8022bd:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8022c2:	40                   	inc    %eax
  8022c3:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  8022c8:	83 ec 0c             	sub    $0xc,%esp
  8022cb:	68 40 d1 81 00       	push   $0x81d140
  8022d0:	e8 ff 1c 00 00       	call   803fd4 <release_uspinlock>
  8022d5:	83 c4 10             	add    $0x10,%esp
							return;
  8022d8:	e9 97 00 00 00       	jmp    802374 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8022dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e0:	8b 40 08             	mov    0x8(%eax),%eax
  8022e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  8022e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022ea:	0f 85 58 ff ff ff    	jne    802248 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8022f0:	83 ec 0c             	sub    $0xc,%esp
  8022f3:	ff 75 d0             	pushl  -0x30(%ebp)
  8022f6:	e8 b5 18 00 00       	call   803bb0 <free_block>
  8022fb:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8022fe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802302:	75 17                	jne    80231b <free+0x735>
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	68 78 4a 80 00       	push   $0x804a78
  80230c:	68 37 01 00 00       	push   $0x137
  802311:	68 2c 4a 80 00       	push   $0x804a2c
  802316:	e8 e6 e0 ff ff       	call   800401 <_panic>
  80231b:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  802321:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802324:	89 50 0c             	mov    %edx,0xc(%eax)
  802327:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80232a:	8b 40 0c             	mov    0xc(%eax),%eax
  80232d:	85 c0                	test   %eax,%eax
  80232f:	74 0d                	je     80233e <free+0x758>
  802331:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802336:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802339:	89 50 08             	mov    %edx,0x8(%eax)
  80233c:	eb 08                	jmp    802346 <free+0x760>
  80233e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802341:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802346:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802349:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80234e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802351:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802358:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80235d:	40                   	inc    %eax
  80235e:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			}
		release_uspinlock(&ulock);
  802363:	83 ec 0c             	sub    $0xc,%esp
  802366:	68 40 d1 81 00       	push   $0x81d140
  80236b:	e8 64 1c 00 00       	call   803fd4 <release_uspinlock>
  802370:	83 c4 10             	add    $0x10,%esp
		return;
  802373:	90                   	nop
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	83 ec 48             	sub    $0x48,%esp
  80237c:	8b 45 10             	mov    0x10(%ebp),%eax
  80237f:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802382:	e8 2d f2 ff ff       	call   8015b4 <uheap_init>
	if (size == 0) return NULL;
  802387:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80238b:	75 0a                	jne    802397 <smalloc+0x21>
  80238d:	b8 00 00 00 00       	mov    $0x0,%eax
  802392:	e9 84 05 00 00       	jmp    80291b <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802397:	83 ec 0c             	sub    $0xc,%esp
  80239a:	68 40 d1 81 00       	push   $0x81d140
  80239f:	e8 d8 1b 00 00       	call   803f7c <acquire_uspinlock>
  8023a4:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8023a7:	83 ec 0c             	sub    $0xc,%esp
  8023aa:	6a 10                	push   $0x10
  8023ac:	e8 63 13 00 00       	call   803714 <alloc_block>
  8023b1:	83 c4 10             	add    $0x10,%esp
  8023b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  8023b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023bb:	75 0a                	jne    8023c7 <smalloc+0x51>
				return NULL;
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c2:	e9 54 05 00 00       	jmp    80291b <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  8023c7:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8023ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023d4:	01 d0                	add    %edx,%eax
  8023d6:	48                   	dec    %eax
  8023d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e2:	f7 75 e8             	divl   -0x18(%ebp)
  8023e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e8:	29 d0                	sub    %edx,%eax
  8023ea:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8023ed:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8023f2:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8023f5:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	74 0f                	je     80240d <smalloc+0x97>
  8023fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802401:	8b 40 04             	mov    0x4(%eax),%eax
  802404:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802407:	0f 83 25 01 00 00    	jae    802532 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  80240d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802412:	2b 45 0c             	sub    0xc(%ebp),%eax
  802415:	89 c2                	mov    %eax,%edx
  802417:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80241c:	39 c2                	cmp    %eax,%edx
  80241e:	0f 82 f4 00 00 00    	jb     802518 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802424:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802429:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  80242c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802432:	8b 45 0c             	mov    0xc(%ebp),%eax
  802435:	01 d0                	add    %edx,%eax
  802437:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  80243c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802442:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802444:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802447:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244a:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80244d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802451:	75 17                	jne    80246a <smalloc+0xf4>
  802453:	83 ec 04             	sub    $0x4,%esp
  802456:	68 78 4a 80 00       	push   $0x804a78
  80245b:	68 57 01 00 00       	push   $0x157
  802460:	68 2c 4a 80 00       	push   $0x804a2c
  802465:	e8 97 df ff ff       	call   800401 <_panic>
  80246a:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802473:	89 50 0c             	mov    %edx,0xc(%eax)
  802476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802479:	8b 40 0c             	mov    0xc(%eax),%eax
  80247c:	85 c0                	test   %eax,%eax
  80247e:	74 0d                	je     80248d <smalloc+0x117>
  802480:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802485:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802488:	89 50 08             	mov    %edx,0x8(%eax)
  80248b:	eb 08                	jmp    802495 <smalloc+0x11f>
  80248d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802490:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802498:	a3 34 d1 81 00       	mov    %eax,0x81d134
  80249d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8024a7:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8024ac:	40                   	inc    %eax
  8024ad:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8024b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b5:	8b 00                	mov    (%eax),%eax
  8024b7:	89 c2                	mov    %eax,%edx
  8024b9:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8024bd:	52                   	push   %edx
  8024be:	50                   	push   %eax
  8024bf:	ff 75 0c             	pushl  0xc(%ebp)
  8024c2:	ff 75 08             	pushl  0x8(%ebp)
  8024c5:	e8 48 0c 00 00       	call   803112 <sys_create_shared_object>
  8024ca:	83 c4 10             	add    $0x10,%esp
  8024cd:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  8024d0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8024d4:	79 28                	jns    8024fe <smalloc+0x188>
							free_block(allocblock);
  8024d6:	83 ec 0c             	sub    $0xc,%esp
  8024d9:	ff 75 ec             	pushl  -0x14(%ebp)
  8024dc:	e8 cf 16 00 00       	call   803bb0 <free_block>
  8024e1:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8024e4:	83 ec 0c             	sub    $0xc,%esp
  8024e7:	68 40 d1 81 00       	push   $0x81d140
  8024ec:	e8 e3 1a 00 00       	call   803fd4 <release_uspinlock>
  8024f1:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f9:	e9 1d 04 00 00       	jmp    80291b <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  8024fe:	83 ec 0c             	sub    $0xc,%esp
  802501:	68 40 d1 81 00       	push   $0x81d140
  802506:	e8 c9 1a 00 00       	call   803fd4 <release_uspinlock>
  80250b:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  80250e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802511:	8b 00                	mov    (%eax),%eax
  802513:	e9 03 04 00 00       	jmp    80291b <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  802518:	83 ec 0c             	sub    $0xc,%esp
  80251b:	68 40 d1 81 00       	push   $0x81d140
  802520:	e8 af 1a 00 00       	call   803fd4 <release_uspinlock>
  802525:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802528:	b8 00 00 00 00       	mov    $0x0,%eax
  80252d:	e9 e9 03 00 00       	jmp    80291b <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802532:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802537:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  80253a:	e9 af 03 00 00       	jmp    8028ee <smalloc+0x578>
				if(size<currentfreeelement->size){
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	8b 40 04             	mov    0x4(%eax),%eax
  802545:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802548:	0f 86 28 02 00 00    	jbe    802776 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  80254e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802551:	8b 10                	mov    (%eax),%edx
  802553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802556:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  802558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255e:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802561:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802565:	75 17                	jne    80257e <smalloc+0x208>
  802567:	83 ec 04             	sub    $0x4,%esp
  80256a:	68 78 4a 80 00       	push   $0x804a78
  80256f:	68 6f 01 00 00       	push   $0x16f
  802574:	68 2c 4a 80 00       	push   $0x804a2c
  802579:	e8 83 de ff ff       	call   800401 <_panic>
  80257e:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802587:	89 50 0c             	mov    %edx,0xc(%eax)
  80258a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258d:	8b 40 0c             	mov    0xc(%eax),%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	74 0d                	je     8025a1 <smalloc+0x22b>
  802594:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802599:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259c:	89 50 08             	mov    %edx,0x8(%eax)
  80259f:	eb 08                	jmp    8025a9 <smalloc+0x233>
  8025a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a4:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8025a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ac:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8025b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8025bb:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8025c0:	40                   	inc    %eax
  8025c1:	a3 3c d1 81 00       	mov    %eax,0x81d13c
	                lastfreeelement->startva += size;
  8025c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c9:	8b 10                	mov    (%eax),%edx
  8025cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ce:	01 c2                	add    %eax,%edx
  8025d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d3:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  8025d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d8:	8b 40 04             	mov    0x4(%eax),%eax
  8025db:	2b 45 0c             	sub    0xc(%ebp),%eax
  8025de:	89 c2                	mov    %eax,%edx
  8025e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e3:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8025e6:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8025eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  8025ee:	e9 13 01 00 00       	jmp    802706 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  8025f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f6:	8b 50 04             	mov    0x4(%eax),%edx
  8025f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fc:	8b 40 04             	mov    0x4(%eax),%eax
  8025ff:	39 c2                	cmp    %eax,%edx
  802601:	0f 83 f6 00 00 00    	jae    8026fd <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802607:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80260b:	75 17                	jne    802624 <smalloc+0x2ae>
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	68 9b 4a 80 00       	push   $0x804a9b
  802615:	68 77 01 00 00       	push   $0x177
  80261a:	68 2c 4a 80 00       	push   $0x804a2c
  80261f:	e8 dd dd ff ff       	call   800401 <_panic>
  802624:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802627:	8b 40 08             	mov    0x8(%eax),%eax
  80262a:	85 c0                	test   %eax,%eax
  80262c:	74 11                	je     80263f <smalloc+0x2c9>
  80262e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802631:	8b 40 08             	mov    0x8(%eax),%eax
  802634:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802637:	8b 52 0c             	mov    0xc(%edx),%edx
  80263a:	89 50 0c             	mov    %edx,0xc(%eax)
  80263d:	eb 0b                	jmp    80264a <smalloc+0x2d4>
  80263f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802642:	8b 40 0c             	mov    0xc(%eax),%eax
  802645:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80264a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80264d:	8b 40 0c             	mov    0xc(%eax),%eax
  802650:	85 c0                	test   %eax,%eax
  802652:	74 11                	je     802665 <smalloc+0x2ef>
  802654:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802657:	8b 40 0c             	mov    0xc(%eax),%eax
  80265a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80265d:	8b 52 08             	mov    0x8(%edx),%edx
  802660:	89 50 08             	mov    %edx,0x8(%eax)
  802663:	eb 0b                	jmp    802670 <smalloc+0x2fa>
  802665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802668:	8b 40 08             	mov    0x8(%eax),%eax
  80266b:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802670:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802673:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80267a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802684:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802689:	48                   	dec    %eax
  80268a:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80268f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802693:	74 06                	je     80269b <smalloc+0x325>
  802695:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802699:	75 17                	jne    8026b2 <smalloc+0x33c>
  80269b:	83 ec 04             	sub    $0x4,%esp
  80269e:	68 bc 4a 80 00       	push   $0x804abc
  8026a3:	68 78 01 00 00       	push   $0x178
  8026a8:	68 2c 4a 80 00       	push   $0x804a2c
  8026ad:	e8 4f dd ff ff       	call   800401 <_panic>
  8026b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8026b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bb:	89 50 0c             	mov    %edx,0xc(%eax)
  8026be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026c4:	89 50 08             	mov    %edx,0x8(%eax)
  8026c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 0e                	je     8026df <smalloc+0x369>
  8026d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026da:	89 50 08             	mov    %edx,0x8(%eax)
  8026dd:	eb 08                	jmp    8026e7 <smalloc+0x371>
  8026df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e2:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8026e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ed:	89 50 0c             	mov    %edx,0xc(%eax)
  8026f0:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8026f5:	40                   	inc    %eax
  8026f6:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		break;
  8026fb:	eb 13                	jmp    802710 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  8026fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802700:	8b 40 08             	mov    0x8(%eax),%eax
  802703:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80270a:	0f 85 e3 fe ff ff    	jne    8025f3 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802710:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802713:	8b 00                	mov    (%eax),%eax
  802715:	89 c2                	mov    %eax,%edx
  802717:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80271b:	52                   	push   %edx
  80271c:	50                   	push   %eax
  80271d:	ff 75 0c             	pushl  0xc(%ebp)
  802720:	ff 75 08             	pushl  0x8(%ebp)
  802723:	e8 ea 09 00 00       	call   803112 <sys_create_shared_object>
  802728:	83 c4 10             	add    $0x10,%esp
  80272b:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  80272e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802732:	79 28                	jns    80275c <smalloc+0x3e6>
	                	free_block(allocblock);
  802734:	83 ec 0c             	sub    $0xc,%esp
  802737:	ff 75 ec             	pushl  -0x14(%ebp)
  80273a:	e8 71 14 00 00       	call   803bb0 <free_block>
  80273f:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802742:	83 ec 0c             	sub    $0xc,%esp
  802745:	68 40 d1 81 00       	push   $0x81d140
  80274a:	e8 85 18 00 00       	call   803fd4 <release_uspinlock>
  80274f:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802752:	b8 00 00 00 00       	mov    $0x0,%eax
  802757:	e9 bf 01 00 00       	jmp    80291b <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  80275c:	83 ec 0c             	sub    $0xc,%esp
  80275f:	68 40 d1 81 00       	push   $0x81d140
  802764:	e8 6b 18 00 00       	call   803fd4 <release_uspinlock>
  802769:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  80276c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276f:	8b 00                	mov    (%eax),%eax
  802771:	e9 a5 01 00 00       	jmp    80291b <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80277f:	0f 85 60 01 00 00    	jne    8028e5 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 10                	mov    (%eax),%edx
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80278f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802792:	8b 55 0c             	mov    0xc(%ebp),%edx
  802795:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802798:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80279c:	75 17                	jne    8027b5 <smalloc+0x43f>
  80279e:	83 ec 04             	sub    $0x4,%esp
  8027a1:	68 78 4a 80 00       	push   $0x804a78
  8027a6:	68 8c 01 00 00       	push   $0x18c
  8027ab:	68 2c 4a 80 00       	push   $0x804a2c
  8027b0:	e8 4c dc ff ff       	call   800401 <_panic>
  8027b5:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8027bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027be:	89 50 0c             	mov    %edx,0xc(%eax)
  8027c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	74 0d                	je     8027d8 <smalloc+0x462>
  8027cb:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8027d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027d3:	89 50 08             	mov    %edx,0x8(%eax)
  8027d6:	eb 08                	jmp    8027e0 <smalloc+0x46a>
  8027d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027db:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8027e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e3:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8027e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027f2:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8027f7:	40                   	inc    %eax
  8027f8:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8027fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802801:	75 17                	jne    80281a <smalloc+0x4a4>
  802803:	83 ec 04             	sub    $0x4,%esp
  802806:	68 9b 4a 80 00       	push   $0x804a9b
  80280b:	68 8d 01 00 00       	push   $0x18d
  802810:	68 2c 4a 80 00       	push   $0x804a2c
  802815:	e8 e7 db ff ff       	call   800401 <_panic>
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 08             	mov    0x8(%eax),%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	74 11                	je     802835 <smalloc+0x4bf>
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 40 08             	mov    0x8(%eax),%eax
  80282a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282d:	8b 52 0c             	mov    0xc(%edx),%edx
  802830:	89 50 0c             	mov    %edx,0xc(%eax)
  802833:	eb 0b                	jmp    802840 <smalloc+0x4ca>
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 0c             	mov    0xc(%eax),%eax
  80283b:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 40 0c             	mov    0xc(%eax),%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	74 11                	je     80285b <smalloc+0x4e5>
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 40 0c             	mov    0xc(%eax),%eax
  802850:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802853:	8b 52 08             	mov    0x8(%edx),%edx
  802856:	89 50 08             	mov    %edx,0x8(%eax)
  802859:	eb 0b                	jmp    802866 <smalloc+0x4f0>
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 40 08             	mov    0x8(%eax),%eax
  802861:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80287a:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80287f:	48                   	dec    %eax
  802880:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	89 c2                	mov    %eax,%edx
  80288c:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802890:	52                   	push   %edx
  802891:	50                   	push   %eax
  802892:	ff 75 0c             	pushl  0xc(%ebp)
  802895:	ff 75 08             	pushl  0x8(%ebp)
  802898:	e8 75 08 00 00       	call   803112 <sys_create_shared_object>
  80289d:	83 c4 10             	add    $0x10,%esp
  8028a0:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  8028a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8028a7:	79 25                	jns    8028ce <smalloc+0x558>
						free_block(allocblock);
  8028a9:	83 ec 0c             	sub    $0xc,%esp
  8028ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8028af:	e8 fc 12 00 00       	call   803bb0 <free_block>
  8028b4:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8028b7:	83 ec 0c             	sub    $0xc,%esp
  8028ba:	68 40 d1 81 00       	push   $0x81d140
  8028bf:	e8 10 17 00 00       	call   803fd4 <release_uspinlock>
  8028c4:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8028c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cc:	eb 4d                	jmp    80291b <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  8028ce:	83 ec 0c             	sub    $0xc,%esp
  8028d1:	68 40 d1 81 00       	push   $0x81d140
  8028d6:	e8 f9 16 00 00       	call   803fd4 <release_uspinlock>
  8028db:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8028de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e1:	8b 00                	mov    (%eax),%eax
  8028e3:	eb 36                	jmp    80291b <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 08             	mov    0x8(%eax),%eax
  8028eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8028ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f2:	0f 85 47 fc ff ff    	jne    80253f <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8028f8:	83 ec 0c             	sub    $0xc,%esp
  8028fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8028fe:	e8 ad 12 00 00       	call   803bb0 <free_block>
  802903:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802906:	83 ec 0c             	sub    $0xc,%esp
  802909:	68 40 d1 81 00       	push   $0x81d140
  80290e:	e8 c1 16 00 00       	call   803fd4 <release_uspinlock>
  802913:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802916:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80291b:	c9                   	leave  
  80291c:	c3                   	ret    

0080291d <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80291d:	55                   	push   %ebp
  80291e:	89 e5                	mov    %esp,%ebp
  802920:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802923:	e8 8c ec ff ff       	call   8015b4 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802928:	83 ec 0c             	sub    $0xc,%esp
  80292b:	68 40 d1 81 00       	push   $0x81d140
  802930:	e8 47 16 00 00       	call   803f7c <acquire_uspinlock>
  802935:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802938:	83 ec 08             	sub    $0x8,%esp
  80293b:	ff 75 0c             	pushl  0xc(%ebp)
  80293e:	ff 75 08             	pushl  0x8(%ebp)
  802941:	e8 f6 07 00 00       	call   80313c <sys_size_of_shared_object>
  802946:	83 c4 10             	add    $0x10,%esp
  802949:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  80294c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802950:	79 1a                	jns    80296c <sget+0x4f>
			release_uspinlock(&ulock);
  802952:	83 ec 0c             	sub    $0xc,%esp
  802955:	68 40 d1 81 00       	push   $0x81d140
  80295a:	e8 75 16 00 00       	call   803fd4 <release_uspinlock>
  80295f:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802962:	b8 00 00 00 00       	mov    $0x0,%eax
  802967:	e9 6e 05 00 00       	jmp    802eda <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  80296c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802973:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802979:	01 d0                	add    %edx,%eax
  80297b:	48                   	dec    %eax
  80297c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80297f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802982:	ba 00 00 00 00       	mov    $0x0,%edx
  802987:	f7 75 e8             	divl   -0x18(%ebp)
  80298a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298d:	29 d0                	sub    %edx,%eax
  80298f:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802992:	83 ec 0c             	sub    $0xc,%esp
  802995:	6a 10                	push   $0x10
  802997:	e8 78 0d 00 00       	call   803714 <alloc_block>
  80299c:	83 c4 10             	add    $0x10,%esp
  80299f:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  8029a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029a6:	75 0a                	jne    8029b2 <sget+0x95>
			return NULL;
  8029a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ad:	e9 28 05 00 00       	jmp    802eda <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8029b2:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8029b7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8029ba:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8029bf:	85 c0                	test   %eax,%eax
  8029c1:	74 11                	je     8029d4 <sget+0xb7>
  8029c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029c6:	8b 50 04             	mov    0x4(%eax),%edx
  8029c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cc:	39 c2                	cmp    %eax,%edx
  8029ce:	0f 83 21 01 00 00    	jae    802af5 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8029d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d7:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  8029dc:	29 c2                	sub    %eax,%edx
  8029de:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8029e3:	39 c2                	cmp    %eax,%edx
  8029e5:	0f 82 f0 00 00 00    	jb     802adb <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  8029eb:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8029f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  8029f3:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8029f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fc:	01 d0                	add    %edx,%eax
  8029fe:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  802a03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a06:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802a09:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802a0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a11:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802a14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a18:	75 17                	jne    802a31 <sget+0x114>
  802a1a:	83 ec 04             	sub    $0x4,%esp
  802a1d:	68 78 4a 80 00       	push   $0x804a78
  802a22:	68 c8 01 00 00       	push   $0x1c8
  802a27:	68 2c 4a 80 00       	push   $0x804a2c
  802a2c:	e8 d0 d9 ff ff       	call   800401 <_panic>
  802a31:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802a37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a3a:	89 50 0c             	mov    %edx,0xc(%eax)
  802a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a40:	8b 40 0c             	mov    0xc(%eax),%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 0d                	je     802a54 <sget+0x137>
  802a47:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802a4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a4f:	89 50 08             	mov    %edx,0x8(%eax)
  802a52:	eb 08                	jmp    802a5c <sget+0x13f>
  802a54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a57:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802a5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5f:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802a64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a6e:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802a73:	40                   	inc    %eax
  802a74:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802a79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a7c:	8b 00                	mov    (%eax),%eax
  802a7e:	83 ec 04             	sub    $0x4,%esp
  802a81:	50                   	push   %eax
  802a82:	ff 75 0c             	pushl  0xc(%ebp)
  802a85:	ff 75 08             	pushl  0x8(%ebp)
  802a88:	e8 cc 06 00 00       	call   803159 <sys_get_shared_object>
  802a8d:	83 c4 10             	add    $0x10,%esp
  802a90:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802a93:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a97:	79 28                	jns    802ac1 <sget+0x1a4>
							free_block(allocblock);
  802a99:	83 ec 0c             	sub    $0xc,%esp
  802a9c:	ff 75 e0             	pushl  -0x20(%ebp)
  802a9f:	e8 0c 11 00 00       	call   803bb0 <free_block>
  802aa4:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802aa7:	83 ec 0c             	sub    $0xc,%esp
  802aaa:	68 40 d1 81 00       	push   $0x81d140
  802aaf:	e8 20 15 00 00       	call   803fd4 <release_uspinlock>
  802ab4:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802ab7:	b8 00 00 00 00       	mov    $0x0,%eax
  802abc:	e9 19 04 00 00       	jmp    802eda <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802ac1:	83 ec 0c             	sub    $0xc,%esp
  802ac4:	68 40 d1 81 00       	push   $0x81d140
  802ac9:	e8 06 15 00 00       	call   803fd4 <release_uspinlock>
  802ace:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad4:	8b 00                	mov    (%eax),%eax
  802ad6:	e9 ff 03 00 00       	jmp    802eda <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802adb:	83 ec 0c             	sub    $0xc,%esp
  802ade:	68 40 d1 81 00       	push   $0x81d140
  802ae3:	e8 ec 14 00 00       	call   803fd4 <release_uspinlock>
  802ae8:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  802af0:	e9 e5 03 00 00       	jmp    802eda <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802af5:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802afd:	e9 ab 03 00 00       	jmp    802ead <sget+0x590>
				if(size<currentfreeelement->size){
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 50 04             	mov    0x4(%eax),%edx
  802b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0b:	39 c2                	cmp    %eax,%edx
  802b0d:	0f 86 24 02 00 00    	jbe    802d37 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802b13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b16:	8b 10                	mov    (%eax),%edx
  802b18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1b:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802b1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b23:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802b26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b2a:	75 17                	jne    802b43 <sget+0x226>
  802b2c:	83 ec 04             	sub    $0x4,%esp
  802b2f:	68 78 4a 80 00       	push   $0x804a78
  802b34:	68 e0 01 00 00       	push   $0x1e0
  802b39:	68 2c 4a 80 00       	push   $0x804a2c
  802b3e:	e8 be d8 ff ff       	call   800401 <_panic>
  802b43:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802b49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4c:	89 50 0c             	mov    %edx,0xc(%eax)
  802b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b52:	8b 40 0c             	mov    0xc(%eax),%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	74 0d                	je     802b66 <sget+0x249>
  802b59:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802b5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b61:	89 50 08             	mov    %edx,0x8(%eax)
  802b64:	eb 08                	jmp    802b6e <sget+0x251>
  802b66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b69:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b71:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802b76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b79:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b80:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802b85:	40                   	inc    %eax
  802b86:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					lastfreeelement->startva += size;
  802b8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b8e:	8b 10                	mov    (%eax),%edx
  802b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b93:	01 c2                	add    %eax,%edx
  802b95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b98:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802b9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b9d:	8b 50 04             	mov    0x4(%eax),%edx
  802ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba3:	29 c2                	sub    %eax,%edx
  802ba5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ba8:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802bab:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802bb3:	e9 13 01 00 00       	jmp    802ccb <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802bb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bbb:	8b 50 04             	mov    0x4(%eax),%edx
  802bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc1:	8b 40 04             	mov    0x4(%eax),%eax
  802bc4:	39 c2                	cmp    %eax,%edx
  802bc6:	0f 83 f6 00 00 00    	jae    802cc2 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802bcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802bd0:	75 17                	jne    802be9 <sget+0x2cc>
  802bd2:	83 ec 04             	sub    $0x4,%esp
  802bd5:	68 9b 4a 80 00       	push   $0x804a9b
  802bda:	68 e8 01 00 00       	push   $0x1e8
  802bdf:	68 2c 4a 80 00       	push   $0x804a2c
  802be4:	e8 18 d8 ff ff       	call   800401 <_panic>
  802be9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bec:	8b 40 08             	mov    0x8(%eax),%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	74 11                	je     802c04 <sget+0x2e7>
  802bf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bf6:	8b 40 08             	mov    0x8(%eax),%eax
  802bf9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bfc:	8b 52 0c             	mov    0xc(%edx),%edx
  802bff:	89 50 0c             	mov    %edx,0xc(%eax)
  802c02:	eb 0b                	jmp    802c0f <sget+0x2f2>
  802c04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c07:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0a:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802c0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c12:	8b 40 0c             	mov    0xc(%eax),%eax
  802c15:	85 c0                	test   %eax,%eax
  802c17:	74 11                	je     802c2a <sget+0x30d>
  802c19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c22:	8b 52 08             	mov    0x8(%edx),%edx
  802c25:	89 50 08             	mov    %edx,0x8(%eax)
  802c28:	eb 0b                	jmp    802c35 <sget+0x318>
  802c2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c2d:	8b 40 08             	mov    0x8(%eax),%eax
  802c30:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802c35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c49:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802c4e:	48                   	dec    %eax
  802c4f:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802c54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c58:	74 06                	je     802c60 <sget+0x343>
  802c5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c5e:	75 17                	jne    802c77 <sget+0x35a>
  802c60:	83 ec 04             	sub    $0x4,%esp
  802c63:	68 bc 4a 80 00       	push   $0x804abc
  802c68:	68 e9 01 00 00       	push   $0x1e9
  802c6d:	68 2c 4a 80 00       	push   $0x804a2c
  802c72:	e8 8a d7 ff ff       	call   800401 <_panic>
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	8b 50 0c             	mov    0xc(%eax),%edx
  802c7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c80:	89 50 0c             	mov    %edx,0xc(%eax)
  802c83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c89:	89 50 08             	mov    %edx,0x8(%eax)
  802c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 0e                	je     802ca4 <sget+0x387>
  802c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c99:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c9f:	89 50 08             	mov    %edx,0x8(%eax)
  802ca2:	eb 08                	jmp    802cac <sget+0x38f>
  802ca4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca7:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cb2:	89 50 0c             	mov    %edx,0xc(%eax)
  802cb5:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802cba:	40                   	inc    %eax
  802cbb:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							break;
  802cc0:	eb 13                	jmp    802cd5 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc5:	8b 40 08             	mov    0x8(%eax),%eax
  802cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802ccb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ccf:	0f 85 e3 fe ff ff    	jne    802bb8 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	83 ec 04             	sub    $0x4,%esp
  802cdd:	50                   	push   %eax
  802cde:	ff 75 0c             	pushl  0xc(%ebp)
  802ce1:	ff 75 08             	pushl  0x8(%ebp)
  802ce4:	e8 70 04 00 00       	call   803159 <sys_get_shared_object>
  802ce9:	83 c4 10             	add    $0x10,%esp
  802cec:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802cef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802cf3:	79 28                	jns    802d1d <sget+0x400>
						free_block(allocblock);
  802cf5:	83 ec 0c             	sub    $0xc,%esp
  802cf8:	ff 75 e0             	pushl  -0x20(%ebp)
  802cfb:	e8 b0 0e 00 00       	call   803bb0 <free_block>
  802d00:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802d03:	83 ec 0c             	sub    $0xc,%esp
  802d06:	68 40 d1 81 00       	push   $0x81d140
  802d0b:	e8 c4 12 00 00       	call   803fd4 <release_uspinlock>
  802d10:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802d13:	b8 00 00 00 00       	mov    $0x0,%eax
  802d18:	e9 bd 01 00 00       	jmp    802eda <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802d1d:	83 ec 0c             	sub    $0xc,%esp
  802d20:	68 40 d1 81 00       	push   $0x81d140
  802d25:	e8 aa 12 00 00       	call   803fd4 <release_uspinlock>
  802d2a:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802d2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	e9 a3 01 00 00       	jmp    802eda <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 50 04             	mov    0x4(%eax),%edx
  802d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d40:	39 c2                	cmp    %eax,%edx
  802d42:	0f 85 5c 01 00 00    	jne    802ea4 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 10                	mov    (%eax),%edx
  802d4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d50:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802d52:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d58:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802d5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d5f:	75 17                	jne    802d78 <sget+0x45b>
  802d61:	83 ec 04             	sub    $0x4,%esp
  802d64:	68 78 4a 80 00       	push   $0x804a78
  802d69:	68 fe 01 00 00       	push   $0x1fe
  802d6e:	68 2c 4a 80 00       	push   $0x804a2c
  802d73:	e8 89 d6 ff ff       	call   800401 <_panic>
  802d78:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d81:	89 50 0c             	mov    %edx,0xc(%eax)
  802d84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d87:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 0d                	je     802d9b <sget+0x47e>
  802d8e:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802d93:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d96:	89 50 08             	mov    %edx,0x8(%eax)
  802d99:	eb 08                	jmp    802da3 <sget+0x486>
  802d9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9e:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802da3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da6:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802dab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802db5:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802dba:	40                   	inc    %eax
  802dbb:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802dc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc4:	75 17                	jne    802ddd <sget+0x4c0>
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	68 9b 4a 80 00       	push   $0x804a9b
  802dce:	68 ff 01 00 00       	push   $0x1ff
  802dd3:	68 2c 4a 80 00       	push   $0x804a2c
  802dd8:	e8 24 d6 ff ff       	call   800401 <_panic>
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 40 08             	mov    0x8(%eax),%eax
  802de3:	85 c0                	test   %eax,%eax
  802de5:	74 11                	je     802df8 <sget+0x4db>
  802de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dea:	8b 40 08             	mov    0x8(%eax),%eax
  802ded:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df0:	8b 52 0c             	mov    0xc(%edx),%edx
  802df3:	89 50 0c             	mov    %edx,0xc(%eax)
  802df6:	eb 0b                	jmp    802e03 <sget+0x4e6>
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfe:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	8b 40 0c             	mov    0xc(%eax),%eax
  802e09:	85 c0                	test   %eax,%eax
  802e0b:	74 11                	je     802e1e <sget+0x501>
  802e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e10:	8b 40 0c             	mov    0xc(%eax),%eax
  802e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e16:	8b 52 08             	mov    0x8(%edx),%edx
  802e19:	89 50 08             	mov    %edx,0x8(%eax)
  802e1c:	eb 0b                	jmp    802e29 <sget+0x50c>
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 40 08             	mov    0x8(%eax),%eax
  802e24:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802e3d:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802e42:	48                   	dec    %eax
  802e43:	a3 2c d1 81 00       	mov    %eax,0x81d12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802e48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4b:	8b 00                	mov    (%eax),%eax
  802e4d:	83 ec 04             	sub    $0x4,%esp
  802e50:	50                   	push   %eax
  802e51:	ff 75 0c             	pushl  0xc(%ebp)
  802e54:	ff 75 08             	pushl  0x8(%ebp)
  802e57:	e8 fd 02 00 00       	call   803159 <sys_get_shared_object>
  802e5c:	83 c4 10             	add    $0x10,%esp
  802e5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802e62:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802e66:	79 25                	jns    802e8d <sget+0x570>
						free_block(allocblock);
  802e68:	83 ec 0c             	sub    $0xc,%esp
  802e6b:	ff 75 e0             	pushl  -0x20(%ebp)
  802e6e:	e8 3d 0d 00 00       	call   803bb0 <free_block>
  802e73:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802e76:	83 ec 0c             	sub    $0xc,%esp
  802e79:	68 40 d1 81 00       	push   $0x81d140
  802e7e:	e8 51 11 00 00       	call   803fd4 <release_uspinlock>
  802e83:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802e86:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8b:	eb 4d                	jmp    802eda <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802e8d:	83 ec 0c             	sub    $0xc,%esp
  802e90:	68 40 d1 81 00       	push   $0x81d140
  802e95:	e8 3a 11 00 00       	call   803fd4 <release_uspinlock>
  802e9a:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	eb 36                	jmp    802eda <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 40 08             	mov    0x8(%eax),%eax
  802eaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802ead:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb1:	0f 85 4b fc ff ff    	jne    802b02 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802eb7:	83 ec 0c             	sub    $0xc,%esp
  802eba:	ff 75 e0             	pushl  -0x20(%ebp)
  802ebd:	e8 ee 0c 00 00       	call   803bb0 <free_block>
  802ec2:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802ec5:	83 ec 0c             	sub    $0xc,%esp
  802ec8:	68 40 d1 81 00       	push   $0x81d140
  802ecd:	e8 02 11 00 00       	call   803fd4 <release_uspinlock>
  802ed2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eda:	c9                   	leave  
  802edb:	c3                   	ret    

00802edc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802edc:	55                   	push   %ebp
  802edd:	89 e5                	mov    %esp,%ebp
  802edf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802ee2:	e8 cd e6 ff ff       	call   8015b4 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 4c 4b 80 00       	push   $0x804b4c
  802eef:	68 2d 02 00 00       	push   $0x22d
  802ef4:	68 2c 4a 80 00       	push   $0x804a2c
  802ef9:	e8 03 d5 ff ff       	call   800401 <_panic>

00802efe <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802efe:	55                   	push   %ebp
  802eff:	89 e5                	mov    %esp,%ebp
  802f01:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802f04:	83 ec 04             	sub    $0x4,%esp
  802f07:	68 74 4b 80 00       	push   $0x804b74
  802f0c:	68 40 02 00 00       	push   $0x240
  802f11:	68 2c 4a 80 00       	push   $0x804a2c
  802f16:	e8 e6 d4 ff ff       	call   800401 <_panic>

00802f1b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802f1b:	55                   	push   %ebp
  802f1c:	89 e5                	mov    %esp,%ebp
  802f1e:	57                   	push   %edi
  802f1f:	56                   	push   %esi
  802f20:	53                   	push   %ebx
  802f21:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f2d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f30:	8b 7d 18             	mov    0x18(%ebp),%edi
  802f33:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802f36:	cd 30                	int    $0x30
  802f38:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802f3e:	83 c4 10             	add    $0x10,%esp
  802f41:	5b                   	pop    %ebx
  802f42:	5e                   	pop    %esi
  802f43:	5f                   	pop    %edi
  802f44:	5d                   	pop    %ebp
  802f45:	c3                   	ret    

00802f46 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802f46:	55                   	push   %ebp
  802f47:	89 e5                	mov    %esp,%ebp
  802f49:	83 ec 04             	sub    $0x4,%esp
  802f4c:	8b 45 10             	mov    0x10(%ebp),%eax
  802f4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802f52:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f55:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	6a 00                	push   $0x0
  802f5e:	51                   	push   %ecx
  802f5f:	52                   	push   %edx
  802f60:	ff 75 0c             	pushl  0xc(%ebp)
  802f63:	50                   	push   %eax
  802f64:	6a 00                	push   $0x0
  802f66:	e8 b0 ff ff ff       	call   802f1b <syscall>
  802f6b:	83 c4 18             	add    $0x18,%esp
}
  802f6e:	90                   	nop
  802f6f:	c9                   	leave  
  802f70:	c3                   	ret    

00802f71 <sys_cgetc>:

int
sys_cgetc(void)
{
  802f71:	55                   	push   %ebp
  802f72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802f74:	6a 00                	push   $0x0
  802f76:	6a 00                	push   $0x0
  802f78:	6a 00                	push   $0x0
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 02                	push   $0x2
  802f80:	e8 96 ff ff ff       	call   802f1b <syscall>
  802f85:	83 c4 18             	add    $0x18,%esp
}
  802f88:	c9                   	leave  
  802f89:	c3                   	ret    

00802f8a <sys_lock_cons>:

void sys_lock_cons(void)
{
  802f8a:	55                   	push   %ebp
  802f8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	6a 03                	push   $0x3
  802f99:	e8 7d ff ff ff       	call   802f1b <syscall>
  802f9e:	83 c4 18             	add    $0x18,%esp
}
  802fa1:	90                   	nop
  802fa2:	c9                   	leave  
  802fa3:	c3                   	ret    

00802fa4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802fa4:	55                   	push   %ebp
  802fa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802fa7:	6a 00                	push   $0x0
  802fa9:	6a 00                	push   $0x0
  802fab:	6a 00                	push   $0x0
  802fad:	6a 00                	push   $0x0
  802faf:	6a 00                	push   $0x0
  802fb1:	6a 04                	push   $0x4
  802fb3:	e8 63 ff ff ff       	call   802f1b <syscall>
  802fb8:	83 c4 18             	add    $0x18,%esp
}
  802fbb:	90                   	nop
  802fbc:	c9                   	leave  
  802fbd:	c3                   	ret    

00802fbe <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802fbe:	55                   	push   %ebp
  802fbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	6a 00                	push   $0x0
  802fcd:	52                   	push   %edx
  802fce:	50                   	push   %eax
  802fcf:	6a 08                	push   $0x8
  802fd1:	e8 45 ff ff ff       	call   802f1b <syscall>
  802fd6:	83 c4 18             	add    $0x18,%esp
}
  802fd9:	c9                   	leave  
  802fda:	c3                   	ret    

00802fdb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802fdb:	55                   	push   %ebp
  802fdc:	89 e5                	mov    %esp,%ebp
  802fde:	56                   	push   %esi
  802fdf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802fe0:	8b 75 18             	mov    0x18(%ebp),%esi
  802fe3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fe6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	56                   	push   %esi
  802ff0:	53                   	push   %ebx
  802ff1:	51                   	push   %ecx
  802ff2:	52                   	push   %edx
  802ff3:	50                   	push   %eax
  802ff4:	6a 09                	push   $0x9
  802ff6:	e8 20 ff ff ff       	call   802f1b <syscall>
  802ffb:	83 c4 18             	add    $0x18,%esp
}
  802ffe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803001:	5b                   	pop    %ebx
  803002:	5e                   	pop    %esi
  803003:	5d                   	pop    %ebp
  803004:	c3                   	ret    

00803005 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803005:	55                   	push   %ebp
  803006:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803008:	6a 00                	push   $0x0
  80300a:	6a 00                	push   $0x0
  80300c:	6a 00                	push   $0x0
  80300e:	6a 00                	push   $0x0
  803010:	ff 75 08             	pushl  0x8(%ebp)
  803013:	6a 0a                	push   $0xa
  803015:	e8 01 ff ff ff       	call   802f1b <syscall>
  80301a:	83 c4 18             	add    $0x18,%esp
}
  80301d:	c9                   	leave  
  80301e:	c3                   	ret    

0080301f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80301f:	55                   	push   %ebp
  803020:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803022:	6a 00                	push   $0x0
  803024:	6a 00                	push   $0x0
  803026:	6a 00                	push   $0x0
  803028:	ff 75 0c             	pushl  0xc(%ebp)
  80302b:	ff 75 08             	pushl  0x8(%ebp)
  80302e:	6a 0b                	push   $0xb
  803030:	e8 e6 fe ff ff       	call   802f1b <syscall>
  803035:	83 c4 18             	add    $0x18,%esp
}
  803038:	c9                   	leave  
  803039:	c3                   	ret    

0080303a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80303a:	55                   	push   %ebp
  80303b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80303d:	6a 00                	push   $0x0
  80303f:	6a 00                	push   $0x0
  803041:	6a 00                	push   $0x0
  803043:	6a 00                	push   $0x0
  803045:	6a 00                	push   $0x0
  803047:	6a 0c                	push   $0xc
  803049:	e8 cd fe ff ff       	call   802f1b <syscall>
  80304e:	83 c4 18             	add    $0x18,%esp
}
  803051:	c9                   	leave  
  803052:	c3                   	ret    

00803053 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803053:	55                   	push   %ebp
  803054:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	6a 00                	push   $0x0
  80305e:	6a 00                	push   $0x0
  803060:	6a 0d                	push   $0xd
  803062:	e8 b4 fe ff ff       	call   802f1b <syscall>
  803067:	83 c4 18             	add    $0x18,%esp
}
  80306a:	c9                   	leave  
  80306b:	c3                   	ret    

0080306c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80306c:	55                   	push   %ebp
  80306d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80306f:	6a 00                	push   $0x0
  803071:	6a 00                	push   $0x0
  803073:	6a 00                	push   $0x0
  803075:	6a 00                	push   $0x0
  803077:	6a 00                	push   $0x0
  803079:	6a 0e                	push   $0xe
  80307b:	e8 9b fe ff ff       	call   802f1b <syscall>
  803080:	83 c4 18             	add    $0x18,%esp
}
  803083:	c9                   	leave  
  803084:	c3                   	ret    

00803085 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803085:	55                   	push   %ebp
  803086:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803088:	6a 00                	push   $0x0
  80308a:	6a 00                	push   $0x0
  80308c:	6a 00                	push   $0x0
  80308e:	6a 00                	push   $0x0
  803090:	6a 00                	push   $0x0
  803092:	6a 0f                	push   $0xf
  803094:	e8 82 fe ff ff       	call   802f1b <syscall>
  803099:	83 c4 18             	add    $0x18,%esp
}
  80309c:	c9                   	leave  
  80309d:	c3                   	ret    

0080309e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80309e:	55                   	push   %ebp
  80309f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8030a1:	6a 00                	push   $0x0
  8030a3:	6a 00                	push   $0x0
  8030a5:	6a 00                	push   $0x0
  8030a7:	6a 00                	push   $0x0
  8030a9:	ff 75 08             	pushl  0x8(%ebp)
  8030ac:	6a 10                	push   $0x10
  8030ae:	e8 68 fe ff ff       	call   802f1b <syscall>
  8030b3:	83 c4 18             	add    $0x18,%esp
}
  8030b6:	c9                   	leave  
  8030b7:	c3                   	ret    

008030b8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8030b8:	55                   	push   %ebp
  8030b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8030bb:	6a 00                	push   $0x0
  8030bd:	6a 00                	push   $0x0
  8030bf:	6a 00                	push   $0x0
  8030c1:	6a 00                	push   $0x0
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 11                	push   $0x11
  8030c7:	e8 4f fe ff ff       	call   802f1b <syscall>
  8030cc:	83 c4 18             	add    $0x18,%esp
}
  8030cf:	90                   	nop
  8030d0:	c9                   	leave  
  8030d1:	c3                   	ret    

008030d2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8030d2:	55                   	push   %ebp
  8030d3:	89 e5                	mov    %esp,%ebp
  8030d5:	83 ec 04             	sub    $0x4,%esp
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8030de:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030e2:	6a 00                	push   $0x0
  8030e4:	6a 00                	push   $0x0
  8030e6:	6a 00                	push   $0x0
  8030e8:	6a 00                	push   $0x0
  8030ea:	50                   	push   %eax
  8030eb:	6a 01                	push   $0x1
  8030ed:	e8 29 fe ff ff       	call   802f1b <syscall>
  8030f2:	83 c4 18             	add    $0x18,%esp
}
  8030f5:	90                   	nop
  8030f6:	c9                   	leave  
  8030f7:	c3                   	ret    

008030f8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8030f8:	55                   	push   %ebp
  8030f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8030fb:	6a 00                	push   $0x0
  8030fd:	6a 00                	push   $0x0
  8030ff:	6a 00                	push   $0x0
  803101:	6a 00                	push   $0x0
  803103:	6a 00                	push   $0x0
  803105:	6a 14                	push   $0x14
  803107:	e8 0f fe ff ff       	call   802f1b <syscall>
  80310c:	83 c4 18             	add    $0x18,%esp
}
  80310f:	90                   	nop
  803110:	c9                   	leave  
  803111:	c3                   	ret    

00803112 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803112:	55                   	push   %ebp
  803113:	89 e5                	mov    %esp,%ebp
  803115:	83 ec 04             	sub    $0x4,%esp
  803118:	8b 45 10             	mov    0x10(%ebp),%eax
  80311b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80311e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803121:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	6a 00                	push   $0x0
  80312a:	51                   	push   %ecx
  80312b:	52                   	push   %edx
  80312c:	ff 75 0c             	pushl  0xc(%ebp)
  80312f:	50                   	push   %eax
  803130:	6a 15                	push   $0x15
  803132:	e8 e4 fd ff ff       	call   802f1b <syscall>
  803137:	83 c4 18             	add    $0x18,%esp
}
  80313a:	c9                   	leave  
  80313b:	c3                   	ret    

0080313c <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80313c:	55                   	push   %ebp
  80313d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80313f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803142:	8b 45 08             	mov    0x8(%ebp),%eax
  803145:	6a 00                	push   $0x0
  803147:	6a 00                	push   $0x0
  803149:	6a 00                	push   $0x0
  80314b:	52                   	push   %edx
  80314c:	50                   	push   %eax
  80314d:	6a 16                	push   $0x16
  80314f:	e8 c7 fd ff ff       	call   802f1b <syscall>
  803154:	83 c4 18             	add    $0x18,%esp
}
  803157:	c9                   	leave  
  803158:	c3                   	ret    

00803159 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803159:	55                   	push   %ebp
  80315a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80315c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80315f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	6a 00                	push   $0x0
  803167:	6a 00                	push   $0x0
  803169:	51                   	push   %ecx
  80316a:	52                   	push   %edx
  80316b:	50                   	push   %eax
  80316c:	6a 17                	push   $0x17
  80316e:	e8 a8 fd ff ff       	call   802f1b <syscall>
  803173:	83 c4 18             	add    $0x18,%esp
}
  803176:	c9                   	leave  
  803177:	c3                   	ret    

00803178 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803178:	55                   	push   %ebp
  803179:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80317b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	6a 00                	push   $0x0
  803183:	6a 00                	push   $0x0
  803185:	6a 00                	push   $0x0
  803187:	52                   	push   %edx
  803188:	50                   	push   %eax
  803189:	6a 18                	push   $0x18
  80318b:	e8 8b fd ff ff       	call   802f1b <syscall>
  803190:	83 c4 18             	add    $0x18,%esp
}
  803193:	c9                   	leave  
  803194:	c3                   	ret    

00803195 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803195:	55                   	push   %ebp
  803196:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	6a 00                	push   $0x0
  80319d:	ff 75 14             	pushl  0x14(%ebp)
  8031a0:	ff 75 10             	pushl  0x10(%ebp)
  8031a3:	ff 75 0c             	pushl  0xc(%ebp)
  8031a6:	50                   	push   %eax
  8031a7:	6a 19                	push   $0x19
  8031a9:	e8 6d fd ff ff       	call   802f1b <syscall>
  8031ae:	83 c4 18             	add    $0x18,%esp
}
  8031b1:	c9                   	leave  
  8031b2:	c3                   	ret    

008031b3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8031b3:	55                   	push   %ebp
  8031b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	6a 00                	push   $0x0
  8031bb:	6a 00                	push   $0x0
  8031bd:	6a 00                	push   $0x0
  8031bf:	6a 00                	push   $0x0
  8031c1:	50                   	push   %eax
  8031c2:	6a 1a                	push   $0x1a
  8031c4:	e8 52 fd ff ff       	call   802f1b <syscall>
  8031c9:	83 c4 18             	add    $0x18,%esp
}
  8031cc:	90                   	nop
  8031cd:	c9                   	leave  
  8031ce:	c3                   	ret    

008031cf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8031cf:	55                   	push   %ebp
  8031d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	6a 00                	push   $0x0
  8031d7:	6a 00                	push   $0x0
  8031d9:	6a 00                	push   $0x0
  8031db:	6a 00                	push   $0x0
  8031dd:	50                   	push   %eax
  8031de:	6a 1b                	push   $0x1b
  8031e0:	e8 36 fd ff ff       	call   802f1b <syscall>
  8031e5:	83 c4 18             	add    $0x18,%esp
}
  8031e8:	c9                   	leave  
  8031e9:	c3                   	ret    

008031ea <sys_getenvid>:

int32 sys_getenvid(void)
{
  8031ea:	55                   	push   %ebp
  8031eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8031ed:	6a 00                	push   $0x0
  8031ef:	6a 00                	push   $0x0
  8031f1:	6a 00                	push   $0x0
  8031f3:	6a 00                	push   $0x0
  8031f5:	6a 00                	push   $0x0
  8031f7:	6a 05                	push   $0x5
  8031f9:	e8 1d fd ff ff       	call   802f1b <syscall>
  8031fe:	83 c4 18             	add    $0x18,%esp
}
  803201:	c9                   	leave  
  803202:	c3                   	ret    

00803203 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803203:	55                   	push   %ebp
  803204:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803206:	6a 00                	push   $0x0
  803208:	6a 00                	push   $0x0
  80320a:	6a 00                	push   $0x0
  80320c:	6a 00                	push   $0x0
  80320e:	6a 00                	push   $0x0
  803210:	6a 06                	push   $0x6
  803212:	e8 04 fd ff ff       	call   802f1b <syscall>
  803217:	83 c4 18             	add    $0x18,%esp
}
  80321a:	c9                   	leave  
  80321b:	c3                   	ret    

0080321c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80321c:	55                   	push   %ebp
  80321d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80321f:	6a 00                	push   $0x0
  803221:	6a 00                	push   $0x0
  803223:	6a 00                	push   $0x0
  803225:	6a 00                	push   $0x0
  803227:	6a 00                	push   $0x0
  803229:	6a 07                	push   $0x7
  80322b:	e8 eb fc ff ff       	call   802f1b <syscall>
  803230:	83 c4 18             	add    $0x18,%esp
}
  803233:	c9                   	leave  
  803234:	c3                   	ret    

00803235 <sys_exit_env>:


void sys_exit_env(void)
{
  803235:	55                   	push   %ebp
  803236:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803238:	6a 00                	push   $0x0
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 00                	push   $0x0
  803240:	6a 00                	push   $0x0
  803242:	6a 1c                	push   $0x1c
  803244:	e8 d2 fc ff ff       	call   802f1b <syscall>
  803249:	83 c4 18             	add    $0x18,%esp
}
  80324c:	90                   	nop
  80324d:	c9                   	leave  
  80324e:	c3                   	ret    

0080324f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80324f:	55                   	push   %ebp
  803250:	89 e5                	mov    %esp,%ebp
  803252:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803255:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803258:	8d 50 04             	lea    0x4(%eax),%edx
  80325b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80325e:	6a 00                	push   $0x0
  803260:	6a 00                	push   $0x0
  803262:	6a 00                	push   $0x0
  803264:	52                   	push   %edx
  803265:	50                   	push   %eax
  803266:	6a 1d                	push   $0x1d
  803268:	e8 ae fc ff ff       	call   802f1b <syscall>
  80326d:	83 c4 18             	add    $0x18,%esp
	return result;
  803270:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803273:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803276:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803279:	89 01                	mov    %eax,(%ecx)
  80327b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	c9                   	leave  
  803282:	c2 04 00             	ret    $0x4

00803285 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803285:	55                   	push   %ebp
  803286:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803288:	6a 00                	push   $0x0
  80328a:	6a 00                	push   $0x0
  80328c:	ff 75 10             	pushl  0x10(%ebp)
  80328f:	ff 75 0c             	pushl  0xc(%ebp)
  803292:	ff 75 08             	pushl  0x8(%ebp)
  803295:	6a 13                	push   $0x13
  803297:	e8 7f fc ff ff       	call   802f1b <syscall>
  80329c:	83 c4 18             	add    $0x18,%esp
	return ;
  80329f:	90                   	nop
}
  8032a0:	c9                   	leave  
  8032a1:	c3                   	ret    

008032a2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8032a2:	55                   	push   %ebp
  8032a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8032a5:	6a 00                	push   $0x0
  8032a7:	6a 00                	push   $0x0
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 00                	push   $0x0
  8032ad:	6a 00                	push   $0x0
  8032af:	6a 1e                	push   $0x1e
  8032b1:	e8 65 fc ff ff       	call   802f1b <syscall>
  8032b6:	83 c4 18             	add    $0x18,%esp
}
  8032b9:	c9                   	leave  
  8032ba:	c3                   	ret    

008032bb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8032bb:	55                   	push   %ebp
  8032bc:	89 e5                	mov    %esp,%ebp
  8032be:	83 ec 04             	sub    $0x4,%esp
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8032c7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8032cb:	6a 00                	push   $0x0
  8032cd:	6a 00                	push   $0x0
  8032cf:	6a 00                	push   $0x0
  8032d1:	6a 00                	push   $0x0
  8032d3:	50                   	push   %eax
  8032d4:	6a 1f                	push   $0x1f
  8032d6:	e8 40 fc ff ff       	call   802f1b <syscall>
  8032db:	83 c4 18             	add    $0x18,%esp
	return ;
  8032de:	90                   	nop
}
  8032df:	c9                   	leave  
  8032e0:	c3                   	ret    

008032e1 <rsttst>:
void rsttst()
{
  8032e1:	55                   	push   %ebp
  8032e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8032e4:	6a 00                	push   $0x0
  8032e6:	6a 00                	push   $0x0
  8032e8:	6a 00                	push   $0x0
  8032ea:	6a 00                	push   $0x0
  8032ec:	6a 00                	push   $0x0
  8032ee:	6a 21                	push   $0x21
  8032f0:	e8 26 fc ff ff       	call   802f1b <syscall>
  8032f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8032f8:	90                   	nop
}
  8032f9:	c9                   	leave  
  8032fa:	c3                   	ret    

008032fb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8032fb:	55                   	push   %ebp
  8032fc:	89 e5                	mov    %esp,%ebp
  8032fe:	83 ec 04             	sub    $0x4,%esp
  803301:	8b 45 14             	mov    0x14(%ebp),%eax
  803304:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803307:	8b 55 18             	mov    0x18(%ebp),%edx
  80330a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80330e:	52                   	push   %edx
  80330f:	50                   	push   %eax
  803310:	ff 75 10             	pushl  0x10(%ebp)
  803313:	ff 75 0c             	pushl  0xc(%ebp)
  803316:	ff 75 08             	pushl  0x8(%ebp)
  803319:	6a 20                	push   $0x20
  80331b:	e8 fb fb ff ff       	call   802f1b <syscall>
  803320:	83 c4 18             	add    $0x18,%esp
	return ;
  803323:	90                   	nop
}
  803324:	c9                   	leave  
  803325:	c3                   	ret    

00803326 <chktst>:
void chktst(uint32 n)
{
  803326:	55                   	push   %ebp
  803327:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803329:	6a 00                	push   $0x0
  80332b:	6a 00                	push   $0x0
  80332d:	6a 00                	push   $0x0
  80332f:	6a 00                	push   $0x0
  803331:	ff 75 08             	pushl  0x8(%ebp)
  803334:	6a 22                	push   $0x22
  803336:	e8 e0 fb ff ff       	call   802f1b <syscall>
  80333b:	83 c4 18             	add    $0x18,%esp
	return ;
  80333e:	90                   	nop
}
  80333f:	c9                   	leave  
  803340:	c3                   	ret    

00803341 <inctst>:

void inctst()
{
  803341:	55                   	push   %ebp
  803342:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803344:	6a 00                	push   $0x0
  803346:	6a 00                	push   $0x0
  803348:	6a 00                	push   $0x0
  80334a:	6a 00                	push   $0x0
  80334c:	6a 00                	push   $0x0
  80334e:	6a 23                	push   $0x23
  803350:	e8 c6 fb ff ff       	call   802f1b <syscall>
  803355:	83 c4 18             	add    $0x18,%esp
	return ;
  803358:	90                   	nop
}
  803359:	c9                   	leave  
  80335a:	c3                   	ret    

0080335b <gettst>:
uint32 gettst()
{
  80335b:	55                   	push   %ebp
  80335c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80335e:	6a 00                	push   $0x0
  803360:	6a 00                	push   $0x0
  803362:	6a 00                	push   $0x0
  803364:	6a 00                	push   $0x0
  803366:	6a 00                	push   $0x0
  803368:	6a 24                	push   $0x24
  80336a:	e8 ac fb ff ff       	call   802f1b <syscall>
  80336f:	83 c4 18             	add    $0x18,%esp
}
  803372:	c9                   	leave  
  803373:	c3                   	ret    

00803374 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803374:	55                   	push   %ebp
  803375:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803377:	6a 00                	push   $0x0
  803379:	6a 00                	push   $0x0
  80337b:	6a 00                	push   $0x0
  80337d:	6a 00                	push   $0x0
  80337f:	6a 00                	push   $0x0
  803381:	6a 25                	push   $0x25
  803383:	e8 93 fb ff ff       	call   802f1b <syscall>
  803388:	83 c4 18             	add    $0x18,%esp
  80338b:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  803390:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  803395:	c9                   	leave  
  803396:	c3                   	ret    

00803397 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803397:	55                   	push   %ebp
  803398:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8033a2:	6a 00                	push   $0x0
  8033a4:	6a 00                	push   $0x0
  8033a6:	6a 00                	push   $0x0
  8033a8:	6a 00                	push   $0x0
  8033aa:	ff 75 08             	pushl  0x8(%ebp)
  8033ad:	6a 26                	push   $0x26
  8033af:	e8 67 fb ff ff       	call   802f1b <syscall>
  8033b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8033b7:	90                   	nop
}
  8033b8:	c9                   	leave  
  8033b9:	c3                   	ret    

008033ba <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8033ba:	55                   	push   %ebp
  8033bb:	89 e5                	mov    %esp,%ebp
  8033bd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8033be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8033c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8033c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	6a 00                	push   $0x0
  8033cc:	53                   	push   %ebx
  8033cd:	51                   	push   %ecx
  8033ce:	52                   	push   %edx
  8033cf:	50                   	push   %eax
  8033d0:	6a 27                	push   $0x27
  8033d2:	e8 44 fb ff ff       	call   802f1b <syscall>
  8033d7:	83 c4 18             	add    $0x18,%esp
}
  8033da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033dd:	c9                   	leave  
  8033de:	c3                   	ret    

008033df <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8033df:	55                   	push   %ebp
  8033e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8033e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	6a 00                	push   $0x0
  8033ea:	6a 00                	push   $0x0
  8033ec:	6a 00                	push   $0x0
  8033ee:	52                   	push   %edx
  8033ef:	50                   	push   %eax
  8033f0:	6a 28                	push   $0x28
  8033f2:	e8 24 fb ff ff       	call   802f1b <syscall>
  8033f7:	83 c4 18             	add    $0x18,%esp
}
  8033fa:	c9                   	leave  
  8033fb:	c3                   	ret    

008033fc <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8033fc:	55                   	push   %ebp
  8033fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8033ff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803402:	8b 55 0c             	mov    0xc(%ebp),%edx
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	6a 00                	push   $0x0
  80340a:	51                   	push   %ecx
  80340b:	ff 75 10             	pushl  0x10(%ebp)
  80340e:	52                   	push   %edx
  80340f:	50                   	push   %eax
  803410:	6a 29                	push   $0x29
  803412:	e8 04 fb ff ff       	call   802f1b <syscall>
  803417:	83 c4 18             	add    $0x18,%esp
}
  80341a:	c9                   	leave  
  80341b:	c3                   	ret    

0080341c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80341c:	55                   	push   %ebp
  80341d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80341f:	6a 00                	push   $0x0
  803421:	6a 00                	push   $0x0
  803423:	ff 75 10             	pushl  0x10(%ebp)
  803426:	ff 75 0c             	pushl  0xc(%ebp)
  803429:	ff 75 08             	pushl  0x8(%ebp)
  80342c:	6a 12                	push   $0x12
  80342e:	e8 e8 fa ff ff       	call   802f1b <syscall>
  803433:	83 c4 18             	add    $0x18,%esp
	return ;
  803436:	90                   	nop
}
  803437:	c9                   	leave  
  803438:	c3                   	ret    

00803439 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803439:	55                   	push   %ebp
  80343a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80343c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	6a 00                	push   $0x0
  803444:	6a 00                	push   $0x0
  803446:	6a 00                	push   $0x0
  803448:	52                   	push   %edx
  803449:	50                   	push   %eax
  80344a:	6a 2a                	push   $0x2a
  80344c:	e8 ca fa ff ff       	call   802f1b <syscall>
  803451:	83 c4 18             	add    $0x18,%esp
	return;
  803454:	90                   	nop
}
  803455:	c9                   	leave  
  803456:	c3                   	ret    

00803457 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803457:	55                   	push   %ebp
  803458:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80345a:	6a 00                	push   $0x0
  80345c:	6a 00                	push   $0x0
  80345e:	6a 00                	push   $0x0
  803460:	6a 00                	push   $0x0
  803462:	6a 00                	push   $0x0
  803464:	6a 2b                	push   $0x2b
  803466:	e8 b0 fa ff ff       	call   802f1b <syscall>
  80346b:	83 c4 18             	add    $0x18,%esp
}
  80346e:	c9                   	leave  
  80346f:	c3                   	ret    

00803470 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803470:	55                   	push   %ebp
  803471:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803473:	6a 00                	push   $0x0
  803475:	6a 00                	push   $0x0
  803477:	6a 00                	push   $0x0
  803479:	ff 75 0c             	pushl  0xc(%ebp)
  80347c:	ff 75 08             	pushl  0x8(%ebp)
  80347f:	6a 2d                	push   $0x2d
  803481:	e8 95 fa ff ff       	call   802f1b <syscall>
  803486:	83 c4 18             	add    $0x18,%esp
	return;
  803489:	90                   	nop
}
  80348a:	c9                   	leave  
  80348b:	c3                   	ret    

0080348c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80348c:	55                   	push   %ebp
  80348d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80348f:	6a 00                	push   $0x0
  803491:	6a 00                	push   $0x0
  803493:	6a 00                	push   $0x0
  803495:	ff 75 0c             	pushl  0xc(%ebp)
  803498:	ff 75 08             	pushl  0x8(%ebp)
  80349b:	6a 2c                	push   $0x2c
  80349d:	e8 79 fa ff ff       	call   802f1b <syscall>
  8034a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8034a5:	90                   	nop
}
  8034a6:	c9                   	leave  
  8034a7:	c3                   	ret    

008034a8 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8034a8:	55                   	push   %ebp
  8034a9:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8034ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	6a 00                	push   $0x0
  8034b3:	6a 00                	push   $0x0
  8034b5:	6a 00                	push   $0x0
  8034b7:	52                   	push   %edx
  8034b8:	50                   	push   %eax
  8034b9:	6a 2e                	push   $0x2e
  8034bb:	e8 5b fa ff ff       	call   802f1b <syscall>
  8034c0:	83 c4 18             	add    $0x18,%esp
	    return;
  8034c3:	90                   	nop
}
  8034c4:	c9                   	leave  
  8034c5:	c3                   	ret    

008034c6 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8034c6:	55                   	push   %ebp
  8034c7:	89 e5                	mov    %esp,%ebp
  8034c9:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	ba 60 50 80 00       	mov    $0x805060,%edx
  8034d4:	29 d0                	sub    %edx,%eax
  8034d6:	c1 f8 02             	sar    $0x2,%eax
  8034d9:	89 c2                	mov    %eax,%edx
  8034db:	89 d0                	mov    %edx,%eax
  8034dd:	c1 e0 02             	shl    $0x2,%eax
  8034e0:	01 d0                	add    %edx,%eax
  8034e2:	c1 e0 02             	shl    $0x2,%eax
  8034e5:	01 d0                	add    %edx,%eax
  8034e7:	c1 e0 02             	shl    $0x2,%eax
  8034ea:	01 d0                	add    %edx,%eax
  8034ec:	89 c1                	mov    %eax,%ecx
  8034ee:	c1 e1 08             	shl    $0x8,%ecx
  8034f1:	01 c8                	add    %ecx,%eax
  8034f3:	89 c1                	mov    %eax,%ecx
  8034f5:	c1 e1 10             	shl    $0x10,%ecx
  8034f8:	01 c8                	add    %ecx,%eax
  8034fa:	01 c0                	add    %eax,%eax
  8034fc:	01 d0                	add    %edx,%eax
  8034fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803501:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803504:	c1 e0 0c             	shl    $0xc,%eax
  803507:	89 c2                	mov    %eax,%edx
  803509:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80350e:	01 d0                	add    %edx,%eax
}
  803510:	c9                   	leave  
  803511:	c3                   	ret    

00803512 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803512:	55                   	push   %ebp
  803513:	89 e5                	mov    %esp,%ebp
  803515:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  803518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  80351f:	eb 06                	jmp    803527 <log2+0x15>
			n >>=1;
  803521:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803524:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803527:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80352b:	77 f4                	ja     803521 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  80352d:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803530:	c9                   	leave  
  803531:	c3                   	ret    

00803532 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803532:	55                   	push   %ebp
  803533:	89 e5                	mov    %esp,%ebp
  803535:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803538:	8b 45 08             	mov    0x8(%ebp),%eax
  80353b:	05 00 00 00 02       	add    $0x2000000,%eax
  803540:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803543:	73 16                	jae    80355b <initialize_dynamic_allocator+0x29>
  803545:	68 98 4b 80 00       	push   $0x804b98
  80354a:	68 be 4b 80 00       	push   $0x804bbe
  80354f:	6a 2d                	push   $0x2d
  803551:	68 d3 4b 80 00       	push   $0x804bd3
  803556:	e8 a6 ce ff ff       	call   800401 <_panic>
		is_initialized = 1;
  80355b:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  803562:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803565:	8b 45 08             	mov    0x8(%ebp),%eax
  803568:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd= daEnd;
  80356d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803570:	a3 40 50 80 00       	mov    %eax,0x805040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803575:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80357b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803580:	29 c2                	sub    %eax,%edx
  803582:	89 d0                	mov    %edx,%eax
  803584:	c1 e8 0c             	shr    $0xc,%eax
  803587:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  80358a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803591:	eb 2f                	jmp    8035c2 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803593:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803596:	89 d0                	mov    %edx,%eax
  803598:	01 c0                	add    %eax,%eax
  80359a:	01 d0                	add    %edx,%eax
  80359c:	c1 e0 02             	shl    $0x2,%eax
  80359f:	05 68 50 80 00       	add    $0x805068,%eax
  8035a4:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  8035a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ac:	89 d0                	mov    %edx,%eax
  8035ae:	01 c0                	add    %eax,%eax
  8035b0:	01 d0                	add    %edx,%eax
  8035b2:	c1 e0 02             	shl    $0x2,%eax
  8035b5:	05 6a 50 80 00       	add    $0x80506a,%eax
  8035ba:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  8035bf:	ff 45 f4             	incl   -0xc(%ebp)
  8035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035c8:	7c c9                	jl     803593 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  8035ca:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8035d1:	00 00 00 
  8035d4:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8035db:	00 00 00 
  8035de:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8035e5:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  8035e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035ef:	e9 9c 00 00 00       	jmp    803690 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8035f4:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8035fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8035fd:	89 c8                	mov    %ecx,%eax
  8035ff:	01 c0                	add    %eax,%eax
  803601:	01 c8                	add    %ecx,%eax
  803603:	c1 e0 02             	shl    $0x2,%eax
  803606:	05 64 50 80 00       	add    $0x805064,%eax
  80360b:	89 10                	mov    %edx,(%eax)
  80360d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803610:	89 d0                	mov    %edx,%eax
  803612:	01 c0                	add    %eax,%eax
  803614:	01 d0                	add    %edx,%eax
  803616:	c1 e0 02             	shl    $0x2,%eax
  803619:	05 64 50 80 00       	add    $0x805064,%eax
  80361e:	8b 00                	mov    (%eax),%eax
  803620:	85 c0                	test   %eax,%eax
  803622:	74 1b                	je     80363f <initialize_dynamic_allocator+0x10d>
  803624:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80362a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80362d:	89 c8                	mov    %ecx,%eax
  80362f:	01 c0                	add    %eax,%eax
  803631:	01 c8                	add    %ecx,%eax
  803633:	c1 e0 02             	shl    $0x2,%eax
  803636:	05 60 50 80 00       	add    $0x805060,%eax
  80363b:	89 02                	mov    %eax,(%edx)
  80363d:	eb 16                	jmp    803655 <initialize_dynamic_allocator+0x123>
  80363f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803642:	89 d0                	mov    %edx,%eax
  803644:	01 c0                	add    %eax,%eax
  803646:	01 d0                	add    %edx,%eax
  803648:	c1 e0 02             	shl    $0x2,%eax
  80364b:	05 60 50 80 00       	add    $0x805060,%eax
  803650:	a3 48 50 80 00       	mov    %eax,0x805048
  803655:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803658:	89 d0                	mov    %edx,%eax
  80365a:	01 c0                	add    %eax,%eax
  80365c:	01 d0                	add    %edx,%eax
  80365e:	c1 e0 02             	shl    $0x2,%eax
  803661:	05 60 50 80 00       	add    $0x805060,%eax
  803666:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80366b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80366e:	89 d0                	mov    %edx,%eax
  803670:	01 c0                	add    %eax,%eax
  803672:	01 d0                	add    %edx,%eax
  803674:	c1 e0 02             	shl    $0x2,%eax
  803677:	05 60 50 80 00       	add    $0x805060,%eax
  80367c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803682:	a1 54 50 80 00       	mov    0x805054,%eax
  803687:	40                   	inc    %eax
  803688:	a3 54 50 80 00       	mov    %eax,0x805054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  80368d:	ff 45 f0             	incl   -0x10(%ebp)
  803690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803693:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803696:	0f 8c 58 ff ff ff    	jl     8035f4 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80369c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8036a3:	eb 36                	jmp    8036db <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  8036a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a8:	c1 e0 04             	shl    $0x4,%eax
  8036ab:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b9:	c1 e0 04             	shl    $0x4,%eax
  8036bc:	05 84 d0 81 00       	add    $0x81d084,%eax
  8036c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ca:	c1 e0 04             	shl    $0x4,%eax
  8036cd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8036d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8036d8:	ff 45 ec             	incl   -0x14(%ebp)
  8036db:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8036df:	7e c4                	jle    8036a5 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8036e1:	90                   	nop
  8036e2:	c9                   	leave  
  8036e3:	c3                   	ret    

008036e4 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  8036e4:	55                   	push   %ebp
  8036e5:	89 e5                	mov    %esp,%ebp
  8036e7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8036ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ed:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8036f2:	29 c2                	sub    %eax,%edx
  8036f4:	89 d0                	mov    %edx,%eax
  8036f6:	c1 e8 0c             	shr    $0xc,%eax
  8036f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  8036fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8036ff:	89 d0                	mov    %edx,%eax
  803701:	01 c0                	add    %eax,%eax
  803703:	01 d0                	add    %edx,%eax
  803705:	c1 e0 02             	shl    $0x2,%eax
  803708:	05 68 50 80 00       	add    $0x805068,%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803712:	c9                   	leave  
  803713:	c3                   	ret    

00803714 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803714:	55                   	push   %ebp
  803715:	89 e5                	mov    %esp,%ebp
  803717:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80371a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803721:	76 16                	jbe    803739 <alloc_block+0x25>
  803723:	68 ec 4b 80 00       	push   $0x804bec
  803728:	68 be 4b 80 00       	push   $0x804bbe
  80372d:	6a 6c                	push   $0x6c
  80372f:	68 d3 4b 80 00       	push   $0x804bd3
  803734:	e8 c8 cc ff ff       	call   800401 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  803739:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80373d:	75 0a                	jne    803749 <alloc_block+0x35>
		return NULL;
  80373f:	b8 00 00 00 00       	mov    $0x0,%eax
  803744:	e9 65 04 00 00       	jmp    803bae <alloc_block+0x49a>
	}
	else if(size<=8){
  803749:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  80374d:	77 09                	ja     803758 <alloc_block+0x44>
		size=8;
  80374f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803756:	eb 1f                	jmp    803777 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803758:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  80375f:	eb 08                	jmp    803769 <alloc_block+0x55>
			reqsize*=2;
  803761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803764:	01 c0                	add    %eax,%eax
  803766:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80376f:	72 f0                	jb     803761 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803774:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803777:	83 ec 0c             	sub    $0xc,%esp
  80377a:	ff 75 08             	pushl  0x8(%ebp)
  80377d:	e8 90 fd ff ff       	call   803512 <log2>
  803782:	83 c4 10             	add    $0x10,%esp
  803785:	83 e8 03             	sub    $0x3,%eax
  803788:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  80378b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378e:	c1 e0 04             	shl    $0x4,%eax
  803791:	05 80 d0 81 00       	add    $0x81d080,%eax
  803796:	8b 00                	mov    (%eax),%eax
  803798:	85 c0                	test   %eax,%eax
  80379a:	0f 84 fb 00 00 00    	je     80389b <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  8037a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a3:	c1 e0 04             	shl    $0x4,%eax
  8037a6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037ab:	8b 00                	mov    (%eax),%eax
  8037ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  8037b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037b4:	75 17                	jne    8037cd <alloc_block+0xb9>
  8037b6:	83 ec 04             	sub    $0x4,%esp
  8037b9:	68 0d 4c 80 00       	push   $0x804c0d
  8037be:	68 86 00 00 00       	push   $0x86
  8037c3:	68 d3 4b 80 00       	push   $0x804bd3
  8037c8:	e8 34 cc ff ff       	call   800401 <_panic>
  8037cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	85 c0                	test   %eax,%eax
  8037d4:	74 10                	je     8037e6 <alloc_block+0xd2>
  8037d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037de:	8b 52 04             	mov    0x4(%edx),%edx
  8037e1:	89 50 04             	mov    %edx,0x4(%eax)
  8037e4:	eb 14                	jmp    8037fa <alloc_block+0xe6>
  8037e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ef:	c1 e2 04             	shl    $0x4,%edx
  8037f2:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8037f8:	89 02                	mov    %eax,(%edx)
  8037fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fd:	8b 40 04             	mov    0x4(%eax),%eax
  803800:	85 c0                	test   %eax,%eax
  803802:	74 0f                	je     803813 <alloc_block+0xff>
  803804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803807:	8b 40 04             	mov    0x4(%eax),%eax
  80380a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80380d:	8b 12                	mov    (%edx),%edx
  80380f:	89 10                	mov    %edx,(%eax)
  803811:	eb 13                	jmp    803826 <alloc_block+0x112>
  803813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803816:	8b 00                	mov    (%eax),%eax
  803818:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80381b:	c1 e2 04             	shl    $0x4,%edx
  80381e:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803824:	89 02                	mov    %eax,(%edx)
  803826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80382f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803832:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803839:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383c:	c1 e0 04             	shl    $0x4,%eax
  80383f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803844:	8b 00                	mov    (%eax),%eax
  803846:	8d 50 ff             	lea    -0x1(%eax),%edx
  803849:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384c:	c1 e0 04             	shl    $0x4,%eax
  80384f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803854:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803856:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803859:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80385e:	29 c2                	sub    %eax,%edx
  803860:	89 d0                	mov    %edx,%eax
  803862:	c1 e8 0c             	shr    $0xc,%eax
  803865:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803868:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80386b:	89 d0                	mov    %edx,%eax
  80386d:	01 c0                	add    %eax,%eax
  80386f:	01 d0                	add    %edx,%eax
  803871:	c1 e0 02             	shl    $0x2,%eax
  803874:	05 6a 50 80 00       	add    $0x80506a,%eax
  803879:	66 8b 00             	mov    (%eax),%ax
  80387c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80387f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803882:	89 c8                	mov    %ecx,%eax
  803884:	01 c0                	add    %eax,%eax
  803886:	01 c8                	add    %ecx,%eax
  803888:	c1 e0 02             	shl    $0x2,%eax
  80388b:	05 6a 50 80 00       	add    $0x80506a,%eax
  803890:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803893:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803896:	e9 13 03 00 00       	jmp    803bae <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  80389b:	a1 48 50 80 00       	mov    0x805048,%eax
  8038a0:	85 c0                	test   %eax,%eax
  8038a2:	0f 84 c9 01 00 00    	je     803a71 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  8038a8:	a1 48 50 80 00       	mov    0x805048,%eax
  8038ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  8038b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038b4:	75 17                	jne    8038cd <alloc_block+0x1b9>
  8038b6:	83 ec 04             	sub    $0x4,%esp
  8038b9:	68 0d 4c 80 00       	push   $0x804c0d
  8038be:	68 8f 00 00 00       	push   $0x8f
  8038c3:	68 d3 4b 80 00       	push   $0x804bd3
  8038c8:	e8 34 cb ff ff       	call   800401 <_panic>
  8038cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d0:	8b 00                	mov    (%eax),%eax
  8038d2:	85 c0                	test   %eax,%eax
  8038d4:	74 10                	je     8038e6 <alloc_block+0x1d2>
  8038d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d9:	8b 00                	mov    (%eax),%eax
  8038db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038de:	8b 52 04             	mov    0x4(%edx),%edx
  8038e1:	89 50 04             	mov    %edx,0x4(%eax)
  8038e4:	eb 0b                	jmp    8038f1 <alloc_block+0x1dd>
  8038e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038e9:	8b 40 04             	mov    0x4(%eax),%eax
  8038ec:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8038f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f4:	8b 40 04             	mov    0x4(%eax),%eax
  8038f7:	85 c0                	test   %eax,%eax
  8038f9:	74 0f                	je     80390a <alloc_block+0x1f6>
  8038fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038fe:	8b 40 04             	mov    0x4(%eax),%eax
  803901:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803904:	8b 12                	mov    (%edx),%edx
  803906:	89 10                	mov    %edx,(%eax)
  803908:	eb 0a                	jmp    803914 <alloc_block+0x200>
  80390a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80390d:	8b 00                	mov    (%eax),%eax
  80390f:	a3 48 50 80 00       	mov    %eax,0x805048
  803914:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803917:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80391d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803920:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803927:	a1 54 50 80 00       	mov    0x805054,%eax
  80392c:	48                   	dec    %eax
  80392d:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803932:	83 ec 0c             	sub    $0xc,%esp
  803935:	ff 75 dc             	pushl  -0x24(%ebp)
  803938:	e8 89 fb ff ff       	call   8034c6 <to_page_va>
  80393d:	83 c4 10             	add    $0x10,%esp
  803940:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803943:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803948:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80394b:	29 c2                	sub    %eax,%edx
  80394d:	89 d0                	mov    %edx,%eax
  80394f:	c1 e8 0c             	shr    $0xc,%eax
  803952:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803958:	83 ec 0c             	sub    $0xc,%esp
  80395b:	50                   	push   %eax
  80395c:	e8 fe dc ff ff       	call   80165f <get_page>
  803961:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803964:	8b 45 08             	mov    0x8(%ebp),%eax
  803967:	89 c2                	mov    %eax,%edx
  803969:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80396c:	89 c8                	mov    %ecx,%eax
  80396e:	01 c0                	add    %eax,%eax
  803970:	01 c8                	add    %ecx,%eax
  803972:	c1 e0 02             	shl    $0x2,%eax
  803975:	05 68 50 80 00       	add    $0x805068,%eax
  80397a:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  80397d:	b8 00 10 00 00       	mov    $0x1000,%eax
  803982:	ba 00 00 00 00       	mov    $0x0,%edx
  803987:	f7 75 08             	divl   0x8(%ebp)
  80398a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  80398d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803990:	8d 50 ff             	lea    -0x1(%eax),%edx
  803993:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803996:	89 c8                	mov    %ecx,%eax
  803998:	01 c0                	add    %eax,%eax
  80399a:	01 c8                	add    %ecx,%eax
  80399c:	c1 e0 02             	shl    $0x2,%eax
  80399f:	05 6a 50 80 00       	add    $0x80506a,%eax
  8039a4:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  8039a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  8039ae:	e9 aa 00 00 00       	jmp    803a5d <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  8039b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b6:	0f af 45 08          	imul   0x8(%ebp),%eax
  8039ba:	89 c2                	mov    %eax,%edx
  8039bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039bf:	01 d0                	add    %edx,%eax
  8039c1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  8039c4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8039c8:	75 17                	jne    8039e1 <alloc_block+0x2cd>
  8039ca:	83 ec 04             	sub    $0x4,%esp
  8039cd:	68 2c 4c 80 00       	push   $0x804c2c
  8039d2:	68 9d 00 00 00       	push   $0x9d
  8039d7:	68 d3 4b 80 00       	push   $0x804bd3
  8039dc:	e8 20 ca ff ff       	call   800401 <_panic>
  8039e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e4:	c1 e0 04             	shl    $0x4,%eax
  8039e7:	05 84 d0 81 00       	add    $0x81d084,%eax
  8039ec:	8b 10                	mov    (%eax),%edx
  8039ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8039f1:	89 50 04             	mov    %edx,0x4(%eax)
  8039f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8039f7:	8b 40 04             	mov    0x4(%eax),%eax
  8039fa:	85 c0                	test   %eax,%eax
  8039fc:	74 14                	je     803a12 <alloc_block+0x2fe>
  8039fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a01:	c1 e0 04             	shl    $0x4,%eax
  803a04:	05 84 d0 81 00       	add    $0x81d084,%eax
  803a09:	8b 00                	mov    (%eax),%eax
  803a0b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803a0e:	89 10                	mov    %edx,(%eax)
  803a10:	eb 11                	jmp    803a23 <alloc_block+0x30f>
  803a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a15:	c1 e0 04             	shl    $0x4,%eax
  803a18:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803a1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a21:	89 02                	mov    %eax,(%edx)
  803a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a26:	c1 e0 04             	shl    $0x4,%eax
  803a29:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803a2f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a32:	89 02                	mov    %eax,(%edx)
  803a34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a40:	c1 e0 04             	shl    $0x4,%eax
  803a43:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a48:	8b 00                	mov    (%eax),%eax
  803a4a:	8d 50 01             	lea    0x1(%eax),%edx
  803a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a50:	c1 e0 04             	shl    $0x4,%eax
  803a53:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a58:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803a5a:	ff 45 f0             	incl   -0x10(%ebp)
  803a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a60:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803a63:	0f 8c 4a ff ff ff    	jl     8039b3 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a6c:	e9 3d 01 00 00       	jmp    803bae <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a74:	40                   	inc    %eax
  803a75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803a78:	e9 10 01 00 00       	jmp    803b8d <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a80:	c1 e0 04             	shl    $0x4,%eax
  803a83:	05 80 d0 81 00       	add    $0x81d080,%eax
  803a88:	8b 00                	mov    (%eax),%eax
  803a8a:	85 c0                	test   %eax,%eax
  803a8c:	0f 84 f8 00 00 00    	je     803b8a <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a95:	c1 e0 04             	shl    $0x4,%eax
  803a98:	05 80 d0 81 00       	add    $0x81d080,%eax
  803a9d:	8b 00                	mov    (%eax),%eax
  803a9f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803aa2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803aa6:	75 17                	jne    803abf <alloc_block+0x3ab>
  803aa8:	83 ec 04             	sub    $0x4,%esp
  803aab:	68 0d 4c 80 00       	push   $0x804c0d
  803ab0:	68 a8 00 00 00       	push   $0xa8
  803ab5:	68 d3 4b 80 00       	push   $0x804bd3
  803aba:	e8 42 c9 ff ff       	call   800401 <_panic>
  803abf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ac2:	8b 00                	mov    (%eax),%eax
  803ac4:	85 c0                	test   %eax,%eax
  803ac6:	74 10                	je     803ad8 <alloc_block+0x3c4>
  803ac8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803acb:	8b 00                	mov    (%eax),%eax
  803acd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ad0:	8b 52 04             	mov    0x4(%edx),%edx
  803ad3:	89 50 04             	mov    %edx,0x4(%eax)
  803ad6:	eb 14                	jmp    803aec <alloc_block+0x3d8>
  803ad8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803adb:	8b 40 04             	mov    0x4(%eax),%eax
  803ade:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ae1:	c1 e2 04             	shl    $0x4,%edx
  803ae4:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803aea:	89 02                	mov    %eax,(%edx)
  803aec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803aef:	8b 40 04             	mov    0x4(%eax),%eax
  803af2:	85 c0                	test   %eax,%eax
  803af4:	74 0f                	je     803b05 <alloc_block+0x3f1>
  803af6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803af9:	8b 40 04             	mov    0x4(%eax),%eax
  803afc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803aff:	8b 12                	mov    (%edx),%edx
  803b01:	89 10                	mov    %edx,(%eax)
  803b03:	eb 13                	jmp    803b18 <alloc_block+0x404>
  803b05:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b08:	8b 00                	mov    (%eax),%eax
  803b0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b0d:	c1 e2 04             	shl    $0x4,%edx
  803b10:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803b16:	89 02                	mov    %eax,(%edx)
  803b18:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b21:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b2e:	c1 e0 04             	shl    $0x4,%eax
  803b31:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803b36:	8b 00                	mov    (%eax),%eax
  803b38:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b3e:	c1 e0 04             	shl    $0x4,%eax
  803b41:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803b46:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803b48:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b4b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803b50:	29 c2                	sub    %eax,%edx
  803b52:	89 d0                	mov    %edx,%eax
  803b54:	c1 e8 0c             	shr    $0xc,%eax
  803b57:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803b5a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803b5d:	89 d0                	mov    %edx,%eax
  803b5f:	01 c0                	add    %eax,%eax
  803b61:	01 d0                	add    %edx,%eax
  803b63:	c1 e0 02             	shl    $0x2,%eax
  803b66:	05 6a 50 80 00       	add    $0x80506a,%eax
  803b6b:	66 8b 00             	mov    (%eax),%ax
  803b6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b71:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803b74:	89 c8                	mov    %ecx,%eax
  803b76:	01 c0                	add    %eax,%eax
  803b78:	01 c8                	add    %ecx,%eax
  803b7a:	c1 e0 02             	shl    $0x2,%eax
  803b7d:	05 6a 50 80 00       	add    $0x80506a,%eax
  803b82:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803b85:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b88:	eb 24                	jmp    803bae <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803b8a:	ff 45 ec             	incl   -0x14(%ebp)
  803b8d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803b91:	0f 8e e6 fe ff ff    	jle    803a7d <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803b97:	83 ec 04             	sub    $0x4,%esp
  803b9a:	68 4f 4c 80 00       	push   $0x804c4f
  803b9f:	68 b1 00 00 00       	push   $0xb1
  803ba4:	68 d3 4b 80 00       	push   $0x804bd3
  803ba9:	e8 53 c8 ff ff       	call   800401 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803bae:	c9                   	leave  
  803baf:	c3                   	ret    

00803bb0 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803bb0:	55                   	push   %ebp
  803bb1:	89 e5                	mov    %esp,%ebp
  803bb3:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  803bb9:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803bbe:	39 c2                	cmp    %eax,%edx
  803bc0:	72 0c                	jb     803bce <free_block+0x1e>
  803bc2:	8b 55 08             	mov    0x8(%ebp),%edx
  803bc5:	a1 40 50 80 00       	mov    0x805040,%eax
  803bca:	39 c2                	cmp    %eax,%edx
  803bcc:	72 19                	jb     803be7 <free_block+0x37>
  803bce:	68 6c 4c 80 00       	push   $0x804c6c
  803bd3:	68 be 4b 80 00       	push   $0x804bbe
  803bd8:	68 c3 00 00 00       	push   $0xc3
  803bdd:	68 d3 4b 80 00       	push   $0x804bd3
  803be2:	e8 1a c8 ff ff       	call   800401 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803be7:	8b 55 08             	mov    0x8(%ebp),%edx
  803bea:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803bef:	29 c2                	sub    %eax,%edx
  803bf1:	89 d0                	mov    %edx,%eax
  803bf3:	c1 e8 0c             	shr    $0xc,%eax
  803bf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803bf9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bfc:	89 d0                	mov    %edx,%eax
  803bfe:	01 c0                	add    %eax,%eax
  803c00:	01 d0                	add    %edx,%eax
  803c02:	c1 e0 02             	shl    $0x2,%eax
  803c05:	05 68 50 80 00       	add    $0x805068,%eax
  803c0a:	8b 00                	mov    (%eax),%eax
  803c0c:	0f b7 c0             	movzwl %ax,%eax
  803c0f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803c12:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c16:	75 17                	jne    803c2f <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803c18:	83 ec 04             	sub    $0x4,%esp
  803c1b:	68 a4 4c 80 00       	push   $0x804ca4
  803c20:	68 cf 00 00 00       	push   $0xcf
  803c25:	68 d3 4b 80 00       	push   $0x804bd3
  803c2a:	e8 d2 c7 ff ff       	call   800401 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803c2f:	83 ec 0c             	sub    $0xc,%esp
  803c32:	ff 75 ec             	pushl  -0x14(%ebp)
  803c35:	e8 d8 f8 ff ff       	call   803512 <log2>
  803c3a:	83 c4 10             	add    $0x10,%esp
  803c3d:	83 e8 03             	sub    $0x3,%eax
  803c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803c43:	8b 45 08             	mov    0x8(%ebp),%eax
  803c46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803c49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c4d:	75 17                	jne    803c66 <free_block+0xb6>
  803c4f:	83 ec 04             	sub    $0x4,%esp
  803c52:	68 2c 4c 80 00       	push   $0x804c2c
  803c57:	68 d5 00 00 00       	push   $0xd5
  803c5c:	68 d3 4b 80 00       	push   $0x804bd3
  803c61:	e8 9b c7 ff ff       	call   800401 <_panic>
  803c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c69:	c1 e0 04             	shl    $0x4,%eax
  803c6c:	05 84 d0 81 00       	add    $0x81d084,%eax
  803c71:	8b 10                	mov    (%eax),%edx
  803c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c76:	89 50 04             	mov    %edx,0x4(%eax)
  803c79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c7c:	8b 40 04             	mov    0x4(%eax),%eax
  803c7f:	85 c0                	test   %eax,%eax
  803c81:	74 14                	je     803c97 <free_block+0xe7>
  803c83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c86:	c1 e0 04             	shl    $0x4,%eax
  803c89:	05 84 d0 81 00       	add    $0x81d084,%eax
  803c8e:	8b 00                	mov    (%eax),%eax
  803c90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c93:	89 10                	mov    %edx,(%eax)
  803c95:	eb 11                	jmp    803ca8 <free_block+0xf8>
  803c97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c9a:	c1 e0 04             	shl    $0x4,%eax
  803c9d:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca6:	89 02                	mov    %eax,(%edx)
  803ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cab:	c1 e0 04             	shl    $0x4,%eax
  803cae:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803cb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb7:	89 02                	mov    %eax,(%edx)
  803cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc5:	c1 e0 04             	shl    $0x4,%eax
  803cc8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ccd:	8b 00                	mov    (%eax),%eax
  803ccf:	8d 50 01             	lea    0x1(%eax),%edx
  803cd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd5:	c1 e0 04             	shl    $0x4,%eax
  803cd8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803cdd:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803cdf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ce2:	89 d0                	mov    %edx,%eax
  803ce4:	01 c0                	add    %eax,%eax
  803ce6:	01 d0                	add    %edx,%eax
  803ce8:	c1 e0 02             	shl    $0x2,%eax
  803ceb:	05 6a 50 80 00       	add    $0x80506a,%eax
  803cf0:	66 8b 00             	mov    (%eax),%ax
  803cf3:	8d 50 01             	lea    0x1(%eax),%edx
  803cf6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803cf9:	89 c8                	mov    %ecx,%eax
  803cfb:	01 c0                	add    %eax,%eax
  803cfd:	01 c8                	add    %ecx,%eax
  803cff:	c1 e0 02             	shl    $0x2,%eax
  803d02:	05 6a 50 80 00       	add    $0x80506a,%eax
  803d07:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803d0a:	b8 00 10 00 00       	mov    $0x1000,%eax
  803d0f:	ba 00 00 00 00       	mov    $0x0,%edx
  803d14:	f7 75 ec             	divl   -0x14(%ebp)
  803d17:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803d1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d1d:	89 d0                	mov    %edx,%eax
  803d1f:	01 c0                	add    %eax,%eax
  803d21:	01 d0                	add    %edx,%eax
  803d23:	c1 e0 02             	shl    $0x2,%eax
  803d26:	05 6a 50 80 00       	add    $0x80506a,%eax
  803d2b:	66 8b 00             	mov    (%eax),%ax
  803d2e:	0f b7 c0             	movzwl %ax,%eax
  803d31:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d34:	0f 85 d3 01 00 00    	jne    803f0d <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803d3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3d:	c1 e0 04             	shl    $0x4,%eax
  803d40:	05 80 d0 81 00       	add    $0x81d080,%eax
  803d45:	8b 00                	mov    (%eax),%eax
  803d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803d4a:	e9 f1 00 00 00       	jmp    803e40 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d52:	8b 00                	mov    (%eax),%eax
  803d54:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d5a:	c1 e0 0c             	shl    $0xc,%eax
  803d5d:	89 c2                	mov    %eax,%edx
  803d5f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803d64:	01 d0                	add    %edx,%eax
  803d66:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d6c:	40                   	inc    %eax
  803d6d:	c1 e0 0c             	shl    $0xc,%eax
  803d70:	89 c2                	mov    %eax,%edx
  803d72:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803d77:	01 d0                	add    %edx,%eax
  803d79:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803d82:	0f 82 b8 00 00 00    	jb     803e40 <free_block+0x290>
  803d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d8e:	0f 83 ac 00 00 00    	jae    803e40 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d98:	75 17                	jne    803db1 <free_block+0x201>
  803d9a:	83 ec 04             	sub    $0x4,%esp
  803d9d:	68 0d 4c 80 00       	push   $0x804c0d
  803da2:	68 e2 00 00 00       	push   $0xe2
  803da7:	68 d3 4b 80 00       	push   $0x804bd3
  803dac:	e8 50 c6 ff ff       	call   800401 <_panic>
  803db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db4:	8b 00                	mov    (%eax),%eax
  803db6:	85 c0                	test   %eax,%eax
  803db8:	74 10                	je     803dca <free_block+0x21a>
  803dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbd:	8b 00                	mov    (%eax),%eax
  803dbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dc2:	8b 52 04             	mov    0x4(%edx),%edx
  803dc5:	89 50 04             	mov    %edx,0x4(%eax)
  803dc8:	eb 14                	jmp    803dde <free_block+0x22e>
  803dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dcd:	8b 40 04             	mov    0x4(%eax),%eax
  803dd0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803dd3:	c1 e2 04             	shl    $0x4,%edx
  803dd6:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803ddc:	89 02                	mov    %eax,(%edx)
  803dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de1:	8b 40 04             	mov    0x4(%eax),%eax
  803de4:	85 c0                	test   %eax,%eax
  803de6:	74 0f                	je     803df7 <free_block+0x247>
  803de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803deb:	8b 40 04             	mov    0x4(%eax),%eax
  803dee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803df1:	8b 12                	mov    (%edx),%edx
  803df3:	89 10                	mov    %edx,(%eax)
  803df5:	eb 13                	jmp    803e0a <free_block+0x25a>
  803df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfa:	8b 00                	mov    (%eax),%eax
  803dfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803dff:	c1 e2 04             	shl    $0x4,%edx
  803e02:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803e08:	89 02                	mov    %eax,(%edx)
  803e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e20:	c1 e0 04             	shl    $0x4,%eax
  803e23:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803e28:	8b 00                	mov    (%eax),%eax
  803e2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e30:	c1 e0 04             	shl    $0x4,%eax
  803e33:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803e38:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803e3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803e40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e44:	0f 85 05 ff ff ff    	jne    803d4f <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803e4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e4d:	89 d0                	mov    %edx,%eax
  803e4f:	01 c0                	add    %eax,%eax
  803e51:	01 d0                	add    %edx,%eax
  803e53:	c1 e0 02             	shl    $0x2,%eax
  803e56:	05 68 50 80 00       	add    $0x805068,%eax
  803e5b:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803e60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e63:	89 d0                	mov    %edx,%eax
  803e65:	01 c0                	add    %eax,%eax
  803e67:	01 d0                	add    %edx,%eax
  803e69:	c1 e0 02             	shl    $0x2,%eax
  803e6c:	05 6a 50 80 00       	add    $0x80506a,%eax
  803e71:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803e76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e79:	89 d0                	mov    %edx,%eax
  803e7b:	01 c0                	add    %eax,%eax
  803e7d:	01 d0                	add    %edx,%eax
  803e7f:	c1 e0 02             	shl    $0x2,%eax
  803e82:	05 60 50 80 00       	add    $0x805060,%eax
  803e87:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803e8a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803e8e:	75 17                	jne    803ea7 <free_block+0x2f7>
  803e90:	83 ec 04             	sub    $0x4,%esp
  803e93:	68 2c 4c 80 00       	push   $0x804c2c
  803e98:	68 eb 00 00 00       	push   $0xeb
  803e9d:	68 d3 4b 80 00       	push   $0x804bd3
  803ea2:	e8 5a c5 ff ff       	call   800401 <_panic>
  803ea7:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803ead:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803eb0:	89 50 04             	mov    %edx,0x4(%eax)
  803eb3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803eb6:	8b 40 04             	mov    0x4(%eax),%eax
  803eb9:	85 c0                	test   %eax,%eax
  803ebb:	74 0c                	je     803ec9 <free_block+0x319>
  803ebd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803ec2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803ec5:	89 10                	mov    %edx,(%eax)
  803ec7:	eb 08                	jmp    803ed1 <free_block+0x321>
  803ec9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ecc:	a3 48 50 80 00       	mov    %eax,0x805048
  803ed1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ed4:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803ed9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803edc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ee2:	a1 54 50 80 00       	mov    0x805054,%eax
  803ee7:	40                   	inc    %eax
  803ee8:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803eed:	83 ec 0c             	sub    $0xc,%esp
  803ef0:	ff 75 d0             	pushl  -0x30(%ebp)
  803ef3:	e8 ce f5 ff ff       	call   8034c6 <to_page_va>
  803ef8:	83 c4 10             	add    $0x10,%esp
  803efb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803efe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f01:	83 ec 0c             	sub    $0xc,%esp
  803f04:	50                   	push   %eax
  803f05:	e8 9e d7 ff ff       	call   8016a8 <return_page>
  803f0a:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803f0d:	90                   	nop
  803f0e:	c9                   	leave  
  803f0f:	c3                   	ret    

00803f10 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803f10:	55                   	push   %ebp
  803f11:	89 e5                	mov    %esp,%ebp
  803f13:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803f16:	83 ec 04             	sub    $0x4,%esp
  803f19:	68 cc 4c 80 00       	push   $0x804ccc
  803f1e:	68 01 01 00 00       	push   $0x101
  803f23:	68 d3 4b 80 00       	push   $0x804bd3
  803f28:	e8 d4 c4 ff ff       	call   800401 <_panic>

00803f2d <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803f2d:	55                   	push   %ebp
  803f2e:	89 e5                	mov    %esp,%ebp
  803f30:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803f33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803f37:	74 1c                	je     803f55 <init_uspinlock+0x28>
  803f39:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803f3d:	74 16                	je     803f55 <init_uspinlock+0x28>
  803f3f:	68 f0 4c 80 00       	push   $0x804cf0
  803f44:	68 0f 4d 80 00       	push   $0x804d0f
  803f49:	6a 10                	push   $0x10
  803f4b:	68 24 4d 80 00       	push   $0x804d24
  803f50:	e8 ac c4 ff ff       	call   800401 <_panic>
	strcpy(lk->name, name);
  803f55:	8b 45 08             	mov    0x8(%ebp),%eax
  803f58:	83 c0 04             	add    $0x4,%eax
  803f5b:	83 ec 08             	sub    $0x8,%esp
  803f5e:	ff 75 0c             	pushl  0xc(%ebp)
  803f61:	50                   	push   %eax
  803f62:	e8 90 ce ff ff       	call   800df7 <strcpy>
  803f67:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  803f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803f6f:	2b 45 10             	sub    0x10(%ebp),%eax
  803f72:	89 c2                	mov    %eax,%edx
  803f74:	8b 45 08             	mov    0x8(%ebp),%eax
  803f77:	89 10                	mov    %edx,(%eax)
}
  803f79:	90                   	nop
  803f7a:	c9                   	leave  
  803f7b:	c3                   	ret    

00803f7c <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  803f7c:	55                   	push   %ebp
  803f7d:	89 e5                	mov    %esp,%ebp
  803f7f:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803f82:	90                   	nop
  803f83:	8b 45 08             	mov    0x8(%ebp),%eax
  803f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f89:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f96:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803f99:	f0 87 02             	lock xchg %eax,(%edx)
  803f9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  803f9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fa2:	85 c0                	test   %eax,%eax
  803fa4:	75 dd                	jne    803f83 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa9:	8d 48 04             	lea    0x4(%eax),%ecx
  803fac:	a1 20 50 80 00       	mov    0x805020,%eax
  803fb1:	8d 50 20             	lea    0x20(%eax),%edx
  803fb4:	a1 20 50 80 00       	mov    0x805020,%eax
  803fb9:	8b 40 10             	mov    0x10(%eax),%eax
  803fbc:	51                   	push   %ecx
  803fbd:	52                   	push   %edx
  803fbe:	50                   	push   %eax
  803fbf:	68 34 4d 80 00       	push   $0x804d34
  803fc4:	e8 06 c7 ff ff       	call   8006cf <cprintf>
  803fc9:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  803fcc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  803fd1:	90                   	nop
  803fd2:	c9                   	leave  
  803fd3:	c3                   	ret    

00803fd4 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  803fd4:	55                   	push   %ebp
  803fd5:	89 e5                	mov    %esp,%ebp
  803fd7:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  803fda:	8b 45 08             	mov    0x8(%ebp),%eax
  803fdd:	8b 00                	mov    (%eax),%eax
  803fdf:	85 c0                	test   %eax,%eax
  803fe1:	75 18                	jne    803ffb <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  803fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe6:	83 c0 04             	add    $0x4,%eax
  803fe9:	50                   	push   %eax
  803fea:	68 58 4d 80 00       	push   $0x804d58
  803fef:	6a 2b                	push   $0x2b
  803ff1:	68 24 4d 80 00       	push   $0x804d24
  803ff6:	e8 06 c4 ff ff       	call   800401 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  803ffb:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  804000:	8b 45 08             	mov    0x8(%ebp),%eax
  804003:	8b 55 08             	mov    0x8(%ebp),%edx
  804006:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80400c:	8b 45 08             	mov    0x8(%ebp),%eax
  80400f:	8d 48 04             	lea    0x4(%eax),%ecx
  804012:	a1 20 50 80 00       	mov    0x805020,%eax
  804017:	8d 50 20             	lea    0x20(%eax),%edx
  80401a:	a1 20 50 80 00       	mov    0x805020,%eax
  80401f:	8b 40 10             	mov    0x10(%eax),%eax
  804022:	51                   	push   %ecx
  804023:	52                   	push   %edx
  804024:	50                   	push   %eax
  804025:	68 78 4d 80 00       	push   $0x804d78
  80402a:	e8 a0 c6 ff ff       	call   8006cf <cprintf>
  80402f:	83 c4 10             	add    $0x10,%esp
}
  804032:	90                   	nop
  804033:	c9                   	leave  
  804034:	c3                   	ret    
  804035:	66 90                	xchg   %ax,%ax
  804037:	90                   	nop

00804038 <__udivdi3>:
  804038:	55                   	push   %ebp
  804039:	57                   	push   %edi
  80403a:	56                   	push   %esi
  80403b:	53                   	push   %ebx
  80403c:	83 ec 1c             	sub    $0x1c,%esp
  80403f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804043:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804047:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80404b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80404f:	89 ca                	mov    %ecx,%edx
  804051:	89 f8                	mov    %edi,%eax
  804053:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804057:	85 f6                	test   %esi,%esi
  804059:	75 2d                	jne    804088 <__udivdi3+0x50>
  80405b:	39 cf                	cmp    %ecx,%edi
  80405d:	77 65                	ja     8040c4 <__udivdi3+0x8c>
  80405f:	89 fd                	mov    %edi,%ebp
  804061:	85 ff                	test   %edi,%edi
  804063:	75 0b                	jne    804070 <__udivdi3+0x38>
  804065:	b8 01 00 00 00       	mov    $0x1,%eax
  80406a:	31 d2                	xor    %edx,%edx
  80406c:	f7 f7                	div    %edi
  80406e:	89 c5                	mov    %eax,%ebp
  804070:	31 d2                	xor    %edx,%edx
  804072:	89 c8                	mov    %ecx,%eax
  804074:	f7 f5                	div    %ebp
  804076:	89 c1                	mov    %eax,%ecx
  804078:	89 d8                	mov    %ebx,%eax
  80407a:	f7 f5                	div    %ebp
  80407c:	89 cf                	mov    %ecx,%edi
  80407e:	89 fa                	mov    %edi,%edx
  804080:	83 c4 1c             	add    $0x1c,%esp
  804083:	5b                   	pop    %ebx
  804084:	5e                   	pop    %esi
  804085:	5f                   	pop    %edi
  804086:	5d                   	pop    %ebp
  804087:	c3                   	ret    
  804088:	39 ce                	cmp    %ecx,%esi
  80408a:	77 28                	ja     8040b4 <__udivdi3+0x7c>
  80408c:	0f bd fe             	bsr    %esi,%edi
  80408f:	83 f7 1f             	xor    $0x1f,%edi
  804092:	75 40                	jne    8040d4 <__udivdi3+0x9c>
  804094:	39 ce                	cmp    %ecx,%esi
  804096:	72 0a                	jb     8040a2 <__udivdi3+0x6a>
  804098:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80409c:	0f 87 9e 00 00 00    	ja     804140 <__udivdi3+0x108>
  8040a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8040a7:	89 fa                	mov    %edi,%edx
  8040a9:	83 c4 1c             	add    $0x1c,%esp
  8040ac:	5b                   	pop    %ebx
  8040ad:	5e                   	pop    %esi
  8040ae:	5f                   	pop    %edi
  8040af:	5d                   	pop    %ebp
  8040b0:	c3                   	ret    
  8040b1:	8d 76 00             	lea    0x0(%esi),%esi
  8040b4:	31 ff                	xor    %edi,%edi
  8040b6:	31 c0                	xor    %eax,%eax
  8040b8:	89 fa                	mov    %edi,%edx
  8040ba:	83 c4 1c             	add    $0x1c,%esp
  8040bd:	5b                   	pop    %ebx
  8040be:	5e                   	pop    %esi
  8040bf:	5f                   	pop    %edi
  8040c0:	5d                   	pop    %ebp
  8040c1:	c3                   	ret    
  8040c2:	66 90                	xchg   %ax,%ax
  8040c4:	89 d8                	mov    %ebx,%eax
  8040c6:	f7 f7                	div    %edi
  8040c8:	31 ff                	xor    %edi,%edi
  8040ca:	89 fa                	mov    %edi,%edx
  8040cc:	83 c4 1c             	add    $0x1c,%esp
  8040cf:	5b                   	pop    %ebx
  8040d0:	5e                   	pop    %esi
  8040d1:	5f                   	pop    %edi
  8040d2:	5d                   	pop    %ebp
  8040d3:	c3                   	ret    
  8040d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040d9:	89 eb                	mov    %ebp,%ebx
  8040db:	29 fb                	sub    %edi,%ebx
  8040dd:	89 f9                	mov    %edi,%ecx
  8040df:	d3 e6                	shl    %cl,%esi
  8040e1:	89 c5                	mov    %eax,%ebp
  8040e3:	88 d9                	mov    %bl,%cl
  8040e5:	d3 ed                	shr    %cl,%ebp
  8040e7:	89 e9                	mov    %ebp,%ecx
  8040e9:	09 f1                	or     %esi,%ecx
  8040eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040ef:	89 f9                	mov    %edi,%ecx
  8040f1:	d3 e0                	shl    %cl,%eax
  8040f3:	89 c5                	mov    %eax,%ebp
  8040f5:	89 d6                	mov    %edx,%esi
  8040f7:	88 d9                	mov    %bl,%cl
  8040f9:	d3 ee                	shr    %cl,%esi
  8040fb:	89 f9                	mov    %edi,%ecx
  8040fd:	d3 e2                	shl    %cl,%edx
  8040ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  804103:	88 d9                	mov    %bl,%cl
  804105:	d3 e8                	shr    %cl,%eax
  804107:	09 c2                	or     %eax,%edx
  804109:	89 d0                	mov    %edx,%eax
  80410b:	89 f2                	mov    %esi,%edx
  80410d:	f7 74 24 0c          	divl   0xc(%esp)
  804111:	89 d6                	mov    %edx,%esi
  804113:	89 c3                	mov    %eax,%ebx
  804115:	f7 e5                	mul    %ebp
  804117:	39 d6                	cmp    %edx,%esi
  804119:	72 19                	jb     804134 <__udivdi3+0xfc>
  80411b:	74 0b                	je     804128 <__udivdi3+0xf0>
  80411d:	89 d8                	mov    %ebx,%eax
  80411f:	31 ff                	xor    %edi,%edi
  804121:	e9 58 ff ff ff       	jmp    80407e <__udivdi3+0x46>
  804126:	66 90                	xchg   %ax,%ax
  804128:	8b 54 24 08          	mov    0x8(%esp),%edx
  80412c:	89 f9                	mov    %edi,%ecx
  80412e:	d3 e2                	shl    %cl,%edx
  804130:	39 c2                	cmp    %eax,%edx
  804132:	73 e9                	jae    80411d <__udivdi3+0xe5>
  804134:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804137:	31 ff                	xor    %edi,%edi
  804139:	e9 40 ff ff ff       	jmp    80407e <__udivdi3+0x46>
  80413e:	66 90                	xchg   %ax,%ax
  804140:	31 c0                	xor    %eax,%eax
  804142:	e9 37 ff ff ff       	jmp    80407e <__udivdi3+0x46>
  804147:	90                   	nop

00804148 <__umoddi3>:
  804148:	55                   	push   %ebp
  804149:	57                   	push   %edi
  80414a:	56                   	push   %esi
  80414b:	53                   	push   %ebx
  80414c:	83 ec 1c             	sub    $0x1c,%esp
  80414f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804153:	8b 74 24 34          	mov    0x34(%esp),%esi
  804157:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80415b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80415f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804163:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804167:	89 f3                	mov    %esi,%ebx
  804169:	89 fa                	mov    %edi,%edx
  80416b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80416f:	89 34 24             	mov    %esi,(%esp)
  804172:	85 c0                	test   %eax,%eax
  804174:	75 1a                	jne    804190 <__umoddi3+0x48>
  804176:	39 f7                	cmp    %esi,%edi
  804178:	0f 86 a2 00 00 00    	jbe    804220 <__umoddi3+0xd8>
  80417e:	89 c8                	mov    %ecx,%eax
  804180:	89 f2                	mov    %esi,%edx
  804182:	f7 f7                	div    %edi
  804184:	89 d0                	mov    %edx,%eax
  804186:	31 d2                	xor    %edx,%edx
  804188:	83 c4 1c             	add    $0x1c,%esp
  80418b:	5b                   	pop    %ebx
  80418c:	5e                   	pop    %esi
  80418d:	5f                   	pop    %edi
  80418e:	5d                   	pop    %ebp
  80418f:	c3                   	ret    
  804190:	39 f0                	cmp    %esi,%eax
  804192:	0f 87 ac 00 00 00    	ja     804244 <__umoddi3+0xfc>
  804198:	0f bd e8             	bsr    %eax,%ebp
  80419b:	83 f5 1f             	xor    $0x1f,%ebp
  80419e:	0f 84 ac 00 00 00    	je     804250 <__umoddi3+0x108>
  8041a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8041a9:	29 ef                	sub    %ebp,%edi
  8041ab:	89 fe                	mov    %edi,%esi
  8041ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041b1:	89 e9                	mov    %ebp,%ecx
  8041b3:	d3 e0                	shl    %cl,%eax
  8041b5:	89 d7                	mov    %edx,%edi
  8041b7:	89 f1                	mov    %esi,%ecx
  8041b9:	d3 ef                	shr    %cl,%edi
  8041bb:	09 c7                	or     %eax,%edi
  8041bd:	89 e9                	mov    %ebp,%ecx
  8041bf:	d3 e2                	shl    %cl,%edx
  8041c1:	89 14 24             	mov    %edx,(%esp)
  8041c4:	89 d8                	mov    %ebx,%eax
  8041c6:	d3 e0                	shl    %cl,%eax
  8041c8:	89 c2                	mov    %eax,%edx
  8041ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041ce:	d3 e0                	shl    %cl,%eax
  8041d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041d8:	89 f1                	mov    %esi,%ecx
  8041da:	d3 e8                	shr    %cl,%eax
  8041dc:	09 d0                	or     %edx,%eax
  8041de:	d3 eb                	shr    %cl,%ebx
  8041e0:	89 da                	mov    %ebx,%edx
  8041e2:	f7 f7                	div    %edi
  8041e4:	89 d3                	mov    %edx,%ebx
  8041e6:	f7 24 24             	mull   (%esp)
  8041e9:	89 c6                	mov    %eax,%esi
  8041eb:	89 d1                	mov    %edx,%ecx
  8041ed:	39 d3                	cmp    %edx,%ebx
  8041ef:	0f 82 87 00 00 00    	jb     80427c <__umoddi3+0x134>
  8041f5:	0f 84 91 00 00 00    	je     80428c <__umoddi3+0x144>
  8041fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041ff:	29 f2                	sub    %esi,%edx
  804201:	19 cb                	sbb    %ecx,%ebx
  804203:	89 d8                	mov    %ebx,%eax
  804205:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804209:	d3 e0                	shl    %cl,%eax
  80420b:	89 e9                	mov    %ebp,%ecx
  80420d:	d3 ea                	shr    %cl,%edx
  80420f:	09 d0                	or     %edx,%eax
  804211:	89 e9                	mov    %ebp,%ecx
  804213:	d3 eb                	shr    %cl,%ebx
  804215:	89 da                	mov    %ebx,%edx
  804217:	83 c4 1c             	add    $0x1c,%esp
  80421a:	5b                   	pop    %ebx
  80421b:	5e                   	pop    %esi
  80421c:	5f                   	pop    %edi
  80421d:	5d                   	pop    %ebp
  80421e:	c3                   	ret    
  80421f:	90                   	nop
  804220:	89 fd                	mov    %edi,%ebp
  804222:	85 ff                	test   %edi,%edi
  804224:	75 0b                	jne    804231 <__umoddi3+0xe9>
  804226:	b8 01 00 00 00       	mov    $0x1,%eax
  80422b:	31 d2                	xor    %edx,%edx
  80422d:	f7 f7                	div    %edi
  80422f:	89 c5                	mov    %eax,%ebp
  804231:	89 f0                	mov    %esi,%eax
  804233:	31 d2                	xor    %edx,%edx
  804235:	f7 f5                	div    %ebp
  804237:	89 c8                	mov    %ecx,%eax
  804239:	f7 f5                	div    %ebp
  80423b:	89 d0                	mov    %edx,%eax
  80423d:	e9 44 ff ff ff       	jmp    804186 <__umoddi3+0x3e>
  804242:	66 90                	xchg   %ax,%ax
  804244:	89 c8                	mov    %ecx,%eax
  804246:	89 f2                	mov    %esi,%edx
  804248:	83 c4 1c             	add    $0x1c,%esp
  80424b:	5b                   	pop    %ebx
  80424c:	5e                   	pop    %esi
  80424d:	5f                   	pop    %edi
  80424e:	5d                   	pop    %ebp
  80424f:	c3                   	ret    
  804250:	3b 04 24             	cmp    (%esp),%eax
  804253:	72 06                	jb     80425b <__umoddi3+0x113>
  804255:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804259:	77 0f                	ja     80426a <__umoddi3+0x122>
  80425b:	89 f2                	mov    %esi,%edx
  80425d:	29 f9                	sub    %edi,%ecx
  80425f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804263:	89 14 24             	mov    %edx,(%esp)
  804266:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80426a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80426e:	8b 14 24             	mov    (%esp),%edx
  804271:	83 c4 1c             	add    $0x1c,%esp
  804274:	5b                   	pop    %ebx
  804275:	5e                   	pop    %esi
  804276:	5f                   	pop    %edi
  804277:	5d                   	pop    %ebp
  804278:	c3                   	ret    
  804279:	8d 76 00             	lea    0x0(%esi),%esi
  80427c:	2b 04 24             	sub    (%esp),%eax
  80427f:	19 fa                	sbb    %edi,%edx
  804281:	89 d1                	mov    %edx,%ecx
  804283:	89 c6                	mov    %eax,%esi
  804285:	e9 71 ff ff ff       	jmp    8041fb <__umoddi3+0xb3>
  80428a:	66 90                	xchg   %ax,%ax
  80428c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804290:	72 ea                	jb     80427c <__umoddi3+0x134>
  804292:	89 d9                	mov    %ebx,%ecx
  804294:	e9 62 ff ff ff       	jmp    8041fb <__umoddi3+0xb3>
