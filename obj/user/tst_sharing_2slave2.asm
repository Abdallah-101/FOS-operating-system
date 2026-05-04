
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 80 13 00 00       	call   8013b6 <libmain>
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
  800067:	e8 3c 41 00 00       	call   8041a8 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 7f 41 00 00       	call   8041f3 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 8f 27 00 00       	call   802856 <malloc>
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
  8000df:	e8 c4 40 00 00       	call   8041a8 <sys_calculate_free_frames>
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
  800125:	68 20 54 80 00       	push   $0x805420
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 39 17 00 00       	call   80186a <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 ba 40 00 00       	call   8041f3 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 9c 54 80 00       	push   $0x80549c
  800150:	6a 0c                	push   $0xc
  800152:	e8 13 17 00 00       	call   80186a <cprintf_colored>
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
  800174:	e8 2f 40 00 00       	call   8041a8 <sys_calculate_free_frames>
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
  8001b9:	e8 ea 3f 00 00       	call   8041a8 <sys_calculate_free_frames>
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
  8001f8:	68 14 55 80 00       	push   $0x805514
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 66 16 00 00       	call   80186a <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 e7 3f 00 00       	call   8041f3 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 a0 55 80 00       	push   $0x8055a0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 39 16 00 00       	call   80186a <cprintf_colored>
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
  800270:	e8 f5 42 00 00       	call   80456a <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 18 56 80 00       	push   $0x805618
  80028f:	6a 0c                	push   $0xc
  800291:	e8 d4 15 00 00       	call   80186a <cprintf_colored>
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
  8002ae:	e8 f5 3e 00 00       	call   8041a8 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 38 3f 00 00       	call   8041f3 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 83 2a 00 00       	call   802d54 <free>
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
  8002fc:	e8 f2 3e 00 00       	call   8041f3 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 50 56 80 00       	push   $0x805650
  800318:	6a 0c                	push   $0xc
  80031a:	e8 4b 15 00 00       	call   80186a <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 81 3e 00 00       	call   8041a8 <sys_calculate_free_frames>
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
  800342:	68 9c 56 80 00       	push   $0x80569c
  800347:	6a 0c                	push   $0xc
  800349:	e8 1c 15 00 00       	call   80186a <cprintf_colored>
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
  8003a0:	e8 c5 41 00 00       	call   80456a <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 f8 56 80 00       	push   $0x8056f8
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 a4 14 00 00       	call   80186a <cprintf_colored>
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
  800416:	68 30 57 80 00       	push   $0x805730
  80041b:	6a 03                	push   $0x3
  80041d:	e8 48 14 00 00       	call   80186a <cprintf_colored>
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
  8004df:	68 60 57 80 00       	push   $0x805760
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 7f 13 00 00       	call   80186a <cprintf_colored>
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
  8005b9:	68 60 57 80 00       	push   $0x805760
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 a5 12 00 00       	call   80186a <cprintf_colored>
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
  800693:	68 60 57 80 00       	push   $0x805760
  800698:	6a 0c                	push   $0xc
  80069a:	e8 cb 11 00 00       	call   80186a <cprintf_colored>
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
  80076d:	68 60 57 80 00       	push   $0x805760
  800772:	6a 0c                	push   $0xc
  800774:	e8 f1 10 00 00       	call   80186a <cprintf_colored>
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
  800847:	68 60 57 80 00       	push   $0x805760
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 17 10 00 00       	call   80186a <cprintf_colored>
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
  800921:	68 60 57 80 00       	push   $0x805760
  800926:	6a 0c                	push   $0xc
  800928:	e8 3d 0f 00 00       	call   80186a <cprintf_colored>
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
  800a16:	68 60 57 80 00       	push   $0x805760
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 48 0e 00 00       	call   80186a <cprintf_colored>
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
  800b14:	68 60 57 80 00       	push   $0x805760
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 4a 0d 00 00       	call   80186a <cprintf_colored>
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
  800c12:	68 60 57 80 00       	push   $0x805760
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 4c 0c 00 00       	call   80186a <cprintf_colored>
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
  800d10:	68 60 57 80 00       	push   $0x805760
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 4e 0b 00 00       	call   80186a <cprintf_colored>
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
  800dfd:	68 60 57 80 00       	push   $0x805760
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 61 0a 00 00       	call   80186a <cprintf_colored>
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
  800eea:	68 60 57 80 00       	push   $0x805760
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 74 09 00 00       	call   80186a <cprintf_colored>
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
  800fd7:	68 60 57 80 00       	push   $0x805760
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 87 08 00 00       	call   80186a <cprintf_colored>
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
  800ffa:	68 b2 57 80 00       	push   $0x8057b2
  800fff:	6a 03                	push   $0x3
  801001:	e8 64 08 00 00       	call   80186a <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 89 31 00 00       	call   8041a8 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 c9 31 00 00       	call   8041f3 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 fc 17 00 00       	call   802856 <malloc>
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
  801084:	68 d0 57 80 00       	push   $0x8057d0
  801089:	6a 0c                	push   $0xc
  80108b:	e8 da 07 00 00       	call   80186a <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 5b 31 00 00       	call   8041f3 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 0c 58 80 00       	push   $0x80580c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 ae 07 00 00       	call   80186a <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 e4 30 00 00       	call   8041a8 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 7c 58 80 00       	push   $0x80587c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 82 07 00 00       	call   80186a <cprintf_colored>
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
#include <user/tst_malloc_helpers.h>
extern volatile bool printStats;

void
_main(void)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	83 ec 30             	sub    $0x30,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801107:	a1 00 72 80 00       	mov    0x807200,%eax
  80110c:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801112:	a1 00 72 80 00       	mov    0x807200,%eax
  801117:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80111d:	39 c2                	cmp    %eax,%edx
  80111f:	72 14                	jb     801135 <_main+0x36>
			panic("Please increase the WS size");
  801121:	83 ec 04             	sub    $0x4,%esp
  801124:	68 c4 58 80 00       	push   $0x8058c4
  801129:	6a 0f                	push   $0xf
  80112b:	68 e0 58 80 00       	push   $0x8058e0
  801130:	e8 3a 04 00 00       	call   80156f <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801135:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  80113c:	e8 49 32 00 00       	call   80438a <sys_getparentenvid>
  801141:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int diff, expected;
	int freeFrames, usedDiskPages ;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_lock_cons();
  801144:	e8 af 2f 00 00       	call   8040f8 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  801149:	e8 5a 30 00 00       	call   8041a8 <sys_calculate_free_frames>
  80114e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801151:	e8 9d 30 00 00       	call   8041f3 <sys_pf_calculate_allocated_pages>
  801156:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = sget(parentenvID,"z");
  801159:	83 ec 08             	sub    $0x8,%esp
  80115c:	68 fb 58 80 00       	push   $0x8058fb
  801161:	ff 75 f0             	pushl  -0x10(%ebp)
  801164:	e8 22 29 00 00       	call   803a8b <sget>
  801169:	83 c4 10             	add    $0x10,%esp
  80116c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  80116f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801172:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  801175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801178:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80117b:	74 1a                	je     801197 <_main+0x98>
  80117d:	83 ec 0c             	sub    $0xc,%esp
  801180:	ff 75 e4             	pushl  -0x1c(%ebp)
  801183:	ff 75 e0             	pushl  -0x20(%ebp)
  801186:	68 00 59 80 00       	push   $0x805900
  80118b:	6a 26                	push   $0x26
  80118d:	68 e0 58 80 00       	push   $0x8058e0
  801192:	e8 d8 03 00 00       	call   80156f <_panic>
		expected = 1 ; /* 1 table in UH*/
  801197:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80119e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8011a1:	e8 02 30 00 00       	call   8041a8 <sys_calculate_free_frames>
  8011a6:	29 c3                	sub    %eax,%ebx
  8011a8:	89 d8                	mov    %ebx,%eax
  8011aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (!inRange(diff, expected, expected + 2 /*UH Block Alloc: max of 1 page & 1 table*/))
  8011ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011b0:	83 c0 02             	add    $0x2,%eax
  8011b3:	83 ec 04             	sub    $0x4,%esp
  8011b6:	50                   	push   %eax
  8011b7:	ff 75 dc             	pushl  -0x24(%ebp)
  8011ba:	ff 75 d8             	pushl  -0x28(%ebp)
  8011bd:	e8 76 ee ff ff       	call   800038 <inRange>
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	75 2b                	jne    8011f4 <_main+0xf5>
			panic("Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expected +2);
  8011c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011cc:	8d 58 02             	lea    0x2(%eax),%ebx
  8011cf:	8b 75 ec             	mov    -0x14(%ebp),%esi
  8011d2:	e8 d1 2f 00 00       	call   8041a8 <sys_calculate_free_frames>
  8011d7:	29 c6                	sub    %eax,%esi
  8011d9:	89 f0                	mov    %esi,%eax
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	53                   	push   %ebx
  8011df:	ff 75 dc             	pushl  -0x24(%ebp)
  8011e2:	50                   	push   %eax
  8011e3:	68 7c 59 80 00       	push   $0x80597c
  8011e8:	6a 2a                	push   $0x2a
  8011ea:	68 e0 58 80 00       	push   $0x8058e0
  8011ef:	e8 7b 03 00 00       	call   80156f <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8011f4:	e8 fa 2f 00 00       	call   8041f3 <sys_pf_calculate_allocated_pages>
  8011f9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8011fc:	74 14                	je     801212 <_main+0x113>
		{panic("Wrong page file allocation: ");}
  8011fe:	83 ec 04             	sub    $0x4,%esp
  801201:	68 1a 5a 80 00       	push   $0x805a1a
  801206:	6a 2c                	push   $0x2c
  801208:	68 e0 58 80 00       	push   $0x8058e0
  80120d:	e8 5d 03 00 00       	call   80156f <_panic>
	}
	sys_unlock_cons();
  801212:	e8 fb 2e 00 00       	call   804112 <sys_unlock_cons>

	sys_lock_cons();
  801217:	e8 dc 2e 00 00       	call   8040f8 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  80121c:	e8 87 2f 00 00       	call   8041a8 <sys_calculate_free_frames>
  801221:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801224:	e8 ca 2f 00 00       	call   8041f3 <sys_pf_calculate_allocated_pages>
  801229:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = sget(parentenvID,"x");
  80122c:	83 ec 08             	sub    $0x8,%esp
  80122f:	68 37 5a 80 00       	push   $0x805a37
  801234:	ff 75 f0             	pushl  -0x10(%ebp)
  801237:	e8 4f 28 00 00       	call   803a8b <sget>
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  801242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801245:	05 00 10 00 00       	add    $0x1000,%eax
  80124a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  80124d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801250:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801253:	74 1a                	je     80126f <_main+0x170>
  801255:	83 ec 0c             	sub    $0xc,%esp
  801258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80125b:	ff 75 e0             	pushl  -0x20(%ebp)
  80125e:	68 00 59 80 00       	push   $0x805900
  801263:	6a 36                	push   $0x36
  801265:	68 e0 58 80 00       	push   $0x8058e0
  80126a:	e8 00 03 00 00       	call   80156f <_panic>
		expected = 0;
  80126f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  801276:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  801279:	e8 2a 2f 00 00       	call   8041a8 <sys_calculate_free_frames>
  80127e:	29 c3                	sub    %eax,%ebx
  801280:	89 d8                	mov    %ebx,%eax
  801282:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  801285:	83 ec 04             	sub    $0x4,%esp
  801288:	ff 75 dc             	pushl  -0x24(%ebp)
  80128b:	ff 75 dc             	pushl  -0x24(%ebp)
  80128e:	ff 75 d8             	pushl  -0x28(%ebp)
  801291:	e8 a2 ed ff ff       	call   800038 <inRange>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	75 24                	jne    8012c1 <_main+0x1c2>
			panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  80129d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8012a0:	e8 03 2f 00 00       	call   8041a8 <sys_calculate_free_frames>
  8012a5:	29 c3                	sub    %eax,%ebx
  8012a7:	89 d8                	mov    %ebx,%eax
  8012a9:	83 ec 0c             	sub    $0xc,%esp
  8012ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8012af:	50                   	push   %eax
  8012b0:	68 3c 5a 80 00       	push   $0x805a3c
  8012b5:	6a 3a                	push   $0x3a
  8012b7:	68 e0 58 80 00       	push   $0x8058e0
  8012bc:	e8 ae 02 00 00       	call   80156f <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8012c1:	e8 2d 2f 00 00       	call   8041f3 <sys_pf_calculate_allocated_pages>
  8012c6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8012c9:	74 14                	je     8012df <_main+0x1e0>
		{panic("Wrong page file allocation: ");}
  8012cb:	83 ec 04             	sub    $0x4,%esp
  8012ce:	68 1a 5a 80 00       	push   $0x805a1a
  8012d3:	6a 3c                	push   $0x3c
  8012d5:	68 e0 58 80 00       	push   $0x8058e0
  8012da:	e8 90 02 00 00       	call   80156f <_panic>
	}
	sys_unlock_cons();
  8012df:	e8 2e 2e 00 00       	call   804112 <sys_unlock_cons>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8012e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	83 f8 0a             	cmp    $0xa,%eax
  8012ec:	74 14                	je     801302 <_main+0x203>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 d4 5a 80 00       	push   $0x805ad4
  8012f6:	6a 40                	push   $0x40
  8012f8:	68 e0 58 80 00       	push   $0x8058e0
  8012fd:	e8 6d 02 00 00       	call   80156f <_panic>

	//Edit the writable object
	*z = 50;
  801302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801305:	c7 00 32 00 00 00    	movl   $0x32,(%eax)
	if (*z != 50) panic("Get(): Shared Variable is not created or got correctly") ;
  80130b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80130e:	8b 00                	mov    (%eax),%eax
  801310:	83 f8 32             	cmp    $0x32,%eax
  801313:	74 14                	je     801329 <_main+0x22a>
  801315:	83 ec 04             	sub    $0x4,%esp
  801318:	68 d4 5a 80 00       	push   $0x805ad4
  80131d:	6a 44                	push   $0x44
  80131f:	68 e0 58 80 00       	push   $0x8058e0
  801324:	e8 46 02 00 00       	call   80156f <_panic>

	inctst();
  801329:	e8 81 31 00 00       	call   8044af <inctst>

	//sync with master
	while (gettst() != 5) ;
  80132e:	90                   	nop
  80132f:	e8 95 31 00 00       	call   8044c9 <gettst>
  801334:	83 f8 05             	cmp    $0x5,%eax
  801337:	75 f6                	jne    80132f <_main+0x230>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  801339:	83 ec 0c             	sub    $0xc,%esp
  80133c:	6a 06                	push   $0x6
  80133e:	e8 e6 30 00 00       	call   804429 <sys_bypassPageFault>
  801343:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 d4             	pushl  -0x2c(%ebp)
  80134c:	68 0c 5b 80 00       	push   $0x805b0c
  801351:	e8 59 05 00 00       	call   8018af <atomic_cprintf>
  801356:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  801359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80135c:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  801362:	83 ec 0c             	sub    $0xc,%esp
  801365:	6a 00                	push   $0x0
  801367:	e8 bd 30 00 00       	call   804429 <sys_bypassPageFault>
  80136c:	83 c4 10             	add    $0x10,%esp

	inctst();
  80136f:	e8 3b 31 00 00       	call   8044af <inctst>
	if (*x == 100)
  801374:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801377:	8b 00                	mov    (%eax),%eax
  801379:	83 f8 64             	cmp    $0x64,%eax
  80137c:	75 14                	jne    801392 <_main+0x293>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	68 3c 5b 80 00       	push   $0x805b3c
  801386:	6a 54                	push   $0x54
  801388:	68 e0 58 80 00       	push   $0x8058e0
  80138d:	e8 dd 01 00 00       	call   80156f <_panic>

	cprintf_colored(TEXT_green, "Slave2 completed.\n");
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	68 83 5b 80 00       	push   $0x805b83
  80139a:	6a 02                	push   $0x2
  80139c:	e8 c9 04 00 00       	call   80186a <cprintf_colored>
  8013a1:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  8013a4:	c7 05 00 70 80 00 00 	movl   $0x0,0x807000
  8013ab:	00 00 00 

	return;
  8013ae:	90                   	nop
}
  8013af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b2:	5b                   	pop    %ebx
  8013b3:	5e                   	pop    %esi
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    

008013b6 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	57                   	push   %edi
  8013ba:	56                   	push   %esi
  8013bb:	53                   	push   %ebx
  8013bc:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8013bf:	e8 ad 2f 00 00       	call   804371 <sys_getenvindex>
  8013c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8013c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ca:	89 d0                	mov    %edx,%eax
  8013cc:	c1 e0 02             	shl    $0x2,%eax
  8013cf:	01 d0                	add    %edx,%eax
  8013d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d8:	01 d0                	add    %edx,%eax
  8013da:	89 c2                	mov    %eax,%edx
  8013dc:	c1 e2 04             	shl    $0x4,%edx
  8013df:	29 c2                	sub    %eax,%edx
  8013e1:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8013e8:	89 c2                	mov    %eax,%edx
  8013ea:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8013f0:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8013f5:	a1 00 72 80 00       	mov    0x807200,%eax
  8013fa:	8a 40 20             	mov    0x20(%eax),%al
  8013fd:	84 c0                	test   %al,%al
  8013ff:	74 0d                	je     80140e <libmain+0x58>
		binaryname = myEnv->prog_name;
  801401:	a1 00 72 80 00       	mov    0x807200,%eax
  801406:	83 c0 20             	add    $0x20,%eax
  801409:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80140e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801412:	7e 0a                	jle    80141e <libmain+0x68>
		binaryname = argv[0];
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	8b 00                	mov    (%eax),%eax
  801419:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  80141e:	83 ec 08             	sub    $0x8,%esp
  801421:	ff 75 0c             	pushl  0xc(%ebp)
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 d3 fc ff ff       	call   8010ff <_main>
  80142c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80142f:	a1 00 70 80 00       	mov    0x807000,%eax
  801434:	85 c0                	test   %eax,%eax
  801436:	0f 84 01 01 00 00    	je     80153d <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80143c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801442:	bb 90 5c 80 00       	mov    $0x805c90,%ebx
  801447:	ba 0e 00 00 00       	mov    $0xe,%edx
  80144c:	89 c7                	mov    %eax,%edi
  80144e:	89 de                	mov    %ebx,%esi
  801450:	89 d1                	mov    %edx,%ecx
  801452:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801454:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801457:	b9 56 00 00 00       	mov    $0x56,%ecx
  80145c:	b0 00                	mov    $0x0,%al
  80145e:	89 d7                	mov    %edx,%edi
  801460:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801462:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801469:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80146c:	83 ec 08             	sub    $0x8,%esp
  80146f:	50                   	push   %eax
  801470:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801476:	50                   	push   %eax
  801477:	e8 2b 31 00 00       	call   8045a7 <sys_utilities>
  80147c:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80147f:	e8 74 2c 00 00       	call   8040f8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801484:	83 ec 0c             	sub    $0xc,%esp
  801487:	68 b0 5b 80 00       	push   $0x805bb0
  80148c:	e8 ac 03 00 00       	call   80183d <cprintf>
  801491:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801497:	85 c0                	test   %eax,%eax
  801499:	74 18                	je     8014b3 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80149b:	e8 25 31 00 00       	call   8045c5 <sys_get_optimal_num_faults>
  8014a0:	83 ec 08             	sub    $0x8,%esp
  8014a3:	50                   	push   %eax
  8014a4:	68 d8 5b 80 00       	push   $0x805bd8
  8014a9:	e8 8f 03 00 00       	call   80183d <cprintf>
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	eb 59                	jmp    80150c <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014b3:	a1 00 72 80 00       	mov    0x807200,%eax
  8014b8:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8014be:	a1 00 72 80 00       	mov    0x807200,%eax
  8014c3:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	52                   	push   %edx
  8014cd:	50                   	push   %eax
  8014ce:	68 fc 5b 80 00       	push   $0x805bfc
  8014d3:	e8 65 03 00 00       	call   80183d <cprintf>
  8014d8:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8014db:	a1 00 72 80 00       	mov    0x807200,%eax
  8014e0:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8014e6:	a1 00 72 80 00       	mov    0x807200,%eax
  8014eb:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8014f1:	a1 00 72 80 00       	mov    0x807200,%eax
  8014f6:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8014fc:	51                   	push   %ecx
  8014fd:	52                   	push   %edx
  8014fe:	50                   	push   %eax
  8014ff:	68 24 5c 80 00       	push   $0x805c24
  801504:	e8 34 03 00 00       	call   80183d <cprintf>
  801509:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80150c:	a1 00 72 80 00       	mov    0x807200,%eax
  801511:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  801517:	83 ec 08             	sub    $0x8,%esp
  80151a:	50                   	push   %eax
  80151b:	68 7c 5c 80 00       	push   $0x805c7c
  801520:	e8 18 03 00 00       	call   80183d <cprintf>
  801525:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	68 b0 5b 80 00       	push   $0x805bb0
  801530:	e8 08 03 00 00       	call   80183d <cprintf>
  801535:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801538:	e8 d5 2b 00 00       	call   804112 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80153d:	e8 1f 00 00 00       	call   801561 <exit>
}
  801542:	90                   	nop
  801543:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801546:	5b                   	pop    %ebx
  801547:	5e                   	pop    %esi
  801548:	5f                   	pop    %edi
  801549:	5d                   	pop    %ebp
  80154a:	c3                   	ret    

0080154b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801551:	83 ec 0c             	sub    $0xc,%esp
  801554:	6a 00                	push   $0x0
  801556:	e8 e2 2d 00 00       	call   80433d <sys_destroy_env>
  80155b:	83 c4 10             	add    $0x10,%esp
}
  80155e:	90                   	nop
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <exit>:

void
exit(void)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801567:	e8 37 2e 00 00       	call   8043a3 <sys_exit_env>
}
  80156c:	90                   	nop
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801575:	8d 45 10             	lea    0x10(%ebp),%eax
  801578:	83 c0 04             	add    $0x4,%eax
  80157b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80157e:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  801583:	85 c0                	test   %eax,%eax
  801585:	74 16                	je     80159d <_panic+0x2e>
		cprintf("%s: ", argv0);
  801587:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  80158c:	83 ec 08             	sub    $0x8,%esp
  80158f:	50                   	push   %eax
  801590:	68 f4 5c 80 00       	push   $0x805cf4
  801595:	e8 a3 02 00 00       	call   80183d <cprintf>
  80159a:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80159d:	a1 04 70 80 00       	mov    0x807004,%eax
  8015a2:	83 ec 0c             	sub    $0xc,%esp
  8015a5:	ff 75 0c             	pushl  0xc(%ebp)
  8015a8:	ff 75 08             	pushl  0x8(%ebp)
  8015ab:	50                   	push   %eax
  8015ac:	68 fc 5c 80 00       	push   $0x805cfc
  8015b1:	6a 74                	push   $0x74
  8015b3:	e8 b2 02 00 00       	call   80186a <cprintf_colored>
  8015b8:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8015bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015be:	83 ec 08             	sub    $0x8,%esp
  8015c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c4:	50                   	push   %eax
  8015c5:	e8 04 02 00 00       	call   8017ce <vcprintf>
  8015ca:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8015cd:	83 ec 08             	sub    $0x8,%esp
  8015d0:	6a 00                	push   $0x0
  8015d2:	68 24 5d 80 00       	push   $0x805d24
  8015d7:	e8 f2 01 00 00       	call   8017ce <vcprintf>
  8015dc:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8015df:	e8 7d ff ff ff       	call   801561 <exit>

	// should not return here
	while (1) ;
  8015e4:	eb fe                	jmp    8015e4 <_panic+0x75>

008015e6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8015ec:	a1 00 72 80 00       	mov    0x807200,%eax
  8015f1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8015f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fa:	39 c2                	cmp    %eax,%edx
  8015fc:	74 14                	je     801612 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 28 5d 80 00       	push   $0x805d28
  801606:	6a 26                	push   $0x26
  801608:	68 74 5d 80 00       	push   $0x805d74
  80160d:	e8 5d ff ff ff       	call   80156f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801612:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801619:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801620:	e9 c5 00 00 00       	jmp    8016ea <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	01 d0                	add    %edx,%eax
  801634:	8b 00                	mov    (%eax),%eax
  801636:	85 c0                	test   %eax,%eax
  801638:	75 08                	jne    801642 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80163a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80163d:	e9 a5 00 00 00       	jmp    8016e7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801642:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801649:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801650:	eb 69                	jmp    8016bb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801652:	a1 00 72 80 00       	mov    0x807200,%eax
  801657:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80165d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801660:	89 d0                	mov    %edx,%eax
  801662:	01 c0                	add    %eax,%eax
  801664:	01 d0                	add    %edx,%eax
  801666:	c1 e0 03             	shl    $0x3,%eax
  801669:	01 c8                	add    %ecx,%eax
  80166b:	8a 40 04             	mov    0x4(%eax),%al
  80166e:	84 c0                	test   %al,%al
  801670:	75 46                	jne    8016b8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801672:	a1 00 72 80 00       	mov    0x807200,%eax
  801677:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80167d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801680:	89 d0                	mov    %edx,%eax
  801682:	01 c0                	add    %eax,%eax
  801684:	01 d0                	add    %edx,%eax
  801686:	c1 e0 03             	shl    $0x3,%eax
  801689:	01 c8                	add    %ecx,%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801690:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801693:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801698:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	01 c8                	add    %ecx,%eax
  8016a9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016ab:	39 c2                	cmp    %eax,%edx
  8016ad:	75 09                	jne    8016b8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8016af:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016b6:	eb 15                	jmp    8016cd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016b8:	ff 45 e8             	incl   -0x18(%ebp)
  8016bb:	a1 00 72 80 00       	mov    0x807200,%eax
  8016c0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016c9:	39 c2                	cmp    %eax,%edx
  8016cb:	77 85                	ja     801652 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8016cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016d1:	75 14                	jne    8016e7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	68 80 5d 80 00       	push   $0x805d80
  8016db:	6a 3a                	push   $0x3a
  8016dd:	68 74 5d 80 00       	push   $0x805d74
  8016e2:	e8 88 fe ff ff       	call   80156f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8016e7:	ff 45 f0             	incl   -0x10(%ebp)
  8016ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8016f0:	0f 8c 2f ff ff ff    	jl     801625 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8016f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801704:	eb 26                	jmp    80172c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801706:	a1 00 72 80 00       	mov    0x807200,%eax
  80170b:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  801711:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801714:	89 d0                	mov    %edx,%eax
  801716:	01 c0                	add    %eax,%eax
  801718:	01 d0                	add    %edx,%eax
  80171a:	c1 e0 03             	shl    $0x3,%eax
  80171d:	01 c8                	add    %ecx,%eax
  80171f:	8a 40 04             	mov    0x4(%eax),%al
  801722:	3c 01                	cmp    $0x1,%al
  801724:	75 03                	jne    801729 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801726:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801729:	ff 45 e0             	incl   -0x20(%ebp)
  80172c:	a1 00 72 80 00       	mov    0x807200,%eax
  801731:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801737:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80173a:	39 c2                	cmp    %eax,%edx
  80173c:	77 c8                	ja     801706 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80173e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801741:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801744:	74 14                	je     80175a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 d4 5d 80 00       	push   $0x805dd4
  80174e:	6a 44                	push   $0x44
  801750:	68 74 5d 80 00       	push   $0x805d74
  801755:	e8 15 fe ff ff       	call   80156f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80175a:	90                   	nop
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	53                   	push   %ebx
  801761:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	8b 00                	mov    (%eax),%eax
  801769:	8d 48 01             	lea    0x1(%eax),%ecx
  80176c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176f:	89 0a                	mov    %ecx,(%edx)
  801771:	8b 55 08             	mov    0x8(%ebp),%edx
  801774:	88 d1                	mov    %dl,%cl
  801776:	8b 55 0c             	mov    0xc(%ebp),%edx
  801779:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80177d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801780:	8b 00                	mov    (%eax),%eax
  801782:	3d ff 00 00 00       	cmp    $0xff,%eax
  801787:	75 30                	jne    8017b9 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801789:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  80178f:	a0 24 72 80 00       	mov    0x807224,%al
  801794:	0f b6 c0             	movzbl %al,%eax
  801797:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80179a:	8b 09                	mov    (%ecx),%ecx
  80179c:	89 cb                	mov    %ecx,%ebx
  80179e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a1:	83 c1 08             	add    $0x8,%ecx
  8017a4:	52                   	push   %edx
  8017a5:	50                   	push   %eax
  8017a6:	53                   	push   %ebx
  8017a7:	51                   	push   %ecx
  8017a8:	e8 07 29 00 00       	call   8040b4 <sys_cputs>
  8017ad:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	8b 40 04             	mov    0x4(%eax),%eax
  8017bf:	8d 50 01             	lea    0x1(%eax),%edx
  8017c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8017c8:	90                   	nop
  8017c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8017d7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017de:	00 00 00 
	b.cnt = 0;
  8017e1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8017e8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8017eb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ee:	ff 75 08             	pushl  0x8(%ebp)
  8017f1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8017f7:	50                   	push   %eax
  8017f8:	68 5d 17 80 00       	push   $0x80175d
  8017fd:	e8 5a 02 00 00       	call   801a5c <vprintfmt>
  801802:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801805:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  80180b:	a0 24 72 80 00       	mov    0x807224,%al
  801810:	0f b6 c0             	movzbl %al,%eax
  801813:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801819:	52                   	push   %edx
  80181a:	50                   	push   %eax
  80181b:	51                   	push   %ecx
  80181c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801822:	83 c0 08             	add    $0x8,%eax
  801825:	50                   	push   %eax
  801826:	e8 89 28 00 00       	call   8040b4 <sys_cputs>
  80182b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80182e:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  801835:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801843:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  80184a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80184d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	ff 75 f4             	pushl  -0xc(%ebp)
  801859:	50                   	push   %eax
  80185a:	e8 6f ff ff ff       	call   8017ce <vcprintf>
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801865:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801870:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	c1 e0 08             	shl    $0x8,%eax
  80187d:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  801882:	8d 45 0c             	lea    0xc(%ebp),%eax
  801885:	83 c0 04             	add    $0x4,%eax
  801888:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80188b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188e:	83 ec 08             	sub    $0x8,%esp
  801891:	ff 75 f4             	pushl  -0xc(%ebp)
  801894:	50                   	push   %eax
  801895:	e8 34 ff ff ff       	call   8017ce <vcprintf>
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8018a0:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  8018a7:	07 00 00 

	return cnt;
  8018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8018b5:	e8 3e 28 00 00       	call   8040f8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8018ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c9:	50                   	push   %eax
  8018ca:	e8 ff fe ff ff       	call   8017ce <vcprintf>
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8018d5:	e8 38 28 00 00       	call   804112 <sys_unlock_cons>
	return cnt;
  8018da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	53                   	push   %ebx
  8018e3:	83 ec 14             	sub    $0x14,%esp
  8018e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8018f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018fd:	77 55                	ja     801954 <printnum+0x75>
  8018ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801902:	72 05                	jb     801909 <printnum+0x2a>
  801904:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801907:	77 4b                	ja     801954 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801909:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80190c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80190f:	8b 45 18             	mov    0x18(%ebp),%eax
  801912:	ba 00 00 00 00       	mov    $0x0,%edx
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	ff 75 f4             	pushl  -0xc(%ebp)
  80191c:	ff 75 f0             	pushl  -0x10(%ebp)
  80191f:	e8 80 38 00 00       	call   8051a4 <__udivdi3>
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	ff 75 20             	pushl  0x20(%ebp)
  80192d:	53                   	push   %ebx
  80192e:	ff 75 18             	pushl  0x18(%ebp)
  801931:	52                   	push   %edx
  801932:	50                   	push   %eax
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	e8 a1 ff ff ff       	call   8018df <printnum>
  80193e:	83 c4 20             	add    $0x20,%esp
  801941:	eb 1a                	jmp    80195d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801943:	83 ec 08             	sub    $0x8,%esp
  801946:	ff 75 0c             	pushl  0xc(%ebp)
  801949:	ff 75 20             	pushl  0x20(%ebp)
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	ff d0                	call   *%eax
  801951:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801954:	ff 4d 1c             	decl   0x1c(%ebp)
  801957:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80195b:	7f e6                	jg     801943 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80195d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801960:	bb 00 00 00 00       	mov    $0x0,%ebx
  801965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801968:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196b:	53                   	push   %ebx
  80196c:	51                   	push   %ecx
  80196d:	52                   	push   %edx
  80196e:	50                   	push   %eax
  80196f:	e8 40 39 00 00       	call   8052b4 <__umoddi3>
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	05 34 60 80 00       	add    $0x806034,%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	0f be c0             	movsbl %al,%eax
  801981:	83 ec 08             	sub    $0x8,%esp
  801984:	ff 75 0c             	pushl  0xc(%ebp)
  801987:	50                   	push   %eax
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	ff d0                	call   *%eax
  80198d:	83 c4 10             	add    $0x10,%esp
}
  801990:	90                   	nop
  801991:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801999:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80199d:	7e 1c                	jle    8019bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8b 00                	mov    (%eax),%eax
  8019a4:	8d 50 08             	lea    0x8(%eax),%edx
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	89 10                	mov    %edx,(%eax)
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	8b 00                	mov    (%eax),%eax
  8019b1:	83 e8 08             	sub    $0x8,%eax
  8019b4:	8b 50 04             	mov    0x4(%eax),%edx
  8019b7:	8b 00                	mov    (%eax),%eax
  8019b9:	eb 40                	jmp    8019fb <getuint+0x65>
	else if (lflag)
  8019bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019bf:	74 1e                	je     8019df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	8b 00                	mov    (%eax),%eax
  8019c6:	8d 50 04             	lea    0x4(%eax),%edx
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	89 10                	mov    %edx,(%eax)
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	8b 00                	mov    (%eax),%eax
  8019d3:	83 e8 04             	sub    $0x4,%eax
  8019d6:	8b 00                	mov    (%eax),%eax
  8019d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019dd:	eb 1c                	jmp    8019fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8b 00                	mov    (%eax),%eax
  8019e4:	8d 50 04             	lea    0x4(%eax),%edx
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	89 10                	mov    %edx,(%eax)
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	83 e8 04             	sub    $0x4,%eax
  8019f4:	8b 00                	mov    (%eax),%eax
  8019f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019fb:	5d                   	pop    %ebp
  8019fc:	c3                   	ret    

008019fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a00:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a04:	7e 1c                	jle    801a22 <getint+0x25>
		return va_arg(*ap, long long);
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	8b 00                	mov    (%eax),%eax
  801a0b:	8d 50 08             	lea    0x8(%eax),%edx
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	89 10                	mov    %edx,(%eax)
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8b 00                	mov    (%eax),%eax
  801a18:	83 e8 08             	sub    $0x8,%eax
  801a1b:	8b 50 04             	mov    0x4(%eax),%edx
  801a1e:	8b 00                	mov    (%eax),%eax
  801a20:	eb 38                	jmp    801a5a <getint+0x5d>
	else if (lflag)
  801a22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a26:	74 1a                	je     801a42 <getint+0x45>
		return va_arg(*ap, long);
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	8b 00                	mov    (%eax),%eax
  801a2d:	8d 50 04             	lea    0x4(%eax),%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	89 10                	mov    %edx,(%eax)
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	8b 00                	mov    (%eax),%eax
  801a3a:	83 e8 04             	sub    $0x4,%eax
  801a3d:	8b 00                	mov    (%eax),%eax
  801a3f:	99                   	cltd   
  801a40:	eb 18                	jmp    801a5a <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	8b 00                	mov    (%eax),%eax
  801a47:	8d 50 04             	lea    0x4(%eax),%edx
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	89 10                	mov    %edx,(%eax)
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8b 00                	mov    (%eax),%eax
  801a54:	83 e8 04             	sub    $0x4,%eax
  801a57:	8b 00                	mov    (%eax),%eax
  801a59:	99                   	cltd   
}
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    

00801a5c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	56                   	push   %esi
  801a60:	53                   	push   %ebx
  801a61:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a64:	eb 17                	jmp    801a7d <vprintfmt+0x21>
			if (ch == '\0')
  801a66:	85 db                	test   %ebx,%ebx
  801a68:	0f 84 c1 03 00 00    	je     801e2f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801a6e:	83 ec 08             	sub    $0x8,%esp
  801a71:	ff 75 0c             	pushl  0xc(%ebp)
  801a74:	53                   	push   %ebx
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	ff d0                	call   *%eax
  801a7a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a80:	8d 50 01             	lea    0x1(%eax),%edx
  801a83:	89 55 10             	mov    %edx,0x10(%ebp)
  801a86:	8a 00                	mov    (%eax),%al
  801a88:	0f b6 d8             	movzbl %al,%ebx
  801a8b:	83 fb 25             	cmp    $0x25,%ebx
  801a8e:	75 d6                	jne    801a66 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a90:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a94:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a9b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801aa2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801aa9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab3:	8d 50 01             	lea    0x1(%eax),%edx
  801ab6:	89 55 10             	mov    %edx,0x10(%ebp)
  801ab9:	8a 00                	mov    (%eax),%al
  801abb:	0f b6 d8             	movzbl %al,%ebx
  801abe:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801ac1:	83 f8 5b             	cmp    $0x5b,%eax
  801ac4:	0f 87 3d 03 00 00    	ja     801e07 <vprintfmt+0x3ab>
  801aca:	8b 04 85 58 60 80 00 	mov    0x806058(,%eax,4),%eax
  801ad1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801ad3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801ad7:	eb d7                	jmp    801ab0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ad9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801add:	eb d1                	jmp    801ab0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801adf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801ae6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae9:	89 d0                	mov    %edx,%eax
  801aeb:	c1 e0 02             	shl    $0x2,%eax
  801aee:	01 d0                	add    %edx,%eax
  801af0:	01 c0                	add    %eax,%eax
  801af2:	01 d8                	add    %ebx,%eax
  801af4:	83 e8 30             	sub    $0x30,%eax
  801af7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801afa:	8b 45 10             	mov    0x10(%ebp),%eax
  801afd:	8a 00                	mov    (%eax),%al
  801aff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801b02:	83 fb 2f             	cmp    $0x2f,%ebx
  801b05:	7e 3e                	jle    801b45 <vprintfmt+0xe9>
  801b07:	83 fb 39             	cmp    $0x39,%ebx
  801b0a:	7f 39                	jg     801b45 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b0c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b0f:	eb d5                	jmp    801ae6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b11:	8b 45 14             	mov    0x14(%ebp),%eax
  801b14:	83 c0 04             	add    $0x4,%eax
  801b17:	89 45 14             	mov    %eax,0x14(%ebp)
  801b1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1d:	83 e8 04             	sub    $0x4,%eax
  801b20:	8b 00                	mov    (%eax),%eax
  801b22:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b25:	eb 1f                	jmp    801b46 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b2b:	79 83                	jns    801ab0 <vprintfmt+0x54>
				width = 0;
  801b2d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b34:	e9 77 ff ff ff       	jmp    801ab0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b39:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b40:	e9 6b ff ff ff       	jmp    801ab0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b45:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b4a:	0f 89 60 ff ff ff    	jns    801ab0 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b56:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b5d:	e9 4e ff ff ff       	jmp    801ab0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b62:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b65:	e9 46 ff ff ff       	jmp    801ab0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6d:	83 c0 04             	add    $0x4,%eax
  801b70:	89 45 14             	mov    %eax,0x14(%ebp)
  801b73:	8b 45 14             	mov    0x14(%ebp),%eax
  801b76:	83 e8 04             	sub    $0x4,%eax
  801b79:	8b 00                	mov    (%eax),%eax
  801b7b:	83 ec 08             	sub    $0x8,%esp
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	50                   	push   %eax
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	ff d0                	call   *%eax
  801b87:	83 c4 10             	add    $0x10,%esp
			break;
  801b8a:	e9 9b 02 00 00       	jmp    801e2a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b92:	83 c0 04             	add    $0x4,%eax
  801b95:	89 45 14             	mov    %eax,0x14(%ebp)
  801b98:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9b:	83 e8 04             	sub    $0x4,%eax
  801b9e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801ba0:	85 db                	test   %ebx,%ebx
  801ba2:	79 02                	jns    801ba6 <vprintfmt+0x14a>
				err = -err;
  801ba4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801ba6:	83 fb 64             	cmp    $0x64,%ebx
  801ba9:	7f 0b                	jg     801bb6 <vprintfmt+0x15a>
  801bab:	8b 34 9d a0 5e 80 00 	mov    0x805ea0(,%ebx,4),%esi
  801bb2:	85 f6                	test   %esi,%esi
  801bb4:	75 19                	jne    801bcf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801bb6:	53                   	push   %ebx
  801bb7:	68 45 60 80 00       	push   $0x806045
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	ff 75 08             	pushl  0x8(%ebp)
  801bc2:	e8 70 02 00 00       	call   801e37 <printfmt>
  801bc7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801bca:	e9 5b 02 00 00       	jmp    801e2a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801bcf:	56                   	push   %esi
  801bd0:	68 4e 60 80 00       	push   $0x80604e
  801bd5:	ff 75 0c             	pushl  0xc(%ebp)
  801bd8:	ff 75 08             	pushl  0x8(%ebp)
  801bdb:	e8 57 02 00 00       	call   801e37 <printfmt>
  801be0:	83 c4 10             	add    $0x10,%esp
			break;
  801be3:	e9 42 02 00 00       	jmp    801e2a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801be8:	8b 45 14             	mov    0x14(%ebp),%eax
  801beb:	83 c0 04             	add    $0x4,%eax
  801bee:	89 45 14             	mov    %eax,0x14(%ebp)
  801bf1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf4:	83 e8 04             	sub    $0x4,%eax
  801bf7:	8b 30                	mov    (%eax),%esi
  801bf9:	85 f6                	test   %esi,%esi
  801bfb:	75 05                	jne    801c02 <vprintfmt+0x1a6>
				p = "(null)";
  801bfd:	be 51 60 80 00       	mov    $0x806051,%esi
			if (width > 0 && padc != '-')
  801c02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c06:	7e 6d                	jle    801c75 <vprintfmt+0x219>
  801c08:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c0c:	74 67                	je     801c75 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c11:	83 ec 08             	sub    $0x8,%esp
  801c14:	50                   	push   %eax
  801c15:	56                   	push   %esi
  801c16:	e8 1e 03 00 00       	call   801f39 <strnlen>
  801c1b:	83 c4 10             	add    $0x10,%esp
  801c1e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c21:	eb 16                	jmp    801c39 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c23:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c27:	83 ec 08             	sub    $0x8,%esp
  801c2a:	ff 75 0c             	pushl  0xc(%ebp)
  801c2d:	50                   	push   %eax
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	ff d0                	call   *%eax
  801c33:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c36:	ff 4d e4             	decl   -0x1c(%ebp)
  801c39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c3d:	7f e4                	jg     801c23 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c3f:	eb 34                	jmp    801c75 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c41:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c45:	74 1c                	je     801c63 <vprintfmt+0x207>
  801c47:	83 fb 1f             	cmp    $0x1f,%ebx
  801c4a:	7e 05                	jle    801c51 <vprintfmt+0x1f5>
  801c4c:	83 fb 7e             	cmp    $0x7e,%ebx
  801c4f:	7e 12                	jle    801c63 <vprintfmt+0x207>
					putch('?', putdat);
  801c51:	83 ec 08             	sub    $0x8,%esp
  801c54:	ff 75 0c             	pushl  0xc(%ebp)
  801c57:	6a 3f                	push   $0x3f
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	ff d0                	call   *%eax
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	eb 0f                	jmp    801c72 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c63:	83 ec 08             	sub    $0x8,%esp
  801c66:	ff 75 0c             	pushl  0xc(%ebp)
  801c69:	53                   	push   %ebx
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	ff d0                	call   *%eax
  801c6f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c72:	ff 4d e4             	decl   -0x1c(%ebp)
  801c75:	89 f0                	mov    %esi,%eax
  801c77:	8d 70 01             	lea    0x1(%eax),%esi
  801c7a:	8a 00                	mov    (%eax),%al
  801c7c:	0f be d8             	movsbl %al,%ebx
  801c7f:	85 db                	test   %ebx,%ebx
  801c81:	74 24                	je     801ca7 <vprintfmt+0x24b>
  801c83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c87:	78 b8                	js     801c41 <vprintfmt+0x1e5>
  801c89:	ff 4d e0             	decl   -0x20(%ebp)
  801c8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c90:	79 af                	jns    801c41 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c92:	eb 13                	jmp    801ca7 <vprintfmt+0x24b>
				putch(' ', putdat);
  801c94:	83 ec 08             	sub    $0x8,%esp
  801c97:	ff 75 0c             	pushl  0xc(%ebp)
  801c9a:	6a 20                	push   $0x20
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	ff d0                	call   *%eax
  801ca1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ca4:	ff 4d e4             	decl   -0x1c(%ebp)
  801ca7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cab:	7f e7                	jg     801c94 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801cad:	e9 78 01 00 00       	jmp    801e2a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801cb2:	83 ec 08             	sub    $0x8,%esp
  801cb5:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb8:	8d 45 14             	lea    0x14(%ebp),%eax
  801cbb:	50                   	push   %eax
  801cbc:	e8 3c fd ff ff       	call   8019fd <getint>
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd0:	85 d2                	test   %edx,%edx
  801cd2:	79 23                	jns    801cf7 <vprintfmt+0x29b>
				putch('-', putdat);
  801cd4:	83 ec 08             	sub    $0x8,%esp
  801cd7:	ff 75 0c             	pushl  0xc(%ebp)
  801cda:	6a 2d                	push   $0x2d
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	ff d0                	call   *%eax
  801ce1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cea:	f7 d8                	neg    %eax
  801cec:	83 d2 00             	adc    $0x0,%edx
  801cef:	f7 da                	neg    %edx
  801cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801cf7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cfe:	e9 bc 00 00 00       	jmp    801dbf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d03:	83 ec 08             	sub    $0x8,%esp
  801d06:	ff 75 e8             	pushl  -0x18(%ebp)
  801d09:	8d 45 14             	lea    0x14(%ebp),%eax
  801d0c:	50                   	push   %eax
  801d0d:	e8 84 fc ff ff       	call   801996 <getuint>
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d22:	e9 98 00 00 00       	jmp    801dbf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d27:	83 ec 08             	sub    $0x8,%esp
  801d2a:	ff 75 0c             	pushl  0xc(%ebp)
  801d2d:	6a 58                	push   $0x58
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	ff d0                	call   *%eax
  801d34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d37:	83 ec 08             	sub    $0x8,%esp
  801d3a:	ff 75 0c             	pushl  0xc(%ebp)
  801d3d:	6a 58                	push   $0x58
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	ff d0                	call   *%eax
  801d44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d47:	83 ec 08             	sub    $0x8,%esp
  801d4a:	ff 75 0c             	pushl  0xc(%ebp)
  801d4d:	6a 58                	push   $0x58
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	ff d0                	call   *%eax
  801d54:	83 c4 10             	add    $0x10,%esp
			break;
  801d57:	e9 ce 00 00 00       	jmp    801e2a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801d5c:	83 ec 08             	sub    $0x8,%esp
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	6a 30                	push   $0x30
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	ff d0                	call   *%eax
  801d69:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d6c:	83 ec 08             	sub    $0x8,%esp
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	6a 78                	push   $0x78
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	ff d0                	call   *%eax
  801d79:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7f:	83 c0 04             	add    $0x4,%eax
  801d82:	89 45 14             	mov    %eax,0x14(%ebp)
  801d85:	8b 45 14             	mov    0x14(%ebp),%eax
  801d88:	83 e8 04             	sub    $0x4,%eax
  801d8b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d9e:	eb 1f                	jmp    801dbf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801da0:	83 ec 08             	sub    $0x8,%esp
  801da3:	ff 75 e8             	pushl  -0x18(%ebp)
  801da6:	8d 45 14             	lea    0x14(%ebp),%eax
  801da9:	50                   	push   %eax
  801daa:	e8 e7 fb ff ff       	call   801996 <getuint>
  801daf:	83 c4 10             	add    $0x10,%esp
  801db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801db5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801db8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801dbf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc6:	83 ec 04             	sub    $0x4,%esp
  801dc9:	52                   	push   %edx
  801dca:	ff 75 e4             	pushl  -0x1c(%ebp)
  801dcd:	50                   	push   %eax
  801dce:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd1:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd4:	ff 75 0c             	pushl  0xc(%ebp)
  801dd7:	ff 75 08             	pushl  0x8(%ebp)
  801dda:	e8 00 fb ff ff       	call   8018df <printnum>
  801ddf:	83 c4 20             	add    $0x20,%esp
			break;
  801de2:	eb 46                	jmp    801e2a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801de4:	83 ec 08             	sub    $0x8,%esp
  801de7:	ff 75 0c             	pushl  0xc(%ebp)
  801dea:	53                   	push   %ebx
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	ff d0                	call   *%eax
  801df0:	83 c4 10             	add    $0x10,%esp
			break;
  801df3:	eb 35                	jmp    801e2a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801df5:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  801dfc:	eb 2c                	jmp    801e2a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801dfe:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  801e05:	eb 23                	jmp    801e2a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e07:	83 ec 08             	sub    $0x8,%esp
  801e0a:	ff 75 0c             	pushl  0xc(%ebp)
  801e0d:	6a 25                	push   $0x25
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	ff d0                	call   *%eax
  801e14:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e17:	ff 4d 10             	decl   0x10(%ebp)
  801e1a:	eb 03                	jmp    801e1f <vprintfmt+0x3c3>
  801e1c:	ff 4d 10             	decl   0x10(%ebp)
  801e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e22:	48                   	dec    %eax
  801e23:	8a 00                	mov    (%eax),%al
  801e25:	3c 25                	cmp    $0x25,%al
  801e27:	75 f3                	jne    801e1c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e29:	90                   	nop
		}
	}
  801e2a:	e9 35 fc ff ff       	jmp    801a64 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e2f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e33:	5b                   	pop    %ebx
  801e34:	5e                   	pop    %esi
  801e35:	5d                   	pop    %ebp
  801e36:	c3                   	ret    

00801e37 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e3d:	8d 45 10             	lea    0x10(%ebp),%eax
  801e40:	83 c0 04             	add    $0x4,%eax
  801e43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e46:	8b 45 10             	mov    0x10(%ebp),%eax
  801e49:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4c:	50                   	push   %eax
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	ff 75 08             	pushl  0x8(%ebp)
  801e53:	e8 04 fc ff ff       	call   801a5c <vprintfmt>
  801e58:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e5b:	90                   	nop
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e64:	8b 40 08             	mov    0x8(%eax),%eax
  801e67:	8d 50 01             	lea    0x1(%eax),%edx
  801e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e73:	8b 10                	mov    (%eax),%edx
  801e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e78:	8b 40 04             	mov    0x4(%eax),%eax
  801e7b:	39 c2                	cmp    %eax,%edx
  801e7d:	73 12                	jae    801e91 <sprintputch+0x33>
		*b->buf++ = ch;
  801e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e82:	8b 00                	mov    (%eax),%eax
  801e84:	8d 48 01             	lea    0x1(%eax),%ecx
  801e87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8a:	89 0a                	mov    %ecx,(%edx)
  801e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8f:	88 10                	mov    %dl,(%eax)
}
  801e91:	90                   	nop
  801e92:	5d                   	pop    %ebp
  801e93:	c3                   	ret    

00801e94 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea3:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	01 d0                	add    %edx,%eax
  801eab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801eb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801eb9:	74 06                	je     801ec1 <vsnprintf+0x2d>
  801ebb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ebf:	7f 07                	jg     801ec8 <vsnprintf+0x34>
		return -E_INVAL;
  801ec1:	b8 03 00 00 00       	mov    $0x3,%eax
  801ec6:	eb 20                	jmp    801ee8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ec8:	ff 75 14             	pushl  0x14(%ebp)
  801ecb:	ff 75 10             	pushl  0x10(%ebp)
  801ece:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ed1:	50                   	push   %eax
  801ed2:	68 5e 1e 80 00       	push   $0x801e5e
  801ed7:	e8 80 fb ff ff       	call   801a5c <vprintfmt>
  801edc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ef0:	8d 45 10             	lea    0x10(%ebp),%eax
  801ef3:	83 c0 04             	add    $0x4,%eax
  801ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  801efc:	ff 75 f4             	pushl  -0xc(%ebp)
  801eff:	50                   	push   %eax
  801f00:	ff 75 0c             	pushl  0xc(%ebp)
  801f03:	ff 75 08             	pushl  0x8(%ebp)
  801f06:	e8 89 ff ff ff       	call   801e94 <vsnprintf>
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f23:	eb 06                	jmp    801f2b <strlen+0x15>
		n++;
  801f25:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f28:	ff 45 08             	incl   0x8(%ebp)
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	8a 00                	mov    (%eax),%al
  801f30:	84 c0                	test   %al,%al
  801f32:	75 f1                	jne    801f25 <strlen+0xf>
		n++;
	return n;
  801f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f46:	eb 09                	jmp    801f51 <strnlen+0x18>
		n++;
  801f48:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f4b:	ff 45 08             	incl   0x8(%ebp)
  801f4e:	ff 4d 0c             	decl   0xc(%ebp)
  801f51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f55:	74 09                	je     801f60 <strnlen+0x27>
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	8a 00                	mov    (%eax),%al
  801f5c:	84 c0                	test   %al,%al
  801f5e:	75 e8                	jne    801f48 <strnlen+0xf>
		n++;
	return n;
  801f60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f71:	90                   	nop
  801f72:	8b 45 08             	mov    0x8(%ebp),%eax
  801f75:	8d 50 01             	lea    0x1(%eax),%edx
  801f78:	89 55 08             	mov    %edx,0x8(%ebp)
  801f7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f81:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f84:	8a 12                	mov    (%edx),%dl
  801f86:	88 10                	mov    %dl,(%eax)
  801f88:	8a 00                	mov    (%eax),%al
  801f8a:	84 c0                	test   %al,%al
  801f8c:	75 e4                	jne    801f72 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fa6:	eb 1f                	jmp    801fc7 <strncpy+0x34>
		*dst++ = *src;
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	8d 50 01             	lea    0x1(%eax),%edx
  801fae:	89 55 08             	mov    %edx,0x8(%ebp)
  801fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb4:	8a 12                	mov    (%edx),%dl
  801fb6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbb:	8a 00                	mov    (%eax),%al
  801fbd:	84 c0                	test   %al,%al
  801fbf:	74 03                	je     801fc4 <strncpy+0x31>
			src++;
  801fc1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fc4:	ff 45 fc             	incl   -0x4(%ebp)
  801fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fca:	3b 45 10             	cmp    0x10(%ebp),%eax
  801fcd:	72 d9                	jb     801fa8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801fcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801fe0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fe4:	74 30                	je     802016 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801fe6:	eb 16                	jmp    801ffe <strlcpy+0x2a>
			*dst++ = *src++;
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	8d 50 01             	lea    0x1(%eax),%edx
  801fee:	89 55 08             	mov    %edx,0x8(%ebp)
  801ff1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff4:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ff7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801ffa:	8a 12                	mov    (%edx),%dl
  801ffc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801ffe:	ff 4d 10             	decl   0x10(%ebp)
  802001:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802005:	74 09                	je     802010 <strlcpy+0x3c>
  802007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200a:	8a 00                	mov    (%eax),%al
  80200c:	84 c0                	test   %al,%al
  80200e:	75 d8                	jne    801fe8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802016:	8b 55 08             	mov    0x8(%ebp),%edx
  802019:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80201c:	29 c2                	sub    %eax,%edx
  80201e:	89 d0                	mov    %edx,%eax
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802025:	eb 06                	jmp    80202d <strcmp+0xb>
		p++, q++;
  802027:	ff 45 08             	incl   0x8(%ebp)
  80202a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8a 00                	mov    (%eax),%al
  802032:	84 c0                	test   %al,%al
  802034:	74 0e                	je     802044 <strcmp+0x22>
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8a 10                	mov    (%eax),%dl
  80203b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203e:	8a 00                	mov    (%eax),%al
  802040:	38 c2                	cmp    %al,%dl
  802042:	74 e3                	je     802027 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	8a 00                	mov    (%eax),%al
  802049:	0f b6 d0             	movzbl %al,%edx
  80204c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204f:	8a 00                	mov    (%eax),%al
  802051:	0f b6 c0             	movzbl %al,%eax
  802054:	29 c2                	sub    %eax,%edx
  802056:	89 d0                	mov    %edx,%eax
}
  802058:	5d                   	pop    %ebp
  802059:	c3                   	ret    

0080205a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80205d:	eb 09                	jmp    802068 <strncmp+0xe>
		n--, p++, q++;
  80205f:	ff 4d 10             	decl   0x10(%ebp)
  802062:	ff 45 08             	incl   0x8(%ebp)
  802065:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802068:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80206c:	74 17                	je     802085 <strncmp+0x2b>
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	8a 00                	mov    (%eax),%al
  802073:	84 c0                	test   %al,%al
  802075:	74 0e                	je     802085 <strncmp+0x2b>
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	8a 10                	mov    (%eax),%dl
  80207c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207f:	8a 00                	mov    (%eax),%al
  802081:	38 c2                	cmp    %al,%dl
  802083:	74 da                	je     80205f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802085:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802089:	75 07                	jne    802092 <strncmp+0x38>
		return 0;
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
  802090:	eb 14                	jmp    8020a6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	8a 00                	mov    (%eax),%al
  802097:	0f b6 d0             	movzbl %al,%edx
  80209a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209d:	8a 00                	mov    (%eax),%al
  80209f:	0f b6 c0             	movzbl %al,%eax
  8020a2:	29 c2                	sub    %eax,%edx
  8020a4:	89 d0                	mov    %edx,%eax
}
  8020a6:	5d                   	pop    %ebp
  8020a7:	c3                   	ret    

008020a8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 04             	sub    $0x4,%esp
  8020ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020b4:	eb 12                	jmp    8020c8 <strchr+0x20>
		if (*s == c)
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	8a 00                	mov    (%eax),%al
  8020bb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020be:	75 05                	jne    8020c5 <strchr+0x1d>
			return (char *) s;
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	eb 11                	jmp    8020d6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020c5:	ff 45 08             	incl   0x8(%ebp)
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	8a 00                	mov    (%eax),%al
  8020cd:	84 c0                	test   %al,%al
  8020cf:	75 e5                	jne    8020b6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8020d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	83 ec 04             	sub    $0x4,%esp
  8020de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020e4:	eb 0d                	jmp    8020f3 <strfind+0x1b>
		if (*s == c)
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	8a 00                	mov    (%eax),%al
  8020eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020ee:	74 0e                	je     8020fe <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020f0:	ff 45 08             	incl   0x8(%ebp)
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	8a 00                	mov    (%eax),%al
  8020f8:	84 c0                	test   %al,%al
  8020fa:	75 ea                	jne    8020e6 <strfind+0xe>
  8020fc:	eb 01                	jmp    8020ff <strfind+0x27>
		if (*s == c)
			break;
  8020fe:	90                   	nop
	return (char *) s;
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802110:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802114:	76 63                	jbe    802179 <memset+0x75>
		uint64 data_block = c;
  802116:	8b 45 0c             	mov    0xc(%ebp),%eax
  802119:	99                   	cltd   
  80211a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80211d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802123:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802126:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80212a:	c1 e0 08             	shl    $0x8,%eax
  80212d:	09 45 f0             	or     %eax,-0x10(%ebp)
  802130:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802136:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802139:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80213d:	c1 e0 10             	shl    $0x10,%eax
  802140:	09 45 f0             	or     %eax,-0x10(%ebp)
  802143:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  802146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214c:	89 c2                	mov    %eax,%edx
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
  802153:	09 45 f0             	or     %eax,-0x10(%ebp)
  802156:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  802159:	eb 18                	jmp    802173 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80215b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80215e:	8d 41 08             	lea    0x8(%ecx),%eax
  802161:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802167:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216a:	89 01                	mov    %eax,(%ecx)
  80216c:	89 51 04             	mov    %edx,0x4(%ecx)
  80216f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802173:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802177:	77 e2                	ja     80215b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  802179:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80217d:	74 23                	je     8021a2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80217f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802182:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  802185:	eb 0e                	jmp    802195 <memset+0x91>
			*p8++ = (uint8)c;
  802187:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80218a:	8d 50 01             	lea    0x1(%eax),%edx
  80218d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802190:	8b 55 0c             	mov    0xc(%ebp),%edx
  802193:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  802195:	8b 45 10             	mov    0x10(%ebp),%eax
  802198:	8d 50 ff             	lea    -0x1(%eax),%edx
  80219b:	89 55 10             	mov    %edx,0x10(%ebp)
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	75 e5                	jne    802187 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8021ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8021b9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021bd:	76 24                	jbe    8021e3 <memcpy+0x3c>
		while(n >= 8){
  8021bf:	eb 1c                	jmp    8021dd <memcpy+0x36>
			*d64 = *s64;
  8021c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c4:	8b 50 04             	mov    0x4(%eax),%edx
  8021c7:	8b 00                	mov    (%eax),%eax
  8021c9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8021cc:	89 01                	mov    %eax,(%ecx)
  8021ce:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8021d1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8021d5:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8021d9:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8021dd:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021e1:	77 de                	ja     8021c1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8021e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021e7:	74 31                	je     80221a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8021e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8021ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8021f5:	eb 16                	jmp    80220d <memcpy+0x66>
			*d8++ = *s8++;
  8021f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fa:	8d 50 01             	lea    0x1(%eax),%edx
  8021fd:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802200:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802203:	8d 4a 01             	lea    0x1(%edx),%ecx
  802206:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802209:	8a 12                	mov    (%edx),%dl
  80220b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80220d:	8b 45 10             	mov    0x10(%ebp),%eax
  802210:	8d 50 ff             	lea    -0x1(%eax),%edx
  802213:	89 55 10             	mov    %edx,0x10(%ebp)
  802216:	85 c0                	test   %eax,%eax
  802218:	75 dd                	jne    8021f7 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802225:	8b 45 0c             	mov    0xc(%ebp),%eax
  802228:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802231:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802234:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802237:	73 50                	jae    802289 <memmove+0x6a>
  802239:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80223c:	8b 45 10             	mov    0x10(%ebp),%eax
  80223f:	01 d0                	add    %edx,%eax
  802241:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802244:	76 43                	jbe    802289 <memmove+0x6a>
		s += n;
  802246:	8b 45 10             	mov    0x10(%ebp),%eax
  802249:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80224c:	8b 45 10             	mov    0x10(%ebp),%eax
  80224f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802252:	eb 10                	jmp    802264 <memmove+0x45>
			*--d = *--s;
  802254:	ff 4d f8             	decl   -0x8(%ebp)
  802257:	ff 4d fc             	decl   -0x4(%ebp)
  80225a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80225d:	8a 10                	mov    (%eax),%dl
  80225f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802262:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802264:	8b 45 10             	mov    0x10(%ebp),%eax
  802267:	8d 50 ff             	lea    -0x1(%eax),%edx
  80226a:	89 55 10             	mov    %edx,0x10(%ebp)
  80226d:	85 c0                	test   %eax,%eax
  80226f:	75 e3                	jne    802254 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802271:	eb 23                	jmp    802296 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802273:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802276:	8d 50 01             	lea    0x1(%eax),%edx
  802279:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80227c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80227f:	8d 4a 01             	lea    0x1(%edx),%ecx
  802282:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802285:	8a 12                	mov    (%edx),%dl
  802287:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802289:	8b 45 10             	mov    0x10(%ebp),%eax
  80228c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80228f:	89 55 10             	mov    %edx,0x10(%ebp)
  802292:	85 c0                	test   %eax,%eax
  802294:	75 dd                	jne    802273 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022aa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8022ad:	eb 2a                	jmp    8022d9 <memcmp+0x3e>
		if (*s1 != *s2)
  8022af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022b2:	8a 10                	mov    (%eax),%dl
  8022b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022b7:	8a 00                	mov    (%eax),%al
  8022b9:	38 c2                	cmp    %al,%dl
  8022bb:	74 16                	je     8022d3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8022bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022c0:	8a 00                	mov    (%eax),%al
  8022c2:	0f b6 d0             	movzbl %al,%edx
  8022c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022c8:	8a 00                	mov    (%eax),%al
  8022ca:	0f b6 c0             	movzbl %al,%eax
  8022cd:	29 c2                	sub    %eax,%edx
  8022cf:	89 d0                	mov    %edx,%eax
  8022d1:	eb 18                	jmp    8022eb <memcmp+0x50>
		s1++, s2++;
  8022d3:	ff 45 fc             	incl   -0x4(%ebp)
  8022d6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8022d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022df:	89 55 10             	mov    %edx,0x10(%ebp)
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	75 c9                	jne    8022af <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8022e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8022f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f9:	01 d0                	add    %edx,%eax
  8022fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8022fe:	eb 15                	jmp    802315 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	8a 00                	mov    (%eax),%al
  802305:	0f b6 d0             	movzbl %al,%edx
  802308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230b:	0f b6 c0             	movzbl %al,%eax
  80230e:	39 c2                	cmp    %eax,%edx
  802310:	74 0d                	je     80231f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802312:	ff 45 08             	incl   0x8(%ebp)
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80231b:	72 e3                	jb     802300 <memfind+0x13>
  80231d:	eb 01                	jmp    802320 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80231f:	90                   	nop
	return (void *) s;
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80232b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802332:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802339:	eb 03                	jmp    80233e <strtol+0x19>
		s++;
  80233b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	8a 00                	mov    (%eax),%al
  802343:	3c 20                	cmp    $0x20,%al
  802345:	74 f4                	je     80233b <strtol+0x16>
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	8a 00                	mov    (%eax),%al
  80234c:	3c 09                	cmp    $0x9,%al
  80234e:	74 eb                	je     80233b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	8a 00                	mov    (%eax),%al
  802355:	3c 2b                	cmp    $0x2b,%al
  802357:	75 05                	jne    80235e <strtol+0x39>
		s++;
  802359:	ff 45 08             	incl   0x8(%ebp)
  80235c:	eb 13                	jmp    802371 <strtol+0x4c>
	else if (*s == '-')
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	8a 00                	mov    (%eax),%al
  802363:	3c 2d                	cmp    $0x2d,%al
  802365:	75 0a                	jne    802371 <strtol+0x4c>
		s++, neg = 1;
  802367:	ff 45 08             	incl   0x8(%ebp)
  80236a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802371:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802375:	74 06                	je     80237d <strtol+0x58>
  802377:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80237b:	75 20                	jne    80239d <strtol+0x78>
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	8a 00                	mov    (%eax),%al
  802382:	3c 30                	cmp    $0x30,%al
  802384:	75 17                	jne    80239d <strtol+0x78>
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	40                   	inc    %eax
  80238a:	8a 00                	mov    (%eax),%al
  80238c:	3c 78                	cmp    $0x78,%al
  80238e:	75 0d                	jne    80239d <strtol+0x78>
		s += 2, base = 16;
  802390:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802394:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80239b:	eb 28                	jmp    8023c5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80239d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023a1:	75 15                	jne    8023b8 <strtol+0x93>
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	8a 00                	mov    (%eax),%al
  8023a8:	3c 30                	cmp    $0x30,%al
  8023aa:	75 0c                	jne    8023b8 <strtol+0x93>
		s++, base = 8;
  8023ac:	ff 45 08             	incl   0x8(%ebp)
  8023af:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8023b6:	eb 0d                	jmp    8023c5 <strtol+0xa0>
	else if (base == 0)
  8023b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023bc:	75 07                	jne    8023c5 <strtol+0xa0>
		base = 10;
  8023be:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	8a 00                	mov    (%eax),%al
  8023ca:	3c 2f                	cmp    $0x2f,%al
  8023cc:	7e 19                	jle    8023e7 <strtol+0xc2>
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	8a 00                	mov    (%eax),%al
  8023d3:	3c 39                	cmp    $0x39,%al
  8023d5:	7f 10                	jg     8023e7 <strtol+0xc2>
			dig = *s - '0';
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	8a 00                	mov    (%eax),%al
  8023dc:	0f be c0             	movsbl %al,%eax
  8023df:	83 e8 30             	sub    $0x30,%eax
  8023e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e5:	eb 42                	jmp    802429 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	8a 00                	mov    (%eax),%al
  8023ec:	3c 60                	cmp    $0x60,%al
  8023ee:	7e 19                	jle    802409 <strtol+0xe4>
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	8a 00                	mov    (%eax),%al
  8023f5:	3c 7a                	cmp    $0x7a,%al
  8023f7:	7f 10                	jg     802409 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	8a 00                	mov    (%eax),%al
  8023fe:	0f be c0             	movsbl %al,%eax
  802401:	83 e8 57             	sub    $0x57,%eax
  802404:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802407:	eb 20                	jmp    802429 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	8a 00                	mov    (%eax),%al
  80240e:	3c 40                	cmp    $0x40,%al
  802410:	7e 39                	jle    80244b <strtol+0x126>
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	8a 00                	mov    (%eax),%al
  802417:	3c 5a                	cmp    $0x5a,%al
  802419:	7f 30                	jg     80244b <strtol+0x126>
			dig = *s - 'A' + 10;
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	8a 00                	mov    (%eax),%al
  802420:	0f be c0             	movsbl %al,%eax
  802423:	83 e8 37             	sub    $0x37,%eax
  802426:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80242f:	7d 19                	jge    80244a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802431:	ff 45 08             	incl   0x8(%ebp)
  802434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802437:	0f af 45 10          	imul   0x10(%ebp),%eax
  80243b:	89 c2                	mov    %eax,%edx
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	01 d0                	add    %edx,%eax
  802442:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802445:	e9 7b ff ff ff       	jmp    8023c5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80244a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80244b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80244f:	74 08                	je     802459 <strtol+0x134>
		*endptr = (char *) s;
  802451:	8b 45 0c             	mov    0xc(%ebp),%eax
  802454:	8b 55 08             	mov    0x8(%ebp),%edx
  802457:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802459:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80245d:	74 07                	je     802466 <strtol+0x141>
  80245f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802462:	f7 d8                	neg    %eax
  802464:	eb 03                	jmp    802469 <strtol+0x144>
  802466:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    

0080246b <ltostr>:

void
ltostr(long value, char *str)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802478:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80247f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802483:	79 13                	jns    802498 <ltostr+0x2d>
	{
		neg = 1;
  802485:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80248c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802492:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802495:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8024a0:	99                   	cltd   
  8024a1:	f7 f9                	idiv   %ecx
  8024a3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8024a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024a9:	8d 50 01             	lea    0x1(%eax),%edx
  8024ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8024af:	89 c2                	mov    %eax,%edx
  8024b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b4:	01 d0                	add    %edx,%eax
  8024b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024b9:	83 c2 30             	add    $0x30,%edx
  8024bc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8024be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024c1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8024c6:	f7 e9                	imul   %ecx
  8024c8:	c1 fa 02             	sar    $0x2,%edx
  8024cb:	89 c8                	mov    %ecx,%eax
  8024cd:	c1 f8 1f             	sar    $0x1f,%eax
  8024d0:	29 c2                	sub    %eax,%edx
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8024d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024db:	75 bb                	jne    802498 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8024dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8024e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e7:	48                   	dec    %eax
  8024e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8024eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024ef:	74 3d                	je     80252e <ltostr+0xc3>
		start = 1 ;
  8024f1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8024f8:	eb 34                	jmp    80252e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8024fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802500:	01 d0                	add    %edx,%eax
  802502:	8a 00                	mov    (%eax),%al
  802504:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250d:	01 c2                	add    %eax,%edx
  80250f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802512:	8b 45 0c             	mov    0xc(%ebp),%eax
  802515:	01 c8                	add    %ecx,%eax
  802517:	8a 00                	mov    (%eax),%al
  802519:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80251b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802521:	01 c2                	add    %eax,%edx
  802523:	8a 45 eb             	mov    -0x15(%ebp),%al
  802526:	88 02                	mov    %al,(%edx)
		start++ ;
  802528:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80252b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802534:	7c c4                	jl     8024fa <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802536:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253c:	01 d0                	add    %edx,%eax
  80253e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802541:	90                   	nop
  802542:	c9                   	leave  
  802543:	c3                   	ret    

00802544 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80254a:	ff 75 08             	pushl  0x8(%ebp)
  80254d:	e8 c4 f9 ff ff       	call   801f16 <strlen>
  802552:	83 c4 04             	add    $0x4,%esp
  802555:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802558:	ff 75 0c             	pushl  0xc(%ebp)
  80255b:	e8 b6 f9 ff ff       	call   801f16 <strlen>
  802560:	83 c4 04             	add    $0x4,%esp
  802563:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802566:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80256d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802574:	eb 17                	jmp    80258d <strcconcat+0x49>
		final[s] = str1[s] ;
  802576:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802579:	8b 45 10             	mov    0x10(%ebp),%eax
  80257c:	01 c2                	add    %eax,%edx
  80257e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	01 c8                	add    %ecx,%eax
  802586:	8a 00                	mov    (%eax),%al
  802588:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80258a:	ff 45 fc             	incl   -0x4(%ebp)
  80258d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802590:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802593:	7c e1                	jl     802576 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802595:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80259c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8025a3:	eb 1f                	jmp    8025c4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8025a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a8:	8d 50 01             	lea    0x1(%eax),%edx
  8025ab:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8025ae:	89 c2                	mov    %eax,%edx
  8025b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b3:	01 c2                	add    %eax,%edx
  8025b5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8025b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025bb:	01 c8                	add    %ecx,%eax
  8025bd:	8a 00                	mov    (%eax),%al
  8025bf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8025c1:	ff 45 f8             	incl   -0x8(%ebp)
  8025c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025ca:	7c d9                	jl     8025a5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8025cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d2:	01 d0                	add    %edx,%eax
  8025d4:	c6 00 00             	movb   $0x0,(%eax)
}
  8025d7:	90                   	nop
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8025dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8025e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8025e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8025e9:	8b 00                	mov    (%eax),%eax
  8025eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f5:	01 d0                	add    %edx,%eax
  8025f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8025fd:	eb 0c                	jmp    80260b <strsplit+0x31>
			*string++ = 0;
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	8d 50 01             	lea    0x1(%eax),%edx
  802605:	89 55 08             	mov    %edx,0x8(%ebp)
  802608:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	8a 00                	mov    (%eax),%al
  802610:	84 c0                	test   %al,%al
  802612:	74 18                	je     80262c <strsplit+0x52>
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	8a 00                	mov    (%eax),%al
  802619:	0f be c0             	movsbl %al,%eax
  80261c:	50                   	push   %eax
  80261d:	ff 75 0c             	pushl  0xc(%ebp)
  802620:	e8 83 fa ff ff       	call   8020a8 <strchr>
  802625:	83 c4 08             	add    $0x8,%esp
  802628:	85 c0                	test   %eax,%eax
  80262a:	75 d3                	jne    8025ff <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80262c:	8b 45 08             	mov    0x8(%ebp),%eax
  80262f:	8a 00                	mov    (%eax),%al
  802631:	84 c0                	test   %al,%al
  802633:	74 5a                	je     80268f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802635:	8b 45 14             	mov    0x14(%ebp),%eax
  802638:	8b 00                	mov    (%eax),%eax
  80263a:	83 f8 0f             	cmp    $0xf,%eax
  80263d:	75 07                	jne    802646 <strsplit+0x6c>
		{
			return 0;
  80263f:	b8 00 00 00 00       	mov    $0x0,%eax
  802644:	eb 66                	jmp    8026ac <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802646:	8b 45 14             	mov    0x14(%ebp),%eax
  802649:	8b 00                	mov    (%eax),%eax
  80264b:	8d 48 01             	lea    0x1(%eax),%ecx
  80264e:	8b 55 14             	mov    0x14(%ebp),%edx
  802651:	89 0a                	mov    %ecx,(%edx)
  802653:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80265a:	8b 45 10             	mov    0x10(%ebp),%eax
  80265d:	01 c2                	add    %eax,%edx
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802664:	eb 03                	jmp    802669 <strsplit+0x8f>
			string++;
  802666:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	8a 00                	mov    (%eax),%al
  80266e:	84 c0                	test   %al,%al
  802670:	74 8b                	je     8025fd <strsplit+0x23>
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	8a 00                	mov    (%eax),%al
  802677:	0f be c0             	movsbl %al,%eax
  80267a:	50                   	push   %eax
  80267b:	ff 75 0c             	pushl  0xc(%ebp)
  80267e:	e8 25 fa ff ff       	call   8020a8 <strchr>
  802683:	83 c4 08             	add    $0x8,%esp
  802686:	85 c0                	test   %eax,%eax
  802688:	74 dc                	je     802666 <strsplit+0x8c>
			string++;
	}
  80268a:	e9 6e ff ff ff       	jmp    8025fd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80268f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802690:	8b 45 14             	mov    0x14(%ebp),%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80269c:	8b 45 10             	mov    0x10(%ebp),%eax
  80269f:	01 d0                	add    %edx,%eax
  8026a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8026a7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026ac:	c9                   	leave  
  8026ad:	c3                   	ret    

008026ae <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
  8026b1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8026ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8026c1:	eb 4a                	jmp    80270d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8026c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	01 c2                	add    %eax,%edx
  8026cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8026ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026d1:	01 c8                	add    %ecx,%eax
  8026d3:	8a 00                	mov    (%eax),%al
  8026d5:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8026d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026dd:	01 d0                	add    %edx,%eax
  8026df:	8a 00                	mov    (%eax),%al
  8026e1:	3c 40                	cmp    $0x40,%al
  8026e3:	7e 25                	jle    80270a <str2lower+0x5c>
  8026e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026eb:	01 d0                	add    %edx,%eax
  8026ed:	8a 00                	mov    (%eax),%al
  8026ef:	3c 5a                	cmp    $0x5a,%al
  8026f1:	7f 17                	jg     80270a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8026f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f9:	01 d0                	add    %edx,%eax
  8026fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8026fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802701:	01 ca                	add    %ecx,%edx
  802703:	8a 12                	mov    (%edx),%dl
  802705:	83 c2 20             	add    $0x20,%edx
  802708:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80270a:	ff 45 fc             	incl   -0x4(%ebp)
  80270d:	ff 75 0c             	pushl  0xc(%ebp)
  802710:	e8 01 f8 ff ff       	call   801f16 <strlen>
  802715:	83 c4 04             	add    $0x4,%esp
  802718:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80271b:	7f a6                	jg     8026c3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80271d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802728:	a1 08 70 80 00       	mov    0x807008,%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	0f 84 95 00 00 00    	je     8027ca <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802735:	83 ec 08             	sub    $0x8,%esp
  802738:	68 00 00 00 82       	push   $0x82000000
  80273d:	68 00 00 00 80       	push   $0x80000000
  802742:	e8 59 1f 00 00       	call   8046a0 <initialize_dynamic_allocator>
  802747:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80274a:	e8 93 1d 00 00       	call   8044e2 <sys_get_uheap_strategy>
  80274f:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802754:	a1 20 72 80 00       	mov    0x807220,%eax
  802759:	05 00 10 00 00       	add    $0x1000,%eax
  80275e:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802763:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802768:	a3 50 f2 81 00       	mov    %eax,0x81f250
		init_uspinlock(&ulock,"malloc",1);
  80276d:	83 ec 04             	sub    $0x4,%esp
  802770:	6a 01                	push   $0x1
  802772:	68 c8 61 80 00       	push   $0x8061c8
  802777:	68 20 f3 81 00       	push   $0x81f320
  80277c:	e8 1a 29 00 00       	call   80509b <init_uspinlock>
  802781:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  802784:	c7 05 00 f3 81 00 00 	movl   $0x0,0x81f300
  80278b:	00 00 00 
  80278e:	c7 05 04 f3 81 00 00 	movl   $0x0,0x81f304
  802795:	00 00 00 
  802798:	c7 05 0c f3 81 00 00 	movl   $0x0,0x81f30c
  80279f:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  8027a2:	c7 05 10 f3 81 00 00 	movl   $0x0,0x81f310
  8027a9:	00 00 00 
  8027ac:	c7 05 14 f3 81 00 00 	movl   $0x0,0x81f314
  8027b3:	00 00 00 
  8027b6:	c7 05 1c f3 81 00 00 	movl   $0x0,0x81f31c
  8027bd:	00 00 00 
		__firstTimeFlag = 0;
  8027c0:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  8027c7:	00 00 00 
	}
}
  8027ca:	90                   	nop
  8027cb:	c9                   	leave  
  8027cc:	c3                   	ret    

008027cd <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8027cd:	55                   	push   %ebp
  8027ce:	89 e5                	mov    %esp,%ebp
  8027d0:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8027e1:	83 ec 08             	sub    $0x8,%esp
  8027e4:	68 06 04 00 00       	push   $0x406
  8027e9:	50                   	push   %eax
  8027ea:	e8 3d 19 00 00       	call   80412c <__sys_allocate_page>
  8027ef:	83 c4 10             	add    $0x10,%esp
  8027f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8027f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027f9:	79 14                	jns    80280f <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8027fb:	83 ec 04             	sub    $0x4,%esp
  8027fe:	68 d0 61 80 00       	push   $0x8061d0
  802803:	6a 2d                	push   $0x2d
  802805:	68 0c 62 80 00       	push   $0x80620c
  80280a:	e8 60 ed ff ff       	call   80156f <_panic>
	return 0;
  80280f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802814:	c9                   	leave  
  802815:	c3                   	ret    

00802816 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802816:	55                   	push   %ebp
  802817:	89 e5                	mov    %esp,%ebp
  802819:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80281c:	8b 45 08             	mov    0x8(%ebp),%eax
  80281f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80282a:	83 ec 0c             	sub    $0xc,%esp
  80282d:	50                   	push   %eax
  80282e:	e8 40 19 00 00       	call   804173 <__sys_unmap_frame>
  802833:	83 c4 10             	add    $0x10,%esp
  802836:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802839:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80283d:	79 14                	jns    802853 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80283f:	83 ec 04             	sub    $0x4,%esp
  802842:	68 18 62 80 00       	push   $0x806218
  802847:	6a 38                	push   $0x38
  802849:	68 0c 62 80 00       	push   $0x80620c
  80284e:	e8 1c ed ff ff       	call   80156f <_panic>
}
  802853:	90                   	nop
  802854:	c9                   	leave  
  802855:	c3                   	ret    

00802856 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80285c:	e8 c1 fe ff ff       	call   802722 <uheap_init>
	if (size == 0) return NULL ;
  802861:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802865:	75 0a                	jne    802871 <malloc+0x1b>
  802867:	b8 00 00 00 00       	mov    $0x0,%eax
  80286c:	e9 e1 04 00 00       	jmp    802d52 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  802871:	83 ec 0c             	sub    $0xc,%esp
  802874:	68 20 f3 81 00       	push   $0x81f320
  802879:	e8 6c 28 00 00       	call   8050ea <acquire_uspinlock>
  80287e:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  802881:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  802888:	77 23                	ja     8028ad <malloc+0x57>
		release_uspinlock(&ulock);
  80288a:	83 ec 0c             	sub    $0xc,%esp
  80288d:	68 20 f3 81 00       	push   $0x81f320
  802892:	e8 ab 28 00 00       	call   805142 <release_uspinlock>
  802897:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  80289a:	83 ec 0c             	sub    $0xc,%esp
  80289d:	ff 75 08             	pushl  0x8(%ebp)
  8028a0:	e8 dd 1f 00 00       	call   804882 <alloc_block>
  8028a5:	83 c4 10             	add    $0x10,%esp
  8028a8:	e9 a5 04 00 00       	jmp    802d52 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8028ad:	83 ec 0c             	sub    $0xc,%esp
  8028b0:	6a 10                	push   $0x10
  8028b2:	e8 cb 1f 00 00       	call   804882 <alloc_block>
  8028b7:	83 c4 10             	add    $0x10,%esp
  8028ba:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  8028bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028c1:	75 0a                	jne    8028cd <malloc+0x77>
			return NULL;
  8028c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c8:	e9 85 04 00 00       	jmp    802d52 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  8028cd:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8028d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028da:	01 d0                	add    %edx,%eax
  8028dc:	48                   	dec    %eax
  8028dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8028e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8028e8:	f7 75 e8             	divl   -0x18(%ebp)
  8028eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ee:	29 d0                	sub    %edx,%eax
  8028f0:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8028f3:	a1 04 f3 81 00       	mov    0x81f304,%eax
  8028f8:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8028fb:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0f                	je     802913 <malloc+0xbd>
  802904:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290d:	0f 83 ea 00 00 00    	jae    8029fd <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  802913:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802918:	2b 45 08             	sub    0x8(%ebp),%eax
  80291b:	89 c2                	mov    %eax,%edx
  80291d:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802922:	39 c2                	cmp    %eax,%edx
  802924:	0f 86 b9 00 00 00    	jbe    8029e3 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  80292a:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80292f:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  802932:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  802938:	8b 45 08             	mov    0x8(%ebp),%eax
  80293b:	01 d0                	add    %edx,%eax
  80293d:	a3 50 f2 81 00       	mov    %eax,0x81f250
					allocblock->startva = requestedblockva;
  802942:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802945:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802948:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80294a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294d:	8b 55 08             	mov    0x8(%ebp),%edx
  802950:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802953:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802957:	75 14                	jne    80296d <malloc+0x117>
  802959:	83 ec 04             	sub    $0x4,%esp
  80295c:	68 58 62 80 00       	push   $0x806258
  802961:	6a 60                	push   $0x60
  802963:	68 0c 62 80 00       	push   $0x80620c
  802968:	e8 02 ec ff ff       	call   80156f <_panic>
  80296d:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802973:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802976:	89 50 0c             	mov    %edx,0xc(%eax)
  802979:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297c:	8b 40 0c             	mov    0xc(%eax),%eax
  80297f:	85 c0                	test   %eax,%eax
  802981:	74 0d                	je     802990 <malloc+0x13a>
  802983:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802988:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80298b:	89 50 08             	mov    %edx,0x8(%eax)
  80298e:	eb 08                	jmp    802998 <malloc+0x142>
  802990:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802993:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299b:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8029a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029aa:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  8029af:	40                   	inc    %eax
  8029b0:	a3 1c f3 81 00       	mov    %eax,0x81f31c


					sys_allocate_user_mem(allocblock->startva ,size);
  8029b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b8:	8b 00                	mov    (%eax),%eax
  8029ba:	83 ec 08             	sub    $0x8,%esp
  8029bd:	ff 75 08             	pushl  0x8(%ebp)
  8029c0:	50                   	push   %eax
  8029c1:	e8 34 1c 00 00       	call   8045fa <sys_allocate_user_mem>
  8029c6:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  8029c9:	83 ec 0c             	sub    $0xc,%esp
  8029cc:	68 20 f3 81 00       	push   $0x81f320
  8029d1:	e8 6c 27 00 00       	call   805142 <release_uspinlock>
  8029d6:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8029d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	e9 6f 03 00 00       	jmp    802d52 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  8029e3:	83 ec 0c             	sub    $0xc,%esp
  8029e6:	68 20 f3 81 00       	push   $0x81f320
  8029eb:	e8 52 27 00 00       	call   805142 <release_uspinlock>
  8029f0:	83 c4 10             	add    $0x10,%esp
					return NULL;
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	e9 55 03 00 00       	jmp    802d52 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8029fd:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  802a05:	e9 39 03 00 00       	jmp    802d43 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 40 04             	mov    0x4(%eax),%eax
  802a10:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a13:	0f 86 e7 01 00 00    	jbe    802c00 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  802a19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a1c:	8b 10                	mov    (%eax),%edx
  802a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a21:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  802a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a26:	8b 55 08             	mov    0x8(%ebp),%edx
  802a29:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802a2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a30:	75 14                	jne    802a46 <malloc+0x1f0>
  802a32:	83 ec 04             	sub    $0x4,%esp
  802a35:	68 58 62 80 00       	push   $0x806258
  802a3a:	6a 72                	push   $0x72
  802a3c:	68 0c 62 80 00       	push   $0x80620c
  802a41:	e8 29 eb ff ff       	call   80156f <_panic>
  802a46:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802a4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4f:	89 50 0c             	mov    %edx,0xc(%eax)
  802a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a55:	8b 40 0c             	mov    0xc(%eax),%eax
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	74 0d                	je     802a69 <malloc+0x213>
  802a5c:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802a61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a64:	89 50 08             	mov    %edx,0x8(%eax)
  802a67:	eb 08                	jmp    802a71 <malloc+0x21b>
  802a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6c:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a74:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a83:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802a88:	40                   	inc    %eax
  802a89:	a3 1c f3 81 00       	mov    %eax,0x81f31c
                lastfreeelement->startva += size;
  802a8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a91:	8b 10                	mov    (%eax),%edx
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	01 c2                	add    %eax,%edx
  802a98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9b:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  802a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa0:	8b 40 04             	mov    0x4(%eax),%eax
  802aa3:	2b 45 08             	sub    0x8(%ebp),%eax
  802aa6:	89 c2                	mov    %eax,%edx
  802aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aab:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802aae:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  802ab6:	e9 0d 01 00 00       	jmp    802bc8 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  802abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802abe:	8b 50 04             	mov    0x4(%eax),%edx
  802ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac4:	8b 40 04             	mov    0x4(%eax),%eax
  802ac7:	39 c2                	cmp    %eax,%edx
  802ac9:	0f 83 f0 00 00 00    	jae    802bbf <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802acf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ad3:	75 14                	jne    802ae9 <malloc+0x293>
  802ad5:	83 ec 04             	sub    $0x4,%esp
  802ad8:	68 7b 62 80 00       	push   $0x80627b
  802add:	6a 7a                	push   $0x7a
  802adf:	68 0c 62 80 00       	push   $0x80620c
  802ae4:	e8 86 ea ff ff       	call   80156f <_panic>
  802ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aec:	8b 40 08             	mov    0x8(%eax),%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	74 11                	je     802b04 <malloc+0x2ae>
  802af3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af6:	8b 40 08             	mov    0x8(%eax),%eax
  802af9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802afc:	8b 52 0c             	mov    0xc(%edx),%edx
  802aff:	89 50 0c             	mov    %edx,0xc(%eax)
  802b02:	eb 0b                	jmp    802b0f <malloc+0x2b9>
  802b04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b07:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0a:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b12:	8b 40 0c             	mov    0xc(%eax),%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	74 11                	je     802b2a <malloc+0x2d4>
  802b19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b22:	8b 52 08             	mov    0x8(%edx),%edx
  802b25:	89 50 08             	mov    %edx,0x8(%eax)
  802b28:	eb 0b                	jmp    802b35 <malloc+0x2df>
  802b2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2d:	8b 40 08             	mov    0x8(%eax),%eax
  802b30:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802b35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b49:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802b4e:	48                   	dec    %eax
  802b4f:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802b54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b58:	74 06                	je     802b60 <malloc+0x30a>
  802b5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b5e:	75 14                	jne    802b74 <malloc+0x31e>
  802b60:	83 ec 04             	sub    $0x4,%esp
  802b63:	68 9c 62 80 00       	push   $0x80629c
  802b68:	6a 7b                	push   $0x7b
  802b6a:	68 0c 62 80 00       	push   $0x80620c
  802b6f:	e8 fb e9 ff ff       	call   80156f <_panic>
  802b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b77:	8b 50 0c             	mov    0xc(%eax),%edx
  802b7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7d:	89 50 0c             	mov    %edx,0xc(%eax)
  802b80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b86:	89 50 08             	mov    %edx,0x8(%eax)
  802b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	74 0e                	je     802ba1 <malloc+0x34b>
  802b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b96:	8b 40 0c             	mov    0xc(%eax),%eax
  802b99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b9c:	89 50 08             	mov    %edx,0x8(%eax)
  802b9f:	eb 08                	jmp    802ba9 <malloc+0x353>
  802ba1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba4:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802baf:	89 50 0c             	mov    %edx,0xc(%eax)
  802bb2:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802bb7:	40                   	inc    %eax
  802bb8:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		break;
  802bbd:	eb 13                	jmp    802bd2 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  802bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc2:	8b 40 08             	mov    0x8(%eax),%eax
  802bc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  802bc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bcc:	0f 85 e9 fe ff ff    	jne    802abb <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  802bd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	83 ec 08             	sub    $0x8,%esp
  802bda:	ff 75 08             	pushl  0x8(%ebp)
  802bdd:	50                   	push   %eax
  802bde:	e8 17 1a 00 00       	call   8045fa <sys_allocate_user_mem>
  802be3:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  802be6:	83 ec 0c             	sub    $0xc,%esp
  802be9:	68 20 f3 81 00       	push   $0x81f320
  802bee:	e8 4f 25 00 00       	call   805142 <release_uspinlock>
  802bf3:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  802bf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	e9 52 01 00 00       	jmp    802d52 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c09:	0f 85 2b 01 00 00    	jne    802d3a <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 10                	mov    (%eax),%edx
  802c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c17:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  802c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1f:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802c22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c26:	75 17                	jne    802c3f <malloc+0x3e9>
  802c28:	83 ec 04             	sub    $0x4,%esp
  802c2b:	68 58 62 80 00       	push   $0x806258
  802c30:	68 89 00 00 00       	push   $0x89
  802c35:	68 0c 62 80 00       	push   $0x80620c
  802c3a:	e8 30 e9 ff ff       	call   80156f <_panic>
  802c3f:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c48:	89 50 0c             	mov    %edx,0xc(%eax)
  802c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	74 0d                	je     802c62 <malloc+0x40c>
  802c55:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802c5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c5d:	89 50 08             	mov    %edx,0x8(%eax)
  802c60:	eb 08                	jmp    802c6a <malloc+0x414>
  802c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c65:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6d:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c75:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c7c:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802c81:	40                   	inc    %eax
  802c82:	a3 1c f3 81 00       	mov    %eax,0x81f31c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  802c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8b:	75 17                	jne    802ca4 <malloc+0x44e>
  802c8d:	83 ec 04             	sub    $0x4,%esp
  802c90:	68 7b 62 80 00       	push   $0x80627b
  802c95:	68 8a 00 00 00       	push   $0x8a
  802c9a:	68 0c 62 80 00       	push   $0x80620c
  802c9f:	e8 cb e8 ff ff       	call   80156f <_panic>
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 40 08             	mov    0x8(%eax),%eax
  802caa:	85 c0                	test   %eax,%eax
  802cac:	74 11                	je     802cbf <malloc+0x469>
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 40 08             	mov    0x8(%eax),%eax
  802cb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb7:	8b 52 0c             	mov    0xc(%edx),%edx
  802cba:	89 50 0c             	mov    %edx,0xc(%eax)
  802cbd:	eb 0b                	jmp    802cca <malloc+0x474>
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc5:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 11                	je     802ce5 <malloc+0x48f>
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdd:	8b 52 08             	mov    0x8(%edx),%edx
  802ce0:	89 50 08             	mov    %edx,0x8(%eax)
  802ce3:	eb 0b                	jmp    802cf0 <malloc+0x49a>
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 40 08             	mov    0x8(%eax),%eax
  802ceb:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d04:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802d09:	48                   	dec    %eax
  802d0a:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				sys_allocate_user_mem(allocblock->startva ,size);
  802d0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d12:	8b 00                	mov    (%eax),%eax
  802d14:	83 ec 08             	sub    $0x8,%esp
  802d17:	ff 75 08             	pushl  0x8(%ebp)
  802d1a:	50                   	push   %eax
  802d1b:	e8 da 18 00 00       	call   8045fa <sys_allocate_user_mem>
  802d20:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  802d23:	83 ec 0c             	sub    $0xc,%esp
  802d26:	68 20 f3 81 00       	push   $0x81f320
  802d2b:	e8 12 24 00 00       	call   805142 <release_uspinlock>
  802d30:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  802d33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	eb 18                	jmp    802d52 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 08             	mov    0x8(%eax),%eax
  802d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  802d43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d47:	0f 85 bd fc ff ff    	jne    802a0a <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  802d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d52:	c9                   	leave  
  802d53:	c3                   	ret    

00802d54 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802d54:	55                   	push   %ebp
  802d55:	89 e5                	mov    %esp,%ebp
  802d57:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802d68:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  802d6b:	e8 b2 f9 ff ff       	call   802722 <uheap_init>
		acquire_uspinlock(&ulock);
  802d70:	83 ec 0c             	sub    $0xc,%esp
  802d73:	68 20 f3 81 00       	push   $0x81f320
  802d78:	e8 6d 23 00 00       	call   8050ea <acquire_uspinlock>
  802d7d:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  802d80:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802d85:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802d88:	73 23                	jae    802dad <free+0x59>
			free_block(virtual_address);
  802d8a:	83 ec 0c             	sub    $0xc,%esp
  802d8d:	ff 75 08             	pushl  0x8(%ebp)
  802d90:	e8 89 1f 00 00       	call   804d1e <free_block>
  802d95:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  802d98:	83 ec 0c             	sub    $0xc,%esp
  802d9b:	68 20 f3 81 00       	push   $0x81f320
  802da0:	e8 9d 23 00 00       	call   805142 <release_uspinlock>
  802da5:	83 c4 10             	add    $0x10,%esp
			return;
  802da8:	e9 35 07 00 00       	jmp    8034e2 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802dad:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802db2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802db5:	72 30                	jb     802de7 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  802db7:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802dbc:	83 ec 04             	sub    $0x4,%esp
  802dbf:	50                   	push   %eax
  802dc0:	ff 75 d8             	pushl  -0x28(%ebp)
  802dc3:	68 d1 62 80 00       	push   $0x8062d1
  802dc8:	e8 70 ea ff ff       	call   80183d <cprintf>
  802dcd:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802dd0:	83 ec 04             	sub    $0x4,%esp
  802dd3:	68 d9 62 80 00       	push   $0x8062d9
  802dd8:	68 a7 00 00 00       	push   $0xa7
  802ddd:	68 0c 62 80 00       	push   $0x80620c
  802de2:	e8 88 e7 ff ff       	call   80156f <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802de7:	83 ec 0c             	sub    $0xc,%esp
  802dea:	6a 10                	push   $0x10
  802dec:	e8 91 1a 00 00       	call   804882 <alloc_block>
  802df1:	83 c4 10             	add    $0x10,%esp
  802df4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  802df7:	83 ec 0c             	sub    $0xc,%esp
  802dfa:	6a 10                	push   $0x10
  802dfc:	e8 81 1a 00 00       	call   804882 <alloc_block>
  802e01:	83 c4 10             	add    $0x10,%esp
  802e04:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  802e07:	a1 10 f3 81 00       	mov    0x81f310,%eax
  802e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  802e0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  802e16:	eb 1c                	jmp    802e34 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802e20:	75 09                	jne    802e2b <free+0xd7>
				foundVA = 1;
  802e22:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  802e29:	eb 0f                	jmp    802e3a <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	8b 40 08             	mov    0x8(%eax),%eax
  802e31:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  802e34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e38:	75 de                	jne    802e18 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  802e3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e3e:	75 17                	jne    802e57 <free+0x103>
				panic("INVALID ADDRESS!");
  802e40:	83 ec 04             	sub    $0x4,%esp
  802e43:	68 f6 62 80 00       	push   $0x8062f6
  802e48:	68 be 00 00 00       	push   $0xbe
  802e4d:	68 0c 62 80 00       	push   $0x80620c
  802e52:	e8 18 e7 ff ff       	call   80156f <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 10                	mov    (%eax),%edx
  802e5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e5f:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 50 04             	mov    0x4(%eax),%edx
  802e67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e6a:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  802e6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e71:	75 17                	jne    802e8a <free+0x136>
  802e73:	83 ec 04             	sub    $0x4,%esp
  802e76:	68 7b 62 80 00       	push   $0x80627b
  802e7b:	68 c8 00 00 00       	push   $0xc8
  802e80:	68 0c 62 80 00       	push   $0x80620c
  802e85:	e8 e5 e6 ff ff       	call   80156f <_panic>
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 40 08             	mov    0x8(%eax),%eax
  802e90:	85 c0                	test   %eax,%eax
  802e92:	74 11                	je     802ea5 <free+0x151>
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 40 08             	mov    0x8(%eax),%eax
  802e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9d:	8b 52 0c             	mov    0xc(%edx),%edx
  802ea0:	89 50 0c             	mov    %edx,0xc(%eax)
  802ea3:	eb 0b                	jmp    802eb0 <free+0x15c>
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eab:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb6:	85 c0                	test   %eax,%eax
  802eb8:	74 11                	je     802ecb <free+0x177>
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec3:	8b 52 08             	mov    0x8(%edx),%edx
  802ec6:	89 50 08             	mov    %edx,0x8(%eax)
  802ec9:	eb 0b                	jmp    802ed6 <free+0x182>
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 40 08             	mov    0x8(%eax),%eax
  802ed1:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802eea:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802eef:	48                   	dec    %eax
  802ef0:	a3 1c f3 81 00       	mov    %eax,0x81f31c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 50 04             	mov    0x4(%eax),%edx
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 00                	mov    (%eax),%eax
  802f00:	83 ec 08             	sub    $0x8,%esp
  802f03:	52                   	push   %edx
  802f04:	50                   	push   %eax
  802f05:	e8 d4 16 00 00       	call   8045de <sys_free_user_mem>
  802f0a:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  802f0d:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802f12:	85 c0                	test   %eax,%eax
  802f14:	75 7a                	jne    802f90 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  802f16:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802f1a:	75 17                	jne    802f33 <free+0x1df>
  802f1c:	83 ec 04             	sub    $0x4,%esp
  802f1f:	68 08 63 80 00       	push   $0x806308
  802f24:	68 d0 00 00 00       	push   $0xd0
  802f29:	68 0c 62 80 00       	push   $0x80620c
  802f2e:	e8 3c e6 ff ff       	call   80156f <_panic>
  802f33:	8b 15 00 f3 81 00    	mov    0x81f300,%edx
  802f39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f3c:	89 50 08             	mov    %edx,0x8(%eax)
  802f3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f42:	8b 40 08             	mov    0x8(%eax),%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	74 0d                	je     802f56 <free+0x202>
  802f49:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802f4e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f51:	89 50 0c             	mov    %edx,0xc(%eax)
  802f54:	eb 08                	jmp    802f5e <free+0x20a>
  802f56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f59:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802f5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f61:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802f66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f69:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f70:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802f75:	40                   	inc    %eax
  802f76:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			release_uspinlock(&ulock);
  802f7b:	83 ec 0c             	sub    $0xc,%esp
  802f7e:	68 20 f3 81 00       	push   $0x81f320
  802f83:	e8 ba 21 00 00       	call   805142 <release_uspinlock>
  802f88:	83 c4 10             	add    $0x10,%esp
			return;
  802f8b:	e9 52 05 00 00       	jmp    8034e2 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  802f90:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802f95:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  802f98:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  802f9f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  802fa6:	e9 d2 00 00 00       	jmp    80307d <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  802fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fae:	8b 10                	mov    (%eax),%edx
  802fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb3:	8b 40 04             	mov    0x4(%eax),%eax
  802fb6:	01 c2                	add    %eax,%edx
  802fb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	39 c2                	cmp    %eax,%edx
  802fbf:	0f 85 af 00 00 00    	jne    803074 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  802fc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc8:	8b 10                	mov    (%eax),%edx
  802fca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fcd:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  802fcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd2:	8b 50 04             	mov    0x4(%eax),%edx
  802fd5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fd8:	8b 40 04             	mov    0x4(%eax),%eax
  802fdb:	01 c2                	add    %eax,%edx
  802fdd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fe0:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  802fe3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fe7:	75 17                	jne    803000 <free+0x2ac>
  802fe9:	83 ec 04             	sub    $0x4,%esp
  802fec:	68 7b 62 80 00       	push   $0x80627b
  802ff1:	68 df 00 00 00       	push   $0xdf
  802ff6:	68 0c 62 80 00       	push   $0x80620c
  802ffb:	e8 6f e5 ff ff       	call   80156f <_panic>
  803000:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803003:	8b 40 08             	mov    0x8(%eax),%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	74 11                	je     80301b <free+0x2c7>
  80300a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300d:	8b 40 08             	mov    0x8(%eax),%eax
  803010:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803013:	8b 52 0c             	mov    0xc(%edx),%edx
  803016:	89 50 0c             	mov    %edx,0xc(%eax)
  803019:	eb 0b                	jmp    803026 <free+0x2d2>
  80301b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301e:	8b 40 0c             	mov    0xc(%eax),%eax
  803021:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803026:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803029:	8b 40 0c             	mov    0xc(%eax),%eax
  80302c:	85 c0                	test   %eax,%eax
  80302e:	74 11                	je     803041 <free+0x2ed>
  803030:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803033:	8b 40 0c             	mov    0xc(%eax),%eax
  803036:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803039:	8b 52 08             	mov    0x8(%edx),%edx
  80303c:	89 50 08             	mov    %edx,0x8(%eax)
  80303f:	eb 0b                	jmp    80304c <free+0x2f8>
  803041:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803044:	8b 40 08             	mov    0x8(%eax),%eax
  803047:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80304c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803056:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803059:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803060:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803065:	48                   	dec    %eax
  803066:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				mergeprev = 1;
  80306b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  803072:	eb 13                	jmp    803087 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  803074:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803077:	8b 40 08             	mov    0x8(%eax),%eax
  80307a:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  80307d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803081:	0f 85 24 ff ff ff    	jne    802fab <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  803087:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80308a:	8b 10                	mov    (%eax),%edx
  80308c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80308f:	8b 40 04             	mov    0x4(%eax),%eax
  803092:	01 c2                	add    %eax,%edx
  803094:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803099:	39 c2                	cmp    %eax,%edx
  80309b:	75 44                	jne    8030e1 <free+0x38d>

			if(mergeprev){
  80309d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030a1:	74 1f                	je     8030c2 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  8030a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030a6:	8b 00                	mov    (%eax),%eax
  8030a8:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  8030ad:	83 ec 0c             	sub    $0xc,%esp
  8030b0:	68 20 f3 81 00       	push   $0x81f320
  8030b5:	e8 88 20 00 00       	call   805142 <release_uspinlock>
  8030ba:	83 c4 10             	add    $0x10,%esp
				return;
  8030bd:	e9 20 04 00 00       	jmp    8034e2 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  8030c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030c5:	8b 00                	mov    (%eax),%eax
  8030c7:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  8030cc:	83 ec 0c             	sub    $0xc,%esp
  8030cf:	68 20 f3 81 00       	push   $0x81f320
  8030d4:	e8 69 20 00 00       	call   805142 <release_uspinlock>
  8030d9:	83 c4 10             	add    $0x10,%esp
				return;
  8030dc:	e9 01 04 00 00       	jmp    8034e2 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  8030e1:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8030e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  8030e9:	e9 7d 01 00 00       	jmp    80326b <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  8030ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030f1:	8b 10                	mov    (%eax),%edx
  8030f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030f6:	8b 40 04             	mov    0x4(%eax),%eax
  8030f9:	01 c2                	add    %eax,%edx
  8030fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fe:	8b 00                	mov    (%eax),%eax
  803100:	39 c2                	cmp    %eax,%edx
  803102:	0f 85 5a 01 00 00    	jne    803262 <free+0x50e>
				if (mergeprev){
  803108:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80310c:	0f 84 a1 00 00 00    	je     8031b3 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  803112:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803115:	8b 50 04             	mov    0x4(%eax),%edx
  803118:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311b:	8b 40 04             	mov    0x4(%eax),%eax
  80311e:	01 c2                	add    %eax,%edx
  803120:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803123:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  803126:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80312a:	75 17                	jne    803143 <free+0x3ef>
  80312c:	83 ec 04             	sub    $0x4,%esp
  80312f:	68 7b 62 80 00       	push   $0x80627b
  803134:	68 0a 01 00 00       	push   $0x10a
  803139:	68 0c 62 80 00       	push   $0x80620c
  80313e:	e8 2c e4 ff ff       	call   80156f <_panic>
  803143:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803146:	8b 40 08             	mov    0x8(%eax),%eax
  803149:	85 c0                	test   %eax,%eax
  80314b:	74 11                	je     80315e <free+0x40a>
  80314d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803150:	8b 40 08             	mov    0x8(%eax),%eax
  803153:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803156:	8b 52 0c             	mov    0xc(%edx),%edx
  803159:	89 50 0c             	mov    %edx,0xc(%eax)
  80315c:	eb 0b                	jmp    803169 <free+0x415>
  80315e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803161:	8b 40 0c             	mov    0xc(%eax),%eax
  803164:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803169:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316c:	8b 40 0c             	mov    0xc(%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	74 11                	je     803184 <free+0x430>
  803173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803176:	8b 40 0c             	mov    0xc(%eax),%eax
  803179:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80317c:	8b 52 08             	mov    0x8(%edx),%edx
  80317f:	89 50 08             	mov    %edx,0x8(%eax)
  803182:	eb 0b                	jmp    80318f <free+0x43b>
  803184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803187:	8b 40 08             	mov    0x8(%eax),%eax
  80318a:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80318f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803192:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8031a3:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8031a8:	48                   	dec    %eax
  8031a9:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					break;
  8031ae:	e9 c2 00 00 00       	jmp    803275 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8031b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031b6:	8b 10                	mov    (%eax),%edx
  8031b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031bb:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  8031bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031c0:	8b 50 04             	mov    0x4(%eax),%edx
  8031c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c6:	8b 40 04             	mov    0x4(%eax),%eax
  8031c9:	01 c2                	add    %eax,%edx
  8031cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031ce:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8031d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031d5:	75 17                	jne    8031ee <free+0x49a>
  8031d7:	83 ec 04             	sub    $0x4,%esp
  8031da:	68 7b 62 80 00       	push   $0x80627b
  8031df:	68 10 01 00 00       	push   $0x110
  8031e4:	68 0c 62 80 00       	push   $0x80620c
  8031e9:	e8 81 e3 ff ff       	call   80156f <_panic>
  8031ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f1:	8b 40 08             	mov    0x8(%eax),%eax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 11                	je     803209 <free+0x4b5>
  8031f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fb:	8b 40 08             	mov    0x8(%eax),%eax
  8031fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803201:	8b 52 0c             	mov    0xc(%edx),%edx
  803204:	89 50 0c             	mov    %edx,0xc(%eax)
  803207:	eb 0b                	jmp    803214 <free+0x4c0>
  803209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320c:	8b 40 0c             	mov    0xc(%eax),%eax
  80320f:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803214:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803217:	8b 40 0c             	mov    0xc(%eax),%eax
  80321a:	85 c0                	test   %eax,%eax
  80321c:	74 11                	je     80322f <free+0x4db>
  80321e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803221:	8b 40 0c             	mov    0xc(%eax),%eax
  803224:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803227:	8b 52 08             	mov    0x8(%edx),%edx
  80322a:	89 50 08             	mov    %edx,0x8(%eax)
  80322d:	eb 0b                	jmp    80323a <free+0x4e6>
  80322f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803232:	8b 40 08             	mov    0x8(%eax),%eax
  803235:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80323a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803247:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80324e:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803253:	48                   	dec    %eax
  803254:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					mergenext = 1;
  803259:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  803260:	eb 13                	jmp    803275 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  803262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803265:	8b 40 08             	mov    0x8(%eax),%eax
  803268:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  80326b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80326f:	0f 85 79 fe ff ff    	jne    8030ee <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  803275:	a1 00 f3 81 00       	mov    0x81f300,%eax
  80327a:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  80327d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803281:	0f 85 ad 00 00 00    	jne    803334 <free+0x5e0>
  803287:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80328b:	0f 84 c3 01 00 00    	je     803454 <free+0x700>
				while(currentfree != NULL){
  803291:	e9 9e 00 00 00       	jmp    803334 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  803296:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803299:	8b 50 04             	mov    0x4(%eax),%edx
  80329c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80329f:	8b 40 04             	mov    0x4(%eax),%eax
  8032a2:	39 c2                	cmp    %eax,%edx
  8032a4:	0f 83 81 00 00 00    	jae    80332b <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8032aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8032ae:	74 06                	je     8032b6 <free+0x562>
  8032b0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8032b4:	75 17                	jne    8032cd <free+0x579>
  8032b6:	83 ec 04             	sub    $0x4,%esp
  8032b9:	68 9c 62 80 00       	push   $0x80629c
  8032be:	68 23 01 00 00       	push   $0x123
  8032c3:	68 0c 62 80 00       	push   $0x80620c
  8032c8:	e8 a2 e2 ff ff       	call   80156f <_panic>
  8032cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d0:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032d6:	89 50 0c             	mov    %edx,0xc(%eax)
  8032d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032df:	89 50 08             	mov    %edx,0x8(%eax)
  8032e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e8:	85 c0                	test   %eax,%eax
  8032ea:	74 0e                	je     8032fa <free+0x5a6>
  8032ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8032f5:	89 50 08             	mov    %edx,0x8(%eax)
  8032f8:	eb 08                	jmp    803302 <free+0x5ae>
  8032fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032fd:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803302:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803305:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803308:	89 50 0c             	mov    %edx,0xc(%eax)
  80330b:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803310:	40                   	inc    %eax
  803311:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  803316:	83 ec 0c             	sub    $0xc,%esp
  803319:	68 20 f3 81 00       	push   $0x81f320
  80331e:	e8 1f 1e 00 00       	call   805142 <release_uspinlock>
  803323:	83 c4 10             	add    $0x10,%esp
							return;
  803326:	e9 b7 01 00 00       	jmp    8034e2 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80332b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80332e:	8b 40 08             	mov    0x8(%eax),%eax
  803331:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  803334:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803338:	0f 85 58 ff ff ff    	jne    803296 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  80333e:	83 ec 0c             	sub    $0xc,%esp
  803341:	ff 75 d4             	pushl  -0x2c(%ebp)
  803344:	e8 d5 19 00 00       	call   804d1e <free_block>
  803349:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  80334c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803350:	75 17                	jne    803369 <free+0x615>
  803352:	83 ec 04             	sub    $0x4,%esp
  803355:	68 58 62 80 00       	push   $0x806258
  80335a:	68 2a 01 00 00       	push   $0x12a
  80335f:	68 0c 62 80 00       	push   $0x80620c
  803364:	e8 06 e2 ff ff       	call   80156f <_panic>
  803369:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  80336f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803372:	89 50 0c             	mov    %edx,0xc(%eax)
  803375:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803378:	8b 40 0c             	mov    0xc(%eax),%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	74 0d                	je     80338c <free+0x638>
  80337f:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803384:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803387:	89 50 08             	mov    %edx,0x8(%eax)
  80338a:	eb 08                	jmp    803394 <free+0x640>
  80338c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80338f:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803394:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803397:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80339c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80339f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8033a6:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8033ab:	40                   	inc    %eax
  8033ac:	a3 0c f3 81 00       	mov    %eax,0x81f30c
  8033b1:	e9 1b 01 00 00       	jmp    8034d1 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8033b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b9:	8b 50 04             	mov    0x4(%eax),%edx
  8033bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033bf:	8b 40 04             	mov    0x4(%eax),%eax
  8033c2:	39 c2                	cmp    %eax,%edx
  8033c4:	0f 83 81 00 00 00    	jae    80344b <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8033ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033ce:	74 06                	je     8033d6 <free+0x682>
  8033d0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033d4:	75 17                	jne    8033ed <free+0x699>
  8033d6:	83 ec 04             	sub    $0x4,%esp
  8033d9:	68 9c 62 80 00       	push   $0x80629c
  8033de:	68 30 01 00 00       	push   $0x130
  8033e3:	68 0c 62 80 00       	push   $0x80620c
  8033e8:	e8 82 e1 ff ff       	call   80156f <_panic>
  8033ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f6:	89 50 0c             	mov    %edx,0xc(%eax)
  8033f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ff:	89 50 08             	mov    %edx,0x8(%eax)
  803402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803405:	8b 40 0c             	mov    0xc(%eax),%eax
  803408:	85 c0                	test   %eax,%eax
  80340a:	74 0e                	je     80341a <free+0x6c6>
  80340c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80340f:	8b 40 0c             	mov    0xc(%eax),%eax
  803412:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803415:	89 50 08             	mov    %edx,0x8(%eax)
  803418:	eb 08                	jmp    803422 <free+0x6ce>
  80341a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80341d:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803425:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803428:	89 50 0c             	mov    %edx,0xc(%eax)
  80342b:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803430:	40                   	inc    %eax
  803431:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  803436:	83 ec 0c             	sub    $0xc,%esp
  803439:	68 20 f3 81 00       	push   $0x81f320
  80343e:	e8 ff 1c 00 00       	call   805142 <release_uspinlock>
  803443:	83 c4 10             	add    $0x10,%esp
							return;
  803446:	e9 97 00 00 00       	jmp    8034e2 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80344b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80344e:	8b 40 08             	mov    0x8(%eax),%eax
  803451:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  803454:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803458:	0f 85 58 ff ff ff    	jne    8033b6 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  80345e:	83 ec 0c             	sub    $0xc,%esp
  803461:	ff 75 d0             	pushl  -0x30(%ebp)
  803464:	e8 b5 18 00 00       	call   804d1e <free_block>
  803469:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  80346c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803470:	75 17                	jne    803489 <free+0x735>
  803472:	83 ec 04             	sub    $0x4,%esp
  803475:	68 58 62 80 00       	push   $0x806258
  80347a:	68 37 01 00 00       	push   $0x137
  80347f:	68 0c 62 80 00       	push   $0x80620c
  803484:	e8 e6 e0 ff ff       	call   80156f <_panic>
  803489:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  80348f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803492:	89 50 0c             	mov    %edx,0xc(%eax)
  803495:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803498:	8b 40 0c             	mov    0xc(%eax),%eax
  80349b:	85 c0                	test   %eax,%eax
  80349d:	74 0d                	je     8034ac <free+0x758>
  80349f:	a1 04 f3 81 00       	mov    0x81f304,%eax
  8034a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034a7:	89 50 08             	mov    %edx,0x8(%eax)
  8034aa:	eb 08                	jmp    8034b4 <free+0x760>
  8034ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034af:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8034b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b7:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8034bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8034c6:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8034cb:	40                   	inc    %eax
  8034cc:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			}
		release_uspinlock(&ulock);
  8034d1:	83 ec 0c             	sub    $0xc,%esp
  8034d4:	68 20 f3 81 00       	push   $0x81f320
  8034d9:	e8 64 1c 00 00       	call   805142 <release_uspinlock>
  8034de:	83 c4 10             	add    $0x10,%esp
		return;
  8034e1:	90                   	nop
}
  8034e2:	c9                   	leave  
  8034e3:	c3                   	ret    

008034e4 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8034e4:	55                   	push   %ebp
  8034e5:	89 e5                	mov    %esp,%ebp
  8034e7:	83 ec 48             	sub    $0x48,%esp
  8034ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8034ed:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8034f0:	e8 2d f2 ff ff       	call   802722 <uheap_init>
	if (size == 0) return NULL;
  8034f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034f9:	75 0a                	jne    803505 <smalloc+0x21>
  8034fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803500:	e9 84 05 00 00       	jmp    803a89 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  803505:	83 ec 0c             	sub    $0xc,%esp
  803508:	68 20 f3 81 00       	push   $0x81f320
  80350d:	e8 d8 1b 00 00       	call   8050ea <acquire_uspinlock>
  803512:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803515:	83 ec 0c             	sub    $0xc,%esp
  803518:	6a 10                	push   $0x10
  80351a:	e8 63 13 00 00       	call   804882 <alloc_block>
  80351f:	83 c4 10             	add    $0x10,%esp
  803522:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  803525:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803529:	75 0a                	jne    803535 <smalloc+0x51>
				return NULL;
  80352b:	b8 00 00 00 00       	mov    $0x0,%eax
  803530:	e9 54 05 00 00       	jmp    803a89 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  803535:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80353c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80353f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803542:	01 d0                	add    %edx,%eax
  803544:	48                   	dec    %eax
  803545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354b:	ba 00 00 00 00       	mov    $0x0,%edx
  803550:	f7 75 e8             	divl   -0x18(%ebp)
  803553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803556:	29 d0                	sub    %edx,%eax
  803558:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80355b:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803560:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  803563:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803568:	85 c0                	test   %eax,%eax
  80356a:	74 0f                	je     80357b <smalloc+0x97>
  80356c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80356f:	8b 40 04             	mov    0x4(%eax),%eax
  803572:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803575:	0f 83 25 01 00 00    	jae    8036a0 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  80357b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  803580:	2b 45 0c             	sub    0xc(%ebp),%eax
  803583:	89 c2                	mov    %eax,%edx
  803585:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80358a:	39 c2                	cmp    %eax,%edx
  80358c:	0f 82 f4 00 00 00    	jb     803686 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  803592:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803597:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  80359a:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8035a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a3:	01 d0                	add    %edx,%eax
  8035a5:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  8035aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035b0:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8035b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035b8:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8035bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035bf:	75 17                	jne    8035d8 <smalloc+0xf4>
  8035c1:	83 ec 04             	sub    $0x4,%esp
  8035c4:	68 58 62 80 00       	push   $0x806258
  8035c9:	68 57 01 00 00       	push   $0x157
  8035ce:	68 0c 62 80 00       	push   $0x80620c
  8035d3:	e8 97 df ff ff       	call   80156f <_panic>
  8035d8:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8035de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e1:	89 50 0c             	mov    %edx,0xc(%eax)
  8035e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	74 0d                	je     8035fb <smalloc+0x117>
  8035ee:	a1 14 f3 81 00       	mov    0x81f314,%eax
  8035f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035f6:	89 50 08             	mov    %edx,0x8(%eax)
  8035f9:	eb 08                	jmp    803603 <smalloc+0x11f>
  8035fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fe:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803603:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803606:	a3 14 f3 81 00       	mov    %eax,0x81f314
  80360b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803615:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  80361a:	40                   	inc    %eax
  80361b:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803620:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803623:	8b 00                	mov    (%eax),%eax
  803625:	89 c2                	mov    %eax,%edx
  803627:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80362b:	52                   	push   %edx
  80362c:	50                   	push   %eax
  80362d:	ff 75 0c             	pushl  0xc(%ebp)
  803630:	ff 75 08             	pushl  0x8(%ebp)
  803633:	e8 48 0c 00 00       	call   804280 <sys_create_shared_object>
  803638:	83 c4 10             	add    $0x10,%esp
  80363b:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  80363e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803642:	79 28                	jns    80366c <smalloc+0x188>
							free_block(allocblock);
  803644:	83 ec 0c             	sub    $0xc,%esp
  803647:	ff 75 ec             	pushl  -0x14(%ebp)
  80364a:	e8 cf 16 00 00       	call   804d1e <free_block>
  80364f:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803652:	83 ec 0c             	sub    $0xc,%esp
  803655:	68 20 f3 81 00       	push   $0x81f320
  80365a:	e8 e3 1a 00 00       	call   805142 <release_uspinlock>
  80365f:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803662:	b8 00 00 00 00       	mov    $0x0,%eax
  803667:	e9 1d 04 00 00       	jmp    803a89 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  80366c:	83 ec 0c             	sub    $0xc,%esp
  80366f:	68 20 f3 81 00       	push   $0x81f320
  803674:	e8 c9 1a 00 00       	call   805142 <release_uspinlock>
  803679:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  80367c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80367f:	8b 00                	mov    (%eax),%eax
  803681:	e9 03 04 00 00       	jmp    803a89 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  803686:	83 ec 0c             	sub    $0xc,%esp
  803689:	68 20 f3 81 00       	push   $0x81f320
  80368e:	e8 af 1a 00 00       	call   805142 <release_uspinlock>
  803693:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803696:	b8 00 00 00 00       	mov    $0x0,%eax
  80369b:	e9 e9 03 00 00       	jmp    803a89 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8036a0:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8036a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8036a8:	e9 af 03 00 00       	jmp    803a5c <smalloc+0x578>
				if(size<currentfreeelement->size){
  8036ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b0:	8b 40 04             	mov    0x4(%eax),%eax
  8036b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036b6:	0f 86 28 02 00 00    	jbe    8038e4 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  8036bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036bf:	8b 10                	mov    (%eax),%edx
  8036c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c4:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  8036c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036cc:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8036cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036d3:	75 17                	jne    8036ec <smalloc+0x208>
  8036d5:	83 ec 04             	sub    $0x4,%esp
  8036d8:	68 58 62 80 00       	push   $0x806258
  8036dd:	68 6f 01 00 00       	push   $0x16f
  8036e2:	68 0c 62 80 00       	push   $0x80620c
  8036e7:	e8 83 de ff ff       	call   80156f <_panic>
  8036ec:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8036f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f5:	89 50 0c             	mov    %edx,0xc(%eax)
  8036f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8036fe:	85 c0                	test   %eax,%eax
  803700:	74 0d                	je     80370f <smalloc+0x22b>
  803702:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803707:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80370a:	89 50 08             	mov    %edx,0x8(%eax)
  80370d:	eb 08                	jmp    803717 <smalloc+0x233>
  80370f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803712:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80371a:	a3 14 f3 81 00       	mov    %eax,0x81f314
  80371f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803722:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803729:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  80372e:	40                   	inc    %eax
  80372f:	a3 1c f3 81 00       	mov    %eax,0x81f31c
	                lastfreeelement->startva += size;
  803734:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803737:	8b 10                	mov    (%eax),%edx
  803739:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373c:	01 c2                	add    %eax,%edx
  80373e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803741:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  803743:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803746:	8b 40 04             	mov    0x4(%eax),%eax
  803749:	2b 45 0c             	sub    0xc(%ebp),%eax
  80374c:	89 c2                	mov    %eax,%edx
  80374e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803751:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803754:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803759:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  80375c:	e9 13 01 00 00       	jmp    803874 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  803761:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803764:	8b 50 04             	mov    0x4(%eax),%edx
  803767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376a:	8b 40 04             	mov    0x4(%eax),%eax
  80376d:	39 c2                	cmp    %eax,%edx
  80376f:	0f 83 f6 00 00 00    	jae    80386b <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  803775:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803779:	75 17                	jne    803792 <smalloc+0x2ae>
  80377b:	83 ec 04             	sub    $0x4,%esp
  80377e:	68 7b 62 80 00       	push   $0x80627b
  803783:	68 77 01 00 00       	push   $0x177
  803788:	68 0c 62 80 00       	push   $0x80620c
  80378d:	e8 dd dd ff ff       	call   80156f <_panic>
  803792:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803795:	8b 40 08             	mov    0x8(%eax),%eax
  803798:	85 c0                	test   %eax,%eax
  80379a:	74 11                	je     8037ad <smalloc+0x2c9>
  80379c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80379f:	8b 40 08             	mov    0x8(%eax),%eax
  8037a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037a5:	8b 52 0c             	mov    0xc(%edx),%edx
  8037a8:	89 50 0c             	mov    %edx,0xc(%eax)
  8037ab:	eb 0b                	jmp    8037b8 <smalloc+0x2d4>
  8037ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b3:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8037b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8037be:	85 c0                	test   %eax,%eax
  8037c0:	74 11                	je     8037d3 <smalloc+0x2ef>
  8037c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037cb:	8b 52 08             	mov    0x8(%edx),%edx
  8037ce:	89 50 08             	mov    %edx,0x8(%eax)
  8037d1:	eb 0b                	jmp    8037de <smalloc+0x2fa>
  8037d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d6:	8b 40 08             	mov    0x8(%eax),%eax
  8037d9:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8037de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8037f2:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8037f7:	48                   	dec    %eax
  8037f8:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8037fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803801:	74 06                	je     803809 <smalloc+0x325>
  803803:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803807:	75 17                	jne    803820 <smalloc+0x33c>
  803809:	83 ec 04             	sub    $0x4,%esp
  80380c:	68 9c 62 80 00       	push   $0x80629c
  803811:	68 78 01 00 00       	push   $0x178
  803816:	68 0c 62 80 00       	push   $0x80620c
  80381b:	e8 4f dd ff ff       	call   80156f <_panic>
  803820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803823:	8b 50 0c             	mov    0xc(%eax),%edx
  803826:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803829:	89 50 0c             	mov    %edx,0xc(%eax)
  80382c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80382f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803832:	89 50 08             	mov    %edx,0x8(%eax)
  803835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803838:	8b 40 0c             	mov    0xc(%eax),%eax
  80383b:	85 c0                	test   %eax,%eax
  80383d:	74 0e                	je     80384d <smalloc+0x369>
  80383f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803842:	8b 40 0c             	mov    0xc(%eax),%eax
  803845:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803848:	89 50 08             	mov    %edx,0x8(%eax)
  80384b:	eb 08                	jmp    803855 <smalloc+0x371>
  80384d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803850:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803858:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80385b:	89 50 0c             	mov    %edx,0xc(%eax)
  80385e:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803863:	40                   	inc    %eax
  803864:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		break;
  803869:	eb 13                	jmp    80387e <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  80386b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386e:	8b 40 08             	mov    0x8(%eax),%eax
  803871:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  803874:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803878:	0f 85 e3 fe ff ff    	jne    803761 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80387e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803881:	8b 00                	mov    (%eax),%eax
  803883:	89 c2                	mov    %eax,%edx
  803885:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803889:	52                   	push   %edx
  80388a:	50                   	push   %eax
  80388b:	ff 75 0c             	pushl  0xc(%ebp)
  80388e:	ff 75 08             	pushl  0x8(%ebp)
  803891:	e8 ea 09 00 00       	call   804280 <sys_create_shared_object>
  803896:	83 c4 10             	add    $0x10,%esp
  803899:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  80389c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8038a0:	79 28                	jns    8038ca <smalloc+0x3e6>
	                	free_block(allocblock);
  8038a2:	83 ec 0c             	sub    $0xc,%esp
  8038a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8038a8:	e8 71 14 00 00       	call   804d1e <free_block>
  8038ad:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  8038b0:	83 ec 0c             	sub    $0xc,%esp
  8038b3:	68 20 f3 81 00       	push   $0x81f320
  8038b8:	e8 85 18 00 00       	call   805142 <release_uspinlock>
  8038bd:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  8038c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c5:	e9 bf 01 00 00       	jmp    803a89 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  8038ca:	83 ec 0c             	sub    $0xc,%esp
  8038cd:	68 20 f3 81 00       	push   $0x81f320
  8038d2:	e8 6b 18 00 00       	call   805142 <release_uspinlock>
  8038d7:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  8038da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038dd:	8b 00                	mov    (%eax),%eax
  8038df:	e9 a5 01 00 00       	jmp    803a89 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  8038e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8038ed:	0f 85 60 01 00 00    	jne    803a53 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  8038f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f6:	8b 10                	mov    (%eax),%edx
  8038f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038fb:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8038fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803900:	8b 55 0c             	mov    0xc(%ebp),%edx
  803903:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803906:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80390a:	75 17                	jne    803923 <smalloc+0x43f>
  80390c:	83 ec 04             	sub    $0x4,%esp
  80390f:	68 58 62 80 00       	push   $0x806258
  803914:	68 8c 01 00 00       	push   $0x18c
  803919:	68 0c 62 80 00       	push   $0x80620c
  80391e:	e8 4c dc ff ff       	call   80156f <_panic>
  803923:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80392c:	89 50 0c             	mov    %edx,0xc(%eax)
  80392f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803932:	8b 40 0c             	mov    0xc(%eax),%eax
  803935:	85 c0                	test   %eax,%eax
  803937:	74 0d                	je     803946 <smalloc+0x462>
  803939:	a1 14 f3 81 00       	mov    0x81f314,%eax
  80393e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803941:	89 50 08             	mov    %edx,0x8(%eax)
  803944:	eb 08                	jmp    80394e <smalloc+0x46a>
  803946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803949:	a3 10 f3 81 00       	mov    %eax,0x81f310
  80394e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803951:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803959:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803960:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803965:	40                   	inc    %eax
  803966:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  80396b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80396f:	75 17                	jne    803988 <smalloc+0x4a4>
  803971:	83 ec 04             	sub    $0x4,%esp
  803974:	68 7b 62 80 00       	push   $0x80627b
  803979:	68 8d 01 00 00       	push   $0x18d
  80397e:	68 0c 62 80 00       	push   $0x80620c
  803983:	e8 e7 db ff ff       	call   80156f <_panic>
  803988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398b:	8b 40 08             	mov    0x8(%eax),%eax
  80398e:	85 c0                	test   %eax,%eax
  803990:	74 11                	je     8039a3 <smalloc+0x4bf>
  803992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803995:	8b 40 08             	mov    0x8(%eax),%eax
  803998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80399b:	8b 52 0c             	mov    0xc(%edx),%edx
  80399e:	89 50 0c             	mov    %edx,0xc(%eax)
  8039a1:	eb 0b                	jmp    8039ae <smalloc+0x4ca>
  8039a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8039a9:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8039ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8039b4:	85 c0                	test   %eax,%eax
  8039b6:	74 11                	je     8039c9 <smalloc+0x4e5>
  8039b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8039be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039c1:	8b 52 08             	mov    0x8(%edx),%edx
  8039c4:	89 50 08             	mov    %edx,0x8(%eax)
  8039c7:	eb 0b                	jmp    8039d4 <smalloc+0x4f0>
  8039c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cc:	8b 40 08             	mov    0x8(%eax),%eax
  8039cf:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8039d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8039de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8039e8:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8039ed:	48                   	dec    %eax
  8039ee:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8039f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039f6:	8b 00                	mov    (%eax),%eax
  8039f8:	89 c2                	mov    %eax,%edx
  8039fa:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8039fe:	52                   	push   %edx
  8039ff:	50                   	push   %eax
  803a00:	ff 75 0c             	pushl  0xc(%ebp)
  803a03:	ff 75 08             	pushl  0x8(%ebp)
  803a06:	e8 75 08 00 00       	call   804280 <sys_create_shared_object>
  803a0b:	83 c4 10             	add    $0x10,%esp
  803a0e:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  803a11:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a15:	79 25                	jns    803a3c <smalloc+0x558>
						free_block(allocblock);
  803a17:	83 ec 0c             	sub    $0xc,%esp
  803a1a:	ff 75 ec             	pushl  -0x14(%ebp)
  803a1d:	e8 fc 12 00 00       	call   804d1e <free_block>
  803a22:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803a25:	83 ec 0c             	sub    $0xc,%esp
  803a28:	68 20 f3 81 00       	push   $0x81f320
  803a2d:	e8 10 17 00 00       	call   805142 <release_uspinlock>
  803a32:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803a35:	b8 00 00 00 00       	mov    $0x0,%eax
  803a3a:	eb 4d                	jmp    803a89 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  803a3c:	83 ec 0c             	sub    $0xc,%esp
  803a3f:	68 20 f3 81 00       	push   $0x81f320
  803a44:	e8 f9 16 00 00       	call   805142 <release_uspinlock>
  803a49:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803a4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a4f:	8b 00                	mov    (%eax),%eax
  803a51:	eb 36                	jmp    803a89 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a56:	8b 40 08             	mov    0x8(%eax),%eax
  803a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803a5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a60:	0f 85 47 fc ff ff    	jne    8036ad <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  803a66:	83 ec 0c             	sub    $0xc,%esp
  803a69:	ff 75 ec             	pushl  -0x14(%ebp)
  803a6c:	e8 ad 12 00 00       	call   804d1e <free_block>
  803a71:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803a74:	83 ec 0c             	sub    $0xc,%esp
  803a77:	68 20 f3 81 00       	push   $0x81f320
  803a7c:	e8 c1 16 00 00       	call   805142 <release_uspinlock>
  803a81:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a89:	c9                   	leave  
  803a8a:	c3                   	ret    

00803a8b <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  803a8b:	55                   	push   %ebp
  803a8c:	89 e5                	mov    %esp,%ebp
  803a8e:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  803a91:	e8 8c ec ff ff       	call   802722 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  803a96:	83 ec 0c             	sub    $0xc,%esp
  803a99:	68 20 f3 81 00       	push   $0x81f320
  803a9e:	e8 47 16 00 00       	call   8050ea <acquire_uspinlock>
  803aa3:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  803aa6:	83 ec 08             	sub    $0x8,%esp
  803aa9:	ff 75 0c             	pushl  0xc(%ebp)
  803aac:	ff 75 08             	pushl  0x8(%ebp)
  803aaf:	e8 f6 07 00 00       	call   8042aa <sys_size_of_shared_object>
  803ab4:	83 c4 10             	add    $0x10,%esp
  803ab7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  803aba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803abe:	79 1a                	jns    803ada <sget+0x4f>
			release_uspinlock(&ulock);
  803ac0:	83 ec 0c             	sub    $0xc,%esp
  803ac3:	68 20 f3 81 00       	push   $0x81f320
  803ac8:	e8 75 16 00 00       	call   805142 <release_uspinlock>
  803acd:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad5:	e9 6e 05 00 00       	jmp    804048 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  803ada:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803ae1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae7:	01 d0                	add    %edx,%eax
  803ae9:	48                   	dec    %eax
  803aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af0:	ba 00 00 00 00       	mov    $0x0,%edx
  803af5:	f7 75 e8             	divl   -0x18(%ebp)
  803af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afb:	29 d0                	sub    %edx,%eax
  803afd:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803b00:	83 ec 0c             	sub    $0xc,%esp
  803b03:	6a 10                	push   $0x10
  803b05:	e8 78 0d 00 00       	call   804882 <alloc_block>
  803b0a:	83 c4 10             	add    $0x10,%esp
  803b0d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  803b10:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803b14:	75 0a                	jne    803b20 <sget+0x95>
			return NULL;
  803b16:	b8 00 00 00 00       	mov    $0x0,%eax
  803b1b:	e9 28 05 00 00       	jmp    804048 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803b20:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803b25:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  803b28:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803b2d:	85 c0                	test   %eax,%eax
  803b2f:	74 11                	je     803b42 <sget+0xb7>
  803b31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b34:	8b 50 04             	mov    0x4(%eax),%edx
  803b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b3a:	39 c2                	cmp    %eax,%edx
  803b3c:	0f 83 21 01 00 00    	jae    803c63 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  803b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b45:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  803b4a:	29 c2                	sub    %eax,%edx
  803b4c:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803b51:	39 c2                	cmp    %eax,%edx
  803b53:	0f 82 f0 00 00 00    	jb     803c49 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  803b59:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803b5e:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  803b61:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b6a:	01 d0                	add    %edx,%eax
  803b6c:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  803b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b74:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b77:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803b79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b7f:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  803b82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803b86:	75 17                	jne    803b9f <sget+0x114>
  803b88:	83 ec 04             	sub    $0x4,%esp
  803b8b:	68 58 62 80 00       	push   $0x806258
  803b90:	68 c8 01 00 00       	push   $0x1c8
  803b95:	68 0c 62 80 00       	push   $0x80620c
  803b9a:	e8 d0 d9 ff ff       	call   80156f <_panic>
  803b9f:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803ba5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ba8:	89 50 0c             	mov    %edx,0xc(%eax)
  803bab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bae:	8b 40 0c             	mov    0xc(%eax),%eax
  803bb1:	85 c0                	test   %eax,%eax
  803bb3:	74 0d                	je     803bc2 <sget+0x137>
  803bb5:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803bba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bbd:	89 50 08             	mov    %edx,0x8(%eax)
  803bc0:	eb 08                	jmp    803bca <sget+0x13f>
  803bc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bc5:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803bca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bcd:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803bd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bd5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803bdc:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803be1:	40                   	inc    %eax
  803be2:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803be7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bea:	8b 00                	mov    (%eax),%eax
  803bec:	83 ec 04             	sub    $0x4,%esp
  803bef:	50                   	push   %eax
  803bf0:	ff 75 0c             	pushl  0xc(%ebp)
  803bf3:	ff 75 08             	pushl  0x8(%ebp)
  803bf6:	e8 cc 06 00 00       	call   8042c7 <sys_get_shared_object>
  803bfb:	83 c4 10             	add    $0x10,%esp
  803bfe:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  803c01:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803c05:	79 28                	jns    803c2f <sget+0x1a4>
							free_block(allocblock);
  803c07:	83 ec 0c             	sub    $0xc,%esp
  803c0a:	ff 75 e0             	pushl  -0x20(%ebp)
  803c0d:	e8 0c 11 00 00       	call   804d1e <free_block>
  803c12:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803c15:	83 ec 0c             	sub    $0xc,%esp
  803c18:	68 20 f3 81 00       	push   $0x81f320
  803c1d:	e8 20 15 00 00       	call   805142 <release_uspinlock>
  803c22:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803c25:	b8 00 00 00 00       	mov    $0x0,%eax
  803c2a:	e9 19 04 00 00       	jmp    804048 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  803c2f:	83 ec 0c             	sub    $0xc,%esp
  803c32:	68 20 f3 81 00       	push   $0x81f320
  803c37:	e8 06 15 00 00       	call   805142 <release_uspinlock>
  803c3c:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c42:	8b 00                	mov    (%eax),%eax
  803c44:	e9 ff 03 00 00       	jmp    804048 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  803c49:	83 ec 0c             	sub    $0xc,%esp
  803c4c:	68 20 f3 81 00       	push   $0x81f320
  803c51:	e8 ec 14 00 00       	call   805142 <release_uspinlock>
  803c56:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803c59:	b8 00 00 00 00       	mov    $0x0,%eax
  803c5e:	e9 e5 03 00 00       	jmp    804048 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803c63:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803c6b:	e9 ab 03 00 00       	jmp    80401b <sget+0x590>
				if(size<currentfreeelement->size){
  803c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c73:	8b 50 04             	mov    0x4(%eax),%edx
  803c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c79:	39 c2                	cmp    %eax,%edx
  803c7b:	0f 86 24 02 00 00    	jbe    803ea5 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  803c81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c84:	8b 10                	mov    (%eax),%edx
  803c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c89:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803c8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c91:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803c94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c98:	75 17                	jne    803cb1 <sget+0x226>
  803c9a:	83 ec 04             	sub    $0x4,%esp
  803c9d:	68 58 62 80 00       	push   $0x806258
  803ca2:	68 e0 01 00 00       	push   $0x1e0
  803ca7:	68 0c 62 80 00       	push   $0x80620c
  803cac:	e8 be d8 ff ff       	call   80156f <_panic>
  803cb1:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cba:	89 50 0c             	mov    %edx,0xc(%eax)
  803cbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  803cc3:	85 c0                	test   %eax,%eax
  803cc5:	74 0d                	je     803cd4 <sget+0x249>
  803cc7:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803ccc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ccf:	89 50 08             	mov    %edx,0x8(%eax)
  803cd2:	eb 08                	jmp    803cdc <sget+0x251>
  803cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cd7:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cdf:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ce7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803cee:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803cf3:	40                   	inc    %eax
  803cf4:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					lastfreeelement->startva += size;
  803cf9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cfc:	8b 10                	mov    (%eax),%edx
  803cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d01:	01 c2                	add    %eax,%edx
  803d03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d06:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  803d08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d0b:	8b 50 04             	mov    0x4(%eax),%edx
  803d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d11:	29 c2                	sub    %eax,%edx
  803d13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d16:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803d19:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  803d21:	e9 13 01 00 00       	jmp    803e39 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  803d26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d29:	8b 50 04             	mov    0x4(%eax),%edx
  803d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d2f:	8b 40 04             	mov    0x4(%eax),%eax
  803d32:	39 c2                	cmp    %eax,%edx
  803d34:	0f 83 f6 00 00 00    	jae    803e30 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  803d3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d3e:	75 17                	jne    803d57 <sget+0x2cc>
  803d40:	83 ec 04             	sub    $0x4,%esp
  803d43:	68 7b 62 80 00       	push   $0x80627b
  803d48:	68 e8 01 00 00       	push   $0x1e8
  803d4d:	68 0c 62 80 00       	push   $0x80620c
  803d52:	e8 18 d8 ff ff       	call   80156f <_panic>
  803d57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d5a:	8b 40 08             	mov    0x8(%eax),%eax
  803d5d:	85 c0                	test   %eax,%eax
  803d5f:	74 11                	je     803d72 <sget+0x2e7>
  803d61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d64:	8b 40 08             	mov    0x8(%eax),%eax
  803d67:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d6a:	8b 52 0c             	mov    0xc(%edx),%edx
  803d6d:	89 50 0c             	mov    %edx,0xc(%eax)
  803d70:	eb 0b                	jmp    803d7d <sget+0x2f2>
  803d72:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d75:	8b 40 0c             	mov    0xc(%eax),%eax
  803d78:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803d7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d80:	8b 40 0c             	mov    0xc(%eax),%eax
  803d83:	85 c0                	test   %eax,%eax
  803d85:	74 11                	je     803d98 <sget+0x30d>
  803d87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d8a:	8b 40 0c             	mov    0xc(%eax),%eax
  803d8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d90:	8b 52 08             	mov    0x8(%edx),%edx
  803d93:	89 50 08             	mov    %edx,0x8(%eax)
  803d96:	eb 0b                	jmp    803da3 <sget+0x318>
  803d98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d9b:	8b 40 08             	mov    0x8(%eax),%eax
  803d9e:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803da3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803da6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803dad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803db0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803db7:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803dbc:	48                   	dec    %eax
  803dbd:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803dc2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803dc6:	74 06                	je     803dce <sget+0x343>
  803dc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803dcc:	75 17                	jne    803de5 <sget+0x35a>
  803dce:	83 ec 04             	sub    $0x4,%esp
  803dd1:	68 9c 62 80 00       	push   $0x80629c
  803dd6:	68 e9 01 00 00       	push   $0x1e9
  803ddb:	68 0c 62 80 00       	push   $0x80620c
  803de0:	e8 8a d7 ff ff       	call   80156f <_panic>
  803de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de8:	8b 50 0c             	mov    0xc(%eax),%edx
  803deb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dee:	89 50 0c             	mov    %edx,0xc(%eax)
  803df1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803df4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803df7:	89 50 08             	mov    %edx,0x8(%eax)
  803dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfd:	8b 40 0c             	mov    0xc(%eax),%eax
  803e00:	85 c0                	test   %eax,%eax
  803e02:	74 0e                	je     803e12 <sget+0x387>
  803e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e07:	8b 40 0c             	mov    0xc(%eax),%eax
  803e0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e0d:	89 50 08             	mov    %edx,0x8(%eax)
  803e10:	eb 08                	jmp    803e1a <sget+0x38f>
  803e12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e15:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e20:	89 50 0c             	mov    %edx,0xc(%eax)
  803e23:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803e28:	40                   	inc    %eax
  803e29:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							break;
  803e2e:	eb 13                	jmp    803e43 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  803e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e33:	8b 40 08             	mov    0x8(%eax),%eax
  803e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  803e39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e3d:	0f 85 e3 fe ff ff    	jne    803d26 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803e43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e46:	8b 00                	mov    (%eax),%eax
  803e48:	83 ec 04             	sub    $0x4,%esp
  803e4b:	50                   	push   %eax
  803e4c:	ff 75 0c             	pushl  0xc(%ebp)
  803e4f:	ff 75 08             	pushl  0x8(%ebp)
  803e52:	e8 70 04 00 00       	call   8042c7 <sys_get_shared_object>
  803e57:	83 c4 10             	add    $0x10,%esp
  803e5a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  803e5d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e61:	79 28                	jns    803e8b <sget+0x400>
						free_block(allocblock);
  803e63:	83 ec 0c             	sub    $0xc,%esp
  803e66:	ff 75 e0             	pushl  -0x20(%ebp)
  803e69:	e8 b0 0e 00 00       	call   804d1e <free_block>
  803e6e:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803e71:	83 ec 0c             	sub    $0xc,%esp
  803e74:	68 20 f3 81 00       	push   $0x81f320
  803e79:	e8 c4 12 00 00       	call   805142 <release_uspinlock>
  803e7e:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803e81:	b8 00 00 00 00       	mov    $0x0,%eax
  803e86:	e9 bd 01 00 00       	jmp    804048 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  803e8b:	83 ec 0c             	sub    $0xc,%esp
  803e8e:	68 20 f3 81 00       	push   $0x81f320
  803e93:	e8 aa 12 00 00       	call   805142 <release_uspinlock>
  803e98:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e9e:	8b 00                	mov    (%eax),%eax
  803ea0:	e9 a3 01 00 00       	jmp    804048 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  803ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea8:	8b 50 04             	mov    0x4(%eax),%edx
  803eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eae:	39 c2                	cmp    %eax,%edx
  803eb0:	0f 85 5c 01 00 00    	jne    804012 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  803eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb9:	8b 10                	mov    (%eax),%edx
  803ebb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ebe:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803ec0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ec3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ec6:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803ec9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803ecd:	75 17                	jne    803ee6 <sget+0x45b>
  803ecf:	83 ec 04             	sub    $0x4,%esp
  803ed2:	68 58 62 80 00       	push   $0x806258
  803ed7:	68 fe 01 00 00       	push   $0x1fe
  803edc:	68 0c 62 80 00       	push   $0x80620c
  803ee1:	e8 89 d6 ff ff       	call   80156f <_panic>
  803ee6:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803eec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803eef:	89 50 0c             	mov    %edx,0xc(%eax)
  803ef2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ef5:	8b 40 0c             	mov    0xc(%eax),%eax
  803ef8:	85 c0                	test   %eax,%eax
  803efa:	74 0d                	je     803f09 <sget+0x47e>
  803efc:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803f01:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f04:	89 50 08             	mov    %edx,0x8(%eax)
  803f07:	eb 08                	jmp    803f11 <sget+0x486>
  803f09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f0c:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803f11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f14:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803f19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803f23:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803f28:	40                   	inc    %eax
  803f29:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f32:	75 17                	jne    803f4b <sget+0x4c0>
  803f34:	83 ec 04             	sub    $0x4,%esp
  803f37:	68 7b 62 80 00       	push   $0x80627b
  803f3c:	68 ff 01 00 00       	push   $0x1ff
  803f41:	68 0c 62 80 00       	push   $0x80620c
  803f46:	e8 24 d6 ff ff       	call   80156f <_panic>
  803f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4e:	8b 40 08             	mov    0x8(%eax),%eax
  803f51:	85 c0                	test   %eax,%eax
  803f53:	74 11                	je     803f66 <sget+0x4db>
  803f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f58:	8b 40 08             	mov    0x8(%eax),%eax
  803f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f5e:	8b 52 0c             	mov    0xc(%edx),%edx
  803f61:	89 50 0c             	mov    %edx,0xc(%eax)
  803f64:	eb 0b                	jmp    803f71 <sget+0x4e6>
  803f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f69:	8b 40 0c             	mov    0xc(%eax),%eax
  803f6c:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f74:	8b 40 0c             	mov    0xc(%eax),%eax
  803f77:	85 c0                	test   %eax,%eax
  803f79:	74 11                	je     803f8c <sget+0x501>
  803f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  803f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f84:	8b 52 08             	mov    0x8(%edx),%edx
  803f87:	89 50 08             	mov    %edx,0x8(%eax)
  803f8a:	eb 0b                	jmp    803f97 <sget+0x50c>
  803f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f8f:	8b 40 08             	mov    0x8(%eax),%eax
  803f92:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803fab:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803fb0:	48                   	dec    %eax
  803fb1:	a3 0c f3 81 00       	mov    %eax,0x81f30c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803fb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fb9:	8b 00                	mov    (%eax),%eax
  803fbb:	83 ec 04             	sub    $0x4,%esp
  803fbe:	50                   	push   %eax
  803fbf:	ff 75 0c             	pushl  0xc(%ebp)
  803fc2:	ff 75 08             	pushl  0x8(%ebp)
  803fc5:	e8 fd 02 00 00       	call   8042c7 <sys_get_shared_object>
  803fca:	83 c4 10             	add    $0x10,%esp
  803fcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803fd0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803fd4:	79 25                	jns    803ffb <sget+0x570>
						free_block(allocblock);
  803fd6:	83 ec 0c             	sub    $0xc,%esp
  803fd9:	ff 75 e0             	pushl  -0x20(%ebp)
  803fdc:	e8 3d 0d 00 00       	call   804d1e <free_block>
  803fe1:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803fe4:	83 ec 0c             	sub    $0xc,%esp
  803fe7:	68 20 f3 81 00       	push   $0x81f320
  803fec:	e8 51 11 00 00       	call   805142 <release_uspinlock>
  803ff1:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ff9:	eb 4d                	jmp    804048 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  803ffb:	83 ec 0c             	sub    $0xc,%esp
  803ffe:	68 20 f3 81 00       	push   $0x81f320
  804003:	e8 3a 11 00 00       	call   805142 <release_uspinlock>
  804008:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80400b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80400e:	8b 00                	mov    (%eax),%eax
  804010:	eb 36                	jmp    804048 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  804012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804015:	8b 40 08             	mov    0x8(%eax),%eax
  804018:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  80401b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80401f:	0f 85 4b fc ff ff    	jne    803c70 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  804025:	83 ec 0c             	sub    $0xc,%esp
  804028:	ff 75 e0             	pushl  -0x20(%ebp)
  80402b:	e8 ee 0c 00 00       	call   804d1e <free_block>
  804030:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  804033:	83 ec 0c             	sub    $0xc,%esp
  804036:	68 20 f3 81 00       	push   $0x81f320
  80403b:	e8 02 11 00 00       	call   805142 <release_uspinlock>
  804040:	83 c4 10             	add    $0x10,%esp
		return NULL;
  804043:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804048:	c9                   	leave  
  804049:	c3                   	ret    

0080404a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80404a:	55                   	push   %ebp
  80404b:	89 e5                	mov    %esp,%ebp
  80404d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  804050:	e8 cd e6 ff ff       	call   802722 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  804055:	83 ec 04             	sub    $0x4,%esp
  804058:	68 2c 63 80 00       	push   $0x80632c
  80405d:	68 2d 02 00 00       	push   $0x22d
  804062:	68 0c 62 80 00       	push   $0x80620c
  804067:	e8 03 d5 ff ff       	call   80156f <_panic>

0080406c <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80406c:	55                   	push   %ebp
  80406d:	89 e5                	mov    %esp,%ebp
  80406f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  804072:	83 ec 04             	sub    $0x4,%esp
  804075:	68 54 63 80 00       	push   $0x806354
  80407a:	68 40 02 00 00       	push   $0x240
  80407f:	68 0c 62 80 00       	push   $0x80620c
  804084:	e8 e6 d4 ff ff       	call   80156f <_panic>

00804089 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  804089:	55                   	push   %ebp
  80408a:	89 e5                	mov    %esp,%ebp
  80408c:	57                   	push   %edi
  80408d:	56                   	push   %esi
  80408e:	53                   	push   %ebx
  80408f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  804092:	8b 45 08             	mov    0x8(%ebp),%eax
  804095:	8b 55 0c             	mov    0xc(%ebp),%edx
  804098:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80409b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80409e:	8b 7d 18             	mov    0x18(%ebp),%edi
  8040a1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8040a4:	cd 30                	int    $0x30
  8040a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8040a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8040ac:	83 c4 10             	add    $0x10,%esp
  8040af:	5b                   	pop    %ebx
  8040b0:	5e                   	pop    %esi
  8040b1:	5f                   	pop    %edi
  8040b2:	5d                   	pop    %ebp
  8040b3:	c3                   	ret    

008040b4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8040b4:	55                   	push   %ebp
  8040b5:	89 e5                	mov    %esp,%ebp
  8040b7:	83 ec 04             	sub    $0x4,%esp
  8040ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8040bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8040c0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8040c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8040c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ca:	6a 00                	push   $0x0
  8040cc:	51                   	push   %ecx
  8040cd:	52                   	push   %edx
  8040ce:	ff 75 0c             	pushl  0xc(%ebp)
  8040d1:	50                   	push   %eax
  8040d2:	6a 00                	push   $0x0
  8040d4:	e8 b0 ff ff ff       	call   804089 <syscall>
  8040d9:	83 c4 18             	add    $0x18,%esp
}
  8040dc:	90                   	nop
  8040dd:	c9                   	leave  
  8040de:	c3                   	ret    

008040df <sys_cgetc>:

int
sys_cgetc(void)
{
  8040df:	55                   	push   %ebp
  8040e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8040e2:	6a 00                	push   $0x0
  8040e4:	6a 00                	push   $0x0
  8040e6:	6a 00                	push   $0x0
  8040e8:	6a 00                	push   $0x0
  8040ea:	6a 00                	push   $0x0
  8040ec:	6a 02                	push   $0x2
  8040ee:	e8 96 ff ff ff       	call   804089 <syscall>
  8040f3:	83 c4 18             	add    $0x18,%esp
}
  8040f6:	c9                   	leave  
  8040f7:	c3                   	ret    

008040f8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8040f8:	55                   	push   %ebp
  8040f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8040fb:	6a 00                	push   $0x0
  8040fd:	6a 00                	push   $0x0
  8040ff:	6a 00                	push   $0x0
  804101:	6a 00                	push   $0x0
  804103:	6a 00                	push   $0x0
  804105:	6a 03                	push   $0x3
  804107:	e8 7d ff ff ff       	call   804089 <syscall>
  80410c:	83 c4 18             	add    $0x18,%esp
}
  80410f:	90                   	nop
  804110:	c9                   	leave  
  804111:	c3                   	ret    

00804112 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  804112:	55                   	push   %ebp
  804113:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  804115:	6a 00                	push   $0x0
  804117:	6a 00                	push   $0x0
  804119:	6a 00                	push   $0x0
  80411b:	6a 00                	push   $0x0
  80411d:	6a 00                	push   $0x0
  80411f:	6a 04                	push   $0x4
  804121:	e8 63 ff ff ff       	call   804089 <syscall>
  804126:	83 c4 18             	add    $0x18,%esp
}
  804129:	90                   	nop
  80412a:	c9                   	leave  
  80412b:	c3                   	ret    

0080412c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80412c:	55                   	push   %ebp
  80412d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80412f:	8b 55 0c             	mov    0xc(%ebp),%edx
  804132:	8b 45 08             	mov    0x8(%ebp),%eax
  804135:	6a 00                	push   $0x0
  804137:	6a 00                	push   $0x0
  804139:	6a 00                	push   $0x0
  80413b:	52                   	push   %edx
  80413c:	50                   	push   %eax
  80413d:	6a 08                	push   $0x8
  80413f:	e8 45 ff ff ff       	call   804089 <syscall>
  804144:	83 c4 18             	add    $0x18,%esp
}
  804147:	c9                   	leave  
  804148:	c3                   	ret    

00804149 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  804149:	55                   	push   %ebp
  80414a:	89 e5                	mov    %esp,%ebp
  80414c:	56                   	push   %esi
  80414d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80414e:	8b 75 18             	mov    0x18(%ebp),%esi
  804151:	8b 5d 14             	mov    0x14(%ebp),%ebx
  804154:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80415a:	8b 45 08             	mov    0x8(%ebp),%eax
  80415d:	56                   	push   %esi
  80415e:	53                   	push   %ebx
  80415f:	51                   	push   %ecx
  804160:	52                   	push   %edx
  804161:	50                   	push   %eax
  804162:	6a 09                	push   $0x9
  804164:	e8 20 ff ff ff       	call   804089 <syscall>
  804169:	83 c4 18             	add    $0x18,%esp
}
  80416c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80416f:	5b                   	pop    %ebx
  804170:	5e                   	pop    %esi
  804171:	5d                   	pop    %ebp
  804172:	c3                   	ret    

00804173 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  804173:	55                   	push   %ebp
  804174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  804176:	6a 00                	push   $0x0
  804178:	6a 00                	push   $0x0
  80417a:	6a 00                	push   $0x0
  80417c:	6a 00                	push   $0x0
  80417e:	ff 75 08             	pushl  0x8(%ebp)
  804181:	6a 0a                	push   $0xa
  804183:	e8 01 ff ff ff       	call   804089 <syscall>
  804188:	83 c4 18             	add    $0x18,%esp
}
  80418b:	c9                   	leave  
  80418c:	c3                   	ret    

0080418d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80418d:	55                   	push   %ebp
  80418e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  804190:	6a 00                	push   $0x0
  804192:	6a 00                	push   $0x0
  804194:	6a 00                	push   $0x0
  804196:	ff 75 0c             	pushl  0xc(%ebp)
  804199:	ff 75 08             	pushl  0x8(%ebp)
  80419c:	6a 0b                	push   $0xb
  80419e:	e8 e6 fe ff ff       	call   804089 <syscall>
  8041a3:	83 c4 18             	add    $0x18,%esp
}
  8041a6:	c9                   	leave  
  8041a7:	c3                   	ret    

008041a8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8041a8:	55                   	push   %ebp
  8041a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8041ab:	6a 00                	push   $0x0
  8041ad:	6a 00                	push   $0x0
  8041af:	6a 00                	push   $0x0
  8041b1:	6a 00                	push   $0x0
  8041b3:	6a 00                	push   $0x0
  8041b5:	6a 0c                	push   $0xc
  8041b7:	e8 cd fe ff ff       	call   804089 <syscall>
  8041bc:	83 c4 18             	add    $0x18,%esp
}
  8041bf:	c9                   	leave  
  8041c0:	c3                   	ret    

008041c1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8041c1:	55                   	push   %ebp
  8041c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8041c4:	6a 00                	push   $0x0
  8041c6:	6a 00                	push   $0x0
  8041c8:	6a 00                	push   $0x0
  8041ca:	6a 00                	push   $0x0
  8041cc:	6a 00                	push   $0x0
  8041ce:	6a 0d                	push   $0xd
  8041d0:	e8 b4 fe ff ff       	call   804089 <syscall>
  8041d5:	83 c4 18             	add    $0x18,%esp
}
  8041d8:	c9                   	leave  
  8041d9:	c3                   	ret    

008041da <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8041da:	55                   	push   %ebp
  8041db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8041dd:	6a 00                	push   $0x0
  8041df:	6a 00                	push   $0x0
  8041e1:	6a 00                	push   $0x0
  8041e3:	6a 00                	push   $0x0
  8041e5:	6a 00                	push   $0x0
  8041e7:	6a 0e                	push   $0xe
  8041e9:	e8 9b fe ff ff       	call   804089 <syscall>
  8041ee:	83 c4 18             	add    $0x18,%esp
}
  8041f1:	c9                   	leave  
  8041f2:	c3                   	ret    

008041f3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8041f3:	55                   	push   %ebp
  8041f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8041f6:	6a 00                	push   $0x0
  8041f8:	6a 00                	push   $0x0
  8041fa:	6a 00                	push   $0x0
  8041fc:	6a 00                	push   $0x0
  8041fe:	6a 00                	push   $0x0
  804200:	6a 0f                	push   $0xf
  804202:	e8 82 fe ff ff       	call   804089 <syscall>
  804207:	83 c4 18             	add    $0x18,%esp
}
  80420a:	c9                   	leave  
  80420b:	c3                   	ret    

0080420c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80420c:	55                   	push   %ebp
  80420d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80420f:	6a 00                	push   $0x0
  804211:	6a 00                	push   $0x0
  804213:	6a 00                	push   $0x0
  804215:	6a 00                	push   $0x0
  804217:	ff 75 08             	pushl  0x8(%ebp)
  80421a:	6a 10                	push   $0x10
  80421c:	e8 68 fe ff ff       	call   804089 <syscall>
  804221:	83 c4 18             	add    $0x18,%esp
}
  804224:	c9                   	leave  
  804225:	c3                   	ret    

00804226 <sys_scarce_memory>:

void sys_scarce_memory()
{
  804226:	55                   	push   %ebp
  804227:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  804229:	6a 00                	push   $0x0
  80422b:	6a 00                	push   $0x0
  80422d:	6a 00                	push   $0x0
  80422f:	6a 00                	push   $0x0
  804231:	6a 00                	push   $0x0
  804233:	6a 11                	push   $0x11
  804235:	e8 4f fe ff ff       	call   804089 <syscall>
  80423a:	83 c4 18             	add    $0x18,%esp
}
  80423d:	90                   	nop
  80423e:	c9                   	leave  
  80423f:	c3                   	ret    

00804240 <sys_cputc>:

void
sys_cputc(const char c)
{
  804240:	55                   	push   %ebp
  804241:	89 e5                	mov    %esp,%ebp
  804243:	83 ec 04             	sub    $0x4,%esp
  804246:	8b 45 08             	mov    0x8(%ebp),%eax
  804249:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80424c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  804250:	6a 00                	push   $0x0
  804252:	6a 00                	push   $0x0
  804254:	6a 00                	push   $0x0
  804256:	6a 00                	push   $0x0
  804258:	50                   	push   %eax
  804259:	6a 01                	push   $0x1
  80425b:	e8 29 fe ff ff       	call   804089 <syscall>
  804260:	83 c4 18             	add    $0x18,%esp
}
  804263:	90                   	nop
  804264:	c9                   	leave  
  804265:	c3                   	ret    

00804266 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  804266:	55                   	push   %ebp
  804267:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  804269:	6a 00                	push   $0x0
  80426b:	6a 00                	push   $0x0
  80426d:	6a 00                	push   $0x0
  80426f:	6a 00                	push   $0x0
  804271:	6a 00                	push   $0x0
  804273:	6a 14                	push   $0x14
  804275:	e8 0f fe ff ff       	call   804089 <syscall>
  80427a:	83 c4 18             	add    $0x18,%esp
}
  80427d:	90                   	nop
  80427e:	c9                   	leave  
  80427f:	c3                   	ret    

00804280 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  804280:	55                   	push   %ebp
  804281:	89 e5                	mov    %esp,%ebp
  804283:	83 ec 04             	sub    $0x4,%esp
  804286:	8b 45 10             	mov    0x10(%ebp),%eax
  804289:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80428c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80428f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  804293:	8b 45 08             	mov    0x8(%ebp),%eax
  804296:	6a 00                	push   $0x0
  804298:	51                   	push   %ecx
  804299:	52                   	push   %edx
  80429a:	ff 75 0c             	pushl  0xc(%ebp)
  80429d:	50                   	push   %eax
  80429e:	6a 15                	push   $0x15
  8042a0:	e8 e4 fd ff ff       	call   804089 <syscall>
  8042a5:	83 c4 18             	add    $0x18,%esp
}
  8042a8:	c9                   	leave  
  8042a9:	c3                   	ret    

008042aa <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8042aa:	55                   	push   %ebp
  8042ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8042ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b3:	6a 00                	push   $0x0
  8042b5:	6a 00                	push   $0x0
  8042b7:	6a 00                	push   $0x0
  8042b9:	52                   	push   %edx
  8042ba:	50                   	push   %eax
  8042bb:	6a 16                	push   $0x16
  8042bd:	e8 c7 fd ff ff       	call   804089 <syscall>
  8042c2:	83 c4 18             	add    $0x18,%esp
}
  8042c5:	c9                   	leave  
  8042c6:	c3                   	ret    

008042c7 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8042c7:	55                   	push   %ebp
  8042c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8042ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8042cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8042d3:	6a 00                	push   $0x0
  8042d5:	6a 00                	push   $0x0
  8042d7:	51                   	push   %ecx
  8042d8:	52                   	push   %edx
  8042d9:	50                   	push   %eax
  8042da:	6a 17                	push   $0x17
  8042dc:	e8 a8 fd ff ff       	call   804089 <syscall>
  8042e1:	83 c4 18             	add    $0x18,%esp
}
  8042e4:	c9                   	leave  
  8042e5:	c3                   	ret    

008042e6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8042e6:	55                   	push   %ebp
  8042e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8042e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ef:	6a 00                	push   $0x0
  8042f1:	6a 00                	push   $0x0
  8042f3:	6a 00                	push   $0x0
  8042f5:	52                   	push   %edx
  8042f6:	50                   	push   %eax
  8042f7:	6a 18                	push   $0x18
  8042f9:	e8 8b fd ff ff       	call   804089 <syscall>
  8042fe:	83 c4 18             	add    $0x18,%esp
}
  804301:	c9                   	leave  
  804302:	c3                   	ret    

00804303 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  804303:	55                   	push   %ebp
  804304:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  804306:	8b 45 08             	mov    0x8(%ebp),%eax
  804309:	6a 00                	push   $0x0
  80430b:	ff 75 14             	pushl  0x14(%ebp)
  80430e:	ff 75 10             	pushl  0x10(%ebp)
  804311:	ff 75 0c             	pushl  0xc(%ebp)
  804314:	50                   	push   %eax
  804315:	6a 19                	push   $0x19
  804317:	e8 6d fd ff ff       	call   804089 <syscall>
  80431c:	83 c4 18             	add    $0x18,%esp
}
  80431f:	c9                   	leave  
  804320:	c3                   	ret    

00804321 <sys_run_env>:

void sys_run_env(int32 envId)
{
  804321:	55                   	push   %ebp
  804322:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  804324:	8b 45 08             	mov    0x8(%ebp),%eax
  804327:	6a 00                	push   $0x0
  804329:	6a 00                	push   $0x0
  80432b:	6a 00                	push   $0x0
  80432d:	6a 00                	push   $0x0
  80432f:	50                   	push   %eax
  804330:	6a 1a                	push   $0x1a
  804332:	e8 52 fd ff ff       	call   804089 <syscall>
  804337:	83 c4 18             	add    $0x18,%esp
}
  80433a:	90                   	nop
  80433b:	c9                   	leave  
  80433c:	c3                   	ret    

0080433d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80433d:	55                   	push   %ebp
  80433e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  804340:	8b 45 08             	mov    0x8(%ebp),%eax
  804343:	6a 00                	push   $0x0
  804345:	6a 00                	push   $0x0
  804347:	6a 00                	push   $0x0
  804349:	6a 00                	push   $0x0
  80434b:	50                   	push   %eax
  80434c:	6a 1b                	push   $0x1b
  80434e:	e8 36 fd ff ff       	call   804089 <syscall>
  804353:	83 c4 18             	add    $0x18,%esp
}
  804356:	c9                   	leave  
  804357:	c3                   	ret    

00804358 <sys_getenvid>:

int32 sys_getenvid(void)
{
  804358:	55                   	push   %ebp
  804359:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80435b:	6a 00                	push   $0x0
  80435d:	6a 00                	push   $0x0
  80435f:	6a 00                	push   $0x0
  804361:	6a 00                	push   $0x0
  804363:	6a 00                	push   $0x0
  804365:	6a 05                	push   $0x5
  804367:	e8 1d fd ff ff       	call   804089 <syscall>
  80436c:	83 c4 18             	add    $0x18,%esp
}
  80436f:	c9                   	leave  
  804370:	c3                   	ret    

00804371 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  804371:	55                   	push   %ebp
  804372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  804374:	6a 00                	push   $0x0
  804376:	6a 00                	push   $0x0
  804378:	6a 00                	push   $0x0
  80437a:	6a 00                	push   $0x0
  80437c:	6a 00                	push   $0x0
  80437e:	6a 06                	push   $0x6
  804380:	e8 04 fd ff ff       	call   804089 <syscall>
  804385:	83 c4 18             	add    $0x18,%esp
}
  804388:	c9                   	leave  
  804389:	c3                   	ret    

0080438a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80438a:	55                   	push   %ebp
  80438b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80438d:	6a 00                	push   $0x0
  80438f:	6a 00                	push   $0x0
  804391:	6a 00                	push   $0x0
  804393:	6a 00                	push   $0x0
  804395:	6a 00                	push   $0x0
  804397:	6a 07                	push   $0x7
  804399:	e8 eb fc ff ff       	call   804089 <syscall>
  80439e:	83 c4 18             	add    $0x18,%esp
}
  8043a1:	c9                   	leave  
  8043a2:	c3                   	ret    

008043a3 <sys_exit_env>:


void sys_exit_env(void)
{
  8043a3:	55                   	push   %ebp
  8043a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8043a6:	6a 00                	push   $0x0
  8043a8:	6a 00                	push   $0x0
  8043aa:	6a 00                	push   $0x0
  8043ac:	6a 00                	push   $0x0
  8043ae:	6a 00                	push   $0x0
  8043b0:	6a 1c                	push   $0x1c
  8043b2:	e8 d2 fc ff ff       	call   804089 <syscall>
  8043b7:	83 c4 18             	add    $0x18,%esp
}
  8043ba:	90                   	nop
  8043bb:	c9                   	leave  
  8043bc:	c3                   	ret    

008043bd <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8043bd:	55                   	push   %ebp
  8043be:	89 e5                	mov    %esp,%ebp
  8043c0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8043c3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8043c6:	8d 50 04             	lea    0x4(%eax),%edx
  8043c9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8043cc:	6a 00                	push   $0x0
  8043ce:	6a 00                	push   $0x0
  8043d0:	6a 00                	push   $0x0
  8043d2:	52                   	push   %edx
  8043d3:	50                   	push   %eax
  8043d4:	6a 1d                	push   $0x1d
  8043d6:	e8 ae fc ff ff       	call   804089 <syscall>
  8043db:	83 c4 18             	add    $0x18,%esp
	return result;
  8043de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8043e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8043e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8043e7:	89 01                	mov    %eax,(%ecx)
  8043e9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8043ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8043ef:	c9                   	leave  
  8043f0:	c2 04 00             	ret    $0x4

008043f3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8043f3:	55                   	push   %ebp
  8043f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8043f6:	6a 00                	push   $0x0
  8043f8:	6a 00                	push   $0x0
  8043fa:	ff 75 10             	pushl  0x10(%ebp)
  8043fd:	ff 75 0c             	pushl  0xc(%ebp)
  804400:	ff 75 08             	pushl  0x8(%ebp)
  804403:	6a 13                	push   $0x13
  804405:	e8 7f fc ff ff       	call   804089 <syscall>
  80440a:	83 c4 18             	add    $0x18,%esp
	return ;
  80440d:	90                   	nop
}
  80440e:	c9                   	leave  
  80440f:	c3                   	ret    

00804410 <sys_rcr2>:
uint32 sys_rcr2()
{
  804410:	55                   	push   %ebp
  804411:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  804413:	6a 00                	push   $0x0
  804415:	6a 00                	push   $0x0
  804417:	6a 00                	push   $0x0
  804419:	6a 00                	push   $0x0
  80441b:	6a 00                	push   $0x0
  80441d:	6a 1e                	push   $0x1e
  80441f:	e8 65 fc ff ff       	call   804089 <syscall>
  804424:	83 c4 18             	add    $0x18,%esp
}
  804427:	c9                   	leave  
  804428:	c3                   	ret    

00804429 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  804429:	55                   	push   %ebp
  80442a:	89 e5                	mov    %esp,%ebp
  80442c:	83 ec 04             	sub    $0x4,%esp
  80442f:	8b 45 08             	mov    0x8(%ebp),%eax
  804432:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  804435:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  804439:	6a 00                	push   $0x0
  80443b:	6a 00                	push   $0x0
  80443d:	6a 00                	push   $0x0
  80443f:	6a 00                	push   $0x0
  804441:	50                   	push   %eax
  804442:	6a 1f                	push   $0x1f
  804444:	e8 40 fc ff ff       	call   804089 <syscall>
  804449:	83 c4 18             	add    $0x18,%esp
	return ;
  80444c:	90                   	nop
}
  80444d:	c9                   	leave  
  80444e:	c3                   	ret    

0080444f <rsttst>:
void rsttst()
{
  80444f:	55                   	push   %ebp
  804450:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  804452:	6a 00                	push   $0x0
  804454:	6a 00                	push   $0x0
  804456:	6a 00                	push   $0x0
  804458:	6a 00                	push   $0x0
  80445a:	6a 00                	push   $0x0
  80445c:	6a 21                	push   $0x21
  80445e:	e8 26 fc ff ff       	call   804089 <syscall>
  804463:	83 c4 18             	add    $0x18,%esp
	return ;
  804466:	90                   	nop
}
  804467:	c9                   	leave  
  804468:	c3                   	ret    

00804469 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  804469:	55                   	push   %ebp
  80446a:	89 e5                	mov    %esp,%ebp
  80446c:	83 ec 04             	sub    $0x4,%esp
  80446f:	8b 45 14             	mov    0x14(%ebp),%eax
  804472:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  804475:	8b 55 18             	mov    0x18(%ebp),%edx
  804478:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80447c:	52                   	push   %edx
  80447d:	50                   	push   %eax
  80447e:	ff 75 10             	pushl  0x10(%ebp)
  804481:	ff 75 0c             	pushl  0xc(%ebp)
  804484:	ff 75 08             	pushl  0x8(%ebp)
  804487:	6a 20                	push   $0x20
  804489:	e8 fb fb ff ff       	call   804089 <syscall>
  80448e:	83 c4 18             	add    $0x18,%esp
	return ;
  804491:	90                   	nop
}
  804492:	c9                   	leave  
  804493:	c3                   	ret    

00804494 <chktst>:
void chktst(uint32 n)
{
  804494:	55                   	push   %ebp
  804495:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  804497:	6a 00                	push   $0x0
  804499:	6a 00                	push   $0x0
  80449b:	6a 00                	push   $0x0
  80449d:	6a 00                	push   $0x0
  80449f:	ff 75 08             	pushl  0x8(%ebp)
  8044a2:	6a 22                	push   $0x22
  8044a4:	e8 e0 fb ff ff       	call   804089 <syscall>
  8044a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8044ac:	90                   	nop
}
  8044ad:	c9                   	leave  
  8044ae:	c3                   	ret    

008044af <inctst>:

void inctst()
{
  8044af:	55                   	push   %ebp
  8044b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8044b2:	6a 00                	push   $0x0
  8044b4:	6a 00                	push   $0x0
  8044b6:	6a 00                	push   $0x0
  8044b8:	6a 00                	push   $0x0
  8044ba:	6a 00                	push   $0x0
  8044bc:	6a 23                	push   $0x23
  8044be:	e8 c6 fb ff ff       	call   804089 <syscall>
  8044c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8044c6:	90                   	nop
}
  8044c7:	c9                   	leave  
  8044c8:	c3                   	ret    

008044c9 <gettst>:
uint32 gettst()
{
  8044c9:	55                   	push   %ebp
  8044ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8044cc:	6a 00                	push   $0x0
  8044ce:	6a 00                	push   $0x0
  8044d0:	6a 00                	push   $0x0
  8044d2:	6a 00                	push   $0x0
  8044d4:	6a 00                	push   $0x0
  8044d6:	6a 24                	push   $0x24
  8044d8:	e8 ac fb ff ff       	call   804089 <syscall>
  8044dd:	83 c4 18             	add    $0x18,%esp
}
  8044e0:	c9                   	leave  
  8044e1:	c3                   	ret    

008044e2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8044e2:	55                   	push   %ebp
  8044e3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8044e5:	6a 00                	push   $0x0
  8044e7:	6a 00                	push   $0x0
  8044e9:	6a 00                	push   $0x0
  8044eb:	6a 00                	push   $0x0
  8044ed:	6a 00                	push   $0x0
  8044ef:	6a 25                	push   $0x25
  8044f1:	e8 93 fb ff ff       	call   804089 <syscall>
  8044f6:	83 c4 18             	add    $0x18,%esp
  8044f9:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  8044fe:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  804503:	c9                   	leave  
  804504:	c3                   	ret    

00804505 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  804505:	55                   	push   %ebp
  804506:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  804508:	8b 45 08             	mov    0x8(%ebp),%eax
  80450b:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  804510:	6a 00                	push   $0x0
  804512:	6a 00                	push   $0x0
  804514:	6a 00                	push   $0x0
  804516:	6a 00                	push   $0x0
  804518:	ff 75 08             	pushl  0x8(%ebp)
  80451b:	6a 26                	push   $0x26
  80451d:	e8 67 fb ff ff       	call   804089 <syscall>
  804522:	83 c4 18             	add    $0x18,%esp
	return ;
  804525:	90                   	nop
}
  804526:	c9                   	leave  
  804527:	c3                   	ret    

00804528 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  804528:	55                   	push   %ebp
  804529:	89 e5                	mov    %esp,%ebp
  80452b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80452c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80452f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804532:	8b 55 0c             	mov    0xc(%ebp),%edx
  804535:	8b 45 08             	mov    0x8(%ebp),%eax
  804538:	6a 00                	push   $0x0
  80453a:	53                   	push   %ebx
  80453b:	51                   	push   %ecx
  80453c:	52                   	push   %edx
  80453d:	50                   	push   %eax
  80453e:	6a 27                	push   $0x27
  804540:	e8 44 fb ff ff       	call   804089 <syscall>
  804545:	83 c4 18             	add    $0x18,%esp
}
  804548:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80454b:	c9                   	leave  
  80454c:	c3                   	ret    

0080454d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80454d:	55                   	push   %ebp
  80454e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  804550:	8b 55 0c             	mov    0xc(%ebp),%edx
  804553:	8b 45 08             	mov    0x8(%ebp),%eax
  804556:	6a 00                	push   $0x0
  804558:	6a 00                	push   $0x0
  80455a:	6a 00                	push   $0x0
  80455c:	52                   	push   %edx
  80455d:	50                   	push   %eax
  80455e:	6a 28                	push   $0x28
  804560:	e8 24 fb ff ff       	call   804089 <syscall>
  804565:	83 c4 18             	add    $0x18,%esp
}
  804568:	c9                   	leave  
  804569:	c3                   	ret    

0080456a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80456a:	55                   	push   %ebp
  80456b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80456d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  804570:	8b 55 0c             	mov    0xc(%ebp),%edx
  804573:	8b 45 08             	mov    0x8(%ebp),%eax
  804576:	6a 00                	push   $0x0
  804578:	51                   	push   %ecx
  804579:	ff 75 10             	pushl  0x10(%ebp)
  80457c:	52                   	push   %edx
  80457d:	50                   	push   %eax
  80457e:	6a 29                	push   $0x29
  804580:	e8 04 fb ff ff       	call   804089 <syscall>
  804585:	83 c4 18             	add    $0x18,%esp
}
  804588:	c9                   	leave  
  804589:	c3                   	ret    

0080458a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80458a:	55                   	push   %ebp
  80458b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80458d:	6a 00                	push   $0x0
  80458f:	6a 00                	push   $0x0
  804591:	ff 75 10             	pushl  0x10(%ebp)
  804594:	ff 75 0c             	pushl  0xc(%ebp)
  804597:	ff 75 08             	pushl  0x8(%ebp)
  80459a:	6a 12                	push   $0x12
  80459c:	e8 e8 fa ff ff       	call   804089 <syscall>
  8045a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8045a4:	90                   	nop
}
  8045a5:	c9                   	leave  
  8045a6:	c3                   	ret    

008045a7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8045a7:	55                   	push   %ebp
  8045a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8045aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8045ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8045b0:	6a 00                	push   $0x0
  8045b2:	6a 00                	push   $0x0
  8045b4:	6a 00                	push   $0x0
  8045b6:	52                   	push   %edx
  8045b7:	50                   	push   %eax
  8045b8:	6a 2a                	push   $0x2a
  8045ba:	e8 ca fa ff ff       	call   804089 <syscall>
  8045bf:	83 c4 18             	add    $0x18,%esp
	return;
  8045c2:	90                   	nop
}
  8045c3:	c9                   	leave  
  8045c4:	c3                   	ret    

008045c5 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8045c5:	55                   	push   %ebp
  8045c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8045c8:	6a 00                	push   $0x0
  8045ca:	6a 00                	push   $0x0
  8045cc:	6a 00                	push   $0x0
  8045ce:	6a 00                	push   $0x0
  8045d0:	6a 00                	push   $0x0
  8045d2:	6a 2b                	push   $0x2b
  8045d4:	e8 b0 fa ff ff       	call   804089 <syscall>
  8045d9:	83 c4 18             	add    $0x18,%esp
}
  8045dc:	c9                   	leave  
  8045dd:	c3                   	ret    

008045de <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8045de:	55                   	push   %ebp
  8045df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8045e1:	6a 00                	push   $0x0
  8045e3:	6a 00                	push   $0x0
  8045e5:	6a 00                	push   $0x0
  8045e7:	ff 75 0c             	pushl  0xc(%ebp)
  8045ea:	ff 75 08             	pushl  0x8(%ebp)
  8045ed:	6a 2d                	push   $0x2d
  8045ef:	e8 95 fa ff ff       	call   804089 <syscall>
  8045f4:	83 c4 18             	add    $0x18,%esp
	return;
  8045f7:	90                   	nop
}
  8045f8:	c9                   	leave  
  8045f9:	c3                   	ret    

008045fa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8045fa:	55                   	push   %ebp
  8045fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8045fd:	6a 00                	push   $0x0
  8045ff:	6a 00                	push   $0x0
  804601:	6a 00                	push   $0x0
  804603:	ff 75 0c             	pushl  0xc(%ebp)
  804606:	ff 75 08             	pushl  0x8(%ebp)
  804609:	6a 2c                	push   $0x2c
  80460b:	e8 79 fa ff ff       	call   804089 <syscall>
  804610:	83 c4 18             	add    $0x18,%esp
	return ;
  804613:	90                   	nop
}
  804614:	c9                   	leave  
  804615:	c3                   	ret    

00804616 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  804616:	55                   	push   %ebp
  804617:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  804619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80461c:	8b 45 08             	mov    0x8(%ebp),%eax
  80461f:	6a 00                	push   $0x0
  804621:	6a 00                	push   $0x0
  804623:	6a 00                	push   $0x0
  804625:	52                   	push   %edx
  804626:	50                   	push   %eax
  804627:	6a 2e                	push   $0x2e
  804629:	e8 5b fa ff ff       	call   804089 <syscall>
  80462e:	83 c4 18             	add    $0x18,%esp
	    return;
  804631:	90                   	nop
}
  804632:	c9                   	leave  
  804633:	c3                   	ret    

00804634 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  804634:	55                   	push   %ebp
  804635:	89 e5                	mov    %esp,%ebp
  804637:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80463a:	8b 45 08             	mov    0x8(%ebp),%eax
  80463d:	ba 40 72 80 00       	mov    $0x807240,%edx
  804642:	29 d0                	sub    %edx,%eax
  804644:	c1 f8 02             	sar    $0x2,%eax
  804647:	89 c2                	mov    %eax,%edx
  804649:	89 d0                	mov    %edx,%eax
  80464b:	c1 e0 02             	shl    $0x2,%eax
  80464e:	01 d0                	add    %edx,%eax
  804650:	c1 e0 02             	shl    $0x2,%eax
  804653:	01 d0                	add    %edx,%eax
  804655:	c1 e0 02             	shl    $0x2,%eax
  804658:	01 d0                	add    %edx,%eax
  80465a:	89 c1                	mov    %eax,%ecx
  80465c:	c1 e1 08             	shl    $0x8,%ecx
  80465f:	01 c8                	add    %ecx,%eax
  804661:	89 c1                	mov    %eax,%ecx
  804663:	c1 e1 10             	shl    $0x10,%ecx
  804666:	01 c8                	add    %ecx,%eax
  804668:	01 c0                	add    %eax,%eax
  80466a:	01 d0                	add    %edx,%eax
  80466c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80466f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804672:	c1 e0 0c             	shl    $0xc,%eax
  804675:	89 c2                	mov    %eax,%edx
  804677:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80467c:	01 d0                	add    %edx,%eax
}
  80467e:	c9                   	leave  
  80467f:	c3                   	ret    

00804680 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  804680:	55                   	push   %ebp
  804681:	89 e5                	mov    %esp,%ebp
  804683:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  804686:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  80468d:	eb 06                	jmp    804695 <log2+0x15>
			n >>=1;
  80468f:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  804692:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  804695:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804699:	77 f4                	ja     80468f <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  80469b:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80469e:	c9                   	leave  
  80469f:	c3                   	ret    

008046a0 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8046a0:	55                   	push   %ebp
  8046a1:	89 e5                	mov    %esp,%ebp
  8046a3:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8046a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8046a9:	05 00 00 00 02       	add    $0x2000000,%eax
  8046ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8046b1:	73 16                	jae    8046c9 <initialize_dynamic_allocator+0x29>
  8046b3:	68 78 63 80 00       	push   $0x806378
  8046b8:	68 9e 63 80 00       	push   $0x80639e
  8046bd:	6a 2d                	push   $0x2d
  8046bf:	68 b3 63 80 00       	push   $0x8063b3
  8046c4:	e8 a6 ce ff ff       	call   80156f <_panic>
		is_initialized = 1;
  8046c9:	c7 05 04 72 80 00 01 	movl   $0x1,0x807204
  8046d0:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  8046d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8046d6:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd= daEnd;
  8046db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046de:	a3 20 72 80 00       	mov    %eax,0x807220
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  8046e3:	8b 15 20 72 80 00    	mov    0x807220,%edx
  8046e9:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8046ee:	29 c2                	sub    %eax,%edx
  8046f0:	89 d0                	mov    %edx,%eax
  8046f2:	c1 e8 0c             	shr    $0xc,%eax
  8046f5:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  8046f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8046ff:	eb 2f                	jmp    804730 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  804701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804704:	89 d0                	mov    %edx,%eax
  804706:	01 c0                	add    %eax,%eax
  804708:	01 d0                	add    %edx,%eax
  80470a:	c1 e0 02             	shl    $0x2,%eax
  80470d:	05 48 72 80 00       	add    $0x807248,%eax
  804712:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  804717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80471a:	89 d0                	mov    %edx,%eax
  80471c:	01 c0                	add    %eax,%eax
  80471e:	01 d0                	add    %edx,%eax
  804720:	c1 e0 02             	shl    $0x2,%eax
  804723:	05 4a 72 80 00       	add    $0x80724a,%eax
  804728:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  80472d:	ff 45 f4             	incl   -0xc(%ebp)
  804730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804733:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804736:	7c c9                	jl     804701 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  804738:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  80473f:	00 00 00 
  804742:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  804749:	00 00 00 
  80474c:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  804753:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  804756:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80475d:	e9 9c 00 00 00       	jmp    8047fe <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  804762:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804768:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80476b:	89 c8                	mov    %ecx,%eax
  80476d:	01 c0                	add    %eax,%eax
  80476f:	01 c8                	add    %ecx,%eax
  804771:	c1 e0 02             	shl    $0x2,%eax
  804774:	05 44 72 80 00       	add    $0x807244,%eax
  804779:	89 10                	mov    %edx,(%eax)
  80477b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80477e:	89 d0                	mov    %edx,%eax
  804780:	01 c0                	add    %eax,%eax
  804782:	01 d0                	add    %edx,%eax
  804784:	c1 e0 02             	shl    $0x2,%eax
  804787:	05 44 72 80 00       	add    $0x807244,%eax
  80478c:	8b 00                	mov    (%eax),%eax
  80478e:	85 c0                	test   %eax,%eax
  804790:	74 1b                	je     8047ad <initialize_dynamic_allocator+0x10d>
  804792:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804798:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80479b:	89 c8                	mov    %ecx,%eax
  80479d:	01 c0                	add    %eax,%eax
  80479f:	01 c8                	add    %ecx,%eax
  8047a1:	c1 e0 02             	shl    $0x2,%eax
  8047a4:	05 40 72 80 00       	add    $0x807240,%eax
  8047a9:	89 02                	mov    %eax,(%edx)
  8047ab:	eb 16                	jmp    8047c3 <initialize_dynamic_allocator+0x123>
  8047ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8047b0:	89 d0                	mov    %edx,%eax
  8047b2:	01 c0                	add    %eax,%eax
  8047b4:	01 d0                	add    %edx,%eax
  8047b6:	c1 e0 02             	shl    $0x2,%eax
  8047b9:	05 40 72 80 00       	add    $0x807240,%eax
  8047be:	a3 28 72 80 00       	mov    %eax,0x807228
  8047c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8047c6:	89 d0                	mov    %edx,%eax
  8047c8:	01 c0                	add    %eax,%eax
  8047ca:	01 d0                	add    %edx,%eax
  8047cc:	c1 e0 02             	shl    $0x2,%eax
  8047cf:	05 40 72 80 00       	add    $0x807240,%eax
  8047d4:	a3 2c 72 80 00       	mov    %eax,0x80722c
  8047d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8047dc:	89 d0                	mov    %edx,%eax
  8047de:	01 c0                	add    %eax,%eax
  8047e0:	01 d0                	add    %edx,%eax
  8047e2:	c1 e0 02             	shl    $0x2,%eax
  8047e5:	05 40 72 80 00       	add    $0x807240,%eax
  8047ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047f0:	a1 34 72 80 00       	mov    0x807234,%eax
  8047f5:	40                   	inc    %eax
  8047f6:	a3 34 72 80 00       	mov    %eax,0x807234
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  8047fb:	ff 45 f0             	incl   -0x10(%ebp)
  8047fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804801:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804804:	0f 8c 58 ff ff ff    	jl     804762 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80480a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  804811:	eb 36                	jmp    804849 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  804813:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804816:	c1 e0 04             	shl    $0x4,%eax
  804819:	05 60 f2 81 00       	add    $0x81f260,%eax
  80481e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804824:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804827:	c1 e0 04             	shl    $0x4,%eax
  80482a:	05 64 f2 81 00       	add    $0x81f264,%eax
  80482f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804838:	c1 e0 04             	shl    $0x4,%eax
  80483b:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804840:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  804846:	ff 45 ec             	incl   -0x14(%ebp)
  804849:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80484d:	7e c4                	jle    804813 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80484f:	90                   	nop
  804850:	c9                   	leave  
  804851:	c3                   	ret    

00804852 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  804852:	55                   	push   %ebp
  804853:	89 e5                	mov    %esp,%ebp
  804855:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804858:	8b 55 08             	mov    0x8(%ebp),%edx
  80485b:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804860:	29 c2                	sub    %eax,%edx
  804862:	89 d0                	mov    %edx,%eax
  804864:	c1 e8 0c             	shr    $0xc,%eax
  804867:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  80486a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80486d:	89 d0                	mov    %edx,%eax
  80486f:	01 c0                	add    %eax,%eax
  804871:	01 d0                	add    %edx,%eax
  804873:	c1 e0 02             	shl    $0x2,%eax
  804876:	05 48 72 80 00       	add    $0x807248,%eax
  80487b:	8b 00                	mov    (%eax),%eax
  80487d:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  804880:	c9                   	leave  
  804881:	c3                   	ret    

00804882 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  804882:	55                   	push   %ebp
  804883:	89 e5                	mov    %esp,%ebp
  804885:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  804888:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80488f:	76 16                	jbe    8048a7 <alloc_block+0x25>
  804891:	68 cc 63 80 00       	push   $0x8063cc
  804896:	68 9e 63 80 00       	push   $0x80639e
  80489b:	6a 6c                	push   $0x6c
  80489d:	68 b3 63 80 00       	push   $0x8063b3
  8048a2:	e8 c8 cc ff ff       	call   80156f <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  8048a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8048ab:	75 0a                	jne    8048b7 <alloc_block+0x35>
		return NULL;
  8048ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8048b2:	e9 65 04 00 00       	jmp    804d1c <alloc_block+0x49a>
	}
	else if(size<=8){
  8048b7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  8048bb:	77 09                	ja     8048c6 <alloc_block+0x44>
		size=8;
  8048bd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  8048c4:	eb 1f                	jmp    8048e5 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  8048c6:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  8048cd:	eb 08                	jmp    8048d7 <alloc_block+0x55>
			reqsize*=2;
  8048cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048d2:	01 c0                	add    %eax,%eax
  8048d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  8048d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8048dd:	72 f0                	jb     8048cf <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  8048df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048e2:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  8048e5:	83 ec 0c             	sub    $0xc,%esp
  8048e8:	ff 75 08             	pushl  0x8(%ebp)
  8048eb:	e8 90 fd ff ff       	call   804680 <log2>
  8048f0:	83 c4 10             	add    $0x10,%esp
  8048f3:	83 e8 03             	sub    $0x3,%eax
  8048f6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  8048f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048fc:	c1 e0 04             	shl    $0x4,%eax
  8048ff:	05 60 f2 81 00       	add    $0x81f260,%eax
  804904:	8b 00                	mov    (%eax),%eax
  804906:	85 c0                	test   %eax,%eax
  804908:	0f 84 fb 00 00 00    	je     804a09 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  80490e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804911:	c1 e0 04             	shl    $0x4,%eax
  804914:	05 60 f2 81 00       	add    $0x81f260,%eax
  804919:	8b 00                	mov    (%eax),%eax
  80491b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  80491e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804922:	75 17                	jne    80493b <alloc_block+0xb9>
  804924:	83 ec 04             	sub    $0x4,%esp
  804927:	68 ed 63 80 00       	push   $0x8063ed
  80492c:	68 86 00 00 00       	push   $0x86
  804931:	68 b3 63 80 00       	push   $0x8063b3
  804936:	e8 34 cc ff ff       	call   80156f <_panic>
  80493b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80493e:	8b 00                	mov    (%eax),%eax
  804940:	85 c0                	test   %eax,%eax
  804942:	74 10                	je     804954 <alloc_block+0xd2>
  804944:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804947:	8b 00                	mov    (%eax),%eax
  804949:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80494c:	8b 52 04             	mov    0x4(%edx),%edx
  80494f:	89 50 04             	mov    %edx,0x4(%eax)
  804952:	eb 14                	jmp    804968 <alloc_block+0xe6>
  804954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804957:	8b 40 04             	mov    0x4(%eax),%eax
  80495a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80495d:	c1 e2 04             	shl    $0x4,%edx
  804960:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804966:	89 02                	mov    %eax,(%edx)
  804968:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80496b:	8b 40 04             	mov    0x4(%eax),%eax
  80496e:	85 c0                	test   %eax,%eax
  804970:	74 0f                	je     804981 <alloc_block+0xff>
  804972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804975:	8b 40 04             	mov    0x4(%eax),%eax
  804978:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80497b:	8b 12                	mov    (%edx),%edx
  80497d:	89 10                	mov    %edx,(%eax)
  80497f:	eb 13                	jmp    804994 <alloc_block+0x112>
  804981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804984:	8b 00                	mov    (%eax),%eax
  804986:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804989:	c1 e2 04             	shl    $0x4,%edx
  80498c:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804992:	89 02                	mov    %eax,(%edx)
  804994:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80499d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8049a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049aa:	c1 e0 04             	shl    $0x4,%eax
  8049ad:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8049b2:	8b 00                	mov    (%eax),%eax
  8049b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8049b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049ba:	c1 e0 04             	shl    $0x4,%eax
  8049bd:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8049c2:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  8049c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049c7:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8049cc:	29 c2                	sub    %eax,%edx
  8049ce:	89 d0                	mov    %edx,%eax
  8049d0:	c1 e8 0c             	shr    $0xc,%eax
  8049d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  8049d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8049d9:	89 d0                	mov    %edx,%eax
  8049db:	01 c0                	add    %eax,%eax
  8049dd:	01 d0                	add    %edx,%eax
  8049df:	c1 e0 02             	shl    $0x2,%eax
  8049e2:	05 4a 72 80 00       	add    $0x80724a,%eax
  8049e7:	66 8b 00             	mov    (%eax),%ax
  8049ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8049ed:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8049f0:	89 c8                	mov    %ecx,%eax
  8049f2:	01 c0                	add    %eax,%eax
  8049f4:	01 c8                	add    %ecx,%eax
  8049f6:	c1 e0 02             	shl    $0x2,%eax
  8049f9:	05 4a 72 80 00       	add    $0x80724a,%eax
  8049fe:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  804a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a04:	e9 13 03 00 00       	jmp    804d1c <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  804a09:	a1 28 72 80 00       	mov    0x807228,%eax
  804a0e:	85 c0                	test   %eax,%eax
  804a10:	0f 84 c9 01 00 00    	je     804bdf <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  804a16:	a1 28 72 80 00       	mov    0x807228,%eax
  804a1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  804a1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804a22:	75 17                	jne    804a3b <alloc_block+0x1b9>
  804a24:	83 ec 04             	sub    $0x4,%esp
  804a27:	68 ed 63 80 00       	push   $0x8063ed
  804a2c:	68 8f 00 00 00       	push   $0x8f
  804a31:	68 b3 63 80 00       	push   $0x8063b3
  804a36:	e8 34 cb ff ff       	call   80156f <_panic>
  804a3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a3e:	8b 00                	mov    (%eax),%eax
  804a40:	85 c0                	test   %eax,%eax
  804a42:	74 10                	je     804a54 <alloc_block+0x1d2>
  804a44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a47:	8b 00                	mov    (%eax),%eax
  804a49:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804a4c:	8b 52 04             	mov    0x4(%edx),%edx
  804a4f:	89 50 04             	mov    %edx,0x4(%eax)
  804a52:	eb 0b                	jmp    804a5f <alloc_block+0x1dd>
  804a54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a57:	8b 40 04             	mov    0x4(%eax),%eax
  804a5a:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804a5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a62:	8b 40 04             	mov    0x4(%eax),%eax
  804a65:	85 c0                	test   %eax,%eax
  804a67:	74 0f                	je     804a78 <alloc_block+0x1f6>
  804a69:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a6c:	8b 40 04             	mov    0x4(%eax),%eax
  804a6f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804a72:	8b 12                	mov    (%edx),%edx
  804a74:	89 10                	mov    %edx,(%eax)
  804a76:	eb 0a                	jmp    804a82 <alloc_block+0x200>
  804a78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a7b:	8b 00                	mov    (%eax),%eax
  804a7d:	a3 28 72 80 00       	mov    %eax,0x807228
  804a82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a95:	a1 34 72 80 00       	mov    0x807234,%eax
  804a9a:	48                   	dec    %eax
  804a9b:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  804aa0:	83 ec 0c             	sub    $0xc,%esp
  804aa3:	ff 75 dc             	pushl  -0x24(%ebp)
  804aa6:	e8 89 fb ff ff       	call   804634 <to_page_va>
  804aab:	83 c4 10             	add    $0x10,%esp
  804aae:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  804ab1:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804ab6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804ab9:	29 c2                	sub    %eax,%edx
  804abb:	89 d0                	mov    %edx,%eax
  804abd:	c1 e8 0c             	shr    $0xc,%eax
  804ac0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  804ac3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804ac6:	83 ec 0c             	sub    $0xc,%esp
  804ac9:	50                   	push   %eax
  804aca:	e8 fe dc ff ff       	call   8027cd <get_page>
  804acf:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  804ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  804ad5:	89 c2                	mov    %eax,%edx
  804ad7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804ada:	89 c8                	mov    %ecx,%eax
  804adc:	01 c0                	add    %eax,%eax
  804ade:	01 c8                	add    %ecx,%eax
  804ae0:	c1 e0 02             	shl    $0x2,%eax
  804ae3:	05 48 72 80 00       	add    $0x807248,%eax
  804ae8:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  804aeb:	b8 00 10 00 00       	mov    $0x1000,%eax
  804af0:	ba 00 00 00 00       	mov    $0x0,%edx
  804af5:	f7 75 08             	divl   0x8(%ebp)
  804af8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  804afb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804afe:	8d 50 ff             	lea    -0x1(%eax),%edx
  804b01:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804b04:	89 c8                	mov    %ecx,%eax
  804b06:	01 c0                	add    %eax,%eax
  804b08:	01 c8                	add    %ecx,%eax
  804b0a:	c1 e0 02             	shl    $0x2,%eax
  804b0d:	05 4a 72 80 00       	add    $0x80724a,%eax
  804b12:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  804b15:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  804b1c:	e9 aa 00 00 00       	jmp    804bcb <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  804b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b24:	0f af 45 08          	imul   0x8(%ebp),%eax
  804b28:	89 c2                	mov    %eax,%edx
  804b2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804b2d:	01 d0                	add    %edx,%eax
  804b2f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  804b32:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804b36:	75 17                	jne    804b4f <alloc_block+0x2cd>
  804b38:	83 ec 04             	sub    $0x4,%esp
  804b3b:	68 0c 64 80 00       	push   $0x80640c
  804b40:	68 9d 00 00 00       	push   $0x9d
  804b45:	68 b3 63 80 00       	push   $0x8063b3
  804b4a:	e8 20 ca ff ff       	call   80156f <_panic>
  804b4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b52:	c1 e0 04             	shl    $0x4,%eax
  804b55:	05 64 f2 81 00       	add    $0x81f264,%eax
  804b5a:	8b 10                	mov    (%eax),%edx
  804b5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804b5f:	89 50 04             	mov    %edx,0x4(%eax)
  804b62:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804b65:	8b 40 04             	mov    0x4(%eax),%eax
  804b68:	85 c0                	test   %eax,%eax
  804b6a:	74 14                	je     804b80 <alloc_block+0x2fe>
  804b6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b6f:	c1 e0 04             	shl    $0x4,%eax
  804b72:	05 64 f2 81 00       	add    $0x81f264,%eax
  804b77:	8b 00                	mov    (%eax),%eax
  804b79:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804b7c:	89 10                	mov    %edx,(%eax)
  804b7e:	eb 11                	jmp    804b91 <alloc_block+0x30f>
  804b80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b83:	c1 e0 04             	shl    $0x4,%eax
  804b86:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804b8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804b8f:	89 02                	mov    %eax,(%edx)
  804b91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b94:	c1 e0 04             	shl    $0x4,%eax
  804b97:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804b9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804ba0:	89 02                	mov    %eax,(%edx)
  804ba2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804ba5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804bab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bae:	c1 e0 04             	shl    $0x4,%eax
  804bb1:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804bb6:	8b 00                	mov    (%eax),%eax
  804bb8:	8d 50 01             	lea    0x1(%eax),%edx
  804bbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bbe:	c1 e0 04             	shl    $0x4,%eax
  804bc1:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804bc6:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  804bc8:	ff 45 f0             	incl   -0x10(%ebp)
  804bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804bce:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  804bd1:	0f 8c 4a ff ff ff    	jl     804b21 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  804bd7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804bda:	e9 3d 01 00 00       	jmp    804d1c <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804bdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804be2:	40                   	inc    %eax
  804be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804be6:	e9 10 01 00 00       	jmp    804cfb <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  804beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804bee:	c1 e0 04             	shl    $0x4,%eax
  804bf1:	05 60 f2 81 00       	add    $0x81f260,%eax
  804bf6:	8b 00                	mov    (%eax),%eax
  804bf8:	85 c0                	test   %eax,%eax
  804bfa:	0f 84 f8 00 00 00    	je     804cf8 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c03:	c1 e0 04             	shl    $0x4,%eax
  804c06:	05 60 f2 81 00       	add    $0x81f260,%eax
  804c0b:	8b 00                	mov    (%eax),%eax
  804c0d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  804c10:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804c14:	75 17                	jne    804c2d <alloc_block+0x3ab>
  804c16:	83 ec 04             	sub    $0x4,%esp
  804c19:	68 ed 63 80 00       	push   $0x8063ed
  804c1e:	68 a8 00 00 00       	push   $0xa8
  804c23:	68 b3 63 80 00       	push   $0x8063b3
  804c28:	e8 42 c9 ff ff       	call   80156f <_panic>
  804c2d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c30:	8b 00                	mov    (%eax),%eax
  804c32:	85 c0                	test   %eax,%eax
  804c34:	74 10                	je     804c46 <alloc_block+0x3c4>
  804c36:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c39:	8b 00                	mov    (%eax),%eax
  804c3b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804c3e:	8b 52 04             	mov    0x4(%edx),%edx
  804c41:	89 50 04             	mov    %edx,0x4(%eax)
  804c44:	eb 14                	jmp    804c5a <alloc_block+0x3d8>
  804c46:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c49:	8b 40 04             	mov    0x4(%eax),%eax
  804c4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804c4f:	c1 e2 04             	shl    $0x4,%edx
  804c52:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804c58:	89 02                	mov    %eax,(%edx)
  804c5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c5d:	8b 40 04             	mov    0x4(%eax),%eax
  804c60:	85 c0                	test   %eax,%eax
  804c62:	74 0f                	je     804c73 <alloc_block+0x3f1>
  804c64:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c67:	8b 40 04             	mov    0x4(%eax),%eax
  804c6a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804c6d:	8b 12                	mov    (%edx),%edx
  804c6f:	89 10                	mov    %edx,(%eax)
  804c71:	eb 13                	jmp    804c86 <alloc_block+0x404>
  804c73:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c76:	8b 00                	mov    (%eax),%eax
  804c78:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804c7b:	c1 e2 04             	shl    $0x4,%edx
  804c7e:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804c84:	89 02                	mov    %eax,(%edx)
  804c86:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c9c:	c1 e0 04             	shl    $0x4,%eax
  804c9f:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804ca4:	8b 00                	mov    (%eax),%eax
  804ca6:	8d 50 ff             	lea    -0x1(%eax),%edx
  804ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804cac:	c1 e0 04             	shl    $0x4,%eax
  804caf:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804cb4:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804cb6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804cb9:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804cbe:	29 c2                	sub    %eax,%edx
  804cc0:	89 d0                	mov    %edx,%eax
  804cc2:	c1 e8 0c             	shr    $0xc,%eax
  804cc5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  804cc8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  804ccb:	89 d0                	mov    %edx,%eax
  804ccd:	01 c0                	add    %eax,%eax
  804ccf:	01 d0                	add    %edx,%eax
  804cd1:	c1 e0 02             	shl    $0x2,%eax
  804cd4:	05 4a 72 80 00       	add    $0x80724a,%eax
  804cd9:	66 8b 00             	mov    (%eax),%ax
  804cdc:	8d 50 ff             	lea    -0x1(%eax),%edx
  804cdf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  804ce2:	89 c8                	mov    %ecx,%eax
  804ce4:	01 c0                	add    %eax,%eax
  804ce6:	01 c8                	add    %ecx,%eax
  804ce8:	c1 e0 02             	shl    $0x2,%eax
  804ceb:	05 4a 72 80 00       	add    $0x80724a,%eax
  804cf0:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  804cf3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804cf6:	eb 24                	jmp    804d1c <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804cf8:	ff 45 ec             	incl   -0x14(%ebp)
  804cfb:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804cff:	0f 8e e6 fe ff ff    	jle    804beb <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  804d05:	83 ec 04             	sub    $0x4,%esp
  804d08:	68 2f 64 80 00       	push   $0x80642f
  804d0d:	68 b1 00 00 00       	push   $0xb1
  804d12:	68 b3 63 80 00       	push   $0x8063b3
  804d17:	e8 53 c8 ff ff       	call   80156f <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804d1c:	c9                   	leave  
  804d1d:	c3                   	ret    

00804d1e <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804d1e:	55                   	push   %ebp
  804d1f:	89 e5                	mov    %esp,%ebp
  804d21:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804d24:	8b 55 08             	mov    0x8(%ebp),%edx
  804d27:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804d2c:	39 c2                	cmp    %eax,%edx
  804d2e:	72 0c                	jb     804d3c <free_block+0x1e>
  804d30:	8b 55 08             	mov    0x8(%ebp),%edx
  804d33:	a1 20 72 80 00       	mov    0x807220,%eax
  804d38:	39 c2                	cmp    %eax,%edx
  804d3a:	72 19                	jb     804d55 <free_block+0x37>
  804d3c:	68 4c 64 80 00       	push   $0x80644c
  804d41:	68 9e 63 80 00       	push   $0x80639e
  804d46:	68 c3 00 00 00       	push   $0xc3
  804d4b:	68 b3 63 80 00       	push   $0x8063b3
  804d50:	e8 1a c8 ff ff       	call   80156f <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804d55:	8b 55 08             	mov    0x8(%ebp),%edx
  804d58:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804d5d:	29 c2                	sub    %eax,%edx
  804d5f:	89 d0                	mov    %edx,%eax
  804d61:	c1 e8 0c             	shr    $0xc,%eax
  804d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  804d67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804d6a:	89 d0                	mov    %edx,%eax
  804d6c:	01 c0                	add    %eax,%eax
  804d6e:	01 d0                	add    %edx,%eax
  804d70:	c1 e0 02             	shl    $0x2,%eax
  804d73:	05 48 72 80 00       	add    $0x807248,%eax
  804d78:	8b 00                	mov    (%eax),%eax
  804d7a:	0f b7 c0             	movzwl %ax,%eax
  804d7d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  804d80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804d84:	75 17                	jne    804d9d <free_block+0x7f>
		panic("page is empty(already not allocated)");
  804d86:	83 ec 04             	sub    $0x4,%esp
  804d89:	68 84 64 80 00       	push   $0x806484
  804d8e:	68 cf 00 00 00       	push   $0xcf
  804d93:	68 b3 63 80 00       	push   $0x8063b3
  804d98:	e8 d2 c7 ff ff       	call   80156f <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804d9d:	83 ec 0c             	sub    $0xc,%esp
  804da0:	ff 75 ec             	pushl  -0x14(%ebp)
  804da3:	e8 d8 f8 ff ff       	call   804680 <log2>
  804da8:	83 c4 10             	add    $0x10,%esp
  804dab:	83 e8 03             	sub    $0x3,%eax
  804dae:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804db1:	8b 45 08             	mov    0x8(%ebp),%eax
  804db4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  804db7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804dbb:	75 17                	jne    804dd4 <free_block+0xb6>
  804dbd:	83 ec 04             	sub    $0x4,%esp
  804dc0:	68 0c 64 80 00       	push   $0x80640c
  804dc5:	68 d5 00 00 00       	push   $0xd5
  804dca:	68 b3 63 80 00       	push   $0x8063b3
  804dcf:	e8 9b c7 ff ff       	call   80156f <_panic>
  804dd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804dd7:	c1 e0 04             	shl    $0x4,%eax
  804dda:	05 64 f2 81 00       	add    $0x81f264,%eax
  804ddf:	8b 10                	mov    (%eax),%edx
  804de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804de4:	89 50 04             	mov    %edx,0x4(%eax)
  804de7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804dea:	8b 40 04             	mov    0x4(%eax),%eax
  804ded:	85 c0                	test   %eax,%eax
  804def:	74 14                	je     804e05 <free_block+0xe7>
  804df1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804df4:	c1 e0 04             	shl    $0x4,%eax
  804df7:	05 64 f2 81 00       	add    $0x81f264,%eax
  804dfc:	8b 00                	mov    (%eax),%eax
  804dfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804e01:	89 10                	mov    %edx,(%eax)
  804e03:	eb 11                	jmp    804e16 <free_block+0xf8>
  804e05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e08:	c1 e0 04             	shl    $0x4,%eax
  804e0b:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804e11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e14:	89 02                	mov    %eax,(%edx)
  804e16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e19:	c1 e0 04             	shl    $0x4,%eax
  804e1c:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e25:	89 02                	mov    %eax,(%edx)
  804e27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e33:	c1 e0 04             	shl    $0x4,%eax
  804e36:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804e3b:	8b 00                	mov    (%eax),%eax
  804e3d:	8d 50 01             	lea    0x1(%eax),%edx
  804e40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e43:	c1 e0 04             	shl    $0x4,%eax
  804e46:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804e4b:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  804e4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804e50:	89 d0                	mov    %edx,%eax
  804e52:	01 c0                	add    %eax,%eax
  804e54:	01 d0                	add    %edx,%eax
  804e56:	c1 e0 02             	shl    $0x2,%eax
  804e59:	05 4a 72 80 00       	add    $0x80724a,%eax
  804e5e:	66 8b 00             	mov    (%eax),%ax
  804e61:	8d 50 01             	lea    0x1(%eax),%edx
  804e64:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804e67:	89 c8                	mov    %ecx,%eax
  804e69:	01 c0                	add    %eax,%eax
  804e6b:	01 c8                	add    %ecx,%eax
  804e6d:	c1 e0 02             	shl    $0x2,%eax
  804e70:	05 4a 72 80 00       	add    $0x80724a,%eax
  804e75:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  804e78:	b8 00 10 00 00       	mov    $0x1000,%eax
  804e7d:	ba 00 00 00 00       	mov    $0x0,%edx
  804e82:	f7 75 ec             	divl   -0x14(%ebp)
  804e85:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  804e88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804e8b:	89 d0                	mov    %edx,%eax
  804e8d:	01 c0                	add    %eax,%eax
  804e8f:	01 d0                	add    %edx,%eax
  804e91:	c1 e0 02             	shl    $0x2,%eax
  804e94:	05 4a 72 80 00       	add    $0x80724a,%eax
  804e99:	66 8b 00             	mov    (%eax),%ax
  804e9c:	0f b7 c0             	movzwl %ax,%eax
  804e9f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804ea2:	0f 85 d3 01 00 00    	jne    80507b <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  804ea8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804eab:	c1 e0 04             	shl    $0x4,%eax
  804eae:	05 60 f2 81 00       	add    $0x81f260,%eax
  804eb3:	8b 00                	mov    (%eax),%eax
  804eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  804eb8:	e9 f1 00 00 00       	jmp    804fae <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ec0:	8b 00                	mov    (%eax),%eax
  804ec2:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  804ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804ec8:	c1 e0 0c             	shl    $0xc,%eax
  804ecb:	89 c2                	mov    %eax,%edx
  804ecd:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804ed2:	01 d0                	add    %edx,%eax
  804ed4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  804ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804eda:	40                   	inc    %eax
  804edb:	c1 e0 0c             	shl    $0xc,%eax
  804ede:	89 c2                	mov    %eax,%edx
  804ee0:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804ee5:	01 d0                	add    %edx,%eax
  804ee7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  804eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804eed:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  804ef0:	0f 82 b8 00 00 00    	jb     804fae <free_block+0x290>
  804ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ef9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804efc:	0f 83 ac 00 00 00    	jae    804fae <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  804f02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804f06:	75 17                	jne    804f1f <free_block+0x201>
  804f08:	83 ec 04             	sub    $0x4,%esp
  804f0b:	68 ed 63 80 00       	push   $0x8063ed
  804f10:	68 e2 00 00 00       	push   $0xe2
  804f15:	68 b3 63 80 00       	push   $0x8063b3
  804f1a:	e8 50 c6 ff ff       	call   80156f <_panic>
  804f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f22:	8b 00                	mov    (%eax),%eax
  804f24:	85 c0                	test   %eax,%eax
  804f26:	74 10                	je     804f38 <free_block+0x21a>
  804f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f2b:	8b 00                	mov    (%eax),%eax
  804f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804f30:	8b 52 04             	mov    0x4(%edx),%edx
  804f33:	89 50 04             	mov    %edx,0x4(%eax)
  804f36:	eb 14                	jmp    804f4c <free_block+0x22e>
  804f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f3b:	8b 40 04             	mov    0x4(%eax),%eax
  804f3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804f41:	c1 e2 04             	shl    $0x4,%edx
  804f44:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804f4a:	89 02                	mov    %eax,(%edx)
  804f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f4f:	8b 40 04             	mov    0x4(%eax),%eax
  804f52:	85 c0                	test   %eax,%eax
  804f54:	74 0f                	je     804f65 <free_block+0x247>
  804f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f59:	8b 40 04             	mov    0x4(%eax),%eax
  804f5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804f5f:	8b 12                	mov    (%edx),%edx
  804f61:	89 10                	mov    %edx,(%eax)
  804f63:	eb 13                	jmp    804f78 <free_block+0x25a>
  804f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f68:	8b 00                	mov    (%eax),%eax
  804f6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804f6d:	c1 e2 04             	shl    $0x4,%edx
  804f70:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804f76:	89 02                	mov    %eax,(%edx)
  804f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804f8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804f8e:	c1 e0 04             	shl    $0x4,%eax
  804f91:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804f96:	8b 00                	mov    (%eax),%eax
  804f98:	8d 50 ff             	lea    -0x1(%eax),%edx
  804f9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804f9e:	c1 e0 04             	shl    $0x4,%eax
  804fa1:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804fa6:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  804fa8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804fae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804fb2:	0f 85 05 ff ff ff    	jne    804ebd <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  804fb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804fbb:	89 d0                	mov    %edx,%eax
  804fbd:	01 c0                	add    %eax,%eax
  804fbf:	01 d0                	add    %edx,%eax
  804fc1:	c1 e0 02             	shl    $0x2,%eax
  804fc4:	05 48 72 80 00       	add    $0x807248,%eax
  804fc9:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  804fce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804fd1:	89 d0                	mov    %edx,%eax
  804fd3:	01 c0                	add    %eax,%eax
  804fd5:	01 d0                	add    %edx,%eax
  804fd7:	c1 e0 02             	shl    $0x2,%eax
  804fda:	05 4a 72 80 00       	add    $0x80724a,%eax
  804fdf:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  804fe4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804fe7:	89 d0                	mov    %edx,%eax
  804fe9:	01 c0                	add    %eax,%eax
  804feb:	01 d0                	add    %edx,%eax
  804fed:	c1 e0 02             	shl    $0x2,%eax
  804ff0:	05 40 72 80 00       	add    $0x807240,%eax
  804ff5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  804ff8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804ffc:	75 17                	jne    805015 <free_block+0x2f7>
  804ffe:	83 ec 04             	sub    $0x4,%esp
  805001:	68 0c 64 80 00       	push   $0x80640c
  805006:	68 eb 00 00 00       	push   $0xeb
  80500b:	68 b3 63 80 00       	push   $0x8063b3
  805010:	e8 5a c5 ff ff       	call   80156f <_panic>
  805015:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  80501b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80501e:	89 50 04             	mov    %edx,0x4(%eax)
  805021:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805024:	8b 40 04             	mov    0x4(%eax),%eax
  805027:	85 c0                	test   %eax,%eax
  805029:	74 0c                	je     805037 <free_block+0x319>
  80502b:	a1 2c 72 80 00       	mov    0x80722c,%eax
  805030:	8b 55 d0             	mov    -0x30(%ebp),%edx
  805033:	89 10                	mov    %edx,(%eax)
  805035:	eb 08                	jmp    80503f <free_block+0x321>
  805037:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80503a:	a3 28 72 80 00       	mov    %eax,0x807228
  80503f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805042:	a3 2c 72 80 00       	mov    %eax,0x80722c
  805047:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80504a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  805050:	a1 34 72 80 00       	mov    0x807234,%eax
  805055:	40                   	inc    %eax
  805056:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  80505b:	83 ec 0c             	sub    $0xc,%esp
  80505e:	ff 75 d0             	pushl  -0x30(%ebp)
  805061:	e8 ce f5 ff ff       	call   804634 <to_page_va>
  805066:	83 c4 10             	add    $0x10,%esp
  805069:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  80506c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80506f:	83 ec 0c             	sub    $0xc,%esp
  805072:	50                   	push   %eax
  805073:	e8 9e d7 ff ff       	call   802816 <return_page>
  805078:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80507b:	90                   	nop
  80507c:	c9                   	leave  
  80507d:	c3                   	ret    

0080507e <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80507e:	55                   	push   %ebp
  80507f:	89 e5                	mov    %esp,%ebp
  805081:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  805084:	83 ec 04             	sub    $0x4,%esp
  805087:	68 ac 64 80 00       	push   $0x8064ac
  80508c:	68 01 01 00 00       	push   $0x101
  805091:	68 b3 63 80 00       	push   $0x8063b3
  805096:	e8 d4 c4 ff ff       	call   80156f <_panic>

0080509b <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  80509b:	55                   	push   %ebp
  80509c:	89 e5                	mov    %esp,%ebp
  80509e:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  8050a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8050a5:	74 1c                	je     8050c3 <init_uspinlock+0x28>
  8050a7:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8050ab:	74 16                	je     8050c3 <init_uspinlock+0x28>
  8050ad:	68 d0 64 80 00       	push   $0x8064d0
  8050b2:	68 ef 64 80 00       	push   $0x8064ef
  8050b7:	6a 10                	push   $0x10
  8050b9:	68 04 65 80 00       	push   $0x806504
  8050be:	e8 ac c4 ff ff       	call   80156f <_panic>
	strcpy(lk->name, name);
  8050c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8050c6:	83 c0 04             	add    $0x4,%eax
  8050c9:	83 ec 08             	sub    $0x8,%esp
  8050cc:	ff 75 0c             	pushl  0xc(%ebp)
  8050cf:	50                   	push   %eax
  8050d0:	e8 90 ce ff ff       	call   801f65 <strcpy>
  8050d5:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  8050d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8050dd:	2b 45 10             	sub    0x10(%ebp),%eax
  8050e0:	89 c2                	mov    %eax,%edx
  8050e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8050e5:	89 10                	mov    %edx,(%eax)
}
  8050e7:	90                   	nop
  8050e8:	c9                   	leave  
  8050e9:	c3                   	ret    

008050ea <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8050ea:	55                   	push   %ebp
  8050eb:	89 e5                	mov    %esp,%ebp
  8050ed:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  8050f0:	90                   	nop
  8050f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8050f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8050f7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8050fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  805101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805104:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  805107:	f0 87 02             	lock xchg %eax,(%edx)
  80510a:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  80510d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  805110:	85 c0                	test   %eax,%eax
  805112:	75 dd                	jne    8050f1 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  805114:	8b 45 08             	mov    0x8(%ebp),%eax
  805117:	8d 48 04             	lea    0x4(%eax),%ecx
  80511a:	a1 00 72 80 00       	mov    0x807200,%eax
  80511f:	8d 50 20             	lea    0x20(%eax),%edx
  805122:	a1 00 72 80 00       	mov    0x807200,%eax
  805127:	8b 40 10             	mov    0x10(%eax),%eax
  80512a:	51                   	push   %ecx
  80512b:	52                   	push   %edx
  80512c:	50                   	push   %eax
  80512d:	68 14 65 80 00       	push   $0x806514
  805132:	e8 06 c7 ff ff       	call   80183d <cprintf>
  805137:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  80513a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  80513f:	90                   	nop
  805140:	c9                   	leave  
  805141:	c3                   	ret    

00805142 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  805142:	55                   	push   %ebp
  805143:	89 e5                	mov    %esp,%ebp
  805145:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  805148:	8b 45 08             	mov    0x8(%ebp),%eax
  80514b:	8b 00                	mov    (%eax),%eax
  80514d:	85 c0                	test   %eax,%eax
  80514f:	75 18                	jne    805169 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  805151:	8b 45 08             	mov    0x8(%ebp),%eax
  805154:	83 c0 04             	add    $0x4,%eax
  805157:	50                   	push   %eax
  805158:	68 38 65 80 00       	push   $0x806538
  80515d:	6a 2b                	push   $0x2b
  80515f:	68 04 65 80 00       	push   $0x806504
  805164:	e8 06 c4 ff ff       	call   80156f <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  805169:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  80516e:	8b 45 08             	mov    0x8(%ebp),%eax
  805171:	8b 55 08             	mov    0x8(%ebp),%edx
  805174:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80517a:	8b 45 08             	mov    0x8(%ebp),%eax
  80517d:	8d 48 04             	lea    0x4(%eax),%ecx
  805180:	a1 00 72 80 00       	mov    0x807200,%eax
  805185:	8d 50 20             	lea    0x20(%eax),%edx
  805188:	a1 00 72 80 00       	mov    0x807200,%eax
  80518d:	8b 40 10             	mov    0x10(%eax),%eax
  805190:	51                   	push   %ecx
  805191:	52                   	push   %edx
  805192:	50                   	push   %eax
  805193:	68 58 65 80 00       	push   $0x806558
  805198:	e8 a0 c6 ff ff       	call   80183d <cprintf>
  80519d:	83 c4 10             	add    $0x10,%esp
}
  8051a0:	90                   	nop
  8051a1:	c9                   	leave  
  8051a2:	c3                   	ret    
  8051a3:	90                   	nop

008051a4 <__udivdi3>:
  8051a4:	55                   	push   %ebp
  8051a5:	57                   	push   %edi
  8051a6:	56                   	push   %esi
  8051a7:	53                   	push   %ebx
  8051a8:	83 ec 1c             	sub    $0x1c,%esp
  8051ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8051af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8051b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8051b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8051bb:	89 ca                	mov    %ecx,%edx
  8051bd:	89 f8                	mov    %edi,%eax
  8051bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8051c3:	85 f6                	test   %esi,%esi
  8051c5:	75 2d                	jne    8051f4 <__udivdi3+0x50>
  8051c7:	39 cf                	cmp    %ecx,%edi
  8051c9:	77 65                	ja     805230 <__udivdi3+0x8c>
  8051cb:	89 fd                	mov    %edi,%ebp
  8051cd:	85 ff                	test   %edi,%edi
  8051cf:	75 0b                	jne    8051dc <__udivdi3+0x38>
  8051d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8051d6:	31 d2                	xor    %edx,%edx
  8051d8:	f7 f7                	div    %edi
  8051da:	89 c5                	mov    %eax,%ebp
  8051dc:	31 d2                	xor    %edx,%edx
  8051de:	89 c8                	mov    %ecx,%eax
  8051e0:	f7 f5                	div    %ebp
  8051e2:	89 c1                	mov    %eax,%ecx
  8051e4:	89 d8                	mov    %ebx,%eax
  8051e6:	f7 f5                	div    %ebp
  8051e8:	89 cf                	mov    %ecx,%edi
  8051ea:	89 fa                	mov    %edi,%edx
  8051ec:	83 c4 1c             	add    $0x1c,%esp
  8051ef:	5b                   	pop    %ebx
  8051f0:	5e                   	pop    %esi
  8051f1:	5f                   	pop    %edi
  8051f2:	5d                   	pop    %ebp
  8051f3:	c3                   	ret    
  8051f4:	39 ce                	cmp    %ecx,%esi
  8051f6:	77 28                	ja     805220 <__udivdi3+0x7c>
  8051f8:	0f bd fe             	bsr    %esi,%edi
  8051fb:	83 f7 1f             	xor    $0x1f,%edi
  8051fe:	75 40                	jne    805240 <__udivdi3+0x9c>
  805200:	39 ce                	cmp    %ecx,%esi
  805202:	72 0a                	jb     80520e <__udivdi3+0x6a>
  805204:	3b 44 24 08          	cmp    0x8(%esp),%eax
  805208:	0f 87 9e 00 00 00    	ja     8052ac <__udivdi3+0x108>
  80520e:	b8 01 00 00 00       	mov    $0x1,%eax
  805213:	89 fa                	mov    %edi,%edx
  805215:	83 c4 1c             	add    $0x1c,%esp
  805218:	5b                   	pop    %ebx
  805219:	5e                   	pop    %esi
  80521a:	5f                   	pop    %edi
  80521b:	5d                   	pop    %ebp
  80521c:	c3                   	ret    
  80521d:	8d 76 00             	lea    0x0(%esi),%esi
  805220:	31 ff                	xor    %edi,%edi
  805222:	31 c0                	xor    %eax,%eax
  805224:	89 fa                	mov    %edi,%edx
  805226:	83 c4 1c             	add    $0x1c,%esp
  805229:	5b                   	pop    %ebx
  80522a:	5e                   	pop    %esi
  80522b:	5f                   	pop    %edi
  80522c:	5d                   	pop    %ebp
  80522d:	c3                   	ret    
  80522e:	66 90                	xchg   %ax,%ax
  805230:	89 d8                	mov    %ebx,%eax
  805232:	f7 f7                	div    %edi
  805234:	31 ff                	xor    %edi,%edi
  805236:	89 fa                	mov    %edi,%edx
  805238:	83 c4 1c             	add    $0x1c,%esp
  80523b:	5b                   	pop    %ebx
  80523c:	5e                   	pop    %esi
  80523d:	5f                   	pop    %edi
  80523e:	5d                   	pop    %ebp
  80523f:	c3                   	ret    
  805240:	bd 20 00 00 00       	mov    $0x20,%ebp
  805245:	89 eb                	mov    %ebp,%ebx
  805247:	29 fb                	sub    %edi,%ebx
  805249:	89 f9                	mov    %edi,%ecx
  80524b:	d3 e6                	shl    %cl,%esi
  80524d:	89 c5                	mov    %eax,%ebp
  80524f:	88 d9                	mov    %bl,%cl
  805251:	d3 ed                	shr    %cl,%ebp
  805253:	89 e9                	mov    %ebp,%ecx
  805255:	09 f1                	or     %esi,%ecx
  805257:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80525b:	89 f9                	mov    %edi,%ecx
  80525d:	d3 e0                	shl    %cl,%eax
  80525f:	89 c5                	mov    %eax,%ebp
  805261:	89 d6                	mov    %edx,%esi
  805263:	88 d9                	mov    %bl,%cl
  805265:	d3 ee                	shr    %cl,%esi
  805267:	89 f9                	mov    %edi,%ecx
  805269:	d3 e2                	shl    %cl,%edx
  80526b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80526f:	88 d9                	mov    %bl,%cl
  805271:	d3 e8                	shr    %cl,%eax
  805273:	09 c2                	or     %eax,%edx
  805275:	89 d0                	mov    %edx,%eax
  805277:	89 f2                	mov    %esi,%edx
  805279:	f7 74 24 0c          	divl   0xc(%esp)
  80527d:	89 d6                	mov    %edx,%esi
  80527f:	89 c3                	mov    %eax,%ebx
  805281:	f7 e5                	mul    %ebp
  805283:	39 d6                	cmp    %edx,%esi
  805285:	72 19                	jb     8052a0 <__udivdi3+0xfc>
  805287:	74 0b                	je     805294 <__udivdi3+0xf0>
  805289:	89 d8                	mov    %ebx,%eax
  80528b:	31 ff                	xor    %edi,%edi
  80528d:	e9 58 ff ff ff       	jmp    8051ea <__udivdi3+0x46>
  805292:	66 90                	xchg   %ax,%ax
  805294:	8b 54 24 08          	mov    0x8(%esp),%edx
  805298:	89 f9                	mov    %edi,%ecx
  80529a:	d3 e2                	shl    %cl,%edx
  80529c:	39 c2                	cmp    %eax,%edx
  80529e:	73 e9                	jae    805289 <__udivdi3+0xe5>
  8052a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8052a3:	31 ff                	xor    %edi,%edi
  8052a5:	e9 40 ff ff ff       	jmp    8051ea <__udivdi3+0x46>
  8052aa:	66 90                	xchg   %ax,%ax
  8052ac:	31 c0                	xor    %eax,%eax
  8052ae:	e9 37 ff ff ff       	jmp    8051ea <__udivdi3+0x46>
  8052b3:	90                   	nop

008052b4 <__umoddi3>:
  8052b4:	55                   	push   %ebp
  8052b5:	57                   	push   %edi
  8052b6:	56                   	push   %esi
  8052b7:	53                   	push   %ebx
  8052b8:	83 ec 1c             	sub    $0x1c,%esp
  8052bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8052bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8052c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8052c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8052cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8052cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8052d3:	89 f3                	mov    %esi,%ebx
  8052d5:	89 fa                	mov    %edi,%edx
  8052d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8052db:	89 34 24             	mov    %esi,(%esp)
  8052de:	85 c0                	test   %eax,%eax
  8052e0:	75 1a                	jne    8052fc <__umoddi3+0x48>
  8052e2:	39 f7                	cmp    %esi,%edi
  8052e4:	0f 86 a2 00 00 00    	jbe    80538c <__umoddi3+0xd8>
  8052ea:	89 c8                	mov    %ecx,%eax
  8052ec:	89 f2                	mov    %esi,%edx
  8052ee:	f7 f7                	div    %edi
  8052f0:	89 d0                	mov    %edx,%eax
  8052f2:	31 d2                	xor    %edx,%edx
  8052f4:	83 c4 1c             	add    $0x1c,%esp
  8052f7:	5b                   	pop    %ebx
  8052f8:	5e                   	pop    %esi
  8052f9:	5f                   	pop    %edi
  8052fa:	5d                   	pop    %ebp
  8052fb:	c3                   	ret    
  8052fc:	39 f0                	cmp    %esi,%eax
  8052fe:	0f 87 ac 00 00 00    	ja     8053b0 <__umoddi3+0xfc>
  805304:	0f bd e8             	bsr    %eax,%ebp
  805307:	83 f5 1f             	xor    $0x1f,%ebp
  80530a:	0f 84 ac 00 00 00    	je     8053bc <__umoddi3+0x108>
  805310:	bf 20 00 00 00       	mov    $0x20,%edi
  805315:	29 ef                	sub    %ebp,%edi
  805317:	89 fe                	mov    %edi,%esi
  805319:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80531d:	89 e9                	mov    %ebp,%ecx
  80531f:	d3 e0                	shl    %cl,%eax
  805321:	89 d7                	mov    %edx,%edi
  805323:	89 f1                	mov    %esi,%ecx
  805325:	d3 ef                	shr    %cl,%edi
  805327:	09 c7                	or     %eax,%edi
  805329:	89 e9                	mov    %ebp,%ecx
  80532b:	d3 e2                	shl    %cl,%edx
  80532d:	89 14 24             	mov    %edx,(%esp)
  805330:	89 d8                	mov    %ebx,%eax
  805332:	d3 e0                	shl    %cl,%eax
  805334:	89 c2                	mov    %eax,%edx
  805336:	8b 44 24 08          	mov    0x8(%esp),%eax
  80533a:	d3 e0                	shl    %cl,%eax
  80533c:	89 44 24 04          	mov    %eax,0x4(%esp)
  805340:	8b 44 24 08          	mov    0x8(%esp),%eax
  805344:	89 f1                	mov    %esi,%ecx
  805346:	d3 e8                	shr    %cl,%eax
  805348:	09 d0                	or     %edx,%eax
  80534a:	d3 eb                	shr    %cl,%ebx
  80534c:	89 da                	mov    %ebx,%edx
  80534e:	f7 f7                	div    %edi
  805350:	89 d3                	mov    %edx,%ebx
  805352:	f7 24 24             	mull   (%esp)
  805355:	89 c6                	mov    %eax,%esi
  805357:	89 d1                	mov    %edx,%ecx
  805359:	39 d3                	cmp    %edx,%ebx
  80535b:	0f 82 87 00 00 00    	jb     8053e8 <__umoddi3+0x134>
  805361:	0f 84 91 00 00 00    	je     8053f8 <__umoddi3+0x144>
  805367:	8b 54 24 04          	mov    0x4(%esp),%edx
  80536b:	29 f2                	sub    %esi,%edx
  80536d:	19 cb                	sbb    %ecx,%ebx
  80536f:	89 d8                	mov    %ebx,%eax
  805371:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  805375:	d3 e0                	shl    %cl,%eax
  805377:	89 e9                	mov    %ebp,%ecx
  805379:	d3 ea                	shr    %cl,%edx
  80537b:	09 d0                	or     %edx,%eax
  80537d:	89 e9                	mov    %ebp,%ecx
  80537f:	d3 eb                	shr    %cl,%ebx
  805381:	89 da                	mov    %ebx,%edx
  805383:	83 c4 1c             	add    $0x1c,%esp
  805386:	5b                   	pop    %ebx
  805387:	5e                   	pop    %esi
  805388:	5f                   	pop    %edi
  805389:	5d                   	pop    %ebp
  80538a:	c3                   	ret    
  80538b:	90                   	nop
  80538c:	89 fd                	mov    %edi,%ebp
  80538e:	85 ff                	test   %edi,%edi
  805390:	75 0b                	jne    80539d <__umoddi3+0xe9>
  805392:	b8 01 00 00 00       	mov    $0x1,%eax
  805397:	31 d2                	xor    %edx,%edx
  805399:	f7 f7                	div    %edi
  80539b:	89 c5                	mov    %eax,%ebp
  80539d:	89 f0                	mov    %esi,%eax
  80539f:	31 d2                	xor    %edx,%edx
  8053a1:	f7 f5                	div    %ebp
  8053a3:	89 c8                	mov    %ecx,%eax
  8053a5:	f7 f5                	div    %ebp
  8053a7:	89 d0                	mov    %edx,%eax
  8053a9:	e9 44 ff ff ff       	jmp    8052f2 <__umoddi3+0x3e>
  8053ae:	66 90                	xchg   %ax,%ax
  8053b0:	89 c8                	mov    %ecx,%eax
  8053b2:	89 f2                	mov    %esi,%edx
  8053b4:	83 c4 1c             	add    $0x1c,%esp
  8053b7:	5b                   	pop    %ebx
  8053b8:	5e                   	pop    %esi
  8053b9:	5f                   	pop    %edi
  8053ba:	5d                   	pop    %ebp
  8053bb:	c3                   	ret    
  8053bc:	3b 04 24             	cmp    (%esp),%eax
  8053bf:	72 06                	jb     8053c7 <__umoddi3+0x113>
  8053c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8053c5:	77 0f                	ja     8053d6 <__umoddi3+0x122>
  8053c7:	89 f2                	mov    %esi,%edx
  8053c9:	29 f9                	sub    %edi,%ecx
  8053cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8053cf:	89 14 24             	mov    %edx,(%esp)
  8053d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8053d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8053da:	8b 14 24             	mov    (%esp),%edx
  8053dd:	83 c4 1c             	add    $0x1c,%esp
  8053e0:	5b                   	pop    %ebx
  8053e1:	5e                   	pop    %esi
  8053e2:	5f                   	pop    %edi
  8053e3:	5d                   	pop    %ebp
  8053e4:	c3                   	ret    
  8053e5:	8d 76 00             	lea    0x0(%esi),%esi
  8053e8:	2b 04 24             	sub    (%esp),%eax
  8053eb:	19 fa                	sbb    %edi,%edx
  8053ed:	89 d1                	mov    %edx,%ecx
  8053ef:	89 c6                	mov    %eax,%esi
  8053f1:	e9 71 ff ff ff       	jmp    805367 <__umoddi3+0xb3>
  8053f6:	66 90                	xchg   %ax,%ax
  8053f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8053fc:	72 ea                	jb     8053e8 <__umoddi3+0x134>
  8053fe:	89 d9                	mov    %ebx,%ecx
  805400:	e9 62 ff ff ff       	jmp    805367 <__umoddi3+0xb3>
