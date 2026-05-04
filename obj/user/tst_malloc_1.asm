
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 01 13 00 00       	call   801337 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <inRange>:
bool allocSpaceInPageAlloc(int index, uint32 size, bool writeData, uint32 expectedNumOfTables);
bool freeSpaceInPageAlloc(int index, bool isDataWritten);
int initial_page_allocations();

int inRange(int val, int min, int max)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
	return (val >= min && val <= max) ? 1 : 0;
  80003b:	8b 45 08             	mov    0x8(%ebp),%eax
  80003e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800041:	7c 0f                	jl     800052 <inRange+0x1a>
  800043:	8b 45 08             	mov    0x8(%ebp),%eax
  800046:	3b 45 10             	cmp    0x10(%ebp),%eax
  800049:	7f 07                	jg     800052 <inRange+0x1a>
  80004b:	b8 01 00 00 00       	mov    $0x1,%eax
  800050:	eb 05                	jmp    800057 <inRange+0x1f>
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800057:	5d                   	pop    %ebp
  800058:	c3                   	ret    

00800059 <allocSpaceInPageAlloc>:

bool allocSpaceInPageAlloc(int index, uint32 size, bool writeData, uint32 expectedNumOfTables)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	53                   	push   %ebx
  80005d:	83 ec 34             	sub    $0x34,%esp
	int correct = 1;
  800060:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	int freeFrames = (int)sys_calculate_free_frames() ;
  800067:	e8 bd 40 00 00       	call   804129 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 00 41 00 00       	call   804174 <sys_pf_calculate_allocated_pages>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
	char *byteArr;

	//Allocate the required size
	requestedSizes[index] = size ;
  800077:	8b 45 08             	mov    0x8(%ebp),%eax
  80007a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80007d:	89 14 85 60 71 80 00 	mov    %edx,0x807160(,%eax,4)
	uint32 expectedNumOfFrames = ROUNDUP(requestedSizes[index], PAGE_SIZE) / PAGE_SIZE ;
  800084:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80008b:	8b 45 08             	mov    0x8(%ebp),%eax
  80008e:	8b 14 85 60 71 80 00 	mov    0x807160(,%eax,4),%edx
  800095:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800098:	01 d0                	add    %edx,%eax
  80009a:	48                   	dec    %eax
  80009b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80009e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a6:	f7 75 e4             	divl   -0x1c(%ebp)
  8000a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ac:	29 d0                	sub    %edx,%eax
  8000ae:	c1 e8 0c             	shr    $0xc,%eax
  8000b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	{
		ptr_allocations[index] = malloc(requestedSizes[index]);
  8000b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b7:	8b 04 85 60 71 80 00 	mov    0x807160(,%eax,4),%eax
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	50                   	push   %eax
  8000c2:	e8 10 27 00 00       	call   8027d7 <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	89 c2                	mov    %eax,%edx
  8000cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cf:	89 14 85 20 70 80 00 	mov    %edx,0x807020(,%eax,4)
	}

	//Check allocation in RAM & Page File
	expectedNumOfFrames = expectedNumOfTables ;
  8000d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8000d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8000dc:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000df:	e8 45 40 00 00       	call   804129 <sys_calculate_free_frames>
  8000e4:	29 c3                	sub    %eax,%ebx
  8000e6:	89 d8                	mov    %ebx,%eax
  8000e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8000eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000ee:	83 c0 02             	add    $0x2,%eax
  8000f1:	89 c1                	mov    %eax,%ecx
  8000f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8000f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	51                   	push   %ecx
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	e8 34 ff ff ff       	call   800038 <inRange>
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	75 29                	jne    800134 <allocSpaceInPageAlloc+0xdb>
	{correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong allocation in alloc#%d: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", index, expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  80010b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800115:	83 c0 02             	add    $0x2,%eax
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	ff 75 f0             	pushl  -0x10(%ebp)
  800122:	ff 75 08             	pushl  0x8(%ebp)
  800125:	68 a0 53 80 00       	push   $0x8053a0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 ba 16 00 00       	call   8017eb <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 3b 40 00 00       	call   804174 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 1c 54 80 00       	push   $0x80541c
  800150:	6a 0c                	push   $0xc
  800152:	e8 94 16 00 00       	call   8017eb <cprintf_colored>
  800157:	83 c4 10             	add    $0x10,%esp

	lastIndices[index] = (size)/sizeof(char) - 1;
  80015a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015d:	48                   	dec    %eax
  80015e:	89 c2                	mov    %eax,%edx
  800160:	8b 45 08             	mov    0x8(%ebp),%eax
  800163:	89 14 85 c0 70 80 00 	mov    %edx,0x8070c0(,%eax,4)
	if (writeData)
  80016a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80016e:	0f 84 25 01 00 00    	je     800299 <allocSpaceInPageAlloc+0x240>
	{
		//Write in first & last pages
		freeFrames = sys_calculate_free_frames() ;
  800174:	e8 b0 3f 00 00       	call   804129 <sys_calculate_free_frames>
  800179:	89 45 ec             	mov    %eax,-0x14(%ebp)
		byteArr = (char *) ptr_allocations[index];
  80017c:	8b 45 08             	mov    0x8(%ebp),%eax
  80017f:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800186:	89 45 d8             	mov    %eax,-0x28(%ebp)
		byteArr[0] = maxByte ;
  800189:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80018c:	c6 00 7f             	movb   $0x7f,(%eax)
		byteArr[lastIndices[index]] = maxByte ;
  80018f:	8b 45 08             	mov    0x8(%ebp),%eax
  800192:	8b 04 85 c0 70 80 00 	mov    0x8070c0(,%eax,4),%eax
  800199:	89 c2                	mov    %eax,%edx
  80019b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80019e:	01 d0                	add    %edx,%eax
  8001a0:	c6 00 7f             	movb   $0x7f,(%eax)

		//Check allocation in RAM & Page File
		expectedNumOfFrames = 1; /*table already created in malloc due to marking the allocated pages*/ ;
  8001a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if(size > PAGE_SIZE)
  8001aa:	81 7d 0c 00 10 00 00 	cmpl   $0x1000,0xc(%ebp)
  8001b1:	76 03                	jbe    8001b6 <allocSpaceInPageAlloc+0x15d>
			expectedNumOfFrames++ ;
  8001b3:	ff 45 f0             	incl   -0x10(%ebp)

		actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8001b6:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001b9:	e8 6b 3f 00 00       	call   804129 <sys_calculate_free_frames>
  8001be:	29 c3                	sub    %eax,%ebx
  8001c0:	89 d8                	mov    %ebx,%eax
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8001c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001c8:	83 c0 02             	add    $0x2,%eax
  8001cb:	89 c1                	mov    %eax,%ecx
  8001cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8001d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	51                   	push   %ecx
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	e8 5a fe ff ff       	call   800038 <inRange>
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	85 c0                	test   %eax,%eax
  8001e3:	75 22                	jne    800207 <allocSpaceInPageAlloc+0x1ae>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong fault handler in alloc#%d: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", index, expectedNumOfFrames, actualNumOfFrames);}
  8001e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 08             	pushl  0x8(%ebp)
  8001f8:	68 94 54 80 00       	push   $0x805494
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 e7 15 00 00       	call   8017eb <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 68 3f 00 00       	call   804174 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 20 55 80 00       	push   $0x805520
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 ba 15 00 00       	call   8017eb <cprintf_colored>
  800231:	83 c4 10             	add    $0x10,%esp

		//Check WS
		uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndices[index]])), PAGE_SIZE)} ;
  800234:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800237:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80023a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800242:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	8b 04 85 c0 70 80 00 	mov    0x8070c0(,%eax,4),%eax
  80024f:	89 c2                	mov    %eax,%edx
  800251:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800254:	01 d0                	add    %edx,%eax
  800256:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800259:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (sys_check_WS_list(expectedVAs, expectedNumOfFrames, 0, 2) != 1)
  800264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800267:	6a 02                	push   $0x2
  800269:	6a 00                	push   $0x0
  80026b:	50                   	push   %eax
  80026c:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80026f:	50                   	push   %eax
  800270:	e8 76 42 00 00       	call   8044eb <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 98 55 80 00       	push   $0x805598
  80028f:	6a 0c                	push   $0xc
  800291:	e8 55 15 00 00       	call   8017eb <cprintf_colored>
  800296:	83 c4 10             	add    $0x10,%esp
	}
	return correct;
  800299:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  80029c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <freeSpaceInPageAlloc>:

bool freeSpaceInPageAlloc(int index, bool isDataWritten)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 38             	sub    $0x38,%esp
	int correct = 1;
  8002a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	int freeFrames = (int)sys_calculate_free_frames() ;
  8002ae:	e8 76 3e 00 00       	call   804129 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 b9 3e 00 00       	call   804174 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 04 2a 00 00       	call   802cd5 <free>
  8002d1:	83 c4 10             	add    $0x10,%esp
	}

	uint32 expectedNumOfFrames = 0;
  8002d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (isDataWritten)
  8002db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8002df:	74 1b                	je     8002fc <freeSpaceInPageAlloc+0x5b>
	{
		expectedNumOfFrames = 1;
  8002e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if(requestedSizes[index] > PAGE_SIZE)
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	8b 04 85 60 71 80 00 	mov    0x807160(,%eax,4),%eax
  8002f2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8002f7:	76 03                	jbe    8002fc <freeSpaceInPageAlloc+0x5b>
			expectedNumOfFrames++ ;
  8002f9:	ff 45 f0             	incl   -0x10(%ebp)
	}
	//Check allocation in RAM & Page File
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8002fc:	e8 73 3e 00 00       	call   804174 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 d0 55 80 00       	push   $0x8055d0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 cc 14 00 00       	call   8017eb <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 02 3e 00 00       	call   804129 <sys_calculate_free_frames>
  800327:	89 c2                	mov    %eax,%edx
  800329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032c:	29 c2                	sub    %eax,%edx
  80032e:	89 d0                	mov    %edx,%eax
  800330:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800333:	74 1c                	je     800351 <freeSpaceInPageAlloc+0xb0>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 Wrong free in alloc#%d: WS pages in memory and/or page tables are not freed correctly\n", index);}
  800335:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	ff 75 08             	pushl  0x8(%ebp)
  800342:	68 1c 56 80 00       	push   $0x80561c
  800347:	6a 0c                	push   $0xc
  800349:	e8 9d 14 00 00       	call   8017eb <cprintf_colored>
  80034e:	83 c4 10             	add    $0x10,%esp

	if (isDataWritten)
  800351:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800355:	74 72                	je     8003c9 <freeSpaceInPageAlloc+0x128>
	{
		//Check WS
		char* byteArr = (char *) ptr_allocations[index];
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800361:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndices[index]])), PAGE_SIZE)} ;
  800364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800367:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80036a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800372:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	8b 04 85 c0 70 80 00 	mov    0x8070c0(,%eax,4),%eax
  80037f:	89 c2                	mov    %eax,%edx
  800381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800389:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800391:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (sys_check_WS_list(notExpectedVAs, expectedNumOfFrames, 0, 3) != 1)
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800397:	6a 03                	push   $0x3
  800399:	6a 00                	push   $0x0
  80039b:	50                   	push   %eax
  80039c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80039f:	50                   	push   %eax
  8003a0:	e8 46 41 00 00       	call   8044eb <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 78 56 80 00       	push   $0x805678
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 25 14 00 00       	call   8017eb <cprintf_colored>
  8003c6:	83 c4 10             	add    $0x10,%esp
	}
	return correct;
  8003c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <initial_page_allocations>:

int initial_page_allocations()
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	57                   	push   %edi
  8003d2:	53                   	push   %ebx
  8003d3:	81 ec 40 01 00 00    	sub    $0x140,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE FOR SOME
	 * IMPLEMENTATIONS TO DYNAMICALLY ALLOCATE SPECIAL DATA
	 * STRUCTURE TO MANAGE THE PAGE ALLOCATOR.
	 *********************************************************/
	uint32 expectedVA = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  8003d9:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	//malloc some spaces
	int i, freeFrames, usedDiskPages, expectedNumOfTables ;
	uint32 size = 0;
  8003e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	char* ptr;
	int sums[20] = {0};
  8003e7:	8d 95 b8 fe ff ff    	lea    -0x148(%ebp),%edx
  8003ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8003f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f7:	89 d7                	mov    %edx,%edi
  8003f9:	f3 ab                	rep stos %eax,%es:(%edi)
	totalRequestedSize = 0;
  8003fb:	c7 05 40 f2 81 00 00 	movl   $0x0,0x81f240
  800402:	00 00 00 

	int eval = 0;
  800405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool correct ;

	correct = 1;
  80040c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//Create some areas in PAGE allocators
	cprintf_colored(TEXT_cyan,"%~\n	1.1 Create some areas in PAGE allocators\n");
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	68 b0 56 80 00       	push   $0x8056b0
  80041b:	6a 03                	push   $0x3
  80041d:	e8 c9 13 00 00       	call   8017eb <cprintf_colored>
  800422:	83 c4 10             	add    $0x10,%esp
	{
		//4 MB
		allocIndex = 0;
  800425:	c7 05 4c f2 81 00 00 	movl   $0x0,0x81f24c
  80042c:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  80042f:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  800436:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	48                   	dec    %eax
  80043f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800445:	ba 00 00 00 00       	mov    $0x0,%edx
  80044a:	f7 75 e4             	divl   -0x1c(%ebp)
  80044d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800450:	29 d0                	sub    %edx,%eax
  800452:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 4*Mega - kilo;
  800455:	c7 45 e8 00 fc 3f 00 	movl   $0x3ffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  80045c:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  800463:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800466:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800469:	01 d0                	add    %edx,%eax
  80046b:	48                   	dec    %eax
  80046c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800472:	ba 00 00 00 00       	mov    $0x0,%edx
  800477:	f7 75 dc             	divl   -0x24(%ebp)
  80047a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80047d:	29 d0                	sub    %edx,%eax
  80047f:	89 c2                	mov    %eax,%edx
  800481:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 2;
  80048d:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800494:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800497:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80049c:	52                   	push   %edx
  80049d:	6a 01                	push   $0x1
  80049f:	ff 75 e8             	pushl  -0x18(%ebp)
  8004a2:	50                   	push   %eax
  8004a3:	e8 b1 fb ff ff       	call   800059 <allocSpaceInPageAlloc>
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8004ae:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8004b3:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8004ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8004bd:	74 2f                	je     8004ee <initial_page_allocations+0x120>
  8004bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c6:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8004cb:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  8004d2:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8004d7:	83 ec 0c             	sub    $0xc,%esp
  8004da:	52                   	push   %edx
  8004db:	ff 75 ec             	pushl  -0x14(%ebp)
  8004de:	50                   	push   %eax
  8004df:	68 e0 56 80 00       	push   $0x8056e0
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 00 13 00 00       	call   8017eb <cprintf_colored>
  8004eb:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  8004ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8004f2:	74 04                	je     8004f8 <initial_page_allocations+0x12a>
  8004f4:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  8004f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//3 MB
		allocIndex = 1;
  8004ff:	c7 05 4c f2 81 00 01 	movl   $0x1,0x81f24c
  800506:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800509:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  800510:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800513:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	48                   	dec    %eax
  800519:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80051c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051f:	ba 00 00 00 00       	mov    $0x0,%edx
  800524:	f7 75 d0             	divl   -0x30(%ebp)
  800527:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052a:	29 d0                	sub    %edx,%eax
  80052c:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 3*Mega - kilo;
  80052f:	c7 45 e8 00 fc 2f 00 	movl   $0x2ffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800536:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80053d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800540:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	48                   	dec    %eax
  800546:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800549:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80054c:	ba 00 00 00 00       	mov    $0x0,%edx
  800551:	f7 75 c8             	divl   -0x38(%ebp)
  800554:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800557:	29 d0                	sub    %edx,%eax
  800559:	89 c2                	mov    %eax,%edx
  80055b:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 0;
  800567:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80056e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800571:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800576:	52                   	push   %edx
  800577:	6a 01                	push   $0x1
  800579:	ff 75 e8             	pushl  -0x18(%ebp)
  80057c:	50                   	push   %eax
  80057d:	e8 d7 fa ff ff       	call   800059 <allocSpaceInPageAlloc>
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800588:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80058d:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800594:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800597:	74 2f                	je     8005c8 <initial_page_allocations+0x1fa>
  800599:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005a0:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8005a5:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  8005ac:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	52                   	push   %edx
  8005b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	68 e0 56 80 00       	push   $0x8056e0
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 26 12 00 00       	call   8017eb <cprintf_colored>
  8005c5:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  8005c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005cc:	74 04                	je     8005d2 <initial_page_allocations+0x204>
  8005ce:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  8005d2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//2 MB
		allocIndex = 2;
  8005d9:	c7 05 4c f2 81 00 02 	movl   $0x2,0x81f24c
  8005e0:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  8005e3:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8005ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005f0:	01 d0                	add    %edx,%eax
  8005f2:	48                   	dec    %eax
  8005f3:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8005f6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8005f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fe:	f7 75 c0             	divl   -0x40(%ebp)
  800601:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800604:	29 d0                	sub    %edx,%eax
  800606:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 2*Mega ;
  800609:	c7 45 e8 00 00 20 00 	movl   $0x200000,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800610:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  800617:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80061a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80061d:	01 d0                	add    %edx,%eax
  80061f:	48                   	dec    %eax
  800620:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800623:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800626:	ba 00 00 00 00       	mov    $0x0,%edx
  80062b:	f7 75 b8             	divl   -0x48(%ebp)
  80062e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800631:	29 d0                	sub    %edx,%eax
  800633:	89 c2                	mov    %eax,%edx
  800635:	a1 40 f2 81 00       	mov    0x81f240,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 1;
  800641:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800648:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80064b:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800650:	52                   	push   %edx
  800651:	6a 01                	push   $0x1
  800653:	ff 75 e8             	pushl  -0x18(%ebp)
  800656:	50                   	push   %eax
  800657:	e8 fd f9 ff ff       	call   800059 <allocSpaceInPageAlloc>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800662:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800667:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  80066e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800671:	74 2f                	je     8006a2 <initial_page_allocations+0x2d4>
  800673:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80067a:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80067f:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800686:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80068b:	83 ec 0c             	sub    $0xc,%esp
  80068e:	52                   	push   %edx
  80068f:	ff 75 ec             	pushl  -0x14(%ebp)
  800692:	50                   	push   %eax
  800693:	68 e0 56 80 00       	push   $0x8056e0
  800698:	6a 0c                	push   $0xc
  80069a:	e8 4c 11 00 00       	call   8017eb <cprintf_colored>
  80069f:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  8006a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006a6:	74 04                	je     8006ac <initial_page_allocations+0x2de>
  8006a8:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  8006ac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//4 MB
		allocIndex = 3;
  8006b3:	c7 05 4c f2 81 00 03 	movl   $0x3,0x81f24c
  8006ba:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  8006bd:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8006c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006c7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006ca:	01 d0                	add    %edx,%eax
  8006cc:	48                   	dec    %eax
  8006cd:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8006d0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d8:	f7 75 b0             	divl   -0x50(%ebp)
  8006db:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006de:	29 d0                	sub    %edx,%eax
  8006e0:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 4*Mega - kilo;
  8006e3:	c7 45 e8 00 fc 3f 00 	movl   $0x3ffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  8006ea:	c7 45 a8 00 10 00 00 	movl   $0x1000,-0x58(%ebp)
  8006f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006f4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8006f7:	01 d0                	add    %edx,%eax
  8006f9:	48                   	dec    %eax
  8006fa:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8006fd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
  800705:	f7 75 a8             	divl   -0x58(%ebp)
  800708:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80070b:	29 d0                	sub    %edx,%eax
  80070d:	89 c2                	mov    %eax,%edx
  80070f:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800714:	01 d0                	add    %edx,%eax
  800716:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 1;
  80071b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800722:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800725:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80072a:	52                   	push   %edx
  80072b:	6a 01                	push   $0x1
  80072d:	ff 75 e8             	pushl  -0x18(%ebp)
  800730:	50                   	push   %eax
  800731:	e8 23 f9 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80073c:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800741:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800748:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80074b:	74 2f                	je     80077c <initial_page_allocations+0x3ae>
  80074d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800754:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800759:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800760:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800765:	83 ec 0c             	sub    $0xc,%esp
  800768:	52                   	push   %edx
  800769:	ff 75 ec             	pushl  -0x14(%ebp)
  80076c:	50                   	push   %eax
  80076d:	68 e0 56 80 00       	push   $0x8056e0
  800772:	6a 0c                	push   $0xc
  800774:	e8 72 10 00 00       	call   8017eb <cprintf_colored>
  800779:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  80077c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800780:	74 04                	je     800786 <initial_page_allocations+0x3b8>
  800782:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  800786:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//1 MB
		allocIndex = 4;
  80078d:	c7 05 4c f2 81 00 04 	movl   $0x4,0x81f24c
  800794:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800797:	c7 45 a0 00 10 00 00 	movl   $0x1000,-0x60(%ebp)
  80079e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007a1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007a4:	01 d0                	add    %edx,%eax
  8007a6:	48                   	dec    %eax
  8007a7:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8007aa:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8007ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b2:	f7 75 a0             	divl   -0x60(%ebp)
  8007b5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8007b8:	29 d0                	sub    %edx,%eax
  8007ba:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 1*Mega - 3*kilo;
  8007bd:	c7 45 e8 00 f4 0f 00 	movl   $0xff400,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  8007c4:	c7 45 98 00 10 00 00 	movl   $0x1000,-0x68(%ebp)
  8007cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ce:	8b 45 98             	mov    -0x68(%ebp),%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	48                   	dec    %eax
  8007d4:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8007d7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007da:	ba 00 00 00 00       	mov    $0x0,%edx
  8007df:	f7 75 98             	divl   -0x68(%ebp)
  8007e2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e5:	29 d0                	sub    %edx,%eax
  8007e7:	89 c2                	mov    %eax,%edx
  8007e9:	a1 40 f2 81 00       	mov    0x81f240,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 0;
  8007f5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8007fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007ff:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800804:	52                   	push   %edx
  800805:	6a 01                	push   $0x1
  800807:	ff 75 e8             	pushl  -0x18(%ebp)
  80080a:	50                   	push   %eax
  80080b:	e8 49 f8 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800816:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80081b:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800822:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800825:	74 2f                	je     800856 <initial_page_allocations+0x488>
  800827:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80082e:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800833:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  80083a:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80083f:	83 ec 0c             	sub    $0xc,%esp
  800842:	52                   	push   %edx
  800843:	ff 75 ec             	pushl  -0x14(%ebp)
  800846:	50                   	push   %eax
  800847:	68 e0 56 80 00       	push   $0x8056e0
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 98 0f 00 00       	call   8017eb <cprintf_colored>
  800853:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800856:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80085a:	74 04                	je     800860 <initial_page_allocations+0x492>
  80085c:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  800860:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//1 MB
		allocIndex = 5;
  800867:	c7 05 4c f2 81 00 05 	movl   $0x5,0x81f24c
  80086e:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800871:	c7 45 90 00 10 00 00 	movl   $0x1000,-0x70(%ebp)
  800878:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	48                   	dec    %eax
  800881:	89 45 8c             	mov    %eax,-0x74(%ebp)
  800884:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800887:	ba 00 00 00 00       	mov    $0x0,%edx
  80088c:	f7 75 90             	divl   -0x70(%ebp)
  80088f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800892:	29 d0                	sub    %edx,%eax
  800894:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 1*Mega - 2*kilo;
  800897:	c7 45 e8 00 f8 0f 00 	movl   $0xff800,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  80089e:	c7 45 88 00 10 00 00 	movl   $0x1000,-0x78(%ebp)
  8008a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a8:	8b 45 88             	mov    -0x78(%ebp),%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	48                   	dec    %eax
  8008ae:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8008b1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8008b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b9:	f7 75 88             	divl   -0x78(%ebp)
  8008bc:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8008bf:	29 d0                	sub    %edx,%eax
  8008c1:	89 c2                	mov    %eax,%edx
  8008c3:	a1 40 f2 81 00       	mov    0x81f240,%eax
  8008c8:	01 d0                	add    %edx,%eax
  8008ca:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 0;
  8008cf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8008d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008d9:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8008de:	52                   	push   %edx
  8008df:	6a 01                	push   $0x1
  8008e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e4:	50                   	push   %eax
  8008e5:	e8 6f f7 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8008f0:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8008f5:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8008fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8008ff:	74 2f                	je     800930 <initial_page_allocations+0x562>
  800901:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800908:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80090d:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800914:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800919:	83 ec 0c             	sub    $0xc,%esp
  80091c:	52                   	push   %edx
  80091d:	ff 75 ec             	pushl  -0x14(%ebp)
  800920:	50                   	push   %eax
  800921:	68 e0 56 80 00       	push   $0x8056e0
  800926:	6a 0c                	push   $0xc
  800928:	e8 be 0e 00 00       	call   8017eb <cprintf_colored>
  80092d:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800930:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800934:	74 04                	je     80093a <initial_page_allocations+0x56c>
  800936:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  80093a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//1 MB
		allocIndex = 6;
  800941:	c7 05 4c f2 81 00 06 	movl   $0x6,0x81f24c
  800948:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  80094b:	c7 45 80 00 10 00 00 	movl   $0x1000,-0x80(%ebp)
  800952:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800955:	8b 45 80             	mov    -0x80(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	48                   	dec    %eax
  80095b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800961:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800967:	ba 00 00 00 00       	mov    $0x0,%edx
  80096c:	f7 75 80             	divl   -0x80(%ebp)
  80096f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800975:	29 d0                	sub    %edx,%eax
  800977:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 1*Mega - 1*kilo;
  80097a:	c7 45 e8 00 fc 0f 00 	movl   $0xffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800981:	c7 85 78 ff ff ff 00 	movl   $0x1000,-0x88(%ebp)
  800988:	10 00 00 
  80098b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80098e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800994:	01 d0                	add    %edx,%eax
  800996:	48                   	dec    %eax
  800997:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  80099d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8009a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a8:	f7 b5 78 ff ff ff    	divl   -0x88(%ebp)
  8009ae:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8009b4:	29 d0                	sub    %edx,%eax
  8009b6:	89 c2                	mov    %eax,%edx
  8009b8:	a1 40 f2 81 00       	mov    0x81f240,%eax
  8009bd:	01 d0                	add    %edx,%eax
  8009bf:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 1; //since page allocator is started 1 page after the 32MB of Block Allocator
  8009c4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8009cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009ce:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8009d3:	52                   	push   %edx
  8009d4:	6a 01                	push   $0x1
  8009d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d9:	50                   	push   %eax
  8009da:	e8 7a f6 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8009e5:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8009ea:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8009f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8009f4:	74 2f                	je     800a25 <initial_page_allocations+0x657>
  8009f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009fd:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800a02:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800a09:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800a0e:	83 ec 0c             	sub    $0xc,%esp
  800a11:	52                   	push   %edx
  800a12:	ff 75 ec             	pushl  -0x14(%ebp)
  800a15:	50                   	push   %eax
  800a16:	68 e0 56 80 00       	push   $0x8056e0
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 c9 0d 00 00       	call   8017eb <cprintf_colored>
  800a22:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800a25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a29:	74 04                	je     800a2f <initial_page_allocations+0x661>
  800a2b:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  800a2f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//2 MB
		allocIndex = 7;
  800a36:	c7 05 4c f2 81 00 07 	movl   $0x7,0x81f24c
  800a3d:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800a40:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  800a47:	10 00 00 
  800a4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a4d:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a53:	01 d0                	add    %edx,%eax
  800a55:	48                   	dec    %eax
  800a56:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800a5c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  800a6d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a73:	29 d0                	sub    %edx,%eax
  800a75:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 2*Mega ;
  800a78:	c7 45 e8 00 00 20 00 	movl   $0x200000,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800a7f:	c7 85 68 ff ff ff 00 	movl   $0x1000,-0x98(%ebp)
  800a86:	10 00 00 
  800a89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800a92:	01 d0                	add    %edx,%eax
  800a94:	48                   	dec    %eax
  800a95:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800a9b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa6:	f7 b5 68 ff ff ff    	divl   -0x98(%ebp)
  800aac:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800ab2:	29 d0                	sub    %edx,%eax
  800ab4:	89 c2                	mov    %eax,%edx
  800ab6:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800abb:	01 d0                	add    %edx,%eax
  800abd:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 0;
  800ac2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800ac9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800acc:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800ad1:	52                   	push   %edx
  800ad2:	6a 01                	push   $0x1
  800ad4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	e8 7c f5 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800ae3:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800ae8:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800aef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800af2:	74 2f                	je     800b23 <initial_page_allocations+0x755>
  800af4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800afb:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800b00:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800b07:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	52                   	push   %edx
  800b10:	ff 75 ec             	pushl  -0x14(%ebp)
  800b13:	50                   	push   %eax
  800b14:	68 e0 56 80 00       	push   $0x8056e0
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 cb 0c 00 00       	call   8017eb <cprintf_colored>
  800b20:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  800b23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b27:	74 04                	je     800b2d <initial_page_allocations+0x75f>
  800b29:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  800b2d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//2 MB
		allocIndex = 8;
  800b34:	c7 05 4c f2 81 00 08 	movl   $0x8,0x81f24c
  800b3b:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800b3e:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  800b45:	10 00 00 
  800b48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b4b:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b51:	01 d0                	add    %edx,%eax
  800b53:	48                   	dec    %eax
  800b54:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800b5a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b60:	ba 00 00 00 00       	mov    $0x0,%edx
  800b65:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  800b6b:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b71:	29 d0                	sub    %edx,%eax
  800b73:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 2*Mega ;
  800b76:	c7 45 e8 00 00 20 00 	movl   $0x200000,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800b7d:	c7 85 58 ff ff ff 00 	movl   $0x1000,-0xa8(%ebp)
  800b84:	10 00 00 
  800b87:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b8a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b90:	01 d0                	add    %edx,%eax
  800b92:	48                   	dec    %eax
  800b93:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b99:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba4:	f7 b5 58 ff ff ff    	divl   -0xa8(%ebp)
  800baa:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800bb0:	29 d0                	sub    %edx,%eax
  800bb2:	89 c2                	mov    %eax,%edx
  800bb4:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800bb9:	01 d0                	add    %edx,%eax
  800bbb:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 1;
  800bc0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800bc7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800bca:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800bcf:	52                   	push   %edx
  800bd0:	6a 01                	push   $0x1
  800bd2:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	e8 7e f4 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800be1:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800be6:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800bed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800bf0:	74 2f                	je     800c21 <initial_page_allocations+0x853>
  800bf2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bf9:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800bfe:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800c05:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800c0a:	83 ec 0c             	sub    $0xc,%esp
  800c0d:	52                   	push   %edx
  800c0e:	ff 75 ec             	pushl  -0x14(%ebp)
  800c11:	50                   	push   %eax
  800c12:	68 e0 56 80 00       	push   $0x8056e0
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 cd 0b 00 00       	call   8017eb <cprintf_colored>
  800c1e:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  800c21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c25:	74 04                	je     800c2b <initial_page_allocations+0x85d>
  800c27:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  800c2b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//ALLOCATIONS OF KILO BYTES
		{
			//3 KB
			allocIndex = 9;
  800c32:	c7 05 4c f2 81 00 09 	movl   $0x9,0x81f24c
  800c39:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800c3c:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  800c43:	10 00 00 
  800c46:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c49:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800c4f:	01 d0                	add    %edx,%eax
  800c51:	48                   	dec    %eax
  800c52:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800c58:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c63:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  800c69:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c6f:	29 d0                	sub    %edx,%eax
  800c71:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 3*kilo ;
  800c74:	c7 45 e8 00 0c 00 00 	movl   $0xc00,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800c7b:	c7 85 48 ff ff ff 00 	movl   $0x1000,-0xb8(%ebp)
  800c82:	10 00 00 
  800c85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c88:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c8e:	01 d0                	add    %edx,%eax
  800c90:	48                   	dec    %eax
  800c91:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800c97:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca2:	f7 b5 48 ff ff ff    	divl   -0xb8(%ebp)
  800ca8:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800cae:	29 d0                	sub    %edx,%eax
  800cb0:	89 c2                	mov    %eax,%edx
  800cb2:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800cb7:	01 d0                	add    %edx,%eax
  800cb9:	a3 40 f2 81 00       	mov    %eax,0x81f240
			expectedNumOfTables = 0;
  800cbe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800cc5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800cc8:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800ccd:	52                   	push   %edx
  800cce:	6a 01                	push   $0x1
  800cd0:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd3:	50                   	push   %eax
  800cd4:	e8 80 f3 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800cd9:	83 c4 10             	add    $0x10,%esp
  800cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800cdf:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800ce4:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800cee:	74 2f                	je     800d1f <initial_page_allocations+0x951>
  800cf0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cf7:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800cfc:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800d03:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800d08:	83 ec 0c             	sub    $0xc,%esp
  800d0b:	52                   	push   %edx
  800d0c:	ff 75 ec             	pushl  -0x14(%ebp)
  800d0f:	50                   	push   %eax
  800d10:	68 e0 56 80 00       	push   $0x8056e0
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 cf 0a 00 00       	call   8017eb <cprintf_colored>
  800d1c:	83 c4 20             	add    $0x20,%esp

			//5 KB
			allocIndex = 10;
  800d1f:	c7 05 4c f2 81 00 0a 	movl   $0xa,0x81f24c
  800d26:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800d29:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  800d30:	10 00 00 
  800d33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d36:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d3c:	01 d0                	add    %edx,%eax
  800d3e:	48                   	dec    %eax
  800d3f:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800d45:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d50:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  800d56:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d5c:	29 d0                	sub    %edx,%eax
  800d5e:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 5*kilo ;
  800d61:	c7 45 e8 00 14 00 00 	movl   $0x1400,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800d68:	c7 85 38 ff ff ff 00 	movl   $0x1000,-0xc8(%ebp)
  800d6f:	10 00 00 
  800d72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d75:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d7b:	01 d0                	add    %edx,%eax
  800d7d:	48                   	dec    %eax
  800d7e:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d84:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8f:	f7 b5 38 ff ff ff    	divl   -0xc8(%ebp)
  800d95:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d9b:	29 d0                	sub    %edx,%eax
  800d9d:	89 c2                	mov    %eax,%edx
  800d9f:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800da4:	01 d0                	add    %edx,%eax
  800da6:	a3 40 f2 81 00       	mov    %eax,0x81f240
			expectedNumOfTables = 0;
  800dab:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800db2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800db5:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800dba:	52                   	push   %edx
  800dbb:	6a 01                	push   $0x1
  800dbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800dc0:	50                   	push   %eax
  800dc1:	e8 93 f2 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800dc6:	83 c4 10             	add    $0x10,%esp
  800dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800dcc:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800dd1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800dd8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800ddb:	74 2f                	je     800e0c <initial_page_allocations+0xa3e>
  800ddd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800de4:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800de9:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800df0:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800df5:	83 ec 0c             	sub    $0xc,%esp
  800df8:	52                   	push   %edx
  800df9:	ff 75 ec             	pushl  -0x14(%ebp)
  800dfc:	50                   	push   %eax
  800dfd:	68 e0 56 80 00       	push   $0x8056e0
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 e2 09 00 00       	call   8017eb <cprintf_colored>
  800e09:	83 c4 20             	add    $0x20,%esp

			//3 KB
			allocIndex = 11;
  800e0c:	c7 05 4c f2 81 00 0b 	movl   $0xb,0x81f24c
  800e13:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800e16:	c7 85 30 ff ff ff 00 	movl   $0x1000,-0xd0(%ebp)
  800e1d:	10 00 00 
  800e20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e23:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800e29:	01 d0                	add    %edx,%eax
  800e2b:	48                   	dec    %eax
  800e2c:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800e32:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800e38:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3d:	f7 b5 30 ff ff ff    	divl   -0xd0(%ebp)
  800e43:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800e49:	29 d0                	sub    %edx,%eax
  800e4b:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 3*kilo ;
  800e4e:	c7 45 e8 00 0c 00 00 	movl   $0xc00,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800e55:	c7 85 28 ff ff ff 00 	movl   $0x1000,-0xd8(%ebp)
  800e5c:	10 00 00 
  800e5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e62:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800e68:	01 d0                	add    %edx,%eax
  800e6a:	48                   	dec    %eax
  800e6b:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  800e71:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e77:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7c:	f7 b5 28 ff ff ff    	divl   -0xd8(%ebp)
  800e82:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e88:	29 d0                	sub    %edx,%eax
  800e8a:	89 c2                	mov    %eax,%edx
  800e8c:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800e91:	01 d0                	add    %edx,%eax
  800e93:	a3 40 f2 81 00       	mov    %eax,0x81f240
			expectedNumOfTables = 0;
  800e98:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800e9f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ea2:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800ea7:	52                   	push   %edx
  800ea8:	6a 01                	push   $0x1
  800eaa:	ff 75 e8             	pushl  -0x18(%ebp)
  800ead:	50                   	push   %eax
  800eae:	e8 a6 f1 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800eb3:	83 c4 10             	add    $0x10,%esp
  800eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800eb9:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800ebe:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800ec5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800ec8:	74 2f                	je     800ef9 <initial_page_allocations+0xb2b>
  800eca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ed1:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800ed6:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800edd:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800ee2:	83 ec 0c             	sub    $0xc,%esp
  800ee5:	52                   	push   %edx
  800ee6:	ff 75 ec             	pushl  -0x14(%ebp)
  800ee9:	50                   	push   %eax
  800eea:	68 e0 56 80 00       	push   $0x8056e0
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 f5 08 00 00       	call   8017eb <cprintf_colored>
  800ef6:	83 c4 20             	add    $0x20,%esp

			//9 KB
			allocIndex = 12;
  800ef9:	c7 05 4c f2 81 00 0c 	movl   $0xc,0x81f24c
  800f00:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800f03:	c7 85 20 ff ff ff 00 	movl   $0x1000,-0xe0(%ebp)
  800f0a:	10 00 00 
  800f0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800f10:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800f16:	01 d0                	add    %edx,%eax
  800f18:	48                   	dec    %eax
  800f19:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800f1f:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800f25:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2a:	f7 b5 20 ff ff ff    	divl   -0xe0(%ebp)
  800f30:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800f36:	29 d0                	sub    %edx,%eax
  800f38:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 9*kilo ;
  800f3b:	c7 45 e8 00 24 00 00 	movl   $0x2400,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800f42:	c7 85 18 ff ff ff 00 	movl   $0x1000,-0xe8(%ebp)
  800f49:	10 00 00 
  800f4c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800f4f:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800f55:	01 d0                	add    %edx,%eax
  800f57:	48                   	dec    %eax
  800f58:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800f5e:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f64:	ba 00 00 00 00       	mov    $0x0,%edx
  800f69:	f7 b5 18 ff ff ff    	divl   -0xe8(%ebp)
  800f6f:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f75:	29 d0                	sub    %edx,%eax
  800f77:	89 c2                	mov    %eax,%edx
  800f79:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800f7e:	01 d0                	add    %edx,%eax
  800f80:	a3 40 f2 81 00       	mov    %eax,0x81f240
			expectedNumOfTables = 0;
  800f85:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800f8c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f8f:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800f94:	52                   	push   %edx
  800f95:	6a 01                	push   $0x1
  800f97:	ff 75 e8             	pushl  -0x18(%ebp)
  800f9a:	50                   	push   %eax
  800f9b:	e8 b9 f0 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800fa0:	83 c4 10             	add    $0x10,%esp
  800fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800fa6:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800fab:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800fb2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800fb5:	74 2f                	je     800fe6 <initial_page_allocations+0xc18>
  800fb7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fbe:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800fc3:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800fca:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800fcf:	83 ec 0c             	sub    $0xc,%esp
  800fd2:	52                   	push   %edx
  800fd3:	ff 75 ec             	pushl  -0x14(%ebp)
  800fd6:	50                   	push   %eax
  800fd7:	68 e0 56 80 00       	push   $0x8056e0
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 08 08 00 00       	call   8017eb <cprintf_colored>
  800fe3:	83 c4 20             	add    $0x20,%esp
		}
		if (correct) eval += 15;
  800fe6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fea:	74 04                	je     800ff0 <initial_page_allocations+0xc22>
  800fec:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
		correct = 1;
  800ff0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	//Insufficient space
	cprintf_colored(TEXT_cyan,"%~\n	1.2 Insufficient Space\n");
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	68 32 57 80 00       	push   $0x805732
  800fff:	6a 03                	push   $0x3
  801001:	e8 e5 07 00 00       	call   8017eb <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 0a 31 00 00       	call   804129 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 4a 31 00 00       	call   804174 <sys_pf_calculate_allocated_pages>
  80102a:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		uint32 restOfUHeap = (USER_HEAP_MAX - ACTUAL_PAGE_ALLOC_START) - (totalRequestedSize) ;
  801030:	a1 40 f2 81 00       	mov    0x81f240,%eax
  801035:	ba 00 f0 ff 1d       	mov    $0x1dfff000,%edx
  80103a:	29 c2                	sub    %eax,%edx
  80103c:	89 d0                	mov    %edx,%eax
  80103e:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
		ptr_allocations[allocIndex] = malloc(restOfUHeap+1);
  801044:	8b 1d 4c f2 81 00    	mov    0x81f24c,%ebx
  80104a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  801050:	40                   	inc    %eax
  801051:	83 ec 0c             	sub    $0xc,%esp
  801054:	50                   	push   %eax
  801055:	e8 7d 17 00 00       	call   8027d7 <malloc>
  80105a:	83 c4 10             	add    $0x10,%esp
  80105d:	89 04 9d 20 70 80 00 	mov    %eax,0x807020(,%ebx,4)
		if (ptr_allocations[allocIndex] != NULL) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.1 Allocating insufficient space: should return NULL\n", allocIndex); }
  801064:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  801069:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  801070:	85 c0                	test   %eax,%eax
  801072:	74 1f                	je     801093 <initial_page_allocations+0xcc5>
  801074:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80107b:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  801080:	83 ec 04             	sub    $0x4,%esp
  801083:	50                   	push   %eax
  801084:	68 50 57 80 00       	push   $0x805750
  801089:	6a 0c                	push   $0xc
  80108b:	e8 5b 07 00 00       	call   8017eb <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 dc 30 00 00       	call   804174 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 8c 57 80 00       	push   $0x80578c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 2f 07 00 00       	call   8017eb <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 65 30 00 00       	call   804129 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 fc 57 80 00       	push   $0x8057fc
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 03 07 00 00       	call   8017eb <cprintf_colored>
  8010e8:	83 c4 10             	add    $0x10,%esp
	}
	if (correct)	eval+=10 ;
  8010eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010ef:	74 04                	je     8010f5 <initial_page_allocations+0xd27>
  8010f1:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)

	return eval;
  8010f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5f                   	pop    %edi
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    

008010ff <_main>:
#include <inc/lib.h>
#include <user/tst_malloc_helpers.h>


void _main(void)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	57                   	push   %edi
  801103:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801109:	a1 00 72 80 00       	mov    0x807200,%eax
  80110e:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801114:	a1 00 72 80 00       	mov    0x807200,%eax
  801119:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80111f:	39 c2                	cmp    %eax,%edx
  801121:	72 14                	jb     801137 <_main+0x38>
			panic("Please increase the WS size");
  801123:	83 ec 04             	sub    $0x4,%esp
  801126:	68 44 58 80 00       	push   $0x805844
  80112b:	6a 18                	push   $0x18
  80112d:	68 60 58 80 00       	push   $0x805860
  801132:	e8 b9 03 00 00       	call   8014f0 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/
	int eval = 0;
  801137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool correct ;

	correct = 1;
  80113e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//Create some areas in PAGE allocators
	cprintf_colored(TEXT_cyan,"%~\n1 Create some allocations\n");
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	68 74 58 80 00       	push   $0x805874
  80114d:	6a 03                	push   $0x3
  80114f:	e8 97 06 00 00       	call   8017eb <cprintf_colored>
  801154:	83 c4 10             	add    $0x10,%esp
	{
		eval = initial_page_allocations();
  801157:	e8 72 f2 ff ff       	call   8003ce <initial_page_allocations>
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		eval = eval * 70 / 100; //rescale
  80115f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801162:	89 d0                	mov    %edx,%eax
  801164:	c1 e0 02             	shl    $0x2,%eax
  801167:	01 d0                	add    %edx,%eax
  801169:	01 c0                	add    %eax,%eax
  80116b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  801172:	89 d1                	mov    %edx,%ecx
  801174:	29 c1                	sub    %eax,%ecx
  801176:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  80117b:	f7 e9                	imul   %ecx
  80117d:	c1 fa 05             	sar    $0x5,%edx
  801180:	89 c8                	mov    %ecx,%eax
  801182:	c1 f8 1f             	sar    $0x1f,%eax
  801185:	29 c2                	sub    %eax,%edx
  801187:	89 d0                	mov    %edx,%eax
  801189:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	//2. Check BREAK
	correct = 1;
  80118c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n2. Check Page Allocator BREAK [10%]\n");
  801193:	83 ec 08             	sub    $0x8,%esp
  801196:	68 94 58 80 00       	push   $0x805894
  80119b:	6a 03                	push   $0x3
  80119d:	e8 49 06 00 00       	call   8017eb <cprintf_colored>
  8011a2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 allocSizes = 0;
  8011a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int i = 0; i < allocIndex; ++i)
  8011ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8011b3:	eb 30                	jmp    8011e5 <_main+0xe6>
		{
			allocSizes += ROUNDUP(requestedSizes[i], PAGE_SIZE);
  8011b5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8011bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011bf:	8b 14 85 60 71 80 00 	mov    0x807160(,%eax,4),%edx
  8011c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c9:	01 d0                	add    %edx,%eax
  8011cb:	48                   	dec    %eax
  8011cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d7:	f7 75 e0             	divl   -0x20(%ebp)
  8011da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011dd:	29 d0                	sub    %edx,%eax
  8011df:	01 45 ec             	add    %eax,-0x14(%ebp)
	//2. Check BREAK
	correct = 1;
	cprintf_colored(TEXT_cyan,"%~\n2. Check Page Allocator BREAK [10%]\n");
	{
		uint32 allocSizes = 0;
		for (int i = 0; i < allocIndex; ++i)
  8011e2:	ff 45 e8             	incl   -0x18(%ebp)
  8011e5:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8011ea:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8011ed:	7c c6                	jl     8011b5 <_main+0xb6>
		{
			allocSizes += ROUNDUP(requestedSizes[i], PAGE_SIZE);
		}
		uint32 expectedVA = ACTUAL_PAGE_ALLOC_START + allocSizes;
  8011ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011f2:	2d 00 f0 ff 7d       	sub    $0x7dfff000,%eax
  8011f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(uheapPageAllocBreak != expectedVA) {correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"BREAK value is not correct! Expected = %x, Actual = %x\n", expectedVA, uheapPageAllocBreak);}
  8011fa:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8011ff:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801202:	74 1f                	je     801223 <_main+0x124>
  801204:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80120b:	a1 50 f2 81 00       	mov    0x81f250,%eax
  801210:	50                   	push   %eax
  801211:	ff 75 d8             	pushl  -0x28(%ebp)
  801214:	68 bc 58 80 00       	push   $0x8058bc
  801219:	6a 0c                	push   $0xc
  80121b:	e8 cb 05 00 00       	call   8017eb <cprintf_colored>
  801220:	83 c4 10             	add    $0x10,%esp
	}
	if (correct) eval += 10;
  801223:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801227:	74 04                	je     80122d <_main+0x12e>
  801229:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	correct = 1;
  80122d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//3. Check Content
	uint32 sums[MAX_NUM_OF_ALLOCS] = {0};
  801234:	8d 95 34 ff ff ff    	lea    -0xcc(%ebp),%edx
  80123a:	b9 28 00 00 00       	mov    $0x28,%ecx
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
  801244:	89 d7                	mov    %edx,%edi
  801246:	f3 ab                	rep stos %eax,%es:(%edi)
	cprintf_colored(TEXT_cyan,"%~\n3. Check Content [20%]\n");
  801248:	83 ec 08             	sub    $0x8,%esp
  80124b:	68 f4 58 80 00       	push   $0x8058f4
  801250:	6a 03                	push   $0x3
  801252:	e8 94 05 00 00       	call   8017eb <cprintf_colored>
  801257:	83 c4 10             	add    $0x10,%esp
	{
		for (int i = 0; i < allocIndex; ++i)
  80125a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801261:	e9 97 00 00 00       	jmp    8012fd <_main+0x1fe>
		{
			char* ptr = (char*)ptr_allocations[i];
  801266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801269:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  801270:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			sums[i] += ptr[0] ;
  801273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801276:	8b 94 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%edx
  80127d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	0f be c0             	movsbl %al,%eax
  801285:	01 c2                	add    %eax,%edx
  801287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80128a:	89 94 85 34 ff ff ff 	mov    %edx,-0xcc(%ebp,%eax,4)
			sums[i] += ptr[lastIndices[i]] ;
  801291:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801294:	8b 94 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%edx
  80129b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80129e:	8b 04 85 c0 70 80 00 	mov    0x8070c0(,%eax,4),%eax
  8012a5:	89 c1                	mov    %eax,%ecx
  8012a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012aa:	01 c8                	add    %ecx,%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	0f be c0             	movsbl %al,%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b6:	89 94 85 34 ff ff ff 	mov    %edx,-0xcc(%ebp,%eax,4)
			if (sums[i] != (maxByte + maxByte))
  8012bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012c0:	8b 84 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%eax
  8012c7:	3d fe 00 00 00       	cmp    $0xfe,%eax
  8012cc:	74 2c                	je     8012fa <_main+0x1fb>
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in allocation#%d. Expected = %d, Actual = %d\n", i, maxByte + maxByte, sums[i]); }
  8012ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d8:	8b 84 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%eax
  8012df:	83 ec 0c             	sub    $0xc,%esp
  8012e2:	50                   	push   %eax
  8012e3:	68 fe 00 00 00       	push   $0xfe
  8012e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012eb:	68 10 59 80 00       	push   $0x805910
  8012f0:	6a 0c                	push   $0xc
  8012f2:	e8 f4 04 00 00       	call   8017eb <cprintf_colored>
  8012f7:	83 c4 20             	add    $0x20,%esp

	//3. Check Content
	uint32 sums[MAX_NUM_OF_ALLOCS] = {0};
	cprintf_colored(TEXT_cyan,"%~\n3. Check Content [20%]\n");
	{
		for (int i = 0; i < allocIndex; ++i)
  8012fa:	ff 45 e4             	incl   -0x1c(%ebp)
  8012fd:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  801302:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801305:	0f 8c 5b ff ff ff    	jl     801266 <_main+0x167>
			sums[i] += ptr[lastIndices[i]] ;
			if (sums[i] != (maxByte + maxByte))
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in allocation#%d. Expected = %d, Actual = %d\n", i, maxByte + maxByte, sums[i]); }
		}
	}
	if (correct) eval += 20;
  80130b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80130f:	74 04                	je     801315 <_main+0x216>
  801311:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	correct = 1;
  801315:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_light_green, "%~\nTest malloc (1) [PAGE ALLOCATOR] completed. Eval = %d\n", eval);
  80131c:	83 ec 04             	sub    $0x4,%esp
  80131f:	ff 75 f4             	pushl  -0xc(%ebp)
  801322:	68 50 59 80 00       	push   $0x805950
  801327:	6a 0a                	push   $0xa
  801329:	e8 bd 04 00 00       	call   8017eb <cprintf_colored>
  80132e:	83 c4 10             	add    $0x10,%esp

	return;
  801331:	90                   	nop
}
  801332:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	57                   	push   %edi
  80133b:	56                   	push   %esi
  80133c:	53                   	push   %ebx
  80133d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801340:	e8 ad 2f 00 00       	call   8042f2 <sys_getenvindex>
  801345:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801348:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80134b:	89 d0                	mov    %edx,%eax
  80134d:	c1 e0 02             	shl    $0x2,%eax
  801350:	01 d0                	add    %edx,%eax
  801352:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801359:	01 d0                	add    %edx,%eax
  80135b:	89 c2                	mov    %eax,%edx
  80135d:	c1 e2 04             	shl    $0x4,%edx
  801360:	29 c2                	sub    %eax,%edx
  801362:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  801369:	89 c2                	mov    %eax,%edx
  80136b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  801371:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801376:	a1 00 72 80 00       	mov    0x807200,%eax
  80137b:	8a 40 20             	mov    0x20(%eax),%al
  80137e:	84 c0                	test   %al,%al
  801380:	74 0d                	je     80138f <libmain+0x58>
		binaryname = myEnv->prog_name;
  801382:	a1 00 72 80 00       	mov    0x807200,%eax
  801387:	83 c0 20             	add    $0x20,%eax
  80138a:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80138f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801393:	7e 0a                	jle    80139f <libmain+0x68>
		binaryname = argv[0];
  801395:	8b 45 0c             	mov    0xc(%ebp),%eax
  801398:	8b 00                	mov    (%eax),%eax
  80139a:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  80139f:	83 ec 08             	sub    $0x8,%esp
  8013a2:	ff 75 0c             	pushl  0xc(%ebp)
  8013a5:	ff 75 08             	pushl  0x8(%ebp)
  8013a8:	e8 52 fd ff ff       	call   8010ff <_main>
  8013ad:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8013b0:	a1 00 70 80 00       	mov    0x807000,%eax
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	0f 84 01 01 00 00    	je     8014be <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8013bd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8013c3:	bb 84 5a 80 00       	mov    $0x805a84,%ebx
  8013c8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8013cd:	89 c7                	mov    %eax,%edi
  8013cf:	89 de                	mov    %ebx,%esi
  8013d1:	89 d1                	mov    %edx,%ecx
  8013d3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8013d5:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8013d8:	b9 56 00 00 00       	mov    $0x56,%ecx
  8013dd:	b0 00                	mov    $0x0,%al
  8013df:	89 d7                	mov    %edx,%edi
  8013e1:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8013e3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8013ea:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013ed:	83 ec 08             	sub    $0x8,%esp
  8013f0:	50                   	push   %eax
  8013f1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8013f7:	50                   	push   %eax
  8013f8:	e8 2b 31 00 00       	call   804528 <sys_utilities>
  8013fd:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801400:	e8 74 2c 00 00       	call   804079 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801405:	83 ec 0c             	sub    $0xc,%esp
  801408:	68 a4 59 80 00       	push   $0x8059a4
  80140d:	e8 ac 03 00 00       	call   8017be <cprintf>
  801412:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 18                	je     801434 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80141c:	e8 25 31 00 00       	call   804546 <sys_get_optimal_num_faults>
  801421:	83 ec 08             	sub    $0x8,%esp
  801424:	50                   	push   %eax
  801425:	68 cc 59 80 00       	push   $0x8059cc
  80142a:	e8 8f 03 00 00       	call   8017be <cprintf>
  80142f:	83 c4 10             	add    $0x10,%esp
  801432:	eb 59                	jmp    80148d <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801434:	a1 00 72 80 00       	mov    0x807200,%eax
  801439:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80143f:	a1 00 72 80 00       	mov    0x807200,%eax
  801444:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80144a:	83 ec 04             	sub    $0x4,%esp
  80144d:	52                   	push   %edx
  80144e:	50                   	push   %eax
  80144f:	68 f0 59 80 00       	push   $0x8059f0
  801454:	e8 65 03 00 00       	call   8017be <cprintf>
  801459:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80145c:	a1 00 72 80 00       	mov    0x807200,%eax
  801461:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  801467:	a1 00 72 80 00       	mov    0x807200,%eax
  80146c:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  801472:	a1 00 72 80 00       	mov    0x807200,%eax
  801477:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80147d:	51                   	push   %ecx
  80147e:	52                   	push   %edx
  80147f:	50                   	push   %eax
  801480:	68 18 5a 80 00       	push   $0x805a18
  801485:	e8 34 03 00 00       	call   8017be <cprintf>
  80148a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80148d:	a1 00 72 80 00       	mov    0x807200,%eax
  801492:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  801498:	83 ec 08             	sub    $0x8,%esp
  80149b:	50                   	push   %eax
  80149c:	68 70 5a 80 00       	push   $0x805a70
  8014a1:	e8 18 03 00 00       	call   8017be <cprintf>
  8014a6:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	68 a4 59 80 00       	push   $0x8059a4
  8014b1:	e8 08 03 00 00       	call   8017be <cprintf>
  8014b6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8014b9:	e8 d5 2b 00 00       	call   804093 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8014be:	e8 1f 00 00 00       	call   8014e2 <exit>
}
  8014c3:	90                   	nop
  8014c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c7:	5b                   	pop    %ebx
  8014c8:	5e                   	pop    %esi
  8014c9:	5f                   	pop    %edi
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    

008014cc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8014d2:	83 ec 0c             	sub    $0xc,%esp
  8014d5:	6a 00                	push   $0x0
  8014d7:	e8 e2 2d 00 00       	call   8042be <sys_destroy_env>
  8014dc:	83 c4 10             	add    $0x10,%esp
}
  8014df:	90                   	nop
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <exit>:

void
exit(void)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
  8014e5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8014e8:	e8 37 2e 00 00       	call   804324 <sys_exit_env>
}
  8014ed:	90                   	nop
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8014f6:	8d 45 10             	lea    0x10(%ebp),%eax
  8014f9:	83 c0 04             	add    $0x4,%eax
  8014fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8014ff:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  801504:	85 c0                	test   %eax,%eax
  801506:	74 16                	je     80151e <_panic+0x2e>
		cprintf("%s: ", argv0);
  801508:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  80150d:	83 ec 08             	sub    $0x8,%esp
  801510:	50                   	push   %eax
  801511:	68 e8 5a 80 00       	push   $0x805ae8
  801516:	e8 a3 02 00 00       	call   8017be <cprintf>
  80151b:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80151e:	a1 04 70 80 00       	mov    0x807004,%eax
  801523:	83 ec 0c             	sub    $0xc,%esp
  801526:	ff 75 0c             	pushl  0xc(%ebp)
  801529:	ff 75 08             	pushl  0x8(%ebp)
  80152c:	50                   	push   %eax
  80152d:	68 f0 5a 80 00       	push   $0x805af0
  801532:	6a 74                	push   $0x74
  801534:	e8 b2 02 00 00       	call   8017eb <cprintf_colored>
  801539:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80153c:	8b 45 10             	mov    0x10(%ebp),%eax
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	ff 75 f4             	pushl  -0xc(%ebp)
  801545:	50                   	push   %eax
  801546:	e8 04 02 00 00       	call   80174f <vcprintf>
  80154b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80154e:	83 ec 08             	sub    $0x8,%esp
  801551:	6a 00                	push   $0x0
  801553:	68 18 5b 80 00       	push   $0x805b18
  801558:	e8 f2 01 00 00       	call   80174f <vcprintf>
  80155d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801560:	e8 7d ff ff ff       	call   8014e2 <exit>

	// should not return here
	while (1) ;
  801565:	eb fe                	jmp    801565 <_panic+0x75>

00801567 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80156d:	a1 00 72 80 00       	mov    0x807200,%eax
  801572:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801578:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157b:	39 c2                	cmp    %eax,%edx
  80157d:	74 14                	je     801593 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80157f:	83 ec 04             	sub    $0x4,%esp
  801582:	68 1c 5b 80 00       	push   $0x805b1c
  801587:	6a 26                	push   $0x26
  801589:	68 68 5b 80 00       	push   $0x805b68
  80158e:	e8 5d ff ff ff       	call   8014f0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801593:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80159a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8015a1:	e9 c5 00 00 00       	jmp    80166b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	01 d0                	add    %edx,%eax
  8015b5:	8b 00                	mov    (%eax),%eax
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	75 08                	jne    8015c3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8015bb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8015be:	e9 a5 00 00 00       	jmp    801668 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8015c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8015d1:	eb 69                	jmp    80163c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8015d3:	a1 00 72 80 00       	mov    0x807200,%eax
  8015d8:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8015de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015e1:	89 d0                	mov    %edx,%eax
  8015e3:	01 c0                	add    %eax,%eax
  8015e5:	01 d0                	add    %edx,%eax
  8015e7:	c1 e0 03             	shl    $0x3,%eax
  8015ea:	01 c8                	add    %ecx,%eax
  8015ec:	8a 40 04             	mov    0x4(%eax),%al
  8015ef:	84 c0                	test   %al,%al
  8015f1:	75 46                	jne    801639 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8015f3:	a1 00 72 80 00       	mov    0x807200,%eax
  8015f8:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8015fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801601:	89 d0                	mov    %edx,%eax
  801603:	01 c0                	add    %eax,%eax
  801605:	01 d0                	add    %edx,%eax
  801607:	c1 e0 03             	shl    $0x3,%eax
  80160a:	01 c8                	add    %ecx,%eax
  80160c:	8b 00                	mov    (%eax),%eax
  80160e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801611:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801614:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801619:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80161b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	01 c8                	add    %ecx,%eax
  80162a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80162c:	39 c2                	cmp    %eax,%edx
  80162e:	75 09                	jne    801639 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801630:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801637:	eb 15                	jmp    80164e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801639:	ff 45 e8             	incl   -0x18(%ebp)
  80163c:	a1 00 72 80 00       	mov    0x807200,%eax
  801641:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80164a:	39 c2                	cmp    %eax,%edx
  80164c:	77 85                	ja     8015d3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80164e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801652:	75 14                	jne    801668 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801654:	83 ec 04             	sub    $0x4,%esp
  801657:	68 74 5b 80 00       	push   $0x805b74
  80165c:	6a 3a                	push   $0x3a
  80165e:	68 68 5b 80 00       	push   $0x805b68
  801663:	e8 88 fe ff ff       	call   8014f0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801668:	ff 45 f0             	incl   -0x10(%ebp)
  80166b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801671:	0f 8c 2f ff ff ff    	jl     8015a6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801677:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80167e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801685:	eb 26                	jmp    8016ad <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801687:	a1 00 72 80 00       	mov    0x807200,%eax
  80168c:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  801692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801695:	89 d0                	mov    %edx,%eax
  801697:	01 c0                	add    %eax,%eax
  801699:	01 d0                	add    %edx,%eax
  80169b:	c1 e0 03             	shl    $0x3,%eax
  80169e:	01 c8                	add    %ecx,%eax
  8016a0:	8a 40 04             	mov    0x4(%eax),%al
  8016a3:	3c 01                	cmp    $0x1,%al
  8016a5:	75 03                	jne    8016aa <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8016a7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016aa:	ff 45 e0             	incl   -0x20(%ebp)
  8016ad:	a1 00 72 80 00       	mov    0x807200,%eax
  8016b2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016bb:	39 c2                	cmp    %eax,%edx
  8016bd:	77 c8                	ja     801687 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8016bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8016c5:	74 14                	je     8016db <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8016c7:	83 ec 04             	sub    $0x4,%esp
  8016ca:	68 c8 5b 80 00       	push   $0x805bc8
  8016cf:	6a 44                	push   $0x44
  8016d1:	68 68 5b 80 00       	push   $0x805b68
  8016d6:	e8 15 fe ff ff       	call   8014f0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8016db:	90                   	nop
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8016e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e8:	8b 00                	mov    (%eax),%eax
  8016ea:	8d 48 01             	lea    0x1(%eax),%ecx
  8016ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f0:	89 0a                	mov    %ecx,(%edx)
  8016f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f5:	88 d1                	mov    %dl,%cl
  8016f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8016fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801701:	8b 00                	mov    (%eax),%eax
  801703:	3d ff 00 00 00       	cmp    $0xff,%eax
  801708:	75 30                	jne    80173a <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80170a:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801710:	a0 24 72 80 00       	mov    0x807224,%al
  801715:	0f b6 c0             	movzbl %al,%eax
  801718:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80171b:	8b 09                	mov    (%ecx),%ecx
  80171d:	89 cb                	mov    %ecx,%ebx
  80171f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801722:	83 c1 08             	add    $0x8,%ecx
  801725:	52                   	push   %edx
  801726:	50                   	push   %eax
  801727:	53                   	push   %ebx
  801728:	51                   	push   %ecx
  801729:	e8 07 29 00 00       	call   804035 <sys_cputs>
  80172e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801731:	8b 45 0c             	mov    0xc(%ebp),%eax
  801734:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80173a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173d:	8b 40 04             	mov    0x4(%eax),%eax
  801740:	8d 50 01             	lea    0x1(%eax),%edx
  801743:	8b 45 0c             	mov    0xc(%ebp),%eax
  801746:	89 50 04             	mov    %edx,0x4(%eax)
}
  801749:	90                   	nop
  80174a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801758:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80175f:	00 00 00 
	b.cnt = 0;
  801762:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801769:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80176c:	ff 75 0c             	pushl  0xc(%ebp)
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801778:	50                   	push   %eax
  801779:	68 de 16 80 00       	push   $0x8016de
  80177e:	e8 5a 02 00 00       	call   8019dd <vprintfmt>
  801783:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801786:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  80178c:	a0 24 72 80 00       	mov    0x807224,%al
  801791:	0f b6 c0             	movzbl %al,%eax
  801794:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80179a:	52                   	push   %edx
  80179b:	50                   	push   %eax
  80179c:	51                   	push   %ecx
  80179d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8017a3:	83 c0 08             	add    $0x8,%eax
  8017a6:	50                   	push   %eax
  8017a7:	e8 89 28 00 00       	call   804035 <sys_cputs>
  8017ac:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8017af:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  8017b6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8017c4:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  8017cb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8017ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	83 ec 08             	sub    $0x8,%esp
  8017d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017da:	50                   	push   %eax
  8017db:	e8 6f ff ff ff       	call   80174f <vcprintf>
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8017e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8017f1:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	c1 e0 08             	shl    $0x8,%eax
  8017fe:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  801803:	8d 45 0c             	lea    0xc(%ebp),%eax
  801806:	83 c0 04             	add    $0x4,%eax
  801809:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80180c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	ff 75 f4             	pushl  -0xc(%ebp)
  801815:	50                   	push   %eax
  801816:	e8 34 ff ff ff       	call   80174f <vcprintf>
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801821:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  801828:	07 00 00 

	return cnt;
  80182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801836:	e8 3e 28 00 00       	call   804079 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80183b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80183e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	ff 75 f4             	pushl  -0xc(%ebp)
  80184a:	50                   	push   %eax
  80184b:	e8 ff fe ff ff       	call   80174f <vcprintf>
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801856:	e8 38 28 00 00       	call   804093 <sys_unlock_cons>
	return cnt;
  80185b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	53                   	push   %ebx
  801864:	83 ec 14             	sub    $0x14,%esp
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80186d:	8b 45 14             	mov    0x14(%ebp),%eax
  801870:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801873:	8b 45 18             	mov    0x18(%ebp),%eax
  801876:	ba 00 00 00 00       	mov    $0x0,%edx
  80187b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80187e:	77 55                	ja     8018d5 <printnum+0x75>
  801880:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801883:	72 05                	jb     80188a <printnum+0x2a>
  801885:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801888:	77 4b                	ja     8018d5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80188a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80188d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801890:	8b 45 18             	mov    0x18(%ebp),%eax
  801893:	ba 00 00 00 00       	mov    $0x0,%edx
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	ff 75 f4             	pushl  -0xc(%ebp)
  80189d:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a0:	e8 7f 38 00 00       	call   805124 <__udivdi3>
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	ff 75 20             	pushl  0x20(%ebp)
  8018ae:	53                   	push   %ebx
  8018af:	ff 75 18             	pushl  0x18(%ebp)
  8018b2:	52                   	push   %edx
  8018b3:	50                   	push   %eax
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	ff 75 08             	pushl  0x8(%ebp)
  8018ba:	e8 a1 ff ff ff       	call   801860 <printnum>
  8018bf:	83 c4 20             	add    $0x20,%esp
  8018c2:	eb 1a                	jmp    8018de <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8018c4:	83 ec 08             	sub    $0x8,%esp
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	ff 75 20             	pushl  0x20(%ebp)
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	ff d0                	call   *%eax
  8018d2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8018d5:	ff 4d 1c             	decl   0x1c(%ebp)
  8018d8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8018dc:	7f e6                	jg     8018c4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8018de:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8018e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ec:	53                   	push   %ebx
  8018ed:	51                   	push   %ecx
  8018ee:	52                   	push   %edx
  8018ef:	50                   	push   %eax
  8018f0:	e8 3f 39 00 00       	call   805234 <__umoddi3>
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	05 34 5e 80 00       	add    $0x805e34,%eax
  8018fd:	8a 00                	mov    (%eax),%al
  8018ff:	0f be c0             	movsbl %al,%eax
  801902:	83 ec 08             	sub    $0x8,%esp
  801905:	ff 75 0c             	pushl  0xc(%ebp)
  801908:	50                   	push   %eax
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	ff d0                	call   *%eax
  80190e:	83 c4 10             	add    $0x10,%esp
}
  801911:	90                   	nop
  801912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80191a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80191e:	7e 1c                	jle    80193c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	8b 00                	mov    (%eax),%eax
  801925:	8d 50 08             	lea    0x8(%eax),%edx
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	89 10                	mov    %edx,(%eax)
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	8b 00                	mov    (%eax),%eax
  801932:	83 e8 08             	sub    $0x8,%eax
  801935:	8b 50 04             	mov    0x4(%eax),%edx
  801938:	8b 00                	mov    (%eax),%eax
  80193a:	eb 40                	jmp    80197c <getuint+0x65>
	else if (lflag)
  80193c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801940:	74 1e                	je     801960 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	8b 00                	mov    (%eax),%eax
  801947:	8d 50 04             	lea    0x4(%eax),%edx
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	89 10                	mov    %edx,(%eax)
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	8b 00                	mov    (%eax),%eax
  801954:	83 e8 04             	sub    $0x4,%eax
  801957:	8b 00                	mov    (%eax),%eax
  801959:	ba 00 00 00 00       	mov    $0x0,%edx
  80195e:	eb 1c                	jmp    80197c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	8b 00                	mov    (%eax),%eax
  801965:	8d 50 04             	lea    0x4(%eax),%edx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	89 10                	mov    %edx,(%eax)
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	83 e8 04             	sub    $0x4,%eax
  801975:	8b 00                	mov    (%eax),%eax
  801977:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80197c:	5d                   	pop    %ebp
  80197d:	c3                   	ret    

0080197e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801981:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801985:	7e 1c                	jle    8019a3 <getint+0x25>
		return va_arg(*ap, long long);
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	8b 00                	mov    (%eax),%eax
  80198c:	8d 50 08             	lea    0x8(%eax),%edx
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	89 10                	mov    %edx,(%eax)
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	8b 00                	mov    (%eax),%eax
  801999:	83 e8 08             	sub    $0x8,%eax
  80199c:	8b 50 04             	mov    0x4(%eax),%edx
  80199f:	8b 00                	mov    (%eax),%eax
  8019a1:	eb 38                	jmp    8019db <getint+0x5d>
	else if (lflag)
  8019a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019a7:	74 1a                	je     8019c3 <getint+0x45>
		return va_arg(*ap, long);
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	8b 00                	mov    (%eax),%eax
  8019ae:	8d 50 04             	lea    0x4(%eax),%edx
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	89 10                	mov    %edx,(%eax)
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8b 00                	mov    (%eax),%eax
  8019bb:	83 e8 04             	sub    $0x4,%eax
  8019be:	8b 00                	mov    (%eax),%eax
  8019c0:	99                   	cltd   
  8019c1:	eb 18                	jmp    8019db <getint+0x5d>
	else
		return va_arg(*ap, int);
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	8b 00                	mov    (%eax),%eax
  8019c8:	8d 50 04             	lea    0x4(%eax),%edx
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	89 10                	mov    %edx,(%eax)
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8b 00                	mov    (%eax),%eax
  8019d5:	83 e8 04             	sub    $0x4,%eax
  8019d8:	8b 00                	mov    (%eax),%eax
  8019da:	99                   	cltd   
}
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    

008019dd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	56                   	push   %esi
  8019e1:	53                   	push   %ebx
  8019e2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8019e5:	eb 17                	jmp    8019fe <vprintfmt+0x21>
			if (ch == '\0')
  8019e7:	85 db                	test   %ebx,%ebx
  8019e9:	0f 84 c1 03 00 00    	je     801db0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8019ef:	83 ec 08             	sub    $0x8,%esp
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	53                   	push   %ebx
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	ff d0                	call   *%eax
  8019fb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8019fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801a01:	8d 50 01             	lea    0x1(%eax),%edx
  801a04:	89 55 10             	mov    %edx,0x10(%ebp)
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	0f b6 d8             	movzbl %al,%ebx
  801a0c:	83 fb 25             	cmp    $0x25,%ebx
  801a0f:	75 d6                	jne    8019e7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a11:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a15:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a1c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a23:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801a2a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a31:	8b 45 10             	mov    0x10(%ebp),%eax
  801a34:	8d 50 01             	lea    0x1(%eax),%edx
  801a37:	89 55 10             	mov    %edx,0x10(%ebp)
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	0f b6 d8             	movzbl %al,%ebx
  801a3f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801a42:	83 f8 5b             	cmp    $0x5b,%eax
  801a45:	0f 87 3d 03 00 00    	ja     801d88 <vprintfmt+0x3ab>
  801a4b:	8b 04 85 58 5e 80 00 	mov    0x805e58(,%eax,4),%eax
  801a52:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801a54:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801a58:	eb d7                	jmp    801a31 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801a5a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801a5e:	eb d1                	jmp    801a31 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801a60:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801a67:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a6a:	89 d0                	mov    %edx,%eax
  801a6c:	c1 e0 02             	shl    $0x2,%eax
  801a6f:	01 d0                	add    %edx,%eax
  801a71:	01 c0                	add    %eax,%eax
  801a73:	01 d8                	add    %ebx,%eax
  801a75:	83 e8 30             	sub    $0x30,%eax
  801a78:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801a7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801a83:	83 fb 2f             	cmp    $0x2f,%ebx
  801a86:	7e 3e                	jle    801ac6 <vprintfmt+0xe9>
  801a88:	83 fb 39             	cmp    $0x39,%ebx
  801a8b:	7f 39                	jg     801ac6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801a8d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801a90:	eb d5                	jmp    801a67 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801a92:	8b 45 14             	mov    0x14(%ebp),%eax
  801a95:	83 c0 04             	add    $0x4,%eax
  801a98:	89 45 14             	mov    %eax,0x14(%ebp)
  801a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9e:	83 e8 04             	sub    $0x4,%eax
  801aa1:	8b 00                	mov    (%eax),%eax
  801aa3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801aa6:	eb 1f                	jmp    801ac7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aac:	79 83                	jns    801a31 <vprintfmt+0x54>
				width = 0;
  801aae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801ab5:	e9 77 ff ff ff       	jmp    801a31 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801aba:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801ac1:	e9 6b ff ff ff       	jmp    801a31 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801ac6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801ac7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801acb:	0f 89 60 ff ff ff    	jns    801a31 <vprintfmt+0x54>
				width = precision, precision = -1;
  801ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ad7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801ade:	e9 4e ff ff ff       	jmp    801a31 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801ae3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801ae6:	e9 46 ff ff ff       	jmp    801a31 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801aeb:	8b 45 14             	mov    0x14(%ebp),%eax
  801aee:	83 c0 04             	add    $0x4,%eax
  801af1:	89 45 14             	mov    %eax,0x14(%ebp)
  801af4:	8b 45 14             	mov    0x14(%ebp),%eax
  801af7:	83 e8 04             	sub    $0x4,%eax
  801afa:	8b 00                	mov    (%eax),%eax
  801afc:	83 ec 08             	sub    $0x8,%esp
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	50                   	push   %eax
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	ff d0                	call   *%eax
  801b08:	83 c4 10             	add    $0x10,%esp
			break;
  801b0b:	e9 9b 02 00 00       	jmp    801dab <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b10:	8b 45 14             	mov    0x14(%ebp),%eax
  801b13:	83 c0 04             	add    $0x4,%eax
  801b16:	89 45 14             	mov    %eax,0x14(%ebp)
  801b19:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1c:	83 e8 04             	sub    $0x4,%eax
  801b1f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b21:	85 db                	test   %ebx,%ebx
  801b23:	79 02                	jns    801b27 <vprintfmt+0x14a>
				err = -err;
  801b25:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b27:	83 fb 64             	cmp    $0x64,%ebx
  801b2a:	7f 0b                	jg     801b37 <vprintfmt+0x15a>
  801b2c:	8b 34 9d a0 5c 80 00 	mov    0x805ca0(,%ebx,4),%esi
  801b33:	85 f6                	test   %esi,%esi
  801b35:	75 19                	jne    801b50 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801b37:	53                   	push   %ebx
  801b38:	68 45 5e 80 00       	push   $0x805e45
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	ff 75 08             	pushl  0x8(%ebp)
  801b43:	e8 70 02 00 00       	call   801db8 <printfmt>
  801b48:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b4b:	e9 5b 02 00 00       	jmp    801dab <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801b50:	56                   	push   %esi
  801b51:	68 4e 5e 80 00       	push   $0x805e4e
  801b56:	ff 75 0c             	pushl  0xc(%ebp)
  801b59:	ff 75 08             	pushl  0x8(%ebp)
  801b5c:	e8 57 02 00 00       	call   801db8 <printfmt>
  801b61:	83 c4 10             	add    $0x10,%esp
			break;
  801b64:	e9 42 02 00 00       	jmp    801dab <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801b69:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6c:	83 c0 04             	add    $0x4,%eax
  801b6f:	89 45 14             	mov    %eax,0x14(%ebp)
  801b72:	8b 45 14             	mov    0x14(%ebp),%eax
  801b75:	83 e8 04             	sub    $0x4,%eax
  801b78:	8b 30                	mov    (%eax),%esi
  801b7a:	85 f6                	test   %esi,%esi
  801b7c:	75 05                	jne    801b83 <vprintfmt+0x1a6>
				p = "(null)";
  801b7e:	be 51 5e 80 00       	mov    $0x805e51,%esi
			if (width > 0 && padc != '-')
  801b83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b87:	7e 6d                	jle    801bf6 <vprintfmt+0x219>
  801b89:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801b8d:	74 67                	je     801bf6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801b8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b92:	83 ec 08             	sub    $0x8,%esp
  801b95:	50                   	push   %eax
  801b96:	56                   	push   %esi
  801b97:	e8 1e 03 00 00       	call   801eba <strnlen>
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801ba2:	eb 16                	jmp    801bba <vprintfmt+0x1dd>
					putch(padc, putdat);
  801ba4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801ba8:	83 ec 08             	sub    $0x8,%esp
  801bab:	ff 75 0c             	pushl  0xc(%ebp)
  801bae:	50                   	push   %eax
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	ff d0                	call   *%eax
  801bb4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bb7:	ff 4d e4             	decl   -0x1c(%ebp)
  801bba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bbe:	7f e4                	jg     801ba4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801bc0:	eb 34                	jmp    801bf6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801bc2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801bc6:	74 1c                	je     801be4 <vprintfmt+0x207>
  801bc8:	83 fb 1f             	cmp    $0x1f,%ebx
  801bcb:	7e 05                	jle    801bd2 <vprintfmt+0x1f5>
  801bcd:	83 fb 7e             	cmp    $0x7e,%ebx
  801bd0:	7e 12                	jle    801be4 <vprintfmt+0x207>
					putch('?', putdat);
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	ff 75 0c             	pushl  0xc(%ebp)
  801bd8:	6a 3f                	push   $0x3f
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	ff d0                	call   *%eax
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	eb 0f                	jmp    801bf3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801be4:	83 ec 08             	sub    $0x8,%esp
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	53                   	push   %ebx
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	ff d0                	call   *%eax
  801bf0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801bf3:	ff 4d e4             	decl   -0x1c(%ebp)
  801bf6:	89 f0                	mov    %esi,%eax
  801bf8:	8d 70 01             	lea    0x1(%eax),%esi
  801bfb:	8a 00                	mov    (%eax),%al
  801bfd:	0f be d8             	movsbl %al,%ebx
  801c00:	85 db                	test   %ebx,%ebx
  801c02:	74 24                	je     801c28 <vprintfmt+0x24b>
  801c04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c08:	78 b8                	js     801bc2 <vprintfmt+0x1e5>
  801c0a:	ff 4d e0             	decl   -0x20(%ebp)
  801c0d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c11:	79 af                	jns    801bc2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c13:	eb 13                	jmp    801c28 <vprintfmt+0x24b>
				putch(' ', putdat);
  801c15:	83 ec 08             	sub    $0x8,%esp
  801c18:	ff 75 0c             	pushl  0xc(%ebp)
  801c1b:	6a 20                	push   $0x20
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	ff d0                	call   *%eax
  801c22:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c25:	ff 4d e4             	decl   -0x1c(%ebp)
  801c28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c2c:	7f e7                	jg     801c15 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801c2e:	e9 78 01 00 00       	jmp    801dab <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801c33:	83 ec 08             	sub    $0x8,%esp
  801c36:	ff 75 e8             	pushl  -0x18(%ebp)
  801c39:	8d 45 14             	lea    0x14(%ebp),%eax
  801c3c:	50                   	push   %eax
  801c3d:	e8 3c fd ff ff       	call   80197e <getint>
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c48:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c51:	85 d2                	test   %edx,%edx
  801c53:	79 23                	jns    801c78 <vprintfmt+0x29b>
				putch('-', putdat);
  801c55:	83 ec 08             	sub    $0x8,%esp
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	6a 2d                	push   $0x2d
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	ff d0                	call   *%eax
  801c62:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c6b:	f7 d8                	neg    %eax
  801c6d:	83 d2 00             	adc    $0x0,%edx
  801c70:	f7 da                	neg    %edx
  801c72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c75:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801c78:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801c7f:	e9 bc 00 00 00       	jmp    801d40 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801c84:	83 ec 08             	sub    $0x8,%esp
  801c87:	ff 75 e8             	pushl  -0x18(%ebp)
  801c8a:	8d 45 14             	lea    0x14(%ebp),%eax
  801c8d:	50                   	push   %eax
  801c8e:	e8 84 fc ff ff       	call   801917 <getuint>
  801c93:	83 c4 10             	add    $0x10,%esp
  801c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801c9c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ca3:	e9 98 00 00 00       	jmp    801d40 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801ca8:	83 ec 08             	sub    $0x8,%esp
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	6a 58                	push   $0x58
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	ff d0                	call   *%eax
  801cb5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801cb8:	83 ec 08             	sub    $0x8,%esp
  801cbb:	ff 75 0c             	pushl  0xc(%ebp)
  801cbe:	6a 58                	push   $0x58
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	ff d0                	call   *%eax
  801cc5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801cc8:	83 ec 08             	sub    $0x8,%esp
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	6a 58                	push   $0x58
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	ff d0                	call   *%eax
  801cd5:	83 c4 10             	add    $0x10,%esp
			break;
  801cd8:	e9 ce 00 00 00       	jmp    801dab <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	ff 75 0c             	pushl  0xc(%ebp)
  801ce3:	6a 30                	push   $0x30
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	ff d0                	call   *%eax
  801cea:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801ced:	83 ec 08             	sub    $0x8,%esp
  801cf0:	ff 75 0c             	pushl  0xc(%ebp)
  801cf3:	6a 78                	push   $0x78
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	ff d0                	call   *%eax
  801cfa:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801cfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801d00:	83 c0 04             	add    $0x4,%eax
  801d03:	89 45 14             	mov    %eax,0x14(%ebp)
  801d06:	8b 45 14             	mov    0x14(%ebp),%eax
  801d09:	83 e8 04             	sub    $0x4,%eax
  801d0c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d18:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d1f:	eb 1f                	jmp    801d40 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d21:	83 ec 08             	sub    $0x8,%esp
  801d24:	ff 75 e8             	pushl  -0x18(%ebp)
  801d27:	8d 45 14             	lea    0x14(%ebp),%eax
  801d2a:	50                   	push   %eax
  801d2b:	e8 e7 fb ff ff       	call   801917 <getuint>
  801d30:	83 c4 10             	add    $0x10,%esp
  801d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d36:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801d39:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d40:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d47:	83 ec 04             	sub    $0x4,%esp
  801d4a:	52                   	push   %edx
  801d4b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d4e:	50                   	push   %eax
  801d4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d52:	ff 75 f0             	pushl  -0x10(%ebp)
  801d55:	ff 75 0c             	pushl  0xc(%ebp)
  801d58:	ff 75 08             	pushl  0x8(%ebp)
  801d5b:	e8 00 fb ff ff       	call   801860 <printnum>
  801d60:	83 c4 20             	add    $0x20,%esp
			break;
  801d63:	eb 46                	jmp    801dab <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801d65:	83 ec 08             	sub    $0x8,%esp
  801d68:	ff 75 0c             	pushl  0xc(%ebp)
  801d6b:	53                   	push   %ebx
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	ff d0                	call   *%eax
  801d71:	83 c4 10             	add    $0x10,%esp
			break;
  801d74:	eb 35                	jmp    801dab <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801d76:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  801d7d:	eb 2c                	jmp    801dab <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801d7f:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  801d86:	eb 23                	jmp    801dab <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801d88:	83 ec 08             	sub    $0x8,%esp
  801d8b:	ff 75 0c             	pushl  0xc(%ebp)
  801d8e:	6a 25                	push   $0x25
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	ff d0                	call   *%eax
  801d95:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801d98:	ff 4d 10             	decl   0x10(%ebp)
  801d9b:	eb 03                	jmp    801da0 <vprintfmt+0x3c3>
  801d9d:	ff 4d 10             	decl   0x10(%ebp)
  801da0:	8b 45 10             	mov    0x10(%ebp),%eax
  801da3:	48                   	dec    %eax
  801da4:	8a 00                	mov    (%eax),%al
  801da6:	3c 25                	cmp    $0x25,%al
  801da8:	75 f3                	jne    801d9d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801daa:	90                   	nop
		}
	}
  801dab:	e9 35 fc ff ff       	jmp    8019e5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801db0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801db1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db4:	5b                   	pop    %ebx
  801db5:	5e                   	pop    %esi
  801db6:	5d                   	pop    %ebp
  801db7:	c3                   	ret    

00801db8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801dbe:	8d 45 10             	lea    0x10(%ebp),%eax
  801dc1:	83 c0 04             	add    $0x4,%eax
  801dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801dc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dca:	ff 75 f4             	pushl  -0xc(%ebp)
  801dcd:	50                   	push   %eax
  801dce:	ff 75 0c             	pushl  0xc(%ebp)
  801dd1:	ff 75 08             	pushl  0x8(%ebp)
  801dd4:	e8 04 fc ff ff       	call   8019dd <vprintfmt>
  801dd9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ddc:	90                   	nop
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de5:	8b 40 08             	mov    0x8(%eax),%eax
  801de8:	8d 50 01             	lea    0x1(%eax),%edx
  801deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dee:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df4:	8b 10                	mov    (%eax),%edx
  801df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df9:	8b 40 04             	mov    0x4(%eax),%eax
  801dfc:	39 c2                	cmp    %eax,%edx
  801dfe:	73 12                	jae    801e12 <sprintputch+0x33>
		*b->buf++ = ch;
  801e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e03:	8b 00                	mov    (%eax),%eax
  801e05:	8d 48 01             	lea    0x1(%eax),%ecx
  801e08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0b:	89 0a                	mov    %ecx,(%edx)
  801e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  801e10:	88 10                	mov    %dl,(%eax)
}
  801e12:	90                   	nop
  801e13:	5d                   	pop    %ebp
  801e14:	c3                   	ret    

00801e15 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e24:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	01 d0                	add    %edx,%eax
  801e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e3a:	74 06                	je     801e42 <vsnprintf+0x2d>
  801e3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e40:	7f 07                	jg     801e49 <vsnprintf+0x34>
		return -E_INVAL;
  801e42:	b8 03 00 00 00       	mov    $0x3,%eax
  801e47:	eb 20                	jmp    801e69 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e49:	ff 75 14             	pushl  0x14(%ebp)
  801e4c:	ff 75 10             	pushl  0x10(%ebp)
  801e4f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e52:	50                   	push   %eax
  801e53:	68 df 1d 80 00       	push   $0x801ddf
  801e58:	e8 80 fb ff ff       	call   8019dd <vprintfmt>
  801e5d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e63:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e71:	8d 45 10             	lea    0x10(%ebp),%eax
  801e74:	83 c0 04             	add    $0x4,%eax
  801e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e80:	50                   	push   %eax
  801e81:	ff 75 0c             	pushl  0xc(%ebp)
  801e84:	ff 75 08             	pushl  0x8(%ebp)
  801e87:	e8 89 ff ff ff       	call   801e15 <vsnprintf>
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801e9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ea4:	eb 06                	jmp    801eac <strlen+0x15>
		n++;
  801ea6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ea9:	ff 45 08             	incl   0x8(%ebp)
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	8a 00                	mov    (%eax),%al
  801eb1:	84 c0                	test   %al,%al
  801eb3:	75 f1                	jne    801ea6 <strlen+0xf>
		n++;
	return n;
  801eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ec0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ec7:	eb 09                	jmp    801ed2 <strnlen+0x18>
		n++;
  801ec9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ecc:	ff 45 08             	incl   0x8(%ebp)
  801ecf:	ff 4d 0c             	decl   0xc(%ebp)
  801ed2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ed6:	74 09                	je     801ee1 <strnlen+0x27>
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	84 c0                	test   %al,%al
  801edf:	75 e8                	jne    801ec9 <strnlen+0xf>
		n++;
	return n;
  801ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801ef2:	90                   	nop
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	8d 50 01             	lea    0x1(%eax),%edx
  801ef9:	89 55 08             	mov    %edx,0x8(%ebp)
  801efc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eff:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f02:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f05:	8a 12                	mov    (%edx),%dl
  801f07:	88 10                	mov    %dl,(%eax)
  801f09:	8a 00                	mov    (%eax),%al
  801f0b:	84 c0                	test   %al,%al
  801f0d:	75 e4                	jne    801ef3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f27:	eb 1f                	jmp    801f48 <strncpy+0x34>
		*dst++ = *src;
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	8d 50 01             	lea    0x1(%eax),%edx
  801f2f:	89 55 08             	mov    %edx,0x8(%ebp)
  801f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f35:	8a 12                	mov    (%edx),%dl
  801f37:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3c:	8a 00                	mov    (%eax),%al
  801f3e:	84 c0                	test   %al,%al
  801f40:	74 03                	je     801f45 <strncpy+0x31>
			src++;
  801f42:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f45:	ff 45 fc             	incl   -0x4(%ebp)
  801f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4b:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f4e:	72 d9                	jb     801f29 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801f50:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f65:	74 30                	je     801f97 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801f67:	eb 16                	jmp    801f7f <strlcpy+0x2a>
			*dst++ = *src++;
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	8d 50 01             	lea    0x1(%eax),%edx
  801f6f:	89 55 08             	mov    %edx,0x8(%ebp)
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f78:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f7b:	8a 12                	mov    (%edx),%dl
  801f7d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801f7f:	ff 4d 10             	decl   0x10(%ebp)
  801f82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f86:	74 09                	je     801f91 <strlcpy+0x3c>
  801f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8b:	8a 00                	mov    (%eax),%al
  801f8d:	84 c0                	test   %al,%al
  801f8f:	75 d8                	jne    801f69 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801f97:	8b 55 08             	mov    0x8(%ebp),%edx
  801f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f9d:	29 c2                	sub    %eax,%edx
  801f9f:	89 d0                	mov    %edx,%eax
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801fa6:	eb 06                	jmp    801fae <strcmp+0xb>
		p++, q++;
  801fa8:	ff 45 08             	incl   0x8(%ebp)
  801fab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	8a 00                	mov    (%eax),%al
  801fb3:	84 c0                	test   %al,%al
  801fb5:	74 0e                	je     801fc5 <strcmp+0x22>
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	8a 10                	mov    (%eax),%dl
  801fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbf:	8a 00                	mov    (%eax),%al
  801fc1:	38 c2                	cmp    %al,%dl
  801fc3:	74 e3                	je     801fa8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	8a 00                	mov    (%eax),%al
  801fca:	0f b6 d0             	movzbl %al,%edx
  801fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd0:	8a 00                	mov    (%eax),%al
  801fd2:	0f b6 c0             	movzbl %al,%eax
  801fd5:	29 c2                	sub    %eax,%edx
  801fd7:	89 d0                	mov    %edx,%eax
}
  801fd9:	5d                   	pop    %ebp
  801fda:	c3                   	ret    

00801fdb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801fde:	eb 09                	jmp    801fe9 <strncmp+0xe>
		n--, p++, q++;
  801fe0:	ff 4d 10             	decl   0x10(%ebp)
  801fe3:	ff 45 08             	incl   0x8(%ebp)
  801fe6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801fe9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fed:	74 17                	je     802006 <strncmp+0x2b>
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	8a 00                	mov    (%eax),%al
  801ff4:	84 c0                	test   %al,%al
  801ff6:	74 0e                	je     802006 <strncmp+0x2b>
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	8a 10                	mov    (%eax),%dl
  801ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802000:	8a 00                	mov    (%eax),%al
  802002:	38 c2                	cmp    %al,%dl
  802004:	74 da                	je     801fe0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802006:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80200a:	75 07                	jne    802013 <strncmp+0x38>
		return 0;
  80200c:	b8 00 00 00 00       	mov    $0x0,%eax
  802011:	eb 14                	jmp    802027 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	8a 00                	mov    (%eax),%al
  802018:	0f b6 d0             	movzbl %al,%edx
  80201b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201e:	8a 00                	mov    (%eax),%al
  802020:	0f b6 c0             	movzbl %al,%eax
  802023:	29 c2                	sub    %eax,%edx
  802025:	89 d0                	mov    %edx,%eax
}
  802027:	5d                   	pop    %ebp
  802028:	c3                   	ret    

00802029 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	83 ec 04             	sub    $0x4,%esp
  80202f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802032:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802035:	eb 12                	jmp    802049 <strchr+0x20>
		if (*s == c)
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	8a 00                	mov    (%eax),%al
  80203c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80203f:	75 05                	jne    802046 <strchr+0x1d>
			return (char *) s;
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	eb 11                	jmp    802057 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802046:	ff 45 08             	incl   0x8(%ebp)
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	8a 00                	mov    (%eax),%al
  80204e:	84 c0                	test   %al,%al
  802050:	75 e5                	jne    802037 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802062:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802065:	eb 0d                	jmp    802074 <strfind+0x1b>
		if (*s == c)
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	8a 00                	mov    (%eax),%al
  80206c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80206f:	74 0e                	je     80207f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802071:	ff 45 08             	incl   0x8(%ebp)
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	8a 00                	mov    (%eax),%al
  802079:	84 c0                	test   %al,%al
  80207b:	75 ea                	jne    802067 <strfind+0xe>
  80207d:	eb 01                	jmp    802080 <strfind+0x27>
		if (*s == c)
			break;
  80207f:	90                   	nop
	return (char *) s;
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802091:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802095:	76 63                	jbe    8020fa <memset+0x75>
		uint64 data_block = c;
  802097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209a:	99                   	cltd   
  80209b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80209e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8020a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a7:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8020ab:	c1 e0 08             	shl    $0x8,%eax
  8020ae:	09 45 f0             	or     %eax,-0x10(%ebp)
  8020b1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ba:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8020be:	c1 e0 10             	shl    $0x10,%eax
  8020c1:	09 45 f0             	or     %eax,-0x10(%ebp)
  8020c4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8020c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cd:	89 c2                	mov    %eax,%edx
  8020cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d4:	09 45 f0             	or     %eax,-0x10(%ebp)
  8020d7:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8020da:	eb 18                	jmp    8020f4 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8020dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8020df:	8d 41 08             	lea    0x8(%ecx),%eax
  8020e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020eb:	89 01                	mov    %eax,(%ecx)
  8020ed:	89 51 04             	mov    %edx,0x4(%ecx)
  8020f0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8020f4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8020f8:	77 e2                	ja     8020dc <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8020fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020fe:	74 23                	je     802123 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802103:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  802106:	eb 0e                	jmp    802116 <memset+0x91>
			*p8++ = (uint8)c;
  802108:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80210b:	8d 50 01             	lea    0x1(%eax),%edx
  80210e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802111:	8b 55 0c             	mov    0xc(%ebp),%edx
  802114:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  802116:	8b 45 10             	mov    0x10(%ebp),%eax
  802119:	8d 50 ff             	lea    -0x1(%eax),%edx
  80211c:	89 55 10             	mov    %edx,0x10(%ebp)
  80211f:	85 c0                	test   %eax,%eax
  802121:	75 e5                	jne    802108 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80212e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802131:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80213a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80213e:	76 24                	jbe    802164 <memcpy+0x3c>
		while(n >= 8){
  802140:	eb 1c                	jmp    80215e <memcpy+0x36>
			*d64 = *s64;
  802142:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802145:	8b 50 04             	mov    0x4(%eax),%edx
  802148:	8b 00                	mov    (%eax),%eax
  80214a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80214d:	89 01                	mov    %eax,(%ecx)
  80214f:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802152:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  802156:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80215a:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80215e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802162:	77 de                	ja     802142 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802164:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802168:	74 31                	je     80219b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80216a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802170:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802173:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802176:	eb 16                	jmp    80218e <memcpy+0x66>
			*d8++ = *s8++;
  802178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217b:	8d 50 01             	lea    0x1(%eax),%edx
  80217e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802181:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802184:	8d 4a 01             	lea    0x1(%edx),%ecx
  802187:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80218a:	8a 12                	mov    (%edx),%dl
  80218c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80218e:	8b 45 10             	mov    0x10(%ebp),%eax
  802191:	8d 50 ff             	lea    -0x1(%eax),%edx
  802194:	89 55 10             	mov    %edx,0x10(%ebp)
  802197:	85 c0                	test   %eax,%eax
  802199:	75 dd                	jne    802178 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8021a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8021b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8021b8:	73 50                	jae    80220a <memmove+0x6a>
  8021ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c0:	01 d0                	add    %edx,%eax
  8021c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8021c5:	76 43                	jbe    80220a <memmove+0x6a>
		s += n;
  8021c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ca:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8021cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8021d3:	eb 10                	jmp    8021e5 <memmove+0x45>
			*--d = *--s;
  8021d5:	ff 4d f8             	decl   -0x8(%ebp)
  8021d8:	ff 4d fc             	decl   -0x4(%ebp)
  8021db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021de:	8a 10                	mov    (%eax),%dl
  8021e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021e3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8021e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	75 e3                	jne    8021d5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8021f2:	eb 23                	jmp    802217 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8021f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021f7:	8d 50 01             	lea    0x1(%eax),%edx
  8021fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802200:	8d 4a 01             	lea    0x1(%edx),%ecx
  802203:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802206:	8a 12                	mov    (%edx),%dl
  802208:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80220a:	8b 45 10             	mov    0x10(%ebp),%eax
  80220d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802210:	89 55 10             	mov    %edx,0x10(%ebp)
  802213:	85 c0                	test   %eax,%eax
  802215:	75 dd                	jne    8021f4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80222e:	eb 2a                	jmp    80225a <memcmp+0x3e>
		if (*s1 != *s2)
  802230:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802233:	8a 10                	mov    (%eax),%dl
  802235:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802238:	8a 00                	mov    (%eax),%al
  80223a:	38 c2                	cmp    %al,%dl
  80223c:	74 16                	je     802254 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80223e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802241:	8a 00                	mov    (%eax),%al
  802243:	0f b6 d0             	movzbl %al,%edx
  802246:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802249:	8a 00                	mov    (%eax),%al
  80224b:	0f b6 c0             	movzbl %al,%eax
  80224e:	29 c2                	sub    %eax,%edx
  802250:	89 d0                	mov    %edx,%eax
  802252:	eb 18                	jmp    80226c <memcmp+0x50>
		s1++, s2++;
  802254:	ff 45 fc             	incl   -0x4(%ebp)
  802257:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80225a:	8b 45 10             	mov    0x10(%ebp),%eax
  80225d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802260:	89 55 10             	mov    %edx,0x10(%ebp)
  802263:	85 c0                	test   %eax,%eax
  802265:	75 c9                	jne    802230 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802267:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802274:	8b 55 08             	mov    0x8(%ebp),%edx
  802277:	8b 45 10             	mov    0x10(%ebp),%eax
  80227a:	01 d0                	add    %edx,%eax
  80227c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80227f:	eb 15                	jmp    802296 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	8a 00                	mov    (%eax),%al
  802286:	0f b6 d0             	movzbl %al,%edx
  802289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228c:	0f b6 c0             	movzbl %al,%eax
  80228f:	39 c2                	cmp    %eax,%edx
  802291:	74 0d                	je     8022a0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802293:	ff 45 08             	incl   0x8(%ebp)
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80229c:	72 e3                	jb     802281 <memfind+0x13>
  80229e:	eb 01                	jmp    8022a1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8022a0:	90                   	nop
	return (void *) s;
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8022ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8022b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8022ba:	eb 03                	jmp    8022bf <strtol+0x19>
		s++;
  8022bc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	8a 00                	mov    (%eax),%al
  8022c4:	3c 20                	cmp    $0x20,%al
  8022c6:	74 f4                	je     8022bc <strtol+0x16>
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	8a 00                	mov    (%eax),%al
  8022cd:	3c 09                	cmp    $0x9,%al
  8022cf:	74 eb                	je     8022bc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	8a 00                	mov    (%eax),%al
  8022d6:	3c 2b                	cmp    $0x2b,%al
  8022d8:	75 05                	jne    8022df <strtol+0x39>
		s++;
  8022da:	ff 45 08             	incl   0x8(%ebp)
  8022dd:	eb 13                	jmp    8022f2 <strtol+0x4c>
	else if (*s == '-')
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	8a 00                	mov    (%eax),%al
  8022e4:	3c 2d                	cmp    $0x2d,%al
  8022e6:	75 0a                	jne    8022f2 <strtol+0x4c>
		s++, neg = 1;
  8022e8:	ff 45 08             	incl   0x8(%ebp)
  8022eb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8022f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022f6:	74 06                	je     8022fe <strtol+0x58>
  8022f8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8022fc:	75 20                	jne    80231e <strtol+0x78>
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	8a 00                	mov    (%eax),%al
  802303:	3c 30                	cmp    $0x30,%al
  802305:	75 17                	jne    80231e <strtol+0x78>
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	40                   	inc    %eax
  80230b:	8a 00                	mov    (%eax),%al
  80230d:	3c 78                	cmp    $0x78,%al
  80230f:	75 0d                	jne    80231e <strtol+0x78>
		s += 2, base = 16;
  802311:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802315:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80231c:	eb 28                	jmp    802346 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80231e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802322:	75 15                	jne    802339 <strtol+0x93>
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	8a 00                	mov    (%eax),%al
  802329:	3c 30                	cmp    $0x30,%al
  80232b:	75 0c                	jne    802339 <strtol+0x93>
		s++, base = 8;
  80232d:	ff 45 08             	incl   0x8(%ebp)
  802330:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802337:	eb 0d                	jmp    802346 <strtol+0xa0>
	else if (base == 0)
  802339:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80233d:	75 07                	jne    802346 <strtol+0xa0>
		base = 10;
  80233f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	8a 00                	mov    (%eax),%al
  80234b:	3c 2f                	cmp    $0x2f,%al
  80234d:	7e 19                	jle    802368 <strtol+0xc2>
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	8a 00                	mov    (%eax),%al
  802354:	3c 39                	cmp    $0x39,%al
  802356:	7f 10                	jg     802368 <strtol+0xc2>
			dig = *s - '0';
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	8a 00                	mov    (%eax),%al
  80235d:	0f be c0             	movsbl %al,%eax
  802360:	83 e8 30             	sub    $0x30,%eax
  802363:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802366:	eb 42                	jmp    8023aa <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	8a 00                	mov    (%eax),%al
  80236d:	3c 60                	cmp    $0x60,%al
  80236f:	7e 19                	jle    80238a <strtol+0xe4>
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	8a 00                	mov    (%eax),%al
  802376:	3c 7a                	cmp    $0x7a,%al
  802378:	7f 10                	jg     80238a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	8a 00                	mov    (%eax),%al
  80237f:	0f be c0             	movsbl %al,%eax
  802382:	83 e8 57             	sub    $0x57,%eax
  802385:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802388:	eb 20                	jmp    8023aa <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	8a 00                	mov    (%eax),%al
  80238f:	3c 40                	cmp    $0x40,%al
  802391:	7e 39                	jle    8023cc <strtol+0x126>
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	8a 00                	mov    (%eax),%al
  802398:	3c 5a                	cmp    $0x5a,%al
  80239a:	7f 30                	jg     8023cc <strtol+0x126>
			dig = *s - 'A' + 10;
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	8a 00                	mov    (%eax),%al
  8023a1:	0f be c0             	movsbl %al,%eax
  8023a4:	83 e8 37             	sub    $0x37,%eax
  8023a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	3b 45 10             	cmp    0x10(%ebp),%eax
  8023b0:	7d 19                	jge    8023cb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8023b2:	ff 45 08             	incl   0x8(%ebp)
  8023b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023b8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8023bc:	89 c2                	mov    %eax,%edx
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	01 d0                	add    %edx,%eax
  8023c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8023c6:	e9 7b ff ff ff       	jmp    802346 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8023cb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8023cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023d0:	74 08                	je     8023da <strtol+0x134>
		*endptr = (char *) s;
  8023d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8023da:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023de:	74 07                	je     8023e7 <strtol+0x141>
  8023e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023e3:	f7 d8                	neg    %eax
  8023e5:	eb 03                	jmp    8023ea <strtol+0x144>
  8023e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <ltostr>:

void
ltostr(long value, char *str)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8023f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8023f9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802400:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802404:	79 13                	jns    802419 <ltostr+0x2d>
	{
		neg = 1;
  802406:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80240d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802410:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802413:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802416:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802421:	99                   	cltd   
  802422:	f7 f9                	idiv   %ecx
  802424:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802427:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80242a:	8d 50 01             	lea    0x1(%eax),%edx
  80242d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802430:	89 c2                	mov    %eax,%edx
  802432:	8b 45 0c             	mov    0xc(%ebp),%eax
  802435:	01 d0                	add    %edx,%eax
  802437:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80243a:	83 c2 30             	add    $0x30,%edx
  80243d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80243f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802442:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802447:	f7 e9                	imul   %ecx
  802449:	c1 fa 02             	sar    $0x2,%edx
  80244c:	89 c8                	mov    %ecx,%eax
  80244e:	c1 f8 1f             	sar    $0x1f,%eax
  802451:	29 c2                	sub    %eax,%edx
  802453:	89 d0                	mov    %edx,%eax
  802455:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802458:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80245c:	75 bb                	jne    802419 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80245e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802465:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802468:	48                   	dec    %eax
  802469:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80246c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802470:	74 3d                	je     8024af <ltostr+0xc3>
		start = 1 ;
  802472:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802479:	eb 34                	jmp    8024af <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80247b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802481:	01 d0                	add    %edx,%eax
  802483:	8a 00                	mov    (%eax),%al
  802485:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802488:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248e:	01 c2                	add    %eax,%edx
  802490:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802493:	8b 45 0c             	mov    0xc(%ebp),%eax
  802496:	01 c8                	add    %ecx,%eax
  802498:	8a 00                	mov    (%eax),%al
  80249a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80249c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80249f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a2:	01 c2                	add    %eax,%edx
  8024a4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8024a7:	88 02                	mov    %al,(%edx)
		start++ ;
  8024a9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8024ac:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024b5:	7c c4                	jl     80247b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8024b7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8024ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bd:	01 d0                	add    %edx,%eax
  8024bf:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8024c2:	90                   	nop
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
  8024c8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8024cb:	ff 75 08             	pushl  0x8(%ebp)
  8024ce:	e8 c4 f9 ff ff       	call   801e97 <strlen>
  8024d3:	83 c4 04             	add    $0x4,%esp
  8024d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8024d9:	ff 75 0c             	pushl  0xc(%ebp)
  8024dc:	e8 b6 f9 ff ff       	call   801e97 <strlen>
  8024e1:	83 c4 04             	add    $0x4,%esp
  8024e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8024e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8024ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024f5:	eb 17                	jmp    80250e <strcconcat+0x49>
		final[s] = str1[s] ;
  8024f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8024fd:	01 c2                	add    %eax,%edx
  8024ff:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	01 c8                	add    %ecx,%eax
  802507:	8a 00                	mov    (%eax),%al
  802509:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80250b:	ff 45 fc             	incl   -0x4(%ebp)
  80250e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802511:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802514:	7c e1                	jl     8024f7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802516:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80251d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802524:	eb 1f                	jmp    802545 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802526:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802529:	8d 50 01             	lea    0x1(%eax),%edx
  80252c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80252f:	89 c2                	mov    %eax,%edx
  802531:	8b 45 10             	mov    0x10(%ebp),%eax
  802534:	01 c2                	add    %eax,%edx
  802536:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253c:	01 c8                	add    %ecx,%eax
  80253e:	8a 00                	mov    (%eax),%al
  802540:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802542:	ff 45 f8             	incl   -0x8(%ebp)
  802545:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802548:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80254b:	7c d9                	jl     802526 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80254d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802550:	8b 45 10             	mov    0x10(%ebp),%eax
  802553:	01 d0                	add    %edx,%eax
  802555:	c6 00 00             	movb   $0x0,(%eax)
}
  802558:	90                   	nop
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80255e:	8b 45 14             	mov    0x14(%ebp),%eax
  802561:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802567:	8b 45 14             	mov    0x14(%ebp),%eax
  80256a:	8b 00                	mov    (%eax),%eax
  80256c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802573:	8b 45 10             	mov    0x10(%ebp),%eax
  802576:	01 d0                	add    %edx,%eax
  802578:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80257e:	eb 0c                	jmp    80258c <strsplit+0x31>
			*string++ = 0;
  802580:	8b 45 08             	mov    0x8(%ebp),%eax
  802583:	8d 50 01             	lea    0x1(%eax),%edx
  802586:	89 55 08             	mov    %edx,0x8(%ebp)
  802589:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	8a 00                	mov    (%eax),%al
  802591:	84 c0                	test   %al,%al
  802593:	74 18                	je     8025ad <strsplit+0x52>
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	8a 00                	mov    (%eax),%al
  80259a:	0f be c0             	movsbl %al,%eax
  80259d:	50                   	push   %eax
  80259e:	ff 75 0c             	pushl  0xc(%ebp)
  8025a1:	e8 83 fa ff ff       	call   802029 <strchr>
  8025a6:	83 c4 08             	add    $0x8,%esp
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	75 d3                	jne    802580 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8025ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b0:	8a 00                	mov    (%eax),%al
  8025b2:	84 c0                	test   %al,%al
  8025b4:	74 5a                	je     802610 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8025b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	83 f8 0f             	cmp    $0xf,%eax
  8025be:	75 07                	jne    8025c7 <strsplit+0x6c>
		{
			return 0;
  8025c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c5:	eb 66                	jmp    80262d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8025c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8025ca:	8b 00                	mov    (%eax),%eax
  8025cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8025cf:	8b 55 14             	mov    0x14(%ebp),%edx
  8025d2:	89 0a                	mov    %ecx,(%edx)
  8025d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025db:	8b 45 10             	mov    0x10(%ebp),%eax
  8025de:	01 c2                	add    %eax,%edx
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025e5:	eb 03                	jmp    8025ea <strsplit+0x8f>
			string++;
  8025e7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	8a 00                	mov    (%eax),%al
  8025ef:	84 c0                	test   %al,%al
  8025f1:	74 8b                	je     80257e <strsplit+0x23>
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	8a 00                	mov    (%eax),%al
  8025f8:	0f be c0             	movsbl %al,%eax
  8025fb:	50                   	push   %eax
  8025fc:	ff 75 0c             	pushl  0xc(%ebp)
  8025ff:	e8 25 fa ff ff       	call   802029 <strchr>
  802604:	83 c4 08             	add    $0x8,%esp
  802607:	85 c0                	test   %eax,%eax
  802609:	74 dc                	je     8025e7 <strsplit+0x8c>
			string++;
	}
  80260b:	e9 6e ff ff ff       	jmp    80257e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802610:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802611:	8b 45 14             	mov    0x14(%ebp),%eax
  802614:	8b 00                	mov    (%eax),%eax
  802616:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80261d:	8b 45 10             	mov    0x10(%ebp),%eax
  802620:	01 d0                	add    %edx,%eax
  802622:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802628:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802635:	8b 45 08             	mov    0x8(%ebp),%eax
  802638:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80263b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802642:	eb 4a                	jmp    80268e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802644:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	01 c2                	add    %eax,%edx
  80264c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80264f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802652:	01 c8                	add    %ecx,%eax
  802654:	8a 00                	mov    (%eax),%al
  802656:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802658:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80265b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265e:	01 d0                	add    %edx,%eax
  802660:	8a 00                	mov    (%eax),%al
  802662:	3c 40                	cmp    $0x40,%al
  802664:	7e 25                	jle    80268b <str2lower+0x5c>
  802666:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80266c:	01 d0                	add    %edx,%eax
  80266e:	8a 00                	mov    (%eax),%al
  802670:	3c 5a                	cmp    $0x5a,%al
  802672:	7f 17                	jg     80268b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802674:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	01 d0                	add    %edx,%eax
  80267c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80267f:	8b 55 08             	mov    0x8(%ebp),%edx
  802682:	01 ca                	add    %ecx,%edx
  802684:	8a 12                	mov    (%edx),%dl
  802686:	83 c2 20             	add    $0x20,%edx
  802689:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80268b:	ff 45 fc             	incl   -0x4(%ebp)
  80268e:	ff 75 0c             	pushl  0xc(%ebp)
  802691:	e8 01 f8 ff ff       	call   801e97 <strlen>
  802696:	83 c4 04             	add    $0x4,%esp
  802699:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80269c:	7f a6                	jg     802644 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80269e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
  8026a6:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8026a9:	a1 08 70 80 00       	mov    0x807008,%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	0f 84 95 00 00 00    	je     80274b <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8026b6:	83 ec 08             	sub    $0x8,%esp
  8026b9:	68 00 00 00 82       	push   $0x82000000
  8026be:	68 00 00 00 80       	push   $0x80000000
  8026c3:	e8 59 1f 00 00       	call   804621 <initialize_dynamic_allocator>
  8026c8:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8026cb:	e8 93 1d 00 00       	call   804463 <sys_get_uheap_strategy>
  8026d0:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8026d5:	a1 20 72 80 00       	mov    0x807220,%eax
  8026da:	05 00 10 00 00       	add    $0x1000,%eax
  8026df:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  8026e4:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8026e9:	a3 50 f2 81 00       	mov    %eax,0x81f250
		init_uspinlock(&ulock,"malloc",1);
  8026ee:	83 ec 04             	sub    $0x4,%esp
  8026f1:	6a 01                	push   $0x1
  8026f3:	68 c8 5f 80 00       	push   $0x805fc8
  8026f8:	68 20 f3 81 00       	push   $0x81f320
  8026fd:	e8 1a 29 00 00       	call   80501c <init_uspinlock>
  802702:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  802705:	c7 05 00 f3 81 00 00 	movl   $0x0,0x81f300
  80270c:	00 00 00 
  80270f:	c7 05 04 f3 81 00 00 	movl   $0x0,0x81f304
  802716:	00 00 00 
  802719:	c7 05 0c f3 81 00 00 	movl   $0x0,0x81f30c
  802720:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  802723:	c7 05 10 f3 81 00 00 	movl   $0x0,0x81f310
  80272a:	00 00 00 
  80272d:	c7 05 14 f3 81 00 00 	movl   $0x0,0x81f314
  802734:	00 00 00 
  802737:	c7 05 1c f3 81 00 00 	movl   $0x0,0x81f31c
  80273e:	00 00 00 
		__firstTimeFlag = 0;
  802741:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  802748:	00 00 00 
	}
}
  80274b:	90                   	nop
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802762:	83 ec 08             	sub    $0x8,%esp
  802765:	68 06 04 00 00       	push   $0x406
  80276a:	50                   	push   %eax
  80276b:	e8 3d 19 00 00       	call   8040ad <__sys_allocate_page>
  802770:	83 c4 10             	add    $0x10,%esp
  802773:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802776:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277a:	79 14                	jns    802790 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80277c:	83 ec 04             	sub    $0x4,%esp
  80277f:	68 d0 5f 80 00       	push   $0x805fd0
  802784:	6a 2d                	push   $0x2d
  802786:	68 0c 60 80 00       	push   $0x80600c
  80278b:	e8 60 ed ff ff       	call   8014f0 <_panic>
	return 0;
  802790:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802795:	c9                   	leave  
  802796:	c3                   	ret    

00802797 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802797:	55                   	push   %ebp
  802798:	89 e5                	mov    %esp,%ebp
  80279a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8027ab:	83 ec 0c             	sub    $0xc,%esp
  8027ae:	50                   	push   %eax
  8027af:	e8 40 19 00 00       	call   8040f4 <__sys_unmap_frame>
  8027b4:	83 c4 10             	add    $0x10,%esp
  8027b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8027ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027be:	79 14                	jns    8027d4 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8027c0:	83 ec 04             	sub    $0x4,%esp
  8027c3:	68 18 60 80 00       	push   $0x806018
  8027c8:	6a 38                	push   $0x38
  8027ca:	68 0c 60 80 00       	push   $0x80600c
  8027cf:	e8 1c ed ff ff       	call   8014f0 <_panic>
}
  8027d4:	90                   	nop
  8027d5:	c9                   	leave  
  8027d6:	c3                   	ret    

008027d7 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
  8027da:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8027dd:	e8 c1 fe ff ff       	call   8026a3 <uheap_init>
	if (size == 0) return NULL ;
  8027e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027e6:	75 0a                	jne    8027f2 <malloc+0x1b>
  8027e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ed:	e9 e1 04 00 00       	jmp    802cd3 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  8027f2:	83 ec 0c             	sub    $0xc,%esp
  8027f5:	68 20 f3 81 00       	push   $0x81f320
  8027fa:	e8 6c 28 00 00       	call   80506b <acquire_uspinlock>
  8027ff:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  802802:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  802809:	77 23                	ja     80282e <malloc+0x57>
		release_uspinlock(&ulock);
  80280b:	83 ec 0c             	sub    $0xc,%esp
  80280e:	68 20 f3 81 00       	push   $0x81f320
  802813:	e8 ab 28 00 00       	call   8050c3 <release_uspinlock>
  802818:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  80281b:	83 ec 0c             	sub    $0xc,%esp
  80281e:	ff 75 08             	pushl  0x8(%ebp)
  802821:	e8 dd 1f 00 00       	call   804803 <alloc_block>
  802826:	83 c4 10             	add    $0x10,%esp
  802829:	e9 a5 04 00 00       	jmp    802cd3 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80282e:	83 ec 0c             	sub    $0xc,%esp
  802831:	6a 10                	push   $0x10
  802833:	e8 cb 1f 00 00       	call   804803 <alloc_block>
  802838:	83 c4 10             	add    $0x10,%esp
  80283b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  80283e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802842:	75 0a                	jne    80284e <malloc+0x77>
			return NULL;
  802844:	b8 00 00 00 00       	mov    $0x0,%eax
  802849:	e9 85 04 00 00       	jmp    802cd3 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  80284e:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802855:	8b 55 08             	mov    0x8(%ebp),%edx
  802858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80285b:	01 d0                	add    %edx,%eax
  80285d:	48                   	dec    %eax
  80285e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802864:	ba 00 00 00 00       	mov    $0x0,%edx
  802869:	f7 75 e8             	divl   -0x18(%ebp)
  80286c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286f:	29 d0                	sub    %edx,%eax
  802871:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802874:	a1 04 f3 81 00       	mov    0x81f304,%eax
  802879:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80287c:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802881:	85 c0                	test   %eax,%eax
  802883:	74 0f                	je     802894 <malloc+0xbd>
  802885:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802888:	8b 40 04             	mov    0x4(%eax),%eax
  80288b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288e:	0f 83 ea 00 00 00    	jae    80297e <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  802894:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802899:	2b 45 08             	sub    0x8(%ebp),%eax
  80289c:	89 c2                	mov    %eax,%edx
  80289e:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8028a3:	39 c2                	cmp    %eax,%edx
  8028a5:	0f 86 b9 00 00 00    	jbe    802964 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  8028ab:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8028b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  8028b3:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	01 d0                	add    %edx,%eax
  8028be:	a3 50 f2 81 00       	mov    %eax,0x81f250
					allocblock->startva = requestedblockva;
  8028c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028c9:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8028cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d1:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8028d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028d8:	75 14                	jne    8028ee <malloc+0x117>
  8028da:	83 ec 04             	sub    $0x4,%esp
  8028dd:	68 58 60 80 00       	push   $0x806058
  8028e2:	6a 60                	push   $0x60
  8028e4:	68 0c 60 80 00       	push   $0x80600c
  8028e9:	e8 02 ec ff ff       	call   8014f0 <_panic>
  8028ee:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8028f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f7:	89 50 0c             	mov    %edx,0xc(%eax)
  8028fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0d                	je     802911 <malloc+0x13a>
  802904:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802909:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80290c:	89 50 08             	mov    %edx,0x8(%eax)
  80290f:	eb 08                	jmp    802919 <malloc+0x142>
  802911:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802914:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802919:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291c:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80292b:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802930:	40                   	inc    %eax
  802931:	a3 1c f3 81 00       	mov    %eax,0x81f31c


					sys_allocate_user_mem(allocblock->startva ,size);
  802936:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	83 ec 08             	sub    $0x8,%esp
  80293e:	ff 75 08             	pushl  0x8(%ebp)
  802941:	50                   	push   %eax
  802942:	e8 34 1c 00 00       	call   80457b <sys_allocate_user_mem>
  802947:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  80294a:	83 ec 0c             	sub    $0xc,%esp
  80294d:	68 20 f3 81 00       	push   $0x81f320
  802952:	e8 6c 27 00 00       	call   8050c3 <release_uspinlock>
  802957:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80295a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295d:	8b 00                	mov    (%eax),%eax
  80295f:	e9 6f 03 00 00       	jmp    802cd3 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  802964:	83 ec 0c             	sub    $0xc,%esp
  802967:	68 20 f3 81 00       	push   $0x81f320
  80296c:	e8 52 27 00 00       	call   8050c3 <release_uspinlock>
  802971:	83 c4 10             	add    $0x10,%esp
					return NULL;
  802974:	b8 00 00 00 00       	mov    $0x0,%eax
  802979:	e9 55 03 00 00       	jmp    802cd3 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80297e:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802983:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  802986:	e9 39 03 00 00       	jmp    802cc4 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 40 04             	mov    0x4(%eax),%eax
  802991:	3b 45 08             	cmp    0x8(%ebp),%eax
  802994:	0f 86 e7 01 00 00    	jbe    802b81 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  80299a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80299d:	8b 10                	mov    (%eax),%edx
  80299f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a2:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  8029a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029aa:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8029ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029b1:	75 14                	jne    8029c7 <malloc+0x1f0>
  8029b3:	83 ec 04             	sub    $0x4,%esp
  8029b6:	68 58 60 80 00       	push   $0x806058
  8029bb:	6a 72                	push   $0x72
  8029bd:	68 0c 60 80 00       	push   $0x80600c
  8029c2:	e8 29 eb ff ff       	call   8014f0 <_panic>
  8029c7:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8029cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d0:	89 50 0c             	mov    %edx,0xc(%eax)
  8029d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	74 0d                	je     8029ea <malloc+0x213>
  8029dd:	a1 14 f3 81 00       	mov    0x81f314,%eax
  8029e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029e5:	89 50 08             	mov    %edx,0x8(%eax)
  8029e8:	eb 08                	jmp    8029f2 <malloc+0x21b>
  8029ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ed:	a3 10 f3 81 00       	mov    %eax,0x81f310
  8029f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f5:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8029fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a04:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802a09:	40                   	inc    %eax
  802a0a:	a3 1c f3 81 00       	mov    %eax,0x81f31c
                lastfreeelement->startva += size;
  802a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a12:	8b 10                	mov    (%eax),%edx
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	01 c2                	add    %eax,%edx
  802a19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a1c:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  802a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a21:	8b 40 04             	mov    0x4(%eax),%eax
  802a24:	2b 45 08             	sub    0x8(%ebp),%eax
  802a27:	89 c2                	mov    %eax,%edx
  802a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2c:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802a2f:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802a34:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  802a37:	e9 0d 01 00 00       	jmp    802b49 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  802a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a3f:	8b 50 04             	mov    0x4(%eax),%edx
  802a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a45:	8b 40 04             	mov    0x4(%eax),%eax
  802a48:	39 c2                	cmp    %eax,%edx
  802a4a:	0f 83 f0 00 00 00    	jae    802b40 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802a50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a54:	75 14                	jne    802a6a <malloc+0x293>
  802a56:	83 ec 04             	sub    $0x4,%esp
  802a59:	68 7b 60 80 00       	push   $0x80607b
  802a5e:	6a 7a                	push   $0x7a
  802a60:	68 0c 60 80 00       	push   $0x80600c
  802a65:	e8 86 ea ff ff       	call   8014f0 <_panic>
  802a6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a6d:	8b 40 08             	mov    0x8(%eax),%eax
  802a70:	85 c0                	test   %eax,%eax
  802a72:	74 11                	je     802a85 <malloc+0x2ae>
  802a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a77:	8b 40 08             	mov    0x8(%eax),%eax
  802a7a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a7d:	8b 52 0c             	mov    0xc(%edx),%edx
  802a80:	89 50 0c             	mov    %edx,0xc(%eax)
  802a83:	eb 0b                	jmp    802a90 <malloc+0x2b9>
  802a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a88:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8b:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802a90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a93:	8b 40 0c             	mov    0xc(%eax),%eax
  802a96:	85 c0                	test   %eax,%eax
  802a98:	74 11                	je     802aab <malloc+0x2d4>
  802a9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802aa3:	8b 52 08             	mov    0x8(%edx),%edx
  802aa6:	89 50 08             	mov    %edx,0x8(%eax)
  802aa9:	eb 0b                	jmp    802ab6 <malloc+0x2df>
  802aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aae:	8b 40 08             	mov    0x8(%eax),%eax
  802ab1:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802ab6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802aca:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802acf:	48                   	dec    %eax
  802ad0:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802ad5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad9:	74 06                	je     802ae1 <malloc+0x30a>
  802adb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802adf:	75 14                	jne    802af5 <malloc+0x31e>
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	68 9c 60 80 00       	push   $0x80609c
  802ae9:	6a 7b                	push   $0x7b
  802aeb:	68 0c 60 80 00       	push   $0x80600c
  802af0:	e8 fb e9 ff ff       	call   8014f0 <_panic>
  802af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af8:	8b 50 0c             	mov    0xc(%eax),%edx
  802afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afe:	89 50 0c             	mov    %edx,0xc(%eax)
  802b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b07:	89 50 08             	mov    %edx,0x8(%eax)
  802b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 0e                	je     802b22 <malloc+0x34b>
  802b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b17:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b1d:	89 50 08             	mov    %edx,0x8(%eax)
  802b20:	eb 08                	jmp    802b2a <malloc+0x353>
  802b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b25:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b30:	89 50 0c             	mov    %edx,0xc(%eax)
  802b33:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802b38:	40                   	inc    %eax
  802b39:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		break;
  802b3e:	eb 13                	jmp    802b53 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	8b 40 08             	mov    0x8(%eax),%eax
  802b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  802b49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4d:	0f 85 e9 fe ff ff    	jne    802a3c <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  802b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	83 ec 08             	sub    $0x8,%esp
  802b5b:	ff 75 08             	pushl  0x8(%ebp)
  802b5e:	50                   	push   %eax
  802b5f:	e8 17 1a 00 00       	call   80457b <sys_allocate_user_mem>
  802b64:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  802b67:	83 ec 0c             	sub    $0xc,%esp
  802b6a:	68 20 f3 81 00       	push   $0x81f320
  802b6f:	e8 4f 25 00 00       	call   8050c3 <release_uspinlock>
  802b74:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  802b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	e9 52 01 00 00       	jmp    802cd3 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 40 04             	mov    0x4(%eax),%eax
  802b87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8a:	0f 85 2b 01 00 00    	jne    802cbb <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 10                	mov    (%eax),%edx
  802b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b98:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  802b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba0:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802ba3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ba7:	75 17                	jne    802bc0 <malloc+0x3e9>
  802ba9:	83 ec 04             	sub    $0x4,%esp
  802bac:	68 58 60 80 00       	push   $0x806058
  802bb1:	68 89 00 00 00       	push   $0x89
  802bb6:	68 0c 60 80 00       	push   $0x80600c
  802bbb:	e8 30 e9 ff ff       	call   8014f0 <_panic>
  802bc0:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc9:	89 50 0c             	mov    %edx,0xc(%eax)
  802bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	74 0d                	je     802be3 <malloc+0x40c>
  802bd6:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802bdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bde:	89 50 08             	mov    %edx,0x8(%eax)
  802be1:	eb 08                	jmp    802beb <malloc+0x414>
  802be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be6:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bee:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bfd:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802c02:	40                   	inc    %eax
  802c03:	a3 1c f3 81 00       	mov    %eax,0x81f31c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  802c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0c:	75 17                	jne    802c25 <malloc+0x44e>
  802c0e:	83 ec 04             	sub    $0x4,%esp
  802c11:	68 7b 60 80 00       	push   $0x80607b
  802c16:	68 8a 00 00 00       	push   $0x8a
  802c1b:	68 0c 60 80 00       	push   $0x80600c
  802c20:	e8 cb e8 ff ff       	call   8014f0 <_panic>
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 40 08             	mov    0x8(%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	74 11                	je     802c40 <malloc+0x469>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 40 08             	mov    0x8(%eax),%eax
  802c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c38:	8b 52 0c             	mov    0xc(%edx),%edx
  802c3b:	89 50 0c             	mov    %edx,0xc(%eax)
  802c3e:	eb 0b                	jmp    802c4b <malloc+0x474>
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 0c             	mov    0xc(%eax),%eax
  802c46:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	74 11                	je     802c66 <malloc+0x48f>
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5e:	8b 52 08             	mov    0x8(%edx),%edx
  802c61:	89 50 08             	mov    %edx,0x8(%eax)
  802c64:	eb 0b                	jmp    802c71 <malloc+0x49a>
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 40 08             	mov    0x8(%eax),%eax
  802c6c:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c85:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802c8a:	48                   	dec    %eax
  802c8b:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				sys_allocate_user_mem(allocblock->startva ,size);
  802c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	83 ec 08             	sub    $0x8,%esp
  802c98:	ff 75 08             	pushl  0x8(%ebp)
  802c9b:	50                   	push   %eax
  802c9c:	e8 da 18 00 00       	call   80457b <sys_allocate_user_mem>
  802ca1:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  802ca4:	83 ec 0c             	sub    $0xc,%esp
  802ca7:	68 20 f3 81 00       	push   $0x81f320
  802cac:	e8 12 24 00 00       	call   8050c3 <release_uspinlock>
  802cb1:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  802cb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb7:	8b 00                	mov    (%eax),%eax
  802cb9:	eb 18                	jmp    802cd3 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 40 08             	mov    0x8(%eax),%eax
  802cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  802cc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc8:	0f 85 bd fc ff ff    	jne    80298b <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  802cce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cd3:	c9                   	leave  
  802cd4:	c3                   	ret    

00802cd5 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802cd5:	55                   	push   %ebp
  802cd6:	89 e5                	mov    %esp,%ebp
  802cd8:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ce1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ce4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802ce9:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  802cec:	e8 b2 f9 ff ff       	call   8026a3 <uheap_init>
		acquire_uspinlock(&ulock);
  802cf1:	83 ec 0c             	sub    $0xc,%esp
  802cf4:	68 20 f3 81 00       	push   $0x81f320
  802cf9:	e8 6d 23 00 00       	call   80506b <acquire_uspinlock>
  802cfe:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  802d01:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802d06:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802d09:	73 23                	jae    802d2e <free+0x59>
			free_block(virtual_address);
  802d0b:	83 ec 0c             	sub    $0xc,%esp
  802d0e:	ff 75 08             	pushl  0x8(%ebp)
  802d11:	e8 89 1f 00 00       	call   804c9f <free_block>
  802d16:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  802d19:	83 ec 0c             	sub    $0xc,%esp
  802d1c:	68 20 f3 81 00       	push   $0x81f320
  802d21:	e8 9d 23 00 00       	call   8050c3 <release_uspinlock>
  802d26:	83 c4 10             	add    $0x10,%esp
			return;
  802d29:	e9 35 07 00 00       	jmp    803463 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802d2e:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802d33:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802d36:	72 30                	jb     802d68 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  802d38:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802d3d:	83 ec 04             	sub    $0x4,%esp
  802d40:	50                   	push   %eax
  802d41:	ff 75 d8             	pushl  -0x28(%ebp)
  802d44:	68 d1 60 80 00       	push   $0x8060d1
  802d49:	e8 70 ea ff ff       	call   8017be <cprintf>
  802d4e:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802d51:	83 ec 04             	sub    $0x4,%esp
  802d54:	68 d9 60 80 00       	push   $0x8060d9
  802d59:	68 a7 00 00 00       	push   $0xa7
  802d5e:	68 0c 60 80 00       	push   $0x80600c
  802d63:	e8 88 e7 ff ff       	call   8014f0 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802d68:	83 ec 0c             	sub    $0xc,%esp
  802d6b:	6a 10                	push   $0x10
  802d6d:	e8 91 1a 00 00       	call   804803 <alloc_block>
  802d72:	83 c4 10             	add    $0x10,%esp
  802d75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  802d78:	83 ec 0c             	sub    $0xc,%esp
  802d7b:	6a 10                	push   $0x10
  802d7d:	e8 81 1a 00 00       	call   804803 <alloc_block>
  802d82:	83 c4 10             	add    $0x10,%esp
  802d85:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  802d88:	a1 10 f3 81 00       	mov    0x81f310,%eax
  802d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  802d90:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  802d97:	eb 1c                	jmp    802db5 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	8b 00                	mov    (%eax),%eax
  802d9e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802da1:	75 09                	jne    802dac <free+0xd7>
				foundVA = 1;
  802da3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  802daa:	eb 0f                	jmp    802dbb <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 40 08             	mov    0x8(%eax),%eax
  802db2:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  802db5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db9:	75 de                	jne    802d99 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  802dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dbf:	75 17                	jne    802dd8 <free+0x103>
				panic("INVALID ADDRESS!");
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	68 f6 60 80 00       	push   $0x8060f6
  802dc9:	68 be 00 00 00       	push   $0xbe
  802dce:	68 0c 60 80 00       	push   $0x80600c
  802dd3:	e8 18 e7 ff ff       	call   8014f0 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 10                	mov    (%eax),%edx
  802ddd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802de0:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 50 04             	mov    0x4(%eax),%edx
  802de8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802deb:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  802dee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df2:	75 17                	jne    802e0b <free+0x136>
  802df4:	83 ec 04             	sub    $0x4,%esp
  802df7:	68 7b 60 80 00       	push   $0x80607b
  802dfc:	68 c8 00 00 00       	push   $0xc8
  802e01:	68 0c 60 80 00       	push   $0x80600c
  802e06:	e8 e5 e6 ff ff       	call   8014f0 <_panic>
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 40 08             	mov    0x8(%eax),%eax
  802e11:	85 c0                	test   %eax,%eax
  802e13:	74 11                	je     802e26 <free+0x151>
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 40 08             	mov    0x8(%eax),%eax
  802e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e1e:	8b 52 0c             	mov    0xc(%edx),%edx
  802e21:	89 50 0c             	mov    %edx,0xc(%eax)
  802e24:	eb 0b                	jmp    802e31 <free+0x15c>
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2c:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 40 0c             	mov    0xc(%eax),%eax
  802e37:	85 c0                	test   %eax,%eax
  802e39:	74 11                	je     802e4c <free+0x177>
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e44:	8b 52 08             	mov    0x8(%edx),%edx
  802e47:	89 50 08             	mov    %edx,0x8(%eax)
  802e4a:	eb 0b                	jmp    802e57 <free+0x182>
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	8b 40 08             	mov    0x8(%eax),%eax
  802e52:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802e6b:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802e70:	48                   	dec    %eax
  802e71:	a3 1c f3 81 00       	mov    %eax,0x81f31c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 50 04             	mov    0x4(%eax),%edx
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	8b 00                	mov    (%eax),%eax
  802e81:	83 ec 08             	sub    $0x8,%esp
  802e84:	52                   	push   %edx
  802e85:	50                   	push   %eax
  802e86:	e8 d4 16 00 00       	call   80455f <sys_free_user_mem>
  802e8b:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  802e8e:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	75 7a                	jne    802f11 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  802e97:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e9b:	75 17                	jne    802eb4 <free+0x1df>
  802e9d:	83 ec 04             	sub    $0x4,%esp
  802ea0:	68 08 61 80 00       	push   $0x806108
  802ea5:	68 d0 00 00 00       	push   $0xd0
  802eaa:	68 0c 60 80 00       	push   $0x80600c
  802eaf:	e8 3c e6 ff ff       	call   8014f0 <_panic>
  802eb4:	8b 15 00 f3 81 00    	mov    0x81f300,%edx
  802eba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ebd:	89 50 08             	mov    %edx,0x8(%eax)
  802ec0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ec3:	8b 40 08             	mov    0x8(%eax),%eax
  802ec6:	85 c0                	test   %eax,%eax
  802ec8:	74 0d                	je     802ed7 <free+0x202>
  802eca:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802ecf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ed2:	89 50 0c             	mov    %edx,0xc(%eax)
  802ed5:	eb 08                	jmp    802edf <free+0x20a>
  802ed7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802eda:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802edf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ee2:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802ee7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802eea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ef1:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802ef6:	40                   	inc    %eax
  802ef7:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			release_uspinlock(&ulock);
  802efc:	83 ec 0c             	sub    $0xc,%esp
  802eff:	68 20 f3 81 00       	push   $0x81f320
  802f04:	e8 ba 21 00 00       	call   8050c3 <release_uspinlock>
  802f09:	83 c4 10             	add    $0x10,%esp
			return;
  802f0c:	e9 52 05 00 00       	jmp    803463 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  802f11:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802f16:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  802f19:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  802f20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  802f27:	e9 d2 00 00 00       	jmp    802ffe <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  802f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2f:	8b 10                	mov    (%eax),%edx
  802f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f34:	8b 40 04             	mov    0x4(%eax),%eax
  802f37:	01 c2                	add    %eax,%edx
  802f39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	39 c2                	cmp    %eax,%edx
  802f40:	0f 85 af 00 00 00    	jne    802ff5 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  802f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f49:	8b 10                	mov    (%eax),%edx
  802f4b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f4e:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  802f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f53:	8b 50 04             	mov    0x4(%eax),%edx
  802f56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f59:	8b 40 04             	mov    0x4(%eax),%eax
  802f5c:	01 c2                	add    %eax,%edx
  802f5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f61:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  802f64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f68:	75 17                	jne    802f81 <free+0x2ac>
  802f6a:	83 ec 04             	sub    $0x4,%esp
  802f6d:	68 7b 60 80 00       	push   $0x80607b
  802f72:	68 df 00 00 00       	push   $0xdf
  802f77:	68 0c 60 80 00       	push   $0x80600c
  802f7c:	e8 6f e5 ff ff       	call   8014f0 <_panic>
  802f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f84:	8b 40 08             	mov    0x8(%eax),%eax
  802f87:	85 c0                	test   %eax,%eax
  802f89:	74 11                	je     802f9c <free+0x2c7>
  802f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8e:	8b 40 08             	mov    0x8(%eax),%eax
  802f91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f94:	8b 52 0c             	mov    0xc(%edx),%edx
  802f97:	89 50 0c             	mov    %edx,0xc(%eax)
  802f9a:	eb 0b                	jmp    802fa7 <free+0x2d2>
  802f9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa2:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faa:	8b 40 0c             	mov    0xc(%eax),%eax
  802fad:	85 c0                	test   %eax,%eax
  802faf:	74 11                	je     802fc2 <free+0x2ed>
  802fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fba:	8b 52 08             	mov    0x8(%edx),%edx
  802fbd:	89 50 08             	mov    %edx,0x8(%eax)
  802fc0:	eb 0b                	jmp    802fcd <free+0x2f8>
  802fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc5:	8b 40 08             	mov    0x8(%eax),%eax
  802fc8:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802fcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fe1:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802fe6:	48                   	dec    %eax
  802fe7:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				mergeprev = 1;
  802fec:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  802ff3:	eb 13                	jmp    803008 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff8:	8b 40 08             	mov    0x8(%eax),%eax
  802ffb:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  802ffe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803002:	0f 85 24 ff ff ff    	jne    802f2c <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  803008:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80300b:	8b 10                	mov    (%eax),%edx
  80300d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803010:	8b 40 04             	mov    0x4(%eax),%eax
  803013:	01 c2                	add    %eax,%edx
  803015:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80301a:	39 c2                	cmp    %eax,%edx
  80301c:	75 44                	jne    803062 <free+0x38d>

			if(mergeprev){
  80301e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803022:	74 1f                	je     803043 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  803024:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803027:	8b 00                	mov    (%eax),%eax
  803029:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  80302e:	83 ec 0c             	sub    $0xc,%esp
  803031:	68 20 f3 81 00       	push   $0x81f320
  803036:	e8 88 20 00 00       	call   8050c3 <release_uspinlock>
  80303b:	83 c4 10             	add    $0x10,%esp
				return;
  80303e:	e9 20 04 00 00       	jmp    803463 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  803043:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  80304d:	83 ec 0c             	sub    $0xc,%esp
  803050:	68 20 f3 81 00       	push   $0x81f320
  803055:	e8 69 20 00 00       	call   8050c3 <release_uspinlock>
  80305a:	83 c4 10             	add    $0x10,%esp
				return;
  80305d:	e9 01 04 00 00       	jmp    803463 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  803062:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803067:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  80306a:	e9 7d 01 00 00       	jmp    8031ec <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  80306f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803072:	8b 10                	mov    (%eax),%edx
  803074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803077:	8b 40 04             	mov    0x4(%eax),%eax
  80307a:	01 c2                	add    %eax,%edx
  80307c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307f:	8b 00                	mov    (%eax),%eax
  803081:	39 c2                	cmp    %eax,%edx
  803083:	0f 85 5a 01 00 00    	jne    8031e3 <free+0x50e>
				if (mergeprev){
  803089:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80308d:	0f 84 a1 00 00 00    	je     803134 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  803093:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803096:	8b 50 04             	mov    0x4(%eax),%edx
  803099:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309c:	8b 40 04             	mov    0x4(%eax),%eax
  80309f:	01 c2                	add    %eax,%edx
  8030a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030a4:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8030a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030ab:	75 17                	jne    8030c4 <free+0x3ef>
  8030ad:	83 ec 04             	sub    $0x4,%esp
  8030b0:	68 7b 60 80 00       	push   $0x80607b
  8030b5:	68 0a 01 00 00       	push   $0x10a
  8030ba:	68 0c 60 80 00       	push   $0x80600c
  8030bf:	e8 2c e4 ff ff       	call   8014f0 <_panic>
  8030c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ca:	85 c0                	test   %eax,%eax
  8030cc:	74 11                	je     8030df <free+0x40a>
  8030ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d1:	8b 40 08             	mov    0x8(%eax),%eax
  8030d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030d7:	8b 52 0c             	mov    0xc(%edx),%edx
  8030da:	89 50 0c             	mov    %edx,0xc(%eax)
  8030dd:	eb 0b                	jmp    8030ea <free+0x415>
  8030df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e5:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8030ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	74 11                	je     803105 <free+0x430>
  8030f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030fd:	8b 52 08             	mov    0x8(%edx),%edx
  803100:	89 50 08             	mov    %edx,0x8(%eax)
  803103:	eb 0b                	jmp    803110 <free+0x43b>
  803105:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803108:	8b 40 08             	mov    0x8(%eax),%eax
  80310b:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803110:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803113:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80311a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803124:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803129:	48                   	dec    %eax
  80312a:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					break;
  80312f:	e9 c2 00 00 00       	jmp    8031f6 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  803134:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803137:	8b 10                	mov    (%eax),%edx
  803139:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80313c:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  80313e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803141:	8b 50 04             	mov    0x4(%eax),%edx
  803144:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803147:	8b 40 04             	mov    0x4(%eax),%eax
  80314a:	01 c2                	add    %eax,%edx
  80314c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80314f:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  803152:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803156:	75 17                	jne    80316f <free+0x49a>
  803158:	83 ec 04             	sub    $0x4,%esp
  80315b:	68 7b 60 80 00       	push   $0x80607b
  803160:	68 10 01 00 00       	push   $0x110
  803165:	68 0c 60 80 00       	push   $0x80600c
  80316a:	e8 81 e3 ff ff       	call   8014f0 <_panic>
  80316f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803172:	8b 40 08             	mov    0x8(%eax),%eax
  803175:	85 c0                	test   %eax,%eax
  803177:	74 11                	je     80318a <free+0x4b5>
  803179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317c:	8b 40 08             	mov    0x8(%eax),%eax
  80317f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803182:	8b 52 0c             	mov    0xc(%edx),%edx
  803185:	89 50 0c             	mov    %edx,0xc(%eax)
  803188:	eb 0b                	jmp    803195 <free+0x4c0>
  80318a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318d:	8b 40 0c             	mov    0xc(%eax),%eax
  803190:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803198:	8b 40 0c             	mov    0xc(%eax),%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	74 11                	je     8031b0 <free+0x4db>
  80319f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031a8:	8b 52 08             	mov    0x8(%edx),%edx
  8031ab:	89 50 08             	mov    %edx,0x8(%eax)
  8031ae:	eb 0b                	jmp    8031bb <free+0x4e6>
  8031b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b3:	8b 40 08             	mov    0x8(%eax),%eax
  8031b6:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8031bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8031cf:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8031d4:	48                   	dec    %eax
  8031d5:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					mergenext = 1;
  8031da:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8031e1:	eb 13                	jmp    8031f6 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8031e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e6:	8b 40 08             	mov    0x8(%eax),%eax
  8031e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  8031ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031f0:	0f 85 79 fe ff ff    	jne    80306f <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  8031f6:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8031fb:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  8031fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803202:	0f 85 ad 00 00 00    	jne    8032b5 <free+0x5e0>
  803208:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80320c:	0f 84 c3 01 00 00    	je     8033d5 <free+0x700>
				while(currentfree != NULL){
  803212:	e9 9e 00 00 00       	jmp    8032b5 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  803217:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80321a:	8b 50 04             	mov    0x4(%eax),%edx
  80321d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803220:	8b 40 04             	mov    0x4(%eax),%eax
  803223:	39 c2                	cmp    %eax,%edx
  803225:	0f 83 81 00 00 00    	jae    8032ac <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  80322b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80322f:	74 06                	je     803237 <free+0x562>
  803231:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803235:	75 17                	jne    80324e <free+0x579>
  803237:	83 ec 04             	sub    $0x4,%esp
  80323a:	68 9c 60 80 00       	push   $0x80609c
  80323f:	68 23 01 00 00       	push   $0x123
  803244:	68 0c 60 80 00       	push   $0x80600c
  803249:	e8 a2 e2 ff ff       	call   8014f0 <_panic>
  80324e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803251:	8b 50 0c             	mov    0xc(%eax),%edx
  803254:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803257:	89 50 0c             	mov    %edx,0xc(%eax)
  80325a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80325d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803260:	89 50 08             	mov    %edx,0x8(%eax)
  803263:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803266:	8b 40 0c             	mov    0xc(%eax),%eax
  803269:	85 c0                	test   %eax,%eax
  80326b:	74 0e                	je     80327b <free+0x5a6>
  80326d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803270:	8b 40 0c             	mov    0xc(%eax),%eax
  803273:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803276:	89 50 08             	mov    %edx,0x8(%eax)
  803279:	eb 08                	jmp    803283 <free+0x5ae>
  80327b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80327e:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803283:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803286:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803289:	89 50 0c             	mov    %edx,0xc(%eax)
  80328c:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803291:	40                   	inc    %eax
  803292:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  803297:	83 ec 0c             	sub    $0xc,%esp
  80329a:	68 20 f3 81 00       	push   $0x81f320
  80329f:	e8 1f 1e 00 00       	call   8050c3 <release_uspinlock>
  8032a4:	83 c4 10             	add    $0x10,%esp
							return;
  8032a7:	e9 b7 01 00 00       	jmp    803463 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8032ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032af:	8b 40 08             	mov    0x8(%eax),%eax
  8032b2:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  8032b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8032b9:	0f 85 58 ff ff ff    	jne    803217 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  8032bf:	83 ec 0c             	sub    $0xc,%esp
  8032c2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8032c5:	e8 d5 19 00 00       	call   804c9f <free_block>
  8032ca:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8032cd:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8032d1:	75 17                	jne    8032ea <free+0x615>
  8032d3:	83 ec 04             	sub    $0x4,%esp
  8032d6:	68 58 60 80 00       	push   $0x806058
  8032db:	68 2a 01 00 00       	push   $0x12a
  8032e0:	68 0c 60 80 00       	push   $0x80600c
  8032e5:	e8 06 e2 ff ff       	call   8014f0 <_panic>
  8032ea:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  8032f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032f3:	89 50 0c             	mov    %edx,0xc(%eax)
  8032f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fc:	85 c0                	test   %eax,%eax
  8032fe:	74 0d                	je     80330d <free+0x638>
  803300:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803305:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803308:	89 50 08             	mov    %edx,0x8(%eax)
  80330b:	eb 08                	jmp    803315 <free+0x640>
  80330d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803310:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803315:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803318:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80331d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803320:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803327:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80332c:	40                   	inc    %eax
  80332d:	a3 0c f3 81 00       	mov    %eax,0x81f30c
  803332:	e9 1b 01 00 00       	jmp    803452 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  803337:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80333a:	8b 50 04             	mov    0x4(%eax),%edx
  80333d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803340:	8b 40 04             	mov    0x4(%eax),%eax
  803343:	39 c2                	cmp    %eax,%edx
  803345:	0f 83 81 00 00 00    	jae    8033cc <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  80334b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80334f:	74 06                	je     803357 <free+0x682>
  803351:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803355:	75 17                	jne    80336e <free+0x699>
  803357:	83 ec 04             	sub    $0x4,%esp
  80335a:	68 9c 60 80 00       	push   $0x80609c
  80335f:	68 30 01 00 00       	push   $0x130
  803364:	68 0c 60 80 00       	push   $0x80600c
  803369:	e8 82 e1 ff ff       	call   8014f0 <_panic>
  80336e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803371:	8b 50 0c             	mov    0xc(%eax),%edx
  803374:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803377:	89 50 0c             	mov    %edx,0xc(%eax)
  80337a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803380:	89 50 08             	mov    %edx,0x8(%eax)
  803383:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803386:	8b 40 0c             	mov    0xc(%eax),%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	74 0e                	je     80339b <free+0x6c6>
  80338d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803390:	8b 40 0c             	mov    0xc(%eax),%eax
  803393:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803396:	89 50 08             	mov    %edx,0x8(%eax)
  803399:	eb 08                	jmp    8033a3 <free+0x6ce>
  80339b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339e:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8033a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033a9:	89 50 0c             	mov    %edx,0xc(%eax)
  8033ac:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8033b1:	40                   	inc    %eax
  8033b2:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  8033b7:	83 ec 0c             	sub    $0xc,%esp
  8033ba:	68 20 f3 81 00       	push   $0x81f320
  8033bf:	e8 ff 1c 00 00       	call   8050c3 <release_uspinlock>
  8033c4:	83 c4 10             	add    $0x10,%esp
							return;
  8033c7:	e9 97 00 00 00       	jmp    803463 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8033cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033cf:	8b 40 08             	mov    0x8(%eax),%eax
  8033d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  8033d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033d9:	0f 85 58 ff ff ff    	jne    803337 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8033df:	83 ec 0c             	sub    $0xc,%esp
  8033e2:	ff 75 d0             	pushl  -0x30(%ebp)
  8033e5:	e8 b5 18 00 00       	call   804c9f <free_block>
  8033ea:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8033ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033f1:	75 17                	jne    80340a <free+0x735>
  8033f3:	83 ec 04             	sub    $0x4,%esp
  8033f6:	68 58 60 80 00       	push   $0x806058
  8033fb:	68 37 01 00 00       	push   $0x137
  803400:	68 0c 60 80 00       	push   $0x80600c
  803405:	e8 e6 e0 ff ff       	call   8014f0 <_panic>
  80340a:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  803410:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803413:	89 50 0c             	mov    %edx,0xc(%eax)
  803416:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803419:	8b 40 0c             	mov    0xc(%eax),%eax
  80341c:	85 c0                	test   %eax,%eax
  80341e:	74 0d                	je     80342d <free+0x758>
  803420:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803425:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803428:	89 50 08             	mov    %edx,0x8(%eax)
  80342b:	eb 08                	jmp    803435 <free+0x760>
  80342d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803430:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803435:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803438:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80343d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803440:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803447:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80344c:	40                   	inc    %eax
  80344d:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			}
		release_uspinlock(&ulock);
  803452:	83 ec 0c             	sub    $0xc,%esp
  803455:	68 20 f3 81 00       	push   $0x81f320
  80345a:	e8 64 1c 00 00       	call   8050c3 <release_uspinlock>
  80345f:	83 c4 10             	add    $0x10,%esp
		return;
  803462:	90                   	nop
}
  803463:	c9                   	leave  
  803464:	c3                   	ret    

00803465 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  803465:	55                   	push   %ebp
  803466:	89 e5                	mov    %esp,%ebp
  803468:	83 ec 48             	sub    $0x48,%esp
  80346b:	8b 45 10             	mov    0x10(%ebp),%eax
  80346e:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803471:	e8 2d f2 ff ff       	call   8026a3 <uheap_init>
	if (size == 0) return NULL;
  803476:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80347a:	75 0a                	jne    803486 <smalloc+0x21>
  80347c:	b8 00 00 00 00       	mov    $0x0,%eax
  803481:	e9 84 05 00 00       	jmp    803a0a <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  803486:	83 ec 0c             	sub    $0xc,%esp
  803489:	68 20 f3 81 00       	push   $0x81f320
  80348e:	e8 d8 1b 00 00       	call   80506b <acquire_uspinlock>
  803493:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803496:	83 ec 0c             	sub    $0xc,%esp
  803499:	6a 10                	push   $0x10
  80349b:	e8 63 13 00 00       	call   804803 <alloc_block>
  8034a0:	83 c4 10             	add    $0x10,%esp
  8034a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  8034a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034aa:	75 0a                	jne    8034b6 <smalloc+0x51>
				return NULL;
  8034ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b1:	e9 54 05 00 00       	jmp    803a0a <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  8034b6:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8034bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c3:	01 d0                	add    %edx,%eax
  8034c5:	48                   	dec    %eax
  8034c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8034c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8034d1:	f7 75 e8             	divl   -0x18(%ebp)
  8034d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d7:	29 d0                	sub    %edx,%eax
  8034d9:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8034dc:	a1 04 f3 81 00       	mov    0x81f304,%eax
  8034e1:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8034e4:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8034e9:	85 c0                	test   %eax,%eax
  8034eb:	74 0f                	je     8034fc <smalloc+0x97>
  8034ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034f0:	8b 40 04             	mov    0x4(%eax),%eax
  8034f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034f6:	0f 83 25 01 00 00    	jae    803621 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8034fc:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  803501:	2b 45 0c             	sub    0xc(%ebp),%eax
  803504:	89 c2                	mov    %eax,%edx
  803506:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80350b:	39 c2                	cmp    %eax,%edx
  80350d:	0f 82 f4 00 00 00    	jb     803607 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  803513:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803518:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  80351b:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803521:	8b 45 0c             	mov    0xc(%ebp),%eax
  803524:	01 d0                	add    %edx,%eax
  803526:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  80352b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803531:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803536:	8b 55 0c             	mov    0xc(%ebp),%edx
  803539:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80353c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803540:	75 17                	jne    803559 <smalloc+0xf4>
  803542:	83 ec 04             	sub    $0x4,%esp
  803545:	68 58 60 80 00       	push   $0x806058
  80354a:	68 57 01 00 00       	push   $0x157
  80354f:	68 0c 60 80 00       	push   $0x80600c
  803554:	e8 97 df ff ff       	call   8014f0 <_panic>
  803559:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  80355f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803562:	89 50 0c             	mov    %edx,0xc(%eax)
  803565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803568:	8b 40 0c             	mov    0xc(%eax),%eax
  80356b:	85 c0                	test   %eax,%eax
  80356d:	74 0d                	je     80357c <smalloc+0x117>
  80356f:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803574:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803577:	89 50 08             	mov    %edx,0x8(%eax)
  80357a:	eb 08                	jmp    803584 <smalloc+0x11f>
  80357c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357f:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803587:	a3 14 f3 81 00       	mov    %eax,0x81f314
  80358c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803596:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  80359b:	40                   	inc    %eax
  80359c:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8035a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a4:	8b 00                	mov    (%eax),%eax
  8035a6:	89 c2                	mov    %eax,%edx
  8035a8:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8035ac:	52                   	push   %edx
  8035ad:	50                   	push   %eax
  8035ae:	ff 75 0c             	pushl  0xc(%ebp)
  8035b1:	ff 75 08             	pushl  0x8(%ebp)
  8035b4:	e8 48 0c 00 00       	call   804201 <sys_create_shared_object>
  8035b9:	83 c4 10             	add    $0x10,%esp
  8035bc:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  8035bf:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8035c3:	79 28                	jns    8035ed <smalloc+0x188>
							free_block(allocblock);
  8035c5:	83 ec 0c             	sub    $0xc,%esp
  8035c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8035cb:	e8 cf 16 00 00       	call   804c9f <free_block>
  8035d0:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8035d3:	83 ec 0c             	sub    $0xc,%esp
  8035d6:	68 20 f3 81 00       	push   $0x81f320
  8035db:	e8 e3 1a 00 00       	call   8050c3 <release_uspinlock>
  8035e0:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8035e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e8:	e9 1d 04 00 00       	jmp    803a0a <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  8035ed:	83 ec 0c             	sub    $0xc,%esp
  8035f0:	68 20 f3 81 00       	push   $0x81f320
  8035f5:	e8 c9 1a 00 00       	call   8050c3 <release_uspinlock>
  8035fa:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8035fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803600:	8b 00                	mov    (%eax),%eax
  803602:	e9 03 04 00 00       	jmp    803a0a <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  803607:	83 ec 0c             	sub    $0xc,%esp
  80360a:	68 20 f3 81 00       	push   $0x81f320
  80360f:	e8 af 1a 00 00       	call   8050c3 <release_uspinlock>
  803614:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803617:	b8 00 00 00 00       	mov    $0x0,%eax
  80361c:	e9 e9 03 00 00       	jmp    803a0a <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803621:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803626:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803629:	e9 af 03 00 00       	jmp    8039dd <smalloc+0x578>
				if(size<currentfreeelement->size){
  80362e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803631:	8b 40 04             	mov    0x4(%eax),%eax
  803634:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803637:	0f 86 28 02 00 00    	jbe    803865 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  80363d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803640:	8b 10                	mov    (%eax),%edx
  803642:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803645:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  803647:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80364a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80364d:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803650:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803654:	75 17                	jne    80366d <smalloc+0x208>
  803656:	83 ec 04             	sub    $0x4,%esp
  803659:	68 58 60 80 00       	push   $0x806058
  80365e:	68 6f 01 00 00       	push   $0x16f
  803663:	68 0c 60 80 00       	push   $0x80600c
  803668:	e8 83 de ff ff       	call   8014f0 <_panic>
  80366d:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803673:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803676:	89 50 0c             	mov    %edx,0xc(%eax)
  803679:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80367c:	8b 40 0c             	mov    0xc(%eax),%eax
  80367f:	85 c0                	test   %eax,%eax
  803681:	74 0d                	je     803690 <smalloc+0x22b>
  803683:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803688:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80368b:	89 50 08             	mov    %edx,0x8(%eax)
  80368e:	eb 08                	jmp    803698 <smalloc+0x233>
  803690:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803693:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803698:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80369b:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8036a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8036aa:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  8036af:	40                   	inc    %eax
  8036b0:	a3 1c f3 81 00       	mov    %eax,0x81f31c
	                lastfreeelement->startva += size;
  8036b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036b8:	8b 10                	mov    (%eax),%edx
  8036ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036bd:	01 c2                	add    %eax,%edx
  8036bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036c2:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  8036c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036c7:	8b 40 04             	mov    0x4(%eax),%eax
  8036ca:	2b 45 0c             	sub    0xc(%ebp),%eax
  8036cd:	89 c2                	mov    %eax,%edx
  8036cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d2:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8036d5:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8036da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  8036dd:	e9 13 01 00 00       	jmp    8037f5 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  8036e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036e5:	8b 50 04             	mov    0x4(%eax),%edx
  8036e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036eb:	8b 40 04             	mov    0x4(%eax),%eax
  8036ee:	39 c2                	cmp    %eax,%edx
  8036f0:	0f 83 f6 00 00 00    	jae    8037ec <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8036f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8036fa:	75 17                	jne    803713 <smalloc+0x2ae>
  8036fc:	83 ec 04             	sub    $0x4,%esp
  8036ff:	68 7b 60 80 00       	push   $0x80607b
  803704:	68 77 01 00 00       	push   $0x177
  803709:	68 0c 60 80 00       	push   $0x80600c
  80370e:	e8 dd dd ff ff       	call   8014f0 <_panic>
  803713:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803716:	8b 40 08             	mov    0x8(%eax),%eax
  803719:	85 c0                	test   %eax,%eax
  80371b:	74 11                	je     80372e <smalloc+0x2c9>
  80371d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803720:	8b 40 08             	mov    0x8(%eax),%eax
  803723:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803726:	8b 52 0c             	mov    0xc(%edx),%edx
  803729:	89 50 0c             	mov    %edx,0xc(%eax)
  80372c:	eb 0b                	jmp    803739 <smalloc+0x2d4>
  80372e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803731:	8b 40 0c             	mov    0xc(%eax),%eax
  803734:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803739:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80373c:	8b 40 0c             	mov    0xc(%eax),%eax
  80373f:	85 c0                	test   %eax,%eax
  803741:	74 11                	je     803754 <smalloc+0x2ef>
  803743:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803746:	8b 40 0c             	mov    0xc(%eax),%eax
  803749:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80374c:	8b 52 08             	mov    0x8(%edx),%edx
  80374f:	89 50 08             	mov    %edx,0x8(%eax)
  803752:	eb 0b                	jmp    80375f <smalloc+0x2fa>
  803754:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803757:	8b 40 08             	mov    0x8(%eax),%eax
  80375a:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80375f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803762:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80376c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803773:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803778:	48                   	dec    %eax
  803779:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80377e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803782:	74 06                	je     80378a <smalloc+0x325>
  803784:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803788:	75 17                	jne    8037a1 <smalloc+0x33c>
  80378a:	83 ec 04             	sub    $0x4,%esp
  80378d:	68 9c 60 80 00       	push   $0x80609c
  803792:	68 78 01 00 00       	push   $0x178
  803797:	68 0c 60 80 00       	push   $0x80600c
  80379c:	e8 4f dd ff ff       	call   8014f0 <_panic>
  8037a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a4:	8b 50 0c             	mov    0xc(%eax),%edx
  8037a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037aa:	89 50 0c             	mov    %edx,0xc(%eax)
  8037ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037b3:	89 50 08             	mov    %edx,0x8(%eax)
  8037b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8037bc:	85 c0                	test   %eax,%eax
  8037be:	74 0e                	je     8037ce <smalloc+0x369>
  8037c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037c9:	89 50 08             	mov    %edx,0x8(%eax)
  8037cc:	eb 08                	jmp    8037d6 <smalloc+0x371>
  8037ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d1:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8037d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037dc:	89 50 0c             	mov    %edx,0xc(%eax)
  8037df:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8037e4:	40                   	inc    %eax
  8037e5:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		break;
  8037ea:	eb 13                	jmp    8037ff <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  8037ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ef:	8b 40 08             	mov    0x8(%eax),%eax
  8037f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  8037f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037f9:	0f 85 e3 fe ff ff    	jne    8036e2 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8037ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803802:	8b 00                	mov    (%eax),%eax
  803804:	89 c2                	mov    %eax,%edx
  803806:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80380a:	52                   	push   %edx
  80380b:	50                   	push   %eax
  80380c:	ff 75 0c             	pushl  0xc(%ebp)
  80380f:	ff 75 08             	pushl  0x8(%ebp)
  803812:	e8 ea 09 00 00       	call   804201 <sys_create_shared_object>
  803817:	83 c4 10             	add    $0x10,%esp
  80381a:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  80381d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803821:	79 28                	jns    80384b <smalloc+0x3e6>
	                	free_block(allocblock);
  803823:	83 ec 0c             	sub    $0xc,%esp
  803826:	ff 75 ec             	pushl  -0x14(%ebp)
  803829:	e8 71 14 00 00       	call   804c9f <free_block>
  80382e:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  803831:	83 ec 0c             	sub    $0xc,%esp
  803834:	68 20 f3 81 00       	push   $0x81f320
  803839:	e8 85 18 00 00       	call   8050c3 <release_uspinlock>
  80383e:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  803841:	b8 00 00 00 00       	mov    $0x0,%eax
  803846:	e9 bf 01 00 00       	jmp    803a0a <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  80384b:	83 ec 0c             	sub    $0xc,%esp
  80384e:	68 20 f3 81 00       	push   $0x81f320
  803853:	e8 6b 18 00 00       	call   8050c3 <release_uspinlock>
  803858:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  80385b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385e:	8b 00                	mov    (%eax),%eax
  803860:	e9 a5 01 00 00       	jmp    803a0a <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  803865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803868:	8b 40 04             	mov    0x4(%eax),%eax
  80386b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80386e:	0f 85 60 01 00 00    	jne    8039d4 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  803874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803877:	8b 10                	mov    (%eax),%edx
  803879:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80387c:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80387e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803881:	8b 55 0c             	mov    0xc(%ebp),%edx
  803884:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803887:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80388b:	75 17                	jne    8038a4 <smalloc+0x43f>
  80388d:	83 ec 04             	sub    $0x4,%esp
  803890:	68 58 60 80 00       	push   $0x806058
  803895:	68 8c 01 00 00       	push   $0x18c
  80389a:	68 0c 60 80 00       	push   $0x80600c
  80389f:	e8 4c dc ff ff       	call   8014f0 <_panic>
  8038a4:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8038aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ad:	89 50 0c             	mov    %edx,0xc(%eax)
  8038b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b6:	85 c0                	test   %eax,%eax
  8038b8:	74 0d                	je     8038c7 <smalloc+0x462>
  8038ba:	a1 14 f3 81 00       	mov    0x81f314,%eax
  8038bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038c2:	89 50 08             	mov    %edx,0x8(%eax)
  8038c5:	eb 08                	jmp    8038cf <smalloc+0x46a>
  8038c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ca:	a3 10 f3 81 00       	mov    %eax,0x81f310
  8038cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038d2:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8038d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8038e1:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  8038e6:	40                   	inc    %eax
  8038e7:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8038ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f0:	75 17                	jne    803909 <smalloc+0x4a4>
  8038f2:	83 ec 04             	sub    $0x4,%esp
  8038f5:	68 7b 60 80 00       	push   $0x80607b
  8038fa:	68 8d 01 00 00       	push   $0x18d
  8038ff:	68 0c 60 80 00       	push   $0x80600c
  803904:	e8 e7 db ff ff       	call   8014f0 <_panic>
  803909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390c:	8b 40 08             	mov    0x8(%eax),%eax
  80390f:	85 c0                	test   %eax,%eax
  803911:	74 11                	je     803924 <smalloc+0x4bf>
  803913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803916:	8b 40 08             	mov    0x8(%eax),%eax
  803919:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80391c:	8b 52 0c             	mov    0xc(%edx),%edx
  80391f:	89 50 0c             	mov    %edx,0xc(%eax)
  803922:	eb 0b                	jmp    80392f <smalloc+0x4ca>
  803924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803927:	8b 40 0c             	mov    0xc(%eax),%eax
  80392a:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80392f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803932:	8b 40 0c             	mov    0xc(%eax),%eax
  803935:	85 c0                	test   %eax,%eax
  803937:	74 11                	je     80394a <smalloc+0x4e5>
  803939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393c:	8b 40 0c             	mov    0xc(%eax),%eax
  80393f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803942:	8b 52 08             	mov    0x8(%edx),%edx
  803945:	89 50 08             	mov    %edx,0x8(%eax)
  803948:	eb 0b                	jmp    803955 <smalloc+0x4f0>
  80394a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394d:	8b 40 08             	mov    0x8(%eax),%eax
  803950:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803958:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80395f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803962:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803969:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80396e:	48                   	dec    %eax
  80396f:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803977:	8b 00                	mov    (%eax),%eax
  803979:	89 c2                	mov    %eax,%edx
  80397b:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80397f:	52                   	push   %edx
  803980:	50                   	push   %eax
  803981:	ff 75 0c             	pushl  0xc(%ebp)
  803984:	ff 75 08             	pushl  0x8(%ebp)
  803987:	e8 75 08 00 00       	call   804201 <sys_create_shared_object>
  80398c:	83 c4 10             	add    $0x10,%esp
  80398f:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  803992:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803996:	79 25                	jns    8039bd <smalloc+0x558>
						free_block(allocblock);
  803998:	83 ec 0c             	sub    $0xc,%esp
  80399b:	ff 75 ec             	pushl  -0x14(%ebp)
  80399e:	e8 fc 12 00 00       	call   804c9f <free_block>
  8039a3:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8039a6:	83 ec 0c             	sub    $0xc,%esp
  8039a9:	68 20 f3 81 00       	push   $0x81f320
  8039ae:	e8 10 17 00 00       	call   8050c3 <release_uspinlock>
  8039b3:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8039b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bb:	eb 4d                	jmp    803a0a <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  8039bd:	83 ec 0c             	sub    $0xc,%esp
  8039c0:	68 20 f3 81 00       	push   $0x81f320
  8039c5:	e8 f9 16 00 00       	call   8050c3 <release_uspinlock>
  8039ca:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8039cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039d0:	8b 00                	mov    (%eax),%eax
  8039d2:	eb 36                	jmp    803a0a <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8039d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d7:	8b 40 08             	mov    0x8(%eax),%eax
  8039da:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8039dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039e1:	0f 85 47 fc ff ff    	jne    80362e <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8039e7:	83 ec 0c             	sub    $0xc,%esp
  8039ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8039ed:	e8 ad 12 00 00       	call   804c9f <free_block>
  8039f2:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8039f5:	83 ec 0c             	sub    $0xc,%esp
  8039f8:	68 20 f3 81 00       	push   $0x81f320
  8039fd:	e8 c1 16 00 00       	call   8050c3 <release_uspinlock>
  803a02:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a0a:	c9                   	leave  
  803a0b:	c3                   	ret    

00803a0c <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  803a0c:	55                   	push   %ebp
  803a0d:	89 e5                	mov    %esp,%ebp
  803a0f:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  803a12:	e8 8c ec ff ff       	call   8026a3 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  803a17:	83 ec 0c             	sub    $0xc,%esp
  803a1a:	68 20 f3 81 00       	push   $0x81f320
  803a1f:	e8 47 16 00 00       	call   80506b <acquire_uspinlock>
  803a24:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  803a27:	83 ec 08             	sub    $0x8,%esp
  803a2a:	ff 75 0c             	pushl  0xc(%ebp)
  803a2d:	ff 75 08             	pushl  0x8(%ebp)
  803a30:	e8 f6 07 00 00       	call   80422b <sys_size_of_shared_object>
  803a35:	83 c4 10             	add    $0x10,%esp
  803a38:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  803a3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a3f:	79 1a                	jns    803a5b <sget+0x4f>
			release_uspinlock(&ulock);
  803a41:	83 ec 0c             	sub    $0xc,%esp
  803a44:	68 20 f3 81 00       	push   $0x81f320
  803a49:	e8 75 16 00 00       	call   8050c3 <release_uspinlock>
  803a4e:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803a51:	b8 00 00 00 00       	mov    $0x0,%eax
  803a56:	e9 6e 05 00 00       	jmp    803fc9 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  803a5b:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803a62:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a68:	01 d0                	add    %edx,%eax
  803a6a:	48                   	dec    %eax
  803a6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803a6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a71:	ba 00 00 00 00       	mov    $0x0,%edx
  803a76:	f7 75 e8             	divl   -0x18(%ebp)
  803a79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7c:	29 d0                	sub    %edx,%eax
  803a7e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803a81:	83 ec 0c             	sub    $0xc,%esp
  803a84:	6a 10                	push   $0x10
  803a86:	e8 78 0d 00 00       	call   804803 <alloc_block>
  803a8b:	83 c4 10             	add    $0x10,%esp
  803a8e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  803a91:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803a95:	75 0a                	jne    803aa1 <sget+0x95>
			return NULL;
  803a97:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9c:	e9 28 05 00 00       	jmp    803fc9 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803aa1:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803aa6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  803aa9:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803aae:	85 c0                	test   %eax,%eax
  803ab0:	74 11                	je     803ac3 <sget+0xb7>
  803ab2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ab5:	8b 50 04             	mov    0x4(%eax),%edx
  803ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803abb:	39 c2                	cmp    %eax,%edx
  803abd:	0f 83 21 01 00 00    	jae    803be4 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  803ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac6:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  803acb:	29 c2                	sub    %eax,%edx
  803acd:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803ad2:	39 c2                	cmp    %eax,%edx
  803ad4:	0f 82 f0 00 00 00    	jb     803bca <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  803ada:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803adf:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  803ae2:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aeb:	01 d0                	add    %edx,%eax
  803aed:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  803af2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803af5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803af8:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803afa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803afd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b00:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  803b03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803b07:	75 17                	jne    803b20 <sget+0x114>
  803b09:	83 ec 04             	sub    $0x4,%esp
  803b0c:	68 58 60 80 00       	push   $0x806058
  803b11:	68 c8 01 00 00       	push   $0x1c8
  803b16:	68 0c 60 80 00       	push   $0x80600c
  803b1b:	e8 d0 d9 ff ff       	call   8014f0 <_panic>
  803b20:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b29:	89 50 0c             	mov    %edx,0xc(%eax)
  803b2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b2f:	8b 40 0c             	mov    0xc(%eax),%eax
  803b32:	85 c0                	test   %eax,%eax
  803b34:	74 0d                	je     803b43 <sget+0x137>
  803b36:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803b3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b3e:	89 50 08             	mov    %edx,0x8(%eax)
  803b41:	eb 08                	jmp    803b4b <sget+0x13f>
  803b43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b46:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b4e:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803b53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803b5d:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803b62:	40                   	inc    %eax
  803b63:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803b68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b6b:	8b 00                	mov    (%eax),%eax
  803b6d:	83 ec 04             	sub    $0x4,%esp
  803b70:	50                   	push   %eax
  803b71:	ff 75 0c             	pushl  0xc(%ebp)
  803b74:	ff 75 08             	pushl  0x8(%ebp)
  803b77:	e8 cc 06 00 00       	call   804248 <sys_get_shared_object>
  803b7c:	83 c4 10             	add    $0x10,%esp
  803b7f:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  803b82:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803b86:	79 28                	jns    803bb0 <sget+0x1a4>
							free_block(allocblock);
  803b88:	83 ec 0c             	sub    $0xc,%esp
  803b8b:	ff 75 e0             	pushl  -0x20(%ebp)
  803b8e:	e8 0c 11 00 00       	call   804c9f <free_block>
  803b93:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803b96:	83 ec 0c             	sub    $0xc,%esp
  803b99:	68 20 f3 81 00       	push   $0x81f320
  803b9e:	e8 20 15 00 00       	call   8050c3 <release_uspinlock>
  803ba3:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  803bab:	e9 19 04 00 00       	jmp    803fc9 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  803bb0:	83 ec 0c             	sub    $0xc,%esp
  803bb3:	68 20 f3 81 00       	push   $0x81f320
  803bb8:	e8 06 15 00 00       	call   8050c3 <release_uspinlock>
  803bbd:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803bc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bc3:	8b 00                	mov    (%eax),%eax
  803bc5:	e9 ff 03 00 00       	jmp    803fc9 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  803bca:	83 ec 0c             	sub    $0xc,%esp
  803bcd:	68 20 f3 81 00       	push   $0x81f320
  803bd2:	e8 ec 14 00 00       	call   8050c3 <release_uspinlock>
  803bd7:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803bda:	b8 00 00 00 00       	mov    $0x0,%eax
  803bdf:	e9 e5 03 00 00       	jmp    803fc9 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803be4:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803bec:	e9 ab 03 00 00       	jmp    803f9c <sget+0x590>
				if(size<currentfreeelement->size){
  803bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf4:	8b 50 04             	mov    0x4(%eax),%edx
  803bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bfa:	39 c2                	cmp    %eax,%edx
  803bfc:	0f 86 24 02 00 00    	jbe    803e26 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  803c02:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c05:	8b 10                	mov    (%eax),%edx
  803c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c0a:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803c0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c12:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803c15:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c19:	75 17                	jne    803c32 <sget+0x226>
  803c1b:	83 ec 04             	sub    $0x4,%esp
  803c1e:	68 58 60 80 00       	push   $0x806058
  803c23:	68 e0 01 00 00       	push   $0x1e0
  803c28:	68 0c 60 80 00       	push   $0x80600c
  803c2d:	e8 be d8 ff ff       	call   8014f0 <_panic>
  803c32:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803c38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c3b:	89 50 0c             	mov    %edx,0xc(%eax)
  803c3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c41:	8b 40 0c             	mov    0xc(%eax),%eax
  803c44:	85 c0                	test   %eax,%eax
  803c46:	74 0d                	je     803c55 <sget+0x249>
  803c48:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803c4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c50:	89 50 08             	mov    %edx,0x8(%eax)
  803c53:	eb 08                	jmp    803c5d <sget+0x251>
  803c55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c58:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803c5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c60:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803c65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803c6f:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803c74:	40                   	inc    %eax
  803c75:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					lastfreeelement->startva += size;
  803c7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c7d:	8b 10                	mov    (%eax),%edx
  803c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c82:	01 c2                	add    %eax,%edx
  803c84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c87:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  803c89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c8c:	8b 50 04             	mov    0x4(%eax),%edx
  803c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c92:	29 c2                	sub    %eax,%edx
  803c94:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c97:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803c9a:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  803ca2:	e9 13 01 00 00       	jmp    803dba <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  803ca7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803caa:	8b 50 04             	mov    0x4(%eax),%edx
  803cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb0:	8b 40 04             	mov    0x4(%eax),%eax
  803cb3:	39 c2                	cmp    %eax,%edx
  803cb5:	0f 83 f6 00 00 00    	jae    803db1 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  803cbb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803cbf:	75 17                	jne    803cd8 <sget+0x2cc>
  803cc1:	83 ec 04             	sub    $0x4,%esp
  803cc4:	68 7b 60 80 00       	push   $0x80607b
  803cc9:	68 e8 01 00 00       	push   $0x1e8
  803cce:	68 0c 60 80 00       	push   $0x80600c
  803cd3:	e8 18 d8 ff ff       	call   8014f0 <_panic>
  803cd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cdb:	8b 40 08             	mov    0x8(%eax),%eax
  803cde:	85 c0                	test   %eax,%eax
  803ce0:	74 11                	je     803cf3 <sget+0x2e7>
  803ce2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ce5:	8b 40 08             	mov    0x8(%eax),%eax
  803ce8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ceb:	8b 52 0c             	mov    0xc(%edx),%edx
  803cee:	89 50 0c             	mov    %edx,0xc(%eax)
  803cf1:	eb 0b                	jmp    803cfe <sget+0x2f2>
  803cf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  803cf9:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803cfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d01:	8b 40 0c             	mov    0xc(%eax),%eax
  803d04:	85 c0                	test   %eax,%eax
  803d06:	74 11                	je     803d19 <sget+0x30d>
  803d08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d0b:	8b 40 0c             	mov    0xc(%eax),%eax
  803d0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d11:	8b 52 08             	mov    0x8(%edx),%edx
  803d14:	89 50 08             	mov    %edx,0x8(%eax)
  803d17:	eb 0b                	jmp    803d24 <sget+0x318>
  803d19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d1c:	8b 40 08             	mov    0x8(%eax),%eax
  803d1f:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803d24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803d2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d31:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803d38:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803d3d:	48                   	dec    %eax
  803d3e:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803d43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d47:	74 06                	je     803d4f <sget+0x343>
  803d49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d4d:	75 17                	jne    803d66 <sget+0x35a>
  803d4f:	83 ec 04             	sub    $0x4,%esp
  803d52:	68 9c 60 80 00       	push   $0x80609c
  803d57:	68 e9 01 00 00       	push   $0x1e9
  803d5c:	68 0c 60 80 00       	push   $0x80600c
  803d61:	e8 8a d7 ff ff       	call   8014f0 <_panic>
  803d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d69:	8b 50 0c             	mov    0xc(%eax),%edx
  803d6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d6f:	89 50 0c             	mov    %edx,0xc(%eax)
  803d72:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d78:	89 50 08             	mov    %edx,0x8(%eax)
  803d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d7e:	8b 40 0c             	mov    0xc(%eax),%eax
  803d81:	85 c0                	test   %eax,%eax
  803d83:	74 0e                	je     803d93 <sget+0x387>
  803d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d88:	8b 40 0c             	mov    0xc(%eax),%eax
  803d8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d8e:	89 50 08             	mov    %edx,0x8(%eax)
  803d91:	eb 08                	jmp    803d9b <sget+0x38f>
  803d93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d96:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803da1:	89 50 0c             	mov    %edx,0xc(%eax)
  803da4:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803da9:	40                   	inc    %eax
  803daa:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							break;
  803daf:	eb 13                	jmp    803dc4 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  803db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db4:	8b 40 08             	mov    0x8(%eax),%eax
  803db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  803dba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803dbe:	0f 85 e3 fe ff ff    	jne    803ca7 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803dc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dc7:	8b 00                	mov    (%eax),%eax
  803dc9:	83 ec 04             	sub    $0x4,%esp
  803dcc:	50                   	push   %eax
  803dcd:	ff 75 0c             	pushl  0xc(%ebp)
  803dd0:	ff 75 08             	pushl  0x8(%ebp)
  803dd3:	e8 70 04 00 00       	call   804248 <sys_get_shared_object>
  803dd8:	83 c4 10             	add    $0x10,%esp
  803ddb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  803dde:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803de2:	79 28                	jns    803e0c <sget+0x400>
						free_block(allocblock);
  803de4:	83 ec 0c             	sub    $0xc,%esp
  803de7:	ff 75 e0             	pushl  -0x20(%ebp)
  803dea:	e8 b0 0e 00 00       	call   804c9f <free_block>
  803def:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803df2:	83 ec 0c             	sub    $0xc,%esp
  803df5:	68 20 f3 81 00       	push   $0x81f320
  803dfa:	e8 c4 12 00 00       	call   8050c3 <release_uspinlock>
  803dff:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803e02:	b8 00 00 00 00       	mov    $0x0,%eax
  803e07:	e9 bd 01 00 00       	jmp    803fc9 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  803e0c:	83 ec 0c             	sub    $0xc,%esp
  803e0f:	68 20 f3 81 00       	push   $0x81f320
  803e14:	e8 aa 12 00 00       	call   8050c3 <release_uspinlock>
  803e19:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803e1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e1f:	8b 00                	mov    (%eax),%eax
  803e21:	e9 a3 01 00 00       	jmp    803fc9 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  803e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e29:	8b 50 04             	mov    0x4(%eax),%edx
  803e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e2f:	39 c2                	cmp    %eax,%edx
  803e31:	0f 85 5c 01 00 00    	jne    803f93 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  803e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3a:	8b 10                	mov    (%eax),%edx
  803e3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e3f:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803e41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e47:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803e4a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803e4e:	75 17                	jne    803e67 <sget+0x45b>
  803e50:	83 ec 04             	sub    $0x4,%esp
  803e53:	68 58 60 80 00       	push   $0x806058
  803e58:	68 fe 01 00 00       	push   $0x1fe
  803e5d:	68 0c 60 80 00       	push   $0x80600c
  803e62:	e8 89 d6 ff ff       	call   8014f0 <_panic>
  803e67:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e70:	89 50 0c             	mov    %edx,0xc(%eax)
  803e73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e76:	8b 40 0c             	mov    0xc(%eax),%eax
  803e79:	85 c0                	test   %eax,%eax
  803e7b:	74 0d                	je     803e8a <sget+0x47e>
  803e7d:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803e82:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e85:	89 50 08             	mov    %edx,0x8(%eax)
  803e88:	eb 08                	jmp    803e92 <sget+0x486>
  803e8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e8d:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803e92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e95:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803e9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e9d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803ea4:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803ea9:	40                   	inc    %eax
  803eaa:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eb3:	75 17                	jne    803ecc <sget+0x4c0>
  803eb5:	83 ec 04             	sub    $0x4,%esp
  803eb8:	68 7b 60 80 00       	push   $0x80607b
  803ebd:	68 ff 01 00 00       	push   $0x1ff
  803ec2:	68 0c 60 80 00       	push   $0x80600c
  803ec7:	e8 24 d6 ff ff       	call   8014f0 <_panic>
  803ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ecf:	8b 40 08             	mov    0x8(%eax),%eax
  803ed2:	85 c0                	test   %eax,%eax
  803ed4:	74 11                	je     803ee7 <sget+0x4db>
  803ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed9:	8b 40 08             	mov    0x8(%eax),%eax
  803edc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803edf:	8b 52 0c             	mov    0xc(%edx),%edx
  803ee2:	89 50 0c             	mov    %edx,0xc(%eax)
  803ee5:	eb 0b                	jmp    803ef2 <sget+0x4e6>
  803ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eea:	8b 40 0c             	mov    0xc(%eax),%eax
  803eed:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef5:	8b 40 0c             	mov    0xc(%eax),%eax
  803ef8:	85 c0                	test   %eax,%eax
  803efa:	74 11                	je     803f0d <sget+0x501>
  803efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eff:	8b 40 0c             	mov    0xc(%eax),%eax
  803f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f05:	8b 52 08             	mov    0x8(%edx),%edx
  803f08:	89 50 08             	mov    %edx,0x8(%eax)
  803f0b:	eb 0b                	jmp    803f18 <sget+0x50c>
  803f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f10:	8b 40 08             	mov    0x8(%eax),%eax
  803f13:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f25:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803f2c:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803f31:	48                   	dec    %eax
  803f32:	a3 0c f3 81 00       	mov    %eax,0x81f30c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803f37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f3a:	8b 00                	mov    (%eax),%eax
  803f3c:	83 ec 04             	sub    $0x4,%esp
  803f3f:	50                   	push   %eax
  803f40:	ff 75 0c             	pushl  0xc(%ebp)
  803f43:	ff 75 08             	pushl  0x8(%ebp)
  803f46:	e8 fd 02 00 00       	call   804248 <sys_get_shared_object>
  803f4b:	83 c4 10             	add    $0x10,%esp
  803f4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803f51:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803f55:	79 25                	jns    803f7c <sget+0x570>
						free_block(allocblock);
  803f57:	83 ec 0c             	sub    $0xc,%esp
  803f5a:	ff 75 e0             	pushl  -0x20(%ebp)
  803f5d:	e8 3d 0d 00 00       	call   804c9f <free_block>
  803f62:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803f65:	83 ec 0c             	sub    $0xc,%esp
  803f68:	68 20 f3 81 00       	push   $0x81f320
  803f6d:	e8 51 11 00 00       	call   8050c3 <release_uspinlock>
  803f72:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803f75:	b8 00 00 00 00       	mov    $0x0,%eax
  803f7a:	eb 4d                	jmp    803fc9 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  803f7c:	83 ec 0c             	sub    $0xc,%esp
  803f7f:	68 20 f3 81 00       	push   $0x81f320
  803f84:	e8 3a 11 00 00       	call   8050c3 <release_uspinlock>
  803f89:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803f8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f8f:	8b 00                	mov    (%eax),%eax
  803f91:	eb 36                	jmp    803fc9 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f96:	8b 40 08             	mov    0x8(%eax),%eax
  803f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803f9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fa0:	0f 85 4b fc ff ff    	jne    803bf1 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  803fa6:	83 ec 0c             	sub    $0xc,%esp
  803fa9:	ff 75 e0             	pushl  -0x20(%ebp)
  803fac:	e8 ee 0c 00 00       	call   804c9f <free_block>
  803fb1:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803fb4:	83 ec 0c             	sub    $0xc,%esp
  803fb7:	68 20 f3 81 00       	push   $0x81f320
  803fbc:	e8 02 11 00 00       	call   8050c3 <release_uspinlock>
  803fc1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803fc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fc9:	c9                   	leave  
  803fca:	c3                   	ret    

00803fcb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803fcb:	55                   	push   %ebp
  803fcc:	89 e5                	mov    %esp,%ebp
  803fce:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803fd1:	e8 cd e6 ff ff       	call   8026a3 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803fd6:	83 ec 04             	sub    $0x4,%esp
  803fd9:	68 2c 61 80 00       	push   $0x80612c
  803fde:	68 2d 02 00 00       	push   $0x22d
  803fe3:	68 0c 60 80 00       	push   $0x80600c
  803fe8:	e8 03 d5 ff ff       	call   8014f0 <_panic>

00803fed <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803fed:	55                   	push   %ebp
  803fee:	89 e5                	mov    %esp,%ebp
  803ff0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803ff3:	83 ec 04             	sub    $0x4,%esp
  803ff6:	68 54 61 80 00       	push   $0x806154
  803ffb:	68 40 02 00 00       	push   $0x240
  804000:	68 0c 60 80 00       	push   $0x80600c
  804005:	e8 e6 d4 ff ff       	call   8014f0 <_panic>

0080400a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80400a:	55                   	push   %ebp
  80400b:	89 e5                	mov    %esp,%ebp
  80400d:	57                   	push   %edi
  80400e:	56                   	push   %esi
  80400f:	53                   	push   %ebx
  804010:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  804013:	8b 45 08             	mov    0x8(%ebp),%eax
  804016:	8b 55 0c             	mov    0xc(%ebp),%edx
  804019:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80401c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80401f:	8b 7d 18             	mov    0x18(%ebp),%edi
  804022:	8b 75 1c             	mov    0x1c(%ebp),%esi
  804025:	cd 30                	int    $0x30
  804027:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80402a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80402d:	83 c4 10             	add    $0x10,%esp
  804030:	5b                   	pop    %ebx
  804031:	5e                   	pop    %esi
  804032:	5f                   	pop    %edi
  804033:	5d                   	pop    %ebp
  804034:	c3                   	ret    

00804035 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  804035:	55                   	push   %ebp
  804036:	89 e5                	mov    %esp,%ebp
  804038:	83 ec 04             	sub    $0x4,%esp
  80403b:	8b 45 10             	mov    0x10(%ebp),%eax
  80403e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  804041:	8b 4d 14             	mov    0x14(%ebp),%ecx
  804044:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  804048:	8b 45 08             	mov    0x8(%ebp),%eax
  80404b:	6a 00                	push   $0x0
  80404d:	51                   	push   %ecx
  80404e:	52                   	push   %edx
  80404f:	ff 75 0c             	pushl  0xc(%ebp)
  804052:	50                   	push   %eax
  804053:	6a 00                	push   $0x0
  804055:	e8 b0 ff ff ff       	call   80400a <syscall>
  80405a:	83 c4 18             	add    $0x18,%esp
}
  80405d:	90                   	nop
  80405e:	c9                   	leave  
  80405f:	c3                   	ret    

00804060 <sys_cgetc>:

int
sys_cgetc(void)
{
  804060:	55                   	push   %ebp
  804061:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  804063:	6a 00                	push   $0x0
  804065:	6a 00                	push   $0x0
  804067:	6a 00                	push   $0x0
  804069:	6a 00                	push   $0x0
  80406b:	6a 00                	push   $0x0
  80406d:	6a 02                	push   $0x2
  80406f:	e8 96 ff ff ff       	call   80400a <syscall>
  804074:	83 c4 18             	add    $0x18,%esp
}
  804077:	c9                   	leave  
  804078:	c3                   	ret    

00804079 <sys_lock_cons>:

void sys_lock_cons(void)
{
  804079:	55                   	push   %ebp
  80407a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80407c:	6a 00                	push   $0x0
  80407e:	6a 00                	push   $0x0
  804080:	6a 00                	push   $0x0
  804082:	6a 00                	push   $0x0
  804084:	6a 00                	push   $0x0
  804086:	6a 03                	push   $0x3
  804088:	e8 7d ff ff ff       	call   80400a <syscall>
  80408d:	83 c4 18             	add    $0x18,%esp
}
  804090:	90                   	nop
  804091:	c9                   	leave  
  804092:	c3                   	ret    

00804093 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  804093:	55                   	push   %ebp
  804094:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  804096:	6a 00                	push   $0x0
  804098:	6a 00                	push   $0x0
  80409a:	6a 00                	push   $0x0
  80409c:	6a 00                	push   $0x0
  80409e:	6a 00                	push   $0x0
  8040a0:	6a 04                	push   $0x4
  8040a2:	e8 63 ff ff ff       	call   80400a <syscall>
  8040a7:	83 c4 18             	add    $0x18,%esp
}
  8040aa:	90                   	nop
  8040ab:	c9                   	leave  
  8040ac:	c3                   	ret    

008040ad <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8040ad:	55                   	push   %ebp
  8040ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8040b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8040b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b6:	6a 00                	push   $0x0
  8040b8:	6a 00                	push   $0x0
  8040ba:	6a 00                	push   $0x0
  8040bc:	52                   	push   %edx
  8040bd:	50                   	push   %eax
  8040be:	6a 08                	push   $0x8
  8040c0:	e8 45 ff ff ff       	call   80400a <syscall>
  8040c5:	83 c4 18             	add    $0x18,%esp
}
  8040c8:	c9                   	leave  
  8040c9:	c3                   	ret    

008040ca <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8040ca:	55                   	push   %ebp
  8040cb:	89 e5                	mov    %esp,%ebp
  8040cd:	56                   	push   %esi
  8040ce:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8040cf:	8b 75 18             	mov    0x18(%ebp),%esi
  8040d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8040d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8040d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8040db:	8b 45 08             	mov    0x8(%ebp),%eax
  8040de:	56                   	push   %esi
  8040df:	53                   	push   %ebx
  8040e0:	51                   	push   %ecx
  8040e1:	52                   	push   %edx
  8040e2:	50                   	push   %eax
  8040e3:	6a 09                	push   $0x9
  8040e5:	e8 20 ff ff ff       	call   80400a <syscall>
  8040ea:	83 c4 18             	add    $0x18,%esp
}
  8040ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8040f0:	5b                   	pop    %ebx
  8040f1:	5e                   	pop    %esi
  8040f2:	5d                   	pop    %ebp
  8040f3:	c3                   	ret    

008040f4 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8040f4:	55                   	push   %ebp
  8040f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8040f7:	6a 00                	push   $0x0
  8040f9:	6a 00                	push   $0x0
  8040fb:	6a 00                	push   $0x0
  8040fd:	6a 00                	push   $0x0
  8040ff:	ff 75 08             	pushl  0x8(%ebp)
  804102:	6a 0a                	push   $0xa
  804104:	e8 01 ff ff ff       	call   80400a <syscall>
  804109:	83 c4 18             	add    $0x18,%esp
}
  80410c:	c9                   	leave  
  80410d:	c3                   	ret    

0080410e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80410e:	55                   	push   %ebp
  80410f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  804111:	6a 00                	push   $0x0
  804113:	6a 00                	push   $0x0
  804115:	6a 00                	push   $0x0
  804117:	ff 75 0c             	pushl  0xc(%ebp)
  80411a:	ff 75 08             	pushl  0x8(%ebp)
  80411d:	6a 0b                	push   $0xb
  80411f:	e8 e6 fe ff ff       	call   80400a <syscall>
  804124:	83 c4 18             	add    $0x18,%esp
}
  804127:	c9                   	leave  
  804128:	c3                   	ret    

00804129 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  804129:	55                   	push   %ebp
  80412a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80412c:	6a 00                	push   $0x0
  80412e:	6a 00                	push   $0x0
  804130:	6a 00                	push   $0x0
  804132:	6a 00                	push   $0x0
  804134:	6a 00                	push   $0x0
  804136:	6a 0c                	push   $0xc
  804138:	e8 cd fe ff ff       	call   80400a <syscall>
  80413d:	83 c4 18             	add    $0x18,%esp
}
  804140:	c9                   	leave  
  804141:	c3                   	ret    

00804142 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  804142:	55                   	push   %ebp
  804143:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  804145:	6a 00                	push   $0x0
  804147:	6a 00                	push   $0x0
  804149:	6a 00                	push   $0x0
  80414b:	6a 00                	push   $0x0
  80414d:	6a 00                	push   $0x0
  80414f:	6a 0d                	push   $0xd
  804151:	e8 b4 fe ff ff       	call   80400a <syscall>
  804156:	83 c4 18             	add    $0x18,%esp
}
  804159:	c9                   	leave  
  80415a:	c3                   	ret    

0080415b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80415b:	55                   	push   %ebp
  80415c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80415e:	6a 00                	push   $0x0
  804160:	6a 00                	push   $0x0
  804162:	6a 00                	push   $0x0
  804164:	6a 00                	push   $0x0
  804166:	6a 00                	push   $0x0
  804168:	6a 0e                	push   $0xe
  80416a:	e8 9b fe ff ff       	call   80400a <syscall>
  80416f:	83 c4 18             	add    $0x18,%esp
}
  804172:	c9                   	leave  
  804173:	c3                   	ret    

00804174 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  804174:	55                   	push   %ebp
  804175:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  804177:	6a 00                	push   $0x0
  804179:	6a 00                	push   $0x0
  80417b:	6a 00                	push   $0x0
  80417d:	6a 00                	push   $0x0
  80417f:	6a 00                	push   $0x0
  804181:	6a 0f                	push   $0xf
  804183:	e8 82 fe ff ff       	call   80400a <syscall>
  804188:	83 c4 18             	add    $0x18,%esp
}
  80418b:	c9                   	leave  
  80418c:	c3                   	ret    

0080418d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80418d:	55                   	push   %ebp
  80418e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  804190:	6a 00                	push   $0x0
  804192:	6a 00                	push   $0x0
  804194:	6a 00                	push   $0x0
  804196:	6a 00                	push   $0x0
  804198:	ff 75 08             	pushl  0x8(%ebp)
  80419b:	6a 10                	push   $0x10
  80419d:	e8 68 fe ff ff       	call   80400a <syscall>
  8041a2:	83 c4 18             	add    $0x18,%esp
}
  8041a5:	c9                   	leave  
  8041a6:	c3                   	ret    

008041a7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8041a7:	55                   	push   %ebp
  8041a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8041aa:	6a 00                	push   $0x0
  8041ac:	6a 00                	push   $0x0
  8041ae:	6a 00                	push   $0x0
  8041b0:	6a 00                	push   $0x0
  8041b2:	6a 00                	push   $0x0
  8041b4:	6a 11                	push   $0x11
  8041b6:	e8 4f fe ff ff       	call   80400a <syscall>
  8041bb:	83 c4 18             	add    $0x18,%esp
}
  8041be:	90                   	nop
  8041bf:	c9                   	leave  
  8041c0:	c3                   	ret    

008041c1 <sys_cputc>:

void
sys_cputc(const char c)
{
  8041c1:	55                   	push   %ebp
  8041c2:	89 e5                	mov    %esp,%ebp
  8041c4:	83 ec 04             	sub    $0x4,%esp
  8041c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8041cd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8041d1:	6a 00                	push   $0x0
  8041d3:	6a 00                	push   $0x0
  8041d5:	6a 00                	push   $0x0
  8041d7:	6a 00                	push   $0x0
  8041d9:	50                   	push   %eax
  8041da:	6a 01                	push   $0x1
  8041dc:	e8 29 fe ff ff       	call   80400a <syscall>
  8041e1:	83 c4 18             	add    $0x18,%esp
}
  8041e4:	90                   	nop
  8041e5:	c9                   	leave  
  8041e6:	c3                   	ret    

008041e7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8041e7:	55                   	push   %ebp
  8041e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8041ea:	6a 00                	push   $0x0
  8041ec:	6a 00                	push   $0x0
  8041ee:	6a 00                	push   $0x0
  8041f0:	6a 00                	push   $0x0
  8041f2:	6a 00                	push   $0x0
  8041f4:	6a 14                	push   $0x14
  8041f6:	e8 0f fe ff ff       	call   80400a <syscall>
  8041fb:	83 c4 18             	add    $0x18,%esp
}
  8041fe:	90                   	nop
  8041ff:	c9                   	leave  
  804200:	c3                   	ret    

00804201 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  804201:	55                   	push   %ebp
  804202:	89 e5                	mov    %esp,%ebp
  804204:	83 ec 04             	sub    $0x4,%esp
  804207:	8b 45 10             	mov    0x10(%ebp),%eax
  80420a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80420d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  804210:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  804214:	8b 45 08             	mov    0x8(%ebp),%eax
  804217:	6a 00                	push   $0x0
  804219:	51                   	push   %ecx
  80421a:	52                   	push   %edx
  80421b:	ff 75 0c             	pushl  0xc(%ebp)
  80421e:	50                   	push   %eax
  80421f:	6a 15                	push   $0x15
  804221:	e8 e4 fd ff ff       	call   80400a <syscall>
  804226:	83 c4 18             	add    $0x18,%esp
}
  804229:	c9                   	leave  
  80422a:	c3                   	ret    

0080422b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80422b:	55                   	push   %ebp
  80422c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80422e:	8b 55 0c             	mov    0xc(%ebp),%edx
  804231:	8b 45 08             	mov    0x8(%ebp),%eax
  804234:	6a 00                	push   $0x0
  804236:	6a 00                	push   $0x0
  804238:	6a 00                	push   $0x0
  80423a:	52                   	push   %edx
  80423b:	50                   	push   %eax
  80423c:	6a 16                	push   $0x16
  80423e:	e8 c7 fd ff ff       	call   80400a <syscall>
  804243:	83 c4 18             	add    $0x18,%esp
}
  804246:	c9                   	leave  
  804247:	c3                   	ret    

00804248 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  804248:	55                   	push   %ebp
  804249:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80424b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80424e:	8b 55 0c             	mov    0xc(%ebp),%edx
  804251:	8b 45 08             	mov    0x8(%ebp),%eax
  804254:	6a 00                	push   $0x0
  804256:	6a 00                	push   $0x0
  804258:	51                   	push   %ecx
  804259:	52                   	push   %edx
  80425a:	50                   	push   %eax
  80425b:	6a 17                	push   $0x17
  80425d:	e8 a8 fd ff ff       	call   80400a <syscall>
  804262:	83 c4 18             	add    $0x18,%esp
}
  804265:	c9                   	leave  
  804266:	c3                   	ret    

00804267 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  804267:	55                   	push   %ebp
  804268:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80426a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80426d:	8b 45 08             	mov    0x8(%ebp),%eax
  804270:	6a 00                	push   $0x0
  804272:	6a 00                	push   $0x0
  804274:	6a 00                	push   $0x0
  804276:	52                   	push   %edx
  804277:	50                   	push   %eax
  804278:	6a 18                	push   $0x18
  80427a:	e8 8b fd ff ff       	call   80400a <syscall>
  80427f:	83 c4 18             	add    $0x18,%esp
}
  804282:	c9                   	leave  
  804283:	c3                   	ret    

00804284 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  804284:	55                   	push   %ebp
  804285:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  804287:	8b 45 08             	mov    0x8(%ebp),%eax
  80428a:	6a 00                	push   $0x0
  80428c:	ff 75 14             	pushl  0x14(%ebp)
  80428f:	ff 75 10             	pushl  0x10(%ebp)
  804292:	ff 75 0c             	pushl  0xc(%ebp)
  804295:	50                   	push   %eax
  804296:	6a 19                	push   $0x19
  804298:	e8 6d fd ff ff       	call   80400a <syscall>
  80429d:	83 c4 18             	add    $0x18,%esp
}
  8042a0:	c9                   	leave  
  8042a1:	c3                   	ret    

008042a2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8042a2:	55                   	push   %ebp
  8042a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8042a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8042a8:	6a 00                	push   $0x0
  8042aa:	6a 00                	push   $0x0
  8042ac:	6a 00                	push   $0x0
  8042ae:	6a 00                	push   $0x0
  8042b0:	50                   	push   %eax
  8042b1:	6a 1a                	push   $0x1a
  8042b3:	e8 52 fd ff ff       	call   80400a <syscall>
  8042b8:	83 c4 18             	add    $0x18,%esp
}
  8042bb:	90                   	nop
  8042bc:	c9                   	leave  
  8042bd:	c3                   	ret    

008042be <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8042be:	55                   	push   %ebp
  8042bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8042c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8042c4:	6a 00                	push   $0x0
  8042c6:	6a 00                	push   $0x0
  8042c8:	6a 00                	push   $0x0
  8042ca:	6a 00                	push   $0x0
  8042cc:	50                   	push   %eax
  8042cd:	6a 1b                	push   $0x1b
  8042cf:	e8 36 fd ff ff       	call   80400a <syscall>
  8042d4:	83 c4 18             	add    $0x18,%esp
}
  8042d7:	c9                   	leave  
  8042d8:	c3                   	ret    

008042d9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8042d9:	55                   	push   %ebp
  8042da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8042dc:	6a 00                	push   $0x0
  8042de:	6a 00                	push   $0x0
  8042e0:	6a 00                	push   $0x0
  8042e2:	6a 00                	push   $0x0
  8042e4:	6a 00                	push   $0x0
  8042e6:	6a 05                	push   $0x5
  8042e8:	e8 1d fd ff ff       	call   80400a <syscall>
  8042ed:	83 c4 18             	add    $0x18,%esp
}
  8042f0:	c9                   	leave  
  8042f1:	c3                   	ret    

008042f2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8042f2:	55                   	push   %ebp
  8042f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8042f5:	6a 00                	push   $0x0
  8042f7:	6a 00                	push   $0x0
  8042f9:	6a 00                	push   $0x0
  8042fb:	6a 00                	push   $0x0
  8042fd:	6a 00                	push   $0x0
  8042ff:	6a 06                	push   $0x6
  804301:	e8 04 fd ff ff       	call   80400a <syscall>
  804306:	83 c4 18             	add    $0x18,%esp
}
  804309:	c9                   	leave  
  80430a:	c3                   	ret    

0080430b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80430b:	55                   	push   %ebp
  80430c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80430e:	6a 00                	push   $0x0
  804310:	6a 00                	push   $0x0
  804312:	6a 00                	push   $0x0
  804314:	6a 00                	push   $0x0
  804316:	6a 00                	push   $0x0
  804318:	6a 07                	push   $0x7
  80431a:	e8 eb fc ff ff       	call   80400a <syscall>
  80431f:	83 c4 18             	add    $0x18,%esp
}
  804322:	c9                   	leave  
  804323:	c3                   	ret    

00804324 <sys_exit_env>:


void sys_exit_env(void)
{
  804324:	55                   	push   %ebp
  804325:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  804327:	6a 00                	push   $0x0
  804329:	6a 00                	push   $0x0
  80432b:	6a 00                	push   $0x0
  80432d:	6a 00                	push   $0x0
  80432f:	6a 00                	push   $0x0
  804331:	6a 1c                	push   $0x1c
  804333:	e8 d2 fc ff ff       	call   80400a <syscall>
  804338:	83 c4 18             	add    $0x18,%esp
}
  80433b:	90                   	nop
  80433c:	c9                   	leave  
  80433d:	c3                   	ret    

0080433e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80433e:	55                   	push   %ebp
  80433f:	89 e5                	mov    %esp,%ebp
  804341:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  804344:	8d 45 f8             	lea    -0x8(%ebp),%eax
  804347:	8d 50 04             	lea    0x4(%eax),%edx
  80434a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80434d:	6a 00                	push   $0x0
  80434f:	6a 00                	push   $0x0
  804351:	6a 00                	push   $0x0
  804353:	52                   	push   %edx
  804354:	50                   	push   %eax
  804355:	6a 1d                	push   $0x1d
  804357:	e8 ae fc ff ff       	call   80400a <syscall>
  80435c:	83 c4 18             	add    $0x18,%esp
	return result;
  80435f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  804362:	8b 45 f8             	mov    -0x8(%ebp),%eax
  804365:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804368:	89 01                	mov    %eax,(%ecx)
  80436a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80436d:	8b 45 08             	mov    0x8(%ebp),%eax
  804370:	c9                   	leave  
  804371:	c2 04 00             	ret    $0x4

00804374 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  804374:	55                   	push   %ebp
  804375:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  804377:	6a 00                	push   $0x0
  804379:	6a 00                	push   $0x0
  80437b:	ff 75 10             	pushl  0x10(%ebp)
  80437e:	ff 75 0c             	pushl  0xc(%ebp)
  804381:	ff 75 08             	pushl  0x8(%ebp)
  804384:	6a 13                	push   $0x13
  804386:	e8 7f fc ff ff       	call   80400a <syscall>
  80438b:	83 c4 18             	add    $0x18,%esp
	return ;
  80438e:	90                   	nop
}
  80438f:	c9                   	leave  
  804390:	c3                   	ret    

00804391 <sys_rcr2>:
uint32 sys_rcr2()
{
  804391:	55                   	push   %ebp
  804392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  804394:	6a 00                	push   $0x0
  804396:	6a 00                	push   $0x0
  804398:	6a 00                	push   $0x0
  80439a:	6a 00                	push   $0x0
  80439c:	6a 00                	push   $0x0
  80439e:	6a 1e                	push   $0x1e
  8043a0:	e8 65 fc ff ff       	call   80400a <syscall>
  8043a5:	83 c4 18             	add    $0x18,%esp
}
  8043a8:	c9                   	leave  
  8043a9:	c3                   	ret    

008043aa <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8043aa:	55                   	push   %ebp
  8043ab:	89 e5                	mov    %esp,%ebp
  8043ad:	83 ec 04             	sub    $0x4,%esp
  8043b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8043b6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8043ba:	6a 00                	push   $0x0
  8043bc:	6a 00                	push   $0x0
  8043be:	6a 00                	push   $0x0
  8043c0:	6a 00                	push   $0x0
  8043c2:	50                   	push   %eax
  8043c3:	6a 1f                	push   $0x1f
  8043c5:	e8 40 fc ff ff       	call   80400a <syscall>
  8043ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8043cd:	90                   	nop
}
  8043ce:	c9                   	leave  
  8043cf:	c3                   	ret    

008043d0 <rsttst>:
void rsttst()
{
  8043d0:	55                   	push   %ebp
  8043d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8043d3:	6a 00                	push   $0x0
  8043d5:	6a 00                	push   $0x0
  8043d7:	6a 00                	push   $0x0
  8043d9:	6a 00                	push   $0x0
  8043db:	6a 00                	push   $0x0
  8043dd:	6a 21                	push   $0x21
  8043df:	e8 26 fc ff ff       	call   80400a <syscall>
  8043e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8043e7:	90                   	nop
}
  8043e8:	c9                   	leave  
  8043e9:	c3                   	ret    

008043ea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8043ea:	55                   	push   %ebp
  8043eb:	89 e5                	mov    %esp,%ebp
  8043ed:	83 ec 04             	sub    $0x4,%esp
  8043f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8043f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8043f6:	8b 55 18             	mov    0x18(%ebp),%edx
  8043f9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8043fd:	52                   	push   %edx
  8043fe:	50                   	push   %eax
  8043ff:	ff 75 10             	pushl  0x10(%ebp)
  804402:	ff 75 0c             	pushl  0xc(%ebp)
  804405:	ff 75 08             	pushl  0x8(%ebp)
  804408:	6a 20                	push   $0x20
  80440a:	e8 fb fb ff ff       	call   80400a <syscall>
  80440f:	83 c4 18             	add    $0x18,%esp
	return ;
  804412:	90                   	nop
}
  804413:	c9                   	leave  
  804414:	c3                   	ret    

00804415 <chktst>:
void chktst(uint32 n)
{
  804415:	55                   	push   %ebp
  804416:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  804418:	6a 00                	push   $0x0
  80441a:	6a 00                	push   $0x0
  80441c:	6a 00                	push   $0x0
  80441e:	6a 00                	push   $0x0
  804420:	ff 75 08             	pushl  0x8(%ebp)
  804423:	6a 22                	push   $0x22
  804425:	e8 e0 fb ff ff       	call   80400a <syscall>
  80442a:	83 c4 18             	add    $0x18,%esp
	return ;
  80442d:	90                   	nop
}
  80442e:	c9                   	leave  
  80442f:	c3                   	ret    

00804430 <inctst>:

void inctst()
{
  804430:	55                   	push   %ebp
  804431:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  804433:	6a 00                	push   $0x0
  804435:	6a 00                	push   $0x0
  804437:	6a 00                	push   $0x0
  804439:	6a 00                	push   $0x0
  80443b:	6a 00                	push   $0x0
  80443d:	6a 23                	push   $0x23
  80443f:	e8 c6 fb ff ff       	call   80400a <syscall>
  804444:	83 c4 18             	add    $0x18,%esp
	return ;
  804447:	90                   	nop
}
  804448:	c9                   	leave  
  804449:	c3                   	ret    

0080444a <gettst>:
uint32 gettst()
{
  80444a:	55                   	push   %ebp
  80444b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80444d:	6a 00                	push   $0x0
  80444f:	6a 00                	push   $0x0
  804451:	6a 00                	push   $0x0
  804453:	6a 00                	push   $0x0
  804455:	6a 00                	push   $0x0
  804457:	6a 24                	push   $0x24
  804459:	e8 ac fb ff ff       	call   80400a <syscall>
  80445e:	83 c4 18             	add    $0x18,%esp
}
  804461:	c9                   	leave  
  804462:	c3                   	ret    

00804463 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  804463:	55                   	push   %ebp
  804464:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  804466:	6a 00                	push   $0x0
  804468:	6a 00                	push   $0x0
  80446a:	6a 00                	push   $0x0
  80446c:	6a 00                	push   $0x0
  80446e:	6a 00                	push   $0x0
  804470:	6a 25                	push   $0x25
  804472:	e8 93 fb ff ff       	call   80400a <syscall>
  804477:	83 c4 18             	add    $0x18,%esp
  80447a:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  80447f:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  804484:	c9                   	leave  
  804485:	c3                   	ret    

00804486 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  804486:	55                   	push   %ebp
  804487:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  804489:	8b 45 08             	mov    0x8(%ebp),%eax
  80448c:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  804491:	6a 00                	push   $0x0
  804493:	6a 00                	push   $0x0
  804495:	6a 00                	push   $0x0
  804497:	6a 00                	push   $0x0
  804499:	ff 75 08             	pushl  0x8(%ebp)
  80449c:	6a 26                	push   $0x26
  80449e:	e8 67 fb ff ff       	call   80400a <syscall>
  8044a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8044a6:	90                   	nop
}
  8044a7:	c9                   	leave  
  8044a8:	c3                   	ret    

008044a9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8044a9:	55                   	push   %ebp
  8044aa:	89 e5                	mov    %esp,%ebp
  8044ac:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8044ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8044b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8044b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8044b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b9:	6a 00                	push   $0x0
  8044bb:	53                   	push   %ebx
  8044bc:	51                   	push   %ecx
  8044bd:	52                   	push   %edx
  8044be:	50                   	push   %eax
  8044bf:	6a 27                	push   $0x27
  8044c1:	e8 44 fb ff ff       	call   80400a <syscall>
  8044c6:	83 c4 18             	add    $0x18,%esp
}
  8044c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8044cc:	c9                   	leave  
  8044cd:	c3                   	ret    

008044ce <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8044ce:	55                   	push   %ebp
  8044cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8044d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8044d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8044d7:	6a 00                	push   $0x0
  8044d9:	6a 00                	push   $0x0
  8044db:	6a 00                	push   $0x0
  8044dd:	52                   	push   %edx
  8044de:	50                   	push   %eax
  8044df:	6a 28                	push   $0x28
  8044e1:	e8 24 fb ff ff       	call   80400a <syscall>
  8044e6:	83 c4 18             	add    $0x18,%esp
}
  8044e9:	c9                   	leave  
  8044ea:	c3                   	ret    

008044eb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8044eb:	55                   	push   %ebp
  8044ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8044ee:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8044f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8044f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8044f7:	6a 00                	push   $0x0
  8044f9:	51                   	push   %ecx
  8044fa:	ff 75 10             	pushl  0x10(%ebp)
  8044fd:	52                   	push   %edx
  8044fe:	50                   	push   %eax
  8044ff:	6a 29                	push   $0x29
  804501:	e8 04 fb ff ff       	call   80400a <syscall>
  804506:	83 c4 18             	add    $0x18,%esp
}
  804509:	c9                   	leave  
  80450a:	c3                   	ret    

0080450b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80450b:	55                   	push   %ebp
  80450c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80450e:	6a 00                	push   $0x0
  804510:	6a 00                	push   $0x0
  804512:	ff 75 10             	pushl  0x10(%ebp)
  804515:	ff 75 0c             	pushl  0xc(%ebp)
  804518:	ff 75 08             	pushl  0x8(%ebp)
  80451b:	6a 12                	push   $0x12
  80451d:	e8 e8 fa ff ff       	call   80400a <syscall>
  804522:	83 c4 18             	add    $0x18,%esp
	return ;
  804525:	90                   	nop
}
  804526:	c9                   	leave  
  804527:	c3                   	ret    

00804528 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  804528:	55                   	push   %ebp
  804529:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80452b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80452e:	8b 45 08             	mov    0x8(%ebp),%eax
  804531:	6a 00                	push   $0x0
  804533:	6a 00                	push   $0x0
  804535:	6a 00                	push   $0x0
  804537:	52                   	push   %edx
  804538:	50                   	push   %eax
  804539:	6a 2a                	push   $0x2a
  80453b:	e8 ca fa ff ff       	call   80400a <syscall>
  804540:	83 c4 18             	add    $0x18,%esp
	return;
  804543:	90                   	nop
}
  804544:	c9                   	leave  
  804545:	c3                   	ret    

00804546 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  804546:	55                   	push   %ebp
  804547:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  804549:	6a 00                	push   $0x0
  80454b:	6a 00                	push   $0x0
  80454d:	6a 00                	push   $0x0
  80454f:	6a 00                	push   $0x0
  804551:	6a 00                	push   $0x0
  804553:	6a 2b                	push   $0x2b
  804555:	e8 b0 fa ff ff       	call   80400a <syscall>
  80455a:	83 c4 18             	add    $0x18,%esp
}
  80455d:	c9                   	leave  
  80455e:	c3                   	ret    

0080455f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80455f:	55                   	push   %ebp
  804560:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  804562:	6a 00                	push   $0x0
  804564:	6a 00                	push   $0x0
  804566:	6a 00                	push   $0x0
  804568:	ff 75 0c             	pushl  0xc(%ebp)
  80456b:	ff 75 08             	pushl  0x8(%ebp)
  80456e:	6a 2d                	push   $0x2d
  804570:	e8 95 fa ff ff       	call   80400a <syscall>
  804575:	83 c4 18             	add    $0x18,%esp
	return;
  804578:	90                   	nop
}
  804579:	c9                   	leave  
  80457a:	c3                   	ret    

0080457b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80457b:	55                   	push   %ebp
  80457c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80457e:	6a 00                	push   $0x0
  804580:	6a 00                	push   $0x0
  804582:	6a 00                	push   $0x0
  804584:	ff 75 0c             	pushl  0xc(%ebp)
  804587:	ff 75 08             	pushl  0x8(%ebp)
  80458a:	6a 2c                	push   $0x2c
  80458c:	e8 79 fa ff ff       	call   80400a <syscall>
  804591:	83 c4 18             	add    $0x18,%esp
	return ;
  804594:	90                   	nop
}
  804595:	c9                   	leave  
  804596:	c3                   	ret    

00804597 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  804597:	55                   	push   %ebp
  804598:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80459a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80459d:	8b 45 08             	mov    0x8(%ebp),%eax
  8045a0:	6a 00                	push   $0x0
  8045a2:	6a 00                	push   $0x0
  8045a4:	6a 00                	push   $0x0
  8045a6:	52                   	push   %edx
  8045a7:	50                   	push   %eax
  8045a8:	6a 2e                	push   $0x2e
  8045aa:	e8 5b fa ff ff       	call   80400a <syscall>
  8045af:	83 c4 18             	add    $0x18,%esp
	    return;
  8045b2:	90                   	nop
}
  8045b3:	c9                   	leave  
  8045b4:	c3                   	ret    

008045b5 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8045b5:	55                   	push   %ebp
  8045b6:	89 e5                	mov    %esp,%ebp
  8045b8:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8045bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8045be:	ba 40 72 80 00       	mov    $0x807240,%edx
  8045c3:	29 d0                	sub    %edx,%eax
  8045c5:	c1 f8 02             	sar    $0x2,%eax
  8045c8:	89 c2                	mov    %eax,%edx
  8045ca:	89 d0                	mov    %edx,%eax
  8045cc:	c1 e0 02             	shl    $0x2,%eax
  8045cf:	01 d0                	add    %edx,%eax
  8045d1:	c1 e0 02             	shl    $0x2,%eax
  8045d4:	01 d0                	add    %edx,%eax
  8045d6:	c1 e0 02             	shl    $0x2,%eax
  8045d9:	01 d0                	add    %edx,%eax
  8045db:	89 c1                	mov    %eax,%ecx
  8045dd:	c1 e1 08             	shl    $0x8,%ecx
  8045e0:	01 c8                	add    %ecx,%eax
  8045e2:	89 c1                	mov    %eax,%ecx
  8045e4:	c1 e1 10             	shl    $0x10,%ecx
  8045e7:	01 c8                	add    %ecx,%eax
  8045e9:	01 c0                	add    %eax,%eax
  8045eb:	01 d0                	add    %edx,%eax
  8045ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8045f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8045f3:	c1 e0 0c             	shl    $0xc,%eax
  8045f6:	89 c2                	mov    %eax,%edx
  8045f8:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8045fd:	01 d0                	add    %edx,%eax
}
  8045ff:	c9                   	leave  
  804600:	c3                   	ret    

00804601 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  804601:	55                   	push   %ebp
  804602:	89 e5                	mov    %esp,%ebp
  804604:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  804607:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  80460e:	eb 06                	jmp    804616 <log2+0x15>
			n >>=1;
  804610:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  804613:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  804616:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80461a:	77 f4                	ja     804610 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  80461c:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80461f:	c9                   	leave  
  804620:	c3                   	ret    

00804621 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  804621:	55                   	push   %ebp
  804622:	89 e5                	mov    %esp,%ebp
  804624:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  804627:	8b 45 08             	mov    0x8(%ebp),%eax
  80462a:	05 00 00 00 02       	add    $0x2000000,%eax
  80462f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804632:	73 16                	jae    80464a <initialize_dynamic_allocator+0x29>
  804634:	68 78 61 80 00       	push   $0x806178
  804639:	68 9e 61 80 00       	push   $0x80619e
  80463e:	6a 2d                	push   $0x2d
  804640:	68 b3 61 80 00       	push   $0x8061b3
  804645:	e8 a6 ce ff ff       	call   8014f0 <_panic>
		is_initialized = 1;
  80464a:	c7 05 04 72 80 00 01 	movl   $0x1,0x807204
  804651:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  804654:	8b 45 08             	mov    0x8(%ebp),%eax
  804657:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd= daEnd;
  80465c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80465f:	a3 20 72 80 00       	mov    %eax,0x807220
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  804664:	8b 15 20 72 80 00    	mov    0x807220,%edx
  80466a:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80466f:	29 c2                	sub    %eax,%edx
  804671:	89 d0                	mov    %edx,%eax
  804673:	c1 e8 0c             	shr    $0xc,%eax
  804676:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  804679:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804680:	eb 2f                	jmp    8046b1 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  804682:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804685:	89 d0                	mov    %edx,%eax
  804687:	01 c0                	add    %eax,%eax
  804689:	01 d0                	add    %edx,%eax
  80468b:	c1 e0 02             	shl    $0x2,%eax
  80468e:	05 48 72 80 00       	add    $0x807248,%eax
  804693:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  804698:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80469b:	89 d0                	mov    %edx,%eax
  80469d:	01 c0                	add    %eax,%eax
  80469f:	01 d0                	add    %edx,%eax
  8046a1:	c1 e0 02             	shl    $0x2,%eax
  8046a4:	05 4a 72 80 00       	add    $0x80724a,%eax
  8046a9:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  8046ae:	ff 45 f4             	incl   -0xc(%ebp)
  8046b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046b4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8046b7:	7c c9                	jl     804682 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  8046b9:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  8046c0:	00 00 00 
  8046c3:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  8046ca:	00 00 00 
  8046cd:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  8046d4:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  8046d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8046de:	e9 9c 00 00 00       	jmp    80477f <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8046e3:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  8046e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8046ec:	89 c8                	mov    %ecx,%eax
  8046ee:	01 c0                	add    %eax,%eax
  8046f0:	01 c8                	add    %ecx,%eax
  8046f2:	c1 e0 02             	shl    $0x2,%eax
  8046f5:	05 44 72 80 00       	add    $0x807244,%eax
  8046fa:	89 10                	mov    %edx,(%eax)
  8046fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8046ff:	89 d0                	mov    %edx,%eax
  804701:	01 c0                	add    %eax,%eax
  804703:	01 d0                	add    %edx,%eax
  804705:	c1 e0 02             	shl    $0x2,%eax
  804708:	05 44 72 80 00       	add    $0x807244,%eax
  80470d:	8b 00                	mov    (%eax),%eax
  80470f:	85 c0                	test   %eax,%eax
  804711:	74 1b                	je     80472e <initialize_dynamic_allocator+0x10d>
  804713:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804719:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80471c:	89 c8                	mov    %ecx,%eax
  80471e:	01 c0                	add    %eax,%eax
  804720:	01 c8                	add    %ecx,%eax
  804722:	c1 e0 02             	shl    $0x2,%eax
  804725:	05 40 72 80 00       	add    $0x807240,%eax
  80472a:	89 02                	mov    %eax,(%edx)
  80472c:	eb 16                	jmp    804744 <initialize_dynamic_allocator+0x123>
  80472e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804731:	89 d0                	mov    %edx,%eax
  804733:	01 c0                	add    %eax,%eax
  804735:	01 d0                	add    %edx,%eax
  804737:	c1 e0 02             	shl    $0x2,%eax
  80473a:	05 40 72 80 00       	add    $0x807240,%eax
  80473f:	a3 28 72 80 00       	mov    %eax,0x807228
  804744:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804747:	89 d0                	mov    %edx,%eax
  804749:	01 c0                	add    %eax,%eax
  80474b:	01 d0                	add    %edx,%eax
  80474d:	c1 e0 02             	shl    $0x2,%eax
  804750:	05 40 72 80 00       	add    $0x807240,%eax
  804755:	a3 2c 72 80 00       	mov    %eax,0x80722c
  80475a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80475d:	89 d0                	mov    %edx,%eax
  80475f:	01 c0                	add    %eax,%eax
  804761:	01 d0                	add    %edx,%eax
  804763:	c1 e0 02             	shl    $0x2,%eax
  804766:	05 40 72 80 00       	add    $0x807240,%eax
  80476b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804771:	a1 34 72 80 00       	mov    0x807234,%eax
  804776:	40                   	inc    %eax
  804777:	a3 34 72 80 00       	mov    %eax,0x807234
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  80477c:	ff 45 f0             	incl   -0x10(%ebp)
  80477f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804782:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804785:	0f 8c 58 ff ff ff    	jl     8046e3 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80478b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  804792:	eb 36                	jmp    8047ca <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  804794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804797:	c1 e0 04             	shl    $0x4,%eax
  80479a:	05 60 f2 81 00       	add    $0x81f260,%eax
  80479f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047a8:	c1 e0 04             	shl    $0x4,%eax
  8047ab:	05 64 f2 81 00       	add    $0x81f264,%eax
  8047b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047b9:	c1 e0 04             	shl    $0x4,%eax
  8047bc:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8047c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8047c7:	ff 45 ec             	incl   -0x14(%ebp)
  8047ca:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8047ce:	7e c4                	jle    804794 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8047d0:	90                   	nop
  8047d1:	c9                   	leave  
  8047d2:	c3                   	ret    

008047d3 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  8047d3:	55                   	push   %ebp
  8047d4:	89 e5                	mov    %esp,%ebp
  8047d6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8047d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8047dc:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8047e1:	29 c2                	sub    %eax,%edx
  8047e3:	89 d0                	mov    %edx,%eax
  8047e5:	c1 e8 0c             	shr    $0xc,%eax
  8047e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  8047eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8047ee:	89 d0                	mov    %edx,%eax
  8047f0:	01 c0                	add    %eax,%eax
  8047f2:	01 d0                	add    %edx,%eax
  8047f4:	c1 e0 02             	shl    $0x2,%eax
  8047f7:	05 48 72 80 00       	add    $0x807248,%eax
  8047fc:	8b 00                	mov    (%eax),%eax
  8047fe:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  804801:	c9                   	leave  
  804802:	c3                   	ret    

00804803 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  804803:	55                   	push   %ebp
  804804:	89 e5                	mov    %esp,%ebp
  804806:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  804809:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  804810:	76 16                	jbe    804828 <alloc_block+0x25>
  804812:	68 cc 61 80 00       	push   $0x8061cc
  804817:	68 9e 61 80 00       	push   $0x80619e
  80481c:	6a 6c                	push   $0x6c
  80481e:	68 b3 61 80 00       	push   $0x8061b3
  804823:	e8 c8 cc ff ff       	call   8014f0 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  804828:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80482c:	75 0a                	jne    804838 <alloc_block+0x35>
		return NULL;
  80482e:	b8 00 00 00 00       	mov    $0x0,%eax
  804833:	e9 65 04 00 00       	jmp    804c9d <alloc_block+0x49a>
	}
	else if(size<=8){
  804838:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  80483c:	77 09                	ja     804847 <alloc_block+0x44>
		size=8;
  80483e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  804845:	eb 1f                	jmp    804866 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  804847:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  80484e:	eb 08                	jmp    804858 <alloc_block+0x55>
			reqsize*=2;
  804850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804853:	01 c0                	add    %eax,%eax
  804855:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  804858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80485b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80485e:	72 f0                	jb     804850 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  804860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804863:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  804866:	83 ec 0c             	sub    $0xc,%esp
  804869:	ff 75 08             	pushl  0x8(%ebp)
  80486c:	e8 90 fd ff ff       	call   804601 <log2>
  804871:	83 c4 10             	add    $0x10,%esp
  804874:	83 e8 03             	sub    $0x3,%eax
  804877:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  80487a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80487d:	c1 e0 04             	shl    $0x4,%eax
  804880:	05 60 f2 81 00       	add    $0x81f260,%eax
  804885:	8b 00                	mov    (%eax),%eax
  804887:	85 c0                	test   %eax,%eax
  804889:	0f 84 fb 00 00 00    	je     80498a <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  80488f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804892:	c1 e0 04             	shl    $0x4,%eax
  804895:	05 60 f2 81 00       	add    $0x81f260,%eax
  80489a:	8b 00                	mov    (%eax),%eax
  80489c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  80489f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8048a3:	75 17                	jne    8048bc <alloc_block+0xb9>
  8048a5:	83 ec 04             	sub    $0x4,%esp
  8048a8:	68 ed 61 80 00       	push   $0x8061ed
  8048ad:	68 86 00 00 00       	push   $0x86
  8048b2:	68 b3 61 80 00       	push   $0x8061b3
  8048b7:	e8 34 cc ff ff       	call   8014f0 <_panic>
  8048bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048bf:	8b 00                	mov    (%eax),%eax
  8048c1:	85 c0                	test   %eax,%eax
  8048c3:	74 10                	je     8048d5 <alloc_block+0xd2>
  8048c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048c8:	8b 00                	mov    (%eax),%eax
  8048ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8048cd:	8b 52 04             	mov    0x4(%edx),%edx
  8048d0:	89 50 04             	mov    %edx,0x4(%eax)
  8048d3:	eb 14                	jmp    8048e9 <alloc_block+0xe6>
  8048d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048d8:	8b 40 04             	mov    0x4(%eax),%eax
  8048db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8048de:	c1 e2 04             	shl    $0x4,%edx
  8048e1:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  8048e7:	89 02                	mov    %eax,(%edx)
  8048e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048ec:	8b 40 04             	mov    0x4(%eax),%eax
  8048ef:	85 c0                	test   %eax,%eax
  8048f1:	74 0f                	je     804902 <alloc_block+0xff>
  8048f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048f6:	8b 40 04             	mov    0x4(%eax),%eax
  8048f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8048fc:	8b 12                	mov    (%edx),%edx
  8048fe:	89 10                	mov    %edx,(%eax)
  804900:	eb 13                	jmp    804915 <alloc_block+0x112>
  804902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804905:	8b 00                	mov    (%eax),%eax
  804907:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80490a:	c1 e2 04             	shl    $0x4,%edx
  80490d:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804913:	89 02                	mov    %eax,(%edx)
  804915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804918:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80491e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804921:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80492b:	c1 e0 04             	shl    $0x4,%eax
  80492e:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804933:	8b 00                	mov    (%eax),%eax
  804935:	8d 50 ff             	lea    -0x1(%eax),%edx
  804938:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80493b:	c1 e0 04             	shl    $0x4,%eax
  80493e:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804943:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804945:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804948:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80494d:	29 c2                	sub    %eax,%edx
  80494f:	89 d0                	mov    %edx,%eax
  804951:	c1 e8 0c             	shr    $0xc,%eax
  804954:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  804957:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80495a:	89 d0                	mov    %edx,%eax
  80495c:	01 c0                	add    %eax,%eax
  80495e:	01 d0                	add    %edx,%eax
  804960:	c1 e0 02             	shl    $0x2,%eax
  804963:	05 4a 72 80 00       	add    $0x80724a,%eax
  804968:	66 8b 00             	mov    (%eax),%ax
  80496b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80496e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  804971:	89 c8                	mov    %ecx,%eax
  804973:	01 c0                	add    %eax,%eax
  804975:	01 c8                	add    %ecx,%eax
  804977:	c1 e0 02             	shl    $0x2,%eax
  80497a:	05 4a 72 80 00       	add    $0x80724a,%eax
  80497f:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  804982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804985:	e9 13 03 00 00       	jmp    804c9d <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  80498a:	a1 28 72 80 00       	mov    0x807228,%eax
  80498f:	85 c0                	test   %eax,%eax
  804991:	0f 84 c9 01 00 00    	je     804b60 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  804997:	a1 28 72 80 00       	mov    0x807228,%eax
  80499c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  80499f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8049a3:	75 17                	jne    8049bc <alloc_block+0x1b9>
  8049a5:	83 ec 04             	sub    $0x4,%esp
  8049a8:	68 ed 61 80 00       	push   $0x8061ed
  8049ad:	68 8f 00 00 00       	push   $0x8f
  8049b2:	68 b3 61 80 00       	push   $0x8061b3
  8049b7:	e8 34 cb ff ff       	call   8014f0 <_panic>
  8049bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8049bf:	8b 00                	mov    (%eax),%eax
  8049c1:	85 c0                	test   %eax,%eax
  8049c3:	74 10                	je     8049d5 <alloc_block+0x1d2>
  8049c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8049c8:	8b 00                	mov    (%eax),%eax
  8049ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8049cd:	8b 52 04             	mov    0x4(%edx),%edx
  8049d0:	89 50 04             	mov    %edx,0x4(%eax)
  8049d3:	eb 0b                	jmp    8049e0 <alloc_block+0x1dd>
  8049d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8049d8:	8b 40 04             	mov    0x4(%eax),%eax
  8049db:	a3 2c 72 80 00       	mov    %eax,0x80722c
  8049e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8049e3:	8b 40 04             	mov    0x4(%eax),%eax
  8049e6:	85 c0                	test   %eax,%eax
  8049e8:	74 0f                	je     8049f9 <alloc_block+0x1f6>
  8049ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8049ed:	8b 40 04             	mov    0x4(%eax),%eax
  8049f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8049f3:	8b 12                	mov    (%edx),%edx
  8049f5:	89 10                	mov    %edx,(%eax)
  8049f7:	eb 0a                	jmp    804a03 <alloc_block+0x200>
  8049f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8049fc:	8b 00                	mov    (%eax),%eax
  8049fe:	a3 28 72 80 00       	mov    %eax,0x807228
  804a03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a16:	a1 34 72 80 00       	mov    0x807234,%eax
  804a1b:	48                   	dec    %eax
  804a1c:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  804a21:	83 ec 0c             	sub    $0xc,%esp
  804a24:	ff 75 dc             	pushl  -0x24(%ebp)
  804a27:	e8 89 fb ff ff       	call   8045b5 <to_page_va>
  804a2c:	83 c4 10             	add    $0x10,%esp
  804a2f:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  804a32:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804a37:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804a3a:	29 c2                	sub    %eax,%edx
  804a3c:	89 d0                	mov    %edx,%eax
  804a3e:	c1 e8 0c             	shr    $0xc,%eax
  804a41:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  804a44:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804a47:	83 ec 0c             	sub    $0xc,%esp
  804a4a:	50                   	push   %eax
  804a4b:	e8 fe dc ff ff       	call   80274e <get_page>
  804a50:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  804a53:	8b 45 08             	mov    0x8(%ebp),%eax
  804a56:	89 c2                	mov    %eax,%edx
  804a58:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804a5b:	89 c8                	mov    %ecx,%eax
  804a5d:	01 c0                	add    %eax,%eax
  804a5f:	01 c8                	add    %ecx,%eax
  804a61:	c1 e0 02             	shl    $0x2,%eax
  804a64:	05 48 72 80 00       	add    $0x807248,%eax
  804a69:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  804a6c:	b8 00 10 00 00       	mov    $0x1000,%eax
  804a71:	ba 00 00 00 00       	mov    $0x0,%edx
  804a76:	f7 75 08             	divl   0x8(%ebp)
  804a79:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  804a7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804a7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  804a82:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804a85:	89 c8                	mov    %ecx,%eax
  804a87:	01 c0                	add    %eax,%eax
  804a89:	01 c8                	add    %ecx,%eax
  804a8b:	c1 e0 02             	shl    $0x2,%eax
  804a8e:	05 4a 72 80 00       	add    $0x80724a,%eax
  804a93:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  804a96:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  804a9d:	e9 aa 00 00 00       	jmp    804b4c <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  804aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804aa5:	0f af 45 08          	imul   0x8(%ebp),%eax
  804aa9:	89 c2                	mov    %eax,%edx
  804aab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804aae:	01 d0                	add    %edx,%eax
  804ab0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  804ab3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804ab7:	75 17                	jne    804ad0 <alloc_block+0x2cd>
  804ab9:	83 ec 04             	sub    $0x4,%esp
  804abc:	68 0c 62 80 00       	push   $0x80620c
  804ac1:	68 9d 00 00 00       	push   $0x9d
  804ac6:	68 b3 61 80 00       	push   $0x8061b3
  804acb:	e8 20 ca ff ff       	call   8014f0 <_panic>
  804ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804ad3:	c1 e0 04             	shl    $0x4,%eax
  804ad6:	05 64 f2 81 00       	add    $0x81f264,%eax
  804adb:	8b 10                	mov    (%eax),%edx
  804add:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804ae0:	89 50 04             	mov    %edx,0x4(%eax)
  804ae3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804ae6:	8b 40 04             	mov    0x4(%eax),%eax
  804ae9:	85 c0                	test   %eax,%eax
  804aeb:	74 14                	je     804b01 <alloc_block+0x2fe>
  804aed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804af0:	c1 e0 04             	shl    $0x4,%eax
  804af3:	05 64 f2 81 00       	add    $0x81f264,%eax
  804af8:	8b 00                	mov    (%eax),%eax
  804afa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804afd:	89 10                	mov    %edx,(%eax)
  804aff:	eb 11                	jmp    804b12 <alloc_block+0x30f>
  804b01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b04:	c1 e0 04             	shl    $0x4,%eax
  804b07:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804b0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804b10:	89 02                	mov    %eax,(%edx)
  804b12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b15:	c1 e0 04             	shl    $0x4,%eax
  804b18:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804b1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804b21:	89 02                	mov    %eax,(%edx)
  804b23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804b26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b2f:	c1 e0 04             	shl    $0x4,%eax
  804b32:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804b37:	8b 00                	mov    (%eax),%eax
  804b39:	8d 50 01             	lea    0x1(%eax),%edx
  804b3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b3f:	c1 e0 04             	shl    $0x4,%eax
  804b42:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804b47:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  804b49:	ff 45 f0             	incl   -0x10(%ebp)
  804b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b4f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  804b52:	0f 8c 4a ff ff ff    	jl     804aa2 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  804b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804b5b:	e9 3d 01 00 00       	jmp    804c9d <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804b60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b63:	40                   	inc    %eax
  804b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804b67:	e9 10 01 00 00       	jmp    804c7c <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  804b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804b6f:	c1 e0 04             	shl    $0x4,%eax
  804b72:	05 60 f2 81 00       	add    $0x81f260,%eax
  804b77:	8b 00                	mov    (%eax),%eax
  804b79:	85 c0                	test   %eax,%eax
  804b7b:	0f 84 f8 00 00 00    	je     804c79 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804b84:	c1 e0 04             	shl    $0x4,%eax
  804b87:	05 60 f2 81 00       	add    $0x81f260,%eax
  804b8c:	8b 00                	mov    (%eax),%eax
  804b8e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  804b91:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804b95:	75 17                	jne    804bae <alloc_block+0x3ab>
  804b97:	83 ec 04             	sub    $0x4,%esp
  804b9a:	68 ed 61 80 00       	push   $0x8061ed
  804b9f:	68 a8 00 00 00       	push   $0xa8
  804ba4:	68 b3 61 80 00       	push   $0x8061b3
  804ba9:	e8 42 c9 ff ff       	call   8014f0 <_panic>
  804bae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804bb1:	8b 00                	mov    (%eax),%eax
  804bb3:	85 c0                	test   %eax,%eax
  804bb5:	74 10                	je     804bc7 <alloc_block+0x3c4>
  804bb7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804bba:	8b 00                	mov    (%eax),%eax
  804bbc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804bbf:	8b 52 04             	mov    0x4(%edx),%edx
  804bc2:	89 50 04             	mov    %edx,0x4(%eax)
  804bc5:	eb 14                	jmp    804bdb <alloc_block+0x3d8>
  804bc7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804bca:	8b 40 04             	mov    0x4(%eax),%eax
  804bcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804bd0:	c1 e2 04             	shl    $0x4,%edx
  804bd3:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804bd9:	89 02                	mov    %eax,(%edx)
  804bdb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804bde:	8b 40 04             	mov    0x4(%eax),%eax
  804be1:	85 c0                	test   %eax,%eax
  804be3:	74 0f                	je     804bf4 <alloc_block+0x3f1>
  804be5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804be8:	8b 40 04             	mov    0x4(%eax),%eax
  804beb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804bee:	8b 12                	mov    (%edx),%edx
  804bf0:	89 10                	mov    %edx,(%eax)
  804bf2:	eb 13                	jmp    804c07 <alloc_block+0x404>
  804bf4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804bf7:	8b 00                	mov    (%eax),%eax
  804bf9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804bfc:	c1 e2 04             	shl    $0x4,%edx
  804bff:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804c05:	89 02                	mov    %eax,(%edx)
  804c07:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c10:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c1d:	c1 e0 04             	shl    $0x4,%eax
  804c20:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804c25:	8b 00                	mov    (%eax),%eax
  804c27:	8d 50 ff             	lea    -0x1(%eax),%edx
  804c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c2d:	c1 e0 04             	shl    $0x4,%eax
  804c30:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804c35:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804c37:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804c3a:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804c3f:	29 c2                	sub    %eax,%edx
  804c41:	89 d0                	mov    %edx,%eax
  804c43:	c1 e8 0c             	shr    $0xc,%eax
  804c46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  804c49:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  804c4c:	89 d0                	mov    %edx,%eax
  804c4e:	01 c0                	add    %eax,%eax
  804c50:	01 d0                	add    %edx,%eax
  804c52:	c1 e0 02             	shl    $0x2,%eax
  804c55:	05 4a 72 80 00       	add    $0x80724a,%eax
  804c5a:	66 8b 00             	mov    (%eax),%ax
  804c5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  804c60:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  804c63:	89 c8                	mov    %ecx,%eax
  804c65:	01 c0                	add    %eax,%eax
  804c67:	01 c8                	add    %ecx,%eax
  804c69:	c1 e0 02             	shl    $0x2,%eax
  804c6c:	05 4a 72 80 00       	add    $0x80724a,%eax
  804c71:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  804c74:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c77:	eb 24                	jmp    804c9d <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804c79:	ff 45 ec             	incl   -0x14(%ebp)
  804c7c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804c80:	0f 8e e6 fe ff ff    	jle    804b6c <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  804c86:	83 ec 04             	sub    $0x4,%esp
  804c89:	68 2f 62 80 00       	push   $0x80622f
  804c8e:	68 b1 00 00 00       	push   $0xb1
  804c93:	68 b3 61 80 00       	push   $0x8061b3
  804c98:	e8 53 c8 ff ff       	call   8014f0 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804c9d:	c9                   	leave  
  804c9e:	c3                   	ret    

00804c9f <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804c9f:	55                   	push   %ebp
  804ca0:	89 e5                	mov    %esp,%ebp
  804ca2:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  804ca8:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804cad:	39 c2                	cmp    %eax,%edx
  804caf:	72 0c                	jb     804cbd <free_block+0x1e>
  804cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  804cb4:	a1 20 72 80 00       	mov    0x807220,%eax
  804cb9:	39 c2                	cmp    %eax,%edx
  804cbb:	72 19                	jb     804cd6 <free_block+0x37>
  804cbd:	68 4c 62 80 00       	push   $0x80624c
  804cc2:	68 9e 61 80 00       	push   $0x80619e
  804cc7:	68 c3 00 00 00       	push   $0xc3
  804ccc:	68 b3 61 80 00       	push   $0x8061b3
  804cd1:	e8 1a c8 ff ff       	call   8014f0 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  804cd9:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804cde:	29 c2                	sub    %eax,%edx
  804ce0:	89 d0                	mov    %edx,%eax
  804ce2:	c1 e8 0c             	shr    $0xc,%eax
  804ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  804ce8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804ceb:	89 d0                	mov    %edx,%eax
  804ced:	01 c0                	add    %eax,%eax
  804cef:	01 d0                	add    %edx,%eax
  804cf1:	c1 e0 02             	shl    $0x2,%eax
  804cf4:	05 48 72 80 00       	add    $0x807248,%eax
  804cf9:	8b 00                	mov    (%eax),%eax
  804cfb:	0f b7 c0             	movzwl %ax,%eax
  804cfe:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  804d01:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804d05:	75 17                	jne    804d1e <free_block+0x7f>
		panic("page is empty(already not allocated)");
  804d07:	83 ec 04             	sub    $0x4,%esp
  804d0a:	68 84 62 80 00       	push   $0x806284
  804d0f:	68 cf 00 00 00       	push   $0xcf
  804d14:	68 b3 61 80 00       	push   $0x8061b3
  804d19:	e8 d2 c7 ff ff       	call   8014f0 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804d1e:	83 ec 0c             	sub    $0xc,%esp
  804d21:	ff 75 ec             	pushl  -0x14(%ebp)
  804d24:	e8 d8 f8 ff ff       	call   804601 <log2>
  804d29:	83 c4 10             	add    $0x10,%esp
  804d2c:	83 e8 03             	sub    $0x3,%eax
  804d2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804d32:	8b 45 08             	mov    0x8(%ebp),%eax
  804d35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  804d38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804d3c:	75 17                	jne    804d55 <free_block+0xb6>
  804d3e:	83 ec 04             	sub    $0x4,%esp
  804d41:	68 0c 62 80 00       	push   $0x80620c
  804d46:	68 d5 00 00 00       	push   $0xd5
  804d4b:	68 b3 61 80 00       	push   $0x8061b3
  804d50:	e8 9b c7 ff ff       	call   8014f0 <_panic>
  804d55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804d58:	c1 e0 04             	shl    $0x4,%eax
  804d5b:	05 64 f2 81 00       	add    $0x81f264,%eax
  804d60:	8b 10                	mov    (%eax),%edx
  804d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d65:	89 50 04             	mov    %edx,0x4(%eax)
  804d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d6b:	8b 40 04             	mov    0x4(%eax),%eax
  804d6e:	85 c0                	test   %eax,%eax
  804d70:	74 14                	je     804d86 <free_block+0xe7>
  804d72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804d75:	c1 e0 04             	shl    $0x4,%eax
  804d78:	05 64 f2 81 00       	add    $0x81f264,%eax
  804d7d:	8b 00                	mov    (%eax),%eax
  804d7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804d82:	89 10                	mov    %edx,(%eax)
  804d84:	eb 11                	jmp    804d97 <free_block+0xf8>
  804d86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804d89:	c1 e0 04             	shl    $0x4,%eax
  804d8c:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d95:	89 02                	mov    %eax,(%edx)
  804d97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804d9a:	c1 e0 04             	shl    $0x4,%eax
  804d9d:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804da6:	89 02                	mov    %eax,(%edx)
  804da8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804dab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804db4:	c1 e0 04             	shl    $0x4,%eax
  804db7:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804dbc:	8b 00                	mov    (%eax),%eax
  804dbe:	8d 50 01             	lea    0x1(%eax),%edx
  804dc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804dc4:	c1 e0 04             	shl    $0x4,%eax
  804dc7:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804dcc:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  804dce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804dd1:	89 d0                	mov    %edx,%eax
  804dd3:	01 c0                	add    %eax,%eax
  804dd5:	01 d0                	add    %edx,%eax
  804dd7:	c1 e0 02             	shl    $0x2,%eax
  804dda:	05 4a 72 80 00       	add    $0x80724a,%eax
  804ddf:	66 8b 00             	mov    (%eax),%ax
  804de2:	8d 50 01             	lea    0x1(%eax),%edx
  804de5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804de8:	89 c8                	mov    %ecx,%eax
  804dea:	01 c0                	add    %eax,%eax
  804dec:	01 c8                	add    %ecx,%eax
  804dee:	c1 e0 02             	shl    $0x2,%eax
  804df1:	05 4a 72 80 00       	add    $0x80724a,%eax
  804df6:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  804df9:	b8 00 10 00 00       	mov    $0x1000,%eax
  804dfe:	ba 00 00 00 00       	mov    $0x0,%edx
  804e03:	f7 75 ec             	divl   -0x14(%ebp)
  804e06:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  804e09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804e0c:	89 d0                	mov    %edx,%eax
  804e0e:	01 c0                	add    %eax,%eax
  804e10:	01 d0                	add    %edx,%eax
  804e12:	c1 e0 02             	shl    $0x2,%eax
  804e15:	05 4a 72 80 00       	add    $0x80724a,%eax
  804e1a:	66 8b 00             	mov    (%eax),%ax
  804e1d:	0f b7 c0             	movzwl %ax,%eax
  804e20:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804e23:	0f 85 d3 01 00 00    	jne    804ffc <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  804e29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e2c:	c1 e0 04             	shl    $0x4,%eax
  804e2f:	05 60 f2 81 00       	add    $0x81f260,%eax
  804e34:	8b 00                	mov    (%eax),%eax
  804e36:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  804e39:	e9 f1 00 00 00       	jmp    804f2f <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804e41:	8b 00                	mov    (%eax),%eax
  804e43:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  804e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804e49:	c1 e0 0c             	shl    $0xc,%eax
  804e4c:	89 c2                	mov    %eax,%edx
  804e4e:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804e53:	01 d0                	add    %edx,%eax
  804e55:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  804e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804e5b:	40                   	inc    %eax
  804e5c:	c1 e0 0c             	shl    $0xc,%eax
  804e5f:	89 c2                	mov    %eax,%edx
  804e61:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804e66:	01 d0                	add    %edx,%eax
  804e68:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  804e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804e6e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  804e71:	0f 82 b8 00 00 00    	jb     804f2f <free_block+0x290>
  804e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804e7a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804e7d:	0f 83 ac 00 00 00    	jae    804f2f <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  804e83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804e87:	75 17                	jne    804ea0 <free_block+0x201>
  804e89:	83 ec 04             	sub    $0x4,%esp
  804e8c:	68 ed 61 80 00       	push   $0x8061ed
  804e91:	68 e2 00 00 00       	push   $0xe2
  804e96:	68 b3 61 80 00       	push   $0x8061b3
  804e9b:	e8 50 c6 ff ff       	call   8014f0 <_panic>
  804ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ea3:	8b 00                	mov    (%eax),%eax
  804ea5:	85 c0                	test   %eax,%eax
  804ea7:	74 10                	je     804eb9 <free_block+0x21a>
  804ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804eac:	8b 00                	mov    (%eax),%eax
  804eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804eb1:	8b 52 04             	mov    0x4(%edx),%edx
  804eb4:	89 50 04             	mov    %edx,0x4(%eax)
  804eb7:	eb 14                	jmp    804ecd <free_block+0x22e>
  804eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ebc:	8b 40 04             	mov    0x4(%eax),%eax
  804ebf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804ec2:	c1 e2 04             	shl    $0x4,%edx
  804ec5:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804ecb:	89 02                	mov    %eax,(%edx)
  804ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ed0:	8b 40 04             	mov    0x4(%eax),%eax
  804ed3:	85 c0                	test   %eax,%eax
  804ed5:	74 0f                	je     804ee6 <free_block+0x247>
  804ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804eda:	8b 40 04             	mov    0x4(%eax),%eax
  804edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804ee0:	8b 12                	mov    (%edx),%edx
  804ee2:	89 10                	mov    %edx,(%eax)
  804ee4:	eb 13                	jmp    804ef9 <free_block+0x25a>
  804ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ee9:	8b 00                	mov    (%eax),%eax
  804eeb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804eee:	c1 e2 04             	shl    $0x4,%edx
  804ef1:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804ef7:	89 02                	mov    %eax,(%edx)
  804ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804efc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804f0f:	c1 e0 04             	shl    $0x4,%eax
  804f12:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804f17:	8b 00                	mov    (%eax),%eax
  804f19:	8d 50 ff             	lea    -0x1(%eax),%edx
  804f1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804f1f:	c1 e0 04             	shl    $0x4,%eax
  804f22:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804f27:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  804f29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804f33:	0f 85 05 ff ff ff    	jne    804e3e <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  804f39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804f3c:	89 d0                	mov    %edx,%eax
  804f3e:	01 c0                	add    %eax,%eax
  804f40:	01 d0                	add    %edx,%eax
  804f42:	c1 e0 02             	shl    $0x2,%eax
  804f45:	05 48 72 80 00       	add    $0x807248,%eax
  804f4a:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  804f4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804f52:	89 d0                	mov    %edx,%eax
  804f54:	01 c0                	add    %eax,%eax
  804f56:	01 d0                	add    %edx,%eax
  804f58:	c1 e0 02             	shl    $0x2,%eax
  804f5b:	05 4a 72 80 00       	add    $0x80724a,%eax
  804f60:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  804f65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804f68:	89 d0                	mov    %edx,%eax
  804f6a:	01 c0                	add    %eax,%eax
  804f6c:	01 d0                	add    %edx,%eax
  804f6e:	c1 e0 02             	shl    $0x2,%eax
  804f71:	05 40 72 80 00       	add    $0x807240,%eax
  804f76:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  804f79:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804f7d:	75 17                	jne    804f96 <free_block+0x2f7>
  804f7f:	83 ec 04             	sub    $0x4,%esp
  804f82:	68 0c 62 80 00       	push   $0x80620c
  804f87:	68 eb 00 00 00       	push   $0xeb
  804f8c:	68 b3 61 80 00       	push   $0x8061b3
  804f91:	e8 5a c5 ff ff       	call   8014f0 <_panic>
  804f96:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804f9c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804f9f:	89 50 04             	mov    %edx,0x4(%eax)
  804fa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804fa5:	8b 40 04             	mov    0x4(%eax),%eax
  804fa8:	85 c0                	test   %eax,%eax
  804faa:	74 0c                	je     804fb8 <free_block+0x319>
  804fac:	a1 2c 72 80 00       	mov    0x80722c,%eax
  804fb1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804fb4:	89 10                	mov    %edx,(%eax)
  804fb6:	eb 08                	jmp    804fc0 <free_block+0x321>
  804fb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804fbb:	a3 28 72 80 00       	mov    %eax,0x807228
  804fc0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804fc3:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804fc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804fcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804fd1:	a1 34 72 80 00       	mov    0x807234,%eax
  804fd6:	40                   	inc    %eax
  804fd7:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  804fdc:	83 ec 0c             	sub    $0xc,%esp
  804fdf:	ff 75 d0             	pushl  -0x30(%ebp)
  804fe2:	e8 ce f5 ff ff       	call   8045b5 <to_page_va>
  804fe7:	83 c4 10             	add    $0x10,%esp
  804fea:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  804fed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804ff0:	83 ec 0c             	sub    $0xc,%esp
  804ff3:	50                   	push   %eax
  804ff4:	e8 9e d7 ff ff       	call   802797 <return_page>
  804ff9:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  804ffc:	90                   	nop
  804ffd:	c9                   	leave  
  804ffe:	c3                   	ret    

00804fff <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  804fff:	55                   	push   %ebp
  805000:	89 e5                	mov    %esp,%ebp
  805002:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  805005:	83 ec 04             	sub    $0x4,%esp
  805008:	68 ac 62 80 00       	push   $0x8062ac
  80500d:	68 01 01 00 00       	push   $0x101
  805012:	68 b3 61 80 00       	push   $0x8061b3
  805017:	e8 d4 c4 ff ff       	call   8014f0 <_panic>

0080501c <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  80501c:	55                   	push   %ebp
  80501d:	89 e5                	mov    %esp,%ebp
  80501f:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  805022:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  805026:	74 1c                	je     805044 <init_uspinlock+0x28>
  805028:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  80502c:	74 16                	je     805044 <init_uspinlock+0x28>
  80502e:	68 d0 62 80 00       	push   $0x8062d0
  805033:	68 ef 62 80 00       	push   $0x8062ef
  805038:	6a 10                	push   $0x10
  80503a:	68 04 63 80 00       	push   $0x806304
  80503f:	e8 ac c4 ff ff       	call   8014f0 <_panic>
	strcpy(lk->name, name);
  805044:	8b 45 08             	mov    0x8(%ebp),%eax
  805047:	83 c0 04             	add    $0x4,%eax
  80504a:	83 ec 08             	sub    $0x8,%esp
  80504d:	ff 75 0c             	pushl  0xc(%ebp)
  805050:	50                   	push   %eax
  805051:	e8 90 ce ff ff       	call   801ee6 <strcpy>
  805056:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  805059:	b8 01 00 00 00       	mov    $0x1,%eax
  80505e:	2b 45 10             	sub    0x10(%ebp),%eax
  805061:	89 c2                	mov    %eax,%edx
  805063:	8b 45 08             	mov    0x8(%ebp),%eax
  805066:	89 10                	mov    %edx,(%eax)
}
  805068:	90                   	nop
  805069:	c9                   	leave  
  80506a:	c3                   	ret    

0080506b <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  80506b:	55                   	push   %ebp
  80506c:	89 e5                	mov    %esp,%ebp
  80506e:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  805071:	90                   	nop
  805072:	8b 45 08             	mov    0x8(%ebp),%eax
  805075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  805078:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80507f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  805082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805085:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  805088:	f0 87 02             	lock xchg %eax,(%edx)
  80508b:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  80508e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  805091:	85 c0                	test   %eax,%eax
  805093:	75 dd                	jne    805072 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  805095:	8b 45 08             	mov    0x8(%ebp),%eax
  805098:	8d 48 04             	lea    0x4(%eax),%ecx
  80509b:	a1 00 72 80 00       	mov    0x807200,%eax
  8050a0:	8d 50 20             	lea    0x20(%eax),%edx
  8050a3:	a1 00 72 80 00       	mov    0x807200,%eax
  8050a8:	8b 40 10             	mov    0x10(%eax),%eax
  8050ab:	51                   	push   %ecx
  8050ac:	52                   	push   %edx
  8050ad:	50                   	push   %eax
  8050ae:	68 14 63 80 00       	push   $0x806314
  8050b3:	e8 06 c7 ff ff       	call   8017be <cprintf>
  8050b8:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8050bb:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8050c0:	90                   	nop
  8050c1:	c9                   	leave  
  8050c2:	c3                   	ret    

008050c3 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8050c3:	55                   	push   %ebp
  8050c4:	89 e5                	mov    %esp,%ebp
  8050c6:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  8050c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8050cc:	8b 00                	mov    (%eax),%eax
  8050ce:	85 c0                	test   %eax,%eax
  8050d0:	75 18                	jne    8050ea <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  8050d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8050d5:	83 c0 04             	add    $0x4,%eax
  8050d8:	50                   	push   %eax
  8050d9:	68 38 63 80 00       	push   $0x806338
  8050de:	6a 2b                	push   $0x2b
  8050e0:	68 04 63 80 00       	push   $0x806304
  8050e5:	e8 06 c4 ff ff       	call   8014f0 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8050ea:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8050ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8050f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8050f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8050fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8050fe:	8d 48 04             	lea    0x4(%eax),%ecx
  805101:	a1 00 72 80 00       	mov    0x807200,%eax
  805106:	8d 50 20             	lea    0x20(%eax),%edx
  805109:	a1 00 72 80 00       	mov    0x807200,%eax
  80510e:	8b 40 10             	mov    0x10(%eax),%eax
  805111:	51                   	push   %ecx
  805112:	52                   	push   %edx
  805113:	50                   	push   %eax
  805114:	68 58 63 80 00       	push   $0x806358
  805119:	e8 a0 c6 ff ff       	call   8017be <cprintf>
  80511e:	83 c4 10             	add    $0x10,%esp
}
  805121:	90                   	nop
  805122:	c9                   	leave  
  805123:	c3                   	ret    

00805124 <__udivdi3>:
  805124:	55                   	push   %ebp
  805125:	57                   	push   %edi
  805126:	56                   	push   %esi
  805127:	53                   	push   %ebx
  805128:	83 ec 1c             	sub    $0x1c,%esp
  80512b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80512f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  805133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  805137:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80513b:	89 ca                	mov    %ecx,%edx
  80513d:	89 f8                	mov    %edi,%eax
  80513f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  805143:	85 f6                	test   %esi,%esi
  805145:	75 2d                	jne    805174 <__udivdi3+0x50>
  805147:	39 cf                	cmp    %ecx,%edi
  805149:	77 65                	ja     8051b0 <__udivdi3+0x8c>
  80514b:	89 fd                	mov    %edi,%ebp
  80514d:	85 ff                	test   %edi,%edi
  80514f:	75 0b                	jne    80515c <__udivdi3+0x38>
  805151:	b8 01 00 00 00       	mov    $0x1,%eax
  805156:	31 d2                	xor    %edx,%edx
  805158:	f7 f7                	div    %edi
  80515a:	89 c5                	mov    %eax,%ebp
  80515c:	31 d2                	xor    %edx,%edx
  80515e:	89 c8                	mov    %ecx,%eax
  805160:	f7 f5                	div    %ebp
  805162:	89 c1                	mov    %eax,%ecx
  805164:	89 d8                	mov    %ebx,%eax
  805166:	f7 f5                	div    %ebp
  805168:	89 cf                	mov    %ecx,%edi
  80516a:	89 fa                	mov    %edi,%edx
  80516c:	83 c4 1c             	add    $0x1c,%esp
  80516f:	5b                   	pop    %ebx
  805170:	5e                   	pop    %esi
  805171:	5f                   	pop    %edi
  805172:	5d                   	pop    %ebp
  805173:	c3                   	ret    
  805174:	39 ce                	cmp    %ecx,%esi
  805176:	77 28                	ja     8051a0 <__udivdi3+0x7c>
  805178:	0f bd fe             	bsr    %esi,%edi
  80517b:	83 f7 1f             	xor    $0x1f,%edi
  80517e:	75 40                	jne    8051c0 <__udivdi3+0x9c>
  805180:	39 ce                	cmp    %ecx,%esi
  805182:	72 0a                	jb     80518e <__udivdi3+0x6a>
  805184:	3b 44 24 08          	cmp    0x8(%esp),%eax
  805188:	0f 87 9e 00 00 00    	ja     80522c <__udivdi3+0x108>
  80518e:	b8 01 00 00 00       	mov    $0x1,%eax
  805193:	89 fa                	mov    %edi,%edx
  805195:	83 c4 1c             	add    $0x1c,%esp
  805198:	5b                   	pop    %ebx
  805199:	5e                   	pop    %esi
  80519a:	5f                   	pop    %edi
  80519b:	5d                   	pop    %ebp
  80519c:	c3                   	ret    
  80519d:	8d 76 00             	lea    0x0(%esi),%esi
  8051a0:	31 ff                	xor    %edi,%edi
  8051a2:	31 c0                	xor    %eax,%eax
  8051a4:	89 fa                	mov    %edi,%edx
  8051a6:	83 c4 1c             	add    $0x1c,%esp
  8051a9:	5b                   	pop    %ebx
  8051aa:	5e                   	pop    %esi
  8051ab:	5f                   	pop    %edi
  8051ac:	5d                   	pop    %ebp
  8051ad:	c3                   	ret    
  8051ae:	66 90                	xchg   %ax,%ax
  8051b0:	89 d8                	mov    %ebx,%eax
  8051b2:	f7 f7                	div    %edi
  8051b4:	31 ff                	xor    %edi,%edi
  8051b6:	89 fa                	mov    %edi,%edx
  8051b8:	83 c4 1c             	add    $0x1c,%esp
  8051bb:	5b                   	pop    %ebx
  8051bc:	5e                   	pop    %esi
  8051bd:	5f                   	pop    %edi
  8051be:	5d                   	pop    %ebp
  8051bf:	c3                   	ret    
  8051c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8051c5:	89 eb                	mov    %ebp,%ebx
  8051c7:	29 fb                	sub    %edi,%ebx
  8051c9:	89 f9                	mov    %edi,%ecx
  8051cb:	d3 e6                	shl    %cl,%esi
  8051cd:	89 c5                	mov    %eax,%ebp
  8051cf:	88 d9                	mov    %bl,%cl
  8051d1:	d3 ed                	shr    %cl,%ebp
  8051d3:	89 e9                	mov    %ebp,%ecx
  8051d5:	09 f1                	or     %esi,%ecx
  8051d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8051db:	89 f9                	mov    %edi,%ecx
  8051dd:	d3 e0                	shl    %cl,%eax
  8051df:	89 c5                	mov    %eax,%ebp
  8051e1:	89 d6                	mov    %edx,%esi
  8051e3:	88 d9                	mov    %bl,%cl
  8051e5:	d3 ee                	shr    %cl,%esi
  8051e7:	89 f9                	mov    %edi,%ecx
  8051e9:	d3 e2                	shl    %cl,%edx
  8051eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8051ef:	88 d9                	mov    %bl,%cl
  8051f1:	d3 e8                	shr    %cl,%eax
  8051f3:	09 c2                	or     %eax,%edx
  8051f5:	89 d0                	mov    %edx,%eax
  8051f7:	89 f2                	mov    %esi,%edx
  8051f9:	f7 74 24 0c          	divl   0xc(%esp)
  8051fd:	89 d6                	mov    %edx,%esi
  8051ff:	89 c3                	mov    %eax,%ebx
  805201:	f7 e5                	mul    %ebp
  805203:	39 d6                	cmp    %edx,%esi
  805205:	72 19                	jb     805220 <__udivdi3+0xfc>
  805207:	74 0b                	je     805214 <__udivdi3+0xf0>
  805209:	89 d8                	mov    %ebx,%eax
  80520b:	31 ff                	xor    %edi,%edi
  80520d:	e9 58 ff ff ff       	jmp    80516a <__udivdi3+0x46>
  805212:	66 90                	xchg   %ax,%ax
  805214:	8b 54 24 08          	mov    0x8(%esp),%edx
  805218:	89 f9                	mov    %edi,%ecx
  80521a:	d3 e2                	shl    %cl,%edx
  80521c:	39 c2                	cmp    %eax,%edx
  80521e:	73 e9                	jae    805209 <__udivdi3+0xe5>
  805220:	8d 43 ff             	lea    -0x1(%ebx),%eax
  805223:	31 ff                	xor    %edi,%edi
  805225:	e9 40 ff ff ff       	jmp    80516a <__udivdi3+0x46>
  80522a:	66 90                	xchg   %ax,%ax
  80522c:	31 c0                	xor    %eax,%eax
  80522e:	e9 37 ff ff ff       	jmp    80516a <__udivdi3+0x46>
  805233:	90                   	nop

00805234 <__umoddi3>:
  805234:	55                   	push   %ebp
  805235:	57                   	push   %edi
  805236:	56                   	push   %esi
  805237:	53                   	push   %ebx
  805238:	83 ec 1c             	sub    $0x1c,%esp
  80523b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80523f:	8b 74 24 34          	mov    0x34(%esp),%esi
  805243:	8b 7c 24 38          	mov    0x38(%esp),%edi
  805247:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80524b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80524f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  805253:	89 f3                	mov    %esi,%ebx
  805255:	89 fa                	mov    %edi,%edx
  805257:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80525b:	89 34 24             	mov    %esi,(%esp)
  80525e:	85 c0                	test   %eax,%eax
  805260:	75 1a                	jne    80527c <__umoddi3+0x48>
  805262:	39 f7                	cmp    %esi,%edi
  805264:	0f 86 a2 00 00 00    	jbe    80530c <__umoddi3+0xd8>
  80526a:	89 c8                	mov    %ecx,%eax
  80526c:	89 f2                	mov    %esi,%edx
  80526e:	f7 f7                	div    %edi
  805270:	89 d0                	mov    %edx,%eax
  805272:	31 d2                	xor    %edx,%edx
  805274:	83 c4 1c             	add    $0x1c,%esp
  805277:	5b                   	pop    %ebx
  805278:	5e                   	pop    %esi
  805279:	5f                   	pop    %edi
  80527a:	5d                   	pop    %ebp
  80527b:	c3                   	ret    
  80527c:	39 f0                	cmp    %esi,%eax
  80527e:	0f 87 ac 00 00 00    	ja     805330 <__umoddi3+0xfc>
  805284:	0f bd e8             	bsr    %eax,%ebp
  805287:	83 f5 1f             	xor    $0x1f,%ebp
  80528a:	0f 84 ac 00 00 00    	je     80533c <__umoddi3+0x108>
  805290:	bf 20 00 00 00       	mov    $0x20,%edi
  805295:	29 ef                	sub    %ebp,%edi
  805297:	89 fe                	mov    %edi,%esi
  805299:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80529d:	89 e9                	mov    %ebp,%ecx
  80529f:	d3 e0                	shl    %cl,%eax
  8052a1:	89 d7                	mov    %edx,%edi
  8052a3:	89 f1                	mov    %esi,%ecx
  8052a5:	d3 ef                	shr    %cl,%edi
  8052a7:	09 c7                	or     %eax,%edi
  8052a9:	89 e9                	mov    %ebp,%ecx
  8052ab:	d3 e2                	shl    %cl,%edx
  8052ad:	89 14 24             	mov    %edx,(%esp)
  8052b0:	89 d8                	mov    %ebx,%eax
  8052b2:	d3 e0                	shl    %cl,%eax
  8052b4:	89 c2                	mov    %eax,%edx
  8052b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8052ba:	d3 e0                	shl    %cl,%eax
  8052bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8052c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8052c4:	89 f1                	mov    %esi,%ecx
  8052c6:	d3 e8                	shr    %cl,%eax
  8052c8:	09 d0                	or     %edx,%eax
  8052ca:	d3 eb                	shr    %cl,%ebx
  8052cc:	89 da                	mov    %ebx,%edx
  8052ce:	f7 f7                	div    %edi
  8052d0:	89 d3                	mov    %edx,%ebx
  8052d2:	f7 24 24             	mull   (%esp)
  8052d5:	89 c6                	mov    %eax,%esi
  8052d7:	89 d1                	mov    %edx,%ecx
  8052d9:	39 d3                	cmp    %edx,%ebx
  8052db:	0f 82 87 00 00 00    	jb     805368 <__umoddi3+0x134>
  8052e1:	0f 84 91 00 00 00    	je     805378 <__umoddi3+0x144>
  8052e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8052eb:	29 f2                	sub    %esi,%edx
  8052ed:	19 cb                	sbb    %ecx,%ebx
  8052ef:	89 d8                	mov    %ebx,%eax
  8052f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8052f5:	d3 e0                	shl    %cl,%eax
  8052f7:	89 e9                	mov    %ebp,%ecx
  8052f9:	d3 ea                	shr    %cl,%edx
  8052fb:	09 d0                	or     %edx,%eax
  8052fd:	89 e9                	mov    %ebp,%ecx
  8052ff:	d3 eb                	shr    %cl,%ebx
  805301:	89 da                	mov    %ebx,%edx
  805303:	83 c4 1c             	add    $0x1c,%esp
  805306:	5b                   	pop    %ebx
  805307:	5e                   	pop    %esi
  805308:	5f                   	pop    %edi
  805309:	5d                   	pop    %ebp
  80530a:	c3                   	ret    
  80530b:	90                   	nop
  80530c:	89 fd                	mov    %edi,%ebp
  80530e:	85 ff                	test   %edi,%edi
  805310:	75 0b                	jne    80531d <__umoddi3+0xe9>
  805312:	b8 01 00 00 00       	mov    $0x1,%eax
  805317:	31 d2                	xor    %edx,%edx
  805319:	f7 f7                	div    %edi
  80531b:	89 c5                	mov    %eax,%ebp
  80531d:	89 f0                	mov    %esi,%eax
  80531f:	31 d2                	xor    %edx,%edx
  805321:	f7 f5                	div    %ebp
  805323:	89 c8                	mov    %ecx,%eax
  805325:	f7 f5                	div    %ebp
  805327:	89 d0                	mov    %edx,%eax
  805329:	e9 44 ff ff ff       	jmp    805272 <__umoddi3+0x3e>
  80532e:	66 90                	xchg   %ax,%ax
  805330:	89 c8                	mov    %ecx,%eax
  805332:	89 f2                	mov    %esi,%edx
  805334:	83 c4 1c             	add    $0x1c,%esp
  805337:	5b                   	pop    %ebx
  805338:	5e                   	pop    %esi
  805339:	5f                   	pop    %edi
  80533a:	5d                   	pop    %ebp
  80533b:	c3                   	ret    
  80533c:	3b 04 24             	cmp    (%esp),%eax
  80533f:	72 06                	jb     805347 <__umoddi3+0x113>
  805341:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  805345:	77 0f                	ja     805356 <__umoddi3+0x122>
  805347:	89 f2                	mov    %esi,%edx
  805349:	29 f9                	sub    %edi,%ecx
  80534b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80534f:	89 14 24             	mov    %edx,(%esp)
  805352:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  805356:	8b 44 24 04          	mov    0x4(%esp),%eax
  80535a:	8b 14 24             	mov    (%esp),%edx
  80535d:	83 c4 1c             	add    $0x1c,%esp
  805360:	5b                   	pop    %ebx
  805361:	5e                   	pop    %esi
  805362:	5f                   	pop    %edi
  805363:	5d                   	pop    %ebp
  805364:	c3                   	ret    
  805365:	8d 76 00             	lea    0x0(%esi),%esi
  805368:	2b 04 24             	sub    (%esp),%eax
  80536b:	19 fa                	sbb    %edi,%edx
  80536d:	89 d1                	mov    %edx,%ecx
  80536f:	89 c6                	mov    %eax,%esi
  805371:	e9 71 ff ff ff       	jmp    8052e7 <__umoddi3+0xb3>
  805376:	66 90                	xchg   %ax,%ax
  805378:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80537c:	72 ea                	jb     805368 <__umoddi3+0x134>
  80537e:	89 d9                	mov    %ebx,%ecx
  805380:	e9 62 ff ff ff       	jmp    8052e7 <__umoddi3+0xb3>
