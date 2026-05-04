
obj/user/tst_custom_fit_3:     file format elf32-i386


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
  800031:	e8 93 18 00 00       	call   8018c9 <libmain>
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
  800067:	e8 4f 46 00 00       	call   8046bb <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 92 46 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 a2 2c 00 00       	call   802d69 <malloc>
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
  8000df:	e8 d7 45 00 00       	call   8046bb <sys_calculate_free_frames>
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
  800125:	68 20 59 80 00       	push   $0x805920
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 4c 1c 00 00       	call   801d7d <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 cd 45 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 9c 59 80 00       	push   $0x80599c
  800150:	6a 0c                	push   $0xc
  800152:	e8 26 1c 00 00       	call   801d7d <cprintf_colored>
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
  800174:	e8 42 45 00 00       	call   8046bb <sys_calculate_free_frames>
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
  8001b9:	e8 fd 44 00 00       	call   8046bb <sys_calculate_free_frames>
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
  8001f8:	68 14 5a 80 00       	push   $0x805a14
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 79 1b 00 00       	call   801d7d <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 fa 44 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 a0 5a 80 00       	push   $0x805aa0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 4c 1b 00 00       	call   801d7d <cprintf_colored>
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
  800270:	e8 08 48 00 00       	call   804a7d <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 18 5b 80 00       	push   $0x805b18
  80028f:	6a 0c                	push   $0xc
  800291:	e8 e7 1a 00 00       	call   801d7d <cprintf_colored>
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
  8002ae:	e8 08 44 00 00       	call   8046bb <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 4b 44 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 96 2f 00 00       	call   803267 <free>
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
  8002fc:	e8 05 44 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 50 5b 80 00       	push   $0x805b50
  800318:	6a 0c                	push   $0xc
  80031a:	e8 5e 1a 00 00       	call   801d7d <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 94 43 00 00       	call   8046bb <sys_calculate_free_frames>
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
  800342:	68 9c 5b 80 00       	push   $0x805b9c
  800347:	6a 0c                	push   $0xc
  800349:	e8 2f 1a 00 00       	call   801d7d <cprintf_colored>
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
  8003a0:	e8 d8 46 00 00       	call   804a7d <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 f8 5b 80 00       	push   $0x805bf8
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 b7 19 00 00       	call   801d7d <cprintf_colored>
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
  800416:	68 30 5c 80 00       	push   $0x805c30
  80041b:	6a 03                	push   $0x3
  80041d:	e8 5b 19 00 00       	call   801d7d <cprintf_colored>
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
  8004df:	68 60 5c 80 00       	push   $0x805c60
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 92 18 00 00       	call   801d7d <cprintf_colored>
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
  8005b9:	68 60 5c 80 00       	push   $0x805c60
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 b8 17 00 00       	call   801d7d <cprintf_colored>
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
  800693:	68 60 5c 80 00       	push   $0x805c60
  800698:	6a 0c                	push   $0xc
  80069a:	e8 de 16 00 00       	call   801d7d <cprintf_colored>
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
  80076d:	68 60 5c 80 00       	push   $0x805c60
  800772:	6a 0c                	push   $0xc
  800774:	e8 04 16 00 00       	call   801d7d <cprintf_colored>
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
  800847:	68 60 5c 80 00       	push   $0x805c60
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 2a 15 00 00       	call   801d7d <cprintf_colored>
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
  800921:	68 60 5c 80 00       	push   $0x805c60
  800926:	6a 0c                	push   $0xc
  800928:	e8 50 14 00 00       	call   801d7d <cprintf_colored>
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
  800a16:	68 60 5c 80 00       	push   $0x805c60
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 5b 13 00 00       	call   801d7d <cprintf_colored>
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
  800b14:	68 60 5c 80 00       	push   $0x805c60
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 5d 12 00 00       	call   801d7d <cprintf_colored>
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
  800c12:	68 60 5c 80 00       	push   $0x805c60
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 5f 11 00 00       	call   801d7d <cprintf_colored>
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
  800d10:	68 60 5c 80 00       	push   $0x805c60
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 61 10 00 00       	call   801d7d <cprintf_colored>
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
  800dfd:	68 60 5c 80 00       	push   $0x805c60
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 74 0f 00 00       	call   801d7d <cprintf_colored>
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
  800eea:	68 60 5c 80 00       	push   $0x805c60
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 87 0e 00 00       	call   801d7d <cprintf_colored>
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
  800fd7:	68 60 5c 80 00       	push   $0x805c60
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 9a 0d 00 00       	call   801d7d <cprintf_colored>
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
  800ffa:	68 b2 5c 80 00       	push   $0x805cb2
  800fff:	6a 03                	push   $0x3
  801001:	e8 77 0d 00 00       	call   801d7d <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 9c 36 00 00       	call   8046bb <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 dc 36 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 0f 1d 00 00       	call   802d69 <malloc>
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
  801084:	68 d0 5c 80 00       	push   $0x805cd0
  801089:	6a 0c                	push   $0xc
  80108b:	e8 ed 0c 00 00       	call   801d7d <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 6e 36 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 0c 5d 80 00       	push   $0x805d0c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 c1 0c 00 00       	call   801d7d <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 f7 35 00 00       	call   8046bb <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 7c 5d 80 00       	push   $0x805d7c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 95 0c 00 00       	call   801d7d <cprintf_colored>
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
/* *********************************************************** */
#include <inc/lib.h>
#include <user/tst_malloc_helpers.h>

void _main(void)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	57                   	push   %edi
  801103:	53                   	push   %ebx
  801104:	83 c4 80             	add    $0xffffff80,%esp
	sys_set_uheap_strategy(UHP_PLACE_CUSTOMFIT);
  801107:	83 ec 0c             	sub    $0xc,%esp
  80110a:	6a 05                	push   $0x5
  80110c:	e8 07 39 00 00       	call   804a18 <sys_set_uheap_strategy>
  801111:	83 c4 10             	add    $0x10,%esp

	//cprintf_colored(TEXT_TESTERR_CLR, "%~1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801114:	a1 00 72 80 00       	mov    0x807200,%eax
  801119:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80111f:	a1 00 72 80 00       	mov    0x807200,%eax
  801124:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80112a:	39 c2                	cmp    %eax,%edx
  80112c:	72 14                	jb     801142 <_main+0x43>
			panic("Please increase the WS size");
  80112e:	83 ec 04             	sub    $0x4,%esp
  801131:	68 c4 5d 80 00       	push   $0x805dc4
  801136:	6a 17                	push   $0x17
  801138:	68 e0 5d 80 00       	push   $0x805de0
  80113d:	e8 40 09 00 00       	call   801a82 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  801142:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  801149:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	int envID = sys_getenvid();
  801150:	e8 16 37 00 00       	call   80486b <sys_getenvid>
  801155:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801158:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)

	void* ptr_allocations[20] = {0};
  80115f:	8d 55 84             	lea    -0x7c(%ebp),%edx
  801162:	b9 14 00 00 00       	mov    $0x14,%ecx
  801167:	b8 00 00 00 00       	mov    $0x0,%eax
  80116c:	89 d7                	mov    %edx,%edi
  80116e:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames, expected, expectedUpper, diff;
	int usedDiskPages;
	//[1] Allocate all
	cprintf_colored(TEXT_cyan, "\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR [20%]\n");
  801170:	83 ec 08             	sub    $0x8,%esp
  801173:	68 f8 5d 80 00       	push   $0x805df8
  801178:	6a 03                	push   $0x3
  80117a:	e8 fe 0b 00 00       	call   801d7d <cprintf_colored>
  80117f:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  801182:	e8 34 35 00 00       	call   8046bb <sys_calculate_free_frames>
  801187:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80118a:	e8 77 35 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
  80118f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  801192:	83 ec 04             	sub    $0x4,%esp
  801195:	6a 01                	push   $0x1
  801197:	68 00 00 10 00       	push   $0x100000
  80119c:	68 3b 5e 80 00       	push   $0x805e3b
  8011a1:	e8 51 28 00 00       	call   8039f7 <smalloc>
  8011a6:	83 c4 10             	add    $0x10,%esp
  8011a9:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if (ptr_allocations[0] != (uint32*)pagealloc_start)
  8011ac:	8b 55 84             	mov    -0x7c(%ebp),%edx
  8011af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011b2:	39 c2                	cmp    %eax,%edx
  8011b4:	74 19                	je     8011cf <_main+0xd0>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8011b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011bd:	83 ec 08             	sub    $0x8,%esp
  8011c0:	68 40 5e 80 00       	push   $0x805e40
  8011c5:	6a 0c                	push   $0xc
  8011c7:	e8 b1 0b 00 00       	call   801d7d <cprintf_colored>
  8011cc:	83 c4 10             	add    $0x10,%esp
		expected = 256+1; /*256pages +1table*/
  8011cf:	c7 45 dc 01 01 00 00 	movl   $0x101,-0x24(%ebp)
		expectedUpper = expected
  8011d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011d9:	83 c0 04             	add    $0x4,%eax
  8011dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
						+2 /*KH Block Alloc: 1 for Share object, 1 for framesStorage*/
						+2 /*UH Block Alloc: max of 1 page & 1 table*/;
		diff = (freeFrames - sys_calculate_free_frames());
  8011df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8011e2:	e8 d4 34 00 00       	call   8046bb <sys_calculate_free_frames>
  8011e7:	29 c3                	sub    %eax,%ebx
  8011e9:	89 d8                	mov    %ebx,%eax
  8011eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expectedUpper))
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8011f4:	ff 75 dc             	pushl  -0x24(%ebp)
  8011f7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8011fa:	e8 39 ee ff ff       	call   800038 <inRange>
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	85 c0                	test   %eax,%eax
  801204:	75 2c                	jne    801232 <_main+0x133>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expectedUpper);}
  801206:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80120d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  801210:	e8 a6 34 00 00       	call   8046bb <sys_calculate_free_frames>
  801215:	29 c3                	sub    %eax,%ebx
  801217:	89 d8                	mov    %ebx,%eax
  801219:	83 ec 0c             	sub    $0xc,%esp
  80121c:	ff 75 d8             	pushl  -0x28(%ebp)
  80121f:	ff 75 dc             	pushl  -0x24(%ebp)
  801222:	50                   	push   %eax
  801223:	68 b0 5e 80 00       	push   $0x805eb0
  801228:	6a 0c                	push   $0xc
  80122a:	e8 4e 0b 00 00       	call   801d7d <cprintf_colored>
  80122f:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  801232:	e8 cf 34 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
  801237:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80123a:	74 19                	je     801255 <_main+0x156>
  80123c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	68 50 5f 80 00       	push   $0x805f50
  80124b:	6a 0c                	push   $0xc
  80124d:	e8 2b 0b 00 00       	call   801d7d <cprintf_colored>
  801252:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		ptr_allocations[1] = malloc(1*Mega-kilo);
  801255:	83 ec 0c             	sub    $0xc,%esp
  801258:	68 00 fc 0f 00       	push   $0xffc00
  80125d:	e8 07 1b 00 00       	call   802d69 <malloc>
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[1] != (pagealloc_start + 1*Mega))
  801268:	8b 45 88             	mov    -0x78(%ebp),%eax
  80126b:	89 c2                	mov    %eax,%edx
  80126d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801270:	05 00 00 10 00       	add    $0x100000,%eax
  801275:	39 c2                	cmp    %eax,%edx
  801277:	74 19                	je     801292 <_main+0x193>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801279:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801280:	83 ec 08             	sub    $0x8,%esp
  801283:	68 70 5f 80 00       	push   $0x805f70
  801288:	6a 0c                	push   $0xc
  80128a:	e8 ee 0a 00 00       	call   801d7d <cprintf_colored>
  80128f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		ptr_allocations[2] = malloc(1*Mega-kilo);
  801292:	83 ec 0c             	sub    $0xc,%esp
  801295:	68 00 fc 0f 00       	push   $0xffc00
  80129a:	e8 ca 1a 00 00       	call   802d69 <malloc>
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[2] != (pagealloc_start + 2*Mega))
  8012a5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8012a8:	89 c2                	mov    %eax,%edx
  8012aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012ad:	05 00 00 20 00       	add    $0x200000,%eax
  8012b2:	39 c2                	cmp    %eax,%edx
  8012b4:	74 19                	je     8012cf <_main+0x1d0>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8012b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012bd:	83 ec 08             	sub    $0x8,%esp
  8012c0:	68 70 5f 80 00       	push   $0x805f70
  8012c5:	6a 0c                	push   $0xc
  8012c7:	e8 b1 0a 00 00       	call   801d7d <cprintf_colored>
  8012cc:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB (New Table)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	68 00 fc 0f 00       	push   $0xffc00
  8012d7:	e8 8d 1a 00 00       	call   802d69 <malloc>
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[3] != (pagealloc_start + 3*Mega) )
  8012e2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8012e5:	89 c2                	mov    %eax,%edx
  8012e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012ea:	05 00 00 30 00       	add    $0x300000,%eax
  8012ef:	39 c2                	cmp    %eax,%edx
  8012f1:	74 19                	je     80130c <_main+0x20d>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8012f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012fa:	83 ec 08             	sub    $0x8,%esp
  8012fd:	68 70 5f 80 00       	push   $0x805f70
  801302:	6a 0c                	push   $0xc
  801304:	e8 74 0a 00 00       	call   801d7d <cprintf_colored>
  801309:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[4] = malloc(2*Mega-kilo);
  80130c:	83 ec 0c             	sub    $0xc,%esp
  80130f:	68 00 fc 1f 00       	push   $0x1ffc00
  801314:	e8 50 1a 00 00       	call   802d69 <malloc>
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega))
  80131f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801322:	89 c2                	mov    %eax,%edx
  801324:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801327:	05 00 00 40 00       	add    $0x400000,%eax
  80132c:	39 c2                	cmp    %eax,%edx
  80132e:	74 19                	je     801349 <_main+0x24a>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801330:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801337:	83 ec 08             	sub    $0x8,%esp
  80133a:	68 70 5f 80 00       	push   $0x805f70
  80133f:	6a 0c                	push   $0xc
  801341:	e8 37 0a 00 00       	call   801d7d <cprintf_colored>
  801346:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 2 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  801349:	e8 6d 33 00 00       	call   8046bb <sys_calculate_free_frames>
  80134e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801351:	e8 b0 33 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
  801356:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  801359:	83 ec 04             	sub    $0x4,%esp
  80135c:	6a 01                	push   $0x1
  80135e:	68 00 00 20 00       	push   $0x200000
  801363:	68 a2 5f 80 00       	push   $0x805fa2
  801368:	e8 8a 26 00 00       	call   8039f7 <smalloc>
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	89 45 98             	mov    %eax,-0x68(%ebp)
		if (ptr_allocations[5] != (uint32*)(pagealloc_start + 6*Mega))
  801373:	8b 45 98             	mov    -0x68(%ebp),%eax
  801376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801379:	81 c2 00 00 60 00    	add    $0x600000,%edx
  80137f:	39 d0                	cmp    %edx,%eax
  801381:	74 19                	je     80139c <_main+0x29d>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  801383:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80138a:	83 ec 08             	sub    $0x8,%esp
  80138d:	68 40 5e 80 00       	push   $0x805e40
  801392:	6a 0c                	push   $0xc
  801394:	e8 e4 09 00 00       	call   801d7d <cprintf_colored>
  801399:	83 c4 10             	add    $0x10,%esp
		expected = 512+1; /*512pages +1table*/
  80139c:	c7 45 dc 01 02 00 00 	movl   $0x201,-0x24(%ebp)
		expectedUpper = expected +1 /*KH Block Alloc: 1 for framesStorage*/;
  8013a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013a6:	40                   	inc    %eax
  8013a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8013aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013ad:	e8 09 33 00 00       	call   8046bb <sys_calculate_free_frames>
  8013b2:	29 c3                	sub    %eax,%ebx
  8013b4:	89 d8                	mov    %ebx,%eax
  8013b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expectedUpper))
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8013bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8013c2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8013c5:	e8 6e ec ff ff       	call   800038 <inRange>
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	75 2c                	jne    8013fd <_main+0x2fe>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expectedUpper);}
  8013d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013d8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013db:	e8 db 32 00 00       	call   8046bb <sys_calculate_free_frames>
  8013e0:	29 c3                	sub    %eax,%ebx
  8013e2:	89 d8                	mov    %ebx,%eax
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8013ea:	ff 75 dc             	pushl  -0x24(%ebp)
  8013ed:	50                   	push   %eax
  8013ee:	68 b0 5e 80 00       	push   $0x805eb0
  8013f3:	6a 0c                	push   $0xc
  8013f5:	e8 83 09 00 00       	call   801d7d <cprintf_colored>
  8013fa:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  8013fd:	e8 04 33 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
  801402:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801405:	74 19                	je     801420 <_main+0x321>
  801407:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80140e:	83 ec 08             	sub    $0x8,%esp
  801411:	68 50 5f 80 00       	push   $0x805f50
  801416:	6a 0c                	push   $0xc
  801418:	e8 60 09 00 00       	call   801d7d <cprintf_colored>
  80141d:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		ptr_allocations[6] = malloc(3*Mega-kilo);
  801420:	83 ec 0c             	sub    $0xc,%esp
  801423:	68 00 fc 2f 00       	push   $0x2ffc00
  801428:	e8 3c 19 00 00       	call   802d69 <malloc>
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[6] != (pagealloc_start + 8*Mega))
  801433:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801436:	89 c2                	mov    %eax,%edx
  801438:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143b:	05 00 00 80 00       	add    $0x800000,%eax
  801440:	39 c2                	cmp    %eax,%edx
  801442:	74 19                	je     80145d <_main+0x35e>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801444:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80144b:	83 ec 08             	sub    $0x8,%esp
  80144e:	68 70 5f 80 00       	push   $0x805f70
  801453:	6a 0c                	push   $0xc
  801455:	e8 23 09 00 00       	call   801d7d <cprintf_colored>
  80145a:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 3 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  80145d:	e8 59 32 00 00       	call   8046bb <sys_calculate_free_frames>
  801462:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801465:	e8 9c 32 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
  80146a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  80146d:	83 ec 04             	sub    $0x4,%esp
  801470:	6a 00                	push   $0x0
  801472:	68 00 00 30 00       	push   $0x300000
  801477:	68 a4 5f 80 00       	push   $0x805fa4
  80147c:	e8 76 25 00 00       	call   8039f7 <smalloc>
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[7] != (uint32*)(pagealloc_start + 11*Mega))
  801487:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80148a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80148d:	81 c2 00 00 b0 00    	add    $0xb00000,%edx
  801493:	39 d0                	cmp    %edx,%eax
  801495:	74 19                	je     8014b0 <_main+0x3b1>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  801497:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	68 40 5e 80 00       	push   $0x805e40
  8014a6:	6a 0c                	push   $0xc
  8014a8:	e8 d0 08 00 00       	call   801d7d <cprintf_colored>
  8014ad:	83 c4 10             	add    $0x10,%esp
		expected = 768+1; /*768pages +1table */
  8014b0:	c7 45 dc 01 03 00 00 	movl   $0x301,-0x24(%ebp)
		expectedUpper = expected +1 /*+1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/;
  8014b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ba:	40                   	inc    %eax
  8014bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8014be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8014c1:	e8 f5 31 00 00       	call   8046bb <sys_calculate_free_frames>
  8014c6:	29 c3                	sub    %eax,%ebx
  8014c8:	89 d8                	mov    %ebx,%eax
  8014ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expectedUpper))
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8014d3:	ff 75 dc             	pushl  -0x24(%ebp)
  8014d6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8014d9:	e8 5a eb ff ff       	call   800038 <inRange>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	75 2c                	jne    801511 <_main+0x412>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expectedUpper);}
  8014e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014ec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8014ef:	e8 c7 31 00 00       	call   8046bb <sys_calculate_free_frames>
  8014f4:	29 c3                	sub    %eax,%ebx
  8014f6:	89 d8                	mov    %ebx,%eax
  8014f8:	83 ec 0c             	sub    $0xc,%esp
  8014fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8014fe:	ff 75 dc             	pushl  -0x24(%ebp)
  801501:	50                   	push   %eax
  801502:	68 b0 5e 80 00       	push   $0x805eb0
  801507:	6a 0c                	push   $0xc
  801509:	e8 6f 08 00 00       	call   801d7d <cprintf_colored>
  80150e:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  801511:	e8 f0 31 00 00       	call   804706 <sys_pf_calculate_allocated_pages>
  801516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801519:	74 19                	je     801534 <_main+0x435>
  80151b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801522:	83 ec 08             	sub    $0x8,%esp
  801525:	68 50 5f 80 00       	push   $0x805f50
  80152a:	6a 0c                	push   $0xc
  80152c:	e8 4c 08 00 00       	call   801d7d <cprintf_colored>
  801531:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=20;
  801534:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801538:	74 04                	je     80153e <_main+0x43f>
  80153a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	is_correct = 1;
  80153e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//[2] Free some to create holes
	cprintf_colored(TEXT_cyan, "\n%~[2] Free some to create holes\n");
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	68 a8 5f 80 00       	push   $0x805fa8
  80154d:	6a 03                	push   $0x3
  80154f:	e8 29 08 00 00       	call   801d7d <cprintf_colored>
  801554:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		free(ptr_allocations[1]);
  801557:	8b 45 88             	mov    -0x78(%ebp),%eax
  80155a:	83 ec 0c             	sub    $0xc,%esp
  80155d:	50                   	push   %eax
  80155e:	e8 04 1d 00 00       	call   803267 <free>
  801563:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		free(ptr_allocations[4]);
  801566:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801569:	83 ec 0c             	sub    $0xc,%esp
  80156c:	50                   	push   %eax
  80156d:	e8 f5 1c 00 00       	call   803267 <free>
  801572:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		free(ptr_allocations[6]);
  801575:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801578:	83 ec 0c             	sub    $0xc,%esp
  80157b:	50                   	push   %eax
  80157c:	e8 e6 1c 00 00       	call   803267 <free>
  801581:	83 c4 10             	add    $0x10,%esp
	}

	//[3] Allocate again [test custom fit]
	cprintf_colored(TEXT_cyan, "\n%~[3] Allocate again [test custom fit] [40%]\n");
  801584:	83 ec 08             	sub    $0x8,%esp
  801587:	68 cc 5f 80 00       	push   $0x805fcc
  80158c:	6a 03                	push   $0x3
  80158e:	e8 ea 07 00 00       	call   801d7d <cprintf_colored>
  801593:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 512 KB - should be placed in 3rd hole [WORST FIT]
		is_correct = 1;
  801596:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[8] = smalloc("Cust1", 512*kilo - kilo, 1);
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	6a 01                	push   $0x1
  8015a2:	68 00 fc 07 00       	push   $0x7fc00
  8015a7:	68 fb 5f 80 00       	push   $0x805ffb
  8015ac:	e8 46 24 00 00       	call   8039f7 <smalloc>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if ((uint32) ptr_allocations[8] != (pagealloc_start + 8*Mega))
  8015b7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8015ba:	89 c2                	mov    %eax,%edx
  8015bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015bf:	05 00 00 80 00       	add    $0x800000,%eax
  8015c4:	39 c2                	cmp    %eax,%edx
  8015c6:	74 19                	je     8015e1 <_main+0x4e2>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8015c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8015cf:	83 ec 08             	sub    $0x8,%esp
  8015d2:	68 70 5f 80 00       	push   $0x805f70
  8015d7:	6a 0c                	push   $0xc
  8015d9:	e8 9f 07 00 00       	call   801d7d <cprintf_colored>
  8015de:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  8015e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015e5:	74 04                	je     8015eb <_main+0x4ec>
  8015e7:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  8015eb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Get Shared 2 MB - should be placed in 2nd hole [EXACT FIT]
		is_correct = 1;
  8015f2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[9] = sget(envID, "y");
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	68 a2 5f 80 00       	push   $0x805fa2
  801601:	ff 75 ec             	pushl  -0x14(%ebp)
  801604:	e8 95 29 00 00       	call   803f9e <sget>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	89 45 a8             	mov    %eax,-0x58(%ebp)
			if ((uint32) ptr_allocations[9] != (pagealloc_start + 4*Mega))
  80160f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801612:	89 c2                	mov    %eax,%edx
  801614:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801617:	05 00 00 40 00       	add    $0x400000,%eax
  80161c:	39 c2                	cmp    %eax,%edx
  80161e:	74 19                	je     801639 <_main+0x53a>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801620:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	68 70 5f 80 00       	push   $0x805f70
  80162f:	6a 0c                	push   $0xc
  801631:	e8 47 07 00 00       	call   801d7d <cprintf_colored>
  801636:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  801639:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80163d:	74 04                	je     801643 <_main+0x544>
  80163f:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  801643:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate Shared 2 MB + 512 KB - should be placed in remaining of 3rd hole [EXACT FIT]
		is_correct = 1;
  80164a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[10] = smalloc("Cust2", 2*Mega + 512*kilo, 1);
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	6a 01                	push   $0x1
  801656:	68 00 00 28 00       	push   $0x280000
  80165b:	68 01 60 80 00       	push   $0x806001
  801660:	e8 92 23 00 00       	call   8039f7 <smalloc>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if ((uint32) ptr_allocations[10] != (pagealloc_start + 8*Mega + 512*kilo))
  80166b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80166e:	89 c2                	mov    %eax,%edx
  801670:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801673:	05 00 00 88 00       	add    $0x880000,%eax
  801678:	39 c2                	cmp    %eax,%edx
  80167a:	74 19                	je     801695 <_main+0x596>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  80167c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801683:	83 ec 08             	sub    $0x8,%esp
  801686:	68 70 5f 80 00       	push   $0x805f70
  80168b:	6a 0c                	push   $0xc
  80168d:	e8 eb 06 00 00       	call   801d7d <cprintf_colored>
  801692:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=5;
  801695:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801699:	74 04                	je     80169f <_main+0x5a0>
  80169b:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		is_correct = 1;
  80169f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Get Shared 512 KB - should be placed in 1st hole [WORST FIT]
		is_correct = 1;
  8016a6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[11] = sget(envID, "Cust1");
  8016ad:	83 ec 08             	sub    $0x8,%esp
  8016b0:	68 fb 5f 80 00       	push   $0x805ffb
  8016b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b8:	e8 e1 28 00 00       	call   803f9e <sget>
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	89 45 b0             	mov    %eax,-0x50(%ebp)
			if ((uint32) ptr_allocations[11] != (pagealloc_start + 1*Mega))
  8016c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8016c6:	89 c2                	mov    %eax,%edx
  8016c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016cb:	05 00 00 10 00       	add    $0x100000,%eax
  8016d0:	39 c2                	cmp    %eax,%edx
  8016d2:	74 19                	je     8016ed <_main+0x5ee>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8016d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016db:	83 ec 08             	sub    $0x8,%esp
  8016de:	68 70 5f 80 00       	push   $0x805f70
  8016e3:	6a 0c                	push   $0xc
  8016e5:	e8 93 06 00 00       	call   801d7d <cprintf_colored>
  8016ea:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=5;
  8016ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f1:	74 04                	je     8016f7 <_main+0x5f8>
  8016f3:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		is_correct = 1;
  8016f7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate Shared 4 MB - should be placed in end of all allocations [EXTEND]
		is_correct = 1;
  8016fe:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[12] = smalloc("Cust3", 4*Mega, 0);
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	6a 00                	push   $0x0
  80170a:	68 00 00 40 00       	push   $0x400000
  80170f:	68 07 60 80 00       	push   $0x806007
  801714:	e8 de 22 00 00       	call   8039f7 <smalloc>
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if ((uint32) ptr_allocations[12] != (pagealloc_start + 14*Mega))
  80171f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801722:	89 c2                	mov    %eax,%edx
  801724:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801727:	05 00 00 e0 00       	add    $0xe00000,%eax
  80172c:	39 c2                	cmp    %eax,%edx
  80172e:	74 19                	je     801749 <_main+0x64a>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	68 70 5f 80 00       	push   $0x805f70
  80173f:	6a 0c                	push   $0xc
  801741:	e8 37 06 00 00       	call   801d7d <cprintf_colored>
  801746:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  801749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80174d:	74 04                	je     801753 <_main+0x654>
  80174f:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  801753:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	//[4] Free contiguous allocations
	cprintf_colored(TEXT_cyan, "%~\n%~[4] Free contiguous allocations\n");
  80175a:	83 ec 08             	sub    $0x8,%esp
  80175d:	68 10 60 80 00       	push   $0x806010
  801762:	6a 03                	push   $0x3
  801764:	e8 14 06 00 00       	call   801d7d <cprintf_colored>
  801769:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		free(ptr_allocations[3]);
  80176c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80176f:	83 ec 0c             	sub    $0xc,%esp
  801772:	50                   	push   %eax
  801773:	e8 ef 1a 00 00       	call   803267 <free>
  801778:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 512 KB hole and next 1 MB Hole => 2MB + 512KB Hole
		free(ptr_allocations[2]);
  80177b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80177e:	83 ec 0c             	sub    $0xc,%esp
  801781:	50                   	push   %eax
  801782:	e8 e0 1a 00 00       	call   803267 <free>
  801787:	83 c4 10             	add    $0x10,%esp
	}

	//[5] Allocate again [test custom fit]
	cprintf_colored(TEXT_cyan, "%~\n%~[5] Allocate again [test custom fit] [40%]\n");
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	68 38 60 80 00       	push   $0x806038
  801792:	6a 03                	push   $0x3
  801794:	e8 e4 05 00 00       	call   801d7d <cprintf_colored>
  801799:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 2 MB + 1 KB - should be placed in the contiguous hole (512 KB + 2 MB)
		is_correct = 1;
  80179c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[13] = smalloc("Cust4", 2*Mega + 1*kilo, 0);
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	6a 00                	push   $0x0
  8017a8:	68 00 04 20 00       	push   $0x200400
  8017ad:	68 69 60 80 00       	push   $0x806069
  8017b2:	e8 40 22 00 00       	call   8039f7 <smalloc>
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if ((uint32) ptr_allocations[13] != (pagealloc_start + 1*Mega + 512*kilo))
  8017bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8017c0:	89 c2                	mov    %eax,%edx
  8017c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017c5:	05 00 00 18 00       	add    $0x180000,%eax
  8017ca:	39 c2                	cmp    %eax,%edx
  8017cc:	74 19                	je     8017e7 <_main+0x6e8>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8017ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8017d5:	83 ec 08             	sub    $0x8,%esp
  8017d8:	68 70 5f 80 00       	push   $0x805f70
  8017dd:	6a 0c                	push   $0xc
  8017df:	e8 99 05 00 00       	call   801d7d <cprintf_colored>
  8017e4:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=15;
  8017e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017eb:	74 04                	je     8017f1 <_main+0x6f2>
  8017ed:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
		is_correct = 1;
  8017f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Get Shared of 1 MB [should be placed at the end of all allocations]
		is_correct = 1;
  8017f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[14] = sget(envID, "x");
  8017ff:	83 ec 08             	sub    $0x8,%esp
  801802:	68 3b 5e 80 00       	push   $0x805e3b
  801807:	ff 75 ec             	pushl  -0x14(%ebp)
  80180a:	e8 8f 27 00 00       	call   803f9e <sget>
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if ((uint32) ptr_allocations[14] != (pagealloc_start + 18*Mega))
  801815:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801818:	89 c2                	mov    %eax,%edx
  80181a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80181d:	05 00 00 20 01       	add    $0x1200000,%eax
  801822:	39 c2                	cmp    %eax,%edx
  801824:	74 19                	je     80183f <_main+0x740>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801826:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	68 70 5f 80 00       	push   $0x805f70
  801835:	6a 0c                	push   $0xc
  801837:	e8 41 05 00 00       	call   801d7d <cprintf_colored>
  80183c:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  80183f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801843:	74 04                	je     801849 <_main+0x74a>
  801845:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  801849:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate shared of 508 KB [should be placed in the remaining part of the contiguous (512 KB + 2 MB) hole
		is_correct = 1;
  801850:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[15] = smalloc("Cust5", 508*kilo, 0);
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	6a 00                	push   $0x0
  80185c:	68 00 f0 07 00       	push   $0x7f000
  801861:	68 6f 60 80 00       	push   $0x80606f
  801866:	e8 8c 21 00 00       	call   8039f7 <smalloc>
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if ((uint32) ptr_allocations[15] != (pagealloc_start + 3*Mega + 512*kilo + 4*kilo))
  801871:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801874:	89 c2                	mov    %eax,%edx
  801876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801879:	05 00 10 38 00       	add    $0x381000,%eax
  80187e:	39 c2                	cmp    %eax,%edx
  801880:	74 19                	je     80189b <_main+0x79c>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801882:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801889:	83 ec 08             	sub    $0x8,%esp
  80188c:	68 70 5f 80 00       	push   $0x805f70
  801891:	6a 0c                	push   $0xc
  801893:	e8 e5 04 00 00       	call   801d7d <cprintf_colored>
  801898:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=15;
  80189b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80189f:	74 04                	je     8018a5 <_main+0x7a6>
  8018a1:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
		is_correct = 1;
  8018a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	cprintf_colored(TEXT_light_green, "%~\ntest Sharing CUSTOM FIT allocation (3) completed. Eval = %d%%\n\n", eval);
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b2:	68 78 60 80 00       	push   $0x806078
  8018b7:	6a 0a                	push   $0xa
  8018b9:	e8 bf 04 00 00       	call   801d7d <cprintf_colored>
  8018be:	83 c4 10             	add    $0x10,%esp

	return;
  8018c1:	90                   	nop
}
  8018c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c5:	5b                   	pop    %ebx
  8018c6:	5f                   	pop    %edi
  8018c7:	5d                   	pop    %ebp
  8018c8:	c3                   	ret    

008018c9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	57                   	push   %edi
  8018cd:	56                   	push   %esi
  8018ce:	53                   	push   %ebx
  8018cf:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8018d2:	e8 ad 2f 00 00       	call   804884 <sys_getenvindex>
  8018d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8018da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018dd:	89 d0                	mov    %edx,%eax
  8018df:	c1 e0 02             	shl    $0x2,%eax
  8018e2:	01 d0                	add    %edx,%eax
  8018e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018eb:	01 d0                	add    %edx,%eax
  8018ed:	89 c2                	mov    %eax,%edx
  8018ef:	c1 e2 04             	shl    $0x4,%edx
  8018f2:	29 c2                	sub    %eax,%edx
  8018f4:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8018fb:	89 c2                	mov    %eax,%edx
  8018fd:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  801903:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801908:	a1 00 72 80 00       	mov    0x807200,%eax
  80190d:	8a 40 20             	mov    0x20(%eax),%al
  801910:	84 c0                	test   %al,%al
  801912:	74 0d                	je     801921 <libmain+0x58>
		binaryname = myEnv->prog_name;
  801914:	a1 00 72 80 00       	mov    0x807200,%eax
  801919:	83 c0 20             	add    $0x20,%eax
  80191c:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801921:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801925:	7e 0a                	jle    801931 <libmain+0x68>
		binaryname = argv[0];
  801927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192a:	8b 00                	mov    (%eax),%eax
  80192c:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  801931:	83 ec 08             	sub    $0x8,%esp
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	e8 c0 f7 ff ff       	call   8010ff <_main>
  80193f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801942:	a1 00 70 80 00       	mov    0x807000,%eax
  801947:	85 c0                	test   %eax,%eax
  801949:	0f 84 01 01 00 00    	je     801a50 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80194f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801955:	bb b4 61 80 00       	mov    $0x8061b4,%ebx
  80195a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80195f:	89 c7                	mov    %eax,%edi
  801961:	89 de                	mov    %ebx,%esi
  801963:	89 d1                	mov    %edx,%ecx
  801965:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801967:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80196a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80196f:	b0 00                	mov    $0x0,%al
  801971:	89 d7                	mov    %edx,%edi
  801973:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801975:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80197c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80197f:	83 ec 08             	sub    $0x8,%esp
  801982:	50                   	push   %eax
  801983:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801989:	50                   	push   %eax
  80198a:	e8 2b 31 00 00       	call   804aba <sys_utilities>
  80198f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801992:	e8 74 2c 00 00       	call   80460b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801997:	83 ec 0c             	sub    $0xc,%esp
  80199a:	68 d4 60 80 00       	push   $0x8060d4
  80199f:	e8 ac 03 00 00       	call   801d50 <cprintf>
  8019a4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8019a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	74 18                	je     8019c6 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8019ae:	e8 25 31 00 00       	call   804ad8 <sys_get_optimal_num_faults>
  8019b3:	83 ec 08             	sub    $0x8,%esp
  8019b6:	50                   	push   %eax
  8019b7:	68 fc 60 80 00       	push   $0x8060fc
  8019bc:	e8 8f 03 00 00       	call   801d50 <cprintf>
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	eb 59                	jmp    801a1f <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8019c6:	a1 00 72 80 00       	mov    0x807200,%eax
  8019cb:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8019d1:	a1 00 72 80 00       	mov    0x807200,%eax
  8019d6:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8019dc:	83 ec 04             	sub    $0x4,%esp
  8019df:	52                   	push   %edx
  8019e0:	50                   	push   %eax
  8019e1:	68 20 61 80 00       	push   $0x806120
  8019e6:	e8 65 03 00 00       	call   801d50 <cprintf>
  8019eb:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8019ee:	a1 00 72 80 00       	mov    0x807200,%eax
  8019f3:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8019f9:	a1 00 72 80 00       	mov    0x807200,%eax
  8019fe:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  801a04:	a1 00 72 80 00       	mov    0x807200,%eax
  801a09:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  801a0f:	51                   	push   %ecx
  801a10:	52                   	push   %edx
  801a11:	50                   	push   %eax
  801a12:	68 48 61 80 00       	push   $0x806148
  801a17:	e8 34 03 00 00       	call   801d50 <cprintf>
  801a1c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801a1f:	a1 00 72 80 00       	mov    0x807200,%eax
  801a24:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  801a2a:	83 ec 08             	sub    $0x8,%esp
  801a2d:	50                   	push   %eax
  801a2e:	68 a0 61 80 00       	push   $0x8061a0
  801a33:	e8 18 03 00 00       	call   801d50 <cprintf>
  801a38:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801a3b:	83 ec 0c             	sub    $0xc,%esp
  801a3e:	68 d4 60 80 00       	push   $0x8060d4
  801a43:	e8 08 03 00 00       	call   801d50 <cprintf>
  801a48:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801a4b:	e8 d5 2b 00 00       	call   804625 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801a50:	e8 1f 00 00 00       	call   801a74 <exit>
}
  801a55:	90                   	nop
  801a56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a59:	5b                   	pop    %ebx
  801a5a:	5e                   	pop    %esi
  801a5b:	5f                   	pop    %edi
  801a5c:	5d                   	pop    %ebp
  801a5d:	c3                   	ret    

00801a5e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801a64:	83 ec 0c             	sub    $0xc,%esp
  801a67:	6a 00                	push   $0x0
  801a69:	e8 e2 2d 00 00       	call   804850 <sys_destroy_env>
  801a6e:	83 c4 10             	add    $0x10,%esp
}
  801a71:	90                   	nop
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <exit>:

void
exit(void)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801a7a:	e8 37 2e 00 00       	call   8048b6 <sys_exit_env>
}
  801a7f:	90                   	nop
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a88:	8d 45 10             	lea    0x10(%ebp),%eax
  801a8b:	83 c0 04             	add    $0x4,%eax
  801a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a91:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  801a96:	85 c0                	test   %eax,%eax
  801a98:	74 16                	je     801ab0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a9a:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  801a9f:	83 ec 08             	sub    $0x8,%esp
  801aa2:	50                   	push   %eax
  801aa3:	68 18 62 80 00       	push   $0x806218
  801aa8:	e8 a3 02 00 00       	call   801d50 <cprintf>
  801aad:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801ab0:	a1 04 70 80 00       	mov    0x807004,%eax
  801ab5:	83 ec 0c             	sub    $0xc,%esp
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	50                   	push   %eax
  801abf:	68 20 62 80 00       	push   $0x806220
  801ac4:	6a 74                	push   $0x74
  801ac6:	e8 b2 02 00 00       	call   801d7d <cprintf_colored>
  801acb:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801ace:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad7:	50                   	push   %eax
  801ad8:	e8 04 02 00 00       	call   801ce1 <vcprintf>
  801add:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801ae0:	83 ec 08             	sub    $0x8,%esp
  801ae3:	6a 00                	push   $0x0
  801ae5:	68 48 62 80 00       	push   $0x806248
  801aea:	e8 f2 01 00 00       	call   801ce1 <vcprintf>
  801aef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801af2:	e8 7d ff ff ff       	call   801a74 <exit>

	// should not return here
	while (1) ;
  801af7:	eb fe                	jmp    801af7 <_panic+0x75>

00801af9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801aff:	a1 00 72 80 00       	mov    0x807200,%eax
  801b04:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0d:	39 c2                	cmp    %eax,%edx
  801b0f:	74 14                	je     801b25 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801b11:	83 ec 04             	sub    $0x4,%esp
  801b14:	68 4c 62 80 00       	push   $0x80624c
  801b19:	6a 26                	push   $0x26
  801b1b:	68 98 62 80 00       	push   $0x806298
  801b20:	e8 5d ff ff ff       	call   801a82 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801b25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801b2c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b33:	e9 c5 00 00 00       	jmp    801bfd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	01 d0                	add    %edx,%eax
  801b47:	8b 00                	mov    (%eax),%eax
  801b49:	85 c0                	test   %eax,%eax
  801b4b:	75 08                	jne    801b55 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b4d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b50:	e9 a5 00 00 00       	jmp    801bfa <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b55:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b5c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b63:	eb 69                	jmp    801bce <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b65:	a1 00 72 80 00       	mov    0x807200,%eax
  801b6a:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  801b70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b73:	89 d0                	mov    %edx,%eax
  801b75:	01 c0                	add    %eax,%eax
  801b77:	01 d0                	add    %edx,%eax
  801b79:	c1 e0 03             	shl    $0x3,%eax
  801b7c:	01 c8                	add    %ecx,%eax
  801b7e:	8a 40 04             	mov    0x4(%eax),%al
  801b81:	84 c0                	test   %al,%al
  801b83:	75 46                	jne    801bcb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b85:	a1 00 72 80 00       	mov    0x807200,%eax
  801b8a:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  801b90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b93:	89 d0                	mov    %edx,%eax
  801b95:	01 c0                	add    %eax,%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	c1 e0 03             	shl    $0x3,%eax
  801b9c:	01 c8                	add    %ecx,%eax
  801b9e:	8b 00                	mov    (%eax),%eax
  801ba0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ba3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ba6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bab:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	01 c8                	add    %ecx,%eax
  801bbc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801bbe:	39 c2                	cmp    %eax,%edx
  801bc0:	75 09                	jne    801bcb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801bc2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801bc9:	eb 15                	jmp    801be0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bcb:	ff 45 e8             	incl   -0x18(%ebp)
  801bce:	a1 00 72 80 00       	mov    0x807200,%eax
  801bd3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801bd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bdc:	39 c2                	cmp    %eax,%edx
  801bde:	77 85                	ja     801b65 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801be0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801be4:	75 14                	jne    801bfa <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801be6:	83 ec 04             	sub    $0x4,%esp
  801be9:	68 a4 62 80 00       	push   $0x8062a4
  801bee:	6a 3a                	push   $0x3a
  801bf0:	68 98 62 80 00       	push   $0x806298
  801bf5:	e8 88 fe ff ff       	call   801a82 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801bfa:	ff 45 f0             	incl   -0x10(%ebp)
  801bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c00:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c03:	0f 8c 2f ff ff ff    	jl     801b38 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801c09:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c10:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c17:	eb 26                	jmp    801c3f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801c19:	a1 00 72 80 00       	mov    0x807200,%eax
  801c1e:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  801c24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c27:	89 d0                	mov    %edx,%eax
  801c29:	01 c0                	add    %eax,%eax
  801c2b:	01 d0                	add    %edx,%eax
  801c2d:	c1 e0 03             	shl    $0x3,%eax
  801c30:	01 c8                	add    %ecx,%eax
  801c32:	8a 40 04             	mov    0x4(%eax),%al
  801c35:	3c 01                	cmp    $0x1,%al
  801c37:	75 03                	jne    801c3c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801c39:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c3c:	ff 45 e0             	incl   -0x20(%ebp)
  801c3f:	a1 00 72 80 00       	mov    0x807200,%eax
  801c44:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c4d:	39 c2                	cmp    %eax,%edx
  801c4f:	77 c8                	ja     801c19 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c54:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c57:	74 14                	je     801c6d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c59:	83 ec 04             	sub    $0x4,%esp
  801c5c:	68 f8 62 80 00       	push   $0x8062f8
  801c61:	6a 44                	push   $0x44
  801c63:	68 98 62 80 00       	push   $0x806298
  801c68:	e8 15 fe ff ff       	call   801a82 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c6d:	90                   	nop
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	53                   	push   %ebx
  801c74:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7a:	8b 00                	mov    (%eax),%eax
  801c7c:	8d 48 01             	lea    0x1(%eax),%ecx
  801c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c82:	89 0a                	mov    %ecx,(%edx)
  801c84:	8b 55 08             	mov    0x8(%ebp),%edx
  801c87:	88 d1                	mov    %dl,%cl
  801c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c93:	8b 00                	mov    (%eax),%eax
  801c95:	3d ff 00 00 00       	cmp    $0xff,%eax
  801c9a:	75 30                	jne    801ccc <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801c9c:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801ca2:	a0 24 72 80 00       	mov    0x807224,%al
  801ca7:	0f b6 c0             	movzbl %al,%eax
  801caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cad:	8b 09                	mov    (%ecx),%ecx
  801caf:	89 cb                	mov    %ecx,%ebx
  801cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb4:	83 c1 08             	add    $0x8,%ecx
  801cb7:	52                   	push   %edx
  801cb8:	50                   	push   %eax
  801cb9:	53                   	push   %ebx
  801cba:	51                   	push   %ecx
  801cbb:	e8 07 29 00 00       	call   8045c7 <sys_cputs>
  801cc0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccf:	8b 40 04             	mov    0x4(%eax),%eax
  801cd2:	8d 50 01             	lea    0x1(%eax),%edx
  801cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd8:	89 50 04             	mov    %edx,0x4(%eax)
}
  801cdb:	90                   	nop
  801cdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801cea:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801cf1:	00 00 00 
	b.cnt = 0;
  801cf4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801cfb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801cfe:	ff 75 0c             	pushl  0xc(%ebp)
  801d01:	ff 75 08             	pushl  0x8(%ebp)
  801d04:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d0a:	50                   	push   %eax
  801d0b:	68 70 1c 80 00       	push   $0x801c70
  801d10:	e8 5a 02 00 00       	call   801f6f <vprintfmt>
  801d15:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801d18:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801d1e:	a0 24 72 80 00       	mov    0x807224,%al
  801d23:	0f b6 c0             	movzbl %al,%eax
  801d26:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801d2c:	52                   	push   %edx
  801d2d:	50                   	push   %eax
  801d2e:	51                   	push   %ecx
  801d2f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d35:	83 c0 08             	add    $0x8,%eax
  801d38:	50                   	push   %eax
  801d39:	e8 89 28 00 00       	call   8045c7 <sys_cputs>
  801d3e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801d41:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  801d48:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801d56:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  801d5d:	8d 45 0c             	lea    0xc(%ebp),%eax
  801d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	83 ec 08             	sub    $0x8,%esp
  801d69:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6c:	50                   	push   %eax
  801d6d:	e8 6f ff ff ff       	call   801ce1 <vcprintf>
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801d83:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	c1 e0 08             	shl    $0x8,%eax
  801d90:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  801d95:	8d 45 0c             	lea    0xc(%ebp),%eax
  801d98:	83 c0 04             	add    $0x4,%eax
  801d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da1:	83 ec 08             	sub    $0x8,%esp
  801da4:	ff 75 f4             	pushl  -0xc(%ebp)
  801da7:	50                   	push   %eax
  801da8:	e8 34 ff ff ff       	call   801ce1 <vcprintf>
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801db3:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  801dba:	07 00 00 

	return cnt;
  801dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801dc8:	e8 3e 28 00 00       	call   80460b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801dcd:	8d 45 0c             	lea    0xc(%ebp),%eax
  801dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	83 ec 08             	sub    $0x8,%esp
  801dd9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ddc:	50                   	push   %eax
  801ddd:	e8 ff fe ff ff       	call   801ce1 <vcprintf>
  801de2:	83 c4 10             	add    $0x10,%esp
  801de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801de8:	e8 38 28 00 00       	call   804625 <sys_unlock_cons>
	return cnt;
  801ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	53                   	push   %ebx
  801df6:	83 ec 14             	sub    $0x14,%esp
  801df9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dff:	8b 45 14             	mov    0x14(%ebp),%eax
  801e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801e05:	8b 45 18             	mov    0x18(%ebp),%eax
  801e08:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801e10:	77 55                	ja     801e67 <printnum+0x75>
  801e12:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801e15:	72 05                	jb     801e1c <printnum+0x2a>
  801e17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e1a:	77 4b                	ja     801e67 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801e1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801e1f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801e22:	8b 45 18             	mov    0x18(%ebp),%eax
  801e25:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2a:	52                   	push   %edx
  801e2b:	50                   	push   %eax
  801e2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e32:	e8 81 38 00 00       	call   8056b8 <__udivdi3>
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	ff 75 20             	pushl  0x20(%ebp)
  801e40:	53                   	push   %ebx
  801e41:	ff 75 18             	pushl  0x18(%ebp)
  801e44:	52                   	push   %edx
  801e45:	50                   	push   %eax
  801e46:	ff 75 0c             	pushl  0xc(%ebp)
  801e49:	ff 75 08             	pushl  0x8(%ebp)
  801e4c:	e8 a1 ff ff ff       	call   801df2 <printnum>
  801e51:	83 c4 20             	add    $0x20,%esp
  801e54:	eb 1a                	jmp    801e70 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801e56:	83 ec 08             	sub    $0x8,%esp
  801e59:	ff 75 0c             	pushl  0xc(%ebp)
  801e5c:	ff 75 20             	pushl  0x20(%ebp)
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	ff d0                	call   *%eax
  801e64:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801e67:	ff 4d 1c             	decl   0x1c(%ebp)
  801e6a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801e6e:	7f e6                	jg     801e56 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801e70:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801e73:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7e:	53                   	push   %ebx
  801e7f:	51                   	push   %ecx
  801e80:	52                   	push   %edx
  801e81:	50                   	push   %eax
  801e82:	e8 41 39 00 00       	call   8057c8 <__umoddi3>
  801e87:	83 c4 10             	add    $0x10,%esp
  801e8a:	05 74 65 80 00       	add    $0x806574,%eax
  801e8f:	8a 00                	mov    (%eax),%al
  801e91:	0f be c0             	movsbl %al,%eax
  801e94:	83 ec 08             	sub    $0x8,%esp
  801e97:	ff 75 0c             	pushl  0xc(%ebp)
  801e9a:	50                   	push   %eax
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	ff d0                	call   *%eax
  801ea0:	83 c4 10             	add    $0x10,%esp
}
  801ea3:	90                   	nop
  801ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801eac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801eb0:	7e 1c                	jle    801ece <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	8b 00                	mov    (%eax),%eax
  801eb7:	8d 50 08             	lea    0x8(%eax),%edx
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	89 10                	mov    %edx,(%eax)
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	8b 00                	mov    (%eax),%eax
  801ec4:	83 e8 08             	sub    $0x8,%eax
  801ec7:	8b 50 04             	mov    0x4(%eax),%edx
  801eca:	8b 00                	mov    (%eax),%eax
  801ecc:	eb 40                	jmp    801f0e <getuint+0x65>
	else if (lflag)
  801ece:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ed2:	74 1e                	je     801ef2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	8b 00                	mov    (%eax),%eax
  801ed9:	8d 50 04             	lea    0x4(%eax),%edx
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	89 10                	mov    %edx,(%eax)
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	8b 00                	mov    (%eax),%eax
  801ee6:	83 e8 04             	sub    $0x4,%eax
  801ee9:	8b 00                	mov    (%eax),%eax
  801eeb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef0:	eb 1c                	jmp    801f0e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	8b 00                	mov    (%eax),%eax
  801ef7:	8d 50 04             	lea    0x4(%eax),%edx
  801efa:	8b 45 08             	mov    0x8(%ebp),%eax
  801efd:	89 10                	mov    %edx,(%eax)
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8b 00                	mov    (%eax),%eax
  801f04:	83 e8 04             	sub    $0x4,%eax
  801f07:	8b 00                	mov    (%eax),%eax
  801f09:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801f0e:	5d                   	pop    %ebp
  801f0f:	c3                   	ret    

00801f10 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801f13:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801f17:	7e 1c                	jle    801f35 <getint+0x25>
		return va_arg(*ap, long long);
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	8b 00                	mov    (%eax),%eax
  801f1e:	8d 50 08             	lea    0x8(%eax),%edx
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	89 10                	mov    %edx,(%eax)
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	8b 00                	mov    (%eax),%eax
  801f2b:	83 e8 08             	sub    $0x8,%eax
  801f2e:	8b 50 04             	mov    0x4(%eax),%edx
  801f31:	8b 00                	mov    (%eax),%eax
  801f33:	eb 38                	jmp    801f6d <getint+0x5d>
	else if (lflag)
  801f35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f39:	74 1a                	je     801f55 <getint+0x45>
		return va_arg(*ap, long);
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	8b 00                	mov    (%eax),%eax
  801f40:	8d 50 04             	lea    0x4(%eax),%edx
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	89 10                	mov    %edx,(%eax)
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	8b 00                	mov    (%eax),%eax
  801f4d:	83 e8 04             	sub    $0x4,%eax
  801f50:	8b 00                	mov    (%eax),%eax
  801f52:	99                   	cltd   
  801f53:	eb 18                	jmp    801f6d <getint+0x5d>
	else
		return va_arg(*ap, int);
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	8b 00                	mov    (%eax),%eax
  801f5a:	8d 50 04             	lea    0x4(%eax),%edx
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	89 10                	mov    %edx,(%eax)
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	8b 00                	mov    (%eax),%eax
  801f67:	83 e8 04             	sub    $0x4,%eax
  801f6a:	8b 00                	mov    (%eax),%eax
  801f6c:	99                   	cltd   
}
  801f6d:	5d                   	pop    %ebp
  801f6e:	c3                   	ret    

00801f6f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	56                   	push   %esi
  801f73:	53                   	push   %ebx
  801f74:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801f77:	eb 17                	jmp    801f90 <vprintfmt+0x21>
			if (ch == '\0')
  801f79:	85 db                	test   %ebx,%ebx
  801f7b:	0f 84 c1 03 00 00    	je     802342 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801f81:	83 ec 08             	sub    $0x8,%esp
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	53                   	push   %ebx
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	ff d0                	call   *%eax
  801f8d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801f90:	8b 45 10             	mov    0x10(%ebp),%eax
  801f93:	8d 50 01             	lea    0x1(%eax),%edx
  801f96:	89 55 10             	mov    %edx,0x10(%ebp)
  801f99:	8a 00                	mov    (%eax),%al
  801f9b:	0f b6 d8             	movzbl %al,%ebx
  801f9e:	83 fb 25             	cmp    $0x25,%ebx
  801fa1:	75 d6                	jne    801f79 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801fa3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801fa7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801fae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801fb5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801fbc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801fc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc6:	8d 50 01             	lea    0x1(%eax),%edx
  801fc9:	89 55 10             	mov    %edx,0x10(%ebp)
  801fcc:	8a 00                	mov    (%eax),%al
  801fce:	0f b6 d8             	movzbl %al,%ebx
  801fd1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801fd4:	83 f8 5b             	cmp    $0x5b,%eax
  801fd7:	0f 87 3d 03 00 00    	ja     80231a <vprintfmt+0x3ab>
  801fdd:	8b 04 85 98 65 80 00 	mov    0x806598(,%eax,4),%eax
  801fe4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801fe6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801fea:	eb d7                	jmp    801fc3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801fec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801ff0:	eb d1                	jmp    801fc3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801ff2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801ff9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ffc:	89 d0                	mov    %edx,%eax
  801ffe:	c1 e0 02             	shl    $0x2,%eax
  802001:	01 d0                	add    %edx,%eax
  802003:	01 c0                	add    %eax,%eax
  802005:	01 d8                	add    %ebx,%eax
  802007:	83 e8 30             	sub    $0x30,%eax
  80200a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80200d:	8b 45 10             	mov    0x10(%ebp),%eax
  802010:	8a 00                	mov    (%eax),%al
  802012:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802015:	83 fb 2f             	cmp    $0x2f,%ebx
  802018:	7e 3e                	jle    802058 <vprintfmt+0xe9>
  80201a:	83 fb 39             	cmp    $0x39,%ebx
  80201d:	7f 39                	jg     802058 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80201f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802022:	eb d5                	jmp    801ff9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  802024:	8b 45 14             	mov    0x14(%ebp),%eax
  802027:	83 c0 04             	add    $0x4,%eax
  80202a:	89 45 14             	mov    %eax,0x14(%ebp)
  80202d:	8b 45 14             	mov    0x14(%ebp),%eax
  802030:	83 e8 04             	sub    $0x4,%eax
  802033:	8b 00                	mov    (%eax),%eax
  802035:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  802038:	eb 1f                	jmp    802059 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80203a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80203e:	79 83                	jns    801fc3 <vprintfmt+0x54>
				width = 0;
  802040:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  802047:	e9 77 ff ff ff       	jmp    801fc3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80204c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  802053:	e9 6b ff ff ff       	jmp    801fc3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  802058:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  802059:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80205d:	0f 89 60 ff ff ff    	jns    801fc3 <vprintfmt+0x54>
				width = precision, precision = -1;
  802063:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802066:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802069:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  802070:	e9 4e ff ff ff       	jmp    801fc3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802075:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  802078:	e9 46 ff ff ff       	jmp    801fc3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80207d:	8b 45 14             	mov    0x14(%ebp),%eax
  802080:	83 c0 04             	add    $0x4,%eax
  802083:	89 45 14             	mov    %eax,0x14(%ebp)
  802086:	8b 45 14             	mov    0x14(%ebp),%eax
  802089:	83 e8 04             	sub    $0x4,%eax
  80208c:	8b 00                	mov    (%eax),%eax
  80208e:	83 ec 08             	sub    $0x8,%esp
  802091:	ff 75 0c             	pushl  0xc(%ebp)
  802094:	50                   	push   %eax
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	ff d0                	call   *%eax
  80209a:	83 c4 10             	add    $0x10,%esp
			break;
  80209d:	e9 9b 02 00 00       	jmp    80233d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8020a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a5:	83 c0 04             	add    $0x4,%eax
  8020a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8020ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ae:	83 e8 04             	sub    $0x4,%eax
  8020b1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8020b3:	85 db                	test   %ebx,%ebx
  8020b5:	79 02                	jns    8020b9 <vprintfmt+0x14a>
				err = -err;
  8020b7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8020b9:	83 fb 64             	cmp    $0x64,%ebx
  8020bc:	7f 0b                	jg     8020c9 <vprintfmt+0x15a>
  8020be:	8b 34 9d e0 63 80 00 	mov    0x8063e0(,%ebx,4),%esi
  8020c5:	85 f6                	test   %esi,%esi
  8020c7:	75 19                	jne    8020e2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8020c9:	53                   	push   %ebx
  8020ca:	68 85 65 80 00       	push   $0x806585
  8020cf:	ff 75 0c             	pushl  0xc(%ebp)
  8020d2:	ff 75 08             	pushl  0x8(%ebp)
  8020d5:	e8 70 02 00 00       	call   80234a <printfmt>
  8020da:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8020dd:	e9 5b 02 00 00       	jmp    80233d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8020e2:	56                   	push   %esi
  8020e3:	68 8e 65 80 00       	push   $0x80658e
  8020e8:	ff 75 0c             	pushl  0xc(%ebp)
  8020eb:	ff 75 08             	pushl  0x8(%ebp)
  8020ee:	e8 57 02 00 00       	call   80234a <printfmt>
  8020f3:	83 c4 10             	add    $0x10,%esp
			break;
  8020f6:	e9 42 02 00 00       	jmp    80233d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8020fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fe:	83 c0 04             	add    $0x4,%eax
  802101:	89 45 14             	mov    %eax,0x14(%ebp)
  802104:	8b 45 14             	mov    0x14(%ebp),%eax
  802107:	83 e8 04             	sub    $0x4,%eax
  80210a:	8b 30                	mov    (%eax),%esi
  80210c:	85 f6                	test   %esi,%esi
  80210e:	75 05                	jne    802115 <vprintfmt+0x1a6>
				p = "(null)";
  802110:	be 91 65 80 00       	mov    $0x806591,%esi
			if (width > 0 && padc != '-')
  802115:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802119:	7e 6d                	jle    802188 <vprintfmt+0x219>
  80211b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80211f:	74 67                	je     802188 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  802121:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802124:	83 ec 08             	sub    $0x8,%esp
  802127:	50                   	push   %eax
  802128:	56                   	push   %esi
  802129:	e8 1e 03 00 00       	call   80244c <strnlen>
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  802134:	eb 16                	jmp    80214c <vprintfmt+0x1dd>
					putch(padc, putdat);
  802136:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80213a:	83 ec 08             	sub    $0x8,%esp
  80213d:	ff 75 0c             	pushl  0xc(%ebp)
  802140:	50                   	push   %eax
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	ff d0                	call   *%eax
  802146:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802149:	ff 4d e4             	decl   -0x1c(%ebp)
  80214c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802150:	7f e4                	jg     802136 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802152:	eb 34                	jmp    802188 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  802154:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802158:	74 1c                	je     802176 <vprintfmt+0x207>
  80215a:	83 fb 1f             	cmp    $0x1f,%ebx
  80215d:	7e 05                	jle    802164 <vprintfmt+0x1f5>
  80215f:	83 fb 7e             	cmp    $0x7e,%ebx
  802162:	7e 12                	jle    802176 <vprintfmt+0x207>
					putch('?', putdat);
  802164:	83 ec 08             	sub    $0x8,%esp
  802167:	ff 75 0c             	pushl  0xc(%ebp)
  80216a:	6a 3f                	push   $0x3f
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	ff d0                	call   *%eax
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	eb 0f                	jmp    802185 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  802176:	83 ec 08             	sub    $0x8,%esp
  802179:	ff 75 0c             	pushl  0xc(%ebp)
  80217c:	53                   	push   %ebx
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	ff d0                	call   *%eax
  802182:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802185:	ff 4d e4             	decl   -0x1c(%ebp)
  802188:	89 f0                	mov    %esi,%eax
  80218a:	8d 70 01             	lea    0x1(%eax),%esi
  80218d:	8a 00                	mov    (%eax),%al
  80218f:	0f be d8             	movsbl %al,%ebx
  802192:	85 db                	test   %ebx,%ebx
  802194:	74 24                	je     8021ba <vprintfmt+0x24b>
  802196:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80219a:	78 b8                	js     802154 <vprintfmt+0x1e5>
  80219c:	ff 4d e0             	decl   -0x20(%ebp)
  80219f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021a3:	79 af                	jns    802154 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8021a5:	eb 13                	jmp    8021ba <vprintfmt+0x24b>
				putch(' ', putdat);
  8021a7:	83 ec 08             	sub    $0x8,%esp
  8021aa:	ff 75 0c             	pushl  0xc(%ebp)
  8021ad:	6a 20                	push   $0x20
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	ff d0                	call   *%eax
  8021b4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8021b7:	ff 4d e4             	decl   -0x1c(%ebp)
  8021ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021be:	7f e7                	jg     8021a7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8021c0:	e9 78 01 00 00       	jmp    80233d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8021c5:	83 ec 08             	sub    $0x8,%esp
  8021c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8021cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8021ce:	50                   	push   %eax
  8021cf:	e8 3c fd ff ff       	call   801f10 <getint>
  8021d4:	83 c4 10             	add    $0x10,%esp
  8021d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8021dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e3:	85 d2                	test   %edx,%edx
  8021e5:	79 23                	jns    80220a <vprintfmt+0x29b>
				putch('-', putdat);
  8021e7:	83 ec 08             	sub    $0x8,%esp
  8021ea:	ff 75 0c             	pushl  0xc(%ebp)
  8021ed:	6a 2d                	push   $0x2d
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	ff d0                	call   *%eax
  8021f4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8021f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fd:	f7 d8                	neg    %eax
  8021ff:	83 d2 00             	adc    $0x0,%edx
  802202:	f7 da                	neg    %edx
  802204:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802207:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80220a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802211:	e9 bc 00 00 00       	jmp    8022d2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802216:	83 ec 08             	sub    $0x8,%esp
  802219:	ff 75 e8             	pushl  -0x18(%ebp)
  80221c:	8d 45 14             	lea    0x14(%ebp),%eax
  80221f:	50                   	push   %eax
  802220:	e8 84 fc ff ff       	call   801ea9 <getuint>
  802225:	83 c4 10             	add    $0x10,%esp
  802228:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80222b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80222e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802235:	e9 98 00 00 00       	jmp    8022d2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80223a:	83 ec 08             	sub    $0x8,%esp
  80223d:	ff 75 0c             	pushl  0xc(%ebp)
  802240:	6a 58                	push   $0x58
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	ff d0                	call   *%eax
  802247:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80224a:	83 ec 08             	sub    $0x8,%esp
  80224d:	ff 75 0c             	pushl  0xc(%ebp)
  802250:	6a 58                	push   $0x58
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	ff d0                	call   *%eax
  802257:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80225a:	83 ec 08             	sub    $0x8,%esp
  80225d:	ff 75 0c             	pushl  0xc(%ebp)
  802260:	6a 58                	push   $0x58
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	ff d0                	call   *%eax
  802267:	83 c4 10             	add    $0x10,%esp
			break;
  80226a:	e9 ce 00 00 00       	jmp    80233d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80226f:	83 ec 08             	sub    $0x8,%esp
  802272:	ff 75 0c             	pushl  0xc(%ebp)
  802275:	6a 30                	push   $0x30
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	ff d0                	call   *%eax
  80227c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80227f:	83 ec 08             	sub    $0x8,%esp
  802282:	ff 75 0c             	pushl  0xc(%ebp)
  802285:	6a 78                	push   $0x78
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	ff d0                	call   *%eax
  80228c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80228f:	8b 45 14             	mov    0x14(%ebp),%eax
  802292:	83 c0 04             	add    $0x4,%eax
  802295:	89 45 14             	mov    %eax,0x14(%ebp)
  802298:	8b 45 14             	mov    0x14(%ebp),%eax
  80229b:	83 e8 04             	sub    $0x4,%eax
  80229e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8022a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8022aa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8022b1:	eb 1f                	jmp    8022d2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8022b3:	83 ec 08             	sub    $0x8,%esp
  8022b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8022b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8022bc:	50                   	push   %eax
  8022bd:	e8 e7 fb ff ff       	call   801ea9 <getuint>
  8022c2:	83 c4 10             	add    $0x10,%esp
  8022c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8022cb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8022d2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8022d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d9:	83 ec 04             	sub    $0x4,%esp
  8022dc:	52                   	push   %edx
  8022dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022e0:	50                   	push   %eax
  8022e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8022e7:	ff 75 0c             	pushl  0xc(%ebp)
  8022ea:	ff 75 08             	pushl  0x8(%ebp)
  8022ed:	e8 00 fb ff ff       	call   801df2 <printnum>
  8022f2:	83 c4 20             	add    $0x20,%esp
			break;
  8022f5:	eb 46                	jmp    80233d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8022f7:	83 ec 08             	sub    $0x8,%esp
  8022fa:	ff 75 0c             	pushl  0xc(%ebp)
  8022fd:	53                   	push   %ebx
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	ff d0                	call   *%eax
  802303:	83 c4 10             	add    $0x10,%esp
			break;
  802306:	eb 35                	jmp    80233d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  802308:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  80230f:	eb 2c                	jmp    80233d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  802311:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  802318:	eb 23                	jmp    80233d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80231a:	83 ec 08             	sub    $0x8,%esp
  80231d:	ff 75 0c             	pushl  0xc(%ebp)
  802320:	6a 25                	push   $0x25
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	ff d0                	call   *%eax
  802327:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80232a:	ff 4d 10             	decl   0x10(%ebp)
  80232d:	eb 03                	jmp    802332 <vprintfmt+0x3c3>
  80232f:	ff 4d 10             	decl   0x10(%ebp)
  802332:	8b 45 10             	mov    0x10(%ebp),%eax
  802335:	48                   	dec    %eax
  802336:	8a 00                	mov    (%eax),%al
  802338:	3c 25                	cmp    $0x25,%al
  80233a:	75 f3                	jne    80232f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80233c:	90                   	nop
		}
	}
  80233d:	e9 35 fc ff ff       	jmp    801f77 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802342:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  802343:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802346:	5b                   	pop    %ebx
  802347:	5e                   	pop    %esi
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    

0080234a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
  80234d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802350:	8d 45 10             	lea    0x10(%ebp),%eax
  802353:	83 c0 04             	add    $0x4,%eax
  802356:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802359:	8b 45 10             	mov    0x10(%ebp),%eax
  80235c:	ff 75 f4             	pushl  -0xc(%ebp)
  80235f:	50                   	push   %eax
  802360:	ff 75 0c             	pushl  0xc(%ebp)
  802363:	ff 75 08             	pushl  0x8(%ebp)
  802366:	e8 04 fc ff ff       	call   801f6f <vprintfmt>
  80236b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80236e:	90                   	nop
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  802374:	8b 45 0c             	mov    0xc(%ebp),%eax
  802377:	8b 40 08             	mov    0x8(%eax),%eax
  80237a:	8d 50 01             	lea    0x1(%eax),%edx
  80237d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802380:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  802383:	8b 45 0c             	mov    0xc(%ebp),%eax
  802386:	8b 10                	mov    (%eax),%edx
  802388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238b:	8b 40 04             	mov    0x4(%eax),%eax
  80238e:	39 c2                	cmp    %eax,%edx
  802390:	73 12                	jae    8023a4 <sprintputch+0x33>
		*b->buf++ = ch;
  802392:	8b 45 0c             	mov    0xc(%ebp),%eax
  802395:	8b 00                	mov    (%eax),%eax
  802397:	8d 48 01             	lea    0x1(%eax),%ecx
  80239a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239d:	89 0a                	mov    %ecx,(%edx)
  80239f:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a2:	88 10                	mov    %dl,(%eax)
}
  8023a4:	90                   	nop
  8023a5:	5d                   	pop    %ebp
  8023a6:	c3                   	ret    

008023a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8023b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	01 d0                	add    %edx,%eax
  8023be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8023c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023cc:	74 06                	je     8023d4 <vsnprintf+0x2d>
  8023ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023d2:	7f 07                	jg     8023db <vsnprintf+0x34>
		return -E_INVAL;
  8023d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8023d9:	eb 20                	jmp    8023fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8023db:	ff 75 14             	pushl  0x14(%ebp)
  8023de:	ff 75 10             	pushl  0x10(%ebp)
  8023e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8023e4:	50                   	push   %eax
  8023e5:	68 71 23 80 00       	push   $0x802371
  8023ea:	e8 80 fb ff ff       	call   801f6f <vprintfmt>
  8023ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8023f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
  802400:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802403:	8d 45 10             	lea    0x10(%ebp),%eax
  802406:	83 c0 04             	add    $0x4,%eax
  802409:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80240c:	8b 45 10             	mov    0x10(%ebp),%eax
  80240f:	ff 75 f4             	pushl  -0xc(%ebp)
  802412:	50                   	push   %eax
  802413:	ff 75 0c             	pushl  0xc(%ebp)
  802416:	ff 75 08             	pushl  0x8(%ebp)
  802419:	e8 89 ff ff ff       	call   8023a7 <vsnprintf>
  80241e:	83 c4 10             	add    $0x10,%esp
  802421:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  802424:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80242f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802436:	eb 06                	jmp    80243e <strlen+0x15>
		n++;
  802438:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80243b:	ff 45 08             	incl   0x8(%ebp)
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	8a 00                	mov    (%eax),%al
  802443:	84 c0                	test   %al,%al
  802445:	75 f1                	jne    802438 <strlen+0xf>
		n++;
	return n;
  802447:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802452:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802459:	eb 09                	jmp    802464 <strnlen+0x18>
		n++;
  80245b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80245e:	ff 45 08             	incl   0x8(%ebp)
  802461:	ff 4d 0c             	decl   0xc(%ebp)
  802464:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802468:	74 09                	je     802473 <strnlen+0x27>
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	8a 00                	mov    (%eax),%al
  80246f:	84 c0                	test   %al,%al
  802471:	75 e8                	jne    80245b <strnlen+0xf>
		n++;
	return n;
  802473:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
  80247b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  802484:	90                   	nop
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	8d 50 01             	lea    0x1(%eax),%edx
  80248b:	89 55 08             	mov    %edx,0x8(%ebp)
  80248e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802491:	8d 4a 01             	lea    0x1(%edx),%ecx
  802494:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802497:	8a 12                	mov    (%edx),%dl
  802499:	88 10                	mov    %dl,(%eax)
  80249b:	8a 00                	mov    (%eax),%al
  80249d:	84 c0                	test   %al,%al
  80249f:	75 e4                	jne    802485 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8024a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
  8024a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8024ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8024af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8024b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024b9:	eb 1f                	jmp    8024da <strncpy+0x34>
		*dst++ = *src;
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	8d 50 01             	lea    0x1(%eax),%edx
  8024c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8024c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c7:	8a 12                	mov    (%edx),%dl
  8024c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8024cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ce:	8a 00                	mov    (%eax),%al
  8024d0:	84 c0                	test   %al,%al
  8024d2:	74 03                	je     8024d7 <strncpy+0x31>
			src++;
  8024d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8024d7:	ff 45 fc             	incl   -0x4(%ebp)
  8024da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8024e0:	72 d9                	jb     8024bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8024e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8024e5:	c9                   	leave  
  8024e6:	c3                   	ret    

008024e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
  8024ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8024f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024f7:	74 30                	je     802529 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8024f9:	eb 16                	jmp    802511 <strlcpy+0x2a>
			*dst++ = *src++;
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	8d 50 01             	lea    0x1(%eax),%edx
  802501:	89 55 08             	mov    %edx,0x8(%ebp)
  802504:	8b 55 0c             	mov    0xc(%ebp),%edx
  802507:	8d 4a 01             	lea    0x1(%edx),%ecx
  80250a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80250d:	8a 12                	mov    (%edx),%dl
  80250f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802511:	ff 4d 10             	decl   0x10(%ebp)
  802514:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802518:	74 09                	je     802523 <strlcpy+0x3c>
  80251a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251d:	8a 00                	mov    (%eax),%al
  80251f:	84 c0                	test   %al,%al
  802521:	75 d8                	jne    8024fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802529:	8b 55 08             	mov    0x8(%ebp),%edx
  80252c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80252f:	29 c2                	sub    %eax,%edx
  802531:	89 d0                	mov    %edx,%eax
}
  802533:	c9                   	leave  
  802534:	c3                   	ret    

00802535 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802538:	eb 06                	jmp    802540 <strcmp+0xb>
		p++, q++;
  80253a:	ff 45 08             	incl   0x8(%ebp)
  80253d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	8a 00                	mov    (%eax),%al
  802545:	84 c0                	test   %al,%al
  802547:	74 0e                	je     802557 <strcmp+0x22>
  802549:	8b 45 08             	mov    0x8(%ebp),%eax
  80254c:	8a 10                	mov    (%eax),%dl
  80254e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802551:	8a 00                	mov    (%eax),%al
  802553:	38 c2                	cmp    %al,%dl
  802555:	74 e3                	je     80253a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802557:	8b 45 08             	mov    0x8(%ebp),%eax
  80255a:	8a 00                	mov    (%eax),%al
  80255c:	0f b6 d0             	movzbl %al,%edx
  80255f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802562:	8a 00                	mov    (%eax),%al
  802564:	0f b6 c0             	movzbl %al,%eax
  802567:	29 c2                	sub    %eax,%edx
  802569:	89 d0                	mov    %edx,%eax
}
  80256b:	5d                   	pop    %ebp
  80256c:	c3                   	ret    

0080256d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802570:	eb 09                	jmp    80257b <strncmp+0xe>
		n--, p++, q++;
  802572:	ff 4d 10             	decl   0x10(%ebp)
  802575:	ff 45 08             	incl   0x8(%ebp)
  802578:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80257b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80257f:	74 17                	je     802598 <strncmp+0x2b>
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	8a 00                	mov    (%eax),%al
  802586:	84 c0                	test   %al,%al
  802588:	74 0e                	je     802598 <strncmp+0x2b>
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	8a 10                	mov    (%eax),%dl
  80258f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802592:	8a 00                	mov    (%eax),%al
  802594:	38 c2                	cmp    %al,%dl
  802596:	74 da                	je     802572 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802598:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80259c:	75 07                	jne    8025a5 <strncmp+0x38>
		return 0;
  80259e:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a3:	eb 14                	jmp    8025b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	8a 00                	mov    (%eax),%al
  8025aa:	0f b6 d0             	movzbl %al,%edx
  8025ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b0:	8a 00                	mov    (%eax),%al
  8025b2:	0f b6 c0             	movzbl %al,%eax
  8025b5:	29 c2                	sub    %eax,%edx
  8025b7:	89 d0                	mov    %edx,%eax
}
  8025b9:	5d                   	pop    %ebp
  8025ba:	c3                   	ret    

008025bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
  8025be:	83 ec 04             	sub    $0x4,%esp
  8025c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8025c7:	eb 12                	jmp    8025db <strchr+0x20>
		if (*s == c)
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	8a 00                	mov    (%eax),%al
  8025ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8025d1:	75 05                	jne    8025d8 <strchr+0x1d>
			return (char *) s;
  8025d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d6:	eb 11                	jmp    8025e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8025d8:	ff 45 08             	incl   0x8(%ebp)
  8025db:	8b 45 08             	mov    0x8(%ebp),%eax
  8025de:	8a 00                	mov    (%eax),%al
  8025e0:	84 c0                	test   %al,%al
  8025e2:	75 e5                	jne    8025c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 04             	sub    $0x4,%esp
  8025f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8025f7:	eb 0d                	jmp    802606 <strfind+0x1b>
		if (*s == c)
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	8a 00                	mov    (%eax),%al
  8025fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802601:	74 0e                	je     802611 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802603:	ff 45 08             	incl   0x8(%ebp)
  802606:	8b 45 08             	mov    0x8(%ebp),%eax
  802609:	8a 00                	mov    (%eax),%al
  80260b:	84 c0                	test   %al,%al
  80260d:	75 ea                	jne    8025f9 <strfind+0xe>
  80260f:	eb 01                	jmp    802612 <strfind+0x27>
		if (*s == c)
			break;
  802611:	90                   	nop
	return (char *) s;
  802612:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
  80261a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802623:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802627:	76 63                	jbe    80268c <memset+0x75>
		uint64 data_block = c;
  802629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262c:	99                   	cltd   
  80262d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802630:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802636:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802639:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80263d:	c1 e0 08             	shl    $0x8,%eax
  802640:	09 45 f0             	or     %eax,-0x10(%ebp)
  802643:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802649:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  802650:	c1 e0 10             	shl    $0x10,%eax
  802653:	09 45 f0             	or     %eax,-0x10(%ebp)
  802656:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  802659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265f:	89 c2                	mov    %eax,%edx
  802661:	b8 00 00 00 00       	mov    $0x0,%eax
  802666:	09 45 f0             	or     %eax,-0x10(%ebp)
  802669:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80266c:	eb 18                	jmp    802686 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80266e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802671:	8d 41 08             	lea    0x8(%ecx),%eax
  802674:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267d:	89 01                	mov    %eax,(%ecx)
  80267f:	89 51 04             	mov    %edx,0x4(%ecx)
  802682:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802686:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80268a:	77 e2                	ja     80266e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80268c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802690:	74 23                	je     8026b5 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802692:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802695:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  802698:	eb 0e                	jmp    8026a8 <memset+0x91>
			*p8++ = (uint8)c;
  80269a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80269d:	8d 50 01             	lea    0x1(%eax),%edx
  8026a0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8026a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a6:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8026a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8026ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	75 e5                	jne    80269a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8026c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8026cc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8026d0:	76 24                	jbe    8026f6 <memcpy+0x3c>
		while(n >= 8){
  8026d2:	eb 1c                	jmp    8026f0 <memcpy+0x36>
			*d64 = *s64;
  8026d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026d7:	8b 50 04             	mov    0x4(%eax),%edx
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8026df:	89 01                	mov    %eax,(%ecx)
  8026e1:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8026e4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8026e8:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8026ec:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8026f0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8026f4:	77 de                	ja     8026d4 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8026f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026fa:	74 31                	je     80272d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8026fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802702:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802705:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802708:	eb 16                	jmp    802720 <memcpy+0x66>
			*d8++ = *s8++;
  80270a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270d:	8d 50 01             	lea    0x1(%eax),%edx
  802710:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802713:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802716:	8d 4a 01             	lea    0x1(%edx),%ecx
  802719:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80271c:	8a 12                	mov    (%edx),%dl
  80271e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802720:	8b 45 10             	mov    0x10(%ebp),%eax
  802723:	8d 50 ff             	lea    -0x1(%eax),%edx
  802726:	89 55 10             	mov    %edx,0x10(%ebp)
  802729:	85 c0                	test   %eax,%eax
  80272b:	75 dd                	jne    80270a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802730:	c9                   	leave  
  802731:	c3                   	ret    

00802732 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
  802735:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802744:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802747:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80274a:	73 50                	jae    80279c <memmove+0x6a>
  80274c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80274f:	8b 45 10             	mov    0x10(%ebp),%eax
  802752:	01 d0                	add    %edx,%eax
  802754:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802757:	76 43                	jbe    80279c <memmove+0x6a>
		s += n;
  802759:	8b 45 10             	mov    0x10(%ebp),%eax
  80275c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80275f:	8b 45 10             	mov    0x10(%ebp),%eax
  802762:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802765:	eb 10                	jmp    802777 <memmove+0x45>
			*--d = *--s;
  802767:	ff 4d f8             	decl   -0x8(%ebp)
  80276a:	ff 4d fc             	decl   -0x4(%ebp)
  80276d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802770:	8a 10                	mov    (%eax),%dl
  802772:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802775:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802777:	8b 45 10             	mov    0x10(%ebp),%eax
  80277a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80277d:	89 55 10             	mov    %edx,0x10(%ebp)
  802780:	85 c0                	test   %eax,%eax
  802782:	75 e3                	jne    802767 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802784:	eb 23                	jmp    8027a9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802786:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802789:	8d 50 01             	lea    0x1(%eax),%edx
  80278c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80278f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802792:	8d 4a 01             	lea    0x1(%edx),%ecx
  802795:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802798:	8a 12                	mov    (%edx),%dl
  80279a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80279c:	8b 45 10             	mov    0x10(%ebp),%eax
  80279f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8027a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	75 dd                	jne    802786 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
  8027b1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8027ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027bd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8027c0:	eb 2a                	jmp    8027ec <memcmp+0x3e>
		if (*s1 != *s2)
  8027c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027c5:	8a 10                	mov    (%eax),%dl
  8027c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027ca:	8a 00                	mov    (%eax),%al
  8027cc:	38 c2                	cmp    %al,%dl
  8027ce:	74 16                	je     8027e6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8027d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027d3:	8a 00                	mov    (%eax),%al
  8027d5:	0f b6 d0             	movzbl %al,%edx
  8027d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027db:	8a 00                	mov    (%eax),%al
  8027dd:	0f b6 c0             	movzbl %al,%eax
  8027e0:	29 c2                	sub    %eax,%edx
  8027e2:	89 d0                	mov    %edx,%eax
  8027e4:	eb 18                	jmp    8027fe <memcmp+0x50>
		s1++, s2++;
  8027e6:	ff 45 fc             	incl   -0x4(%ebp)
  8027e9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8027ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8027f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	75 c9                	jne    8027c2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027fe:	c9                   	leave  
  8027ff:	c3                   	ret    

00802800 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802806:	8b 55 08             	mov    0x8(%ebp),%edx
  802809:	8b 45 10             	mov    0x10(%ebp),%eax
  80280c:	01 d0                	add    %edx,%eax
  80280e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802811:	eb 15                	jmp    802828 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	8a 00                	mov    (%eax),%al
  802818:	0f b6 d0             	movzbl %al,%edx
  80281b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80281e:	0f b6 c0             	movzbl %al,%eax
  802821:	39 c2                	cmp    %eax,%edx
  802823:	74 0d                	je     802832 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802825:	ff 45 08             	incl   0x8(%ebp)
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80282e:	72 e3                	jb     802813 <memfind+0x13>
  802830:	eb 01                	jmp    802833 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802832:	90                   	nop
	return (void *) s;
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802836:	c9                   	leave  
  802837:	c3                   	ret    

00802838 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80283e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802845:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80284c:	eb 03                	jmp    802851 <strtol+0x19>
		s++;
  80284e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	8a 00                	mov    (%eax),%al
  802856:	3c 20                	cmp    $0x20,%al
  802858:	74 f4                	je     80284e <strtol+0x16>
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	8a 00                	mov    (%eax),%al
  80285f:	3c 09                	cmp    $0x9,%al
  802861:	74 eb                	je     80284e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	8a 00                	mov    (%eax),%al
  802868:	3c 2b                	cmp    $0x2b,%al
  80286a:	75 05                	jne    802871 <strtol+0x39>
		s++;
  80286c:	ff 45 08             	incl   0x8(%ebp)
  80286f:	eb 13                	jmp    802884 <strtol+0x4c>
	else if (*s == '-')
  802871:	8b 45 08             	mov    0x8(%ebp),%eax
  802874:	8a 00                	mov    (%eax),%al
  802876:	3c 2d                	cmp    $0x2d,%al
  802878:	75 0a                	jne    802884 <strtol+0x4c>
		s++, neg = 1;
  80287a:	ff 45 08             	incl   0x8(%ebp)
  80287d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802884:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802888:	74 06                	je     802890 <strtol+0x58>
  80288a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80288e:	75 20                	jne    8028b0 <strtol+0x78>
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	8a 00                	mov    (%eax),%al
  802895:	3c 30                	cmp    $0x30,%al
  802897:	75 17                	jne    8028b0 <strtol+0x78>
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	40                   	inc    %eax
  80289d:	8a 00                	mov    (%eax),%al
  80289f:	3c 78                	cmp    $0x78,%al
  8028a1:	75 0d                	jne    8028b0 <strtol+0x78>
		s += 2, base = 16;
  8028a3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8028a7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8028ae:	eb 28                	jmp    8028d8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8028b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028b4:	75 15                	jne    8028cb <strtol+0x93>
  8028b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b9:	8a 00                	mov    (%eax),%al
  8028bb:	3c 30                	cmp    $0x30,%al
  8028bd:	75 0c                	jne    8028cb <strtol+0x93>
		s++, base = 8;
  8028bf:	ff 45 08             	incl   0x8(%ebp)
  8028c2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8028c9:	eb 0d                	jmp    8028d8 <strtol+0xa0>
	else if (base == 0)
  8028cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028cf:	75 07                	jne    8028d8 <strtol+0xa0>
		base = 10;
  8028d1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	8a 00                	mov    (%eax),%al
  8028dd:	3c 2f                	cmp    $0x2f,%al
  8028df:	7e 19                	jle    8028fa <strtol+0xc2>
  8028e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e4:	8a 00                	mov    (%eax),%al
  8028e6:	3c 39                	cmp    $0x39,%al
  8028e8:	7f 10                	jg     8028fa <strtol+0xc2>
			dig = *s - '0';
  8028ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ed:	8a 00                	mov    (%eax),%al
  8028ef:	0f be c0             	movsbl %al,%eax
  8028f2:	83 e8 30             	sub    $0x30,%eax
  8028f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f8:	eb 42                	jmp    80293c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	8a 00                	mov    (%eax),%al
  8028ff:	3c 60                	cmp    $0x60,%al
  802901:	7e 19                	jle    80291c <strtol+0xe4>
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	8a 00                	mov    (%eax),%al
  802908:	3c 7a                	cmp    $0x7a,%al
  80290a:	7f 10                	jg     80291c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	8a 00                	mov    (%eax),%al
  802911:	0f be c0             	movsbl %al,%eax
  802914:	83 e8 57             	sub    $0x57,%eax
  802917:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291a:	eb 20                	jmp    80293c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	8a 00                	mov    (%eax),%al
  802921:	3c 40                	cmp    $0x40,%al
  802923:	7e 39                	jle    80295e <strtol+0x126>
  802925:	8b 45 08             	mov    0x8(%ebp),%eax
  802928:	8a 00                	mov    (%eax),%al
  80292a:	3c 5a                	cmp    $0x5a,%al
  80292c:	7f 30                	jg     80295e <strtol+0x126>
			dig = *s - 'A' + 10;
  80292e:	8b 45 08             	mov    0x8(%ebp),%eax
  802931:	8a 00                	mov    (%eax),%al
  802933:	0f be c0             	movsbl %al,%eax
  802936:	83 e8 37             	sub    $0x37,%eax
  802939:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	3b 45 10             	cmp    0x10(%ebp),%eax
  802942:	7d 19                	jge    80295d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802944:	ff 45 08             	incl   0x8(%ebp)
  802947:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80294a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80294e:	89 c2                	mov    %eax,%edx
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	01 d0                	add    %edx,%eax
  802955:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802958:	e9 7b ff ff ff       	jmp    8028d8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80295d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80295e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802962:	74 08                	je     80296c <strtol+0x134>
		*endptr = (char *) s;
  802964:	8b 45 0c             	mov    0xc(%ebp),%eax
  802967:	8b 55 08             	mov    0x8(%ebp),%edx
  80296a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80296c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802970:	74 07                	je     802979 <strtol+0x141>
  802972:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802975:	f7 d8                	neg    %eax
  802977:	eb 03                	jmp    80297c <strtol+0x144>
  802979:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80297c:	c9                   	leave  
  80297d:	c3                   	ret    

0080297e <ltostr>:

void
ltostr(long value, char *str)
{
  80297e:	55                   	push   %ebp
  80297f:	89 e5                	mov    %esp,%ebp
  802981:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802984:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80298b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802992:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802996:	79 13                	jns    8029ab <ltostr+0x2d>
	{
		neg = 1;
  802998:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80299f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029a2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8029a5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8029a8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8029b3:	99                   	cltd   
  8029b4:	f7 f9                	idiv   %ecx
  8029b6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8029b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029bc:	8d 50 01             	lea    0x1(%eax),%edx
  8029bf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8029c2:	89 c2                	mov    %eax,%edx
  8029c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c7:	01 d0                	add    %edx,%eax
  8029c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029cc:	83 c2 30             	add    $0x30,%edx
  8029cf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8029d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8029d9:	f7 e9                	imul   %ecx
  8029db:	c1 fa 02             	sar    $0x2,%edx
  8029de:	89 c8                	mov    %ecx,%eax
  8029e0:	c1 f8 1f             	sar    $0x1f,%eax
  8029e3:	29 c2                	sub    %eax,%edx
  8029e5:	89 d0                	mov    %edx,%eax
  8029e7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8029ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ee:	75 bb                	jne    8029ab <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8029f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8029f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029fa:	48                   	dec    %eax
  8029fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8029fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a02:	74 3d                	je     802a41 <ltostr+0xc3>
		start = 1 ;
  802a04:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802a0b:	eb 34                	jmp    802a41 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802a0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a13:	01 d0                	add    %edx,%eax
  802a15:	8a 00                	mov    (%eax),%al
  802a17:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a20:	01 c2                	add    %eax,%edx
  802a22:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a28:	01 c8                	add    %ecx,%eax
  802a2a:	8a 00                	mov    (%eax),%al
  802a2c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802a2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a34:	01 c2                	add    %eax,%edx
  802a36:	8a 45 eb             	mov    -0x15(%ebp),%al
  802a39:	88 02                	mov    %al,(%edx)
		start++ ;
  802a3b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802a3e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a47:	7c c4                	jl     802a0d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802a49:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a4f:	01 d0                	add    %edx,%eax
  802a51:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802a54:	90                   	nop
  802a55:	c9                   	leave  
  802a56:	c3                   	ret    

00802a57 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802a57:	55                   	push   %ebp
  802a58:	89 e5                	mov    %esp,%ebp
  802a5a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802a5d:	ff 75 08             	pushl  0x8(%ebp)
  802a60:	e8 c4 f9 ff ff       	call   802429 <strlen>
  802a65:	83 c4 04             	add    $0x4,%esp
  802a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802a6b:	ff 75 0c             	pushl  0xc(%ebp)
  802a6e:	e8 b6 f9 ff ff       	call   802429 <strlen>
  802a73:	83 c4 04             	add    $0x4,%esp
  802a76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802a79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802a80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802a87:	eb 17                	jmp    802aa0 <strcconcat+0x49>
		final[s] = str1[s] ;
  802a89:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a8c:	8b 45 10             	mov    0x10(%ebp),%eax
  802a8f:	01 c2                	add    %eax,%edx
  802a91:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	01 c8                	add    %ecx,%eax
  802a99:	8a 00                	mov    (%eax),%al
  802a9b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802a9d:	ff 45 fc             	incl   -0x4(%ebp)
  802aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aa3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802aa6:	7c e1                	jl     802a89 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802aa8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802aaf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802ab6:	eb 1f                	jmp    802ad7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802ab8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802abb:	8d 50 01             	lea    0x1(%eax),%edx
  802abe:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802ac1:	89 c2                	mov    %eax,%edx
  802ac3:	8b 45 10             	mov    0x10(%ebp),%eax
  802ac6:	01 c2                	add    %eax,%edx
  802ac8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ace:	01 c8                	add    %ecx,%eax
  802ad0:	8a 00                	mov    (%eax),%al
  802ad2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802ad4:	ff 45 f8             	incl   -0x8(%ebp)
  802ad7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802ada:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802add:	7c d9                	jl     802ab8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802adf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  802ae5:	01 d0                	add    %edx,%eax
  802ae7:	c6 00 00             	movb   $0x0,(%eax)
}
  802aea:	90                   	nop
  802aeb:	c9                   	leave  
  802aec:	c3                   	ret    

00802aed <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802aed:	55                   	push   %ebp
  802aee:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802af0:	8b 45 14             	mov    0x14(%ebp),%eax
  802af3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802af9:	8b 45 14             	mov    0x14(%ebp),%eax
  802afc:	8b 00                	mov    (%eax),%eax
  802afe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802b05:	8b 45 10             	mov    0x10(%ebp),%eax
  802b08:	01 d0                	add    %edx,%eax
  802b0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802b10:	eb 0c                	jmp    802b1e <strsplit+0x31>
			*string++ = 0;
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	8d 50 01             	lea    0x1(%eax),%edx
  802b18:	89 55 08             	mov    %edx,0x8(%ebp)
  802b1b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	8a 00                	mov    (%eax),%al
  802b23:	84 c0                	test   %al,%al
  802b25:	74 18                	je     802b3f <strsplit+0x52>
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	8a 00                	mov    (%eax),%al
  802b2c:	0f be c0             	movsbl %al,%eax
  802b2f:	50                   	push   %eax
  802b30:	ff 75 0c             	pushl  0xc(%ebp)
  802b33:	e8 83 fa ff ff       	call   8025bb <strchr>
  802b38:	83 c4 08             	add    $0x8,%esp
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	75 d3                	jne    802b12 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	8a 00                	mov    (%eax),%al
  802b44:	84 c0                	test   %al,%al
  802b46:	74 5a                	je     802ba2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802b48:	8b 45 14             	mov    0x14(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	83 f8 0f             	cmp    $0xf,%eax
  802b50:	75 07                	jne    802b59 <strsplit+0x6c>
		{
			return 0;
  802b52:	b8 00 00 00 00       	mov    $0x0,%eax
  802b57:	eb 66                	jmp    802bbf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802b59:	8b 45 14             	mov    0x14(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	8d 48 01             	lea    0x1(%eax),%ecx
  802b61:	8b 55 14             	mov    0x14(%ebp),%edx
  802b64:	89 0a                	mov    %ecx,(%edx)
  802b66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  802b70:	01 c2                	add    %eax,%edx
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802b77:	eb 03                	jmp    802b7c <strsplit+0x8f>
			string++;
  802b79:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	8a 00                	mov    (%eax),%al
  802b81:	84 c0                	test   %al,%al
  802b83:	74 8b                	je     802b10 <strsplit+0x23>
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	8a 00                	mov    (%eax),%al
  802b8a:	0f be c0             	movsbl %al,%eax
  802b8d:	50                   	push   %eax
  802b8e:	ff 75 0c             	pushl  0xc(%ebp)
  802b91:	e8 25 fa ff ff       	call   8025bb <strchr>
  802b96:	83 c4 08             	add    $0x8,%esp
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	74 dc                	je     802b79 <strsplit+0x8c>
			string++;
	}
  802b9d:	e9 6e ff ff ff       	jmp    802b10 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802ba2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802ba3:	8b 45 14             	mov    0x14(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802baf:	8b 45 10             	mov    0x10(%ebp),%eax
  802bb2:	01 d0                	add    %edx,%eax
  802bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802bba:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802bbf:	c9                   	leave  
  802bc0:	c3                   	ret    

00802bc1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802bc1:	55                   	push   %ebp
  802bc2:	89 e5                	mov    %esp,%ebp
  802bc4:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802bcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802bd4:	eb 4a                	jmp    802c20 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802bd6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	01 c2                	add    %eax,%edx
  802bde:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be4:	01 c8                	add    %ecx,%eax
  802be6:	8a 00                	mov    (%eax),%al
  802be8:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802bea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf0:	01 d0                	add    %edx,%eax
  802bf2:	8a 00                	mov    (%eax),%al
  802bf4:	3c 40                	cmp    $0x40,%al
  802bf6:	7e 25                	jle    802c1d <str2lower+0x5c>
  802bf8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bfe:	01 d0                	add    %edx,%eax
  802c00:	8a 00                	mov    (%eax),%al
  802c02:	3c 5a                	cmp    $0x5a,%al
  802c04:	7f 17                	jg     802c1d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802c06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	01 d0                	add    %edx,%eax
  802c0e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802c11:	8b 55 08             	mov    0x8(%ebp),%edx
  802c14:	01 ca                	add    %ecx,%edx
  802c16:	8a 12                	mov    (%edx),%dl
  802c18:	83 c2 20             	add    $0x20,%edx
  802c1b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802c1d:	ff 45 fc             	incl   -0x4(%ebp)
  802c20:	ff 75 0c             	pushl  0xc(%ebp)
  802c23:	e8 01 f8 ff ff       	call   802429 <strlen>
  802c28:	83 c4 04             	add    $0x4,%esp
  802c2b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802c2e:	7f a6                	jg     802bd6 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802c33:	c9                   	leave  
  802c34:	c3                   	ret    

00802c35 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802c35:	55                   	push   %ebp
  802c36:	89 e5                	mov    %esp,%ebp
  802c38:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802c3b:	a1 08 70 80 00       	mov    0x807008,%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	0f 84 95 00 00 00    	je     802cdd <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802c48:	83 ec 08             	sub    $0x8,%esp
  802c4b:	68 00 00 00 82       	push   $0x82000000
  802c50:	68 00 00 00 80       	push   $0x80000000
  802c55:	e8 59 1f 00 00       	call   804bb3 <initialize_dynamic_allocator>
  802c5a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802c5d:	e8 93 1d 00 00       	call   8049f5 <sys_get_uheap_strategy>
  802c62:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802c67:	a1 20 72 80 00       	mov    0x807220,%eax
  802c6c:	05 00 10 00 00       	add    $0x1000,%eax
  802c71:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802c76:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802c7b:	a3 50 f2 81 00       	mov    %eax,0x81f250
		init_uspinlock(&ulock,"malloc",1);
  802c80:	83 ec 04             	sub    $0x4,%esp
  802c83:	6a 01                	push   $0x1
  802c85:	68 08 67 80 00       	push   $0x806708
  802c8a:	68 20 f3 81 00       	push   $0x81f320
  802c8f:	e8 1a 29 00 00       	call   8055ae <init_uspinlock>
  802c94:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  802c97:	c7 05 00 f3 81 00 00 	movl   $0x0,0x81f300
  802c9e:	00 00 00 
  802ca1:	c7 05 04 f3 81 00 00 	movl   $0x0,0x81f304
  802ca8:	00 00 00 
  802cab:	c7 05 0c f3 81 00 00 	movl   $0x0,0x81f30c
  802cb2:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  802cb5:	c7 05 10 f3 81 00 00 	movl   $0x0,0x81f310
  802cbc:	00 00 00 
  802cbf:	c7 05 14 f3 81 00 00 	movl   $0x0,0x81f314
  802cc6:	00 00 00 
  802cc9:	c7 05 1c f3 81 00 00 	movl   $0x0,0x81f31c
  802cd0:	00 00 00 
		__firstTimeFlag = 0;
  802cd3:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  802cda:	00 00 00 
	}
}
  802cdd:	90                   	nop
  802cde:	c9                   	leave  
  802cdf:	c3                   	ret    

00802ce0 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802ce0:	55                   	push   %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
  802ce3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802cf4:	83 ec 08             	sub    $0x8,%esp
  802cf7:	68 06 04 00 00       	push   $0x406
  802cfc:	50                   	push   %eax
  802cfd:	e8 3d 19 00 00       	call   80463f <__sys_allocate_page>
  802d02:	83 c4 10             	add    $0x10,%esp
  802d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802d08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0c:	79 14                	jns    802d22 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802d0e:	83 ec 04             	sub    $0x4,%esp
  802d11:	68 10 67 80 00       	push   $0x806710
  802d16:	6a 2d                	push   $0x2d
  802d18:	68 4c 67 80 00       	push   $0x80674c
  802d1d:	e8 60 ed ff ff       	call   801a82 <_panic>
	return 0;
  802d22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d27:	c9                   	leave  
  802d28:	c3                   	ret    

00802d29 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802d29:	55                   	push   %ebp
  802d2a:	89 e5                	mov    %esp,%ebp
  802d2c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802d3d:	83 ec 0c             	sub    $0xc,%esp
  802d40:	50                   	push   %eax
  802d41:	e8 40 19 00 00       	call   804686 <__sys_unmap_frame>
  802d46:	83 c4 10             	add    $0x10,%esp
  802d49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802d4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d50:	79 14                	jns    802d66 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802d52:	83 ec 04             	sub    $0x4,%esp
  802d55:	68 58 67 80 00       	push   $0x806758
  802d5a:	6a 38                	push   $0x38
  802d5c:	68 4c 67 80 00       	push   $0x80674c
  802d61:	e8 1c ed ff ff       	call   801a82 <_panic>
}
  802d66:	90                   	nop
  802d67:	c9                   	leave  
  802d68:	c3                   	ret    

00802d69 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802d69:	55                   	push   %ebp
  802d6a:	89 e5                	mov    %esp,%ebp
  802d6c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802d6f:	e8 c1 fe ff ff       	call   802c35 <uheap_init>
	if (size == 0) return NULL ;
  802d74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d78:	75 0a                	jne    802d84 <malloc+0x1b>
  802d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7f:	e9 e1 04 00 00       	jmp    803265 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  802d84:	83 ec 0c             	sub    $0xc,%esp
  802d87:	68 20 f3 81 00       	push   $0x81f320
  802d8c:	e8 6c 28 00 00       	call   8055fd <acquire_uspinlock>
  802d91:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  802d94:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  802d9b:	77 23                	ja     802dc0 <malloc+0x57>
		release_uspinlock(&ulock);
  802d9d:	83 ec 0c             	sub    $0xc,%esp
  802da0:	68 20 f3 81 00       	push   $0x81f320
  802da5:	e8 ab 28 00 00       	call   805655 <release_uspinlock>
  802daa:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  802dad:	83 ec 0c             	sub    $0xc,%esp
  802db0:	ff 75 08             	pushl  0x8(%ebp)
  802db3:	e8 dd 1f 00 00       	call   804d95 <alloc_block>
  802db8:	83 c4 10             	add    $0x10,%esp
  802dbb:	e9 a5 04 00 00       	jmp    803265 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802dc0:	83 ec 0c             	sub    $0xc,%esp
  802dc3:	6a 10                	push   $0x10
  802dc5:	e8 cb 1f 00 00       	call   804d95 <alloc_block>
  802dca:	83 c4 10             	add    $0x10,%esp
  802dcd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  802dd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dd4:	75 0a                	jne    802de0 <malloc+0x77>
			return NULL;
  802dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddb:	e9 85 04 00 00       	jmp    803265 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  802de0:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802de7:	8b 55 08             	mov    0x8(%ebp),%edx
  802dea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ded:	01 d0                	add    %edx,%eax
  802def:	48                   	dec    %eax
  802df0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df6:	ba 00 00 00 00       	mov    $0x0,%edx
  802dfb:	f7 75 e8             	divl   -0x18(%ebp)
  802dfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e01:	29 d0                	sub    %edx,%eax
  802e03:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802e06:	a1 04 f3 81 00       	mov    0x81f304,%eax
  802e0b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802e0e:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802e13:	85 c0                	test   %eax,%eax
  802e15:	74 0f                	je     802e26 <malloc+0xbd>
  802e17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1a:	8b 40 04             	mov    0x4(%eax),%eax
  802e1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e20:	0f 83 ea 00 00 00    	jae    802f10 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  802e26:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802e2b:	2b 45 08             	sub    0x8(%ebp),%eax
  802e2e:	89 c2                	mov    %eax,%edx
  802e30:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802e35:	39 c2                	cmp    %eax,%edx
  802e37:	0f 86 b9 00 00 00    	jbe    802ef6 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  802e3d:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802e42:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  802e45:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	01 d0                	add    %edx,%eax
  802e50:	a3 50 f2 81 00       	mov    %eax,0x81f250
					allocblock->startva = requestedblockva;
  802e55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e58:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e5b:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e60:	8b 55 08             	mov    0x8(%ebp),%edx
  802e63:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802e66:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e6a:	75 14                	jne    802e80 <malloc+0x117>
  802e6c:	83 ec 04             	sub    $0x4,%esp
  802e6f:	68 98 67 80 00       	push   $0x806798
  802e74:	6a 60                	push   $0x60
  802e76:	68 4c 67 80 00       	push   $0x80674c
  802e7b:	e8 02 ec ff ff       	call   801a82 <_panic>
  802e80:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e89:	89 50 0c             	mov    %edx,0xc(%eax)
  802e8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e92:	85 c0                	test   %eax,%eax
  802e94:	74 0d                	je     802ea3 <malloc+0x13a>
  802e96:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802e9b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e9e:	89 50 08             	mov    %edx,0x8(%eax)
  802ea1:	eb 08                	jmp    802eab <malloc+0x142>
  802ea3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea6:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eae:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802eb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ebd:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802ec2:	40                   	inc    %eax
  802ec3:	a3 1c f3 81 00       	mov    %eax,0x81f31c


					sys_allocate_user_mem(allocblock->startva ,size);
  802ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecb:	8b 00                	mov    (%eax),%eax
  802ecd:	83 ec 08             	sub    $0x8,%esp
  802ed0:	ff 75 08             	pushl  0x8(%ebp)
  802ed3:	50                   	push   %eax
  802ed4:	e8 34 1c 00 00       	call   804b0d <sys_allocate_user_mem>
  802ed9:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  802edc:	83 ec 0c             	sub    $0xc,%esp
  802edf:	68 20 f3 81 00       	push   $0x81f320
  802ee4:	e8 6c 27 00 00       	call   805655 <release_uspinlock>
  802ee9:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eef:	8b 00                	mov    (%eax),%eax
  802ef1:	e9 6f 03 00 00       	jmp    803265 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  802ef6:	83 ec 0c             	sub    $0xc,%esp
  802ef9:	68 20 f3 81 00       	push   $0x81f320
  802efe:	e8 52 27 00 00       	call   805655 <release_uspinlock>
  802f03:	83 c4 10             	add    $0x10,%esp
					return NULL;
  802f06:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0b:	e9 55 03 00 00       	jmp    803265 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802f10:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  802f18:	e9 39 03 00 00       	jmp    803256 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 40 04             	mov    0x4(%eax),%eax
  802f23:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f26:	0f 86 e7 01 00 00    	jbe    803113 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  802f2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2f:	8b 10                	mov    (%eax),%edx
  802f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f34:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  802f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f39:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3c:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802f3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f43:	75 14                	jne    802f59 <malloc+0x1f0>
  802f45:	83 ec 04             	sub    $0x4,%esp
  802f48:	68 98 67 80 00       	push   $0x806798
  802f4d:	6a 72                	push   $0x72
  802f4f:	68 4c 67 80 00       	push   $0x80674c
  802f54:	e8 29 eb ff ff       	call   801a82 <_panic>
  802f59:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f62:	89 50 0c             	mov    %edx,0xc(%eax)
  802f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f68:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6b:	85 c0                	test   %eax,%eax
  802f6d:	74 0d                	je     802f7c <malloc+0x213>
  802f6f:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802f74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f77:	89 50 08             	mov    %edx,0x8(%eax)
  802f7a:	eb 08                	jmp    802f84 <malloc+0x21b>
  802f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7f:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f87:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802f8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f96:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802f9b:	40                   	inc    %eax
  802f9c:	a3 1c f3 81 00       	mov    %eax,0x81f31c
                lastfreeelement->startva += size;
  802fa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa4:	8b 10                	mov    (%eax),%edx
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	01 c2                	add    %eax,%edx
  802fab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fae:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  802fb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb3:	8b 40 04             	mov    0x4(%eax),%eax
  802fb6:	2b 45 08             	sub    0x8(%ebp),%eax
  802fb9:	89 c2                	mov    %eax,%edx
  802fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fbe:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802fc1:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  802fc9:	e9 0d 01 00 00       	jmp    8030db <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  802fce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd1:	8b 50 04             	mov    0x4(%eax),%edx
  802fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd7:	8b 40 04             	mov    0x4(%eax),%eax
  802fda:	39 c2                	cmp    %eax,%edx
  802fdc:	0f 83 f0 00 00 00    	jae    8030d2 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802fe2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fe6:	75 14                	jne    802ffc <malloc+0x293>
  802fe8:	83 ec 04             	sub    $0x4,%esp
  802feb:	68 bb 67 80 00       	push   $0x8067bb
  802ff0:	6a 7a                	push   $0x7a
  802ff2:	68 4c 67 80 00       	push   $0x80674c
  802ff7:	e8 86 ea ff ff       	call   801a82 <_panic>
  802ffc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fff:	8b 40 08             	mov    0x8(%eax),%eax
  803002:	85 c0                	test   %eax,%eax
  803004:	74 11                	je     803017 <malloc+0x2ae>
  803006:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803009:	8b 40 08             	mov    0x8(%eax),%eax
  80300c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80300f:	8b 52 0c             	mov    0xc(%edx),%edx
  803012:	89 50 0c             	mov    %edx,0xc(%eax)
  803015:	eb 0b                	jmp    803022 <malloc+0x2b9>
  803017:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301a:	8b 40 0c             	mov    0xc(%eax),%eax
  80301d:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803022:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803025:	8b 40 0c             	mov    0xc(%eax),%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	74 11                	je     80303d <malloc+0x2d4>
  80302c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80302f:	8b 40 0c             	mov    0xc(%eax),%eax
  803032:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803035:	8b 52 08             	mov    0x8(%edx),%edx
  803038:	89 50 08             	mov    %edx,0x8(%eax)
  80303b:	eb 0b                	jmp    803048 <malloc+0x2df>
  80303d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803040:	8b 40 08             	mov    0x8(%eax),%eax
  803043:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803048:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803052:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803055:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80305c:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803061:	48                   	dec    %eax
  803062:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803067:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80306b:	74 06                	je     803073 <malloc+0x30a>
  80306d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803071:	75 14                	jne    803087 <malloc+0x31e>
  803073:	83 ec 04             	sub    $0x4,%esp
  803076:	68 dc 67 80 00       	push   $0x8067dc
  80307b:	6a 7b                	push   $0x7b
  80307d:	68 4c 67 80 00       	push   $0x80674c
  803082:	e8 fb e9 ff ff       	call   801a82 <_panic>
  803087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308a:	8b 50 0c             	mov    0xc(%eax),%edx
  80308d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803090:	89 50 0c             	mov    %edx,0xc(%eax)
  803093:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803096:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803099:	89 50 08             	mov    %edx,0x8(%eax)
  80309c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309f:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a2:	85 c0                	test   %eax,%eax
  8030a4:	74 0e                	je     8030b4 <malloc+0x34b>
  8030a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030af:	89 50 08             	mov    %edx,0x8(%eax)
  8030b2:	eb 08                	jmp    8030bc <malloc+0x353>
  8030b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b7:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8030bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030c2:	89 50 0c             	mov    %edx,0xc(%eax)
  8030c5:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8030ca:	40                   	inc    %eax
  8030cb:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		break;
  8030d0:	eb 13                	jmp    8030e5 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  8030d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d5:	8b 40 08             	mov    0x8(%eax),%eax
  8030d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  8030db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030df:	0f 85 e9 fe ff ff    	jne    802fce <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  8030e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e8:	8b 00                	mov    (%eax),%eax
  8030ea:	83 ec 08             	sub    $0x8,%esp
  8030ed:	ff 75 08             	pushl  0x8(%ebp)
  8030f0:	50                   	push   %eax
  8030f1:	e8 17 1a 00 00       	call   804b0d <sys_allocate_user_mem>
  8030f6:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  8030f9:	83 ec 0c             	sub    $0xc,%esp
  8030fc:	68 20 f3 81 00       	push   $0x81f320
  803101:	e8 4f 25 00 00       	call   805655 <release_uspinlock>
  803106:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  803109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310c:	8b 00                	mov    (%eax),%eax
  80310e:	e9 52 01 00 00       	jmp    803265 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 40 04             	mov    0x4(%eax),%eax
  803119:	3b 45 08             	cmp    0x8(%ebp),%eax
  80311c:	0f 85 2b 01 00 00    	jne    80324d <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 10                	mov    (%eax),%edx
  803127:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312a:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  80312c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312f:	8b 55 08             	mov    0x8(%ebp),%edx
  803132:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803135:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803139:	75 17                	jne    803152 <malloc+0x3e9>
  80313b:	83 ec 04             	sub    $0x4,%esp
  80313e:	68 98 67 80 00       	push   $0x806798
  803143:	68 89 00 00 00       	push   $0x89
  803148:	68 4c 67 80 00       	push   $0x80674c
  80314d:	e8 30 e9 ff ff       	call   801a82 <_panic>
  803152:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315b:	89 50 0c             	mov    %edx,0xc(%eax)
  80315e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803161:	8b 40 0c             	mov    0xc(%eax),%eax
  803164:	85 c0                	test   %eax,%eax
  803166:	74 0d                	je     803175 <malloc+0x40c>
  803168:	a1 14 f3 81 00       	mov    0x81f314,%eax
  80316d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803170:	89 50 08             	mov    %edx,0x8(%eax)
  803173:	eb 08                	jmp    80317d <malloc+0x414>
  803175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803178:	a3 10 f3 81 00       	mov    %eax,0x81f310
  80317d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803180:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803188:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80318f:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803194:	40                   	inc    %eax
  803195:	a3 1c f3 81 00       	mov    %eax,0x81f31c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  80319a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80319e:	75 17                	jne    8031b7 <malloc+0x44e>
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	68 bb 67 80 00       	push   $0x8067bb
  8031a8:	68 8a 00 00 00       	push   $0x8a
  8031ad:	68 4c 67 80 00       	push   $0x80674c
  8031b2:	e8 cb e8 ff ff       	call   801a82 <_panic>
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 40 08             	mov    0x8(%eax),%eax
  8031bd:	85 c0                	test   %eax,%eax
  8031bf:	74 11                	je     8031d2 <malloc+0x469>
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	8b 40 08             	mov    0x8(%eax),%eax
  8031c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ca:	8b 52 0c             	mov    0xc(%edx),%edx
  8031cd:	89 50 0c             	mov    %edx,0xc(%eax)
  8031d0:	eb 0b                	jmp    8031dd <malloc+0x474>
  8031d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d8:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8031dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e3:	85 c0                	test   %eax,%eax
  8031e5:	74 11                	je     8031f8 <malloc+0x48f>
  8031e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f0:	8b 52 08             	mov    0x8(%edx),%edx
  8031f3:	89 50 08             	mov    %edx,0x8(%eax)
  8031f6:	eb 0b                	jmp    803203 <malloc+0x49a>
  8031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fb:	8b 40 08             	mov    0x8(%eax),%eax
  8031fe:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803217:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80321c:	48                   	dec    %eax
  80321d:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				sys_allocate_user_mem(allocblock->startva ,size);
  803222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803225:	8b 00                	mov    (%eax),%eax
  803227:	83 ec 08             	sub    $0x8,%esp
  80322a:	ff 75 08             	pushl  0x8(%ebp)
  80322d:	50                   	push   %eax
  80322e:	e8 da 18 00 00       	call   804b0d <sys_allocate_user_mem>
  803233:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  803236:	83 ec 0c             	sub    $0xc,%esp
  803239:	68 20 f3 81 00       	push   $0x81f320
  80323e:	e8 12 24 00 00       	call   805655 <release_uspinlock>
  803243:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  803246:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803249:	8b 00                	mov    (%eax),%eax
  80324b:	eb 18                	jmp    803265 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 40 08             	mov    0x8(%eax),%eax
  803253:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  803256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325a:	0f 85 bd fc ff ff    	jne    802f1d <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  803260:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803265:	c9                   	leave  
  803266:	c3                   	ret    

00803267 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  803267:	55                   	push   %ebp
  803268:	89 e5                	mov    %esp,%ebp
  80326a:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803273:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803276:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80327b:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  80327e:	e8 b2 f9 ff ff       	call   802c35 <uheap_init>
		acquire_uspinlock(&ulock);
  803283:	83 ec 0c             	sub    $0xc,%esp
  803286:	68 20 f3 81 00       	push   $0x81f320
  80328b:	e8 6d 23 00 00       	call   8055fd <acquire_uspinlock>
  803290:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  803293:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803298:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80329b:	73 23                	jae    8032c0 <free+0x59>
			free_block(virtual_address);
  80329d:	83 ec 0c             	sub    $0xc,%esp
  8032a0:	ff 75 08             	pushl  0x8(%ebp)
  8032a3:	e8 89 1f 00 00       	call   805231 <free_block>
  8032a8:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  8032ab:	83 ec 0c             	sub    $0xc,%esp
  8032ae:	68 20 f3 81 00       	push   $0x81f320
  8032b3:	e8 9d 23 00 00       	call   805655 <release_uspinlock>
  8032b8:	83 c4 10             	add    $0x10,%esp
			return;
  8032bb:	e9 35 07 00 00       	jmp    8039f5 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  8032c0:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8032c5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8032c8:	72 30                	jb     8032fa <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  8032ca:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8032cf:	83 ec 04             	sub    $0x4,%esp
  8032d2:	50                   	push   %eax
  8032d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8032d6:	68 11 68 80 00       	push   $0x806811
  8032db:	e8 70 ea ff ff       	call   801d50 <cprintf>
  8032e0:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  8032e3:	83 ec 04             	sub    $0x4,%esp
  8032e6:	68 19 68 80 00       	push   $0x806819
  8032eb:	68 a7 00 00 00       	push   $0xa7
  8032f0:	68 4c 67 80 00       	push   $0x80674c
  8032f5:	e8 88 e7 ff ff       	call   801a82 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8032fa:	83 ec 0c             	sub    $0xc,%esp
  8032fd:	6a 10                	push   $0x10
  8032ff:	e8 91 1a 00 00       	call   804d95 <alloc_block>
  803304:	83 c4 10             	add    $0x10,%esp
  803307:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  80330a:	83 ec 0c             	sub    $0xc,%esp
  80330d:	6a 10                	push   $0x10
  80330f:	e8 81 1a 00 00       	call   804d95 <alloc_block>
  803314:	83 c4 10             	add    $0x10,%esp
  803317:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  80331a:	a1 10 f3 81 00       	mov    0x81f310,%eax
  80331f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  803322:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  803329:	eb 1c                	jmp    803347 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  80332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332e:	8b 00                	mov    (%eax),%eax
  803330:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803333:	75 09                	jne    80333e <free+0xd7>
				foundVA = 1;
  803335:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  80333c:	eb 0f                	jmp    80334d <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  80333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803341:	8b 40 08             	mov    0x8(%eax),%eax
  803344:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  803347:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80334b:	75 de                	jne    80332b <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  80334d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803351:	75 17                	jne    80336a <free+0x103>
				panic("INVALID ADDRESS!");
  803353:	83 ec 04             	sub    $0x4,%esp
  803356:	68 36 68 80 00       	push   $0x806836
  80335b:	68 be 00 00 00       	push   $0xbe
  803360:	68 4c 67 80 00       	push   $0x80674c
  803365:	e8 18 e7 ff ff       	call   801a82 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  80336a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336d:	8b 10                	mov    (%eax),%edx
  80336f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803372:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  803374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803377:	8b 50 04             	mov    0x4(%eax),%edx
  80337a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337d:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  803380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803384:	75 17                	jne    80339d <free+0x136>
  803386:	83 ec 04             	sub    $0x4,%esp
  803389:	68 bb 67 80 00       	push   $0x8067bb
  80338e:	68 c8 00 00 00       	push   $0xc8
  803393:	68 4c 67 80 00       	push   $0x80674c
  803398:	e8 e5 e6 ff ff       	call   801a82 <_panic>
  80339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a0:	8b 40 08             	mov    0x8(%eax),%eax
  8033a3:	85 c0                	test   %eax,%eax
  8033a5:	74 11                	je     8033b8 <free+0x151>
  8033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033aa:	8b 40 08             	mov    0x8(%eax),%eax
  8033ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033b0:	8b 52 0c             	mov    0xc(%edx),%edx
  8033b3:	89 50 0c             	mov    %edx,0xc(%eax)
  8033b6:	eb 0b                	jmp    8033c3 <free+0x15c>
  8033b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033be:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	74 11                	je     8033de <free+0x177>
  8033cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d6:	8b 52 08             	mov    0x8(%edx),%edx
  8033d9:	89 50 08             	mov    %edx,0x8(%eax)
  8033dc:	eb 0b                	jmp    8033e9 <free+0x182>
  8033de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e1:	8b 40 08             	mov    0x8(%eax),%eax
  8033e4:	a3 10 f3 81 00       	mov    %eax,0x81f310
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8033fd:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803402:	48                   	dec    %eax
  803403:	a3 1c f3 81 00       	mov    %eax,0x81f31c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  803408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340b:	8b 50 04             	mov    0x4(%eax),%edx
  80340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803411:	8b 00                	mov    (%eax),%eax
  803413:	83 ec 08             	sub    $0x8,%esp
  803416:	52                   	push   %edx
  803417:	50                   	push   %eax
  803418:	e8 d4 16 00 00       	call   804af1 <sys_free_user_mem>
  80341d:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  803420:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803425:	85 c0                	test   %eax,%eax
  803427:	75 7a                	jne    8034a3 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  803429:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80342d:	75 17                	jne    803446 <free+0x1df>
  80342f:	83 ec 04             	sub    $0x4,%esp
  803432:	68 48 68 80 00       	push   $0x806848
  803437:	68 d0 00 00 00       	push   $0xd0
  80343c:	68 4c 67 80 00       	push   $0x80674c
  803441:	e8 3c e6 ff ff       	call   801a82 <_panic>
  803446:	8b 15 00 f3 81 00    	mov    0x81f300,%edx
  80344c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344f:	89 50 08             	mov    %edx,0x8(%eax)
  803452:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803455:	8b 40 08             	mov    0x8(%eax),%eax
  803458:	85 c0                	test   %eax,%eax
  80345a:	74 0d                	je     803469 <free+0x202>
  80345c:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803461:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803464:	89 50 0c             	mov    %edx,0xc(%eax)
  803467:	eb 08                	jmp    803471 <free+0x20a>
  803469:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346c:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803471:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803474:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803479:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803483:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803488:	40                   	inc    %eax
  803489:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			release_uspinlock(&ulock);
  80348e:	83 ec 0c             	sub    $0xc,%esp
  803491:	68 20 f3 81 00       	push   $0x81f320
  803496:	e8 ba 21 00 00       	call   805655 <release_uspinlock>
  80349b:	83 c4 10             	add    $0x10,%esp
			return;
  80349e:	e9 52 05 00 00       	jmp    8039f5 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  8034a3:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8034a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  8034ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  8034b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  8034b9:	e9 d2 00 00 00       	jmp    803590 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  8034be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c1:	8b 10                	mov    (%eax),%edx
  8034c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c6:	8b 40 04             	mov    0x4(%eax),%eax
  8034c9:	01 c2                	add    %eax,%edx
  8034cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ce:	8b 00                	mov    (%eax),%eax
  8034d0:	39 c2                	cmp    %eax,%edx
  8034d2:	0f 85 af 00 00 00    	jne    803587 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  8034d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034db:	8b 10                	mov    (%eax),%edx
  8034dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034e0:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  8034e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e5:	8b 50 04             	mov    0x4(%eax),%edx
  8034e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034eb:	8b 40 04             	mov    0x4(%eax),%eax
  8034ee:	01 c2                	add    %eax,%edx
  8034f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034f3:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  8034f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034fa:	75 17                	jne    803513 <free+0x2ac>
  8034fc:	83 ec 04             	sub    $0x4,%esp
  8034ff:	68 bb 67 80 00       	push   $0x8067bb
  803504:	68 df 00 00 00       	push   $0xdf
  803509:	68 4c 67 80 00       	push   $0x80674c
  80350e:	e8 6f e5 ff ff       	call   801a82 <_panic>
  803513:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803516:	8b 40 08             	mov    0x8(%eax),%eax
  803519:	85 c0                	test   %eax,%eax
  80351b:	74 11                	je     80352e <free+0x2c7>
  80351d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803520:	8b 40 08             	mov    0x8(%eax),%eax
  803523:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803526:	8b 52 0c             	mov    0xc(%edx),%edx
  803529:	89 50 0c             	mov    %edx,0xc(%eax)
  80352c:	eb 0b                	jmp    803539 <free+0x2d2>
  80352e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803531:	8b 40 0c             	mov    0xc(%eax),%eax
  803534:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353c:	8b 40 0c             	mov    0xc(%eax),%eax
  80353f:	85 c0                	test   %eax,%eax
  803541:	74 11                	je     803554 <free+0x2ed>
  803543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803546:	8b 40 0c             	mov    0xc(%eax),%eax
  803549:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80354c:	8b 52 08             	mov    0x8(%edx),%edx
  80354f:	89 50 08             	mov    %edx,0x8(%eax)
  803552:	eb 0b                	jmp    80355f <free+0x2f8>
  803554:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803557:	8b 40 08             	mov    0x8(%eax),%eax
  80355a:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80355f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803562:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803573:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803578:	48                   	dec    %eax
  803579:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				mergeprev = 1;
  80357e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  803585:	eb 13                	jmp    80359a <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  803587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358a:	8b 40 08             	mov    0x8(%eax),%eax
  80358d:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  803590:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803594:	0f 85 24 ff ff ff    	jne    8034be <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  80359a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359d:	8b 10                	mov    (%eax),%edx
  80359f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a2:	8b 40 04             	mov    0x4(%eax),%eax
  8035a5:	01 c2                	add    %eax,%edx
  8035a7:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8035ac:	39 c2                	cmp    %eax,%edx
  8035ae:	75 44                	jne    8035f4 <free+0x38d>

			if(mergeprev){
  8035b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035b4:	74 1f                	je     8035d5 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  8035b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035b9:	8b 00                	mov    (%eax),%eax
  8035bb:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  8035c0:	83 ec 0c             	sub    $0xc,%esp
  8035c3:	68 20 f3 81 00       	push   $0x81f320
  8035c8:	e8 88 20 00 00       	call   805655 <release_uspinlock>
  8035cd:	83 c4 10             	add    $0x10,%esp
				return;
  8035d0:	e9 20 04 00 00       	jmp    8039f5 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  8035d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d8:	8b 00                	mov    (%eax),%eax
  8035da:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  8035df:	83 ec 0c             	sub    $0xc,%esp
  8035e2:	68 20 f3 81 00       	push   $0x81f320
  8035e7:	e8 69 20 00 00       	call   805655 <release_uspinlock>
  8035ec:	83 c4 10             	add    $0x10,%esp
				return;
  8035ef:	e9 01 04 00 00       	jmp    8039f5 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  8035f4:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8035f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  8035fc:	e9 7d 01 00 00       	jmp    80377e <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  803601:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803604:	8b 10                	mov    (%eax),%edx
  803606:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803609:	8b 40 04             	mov    0x4(%eax),%eax
  80360c:	01 c2                	add    %eax,%edx
  80360e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803611:	8b 00                	mov    (%eax),%eax
  803613:	39 c2                	cmp    %eax,%edx
  803615:	0f 85 5a 01 00 00    	jne    803775 <free+0x50e>
				if (mergeprev){
  80361b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80361f:	0f 84 a1 00 00 00    	je     8036c6 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  803625:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803628:	8b 50 04             	mov    0x4(%eax),%edx
  80362b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80362e:	8b 40 04             	mov    0x4(%eax),%eax
  803631:	01 c2                	add    %eax,%edx
  803633:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803636:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  803639:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80363d:	75 17                	jne    803656 <free+0x3ef>
  80363f:	83 ec 04             	sub    $0x4,%esp
  803642:	68 bb 67 80 00       	push   $0x8067bb
  803647:	68 0a 01 00 00       	push   $0x10a
  80364c:	68 4c 67 80 00       	push   $0x80674c
  803651:	e8 2c e4 ff ff       	call   801a82 <_panic>
  803656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803659:	8b 40 08             	mov    0x8(%eax),%eax
  80365c:	85 c0                	test   %eax,%eax
  80365e:	74 11                	je     803671 <free+0x40a>
  803660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803663:	8b 40 08             	mov    0x8(%eax),%eax
  803666:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803669:	8b 52 0c             	mov    0xc(%edx),%edx
  80366c:	89 50 0c             	mov    %edx,0xc(%eax)
  80366f:	eb 0b                	jmp    80367c <free+0x415>
  803671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803674:	8b 40 0c             	mov    0xc(%eax),%eax
  803677:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80367c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80367f:	8b 40 0c             	mov    0xc(%eax),%eax
  803682:	85 c0                	test   %eax,%eax
  803684:	74 11                	je     803697 <free+0x430>
  803686:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803689:	8b 40 0c             	mov    0xc(%eax),%eax
  80368c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80368f:	8b 52 08             	mov    0x8(%edx),%edx
  803692:	89 50 08             	mov    %edx,0x8(%eax)
  803695:	eb 0b                	jmp    8036a2 <free+0x43b>
  803697:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80369a:	8b 40 08             	mov    0x8(%eax),%eax
  80369d:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8036a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8036ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8036b6:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8036bb:	48                   	dec    %eax
  8036bc:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					break;
  8036c1:	e9 c2 00 00 00       	jmp    803788 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8036c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c9:	8b 10                	mov    (%eax),%edx
  8036cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036ce:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  8036d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d3:	8b 50 04             	mov    0x4(%eax),%edx
  8036d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d9:	8b 40 04             	mov    0x4(%eax),%eax
  8036dc:	01 c2                	add    %eax,%edx
  8036de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036e1:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8036e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036e8:	75 17                	jne    803701 <free+0x49a>
  8036ea:	83 ec 04             	sub    $0x4,%esp
  8036ed:	68 bb 67 80 00       	push   $0x8067bb
  8036f2:	68 10 01 00 00       	push   $0x110
  8036f7:	68 4c 67 80 00       	push   $0x80674c
  8036fc:	e8 81 e3 ff ff       	call   801a82 <_panic>
  803701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803704:	8b 40 08             	mov    0x8(%eax),%eax
  803707:	85 c0                	test   %eax,%eax
  803709:	74 11                	je     80371c <free+0x4b5>
  80370b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80370e:	8b 40 08             	mov    0x8(%eax),%eax
  803711:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803714:	8b 52 0c             	mov    0xc(%edx),%edx
  803717:	89 50 0c             	mov    %edx,0xc(%eax)
  80371a:	eb 0b                	jmp    803727 <free+0x4c0>
  80371c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80371f:	8b 40 0c             	mov    0xc(%eax),%eax
  803722:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372a:	8b 40 0c             	mov    0xc(%eax),%eax
  80372d:	85 c0                	test   %eax,%eax
  80372f:	74 11                	je     803742 <free+0x4db>
  803731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803734:	8b 40 0c             	mov    0xc(%eax),%eax
  803737:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80373a:	8b 52 08             	mov    0x8(%edx),%edx
  80373d:	89 50 08             	mov    %edx,0x8(%eax)
  803740:	eb 0b                	jmp    80374d <free+0x4e6>
  803742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803745:	8b 40 08             	mov    0x8(%eax),%eax
  803748:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80374d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803750:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803757:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80375a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803761:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803766:	48                   	dec    %eax
  803767:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					mergenext = 1;
  80376c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  803773:	eb 13                	jmp    803788 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  803775:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803778:	8b 40 08             	mov    0x8(%eax),%eax
  80377b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  80377e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803782:	0f 85 79 fe ff ff    	jne    803601 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  803788:	a1 00 f3 81 00       	mov    0x81f300,%eax
  80378d:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  803790:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803794:	0f 85 ad 00 00 00    	jne    803847 <free+0x5e0>
  80379a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80379e:	0f 84 c3 01 00 00    	je     803967 <free+0x700>
				while(currentfree != NULL){
  8037a4:	e9 9e 00 00 00       	jmp    803847 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8037a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037ac:	8b 50 04             	mov    0x4(%eax),%edx
  8037af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b2:	8b 40 04             	mov    0x4(%eax),%eax
  8037b5:	39 c2                	cmp    %eax,%edx
  8037b7:	0f 83 81 00 00 00    	jae    80383e <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8037bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8037c1:	74 06                	je     8037c9 <free+0x562>
  8037c3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8037c7:	75 17                	jne    8037e0 <free+0x579>
  8037c9:	83 ec 04             	sub    $0x4,%esp
  8037cc:	68 dc 67 80 00       	push   $0x8067dc
  8037d1:	68 23 01 00 00       	push   $0x123
  8037d6:	68 4c 67 80 00       	push   $0x80674c
  8037db:	e8 a2 e2 ff ff       	call   801a82 <_panic>
  8037e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8037e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037e9:	89 50 0c             	mov    %edx,0xc(%eax)
  8037ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037f2:	89 50 08             	mov    %edx,0x8(%eax)
  8037f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8037fb:	85 c0                	test   %eax,%eax
  8037fd:	74 0e                	je     80380d <free+0x5a6>
  8037ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803802:	8b 40 0c             	mov    0xc(%eax),%eax
  803805:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803808:	89 50 08             	mov    %edx,0x8(%eax)
  80380b:	eb 08                	jmp    803815 <free+0x5ae>
  80380d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803810:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803815:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803818:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80381b:	89 50 0c             	mov    %edx,0xc(%eax)
  80381e:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803823:	40                   	inc    %eax
  803824:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  803829:	83 ec 0c             	sub    $0xc,%esp
  80382c:	68 20 f3 81 00       	push   $0x81f320
  803831:	e8 1f 1e 00 00       	call   805655 <release_uspinlock>
  803836:	83 c4 10             	add    $0x10,%esp
							return;
  803839:	e9 b7 01 00 00       	jmp    8039f5 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80383e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803841:	8b 40 08             	mov    0x8(%eax),%eax
  803844:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  803847:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80384b:	0f 85 58 ff ff ff    	jne    8037a9 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  803851:	83 ec 0c             	sub    $0xc,%esp
  803854:	ff 75 d4             	pushl  -0x2c(%ebp)
  803857:	e8 d5 19 00 00       	call   805231 <free_block>
  80385c:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  80385f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803863:	75 17                	jne    80387c <free+0x615>
  803865:	83 ec 04             	sub    $0x4,%esp
  803868:	68 98 67 80 00       	push   $0x806798
  80386d:	68 2a 01 00 00       	push   $0x12a
  803872:	68 4c 67 80 00       	push   $0x80674c
  803877:	e8 06 e2 ff ff       	call   801a82 <_panic>
  80387c:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  803882:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803885:	89 50 0c             	mov    %edx,0xc(%eax)
  803888:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80388b:	8b 40 0c             	mov    0xc(%eax),%eax
  80388e:	85 c0                	test   %eax,%eax
  803890:	74 0d                	je     80389f <free+0x638>
  803892:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803897:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80389a:	89 50 08             	mov    %edx,0x8(%eax)
  80389d:	eb 08                	jmp    8038a7 <free+0x640>
  80389f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038a2:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8038a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038aa:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8038af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8038b9:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8038be:	40                   	inc    %eax
  8038bf:	a3 0c f3 81 00       	mov    %eax,0x81f30c
  8038c4:	e9 1b 01 00 00       	jmp    8039e4 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8038c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038cc:	8b 50 04             	mov    0x4(%eax),%edx
  8038cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038d2:	8b 40 04             	mov    0x4(%eax),%eax
  8038d5:	39 c2                	cmp    %eax,%edx
  8038d7:	0f 83 81 00 00 00    	jae    80395e <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8038dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8038e1:	74 06                	je     8038e9 <free+0x682>
  8038e3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038e7:	75 17                	jne    803900 <free+0x699>
  8038e9:	83 ec 04             	sub    $0x4,%esp
  8038ec:	68 dc 67 80 00       	push   $0x8067dc
  8038f1:	68 30 01 00 00       	push   $0x130
  8038f6:	68 4c 67 80 00       	push   $0x80674c
  8038fb:	e8 82 e1 ff ff       	call   801a82 <_panic>
  803900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803903:	8b 50 0c             	mov    0xc(%eax),%edx
  803906:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803909:	89 50 0c             	mov    %edx,0xc(%eax)
  80390c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80390f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803912:	89 50 08             	mov    %edx,0x8(%eax)
  803915:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803918:	8b 40 0c             	mov    0xc(%eax),%eax
  80391b:	85 c0                	test   %eax,%eax
  80391d:	74 0e                	je     80392d <free+0x6c6>
  80391f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803922:	8b 40 0c             	mov    0xc(%eax),%eax
  803925:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803928:	89 50 08             	mov    %edx,0x8(%eax)
  80392b:	eb 08                	jmp    803935 <free+0x6ce>
  80392d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803930:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803935:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803938:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80393b:	89 50 0c             	mov    %edx,0xc(%eax)
  80393e:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803943:	40                   	inc    %eax
  803944:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  803949:	83 ec 0c             	sub    $0xc,%esp
  80394c:	68 20 f3 81 00       	push   $0x81f320
  803951:	e8 ff 1c 00 00       	call   805655 <release_uspinlock>
  803956:	83 c4 10             	add    $0x10,%esp
							return;
  803959:	e9 97 00 00 00       	jmp    8039f5 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80395e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803961:	8b 40 08             	mov    0x8(%eax),%eax
  803964:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  803967:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80396b:	0f 85 58 ff ff ff    	jne    8038c9 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  803971:	83 ec 0c             	sub    $0xc,%esp
  803974:	ff 75 d0             	pushl  -0x30(%ebp)
  803977:	e8 b5 18 00 00       	call   805231 <free_block>
  80397c:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  80397f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803983:	75 17                	jne    80399c <free+0x735>
  803985:	83 ec 04             	sub    $0x4,%esp
  803988:	68 98 67 80 00       	push   $0x806798
  80398d:	68 37 01 00 00       	push   $0x137
  803992:	68 4c 67 80 00       	push   $0x80674c
  803997:	e8 e6 e0 ff ff       	call   801a82 <_panic>
  80399c:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  8039a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a5:	89 50 0c             	mov    %edx,0xc(%eax)
  8039a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ae:	85 c0                	test   %eax,%eax
  8039b0:	74 0d                	je     8039bf <free+0x758>
  8039b2:	a1 04 f3 81 00       	mov    0x81f304,%eax
  8039b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039ba:	89 50 08             	mov    %edx,0x8(%eax)
  8039bd:	eb 08                	jmp    8039c7 <free+0x760>
  8039bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039c2:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8039c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ca:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8039cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8039d9:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8039de:	40                   	inc    %eax
  8039df:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			}
		release_uspinlock(&ulock);
  8039e4:	83 ec 0c             	sub    $0xc,%esp
  8039e7:	68 20 f3 81 00       	push   $0x81f320
  8039ec:	e8 64 1c 00 00       	call   805655 <release_uspinlock>
  8039f1:	83 c4 10             	add    $0x10,%esp
		return;
  8039f4:	90                   	nop
}
  8039f5:	c9                   	leave  
  8039f6:	c3                   	ret    

008039f7 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8039f7:	55                   	push   %ebp
  8039f8:	89 e5                	mov    %esp,%ebp
  8039fa:	83 ec 48             	sub    $0x48,%esp
  8039fd:	8b 45 10             	mov    0x10(%ebp),%eax
  803a00:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803a03:	e8 2d f2 ff ff       	call   802c35 <uheap_init>
	if (size == 0) return NULL;
  803a08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a0c:	75 0a                	jne    803a18 <smalloc+0x21>
  803a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a13:	e9 84 05 00 00       	jmp    803f9c <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  803a18:	83 ec 0c             	sub    $0xc,%esp
  803a1b:	68 20 f3 81 00       	push   $0x81f320
  803a20:	e8 d8 1b 00 00       	call   8055fd <acquire_uspinlock>
  803a25:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803a28:	83 ec 0c             	sub    $0xc,%esp
  803a2b:	6a 10                	push   $0x10
  803a2d:	e8 63 13 00 00       	call   804d95 <alloc_block>
  803a32:	83 c4 10             	add    $0x10,%esp
  803a35:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  803a38:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a3c:	75 0a                	jne    803a48 <smalloc+0x51>
				return NULL;
  803a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a43:	e9 54 05 00 00       	jmp    803f9c <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  803a48:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a55:	01 d0                	add    %edx,%eax
  803a57:	48                   	dec    %eax
  803a58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5e:	ba 00 00 00 00       	mov    $0x0,%edx
  803a63:	f7 75 e8             	divl   -0x18(%ebp)
  803a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a69:	29 d0                	sub    %edx,%eax
  803a6b:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803a6e:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803a73:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  803a76:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803a7b:	85 c0                	test   %eax,%eax
  803a7d:	74 0f                	je     803a8e <smalloc+0x97>
  803a7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a82:	8b 40 04             	mov    0x4(%eax),%eax
  803a85:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a88:	0f 83 25 01 00 00    	jae    803bb3 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  803a8e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  803a93:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a96:	89 c2                	mov    %eax,%edx
  803a98:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803a9d:	39 c2                	cmp    %eax,%edx
  803a9f:	0f 82 f4 00 00 00    	jb     803b99 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  803aa5:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803aaa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  803aad:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ab6:	01 d0                	add    %edx,%eax
  803ab8:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  803abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ac3:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  803acb:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  803ace:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ad2:	75 17                	jne    803aeb <smalloc+0xf4>
  803ad4:	83 ec 04             	sub    $0x4,%esp
  803ad7:	68 98 67 80 00       	push   $0x806798
  803adc:	68 57 01 00 00       	push   $0x157
  803ae1:	68 4c 67 80 00       	push   $0x80674c
  803ae6:	e8 97 df ff ff       	call   801a82 <_panic>
  803aeb:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af4:	89 50 0c             	mov    %edx,0xc(%eax)
  803af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803afa:	8b 40 0c             	mov    0xc(%eax),%eax
  803afd:	85 c0                	test   %eax,%eax
  803aff:	74 0d                	je     803b0e <smalloc+0x117>
  803b01:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803b06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b09:	89 50 08             	mov    %edx,0x8(%eax)
  803b0c:	eb 08                	jmp    803b16 <smalloc+0x11f>
  803b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b11:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b19:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803b28:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803b2d:	40                   	inc    %eax
  803b2e:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b36:	8b 00                	mov    (%eax),%eax
  803b38:	89 c2                	mov    %eax,%edx
  803b3a:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803b3e:	52                   	push   %edx
  803b3f:	50                   	push   %eax
  803b40:	ff 75 0c             	pushl  0xc(%ebp)
  803b43:	ff 75 08             	pushl  0x8(%ebp)
  803b46:	e8 48 0c 00 00       	call   804793 <sys_create_shared_object>
  803b4b:	83 c4 10             	add    $0x10,%esp
  803b4e:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  803b51:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b55:	79 28                	jns    803b7f <smalloc+0x188>
							free_block(allocblock);
  803b57:	83 ec 0c             	sub    $0xc,%esp
  803b5a:	ff 75 ec             	pushl  -0x14(%ebp)
  803b5d:	e8 cf 16 00 00       	call   805231 <free_block>
  803b62:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803b65:	83 ec 0c             	sub    $0xc,%esp
  803b68:	68 20 f3 81 00       	push   $0x81f320
  803b6d:	e8 e3 1a 00 00       	call   805655 <release_uspinlock>
  803b72:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803b75:	b8 00 00 00 00       	mov    $0x0,%eax
  803b7a:	e9 1d 04 00 00       	jmp    803f9c <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  803b7f:	83 ec 0c             	sub    $0xc,%esp
  803b82:	68 20 f3 81 00       	push   $0x81f320
  803b87:	e8 c9 1a 00 00       	call   805655 <release_uspinlock>
  803b8c:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b92:	8b 00                	mov    (%eax),%eax
  803b94:	e9 03 04 00 00       	jmp    803f9c <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  803b99:	83 ec 0c             	sub    $0xc,%esp
  803b9c:	68 20 f3 81 00       	push   $0x81f320
  803ba1:	e8 af 1a 00 00       	call   805655 <release_uspinlock>
  803ba6:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bae:	e9 e9 03 00 00       	jmp    803f9c <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803bb3:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803bbb:	e9 af 03 00 00       	jmp    803f6f <smalloc+0x578>
				if(size<currentfreeelement->size){
  803bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc3:	8b 40 04             	mov    0x4(%eax),%eax
  803bc6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803bc9:	0f 86 28 02 00 00    	jbe    803df7 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  803bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bd2:	8b 10                	mov    (%eax),%edx
  803bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd7:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  803bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bdf:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803be2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803be6:	75 17                	jne    803bff <smalloc+0x208>
  803be8:	83 ec 04             	sub    $0x4,%esp
  803beb:	68 98 67 80 00       	push   $0x806798
  803bf0:	68 6f 01 00 00       	push   $0x16f
  803bf5:	68 4c 67 80 00       	push   $0x80674c
  803bfa:	e8 83 de ff ff       	call   801a82 <_panic>
  803bff:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c08:	89 50 0c             	mov    %edx,0xc(%eax)
  803c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c0e:	8b 40 0c             	mov    0xc(%eax),%eax
  803c11:	85 c0                	test   %eax,%eax
  803c13:	74 0d                	je     803c22 <smalloc+0x22b>
  803c15:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803c1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c1d:	89 50 08             	mov    %edx,0x8(%eax)
  803c20:	eb 08                	jmp    803c2a <smalloc+0x233>
  803c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c25:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c2d:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803c3c:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803c41:	40                   	inc    %eax
  803c42:	a3 1c f3 81 00       	mov    %eax,0x81f31c
	                lastfreeelement->startva += size;
  803c47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c4a:	8b 10                	mov    (%eax),%edx
  803c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c4f:	01 c2                	add    %eax,%edx
  803c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c54:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  803c56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c59:	8b 40 04             	mov    0x4(%eax),%eax
  803c5c:	2b 45 0c             	sub    0xc(%ebp),%eax
  803c5f:	89 c2                	mov    %eax,%edx
  803c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c64:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803c67:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803c6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  803c6f:	e9 13 01 00 00       	jmp    803d87 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  803c74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c77:	8b 50 04             	mov    0x4(%eax),%edx
  803c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c7d:	8b 40 04             	mov    0x4(%eax),%eax
  803c80:	39 c2                	cmp    %eax,%edx
  803c82:	0f 83 f6 00 00 00    	jae    803d7e <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  803c88:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c8c:	75 17                	jne    803ca5 <smalloc+0x2ae>
  803c8e:	83 ec 04             	sub    $0x4,%esp
  803c91:	68 bb 67 80 00       	push   $0x8067bb
  803c96:	68 77 01 00 00       	push   $0x177
  803c9b:	68 4c 67 80 00       	push   $0x80674c
  803ca0:	e8 dd dd ff ff       	call   801a82 <_panic>
  803ca5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ca8:	8b 40 08             	mov    0x8(%eax),%eax
  803cab:	85 c0                	test   %eax,%eax
  803cad:	74 11                	je     803cc0 <smalloc+0x2c9>
  803caf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cb2:	8b 40 08             	mov    0x8(%eax),%eax
  803cb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cb8:	8b 52 0c             	mov    0xc(%edx),%edx
  803cbb:	89 50 0c             	mov    %edx,0xc(%eax)
  803cbe:	eb 0b                	jmp    803ccb <smalloc+0x2d4>
  803cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  803cc6:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803ccb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cce:	8b 40 0c             	mov    0xc(%eax),%eax
  803cd1:	85 c0                	test   %eax,%eax
  803cd3:	74 11                	je     803ce6 <smalloc+0x2ef>
  803cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cd8:	8b 40 0c             	mov    0xc(%eax),%eax
  803cdb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cde:	8b 52 08             	mov    0x8(%edx),%edx
  803ce1:	89 50 08             	mov    %edx,0x8(%eax)
  803ce4:	eb 0b                	jmp    803cf1 <smalloc+0x2fa>
  803ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ce9:	8b 40 08             	mov    0x8(%eax),%eax
  803cec:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803cf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cf4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cfe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803d05:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803d0a:	48                   	dec    %eax
  803d0b:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803d10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d14:	74 06                	je     803d1c <smalloc+0x325>
  803d16:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d1a:	75 17                	jne    803d33 <smalloc+0x33c>
  803d1c:	83 ec 04             	sub    $0x4,%esp
  803d1f:	68 dc 67 80 00       	push   $0x8067dc
  803d24:	68 78 01 00 00       	push   $0x178
  803d29:	68 4c 67 80 00       	push   $0x80674c
  803d2e:	e8 4f dd ff ff       	call   801a82 <_panic>
  803d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d36:	8b 50 0c             	mov    0xc(%eax),%edx
  803d39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d3c:	89 50 0c             	mov    %edx,0xc(%eax)
  803d3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d45:	89 50 08             	mov    %edx,0x8(%eax)
  803d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d4b:	8b 40 0c             	mov    0xc(%eax),%eax
  803d4e:	85 c0                	test   %eax,%eax
  803d50:	74 0e                	je     803d60 <smalloc+0x369>
  803d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d55:	8b 40 0c             	mov    0xc(%eax),%eax
  803d58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d5b:	89 50 08             	mov    %edx,0x8(%eax)
  803d5e:	eb 08                	jmp    803d68 <smalloc+0x371>
  803d60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d63:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d6e:	89 50 0c             	mov    %edx,0xc(%eax)
  803d71:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803d76:	40                   	inc    %eax
  803d77:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		break;
  803d7c:	eb 13                	jmp    803d91 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  803d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d81:	8b 40 08             	mov    0x8(%eax),%eax
  803d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  803d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d8b:	0f 85 e3 fe ff ff    	jne    803c74 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d94:	8b 00                	mov    (%eax),%eax
  803d96:	89 c2                	mov    %eax,%edx
  803d98:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803d9c:	52                   	push   %edx
  803d9d:	50                   	push   %eax
  803d9e:	ff 75 0c             	pushl  0xc(%ebp)
  803da1:	ff 75 08             	pushl  0x8(%ebp)
  803da4:	e8 ea 09 00 00       	call   804793 <sys_create_shared_object>
  803da9:	83 c4 10             	add    $0x10,%esp
  803dac:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  803daf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803db3:	79 28                	jns    803ddd <smalloc+0x3e6>
	                	free_block(allocblock);
  803db5:	83 ec 0c             	sub    $0xc,%esp
  803db8:	ff 75 ec             	pushl  -0x14(%ebp)
  803dbb:	e8 71 14 00 00       	call   805231 <free_block>
  803dc0:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  803dc3:	83 ec 0c             	sub    $0xc,%esp
  803dc6:	68 20 f3 81 00       	push   $0x81f320
  803dcb:	e8 85 18 00 00       	call   805655 <release_uspinlock>
  803dd0:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  803dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd8:	e9 bf 01 00 00       	jmp    803f9c <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  803ddd:	83 ec 0c             	sub    $0xc,%esp
  803de0:	68 20 f3 81 00       	push   $0x81f320
  803de5:	e8 6b 18 00 00       	call   805655 <release_uspinlock>
  803dea:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  803ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803df0:	8b 00                	mov    (%eax),%eax
  803df2:	e9 a5 01 00 00       	jmp    803f9c <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  803df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfa:	8b 40 04             	mov    0x4(%eax),%eax
  803dfd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803e00:	0f 85 60 01 00 00    	jne    803f66 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  803e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e09:	8b 10                	mov    (%eax),%edx
  803e0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e0e:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e13:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e16:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803e19:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e1d:	75 17                	jne    803e36 <smalloc+0x43f>
  803e1f:	83 ec 04             	sub    $0x4,%esp
  803e22:	68 98 67 80 00       	push   $0x806798
  803e27:	68 8c 01 00 00       	push   $0x18c
  803e2c:	68 4c 67 80 00       	push   $0x80674c
  803e31:	e8 4c dc ff ff       	call   801a82 <_panic>
  803e36:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e3f:	89 50 0c             	mov    %edx,0xc(%eax)
  803e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e45:	8b 40 0c             	mov    0xc(%eax),%eax
  803e48:	85 c0                	test   %eax,%eax
  803e4a:	74 0d                	je     803e59 <smalloc+0x462>
  803e4c:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803e51:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e54:	89 50 08             	mov    %edx,0x8(%eax)
  803e57:	eb 08                	jmp    803e61 <smalloc+0x46a>
  803e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e5c:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e64:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803e69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e6c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803e73:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803e78:	40                   	inc    %eax
  803e79:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803e7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e82:	75 17                	jne    803e9b <smalloc+0x4a4>
  803e84:	83 ec 04             	sub    $0x4,%esp
  803e87:	68 bb 67 80 00       	push   $0x8067bb
  803e8c:	68 8d 01 00 00       	push   $0x18d
  803e91:	68 4c 67 80 00       	push   $0x80674c
  803e96:	e8 e7 db ff ff       	call   801a82 <_panic>
  803e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9e:	8b 40 08             	mov    0x8(%eax),%eax
  803ea1:	85 c0                	test   %eax,%eax
  803ea3:	74 11                	je     803eb6 <smalloc+0x4bf>
  803ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea8:	8b 40 08             	mov    0x8(%eax),%eax
  803eab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803eae:	8b 52 0c             	mov    0xc(%edx),%edx
  803eb1:	89 50 0c             	mov    %edx,0xc(%eax)
  803eb4:	eb 0b                	jmp    803ec1 <smalloc+0x4ca>
  803eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb9:	8b 40 0c             	mov    0xc(%eax),%eax
  803ebc:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec4:	8b 40 0c             	mov    0xc(%eax),%eax
  803ec7:	85 c0                	test   %eax,%eax
  803ec9:	74 11                	je     803edc <smalloc+0x4e5>
  803ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ece:	8b 40 0c             	mov    0xc(%eax),%eax
  803ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ed4:	8b 52 08             	mov    0x8(%edx),%edx
  803ed7:	89 50 08             	mov    %edx,0x8(%eax)
  803eda:	eb 0b                	jmp    803ee7 <smalloc+0x4f0>
  803edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803edf:	8b 40 08             	mov    0x8(%eax),%eax
  803ee2:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803efb:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803f00:	48                   	dec    %eax
  803f01:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f09:	8b 00                	mov    (%eax),%eax
  803f0b:	89 c2                	mov    %eax,%edx
  803f0d:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803f11:	52                   	push   %edx
  803f12:	50                   	push   %eax
  803f13:	ff 75 0c             	pushl  0xc(%ebp)
  803f16:	ff 75 08             	pushl  0x8(%ebp)
  803f19:	e8 75 08 00 00       	call   804793 <sys_create_shared_object>
  803f1e:	83 c4 10             	add    $0x10,%esp
  803f21:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  803f24:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803f28:	79 25                	jns    803f4f <smalloc+0x558>
						free_block(allocblock);
  803f2a:	83 ec 0c             	sub    $0xc,%esp
  803f2d:	ff 75 ec             	pushl  -0x14(%ebp)
  803f30:	e8 fc 12 00 00       	call   805231 <free_block>
  803f35:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803f38:	83 ec 0c             	sub    $0xc,%esp
  803f3b:	68 20 f3 81 00       	push   $0x81f320
  803f40:	e8 10 17 00 00       	call   805655 <release_uspinlock>
  803f45:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803f48:	b8 00 00 00 00       	mov    $0x0,%eax
  803f4d:	eb 4d                	jmp    803f9c <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  803f4f:	83 ec 0c             	sub    $0xc,%esp
  803f52:	68 20 f3 81 00       	push   $0x81f320
  803f57:	e8 f9 16 00 00       	call   805655 <release_uspinlock>
  803f5c:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f62:	8b 00                	mov    (%eax),%eax
  803f64:	eb 36                	jmp    803f9c <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f69:	8b 40 08             	mov    0x8(%eax),%eax
  803f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803f6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f73:	0f 85 47 fc ff ff    	jne    803bc0 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  803f79:	83 ec 0c             	sub    $0xc,%esp
  803f7c:	ff 75 ec             	pushl  -0x14(%ebp)
  803f7f:	e8 ad 12 00 00       	call   805231 <free_block>
  803f84:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803f87:	83 ec 0c             	sub    $0xc,%esp
  803f8a:	68 20 f3 81 00       	push   $0x81f320
  803f8f:	e8 c1 16 00 00       	call   805655 <release_uspinlock>
  803f94:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f9c:	c9                   	leave  
  803f9d:	c3                   	ret    

00803f9e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  803f9e:	55                   	push   %ebp
  803f9f:	89 e5                	mov    %esp,%ebp
  803fa1:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  803fa4:	e8 8c ec ff ff       	call   802c35 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  803fa9:	83 ec 0c             	sub    $0xc,%esp
  803fac:	68 20 f3 81 00       	push   $0x81f320
  803fb1:	e8 47 16 00 00       	call   8055fd <acquire_uspinlock>
  803fb6:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  803fb9:	83 ec 08             	sub    $0x8,%esp
  803fbc:	ff 75 0c             	pushl  0xc(%ebp)
  803fbf:	ff 75 08             	pushl  0x8(%ebp)
  803fc2:	e8 f6 07 00 00       	call   8047bd <sys_size_of_shared_object>
  803fc7:	83 c4 10             	add    $0x10,%esp
  803fca:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  803fcd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803fd1:	79 1a                	jns    803fed <sget+0x4f>
			release_uspinlock(&ulock);
  803fd3:	83 ec 0c             	sub    $0xc,%esp
  803fd6:	68 20 f3 81 00       	push   $0x81f320
  803fdb:	e8 75 16 00 00       	call   805655 <release_uspinlock>
  803fe0:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe8:	e9 6e 05 00 00       	jmp    80455b <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  803fed:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803ff4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ffa:	01 d0                	add    %edx,%eax
  803ffc:	48                   	dec    %eax
  803ffd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  804000:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804003:	ba 00 00 00 00       	mov    $0x0,%edx
  804008:	f7 75 e8             	divl   -0x18(%ebp)
  80400b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80400e:	29 d0                	sub    %edx,%eax
  804010:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  804013:	83 ec 0c             	sub    $0xc,%esp
  804016:	6a 10                	push   $0x10
  804018:	e8 78 0d 00 00       	call   804d95 <alloc_block>
  80401d:	83 c4 10             	add    $0x10,%esp
  804020:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  804023:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  804027:	75 0a                	jne    804033 <sget+0x95>
			return NULL;
  804029:	b8 00 00 00 00       	mov    $0x0,%eax
  80402e:	e9 28 05 00 00       	jmp    80455b <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  804033:	a1 04 f3 81 00       	mov    0x81f304,%eax
  804038:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80403b:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  804040:	85 c0                	test   %eax,%eax
  804042:	74 11                	je     804055 <sget+0xb7>
  804044:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804047:	8b 50 04             	mov    0x4(%eax),%edx
  80404a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80404d:	39 c2                	cmp    %eax,%edx
  80404f:	0f 83 21 01 00 00    	jae    804176 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  804055:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804058:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  80405d:	29 c2                	sub    %eax,%edx
  80405f:	a1 50 f2 81 00       	mov    0x81f250,%eax
  804064:	39 c2                	cmp    %eax,%edx
  804066:	0f 82 f0 00 00 00    	jb     80415c <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  80406c:	a1 50 f2 81 00       	mov    0x81f250,%eax
  804071:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  804074:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80407a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80407d:	01 d0                	add    %edx,%eax
  80407f:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  804084:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804087:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80408a:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  80408c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80408f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804092:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  804095:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  804099:	75 17                	jne    8040b2 <sget+0x114>
  80409b:	83 ec 04             	sub    $0x4,%esp
  80409e:	68 98 67 80 00       	push   $0x806798
  8040a3:	68 c8 01 00 00       	push   $0x1c8
  8040a8:	68 4c 67 80 00       	push   $0x80674c
  8040ad:	e8 d0 d9 ff ff       	call   801a82 <_panic>
  8040b2:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8040b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040bb:	89 50 0c             	mov    %edx,0xc(%eax)
  8040be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8040c4:	85 c0                	test   %eax,%eax
  8040c6:	74 0d                	je     8040d5 <sget+0x137>
  8040c8:	a1 14 f3 81 00       	mov    0x81f314,%eax
  8040cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8040d0:	89 50 08             	mov    %edx,0x8(%eax)
  8040d3:	eb 08                	jmp    8040dd <sget+0x13f>
  8040d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040d8:	a3 10 f3 81 00       	mov    %eax,0x81f310
  8040dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040e0:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8040e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8040ef:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  8040f4:	40                   	inc    %eax
  8040f5:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  8040fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040fd:	8b 00                	mov    (%eax),%eax
  8040ff:	83 ec 04             	sub    $0x4,%esp
  804102:	50                   	push   %eax
  804103:	ff 75 0c             	pushl  0xc(%ebp)
  804106:	ff 75 08             	pushl  0x8(%ebp)
  804109:	e8 cc 06 00 00       	call   8047da <sys_get_shared_object>
  80410e:	83 c4 10             	add    $0x10,%esp
  804111:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  804114:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804118:	79 28                	jns    804142 <sget+0x1a4>
							free_block(allocblock);
  80411a:	83 ec 0c             	sub    $0xc,%esp
  80411d:	ff 75 e0             	pushl  -0x20(%ebp)
  804120:	e8 0c 11 00 00       	call   805231 <free_block>
  804125:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  804128:	83 ec 0c             	sub    $0xc,%esp
  80412b:	68 20 f3 81 00       	push   $0x81f320
  804130:	e8 20 15 00 00       	call   805655 <release_uspinlock>
  804135:	83 c4 10             	add    $0x10,%esp
							return NULL;
  804138:	b8 00 00 00 00       	mov    $0x0,%eax
  80413d:	e9 19 04 00 00       	jmp    80455b <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  804142:	83 ec 0c             	sub    $0xc,%esp
  804145:	68 20 f3 81 00       	push   $0x81f320
  80414a:	e8 06 15 00 00       	call   805655 <release_uspinlock>
  80414f:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  804152:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804155:	8b 00                	mov    (%eax),%eax
  804157:	e9 ff 03 00 00       	jmp    80455b <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  80415c:	83 ec 0c             	sub    $0xc,%esp
  80415f:	68 20 f3 81 00       	push   $0x81f320
  804164:	e8 ec 14 00 00       	call   805655 <release_uspinlock>
  804169:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80416c:	b8 00 00 00 00       	mov    $0x0,%eax
  804171:	e9 e5 03 00 00       	jmp    80455b <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  804176:	a1 00 f3 81 00       	mov    0x81f300,%eax
  80417b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  80417e:	e9 ab 03 00 00       	jmp    80452e <sget+0x590>
				if(size<currentfreeelement->size){
  804183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804186:	8b 50 04             	mov    0x4(%eax),%edx
  804189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80418c:	39 c2                	cmp    %eax,%edx
  80418e:	0f 86 24 02 00 00    	jbe    8043b8 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  804194:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804197:	8b 10                	mov    (%eax),%edx
  804199:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80419c:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80419e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041a4:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8041a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8041ab:	75 17                	jne    8041c4 <sget+0x226>
  8041ad:	83 ec 04             	sub    $0x4,%esp
  8041b0:	68 98 67 80 00       	push   $0x806798
  8041b5:	68 e0 01 00 00       	push   $0x1e0
  8041ba:	68 4c 67 80 00       	push   $0x80674c
  8041bf:	e8 be d8 ff ff       	call   801a82 <_panic>
  8041c4:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8041ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041cd:	89 50 0c             	mov    %edx,0xc(%eax)
  8041d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8041d6:	85 c0                	test   %eax,%eax
  8041d8:	74 0d                	je     8041e7 <sget+0x249>
  8041da:	a1 14 f3 81 00       	mov    0x81f314,%eax
  8041df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8041e2:	89 50 08             	mov    %edx,0x8(%eax)
  8041e5:	eb 08                	jmp    8041ef <sget+0x251>
  8041e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041ea:	a3 10 f3 81 00       	mov    %eax,0x81f310
  8041ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041f2:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8041f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  804201:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  804206:	40                   	inc    %eax
  804207:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					lastfreeelement->startva += size;
  80420c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80420f:	8b 10                	mov    (%eax),%edx
  804211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804214:	01 c2                	add    %eax,%edx
  804216:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804219:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  80421b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80421e:	8b 50 04             	mov    0x4(%eax),%edx
  804221:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804224:	29 c2                	sub    %eax,%edx
  804226:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804229:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  80422c:	a1 00 f3 81 00       	mov    0x81f300,%eax
  804231:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  804234:	e9 13 01 00 00       	jmp    80434c <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  804239:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80423c:	8b 50 04             	mov    0x4(%eax),%edx
  80423f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804242:	8b 40 04             	mov    0x4(%eax),%eax
  804245:	39 c2                	cmp    %eax,%edx
  804247:	0f 83 f6 00 00 00    	jae    804343 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  80424d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804251:	75 17                	jne    80426a <sget+0x2cc>
  804253:	83 ec 04             	sub    $0x4,%esp
  804256:	68 bb 67 80 00       	push   $0x8067bb
  80425b:	68 e8 01 00 00       	push   $0x1e8
  804260:	68 4c 67 80 00       	push   $0x80674c
  804265:	e8 18 d8 ff ff       	call   801a82 <_panic>
  80426a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80426d:	8b 40 08             	mov    0x8(%eax),%eax
  804270:	85 c0                	test   %eax,%eax
  804272:	74 11                	je     804285 <sget+0x2e7>
  804274:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804277:	8b 40 08             	mov    0x8(%eax),%eax
  80427a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80427d:	8b 52 0c             	mov    0xc(%edx),%edx
  804280:	89 50 0c             	mov    %edx,0xc(%eax)
  804283:	eb 0b                	jmp    804290 <sget+0x2f2>
  804285:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804288:	8b 40 0c             	mov    0xc(%eax),%eax
  80428b:	a3 04 f3 81 00       	mov    %eax,0x81f304
  804290:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804293:	8b 40 0c             	mov    0xc(%eax),%eax
  804296:	85 c0                	test   %eax,%eax
  804298:	74 11                	je     8042ab <sget+0x30d>
  80429a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80429d:	8b 40 0c             	mov    0xc(%eax),%eax
  8042a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8042a3:	8b 52 08             	mov    0x8(%edx),%edx
  8042a6:	89 50 08             	mov    %edx,0x8(%eax)
  8042a9:	eb 0b                	jmp    8042b6 <sget+0x318>
  8042ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042ae:	8b 40 08             	mov    0x8(%eax),%eax
  8042b1:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8042b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8042c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042c3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8042ca:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8042cf:	48                   	dec    %eax
  8042d0:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8042d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8042d9:	74 06                	je     8042e1 <sget+0x343>
  8042db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8042df:	75 17                	jne    8042f8 <sget+0x35a>
  8042e1:	83 ec 04             	sub    $0x4,%esp
  8042e4:	68 dc 67 80 00       	push   $0x8067dc
  8042e9:	68 e9 01 00 00       	push   $0x1e9
  8042ee:	68 4c 67 80 00       	push   $0x80674c
  8042f3:	e8 8a d7 ff ff       	call   801a82 <_panic>
  8042f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8042fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804301:	89 50 0c             	mov    %edx,0xc(%eax)
  804304:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804307:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80430a:	89 50 08             	mov    %edx,0x8(%eax)
  80430d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804310:	8b 40 0c             	mov    0xc(%eax),%eax
  804313:	85 c0                	test   %eax,%eax
  804315:	74 0e                	je     804325 <sget+0x387>
  804317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80431a:	8b 40 0c             	mov    0xc(%eax),%eax
  80431d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804320:	89 50 08             	mov    %edx,0x8(%eax)
  804323:	eb 08                	jmp    80432d <sget+0x38f>
  804325:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804328:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80432d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804330:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804333:	89 50 0c             	mov    %edx,0xc(%eax)
  804336:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80433b:	40                   	inc    %eax
  80433c:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							break;
  804341:	eb 13                	jmp    804356 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  804343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804346:	8b 40 08             	mov    0x8(%eax),%eax
  804349:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  80434c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804350:	0f 85 e3 fe ff ff    	jne    804239 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  804356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804359:	8b 00                	mov    (%eax),%eax
  80435b:	83 ec 04             	sub    $0x4,%esp
  80435e:	50                   	push   %eax
  80435f:	ff 75 0c             	pushl  0xc(%ebp)
  804362:	ff 75 08             	pushl  0x8(%ebp)
  804365:	e8 70 04 00 00       	call   8047da <sys_get_shared_object>
  80436a:	83 c4 10             	add    $0x10,%esp
  80436d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  804370:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804374:	79 28                	jns    80439e <sget+0x400>
						free_block(allocblock);
  804376:	83 ec 0c             	sub    $0xc,%esp
  804379:	ff 75 e0             	pushl  -0x20(%ebp)
  80437c:	e8 b0 0e 00 00       	call   805231 <free_block>
  804381:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  804384:	83 ec 0c             	sub    $0xc,%esp
  804387:	68 20 f3 81 00       	push   $0x81f320
  80438c:	e8 c4 12 00 00       	call   805655 <release_uspinlock>
  804391:	83 c4 10             	add    $0x10,%esp
						return NULL;
  804394:	b8 00 00 00 00       	mov    $0x0,%eax
  804399:	e9 bd 01 00 00       	jmp    80455b <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  80439e:	83 ec 0c             	sub    $0xc,%esp
  8043a1:	68 20 f3 81 00       	push   $0x81f320
  8043a6:	e8 aa 12 00 00       	call   805655 <release_uspinlock>
  8043ab:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8043ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043b1:	8b 00                	mov    (%eax),%eax
  8043b3:	e9 a3 01 00 00       	jmp    80455b <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  8043b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043bb:	8b 50 04             	mov    0x4(%eax),%edx
  8043be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043c1:	39 c2                	cmp    %eax,%edx
  8043c3:	0f 85 5c 01 00 00    	jne    804525 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  8043c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043cc:	8b 10                	mov    (%eax),%edx
  8043ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043d1:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8043d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8043d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043d9:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  8043dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8043e0:	75 17                	jne    8043f9 <sget+0x45b>
  8043e2:	83 ec 04             	sub    $0x4,%esp
  8043e5:	68 98 67 80 00       	push   $0x806798
  8043ea:	68 fe 01 00 00       	push   $0x1fe
  8043ef:	68 4c 67 80 00       	push   $0x80674c
  8043f4:	e8 89 d6 ff ff       	call   801a82 <_panic>
  8043f9:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8043ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804402:	89 50 0c             	mov    %edx,0xc(%eax)
  804405:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804408:	8b 40 0c             	mov    0xc(%eax),%eax
  80440b:	85 c0                	test   %eax,%eax
  80440d:	74 0d                	je     80441c <sget+0x47e>
  80440f:	a1 14 f3 81 00       	mov    0x81f314,%eax
  804414:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804417:	89 50 08             	mov    %edx,0x8(%eax)
  80441a:	eb 08                	jmp    804424 <sget+0x486>
  80441c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80441f:	a3 10 f3 81 00       	mov    %eax,0x81f310
  804424:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804427:	a3 14 f3 81 00       	mov    %eax,0x81f314
  80442c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80442f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  804436:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  80443b:	40                   	inc    %eax
  80443c:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  804441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804445:	75 17                	jne    80445e <sget+0x4c0>
  804447:	83 ec 04             	sub    $0x4,%esp
  80444a:	68 bb 67 80 00       	push   $0x8067bb
  80444f:	68 ff 01 00 00       	push   $0x1ff
  804454:	68 4c 67 80 00       	push   $0x80674c
  804459:	e8 24 d6 ff ff       	call   801a82 <_panic>
  80445e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804461:	8b 40 08             	mov    0x8(%eax),%eax
  804464:	85 c0                	test   %eax,%eax
  804466:	74 11                	je     804479 <sget+0x4db>
  804468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80446b:	8b 40 08             	mov    0x8(%eax),%eax
  80446e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804471:	8b 52 0c             	mov    0xc(%edx),%edx
  804474:	89 50 0c             	mov    %edx,0xc(%eax)
  804477:	eb 0b                	jmp    804484 <sget+0x4e6>
  804479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80447c:	8b 40 0c             	mov    0xc(%eax),%eax
  80447f:	a3 04 f3 81 00       	mov    %eax,0x81f304
  804484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804487:	8b 40 0c             	mov    0xc(%eax),%eax
  80448a:	85 c0                	test   %eax,%eax
  80448c:	74 11                	je     80449f <sget+0x501>
  80448e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804491:	8b 40 0c             	mov    0xc(%eax),%eax
  804494:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804497:	8b 52 08             	mov    0x8(%edx),%edx
  80449a:	89 50 08             	mov    %edx,0x8(%eax)
  80449d:	eb 0b                	jmp    8044aa <sget+0x50c>
  80449f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044a2:	8b 40 08             	mov    0x8(%eax),%eax
  8044a5:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8044aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8044b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8044be:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8044c3:	48                   	dec    %eax
  8044c4:	a3 0c f3 81 00       	mov    %eax,0x81f30c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  8044c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044cc:	8b 00                	mov    (%eax),%eax
  8044ce:	83 ec 04             	sub    $0x4,%esp
  8044d1:	50                   	push   %eax
  8044d2:	ff 75 0c             	pushl  0xc(%ebp)
  8044d5:	ff 75 08             	pushl  0x8(%ebp)
  8044d8:	e8 fd 02 00 00       	call   8047da <sys_get_shared_object>
  8044dd:	83 c4 10             	add    $0x10,%esp
  8044e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  8044e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8044e7:	79 25                	jns    80450e <sget+0x570>
						free_block(allocblock);
  8044e9:	83 ec 0c             	sub    $0xc,%esp
  8044ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8044ef:	e8 3d 0d 00 00       	call   805231 <free_block>
  8044f4:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8044f7:	83 ec 0c             	sub    $0xc,%esp
  8044fa:	68 20 f3 81 00       	push   $0x81f320
  8044ff:	e8 51 11 00 00       	call   805655 <release_uspinlock>
  804504:	83 c4 10             	add    $0x10,%esp
						return NULL;
  804507:	b8 00 00 00 00       	mov    $0x0,%eax
  80450c:	eb 4d                	jmp    80455b <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  80450e:	83 ec 0c             	sub    $0xc,%esp
  804511:	68 20 f3 81 00       	push   $0x81f320
  804516:	e8 3a 11 00 00       	call   805655 <release_uspinlock>
  80451b:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80451e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804521:	8b 00                	mov    (%eax),%eax
  804523:	eb 36                	jmp    80455b <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  804525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804528:	8b 40 08             	mov    0x8(%eax),%eax
  80452b:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  80452e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804532:	0f 85 4b fc ff ff    	jne    804183 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  804538:	83 ec 0c             	sub    $0xc,%esp
  80453b:	ff 75 e0             	pushl  -0x20(%ebp)
  80453e:	e8 ee 0c 00 00       	call   805231 <free_block>
  804543:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  804546:	83 ec 0c             	sub    $0xc,%esp
  804549:	68 20 f3 81 00       	push   $0x81f320
  80454e:	e8 02 11 00 00       	call   805655 <release_uspinlock>
  804553:	83 c4 10             	add    $0x10,%esp
		return NULL;
  804556:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80455b:	c9                   	leave  
  80455c:	c3                   	ret    

0080455d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80455d:	55                   	push   %ebp
  80455e:	89 e5                	mov    %esp,%ebp
  804560:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  804563:	e8 cd e6 ff ff       	call   802c35 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  804568:	83 ec 04             	sub    $0x4,%esp
  80456b:	68 6c 68 80 00       	push   $0x80686c
  804570:	68 2d 02 00 00       	push   $0x22d
  804575:	68 4c 67 80 00       	push   $0x80674c
  80457a:	e8 03 d5 ff ff       	call   801a82 <_panic>

0080457f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80457f:	55                   	push   %ebp
  804580:	89 e5                	mov    %esp,%ebp
  804582:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  804585:	83 ec 04             	sub    $0x4,%esp
  804588:	68 94 68 80 00       	push   $0x806894
  80458d:	68 40 02 00 00       	push   $0x240
  804592:	68 4c 67 80 00       	push   $0x80674c
  804597:	e8 e6 d4 ff ff       	call   801a82 <_panic>

0080459c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80459c:	55                   	push   %ebp
  80459d:	89 e5                	mov    %esp,%ebp
  80459f:	57                   	push   %edi
  8045a0:	56                   	push   %esi
  8045a1:	53                   	push   %ebx
  8045a2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8045a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8045a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8045ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8045ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8045b1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8045b4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8045b7:	cd 30                	int    $0x30
  8045b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8045bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8045bf:	83 c4 10             	add    $0x10,%esp
  8045c2:	5b                   	pop    %ebx
  8045c3:	5e                   	pop    %esi
  8045c4:	5f                   	pop    %edi
  8045c5:	5d                   	pop    %ebp
  8045c6:	c3                   	ret    

008045c7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8045c7:	55                   	push   %ebp
  8045c8:	89 e5                	mov    %esp,%ebp
  8045ca:	83 ec 04             	sub    $0x4,%esp
  8045cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8045d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8045d3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8045d6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8045da:	8b 45 08             	mov    0x8(%ebp),%eax
  8045dd:	6a 00                	push   $0x0
  8045df:	51                   	push   %ecx
  8045e0:	52                   	push   %edx
  8045e1:	ff 75 0c             	pushl  0xc(%ebp)
  8045e4:	50                   	push   %eax
  8045e5:	6a 00                	push   $0x0
  8045e7:	e8 b0 ff ff ff       	call   80459c <syscall>
  8045ec:	83 c4 18             	add    $0x18,%esp
}
  8045ef:	90                   	nop
  8045f0:	c9                   	leave  
  8045f1:	c3                   	ret    

008045f2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8045f2:	55                   	push   %ebp
  8045f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8045f5:	6a 00                	push   $0x0
  8045f7:	6a 00                	push   $0x0
  8045f9:	6a 00                	push   $0x0
  8045fb:	6a 00                	push   $0x0
  8045fd:	6a 00                	push   $0x0
  8045ff:	6a 02                	push   $0x2
  804601:	e8 96 ff ff ff       	call   80459c <syscall>
  804606:	83 c4 18             	add    $0x18,%esp
}
  804609:	c9                   	leave  
  80460a:	c3                   	ret    

0080460b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80460b:	55                   	push   %ebp
  80460c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80460e:	6a 00                	push   $0x0
  804610:	6a 00                	push   $0x0
  804612:	6a 00                	push   $0x0
  804614:	6a 00                	push   $0x0
  804616:	6a 00                	push   $0x0
  804618:	6a 03                	push   $0x3
  80461a:	e8 7d ff ff ff       	call   80459c <syscall>
  80461f:	83 c4 18             	add    $0x18,%esp
}
  804622:	90                   	nop
  804623:	c9                   	leave  
  804624:	c3                   	ret    

00804625 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  804625:	55                   	push   %ebp
  804626:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  804628:	6a 00                	push   $0x0
  80462a:	6a 00                	push   $0x0
  80462c:	6a 00                	push   $0x0
  80462e:	6a 00                	push   $0x0
  804630:	6a 00                	push   $0x0
  804632:	6a 04                	push   $0x4
  804634:	e8 63 ff ff ff       	call   80459c <syscall>
  804639:	83 c4 18             	add    $0x18,%esp
}
  80463c:	90                   	nop
  80463d:	c9                   	leave  
  80463e:	c3                   	ret    

0080463f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80463f:	55                   	push   %ebp
  804640:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  804642:	8b 55 0c             	mov    0xc(%ebp),%edx
  804645:	8b 45 08             	mov    0x8(%ebp),%eax
  804648:	6a 00                	push   $0x0
  80464a:	6a 00                	push   $0x0
  80464c:	6a 00                	push   $0x0
  80464e:	52                   	push   %edx
  80464f:	50                   	push   %eax
  804650:	6a 08                	push   $0x8
  804652:	e8 45 ff ff ff       	call   80459c <syscall>
  804657:	83 c4 18             	add    $0x18,%esp
}
  80465a:	c9                   	leave  
  80465b:	c3                   	ret    

0080465c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80465c:	55                   	push   %ebp
  80465d:	89 e5                	mov    %esp,%ebp
  80465f:	56                   	push   %esi
  804660:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  804661:	8b 75 18             	mov    0x18(%ebp),%esi
  804664:	8b 5d 14             	mov    0x14(%ebp),%ebx
  804667:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80466a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80466d:	8b 45 08             	mov    0x8(%ebp),%eax
  804670:	56                   	push   %esi
  804671:	53                   	push   %ebx
  804672:	51                   	push   %ecx
  804673:	52                   	push   %edx
  804674:	50                   	push   %eax
  804675:	6a 09                	push   $0x9
  804677:	e8 20 ff ff ff       	call   80459c <syscall>
  80467c:	83 c4 18             	add    $0x18,%esp
}
  80467f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  804682:	5b                   	pop    %ebx
  804683:	5e                   	pop    %esi
  804684:	5d                   	pop    %ebp
  804685:	c3                   	ret    

00804686 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  804686:	55                   	push   %ebp
  804687:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  804689:	6a 00                	push   $0x0
  80468b:	6a 00                	push   $0x0
  80468d:	6a 00                	push   $0x0
  80468f:	6a 00                	push   $0x0
  804691:	ff 75 08             	pushl  0x8(%ebp)
  804694:	6a 0a                	push   $0xa
  804696:	e8 01 ff ff ff       	call   80459c <syscall>
  80469b:	83 c4 18             	add    $0x18,%esp
}
  80469e:	c9                   	leave  
  80469f:	c3                   	ret    

008046a0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8046a0:	55                   	push   %ebp
  8046a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8046a3:	6a 00                	push   $0x0
  8046a5:	6a 00                	push   $0x0
  8046a7:	6a 00                	push   $0x0
  8046a9:	ff 75 0c             	pushl  0xc(%ebp)
  8046ac:	ff 75 08             	pushl  0x8(%ebp)
  8046af:	6a 0b                	push   $0xb
  8046b1:	e8 e6 fe ff ff       	call   80459c <syscall>
  8046b6:	83 c4 18             	add    $0x18,%esp
}
  8046b9:	c9                   	leave  
  8046ba:	c3                   	ret    

008046bb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8046bb:	55                   	push   %ebp
  8046bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8046be:	6a 00                	push   $0x0
  8046c0:	6a 00                	push   $0x0
  8046c2:	6a 00                	push   $0x0
  8046c4:	6a 00                	push   $0x0
  8046c6:	6a 00                	push   $0x0
  8046c8:	6a 0c                	push   $0xc
  8046ca:	e8 cd fe ff ff       	call   80459c <syscall>
  8046cf:	83 c4 18             	add    $0x18,%esp
}
  8046d2:	c9                   	leave  
  8046d3:	c3                   	ret    

008046d4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8046d4:	55                   	push   %ebp
  8046d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8046d7:	6a 00                	push   $0x0
  8046d9:	6a 00                	push   $0x0
  8046db:	6a 00                	push   $0x0
  8046dd:	6a 00                	push   $0x0
  8046df:	6a 00                	push   $0x0
  8046e1:	6a 0d                	push   $0xd
  8046e3:	e8 b4 fe ff ff       	call   80459c <syscall>
  8046e8:	83 c4 18             	add    $0x18,%esp
}
  8046eb:	c9                   	leave  
  8046ec:	c3                   	ret    

008046ed <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8046ed:	55                   	push   %ebp
  8046ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8046f0:	6a 00                	push   $0x0
  8046f2:	6a 00                	push   $0x0
  8046f4:	6a 00                	push   $0x0
  8046f6:	6a 00                	push   $0x0
  8046f8:	6a 00                	push   $0x0
  8046fa:	6a 0e                	push   $0xe
  8046fc:	e8 9b fe ff ff       	call   80459c <syscall>
  804701:	83 c4 18             	add    $0x18,%esp
}
  804704:	c9                   	leave  
  804705:	c3                   	ret    

00804706 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  804706:	55                   	push   %ebp
  804707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  804709:	6a 00                	push   $0x0
  80470b:	6a 00                	push   $0x0
  80470d:	6a 00                	push   $0x0
  80470f:	6a 00                	push   $0x0
  804711:	6a 00                	push   $0x0
  804713:	6a 0f                	push   $0xf
  804715:	e8 82 fe ff ff       	call   80459c <syscall>
  80471a:	83 c4 18             	add    $0x18,%esp
}
  80471d:	c9                   	leave  
  80471e:	c3                   	ret    

0080471f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80471f:	55                   	push   %ebp
  804720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  804722:	6a 00                	push   $0x0
  804724:	6a 00                	push   $0x0
  804726:	6a 00                	push   $0x0
  804728:	6a 00                	push   $0x0
  80472a:	ff 75 08             	pushl  0x8(%ebp)
  80472d:	6a 10                	push   $0x10
  80472f:	e8 68 fe ff ff       	call   80459c <syscall>
  804734:	83 c4 18             	add    $0x18,%esp
}
  804737:	c9                   	leave  
  804738:	c3                   	ret    

00804739 <sys_scarce_memory>:

void sys_scarce_memory()
{
  804739:	55                   	push   %ebp
  80473a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80473c:	6a 00                	push   $0x0
  80473e:	6a 00                	push   $0x0
  804740:	6a 00                	push   $0x0
  804742:	6a 00                	push   $0x0
  804744:	6a 00                	push   $0x0
  804746:	6a 11                	push   $0x11
  804748:	e8 4f fe ff ff       	call   80459c <syscall>
  80474d:	83 c4 18             	add    $0x18,%esp
}
  804750:	90                   	nop
  804751:	c9                   	leave  
  804752:	c3                   	ret    

00804753 <sys_cputc>:

void
sys_cputc(const char c)
{
  804753:	55                   	push   %ebp
  804754:	89 e5                	mov    %esp,%ebp
  804756:	83 ec 04             	sub    $0x4,%esp
  804759:	8b 45 08             	mov    0x8(%ebp),%eax
  80475c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80475f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  804763:	6a 00                	push   $0x0
  804765:	6a 00                	push   $0x0
  804767:	6a 00                	push   $0x0
  804769:	6a 00                	push   $0x0
  80476b:	50                   	push   %eax
  80476c:	6a 01                	push   $0x1
  80476e:	e8 29 fe ff ff       	call   80459c <syscall>
  804773:	83 c4 18             	add    $0x18,%esp
}
  804776:	90                   	nop
  804777:	c9                   	leave  
  804778:	c3                   	ret    

00804779 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  804779:	55                   	push   %ebp
  80477a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80477c:	6a 00                	push   $0x0
  80477e:	6a 00                	push   $0x0
  804780:	6a 00                	push   $0x0
  804782:	6a 00                	push   $0x0
  804784:	6a 00                	push   $0x0
  804786:	6a 14                	push   $0x14
  804788:	e8 0f fe ff ff       	call   80459c <syscall>
  80478d:	83 c4 18             	add    $0x18,%esp
}
  804790:	90                   	nop
  804791:	c9                   	leave  
  804792:	c3                   	ret    

00804793 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  804793:	55                   	push   %ebp
  804794:	89 e5                	mov    %esp,%ebp
  804796:	83 ec 04             	sub    $0x4,%esp
  804799:	8b 45 10             	mov    0x10(%ebp),%eax
  80479c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80479f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8047a2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8047a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8047a9:	6a 00                	push   $0x0
  8047ab:	51                   	push   %ecx
  8047ac:	52                   	push   %edx
  8047ad:	ff 75 0c             	pushl  0xc(%ebp)
  8047b0:	50                   	push   %eax
  8047b1:	6a 15                	push   $0x15
  8047b3:	e8 e4 fd ff ff       	call   80459c <syscall>
  8047b8:	83 c4 18             	add    $0x18,%esp
}
  8047bb:	c9                   	leave  
  8047bc:	c3                   	ret    

008047bd <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8047bd:	55                   	push   %ebp
  8047be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8047c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8047c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8047c6:	6a 00                	push   $0x0
  8047c8:	6a 00                	push   $0x0
  8047ca:	6a 00                	push   $0x0
  8047cc:	52                   	push   %edx
  8047cd:	50                   	push   %eax
  8047ce:	6a 16                	push   $0x16
  8047d0:	e8 c7 fd ff ff       	call   80459c <syscall>
  8047d5:	83 c4 18             	add    $0x18,%esp
}
  8047d8:	c9                   	leave  
  8047d9:	c3                   	ret    

008047da <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8047da:	55                   	push   %ebp
  8047db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8047dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8047e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8047e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8047e6:	6a 00                	push   $0x0
  8047e8:	6a 00                	push   $0x0
  8047ea:	51                   	push   %ecx
  8047eb:	52                   	push   %edx
  8047ec:	50                   	push   %eax
  8047ed:	6a 17                	push   $0x17
  8047ef:	e8 a8 fd ff ff       	call   80459c <syscall>
  8047f4:	83 c4 18             	add    $0x18,%esp
}
  8047f7:	c9                   	leave  
  8047f8:	c3                   	ret    

008047f9 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8047f9:	55                   	push   %ebp
  8047fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8047fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8047ff:	8b 45 08             	mov    0x8(%ebp),%eax
  804802:	6a 00                	push   $0x0
  804804:	6a 00                	push   $0x0
  804806:	6a 00                	push   $0x0
  804808:	52                   	push   %edx
  804809:	50                   	push   %eax
  80480a:	6a 18                	push   $0x18
  80480c:	e8 8b fd ff ff       	call   80459c <syscall>
  804811:	83 c4 18             	add    $0x18,%esp
}
  804814:	c9                   	leave  
  804815:	c3                   	ret    

00804816 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  804816:	55                   	push   %ebp
  804817:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  804819:	8b 45 08             	mov    0x8(%ebp),%eax
  80481c:	6a 00                	push   $0x0
  80481e:	ff 75 14             	pushl  0x14(%ebp)
  804821:	ff 75 10             	pushl  0x10(%ebp)
  804824:	ff 75 0c             	pushl  0xc(%ebp)
  804827:	50                   	push   %eax
  804828:	6a 19                	push   $0x19
  80482a:	e8 6d fd ff ff       	call   80459c <syscall>
  80482f:	83 c4 18             	add    $0x18,%esp
}
  804832:	c9                   	leave  
  804833:	c3                   	ret    

00804834 <sys_run_env>:

void sys_run_env(int32 envId)
{
  804834:	55                   	push   %ebp
  804835:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  804837:	8b 45 08             	mov    0x8(%ebp),%eax
  80483a:	6a 00                	push   $0x0
  80483c:	6a 00                	push   $0x0
  80483e:	6a 00                	push   $0x0
  804840:	6a 00                	push   $0x0
  804842:	50                   	push   %eax
  804843:	6a 1a                	push   $0x1a
  804845:	e8 52 fd ff ff       	call   80459c <syscall>
  80484a:	83 c4 18             	add    $0x18,%esp
}
  80484d:	90                   	nop
  80484e:	c9                   	leave  
  80484f:	c3                   	ret    

00804850 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  804850:	55                   	push   %ebp
  804851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  804853:	8b 45 08             	mov    0x8(%ebp),%eax
  804856:	6a 00                	push   $0x0
  804858:	6a 00                	push   $0x0
  80485a:	6a 00                	push   $0x0
  80485c:	6a 00                	push   $0x0
  80485e:	50                   	push   %eax
  80485f:	6a 1b                	push   $0x1b
  804861:	e8 36 fd ff ff       	call   80459c <syscall>
  804866:	83 c4 18             	add    $0x18,%esp
}
  804869:	c9                   	leave  
  80486a:	c3                   	ret    

0080486b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80486b:	55                   	push   %ebp
  80486c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80486e:	6a 00                	push   $0x0
  804870:	6a 00                	push   $0x0
  804872:	6a 00                	push   $0x0
  804874:	6a 00                	push   $0x0
  804876:	6a 00                	push   $0x0
  804878:	6a 05                	push   $0x5
  80487a:	e8 1d fd ff ff       	call   80459c <syscall>
  80487f:	83 c4 18             	add    $0x18,%esp
}
  804882:	c9                   	leave  
  804883:	c3                   	ret    

00804884 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  804884:	55                   	push   %ebp
  804885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  804887:	6a 00                	push   $0x0
  804889:	6a 00                	push   $0x0
  80488b:	6a 00                	push   $0x0
  80488d:	6a 00                	push   $0x0
  80488f:	6a 00                	push   $0x0
  804891:	6a 06                	push   $0x6
  804893:	e8 04 fd ff ff       	call   80459c <syscall>
  804898:	83 c4 18             	add    $0x18,%esp
}
  80489b:	c9                   	leave  
  80489c:	c3                   	ret    

0080489d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80489d:	55                   	push   %ebp
  80489e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8048a0:	6a 00                	push   $0x0
  8048a2:	6a 00                	push   $0x0
  8048a4:	6a 00                	push   $0x0
  8048a6:	6a 00                	push   $0x0
  8048a8:	6a 00                	push   $0x0
  8048aa:	6a 07                	push   $0x7
  8048ac:	e8 eb fc ff ff       	call   80459c <syscall>
  8048b1:	83 c4 18             	add    $0x18,%esp
}
  8048b4:	c9                   	leave  
  8048b5:	c3                   	ret    

008048b6 <sys_exit_env>:


void sys_exit_env(void)
{
  8048b6:	55                   	push   %ebp
  8048b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8048b9:	6a 00                	push   $0x0
  8048bb:	6a 00                	push   $0x0
  8048bd:	6a 00                	push   $0x0
  8048bf:	6a 00                	push   $0x0
  8048c1:	6a 00                	push   $0x0
  8048c3:	6a 1c                	push   $0x1c
  8048c5:	e8 d2 fc ff ff       	call   80459c <syscall>
  8048ca:	83 c4 18             	add    $0x18,%esp
}
  8048cd:	90                   	nop
  8048ce:	c9                   	leave  
  8048cf:	c3                   	ret    

008048d0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8048d0:	55                   	push   %ebp
  8048d1:	89 e5                	mov    %esp,%ebp
  8048d3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8048d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8048d9:	8d 50 04             	lea    0x4(%eax),%edx
  8048dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8048df:	6a 00                	push   $0x0
  8048e1:	6a 00                	push   $0x0
  8048e3:	6a 00                	push   $0x0
  8048e5:	52                   	push   %edx
  8048e6:	50                   	push   %eax
  8048e7:	6a 1d                	push   $0x1d
  8048e9:	e8 ae fc ff ff       	call   80459c <syscall>
  8048ee:	83 c4 18             	add    $0x18,%esp
	return result;
  8048f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8048f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8048f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8048fa:	89 01                	mov    %eax,(%ecx)
  8048fc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8048ff:	8b 45 08             	mov    0x8(%ebp),%eax
  804902:	c9                   	leave  
  804903:	c2 04 00             	ret    $0x4

00804906 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  804906:	55                   	push   %ebp
  804907:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  804909:	6a 00                	push   $0x0
  80490b:	6a 00                	push   $0x0
  80490d:	ff 75 10             	pushl  0x10(%ebp)
  804910:	ff 75 0c             	pushl  0xc(%ebp)
  804913:	ff 75 08             	pushl  0x8(%ebp)
  804916:	6a 13                	push   $0x13
  804918:	e8 7f fc ff ff       	call   80459c <syscall>
  80491d:	83 c4 18             	add    $0x18,%esp
	return ;
  804920:	90                   	nop
}
  804921:	c9                   	leave  
  804922:	c3                   	ret    

00804923 <sys_rcr2>:
uint32 sys_rcr2()
{
  804923:	55                   	push   %ebp
  804924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  804926:	6a 00                	push   $0x0
  804928:	6a 00                	push   $0x0
  80492a:	6a 00                	push   $0x0
  80492c:	6a 00                	push   $0x0
  80492e:	6a 00                	push   $0x0
  804930:	6a 1e                	push   $0x1e
  804932:	e8 65 fc ff ff       	call   80459c <syscall>
  804937:	83 c4 18             	add    $0x18,%esp
}
  80493a:	c9                   	leave  
  80493b:	c3                   	ret    

0080493c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80493c:	55                   	push   %ebp
  80493d:	89 e5                	mov    %esp,%ebp
  80493f:	83 ec 04             	sub    $0x4,%esp
  804942:	8b 45 08             	mov    0x8(%ebp),%eax
  804945:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  804948:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80494c:	6a 00                	push   $0x0
  80494e:	6a 00                	push   $0x0
  804950:	6a 00                	push   $0x0
  804952:	6a 00                	push   $0x0
  804954:	50                   	push   %eax
  804955:	6a 1f                	push   $0x1f
  804957:	e8 40 fc ff ff       	call   80459c <syscall>
  80495c:	83 c4 18             	add    $0x18,%esp
	return ;
  80495f:	90                   	nop
}
  804960:	c9                   	leave  
  804961:	c3                   	ret    

00804962 <rsttst>:
void rsttst()
{
  804962:	55                   	push   %ebp
  804963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  804965:	6a 00                	push   $0x0
  804967:	6a 00                	push   $0x0
  804969:	6a 00                	push   $0x0
  80496b:	6a 00                	push   $0x0
  80496d:	6a 00                	push   $0x0
  80496f:	6a 21                	push   $0x21
  804971:	e8 26 fc ff ff       	call   80459c <syscall>
  804976:	83 c4 18             	add    $0x18,%esp
	return ;
  804979:	90                   	nop
}
  80497a:	c9                   	leave  
  80497b:	c3                   	ret    

0080497c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80497c:	55                   	push   %ebp
  80497d:	89 e5                	mov    %esp,%ebp
  80497f:	83 ec 04             	sub    $0x4,%esp
  804982:	8b 45 14             	mov    0x14(%ebp),%eax
  804985:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  804988:	8b 55 18             	mov    0x18(%ebp),%edx
  80498b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80498f:	52                   	push   %edx
  804990:	50                   	push   %eax
  804991:	ff 75 10             	pushl  0x10(%ebp)
  804994:	ff 75 0c             	pushl  0xc(%ebp)
  804997:	ff 75 08             	pushl  0x8(%ebp)
  80499a:	6a 20                	push   $0x20
  80499c:	e8 fb fb ff ff       	call   80459c <syscall>
  8049a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8049a4:	90                   	nop
}
  8049a5:	c9                   	leave  
  8049a6:	c3                   	ret    

008049a7 <chktst>:
void chktst(uint32 n)
{
  8049a7:	55                   	push   %ebp
  8049a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8049aa:	6a 00                	push   $0x0
  8049ac:	6a 00                	push   $0x0
  8049ae:	6a 00                	push   $0x0
  8049b0:	6a 00                	push   $0x0
  8049b2:	ff 75 08             	pushl  0x8(%ebp)
  8049b5:	6a 22                	push   $0x22
  8049b7:	e8 e0 fb ff ff       	call   80459c <syscall>
  8049bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8049bf:	90                   	nop
}
  8049c0:	c9                   	leave  
  8049c1:	c3                   	ret    

008049c2 <inctst>:

void inctst()
{
  8049c2:	55                   	push   %ebp
  8049c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8049c5:	6a 00                	push   $0x0
  8049c7:	6a 00                	push   $0x0
  8049c9:	6a 00                	push   $0x0
  8049cb:	6a 00                	push   $0x0
  8049cd:	6a 00                	push   $0x0
  8049cf:	6a 23                	push   $0x23
  8049d1:	e8 c6 fb ff ff       	call   80459c <syscall>
  8049d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8049d9:	90                   	nop
}
  8049da:	c9                   	leave  
  8049db:	c3                   	ret    

008049dc <gettst>:
uint32 gettst()
{
  8049dc:	55                   	push   %ebp
  8049dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8049df:	6a 00                	push   $0x0
  8049e1:	6a 00                	push   $0x0
  8049e3:	6a 00                	push   $0x0
  8049e5:	6a 00                	push   $0x0
  8049e7:	6a 00                	push   $0x0
  8049e9:	6a 24                	push   $0x24
  8049eb:	e8 ac fb ff ff       	call   80459c <syscall>
  8049f0:	83 c4 18             	add    $0x18,%esp
}
  8049f3:	c9                   	leave  
  8049f4:	c3                   	ret    

008049f5 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8049f5:	55                   	push   %ebp
  8049f6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8049f8:	6a 00                	push   $0x0
  8049fa:	6a 00                	push   $0x0
  8049fc:	6a 00                	push   $0x0
  8049fe:	6a 00                	push   $0x0
  804a00:	6a 00                	push   $0x0
  804a02:	6a 25                	push   $0x25
  804a04:	e8 93 fb ff ff       	call   80459c <syscall>
  804a09:	83 c4 18             	add    $0x18,%esp
  804a0c:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  804a11:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  804a16:	c9                   	leave  
  804a17:	c3                   	ret    

00804a18 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  804a18:	55                   	push   %ebp
  804a19:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  804a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  804a1e:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  804a23:	6a 00                	push   $0x0
  804a25:	6a 00                	push   $0x0
  804a27:	6a 00                	push   $0x0
  804a29:	6a 00                	push   $0x0
  804a2b:	ff 75 08             	pushl  0x8(%ebp)
  804a2e:	6a 26                	push   $0x26
  804a30:	e8 67 fb ff ff       	call   80459c <syscall>
  804a35:	83 c4 18             	add    $0x18,%esp
	return ;
  804a38:	90                   	nop
}
  804a39:	c9                   	leave  
  804a3a:	c3                   	ret    

00804a3b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  804a3b:	55                   	push   %ebp
  804a3c:	89 e5                	mov    %esp,%ebp
  804a3e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  804a3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  804a42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  804a48:	8b 45 08             	mov    0x8(%ebp),%eax
  804a4b:	6a 00                	push   $0x0
  804a4d:	53                   	push   %ebx
  804a4e:	51                   	push   %ecx
  804a4f:	52                   	push   %edx
  804a50:	50                   	push   %eax
  804a51:	6a 27                	push   $0x27
  804a53:	e8 44 fb ff ff       	call   80459c <syscall>
  804a58:	83 c4 18             	add    $0x18,%esp
}
  804a5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  804a5e:	c9                   	leave  
  804a5f:	c3                   	ret    

00804a60 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  804a60:	55                   	push   %ebp
  804a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  804a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  804a66:	8b 45 08             	mov    0x8(%ebp),%eax
  804a69:	6a 00                	push   $0x0
  804a6b:	6a 00                	push   $0x0
  804a6d:	6a 00                	push   $0x0
  804a6f:	52                   	push   %edx
  804a70:	50                   	push   %eax
  804a71:	6a 28                	push   $0x28
  804a73:	e8 24 fb ff ff       	call   80459c <syscall>
  804a78:	83 c4 18             	add    $0x18,%esp
}
  804a7b:	c9                   	leave  
  804a7c:	c3                   	ret    

00804a7d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  804a7d:	55                   	push   %ebp
  804a7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  804a80:	8b 4d 14             	mov    0x14(%ebp),%ecx
  804a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  804a86:	8b 45 08             	mov    0x8(%ebp),%eax
  804a89:	6a 00                	push   $0x0
  804a8b:	51                   	push   %ecx
  804a8c:	ff 75 10             	pushl  0x10(%ebp)
  804a8f:	52                   	push   %edx
  804a90:	50                   	push   %eax
  804a91:	6a 29                	push   $0x29
  804a93:	e8 04 fb ff ff       	call   80459c <syscall>
  804a98:	83 c4 18             	add    $0x18,%esp
}
  804a9b:	c9                   	leave  
  804a9c:	c3                   	ret    

00804a9d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  804a9d:	55                   	push   %ebp
  804a9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  804aa0:	6a 00                	push   $0x0
  804aa2:	6a 00                	push   $0x0
  804aa4:	ff 75 10             	pushl  0x10(%ebp)
  804aa7:	ff 75 0c             	pushl  0xc(%ebp)
  804aaa:	ff 75 08             	pushl  0x8(%ebp)
  804aad:	6a 12                	push   $0x12
  804aaf:	e8 e8 fa ff ff       	call   80459c <syscall>
  804ab4:	83 c4 18             	add    $0x18,%esp
	return ;
  804ab7:	90                   	nop
}
  804ab8:	c9                   	leave  
  804ab9:	c3                   	ret    

00804aba <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  804aba:	55                   	push   %ebp
  804abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  804abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  804ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  804ac3:	6a 00                	push   $0x0
  804ac5:	6a 00                	push   $0x0
  804ac7:	6a 00                	push   $0x0
  804ac9:	52                   	push   %edx
  804aca:	50                   	push   %eax
  804acb:	6a 2a                	push   $0x2a
  804acd:	e8 ca fa ff ff       	call   80459c <syscall>
  804ad2:	83 c4 18             	add    $0x18,%esp
	return;
  804ad5:	90                   	nop
}
  804ad6:	c9                   	leave  
  804ad7:	c3                   	ret    

00804ad8 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  804ad8:	55                   	push   %ebp
  804ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  804adb:	6a 00                	push   $0x0
  804add:	6a 00                	push   $0x0
  804adf:	6a 00                	push   $0x0
  804ae1:	6a 00                	push   $0x0
  804ae3:	6a 00                	push   $0x0
  804ae5:	6a 2b                	push   $0x2b
  804ae7:	e8 b0 fa ff ff       	call   80459c <syscall>
  804aec:	83 c4 18             	add    $0x18,%esp
}
  804aef:	c9                   	leave  
  804af0:	c3                   	ret    

00804af1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  804af1:	55                   	push   %ebp
  804af2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  804af4:	6a 00                	push   $0x0
  804af6:	6a 00                	push   $0x0
  804af8:	6a 00                	push   $0x0
  804afa:	ff 75 0c             	pushl  0xc(%ebp)
  804afd:	ff 75 08             	pushl  0x8(%ebp)
  804b00:	6a 2d                	push   $0x2d
  804b02:	e8 95 fa ff ff       	call   80459c <syscall>
  804b07:	83 c4 18             	add    $0x18,%esp
	return;
  804b0a:	90                   	nop
}
  804b0b:	c9                   	leave  
  804b0c:	c3                   	ret    

00804b0d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  804b0d:	55                   	push   %ebp
  804b0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  804b10:	6a 00                	push   $0x0
  804b12:	6a 00                	push   $0x0
  804b14:	6a 00                	push   $0x0
  804b16:	ff 75 0c             	pushl  0xc(%ebp)
  804b19:	ff 75 08             	pushl  0x8(%ebp)
  804b1c:	6a 2c                	push   $0x2c
  804b1e:	e8 79 fa ff ff       	call   80459c <syscall>
  804b23:	83 c4 18             	add    $0x18,%esp
	return ;
  804b26:	90                   	nop
}
  804b27:	c9                   	leave  
  804b28:	c3                   	ret    

00804b29 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  804b29:	55                   	push   %ebp
  804b2a:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  804b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  804b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  804b32:	6a 00                	push   $0x0
  804b34:	6a 00                	push   $0x0
  804b36:	6a 00                	push   $0x0
  804b38:	52                   	push   %edx
  804b39:	50                   	push   %eax
  804b3a:	6a 2e                	push   $0x2e
  804b3c:	e8 5b fa ff ff       	call   80459c <syscall>
  804b41:	83 c4 18             	add    $0x18,%esp
	    return;
  804b44:	90                   	nop
}
  804b45:	c9                   	leave  
  804b46:	c3                   	ret    

00804b47 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  804b47:	55                   	push   %ebp
  804b48:	89 e5                	mov    %esp,%ebp
  804b4a:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  804b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  804b50:	ba 40 72 80 00       	mov    $0x807240,%edx
  804b55:	29 d0                	sub    %edx,%eax
  804b57:	c1 f8 02             	sar    $0x2,%eax
  804b5a:	89 c2                	mov    %eax,%edx
  804b5c:	89 d0                	mov    %edx,%eax
  804b5e:	c1 e0 02             	shl    $0x2,%eax
  804b61:	01 d0                	add    %edx,%eax
  804b63:	c1 e0 02             	shl    $0x2,%eax
  804b66:	01 d0                	add    %edx,%eax
  804b68:	c1 e0 02             	shl    $0x2,%eax
  804b6b:	01 d0                	add    %edx,%eax
  804b6d:	89 c1                	mov    %eax,%ecx
  804b6f:	c1 e1 08             	shl    $0x8,%ecx
  804b72:	01 c8                	add    %ecx,%eax
  804b74:	89 c1                	mov    %eax,%ecx
  804b76:	c1 e1 10             	shl    $0x10,%ecx
  804b79:	01 c8                	add    %ecx,%eax
  804b7b:	01 c0                	add    %eax,%eax
  804b7d:	01 d0                	add    %edx,%eax
  804b7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  804b82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804b85:	c1 e0 0c             	shl    $0xc,%eax
  804b88:	89 c2                	mov    %eax,%edx
  804b8a:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804b8f:	01 d0                	add    %edx,%eax
}
  804b91:	c9                   	leave  
  804b92:	c3                   	ret    

00804b93 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  804b93:	55                   	push   %ebp
  804b94:	89 e5                	mov    %esp,%ebp
  804b96:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  804b99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  804ba0:	eb 06                	jmp    804ba8 <log2+0x15>
			n >>=1;
  804ba2:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  804ba5:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  804ba8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804bac:	77 f4                	ja     804ba2 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  804bae:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  804bb1:	c9                   	leave  
  804bb2:	c3                   	ret    

00804bb3 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  804bb3:	55                   	push   %ebp
  804bb4:	89 e5                	mov    %esp,%ebp
  804bb6:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  804bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  804bbc:	05 00 00 00 02       	add    $0x2000000,%eax
  804bc1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804bc4:	73 16                	jae    804bdc <initialize_dynamic_allocator+0x29>
  804bc6:	68 b8 68 80 00       	push   $0x8068b8
  804bcb:	68 de 68 80 00       	push   $0x8068de
  804bd0:	6a 2d                	push   $0x2d
  804bd2:	68 f3 68 80 00       	push   $0x8068f3
  804bd7:	e8 a6 ce ff ff       	call   801a82 <_panic>
		is_initialized = 1;
  804bdc:	c7 05 04 72 80 00 01 	movl   $0x1,0x807204
  804be3:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  804be6:	8b 45 08             	mov    0x8(%ebp),%eax
  804be9:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd= daEnd;
  804bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  804bf1:	a3 20 72 80 00       	mov    %eax,0x807220
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  804bf6:	8b 15 20 72 80 00    	mov    0x807220,%edx
  804bfc:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804c01:	29 c2                	sub    %eax,%edx
  804c03:	89 d0                	mov    %edx,%eax
  804c05:	c1 e8 0c             	shr    $0xc,%eax
  804c08:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  804c0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804c12:	eb 2f                	jmp    804c43 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  804c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804c17:	89 d0                	mov    %edx,%eax
  804c19:	01 c0                	add    %eax,%eax
  804c1b:	01 d0                	add    %edx,%eax
  804c1d:	c1 e0 02             	shl    $0x2,%eax
  804c20:	05 48 72 80 00       	add    $0x807248,%eax
  804c25:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  804c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804c2d:	89 d0                	mov    %edx,%eax
  804c2f:	01 c0                	add    %eax,%eax
  804c31:	01 d0                	add    %edx,%eax
  804c33:	c1 e0 02             	shl    $0x2,%eax
  804c36:	05 4a 72 80 00       	add    $0x80724a,%eax
  804c3b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  804c40:	ff 45 f4             	incl   -0xc(%ebp)
  804c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c46:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804c49:	7c c9                	jl     804c14 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  804c4b:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  804c52:	00 00 00 
  804c55:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  804c5c:	00 00 00 
  804c5f:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  804c66:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  804c69:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804c70:	e9 9c 00 00 00       	jmp    804d11 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  804c75:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804c7b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804c7e:	89 c8                	mov    %ecx,%eax
  804c80:	01 c0                	add    %eax,%eax
  804c82:	01 c8                	add    %ecx,%eax
  804c84:	c1 e0 02             	shl    $0x2,%eax
  804c87:	05 44 72 80 00       	add    $0x807244,%eax
  804c8c:	89 10                	mov    %edx,(%eax)
  804c8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804c91:	89 d0                	mov    %edx,%eax
  804c93:	01 c0                	add    %eax,%eax
  804c95:	01 d0                	add    %edx,%eax
  804c97:	c1 e0 02             	shl    $0x2,%eax
  804c9a:	05 44 72 80 00       	add    $0x807244,%eax
  804c9f:	8b 00                	mov    (%eax),%eax
  804ca1:	85 c0                	test   %eax,%eax
  804ca3:	74 1b                	je     804cc0 <initialize_dynamic_allocator+0x10d>
  804ca5:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804cab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804cae:	89 c8                	mov    %ecx,%eax
  804cb0:	01 c0                	add    %eax,%eax
  804cb2:	01 c8                	add    %ecx,%eax
  804cb4:	c1 e0 02             	shl    $0x2,%eax
  804cb7:	05 40 72 80 00       	add    $0x807240,%eax
  804cbc:	89 02                	mov    %eax,(%edx)
  804cbe:	eb 16                	jmp    804cd6 <initialize_dynamic_allocator+0x123>
  804cc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804cc3:	89 d0                	mov    %edx,%eax
  804cc5:	01 c0                	add    %eax,%eax
  804cc7:	01 d0                	add    %edx,%eax
  804cc9:	c1 e0 02             	shl    $0x2,%eax
  804ccc:	05 40 72 80 00       	add    $0x807240,%eax
  804cd1:	a3 28 72 80 00       	mov    %eax,0x807228
  804cd6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804cd9:	89 d0                	mov    %edx,%eax
  804cdb:	01 c0                	add    %eax,%eax
  804cdd:	01 d0                	add    %edx,%eax
  804cdf:	c1 e0 02             	shl    $0x2,%eax
  804ce2:	05 40 72 80 00       	add    $0x807240,%eax
  804ce7:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804cec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804cef:	89 d0                	mov    %edx,%eax
  804cf1:	01 c0                	add    %eax,%eax
  804cf3:	01 d0                	add    %edx,%eax
  804cf5:	c1 e0 02             	shl    $0x2,%eax
  804cf8:	05 40 72 80 00       	add    $0x807240,%eax
  804cfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804d03:	a1 34 72 80 00       	mov    0x807234,%eax
  804d08:	40                   	inc    %eax
  804d09:	a3 34 72 80 00       	mov    %eax,0x807234
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  804d0e:	ff 45 f0             	incl   -0x10(%ebp)
  804d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804d14:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804d17:	0f 8c 58 ff ff ff    	jl     804c75 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  804d1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  804d24:	eb 36                	jmp    804d5c <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  804d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d29:	c1 e0 04             	shl    $0x4,%eax
  804d2c:	05 60 f2 81 00       	add    $0x81f260,%eax
  804d31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d3a:	c1 e0 04             	shl    $0x4,%eax
  804d3d:	05 64 f2 81 00       	add    $0x81f264,%eax
  804d42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d4b:	c1 e0 04             	shl    $0x4,%eax
  804d4e:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804d53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  804d59:	ff 45 ec             	incl   -0x14(%ebp)
  804d5c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804d60:	7e c4                	jle    804d26 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  804d62:	90                   	nop
  804d63:	c9                   	leave  
  804d64:	c3                   	ret    

00804d65 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  804d65:	55                   	push   %ebp
  804d66:	89 e5                	mov    %esp,%ebp
  804d68:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  804d6e:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804d73:	29 c2                	sub    %eax,%edx
  804d75:	89 d0                	mov    %edx,%eax
  804d77:	c1 e8 0c             	shr    $0xc,%eax
  804d7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  804d7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804d80:	89 d0                	mov    %edx,%eax
  804d82:	01 c0                	add    %eax,%eax
  804d84:	01 d0                	add    %edx,%eax
  804d86:	c1 e0 02             	shl    $0x2,%eax
  804d89:	05 48 72 80 00       	add    $0x807248,%eax
  804d8e:	8b 00                	mov    (%eax),%eax
  804d90:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  804d93:	c9                   	leave  
  804d94:	c3                   	ret    

00804d95 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  804d95:	55                   	push   %ebp
  804d96:	89 e5                	mov    %esp,%ebp
  804d98:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  804d9b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  804da2:	76 16                	jbe    804dba <alloc_block+0x25>
  804da4:	68 0c 69 80 00       	push   $0x80690c
  804da9:	68 de 68 80 00       	push   $0x8068de
  804dae:	6a 6c                	push   $0x6c
  804db0:	68 f3 68 80 00       	push   $0x8068f3
  804db5:	e8 c8 cc ff ff       	call   801a82 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  804dba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804dbe:	75 0a                	jne    804dca <alloc_block+0x35>
		return NULL;
  804dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  804dc5:	e9 65 04 00 00       	jmp    80522f <alloc_block+0x49a>
	}
	else if(size<=8){
  804dca:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  804dce:	77 09                	ja     804dd9 <alloc_block+0x44>
		size=8;
  804dd0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  804dd7:	eb 1f                	jmp    804df8 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  804dd9:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  804de0:	eb 08                	jmp    804dea <alloc_block+0x55>
			reqsize*=2;
  804de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804de5:	01 c0                	add    %eax,%eax
  804de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  804dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ded:	3b 45 08             	cmp    0x8(%ebp),%eax
  804df0:	72 f0                	jb     804de2 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  804df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804df5:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  804df8:	83 ec 0c             	sub    $0xc,%esp
  804dfb:	ff 75 08             	pushl  0x8(%ebp)
  804dfe:	e8 90 fd ff ff       	call   804b93 <log2>
  804e03:	83 c4 10             	add    $0x10,%esp
  804e06:	83 e8 03             	sub    $0x3,%eax
  804e09:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  804e0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e0f:	c1 e0 04             	shl    $0x4,%eax
  804e12:	05 60 f2 81 00       	add    $0x81f260,%eax
  804e17:	8b 00                	mov    (%eax),%eax
  804e19:	85 c0                	test   %eax,%eax
  804e1b:	0f 84 fb 00 00 00    	je     804f1c <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  804e21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e24:	c1 e0 04             	shl    $0x4,%eax
  804e27:	05 60 f2 81 00       	add    $0x81f260,%eax
  804e2c:	8b 00                	mov    (%eax),%eax
  804e2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  804e31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804e35:	75 17                	jne    804e4e <alloc_block+0xb9>
  804e37:	83 ec 04             	sub    $0x4,%esp
  804e3a:	68 2d 69 80 00       	push   $0x80692d
  804e3f:	68 86 00 00 00       	push   $0x86
  804e44:	68 f3 68 80 00       	push   $0x8068f3
  804e49:	e8 34 cc ff ff       	call   801a82 <_panic>
  804e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e51:	8b 00                	mov    (%eax),%eax
  804e53:	85 c0                	test   %eax,%eax
  804e55:	74 10                	je     804e67 <alloc_block+0xd2>
  804e57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e5a:	8b 00                	mov    (%eax),%eax
  804e5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804e5f:	8b 52 04             	mov    0x4(%edx),%edx
  804e62:	89 50 04             	mov    %edx,0x4(%eax)
  804e65:	eb 14                	jmp    804e7b <alloc_block+0xe6>
  804e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e6a:	8b 40 04             	mov    0x4(%eax),%eax
  804e6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804e70:	c1 e2 04             	shl    $0x4,%edx
  804e73:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804e79:	89 02                	mov    %eax,(%edx)
  804e7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e7e:	8b 40 04             	mov    0x4(%eax),%eax
  804e81:	85 c0                	test   %eax,%eax
  804e83:	74 0f                	je     804e94 <alloc_block+0xff>
  804e85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e88:	8b 40 04             	mov    0x4(%eax),%eax
  804e8b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804e8e:	8b 12                	mov    (%edx),%edx
  804e90:	89 10                	mov    %edx,(%eax)
  804e92:	eb 13                	jmp    804ea7 <alloc_block+0x112>
  804e94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e97:	8b 00                	mov    (%eax),%eax
  804e99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804e9c:	c1 e2 04             	shl    $0x4,%edx
  804e9f:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804ea5:	89 02                	mov    %eax,(%edx)
  804ea7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804eaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804eb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804eb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804eba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804ebd:	c1 e0 04             	shl    $0x4,%eax
  804ec0:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804ec5:	8b 00                	mov    (%eax),%eax
  804ec7:	8d 50 ff             	lea    -0x1(%eax),%edx
  804eca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804ecd:	c1 e0 04             	shl    $0x4,%eax
  804ed0:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804ed5:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804ed7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804eda:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804edf:	29 c2                	sub    %eax,%edx
  804ee1:	89 d0                	mov    %edx,%eax
  804ee3:	c1 e8 0c             	shr    $0xc,%eax
  804ee6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  804ee9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804eec:	89 d0                	mov    %edx,%eax
  804eee:	01 c0                	add    %eax,%eax
  804ef0:	01 d0                	add    %edx,%eax
  804ef2:	c1 e0 02             	shl    $0x2,%eax
  804ef5:	05 4a 72 80 00       	add    $0x80724a,%eax
  804efa:	66 8b 00             	mov    (%eax),%ax
  804efd:	8d 50 ff             	lea    -0x1(%eax),%edx
  804f00:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  804f03:	89 c8                	mov    %ecx,%eax
  804f05:	01 c0                	add    %eax,%eax
  804f07:	01 c8                	add    %ecx,%eax
  804f09:	c1 e0 02             	shl    $0x2,%eax
  804f0c:	05 4a 72 80 00       	add    $0x80724a,%eax
  804f11:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  804f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804f17:	e9 13 03 00 00       	jmp    80522f <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  804f1c:	a1 28 72 80 00       	mov    0x807228,%eax
  804f21:	85 c0                	test   %eax,%eax
  804f23:	0f 84 c9 01 00 00    	je     8050f2 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  804f29:	a1 28 72 80 00       	mov    0x807228,%eax
  804f2e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  804f31:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804f35:	75 17                	jne    804f4e <alloc_block+0x1b9>
  804f37:	83 ec 04             	sub    $0x4,%esp
  804f3a:	68 2d 69 80 00       	push   $0x80692d
  804f3f:	68 8f 00 00 00       	push   $0x8f
  804f44:	68 f3 68 80 00       	push   $0x8068f3
  804f49:	e8 34 cb ff ff       	call   801a82 <_panic>
  804f4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804f51:	8b 00                	mov    (%eax),%eax
  804f53:	85 c0                	test   %eax,%eax
  804f55:	74 10                	je     804f67 <alloc_block+0x1d2>
  804f57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804f5a:	8b 00                	mov    (%eax),%eax
  804f5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804f5f:	8b 52 04             	mov    0x4(%edx),%edx
  804f62:	89 50 04             	mov    %edx,0x4(%eax)
  804f65:	eb 0b                	jmp    804f72 <alloc_block+0x1dd>
  804f67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804f6a:	8b 40 04             	mov    0x4(%eax),%eax
  804f6d:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804f72:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804f75:	8b 40 04             	mov    0x4(%eax),%eax
  804f78:	85 c0                	test   %eax,%eax
  804f7a:	74 0f                	je     804f8b <alloc_block+0x1f6>
  804f7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804f7f:	8b 40 04             	mov    0x4(%eax),%eax
  804f82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804f85:	8b 12                	mov    (%edx),%edx
  804f87:	89 10                	mov    %edx,(%eax)
  804f89:	eb 0a                	jmp    804f95 <alloc_block+0x200>
  804f8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804f8e:	8b 00                	mov    (%eax),%eax
  804f90:	a3 28 72 80 00       	mov    %eax,0x807228
  804f95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804f98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804f9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804fa1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804fa8:	a1 34 72 80 00       	mov    0x807234,%eax
  804fad:	48                   	dec    %eax
  804fae:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  804fb3:	83 ec 0c             	sub    $0xc,%esp
  804fb6:	ff 75 dc             	pushl  -0x24(%ebp)
  804fb9:	e8 89 fb ff ff       	call   804b47 <to_page_va>
  804fbe:	83 c4 10             	add    $0x10,%esp
  804fc1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  804fc4:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804fc9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804fcc:	29 c2                	sub    %eax,%edx
  804fce:	89 d0                	mov    %edx,%eax
  804fd0:	c1 e8 0c             	shr    $0xc,%eax
  804fd3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  804fd6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804fd9:	83 ec 0c             	sub    $0xc,%esp
  804fdc:	50                   	push   %eax
  804fdd:	e8 fe dc ff ff       	call   802ce0 <get_page>
  804fe2:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  804fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  804fe8:	89 c2                	mov    %eax,%edx
  804fea:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804fed:	89 c8                	mov    %ecx,%eax
  804fef:	01 c0                	add    %eax,%eax
  804ff1:	01 c8                	add    %ecx,%eax
  804ff3:	c1 e0 02             	shl    $0x2,%eax
  804ff6:	05 48 72 80 00       	add    $0x807248,%eax
  804ffb:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  804ffe:	b8 00 10 00 00       	mov    $0x1000,%eax
  805003:	ba 00 00 00 00       	mov    $0x0,%edx
  805008:	f7 75 08             	divl   0x8(%ebp)
  80500b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  80500e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805011:	8d 50 ff             	lea    -0x1(%eax),%edx
  805014:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  805017:	89 c8                	mov    %ecx,%eax
  805019:	01 c0                	add    %eax,%eax
  80501b:	01 c8                	add    %ecx,%eax
  80501d:	c1 e0 02             	shl    $0x2,%eax
  805020:	05 4a 72 80 00       	add    $0x80724a,%eax
  805025:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  805028:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  80502f:	e9 aa 00 00 00       	jmp    8050de <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  805034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805037:	0f af 45 08          	imul   0x8(%ebp),%eax
  80503b:	89 c2                	mov    %eax,%edx
  80503d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  805040:	01 d0                	add    %edx,%eax
  805042:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  805045:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  805049:	75 17                	jne    805062 <alloc_block+0x2cd>
  80504b:	83 ec 04             	sub    $0x4,%esp
  80504e:	68 4c 69 80 00       	push   $0x80694c
  805053:	68 9d 00 00 00       	push   $0x9d
  805058:	68 f3 68 80 00       	push   $0x8068f3
  80505d:	e8 20 ca ff ff       	call   801a82 <_panic>
  805062:	8b 45 e8             	mov    -0x18(%ebp),%eax
  805065:	c1 e0 04             	shl    $0x4,%eax
  805068:	05 64 f2 81 00       	add    $0x81f264,%eax
  80506d:	8b 10                	mov    (%eax),%edx
  80506f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  805072:	89 50 04             	mov    %edx,0x4(%eax)
  805075:	8b 45 cc             	mov    -0x34(%ebp),%eax
  805078:	8b 40 04             	mov    0x4(%eax),%eax
  80507b:	85 c0                	test   %eax,%eax
  80507d:	74 14                	je     805093 <alloc_block+0x2fe>
  80507f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  805082:	c1 e0 04             	shl    $0x4,%eax
  805085:	05 64 f2 81 00       	add    $0x81f264,%eax
  80508a:	8b 00                	mov    (%eax),%eax
  80508c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80508f:	89 10                	mov    %edx,(%eax)
  805091:	eb 11                	jmp    8050a4 <alloc_block+0x30f>
  805093:	8b 45 e8             	mov    -0x18(%ebp),%eax
  805096:	c1 e0 04             	shl    $0x4,%eax
  805099:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  80509f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8050a2:	89 02                	mov    %eax,(%edx)
  8050a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8050a7:	c1 e0 04             	shl    $0x4,%eax
  8050aa:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  8050b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8050b3:	89 02                	mov    %eax,(%edx)
  8050b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8050b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8050be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8050c1:	c1 e0 04             	shl    $0x4,%eax
  8050c4:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8050c9:	8b 00                	mov    (%eax),%eax
  8050cb:	8d 50 01             	lea    0x1(%eax),%edx
  8050ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8050d1:	c1 e0 04             	shl    $0x4,%eax
  8050d4:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8050d9:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  8050db:	ff 45 f0             	incl   -0x10(%ebp)
  8050de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8050e1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8050e4:	0f 8c 4a ff ff ff    	jl     805034 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  8050ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8050ed:	e9 3d 01 00 00       	jmp    80522f <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  8050f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8050f5:	40                   	inc    %eax
  8050f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8050f9:	e9 10 01 00 00       	jmp    80520e <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  8050fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  805101:	c1 e0 04             	shl    $0x4,%eax
  805104:	05 60 f2 81 00       	add    $0x81f260,%eax
  805109:	8b 00                	mov    (%eax),%eax
  80510b:	85 c0                	test   %eax,%eax
  80510d:	0f 84 f8 00 00 00    	je     80520b <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  805113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  805116:	c1 e0 04             	shl    $0x4,%eax
  805119:	05 60 f2 81 00       	add    $0x81f260,%eax
  80511e:	8b 00                	mov    (%eax),%eax
  805120:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  805123:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  805127:	75 17                	jne    805140 <alloc_block+0x3ab>
  805129:	83 ec 04             	sub    $0x4,%esp
  80512c:	68 2d 69 80 00       	push   $0x80692d
  805131:	68 a8 00 00 00       	push   $0xa8
  805136:	68 f3 68 80 00       	push   $0x8068f3
  80513b:	e8 42 c9 ff ff       	call   801a82 <_panic>
  805140:	8b 45 c8             	mov    -0x38(%ebp),%eax
  805143:	8b 00                	mov    (%eax),%eax
  805145:	85 c0                	test   %eax,%eax
  805147:	74 10                	je     805159 <alloc_block+0x3c4>
  805149:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80514c:	8b 00                	mov    (%eax),%eax
  80514e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  805151:	8b 52 04             	mov    0x4(%edx),%edx
  805154:	89 50 04             	mov    %edx,0x4(%eax)
  805157:	eb 14                	jmp    80516d <alloc_block+0x3d8>
  805159:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80515c:	8b 40 04             	mov    0x4(%eax),%eax
  80515f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  805162:	c1 e2 04             	shl    $0x4,%edx
  805165:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  80516b:	89 02                	mov    %eax,(%edx)
  80516d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  805170:	8b 40 04             	mov    0x4(%eax),%eax
  805173:	85 c0                	test   %eax,%eax
  805175:	74 0f                	je     805186 <alloc_block+0x3f1>
  805177:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80517a:	8b 40 04             	mov    0x4(%eax),%eax
  80517d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  805180:	8b 12                	mov    (%edx),%edx
  805182:	89 10                	mov    %edx,(%eax)
  805184:	eb 13                	jmp    805199 <alloc_block+0x404>
  805186:	8b 45 c8             	mov    -0x38(%ebp),%eax
  805189:	8b 00                	mov    (%eax),%eax
  80518b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80518e:	c1 e2 04             	shl    $0x4,%edx
  805191:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  805197:	89 02                	mov    %eax,(%edx)
  805199:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80519c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8051a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8051a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8051ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8051af:	c1 e0 04             	shl    $0x4,%eax
  8051b2:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8051b7:	8b 00                	mov    (%eax),%eax
  8051b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8051bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8051bf:	c1 e0 04             	shl    $0x4,%eax
  8051c2:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8051c7:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  8051c9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8051cc:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8051d1:	29 c2                	sub    %eax,%edx
  8051d3:	89 d0                	mov    %edx,%eax
  8051d5:	c1 e8 0c             	shr    $0xc,%eax
  8051d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  8051db:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8051de:	89 d0                	mov    %edx,%eax
  8051e0:	01 c0                	add    %eax,%eax
  8051e2:	01 d0                	add    %edx,%eax
  8051e4:	c1 e0 02             	shl    $0x2,%eax
  8051e7:	05 4a 72 80 00       	add    $0x80724a,%eax
  8051ec:	66 8b 00             	mov    (%eax),%ax
  8051ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8051f2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8051f5:	89 c8                	mov    %ecx,%eax
  8051f7:	01 c0                	add    %eax,%eax
  8051f9:	01 c8                	add    %ecx,%eax
  8051fb:	c1 e0 02             	shl    $0x2,%eax
  8051fe:	05 4a 72 80 00       	add    $0x80724a,%eax
  805203:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  805206:	8b 45 c8             	mov    -0x38(%ebp),%eax
  805209:	eb 24                	jmp    80522f <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  80520b:	ff 45 ec             	incl   -0x14(%ebp)
  80520e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  805212:	0f 8e e6 fe ff ff    	jle    8050fe <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  805218:	83 ec 04             	sub    $0x4,%esp
  80521b:	68 6f 69 80 00       	push   $0x80696f
  805220:	68 b1 00 00 00       	push   $0xb1
  805225:	68 f3 68 80 00       	push   $0x8068f3
  80522a:	e8 53 c8 ff ff       	call   801a82 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  80522f:	c9                   	leave  
  805230:	c3                   	ret    

00805231 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  805231:	55                   	push   %ebp
  805232:	89 e5                	mov    %esp,%ebp
  805234:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  805237:	8b 55 08             	mov    0x8(%ebp),%edx
  80523a:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80523f:	39 c2                	cmp    %eax,%edx
  805241:	72 0c                	jb     80524f <free_block+0x1e>
  805243:	8b 55 08             	mov    0x8(%ebp),%edx
  805246:	a1 20 72 80 00       	mov    0x807220,%eax
  80524b:	39 c2                	cmp    %eax,%edx
  80524d:	72 19                	jb     805268 <free_block+0x37>
  80524f:	68 8c 69 80 00       	push   $0x80698c
  805254:	68 de 68 80 00       	push   $0x8068de
  805259:	68 c3 00 00 00       	push   $0xc3
  80525e:	68 f3 68 80 00       	push   $0x8068f3
  805263:	e8 1a c8 ff ff       	call   801a82 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  805268:	8b 55 08             	mov    0x8(%ebp),%edx
  80526b:	a1 48 f2 81 00       	mov    0x81f248,%eax
  805270:	29 c2                	sub    %eax,%edx
  805272:	89 d0                	mov    %edx,%eax
  805274:	c1 e8 0c             	shr    $0xc,%eax
  805277:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  80527a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80527d:	89 d0                	mov    %edx,%eax
  80527f:	01 c0                	add    %eax,%eax
  805281:	01 d0                	add    %edx,%eax
  805283:	c1 e0 02             	shl    $0x2,%eax
  805286:	05 48 72 80 00       	add    $0x807248,%eax
  80528b:	8b 00                	mov    (%eax),%eax
  80528d:	0f b7 c0             	movzwl %ax,%eax
  805290:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  805293:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  805297:	75 17                	jne    8052b0 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  805299:	83 ec 04             	sub    $0x4,%esp
  80529c:	68 c4 69 80 00       	push   $0x8069c4
  8052a1:	68 cf 00 00 00       	push   $0xcf
  8052a6:	68 f3 68 80 00       	push   $0x8068f3
  8052ab:	e8 d2 c7 ff ff       	call   801a82 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  8052b0:	83 ec 0c             	sub    $0xc,%esp
  8052b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8052b6:	e8 d8 f8 ff ff       	call   804b93 <log2>
  8052bb:	83 c4 10             	add    $0x10,%esp
  8052be:	83 e8 03             	sub    $0x3,%eax
  8052c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  8052c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8052c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  8052ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8052ce:	75 17                	jne    8052e7 <free_block+0xb6>
  8052d0:	83 ec 04             	sub    $0x4,%esp
  8052d3:	68 4c 69 80 00       	push   $0x80694c
  8052d8:	68 d5 00 00 00       	push   $0xd5
  8052dd:	68 f3 68 80 00       	push   $0x8068f3
  8052e2:	e8 9b c7 ff ff       	call   801a82 <_panic>
  8052e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8052ea:	c1 e0 04             	shl    $0x4,%eax
  8052ed:	05 64 f2 81 00       	add    $0x81f264,%eax
  8052f2:	8b 10                	mov    (%eax),%edx
  8052f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8052f7:	89 50 04             	mov    %edx,0x4(%eax)
  8052fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8052fd:	8b 40 04             	mov    0x4(%eax),%eax
  805300:	85 c0                	test   %eax,%eax
  805302:	74 14                	je     805318 <free_block+0xe7>
  805304:	8b 45 e8             	mov    -0x18(%ebp),%eax
  805307:	c1 e0 04             	shl    $0x4,%eax
  80530a:	05 64 f2 81 00       	add    $0x81f264,%eax
  80530f:	8b 00                	mov    (%eax),%eax
  805311:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  805314:	89 10                	mov    %edx,(%eax)
  805316:	eb 11                	jmp    805329 <free_block+0xf8>
  805318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80531b:	c1 e0 04             	shl    $0x4,%eax
  80531e:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  805324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  805327:	89 02                	mov    %eax,(%edx)
  805329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80532c:	c1 e0 04             	shl    $0x4,%eax
  80532f:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  805335:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  805338:	89 02                	mov    %eax,(%edx)
  80533a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80533d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  805343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  805346:	c1 e0 04             	shl    $0x4,%eax
  805349:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80534e:	8b 00                	mov    (%eax),%eax
  805350:	8d 50 01             	lea    0x1(%eax),%edx
  805353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  805356:	c1 e0 04             	shl    $0x4,%eax
  805359:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80535e:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  805360:	8b 55 f0             	mov    -0x10(%ebp),%edx
  805363:	89 d0                	mov    %edx,%eax
  805365:	01 c0                	add    %eax,%eax
  805367:	01 d0                	add    %edx,%eax
  805369:	c1 e0 02             	shl    $0x2,%eax
  80536c:	05 4a 72 80 00       	add    $0x80724a,%eax
  805371:	66 8b 00             	mov    (%eax),%ax
  805374:	8d 50 01             	lea    0x1(%eax),%edx
  805377:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80537a:	89 c8                	mov    %ecx,%eax
  80537c:	01 c0                	add    %eax,%eax
  80537e:	01 c8                	add    %ecx,%eax
  805380:	c1 e0 02             	shl    $0x2,%eax
  805383:	05 4a 72 80 00       	add    $0x80724a,%eax
  805388:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  80538b:	b8 00 10 00 00       	mov    $0x1000,%eax
  805390:	ba 00 00 00 00       	mov    $0x0,%edx
  805395:	f7 75 ec             	divl   -0x14(%ebp)
  805398:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  80539b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80539e:	89 d0                	mov    %edx,%eax
  8053a0:	01 c0                	add    %eax,%eax
  8053a2:	01 d0                	add    %edx,%eax
  8053a4:	c1 e0 02             	shl    $0x2,%eax
  8053a7:	05 4a 72 80 00       	add    $0x80724a,%eax
  8053ac:	66 8b 00             	mov    (%eax),%ax
  8053af:	0f b7 c0             	movzwl %ax,%eax
  8053b2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8053b5:	0f 85 d3 01 00 00    	jne    80558e <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  8053bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8053be:	c1 e0 04             	shl    $0x4,%eax
  8053c1:	05 60 f2 81 00       	add    $0x81f260,%eax
  8053c6:	8b 00                	mov    (%eax),%eax
  8053c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  8053cb:	e9 f1 00 00 00       	jmp    8054c1 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  8053d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8053d3:	8b 00                	mov    (%eax),%eax
  8053d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  8053d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8053db:	c1 e0 0c             	shl    $0xc,%eax
  8053de:	89 c2                	mov    %eax,%edx
  8053e0:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8053e5:	01 d0                	add    %edx,%eax
  8053e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  8053ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8053ed:	40                   	inc    %eax
  8053ee:	c1 e0 0c             	shl    $0xc,%eax
  8053f1:	89 c2                	mov    %eax,%edx
  8053f3:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8053f8:	01 d0                	add    %edx,%eax
  8053fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  8053fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805400:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  805403:	0f 82 b8 00 00 00    	jb     8054c1 <free_block+0x290>
  805409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80540c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80540f:	0f 83 ac 00 00 00    	jae    8054c1 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  805415:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  805419:	75 17                	jne    805432 <free_block+0x201>
  80541b:	83 ec 04             	sub    $0x4,%esp
  80541e:	68 2d 69 80 00       	push   $0x80692d
  805423:	68 e2 00 00 00       	push   $0xe2
  805428:	68 f3 68 80 00       	push   $0x8068f3
  80542d:	e8 50 c6 ff ff       	call   801a82 <_panic>
  805432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805435:	8b 00                	mov    (%eax),%eax
  805437:	85 c0                	test   %eax,%eax
  805439:	74 10                	je     80544b <free_block+0x21a>
  80543b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80543e:	8b 00                	mov    (%eax),%eax
  805440:	8b 55 f4             	mov    -0xc(%ebp),%edx
  805443:	8b 52 04             	mov    0x4(%edx),%edx
  805446:	89 50 04             	mov    %edx,0x4(%eax)
  805449:	eb 14                	jmp    80545f <free_block+0x22e>
  80544b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80544e:	8b 40 04             	mov    0x4(%eax),%eax
  805451:	8b 55 e8             	mov    -0x18(%ebp),%edx
  805454:	c1 e2 04             	shl    $0x4,%edx
  805457:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  80545d:	89 02                	mov    %eax,(%edx)
  80545f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805462:	8b 40 04             	mov    0x4(%eax),%eax
  805465:	85 c0                	test   %eax,%eax
  805467:	74 0f                	je     805478 <free_block+0x247>
  805469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80546c:	8b 40 04             	mov    0x4(%eax),%eax
  80546f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  805472:	8b 12                	mov    (%edx),%edx
  805474:	89 10                	mov    %edx,(%eax)
  805476:	eb 13                	jmp    80548b <free_block+0x25a>
  805478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80547b:	8b 00                	mov    (%eax),%eax
  80547d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  805480:	c1 e2 04             	shl    $0x4,%edx
  805483:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  805489:	89 02                	mov    %eax,(%edx)
  80548b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80548e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  805494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805497:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80549e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8054a1:	c1 e0 04             	shl    $0x4,%eax
  8054a4:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8054a9:	8b 00                	mov    (%eax),%eax
  8054ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8054ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8054b1:	c1 e0 04             	shl    $0x4,%eax
  8054b4:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8054b9:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  8054bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8054be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  8054c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8054c5:	0f 85 05 ff ff ff    	jne    8053d0 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  8054cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8054ce:	89 d0                	mov    %edx,%eax
  8054d0:	01 c0                	add    %eax,%eax
  8054d2:	01 d0                	add    %edx,%eax
  8054d4:	c1 e0 02             	shl    $0x2,%eax
  8054d7:	05 48 72 80 00       	add    $0x807248,%eax
  8054dc:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  8054e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8054e4:	89 d0                	mov    %edx,%eax
  8054e6:	01 c0                	add    %eax,%eax
  8054e8:	01 d0                	add    %edx,%eax
  8054ea:	c1 e0 02             	shl    $0x2,%eax
  8054ed:	05 4a 72 80 00       	add    $0x80724a,%eax
  8054f2:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  8054f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8054fa:	89 d0                	mov    %edx,%eax
  8054fc:	01 c0                	add    %eax,%eax
  8054fe:	01 d0                	add    %edx,%eax
  805500:	c1 e0 02             	shl    $0x2,%eax
  805503:	05 40 72 80 00       	add    $0x807240,%eax
  805508:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  80550b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80550f:	75 17                	jne    805528 <free_block+0x2f7>
  805511:	83 ec 04             	sub    $0x4,%esp
  805514:	68 4c 69 80 00       	push   $0x80694c
  805519:	68 eb 00 00 00       	push   $0xeb
  80551e:	68 f3 68 80 00       	push   $0x8068f3
  805523:	e8 5a c5 ff ff       	call   801a82 <_panic>
  805528:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  80552e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805531:	89 50 04             	mov    %edx,0x4(%eax)
  805534:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805537:	8b 40 04             	mov    0x4(%eax),%eax
  80553a:	85 c0                	test   %eax,%eax
  80553c:	74 0c                	je     80554a <free_block+0x319>
  80553e:	a1 2c 72 80 00       	mov    0x80722c,%eax
  805543:	8b 55 d0             	mov    -0x30(%ebp),%edx
  805546:	89 10                	mov    %edx,(%eax)
  805548:	eb 08                	jmp    805552 <free_block+0x321>
  80554a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80554d:	a3 28 72 80 00       	mov    %eax,0x807228
  805552:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805555:	a3 2c 72 80 00       	mov    %eax,0x80722c
  80555a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80555d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  805563:	a1 34 72 80 00       	mov    0x807234,%eax
  805568:	40                   	inc    %eax
  805569:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  80556e:	83 ec 0c             	sub    $0xc,%esp
  805571:	ff 75 d0             	pushl  -0x30(%ebp)
  805574:	e8 ce f5 ff ff       	call   804b47 <to_page_va>
  805579:	83 c4 10             	add    $0x10,%esp
  80557c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  80557f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  805582:	83 ec 0c             	sub    $0xc,%esp
  805585:	50                   	push   %eax
  805586:	e8 9e d7 ff ff       	call   802d29 <return_page>
  80558b:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80558e:	90                   	nop
  80558f:	c9                   	leave  
  805590:	c3                   	ret    

00805591 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  805591:	55                   	push   %ebp
  805592:	89 e5                	mov    %esp,%ebp
  805594:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  805597:	83 ec 04             	sub    $0x4,%esp
  80559a:	68 ec 69 80 00       	push   $0x8069ec
  80559f:	68 01 01 00 00       	push   $0x101
  8055a4:	68 f3 68 80 00       	push   $0x8068f3
  8055a9:	e8 d4 c4 ff ff       	call   801a82 <_panic>

008055ae <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  8055ae:	55                   	push   %ebp
  8055af:	89 e5                	mov    %esp,%ebp
  8055b1:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  8055b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8055b8:	74 1c                	je     8055d6 <init_uspinlock+0x28>
  8055ba:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8055be:	74 16                	je     8055d6 <init_uspinlock+0x28>
  8055c0:	68 10 6a 80 00       	push   $0x806a10
  8055c5:	68 2f 6a 80 00       	push   $0x806a2f
  8055ca:	6a 10                	push   $0x10
  8055cc:	68 44 6a 80 00       	push   $0x806a44
  8055d1:	e8 ac c4 ff ff       	call   801a82 <_panic>
	strcpy(lk->name, name);
  8055d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8055d9:	83 c0 04             	add    $0x4,%eax
  8055dc:	83 ec 08             	sub    $0x8,%esp
  8055df:	ff 75 0c             	pushl  0xc(%ebp)
  8055e2:	50                   	push   %eax
  8055e3:	e8 90 ce ff ff       	call   802478 <strcpy>
  8055e8:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  8055eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8055f0:	2b 45 10             	sub    0x10(%ebp),%eax
  8055f3:	89 c2                	mov    %eax,%edx
  8055f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8055f8:	89 10                	mov    %edx,(%eax)
}
  8055fa:	90                   	nop
  8055fb:	c9                   	leave  
  8055fc:	c3                   	ret    

008055fd <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8055fd:	55                   	push   %ebp
  8055fe:	89 e5                	mov    %esp,%ebp
  805600:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  805603:	90                   	nop
  805604:	8b 45 08             	mov    0x8(%ebp),%eax
  805607:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80560a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  805611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  805614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805617:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80561a:	f0 87 02             	lock xchg %eax,(%edx)
  80561d:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  805620:	8b 45 ec             	mov    -0x14(%ebp),%eax
  805623:	85 c0                	test   %eax,%eax
  805625:	75 dd                	jne    805604 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  805627:	8b 45 08             	mov    0x8(%ebp),%eax
  80562a:	8d 48 04             	lea    0x4(%eax),%ecx
  80562d:	a1 00 72 80 00       	mov    0x807200,%eax
  805632:	8d 50 20             	lea    0x20(%eax),%edx
  805635:	a1 00 72 80 00       	mov    0x807200,%eax
  80563a:	8b 40 10             	mov    0x10(%eax),%eax
  80563d:	51                   	push   %ecx
  80563e:	52                   	push   %edx
  80563f:	50                   	push   %eax
  805640:	68 54 6a 80 00       	push   $0x806a54
  805645:	e8 06 c7 ff ff       	call   801d50 <cprintf>
  80564a:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  80564d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  805652:	90                   	nop
  805653:	c9                   	leave  
  805654:	c3                   	ret    

00805655 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  805655:	55                   	push   %ebp
  805656:	89 e5                	mov    %esp,%ebp
  805658:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  80565b:	8b 45 08             	mov    0x8(%ebp),%eax
  80565e:	8b 00                	mov    (%eax),%eax
  805660:	85 c0                	test   %eax,%eax
  805662:	75 18                	jne    80567c <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  805664:	8b 45 08             	mov    0x8(%ebp),%eax
  805667:	83 c0 04             	add    $0x4,%eax
  80566a:	50                   	push   %eax
  80566b:	68 78 6a 80 00       	push   $0x806a78
  805670:	6a 2b                	push   $0x2b
  805672:	68 44 6a 80 00       	push   $0x806a44
  805677:	e8 06 c4 ff ff       	call   801a82 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  80567c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  805681:	8b 45 08             	mov    0x8(%ebp),%eax
  805684:	8b 55 08             	mov    0x8(%ebp),%edx
  805687:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80568d:	8b 45 08             	mov    0x8(%ebp),%eax
  805690:	8d 48 04             	lea    0x4(%eax),%ecx
  805693:	a1 00 72 80 00       	mov    0x807200,%eax
  805698:	8d 50 20             	lea    0x20(%eax),%edx
  80569b:	a1 00 72 80 00       	mov    0x807200,%eax
  8056a0:	8b 40 10             	mov    0x10(%eax),%eax
  8056a3:	51                   	push   %ecx
  8056a4:	52                   	push   %edx
  8056a5:	50                   	push   %eax
  8056a6:	68 98 6a 80 00       	push   $0x806a98
  8056ab:	e8 a0 c6 ff ff       	call   801d50 <cprintf>
  8056b0:	83 c4 10             	add    $0x10,%esp
}
  8056b3:	90                   	nop
  8056b4:	c9                   	leave  
  8056b5:	c3                   	ret    
  8056b6:	66 90                	xchg   %ax,%ax

008056b8 <__udivdi3>:
  8056b8:	55                   	push   %ebp
  8056b9:	57                   	push   %edi
  8056ba:	56                   	push   %esi
  8056bb:	53                   	push   %ebx
  8056bc:	83 ec 1c             	sub    $0x1c,%esp
  8056bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8056c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8056c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8056cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8056cf:	89 ca                	mov    %ecx,%edx
  8056d1:	89 f8                	mov    %edi,%eax
  8056d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8056d7:	85 f6                	test   %esi,%esi
  8056d9:	75 2d                	jne    805708 <__udivdi3+0x50>
  8056db:	39 cf                	cmp    %ecx,%edi
  8056dd:	77 65                	ja     805744 <__udivdi3+0x8c>
  8056df:	89 fd                	mov    %edi,%ebp
  8056e1:	85 ff                	test   %edi,%edi
  8056e3:	75 0b                	jne    8056f0 <__udivdi3+0x38>
  8056e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8056ea:	31 d2                	xor    %edx,%edx
  8056ec:	f7 f7                	div    %edi
  8056ee:	89 c5                	mov    %eax,%ebp
  8056f0:	31 d2                	xor    %edx,%edx
  8056f2:	89 c8                	mov    %ecx,%eax
  8056f4:	f7 f5                	div    %ebp
  8056f6:	89 c1                	mov    %eax,%ecx
  8056f8:	89 d8                	mov    %ebx,%eax
  8056fa:	f7 f5                	div    %ebp
  8056fc:	89 cf                	mov    %ecx,%edi
  8056fe:	89 fa                	mov    %edi,%edx
  805700:	83 c4 1c             	add    $0x1c,%esp
  805703:	5b                   	pop    %ebx
  805704:	5e                   	pop    %esi
  805705:	5f                   	pop    %edi
  805706:	5d                   	pop    %ebp
  805707:	c3                   	ret    
  805708:	39 ce                	cmp    %ecx,%esi
  80570a:	77 28                	ja     805734 <__udivdi3+0x7c>
  80570c:	0f bd fe             	bsr    %esi,%edi
  80570f:	83 f7 1f             	xor    $0x1f,%edi
  805712:	75 40                	jne    805754 <__udivdi3+0x9c>
  805714:	39 ce                	cmp    %ecx,%esi
  805716:	72 0a                	jb     805722 <__udivdi3+0x6a>
  805718:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80571c:	0f 87 9e 00 00 00    	ja     8057c0 <__udivdi3+0x108>
  805722:	b8 01 00 00 00       	mov    $0x1,%eax
  805727:	89 fa                	mov    %edi,%edx
  805729:	83 c4 1c             	add    $0x1c,%esp
  80572c:	5b                   	pop    %ebx
  80572d:	5e                   	pop    %esi
  80572e:	5f                   	pop    %edi
  80572f:	5d                   	pop    %ebp
  805730:	c3                   	ret    
  805731:	8d 76 00             	lea    0x0(%esi),%esi
  805734:	31 ff                	xor    %edi,%edi
  805736:	31 c0                	xor    %eax,%eax
  805738:	89 fa                	mov    %edi,%edx
  80573a:	83 c4 1c             	add    $0x1c,%esp
  80573d:	5b                   	pop    %ebx
  80573e:	5e                   	pop    %esi
  80573f:	5f                   	pop    %edi
  805740:	5d                   	pop    %ebp
  805741:	c3                   	ret    
  805742:	66 90                	xchg   %ax,%ax
  805744:	89 d8                	mov    %ebx,%eax
  805746:	f7 f7                	div    %edi
  805748:	31 ff                	xor    %edi,%edi
  80574a:	89 fa                	mov    %edi,%edx
  80574c:	83 c4 1c             	add    $0x1c,%esp
  80574f:	5b                   	pop    %ebx
  805750:	5e                   	pop    %esi
  805751:	5f                   	pop    %edi
  805752:	5d                   	pop    %ebp
  805753:	c3                   	ret    
  805754:	bd 20 00 00 00       	mov    $0x20,%ebp
  805759:	89 eb                	mov    %ebp,%ebx
  80575b:	29 fb                	sub    %edi,%ebx
  80575d:	89 f9                	mov    %edi,%ecx
  80575f:	d3 e6                	shl    %cl,%esi
  805761:	89 c5                	mov    %eax,%ebp
  805763:	88 d9                	mov    %bl,%cl
  805765:	d3 ed                	shr    %cl,%ebp
  805767:	89 e9                	mov    %ebp,%ecx
  805769:	09 f1                	or     %esi,%ecx
  80576b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80576f:	89 f9                	mov    %edi,%ecx
  805771:	d3 e0                	shl    %cl,%eax
  805773:	89 c5                	mov    %eax,%ebp
  805775:	89 d6                	mov    %edx,%esi
  805777:	88 d9                	mov    %bl,%cl
  805779:	d3 ee                	shr    %cl,%esi
  80577b:	89 f9                	mov    %edi,%ecx
  80577d:	d3 e2                	shl    %cl,%edx
  80577f:	8b 44 24 08          	mov    0x8(%esp),%eax
  805783:	88 d9                	mov    %bl,%cl
  805785:	d3 e8                	shr    %cl,%eax
  805787:	09 c2                	or     %eax,%edx
  805789:	89 d0                	mov    %edx,%eax
  80578b:	89 f2                	mov    %esi,%edx
  80578d:	f7 74 24 0c          	divl   0xc(%esp)
  805791:	89 d6                	mov    %edx,%esi
  805793:	89 c3                	mov    %eax,%ebx
  805795:	f7 e5                	mul    %ebp
  805797:	39 d6                	cmp    %edx,%esi
  805799:	72 19                	jb     8057b4 <__udivdi3+0xfc>
  80579b:	74 0b                	je     8057a8 <__udivdi3+0xf0>
  80579d:	89 d8                	mov    %ebx,%eax
  80579f:	31 ff                	xor    %edi,%edi
  8057a1:	e9 58 ff ff ff       	jmp    8056fe <__udivdi3+0x46>
  8057a6:	66 90                	xchg   %ax,%ax
  8057a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8057ac:	89 f9                	mov    %edi,%ecx
  8057ae:	d3 e2                	shl    %cl,%edx
  8057b0:	39 c2                	cmp    %eax,%edx
  8057b2:	73 e9                	jae    80579d <__udivdi3+0xe5>
  8057b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8057b7:	31 ff                	xor    %edi,%edi
  8057b9:	e9 40 ff ff ff       	jmp    8056fe <__udivdi3+0x46>
  8057be:	66 90                	xchg   %ax,%ax
  8057c0:	31 c0                	xor    %eax,%eax
  8057c2:	e9 37 ff ff ff       	jmp    8056fe <__udivdi3+0x46>
  8057c7:	90                   	nop

008057c8 <__umoddi3>:
  8057c8:	55                   	push   %ebp
  8057c9:	57                   	push   %edi
  8057ca:	56                   	push   %esi
  8057cb:	53                   	push   %ebx
  8057cc:	83 ec 1c             	sub    $0x1c,%esp
  8057cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8057d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8057d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8057db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8057df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8057e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8057e7:	89 f3                	mov    %esi,%ebx
  8057e9:	89 fa                	mov    %edi,%edx
  8057eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8057ef:	89 34 24             	mov    %esi,(%esp)
  8057f2:	85 c0                	test   %eax,%eax
  8057f4:	75 1a                	jne    805810 <__umoddi3+0x48>
  8057f6:	39 f7                	cmp    %esi,%edi
  8057f8:	0f 86 a2 00 00 00    	jbe    8058a0 <__umoddi3+0xd8>
  8057fe:	89 c8                	mov    %ecx,%eax
  805800:	89 f2                	mov    %esi,%edx
  805802:	f7 f7                	div    %edi
  805804:	89 d0                	mov    %edx,%eax
  805806:	31 d2                	xor    %edx,%edx
  805808:	83 c4 1c             	add    $0x1c,%esp
  80580b:	5b                   	pop    %ebx
  80580c:	5e                   	pop    %esi
  80580d:	5f                   	pop    %edi
  80580e:	5d                   	pop    %ebp
  80580f:	c3                   	ret    
  805810:	39 f0                	cmp    %esi,%eax
  805812:	0f 87 ac 00 00 00    	ja     8058c4 <__umoddi3+0xfc>
  805818:	0f bd e8             	bsr    %eax,%ebp
  80581b:	83 f5 1f             	xor    $0x1f,%ebp
  80581e:	0f 84 ac 00 00 00    	je     8058d0 <__umoddi3+0x108>
  805824:	bf 20 00 00 00       	mov    $0x20,%edi
  805829:	29 ef                	sub    %ebp,%edi
  80582b:	89 fe                	mov    %edi,%esi
  80582d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  805831:	89 e9                	mov    %ebp,%ecx
  805833:	d3 e0                	shl    %cl,%eax
  805835:	89 d7                	mov    %edx,%edi
  805837:	89 f1                	mov    %esi,%ecx
  805839:	d3 ef                	shr    %cl,%edi
  80583b:	09 c7                	or     %eax,%edi
  80583d:	89 e9                	mov    %ebp,%ecx
  80583f:	d3 e2                	shl    %cl,%edx
  805841:	89 14 24             	mov    %edx,(%esp)
  805844:	89 d8                	mov    %ebx,%eax
  805846:	d3 e0                	shl    %cl,%eax
  805848:	89 c2                	mov    %eax,%edx
  80584a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80584e:	d3 e0                	shl    %cl,%eax
  805850:	89 44 24 04          	mov    %eax,0x4(%esp)
  805854:	8b 44 24 08          	mov    0x8(%esp),%eax
  805858:	89 f1                	mov    %esi,%ecx
  80585a:	d3 e8                	shr    %cl,%eax
  80585c:	09 d0                	or     %edx,%eax
  80585e:	d3 eb                	shr    %cl,%ebx
  805860:	89 da                	mov    %ebx,%edx
  805862:	f7 f7                	div    %edi
  805864:	89 d3                	mov    %edx,%ebx
  805866:	f7 24 24             	mull   (%esp)
  805869:	89 c6                	mov    %eax,%esi
  80586b:	89 d1                	mov    %edx,%ecx
  80586d:	39 d3                	cmp    %edx,%ebx
  80586f:	0f 82 87 00 00 00    	jb     8058fc <__umoddi3+0x134>
  805875:	0f 84 91 00 00 00    	je     80590c <__umoddi3+0x144>
  80587b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80587f:	29 f2                	sub    %esi,%edx
  805881:	19 cb                	sbb    %ecx,%ebx
  805883:	89 d8                	mov    %ebx,%eax
  805885:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  805889:	d3 e0                	shl    %cl,%eax
  80588b:	89 e9                	mov    %ebp,%ecx
  80588d:	d3 ea                	shr    %cl,%edx
  80588f:	09 d0                	or     %edx,%eax
  805891:	89 e9                	mov    %ebp,%ecx
  805893:	d3 eb                	shr    %cl,%ebx
  805895:	89 da                	mov    %ebx,%edx
  805897:	83 c4 1c             	add    $0x1c,%esp
  80589a:	5b                   	pop    %ebx
  80589b:	5e                   	pop    %esi
  80589c:	5f                   	pop    %edi
  80589d:	5d                   	pop    %ebp
  80589e:	c3                   	ret    
  80589f:	90                   	nop
  8058a0:	89 fd                	mov    %edi,%ebp
  8058a2:	85 ff                	test   %edi,%edi
  8058a4:	75 0b                	jne    8058b1 <__umoddi3+0xe9>
  8058a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8058ab:	31 d2                	xor    %edx,%edx
  8058ad:	f7 f7                	div    %edi
  8058af:	89 c5                	mov    %eax,%ebp
  8058b1:	89 f0                	mov    %esi,%eax
  8058b3:	31 d2                	xor    %edx,%edx
  8058b5:	f7 f5                	div    %ebp
  8058b7:	89 c8                	mov    %ecx,%eax
  8058b9:	f7 f5                	div    %ebp
  8058bb:	89 d0                	mov    %edx,%eax
  8058bd:	e9 44 ff ff ff       	jmp    805806 <__umoddi3+0x3e>
  8058c2:	66 90                	xchg   %ax,%ax
  8058c4:	89 c8                	mov    %ecx,%eax
  8058c6:	89 f2                	mov    %esi,%edx
  8058c8:	83 c4 1c             	add    $0x1c,%esp
  8058cb:	5b                   	pop    %ebx
  8058cc:	5e                   	pop    %esi
  8058cd:	5f                   	pop    %edi
  8058ce:	5d                   	pop    %ebp
  8058cf:	c3                   	ret    
  8058d0:	3b 04 24             	cmp    (%esp),%eax
  8058d3:	72 06                	jb     8058db <__umoddi3+0x113>
  8058d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8058d9:	77 0f                	ja     8058ea <__umoddi3+0x122>
  8058db:	89 f2                	mov    %esi,%edx
  8058dd:	29 f9                	sub    %edi,%ecx
  8058df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8058e3:	89 14 24             	mov    %edx,(%esp)
  8058e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8058ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8058ee:	8b 14 24             	mov    (%esp),%edx
  8058f1:	83 c4 1c             	add    $0x1c,%esp
  8058f4:	5b                   	pop    %ebx
  8058f5:	5e                   	pop    %esi
  8058f6:	5f                   	pop    %edi
  8058f7:	5d                   	pop    %ebp
  8058f8:	c3                   	ret    
  8058f9:	8d 76 00             	lea    0x0(%esi),%esi
  8058fc:	2b 04 24             	sub    (%esp),%eax
  8058ff:	19 fa                	sbb    %edi,%edx
  805901:	89 d1                	mov    %edx,%ecx
  805903:	89 c6                	mov    %eax,%esi
  805905:	e9 71 ff ff ff       	jmp    80587b <__umoddi3+0xb3>
  80590a:	66 90                	xchg   %ax,%ax
  80590c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  805910:	72 ea                	jb     8058fc <__umoddi3+0x134>
  805912:	89 d9                	mov    %ebx,%ecx
  805914:	e9 62 ff ff ff       	jmp    80587b <__umoddi3+0xb3>
