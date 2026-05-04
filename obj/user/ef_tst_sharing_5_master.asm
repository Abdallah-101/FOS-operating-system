
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 d6 04 00 00       	call   80050c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800044:	a1 20 60 80 00       	mov    0x806020,%eax
  800049:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004f:	a1 20 60 80 00       	mov    0x806020,%eax
  800054:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80005a:	39 c2                	cmp    %eax,%edx
  80005c:	72 14                	jb     800072 <_main+0x3a>
			panic("Please increase the WS size");
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 20 46 80 00       	push   $0x804620
  800066:	6a 0b                	push   $0xb
  800068:	68 3c 46 80 00       	push   $0x80463c
  80006d:	e8 53 06 00 00       	call   8006c5 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800072:	c7 45 e4 00 10 00 82 	movl   $0x82001000,-0x1c(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	68 5c 46 80 00       	push   $0x80465c
  800081:	e8 0d 09 00 00       	call   800993 <cprintf>
  800086:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	68 90 46 80 00       	push   $0x804690
  800091:	e8 fd 08 00 00       	call   800993 <cprintf>
  800096:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 ec 46 80 00       	push   $0x8046ec
  8000a1:	e8 ed 08 00 00       	call   800993 <cprintf>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000a9:	e8 00 34 00 00       	call   8034ae <sys_getenvid>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 20 47 80 00       	push   $0x804720
  8000b9:	e8 d5 08 00 00       	call   800993 <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000c1:	a1 20 60 80 00       	mov    0x806020,%eax
  8000c6:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8000cc:	89 c2                	mov    %eax,%edx
  8000ce:	a1 20 60 80 00       	mov    0x806020,%eax
  8000d3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d9:	6a 32                	push   $0x32
  8000db:	52                   	push   %edx
  8000dc:	50                   	push   %eax
  8000dd:	68 61 47 80 00       	push   $0x804761
  8000e2:	e8 72 33 00 00       	call   803459 <sys_create_env>
  8000e7:	83 c4 10             	add    $0x10,%esp
  8000ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000ed:	a1 20 60 80 00       	mov    0x806020,%eax
  8000f2:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8000f8:	89 c2                	mov    %eax,%edx
  8000fa:	a1 20 60 80 00       	mov    0x806020,%eax
  8000ff:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800105:	6a 32                	push   $0x32
  800107:	52                   	push   %edx
  800108:	50                   	push   %eax
  800109:	68 61 47 80 00       	push   $0x804761
  80010e:	e8 46 33 00 00       	call   803459 <sys_create_env>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800119:	e8 e0 31 00 00       	call   8032fe <sys_calculate_free_frames>
  80011e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800121:	83 ec 04             	sub    $0x4,%esp
  800124:	6a 01                	push   $0x1
  800126:	68 00 10 00 00       	push   $0x1000
  80012b:	68 6f 47 80 00       	push   $0x80476f
  800130:	e8 05 25 00 00       	call   80263a <smalloc>
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	89 45 d0             	mov    %eax,-0x30(%ebp)
		cprintf("Master env created x (1 page) \n");
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	68 74 47 80 00       	push   $0x804774
  800143:	e8 4b 08 00 00       	call   800993 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80014b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 94 47 80 00       	push   $0x804794
  80015b:	6a 27                	push   $0x27
  80015d:	68 3c 46 80 00       	push   $0x80463c
  800162:	e8 5e 05 00 00       	call   8006c5 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800167:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80016e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800171:	e8 88 31 00 00       	call   8032fe <sys_calculate_free_frames>
  800176:	29 c3                	sub    %eax,%ebx
  800178:	89 d8                	mov    %ebx,%eax
  80017a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80017d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800180:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800183:	7c 0b                	jl     800190 <_main+0x158>
  800185:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800188:	83 c0 02             	add    $0x2,%eax
  80018b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80018e:	7d 24                	jge    8001b4 <_main+0x17c>
			panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800190:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800193:	e8 66 31 00 00       	call   8032fe <sys_calculate_free_frames>
  800198:	29 c3                	sub    %eax,%ebx
  80019a:	89 d8                	mov    %ebx,%eax
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 cc             	pushl  -0x34(%ebp)
  8001a2:	50                   	push   %eax
  8001a3:	68 00 48 80 00       	push   $0x804800
  8001a8:	6a 2b                	push   $0x2b
  8001aa:	68 3c 46 80 00       	push   $0x80463c
  8001af:	e8 11 05 00 00       	call   8006c5 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001b4:	e8 ec 33 00 00       	call   8035a5 <rsttst>

		sys_run_env(envIdSlave1);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	ff 75 dc             	pushl  -0x24(%ebp)
  8001bf:	e8 b3 32 00 00       	call   803477 <sys_run_env>
  8001c4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cd:	e8 a5 32 00 00       	call   803477 <sys_run_env>
  8001d2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 98 48 80 00       	push   $0x804898
  8001dd:	e8 b1 07 00 00       	call   800993 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 b8 0b 00 00       	push   $0xbb8
  8001ed:	e8 ff 3f 00 00       	call   8041f1 <env_sleep>
  8001f2:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  8001f5:	90                   	nop
  8001f6:	e8 24 34 00 00       	call   80361f <gettst>
  8001fb:	83 f8 02             	cmp    $0x2,%eax
  8001fe:	75 f6                	jne    8001f6 <_main+0x1be>

		freeFrames = sys_calculate_free_frames() ;
  800200:	e8 f9 30 00 00       	call   8032fe <sys_calculate_free_frames>
  800205:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		sfree(x);
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	ff 75 d0             	pushl  -0x30(%ebp)
  80020e:	e8 af 2f 00 00       	call   8031c2 <sfree>
  800213:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	68 b0 48 80 00       	push   $0x8048b0
  80021e:	e8 70 07 00 00       	call   800993 <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
		int diff2 = (sys_calculate_free_frames() - freeFrames);
  800226:	e8 d3 30 00 00       	call   8032fe <sys_calculate_free_frames>
  80022b:	89 c2                	mov    %eax,%edx
  80022d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800230:	29 c2                	sub    %eax,%edx
  800232:	89 d0                	mov    %edx,%eax
  800234:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		expected = 1+1; /*1page+1table*/
  800237:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
		if (diff2 != expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff2, expected);
  80023e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800241:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800244:	74 1a                	je     800260 <_main+0x228>
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	ff 75 cc             	pushl  -0x34(%ebp)
  80024c:	ff 75 c4             	pushl  -0x3c(%ebp)
  80024f:	68 d0 48 80 00       	push   $0x8048d0
  800254:	6a 3e                	push   $0x3e
  800256:	68 3c 46 80 00       	push   $0x80463c
  80025b:	e8 65 04 00 00       	call   8006c5 <_panic>
	}
	cprintf("Step A is finished!!\n\n\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 17 49 80 00       	push   $0x804917
  800268:	e8 26 07 00 00       	call   800993 <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 30 49 80 00       	push   $0x804930
  800278:	e8 16 07 00 00       	call   800993 <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800280:	a1 20 60 80 00       	mov    0x806020,%eax
  800285:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80028b:	89 c2                	mov    %eax,%edx
  80028d:	a1 20 60 80 00       	mov    0x806020,%eax
  800292:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800298:	6a 32                	push   $0x32
  80029a:	52                   	push   %edx
  80029b:	50                   	push   %eax
  80029c:	68 60 49 80 00       	push   $0x804960
  8002a1:	e8 b3 31 00 00       	call   803459 <sys_create_env>
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  8002ac:	a1 20 60 80 00       	mov    0x806020,%eax
  8002b1:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8002b7:	89 c2                	mov    %eax,%edx
  8002b9:	a1 20 60 80 00       	mov    0x806020,%eax
  8002be:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002c4:	6a 32                	push   $0x32
  8002c6:	52                   	push   %edx
  8002c7:	50                   	push   %eax
  8002c8:	68 70 49 80 00       	push   $0x804970
  8002cd:	e8 87 31 00 00       	call   803459 <sys_create_env>
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	89 45 bc             	mov    %eax,-0x44(%ebp)

		z = smalloc("z", PAGE_SIZE+1, 1);
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	6a 01                	push   $0x1
  8002dd:	68 01 10 00 00       	push   $0x1001
  8002e2:	68 80 49 80 00       	push   $0x804980
  8002e7:	e8 4e 23 00 00       	call   80263a <smalloc>
  8002ec:	83 c4 10             	add    $0x10,%esp
  8002ef:	89 45 b8             	mov    %eax,-0x48(%ebp)
		cprintf("Master env created z (2 pages) \n");
  8002f2:	83 ec 0c             	sub    $0xc,%esp
  8002f5:	68 84 49 80 00       	push   $0x804984
  8002fa:	e8 94 06 00 00       	call   800993 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE+1024, 1);
  800302:	83 ec 04             	sub    $0x4,%esp
  800305:	6a 01                	push   $0x1
  800307:	68 00 14 00 00       	push   $0x1400
  80030c:	68 6f 47 80 00       	push   $0x80476f
  800311:	e8 24 23 00 00       	call   80263a <smalloc>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		cprintf("Master env created x (2 pages) \n");
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	68 a8 49 80 00       	push   $0x8049a8
  800324:	e8 6a 06 00 00       	call   800993 <cprintf>
  800329:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80032c:	e8 74 32 00 00       	call   8035a5 <rsttst>

		sys_run_env(envIdSlaveB1);
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	ff 75 c0             	pushl  -0x40(%ebp)
  800337:	e8 3b 31 00 00       	call   803477 <sys_run_env>
  80033c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 bc             	pushl  -0x44(%ebp)
  800345:	e8 2d 31 00 00       	call   803477 <sys_run_env>
  80034a:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
			//			env_sleep(4000);
			while (gettst()!=2) ;
  80034d:	90                   	nop
  80034e:	e8 cc 32 00 00       	call   80361f <gettst>
  800353:	83 f8 02             	cmp    $0x2,%eax
  800356:	75 f6                	jne    80034e <_main+0x316>
		}

		int freeFrames = sys_calculate_free_frames() ;
  800358:	e8 a1 2f 00 00       	call   8032fe <sys_calculate_free_frames>
  80035d:	89 45 b0             	mov    %eax,-0x50(%ebp)

		sfree(z);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	ff 75 b8             	pushl  -0x48(%ebp)
  800366:	e8 57 2e 00 00       	call   8031c2 <sfree>
  80036b:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	68 c9 49 80 00       	push   $0x8049c9
  800376:	e8 18 06 00 00       	call   800993 <cprintf>
  80037b:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  80037e:	83 ec 0c             	sub    $0xc,%esp
  800381:	ff 75 b4             	pushl  -0x4c(%ebp)
  800384:	e8 39 2e 00 00       	call   8031c2 <sfree>
  800389:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80038c:	83 ec 0c             	sub    $0xc,%esp
  80038f:	68 df 49 80 00       	push   $0x8049df
  800394:	e8 fa 05 00 00       	call   800993 <cprintf>
  800399:	83 c4 10             	add    $0x10,%esp

		inctst(); //finish the free's
  80039c:	e8 64 32 00 00       	call   803605 <inctst>

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003a1:	e8 58 2f 00 00       	call   8032fe <sys_calculate_free_frames>
  8003a6:	89 c2                	mov    %eax,%edx
  8003a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003ab:	29 c2                	sub    %eax,%edx
  8003ad:	89 d0                	mov    %edx,%eax
  8003af:	89 45 ac             	mov    %eax,-0x54(%ebp)
		expected = 1 /*table*/;
  8003b2:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003b9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003bc:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8003bf:	74 14                	je     8003d5 <_main+0x39d>
  8003c1:	83 ec 04             	sub    $0x4,%esp
  8003c4:	68 f8 49 80 00       	push   $0x8049f8
  8003c9:	6a 65                	push   $0x65
  8003cb:	68 3c 46 80 00       	push   $0x80463c
  8003d0:	e8 f0 02 00 00       	call   8006c5 <_panic>

		inctst();	// finish checking
  8003d5:	e8 2b 32 00 00       	call   803605 <inctst>

		//to ensure that the other environments completed successfully
		while (gettst()!=6) ;// panic("test failed");
  8003da:	90                   	nop
  8003db:	e8 3f 32 00 00       	call   80361f <gettst>
  8003e0:	83 f8 06             	cmp    $0x6,%eax
  8003e3:	75 f6                	jne    8003db <_main+0x3a3>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	6a 01                	push   $0x1
  8003ea:	6a 04                	push   $0x4
  8003ec:	68 9d 4a 80 00       	push   $0x804a9d
  8003f1:	e8 44 22 00 00       	call   80263a <smalloc>
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		*finish_children = 0;
  8003fc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		//To indicate that it create the finish_children & completed successfully
		cprintf("Master is completed.\n");
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	68 ad 4a 80 00       	push   $0x804aad
  80040d:	e8 81 05 00 00       	call   800993 <cprintf>
  800412:	83 c4 10             	add    $0x10,%esp
		inctst();
  800415:	e8 eb 31 00 00       	call   803605 <inctst>

		if (sys_getparentenvid() > 0) {
  80041a:	e8 c1 30 00 00       	call   8034e0 <sys_getparentenvid>
  80041f:	85 c0                	test   %eax,%eax
  800421:	0f 8e dc 00 00 00    	jle    800503 <_main+0x4cb>
			while(*finish_children != 1);
  800427:	90                   	nop
  800428:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	83 f8 01             	cmp    $0x1,%eax
  800430:	75 f6                	jne    800428 <_main+0x3f0>
			cprintf("done\n");
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	68 c3 4a 80 00       	push   $0x804ac3
  80043a:	e8 54 05 00 00       	call   800993 <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp

			//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
			//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
			//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
			//	2. changing the # free frames
			char changeIntCmd[100] = "__changeInterruptStatus__";
  800442:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800448:	bb d7 4a 80 00       	mov    $0x804ad7,%ebx
  80044d:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800452:	89 c7                	mov    %eax,%edi
  800454:	89 de                	mov    %ebx,%esi
  800456:	89 d1                	mov    %edx,%ecx
  800458:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80045a:	8d 95 5a ff ff ff    	lea    -0xa6(%ebp),%edx
  800460:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800465:	b0 00                	mov    $0x0,%al
  800467:	89 d7                	mov    %edx,%edi
  800469:	f3 aa                	rep stos %al,%es:(%edi)
			sys_utilities(changeIntCmd, 0);
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	6a 00                	push   $0x0
  800470:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800476:	50                   	push   %eax
  800477:	e8 81 32 00 00       	call   8036fd <sys_utilities>
  80047c:	83 c4 10             	add    $0x10,%esp
			{
				sys_destroy_env(envIdSlave1);
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	ff 75 dc             	pushl  -0x24(%ebp)
  800485:	e8 09 30 00 00       	call   803493 <sys_destroy_env>
  80048a:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlave2);
  80048d:	83 ec 0c             	sub    $0xc,%esp
  800490:	ff 75 d8             	pushl  -0x28(%ebp)
  800493:	e8 fb 2f 00 00       	call   803493 <sys_destroy_env>
  800498:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlaveB1);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a1:	e8 ed 2f 00 00       	call   803493 <sys_destroy_env>
  8004a6:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlaveB2);
  8004a9:	83 ec 0c             	sub    $0xc,%esp
  8004ac:	ff 75 bc             	pushl  -0x44(%ebp)
  8004af:	e8 df 2f 00 00       	call   803493 <sys_destroy_env>
  8004b4:	83 c4 10             	add    $0x10,%esp
			}
			sys_utilities(changeIntCmd, 1);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	6a 01                	push   $0x1
  8004bc:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8004c2:	50                   	push   %eax
  8004c3:	e8 35 32 00 00       	call   8036fd <sys_utilities>
  8004c8:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  8004cb:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  8004d2:	e8 09 30 00 00       	call   8034e0 <sys_getparentenvid>
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	68 c9 4a 80 00       	push   $0x804ac9
  8004df:	50                   	push   %eax
  8004e0:	e8 fc 26 00 00       	call   802be1 <sget>
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	89 45 a4             	mov    %eax,-0x5c(%ebp)

			//Critical section to protect the shared variable
			sys_lock_cons();
  8004eb:	e8 5e 2d 00 00       	call   80324e <sys_lock_cons>
			{
				(*finishedCount)++ ;
  8004f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004f3:	8b 00                	mov    (%eax),%eax
  8004f5:	8d 50 01             	lea    0x1(%eax),%edx
  8004f8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004fb:	89 10                	mov    %edx,(%eax)
			}
			sys_unlock_cons();
  8004fd:	e8 66 2d 00 00       	call   803268 <sys_unlock_cons>
		}
	}


	return;
  800502:	90                   	nop
  800503:	90                   	nop
}
  800504:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800507:	5b                   	pop    %ebx
  800508:	5e                   	pop    %esi
  800509:	5f                   	pop    %edi
  80050a:	5d                   	pop    %ebp
  80050b:	c3                   	ret    

0080050c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	57                   	push   %edi
  800510:	56                   	push   %esi
  800511:	53                   	push   %ebx
  800512:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800515:	e8 ad 2f 00 00       	call   8034c7 <sys_getenvindex>
  80051a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80051d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800520:	89 d0                	mov    %edx,%eax
  800522:	c1 e0 02             	shl    $0x2,%eax
  800525:	01 d0                	add    %edx,%eax
  800527:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052e:	01 d0                	add    %edx,%eax
  800530:	89 c2                	mov    %eax,%edx
  800532:	c1 e2 04             	shl    $0x4,%edx
  800535:	29 c2                	sub    %eax,%edx
  800537:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80053e:	89 c2                	mov    %eax,%edx
  800540:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800546:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80054b:	a1 20 60 80 00       	mov    0x806020,%eax
  800550:	8a 40 20             	mov    0x20(%eax),%al
  800553:	84 c0                	test   %al,%al
  800555:	74 0d                	je     800564 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800557:	a1 20 60 80 00       	mov    0x806020,%eax
  80055c:	83 c0 20             	add    $0x20,%eax
  80055f:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800564:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800568:	7e 0a                	jle    800574 <libmain+0x68>
		binaryname = argv[0];
  80056a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 0c             	pushl  0xc(%ebp)
  80057a:	ff 75 08             	pushl  0x8(%ebp)
  80057d:	e8 b6 fa ff ff       	call   800038 <_main>
  800582:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800585:	a1 00 60 80 00       	mov    0x806000,%eax
  80058a:	85 c0                	test   %eax,%eax
  80058c:	0f 84 01 01 00 00    	je     800693 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800592:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800598:	bb 34 4c 80 00       	mov    $0x804c34,%ebx
  80059d:	ba 0e 00 00 00       	mov    $0xe,%edx
  8005a2:	89 c7                	mov    %eax,%edi
  8005a4:	89 de                	mov    %ebx,%esi
  8005a6:	89 d1                	mov    %edx,%ecx
  8005a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005aa:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8005ad:	b9 56 00 00 00       	mov    $0x56,%ecx
  8005b2:	b0 00                	mov    $0x0,%al
  8005b4:	89 d7                	mov    %edx,%edi
  8005b6:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8005b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8005bf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	50                   	push   %eax
  8005c6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8005cc:	50                   	push   %eax
  8005cd:	e8 2b 31 00 00       	call   8036fd <sys_utilities>
  8005d2:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8005d5:	e8 74 2c 00 00       	call   80324e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8005da:	83 ec 0c             	sub    $0xc,%esp
  8005dd:	68 54 4b 80 00       	push   $0x804b54
  8005e2:	e8 ac 03 00 00       	call   800993 <cprintf>
  8005e7:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8005ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ed:	85 c0                	test   %eax,%eax
  8005ef:	74 18                	je     800609 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8005f1:	e8 25 31 00 00       	call   80371b <sys_get_optimal_num_faults>
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	50                   	push   %eax
  8005fa:	68 7c 4b 80 00       	push   $0x804b7c
  8005ff:	e8 8f 03 00 00       	call   800993 <cprintf>
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	eb 59                	jmp    800662 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800609:	a1 20 60 80 00       	mov    0x806020,%eax
  80060e:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800614:	a1 20 60 80 00       	mov    0x806020,%eax
  800619:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80061f:	83 ec 04             	sub    $0x4,%esp
  800622:	52                   	push   %edx
  800623:	50                   	push   %eax
  800624:	68 a0 4b 80 00       	push   $0x804ba0
  800629:	e8 65 03 00 00       	call   800993 <cprintf>
  80062e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800631:	a1 20 60 80 00       	mov    0x806020,%eax
  800636:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80063c:	a1 20 60 80 00       	mov    0x806020,%eax
  800641:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800647:	a1 20 60 80 00       	mov    0x806020,%eax
  80064c:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800652:	51                   	push   %ecx
  800653:	52                   	push   %edx
  800654:	50                   	push   %eax
  800655:	68 c8 4b 80 00       	push   $0x804bc8
  80065a:	e8 34 03 00 00       	call   800993 <cprintf>
  80065f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800662:	a1 20 60 80 00       	mov    0x806020,%eax
  800667:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	50                   	push   %eax
  800671:	68 20 4c 80 00       	push   $0x804c20
  800676:	e8 18 03 00 00       	call   800993 <cprintf>
  80067b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80067e:	83 ec 0c             	sub    $0xc,%esp
  800681:	68 54 4b 80 00       	push   $0x804b54
  800686:	e8 08 03 00 00       	call   800993 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80068e:	e8 d5 2b 00 00       	call   803268 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800693:	e8 1f 00 00 00       	call   8006b7 <exit>
}
  800698:	90                   	nop
  800699:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80069c:	5b                   	pop    %ebx
  80069d:	5e                   	pop    %esi
  80069e:	5f                   	pop    %edi
  80069f:	5d                   	pop    %ebp
  8006a0:	c3                   	ret    

008006a1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006a7:	83 ec 0c             	sub    $0xc,%esp
  8006aa:	6a 00                	push   $0x0
  8006ac:	e8 e2 2d 00 00       	call   803493 <sys_destroy_env>
  8006b1:	83 c4 10             	add    $0x10,%esp
}
  8006b4:	90                   	nop
  8006b5:	c9                   	leave  
  8006b6:	c3                   	ret    

008006b7 <exit>:

void
exit(void)
{
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
  8006ba:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006bd:	e8 37 2e 00 00       	call   8034f9 <sys_exit_env>
}
  8006c2:	90                   	nop
  8006c3:	c9                   	leave  
  8006c4:	c3                   	ret    

008006c5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006c5:	55                   	push   %ebp
  8006c6:	89 e5                	mov    %esp,%ebp
  8006c8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006cb:	8d 45 10             	lea    0x10(%ebp),%eax
  8006ce:	83 c0 04             	add    $0x4,%eax
  8006d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006d4:	a1 18 e1 81 00       	mov    0x81e118,%eax
  8006d9:	85 c0                	test   %eax,%eax
  8006db:	74 16                	je     8006f3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006dd:	a1 18 e1 81 00       	mov    0x81e118,%eax
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	50                   	push   %eax
  8006e6:	68 98 4c 80 00       	push   $0x804c98
  8006eb:	e8 a3 02 00 00       	call   800993 <cprintf>
  8006f0:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8006f3:	a1 04 60 80 00       	mov    0x806004,%eax
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	ff 75 08             	pushl  0x8(%ebp)
  800701:	50                   	push   %eax
  800702:	68 a0 4c 80 00       	push   $0x804ca0
  800707:	6a 74                	push   $0x74
  800709:	e8 b2 02 00 00       	call   8009c0 <cprintf_colored>
  80070e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800711:	8b 45 10             	mov    0x10(%ebp),%eax
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	ff 75 f4             	pushl  -0xc(%ebp)
  80071a:	50                   	push   %eax
  80071b:	e8 04 02 00 00       	call   800924 <vcprintf>
  800720:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	6a 00                	push   $0x0
  800728:	68 c8 4c 80 00       	push   $0x804cc8
  80072d:	e8 f2 01 00 00       	call   800924 <vcprintf>
  800732:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800735:	e8 7d ff ff ff       	call   8006b7 <exit>

	// should not return here
	while (1) ;
  80073a:	eb fe                	jmp    80073a <_panic+0x75>

0080073c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800742:	a1 20 60 80 00       	mov    0x806020,%eax
  800747:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80074d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800750:	39 c2                	cmp    %eax,%edx
  800752:	74 14                	je     800768 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800754:	83 ec 04             	sub    $0x4,%esp
  800757:	68 cc 4c 80 00       	push   $0x804ccc
  80075c:	6a 26                	push   $0x26
  80075e:	68 18 4d 80 00       	push   $0x804d18
  800763:	e8 5d ff ff ff       	call   8006c5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800768:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80076f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800776:	e9 c5 00 00 00       	jmp    800840 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80077b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	01 d0                	add    %edx,%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	85 c0                	test   %eax,%eax
  80078e:	75 08                	jne    800798 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800790:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800793:	e9 a5 00 00 00       	jmp    80083d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800798:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80079f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007a6:	eb 69                	jmp    800811 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007a8:	a1 20 60 80 00       	mov    0x806020,%eax
  8007ad:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8007b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b6:	89 d0                	mov    %edx,%eax
  8007b8:	01 c0                	add    %eax,%eax
  8007ba:	01 d0                	add    %edx,%eax
  8007bc:	c1 e0 03             	shl    $0x3,%eax
  8007bf:	01 c8                	add    %ecx,%eax
  8007c1:	8a 40 04             	mov    0x4(%eax),%al
  8007c4:	84 c0                	test   %al,%al
  8007c6:	75 46                	jne    80080e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007c8:	a1 20 60 80 00       	mov    0x806020,%eax
  8007cd:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8007d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	c1 e0 03             	shl    $0x3,%eax
  8007df:	01 c8                	add    %ecx,%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007ee:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	01 c8                	add    %ecx,%eax
  8007ff:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800801:	39 c2                	cmp    %eax,%edx
  800803:	75 09                	jne    80080e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800805:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80080c:	eb 15                	jmp    800823 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80080e:	ff 45 e8             	incl   -0x18(%ebp)
  800811:	a1 20 60 80 00       	mov    0x806020,%eax
  800816:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80081c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081f:	39 c2                	cmp    %eax,%edx
  800821:	77 85                	ja     8007a8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800823:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800827:	75 14                	jne    80083d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800829:	83 ec 04             	sub    $0x4,%esp
  80082c:	68 24 4d 80 00       	push   $0x804d24
  800831:	6a 3a                	push   $0x3a
  800833:	68 18 4d 80 00       	push   $0x804d18
  800838:	e8 88 fe ff ff       	call   8006c5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80083d:	ff 45 f0             	incl   -0x10(%ebp)
  800840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800843:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800846:	0f 8c 2f ff ff ff    	jl     80077b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80084c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800853:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80085a:	eb 26                	jmp    800882 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80085c:	a1 20 60 80 00       	mov    0x806020,%eax
  800861:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800867:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80086a:	89 d0                	mov    %edx,%eax
  80086c:	01 c0                	add    %eax,%eax
  80086e:	01 d0                	add    %edx,%eax
  800870:	c1 e0 03             	shl    $0x3,%eax
  800873:	01 c8                	add    %ecx,%eax
  800875:	8a 40 04             	mov    0x4(%eax),%al
  800878:	3c 01                	cmp    $0x1,%al
  80087a:	75 03                	jne    80087f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80087c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80087f:	ff 45 e0             	incl   -0x20(%ebp)
  800882:	a1 20 60 80 00       	mov    0x806020,%eax
  800887:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80088d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800890:	39 c2                	cmp    %eax,%edx
  800892:	77 c8                	ja     80085c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800897:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80089a:	74 14                	je     8008b0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80089c:	83 ec 04             	sub    $0x4,%esp
  80089f:	68 78 4d 80 00       	push   $0x804d78
  8008a4:	6a 44                	push   $0x44
  8008a6:	68 18 4d 80 00       	push   $0x804d18
  8008ab:	e8 15 fe ff ff       	call   8006c5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008b0:	90                   	nop
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	53                   	push   %ebx
  8008b7:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8008ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	8d 48 01             	lea    0x1(%eax),%ecx
  8008c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c5:	89 0a                	mov    %ecx,(%edx)
  8008c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ca:	88 d1                	mov    %dl,%cl
  8008cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cf:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d6:	8b 00                	mov    (%eax),%eax
  8008d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008dd:	75 30                	jne    80090f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8008df:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  8008e5:	a0 44 60 80 00       	mov    0x806044,%al
  8008ea:	0f b6 c0             	movzbl %al,%eax
  8008ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f0:	8b 09                	mov    (%ecx),%ecx
  8008f2:	89 cb                	mov    %ecx,%ebx
  8008f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f7:	83 c1 08             	add    $0x8,%ecx
  8008fa:	52                   	push   %edx
  8008fb:	50                   	push   %eax
  8008fc:	53                   	push   %ebx
  8008fd:	51                   	push   %ecx
  8008fe:	e8 07 29 00 00       	call   80320a <sys_cputs>
  800903:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800906:	8b 45 0c             	mov    0xc(%ebp),%eax
  800909:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	8b 40 04             	mov    0x4(%eax),%eax
  800915:	8d 50 01             	lea    0x1(%eax),%edx
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80091e:	90                   	nop
  80091f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800922:	c9                   	leave  
  800923:	c3                   	ret    

00800924 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80092d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800934:	00 00 00 
	b.cnt = 0;
  800937:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80093e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	ff 75 08             	pushl  0x8(%ebp)
  800947:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80094d:	50                   	push   %eax
  80094e:	68 b3 08 80 00       	push   $0x8008b3
  800953:	e8 5a 02 00 00       	call   800bb2 <vprintfmt>
  800958:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80095b:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800961:	a0 44 60 80 00       	mov    0x806044,%al
  800966:	0f b6 c0             	movzbl %al,%eax
  800969:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80096f:	52                   	push   %edx
  800970:	50                   	push   %eax
  800971:	51                   	push   %ecx
  800972:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800978:	83 c0 08             	add    $0x8,%eax
  80097b:	50                   	push   %eax
  80097c:	e8 89 28 00 00       	call   80320a <sys_cputs>
  800981:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800984:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  80098b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800999:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  8009a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	e8 6f ff ff ff       	call   800924 <vcprintf>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009be:	c9                   	leave  
  8009bf:	c3                   	ret    

008009c0 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009c6:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	c1 e0 08             	shl    $0x8,%eax
  8009d3:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  8009d8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009db:	83 c0 04             	add    $0x4,%eax
  8009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ea:	50                   	push   %eax
  8009eb:	e8 34 ff ff ff       	call   800924 <vcprintf>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8009f6:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  8009fd:	07 00 00 

	return cnt;
  800a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a0b:	e8 3e 28 00 00       	call   80324e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a10:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1f:	50                   	push   %eax
  800a20:	e8 ff fe ff ff       	call   800924 <vcprintf>
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a2b:	e8 38 28 00 00       	call   803268 <sys_unlock_cons>
	return cnt;
  800a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	53                   	push   %ebx
  800a39:	83 ec 14             	sub    $0x14,%esp
  800a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a42:	8b 45 14             	mov    0x14(%ebp),%eax
  800a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a48:	8b 45 18             	mov    0x18(%ebp),%eax
  800a4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a50:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a53:	77 55                	ja     800aaa <printnum+0x75>
  800a55:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a58:	72 05                	jb     800a5f <printnum+0x2a>
  800a5a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a5d:	77 4b                	ja     800aaa <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a5f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a62:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a65:	8b 45 18             	mov    0x18(%ebp),%eax
  800a68:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6d:	52                   	push   %edx
  800a6e:	50                   	push   %eax
  800a6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a72:	ff 75 f0             	pushl  -0x10(%ebp)
  800a75:	e8 3e 39 00 00       	call   8043b8 <__udivdi3>
  800a7a:	83 c4 10             	add    $0x10,%esp
  800a7d:	83 ec 04             	sub    $0x4,%esp
  800a80:	ff 75 20             	pushl  0x20(%ebp)
  800a83:	53                   	push   %ebx
  800a84:	ff 75 18             	pushl  0x18(%ebp)
  800a87:	52                   	push   %edx
  800a88:	50                   	push   %eax
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	ff 75 08             	pushl  0x8(%ebp)
  800a8f:	e8 a1 ff ff ff       	call   800a35 <printnum>
  800a94:	83 c4 20             	add    $0x20,%esp
  800a97:	eb 1a                	jmp    800ab3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a99:	83 ec 08             	sub    $0x8,%esp
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	ff 75 20             	pushl  0x20(%ebp)
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aaa:	ff 4d 1c             	decl   0x1c(%ebp)
  800aad:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ab1:	7f e6                	jg     800a99 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ab3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac1:	53                   	push   %ebx
  800ac2:	51                   	push   %ecx
  800ac3:	52                   	push   %edx
  800ac4:	50                   	push   %eax
  800ac5:	e8 fe 39 00 00       	call   8044c8 <__umoddi3>
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	05 f4 4f 80 00       	add    $0x804ff4,%eax
  800ad2:	8a 00                	mov    (%eax),%al
  800ad4:	0f be c0             	movsbl %al,%eax
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	50                   	push   %eax
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	ff d0                	call   *%eax
  800ae3:	83 c4 10             	add    $0x10,%esp
}
  800ae6:	90                   	nop
  800ae7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800af3:	7e 1c                	jle    800b11 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8b 00                	mov    (%eax),%eax
  800afa:	8d 50 08             	lea    0x8(%eax),%edx
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	89 10                	mov    %edx,(%eax)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8b 00                	mov    (%eax),%eax
  800b07:	83 e8 08             	sub    $0x8,%eax
  800b0a:	8b 50 04             	mov    0x4(%eax),%edx
  800b0d:	8b 00                	mov    (%eax),%eax
  800b0f:	eb 40                	jmp    800b51 <getuint+0x65>
	else if (lflag)
  800b11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b15:	74 1e                	je     800b35 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8b 00                	mov    (%eax),%eax
  800b1c:	8d 50 04             	lea    0x4(%eax),%edx
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	89 10                	mov    %edx,(%eax)
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8b 00                	mov    (%eax),%eax
  800b29:	83 e8 04             	sub    $0x4,%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b33:	eb 1c                	jmp    800b51 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	8b 00                	mov    (%eax),%eax
  800b3a:	8d 50 04             	lea    0x4(%eax),%edx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	89 10                	mov    %edx,(%eax)
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	8b 00                	mov    (%eax),%eax
  800b47:	83 e8 04             	sub    $0x4,%eax
  800b4a:	8b 00                	mov    (%eax),%eax
  800b4c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b56:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b5a:	7e 1c                	jle    800b78 <getint+0x25>
		return va_arg(*ap, long long);
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 50 08             	lea    0x8(%eax),%edx
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	89 10                	mov    %edx,(%eax)
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 00                	mov    (%eax),%eax
  800b6e:	83 e8 08             	sub    $0x8,%eax
  800b71:	8b 50 04             	mov    0x4(%eax),%edx
  800b74:	8b 00                	mov    (%eax),%eax
  800b76:	eb 38                	jmp    800bb0 <getint+0x5d>
	else if (lflag)
  800b78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7c:	74 1a                	je     800b98 <getint+0x45>
		return va_arg(*ap, long);
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	8b 00                	mov    (%eax),%eax
  800b83:	8d 50 04             	lea    0x4(%eax),%edx
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	89 10                	mov    %edx,(%eax)
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	83 e8 04             	sub    $0x4,%eax
  800b93:	8b 00                	mov    (%eax),%eax
  800b95:	99                   	cltd   
  800b96:	eb 18                	jmp    800bb0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8b 00                	mov    (%eax),%eax
  800b9d:	8d 50 04             	lea    0x4(%eax),%edx
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 10                	mov    %edx,(%eax)
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8b 00                	mov    (%eax),%eax
  800baa:	83 e8 04             	sub    $0x4,%eax
  800bad:	8b 00                	mov    (%eax),%eax
  800baf:	99                   	cltd   
}
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	56                   	push   %esi
  800bb6:	53                   	push   %ebx
  800bb7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bba:	eb 17                	jmp    800bd3 <vprintfmt+0x21>
			if (ch == '\0')
  800bbc:	85 db                	test   %ebx,%ebx
  800bbe:	0f 84 c1 03 00 00    	je     800f85 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	53                   	push   %ebx
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	ff d0                	call   *%eax
  800bd0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd6:	8d 50 01             	lea    0x1(%eax),%edx
  800bd9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bdc:	8a 00                	mov    (%eax),%al
  800bde:	0f b6 d8             	movzbl %al,%ebx
  800be1:	83 fb 25             	cmp    $0x25,%ebx
  800be4:	75 d6                	jne    800bbc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bea:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bf1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bf8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bff:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c06:	8b 45 10             	mov    0x10(%ebp),%eax
  800c09:	8d 50 01             	lea    0x1(%eax),%edx
  800c0c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c0f:	8a 00                	mov    (%eax),%al
  800c11:	0f b6 d8             	movzbl %al,%ebx
  800c14:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c17:	83 f8 5b             	cmp    $0x5b,%eax
  800c1a:	0f 87 3d 03 00 00    	ja     800f5d <vprintfmt+0x3ab>
  800c20:	8b 04 85 18 50 80 00 	mov    0x805018(,%eax,4),%eax
  800c27:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c29:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c2d:	eb d7                	jmp    800c06 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c2f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c33:	eb d1                	jmp    800c06 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c35:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c3f:	89 d0                	mov    %edx,%eax
  800c41:	c1 e0 02             	shl    $0x2,%eax
  800c44:	01 d0                	add    %edx,%eax
  800c46:	01 c0                	add    %eax,%eax
  800c48:	01 d8                	add    %ebx,%eax
  800c4a:	83 e8 30             	sub    $0x30,%eax
  800c4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c50:	8b 45 10             	mov    0x10(%ebp),%eax
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c58:	83 fb 2f             	cmp    $0x2f,%ebx
  800c5b:	7e 3e                	jle    800c9b <vprintfmt+0xe9>
  800c5d:	83 fb 39             	cmp    $0x39,%ebx
  800c60:	7f 39                	jg     800c9b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c62:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c65:	eb d5                	jmp    800c3c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c67:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6a:	83 c0 04             	add    $0x4,%eax
  800c6d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c70:	8b 45 14             	mov    0x14(%ebp),%eax
  800c73:	83 e8 04             	sub    $0x4,%eax
  800c76:	8b 00                	mov    (%eax),%eax
  800c78:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c7b:	eb 1f                	jmp    800c9c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c81:	79 83                	jns    800c06 <vprintfmt+0x54>
				width = 0;
  800c83:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c8a:	e9 77 ff ff ff       	jmp    800c06 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c8f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c96:	e9 6b ff ff ff       	jmp    800c06 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c9b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca0:	0f 89 60 ff ff ff    	jns    800c06 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cb3:	e9 4e ff ff ff       	jmp    800c06 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cb8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cbb:	e9 46 ff ff ff       	jmp    800c06 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	83 c0 04             	add    $0x4,%eax
  800cc6:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccc:	83 e8 04             	sub    $0x4,%eax
  800ccf:	8b 00                	mov    (%eax),%eax
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	50                   	push   %eax
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	ff d0                	call   *%eax
  800cdd:	83 c4 10             	add    $0x10,%esp
			break;
  800ce0:	e9 9b 02 00 00       	jmp    800f80 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	83 c0 04             	add    $0x4,%eax
  800ceb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cee:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf1:	83 e8 04             	sub    $0x4,%eax
  800cf4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf6:	85 db                	test   %ebx,%ebx
  800cf8:	79 02                	jns    800cfc <vprintfmt+0x14a>
				err = -err;
  800cfa:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cfc:	83 fb 64             	cmp    $0x64,%ebx
  800cff:	7f 0b                	jg     800d0c <vprintfmt+0x15a>
  800d01:	8b 34 9d 60 4e 80 00 	mov    0x804e60(,%ebx,4),%esi
  800d08:	85 f6                	test   %esi,%esi
  800d0a:	75 19                	jne    800d25 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d0c:	53                   	push   %ebx
  800d0d:	68 05 50 80 00       	push   $0x805005
  800d12:	ff 75 0c             	pushl  0xc(%ebp)
  800d15:	ff 75 08             	pushl  0x8(%ebp)
  800d18:	e8 70 02 00 00       	call   800f8d <printfmt>
  800d1d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d20:	e9 5b 02 00 00       	jmp    800f80 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d25:	56                   	push   %esi
  800d26:	68 0e 50 80 00       	push   $0x80500e
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	ff 75 08             	pushl  0x8(%ebp)
  800d31:	e8 57 02 00 00       	call   800f8d <printfmt>
  800d36:	83 c4 10             	add    $0x10,%esp
			break;
  800d39:	e9 42 02 00 00       	jmp    800f80 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d41:	83 c0 04             	add    $0x4,%eax
  800d44:	89 45 14             	mov    %eax,0x14(%ebp)
  800d47:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4a:	83 e8 04             	sub    $0x4,%eax
  800d4d:	8b 30                	mov    (%eax),%esi
  800d4f:	85 f6                	test   %esi,%esi
  800d51:	75 05                	jne    800d58 <vprintfmt+0x1a6>
				p = "(null)";
  800d53:	be 11 50 80 00       	mov    $0x805011,%esi
			if (width > 0 && padc != '-')
  800d58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5c:	7e 6d                	jle    800dcb <vprintfmt+0x219>
  800d5e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d62:	74 67                	je     800dcb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d67:	83 ec 08             	sub    $0x8,%esp
  800d6a:	50                   	push   %eax
  800d6b:	56                   	push   %esi
  800d6c:	e8 1e 03 00 00       	call   80108f <strnlen>
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d77:	eb 16                	jmp    800d8f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d79:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d7d:	83 ec 08             	sub    $0x8,%esp
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	50                   	push   %eax
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	ff d0                	call   *%eax
  800d89:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8c:	ff 4d e4             	decl   -0x1c(%ebp)
  800d8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d93:	7f e4                	jg     800d79 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d95:	eb 34                	jmp    800dcb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d97:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d9b:	74 1c                	je     800db9 <vprintfmt+0x207>
  800d9d:	83 fb 1f             	cmp    $0x1f,%ebx
  800da0:	7e 05                	jle    800da7 <vprintfmt+0x1f5>
  800da2:	83 fb 7e             	cmp    $0x7e,%ebx
  800da5:	7e 12                	jle    800db9 <vprintfmt+0x207>
					putch('?', putdat);
  800da7:	83 ec 08             	sub    $0x8,%esp
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	6a 3f                	push   $0x3f
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	ff d0                	call   *%eax
  800db4:	83 c4 10             	add    $0x10,%esp
  800db7:	eb 0f                	jmp    800dc8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	53                   	push   %ebx
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	ff d0                	call   *%eax
  800dc5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcb:	89 f0                	mov    %esi,%eax
  800dcd:	8d 70 01             	lea    0x1(%eax),%esi
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	0f be d8             	movsbl %al,%ebx
  800dd5:	85 db                	test   %ebx,%ebx
  800dd7:	74 24                	je     800dfd <vprintfmt+0x24b>
  800dd9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ddd:	78 b8                	js     800d97 <vprintfmt+0x1e5>
  800ddf:	ff 4d e0             	decl   -0x20(%ebp)
  800de2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de6:	79 af                	jns    800d97 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de8:	eb 13                	jmp    800dfd <vprintfmt+0x24b>
				putch(' ', putdat);
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	6a 20                	push   $0x20
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	ff d0                	call   *%eax
  800df7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dfa:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e01:	7f e7                	jg     800dea <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e03:	e9 78 01 00 00       	jmp    800f80 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e08:	83 ec 08             	sub    $0x8,%esp
  800e0b:	ff 75 e8             	pushl  -0x18(%ebp)
  800e0e:	8d 45 14             	lea    0x14(%ebp),%eax
  800e11:	50                   	push   %eax
  800e12:	e8 3c fd ff ff       	call   800b53 <getint>
  800e17:	83 c4 10             	add    $0x10,%esp
  800e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e26:	85 d2                	test   %edx,%edx
  800e28:	79 23                	jns    800e4d <vprintfmt+0x29b>
				putch('-', putdat);
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	6a 2d                	push   $0x2d
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	ff d0                	call   *%eax
  800e37:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e40:	f7 d8                	neg    %eax
  800e42:	83 d2 00             	adc    $0x0,%edx
  800e45:	f7 da                	neg    %edx
  800e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e4d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e54:	e9 bc 00 00 00       	jmp    800f15 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e59:	83 ec 08             	sub    $0x8,%esp
  800e5c:	ff 75 e8             	pushl  -0x18(%ebp)
  800e5f:	8d 45 14             	lea    0x14(%ebp),%eax
  800e62:	50                   	push   %eax
  800e63:	e8 84 fc ff ff       	call   800aec <getuint>
  800e68:	83 c4 10             	add    $0x10,%esp
  800e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e71:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e78:	e9 98 00 00 00       	jmp    800f15 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	ff 75 0c             	pushl  0xc(%ebp)
  800e83:	6a 58                	push   $0x58
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	ff d0                	call   *%eax
  800e8a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e8d:	83 ec 08             	sub    $0x8,%esp
  800e90:	ff 75 0c             	pushl  0xc(%ebp)
  800e93:	6a 58                	push   $0x58
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	ff d0                	call   *%eax
  800e9a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	6a 58                	push   $0x58
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	ff d0                	call   *%eax
  800eaa:	83 c4 10             	add    $0x10,%esp
			break;
  800ead:	e9 ce 00 00 00       	jmp    800f80 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	6a 30                	push   $0x30
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 78                	push   $0x78
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ed2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed5:	83 c0 04             	add    $0x4,%eax
  800ed8:	89 45 14             	mov    %eax,0x14(%ebp)
  800edb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ede:	83 e8 04             	sub    $0x4,%eax
  800ee1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eed:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ef4:	eb 1f                	jmp    800f15 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 e8             	pushl  -0x18(%ebp)
  800efc:	8d 45 14             	lea    0x14(%ebp),%eax
  800eff:	50                   	push   %eax
  800f00:	e8 e7 fb ff ff       	call   800aec <getuint>
  800f05:	83 c4 10             	add    $0x10,%esp
  800f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f0e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f15:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f1c:	83 ec 04             	sub    $0x4,%esp
  800f1f:	52                   	push   %edx
  800f20:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f23:	50                   	push   %eax
  800f24:	ff 75 f4             	pushl  -0xc(%ebp)
  800f27:	ff 75 f0             	pushl  -0x10(%ebp)
  800f2a:	ff 75 0c             	pushl  0xc(%ebp)
  800f2d:	ff 75 08             	pushl  0x8(%ebp)
  800f30:	e8 00 fb ff ff       	call   800a35 <printnum>
  800f35:	83 c4 20             	add    $0x20,%esp
			break;
  800f38:	eb 46                	jmp    800f80 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f3a:	83 ec 08             	sub    $0x8,%esp
  800f3d:	ff 75 0c             	pushl  0xc(%ebp)
  800f40:	53                   	push   %ebx
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			break;
  800f49:	eb 35                	jmp    800f80 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f4b:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  800f52:	eb 2c                	jmp    800f80 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f54:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  800f5b:	eb 23                	jmp    800f80 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f5d:	83 ec 08             	sub    $0x8,%esp
  800f60:	ff 75 0c             	pushl  0xc(%ebp)
  800f63:	6a 25                	push   $0x25
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	ff d0                	call   *%eax
  800f6a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f6d:	ff 4d 10             	decl   0x10(%ebp)
  800f70:	eb 03                	jmp    800f75 <vprintfmt+0x3c3>
  800f72:	ff 4d 10             	decl   0x10(%ebp)
  800f75:	8b 45 10             	mov    0x10(%ebp),%eax
  800f78:	48                   	dec    %eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	3c 25                	cmp    $0x25,%al
  800f7d:	75 f3                	jne    800f72 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800f7f:	90                   	nop
		}
	}
  800f80:	e9 35 fc ff ff       	jmp    800bba <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f85:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    

00800f8d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f93:	8d 45 10             	lea    0x10(%ebp),%eax
  800f96:	83 c0 04             	add    $0x4,%eax
  800f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9f:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa2:	50                   	push   %eax
  800fa3:	ff 75 0c             	pushl  0xc(%ebp)
  800fa6:	ff 75 08             	pushl  0x8(%ebp)
  800fa9:	e8 04 fc ff ff       	call   800bb2 <vprintfmt>
  800fae:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fb1:	90                   	nop
  800fb2:	c9                   	leave  
  800fb3:	c3                   	ret    

00800fb4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	8b 40 08             	mov    0x8(%eax),%eax
  800fbd:	8d 50 01             	lea    0x1(%eax),%edx
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	8b 10                	mov    (%eax),%edx
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	8b 40 04             	mov    0x4(%eax),%eax
  800fd1:	39 c2                	cmp    %eax,%edx
  800fd3:	73 12                	jae    800fe7 <sprintputch+0x33>
		*b->buf++ = ch;
  800fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd8:	8b 00                	mov    (%eax),%eax
  800fda:	8d 48 01             	lea    0x1(%eax),%ecx
  800fdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe0:	89 0a                	mov    %ecx,(%edx)
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	88 10                	mov    %dl,(%eax)
}
  800fe7:	90                   	nop
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    

00800fea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	01 d0                	add    %edx,%eax
  801001:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801004:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80100b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100f:	74 06                	je     801017 <vsnprintf+0x2d>
  801011:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801015:	7f 07                	jg     80101e <vsnprintf+0x34>
		return -E_INVAL;
  801017:	b8 03 00 00 00       	mov    $0x3,%eax
  80101c:	eb 20                	jmp    80103e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80101e:	ff 75 14             	pushl  0x14(%ebp)
  801021:	ff 75 10             	pushl  0x10(%ebp)
  801024:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801027:	50                   	push   %eax
  801028:	68 b4 0f 80 00       	push   $0x800fb4
  80102d:	e8 80 fb ff ff       	call   800bb2 <vprintfmt>
  801032:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801035:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801038:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80103b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801046:	8d 45 10             	lea    0x10(%ebp),%eax
  801049:	83 c0 04             	add    $0x4,%eax
  80104c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80104f:	8b 45 10             	mov    0x10(%ebp),%eax
  801052:	ff 75 f4             	pushl  -0xc(%ebp)
  801055:	50                   	push   %eax
  801056:	ff 75 0c             	pushl  0xc(%ebp)
  801059:	ff 75 08             	pushl  0x8(%ebp)
  80105c:	e8 89 ff ff ff       	call   800fea <vsnprintf>
  801061:	83 c4 10             	add    $0x10,%esp
  801064:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801067:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801079:	eb 06                	jmp    801081 <strlen+0x15>
		n++;
  80107b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80107e:	ff 45 08             	incl   0x8(%ebp)
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8a 00                	mov    (%eax),%al
  801086:	84 c0                	test   %al,%al
  801088:	75 f1                	jne    80107b <strlen+0xf>
		n++;
	return n;
  80108a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109c:	eb 09                	jmp    8010a7 <strnlen+0x18>
		n++;
  80109e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010a1:	ff 45 08             	incl   0x8(%ebp)
  8010a4:	ff 4d 0c             	decl   0xc(%ebp)
  8010a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ab:	74 09                	je     8010b6 <strnlen+0x27>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	84 c0                	test   %al,%al
  8010b4:	75 e8                	jne    80109e <strnlen+0xf>
		n++;
	return n;
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    

008010bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010c7:	90                   	nop
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ce:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010da:	8a 12                	mov    (%edx),%dl
  8010dc:	88 10                	mov    %dl,(%eax)
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	84 c0                	test   %al,%al
  8010e2:	75 e4                	jne    8010c8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010e7:	c9                   	leave  
  8010e8:	c3                   	ret    

008010e9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010fc:	eb 1f                	jmp    80111d <strncpy+0x34>
		*dst++ = *src;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8d 50 01             	lea    0x1(%eax),%edx
  801104:	89 55 08             	mov    %edx,0x8(%ebp)
  801107:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110a:	8a 12                	mov    (%edx),%dl
  80110c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	84 c0                	test   %al,%al
  801115:	74 03                	je     80111a <strncpy+0x31>
			src++;
  801117:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801120:	3b 45 10             	cmp    0x10(%ebp),%eax
  801123:	72 d9                	jb     8010fe <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801125:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801136:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113a:	74 30                	je     80116c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80113c:	eb 16                	jmp    801154 <strlcpy+0x2a>
			*dst++ = *src++;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8d 50 01             	lea    0x1(%eax),%edx
  801144:	89 55 08             	mov    %edx,0x8(%ebp)
  801147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80114d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801150:	8a 12                	mov    (%edx),%dl
  801152:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801154:	ff 4d 10             	decl   0x10(%ebp)
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	74 09                	je     801166 <strlcpy+0x3c>
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	75 d8                	jne    80113e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80116c:	8b 55 08             	mov    0x8(%ebp),%edx
  80116f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801172:	29 c2                	sub    %eax,%edx
  801174:	89 d0                	mov    %edx,%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80117b:	eb 06                	jmp    801183 <strcmp+0xb>
		p++, q++;
  80117d:	ff 45 08             	incl   0x8(%ebp)
  801180:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	84 c0                	test   %al,%al
  80118a:	74 0e                	je     80119a <strcmp+0x22>
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 10                	mov    (%eax),%dl
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	38 c2                	cmp    %al,%dl
  801198:	74 e3                	je     80117d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	0f b6 d0             	movzbl %al,%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	0f b6 c0             	movzbl %al,%eax
  8011aa:	29 c2                	sub    %eax,%edx
  8011ac:	89 d0                	mov    %edx,%eax
}
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011b3:	eb 09                	jmp    8011be <strncmp+0xe>
		n--, p++, q++;
  8011b5:	ff 4d 10             	decl   0x10(%ebp)
  8011b8:	ff 45 08             	incl   0x8(%ebp)
  8011bb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c2:	74 17                	je     8011db <strncmp+0x2b>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	84 c0                	test   %al,%al
  8011cb:	74 0e                	je     8011db <strncmp+0x2b>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	8a 10                	mov    (%eax),%dl
  8011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	38 c2                	cmp    %al,%dl
  8011d9:	74 da                	je     8011b5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011df:	75 07                	jne    8011e8 <strncmp+0x38>
		return 0;
  8011e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e6:	eb 14                	jmp    8011fc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	0f b6 d0             	movzbl %al,%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	0f b6 c0             	movzbl %al,%eax
  8011f8:	29 c2                	sub    %eax,%edx
  8011fa:	89 d0                	mov    %edx,%eax
}
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    

008011fe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 04             	sub    $0x4,%esp
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80120a:	eb 12                	jmp    80121e <strchr+0x20>
		if (*s == c)
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801214:	75 05                	jne    80121b <strchr+0x1d>
			return (char *) s;
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	eb 11                	jmp    80122c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80121b:	ff 45 08             	incl   0x8(%ebp)
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	84 c0                	test   %al,%al
  801225:	75 e5                	jne    80120c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801227:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 04             	sub    $0x4,%esp
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80123a:	eb 0d                	jmp    801249 <strfind+0x1b>
		if (*s == c)
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801244:	74 0e                	je     801254 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801246:	ff 45 08             	incl   0x8(%ebp)
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	84 c0                	test   %al,%al
  801250:	75 ea                	jne    80123c <strfind+0xe>
  801252:	eb 01                	jmp    801255 <strfind+0x27>
		if (*s == c)
			break;
  801254:	90                   	nop
	return (char *) s;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801258:	c9                   	leave  
  801259:	c3                   	ret    

0080125a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801266:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80126a:	76 63                	jbe    8012cf <memset+0x75>
		uint64 data_block = c;
  80126c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126f:	99                   	cltd   
  801270:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801273:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801279:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801280:	c1 e0 08             	shl    $0x8,%eax
  801283:	09 45 f0             	or     %eax,-0x10(%ebp)
  801286:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801293:	c1 e0 10             	shl    $0x10,%eax
  801296:	09 45 f0             	or     %eax,-0x10(%ebp)
  801299:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80129c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80129f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a2:	89 c2                	mov    %eax,%edx
  8012a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a9:	09 45 f0             	or     %eax,-0x10(%ebp)
  8012ac:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8012af:	eb 18                	jmp    8012c9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8012b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012b4:	8d 41 08             	lea    0x8(%ecx),%eax
  8012b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8012ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c0:	89 01                	mov    %eax,(%ecx)
  8012c2:	89 51 04             	mov    %edx,0x4(%ecx)
  8012c5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8012c9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012cd:	77 e2                	ja     8012b1 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8012cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d3:	74 23                	je     8012f8 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8012d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012db:	eb 0e                	jmp    8012eb <memset+0x91>
			*p8++ = (uint8)c;
  8012dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e0:	8d 50 01             	lea    0x1(%eax),%edx
  8012e3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e9:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8012eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	75 e5                	jne    8012dd <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801303:	8b 45 0c             	mov    0xc(%ebp),%eax
  801306:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80130f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801313:	76 24                	jbe    801339 <memcpy+0x3c>
		while(n >= 8){
  801315:	eb 1c                	jmp    801333 <memcpy+0x36>
			*d64 = *s64;
  801317:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131a:	8b 50 04             	mov    0x4(%eax),%edx
  80131d:	8b 00                	mov    (%eax),%eax
  80131f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801322:	89 01                	mov    %eax,(%ecx)
  801324:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801327:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80132b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80132f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801333:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801337:	77 de                	ja     801317 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801339:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80133d:	74 31                	je     801370 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801342:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801345:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801348:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80134b:	eb 16                	jmp    801363 <memcpy+0x66>
			*d8++ = *s8++;
  80134d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801350:	8d 50 01             	lea    0x1(%eax),%edx
  801353:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801359:	8d 4a 01             	lea    0x1(%edx),%ecx
  80135c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80135f:	8a 12                	mov    (%edx),%dl
  801361:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801363:	8b 45 10             	mov    0x10(%ebp),%eax
  801366:	8d 50 ff             	lea    -0x1(%eax),%edx
  801369:	89 55 10             	mov    %edx,0x10(%ebp)
  80136c:	85 c0                	test   %eax,%eax
  80136e:	75 dd                	jne    80134d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80137b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80138d:	73 50                	jae    8013df <memmove+0x6a>
  80138f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801392:	8b 45 10             	mov    0x10(%ebp),%eax
  801395:	01 d0                	add    %edx,%eax
  801397:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80139a:	76 43                	jbe    8013df <memmove+0x6a>
		s += n;
  80139c:	8b 45 10             	mov    0x10(%ebp),%eax
  80139f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013a8:	eb 10                	jmp    8013ba <memmove+0x45>
			*--d = *--s;
  8013aa:	ff 4d f8             	decl   -0x8(%ebp)
  8013ad:	ff 4d fc             	decl   -0x4(%ebp)
  8013b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b3:	8a 10                	mov    (%eax),%dl
  8013b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013c0:	89 55 10             	mov    %edx,0x10(%ebp)
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	75 e3                	jne    8013aa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013c7:	eb 23                	jmp    8013ec <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cc:	8d 50 01             	lea    0x1(%eax),%edx
  8013cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013d8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013db:	8a 12                	mov    (%edx),%dl
  8013dd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	75 dd                	jne    8013c9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801400:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801403:	eb 2a                	jmp    80142f <memcmp+0x3e>
		if (*s1 != *s2)
  801405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801408:	8a 10                	mov    (%eax),%dl
  80140a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	38 c2                	cmp    %al,%dl
  801411:	74 16                	je     801429 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801413:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	0f b6 d0             	movzbl %al,%edx
  80141b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	0f b6 c0             	movzbl %al,%eax
  801423:	29 c2                	sub    %eax,%edx
  801425:	89 d0                	mov    %edx,%eax
  801427:	eb 18                	jmp    801441 <memcmp+0x50>
		s1++, s2++;
  801429:	ff 45 fc             	incl   -0x4(%ebp)
  80142c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80142f:	8b 45 10             	mov    0x10(%ebp),%eax
  801432:	8d 50 ff             	lea    -0x1(%eax),%edx
  801435:	89 55 10             	mov    %edx,0x10(%ebp)
  801438:	85 c0                	test   %eax,%eax
  80143a:	75 c9                	jne    801405 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80143c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801449:	8b 55 08             	mov    0x8(%ebp),%edx
  80144c:	8b 45 10             	mov    0x10(%ebp),%eax
  80144f:	01 d0                	add    %edx,%eax
  801451:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801454:	eb 15                	jmp    80146b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	0f b6 d0             	movzbl %al,%edx
  80145e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801461:	0f b6 c0             	movzbl %al,%eax
  801464:	39 c2                	cmp    %eax,%edx
  801466:	74 0d                	je     801475 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801468:	ff 45 08             	incl   0x8(%ebp)
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801471:	72 e3                	jb     801456 <memfind+0x13>
  801473:	eb 01                	jmp    801476 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801475:	90                   	nop
	return (void *) s;
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801481:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801488:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80148f:	eb 03                	jmp    801494 <strtol+0x19>
		s++;
  801491:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	3c 20                	cmp    $0x20,%al
  80149b:	74 f4                	je     801491 <strtol+0x16>
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3c 09                	cmp    $0x9,%al
  8014a4:	74 eb                	je     801491 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	3c 2b                	cmp    $0x2b,%al
  8014ad:	75 05                	jne    8014b4 <strtol+0x39>
		s++;
  8014af:	ff 45 08             	incl   0x8(%ebp)
  8014b2:	eb 13                	jmp    8014c7 <strtol+0x4c>
	else if (*s == '-')
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	3c 2d                	cmp    $0x2d,%al
  8014bb:	75 0a                	jne    8014c7 <strtol+0x4c>
		s++, neg = 1;
  8014bd:	ff 45 08             	incl   0x8(%ebp)
  8014c0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014cb:	74 06                	je     8014d3 <strtol+0x58>
  8014cd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014d1:	75 20                	jne    8014f3 <strtol+0x78>
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 30                	cmp    $0x30,%al
  8014da:	75 17                	jne    8014f3 <strtol+0x78>
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	40                   	inc    %eax
  8014e0:	8a 00                	mov    (%eax),%al
  8014e2:	3c 78                	cmp    $0x78,%al
  8014e4:	75 0d                	jne    8014f3 <strtol+0x78>
		s += 2, base = 16;
  8014e6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014ea:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014f1:	eb 28                	jmp    80151b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f7:	75 15                	jne    80150e <strtol+0x93>
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	3c 30                	cmp    $0x30,%al
  801500:	75 0c                	jne    80150e <strtol+0x93>
		s++, base = 8;
  801502:	ff 45 08             	incl   0x8(%ebp)
  801505:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80150c:	eb 0d                	jmp    80151b <strtol+0xa0>
	else if (base == 0)
  80150e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801512:	75 07                	jne    80151b <strtol+0xa0>
		base = 10;
  801514:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	3c 2f                	cmp    $0x2f,%al
  801522:	7e 19                	jle    80153d <strtol+0xc2>
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	3c 39                	cmp    $0x39,%al
  80152b:	7f 10                	jg     80153d <strtol+0xc2>
			dig = *s - '0';
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	0f be c0             	movsbl %al,%eax
  801535:	83 e8 30             	sub    $0x30,%eax
  801538:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80153b:	eb 42                	jmp    80157f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8a 00                	mov    (%eax),%al
  801542:	3c 60                	cmp    $0x60,%al
  801544:	7e 19                	jle    80155f <strtol+0xe4>
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8a 00                	mov    (%eax),%al
  80154b:	3c 7a                	cmp    $0x7a,%al
  80154d:	7f 10                	jg     80155f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	8a 00                	mov    (%eax),%al
  801554:	0f be c0             	movsbl %al,%eax
  801557:	83 e8 57             	sub    $0x57,%eax
  80155a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80155d:	eb 20                	jmp    80157f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	8a 00                	mov    (%eax),%al
  801564:	3c 40                	cmp    $0x40,%al
  801566:	7e 39                	jle    8015a1 <strtol+0x126>
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	3c 5a                	cmp    $0x5a,%al
  80156f:	7f 30                	jg     8015a1 <strtol+0x126>
			dig = *s - 'A' + 10;
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	8a 00                	mov    (%eax),%al
  801576:	0f be c0             	movsbl %al,%eax
  801579:	83 e8 37             	sub    $0x37,%eax
  80157c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801582:	3b 45 10             	cmp    0x10(%ebp),%eax
  801585:	7d 19                	jge    8015a0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801587:	ff 45 08             	incl   0x8(%ebp)
  80158a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801591:	89 c2                	mov    %eax,%edx
  801593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80159b:	e9 7b ff ff ff       	jmp    80151b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015a0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015a5:	74 08                	je     8015af <strtol+0x134>
		*endptr = (char *) s;
  8015a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ad:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015af:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015b3:	74 07                	je     8015bc <strtol+0x141>
  8015b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b8:	f7 d8                	neg    %eax
  8015ba:	eb 03                	jmp    8015bf <strtol+0x144>
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <ltostr>:

void
ltostr(long value, char *str)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015d9:	79 13                	jns    8015ee <ltostr+0x2d>
	{
		neg = 1;
  8015db:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015e8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015eb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015f6:	99                   	cltd   
  8015f7:	f7 f9                	idiv   %ecx
  8015f9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ff:	8d 50 01             	lea    0x1(%eax),%edx
  801602:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801605:	89 c2                	mov    %eax,%edx
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	01 d0                	add    %edx,%eax
  80160c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80160f:	83 c2 30             	add    $0x30,%edx
  801612:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801614:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801617:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80161c:	f7 e9                	imul   %ecx
  80161e:	c1 fa 02             	sar    $0x2,%edx
  801621:	89 c8                	mov    %ecx,%eax
  801623:	c1 f8 1f             	sar    $0x1f,%eax
  801626:	29 c2                	sub    %eax,%edx
  801628:	89 d0                	mov    %edx,%eax
  80162a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80162d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801631:	75 bb                	jne    8015ee <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801633:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80163a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163d:	48                   	dec    %eax
  80163e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801641:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801645:	74 3d                	je     801684 <ltostr+0xc3>
		start = 1 ;
  801647:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80164e:	eb 34                	jmp    801684 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801653:	8b 45 0c             	mov    0xc(%ebp),%eax
  801656:	01 d0                	add    %edx,%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80165d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	01 c2                	add    %eax,%edx
  801665:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801668:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166b:	01 c8                	add    %ecx,%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801671:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	01 c2                	add    %eax,%edx
  801679:	8a 45 eb             	mov    -0x15(%ebp),%al
  80167c:	88 02                	mov    %al,(%edx)
		start++ ;
  80167e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801681:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801687:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80168a:	7c c4                	jl     801650 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80168c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80168f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801692:	01 d0                	add    %edx,%eax
  801694:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801697:	90                   	nop
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016a0:	ff 75 08             	pushl  0x8(%ebp)
  8016a3:	e8 c4 f9 ff ff       	call   80106c <strlen>
  8016a8:	83 c4 04             	add    $0x4,%esp
  8016ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016ae:	ff 75 0c             	pushl  0xc(%ebp)
  8016b1:	e8 b6 f9 ff ff       	call   80106c <strlen>
  8016b6:	83 c4 04             	add    $0x4,%esp
  8016b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ca:	eb 17                	jmp    8016e3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d2:	01 c2                	add    %eax,%edx
  8016d4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	01 c8                	add    %ecx,%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016e0:	ff 45 fc             	incl   -0x4(%ebp)
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016e9:	7c e1                	jl     8016cc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016f9:	eb 1f                	jmp    80171a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016fe:	8d 50 01             	lea    0x1(%eax),%edx
  801701:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801704:	89 c2                	mov    %eax,%edx
  801706:	8b 45 10             	mov    0x10(%ebp),%eax
  801709:	01 c2                	add    %eax,%edx
  80170b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80170e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801711:	01 c8                	add    %ecx,%eax
  801713:	8a 00                	mov    (%eax),%al
  801715:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801717:	ff 45 f8             	incl   -0x8(%ebp)
  80171a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801720:	7c d9                	jl     8016fb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801722:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801725:	8b 45 10             	mov    0x10(%ebp),%eax
  801728:	01 d0                	add    %edx,%eax
  80172a:	c6 00 00             	movb   $0x0,(%eax)
}
  80172d:	90                   	nop
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801733:	8b 45 14             	mov    0x14(%ebp),%eax
  801736:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80173c:	8b 45 14             	mov    0x14(%ebp),%eax
  80173f:	8b 00                	mov    (%eax),%eax
  801741:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801748:	8b 45 10             	mov    0x10(%ebp),%eax
  80174b:	01 d0                	add    %edx,%eax
  80174d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801753:	eb 0c                	jmp    801761 <strsplit+0x31>
			*string++ = 0;
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8d 50 01             	lea    0x1(%eax),%edx
  80175b:	89 55 08             	mov    %edx,0x8(%ebp)
  80175e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	8a 00                	mov    (%eax),%al
  801766:	84 c0                	test   %al,%al
  801768:	74 18                	je     801782 <strsplit+0x52>
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	0f be c0             	movsbl %al,%eax
  801772:	50                   	push   %eax
  801773:	ff 75 0c             	pushl  0xc(%ebp)
  801776:	e8 83 fa ff ff       	call   8011fe <strchr>
  80177b:	83 c4 08             	add    $0x8,%esp
  80177e:	85 c0                	test   %eax,%eax
  801780:	75 d3                	jne    801755 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	84 c0                	test   %al,%al
  801789:	74 5a                	je     8017e5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80178b:	8b 45 14             	mov    0x14(%ebp),%eax
  80178e:	8b 00                	mov    (%eax),%eax
  801790:	83 f8 0f             	cmp    $0xf,%eax
  801793:	75 07                	jne    80179c <strsplit+0x6c>
		{
			return 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
  80179a:	eb 66                	jmp    801802 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80179c:	8b 45 14             	mov    0x14(%ebp),%eax
  80179f:	8b 00                	mov    (%eax),%eax
  8017a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8017a4:	8b 55 14             	mov    0x14(%ebp),%edx
  8017a7:	89 0a                	mov    %ecx,(%edx)
  8017a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b3:	01 c2                	add    %eax,%edx
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017ba:	eb 03                	jmp    8017bf <strsplit+0x8f>
			string++;
  8017bc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	84 c0                	test   %al,%al
  8017c6:	74 8b                	je     801753 <strsplit+0x23>
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	0f be c0             	movsbl %al,%eax
  8017d0:	50                   	push   %eax
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	e8 25 fa ff ff       	call   8011fe <strchr>
  8017d9:	83 c4 08             	add    $0x8,%esp
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	74 dc                	je     8017bc <strsplit+0x8c>
			string++;
	}
  8017e0:	e9 6e ff ff ff       	jmp    801753 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017e5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e9:	8b 00                	mov    (%eax),%eax
  8017eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f5:	01 d0                	add    %edx,%eax
  8017f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017fd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801810:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801817:	eb 4a                	jmp    801863 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801819:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	01 c2                	add    %eax,%edx
  801821:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 c8                	add    %ecx,%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80182d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801830:	8b 45 0c             	mov    0xc(%ebp),%eax
  801833:	01 d0                	add    %edx,%eax
  801835:	8a 00                	mov    (%eax),%al
  801837:	3c 40                	cmp    $0x40,%al
  801839:	7e 25                	jle    801860 <str2lower+0x5c>
  80183b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80183e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801841:	01 d0                	add    %edx,%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	3c 5a                	cmp    $0x5a,%al
  801847:	7f 17                	jg     801860 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801849:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	01 d0                	add    %edx,%eax
  801851:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801854:	8b 55 08             	mov    0x8(%ebp),%edx
  801857:	01 ca                	add    %ecx,%edx
  801859:	8a 12                	mov    (%edx),%dl
  80185b:	83 c2 20             	add    $0x20,%edx
  80185e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801860:	ff 45 fc             	incl   -0x4(%ebp)
  801863:	ff 75 0c             	pushl  0xc(%ebp)
  801866:	e8 01 f8 ff ff       	call   80106c <strlen>
  80186b:	83 c4 04             	add    $0x4,%esp
  80186e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801871:	7f a6                	jg     801819 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801873:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80187e:	a1 08 60 80 00       	mov    0x806008,%eax
  801883:	85 c0                	test   %eax,%eax
  801885:	0f 84 95 00 00 00    	je     801920 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	68 00 00 00 82       	push   $0x82000000
  801893:	68 00 00 00 80       	push   $0x80000000
  801898:	e8 59 1f 00 00       	call   8037f6 <initialize_dynamic_allocator>
  80189d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8018a0:	e8 93 1d 00 00       	call   803638 <sys_get_uheap_strategy>
  8018a5:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8018aa:	a1 40 60 80 00       	mov    0x806040,%eax
  8018af:	05 00 10 00 00       	add    $0x1000,%eax
  8018b4:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  8018b9:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8018be:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	6a 01                	push   $0x1
  8018c8:	68 88 51 80 00       	push   $0x805188
  8018cd:	68 40 e1 81 00       	push   $0x81e140
  8018d2:	e8 d8 29 00 00       	call   8042af <init_uspinlock>
  8018d7:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  8018da:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  8018e1:	00 00 00 
  8018e4:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  8018eb:	00 00 00 
  8018ee:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  8018f5:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  8018f8:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  8018ff:	00 00 00 
  801902:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  801909:	00 00 00 
  80190c:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  801913:	00 00 00 
		__firstTimeFlag = 0;
  801916:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  80191d:	00 00 00 
	}
}
  801920:	90                   	nop
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80192f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801932:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801937:	83 ec 08             	sub    $0x8,%esp
  80193a:	68 06 04 00 00       	push   $0x406
  80193f:	50                   	push   %eax
  801940:	e8 3d 19 00 00       	call   803282 <__sys_allocate_page>
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80194b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80194f:	79 14                	jns    801965 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	68 90 51 80 00       	push   $0x805190
  801959:	6a 2d                	push   $0x2d
  80195b:	68 cc 51 80 00       	push   $0x8051cc
  801960:	e8 60 ed ff ff       	call   8006c5 <_panic>
	return 0;
  801965:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801980:	83 ec 0c             	sub    $0xc,%esp
  801983:	50                   	push   %eax
  801984:	e8 40 19 00 00       	call   8032c9 <__sys_unmap_frame>
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80198f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801993:	79 14                	jns    8019a9 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	68 d8 51 80 00       	push   $0x8051d8
  80199d:	6a 38                	push   $0x38
  80199f:	68 cc 51 80 00       	push   $0x8051cc
  8019a4:	e8 1c ed ff ff       	call   8006c5 <_panic>
}
  8019a9:	90                   	nop
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8019b2:	e8 c1 fe ff ff       	call   801878 <uheap_init>
	if (size == 0) return NULL ;
  8019b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019bb:	75 0a                	jne    8019c7 <malloc+0x1b>
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c2:	e9 e1 04 00 00       	jmp    801ea8 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  8019c7:	83 ec 0c             	sub    $0xc,%esp
  8019ca:	68 40 e1 81 00       	push   $0x81e140
  8019cf:	e8 2a 29 00 00       	call   8042fe <acquire_uspinlock>
  8019d4:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  8019d7:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  8019de:	77 23                	ja     801a03 <malloc+0x57>
		release_uspinlock(&ulock);
  8019e0:	83 ec 0c             	sub    $0xc,%esp
  8019e3:	68 40 e1 81 00       	push   $0x81e140
  8019e8:	e8 69 29 00 00       	call   804356 <release_uspinlock>
  8019ed:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  8019f0:	83 ec 0c             	sub    $0xc,%esp
  8019f3:	ff 75 08             	pushl  0x8(%ebp)
  8019f6:	e8 dd 1f 00 00       	call   8039d8 <alloc_block>
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	e9 a5 04 00 00       	jmp    801ea8 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801a03:	83 ec 0c             	sub    $0xc,%esp
  801a06:	6a 10                	push   $0x10
  801a08:	e8 cb 1f 00 00       	call   8039d8 <alloc_block>
  801a0d:	83 c4 10             	add    $0x10,%esp
  801a10:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801a13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a17:	75 0a                	jne    801a23 <malloc+0x77>
			return NULL;
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1e:	e9 85 04 00 00       	jmp    801ea8 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801a23:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801a2a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a30:	01 d0                	add    %edx,%eax
  801a32:	48                   	dec    %eax
  801a33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a39:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3e:	f7 75 e8             	divl   -0x18(%ebp)
  801a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a44:	29 d0                	sub    %edx,%eax
  801a46:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801a49:	a1 24 e1 81 00       	mov    0x81e124,%eax
  801a4e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801a51:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801a56:	85 c0                	test   %eax,%eax
  801a58:	74 0f                	je     801a69 <malloc+0xbd>
  801a5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a5d:	8b 40 04             	mov    0x4(%eax),%eax
  801a60:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a63:	0f 83 ea 00 00 00    	jae    801b53 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801a69:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801a6e:	2b 45 08             	sub    0x8(%ebp),%eax
  801a71:	89 c2                	mov    %eax,%edx
  801a73:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801a78:	39 c2                	cmp    %eax,%edx
  801a7a:	0f 86 b9 00 00 00    	jbe    801b39 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801a80:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801a85:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801a88:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	01 d0                	add    %edx,%eax
  801a93:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  801a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a9b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a9e:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa3:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa6:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801aa9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801aad:	75 14                	jne    801ac3 <malloc+0x117>
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	68 18 52 80 00       	push   $0x805218
  801ab7:	6a 60                	push   $0x60
  801ab9:	68 cc 51 80 00       	push   $0x8051cc
  801abe:	e8 02 ec ff ff       	call   8006c5 <_panic>
  801ac3:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801acc:	89 50 0c             	mov    %edx,0xc(%eax)
  801acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	74 0d                	je     801ae6 <malloc+0x13a>
  801ad9:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801ade:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ae1:	89 50 08             	mov    %edx,0x8(%eax)
  801ae4:	eb 08                	jmp    801aee <malloc+0x142>
  801ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ae9:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af1:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801b00:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801b05:	40                   	inc    %eax
  801b06:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0e:	8b 00                	mov    (%eax),%eax
  801b10:	83 ec 08             	sub    $0x8,%esp
  801b13:	ff 75 08             	pushl  0x8(%ebp)
  801b16:	50                   	push   %eax
  801b17:	e8 34 1c 00 00       	call   803750 <sys_allocate_user_mem>
  801b1c:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	68 40 e1 81 00       	push   $0x81e140
  801b27:	e8 2a 28 00 00       	call   804356 <release_uspinlock>
  801b2c:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801b2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b32:	8b 00                	mov    (%eax),%eax
  801b34:	e9 6f 03 00 00       	jmp    801ea8 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801b39:	83 ec 0c             	sub    $0xc,%esp
  801b3c:	68 40 e1 81 00       	push   $0x81e140
  801b41:	e8 10 28 00 00       	call   804356 <release_uspinlock>
  801b46:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801b49:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4e:	e9 55 03 00 00       	jmp    801ea8 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801b53:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801b5b:	e9 39 03 00 00       	jmp    801e99 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b63:	8b 40 04             	mov    0x4(%eax),%eax
  801b66:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b69:	0f 86 e7 01 00 00    	jbe    801d56 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801b6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b72:	8b 10                	mov    (%eax),%edx
  801b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b77:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b7c:	8b 55 08             	mov    0x8(%ebp),%edx
  801b7f:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801b82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b86:	75 14                	jne    801b9c <malloc+0x1f0>
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	68 18 52 80 00       	push   $0x805218
  801b90:	6a 72                	push   $0x72
  801b92:	68 cc 51 80 00       	push   $0x8051cc
  801b97:	e8 29 eb ff ff       	call   8006c5 <_panic>
  801b9c:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba5:	89 50 0c             	mov    %edx,0xc(%eax)
  801ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bab:	8b 40 0c             	mov    0xc(%eax),%eax
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	74 0d                	je     801bbf <malloc+0x213>
  801bb2:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801bb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bba:	89 50 08             	mov    %edx,0x8(%eax)
  801bbd:	eb 08                	jmp    801bc7 <malloc+0x21b>
  801bbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc2:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bca:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801bd9:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801bde:	40                   	inc    %eax
  801bdf:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  801be4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801be7:	8b 10                	mov    (%eax),%edx
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	01 c2                	add    %eax,%edx
  801bee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf1:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801bf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf6:	8b 40 04             	mov    0x4(%eax),%eax
  801bf9:	2b 45 08             	sub    0x8(%ebp),%eax
  801bfc:	89 c2                	mov    %eax,%edx
  801bfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c01:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801c04:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801c0c:	e9 0d 01 00 00       	jmp    801d1e <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  801c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c14:	8b 50 04             	mov    0x4(%eax),%edx
  801c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1a:	8b 40 04             	mov    0x4(%eax),%eax
  801c1d:	39 c2                	cmp    %eax,%edx
  801c1f:	0f 83 f0 00 00 00    	jae    801d15 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801c25:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c29:	75 14                	jne    801c3f <malloc+0x293>
  801c2b:	83 ec 04             	sub    $0x4,%esp
  801c2e:	68 3b 52 80 00       	push   $0x80523b
  801c33:	6a 7a                	push   $0x7a
  801c35:	68 cc 51 80 00       	push   $0x8051cc
  801c3a:	e8 86 ea ff ff       	call   8006c5 <_panic>
  801c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c42:	8b 40 08             	mov    0x8(%eax),%eax
  801c45:	85 c0                	test   %eax,%eax
  801c47:	74 11                	je     801c5a <malloc+0x2ae>
  801c49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c4c:	8b 40 08             	mov    0x8(%eax),%eax
  801c4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c52:	8b 52 0c             	mov    0xc(%edx),%edx
  801c55:	89 50 0c             	mov    %edx,0xc(%eax)
  801c58:	eb 0b                	jmp    801c65 <malloc+0x2b9>
  801c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c60:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801c65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c68:	8b 40 0c             	mov    0xc(%eax),%eax
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	74 11                	je     801c80 <malloc+0x2d4>
  801c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c72:	8b 40 0c             	mov    0xc(%eax),%eax
  801c75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c78:	8b 52 08             	mov    0x8(%edx),%edx
  801c7b:	89 50 08             	mov    %edx,0x8(%eax)
  801c7e:	eb 0b                	jmp    801c8b <malloc+0x2df>
  801c80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c83:	8b 40 08             	mov    0x8(%eax),%eax
  801c86:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801c8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c8e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c98:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c9f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801ca4:	48                   	dec    %eax
  801ca5:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801caa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cae:	74 06                	je     801cb6 <malloc+0x30a>
  801cb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cb4:	75 14                	jne    801cca <malloc+0x31e>
  801cb6:	83 ec 04             	sub    $0x4,%esp
  801cb9:	68 5c 52 80 00       	push   $0x80525c
  801cbe:	6a 7b                	push   $0x7b
  801cc0:	68 cc 51 80 00       	push   $0x8051cc
  801cc5:	e8 fb e9 ff ff       	call   8006c5 <_panic>
  801cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccd:	8b 50 0c             	mov    0xc(%eax),%edx
  801cd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cd3:	89 50 0c             	mov    %edx,0xc(%eax)
  801cd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cdc:	89 50 08             	mov    %edx,0x8(%eax)
  801cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	74 0e                	je     801cf7 <malloc+0x34b>
  801ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cec:	8b 40 0c             	mov    0xc(%eax),%eax
  801cef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cf2:	89 50 08             	mov    %edx,0x8(%eax)
  801cf5:	eb 08                	jmp    801cff <malloc+0x353>
  801cf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cfa:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d05:	89 50 0c             	mov    %edx,0xc(%eax)
  801d08:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801d0d:	40                   	inc    %eax
  801d0e:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  801d13:	eb 13                	jmp    801d28 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d18:	8b 40 08             	mov    0x8(%eax),%eax
  801d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801d1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d22:	0f 85 e9 fe ff ff    	jne    801c11 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2b:	8b 00                	mov    (%eax),%eax
  801d2d:	83 ec 08             	sub    $0x8,%esp
  801d30:	ff 75 08             	pushl  0x8(%ebp)
  801d33:	50                   	push   %eax
  801d34:	e8 17 1a 00 00       	call   803750 <sys_allocate_user_mem>
  801d39:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801d3c:	83 ec 0c             	sub    $0xc,%esp
  801d3f:	68 40 e1 81 00       	push   $0x81e140
  801d44:	e8 0d 26 00 00       	call   804356 <release_uspinlock>
  801d49:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801d4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d4f:	8b 00                	mov    (%eax),%eax
  801d51:	e9 52 01 00 00       	jmp    801ea8 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d59:	8b 40 04             	mov    0x4(%eax),%eax
  801d5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d5f:	0f 85 2b 01 00 00    	jne    801e90 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d68:	8b 10                	mov    (%eax),%edx
  801d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6d:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d72:	8b 55 08             	mov    0x8(%ebp),%edx
  801d75:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801d78:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d7c:	75 17                	jne    801d95 <malloc+0x3e9>
  801d7e:	83 ec 04             	sub    $0x4,%esp
  801d81:	68 18 52 80 00       	push   $0x805218
  801d86:	68 89 00 00 00       	push   $0x89
  801d8b:	68 cc 51 80 00       	push   $0x8051cc
  801d90:	e8 30 e9 ff ff       	call   8006c5 <_panic>
  801d95:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9e:	89 50 0c             	mov    %edx,0xc(%eax)
  801da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da4:	8b 40 0c             	mov    0xc(%eax),%eax
  801da7:	85 c0                	test   %eax,%eax
  801da9:	74 0d                	je     801db8 <malloc+0x40c>
  801dab:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801db0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801db3:	89 50 08             	mov    %edx,0x8(%eax)
  801db6:	eb 08                	jmp    801dc0 <malloc+0x414>
  801db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbb:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc3:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dcb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801dd2:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801dd7:	40                   	inc    %eax
  801dd8:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801ddd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de1:	75 17                	jne    801dfa <malloc+0x44e>
  801de3:	83 ec 04             	sub    $0x4,%esp
  801de6:	68 3b 52 80 00       	push   $0x80523b
  801deb:	68 8a 00 00 00       	push   $0x8a
  801df0:	68 cc 51 80 00       	push   $0x8051cc
  801df5:	e8 cb e8 ff ff       	call   8006c5 <_panic>
  801dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfd:	8b 40 08             	mov    0x8(%eax),%eax
  801e00:	85 c0                	test   %eax,%eax
  801e02:	74 11                	je     801e15 <malloc+0x469>
  801e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e07:	8b 40 08             	mov    0x8(%eax),%eax
  801e0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0d:	8b 52 0c             	mov    0xc(%edx),%edx
  801e10:	89 50 0c             	mov    %edx,0xc(%eax)
  801e13:	eb 0b                	jmp    801e20 <malloc+0x474>
  801e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e18:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1b:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e23:	8b 40 0c             	mov    0xc(%eax),%eax
  801e26:	85 c0                	test   %eax,%eax
  801e28:	74 11                	je     801e3b <malloc+0x48f>
  801e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e33:	8b 52 08             	mov    0x8(%edx),%edx
  801e36:	89 50 08             	mov    %edx,0x8(%eax)
  801e39:	eb 0b                	jmp    801e46 <malloc+0x49a>
  801e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3e:	8b 40 08             	mov    0x8(%eax),%eax
  801e41:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e53:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e5a:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801e5f:	48                   	dec    %eax
  801e60:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801e65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e68:	8b 00                	mov    (%eax),%eax
  801e6a:	83 ec 08             	sub    $0x8,%esp
  801e6d:	ff 75 08             	pushl  0x8(%ebp)
  801e70:	50                   	push   %eax
  801e71:	e8 da 18 00 00       	call   803750 <sys_allocate_user_mem>
  801e76:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	68 40 e1 81 00       	push   $0x81e140
  801e81:	e8 d0 24 00 00       	call   804356 <release_uspinlock>
  801e86:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e8c:	8b 00                	mov    (%eax),%eax
  801e8e:	eb 18                	jmp    801ea8 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e93:	8b 40 08             	mov    0x8(%eax),%eax
  801e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801e99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e9d:	0f 85 bd fc ff ff    	jne    801b60 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801eb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ebe:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801ec1:	e8 b2 f9 ff ff       	call   801878 <uheap_init>
		acquire_uspinlock(&ulock);
  801ec6:	83 ec 0c             	sub    $0xc,%esp
  801ec9:	68 40 e1 81 00       	push   $0x81e140
  801ece:	e8 2b 24 00 00       	call   8042fe <acquire_uspinlock>
  801ed3:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801ed6:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801edb:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801ede:	73 23                	jae    801f03 <free+0x59>
			free_block(virtual_address);
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	ff 75 08             	pushl  0x8(%ebp)
  801ee6:	e8 89 1f 00 00       	call   803e74 <free_block>
  801eeb:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	68 40 e1 81 00       	push   $0x81e140
  801ef6:	e8 5b 24 00 00       	call   804356 <release_uspinlock>
  801efb:	83 c4 10             	add    $0x10,%esp
			return;
  801efe:	e9 35 07 00 00       	jmp    802638 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801f03:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801f08:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801f0b:	72 30                	jb     801f3d <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801f0d:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	50                   	push   %eax
  801f16:	ff 75 d8             	pushl  -0x28(%ebp)
  801f19:	68 91 52 80 00       	push   $0x805291
  801f1e:	e8 70 ea ff ff       	call   800993 <cprintf>
  801f23:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	68 99 52 80 00       	push   $0x805299
  801f2e:	68 a7 00 00 00       	push   $0xa7
  801f33:	68 cc 51 80 00       	push   $0x8051cc
  801f38:	e8 88 e7 ff ff       	call   8006c5 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801f3d:	83 ec 0c             	sub    $0xc,%esp
  801f40:	6a 10                	push   $0x10
  801f42:	e8 91 1a 00 00       	call   8039d8 <alloc_block>
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	6a 10                	push   $0x10
  801f52:	e8 81 1a 00 00       	call   8039d8 <alloc_block>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801f5d:	a1 30 e1 81 00       	mov    0x81e130,%eax
  801f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801f65:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801f6c:	eb 1c                	jmp    801f8a <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f71:	8b 00                	mov    (%eax),%eax
  801f73:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801f76:	75 09                	jne    801f81 <free+0xd7>
				foundVA = 1;
  801f78:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801f7f:	eb 0f                	jmp    801f90 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	8b 40 08             	mov    0x8(%eax),%eax
  801f87:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8e:	75 de                	jne    801f6e <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801f90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f94:	75 17                	jne    801fad <free+0x103>
				panic("INVALID ADDRESS!");
  801f96:	83 ec 04             	sub    $0x4,%esp
  801f99:	68 b6 52 80 00       	push   $0x8052b6
  801f9e:	68 be 00 00 00       	push   $0xbe
  801fa3:	68 cc 51 80 00       	push   $0x8051cc
  801fa8:	e8 18 e7 ff ff       	call   8006c5 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	8b 10                	mov    (%eax),%edx
  801fb2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fb5:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	8b 50 04             	mov    0x4(%eax),%edx
  801fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fc0:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801fc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc7:	75 17                	jne    801fe0 <free+0x136>
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	68 3b 52 80 00       	push   $0x80523b
  801fd1:	68 c8 00 00 00       	push   $0xc8
  801fd6:	68 cc 51 80 00       	push   $0x8051cc
  801fdb:	e8 e5 e6 ff ff       	call   8006c5 <_panic>
  801fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe3:	8b 40 08             	mov    0x8(%eax),%eax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	74 11                	je     801ffb <free+0x151>
  801fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fed:	8b 40 08             	mov    0x8(%eax),%eax
  801ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff3:	8b 52 0c             	mov    0xc(%edx),%edx
  801ff6:	89 50 0c             	mov    %edx,0xc(%eax)
  801ff9:	eb 0b                	jmp    802006 <free+0x15c>
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  802001:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802009:	8b 40 0c             	mov    0xc(%eax),%eax
  80200c:	85 c0                	test   %eax,%eax
  80200e:	74 11                	je     802021 <free+0x177>
  802010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802013:	8b 40 0c             	mov    0xc(%eax),%eax
  802016:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802019:	8b 52 08             	mov    0x8(%edx),%edx
  80201c:	89 50 08             	mov    %edx,0x8(%eax)
  80201f:	eb 0b                	jmp    80202c <free+0x182>
  802021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802024:	8b 40 08             	mov    0x8(%eax),%eax
  802027:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802040:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802045:	48                   	dec    %eax
  802046:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	8b 50 04             	mov    0x4(%eax),%edx
  802051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802054:	8b 00                	mov    (%eax),%eax
  802056:	83 ec 08             	sub    $0x8,%esp
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	e8 d4 16 00 00       	call   803734 <sys_free_user_mem>
  802060:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  802063:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802068:	85 c0                	test   %eax,%eax
  80206a:	75 7a                	jne    8020e6 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  80206c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802070:	75 17                	jne    802089 <free+0x1df>
  802072:	83 ec 04             	sub    $0x4,%esp
  802075:	68 c8 52 80 00       	push   $0x8052c8
  80207a:	68 d0 00 00 00       	push   $0xd0
  80207f:	68 cc 51 80 00       	push   $0x8051cc
  802084:	e8 3c e6 ff ff       	call   8006c5 <_panic>
  802089:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  80208f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802092:	89 50 08             	mov    %edx,0x8(%eax)
  802095:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802098:	8b 40 08             	mov    0x8(%eax),%eax
  80209b:	85 c0                	test   %eax,%eax
  80209d:	74 0d                	je     8020ac <free+0x202>
  80209f:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8020a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8020a7:	89 50 0c             	mov    %edx,0xc(%eax)
  8020aa:	eb 08                	jmp    8020b4 <free+0x20a>
  8020ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020af:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8020b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020b7:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8020bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020c6:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8020cb:	40                   	inc    %eax
  8020cc:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	68 40 e1 81 00       	push   $0x81e140
  8020d9:	e8 78 22 00 00       	call   804356 <release_uspinlock>
  8020de:	83 c4 10             	add    $0x10,%esp
			return;
  8020e1:	e9 52 05 00 00       	jmp    802638 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  8020e6:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8020eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  8020ee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  8020f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  8020fc:	e9 d2 00 00 00       	jmp    8021d3 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  802101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802104:	8b 10                	mov    (%eax),%edx
  802106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802109:	8b 40 04             	mov    0x4(%eax),%eax
  80210c:	01 c2                	add    %eax,%edx
  80210e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802111:	8b 00                	mov    (%eax),%eax
  802113:	39 c2                	cmp    %eax,%edx
  802115:	0f 85 af 00 00 00    	jne    8021ca <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  80211b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211e:	8b 10                	mov    (%eax),%edx
  802120:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802123:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  802125:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802128:	8b 50 04             	mov    0x4(%eax),%edx
  80212b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80212e:	8b 40 04             	mov    0x4(%eax),%eax
  802131:	01 c2                	add    %eax,%edx
  802133:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802136:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  802139:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80213d:	75 17                	jne    802156 <free+0x2ac>
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	68 3b 52 80 00       	push   $0x80523b
  802147:	68 df 00 00 00       	push   $0xdf
  80214c:	68 cc 51 80 00       	push   $0x8051cc
  802151:	e8 6f e5 ff ff       	call   8006c5 <_panic>
  802156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802159:	8b 40 08             	mov    0x8(%eax),%eax
  80215c:	85 c0                	test   %eax,%eax
  80215e:	74 11                	je     802171 <free+0x2c7>
  802160:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802163:	8b 40 08             	mov    0x8(%eax),%eax
  802166:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802169:	8b 52 0c             	mov    0xc(%edx),%edx
  80216c:	89 50 0c             	mov    %edx,0xc(%eax)
  80216f:	eb 0b                	jmp    80217c <free+0x2d2>
  802171:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802174:	8b 40 0c             	mov    0xc(%eax),%eax
  802177:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80217c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217f:	8b 40 0c             	mov    0xc(%eax),%eax
  802182:	85 c0                	test   %eax,%eax
  802184:	74 11                	je     802197 <free+0x2ed>
  802186:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802189:	8b 40 0c             	mov    0xc(%eax),%eax
  80218c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80218f:	8b 52 08             	mov    0x8(%edx),%edx
  802192:	89 50 08             	mov    %edx,0x8(%eax)
  802195:	eb 0b                	jmp    8021a2 <free+0x2f8>
  802197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219a:	8b 40 08             	mov    0x8(%eax),%eax
  80219d:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8021a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8021ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8021b6:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8021bb:	48                   	dec    %eax
  8021bc:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  8021c1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  8021c8:	eb 13                	jmp    8021dd <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8021ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021cd:	8b 40 08             	mov    0x8(%eax),%eax
  8021d0:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  8021d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021d7:	0f 85 24 ff ff ff    	jne    802101 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  8021dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021e0:	8b 10                	mov    (%eax),%edx
  8021e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021e5:	8b 40 04             	mov    0x4(%eax),%eax
  8021e8:	01 c2                	add    %eax,%edx
  8021ea:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8021ef:	39 c2                	cmp    %eax,%edx
  8021f1:	75 44                	jne    802237 <free+0x38d>

			if(mergeprev){
  8021f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021f7:	74 1f                	je     802218 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  8021f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021fc:	8b 00                	mov    (%eax),%eax
  8021fe:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802203:	83 ec 0c             	sub    $0xc,%esp
  802206:	68 40 e1 81 00       	push   $0x81e140
  80220b:	e8 46 21 00 00       	call   804356 <release_uspinlock>
  802210:	83 c4 10             	add    $0x10,%esp
				return;
  802213:	e9 20 04 00 00       	jmp    802638 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  802218:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80221b:	8b 00                	mov    (%eax),%eax
  80221d:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802222:	83 ec 0c             	sub    $0xc,%esp
  802225:	68 40 e1 81 00       	push   $0x81e140
  80222a:	e8 27 21 00 00       	call   804356 <release_uspinlock>
  80222f:	83 c4 10             	add    $0x10,%esp
				return;
  802232:	e9 01 04 00 00       	jmp    802638 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  802237:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80223c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  80223f:	e9 7d 01 00 00       	jmp    8023c1 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  802244:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802247:	8b 10                	mov    (%eax),%edx
  802249:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80224c:	8b 40 04             	mov    0x4(%eax),%eax
  80224f:	01 c2                	add    %eax,%edx
  802251:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802254:	8b 00                	mov    (%eax),%eax
  802256:	39 c2                	cmp    %eax,%edx
  802258:	0f 85 5a 01 00 00    	jne    8023b8 <free+0x50e>
				if (mergeprev){
  80225e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802262:	0f 84 a1 00 00 00    	je     802309 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  802268:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80226b:	8b 50 04             	mov    0x4(%eax),%edx
  80226e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802271:	8b 40 04             	mov    0x4(%eax),%eax
  802274:	01 c2                	add    %eax,%edx
  802276:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802279:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  80227c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802280:	75 17                	jne    802299 <free+0x3ef>
  802282:	83 ec 04             	sub    $0x4,%esp
  802285:	68 3b 52 80 00       	push   $0x80523b
  80228a:	68 0a 01 00 00       	push   $0x10a
  80228f:	68 cc 51 80 00       	push   $0x8051cc
  802294:	e8 2c e4 ff ff       	call   8006c5 <_panic>
  802299:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229c:	8b 40 08             	mov    0x8(%eax),%eax
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	74 11                	je     8022b4 <free+0x40a>
  8022a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a6:	8b 40 08             	mov    0x8(%eax),%eax
  8022a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022ac:	8b 52 0c             	mov    0xc(%edx),%edx
  8022af:	89 50 0c             	mov    %edx,0xc(%eax)
  8022b2:	eb 0b                	jmp    8022bf <free+0x415>
  8022b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ba:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8022bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 11                	je     8022da <free+0x430>
  8022c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8022cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022d2:	8b 52 08             	mov    0x8(%edx),%edx
  8022d5:	89 50 08             	mov    %edx,0x8(%eax)
  8022d8:	eb 0b                	jmp    8022e5 <free+0x43b>
  8022da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022dd:	8b 40 08             	mov    0x8(%eax),%eax
  8022e0:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8022e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8022f9:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8022fe:	48                   	dec    %eax
  8022ff:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  802304:	e9 c2 00 00 00       	jmp    8023cb <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  802309:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80230c:	8b 10                	mov    (%eax),%edx
  80230e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802311:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  802313:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802316:	8b 50 04             	mov    0x4(%eax),%edx
  802319:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231c:	8b 40 04             	mov    0x4(%eax),%eax
  80231f:	01 c2                	add    %eax,%edx
  802321:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802324:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802327:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80232b:	75 17                	jne    802344 <free+0x49a>
  80232d:	83 ec 04             	sub    $0x4,%esp
  802330:	68 3b 52 80 00       	push   $0x80523b
  802335:	68 10 01 00 00       	push   $0x110
  80233a:	68 cc 51 80 00       	push   $0x8051cc
  80233f:	e8 81 e3 ff ff       	call   8006c5 <_panic>
  802344:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802347:	8b 40 08             	mov    0x8(%eax),%eax
  80234a:	85 c0                	test   %eax,%eax
  80234c:	74 11                	je     80235f <free+0x4b5>
  80234e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802351:	8b 40 08             	mov    0x8(%eax),%eax
  802354:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802357:	8b 52 0c             	mov    0xc(%edx),%edx
  80235a:	89 50 0c             	mov    %edx,0xc(%eax)
  80235d:	eb 0b                	jmp    80236a <free+0x4c0>
  80235f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802362:	8b 40 0c             	mov    0xc(%eax),%eax
  802365:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80236a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236d:	8b 40 0c             	mov    0xc(%eax),%eax
  802370:	85 c0                	test   %eax,%eax
  802372:	74 11                	je     802385 <free+0x4db>
  802374:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802377:	8b 40 0c             	mov    0xc(%eax),%eax
  80237a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80237d:	8b 52 08             	mov    0x8(%edx),%edx
  802380:	89 50 08             	mov    %edx,0x8(%eax)
  802383:	eb 0b                	jmp    802390 <free+0x4e6>
  802385:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802388:	8b 40 08             	mov    0x8(%eax),%eax
  80238b:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802390:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802393:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80239a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8023a4:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8023a9:	48                   	dec    %eax
  8023aa:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  8023af:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8023b6:	eb 13                	jmp    8023cb <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8023b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bb:	8b 40 08             	mov    0x8(%eax),%eax
  8023be:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  8023c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023c5:	0f 85 79 fe ff ff    	jne    802244 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  8023cb:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8023d0:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  8023d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023d7:	0f 85 ad 00 00 00    	jne    80248a <free+0x5e0>
  8023dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023e1:	0f 84 c3 01 00 00    	je     8025aa <free+0x700>
				while(currentfree != NULL){
  8023e7:	e9 9e 00 00 00       	jmp    80248a <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8023ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023ef:	8b 50 04             	mov    0x4(%eax),%edx
  8023f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f5:	8b 40 04             	mov    0x4(%eax),%eax
  8023f8:	39 c2                	cmp    %eax,%edx
  8023fa:	0f 83 81 00 00 00    	jae    802481 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  802400:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802404:	74 06                	je     80240c <free+0x562>
  802406:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80240a:	75 17                	jne    802423 <free+0x579>
  80240c:	83 ec 04             	sub    $0x4,%esp
  80240f:	68 5c 52 80 00       	push   $0x80525c
  802414:	68 23 01 00 00       	push   $0x123
  802419:	68 cc 51 80 00       	push   $0x8051cc
  80241e:	e8 a2 e2 ff ff       	call   8006c5 <_panic>
  802423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802426:	8b 50 0c             	mov    0xc(%eax),%edx
  802429:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80242c:	89 50 0c             	mov    %edx,0xc(%eax)
  80242f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802432:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802435:	89 50 08             	mov    %edx,0x8(%eax)
  802438:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80243b:	8b 40 0c             	mov    0xc(%eax),%eax
  80243e:	85 c0                	test   %eax,%eax
  802440:	74 0e                	je     802450 <free+0x5a6>
  802442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802445:	8b 40 0c             	mov    0xc(%eax),%eax
  802448:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80244b:	89 50 08             	mov    %edx,0x8(%eax)
  80244e:	eb 08                	jmp    802458 <free+0x5ae>
  802450:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802453:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802458:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80245b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80245e:	89 50 0c             	mov    %edx,0xc(%eax)
  802461:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802466:	40                   	inc    %eax
  802467:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  80246c:	83 ec 0c             	sub    $0xc,%esp
  80246f:	68 40 e1 81 00       	push   $0x81e140
  802474:	e8 dd 1e 00 00       	call   804356 <release_uspinlock>
  802479:	83 c4 10             	add    $0x10,%esp
							return;
  80247c:	e9 b7 01 00 00       	jmp    802638 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802484:	8b 40 08             	mov    0x8(%eax),%eax
  802487:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  80248a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80248e:	0f 85 58 ff ff ff    	jne    8023ec <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802494:	83 ec 0c             	sub    $0xc,%esp
  802497:	ff 75 d4             	pushl  -0x2c(%ebp)
  80249a:	e8 d5 19 00 00       	call   803e74 <free_block>
  80249f:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8024a2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8024a6:	75 17                	jne    8024bf <free+0x615>
  8024a8:	83 ec 04             	sub    $0x4,%esp
  8024ab:	68 18 52 80 00       	push   $0x805218
  8024b0:	68 2a 01 00 00       	push   $0x12a
  8024b5:	68 cc 51 80 00       	push   $0x8051cc
  8024ba:	e8 06 e2 ff ff       	call   8006c5 <_panic>
  8024bf:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  8024c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024c8:	89 50 0c             	mov    %edx,0xc(%eax)
  8024cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 0d                	je     8024e2 <free+0x638>
  8024d5:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8024da:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8024dd:	89 50 08             	mov    %edx,0x8(%eax)
  8024e0:	eb 08                	jmp    8024ea <free+0x640>
  8024e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024e5:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8024ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024ed:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8024f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8024fc:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802501:	40                   	inc    %eax
  802502:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  802507:	e9 1b 01 00 00       	jmp    802627 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  80250c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80250f:	8b 50 04             	mov    0x4(%eax),%edx
  802512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802515:	8b 40 04             	mov    0x4(%eax),%eax
  802518:	39 c2                	cmp    %eax,%edx
  80251a:	0f 83 81 00 00 00    	jae    8025a1 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  802520:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802524:	74 06                	je     80252c <free+0x682>
  802526:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80252a:	75 17                	jne    802543 <free+0x699>
  80252c:	83 ec 04             	sub    $0x4,%esp
  80252f:	68 5c 52 80 00       	push   $0x80525c
  802534:	68 30 01 00 00       	push   $0x130
  802539:	68 cc 51 80 00       	push   $0x8051cc
  80253e:	e8 82 e1 ff ff       	call   8006c5 <_panic>
  802543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802546:	8b 50 0c             	mov    0xc(%eax),%edx
  802549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80254c:	89 50 0c             	mov    %edx,0xc(%eax)
  80254f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802552:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802555:	89 50 08             	mov    %edx,0x8(%eax)
  802558:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80255b:	8b 40 0c             	mov    0xc(%eax),%eax
  80255e:	85 c0                	test   %eax,%eax
  802560:	74 0e                	je     802570 <free+0x6c6>
  802562:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802565:	8b 40 0c             	mov    0xc(%eax),%eax
  802568:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80256b:	89 50 08             	mov    %edx,0x8(%eax)
  80256e:	eb 08                	jmp    802578 <free+0x6ce>
  802570:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802573:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802578:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80257e:	89 50 0c             	mov    %edx,0xc(%eax)
  802581:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802586:	40                   	inc    %eax
  802587:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  80258c:	83 ec 0c             	sub    $0xc,%esp
  80258f:	68 40 e1 81 00       	push   $0x81e140
  802594:	e8 bd 1d 00 00       	call   804356 <release_uspinlock>
  802599:	83 c4 10             	add    $0x10,%esp
							return;
  80259c:	e9 97 00 00 00       	jmp    802638 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8025a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a4:	8b 40 08             	mov    0x8(%eax),%eax
  8025a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  8025aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8025ae:	0f 85 58 ff ff ff    	jne    80250c <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8025b4:	83 ec 0c             	sub    $0xc,%esp
  8025b7:	ff 75 d0             	pushl  -0x30(%ebp)
  8025ba:	e8 b5 18 00 00       	call   803e74 <free_block>
  8025bf:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8025c2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8025c6:	75 17                	jne    8025df <free+0x735>
  8025c8:	83 ec 04             	sub    $0x4,%esp
  8025cb:	68 18 52 80 00       	push   $0x805218
  8025d0:	68 37 01 00 00       	push   $0x137
  8025d5:	68 cc 51 80 00       	push   $0x8051cc
  8025da:	e8 e6 e0 ff ff       	call   8006c5 <_panic>
  8025df:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  8025e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025e8:	89 50 0c             	mov    %edx,0xc(%eax)
  8025eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	74 0d                	je     802602 <free+0x758>
  8025f5:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8025fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8025fd:	89 50 08             	mov    %edx,0x8(%eax)
  802600:	eb 08                	jmp    80260a <free+0x760>
  802602:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802605:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80260a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80260d:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802612:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802615:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80261c:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802621:	40                   	inc    %eax
  802622:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  802627:	83 ec 0c             	sub    $0xc,%esp
  80262a:	68 40 e1 81 00       	push   $0x81e140
  80262f:	e8 22 1d 00 00       	call   804356 <release_uspinlock>
  802634:	83 c4 10             	add    $0x10,%esp
		return;
  802637:	90                   	nop
}
  802638:	c9                   	leave  
  802639:	c3                   	ret    

0080263a <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80263a:	55                   	push   %ebp
  80263b:	89 e5                	mov    %esp,%ebp
  80263d:	83 ec 48             	sub    $0x48,%esp
  802640:	8b 45 10             	mov    0x10(%ebp),%eax
  802643:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802646:	e8 2d f2 ff ff       	call   801878 <uheap_init>
	if (size == 0) return NULL;
  80264b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80264f:	75 0a                	jne    80265b <smalloc+0x21>
  802651:	b8 00 00 00 00       	mov    $0x0,%eax
  802656:	e9 84 05 00 00       	jmp    802bdf <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  80265b:	83 ec 0c             	sub    $0xc,%esp
  80265e:	68 40 e1 81 00       	push   $0x81e140
  802663:	e8 96 1c 00 00       	call   8042fe <acquire_uspinlock>
  802668:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80266b:	83 ec 0c             	sub    $0xc,%esp
  80266e:	6a 10                	push   $0x10
  802670:	e8 63 13 00 00       	call   8039d8 <alloc_block>
  802675:	83 c4 10             	add    $0x10,%esp
  802678:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  80267b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80267f:	75 0a                	jne    80268b <smalloc+0x51>
				return NULL;
  802681:	b8 00 00 00 00       	mov    $0x0,%eax
  802686:	e9 54 05 00 00       	jmp    802bdf <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  80268b:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802692:	8b 55 0c             	mov    0xc(%ebp),%edx
  802695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802698:	01 d0                	add    %edx,%eax
  80269a:	48                   	dec    %eax
  80269b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80269e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a6:	f7 75 e8             	divl   -0x18(%ebp)
  8026a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ac:	29 d0                	sub    %edx,%eax
  8026ae:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8026b1:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8026b6:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8026b9:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	74 0f                	je     8026d1 <smalloc+0x97>
  8026c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c5:	8b 40 04             	mov    0x4(%eax),%eax
  8026c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8026cb:	0f 83 25 01 00 00    	jae    8027f6 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8026d1:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8026d6:	2b 45 0c             	sub    0xc(%ebp),%eax
  8026d9:	89 c2                	mov    %eax,%edx
  8026db:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8026e0:	39 c2                	cmp    %eax,%edx
  8026e2:	0f 82 f4 00 00 00    	jb     8027dc <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  8026e8:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8026ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  8026f0:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8026f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f9:	01 d0                	add    %edx,%eax
  8026fb:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802700:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802703:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802706:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802708:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270e:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802711:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802715:	75 17                	jne    80272e <smalloc+0xf4>
  802717:	83 ec 04             	sub    $0x4,%esp
  80271a:	68 18 52 80 00       	push   $0x805218
  80271f:	68 57 01 00 00       	push   $0x157
  802724:	68 cc 51 80 00       	push   $0x8051cc
  802729:	e8 97 df ff ff       	call   8006c5 <_panic>
  80272e:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802737:	89 50 0c             	mov    %edx,0xc(%eax)
  80273a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273d:	8b 40 0c             	mov    0xc(%eax),%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	74 0d                	je     802751 <smalloc+0x117>
  802744:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802749:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80274c:	89 50 08             	mov    %edx,0x8(%eax)
  80274f:	eb 08                	jmp    802759 <smalloc+0x11f>
  802751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802754:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275c:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802761:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802764:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80276b:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802770:	40                   	inc    %eax
  802771:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802776:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	89 c2                	mov    %eax,%edx
  80277d:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802781:	52                   	push   %edx
  802782:	50                   	push   %eax
  802783:	ff 75 0c             	pushl  0xc(%ebp)
  802786:	ff 75 08             	pushl  0x8(%ebp)
  802789:	e8 48 0c 00 00       	call   8033d6 <sys_create_shared_object>
  80278e:	83 c4 10             	add    $0x10,%esp
  802791:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802794:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802798:	79 28                	jns    8027c2 <smalloc+0x188>
							free_block(allocblock);
  80279a:	83 ec 0c             	sub    $0xc,%esp
  80279d:	ff 75 ec             	pushl  -0x14(%ebp)
  8027a0:	e8 cf 16 00 00       	call   803e74 <free_block>
  8027a5:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8027a8:	83 ec 0c             	sub    $0xc,%esp
  8027ab:	68 40 e1 81 00       	push   $0x81e140
  8027b0:	e8 a1 1b 00 00       	call   804356 <release_uspinlock>
  8027b5:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8027b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bd:	e9 1d 04 00 00       	jmp    802bdf <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  8027c2:	83 ec 0c             	sub    $0xc,%esp
  8027c5:	68 40 e1 81 00       	push   $0x81e140
  8027ca:	e8 87 1b 00 00       	call   804356 <release_uspinlock>
  8027cf:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8027d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	e9 03 04 00 00       	jmp    802bdf <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  8027dc:	83 ec 0c             	sub    $0xc,%esp
  8027df:	68 40 e1 81 00       	push   $0x81e140
  8027e4:	e8 6d 1b 00 00       	call   804356 <release_uspinlock>
  8027e9:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8027ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f1:	e9 e9 03 00 00       	jmp    802bdf <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8027f6:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8027fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8027fe:	e9 af 03 00 00       	jmp    802bb2 <smalloc+0x578>
				if(size<currentfreeelement->size){
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80280c:	0f 86 28 02 00 00    	jbe    802a3a <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802815:	8b 10                	mov    (%eax),%edx
  802817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281a:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  80281c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802822:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802825:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802829:	75 17                	jne    802842 <smalloc+0x208>
  80282b:	83 ec 04             	sub    $0x4,%esp
  80282e:	68 18 52 80 00       	push   $0x805218
  802833:	68 6f 01 00 00       	push   $0x16f
  802838:	68 cc 51 80 00       	push   $0x8051cc
  80283d:	e8 83 de ff ff       	call   8006c5 <_panic>
  802842:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284b:	89 50 0c             	mov    %edx,0xc(%eax)
  80284e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802851:	8b 40 0c             	mov    0xc(%eax),%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	74 0d                	je     802865 <smalloc+0x22b>
  802858:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80285d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802860:	89 50 08             	mov    %edx,0x8(%eax)
  802863:	eb 08                	jmp    80286d <smalloc+0x233>
  802865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802868:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80286d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802870:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802878:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80287f:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802884:	40                   	inc    %eax
  802885:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  80288a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288d:	8b 10                	mov    (%eax),%edx
  80288f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802892:	01 c2                	add    %eax,%edx
  802894:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802897:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802899:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289c:	8b 40 04             	mov    0x4(%eax),%eax
  80289f:	2b 45 0c             	sub    0xc(%ebp),%eax
  8028a2:	89 c2                	mov    %eax,%edx
  8028a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a7:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8028aa:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8028af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  8028b2:	e9 13 01 00 00       	jmp    8029ca <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  8028b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ba:	8b 50 04             	mov    0x4(%eax),%edx
  8028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c0:	8b 40 04             	mov    0x4(%eax),%eax
  8028c3:	39 c2                	cmp    %eax,%edx
  8028c5:	0f 83 f6 00 00 00    	jae    8029c1 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8028cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028cf:	75 17                	jne    8028e8 <smalloc+0x2ae>
  8028d1:	83 ec 04             	sub    $0x4,%esp
  8028d4:	68 3b 52 80 00       	push   $0x80523b
  8028d9:	68 77 01 00 00       	push   $0x177
  8028de:	68 cc 51 80 00       	push   $0x8051cc
  8028e3:	e8 dd dd ff ff       	call   8006c5 <_panic>
  8028e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028eb:	8b 40 08             	mov    0x8(%eax),%eax
  8028ee:	85 c0                	test   %eax,%eax
  8028f0:	74 11                	je     802903 <smalloc+0x2c9>
  8028f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f5:	8b 40 08             	mov    0x8(%eax),%eax
  8028f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028fb:	8b 52 0c             	mov    0xc(%edx),%edx
  8028fe:	89 50 0c             	mov    %edx,0xc(%eax)
  802901:	eb 0b                	jmp    80290e <smalloc+0x2d4>
  802903:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802906:	8b 40 0c             	mov    0xc(%eax),%eax
  802909:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80290e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802911:	8b 40 0c             	mov    0xc(%eax),%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	74 11                	je     802929 <smalloc+0x2ef>
  802918:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291b:	8b 40 0c             	mov    0xc(%eax),%eax
  80291e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802921:	8b 52 08             	mov    0x8(%edx),%edx
  802924:	89 50 08             	mov    %edx,0x8(%eax)
  802927:	eb 0b                	jmp    802934 <smalloc+0x2fa>
  802929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292c:	8b 40 08             	mov    0x8(%eax),%eax
  80292f:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802934:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802937:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80293e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802941:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802948:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80294d:	48                   	dec    %eax
  80294e:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802953:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802957:	74 06                	je     80295f <smalloc+0x325>
  802959:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80295d:	75 17                	jne    802976 <smalloc+0x33c>
  80295f:	83 ec 04             	sub    $0x4,%esp
  802962:	68 5c 52 80 00       	push   $0x80525c
  802967:	68 78 01 00 00       	push   $0x178
  80296c:	68 cc 51 80 00       	push   $0x8051cc
  802971:	e8 4f dd ff ff       	call   8006c5 <_panic>
  802976:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802979:	8b 50 0c             	mov    0xc(%eax),%edx
  80297c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80297f:	89 50 0c             	mov    %edx,0xc(%eax)
  802982:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802985:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802988:	89 50 08             	mov    %edx,0x8(%eax)
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	8b 40 0c             	mov    0xc(%eax),%eax
  802991:	85 c0                	test   %eax,%eax
  802993:	74 0e                	je     8029a3 <smalloc+0x369>
  802995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802998:	8b 40 0c             	mov    0xc(%eax),%eax
  80299b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80299e:	89 50 08             	mov    %edx,0x8(%eax)
  8029a1:	eb 08                	jmp    8029ab <smalloc+0x371>
  8029a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a6:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029b1:	89 50 0c             	mov    %edx,0xc(%eax)
  8029b4:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8029b9:	40                   	inc    %eax
  8029ba:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  8029bf:	eb 13                	jmp    8029d4 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  8029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c4:	8b 40 08             	mov    0x8(%eax),%eax
  8029c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  8029ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ce:	0f 85 e3 fe ff ff    	jne    8028b7 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8029d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	89 c2                	mov    %eax,%edx
  8029db:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8029df:	52                   	push   %edx
  8029e0:	50                   	push   %eax
  8029e1:	ff 75 0c             	pushl  0xc(%ebp)
  8029e4:	ff 75 08             	pushl  0x8(%ebp)
  8029e7:	e8 ea 09 00 00       	call   8033d6 <sys_create_shared_object>
  8029ec:	83 c4 10             	add    $0x10,%esp
  8029ef:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  8029f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8029f6:	79 28                	jns    802a20 <smalloc+0x3e6>
	                	free_block(allocblock);
  8029f8:	83 ec 0c             	sub    $0xc,%esp
  8029fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8029fe:	e8 71 14 00 00       	call   803e74 <free_block>
  802a03:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802a06:	83 ec 0c             	sub    $0xc,%esp
  802a09:	68 40 e1 81 00       	push   $0x81e140
  802a0e:	e8 43 19 00 00       	call   804356 <release_uspinlock>
  802a13:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802a16:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1b:	e9 bf 01 00 00       	jmp    802bdf <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802a20:	83 ec 0c             	sub    $0xc,%esp
  802a23:	68 40 e1 81 00       	push   $0x81e140
  802a28:	e8 29 19 00 00       	call   804356 <release_uspinlock>
  802a2d:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	e9 a5 01 00 00       	jmp    802bdf <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a43:	0f 85 60 01 00 00    	jne    802ba9 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 10                	mov    (%eax),%edx
  802a4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a51:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a59:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802a5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a60:	75 17                	jne    802a79 <smalloc+0x43f>
  802a62:	83 ec 04             	sub    $0x4,%esp
  802a65:	68 18 52 80 00       	push   $0x805218
  802a6a:	68 8c 01 00 00       	push   $0x18c
  802a6f:	68 cc 51 80 00       	push   $0x8051cc
  802a74:	e8 4c dc ff ff       	call   8006c5 <_panic>
  802a79:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a82:	89 50 0c             	mov    %edx,0xc(%eax)
  802a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a88:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 0d                	je     802a9c <smalloc+0x462>
  802a8f:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802a94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a97:	89 50 08             	mov    %edx,0x8(%eax)
  802a9a:	eb 08                	jmp    802aa4 <smalloc+0x46a>
  802a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9f:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa7:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802aac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aaf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ab6:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802abb:	40                   	inc    %eax
  802abc:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac5:	75 17                	jne    802ade <smalloc+0x4a4>
  802ac7:	83 ec 04             	sub    $0x4,%esp
  802aca:	68 3b 52 80 00       	push   $0x80523b
  802acf:	68 8d 01 00 00       	push   $0x18d
  802ad4:	68 cc 51 80 00       	push   $0x8051cc
  802ad9:	e8 e7 db ff ff       	call   8006c5 <_panic>
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	8b 40 08             	mov    0x8(%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 11                	je     802af9 <smalloc+0x4bf>
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 40 08             	mov    0x8(%eax),%eax
  802aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af1:	8b 52 0c             	mov    0xc(%edx),%edx
  802af4:	89 50 0c             	mov    %edx,0xc(%eax)
  802af7:	eb 0b                	jmp    802b04 <smalloc+0x4ca>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 40 0c             	mov    0xc(%eax),%eax
  802aff:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	74 11                	je     802b1f <smalloc+0x4e5>
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 40 0c             	mov    0xc(%eax),%eax
  802b14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b17:	8b 52 08             	mov    0x8(%edx),%edx
  802b1a:	89 50 08             	mov    %edx,0x8(%eax)
  802b1d:	eb 0b                	jmp    802b2a <smalloc+0x4f0>
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 40 08             	mov    0x8(%eax),%eax
  802b25:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b3e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802b43:	48                   	dec    %eax
  802b44:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	89 c2                	mov    %eax,%edx
  802b50:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802b54:	52                   	push   %edx
  802b55:	50                   	push   %eax
  802b56:	ff 75 0c             	pushl  0xc(%ebp)
  802b59:	ff 75 08             	pushl  0x8(%ebp)
  802b5c:	e8 75 08 00 00       	call   8033d6 <sys_create_shared_object>
  802b61:	83 c4 10             	add    $0x10,%esp
  802b64:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802b67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b6b:	79 25                	jns    802b92 <smalloc+0x558>
						free_block(allocblock);
  802b6d:	83 ec 0c             	sub    $0xc,%esp
  802b70:	ff 75 ec             	pushl  -0x14(%ebp)
  802b73:	e8 fc 12 00 00       	call   803e74 <free_block>
  802b78:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802b7b:	83 ec 0c             	sub    $0xc,%esp
  802b7e:	68 40 e1 81 00       	push   $0x81e140
  802b83:	e8 ce 17 00 00       	call   804356 <release_uspinlock>
  802b88:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b90:	eb 4d                	jmp    802bdf <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802b92:	83 ec 0c             	sub    $0xc,%esp
  802b95:	68 40 e1 81 00       	push   $0x81e140
  802b9a:	e8 b7 17 00 00       	call   804356 <release_uspinlock>
  802b9f:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	eb 36                	jmp    802bdf <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 40 08             	mov    0x8(%eax),%eax
  802baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802bb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb6:	0f 85 47 fc ff ff    	jne    802803 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802bbc:	83 ec 0c             	sub    $0xc,%esp
  802bbf:	ff 75 ec             	pushl  -0x14(%ebp)
  802bc2:	e8 ad 12 00 00       	call   803e74 <free_block>
  802bc7:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802bca:	83 ec 0c             	sub    $0xc,%esp
  802bcd:	68 40 e1 81 00       	push   $0x81e140
  802bd2:	e8 7f 17 00 00       	call   804356 <release_uspinlock>
  802bd7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802bda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bdf:	c9                   	leave  
  802be0:	c3                   	ret    

00802be1 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802be1:	55                   	push   %ebp
  802be2:	89 e5                	mov    %esp,%ebp
  802be4:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802be7:	e8 8c ec ff ff       	call   801878 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802bec:	83 ec 0c             	sub    $0xc,%esp
  802bef:	68 40 e1 81 00       	push   $0x81e140
  802bf4:	e8 05 17 00 00       	call   8042fe <acquire_uspinlock>
  802bf9:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802bfc:	83 ec 08             	sub    $0x8,%esp
  802bff:	ff 75 0c             	pushl  0xc(%ebp)
  802c02:	ff 75 08             	pushl  0x8(%ebp)
  802c05:	e8 f6 07 00 00       	call   803400 <sys_size_of_shared_object>
  802c0a:	83 c4 10             	add    $0x10,%esp
  802c0d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  802c10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c14:	79 1a                	jns    802c30 <sget+0x4f>
			release_uspinlock(&ulock);
  802c16:	83 ec 0c             	sub    $0xc,%esp
  802c19:	68 40 e1 81 00       	push   $0x81e140
  802c1e:	e8 33 17 00 00       	call   804356 <release_uspinlock>
  802c23:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802c26:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2b:	e9 6e 05 00 00       	jmp    80319e <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802c30:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802c37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c3d:	01 d0                	add    %edx,%eax
  802c3f:	48                   	dec    %eax
  802c40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c46:	ba 00 00 00 00       	mov    $0x0,%edx
  802c4b:	f7 75 e8             	divl   -0x18(%ebp)
  802c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c51:	29 d0                	sub    %edx,%eax
  802c53:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802c56:	83 ec 0c             	sub    $0xc,%esp
  802c59:	6a 10                	push   $0x10
  802c5b:	e8 78 0d 00 00       	call   8039d8 <alloc_block>
  802c60:	83 c4 10             	add    $0x10,%esp
  802c63:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802c66:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c6a:	75 0a                	jne    802c76 <sget+0x95>
			return NULL;
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c71:	e9 28 05 00 00       	jmp    80319e <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802c76:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802c7b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802c7e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	74 11                	je     802c98 <sget+0xb7>
  802c87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c8a:	8b 50 04             	mov    0x4(%eax),%edx
  802c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c90:	39 c2                	cmp    %eax,%edx
  802c92:	0f 83 21 01 00 00    	jae    802db9 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9b:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802ca0:	29 c2                	sub    %eax,%edx
  802ca2:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802ca7:	39 c2                	cmp    %eax,%edx
  802ca9:	0f 82 f0 00 00 00    	jb     802d9f <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802caf:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802cb4:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802cb7:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc0:	01 d0                	add    %edx,%eax
  802cc2:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cca:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ccd:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802ccf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd5:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802cd8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802cdc:	75 17                	jne    802cf5 <sget+0x114>
  802cde:	83 ec 04             	sub    $0x4,%esp
  802ce1:	68 18 52 80 00       	push   $0x805218
  802ce6:	68 c8 01 00 00       	push   $0x1c8
  802ceb:	68 cc 51 80 00       	push   $0x8051cc
  802cf0:	e8 d0 d9 ff ff       	call   8006c5 <_panic>
  802cf5:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cfe:	89 50 0c             	mov    %edx,0xc(%eax)
  802d01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d04:	8b 40 0c             	mov    0xc(%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 0d                	je     802d18 <sget+0x137>
  802d0b:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802d10:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d13:	89 50 08             	mov    %edx,0x8(%eax)
  802d16:	eb 08                	jmp    802d20 <sget+0x13f>
  802d18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1b:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802d20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d23:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d32:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802d37:	40                   	inc    %eax
  802d38:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802d3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	83 ec 04             	sub    $0x4,%esp
  802d45:	50                   	push   %eax
  802d46:	ff 75 0c             	pushl  0xc(%ebp)
  802d49:	ff 75 08             	pushl  0x8(%ebp)
  802d4c:	e8 cc 06 00 00       	call   80341d <sys_get_shared_object>
  802d51:	83 c4 10             	add    $0x10,%esp
  802d54:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802d57:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d5b:	79 28                	jns    802d85 <sget+0x1a4>
							free_block(allocblock);
  802d5d:	83 ec 0c             	sub    $0xc,%esp
  802d60:	ff 75 e0             	pushl  -0x20(%ebp)
  802d63:	e8 0c 11 00 00       	call   803e74 <free_block>
  802d68:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802d6b:	83 ec 0c             	sub    $0xc,%esp
  802d6e:	68 40 e1 81 00       	push   $0x81e140
  802d73:	e8 de 15 00 00       	call   804356 <release_uspinlock>
  802d78:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d80:	e9 19 04 00 00       	jmp    80319e <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802d85:	83 ec 0c             	sub    $0xc,%esp
  802d88:	68 40 e1 81 00       	push   $0x81e140
  802d8d:	e8 c4 15 00 00       	call   804356 <release_uspinlock>
  802d92:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802d95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	e9 ff 03 00 00       	jmp    80319e <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802d9f:	83 ec 0c             	sub    $0xc,%esp
  802da2:	68 40 e1 81 00       	push   $0x81e140
  802da7:	e8 aa 15 00 00       	call   804356 <release_uspinlock>
  802dac:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802daf:	b8 00 00 00 00       	mov    $0x0,%eax
  802db4:	e9 e5 03 00 00       	jmp    80319e <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802db9:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802dbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802dc1:	e9 ab 03 00 00       	jmp    803171 <sget+0x590>
				if(size<currentfreeelement->size){
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 50 04             	mov    0x4(%eax),%edx
  802dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcf:	39 c2                	cmp    %eax,%edx
  802dd1:	0f 86 24 02 00 00    	jbe    802ffb <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802dd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dda:	8b 10                	mov    (%eax),%edx
  802ddc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ddf:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802de1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802dea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dee:	75 17                	jne    802e07 <sget+0x226>
  802df0:	83 ec 04             	sub    $0x4,%esp
  802df3:	68 18 52 80 00       	push   $0x805218
  802df8:	68 e0 01 00 00       	push   $0x1e0
  802dfd:	68 cc 51 80 00       	push   $0x8051cc
  802e02:	e8 be d8 ff ff       	call   8006c5 <_panic>
  802e07:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e10:	89 50 0c             	mov    %edx,0xc(%eax)
  802e13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e16:	8b 40 0c             	mov    0xc(%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 0d                	je     802e2a <sget+0x249>
  802e1d:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802e22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e25:	89 50 08             	mov    %edx,0x8(%eax)
  802e28:	eb 08                	jmp    802e32 <sget+0x251>
  802e2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2d:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802e32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e35:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e44:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802e49:	40                   	inc    %eax
  802e4a:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  802e4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e52:	8b 10                	mov    (%eax),%edx
  802e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e57:	01 c2                	add    %eax,%edx
  802e59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e5c:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802e5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e61:	8b 50 04             	mov    0x4(%eax),%edx
  802e64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e67:	29 c2                	sub    %eax,%edx
  802e69:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e6c:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802e6f:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802e74:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802e77:	e9 13 01 00 00       	jmp    802f8f <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802e7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7f:	8b 50 04             	mov    0x4(%eax),%edx
  802e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e85:	8b 40 04             	mov    0x4(%eax),%eax
  802e88:	39 c2                	cmp    %eax,%edx
  802e8a:	0f 83 f6 00 00 00    	jae    802f86 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802e90:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e94:	75 17                	jne    802ead <sget+0x2cc>
  802e96:	83 ec 04             	sub    $0x4,%esp
  802e99:	68 3b 52 80 00       	push   $0x80523b
  802e9e:	68 e8 01 00 00       	push   $0x1e8
  802ea3:	68 cc 51 80 00       	push   $0x8051cc
  802ea8:	e8 18 d8 ff ff       	call   8006c5 <_panic>
  802ead:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb0:	8b 40 08             	mov    0x8(%eax),%eax
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	74 11                	je     802ec8 <sget+0x2e7>
  802eb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eba:	8b 40 08             	mov    0x8(%eax),%eax
  802ebd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ec0:	8b 52 0c             	mov    0xc(%edx),%edx
  802ec3:	89 50 0c             	mov    %edx,0xc(%eax)
  802ec6:	eb 0b                	jmp    802ed3 <sget+0x2f2>
  802ec8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ecb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ece:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802ed3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 11                	je     802eee <sget+0x30d>
  802edd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ee6:	8b 52 08             	mov    0x8(%edx),%edx
  802ee9:	89 50 08             	mov    %edx,0x8(%eax)
  802eec:	eb 0b                	jmp    802ef9 <sget+0x318>
  802eee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef1:	8b 40 08             	mov    0x8(%eax),%eax
  802ef4:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802ef9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802efc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f06:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f0d:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802f12:	48                   	dec    %eax
  802f13:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802f18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f1c:	74 06                	je     802f24 <sget+0x343>
  802f1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f22:	75 17                	jne    802f3b <sget+0x35a>
  802f24:	83 ec 04             	sub    $0x4,%esp
  802f27:	68 5c 52 80 00       	push   $0x80525c
  802f2c:	68 e9 01 00 00       	push   $0x1e9
  802f31:	68 cc 51 80 00       	push   $0x8051cc
  802f36:	e8 8a d7 ff ff       	call   8006c5 <_panic>
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f44:	89 50 0c             	mov    %edx,0xc(%eax)
  802f47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f4d:	89 50 08             	mov    %edx,0x8(%eax)
  802f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f53:	8b 40 0c             	mov    0xc(%eax),%eax
  802f56:	85 c0                	test   %eax,%eax
  802f58:	74 0e                	je     802f68 <sget+0x387>
  802f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f60:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f63:	89 50 08             	mov    %edx,0x8(%eax)
  802f66:	eb 08                	jmp    802f70 <sget+0x38f>
  802f68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f6b:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f73:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f76:	89 50 0c             	mov    %edx,0xc(%eax)
  802f79:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802f7e:	40                   	inc    %eax
  802f7f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  802f84:	eb 13                	jmp    802f99 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f89:	8b 40 08             	mov    0x8(%eax),%eax
  802f8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802f8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f93:	0f 85 e3 fe ff ff    	jne    802e7c <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802f99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f9c:	8b 00                	mov    (%eax),%eax
  802f9e:	83 ec 04             	sub    $0x4,%esp
  802fa1:	50                   	push   %eax
  802fa2:	ff 75 0c             	pushl  0xc(%ebp)
  802fa5:	ff 75 08             	pushl  0x8(%ebp)
  802fa8:	e8 70 04 00 00       	call   80341d <sys_get_shared_object>
  802fad:	83 c4 10             	add    $0x10,%esp
  802fb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802fb3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802fb7:	79 28                	jns    802fe1 <sget+0x400>
						free_block(allocblock);
  802fb9:	83 ec 0c             	sub    $0xc,%esp
  802fbc:	ff 75 e0             	pushl  -0x20(%ebp)
  802fbf:	e8 b0 0e 00 00       	call   803e74 <free_block>
  802fc4:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802fc7:	83 ec 0c             	sub    $0xc,%esp
  802fca:	68 40 e1 81 00       	push   $0x81e140
  802fcf:	e8 82 13 00 00       	call   804356 <release_uspinlock>
  802fd4:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdc:	e9 bd 01 00 00       	jmp    80319e <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802fe1:	83 ec 0c             	sub    $0xc,%esp
  802fe4:	68 40 e1 81 00       	push   $0x81e140
  802fe9:	e8 68 13 00 00       	call   804356 <release_uspinlock>
  802fee:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802ff1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff4:	8b 00                	mov    (%eax),%eax
  802ff6:	e9 a3 01 00 00       	jmp    80319e <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 50 04             	mov    0x4(%eax),%edx
  803001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803004:	39 c2                	cmp    %eax,%edx
  803006:	0f 85 5c 01 00 00    	jne    803168 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 10                	mov    (%eax),%edx
  803011:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803014:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803016:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803019:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301c:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  80301f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803023:	75 17                	jne    80303c <sget+0x45b>
  803025:	83 ec 04             	sub    $0x4,%esp
  803028:	68 18 52 80 00       	push   $0x805218
  80302d:	68 fe 01 00 00       	push   $0x1fe
  803032:	68 cc 51 80 00       	push   $0x8051cc
  803037:	e8 89 d6 ff ff       	call   8006c5 <_panic>
  80303c:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  803042:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803045:	89 50 0c             	mov    %edx,0xc(%eax)
  803048:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304b:	8b 40 0c             	mov    0xc(%eax),%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	74 0d                	je     80305f <sget+0x47e>
  803052:	a1 34 e1 81 00       	mov    0x81e134,%eax
  803057:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80305a:	89 50 08             	mov    %edx,0x8(%eax)
  80305d:	eb 08                	jmp    803067 <sget+0x486>
  80305f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803062:	a3 30 e1 81 00       	mov    %eax,0x81e130
  803067:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80306a:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80306f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803072:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803079:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80307e:	40                   	inc    %eax
  80307f:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803084:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803088:	75 17                	jne    8030a1 <sget+0x4c0>
  80308a:	83 ec 04             	sub    $0x4,%esp
  80308d:	68 3b 52 80 00       	push   $0x80523b
  803092:	68 ff 01 00 00       	push   $0x1ff
  803097:	68 cc 51 80 00       	push   $0x8051cc
  80309c:	e8 24 d6 ff ff       	call   8006c5 <_panic>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 40 08             	mov    0x8(%eax),%eax
  8030a7:	85 c0                	test   %eax,%eax
  8030a9:	74 11                	je     8030bc <sget+0x4db>
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 40 08             	mov    0x8(%eax),%eax
  8030b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b4:	8b 52 0c             	mov    0xc(%edx),%edx
  8030b7:	89 50 0c             	mov    %edx,0xc(%eax)
  8030ba:	eb 0b                	jmp    8030c7 <sget+0x4e6>
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c2:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cd:	85 c0                	test   %eax,%eax
  8030cf:	74 11                	je     8030e2 <sget+0x501>
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030da:	8b 52 08             	mov    0x8(%edx),%edx
  8030dd:	89 50 08             	mov    %edx,0x8(%eax)
  8030e0:	eb 0b                	jmp    8030ed <sget+0x50c>
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	8b 40 08             	mov    0x8(%eax),%eax
  8030e8:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803101:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803106:	48                   	dec    %eax
  803107:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80310c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80310f:	8b 00                	mov    (%eax),%eax
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	50                   	push   %eax
  803115:	ff 75 0c             	pushl  0xc(%ebp)
  803118:	ff 75 08             	pushl  0x8(%ebp)
  80311b:	e8 fd 02 00 00       	call   80341d <sys_get_shared_object>
  803120:	83 c4 10             	add    $0x10,%esp
  803123:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803126:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80312a:	79 25                	jns    803151 <sget+0x570>
						free_block(allocblock);
  80312c:	83 ec 0c             	sub    $0xc,%esp
  80312f:	ff 75 e0             	pushl  -0x20(%ebp)
  803132:	e8 3d 0d 00 00       	call   803e74 <free_block>
  803137:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  80313a:	83 ec 0c             	sub    $0xc,%esp
  80313d:	68 40 e1 81 00       	push   $0x81e140
  803142:	e8 0f 12 00 00       	call   804356 <release_uspinlock>
  803147:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80314a:	b8 00 00 00 00       	mov    $0x0,%eax
  80314f:	eb 4d                	jmp    80319e <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  803151:	83 ec 0c             	sub    $0xc,%esp
  803154:	68 40 e1 81 00       	push   $0x81e140
  803159:	e8 f8 11 00 00       	call   804356 <release_uspinlock>
  80315e:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803161:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	eb 36                	jmp    80319e <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	8b 40 08             	mov    0x8(%eax),%eax
  80316e:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803171:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803175:	0f 85 4b fc ff ff    	jne    802dc6 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  80317b:	83 ec 0c             	sub    $0xc,%esp
  80317e:	ff 75 e0             	pushl  -0x20(%ebp)
  803181:	e8 ee 0c 00 00       	call   803e74 <free_block>
  803186:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803189:	83 ec 0c             	sub    $0xc,%esp
  80318c:	68 40 e1 81 00       	push   $0x81e140
  803191:	e8 c0 11 00 00       	call   804356 <release_uspinlock>
  803196:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803199:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80319e:	c9                   	leave  
  80319f:	c3                   	ret    

008031a0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8031a0:	55                   	push   %ebp
  8031a1:	89 e5                	mov    %esp,%ebp
  8031a3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8031a6:	e8 cd e6 ff ff       	call   801878 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8031ab:	83 ec 04             	sub    $0x4,%esp
  8031ae:	68 ec 52 80 00       	push   $0x8052ec
  8031b3:	68 2d 02 00 00       	push   $0x22d
  8031b8:	68 cc 51 80 00       	push   $0x8051cc
  8031bd:	e8 03 d5 ff ff       	call   8006c5 <_panic>

008031c2 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8031c2:	55                   	push   %ebp
  8031c3:	89 e5                	mov    %esp,%ebp
  8031c5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8031c8:	83 ec 04             	sub    $0x4,%esp
  8031cb:	68 14 53 80 00       	push   $0x805314
  8031d0:	68 40 02 00 00       	push   $0x240
  8031d5:	68 cc 51 80 00       	push   $0x8051cc
  8031da:	e8 e6 d4 ff ff       	call   8006c5 <_panic>

008031df <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8031df:	55                   	push   %ebp
  8031e0:	89 e5                	mov    %esp,%ebp
  8031e2:	57                   	push   %edi
  8031e3:	56                   	push   %esi
  8031e4:	53                   	push   %ebx
  8031e5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8031f4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8031f7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8031fa:	cd 30                	int    $0x30
  8031fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8031ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803202:	83 c4 10             	add    $0x10,%esp
  803205:	5b                   	pop    %ebx
  803206:	5e                   	pop    %esi
  803207:	5f                   	pop    %edi
  803208:	5d                   	pop    %ebp
  803209:	c3                   	ret    

0080320a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80320a:	55                   	push   %ebp
  80320b:	89 e5                	mov    %esp,%ebp
  80320d:	83 ec 04             	sub    $0x4,%esp
  803210:	8b 45 10             	mov    0x10(%ebp),%eax
  803213:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803216:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803219:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	6a 00                	push   $0x0
  803222:	51                   	push   %ecx
  803223:	52                   	push   %edx
  803224:	ff 75 0c             	pushl  0xc(%ebp)
  803227:	50                   	push   %eax
  803228:	6a 00                	push   $0x0
  80322a:	e8 b0 ff ff ff       	call   8031df <syscall>
  80322f:	83 c4 18             	add    $0x18,%esp
}
  803232:	90                   	nop
  803233:	c9                   	leave  
  803234:	c3                   	ret    

00803235 <sys_cgetc>:

int
sys_cgetc(void)
{
  803235:	55                   	push   %ebp
  803236:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803238:	6a 00                	push   $0x0
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 00                	push   $0x0
  803240:	6a 00                	push   $0x0
  803242:	6a 02                	push   $0x2
  803244:	e8 96 ff ff ff       	call   8031df <syscall>
  803249:	83 c4 18             	add    $0x18,%esp
}
  80324c:	c9                   	leave  
  80324d:	c3                   	ret    

0080324e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80324e:	55                   	push   %ebp
  80324f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803251:	6a 00                	push   $0x0
  803253:	6a 00                	push   $0x0
  803255:	6a 00                	push   $0x0
  803257:	6a 00                	push   $0x0
  803259:	6a 00                	push   $0x0
  80325b:	6a 03                	push   $0x3
  80325d:	e8 7d ff ff ff       	call   8031df <syscall>
  803262:	83 c4 18             	add    $0x18,%esp
}
  803265:	90                   	nop
  803266:	c9                   	leave  
  803267:	c3                   	ret    

00803268 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803268:	55                   	push   %ebp
  803269:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80326b:	6a 00                	push   $0x0
  80326d:	6a 00                	push   $0x0
  80326f:	6a 00                	push   $0x0
  803271:	6a 00                	push   $0x0
  803273:	6a 00                	push   $0x0
  803275:	6a 04                	push   $0x4
  803277:	e8 63 ff ff ff       	call   8031df <syscall>
  80327c:	83 c4 18             	add    $0x18,%esp
}
  80327f:	90                   	nop
  803280:	c9                   	leave  
  803281:	c3                   	ret    

00803282 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803282:	55                   	push   %ebp
  803283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803285:	8b 55 0c             	mov    0xc(%ebp),%edx
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	6a 00                	push   $0x0
  80328d:	6a 00                	push   $0x0
  80328f:	6a 00                	push   $0x0
  803291:	52                   	push   %edx
  803292:	50                   	push   %eax
  803293:	6a 08                	push   $0x8
  803295:	e8 45 ff ff ff       	call   8031df <syscall>
  80329a:	83 c4 18             	add    $0x18,%esp
}
  80329d:	c9                   	leave  
  80329e:	c3                   	ret    

0080329f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80329f:	55                   	push   %ebp
  8032a0:	89 e5                	mov    %esp,%ebp
  8032a2:	56                   	push   %esi
  8032a3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8032a4:	8b 75 18             	mov    0x18(%ebp),%esi
  8032a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b3:	56                   	push   %esi
  8032b4:	53                   	push   %ebx
  8032b5:	51                   	push   %ecx
  8032b6:	52                   	push   %edx
  8032b7:	50                   	push   %eax
  8032b8:	6a 09                	push   $0x9
  8032ba:	e8 20 ff ff ff       	call   8031df <syscall>
  8032bf:	83 c4 18             	add    $0x18,%esp
}
  8032c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032c5:	5b                   	pop    %ebx
  8032c6:	5e                   	pop    %esi
  8032c7:	5d                   	pop    %ebp
  8032c8:	c3                   	ret    

008032c9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8032c9:	55                   	push   %ebp
  8032ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8032cc:	6a 00                	push   $0x0
  8032ce:	6a 00                	push   $0x0
  8032d0:	6a 00                	push   $0x0
  8032d2:	6a 00                	push   $0x0
  8032d4:	ff 75 08             	pushl  0x8(%ebp)
  8032d7:	6a 0a                	push   $0xa
  8032d9:	e8 01 ff ff ff       	call   8031df <syscall>
  8032de:	83 c4 18             	add    $0x18,%esp
}
  8032e1:	c9                   	leave  
  8032e2:	c3                   	ret    

008032e3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8032e6:	6a 00                	push   $0x0
  8032e8:	6a 00                	push   $0x0
  8032ea:	6a 00                	push   $0x0
  8032ec:	ff 75 0c             	pushl  0xc(%ebp)
  8032ef:	ff 75 08             	pushl  0x8(%ebp)
  8032f2:	6a 0b                	push   $0xb
  8032f4:	e8 e6 fe ff ff       	call   8031df <syscall>
  8032f9:	83 c4 18             	add    $0x18,%esp
}
  8032fc:	c9                   	leave  
  8032fd:	c3                   	ret    

008032fe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8032fe:	55                   	push   %ebp
  8032ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803301:	6a 00                	push   $0x0
  803303:	6a 00                	push   $0x0
  803305:	6a 00                	push   $0x0
  803307:	6a 00                	push   $0x0
  803309:	6a 00                	push   $0x0
  80330b:	6a 0c                	push   $0xc
  80330d:	e8 cd fe ff ff       	call   8031df <syscall>
  803312:	83 c4 18             	add    $0x18,%esp
}
  803315:	c9                   	leave  
  803316:	c3                   	ret    

00803317 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803317:	55                   	push   %ebp
  803318:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80331a:	6a 00                	push   $0x0
  80331c:	6a 00                	push   $0x0
  80331e:	6a 00                	push   $0x0
  803320:	6a 00                	push   $0x0
  803322:	6a 00                	push   $0x0
  803324:	6a 0d                	push   $0xd
  803326:	e8 b4 fe ff ff       	call   8031df <syscall>
  80332b:	83 c4 18             	add    $0x18,%esp
}
  80332e:	c9                   	leave  
  80332f:	c3                   	ret    

00803330 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803330:	55                   	push   %ebp
  803331:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803333:	6a 00                	push   $0x0
  803335:	6a 00                	push   $0x0
  803337:	6a 00                	push   $0x0
  803339:	6a 00                	push   $0x0
  80333b:	6a 00                	push   $0x0
  80333d:	6a 0e                	push   $0xe
  80333f:	e8 9b fe ff ff       	call   8031df <syscall>
  803344:	83 c4 18             	add    $0x18,%esp
}
  803347:	c9                   	leave  
  803348:	c3                   	ret    

00803349 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803349:	55                   	push   %ebp
  80334a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80334c:	6a 00                	push   $0x0
  80334e:	6a 00                	push   $0x0
  803350:	6a 00                	push   $0x0
  803352:	6a 00                	push   $0x0
  803354:	6a 00                	push   $0x0
  803356:	6a 0f                	push   $0xf
  803358:	e8 82 fe ff ff       	call   8031df <syscall>
  80335d:	83 c4 18             	add    $0x18,%esp
}
  803360:	c9                   	leave  
  803361:	c3                   	ret    

00803362 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803362:	55                   	push   %ebp
  803363:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803365:	6a 00                	push   $0x0
  803367:	6a 00                	push   $0x0
  803369:	6a 00                	push   $0x0
  80336b:	6a 00                	push   $0x0
  80336d:	ff 75 08             	pushl  0x8(%ebp)
  803370:	6a 10                	push   $0x10
  803372:	e8 68 fe ff ff       	call   8031df <syscall>
  803377:	83 c4 18             	add    $0x18,%esp
}
  80337a:	c9                   	leave  
  80337b:	c3                   	ret    

0080337c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80337c:	55                   	push   %ebp
  80337d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80337f:	6a 00                	push   $0x0
  803381:	6a 00                	push   $0x0
  803383:	6a 00                	push   $0x0
  803385:	6a 00                	push   $0x0
  803387:	6a 00                	push   $0x0
  803389:	6a 11                	push   $0x11
  80338b:	e8 4f fe ff ff       	call   8031df <syscall>
  803390:	83 c4 18             	add    $0x18,%esp
}
  803393:	90                   	nop
  803394:	c9                   	leave  
  803395:	c3                   	ret    

00803396 <sys_cputc>:

void
sys_cputc(const char c)
{
  803396:	55                   	push   %ebp
  803397:	89 e5                	mov    %esp,%ebp
  803399:	83 ec 04             	sub    $0x4,%esp
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8033a2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8033a6:	6a 00                	push   $0x0
  8033a8:	6a 00                	push   $0x0
  8033aa:	6a 00                	push   $0x0
  8033ac:	6a 00                	push   $0x0
  8033ae:	50                   	push   %eax
  8033af:	6a 01                	push   $0x1
  8033b1:	e8 29 fe ff ff       	call   8031df <syscall>
  8033b6:	83 c4 18             	add    $0x18,%esp
}
  8033b9:	90                   	nop
  8033ba:	c9                   	leave  
  8033bb:	c3                   	ret    

008033bc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8033bc:	55                   	push   %ebp
  8033bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8033bf:	6a 00                	push   $0x0
  8033c1:	6a 00                	push   $0x0
  8033c3:	6a 00                	push   $0x0
  8033c5:	6a 00                	push   $0x0
  8033c7:	6a 00                	push   $0x0
  8033c9:	6a 14                	push   $0x14
  8033cb:	e8 0f fe ff ff       	call   8031df <syscall>
  8033d0:	83 c4 18             	add    $0x18,%esp
}
  8033d3:	90                   	nop
  8033d4:	c9                   	leave  
  8033d5:	c3                   	ret    

008033d6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8033d6:	55                   	push   %ebp
  8033d7:	89 e5                	mov    %esp,%ebp
  8033d9:	83 ec 04             	sub    $0x4,%esp
  8033dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8033df:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8033e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8033e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	6a 00                	push   $0x0
  8033ee:	51                   	push   %ecx
  8033ef:	52                   	push   %edx
  8033f0:	ff 75 0c             	pushl  0xc(%ebp)
  8033f3:	50                   	push   %eax
  8033f4:	6a 15                	push   $0x15
  8033f6:	e8 e4 fd ff ff       	call   8031df <syscall>
  8033fb:	83 c4 18             	add    $0x18,%esp
}
  8033fe:	c9                   	leave  
  8033ff:	c3                   	ret    

00803400 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803400:	55                   	push   %ebp
  803401:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803403:	8b 55 0c             	mov    0xc(%ebp),%edx
  803406:	8b 45 08             	mov    0x8(%ebp),%eax
  803409:	6a 00                	push   $0x0
  80340b:	6a 00                	push   $0x0
  80340d:	6a 00                	push   $0x0
  80340f:	52                   	push   %edx
  803410:	50                   	push   %eax
  803411:	6a 16                	push   $0x16
  803413:	e8 c7 fd ff ff       	call   8031df <syscall>
  803418:	83 c4 18             	add    $0x18,%esp
}
  80341b:	c9                   	leave  
  80341c:	c3                   	ret    

0080341d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80341d:	55                   	push   %ebp
  80341e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803420:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803423:	8b 55 0c             	mov    0xc(%ebp),%edx
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	6a 00                	push   $0x0
  80342b:	6a 00                	push   $0x0
  80342d:	51                   	push   %ecx
  80342e:	52                   	push   %edx
  80342f:	50                   	push   %eax
  803430:	6a 17                	push   $0x17
  803432:	e8 a8 fd ff ff       	call   8031df <syscall>
  803437:	83 c4 18             	add    $0x18,%esp
}
  80343a:	c9                   	leave  
  80343b:	c3                   	ret    

0080343c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80343c:	55                   	push   %ebp
  80343d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80343f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	6a 00                	push   $0x0
  803447:	6a 00                	push   $0x0
  803449:	6a 00                	push   $0x0
  80344b:	52                   	push   %edx
  80344c:	50                   	push   %eax
  80344d:	6a 18                	push   $0x18
  80344f:	e8 8b fd ff ff       	call   8031df <syscall>
  803454:	83 c4 18             	add    $0x18,%esp
}
  803457:	c9                   	leave  
  803458:	c3                   	ret    

00803459 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803459:	55                   	push   %ebp
  80345a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	6a 00                	push   $0x0
  803461:	ff 75 14             	pushl  0x14(%ebp)
  803464:	ff 75 10             	pushl  0x10(%ebp)
  803467:	ff 75 0c             	pushl  0xc(%ebp)
  80346a:	50                   	push   %eax
  80346b:	6a 19                	push   $0x19
  80346d:	e8 6d fd ff ff       	call   8031df <syscall>
  803472:	83 c4 18             	add    $0x18,%esp
}
  803475:	c9                   	leave  
  803476:	c3                   	ret    

00803477 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803477:	55                   	push   %ebp
  803478:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80347a:	8b 45 08             	mov    0x8(%ebp),%eax
  80347d:	6a 00                	push   $0x0
  80347f:	6a 00                	push   $0x0
  803481:	6a 00                	push   $0x0
  803483:	6a 00                	push   $0x0
  803485:	50                   	push   %eax
  803486:	6a 1a                	push   $0x1a
  803488:	e8 52 fd ff ff       	call   8031df <syscall>
  80348d:	83 c4 18             	add    $0x18,%esp
}
  803490:	90                   	nop
  803491:	c9                   	leave  
  803492:	c3                   	ret    

00803493 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803493:	55                   	push   %ebp
  803494:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803496:	8b 45 08             	mov    0x8(%ebp),%eax
  803499:	6a 00                	push   $0x0
  80349b:	6a 00                	push   $0x0
  80349d:	6a 00                	push   $0x0
  80349f:	6a 00                	push   $0x0
  8034a1:	50                   	push   %eax
  8034a2:	6a 1b                	push   $0x1b
  8034a4:	e8 36 fd ff ff       	call   8031df <syscall>
  8034a9:	83 c4 18             	add    $0x18,%esp
}
  8034ac:	c9                   	leave  
  8034ad:	c3                   	ret    

008034ae <sys_getenvid>:

int32 sys_getenvid(void)
{
  8034ae:	55                   	push   %ebp
  8034af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8034b1:	6a 00                	push   $0x0
  8034b3:	6a 00                	push   $0x0
  8034b5:	6a 00                	push   $0x0
  8034b7:	6a 00                	push   $0x0
  8034b9:	6a 00                	push   $0x0
  8034bb:	6a 05                	push   $0x5
  8034bd:	e8 1d fd ff ff       	call   8031df <syscall>
  8034c2:	83 c4 18             	add    $0x18,%esp
}
  8034c5:	c9                   	leave  
  8034c6:	c3                   	ret    

008034c7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8034c7:	55                   	push   %ebp
  8034c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8034ca:	6a 00                	push   $0x0
  8034cc:	6a 00                	push   $0x0
  8034ce:	6a 00                	push   $0x0
  8034d0:	6a 00                	push   $0x0
  8034d2:	6a 00                	push   $0x0
  8034d4:	6a 06                	push   $0x6
  8034d6:	e8 04 fd ff ff       	call   8031df <syscall>
  8034db:	83 c4 18             	add    $0x18,%esp
}
  8034de:	c9                   	leave  
  8034df:	c3                   	ret    

008034e0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8034e0:	55                   	push   %ebp
  8034e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8034e3:	6a 00                	push   $0x0
  8034e5:	6a 00                	push   $0x0
  8034e7:	6a 00                	push   $0x0
  8034e9:	6a 00                	push   $0x0
  8034eb:	6a 00                	push   $0x0
  8034ed:	6a 07                	push   $0x7
  8034ef:	e8 eb fc ff ff       	call   8031df <syscall>
  8034f4:	83 c4 18             	add    $0x18,%esp
}
  8034f7:	c9                   	leave  
  8034f8:	c3                   	ret    

008034f9 <sys_exit_env>:


void sys_exit_env(void)
{
  8034f9:	55                   	push   %ebp
  8034fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8034fc:	6a 00                	push   $0x0
  8034fe:	6a 00                	push   $0x0
  803500:	6a 00                	push   $0x0
  803502:	6a 00                	push   $0x0
  803504:	6a 00                	push   $0x0
  803506:	6a 1c                	push   $0x1c
  803508:	e8 d2 fc ff ff       	call   8031df <syscall>
  80350d:	83 c4 18             	add    $0x18,%esp
}
  803510:	90                   	nop
  803511:	c9                   	leave  
  803512:	c3                   	ret    

00803513 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803513:	55                   	push   %ebp
  803514:	89 e5                	mov    %esp,%ebp
  803516:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803519:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80351c:	8d 50 04             	lea    0x4(%eax),%edx
  80351f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803522:	6a 00                	push   $0x0
  803524:	6a 00                	push   $0x0
  803526:	6a 00                	push   $0x0
  803528:	52                   	push   %edx
  803529:	50                   	push   %eax
  80352a:	6a 1d                	push   $0x1d
  80352c:	e8 ae fc ff ff       	call   8031df <syscall>
  803531:	83 c4 18             	add    $0x18,%esp
	return result;
  803534:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803537:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80353a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80353d:	89 01                	mov    %eax,(%ecx)
  80353f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	c9                   	leave  
  803546:	c2 04 00             	ret    $0x4

00803549 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803549:	55                   	push   %ebp
  80354a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80354c:	6a 00                	push   $0x0
  80354e:	6a 00                	push   $0x0
  803550:	ff 75 10             	pushl  0x10(%ebp)
  803553:	ff 75 0c             	pushl  0xc(%ebp)
  803556:	ff 75 08             	pushl  0x8(%ebp)
  803559:	6a 13                	push   $0x13
  80355b:	e8 7f fc ff ff       	call   8031df <syscall>
  803560:	83 c4 18             	add    $0x18,%esp
	return ;
  803563:	90                   	nop
}
  803564:	c9                   	leave  
  803565:	c3                   	ret    

00803566 <sys_rcr2>:
uint32 sys_rcr2()
{
  803566:	55                   	push   %ebp
  803567:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803569:	6a 00                	push   $0x0
  80356b:	6a 00                	push   $0x0
  80356d:	6a 00                	push   $0x0
  80356f:	6a 00                	push   $0x0
  803571:	6a 00                	push   $0x0
  803573:	6a 1e                	push   $0x1e
  803575:	e8 65 fc ff ff       	call   8031df <syscall>
  80357a:	83 c4 18             	add    $0x18,%esp
}
  80357d:	c9                   	leave  
  80357e:	c3                   	ret    

0080357f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80357f:	55                   	push   %ebp
  803580:	89 e5                	mov    %esp,%ebp
  803582:	83 ec 04             	sub    $0x4,%esp
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80358b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80358f:	6a 00                	push   $0x0
  803591:	6a 00                	push   $0x0
  803593:	6a 00                	push   $0x0
  803595:	6a 00                	push   $0x0
  803597:	50                   	push   %eax
  803598:	6a 1f                	push   $0x1f
  80359a:	e8 40 fc ff ff       	call   8031df <syscall>
  80359f:	83 c4 18             	add    $0x18,%esp
	return ;
  8035a2:	90                   	nop
}
  8035a3:	c9                   	leave  
  8035a4:	c3                   	ret    

008035a5 <rsttst>:
void rsttst()
{
  8035a5:	55                   	push   %ebp
  8035a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8035a8:	6a 00                	push   $0x0
  8035aa:	6a 00                	push   $0x0
  8035ac:	6a 00                	push   $0x0
  8035ae:	6a 00                	push   $0x0
  8035b0:	6a 00                	push   $0x0
  8035b2:	6a 21                	push   $0x21
  8035b4:	e8 26 fc ff ff       	call   8031df <syscall>
  8035b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8035bc:	90                   	nop
}
  8035bd:	c9                   	leave  
  8035be:	c3                   	ret    

008035bf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8035bf:	55                   	push   %ebp
  8035c0:	89 e5                	mov    %esp,%ebp
  8035c2:	83 ec 04             	sub    $0x4,%esp
  8035c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8035c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8035cb:	8b 55 18             	mov    0x18(%ebp),%edx
  8035ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8035d2:	52                   	push   %edx
  8035d3:	50                   	push   %eax
  8035d4:	ff 75 10             	pushl  0x10(%ebp)
  8035d7:	ff 75 0c             	pushl  0xc(%ebp)
  8035da:	ff 75 08             	pushl  0x8(%ebp)
  8035dd:	6a 20                	push   $0x20
  8035df:	e8 fb fb ff ff       	call   8031df <syscall>
  8035e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8035e7:	90                   	nop
}
  8035e8:	c9                   	leave  
  8035e9:	c3                   	ret    

008035ea <chktst>:
void chktst(uint32 n)
{
  8035ea:	55                   	push   %ebp
  8035eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8035ed:	6a 00                	push   $0x0
  8035ef:	6a 00                	push   $0x0
  8035f1:	6a 00                	push   $0x0
  8035f3:	6a 00                	push   $0x0
  8035f5:	ff 75 08             	pushl  0x8(%ebp)
  8035f8:	6a 22                	push   $0x22
  8035fa:	e8 e0 fb ff ff       	call   8031df <syscall>
  8035ff:	83 c4 18             	add    $0x18,%esp
	return ;
  803602:	90                   	nop
}
  803603:	c9                   	leave  
  803604:	c3                   	ret    

00803605 <inctst>:

void inctst()
{
  803605:	55                   	push   %ebp
  803606:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803608:	6a 00                	push   $0x0
  80360a:	6a 00                	push   $0x0
  80360c:	6a 00                	push   $0x0
  80360e:	6a 00                	push   $0x0
  803610:	6a 00                	push   $0x0
  803612:	6a 23                	push   $0x23
  803614:	e8 c6 fb ff ff       	call   8031df <syscall>
  803619:	83 c4 18             	add    $0x18,%esp
	return ;
  80361c:	90                   	nop
}
  80361d:	c9                   	leave  
  80361e:	c3                   	ret    

0080361f <gettst>:
uint32 gettst()
{
  80361f:	55                   	push   %ebp
  803620:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803622:	6a 00                	push   $0x0
  803624:	6a 00                	push   $0x0
  803626:	6a 00                	push   $0x0
  803628:	6a 00                	push   $0x0
  80362a:	6a 00                	push   $0x0
  80362c:	6a 24                	push   $0x24
  80362e:	e8 ac fb ff ff       	call   8031df <syscall>
  803633:	83 c4 18             	add    $0x18,%esp
}
  803636:	c9                   	leave  
  803637:	c3                   	ret    

00803638 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803638:	55                   	push   %ebp
  803639:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80363b:	6a 00                	push   $0x0
  80363d:	6a 00                	push   $0x0
  80363f:	6a 00                	push   $0x0
  803641:	6a 00                	push   $0x0
  803643:	6a 00                	push   $0x0
  803645:	6a 25                	push   $0x25
  803647:	e8 93 fb ff ff       	call   8031df <syscall>
  80364c:	83 c4 18             	add    $0x18,%esp
  80364f:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  803654:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  803659:	c9                   	leave  
  80365a:	c3                   	ret    

0080365b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80365b:	55                   	push   %ebp
  80365c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803666:	6a 00                	push   $0x0
  803668:	6a 00                	push   $0x0
  80366a:	6a 00                	push   $0x0
  80366c:	6a 00                	push   $0x0
  80366e:	ff 75 08             	pushl  0x8(%ebp)
  803671:	6a 26                	push   $0x26
  803673:	e8 67 fb ff ff       	call   8031df <syscall>
  803678:	83 c4 18             	add    $0x18,%esp
	return ;
  80367b:	90                   	nop
}
  80367c:	c9                   	leave  
  80367d:	c3                   	ret    

0080367e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80367e:	55                   	push   %ebp
  80367f:	89 e5                	mov    %esp,%ebp
  803681:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803682:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803685:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	6a 00                	push   $0x0
  803690:	53                   	push   %ebx
  803691:	51                   	push   %ecx
  803692:	52                   	push   %edx
  803693:	50                   	push   %eax
  803694:	6a 27                	push   $0x27
  803696:	e8 44 fb ff ff       	call   8031df <syscall>
  80369b:	83 c4 18             	add    $0x18,%esp
}
  80369e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036a1:	c9                   	leave  
  8036a2:	c3                   	ret    

008036a3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8036a3:	55                   	push   %ebp
  8036a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8036a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ac:	6a 00                	push   $0x0
  8036ae:	6a 00                	push   $0x0
  8036b0:	6a 00                	push   $0x0
  8036b2:	52                   	push   %edx
  8036b3:	50                   	push   %eax
  8036b4:	6a 28                	push   $0x28
  8036b6:	e8 24 fb ff ff       	call   8031df <syscall>
  8036bb:	83 c4 18             	add    $0x18,%esp
}
  8036be:	c9                   	leave  
  8036bf:	c3                   	ret    

008036c0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8036c0:	55                   	push   %ebp
  8036c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8036c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8036c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cc:	6a 00                	push   $0x0
  8036ce:	51                   	push   %ecx
  8036cf:	ff 75 10             	pushl  0x10(%ebp)
  8036d2:	52                   	push   %edx
  8036d3:	50                   	push   %eax
  8036d4:	6a 29                	push   $0x29
  8036d6:	e8 04 fb ff ff       	call   8031df <syscall>
  8036db:	83 c4 18             	add    $0x18,%esp
}
  8036de:	c9                   	leave  
  8036df:	c3                   	ret    

008036e0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8036e0:	55                   	push   %ebp
  8036e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8036e3:	6a 00                	push   $0x0
  8036e5:	6a 00                	push   $0x0
  8036e7:	ff 75 10             	pushl  0x10(%ebp)
  8036ea:	ff 75 0c             	pushl  0xc(%ebp)
  8036ed:	ff 75 08             	pushl  0x8(%ebp)
  8036f0:	6a 12                	push   $0x12
  8036f2:	e8 e8 fa ff ff       	call   8031df <syscall>
  8036f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8036fa:	90                   	nop
}
  8036fb:	c9                   	leave  
  8036fc:	c3                   	ret    

008036fd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8036fd:	55                   	push   %ebp
  8036fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803700:	8b 55 0c             	mov    0xc(%ebp),%edx
  803703:	8b 45 08             	mov    0x8(%ebp),%eax
  803706:	6a 00                	push   $0x0
  803708:	6a 00                	push   $0x0
  80370a:	6a 00                	push   $0x0
  80370c:	52                   	push   %edx
  80370d:	50                   	push   %eax
  80370e:	6a 2a                	push   $0x2a
  803710:	e8 ca fa ff ff       	call   8031df <syscall>
  803715:	83 c4 18             	add    $0x18,%esp
	return;
  803718:	90                   	nop
}
  803719:	c9                   	leave  
  80371a:	c3                   	ret    

0080371b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80371b:	55                   	push   %ebp
  80371c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80371e:	6a 00                	push   $0x0
  803720:	6a 00                	push   $0x0
  803722:	6a 00                	push   $0x0
  803724:	6a 00                	push   $0x0
  803726:	6a 00                	push   $0x0
  803728:	6a 2b                	push   $0x2b
  80372a:	e8 b0 fa ff ff       	call   8031df <syscall>
  80372f:	83 c4 18             	add    $0x18,%esp
}
  803732:	c9                   	leave  
  803733:	c3                   	ret    

00803734 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803734:	55                   	push   %ebp
  803735:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803737:	6a 00                	push   $0x0
  803739:	6a 00                	push   $0x0
  80373b:	6a 00                	push   $0x0
  80373d:	ff 75 0c             	pushl  0xc(%ebp)
  803740:	ff 75 08             	pushl  0x8(%ebp)
  803743:	6a 2d                	push   $0x2d
  803745:	e8 95 fa ff ff       	call   8031df <syscall>
  80374a:	83 c4 18             	add    $0x18,%esp
	return;
  80374d:	90                   	nop
}
  80374e:	c9                   	leave  
  80374f:	c3                   	ret    

00803750 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803750:	55                   	push   %ebp
  803751:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803753:	6a 00                	push   $0x0
  803755:	6a 00                	push   $0x0
  803757:	6a 00                	push   $0x0
  803759:	ff 75 0c             	pushl  0xc(%ebp)
  80375c:	ff 75 08             	pushl  0x8(%ebp)
  80375f:	6a 2c                	push   $0x2c
  803761:	e8 79 fa ff ff       	call   8031df <syscall>
  803766:	83 c4 18             	add    $0x18,%esp
	return ;
  803769:	90                   	nop
}
  80376a:	c9                   	leave  
  80376b:	c3                   	ret    

0080376c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80376c:	55                   	push   %ebp
  80376d:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80376f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803772:	8b 45 08             	mov    0x8(%ebp),%eax
  803775:	6a 00                	push   $0x0
  803777:	6a 00                	push   $0x0
  803779:	6a 00                	push   $0x0
  80377b:	52                   	push   %edx
  80377c:	50                   	push   %eax
  80377d:	6a 2e                	push   $0x2e
  80377f:	e8 5b fa ff ff       	call   8031df <syscall>
  803784:	83 c4 18             	add    $0x18,%esp
	    return;
  803787:	90                   	nop
}
  803788:	c9                   	leave  
  803789:	c3                   	ret    

0080378a <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80378a:	55                   	push   %ebp
  80378b:	89 e5                	mov    %esp,%ebp
  80378d:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803790:	8b 45 08             	mov    0x8(%ebp),%eax
  803793:	ba 60 60 80 00       	mov    $0x806060,%edx
  803798:	29 d0                	sub    %edx,%eax
  80379a:	c1 f8 02             	sar    $0x2,%eax
  80379d:	89 c2                	mov    %eax,%edx
  80379f:	89 d0                	mov    %edx,%eax
  8037a1:	c1 e0 02             	shl    $0x2,%eax
  8037a4:	01 d0                	add    %edx,%eax
  8037a6:	c1 e0 02             	shl    $0x2,%eax
  8037a9:	01 d0                	add    %edx,%eax
  8037ab:	c1 e0 02             	shl    $0x2,%eax
  8037ae:	01 d0                	add    %edx,%eax
  8037b0:	89 c1                	mov    %eax,%ecx
  8037b2:	c1 e1 08             	shl    $0x8,%ecx
  8037b5:	01 c8                	add    %ecx,%eax
  8037b7:	89 c1                	mov    %eax,%ecx
  8037b9:	c1 e1 10             	shl    $0x10,%ecx
  8037bc:	01 c8                	add    %ecx,%eax
  8037be:	01 c0                	add    %eax,%eax
  8037c0:	01 d0                	add    %edx,%eax
  8037c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8037c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037c8:	c1 e0 0c             	shl    $0xc,%eax
  8037cb:	89 c2                	mov    %eax,%edx
  8037cd:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8037d2:	01 d0                	add    %edx,%eax
}
  8037d4:	c9                   	leave  
  8037d5:	c3                   	ret    

008037d6 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  8037d6:	55                   	push   %ebp
  8037d7:	89 e5                	mov    %esp,%ebp
  8037d9:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  8037dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8037e3:	eb 06                	jmp    8037eb <log2+0x15>
			n >>=1;
  8037e5:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  8037e8:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  8037eb:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8037ef:	77 f4                	ja     8037e5 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  8037f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8037f4:	c9                   	leave  
  8037f5:	c3                   	ret    

008037f6 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8037f6:	55                   	push   %ebp
  8037f7:	89 e5                	mov    %esp,%ebp
  8037f9:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8037fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ff:	05 00 00 00 02       	add    $0x2000000,%eax
  803804:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803807:	73 16                	jae    80381f <initialize_dynamic_allocator+0x29>
  803809:	68 38 53 80 00       	push   $0x805338
  80380e:	68 5e 53 80 00       	push   $0x80535e
  803813:	6a 2d                	push   $0x2d
  803815:	68 73 53 80 00       	push   $0x805373
  80381a:	e8 a6 ce ff ff       	call   8006c5 <_panic>
		is_initialized = 1;
  80381f:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  803826:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803829:	8b 45 08             	mov    0x8(%ebp),%eax
  80382c:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  803831:	8b 45 0c             	mov    0xc(%ebp),%eax
  803834:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803839:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80383f:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803844:	29 c2                	sub    %eax,%edx
  803846:	89 d0                	mov    %edx,%eax
  803848:	c1 e8 0c             	shr    $0xc,%eax
  80384b:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  80384e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803855:	eb 2f                	jmp    803886 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803857:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80385a:	89 d0                	mov    %edx,%eax
  80385c:	01 c0                	add    %eax,%eax
  80385e:	01 d0                	add    %edx,%eax
  803860:	c1 e0 02             	shl    $0x2,%eax
  803863:	05 68 60 80 00       	add    $0x806068,%eax
  803868:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  80386d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803870:	89 d0                	mov    %edx,%eax
  803872:	01 c0                	add    %eax,%eax
  803874:	01 d0                	add    %edx,%eax
  803876:	c1 e0 02             	shl    $0x2,%eax
  803879:	05 6a 60 80 00       	add    $0x80606a,%eax
  80387e:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803883:	ff 45 f4             	incl   -0xc(%ebp)
  803886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803889:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80388c:	7c c9                	jl     803857 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  80388e:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  803895:	00 00 00 
  803898:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  80389f:	00 00 00 
  8038a2:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  8038a9:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  8038ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8038b3:	e9 9c 00 00 00       	jmp    803954 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8038b8:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8038be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8038c1:	89 c8                	mov    %ecx,%eax
  8038c3:	01 c0                	add    %eax,%eax
  8038c5:	01 c8                	add    %ecx,%eax
  8038c7:	c1 e0 02             	shl    $0x2,%eax
  8038ca:	05 64 60 80 00       	add    $0x806064,%eax
  8038cf:	89 10                	mov    %edx,(%eax)
  8038d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038d4:	89 d0                	mov    %edx,%eax
  8038d6:	01 c0                	add    %eax,%eax
  8038d8:	01 d0                	add    %edx,%eax
  8038da:	c1 e0 02             	shl    $0x2,%eax
  8038dd:	05 64 60 80 00       	add    $0x806064,%eax
  8038e2:	8b 00                	mov    (%eax),%eax
  8038e4:	85 c0                	test   %eax,%eax
  8038e6:	74 1b                	je     803903 <initialize_dynamic_allocator+0x10d>
  8038e8:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8038ee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8038f1:	89 c8                	mov    %ecx,%eax
  8038f3:	01 c0                	add    %eax,%eax
  8038f5:	01 c8                	add    %ecx,%eax
  8038f7:	c1 e0 02             	shl    $0x2,%eax
  8038fa:	05 60 60 80 00       	add    $0x806060,%eax
  8038ff:	89 02                	mov    %eax,(%edx)
  803901:	eb 16                	jmp    803919 <initialize_dynamic_allocator+0x123>
  803903:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803906:	89 d0                	mov    %edx,%eax
  803908:	01 c0                	add    %eax,%eax
  80390a:	01 d0                	add    %edx,%eax
  80390c:	c1 e0 02             	shl    $0x2,%eax
  80390f:	05 60 60 80 00       	add    $0x806060,%eax
  803914:	a3 48 60 80 00       	mov    %eax,0x806048
  803919:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80391c:	89 d0                	mov    %edx,%eax
  80391e:	01 c0                	add    %eax,%eax
  803920:	01 d0                	add    %edx,%eax
  803922:	c1 e0 02             	shl    $0x2,%eax
  803925:	05 60 60 80 00       	add    $0x806060,%eax
  80392a:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80392f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803932:	89 d0                	mov    %edx,%eax
  803934:	01 c0                	add    %eax,%eax
  803936:	01 d0                	add    %edx,%eax
  803938:	c1 e0 02             	shl    $0x2,%eax
  80393b:	05 60 60 80 00       	add    $0x806060,%eax
  803940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803946:	a1 54 60 80 00       	mov    0x806054,%eax
  80394b:	40                   	inc    %eax
  80394c:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803951:	ff 45 f0             	incl   -0x10(%ebp)
  803954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803957:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80395a:	0f 8c 58 ff ff ff    	jl     8038b8 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803960:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803967:	eb 36                	jmp    80399f <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80396c:	c1 e0 04             	shl    $0x4,%eax
  80396f:	05 80 e0 81 00       	add    $0x81e080,%eax
  803974:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80397a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80397d:	c1 e0 04             	shl    $0x4,%eax
  803980:	05 84 e0 81 00       	add    $0x81e084,%eax
  803985:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80398b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80398e:	c1 e0 04             	shl    $0x4,%eax
  803991:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803996:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80399c:	ff 45 ec             	incl   -0x14(%ebp)
  80399f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8039a3:	7e c4                	jle    803969 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8039a5:	90                   	nop
  8039a6:	c9                   	leave  
  8039a7:	c3                   	ret    

008039a8 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  8039a8:	55                   	push   %ebp
  8039a9:	89 e5                	mov    %esp,%ebp
  8039ab:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8039ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8039b1:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8039b6:	29 c2                	sub    %eax,%edx
  8039b8:	89 d0                	mov    %edx,%eax
  8039ba:	c1 e8 0c             	shr    $0xc,%eax
  8039bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  8039c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8039c3:	89 d0                	mov    %edx,%eax
  8039c5:	01 c0                	add    %eax,%eax
  8039c7:	01 d0                	add    %edx,%eax
  8039c9:	c1 e0 02             	shl    $0x2,%eax
  8039cc:	05 68 60 80 00       	add    $0x806068,%eax
  8039d1:	8b 00                	mov    (%eax),%eax
  8039d3:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8039d6:	c9                   	leave  
  8039d7:	c3                   	ret    

008039d8 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8039d8:	55                   	push   %ebp
  8039d9:	89 e5                	mov    %esp,%ebp
  8039db:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8039de:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8039e5:	76 16                	jbe    8039fd <alloc_block+0x25>
  8039e7:	68 8c 53 80 00       	push   $0x80538c
  8039ec:	68 5e 53 80 00       	push   $0x80535e
  8039f1:	6a 6c                	push   $0x6c
  8039f3:	68 73 53 80 00       	push   $0x805373
  8039f8:	e8 c8 cc ff ff       	call   8006c5 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  8039fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a01:	75 0a                	jne    803a0d <alloc_block+0x35>
		return NULL;
  803a03:	b8 00 00 00 00       	mov    $0x0,%eax
  803a08:	e9 65 04 00 00       	jmp    803e72 <alloc_block+0x49a>
	}
	else if(size<=8){
  803a0d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803a11:	77 09                	ja     803a1c <alloc_block+0x44>
		size=8;
  803a13:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803a1a:	eb 1f                	jmp    803a3b <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803a1c:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803a23:	eb 08                	jmp    803a2d <alloc_block+0x55>
			reqsize*=2;
  803a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a28:	01 c0                	add    %eax,%eax
  803a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a30:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a33:	72 f0                	jb     803a25 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a38:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803a3b:	83 ec 0c             	sub    $0xc,%esp
  803a3e:	ff 75 08             	pushl  0x8(%ebp)
  803a41:	e8 90 fd ff ff       	call   8037d6 <log2>
  803a46:	83 c4 10             	add    $0x10,%esp
  803a49:	83 e8 03             	sub    $0x3,%eax
  803a4c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803a4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a52:	c1 e0 04             	shl    $0x4,%eax
  803a55:	05 80 e0 81 00       	add    $0x81e080,%eax
  803a5a:	8b 00                	mov    (%eax),%eax
  803a5c:	85 c0                	test   %eax,%eax
  803a5e:	0f 84 fb 00 00 00    	je     803b5f <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803a64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a67:	c1 e0 04             	shl    $0x4,%eax
  803a6a:	05 80 e0 81 00       	add    $0x81e080,%eax
  803a6f:	8b 00                	mov    (%eax),%eax
  803a71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803a74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a78:	75 17                	jne    803a91 <alloc_block+0xb9>
  803a7a:	83 ec 04             	sub    $0x4,%esp
  803a7d:	68 ad 53 80 00       	push   $0x8053ad
  803a82:	68 86 00 00 00       	push   $0x86
  803a87:	68 73 53 80 00       	push   $0x805373
  803a8c:	e8 34 cc ff ff       	call   8006c5 <_panic>
  803a91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a94:	8b 00                	mov    (%eax),%eax
  803a96:	85 c0                	test   %eax,%eax
  803a98:	74 10                	je     803aaa <alloc_block+0xd2>
  803a9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9d:	8b 00                	mov    (%eax),%eax
  803a9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aa2:	8b 52 04             	mov    0x4(%edx),%edx
  803aa5:	89 50 04             	mov    %edx,0x4(%eax)
  803aa8:	eb 14                	jmp    803abe <alloc_block+0xe6>
  803aaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aad:	8b 40 04             	mov    0x4(%eax),%eax
  803ab0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ab3:	c1 e2 04             	shl    $0x4,%edx
  803ab6:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803abc:	89 02                	mov    %eax,(%edx)
  803abe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac1:	8b 40 04             	mov    0x4(%eax),%eax
  803ac4:	85 c0                	test   %eax,%eax
  803ac6:	74 0f                	je     803ad7 <alloc_block+0xff>
  803ac8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acb:	8b 40 04             	mov    0x4(%eax),%eax
  803ace:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad1:	8b 12                	mov    (%edx),%edx
  803ad3:	89 10                	mov    %edx,(%eax)
  803ad5:	eb 13                	jmp    803aea <alloc_block+0x112>
  803ad7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ada:	8b 00                	mov    (%eax),%eax
  803adc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803adf:	c1 e2 04             	shl    $0x4,%edx
  803ae2:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803ae8:	89 02                	mov    %eax,(%edx)
  803aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803afd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b00:	c1 e0 04             	shl    $0x4,%eax
  803b03:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803b08:	8b 00                	mov    (%eax),%eax
  803b0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b10:	c1 e0 04             	shl    $0x4,%eax
  803b13:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803b18:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803b1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b1d:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803b22:	29 c2                	sub    %eax,%edx
  803b24:	89 d0                	mov    %edx,%eax
  803b26:	c1 e8 0c             	shr    $0xc,%eax
  803b29:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803b2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b2f:	89 d0                	mov    %edx,%eax
  803b31:	01 c0                	add    %eax,%eax
  803b33:	01 d0                	add    %edx,%eax
  803b35:	c1 e0 02             	shl    $0x2,%eax
  803b38:	05 6a 60 80 00       	add    $0x80606a,%eax
  803b3d:	66 8b 00             	mov    (%eax),%ax
  803b40:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b43:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803b46:	89 c8                	mov    %ecx,%eax
  803b48:	01 c0                	add    %eax,%eax
  803b4a:	01 c8                	add    %ecx,%eax
  803b4c:	c1 e0 02             	shl    $0x2,%eax
  803b4f:	05 6a 60 80 00       	add    $0x80606a,%eax
  803b54:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5a:	e9 13 03 00 00       	jmp    803e72 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803b5f:	a1 48 60 80 00       	mov    0x806048,%eax
  803b64:	85 c0                	test   %eax,%eax
  803b66:	0f 84 c9 01 00 00    	je     803d35 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803b6c:	a1 48 60 80 00       	mov    0x806048,%eax
  803b71:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803b74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803b78:	75 17                	jne    803b91 <alloc_block+0x1b9>
  803b7a:	83 ec 04             	sub    $0x4,%esp
  803b7d:	68 ad 53 80 00       	push   $0x8053ad
  803b82:	68 8f 00 00 00       	push   $0x8f
  803b87:	68 73 53 80 00       	push   $0x805373
  803b8c:	e8 34 cb ff ff       	call   8006c5 <_panic>
  803b91:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b94:	8b 00                	mov    (%eax),%eax
  803b96:	85 c0                	test   %eax,%eax
  803b98:	74 10                	je     803baa <alloc_block+0x1d2>
  803b9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b9d:	8b 00                	mov    (%eax),%eax
  803b9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ba2:	8b 52 04             	mov    0x4(%edx),%edx
  803ba5:	89 50 04             	mov    %edx,0x4(%eax)
  803ba8:	eb 0b                	jmp    803bb5 <alloc_block+0x1dd>
  803baa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bad:	8b 40 04             	mov    0x4(%eax),%eax
  803bb0:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803bb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bb8:	8b 40 04             	mov    0x4(%eax),%eax
  803bbb:	85 c0                	test   %eax,%eax
  803bbd:	74 0f                	je     803bce <alloc_block+0x1f6>
  803bbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bc2:	8b 40 04             	mov    0x4(%eax),%eax
  803bc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bc8:	8b 12                	mov    (%edx),%edx
  803bca:	89 10                	mov    %edx,(%eax)
  803bcc:	eb 0a                	jmp    803bd8 <alloc_block+0x200>
  803bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bd1:	8b 00                	mov    (%eax),%eax
  803bd3:	a3 48 60 80 00       	mov    %eax,0x806048
  803bd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803be4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803beb:	a1 54 60 80 00       	mov    0x806054,%eax
  803bf0:	48                   	dec    %eax
  803bf1:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803bf6:	83 ec 0c             	sub    $0xc,%esp
  803bf9:	ff 75 dc             	pushl  -0x24(%ebp)
  803bfc:	e8 89 fb ff ff       	call   80378a <to_page_va>
  803c01:	83 c4 10             	add    $0x10,%esp
  803c04:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803c07:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c0c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803c0f:	29 c2                	sub    %eax,%edx
  803c11:	89 d0                	mov    %edx,%eax
  803c13:	c1 e8 0c             	shr    $0xc,%eax
  803c16:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803c19:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c1c:	83 ec 0c             	sub    $0xc,%esp
  803c1f:	50                   	push   %eax
  803c20:	e8 fe dc ff ff       	call   801923 <get_page>
  803c25:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803c28:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2b:	89 c2                	mov    %eax,%edx
  803c2d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803c30:	89 c8                	mov    %ecx,%eax
  803c32:	01 c0                	add    %eax,%eax
  803c34:	01 c8                	add    %ecx,%eax
  803c36:	c1 e0 02             	shl    $0x2,%eax
  803c39:	05 68 60 80 00       	add    $0x806068,%eax
  803c3e:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803c41:	b8 00 10 00 00       	mov    $0x1000,%eax
  803c46:	ba 00 00 00 00       	mov    $0x0,%edx
  803c4b:	f7 75 08             	divl   0x8(%ebp)
  803c4e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803c51:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c54:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c57:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803c5a:	89 c8                	mov    %ecx,%eax
  803c5c:	01 c0                	add    %eax,%eax
  803c5e:	01 c8                	add    %ecx,%eax
  803c60:	c1 e0 02             	shl    $0x2,%eax
  803c63:	05 6a 60 80 00       	add    $0x80606a,%eax
  803c68:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803c6b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803c72:	e9 aa 00 00 00       	jmp    803d21 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c7a:	0f af 45 08          	imul   0x8(%ebp),%eax
  803c7e:	89 c2                	mov    %eax,%edx
  803c80:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c83:	01 d0                	add    %edx,%eax
  803c85:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803c88:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803c8c:	75 17                	jne    803ca5 <alloc_block+0x2cd>
  803c8e:	83 ec 04             	sub    $0x4,%esp
  803c91:	68 cc 53 80 00       	push   $0x8053cc
  803c96:	68 9d 00 00 00       	push   $0x9d
  803c9b:	68 73 53 80 00       	push   $0x805373
  803ca0:	e8 20 ca ff ff       	call   8006c5 <_panic>
  803ca5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca8:	c1 e0 04             	shl    $0x4,%eax
  803cab:	05 84 e0 81 00       	add    $0x81e084,%eax
  803cb0:	8b 10                	mov    (%eax),%edx
  803cb2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cb5:	89 50 04             	mov    %edx,0x4(%eax)
  803cb8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cbb:	8b 40 04             	mov    0x4(%eax),%eax
  803cbe:	85 c0                	test   %eax,%eax
  803cc0:	74 14                	je     803cd6 <alloc_block+0x2fe>
  803cc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc5:	c1 e0 04             	shl    $0x4,%eax
  803cc8:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ccd:	8b 00                	mov    (%eax),%eax
  803ccf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803cd2:	89 10                	mov    %edx,(%eax)
  803cd4:	eb 11                	jmp    803ce7 <alloc_block+0x30f>
  803cd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd9:	c1 e0 04             	shl    $0x4,%eax
  803cdc:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803ce2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ce5:	89 02                	mov    %eax,(%edx)
  803ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cea:	c1 e0 04             	shl    $0x4,%eax
  803ced:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803cf3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cf6:	89 02                	mov    %eax,(%edx)
  803cf8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d04:	c1 e0 04             	shl    $0x4,%eax
  803d07:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d0c:	8b 00                	mov    (%eax),%eax
  803d0e:	8d 50 01             	lea    0x1(%eax),%edx
  803d11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d14:	c1 e0 04             	shl    $0x4,%eax
  803d17:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d1c:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803d1e:	ff 45 f0             	incl   -0x10(%ebp)
  803d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d24:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803d27:	0f 8c 4a ff ff ff    	jl     803c77 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803d2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d30:	e9 3d 01 00 00       	jmp    803e72 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d38:	40                   	inc    %eax
  803d39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803d3c:	e9 10 01 00 00       	jmp    803e51 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d44:	c1 e0 04             	shl    $0x4,%eax
  803d47:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d4c:	8b 00                	mov    (%eax),%eax
  803d4e:	85 c0                	test   %eax,%eax
  803d50:	0f 84 f8 00 00 00    	je     803e4e <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d59:	c1 e0 04             	shl    $0x4,%eax
  803d5c:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d61:	8b 00                	mov    (%eax),%eax
  803d63:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803d66:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803d6a:	75 17                	jne    803d83 <alloc_block+0x3ab>
  803d6c:	83 ec 04             	sub    $0x4,%esp
  803d6f:	68 ad 53 80 00       	push   $0x8053ad
  803d74:	68 a8 00 00 00       	push   $0xa8
  803d79:	68 73 53 80 00       	push   $0x805373
  803d7e:	e8 42 c9 ff ff       	call   8006c5 <_panic>
  803d83:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d86:	8b 00                	mov    (%eax),%eax
  803d88:	85 c0                	test   %eax,%eax
  803d8a:	74 10                	je     803d9c <alloc_block+0x3c4>
  803d8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d8f:	8b 00                	mov    (%eax),%eax
  803d91:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803d94:	8b 52 04             	mov    0x4(%edx),%edx
  803d97:	89 50 04             	mov    %edx,0x4(%eax)
  803d9a:	eb 14                	jmp    803db0 <alloc_block+0x3d8>
  803d9c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d9f:	8b 40 04             	mov    0x4(%eax),%eax
  803da2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803da5:	c1 e2 04             	shl    $0x4,%edx
  803da8:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803dae:	89 02                	mov    %eax,(%edx)
  803db0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803db3:	8b 40 04             	mov    0x4(%eax),%eax
  803db6:	85 c0                	test   %eax,%eax
  803db8:	74 0f                	je     803dc9 <alloc_block+0x3f1>
  803dba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803dbd:	8b 40 04             	mov    0x4(%eax),%eax
  803dc0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803dc3:	8b 12                	mov    (%edx),%edx
  803dc5:	89 10                	mov    %edx,(%eax)
  803dc7:	eb 13                	jmp    803ddc <alloc_block+0x404>
  803dc9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803dcc:	8b 00                	mov    (%eax),%eax
  803dce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dd1:	c1 e2 04             	shl    $0x4,%edx
  803dd4:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803dda:	89 02                	mov    %eax,(%edx)
  803ddc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ddf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803de5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803de8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803df2:	c1 e0 04             	shl    $0x4,%eax
  803df5:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803dfa:	8b 00                	mov    (%eax),%eax
  803dfc:	8d 50 ff             	lea    -0x1(%eax),%edx
  803dff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e02:	c1 e0 04             	shl    $0x4,%eax
  803e05:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803e0a:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803e0c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803e0f:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803e14:	29 c2                	sub    %eax,%edx
  803e16:	89 d0                	mov    %edx,%eax
  803e18:	c1 e8 0c             	shr    $0xc,%eax
  803e1b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803e1e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803e21:	89 d0                	mov    %edx,%eax
  803e23:	01 c0                	add    %eax,%eax
  803e25:	01 d0                	add    %edx,%eax
  803e27:	c1 e0 02             	shl    $0x2,%eax
  803e2a:	05 6a 60 80 00       	add    $0x80606a,%eax
  803e2f:	66 8b 00             	mov    (%eax),%ax
  803e32:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e35:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803e38:	89 c8                	mov    %ecx,%eax
  803e3a:	01 c0                	add    %eax,%eax
  803e3c:	01 c8                	add    %ecx,%eax
  803e3e:	c1 e0 02             	shl    $0x2,%eax
  803e41:	05 6a 60 80 00       	add    $0x80606a,%eax
  803e46:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803e49:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803e4c:	eb 24                	jmp    803e72 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803e4e:	ff 45 ec             	incl   -0x14(%ebp)
  803e51:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803e55:	0f 8e e6 fe ff ff    	jle    803d41 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803e5b:	83 ec 04             	sub    $0x4,%esp
  803e5e:	68 ef 53 80 00       	push   $0x8053ef
  803e63:	68 b1 00 00 00       	push   $0xb1
  803e68:	68 73 53 80 00       	push   $0x805373
  803e6d:	e8 53 c8 ff ff       	call   8006c5 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803e72:	c9                   	leave  
  803e73:	c3                   	ret    

00803e74 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803e74:	55                   	push   %ebp
  803e75:	89 e5                	mov    %esp,%ebp
  803e77:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  803e7d:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803e82:	39 c2                	cmp    %eax,%edx
  803e84:	72 0c                	jb     803e92 <free_block+0x1e>
  803e86:	8b 55 08             	mov    0x8(%ebp),%edx
  803e89:	a1 40 60 80 00       	mov    0x806040,%eax
  803e8e:	39 c2                	cmp    %eax,%edx
  803e90:	72 19                	jb     803eab <free_block+0x37>
  803e92:	68 0c 54 80 00       	push   $0x80540c
  803e97:	68 5e 53 80 00       	push   $0x80535e
  803e9c:	68 c3 00 00 00       	push   $0xc3
  803ea1:	68 73 53 80 00       	push   $0x805373
  803ea6:	e8 1a c8 ff ff       	call   8006c5 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803eab:	8b 55 08             	mov    0x8(%ebp),%edx
  803eae:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803eb3:	29 c2                	sub    %eax,%edx
  803eb5:	89 d0                	mov    %edx,%eax
  803eb7:	c1 e8 0c             	shr    $0xc,%eax
  803eba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803ebd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ec0:	89 d0                	mov    %edx,%eax
  803ec2:	01 c0                	add    %eax,%eax
  803ec4:	01 d0                	add    %edx,%eax
  803ec6:	c1 e0 02             	shl    $0x2,%eax
  803ec9:	05 68 60 80 00       	add    $0x806068,%eax
  803ece:	8b 00                	mov    (%eax),%eax
  803ed0:	0f b7 c0             	movzwl %ax,%eax
  803ed3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803ed6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803eda:	75 17                	jne    803ef3 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803edc:	83 ec 04             	sub    $0x4,%esp
  803edf:	68 44 54 80 00       	push   $0x805444
  803ee4:	68 cf 00 00 00       	push   $0xcf
  803ee9:	68 73 53 80 00       	push   $0x805373
  803eee:	e8 d2 c7 ff ff       	call   8006c5 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803ef3:	83 ec 0c             	sub    $0xc,%esp
  803ef6:	ff 75 ec             	pushl  -0x14(%ebp)
  803ef9:	e8 d8 f8 ff ff       	call   8037d6 <log2>
  803efe:	83 c4 10             	add    $0x10,%esp
  803f01:	83 e8 03             	sub    $0x3,%eax
  803f04:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803f07:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803f0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f11:	75 17                	jne    803f2a <free_block+0xb6>
  803f13:	83 ec 04             	sub    $0x4,%esp
  803f16:	68 cc 53 80 00       	push   $0x8053cc
  803f1b:	68 d5 00 00 00       	push   $0xd5
  803f20:	68 73 53 80 00       	push   $0x805373
  803f25:	e8 9b c7 ff ff       	call   8006c5 <_panic>
  803f2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f2d:	c1 e0 04             	shl    $0x4,%eax
  803f30:	05 84 e0 81 00       	add    $0x81e084,%eax
  803f35:	8b 10                	mov    (%eax),%edx
  803f37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f3a:	89 50 04             	mov    %edx,0x4(%eax)
  803f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f40:	8b 40 04             	mov    0x4(%eax),%eax
  803f43:	85 c0                	test   %eax,%eax
  803f45:	74 14                	je     803f5b <free_block+0xe7>
  803f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f4a:	c1 e0 04             	shl    $0x4,%eax
  803f4d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803f52:	8b 00                	mov    (%eax),%eax
  803f54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f57:	89 10                	mov    %edx,(%eax)
  803f59:	eb 11                	jmp    803f6c <free_block+0xf8>
  803f5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f5e:	c1 e0 04             	shl    $0x4,%eax
  803f61:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f6a:	89 02                	mov    %eax,(%edx)
  803f6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f6f:	c1 e0 04             	shl    $0x4,%eax
  803f72:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f7b:	89 02                	mov    %eax,(%edx)
  803f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f89:	c1 e0 04             	shl    $0x4,%eax
  803f8c:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803f91:	8b 00                	mov    (%eax),%eax
  803f93:	8d 50 01             	lea    0x1(%eax),%edx
  803f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f99:	c1 e0 04             	shl    $0x4,%eax
  803f9c:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803fa1:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803fa3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fa6:	89 d0                	mov    %edx,%eax
  803fa8:	01 c0                	add    %eax,%eax
  803faa:	01 d0                	add    %edx,%eax
  803fac:	c1 e0 02             	shl    $0x2,%eax
  803faf:	05 6a 60 80 00       	add    $0x80606a,%eax
  803fb4:	66 8b 00             	mov    (%eax),%ax
  803fb7:	8d 50 01             	lea    0x1(%eax),%edx
  803fba:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803fbd:	89 c8                	mov    %ecx,%eax
  803fbf:	01 c0                	add    %eax,%eax
  803fc1:	01 c8                	add    %ecx,%eax
  803fc3:	c1 e0 02             	shl    $0x2,%eax
  803fc6:	05 6a 60 80 00       	add    $0x80606a,%eax
  803fcb:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803fce:	b8 00 10 00 00       	mov    $0x1000,%eax
  803fd3:	ba 00 00 00 00       	mov    $0x0,%edx
  803fd8:	f7 75 ec             	divl   -0x14(%ebp)
  803fdb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803fde:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fe1:	89 d0                	mov    %edx,%eax
  803fe3:	01 c0                	add    %eax,%eax
  803fe5:	01 d0                	add    %edx,%eax
  803fe7:	c1 e0 02             	shl    $0x2,%eax
  803fea:	05 6a 60 80 00       	add    $0x80606a,%eax
  803fef:	66 8b 00             	mov    (%eax),%ax
  803ff2:	0f b7 c0             	movzwl %ax,%eax
  803ff5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803ff8:	0f 85 d3 01 00 00    	jne    8041d1 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804001:	c1 e0 04             	shl    $0x4,%eax
  804004:	05 80 e0 81 00       	add    $0x81e080,%eax
  804009:	8b 00                	mov    (%eax),%eax
  80400b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  80400e:	e9 f1 00 00 00       	jmp    804104 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804016:	8b 00                	mov    (%eax),%eax
  804018:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  80401b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80401e:	c1 e0 0c             	shl    $0xc,%eax
  804021:	89 c2                	mov    %eax,%edx
  804023:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804028:	01 d0                	add    %edx,%eax
  80402a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  80402d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804030:	40                   	inc    %eax
  804031:	c1 e0 0c             	shl    $0xc,%eax
  804034:	89 c2                	mov    %eax,%edx
  804036:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80403b:	01 d0                	add    %edx,%eax
  80403d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  804040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804043:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  804046:	0f 82 b8 00 00 00    	jb     804104 <free_block+0x290>
  80404c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80404f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804052:	0f 83 ac 00 00 00    	jae    804104 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  804058:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80405c:	75 17                	jne    804075 <free_block+0x201>
  80405e:	83 ec 04             	sub    $0x4,%esp
  804061:	68 ad 53 80 00       	push   $0x8053ad
  804066:	68 e2 00 00 00       	push   $0xe2
  80406b:	68 73 53 80 00       	push   $0x805373
  804070:	e8 50 c6 ff ff       	call   8006c5 <_panic>
  804075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804078:	8b 00                	mov    (%eax),%eax
  80407a:	85 c0                	test   %eax,%eax
  80407c:	74 10                	je     80408e <free_block+0x21a>
  80407e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804081:	8b 00                	mov    (%eax),%eax
  804083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804086:	8b 52 04             	mov    0x4(%edx),%edx
  804089:	89 50 04             	mov    %edx,0x4(%eax)
  80408c:	eb 14                	jmp    8040a2 <free_block+0x22e>
  80408e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804091:	8b 40 04             	mov    0x4(%eax),%eax
  804094:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804097:	c1 e2 04             	shl    $0x4,%edx
  80409a:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8040a0:	89 02                	mov    %eax,(%edx)
  8040a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a5:	8b 40 04             	mov    0x4(%eax),%eax
  8040a8:	85 c0                	test   %eax,%eax
  8040aa:	74 0f                	je     8040bb <free_block+0x247>
  8040ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040af:	8b 40 04             	mov    0x4(%eax),%eax
  8040b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040b5:	8b 12                	mov    (%edx),%edx
  8040b7:	89 10                	mov    %edx,(%eax)
  8040b9:	eb 13                	jmp    8040ce <free_block+0x25a>
  8040bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040be:	8b 00                	mov    (%eax),%eax
  8040c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8040c3:	c1 e2 04             	shl    $0x4,%edx
  8040c6:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8040cc:	89 02                	mov    %eax,(%edx)
  8040ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040e4:	c1 e0 04             	shl    $0x4,%eax
  8040e7:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8040ec:	8b 00                	mov    (%eax),%eax
  8040ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8040f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040f4:	c1 e0 04             	shl    $0x4,%eax
  8040f7:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8040fc:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  8040fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804101:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804104:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804108:	0f 85 05 ff ff ff    	jne    804013 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  80410e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804111:	89 d0                	mov    %edx,%eax
  804113:	01 c0                	add    %eax,%eax
  804115:	01 d0                	add    %edx,%eax
  804117:	c1 e0 02             	shl    $0x2,%eax
  80411a:	05 68 60 80 00       	add    $0x806068,%eax
  80411f:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  804124:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804127:	89 d0                	mov    %edx,%eax
  804129:	01 c0                	add    %eax,%eax
  80412b:	01 d0                	add    %edx,%eax
  80412d:	c1 e0 02             	shl    $0x2,%eax
  804130:	05 6a 60 80 00       	add    $0x80606a,%eax
  804135:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  80413a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80413d:	89 d0                	mov    %edx,%eax
  80413f:	01 c0                	add    %eax,%eax
  804141:	01 d0                	add    %edx,%eax
  804143:	c1 e0 02             	shl    $0x2,%eax
  804146:	05 60 60 80 00       	add    $0x806060,%eax
  80414b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  80414e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804152:	75 17                	jne    80416b <free_block+0x2f7>
  804154:	83 ec 04             	sub    $0x4,%esp
  804157:	68 cc 53 80 00       	push   $0x8053cc
  80415c:	68 eb 00 00 00       	push   $0xeb
  804161:	68 73 53 80 00       	push   $0x805373
  804166:	e8 5a c5 ff ff       	call   8006c5 <_panic>
  80416b:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  804171:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804174:	89 50 04             	mov    %edx,0x4(%eax)
  804177:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80417a:	8b 40 04             	mov    0x4(%eax),%eax
  80417d:	85 c0                	test   %eax,%eax
  80417f:	74 0c                	je     80418d <free_block+0x319>
  804181:	a1 4c 60 80 00       	mov    0x80604c,%eax
  804186:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804189:	89 10                	mov    %edx,(%eax)
  80418b:	eb 08                	jmp    804195 <free_block+0x321>
  80418d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804190:	a3 48 60 80 00       	mov    %eax,0x806048
  804195:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804198:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80419d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041a6:	a1 54 60 80 00       	mov    0x806054,%eax
  8041ab:	40                   	inc    %eax
  8041ac:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  8041b1:	83 ec 0c             	sub    $0xc,%esp
  8041b4:	ff 75 d0             	pushl  -0x30(%ebp)
  8041b7:	e8 ce f5 ff ff       	call   80378a <to_page_va>
  8041bc:	83 c4 10             	add    $0x10,%esp
  8041bf:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  8041c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041c5:	83 ec 0c             	sub    $0xc,%esp
  8041c8:	50                   	push   %eax
  8041c9:	e8 9e d7 ff ff       	call   80196c <return_page>
  8041ce:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8041d1:	90                   	nop
  8041d2:	c9                   	leave  
  8041d3:	c3                   	ret    

008041d4 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8041d4:	55                   	push   %ebp
  8041d5:	89 e5                	mov    %esp,%ebp
  8041d7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8041da:	83 ec 04             	sub    $0x4,%esp
  8041dd:	68 6c 54 80 00       	push   $0x80546c
  8041e2:	68 01 01 00 00       	push   $0x101
  8041e7:	68 73 53 80 00       	push   $0x805373
  8041ec:	e8 d4 c4 ff ff       	call   8006c5 <_panic>

008041f1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8041f1:	55                   	push   %ebp
  8041f2:	89 e5                	mov    %esp,%ebp
  8041f4:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8041f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8041fa:	89 d0                	mov    %edx,%eax
  8041fc:	c1 e0 02             	shl    $0x2,%eax
  8041ff:	01 d0                	add    %edx,%eax
  804201:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804208:	01 d0                	add    %edx,%eax
  80420a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804211:	01 d0                	add    %edx,%eax
  804213:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80421a:	01 d0                	add    %edx,%eax
  80421c:	c1 e0 04             	shl    $0x4,%eax
  80421f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  804222:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  804229:	0f 31                	rdtsc  
  80422b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80422e:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804231:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804234:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80423a:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80423d:	eb 46                	jmp    804285 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80423f:	0f 31                	rdtsc  
  804241:	89 45 d0             	mov    %eax,-0x30(%ebp)
  804244:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804247:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80424a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80424d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  804250:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804253:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804259:	29 c2                	sub    %eax,%edx
  80425b:	89 d0                	mov    %edx,%eax
  80425d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804260:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804266:	89 d1                	mov    %edx,%ecx
  804268:	29 c1                	sub    %eax,%ecx
  80426a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80426d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804270:	39 c2                	cmp    %eax,%edx
  804272:	0f 97 c0             	seta   %al
  804275:	0f b6 c0             	movzbl %al,%eax
  804278:	29 c1                	sub    %eax,%ecx
  80427a:	89 c8                	mov    %ecx,%eax
  80427c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80427f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804282:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  804285:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804288:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80428b:	72 b2                	jb     80423f <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80428d:	90                   	nop
  80428e:	c9                   	leave  
  80428f:	c3                   	ret    

00804290 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804290:	55                   	push   %ebp
  804291:	89 e5                	mov    %esp,%ebp
  804293:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804296:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80429d:	eb 03                	jmp    8042a2 <busy_wait+0x12>
  80429f:	ff 45 fc             	incl   -0x4(%ebp)
  8042a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8042a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8042a8:	72 f5                	jb     80429f <busy_wait+0xf>
	return i;
  8042aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8042ad:	c9                   	leave  
  8042ae:	c3                   	ret    

008042af <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  8042af:	55                   	push   %ebp
  8042b0:	89 e5                	mov    %esp,%ebp
  8042b2:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  8042b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8042b9:	74 1c                	je     8042d7 <init_uspinlock+0x28>
  8042bb:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8042bf:	74 16                	je     8042d7 <init_uspinlock+0x28>
  8042c1:	68 90 54 80 00       	push   $0x805490
  8042c6:	68 af 54 80 00       	push   $0x8054af
  8042cb:	6a 10                	push   $0x10
  8042cd:	68 c4 54 80 00       	push   $0x8054c4
  8042d2:	e8 ee c3 ff ff       	call   8006c5 <_panic>
	strcpy(lk->name, name);
  8042d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042da:	83 c0 04             	add    $0x4,%eax
  8042dd:	83 ec 08             	sub    $0x8,%esp
  8042e0:	ff 75 0c             	pushl  0xc(%ebp)
  8042e3:	50                   	push   %eax
  8042e4:	e8 d2 cd ff ff       	call   8010bb <strcpy>
  8042e9:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  8042ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8042f1:	2b 45 10             	sub    0x10(%ebp),%eax
  8042f4:	89 c2                	mov    %eax,%edx
  8042f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8042f9:	89 10                	mov    %edx,(%eax)
}
  8042fb:	90                   	nop
  8042fc:	c9                   	leave  
  8042fd:	c3                   	ret    

008042fe <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8042fe:	55                   	push   %ebp
  8042ff:	89 e5                	mov    %esp,%ebp
  804301:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  804304:	90                   	nop
  804305:	8b 45 08             	mov    0x8(%ebp),%eax
  804308:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80430b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  804312:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804318:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80431b:	f0 87 02             	lock xchg %eax,(%edx)
  80431e:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  804321:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804324:	85 c0                	test   %eax,%eax
  804326:	75 dd                	jne    804305 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804328:	8b 45 08             	mov    0x8(%ebp),%eax
  80432b:	8d 48 04             	lea    0x4(%eax),%ecx
  80432e:	a1 20 60 80 00       	mov    0x806020,%eax
  804333:	8d 50 20             	lea    0x20(%eax),%edx
  804336:	a1 20 60 80 00       	mov    0x806020,%eax
  80433b:	8b 40 10             	mov    0x10(%eax),%eax
  80433e:	51                   	push   %ecx
  80433f:	52                   	push   %edx
  804340:	50                   	push   %eax
  804341:	68 d4 54 80 00       	push   $0x8054d4
  804346:	e8 48 c6 ff ff       	call   800993 <cprintf>
  80434b:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  80434e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  804353:	90                   	nop
  804354:	c9                   	leave  
  804355:	c3                   	ret    

00804356 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  804356:	55                   	push   %ebp
  804357:	89 e5                	mov    %esp,%ebp
  804359:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  80435c:	8b 45 08             	mov    0x8(%ebp),%eax
  80435f:	8b 00                	mov    (%eax),%eax
  804361:	85 c0                	test   %eax,%eax
  804363:	75 18                	jne    80437d <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  804365:	8b 45 08             	mov    0x8(%ebp),%eax
  804368:	83 c0 04             	add    $0x4,%eax
  80436b:	50                   	push   %eax
  80436c:	68 f8 54 80 00       	push   $0x8054f8
  804371:	6a 2b                	push   $0x2b
  804373:	68 c4 54 80 00       	push   $0x8054c4
  804378:	e8 48 c3 ff ff       	call   8006c5 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  80437d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  804382:	8b 45 08             	mov    0x8(%ebp),%eax
  804385:	8b 55 08             	mov    0x8(%ebp),%edx
  804388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80438e:	8b 45 08             	mov    0x8(%ebp),%eax
  804391:	8d 48 04             	lea    0x4(%eax),%ecx
  804394:	a1 20 60 80 00       	mov    0x806020,%eax
  804399:	8d 50 20             	lea    0x20(%eax),%edx
  80439c:	a1 20 60 80 00       	mov    0x806020,%eax
  8043a1:	8b 40 10             	mov    0x10(%eax),%eax
  8043a4:	51                   	push   %ecx
  8043a5:	52                   	push   %edx
  8043a6:	50                   	push   %eax
  8043a7:	68 18 55 80 00       	push   $0x805518
  8043ac:	e8 e2 c5 ff ff       	call   800993 <cprintf>
  8043b1:	83 c4 10             	add    $0x10,%esp
}
  8043b4:	90                   	nop
  8043b5:	c9                   	leave  
  8043b6:	c3                   	ret    
  8043b7:	90                   	nop

008043b8 <__udivdi3>:
  8043b8:	55                   	push   %ebp
  8043b9:	57                   	push   %edi
  8043ba:	56                   	push   %esi
  8043bb:	53                   	push   %ebx
  8043bc:	83 ec 1c             	sub    $0x1c,%esp
  8043bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8043c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8043c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8043cf:	89 ca                	mov    %ecx,%edx
  8043d1:	89 f8                	mov    %edi,%eax
  8043d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8043d7:	85 f6                	test   %esi,%esi
  8043d9:	75 2d                	jne    804408 <__udivdi3+0x50>
  8043db:	39 cf                	cmp    %ecx,%edi
  8043dd:	77 65                	ja     804444 <__udivdi3+0x8c>
  8043df:	89 fd                	mov    %edi,%ebp
  8043e1:	85 ff                	test   %edi,%edi
  8043e3:	75 0b                	jne    8043f0 <__udivdi3+0x38>
  8043e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8043ea:	31 d2                	xor    %edx,%edx
  8043ec:	f7 f7                	div    %edi
  8043ee:	89 c5                	mov    %eax,%ebp
  8043f0:	31 d2                	xor    %edx,%edx
  8043f2:	89 c8                	mov    %ecx,%eax
  8043f4:	f7 f5                	div    %ebp
  8043f6:	89 c1                	mov    %eax,%ecx
  8043f8:	89 d8                	mov    %ebx,%eax
  8043fa:	f7 f5                	div    %ebp
  8043fc:	89 cf                	mov    %ecx,%edi
  8043fe:	89 fa                	mov    %edi,%edx
  804400:	83 c4 1c             	add    $0x1c,%esp
  804403:	5b                   	pop    %ebx
  804404:	5e                   	pop    %esi
  804405:	5f                   	pop    %edi
  804406:	5d                   	pop    %ebp
  804407:	c3                   	ret    
  804408:	39 ce                	cmp    %ecx,%esi
  80440a:	77 28                	ja     804434 <__udivdi3+0x7c>
  80440c:	0f bd fe             	bsr    %esi,%edi
  80440f:	83 f7 1f             	xor    $0x1f,%edi
  804412:	75 40                	jne    804454 <__udivdi3+0x9c>
  804414:	39 ce                	cmp    %ecx,%esi
  804416:	72 0a                	jb     804422 <__udivdi3+0x6a>
  804418:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80441c:	0f 87 9e 00 00 00    	ja     8044c0 <__udivdi3+0x108>
  804422:	b8 01 00 00 00       	mov    $0x1,%eax
  804427:	89 fa                	mov    %edi,%edx
  804429:	83 c4 1c             	add    $0x1c,%esp
  80442c:	5b                   	pop    %ebx
  80442d:	5e                   	pop    %esi
  80442e:	5f                   	pop    %edi
  80442f:	5d                   	pop    %ebp
  804430:	c3                   	ret    
  804431:	8d 76 00             	lea    0x0(%esi),%esi
  804434:	31 ff                	xor    %edi,%edi
  804436:	31 c0                	xor    %eax,%eax
  804438:	89 fa                	mov    %edi,%edx
  80443a:	83 c4 1c             	add    $0x1c,%esp
  80443d:	5b                   	pop    %ebx
  80443e:	5e                   	pop    %esi
  80443f:	5f                   	pop    %edi
  804440:	5d                   	pop    %ebp
  804441:	c3                   	ret    
  804442:	66 90                	xchg   %ax,%ax
  804444:	89 d8                	mov    %ebx,%eax
  804446:	f7 f7                	div    %edi
  804448:	31 ff                	xor    %edi,%edi
  80444a:	89 fa                	mov    %edi,%edx
  80444c:	83 c4 1c             	add    $0x1c,%esp
  80444f:	5b                   	pop    %ebx
  804450:	5e                   	pop    %esi
  804451:	5f                   	pop    %edi
  804452:	5d                   	pop    %ebp
  804453:	c3                   	ret    
  804454:	bd 20 00 00 00       	mov    $0x20,%ebp
  804459:	89 eb                	mov    %ebp,%ebx
  80445b:	29 fb                	sub    %edi,%ebx
  80445d:	89 f9                	mov    %edi,%ecx
  80445f:	d3 e6                	shl    %cl,%esi
  804461:	89 c5                	mov    %eax,%ebp
  804463:	88 d9                	mov    %bl,%cl
  804465:	d3 ed                	shr    %cl,%ebp
  804467:	89 e9                	mov    %ebp,%ecx
  804469:	09 f1                	or     %esi,%ecx
  80446b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80446f:	89 f9                	mov    %edi,%ecx
  804471:	d3 e0                	shl    %cl,%eax
  804473:	89 c5                	mov    %eax,%ebp
  804475:	89 d6                	mov    %edx,%esi
  804477:	88 d9                	mov    %bl,%cl
  804479:	d3 ee                	shr    %cl,%esi
  80447b:	89 f9                	mov    %edi,%ecx
  80447d:	d3 e2                	shl    %cl,%edx
  80447f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804483:	88 d9                	mov    %bl,%cl
  804485:	d3 e8                	shr    %cl,%eax
  804487:	09 c2                	or     %eax,%edx
  804489:	89 d0                	mov    %edx,%eax
  80448b:	89 f2                	mov    %esi,%edx
  80448d:	f7 74 24 0c          	divl   0xc(%esp)
  804491:	89 d6                	mov    %edx,%esi
  804493:	89 c3                	mov    %eax,%ebx
  804495:	f7 e5                	mul    %ebp
  804497:	39 d6                	cmp    %edx,%esi
  804499:	72 19                	jb     8044b4 <__udivdi3+0xfc>
  80449b:	74 0b                	je     8044a8 <__udivdi3+0xf0>
  80449d:	89 d8                	mov    %ebx,%eax
  80449f:	31 ff                	xor    %edi,%edi
  8044a1:	e9 58 ff ff ff       	jmp    8043fe <__udivdi3+0x46>
  8044a6:	66 90                	xchg   %ax,%ax
  8044a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8044ac:	89 f9                	mov    %edi,%ecx
  8044ae:	d3 e2                	shl    %cl,%edx
  8044b0:	39 c2                	cmp    %eax,%edx
  8044b2:	73 e9                	jae    80449d <__udivdi3+0xe5>
  8044b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8044b7:	31 ff                	xor    %edi,%edi
  8044b9:	e9 40 ff ff ff       	jmp    8043fe <__udivdi3+0x46>
  8044be:	66 90                	xchg   %ax,%ax
  8044c0:	31 c0                	xor    %eax,%eax
  8044c2:	e9 37 ff ff ff       	jmp    8043fe <__udivdi3+0x46>
  8044c7:	90                   	nop

008044c8 <__umoddi3>:
  8044c8:	55                   	push   %ebp
  8044c9:	57                   	push   %edi
  8044ca:	56                   	push   %esi
  8044cb:	53                   	push   %ebx
  8044cc:	83 ec 1c             	sub    $0x1c,%esp
  8044cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8044d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8044d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8044df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8044e7:	89 f3                	mov    %esi,%ebx
  8044e9:	89 fa                	mov    %edi,%edx
  8044eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044ef:	89 34 24             	mov    %esi,(%esp)
  8044f2:	85 c0                	test   %eax,%eax
  8044f4:	75 1a                	jne    804510 <__umoddi3+0x48>
  8044f6:	39 f7                	cmp    %esi,%edi
  8044f8:	0f 86 a2 00 00 00    	jbe    8045a0 <__umoddi3+0xd8>
  8044fe:	89 c8                	mov    %ecx,%eax
  804500:	89 f2                	mov    %esi,%edx
  804502:	f7 f7                	div    %edi
  804504:	89 d0                	mov    %edx,%eax
  804506:	31 d2                	xor    %edx,%edx
  804508:	83 c4 1c             	add    $0x1c,%esp
  80450b:	5b                   	pop    %ebx
  80450c:	5e                   	pop    %esi
  80450d:	5f                   	pop    %edi
  80450e:	5d                   	pop    %ebp
  80450f:	c3                   	ret    
  804510:	39 f0                	cmp    %esi,%eax
  804512:	0f 87 ac 00 00 00    	ja     8045c4 <__umoddi3+0xfc>
  804518:	0f bd e8             	bsr    %eax,%ebp
  80451b:	83 f5 1f             	xor    $0x1f,%ebp
  80451e:	0f 84 ac 00 00 00    	je     8045d0 <__umoddi3+0x108>
  804524:	bf 20 00 00 00       	mov    $0x20,%edi
  804529:	29 ef                	sub    %ebp,%edi
  80452b:	89 fe                	mov    %edi,%esi
  80452d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804531:	89 e9                	mov    %ebp,%ecx
  804533:	d3 e0                	shl    %cl,%eax
  804535:	89 d7                	mov    %edx,%edi
  804537:	89 f1                	mov    %esi,%ecx
  804539:	d3 ef                	shr    %cl,%edi
  80453b:	09 c7                	or     %eax,%edi
  80453d:	89 e9                	mov    %ebp,%ecx
  80453f:	d3 e2                	shl    %cl,%edx
  804541:	89 14 24             	mov    %edx,(%esp)
  804544:	89 d8                	mov    %ebx,%eax
  804546:	d3 e0                	shl    %cl,%eax
  804548:	89 c2                	mov    %eax,%edx
  80454a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80454e:	d3 e0                	shl    %cl,%eax
  804550:	89 44 24 04          	mov    %eax,0x4(%esp)
  804554:	8b 44 24 08          	mov    0x8(%esp),%eax
  804558:	89 f1                	mov    %esi,%ecx
  80455a:	d3 e8                	shr    %cl,%eax
  80455c:	09 d0                	or     %edx,%eax
  80455e:	d3 eb                	shr    %cl,%ebx
  804560:	89 da                	mov    %ebx,%edx
  804562:	f7 f7                	div    %edi
  804564:	89 d3                	mov    %edx,%ebx
  804566:	f7 24 24             	mull   (%esp)
  804569:	89 c6                	mov    %eax,%esi
  80456b:	89 d1                	mov    %edx,%ecx
  80456d:	39 d3                	cmp    %edx,%ebx
  80456f:	0f 82 87 00 00 00    	jb     8045fc <__umoddi3+0x134>
  804575:	0f 84 91 00 00 00    	je     80460c <__umoddi3+0x144>
  80457b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80457f:	29 f2                	sub    %esi,%edx
  804581:	19 cb                	sbb    %ecx,%ebx
  804583:	89 d8                	mov    %ebx,%eax
  804585:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804589:	d3 e0                	shl    %cl,%eax
  80458b:	89 e9                	mov    %ebp,%ecx
  80458d:	d3 ea                	shr    %cl,%edx
  80458f:	09 d0                	or     %edx,%eax
  804591:	89 e9                	mov    %ebp,%ecx
  804593:	d3 eb                	shr    %cl,%ebx
  804595:	89 da                	mov    %ebx,%edx
  804597:	83 c4 1c             	add    $0x1c,%esp
  80459a:	5b                   	pop    %ebx
  80459b:	5e                   	pop    %esi
  80459c:	5f                   	pop    %edi
  80459d:	5d                   	pop    %ebp
  80459e:	c3                   	ret    
  80459f:	90                   	nop
  8045a0:	89 fd                	mov    %edi,%ebp
  8045a2:	85 ff                	test   %edi,%edi
  8045a4:	75 0b                	jne    8045b1 <__umoddi3+0xe9>
  8045a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8045ab:	31 d2                	xor    %edx,%edx
  8045ad:	f7 f7                	div    %edi
  8045af:	89 c5                	mov    %eax,%ebp
  8045b1:	89 f0                	mov    %esi,%eax
  8045b3:	31 d2                	xor    %edx,%edx
  8045b5:	f7 f5                	div    %ebp
  8045b7:	89 c8                	mov    %ecx,%eax
  8045b9:	f7 f5                	div    %ebp
  8045bb:	89 d0                	mov    %edx,%eax
  8045bd:	e9 44 ff ff ff       	jmp    804506 <__umoddi3+0x3e>
  8045c2:	66 90                	xchg   %ax,%ax
  8045c4:	89 c8                	mov    %ecx,%eax
  8045c6:	89 f2                	mov    %esi,%edx
  8045c8:	83 c4 1c             	add    $0x1c,%esp
  8045cb:	5b                   	pop    %ebx
  8045cc:	5e                   	pop    %esi
  8045cd:	5f                   	pop    %edi
  8045ce:	5d                   	pop    %ebp
  8045cf:	c3                   	ret    
  8045d0:	3b 04 24             	cmp    (%esp),%eax
  8045d3:	72 06                	jb     8045db <__umoddi3+0x113>
  8045d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8045d9:	77 0f                	ja     8045ea <__umoddi3+0x122>
  8045db:	89 f2                	mov    %esi,%edx
  8045dd:	29 f9                	sub    %edi,%ecx
  8045df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8045e3:	89 14 24             	mov    %edx,(%esp)
  8045e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8045ee:	8b 14 24             	mov    (%esp),%edx
  8045f1:	83 c4 1c             	add    $0x1c,%esp
  8045f4:	5b                   	pop    %ebx
  8045f5:	5e                   	pop    %esi
  8045f6:	5f                   	pop    %edi
  8045f7:	5d                   	pop    %ebp
  8045f8:	c3                   	ret    
  8045f9:	8d 76 00             	lea    0x0(%esi),%esi
  8045fc:	2b 04 24             	sub    (%esp),%eax
  8045ff:	19 fa                	sbb    %edi,%edx
  804601:	89 d1                	mov    %edx,%ecx
  804603:	89 c6                	mov    %eax,%esi
  804605:	e9 71 ff ff ff       	jmp    80457b <__umoddi3+0xb3>
  80460a:	66 90                	xchg   %ax,%ax
  80460c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804610:	72 ea                	jb     8045fc <__umoddi3+0x134>
  804612:	89 d9                	mov    %ebx,%ecx
  804614:	e9 62 ff ff ff       	jmp    80457b <__umoddi3+0xb3>
