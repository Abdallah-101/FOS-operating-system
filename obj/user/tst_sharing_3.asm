
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 a7 13 00 00       	call   8013dd <libmain>
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
  800067:	e8 63 41 00 00       	call   8041cf <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 a6 41 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 b6 27 00 00       	call   80287d <malloc>
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
  8000df:	e8 eb 40 00 00       	call   8041cf <sys_calculate_free_frames>
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
  800125:	68 40 54 80 00       	push   $0x805440
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 60 17 00 00       	call   801891 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 e1 40 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 bc 54 80 00       	push   $0x8054bc
  800150:	6a 0c                	push   $0xc
  800152:	e8 3a 17 00 00       	call   801891 <cprintf_colored>
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
  800174:	e8 56 40 00 00       	call   8041cf <sys_calculate_free_frames>
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
  8001b9:	e8 11 40 00 00       	call   8041cf <sys_calculate_free_frames>
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
  8001f8:	68 34 55 80 00       	push   $0x805534
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 8d 16 00 00       	call   801891 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 0e 40 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 c0 55 80 00       	push   $0x8055c0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 60 16 00 00       	call   801891 <cprintf_colored>
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
  800270:	e8 1c 43 00 00       	call   804591 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 38 56 80 00       	push   $0x805638
  80028f:	6a 0c                	push   $0xc
  800291:	e8 fb 15 00 00       	call   801891 <cprintf_colored>
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
  8002ae:	e8 1c 3f 00 00       	call   8041cf <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 5f 3f 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 aa 2a 00 00       	call   802d7b <free>
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
  8002fc:	e8 19 3f 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 70 56 80 00       	push   $0x805670
  800318:	6a 0c                	push   $0xc
  80031a:	e8 72 15 00 00       	call   801891 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 a8 3e 00 00       	call   8041cf <sys_calculate_free_frames>
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
  800342:	68 bc 56 80 00       	push   $0x8056bc
  800347:	6a 0c                	push   $0xc
  800349:	e8 43 15 00 00       	call   801891 <cprintf_colored>
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
  8003a0:	e8 ec 41 00 00       	call   804591 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 18 57 80 00       	push   $0x805718
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 cb 14 00 00       	call   801891 <cprintf_colored>
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
  800416:	68 50 57 80 00       	push   $0x805750
  80041b:	6a 03                	push   $0x3
  80041d:	e8 6f 14 00 00       	call   801891 <cprintf_colored>
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
  8004df:	68 80 57 80 00       	push   $0x805780
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 a6 13 00 00       	call   801891 <cprintf_colored>
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
  8005b9:	68 80 57 80 00       	push   $0x805780
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 cc 12 00 00       	call   801891 <cprintf_colored>
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
  800693:	68 80 57 80 00       	push   $0x805780
  800698:	6a 0c                	push   $0xc
  80069a:	e8 f2 11 00 00       	call   801891 <cprintf_colored>
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
  80076d:	68 80 57 80 00       	push   $0x805780
  800772:	6a 0c                	push   $0xc
  800774:	e8 18 11 00 00       	call   801891 <cprintf_colored>
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
  800847:	68 80 57 80 00       	push   $0x805780
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 3e 10 00 00       	call   801891 <cprintf_colored>
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
  800921:	68 80 57 80 00       	push   $0x805780
  800926:	6a 0c                	push   $0xc
  800928:	e8 64 0f 00 00       	call   801891 <cprintf_colored>
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
  800a16:	68 80 57 80 00       	push   $0x805780
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 6f 0e 00 00       	call   801891 <cprintf_colored>
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
  800b14:	68 80 57 80 00       	push   $0x805780
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 71 0d 00 00       	call   801891 <cprintf_colored>
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
  800c12:	68 80 57 80 00       	push   $0x805780
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 73 0c 00 00       	call   801891 <cprintf_colored>
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
  800d10:	68 80 57 80 00       	push   $0x805780
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 75 0b 00 00       	call   801891 <cprintf_colored>
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
  800dfd:	68 80 57 80 00       	push   $0x805780
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 88 0a 00 00       	call   801891 <cprintf_colored>
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
  800eea:	68 80 57 80 00       	push   $0x805780
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 9b 09 00 00       	call   801891 <cprintf_colored>
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
  800fd7:	68 80 57 80 00       	push   $0x805780
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 ae 08 00 00       	call   801891 <cprintf_colored>
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
  800ffa:	68 d2 57 80 00       	push   $0x8057d2
  800fff:	6a 03                	push   $0x3
  801001:	e8 8b 08 00 00       	call   801891 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 b0 31 00 00       	call   8041cf <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 f0 31 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
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
  801055:	e8 23 18 00 00       	call   80287d <malloc>
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
  801084:	68 f0 57 80 00       	push   $0x8057f0
  801089:	6a 0c                	push   $0xc
  80108b:	e8 01 08 00 00       	call   801891 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 82 31 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 2c 58 80 00       	push   $0x80582c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 d5 07 00 00       	call   801891 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 0b 31 00 00       	call   8041cf <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 9c 58 80 00       	push   $0x80589c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 a9 07 00 00       	call   801891 <cprintf_colored>
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

void
_main(void)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	83 ec 28             	sub    $0x28,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801105:	a1 00 72 80 00       	mov    0x807200,%eax
  80110a:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801110:	a1 00 72 80 00       	mov    0x807200,%eax
  801115:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80111b:	39 c2                	cmp    %eax,%edx
  80111d:	72 14                	jb     801133 <_main+0x34>
			panic("Please increase the WS size");
  80111f:	83 ec 04             	sub    $0x4,%esp
  801122:	68 e4 58 80 00       	push   $0x8058e4
  801127:	6a 0d                	push   $0xd
  801129:	68 00 59 80 00       	push   $0x805900
  80112e:	e8 63 04 00 00       	call   801596 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf_colored(TEXT_yellow, "%~************************************************\n");
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	68 18 59 80 00       	push   $0x805918
  80113b:	6a 0e                	push   $0xe
  80113d:	e8 4f 07 00 00       	call   801891 <cprintf_colored>
  801142:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	68 4c 59 80 00       	push   $0x80594c
  80114d:	6a 0e                	push   $0xe
  80114f:	e8 3d 07 00 00       	call   801891 <cprintf_colored>
  801154:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~************************************************\n\n\n");
  801157:	83 ec 08             	sub    $0x8,%esp
  80115a:	68 a8 59 80 00       	push   $0x8059a8
  80115f:	6a 0e                	push   $0xe
  801161:	e8 2b 07 00 00       	call   801891 <cprintf_colored>
  801166:	83 c4 10             	add    $0x10,%esp

	int eval = 0;
  801169:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  801170:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801177:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)
	int freeFrames, usedDiskPages ;

	uint32 *x, *y, *z ;
	cprintf_colored(TEXT_cyan, "\n%~STEP A: checking creation of shared object that is already exists... [35%] \n\n");
  80117e:	83 ec 08             	sub    $0x8,%esp
  801181:	68 e0 59 80 00       	push   $0x8059e0
  801186:	6a 03                	push   $0x3
  801188:	e8 04 07 00 00       	call   801891 <cprintf_colored>
  80118d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  801190:	83 ec 04             	sub    $0x4,%esp
  801193:	6a 01                	push   $0x1
  801195:	68 00 10 00 00       	push   $0x1000
  80119a:	68 31 5a 80 00       	push   $0x805a31
  80119f:	e8 67 23 00 00       	call   80350b <smalloc>
  8011a4:	83 c4 10             	add    $0x10,%esp
  8011a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8011aa:	e8 20 30 00 00       	call   8041cf <sys_calculate_free_frames>
  8011af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8011b2:	e8 63 30 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
  8011b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	6a 01                	push   $0x1
  8011bf:	68 00 10 00 00       	push   $0x1000
  8011c4:	68 31 5a 80 00       	push   $0x805a31
  8011c9:	e8 3d 23 00 00       	call   80350b <smalloc>
  8011ce:	83 c4 10             	add    $0x10,%esp
  8011d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0;
  8011d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8011d8:	74 19                	je     8011f3 <_main+0xf4>
  8011da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		cprintf_colored(TEXT_TESTERR_CLR, "%~Trying to create an already exists object and corresponding error is not returned!!");}
  8011e1:	83 ec 08             	sub    $0x8,%esp
  8011e4:	68 34 5a 80 00       	push   $0x805a34
  8011e9:	6a 0c                	push   $0xc
  8011eb:	e8 a1 06 00 00       	call   801891 <cprintf_colored>
  8011f0:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0)
  8011f3:	e8 d7 2f 00 00       	call   8041cf <sys_calculate_free_frames>
  8011f8:	89 c2                	mov    %eax,%edx
  8011fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011fd:	39 c2                	cmp    %eax,%edx
  8011ff:	74 19                	je     80121a <_main+0x11b>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  801201:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801208:	83 ec 08             	sub    $0x8,%esp
  80120b:	68 8c 5a 80 00       	push   $0x805a8c
  801210:	6a 0c                	push   $0xc
  801212:	e8 7a 06 00 00       	call   801891 <cprintf_colored>
  801217:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  80121a:	e8 fb 2f 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
  80121f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801222:	74 19                	je     80123d <_main+0x13e>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  801224:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80122b:	83 ec 08             	sub    $0x8,%esp
  80122e:	68 ec 5a 80 00       	push   $0x805aec
  801233:	6a 0c                	push   $0xc
  801235:	e8 57 06 00 00       	call   801891 <cprintf_colored>
  80123a:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  80123d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801241:	74 04                	je     801247 <_main+0x148>
  801243:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  801247:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_cyan, "\n%~STEP B: checking getting shared object that is NOT exists... [35%]\n\n");
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	68 0c 5b 80 00       	push   $0x805b0c
  801256:	6a 03                	push   $0x3
  801258:	e8 34 06 00 00       	call   801891 <cprintf_colored>
  80125d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  801260:	a1 00 72 80 00       	mov    0x807200,%eax
  801265:	8b 40 10             	mov    0x10(%eax),%eax
  801268:	83 ec 08             	sub    $0x8,%esp
  80126b:	68 54 5b 80 00       	push   $0x805b54
  801270:	50                   	push   %eax
  801271:	e8 3c 28 00 00       	call   803ab2 <sget>
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	89 45 e8             	mov    %eax,-0x18(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80127c:	e8 4e 2f 00 00       	call   8041cf <sys_calculate_free_frames>
  801281:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801284:	e8 91 2f 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
  801289:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL)
  80128c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801290:	74 19                	je     8012ab <_main+0x1ac>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Trying to get a NONE existing object and corresponding error is not returned!!");}
  801292:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801299:	83 ec 08             	sub    $0x8,%esp
  80129c:	68 58 5b 80 00       	push   $0x805b58
  8012a1:	6a 0c                	push   $0xc
  8012a3:	e8 e9 05 00 00       	call   801891 <cprintf_colored>
  8012a8:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0)
  8012ab:	e8 1f 2f 00 00       	call   8041cf <sys_calculate_free_frames>
  8012b0:	89 c2                	mov    %eax,%edx
  8012b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b5:	39 c2                	cmp    %eax,%edx
  8012b7:	74 19                	je     8012d2 <_main+0x1d3>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8012b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	68 ac 5b 80 00       	push   $0x805bac
  8012c8:	6a 0c                	push   $0xc
  8012ca:	e8 c2 05 00 00       	call   801891 <cprintf_colored>
  8012cf:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8012d2:	e8 43 2f 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
  8012d7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8012da:	74 19                	je     8012f5 <_main+0x1f6>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  8012dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012e3:	83 ec 08             	sub    $0x8,%esp
  8012e6:	68 ec 5a 80 00       	push   $0x805aec
  8012eb:	6a 0c                	push   $0xc
  8012ed:	e8 9f 05 00 00       	call   801891 <cprintf_colored>
  8012f2:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  8012f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012f9:	74 04                	je     8012ff <_main+0x200>
  8012fb:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  8012ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_cyan, "\n%~STEP C: checking the creation of shared object that exceeds the SHARED area limit... [30%]\n\n");
  801306:	83 ec 08             	sub    $0x8,%esp
  801309:	68 08 5c 80 00       	push   $0x805c08
  80130e:	6a 03                	push   $0x3
  801310:	e8 7c 05 00 00       	call   801891 <cprintf_colored>
  801315:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  801318:	e8 b2 2e 00 00       	call   8041cf <sys_calculate_free_frames>
  80131d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801320:	e8 f5 2e 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
  801325:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  801328:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  80132d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801330:	89 45 dc             	mov    %eax,-0x24(%ebp)
		y = smalloc("y", size, 1);
  801333:	83 ec 04             	sub    $0x4,%esp
  801336:	6a 01                	push   $0x1
  801338:	ff 75 dc             	pushl  -0x24(%ebp)
  80133b:	68 68 5c 80 00       	push   $0x805c68
  801340:	e8 c6 21 00 00       	call   80350b <smalloc>
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL)
  80134b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80134f:	74 19                	je     80136a <_main+0x26b>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  801351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801358:	83 ec 08             	sub    $0x8,%esp
  80135b:	68 6c 5c 80 00       	push   $0x805c6c
  801360:	6a 0c                	push   $0xc
  801362:	e8 2a 05 00 00       	call   801891 <cprintf_colored>
  801367:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0)
  80136a:	e8 60 2e 00 00       	call   8041cf <sys_calculate_free_frames>
  80136f:	89 c2                	mov    %eax,%edx
  801371:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801374:	39 c2                	cmp    %eax,%edx
  801376:	74 19                	je     801391 <_main+0x292>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  801378:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80137f:	83 ec 08             	sub    $0x8,%esp
  801382:	68 e0 5c 80 00       	push   $0x805ce0
  801387:	6a 0c                	push   $0xc
  801389:	e8 03 05 00 00       	call   801891 <cprintf_colored>
  80138e:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801391:	e8 84 2e 00 00       	call   80421a <sys_pf_calculate_allocated_pages>
  801396:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801399:	74 19                	je     8013b4 <_main+0x2b5>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  80139b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013a2:	83 ec 08             	sub    $0x8,%esp
  8013a5:	68 ec 5a 80 00       	push   $0x805aec
  8013aa:	6a 0c                	push   $0xc
  8013ac:	e8 e0 04 00 00       	call   801891 <cprintf_colored>
  8013b1:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=30;
  8013b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b8:	74 04                	je     8013be <_main+0x2bf>
  8013ba:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	is_correct = 1;
  8013be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_light_green, "%~\nTest of Shared Variables [Create & Get: Special Cases] completed. Eval = %d%%\n\n", eval);
  8013c5:	83 ec 04             	sub    $0x4,%esp
  8013c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8013cb:	68 54 5d 80 00       	push   $0x805d54
  8013d0:	6a 0a                	push   $0xa
  8013d2:	e8 ba 04 00 00       	call   801891 <cprintf_colored>
  8013d7:	83 c4 10             	add    $0x10,%esp

}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	57                   	push   %edi
  8013e1:	56                   	push   %esi
  8013e2:	53                   	push   %ebx
  8013e3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8013e6:	e8 ad 2f 00 00       	call   804398 <sys_getenvindex>
  8013eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8013ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f1:	89 d0                	mov    %edx,%eax
  8013f3:	c1 e0 02             	shl    $0x2,%eax
  8013f6:	01 d0                	add    %edx,%eax
  8013f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ff:	01 d0                	add    %edx,%eax
  801401:	89 c2                	mov    %eax,%edx
  801403:	c1 e2 04             	shl    $0x4,%edx
  801406:	29 c2                	sub    %eax,%edx
  801408:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80140f:	89 c2                	mov    %eax,%edx
  801411:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  801417:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80141c:	a1 00 72 80 00       	mov    0x807200,%eax
  801421:	8a 40 20             	mov    0x20(%eax),%al
  801424:	84 c0                	test   %al,%al
  801426:	74 0d                	je     801435 <libmain+0x58>
		binaryname = myEnv->prog_name;
  801428:	a1 00 72 80 00       	mov    0x807200,%eax
  80142d:	83 c0 20             	add    $0x20,%eax
  801430:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801435:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801439:	7e 0a                	jle    801445 <libmain+0x68>
		binaryname = argv[0];
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	8b 00                	mov    (%eax),%eax
  801440:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  801445:	83 ec 08             	sub    $0x8,%esp
  801448:	ff 75 0c             	pushl  0xc(%ebp)
  80144b:	ff 75 08             	pushl  0x8(%ebp)
  80144e:	e8 ac fc ff ff       	call   8010ff <_main>
  801453:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801456:	a1 00 70 80 00       	mov    0x807000,%eax
  80145b:	85 c0                	test   %eax,%eax
  80145d:	0f 84 01 01 00 00    	je     801564 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801463:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801469:	bb a0 5e 80 00       	mov    $0x805ea0,%ebx
  80146e:	ba 0e 00 00 00       	mov    $0xe,%edx
  801473:	89 c7                	mov    %eax,%edi
  801475:	89 de                	mov    %ebx,%esi
  801477:	89 d1                	mov    %edx,%ecx
  801479:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80147b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80147e:	b9 56 00 00 00       	mov    $0x56,%ecx
  801483:	b0 00                	mov    $0x0,%al
  801485:	89 d7                	mov    %edx,%edi
  801487:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801489:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801490:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801493:	83 ec 08             	sub    $0x8,%esp
  801496:	50                   	push   %eax
  801497:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80149d:	50                   	push   %eax
  80149e:	e8 2b 31 00 00       	call   8045ce <sys_utilities>
  8014a3:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8014a6:	e8 74 2c 00 00       	call   80411f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8014ab:	83 ec 0c             	sub    $0xc,%esp
  8014ae:	68 c0 5d 80 00       	push   $0x805dc0
  8014b3:	e8 ac 03 00 00       	call   801864 <cprintf>
  8014b8:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8014bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	74 18                	je     8014da <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8014c2:	e8 25 31 00 00       	call   8045ec <sys_get_optimal_num_faults>
  8014c7:	83 ec 08             	sub    $0x8,%esp
  8014ca:	50                   	push   %eax
  8014cb:	68 e8 5d 80 00       	push   $0x805de8
  8014d0:	e8 8f 03 00 00       	call   801864 <cprintf>
  8014d5:	83 c4 10             	add    $0x10,%esp
  8014d8:	eb 59                	jmp    801533 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014da:	a1 00 72 80 00       	mov    0x807200,%eax
  8014df:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8014e5:	a1 00 72 80 00       	mov    0x807200,%eax
  8014ea:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8014f0:	83 ec 04             	sub    $0x4,%esp
  8014f3:	52                   	push   %edx
  8014f4:	50                   	push   %eax
  8014f5:	68 0c 5e 80 00       	push   $0x805e0c
  8014fa:	e8 65 03 00 00       	call   801864 <cprintf>
  8014ff:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801502:	a1 00 72 80 00       	mov    0x807200,%eax
  801507:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80150d:	a1 00 72 80 00       	mov    0x807200,%eax
  801512:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  801518:	a1 00 72 80 00       	mov    0x807200,%eax
  80151d:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  801523:	51                   	push   %ecx
  801524:	52                   	push   %edx
  801525:	50                   	push   %eax
  801526:	68 34 5e 80 00       	push   $0x805e34
  80152b:	e8 34 03 00 00       	call   801864 <cprintf>
  801530:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801533:	a1 00 72 80 00       	mov    0x807200,%eax
  801538:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	50                   	push   %eax
  801542:	68 8c 5e 80 00       	push   $0x805e8c
  801547:	e8 18 03 00 00       	call   801864 <cprintf>
  80154c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80154f:	83 ec 0c             	sub    $0xc,%esp
  801552:	68 c0 5d 80 00       	push   $0x805dc0
  801557:	e8 08 03 00 00       	call   801864 <cprintf>
  80155c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80155f:	e8 d5 2b 00 00       	call   804139 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801564:	e8 1f 00 00 00       	call   801588 <exit>
}
  801569:	90                   	nop
  80156a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80156d:	5b                   	pop    %ebx
  80156e:	5e                   	pop    %esi
  80156f:	5f                   	pop    %edi
  801570:	5d                   	pop    %ebp
  801571:	c3                   	ret    

00801572 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801578:	83 ec 0c             	sub    $0xc,%esp
  80157b:	6a 00                	push   $0x0
  80157d:	e8 e2 2d 00 00       	call   804364 <sys_destroy_env>
  801582:	83 c4 10             	add    $0x10,%esp
}
  801585:	90                   	nop
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <exit>:

void
exit(void)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80158e:	e8 37 2e 00 00       	call   8043ca <sys_exit_env>
}
  801593:	90                   	nop
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80159c:	8d 45 10             	lea    0x10(%ebp),%eax
  80159f:	83 c0 04             	add    $0x4,%eax
  8015a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8015a5:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	74 16                	je     8015c4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015ae:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  8015b3:	83 ec 08             	sub    $0x8,%esp
  8015b6:	50                   	push   %eax
  8015b7:	68 04 5f 80 00       	push   $0x805f04
  8015bc:	e8 a3 02 00 00       	call   801864 <cprintf>
  8015c1:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8015c4:	a1 04 70 80 00       	mov    0x807004,%eax
  8015c9:	83 ec 0c             	sub    $0xc,%esp
  8015cc:	ff 75 0c             	pushl  0xc(%ebp)
  8015cf:	ff 75 08             	pushl  0x8(%ebp)
  8015d2:	50                   	push   %eax
  8015d3:	68 0c 5f 80 00       	push   $0x805f0c
  8015d8:	6a 74                	push   $0x74
  8015da:	e8 b2 02 00 00       	call   801891 <cprintf_colored>
  8015df:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8015e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e5:	83 ec 08             	sub    $0x8,%esp
  8015e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015eb:	50                   	push   %eax
  8015ec:	e8 04 02 00 00       	call   8017f5 <vcprintf>
  8015f1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8015f4:	83 ec 08             	sub    $0x8,%esp
  8015f7:	6a 00                	push   $0x0
  8015f9:	68 34 5f 80 00       	push   $0x805f34
  8015fe:	e8 f2 01 00 00       	call   8017f5 <vcprintf>
  801603:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801606:	e8 7d ff ff ff       	call   801588 <exit>

	// should not return here
	while (1) ;
  80160b:	eb fe                	jmp    80160b <_panic+0x75>

0080160d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801613:	a1 00 72 80 00       	mov    0x807200,%eax
  801618:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80161e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801621:	39 c2                	cmp    %eax,%edx
  801623:	74 14                	je     801639 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801625:	83 ec 04             	sub    $0x4,%esp
  801628:	68 38 5f 80 00       	push   $0x805f38
  80162d:	6a 26                	push   $0x26
  80162f:	68 84 5f 80 00       	push   $0x805f84
  801634:	e8 5d ff ff ff       	call   801596 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801639:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801640:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801647:	e9 c5 00 00 00       	jmp    801711 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	01 d0                	add    %edx,%eax
  80165b:	8b 00                	mov    (%eax),%eax
  80165d:	85 c0                	test   %eax,%eax
  80165f:	75 08                	jne    801669 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801661:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801664:	e9 a5 00 00 00       	jmp    80170e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801669:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801670:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801677:	eb 69                	jmp    8016e2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801679:	a1 00 72 80 00       	mov    0x807200,%eax
  80167e:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  801684:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801687:	89 d0                	mov    %edx,%eax
  801689:	01 c0                	add    %eax,%eax
  80168b:	01 d0                	add    %edx,%eax
  80168d:	c1 e0 03             	shl    $0x3,%eax
  801690:	01 c8                	add    %ecx,%eax
  801692:	8a 40 04             	mov    0x4(%eax),%al
  801695:	84 c0                	test   %al,%al
  801697:	75 46                	jne    8016df <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801699:	a1 00 72 80 00       	mov    0x807200,%eax
  80169e:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8016a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016a7:	89 d0                	mov    %edx,%eax
  8016a9:	01 c0                	add    %eax,%eax
  8016ab:	01 d0                	add    %edx,%eax
  8016ad:	c1 e0 03             	shl    $0x3,%eax
  8016b0:	01 c8                	add    %ecx,%eax
  8016b2:	8b 00                	mov    (%eax),%eax
  8016b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016bf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	01 c8                	add    %ecx,%eax
  8016d0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016d2:	39 c2                	cmp    %eax,%edx
  8016d4:	75 09                	jne    8016df <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8016d6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016dd:	eb 15                	jmp    8016f4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016df:	ff 45 e8             	incl   -0x18(%ebp)
  8016e2:	a1 00 72 80 00       	mov    0x807200,%eax
  8016e7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f0:	39 c2                	cmp    %eax,%edx
  8016f2:	77 85                	ja     801679 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8016f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016f8:	75 14                	jne    80170e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	68 90 5f 80 00       	push   $0x805f90
  801702:	6a 3a                	push   $0x3a
  801704:	68 84 5f 80 00       	push   $0x805f84
  801709:	e8 88 fe ff ff       	call   801596 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80170e:	ff 45 f0             	incl   -0x10(%ebp)
  801711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801714:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801717:	0f 8c 2f ff ff ff    	jl     80164c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80171d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801724:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80172b:	eb 26                	jmp    801753 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80172d:	a1 00 72 80 00       	mov    0x807200,%eax
  801732:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  801738:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80173b:	89 d0                	mov    %edx,%eax
  80173d:	01 c0                	add    %eax,%eax
  80173f:	01 d0                	add    %edx,%eax
  801741:	c1 e0 03             	shl    $0x3,%eax
  801744:	01 c8                	add    %ecx,%eax
  801746:	8a 40 04             	mov    0x4(%eax),%al
  801749:	3c 01                	cmp    $0x1,%al
  80174b:	75 03                	jne    801750 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80174d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801750:	ff 45 e0             	incl   -0x20(%ebp)
  801753:	a1 00 72 80 00       	mov    0x807200,%eax
  801758:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80175e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801761:	39 c2                	cmp    %eax,%edx
  801763:	77 c8                	ja     80172d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801768:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80176b:	74 14                	je     801781 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	68 e4 5f 80 00       	push   $0x805fe4
  801775:	6a 44                	push   $0x44
  801777:	68 84 5f 80 00       	push   $0x805f84
  80177c:	e8 15 fe ff ff       	call   801596 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801781:	90                   	nop
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	53                   	push   %ebx
  801788:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80178b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178e:	8b 00                	mov    (%eax),%eax
  801790:	8d 48 01             	lea    0x1(%eax),%ecx
  801793:	8b 55 0c             	mov    0xc(%ebp),%edx
  801796:	89 0a                	mov    %ecx,(%edx)
  801798:	8b 55 08             	mov    0x8(%ebp),%edx
  80179b:	88 d1                	mov    %dl,%cl
  80179d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8017a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a7:	8b 00                	mov    (%eax),%eax
  8017a9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017ae:	75 30                	jne    8017e0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8017b0:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  8017b6:	a0 24 72 80 00       	mov    0x807224,%al
  8017bb:	0f b6 c0             	movzbl %al,%eax
  8017be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c1:	8b 09                	mov    (%ecx),%ecx
  8017c3:	89 cb                	mov    %ecx,%ebx
  8017c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c8:	83 c1 08             	add    $0x8,%ecx
  8017cb:	52                   	push   %edx
  8017cc:	50                   	push   %eax
  8017cd:	53                   	push   %ebx
  8017ce:	51                   	push   %ecx
  8017cf:	e8 07 29 00 00       	call   8040db <sys_cputs>
  8017d4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e3:	8b 40 04             	mov    0x4(%eax),%eax
  8017e6:	8d 50 01             	lea    0x1(%eax),%edx
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	89 50 04             	mov    %edx,0x4(%eax)
}
  8017ef:	90                   	nop
  8017f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8017fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801805:	00 00 00 
	b.cnt = 0;
  801808:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80180f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	ff 75 08             	pushl  0x8(%ebp)
  801818:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80181e:	50                   	push   %eax
  80181f:	68 84 17 80 00       	push   $0x801784
  801824:	e8 5a 02 00 00       	call   801a83 <vprintfmt>
  801829:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80182c:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801832:	a0 24 72 80 00       	mov    0x807224,%al
  801837:	0f b6 c0             	movzbl %al,%eax
  80183a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801840:	52                   	push   %edx
  801841:	50                   	push   %eax
  801842:	51                   	push   %ecx
  801843:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801849:	83 c0 08             	add    $0x8,%eax
  80184c:	50                   	push   %eax
  80184d:	e8 89 28 00 00       	call   8040db <sys_cputs>
  801852:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801855:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  80185c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80186a:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  801871:	8d 45 0c             	lea    0xc(%ebp),%eax
  801874:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	83 ec 08             	sub    $0x8,%esp
  80187d:	ff 75 f4             	pushl  -0xc(%ebp)
  801880:	50                   	push   %eax
  801881:	e8 6f ff ff ff       	call   8017f5 <vcprintf>
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80188c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801897:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	c1 e0 08             	shl    $0x8,%eax
  8018a4:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  8018a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018ac:	83 c0 04             	add    $0x4,%eax
  8018af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b5:	83 ec 08             	sub    $0x8,%esp
  8018b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018bb:	50                   	push   %eax
  8018bc:	e8 34 ff ff ff       	call   8017f5 <vcprintf>
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8018c7:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  8018ce:	07 00 00 

	return cnt;
  8018d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8018dc:	e8 3e 28 00 00       	call   80411f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8018e1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	83 ec 08             	sub    $0x8,%esp
  8018ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f0:	50                   	push   %eax
  8018f1:	e8 ff fe ff ff       	call   8017f5 <vcprintf>
  8018f6:	83 c4 10             	add    $0x10,%esp
  8018f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8018fc:	e8 38 28 00 00       	call   804139 <sys_unlock_cons>
	return cnt;
  801901:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	53                   	push   %ebx
  80190a:	83 ec 14             	sub    $0x14,%esp
  80190d:	8b 45 10             	mov    0x10(%ebp),%eax
  801910:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801913:	8b 45 14             	mov    0x14(%ebp),%eax
  801916:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801919:	8b 45 18             	mov    0x18(%ebp),%eax
  80191c:	ba 00 00 00 00       	mov    $0x0,%edx
  801921:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801924:	77 55                	ja     80197b <printnum+0x75>
  801926:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801929:	72 05                	jb     801930 <printnum+0x2a>
  80192b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80192e:	77 4b                	ja     80197b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801930:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801933:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801936:	8b 45 18             	mov    0x18(%ebp),%eax
  801939:	ba 00 00 00 00       	mov    $0x0,%edx
  80193e:	52                   	push   %edx
  80193f:	50                   	push   %eax
  801940:	ff 75 f4             	pushl  -0xc(%ebp)
  801943:	ff 75 f0             	pushl  -0x10(%ebp)
  801946:	e8 81 38 00 00       	call   8051cc <__udivdi3>
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	ff 75 20             	pushl  0x20(%ebp)
  801954:	53                   	push   %ebx
  801955:	ff 75 18             	pushl  0x18(%ebp)
  801958:	52                   	push   %edx
  801959:	50                   	push   %eax
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	ff 75 08             	pushl  0x8(%ebp)
  801960:	e8 a1 ff ff ff       	call   801906 <printnum>
  801965:	83 c4 20             	add    $0x20,%esp
  801968:	eb 1a                	jmp    801984 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	ff 75 20             	pushl  0x20(%ebp)
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	ff d0                	call   *%eax
  801978:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80197b:	ff 4d 1c             	decl   0x1c(%ebp)
  80197e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801982:	7f e6                	jg     80196a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801984:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801987:	bb 00 00 00 00       	mov    $0x0,%ebx
  80198c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801992:	53                   	push   %ebx
  801993:	51                   	push   %ecx
  801994:	52                   	push   %edx
  801995:	50                   	push   %eax
  801996:	e8 41 39 00 00       	call   8052dc <__umoddi3>
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	05 54 62 80 00       	add    $0x806254,%eax
  8019a3:	8a 00                	mov    (%eax),%al
  8019a5:	0f be c0             	movsbl %al,%eax
  8019a8:	83 ec 08             	sub    $0x8,%esp
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	50                   	push   %eax
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	ff d0                	call   *%eax
  8019b4:	83 c4 10             	add    $0x10,%esp
}
  8019b7:	90                   	nop
  8019b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019c0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019c4:	7e 1c                	jle    8019e2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8b 00                	mov    (%eax),%eax
  8019cb:	8d 50 08             	lea    0x8(%eax),%edx
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	89 10                	mov    %edx,(%eax)
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	8b 00                	mov    (%eax),%eax
  8019d8:	83 e8 08             	sub    $0x8,%eax
  8019db:	8b 50 04             	mov    0x4(%eax),%edx
  8019de:	8b 00                	mov    (%eax),%eax
  8019e0:	eb 40                	jmp    801a22 <getuint+0x65>
	else if (lflag)
  8019e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019e6:	74 1e                	je     801a06 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8b 00                	mov    (%eax),%eax
  8019ed:	8d 50 04             	lea    0x4(%eax),%edx
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	89 10                	mov    %edx,(%eax)
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	8b 00                	mov    (%eax),%eax
  8019fa:	83 e8 04             	sub    $0x4,%eax
  8019fd:	8b 00                	mov    (%eax),%eax
  8019ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801a04:	eb 1c                	jmp    801a22 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	8b 00                	mov    (%eax),%eax
  801a0b:	8d 50 04             	lea    0x4(%eax),%edx
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	89 10                	mov    %edx,(%eax)
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8b 00                	mov    (%eax),%eax
  801a18:	83 e8 04             	sub    $0x4,%eax
  801a1b:	8b 00                	mov    (%eax),%eax
  801a1d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    

00801a24 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a27:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a2b:	7e 1c                	jle    801a49 <getint+0x25>
		return va_arg(*ap, long long);
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8b 00                	mov    (%eax),%eax
  801a32:	8d 50 08             	lea    0x8(%eax),%edx
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	89 10                	mov    %edx,(%eax)
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8b 00                	mov    (%eax),%eax
  801a3f:	83 e8 08             	sub    $0x8,%eax
  801a42:	8b 50 04             	mov    0x4(%eax),%edx
  801a45:	8b 00                	mov    (%eax),%eax
  801a47:	eb 38                	jmp    801a81 <getint+0x5d>
	else if (lflag)
  801a49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a4d:	74 1a                	je     801a69 <getint+0x45>
		return va_arg(*ap, long);
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8b 00                	mov    (%eax),%eax
  801a54:	8d 50 04             	lea    0x4(%eax),%edx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	89 10                	mov    %edx,(%eax)
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	8b 00                	mov    (%eax),%eax
  801a61:	83 e8 04             	sub    $0x4,%eax
  801a64:	8b 00                	mov    (%eax),%eax
  801a66:	99                   	cltd   
  801a67:	eb 18                	jmp    801a81 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8b 00                	mov    (%eax),%eax
  801a6e:	8d 50 04             	lea    0x4(%eax),%edx
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	89 10                	mov    %edx,(%eax)
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	8b 00                	mov    (%eax),%eax
  801a7b:	83 e8 04             	sub    $0x4,%eax
  801a7e:	8b 00                	mov    (%eax),%eax
  801a80:	99                   	cltd   
}
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a8b:	eb 17                	jmp    801aa4 <vprintfmt+0x21>
			if (ch == '\0')
  801a8d:	85 db                	test   %ebx,%ebx
  801a8f:	0f 84 c1 03 00 00    	je     801e56 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801a95:	83 ec 08             	sub    $0x8,%esp
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	53                   	push   %ebx
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	ff d0                	call   *%eax
  801aa1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801aa4:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa7:	8d 50 01             	lea    0x1(%eax),%edx
  801aaa:	89 55 10             	mov    %edx,0x10(%ebp)
  801aad:	8a 00                	mov    (%eax),%al
  801aaf:	0f b6 d8             	movzbl %al,%ebx
  801ab2:	83 fb 25             	cmp    $0x25,%ebx
  801ab5:	75 d6                	jne    801a8d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801ab7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801abb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801ac2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801ac9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801ad0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  801ada:	8d 50 01             	lea    0x1(%eax),%edx
  801add:	89 55 10             	mov    %edx,0x10(%ebp)
  801ae0:	8a 00                	mov    (%eax),%al
  801ae2:	0f b6 d8             	movzbl %al,%ebx
  801ae5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801ae8:	83 f8 5b             	cmp    $0x5b,%eax
  801aeb:	0f 87 3d 03 00 00    	ja     801e2e <vprintfmt+0x3ab>
  801af1:	8b 04 85 78 62 80 00 	mov    0x806278(,%eax,4),%eax
  801af8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801afa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801afe:	eb d7                	jmp    801ad7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b00:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801b04:	eb d1                	jmp    801ad7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b06:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801b0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b10:	89 d0                	mov    %edx,%eax
  801b12:	c1 e0 02             	shl    $0x2,%eax
  801b15:	01 d0                	add    %edx,%eax
  801b17:	01 c0                	add    %eax,%eax
  801b19:	01 d8                	add    %ebx,%eax
  801b1b:	83 e8 30             	sub    $0x30,%eax
  801b1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801b21:	8b 45 10             	mov    0x10(%ebp),%eax
  801b24:	8a 00                	mov    (%eax),%al
  801b26:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801b29:	83 fb 2f             	cmp    $0x2f,%ebx
  801b2c:	7e 3e                	jle    801b6c <vprintfmt+0xe9>
  801b2e:	83 fb 39             	cmp    $0x39,%ebx
  801b31:	7f 39                	jg     801b6c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b33:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b36:	eb d5                	jmp    801b0d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b38:	8b 45 14             	mov    0x14(%ebp),%eax
  801b3b:	83 c0 04             	add    $0x4,%eax
  801b3e:	89 45 14             	mov    %eax,0x14(%ebp)
  801b41:	8b 45 14             	mov    0x14(%ebp),%eax
  801b44:	83 e8 04             	sub    $0x4,%eax
  801b47:	8b 00                	mov    (%eax),%eax
  801b49:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b4c:	eb 1f                	jmp    801b6d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b52:	79 83                	jns    801ad7 <vprintfmt+0x54>
				width = 0;
  801b54:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b5b:	e9 77 ff ff ff       	jmp    801ad7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b60:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b67:	e9 6b ff ff ff       	jmp    801ad7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b6c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b71:	0f 89 60 ff ff ff    	jns    801ad7 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b7d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b84:	e9 4e ff ff ff       	jmp    801ad7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b89:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b8c:	e9 46 ff ff ff       	jmp    801ad7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b91:	8b 45 14             	mov    0x14(%ebp),%eax
  801b94:	83 c0 04             	add    $0x4,%eax
  801b97:	89 45 14             	mov    %eax,0x14(%ebp)
  801b9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9d:	83 e8 04             	sub    $0x4,%eax
  801ba0:	8b 00                	mov    (%eax),%eax
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	50                   	push   %eax
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	ff d0                	call   *%eax
  801bae:	83 c4 10             	add    $0x10,%esp
			break;
  801bb1:	e9 9b 02 00 00       	jmp    801e51 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb9:	83 c0 04             	add    $0x4,%eax
  801bbc:	89 45 14             	mov    %eax,0x14(%ebp)
  801bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc2:	83 e8 04             	sub    $0x4,%eax
  801bc5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801bc7:	85 db                	test   %ebx,%ebx
  801bc9:	79 02                	jns    801bcd <vprintfmt+0x14a>
				err = -err;
  801bcb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801bcd:	83 fb 64             	cmp    $0x64,%ebx
  801bd0:	7f 0b                	jg     801bdd <vprintfmt+0x15a>
  801bd2:	8b 34 9d c0 60 80 00 	mov    0x8060c0(,%ebx,4),%esi
  801bd9:	85 f6                	test   %esi,%esi
  801bdb:	75 19                	jne    801bf6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801bdd:	53                   	push   %ebx
  801bde:	68 65 62 80 00       	push   $0x806265
  801be3:	ff 75 0c             	pushl  0xc(%ebp)
  801be6:	ff 75 08             	pushl  0x8(%ebp)
  801be9:	e8 70 02 00 00       	call   801e5e <printfmt>
  801bee:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801bf1:	e9 5b 02 00 00       	jmp    801e51 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801bf6:	56                   	push   %esi
  801bf7:	68 6e 62 80 00       	push   $0x80626e
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	ff 75 08             	pushl  0x8(%ebp)
  801c02:	e8 57 02 00 00       	call   801e5e <printfmt>
  801c07:	83 c4 10             	add    $0x10,%esp
			break;
  801c0a:	e9 42 02 00 00       	jmp    801e51 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c12:	83 c0 04             	add    $0x4,%eax
  801c15:	89 45 14             	mov    %eax,0x14(%ebp)
  801c18:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1b:	83 e8 04             	sub    $0x4,%eax
  801c1e:	8b 30                	mov    (%eax),%esi
  801c20:	85 f6                	test   %esi,%esi
  801c22:	75 05                	jne    801c29 <vprintfmt+0x1a6>
				p = "(null)";
  801c24:	be 71 62 80 00       	mov    $0x806271,%esi
			if (width > 0 && padc != '-')
  801c29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c2d:	7e 6d                	jle    801c9c <vprintfmt+0x219>
  801c2f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c33:	74 67                	je     801c9c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c38:	83 ec 08             	sub    $0x8,%esp
  801c3b:	50                   	push   %eax
  801c3c:	56                   	push   %esi
  801c3d:	e8 1e 03 00 00       	call   801f60 <strnlen>
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c48:	eb 16                	jmp    801c60 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c4a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c4e:	83 ec 08             	sub    $0x8,%esp
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	50                   	push   %eax
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	ff d0                	call   *%eax
  801c5a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c5d:	ff 4d e4             	decl   -0x1c(%ebp)
  801c60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c64:	7f e4                	jg     801c4a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c66:	eb 34                	jmp    801c9c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c68:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c6c:	74 1c                	je     801c8a <vprintfmt+0x207>
  801c6e:	83 fb 1f             	cmp    $0x1f,%ebx
  801c71:	7e 05                	jle    801c78 <vprintfmt+0x1f5>
  801c73:	83 fb 7e             	cmp    $0x7e,%ebx
  801c76:	7e 12                	jle    801c8a <vprintfmt+0x207>
					putch('?', putdat);
  801c78:	83 ec 08             	sub    $0x8,%esp
  801c7b:	ff 75 0c             	pushl  0xc(%ebp)
  801c7e:	6a 3f                	push   $0x3f
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	ff d0                	call   *%eax
  801c85:	83 c4 10             	add    $0x10,%esp
  801c88:	eb 0f                	jmp    801c99 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c8a:	83 ec 08             	sub    $0x8,%esp
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	53                   	push   %ebx
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	ff d0                	call   *%eax
  801c96:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c99:	ff 4d e4             	decl   -0x1c(%ebp)
  801c9c:	89 f0                	mov    %esi,%eax
  801c9e:	8d 70 01             	lea    0x1(%eax),%esi
  801ca1:	8a 00                	mov    (%eax),%al
  801ca3:	0f be d8             	movsbl %al,%ebx
  801ca6:	85 db                	test   %ebx,%ebx
  801ca8:	74 24                	je     801cce <vprintfmt+0x24b>
  801caa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cae:	78 b8                	js     801c68 <vprintfmt+0x1e5>
  801cb0:	ff 4d e0             	decl   -0x20(%ebp)
  801cb3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cb7:	79 af                	jns    801c68 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cb9:	eb 13                	jmp    801cce <vprintfmt+0x24b>
				putch(' ', putdat);
  801cbb:	83 ec 08             	sub    $0x8,%esp
  801cbe:	ff 75 0c             	pushl  0xc(%ebp)
  801cc1:	6a 20                	push   $0x20
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	ff d0                	call   *%eax
  801cc8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ccb:	ff 4d e4             	decl   -0x1c(%ebp)
  801cce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cd2:	7f e7                	jg     801cbb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801cd4:	e9 78 01 00 00       	jmp    801e51 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801cd9:	83 ec 08             	sub    $0x8,%esp
  801cdc:	ff 75 e8             	pushl  -0x18(%ebp)
  801cdf:	8d 45 14             	lea    0x14(%ebp),%eax
  801ce2:	50                   	push   %eax
  801ce3:	e8 3c fd ff ff       	call   801a24 <getint>
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf7:	85 d2                	test   %edx,%edx
  801cf9:	79 23                	jns    801d1e <vprintfmt+0x29b>
				putch('-', putdat);
  801cfb:	83 ec 08             	sub    $0x8,%esp
  801cfe:	ff 75 0c             	pushl  0xc(%ebp)
  801d01:	6a 2d                	push   $0x2d
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	ff d0                	call   *%eax
  801d08:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d11:	f7 d8                	neg    %eax
  801d13:	83 d2 00             	adc    $0x0,%edx
  801d16:	f7 da                	neg    %edx
  801d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801d1e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d25:	e9 bc 00 00 00       	jmp    801de6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d2a:	83 ec 08             	sub    $0x8,%esp
  801d2d:	ff 75 e8             	pushl  -0x18(%ebp)
  801d30:	8d 45 14             	lea    0x14(%ebp),%eax
  801d33:	50                   	push   %eax
  801d34:	e8 84 fc ff ff       	call   8019bd <getuint>
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d3f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d42:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d49:	e9 98 00 00 00       	jmp    801de6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d4e:	83 ec 08             	sub    $0x8,%esp
  801d51:	ff 75 0c             	pushl  0xc(%ebp)
  801d54:	6a 58                	push   $0x58
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	ff d0                	call   *%eax
  801d5b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d5e:	83 ec 08             	sub    $0x8,%esp
  801d61:	ff 75 0c             	pushl  0xc(%ebp)
  801d64:	6a 58                	push   $0x58
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	ff d0                	call   *%eax
  801d6b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d6e:	83 ec 08             	sub    $0x8,%esp
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	6a 58                	push   $0x58
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	ff d0                	call   *%eax
  801d7b:	83 c4 10             	add    $0x10,%esp
			break;
  801d7e:	e9 ce 00 00 00       	jmp    801e51 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801d83:	83 ec 08             	sub    $0x8,%esp
  801d86:	ff 75 0c             	pushl  0xc(%ebp)
  801d89:	6a 30                	push   $0x30
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	ff d0                	call   *%eax
  801d90:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d93:	83 ec 08             	sub    $0x8,%esp
  801d96:	ff 75 0c             	pushl  0xc(%ebp)
  801d99:	6a 78                	push   $0x78
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	ff d0                	call   *%eax
  801da0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801da3:	8b 45 14             	mov    0x14(%ebp),%eax
  801da6:	83 c0 04             	add    $0x4,%eax
  801da9:	89 45 14             	mov    %eax,0x14(%ebp)
  801dac:	8b 45 14             	mov    0x14(%ebp),%eax
  801daf:	83 e8 04             	sub    $0x4,%eax
  801db2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801db7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801dbe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801dc5:	eb 1f                	jmp    801de6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	ff 75 e8             	pushl  -0x18(%ebp)
  801dcd:	8d 45 14             	lea    0x14(%ebp),%eax
  801dd0:	50                   	push   %eax
  801dd1:	e8 e7 fb ff ff       	call   8019bd <getuint>
  801dd6:	83 c4 10             	add    $0x10,%esp
  801dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ddc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801ddf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801de6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ded:	83 ec 04             	sub    $0x4,%esp
  801df0:	52                   	push   %edx
  801df1:	ff 75 e4             	pushl  -0x1c(%ebp)
  801df4:	50                   	push   %eax
  801df5:	ff 75 f4             	pushl  -0xc(%ebp)
  801df8:	ff 75 f0             	pushl  -0x10(%ebp)
  801dfb:	ff 75 0c             	pushl  0xc(%ebp)
  801dfe:	ff 75 08             	pushl  0x8(%ebp)
  801e01:	e8 00 fb ff ff       	call   801906 <printnum>
  801e06:	83 c4 20             	add    $0x20,%esp
			break;
  801e09:	eb 46                	jmp    801e51 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e0b:	83 ec 08             	sub    $0x8,%esp
  801e0e:	ff 75 0c             	pushl  0xc(%ebp)
  801e11:	53                   	push   %ebx
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	ff d0                	call   *%eax
  801e17:	83 c4 10             	add    $0x10,%esp
			break;
  801e1a:	eb 35                	jmp    801e51 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801e1c:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  801e23:	eb 2c                	jmp    801e51 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801e25:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  801e2c:	eb 23                	jmp    801e51 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e2e:	83 ec 08             	sub    $0x8,%esp
  801e31:	ff 75 0c             	pushl  0xc(%ebp)
  801e34:	6a 25                	push   $0x25
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	ff d0                	call   *%eax
  801e3b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e3e:	ff 4d 10             	decl   0x10(%ebp)
  801e41:	eb 03                	jmp    801e46 <vprintfmt+0x3c3>
  801e43:	ff 4d 10             	decl   0x10(%ebp)
  801e46:	8b 45 10             	mov    0x10(%ebp),%eax
  801e49:	48                   	dec    %eax
  801e4a:	8a 00                	mov    (%eax),%al
  801e4c:	3c 25                	cmp    $0x25,%al
  801e4e:	75 f3                	jne    801e43 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e50:	90                   	nop
		}
	}
  801e51:	e9 35 fc ff ff       	jmp    801a8b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e56:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5a:	5b                   	pop    %ebx
  801e5b:	5e                   	pop    %esi
  801e5c:	5d                   	pop    %ebp
  801e5d:	c3                   	ret    

00801e5e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e64:	8d 45 10             	lea    0x10(%ebp),%eax
  801e67:	83 c0 04             	add    $0x4,%eax
  801e6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e70:	ff 75 f4             	pushl  -0xc(%ebp)
  801e73:	50                   	push   %eax
  801e74:	ff 75 0c             	pushl  0xc(%ebp)
  801e77:	ff 75 08             	pushl  0x8(%ebp)
  801e7a:	e8 04 fc ff ff       	call   801a83 <vprintfmt>
  801e7f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e82:	90                   	nop
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8b:	8b 40 08             	mov    0x8(%eax),%eax
  801e8e:	8d 50 01             	lea    0x1(%eax),%edx
  801e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e94:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9a:	8b 10                	mov    (%eax),%edx
  801e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9f:	8b 40 04             	mov    0x4(%eax),%eax
  801ea2:	39 c2                	cmp    %eax,%edx
  801ea4:	73 12                	jae    801eb8 <sprintputch+0x33>
		*b->buf++ = ch;
  801ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea9:	8b 00                	mov    (%eax),%eax
  801eab:	8d 48 01             	lea    0x1(%eax),%ecx
  801eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb1:	89 0a                	mov    %ecx,(%edx)
  801eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  801eb6:	88 10                	mov    %dl,(%eax)
}
  801eb8:	90                   	nop
  801eb9:	5d                   	pop    %ebp
  801eba:	c3                   	ret    

00801ebb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eca:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed0:	01 d0                	add    %edx,%eax
  801ed2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ed5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801edc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ee0:	74 06                	je     801ee8 <vsnprintf+0x2d>
  801ee2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ee6:	7f 07                	jg     801eef <vsnprintf+0x34>
		return -E_INVAL;
  801ee8:	b8 03 00 00 00       	mov    $0x3,%eax
  801eed:	eb 20                	jmp    801f0f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801eef:	ff 75 14             	pushl  0x14(%ebp)
  801ef2:	ff 75 10             	pushl  0x10(%ebp)
  801ef5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ef8:	50                   	push   %eax
  801ef9:	68 85 1e 80 00       	push   $0x801e85
  801efe:	e8 80 fb ff ff       	call   801a83 <vprintfmt>
  801f03:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f09:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f17:	8d 45 10             	lea    0x10(%ebp),%eax
  801f1a:	83 c0 04             	add    $0x4,%eax
  801f1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801f20:	8b 45 10             	mov    0x10(%ebp),%eax
  801f23:	ff 75 f4             	pushl  -0xc(%ebp)
  801f26:	50                   	push   %eax
  801f27:	ff 75 0c             	pushl  0xc(%ebp)
  801f2a:	ff 75 08             	pushl  0x8(%ebp)
  801f2d:	e8 89 ff ff ff       	call   801ebb <vsnprintf>
  801f32:	83 c4 10             	add    $0x10,%esp
  801f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f4a:	eb 06                	jmp    801f52 <strlen+0x15>
		n++;
  801f4c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f4f:	ff 45 08             	incl   0x8(%ebp)
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	8a 00                	mov    (%eax),%al
  801f57:	84 c0                	test   %al,%al
  801f59:	75 f1                	jne    801f4c <strlen+0xf>
		n++;
	return n;
  801f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f6d:	eb 09                	jmp    801f78 <strnlen+0x18>
		n++;
  801f6f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f72:	ff 45 08             	incl   0x8(%ebp)
  801f75:	ff 4d 0c             	decl   0xc(%ebp)
  801f78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f7c:	74 09                	je     801f87 <strnlen+0x27>
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	8a 00                	mov    (%eax),%al
  801f83:	84 c0                	test   %al,%al
  801f85:	75 e8                	jne    801f6f <strnlen+0xf>
		n++;
	return n;
  801f87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f98:	90                   	nop
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	8d 50 01             	lea    0x1(%eax),%edx
  801f9f:	89 55 08             	mov    %edx,0x8(%ebp)
  801fa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa5:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fab:	8a 12                	mov    (%edx),%dl
  801fad:	88 10                	mov    %dl,(%eax)
  801faf:	8a 00                	mov    (%eax),%al
  801fb1:	84 c0                	test   %al,%al
  801fb3:	75 e4                	jne    801f99 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801fb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801fc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fcd:	eb 1f                	jmp    801fee <strncpy+0x34>
		*dst++ = *src;
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	8d 50 01             	lea    0x1(%eax),%edx
  801fd5:	89 55 08             	mov    %edx,0x8(%ebp)
  801fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdb:	8a 12                	mov    (%edx),%dl
  801fdd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe2:	8a 00                	mov    (%eax),%al
  801fe4:	84 c0                	test   %al,%al
  801fe6:	74 03                	je     801feb <strncpy+0x31>
			src++;
  801fe8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801feb:	ff 45 fc             	incl   -0x4(%ebp)
  801fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff1:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ff4:	72 d9                	jb     801fcf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801ff6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802001:	8b 45 08             	mov    0x8(%ebp),%eax
  802004:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802007:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80200b:	74 30                	je     80203d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80200d:	eb 16                	jmp    802025 <strlcpy+0x2a>
			*dst++ = *src++;
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	8d 50 01             	lea    0x1(%eax),%edx
  802015:	89 55 08             	mov    %edx,0x8(%ebp)
  802018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80201e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802021:	8a 12                	mov    (%edx),%dl
  802023:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802025:	ff 4d 10             	decl   0x10(%ebp)
  802028:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80202c:	74 09                	je     802037 <strlcpy+0x3c>
  80202e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802031:	8a 00                	mov    (%eax),%al
  802033:	84 c0                	test   %al,%al
  802035:	75 d8                	jne    80200f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80203d:	8b 55 08             	mov    0x8(%ebp),%edx
  802040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802043:	29 c2                	sub    %eax,%edx
  802045:	89 d0                	mov    %edx,%eax
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80204c:	eb 06                	jmp    802054 <strcmp+0xb>
		p++, q++;
  80204e:	ff 45 08             	incl   0x8(%ebp)
  802051:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	8a 00                	mov    (%eax),%al
  802059:	84 c0                	test   %al,%al
  80205b:	74 0e                	je     80206b <strcmp+0x22>
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	8a 10                	mov    (%eax),%dl
  802062:	8b 45 0c             	mov    0xc(%ebp),%eax
  802065:	8a 00                	mov    (%eax),%al
  802067:	38 c2                	cmp    %al,%dl
  802069:	74 e3                	je     80204e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	8a 00                	mov    (%eax),%al
  802070:	0f b6 d0             	movzbl %al,%edx
  802073:	8b 45 0c             	mov    0xc(%ebp),%eax
  802076:	8a 00                	mov    (%eax),%al
  802078:	0f b6 c0             	movzbl %al,%eax
  80207b:	29 c2                	sub    %eax,%edx
  80207d:	89 d0                	mov    %edx,%eax
}
  80207f:	5d                   	pop    %ebp
  802080:	c3                   	ret    

00802081 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802084:	eb 09                	jmp    80208f <strncmp+0xe>
		n--, p++, q++;
  802086:	ff 4d 10             	decl   0x10(%ebp)
  802089:	ff 45 08             	incl   0x8(%ebp)
  80208c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80208f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802093:	74 17                	je     8020ac <strncmp+0x2b>
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	8a 00                	mov    (%eax),%al
  80209a:	84 c0                	test   %al,%al
  80209c:	74 0e                	je     8020ac <strncmp+0x2b>
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	8a 10                	mov    (%eax),%dl
  8020a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a6:	8a 00                	mov    (%eax),%al
  8020a8:	38 c2                	cmp    %al,%dl
  8020aa:	74 da                	je     802086 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8020ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020b0:	75 07                	jne    8020b9 <strncmp+0x38>
		return 0;
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b7:	eb 14                	jmp    8020cd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	8a 00                	mov    (%eax),%al
  8020be:	0f b6 d0             	movzbl %al,%edx
  8020c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c4:	8a 00                	mov    (%eax),%al
  8020c6:	0f b6 c0             	movzbl %al,%eax
  8020c9:	29 c2                	sub    %eax,%edx
  8020cb:	89 d0                	mov    %edx,%eax
}
  8020cd:	5d                   	pop    %ebp
  8020ce:	c3                   	ret    

008020cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020db:	eb 12                	jmp    8020ef <strchr+0x20>
		if (*s == c)
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	8a 00                	mov    (%eax),%al
  8020e2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020e5:	75 05                	jne    8020ec <strchr+0x1d>
			return (char *) s;
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	eb 11                	jmp    8020fd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020ec:	ff 45 08             	incl   0x8(%ebp)
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8a 00                	mov    (%eax),%al
  8020f4:	84 c0                	test   %al,%al
  8020f6:	75 e5                	jne    8020dd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8020f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	8b 45 0c             	mov    0xc(%ebp),%eax
  802108:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80210b:	eb 0d                	jmp    80211a <strfind+0x1b>
		if (*s == c)
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	8a 00                	mov    (%eax),%al
  802112:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802115:	74 0e                	je     802125 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802117:	ff 45 08             	incl   0x8(%ebp)
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	8a 00                	mov    (%eax),%al
  80211f:	84 c0                	test   %al,%al
  802121:	75 ea                	jne    80210d <strfind+0xe>
  802123:	eb 01                	jmp    802126 <strfind+0x27>
		if (*s == c)
			break;
  802125:	90                   	nop
	return (char *) s;
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802137:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80213b:	76 63                	jbe    8021a0 <memset+0x75>
		uint64 data_block = c;
  80213d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802140:	99                   	cltd   
  802141:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802144:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802147:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802151:	c1 e0 08             	shl    $0x8,%eax
  802154:	09 45 f0             	or     %eax,-0x10(%ebp)
  802157:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80215a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802160:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  802164:	c1 e0 10             	shl    $0x10,%eax
  802167:	09 45 f0             	or     %eax,-0x10(%ebp)
  80216a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80216d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802170:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802173:	89 c2                	mov    %eax,%edx
  802175:	b8 00 00 00 00       	mov    $0x0,%eax
  80217a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80217d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  802180:	eb 18                	jmp    80219a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  802182:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802185:	8d 41 08             	lea    0x8(%ecx),%eax
  802188:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80218b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802191:	89 01                	mov    %eax,(%ecx)
  802193:	89 51 04             	mov    %edx,0x4(%ecx)
  802196:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80219a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80219e:	77 e2                	ja     802182 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8021a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021a4:	74 23                	je     8021c9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8021a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8021ac:	eb 0e                	jmp    8021bc <memset+0x91>
			*p8++ = (uint8)c;
  8021ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021b1:	8d 50 01             	lea    0x1(%eax),%edx
  8021b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8021bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	75 e5                	jne    8021ae <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8021e0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021e4:	76 24                	jbe    80220a <memcpy+0x3c>
		while(n >= 8){
  8021e6:	eb 1c                	jmp    802204 <memcpy+0x36>
			*d64 = *s64;
  8021e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021eb:	8b 50 04             	mov    0x4(%eax),%edx
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8021f3:	89 01                	mov    %eax,(%ecx)
  8021f5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8021f8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8021fc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  802200:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802204:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802208:	77 de                	ja     8021e8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80220a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80220e:	74 31                	je     802241 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802210:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802213:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802216:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802219:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80221c:	eb 16                	jmp    802234 <memcpy+0x66>
			*d8++ = *s8++;
  80221e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802221:	8d 50 01             	lea    0x1(%eax),%edx
  802224:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80222d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802230:	8a 12                	mov    (%edx),%dl
  802232:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802234:	8b 45 10             	mov    0x10(%ebp),%eax
  802237:	8d 50 ff             	lea    -0x1(%eax),%edx
  80223a:	89 55 10             	mov    %edx,0x10(%ebp)
  80223d:	85 c0                	test   %eax,%eax
  80223f:	75 dd                	jne    80221e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80224c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802258:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80225b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80225e:	73 50                	jae    8022b0 <memmove+0x6a>
  802260:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802263:	8b 45 10             	mov    0x10(%ebp),%eax
  802266:	01 d0                	add    %edx,%eax
  802268:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80226b:	76 43                	jbe    8022b0 <memmove+0x6a>
		s += n;
  80226d:	8b 45 10             	mov    0x10(%ebp),%eax
  802270:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802273:	8b 45 10             	mov    0x10(%ebp),%eax
  802276:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802279:	eb 10                	jmp    80228b <memmove+0x45>
			*--d = *--s;
  80227b:	ff 4d f8             	decl   -0x8(%ebp)
  80227e:	ff 4d fc             	decl   -0x4(%ebp)
  802281:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802284:	8a 10                	mov    (%eax),%dl
  802286:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802289:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80228b:	8b 45 10             	mov    0x10(%ebp),%eax
  80228e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802291:	89 55 10             	mov    %edx,0x10(%ebp)
  802294:	85 c0                	test   %eax,%eax
  802296:	75 e3                	jne    80227b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802298:	eb 23                	jmp    8022bd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80229a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80229d:	8d 50 01             	lea    0x1(%eax),%edx
  8022a0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022a9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8022ac:	8a 12                	mov    (%edx),%dl
  8022ae:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8022b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	75 dd                	jne    80229a <memmove+0x54>
			*d++ = *s++;

	return dst;
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8022ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8022d4:	eb 2a                	jmp    802300 <memcmp+0x3e>
		if (*s1 != *s2)
  8022d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022d9:	8a 10                	mov    (%eax),%dl
  8022db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022de:	8a 00                	mov    (%eax),%al
  8022e0:	38 c2                	cmp    %al,%dl
  8022e2:	74 16                	je     8022fa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8022e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e7:	8a 00                	mov    (%eax),%al
  8022e9:	0f b6 d0             	movzbl %al,%edx
  8022ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022ef:	8a 00                	mov    (%eax),%al
  8022f1:	0f b6 c0             	movzbl %al,%eax
  8022f4:	29 c2                	sub    %eax,%edx
  8022f6:	89 d0                	mov    %edx,%eax
  8022f8:	eb 18                	jmp    802312 <memcmp+0x50>
		s1++, s2++;
  8022fa:	ff 45 fc             	incl   -0x4(%ebp)
  8022fd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802300:	8b 45 10             	mov    0x10(%ebp),%eax
  802303:	8d 50 ff             	lea    -0x1(%eax),%edx
  802306:	89 55 10             	mov    %edx,0x10(%ebp)
  802309:	85 c0                	test   %eax,%eax
  80230b:	75 c9                	jne    8022d6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80230d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80231a:	8b 55 08             	mov    0x8(%ebp),%edx
  80231d:	8b 45 10             	mov    0x10(%ebp),%eax
  802320:	01 d0                	add    %edx,%eax
  802322:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802325:	eb 15                	jmp    80233c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	8a 00                	mov    (%eax),%al
  80232c:	0f b6 d0             	movzbl %al,%edx
  80232f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802332:	0f b6 c0             	movzbl %al,%eax
  802335:	39 c2                	cmp    %eax,%edx
  802337:	74 0d                	je     802346 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802339:	ff 45 08             	incl   0x8(%ebp)
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802342:	72 e3                	jb     802327 <memfind+0x13>
  802344:	eb 01                	jmp    802347 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802346:	90                   	nop
	return (void *) s;
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802352:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802359:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802360:	eb 03                	jmp    802365 <strtol+0x19>
		s++;
  802362:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	8a 00                	mov    (%eax),%al
  80236a:	3c 20                	cmp    $0x20,%al
  80236c:	74 f4                	je     802362 <strtol+0x16>
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	8a 00                	mov    (%eax),%al
  802373:	3c 09                	cmp    $0x9,%al
  802375:	74 eb                	je     802362 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	8a 00                	mov    (%eax),%al
  80237c:	3c 2b                	cmp    $0x2b,%al
  80237e:	75 05                	jne    802385 <strtol+0x39>
		s++;
  802380:	ff 45 08             	incl   0x8(%ebp)
  802383:	eb 13                	jmp    802398 <strtol+0x4c>
	else if (*s == '-')
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	8a 00                	mov    (%eax),%al
  80238a:	3c 2d                	cmp    $0x2d,%al
  80238c:	75 0a                	jne    802398 <strtol+0x4c>
		s++, neg = 1;
  80238e:	ff 45 08             	incl   0x8(%ebp)
  802391:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802398:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80239c:	74 06                	je     8023a4 <strtol+0x58>
  80239e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8023a2:	75 20                	jne    8023c4 <strtol+0x78>
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	8a 00                	mov    (%eax),%al
  8023a9:	3c 30                	cmp    $0x30,%al
  8023ab:	75 17                	jne    8023c4 <strtol+0x78>
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	40                   	inc    %eax
  8023b1:	8a 00                	mov    (%eax),%al
  8023b3:	3c 78                	cmp    $0x78,%al
  8023b5:	75 0d                	jne    8023c4 <strtol+0x78>
		s += 2, base = 16;
  8023b7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8023bb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8023c2:	eb 28                	jmp    8023ec <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8023c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023c8:	75 15                	jne    8023df <strtol+0x93>
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	8a 00                	mov    (%eax),%al
  8023cf:	3c 30                	cmp    $0x30,%al
  8023d1:	75 0c                	jne    8023df <strtol+0x93>
		s++, base = 8;
  8023d3:	ff 45 08             	incl   0x8(%ebp)
  8023d6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8023dd:	eb 0d                	jmp    8023ec <strtol+0xa0>
	else if (base == 0)
  8023df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023e3:	75 07                	jne    8023ec <strtol+0xa0>
		base = 10;
  8023e5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	8a 00                	mov    (%eax),%al
  8023f1:	3c 2f                	cmp    $0x2f,%al
  8023f3:	7e 19                	jle    80240e <strtol+0xc2>
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	8a 00                	mov    (%eax),%al
  8023fa:	3c 39                	cmp    $0x39,%al
  8023fc:	7f 10                	jg     80240e <strtol+0xc2>
			dig = *s - '0';
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	8a 00                	mov    (%eax),%al
  802403:	0f be c0             	movsbl %al,%eax
  802406:	83 e8 30             	sub    $0x30,%eax
  802409:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240c:	eb 42                	jmp    802450 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	8a 00                	mov    (%eax),%al
  802413:	3c 60                	cmp    $0x60,%al
  802415:	7e 19                	jle    802430 <strtol+0xe4>
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	8a 00                	mov    (%eax),%al
  80241c:	3c 7a                	cmp    $0x7a,%al
  80241e:	7f 10                	jg     802430 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	8a 00                	mov    (%eax),%al
  802425:	0f be c0             	movsbl %al,%eax
  802428:	83 e8 57             	sub    $0x57,%eax
  80242b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242e:	eb 20                	jmp    802450 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8a 00                	mov    (%eax),%al
  802435:	3c 40                	cmp    $0x40,%al
  802437:	7e 39                	jle    802472 <strtol+0x126>
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	8a 00                	mov    (%eax),%al
  80243e:	3c 5a                	cmp    $0x5a,%al
  802440:	7f 30                	jg     802472 <strtol+0x126>
			dig = *s - 'A' + 10;
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	8a 00                	mov    (%eax),%al
  802447:	0f be c0             	movsbl %al,%eax
  80244a:	83 e8 37             	sub    $0x37,%eax
  80244d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	3b 45 10             	cmp    0x10(%ebp),%eax
  802456:	7d 19                	jge    802471 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802458:	ff 45 08             	incl   0x8(%ebp)
  80245b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80245e:	0f af 45 10          	imul   0x10(%ebp),%eax
  802462:	89 c2                	mov    %eax,%edx
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	01 d0                	add    %edx,%eax
  802469:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80246c:	e9 7b ff ff ff       	jmp    8023ec <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802471:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802472:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802476:	74 08                	je     802480 <strtol+0x134>
		*endptr = (char *) s;
  802478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247b:	8b 55 08             	mov    0x8(%ebp),%edx
  80247e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802480:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802484:	74 07                	je     80248d <strtol+0x141>
  802486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802489:	f7 d8                	neg    %eax
  80248b:	eb 03                	jmp    802490 <strtol+0x144>
  80248d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <ltostr>:

void
ltostr(long value, char *str)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802498:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80249f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8024a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024aa:	79 13                	jns    8024bf <ltostr+0x2d>
	{
		neg = 1;
  8024ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8024b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8024b9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8024bc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8024c7:	99                   	cltd   
  8024c8:	f7 f9                	idiv   %ecx
  8024ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8024cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024d0:	8d 50 01             	lea    0x1(%eax),%edx
  8024d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8024d6:	89 c2                	mov    %eax,%edx
  8024d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024db:	01 d0                	add    %edx,%eax
  8024dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024e0:	83 c2 30             	add    $0x30,%edx
  8024e3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8024e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8024ed:	f7 e9                	imul   %ecx
  8024ef:	c1 fa 02             	sar    $0x2,%edx
  8024f2:	89 c8                	mov    %ecx,%eax
  8024f4:	c1 f8 1f             	sar    $0x1f,%eax
  8024f7:	29 c2                	sub    %eax,%edx
  8024f9:	89 d0                	mov    %edx,%eax
  8024fb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8024fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802502:	75 bb                	jne    8024bf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802504:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80250b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80250e:	48                   	dec    %eax
  80250f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802512:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802516:	74 3d                	je     802555 <ltostr+0xc3>
		start = 1 ;
  802518:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80251f:	eb 34                	jmp    802555 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802521:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802524:	8b 45 0c             	mov    0xc(%ebp),%eax
  802527:	01 d0                	add    %edx,%eax
  802529:	8a 00                	mov    (%eax),%al
  80252b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80252e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802531:	8b 45 0c             	mov    0xc(%ebp),%eax
  802534:	01 c2                	add    %eax,%edx
  802536:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253c:	01 c8                	add    %ecx,%eax
  80253e:	8a 00                	mov    (%eax),%al
  802540:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802542:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802545:	8b 45 0c             	mov    0xc(%ebp),%eax
  802548:	01 c2                	add    %eax,%edx
  80254a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80254d:	88 02                	mov    %al,(%edx)
		start++ ;
  80254f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802552:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80255b:	7c c4                	jl     802521 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80255d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802560:	8b 45 0c             	mov    0xc(%ebp),%eax
  802563:	01 d0                	add    %edx,%eax
  802565:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802568:	90                   	nop
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802571:	ff 75 08             	pushl  0x8(%ebp)
  802574:	e8 c4 f9 ff ff       	call   801f3d <strlen>
  802579:	83 c4 04             	add    $0x4,%esp
  80257c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80257f:	ff 75 0c             	pushl  0xc(%ebp)
  802582:	e8 b6 f9 ff ff       	call   801f3d <strlen>
  802587:	83 c4 04             	add    $0x4,%esp
  80258a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80258d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802594:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80259b:	eb 17                	jmp    8025b4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80259d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a3:	01 c2                	add    %eax,%edx
  8025a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ab:	01 c8                	add    %ecx,%eax
  8025ad:	8a 00                	mov    (%eax),%al
  8025af:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8025b1:	ff 45 fc             	incl   -0x4(%ebp)
  8025b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025ba:	7c e1                	jl     80259d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8025bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8025c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8025ca:	eb 1f                	jmp    8025eb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8025cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025cf:	8d 50 01             	lea    0x1(%eax),%edx
  8025d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8025d5:	89 c2                	mov    %eax,%edx
  8025d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8025da:	01 c2                	add    %eax,%edx
  8025dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8025df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e2:	01 c8                	add    %ecx,%eax
  8025e4:	8a 00                	mov    (%eax),%al
  8025e6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8025e8:	ff 45 f8             	incl   -0x8(%ebp)
  8025eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025f1:	7c d9                	jl     8025cc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8025f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f9:	01 d0                	add    %edx,%eax
  8025fb:	c6 00 00             	movb   $0x0,(%eax)
}
  8025fe:	90                   	nop
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802604:	8b 45 14             	mov    0x14(%ebp),%eax
  802607:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80260d:	8b 45 14             	mov    0x14(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802619:	8b 45 10             	mov    0x10(%ebp),%eax
  80261c:	01 d0                	add    %edx,%eax
  80261e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802624:	eb 0c                	jmp    802632 <strsplit+0x31>
			*string++ = 0;
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	8d 50 01             	lea    0x1(%eax),%edx
  80262c:	89 55 08             	mov    %edx,0x8(%ebp)
  80262f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	8a 00                	mov    (%eax),%al
  802637:	84 c0                	test   %al,%al
  802639:	74 18                	je     802653 <strsplit+0x52>
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	8a 00                	mov    (%eax),%al
  802640:	0f be c0             	movsbl %al,%eax
  802643:	50                   	push   %eax
  802644:	ff 75 0c             	pushl  0xc(%ebp)
  802647:	e8 83 fa ff ff       	call   8020cf <strchr>
  80264c:	83 c4 08             	add    $0x8,%esp
  80264f:	85 c0                	test   %eax,%eax
  802651:	75 d3                	jne    802626 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	8a 00                	mov    (%eax),%al
  802658:	84 c0                	test   %al,%al
  80265a:	74 5a                	je     8026b6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80265c:	8b 45 14             	mov    0x14(%ebp),%eax
  80265f:	8b 00                	mov    (%eax),%eax
  802661:	83 f8 0f             	cmp    $0xf,%eax
  802664:	75 07                	jne    80266d <strsplit+0x6c>
		{
			return 0;
  802666:	b8 00 00 00 00       	mov    $0x0,%eax
  80266b:	eb 66                	jmp    8026d3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80266d:	8b 45 14             	mov    0x14(%ebp),%eax
  802670:	8b 00                	mov    (%eax),%eax
  802672:	8d 48 01             	lea    0x1(%eax),%ecx
  802675:	8b 55 14             	mov    0x14(%ebp),%edx
  802678:	89 0a                	mov    %ecx,(%edx)
  80267a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802681:	8b 45 10             	mov    0x10(%ebp),%eax
  802684:	01 c2                	add    %eax,%edx
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80268b:	eb 03                	jmp    802690 <strsplit+0x8f>
			string++;
  80268d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802690:	8b 45 08             	mov    0x8(%ebp),%eax
  802693:	8a 00                	mov    (%eax),%al
  802695:	84 c0                	test   %al,%al
  802697:	74 8b                	je     802624 <strsplit+0x23>
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	8a 00                	mov    (%eax),%al
  80269e:	0f be c0             	movsbl %al,%eax
  8026a1:	50                   	push   %eax
  8026a2:	ff 75 0c             	pushl  0xc(%ebp)
  8026a5:	e8 25 fa ff ff       	call   8020cf <strchr>
  8026aa:	83 c4 08             	add    $0x8,%esp
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	74 dc                	je     80268d <strsplit+0x8c>
			string++;
	}
  8026b1:	e9 6e ff ff ff       	jmp    802624 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8026b6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8026b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8026c6:	01 d0                	add    %edx,%eax
  8026c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8026ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8026e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8026e8:	eb 4a                	jmp    802734 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8026ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f0:	01 c2                	add    %eax,%edx
  8026f2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8026f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f8:	01 c8                	add    %ecx,%eax
  8026fa:	8a 00                	mov    (%eax),%al
  8026fc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8026fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802701:	8b 45 0c             	mov    0xc(%ebp),%eax
  802704:	01 d0                	add    %edx,%eax
  802706:	8a 00                	mov    (%eax),%al
  802708:	3c 40                	cmp    $0x40,%al
  80270a:	7e 25                	jle    802731 <str2lower+0x5c>
  80270c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80270f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802712:	01 d0                	add    %edx,%eax
  802714:	8a 00                	mov    (%eax),%al
  802716:	3c 5a                	cmp    $0x5a,%al
  802718:	7f 17                	jg     802731 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80271a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80271d:	8b 45 08             	mov    0x8(%ebp),%eax
  802720:	01 d0                	add    %edx,%eax
  802722:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802725:	8b 55 08             	mov    0x8(%ebp),%edx
  802728:	01 ca                	add    %ecx,%edx
  80272a:	8a 12                	mov    (%edx),%dl
  80272c:	83 c2 20             	add    $0x20,%edx
  80272f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802731:	ff 45 fc             	incl   -0x4(%ebp)
  802734:	ff 75 0c             	pushl  0xc(%ebp)
  802737:	e8 01 f8 ff ff       	call   801f3d <strlen>
  80273c:	83 c4 04             	add    $0x4,%esp
  80273f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802742:	7f a6                	jg     8026ea <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802744:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
  80274c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80274f:	a1 08 70 80 00       	mov    0x807008,%eax
  802754:	85 c0                	test   %eax,%eax
  802756:	0f 84 95 00 00 00    	je     8027f1 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80275c:	83 ec 08             	sub    $0x8,%esp
  80275f:	68 00 00 00 82       	push   $0x82000000
  802764:	68 00 00 00 80       	push   $0x80000000
  802769:	e8 59 1f 00 00       	call   8046c7 <initialize_dynamic_allocator>
  80276e:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802771:	e8 93 1d 00 00       	call   804509 <sys_get_uheap_strategy>
  802776:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80277b:	a1 20 72 80 00       	mov    0x807220,%eax
  802780:	05 00 10 00 00       	add    $0x1000,%eax
  802785:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  80278a:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80278f:	a3 50 f2 81 00       	mov    %eax,0x81f250
		init_uspinlock(&ulock,"malloc",1);
  802794:	83 ec 04             	sub    $0x4,%esp
  802797:	6a 01                	push   $0x1
  802799:	68 e8 63 80 00       	push   $0x8063e8
  80279e:	68 20 f3 81 00       	push   $0x81f320
  8027a3:	e8 1a 29 00 00       	call   8050c2 <init_uspinlock>
  8027a8:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  8027ab:	c7 05 00 f3 81 00 00 	movl   $0x0,0x81f300
  8027b2:	00 00 00 
  8027b5:	c7 05 04 f3 81 00 00 	movl   $0x0,0x81f304
  8027bc:	00 00 00 
  8027bf:	c7 05 0c f3 81 00 00 	movl   $0x0,0x81f30c
  8027c6:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  8027c9:	c7 05 10 f3 81 00 00 	movl   $0x0,0x81f310
  8027d0:	00 00 00 
  8027d3:	c7 05 14 f3 81 00 00 	movl   $0x0,0x81f314
  8027da:	00 00 00 
  8027dd:	c7 05 1c f3 81 00 00 	movl   $0x0,0x81f31c
  8027e4:	00 00 00 
		__firstTimeFlag = 0;
  8027e7:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  8027ee:	00 00 00 
	}
}
  8027f1:	90                   	nop
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802808:	83 ec 08             	sub    $0x8,%esp
  80280b:	68 06 04 00 00       	push   $0x406
  802810:	50                   	push   %eax
  802811:	e8 3d 19 00 00       	call   804153 <__sys_allocate_page>
  802816:	83 c4 10             	add    $0x10,%esp
  802819:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80281c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802820:	79 14                	jns    802836 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802822:	83 ec 04             	sub    $0x4,%esp
  802825:	68 f0 63 80 00       	push   $0x8063f0
  80282a:	6a 2d                	push   $0x2d
  80282c:	68 2c 64 80 00       	push   $0x80642c
  802831:	e8 60 ed ff ff       	call   801596 <_panic>
	return 0;
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
  802840:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802851:	83 ec 0c             	sub    $0xc,%esp
  802854:	50                   	push   %eax
  802855:	e8 40 19 00 00       	call   80419a <__sys_unmap_frame>
  80285a:	83 c4 10             	add    $0x10,%esp
  80285d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802860:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802864:	79 14                	jns    80287a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	68 38 64 80 00       	push   $0x806438
  80286e:	6a 38                	push   $0x38
  802870:	68 2c 64 80 00       	push   $0x80642c
  802875:	e8 1c ed ff ff       	call   801596 <_panic>
}
  80287a:	90                   	nop
  80287b:	c9                   	leave  
  80287c:	c3                   	ret    

0080287d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
  802880:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802883:	e8 c1 fe ff ff       	call   802749 <uheap_init>
	if (size == 0) return NULL ;
  802888:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80288c:	75 0a                	jne    802898 <malloc+0x1b>
  80288e:	b8 00 00 00 00       	mov    $0x0,%eax
  802893:	e9 e1 04 00 00       	jmp    802d79 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  802898:	83 ec 0c             	sub    $0xc,%esp
  80289b:	68 20 f3 81 00       	push   $0x81f320
  8028a0:	e8 6c 28 00 00       	call   805111 <acquire_uspinlock>
  8028a5:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  8028a8:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  8028af:	77 23                	ja     8028d4 <malloc+0x57>
		release_uspinlock(&ulock);
  8028b1:	83 ec 0c             	sub    $0xc,%esp
  8028b4:	68 20 f3 81 00       	push   $0x81f320
  8028b9:	e8 ab 28 00 00       	call   805169 <release_uspinlock>
  8028be:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  8028c1:	83 ec 0c             	sub    $0xc,%esp
  8028c4:	ff 75 08             	pushl  0x8(%ebp)
  8028c7:	e8 dd 1f 00 00       	call   8048a9 <alloc_block>
  8028cc:	83 c4 10             	add    $0x10,%esp
  8028cf:	e9 a5 04 00 00       	jmp    802d79 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8028d4:	83 ec 0c             	sub    $0xc,%esp
  8028d7:	6a 10                	push   $0x10
  8028d9:	e8 cb 1f 00 00       	call   8048a9 <alloc_block>
  8028de:	83 c4 10             	add    $0x10,%esp
  8028e1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  8028e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028e8:	75 0a                	jne    8028f4 <malloc+0x77>
			return NULL;
  8028ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ef:	e9 85 04 00 00       	jmp    802d79 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  8028f4:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8028fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802901:	01 d0                	add    %edx,%eax
  802903:	48                   	dec    %eax
  802904:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802907:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80290a:	ba 00 00 00 00       	mov    $0x0,%edx
  80290f:	f7 75 e8             	divl   -0x18(%ebp)
  802912:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802915:	29 d0                	sub    %edx,%eax
  802917:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80291a:	a1 04 f3 81 00       	mov    0x81f304,%eax
  80291f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802922:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802927:	85 c0                	test   %eax,%eax
  802929:	74 0f                	je     80293a <malloc+0xbd>
  80292b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292e:	8b 40 04             	mov    0x4(%eax),%eax
  802931:	3b 45 08             	cmp    0x8(%ebp),%eax
  802934:	0f 83 ea 00 00 00    	jae    802a24 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  80293a:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80293f:	2b 45 08             	sub    0x8(%ebp),%eax
  802942:	89 c2                	mov    %eax,%edx
  802944:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802949:	39 c2                	cmp    %eax,%edx
  80294b:	0f 86 b9 00 00 00    	jbe    802a0a <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  802951:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802956:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  802959:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80295f:	8b 45 08             	mov    0x8(%ebp),%eax
  802962:	01 d0                	add    %edx,%eax
  802964:	a3 50 f2 81 00       	mov    %eax,0x81f250
					allocblock->startva = requestedblockva;
  802969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80296f:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802974:	8b 55 08             	mov    0x8(%ebp),%edx
  802977:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80297a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80297e:	75 14                	jne    802994 <malloc+0x117>
  802980:	83 ec 04             	sub    $0x4,%esp
  802983:	68 78 64 80 00       	push   $0x806478
  802988:	6a 60                	push   $0x60
  80298a:	68 2c 64 80 00       	push   $0x80642c
  80298f:	e8 02 ec ff ff       	call   801596 <_panic>
  802994:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  80299a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299d:	89 50 0c             	mov    %edx,0xc(%eax)
  8029a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	74 0d                	je     8029b7 <malloc+0x13a>
  8029aa:	a1 14 f3 81 00       	mov    0x81f314,%eax
  8029af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029b2:	89 50 08             	mov    %edx,0x8(%eax)
  8029b5:	eb 08                	jmp    8029bf <malloc+0x142>
  8029b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ba:	a3 10 f3 81 00       	mov    %eax,0x81f310
  8029bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c2:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8029c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029d1:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  8029d6:	40                   	inc    %eax
  8029d7:	a3 1c f3 81 00       	mov    %eax,0x81f31c


					sys_allocate_user_mem(allocblock->startva ,size);
  8029dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029df:	8b 00                	mov    (%eax),%eax
  8029e1:	83 ec 08             	sub    $0x8,%esp
  8029e4:	ff 75 08             	pushl  0x8(%ebp)
  8029e7:	50                   	push   %eax
  8029e8:	e8 34 1c 00 00       	call   804621 <sys_allocate_user_mem>
  8029ed:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  8029f0:	83 ec 0c             	sub    $0xc,%esp
  8029f3:	68 20 f3 81 00       	push   $0x81f320
  8029f8:	e8 6c 27 00 00       	call   805169 <release_uspinlock>
  8029fd:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	e9 6f 03 00 00       	jmp    802d79 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  802a0a:	83 ec 0c             	sub    $0xc,%esp
  802a0d:	68 20 f3 81 00       	push   $0x81f320
  802a12:	e8 52 27 00 00       	call   805169 <release_uspinlock>
  802a17:	83 c4 10             	add    $0x10,%esp
					return NULL;
  802a1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1f:	e9 55 03 00 00       	jmp    802d79 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802a24:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  802a2c:	e9 39 03 00 00       	jmp    802d6a <malloc+0x4ed>
			if(size<currentfreeelement->size){
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	8b 40 04             	mov    0x4(%eax),%eax
  802a37:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a3a:	0f 86 e7 01 00 00    	jbe    802c27 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  802a40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a43:	8b 10                	mov    (%eax),%edx
  802a45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a48:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  802a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a50:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802a53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a57:	75 14                	jne    802a6d <malloc+0x1f0>
  802a59:	83 ec 04             	sub    $0x4,%esp
  802a5c:	68 78 64 80 00       	push   $0x806478
  802a61:	6a 72                	push   $0x72
  802a63:	68 2c 64 80 00       	push   $0x80642c
  802a68:	e8 29 eb ff ff       	call   801596 <_panic>
  802a6d:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a76:	89 50 0c             	mov    %edx,0xc(%eax)
  802a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	74 0d                	je     802a90 <malloc+0x213>
  802a83:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802a88:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a8b:	89 50 08             	mov    %edx,0x8(%eax)
  802a8e:	eb 08                	jmp    802a98 <malloc+0x21b>
  802a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a93:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9b:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802aaa:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802aaf:	40                   	inc    %eax
  802ab0:	a3 1c f3 81 00       	mov    %eax,0x81f31c
                lastfreeelement->startva += size;
  802ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab8:	8b 10                	mov    (%eax),%edx
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	01 c2                	add    %eax,%edx
  802abf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac2:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  802ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac7:	8b 40 04             	mov    0x4(%eax),%eax
  802aca:	2b 45 08             	sub    0x8(%ebp),%eax
  802acd:	89 c2                	mov    %eax,%edx
  802acf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad2:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802ad5:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  802add:	e9 0d 01 00 00       	jmp    802bef <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  802ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae5:	8b 50 04             	mov    0x4(%eax),%edx
  802ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aeb:	8b 40 04             	mov    0x4(%eax),%eax
  802aee:	39 c2                	cmp    %eax,%edx
  802af0:	0f 83 f0 00 00 00    	jae    802be6 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802af6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802afa:	75 14                	jne    802b10 <malloc+0x293>
  802afc:	83 ec 04             	sub    $0x4,%esp
  802aff:	68 9b 64 80 00       	push   $0x80649b
  802b04:	6a 7a                	push   $0x7a
  802b06:	68 2c 64 80 00       	push   $0x80642c
  802b0b:	e8 86 ea ff ff       	call   801596 <_panic>
  802b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b13:	8b 40 08             	mov    0x8(%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 11                	je     802b2b <malloc+0x2ae>
  802b1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1d:	8b 40 08             	mov    0x8(%eax),%eax
  802b20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b23:	8b 52 0c             	mov    0xc(%edx),%edx
  802b26:	89 50 0c             	mov    %edx,0xc(%eax)
  802b29:	eb 0b                	jmp    802b36 <malloc+0x2b9>
  802b2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b31:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802b36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b39:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3c:	85 c0                	test   %eax,%eax
  802b3e:	74 11                	je     802b51 <malloc+0x2d4>
  802b40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b43:	8b 40 0c             	mov    0xc(%eax),%eax
  802b46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b49:	8b 52 08             	mov    0x8(%edx),%edx
  802b4c:	89 50 08             	mov    %edx,0x8(%eax)
  802b4f:	eb 0b                	jmp    802b5c <malloc+0x2df>
  802b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b54:	8b 40 08             	mov    0x8(%eax),%eax
  802b57:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b69:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b70:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802b75:	48                   	dec    %eax
  802b76:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802b7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7f:	74 06                	je     802b87 <malloc+0x30a>
  802b81:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b85:	75 14                	jne    802b9b <malloc+0x31e>
  802b87:	83 ec 04             	sub    $0x4,%esp
  802b8a:	68 bc 64 80 00       	push   $0x8064bc
  802b8f:	6a 7b                	push   $0x7b
  802b91:	68 2c 64 80 00       	push   $0x80642c
  802b96:	e8 fb e9 ff ff       	call   801596 <_panic>
  802b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9e:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba4:	89 50 0c             	mov    %edx,0xc(%eax)
  802ba7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802baa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bad:	89 50 08             	mov    %edx,0x8(%eax)
  802bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	74 0e                	je     802bc8 <malloc+0x34b>
  802bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bc3:	89 50 08             	mov    %edx,0x8(%eax)
  802bc6:	eb 08                	jmp    802bd0 <malloc+0x353>
  802bc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bcb:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bd6:	89 50 0c             	mov    %edx,0xc(%eax)
  802bd9:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802bde:	40                   	inc    %eax
  802bdf:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		break;
  802be4:	eb 13                	jmp    802bf9 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	8b 40 08             	mov    0x8(%eax),%eax
  802bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  802bef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bf3:	0f 85 e9 fe ff ff    	jne    802ae2 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  802bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	83 ec 08             	sub    $0x8,%esp
  802c01:	ff 75 08             	pushl  0x8(%ebp)
  802c04:	50                   	push   %eax
  802c05:	e8 17 1a 00 00       	call   804621 <sys_allocate_user_mem>
  802c0a:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  802c0d:	83 ec 0c             	sub    $0xc,%esp
  802c10:	68 20 f3 81 00       	push   $0x81f320
  802c15:	e8 4f 25 00 00       	call   805169 <release_uspinlock>
  802c1a:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  802c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	e9 52 01 00 00       	jmp    802d79 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	8b 40 04             	mov    0x4(%eax),%eax
  802c2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c30:	0f 85 2b 01 00 00    	jne    802d61 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 10                	mov    (%eax),%edx
  802c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3e:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  802c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c43:	8b 55 08             	mov    0x8(%ebp),%edx
  802c46:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802c49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c4d:	75 17                	jne    802c66 <malloc+0x3e9>
  802c4f:	83 ec 04             	sub    $0x4,%esp
  802c52:	68 78 64 80 00       	push   $0x806478
  802c57:	68 89 00 00 00       	push   $0x89
  802c5c:	68 2c 64 80 00       	push   $0x80642c
  802c61:	e8 30 e9 ff ff       	call   801596 <_panic>
  802c66:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6f:	89 50 0c             	mov    %edx,0xc(%eax)
  802c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c75:	8b 40 0c             	mov    0xc(%eax),%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	74 0d                	je     802c89 <malloc+0x40c>
  802c7c:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802c81:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c84:	89 50 08             	mov    %edx,0x8(%eax)
  802c87:	eb 08                	jmp    802c91 <malloc+0x414>
  802c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8c:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c94:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ca3:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802ca8:	40                   	inc    %eax
  802ca9:	a3 1c f3 81 00       	mov    %eax,0x81f31c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  802cae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb2:	75 17                	jne    802ccb <malloc+0x44e>
  802cb4:	83 ec 04             	sub    $0x4,%esp
  802cb7:	68 9b 64 80 00       	push   $0x80649b
  802cbc:	68 8a 00 00 00       	push   $0x8a
  802cc1:	68 2c 64 80 00       	push   $0x80642c
  802cc6:	e8 cb e8 ff ff       	call   801596 <_panic>
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 40 08             	mov    0x8(%eax),%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	74 11                	je     802ce6 <malloc+0x469>
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 40 08             	mov    0x8(%eax),%eax
  802cdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cde:	8b 52 0c             	mov    0xc(%edx),%edx
  802ce1:	89 50 0c             	mov    %edx,0xc(%eax)
  802ce4:	eb 0b                	jmp    802cf1 <malloc+0x474>
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cec:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf7:	85 c0                	test   %eax,%eax
  802cf9:	74 11                	je     802d0c <malloc+0x48f>
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d04:	8b 52 08             	mov    0x8(%edx),%edx
  802d07:	89 50 08             	mov    %edx,0x8(%eax)
  802d0a:	eb 0b                	jmp    802d17 <malloc+0x49a>
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 40 08             	mov    0x8(%eax),%eax
  802d12:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d2b:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802d30:	48                   	dec    %eax
  802d31:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				sys_allocate_user_mem(allocblock->startva ,size);
  802d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	83 ec 08             	sub    $0x8,%esp
  802d3e:	ff 75 08             	pushl  0x8(%ebp)
  802d41:	50                   	push   %eax
  802d42:	e8 da 18 00 00       	call   804621 <sys_allocate_user_mem>
  802d47:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  802d4a:	83 ec 0c             	sub    $0xc,%esp
  802d4d:	68 20 f3 81 00       	push   $0x81f320
  802d52:	e8 12 24 00 00       	call   805169 <release_uspinlock>
  802d57:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  802d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5d:	8b 00                	mov    (%eax),%eax
  802d5f:	eb 18                	jmp    802d79 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 40 08             	mov    0x8(%eax),%eax
  802d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  802d6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6e:	0f 85 bd fc ff ff    	jne    802a31 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  802d74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d79:	c9                   	leave  
  802d7a:	c3                   	ret    

00802d7b <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802d7b:	55                   	push   %ebp
  802d7c:	89 e5                	mov    %esp,%ebp
  802d7e:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802d8f:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  802d92:	e8 b2 f9 ff ff       	call   802749 <uheap_init>
		acquire_uspinlock(&ulock);
  802d97:	83 ec 0c             	sub    $0xc,%esp
  802d9a:	68 20 f3 81 00       	push   $0x81f320
  802d9f:	e8 6d 23 00 00       	call   805111 <acquire_uspinlock>
  802da4:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  802da7:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802dac:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802daf:	73 23                	jae    802dd4 <free+0x59>
			free_block(virtual_address);
  802db1:	83 ec 0c             	sub    $0xc,%esp
  802db4:	ff 75 08             	pushl  0x8(%ebp)
  802db7:	e8 89 1f 00 00       	call   804d45 <free_block>
  802dbc:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  802dbf:	83 ec 0c             	sub    $0xc,%esp
  802dc2:	68 20 f3 81 00       	push   $0x81f320
  802dc7:	e8 9d 23 00 00       	call   805169 <release_uspinlock>
  802dcc:	83 c4 10             	add    $0x10,%esp
			return;
  802dcf:	e9 35 07 00 00       	jmp    803509 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802dd4:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802dd9:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802ddc:	72 30                	jb     802e0e <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  802dde:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802de3:	83 ec 04             	sub    $0x4,%esp
  802de6:	50                   	push   %eax
  802de7:	ff 75 d8             	pushl  -0x28(%ebp)
  802dea:	68 f1 64 80 00       	push   $0x8064f1
  802def:	e8 70 ea ff ff       	call   801864 <cprintf>
  802df4:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802df7:	83 ec 04             	sub    $0x4,%esp
  802dfa:	68 f9 64 80 00       	push   $0x8064f9
  802dff:	68 a7 00 00 00       	push   $0xa7
  802e04:	68 2c 64 80 00       	push   $0x80642c
  802e09:	e8 88 e7 ff ff       	call   801596 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802e0e:	83 ec 0c             	sub    $0xc,%esp
  802e11:	6a 10                	push   $0x10
  802e13:	e8 91 1a 00 00       	call   8048a9 <alloc_block>
  802e18:	83 c4 10             	add    $0x10,%esp
  802e1b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  802e1e:	83 ec 0c             	sub    $0xc,%esp
  802e21:	6a 10                	push   $0x10
  802e23:	e8 81 1a 00 00       	call   8048a9 <alloc_block>
  802e28:	83 c4 10             	add    $0x10,%esp
  802e2b:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  802e2e:	a1 10 f3 81 00       	mov    0x81f310,%eax
  802e33:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  802e36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  802e3d:	eb 1c                	jmp    802e5b <free+0xe0>

			if (VA ==ToBefreed->startva ){
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	8b 00                	mov    (%eax),%eax
  802e44:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802e47:	75 09                	jne    802e52 <free+0xd7>
				foundVA = 1;
  802e49:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  802e50:	eb 0f                	jmp    802e61 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 40 08             	mov    0x8(%eax),%eax
  802e58:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  802e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5f:	75 de                	jne    802e3f <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  802e61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e65:	75 17                	jne    802e7e <free+0x103>
				panic("INVALID ADDRESS!");
  802e67:	83 ec 04             	sub    $0x4,%esp
  802e6a:	68 16 65 80 00       	push   $0x806516
  802e6f:	68 be 00 00 00       	push   $0xbe
  802e74:	68 2c 64 80 00       	push   $0x80642c
  802e79:	e8 18 e7 ff ff       	call   801596 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 10                	mov    (%eax),%edx
  802e83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e86:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 50 04             	mov    0x4(%eax),%edx
  802e8e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e91:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  802e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e98:	75 17                	jne    802eb1 <free+0x136>
  802e9a:	83 ec 04             	sub    $0x4,%esp
  802e9d:	68 9b 64 80 00       	push   $0x80649b
  802ea2:	68 c8 00 00 00       	push   $0xc8
  802ea7:	68 2c 64 80 00       	push   $0x80642c
  802eac:	e8 e5 e6 ff ff       	call   801596 <_panic>
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	8b 40 08             	mov    0x8(%eax),%eax
  802eb7:	85 c0                	test   %eax,%eax
  802eb9:	74 11                	je     802ecc <free+0x151>
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 40 08             	mov    0x8(%eax),%eax
  802ec1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec4:	8b 52 0c             	mov    0xc(%edx),%edx
  802ec7:	89 50 0c             	mov    %edx,0xc(%eax)
  802eca:	eb 0b                	jmp    802ed7 <free+0x15c>
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed2:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	8b 40 0c             	mov    0xc(%eax),%eax
  802edd:	85 c0                	test   %eax,%eax
  802edf:	74 11                	je     802ef2 <free+0x177>
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eea:	8b 52 08             	mov    0x8(%edx),%edx
  802eed:	89 50 08             	mov    %edx,0x8(%eax)
  802ef0:	eb 0b                	jmp    802efd <free+0x182>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 08             	mov    0x8(%eax),%eax
  802ef8:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f11:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802f16:	48                   	dec    %eax
  802f17:	a3 1c f3 81 00       	mov    %eax,0x81f31c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 50 04             	mov    0x4(%eax),%edx
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	83 ec 08             	sub    $0x8,%esp
  802f2a:	52                   	push   %edx
  802f2b:	50                   	push   %eax
  802f2c:	e8 d4 16 00 00       	call   804605 <sys_free_user_mem>
  802f31:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  802f34:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802f39:	85 c0                	test   %eax,%eax
  802f3b:	75 7a                	jne    802fb7 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  802f3d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802f41:	75 17                	jne    802f5a <free+0x1df>
  802f43:	83 ec 04             	sub    $0x4,%esp
  802f46:	68 28 65 80 00       	push   $0x806528
  802f4b:	68 d0 00 00 00       	push   $0xd0
  802f50:	68 2c 64 80 00       	push   $0x80642c
  802f55:	e8 3c e6 ff ff       	call   801596 <_panic>
  802f5a:	8b 15 00 f3 81 00    	mov    0x81f300,%edx
  802f60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f63:	89 50 08             	mov    %edx,0x8(%eax)
  802f66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f69:	8b 40 08             	mov    0x8(%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 0d                	je     802f7d <free+0x202>
  802f70:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802f75:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f78:	89 50 0c             	mov    %edx,0xc(%eax)
  802f7b:	eb 08                	jmp    802f85 <free+0x20a>
  802f7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f80:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802f85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f88:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802f8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f90:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f97:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802f9c:	40                   	inc    %eax
  802f9d:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			release_uspinlock(&ulock);
  802fa2:	83 ec 0c             	sub    $0xc,%esp
  802fa5:	68 20 f3 81 00       	push   $0x81f320
  802faa:	e8 ba 21 00 00       	call   805169 <release_uspinlock>
  802faf:	83 c4 10             	add    $0x10,%esp
			return;
  802fb2:	e9 52 05 00 00       	jmp    803509 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  802fb7:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802fbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  802fbf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  802fc6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  802fcd:	e9 d2 00 00 00       	jmp    8030a4 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  802fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd5:	8b 10                	mov    (%eax),%edx
  802fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fda:	8b 40 04             	mov    0x4(%eax),%eax
  802fdd:	01 c2                	add    %eax,%edx
  802fdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	39 c2                	cmp    %eax,%edx
  802fe6:	0f 85 af 00 00 00    	jne    80309b <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  802fec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fef:	8b 10                	mov    (%eax),%edx
  802ff1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ff4:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  802ff6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff9:	8b 50 04             	mov    0x4(%eax),%edx
  802ffc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fff:	8b 40 04             	mov    0x4(%eax),%eax
  803002:	01 c2                	add    %eax,%edx
  803004:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803007:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  80300a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80300e:	75 17                	jne    803027 <free+0x2ac>
  803010:	83 ec 04             	sub    $0x4,%esp
  803013:	68 9b 64 80 00       	push   $0x80649b
  803018:	68 df 00 00 00       	push   $0xdf
  80301d:	68 2c 64 80 00       	push   $0x80642c
  803022:	e8 6f e5 ff ff       	call   801596 <_panic>
  803027:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302a:	8b 40 08             	mov    0x8(%eax),%eax
  80302d:	85 c0                	test   %eax,%eax
  80302f:	74 11                	je     803042 <free+0x2c7>
  803031:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803034:	8b 40 08             	mov    0x8(%eax),%eax
  803037:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80303a:	8b 52 0c             	mov    0xc(%edx),%edx
  80303d:	89 50 0c             	mov    %edx,0xc(%eax)
  803040:	eb 0b                	jmp    80304d <free+0x2d2>
  803042:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803045:	8b 40 0c             	mov    0xc(%eax),%eax
  803048:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80304d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803050:	8b 40 0c             	mov    0xc(%eax),%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	74 11                	je     803068 <free+0x2ed>
  803057:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305a:	8b 40 0c             	mov    0xc(%eax),%eax
  80305d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803060:	8b 52 08             	mov    0x8(%edx),%edx
  803063:	89 50 08             	mov    %edx,0x8(%eax)
  803066:	eb 0b                	jmp    803073 <free+0x2f8>
  803068:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306b:	8b 40 08             	mov    0x8(%eax),%eax
  80306e:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803073:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803076:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80307d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803080:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803087:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80308c:	48                   	dec    %eax
  80308d:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				mergeprev = 1;
  803092:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  803099:	eb 13                	jmp    8030ae <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  80309b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309e:	8b 40 08             	mov    0x8(%eax),%eax
  8030a1:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  8030a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030a8:	0f 85 24 ff ff ff    	jne    802fd2 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  8030ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030b1:	8b 10                	mov    (%eax),%edx
  8030b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030b6:	8b 40 04             	mov    0x4(%eax),%eax
  8030b9:	01 c2                	add    %eax,%edx
  8030bb:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8030c0:	39 c2                	cmp    %eax,%edx
  8030c2:	75 44                	jne    803108 <free+0x38d>

			if(mergeprev){
  8030c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030c8:	74 1f                	je     8030e9 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  8030ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  8030d4:	83 ec 0c             	sub    $0xc,%esp
  8030d7:	68 20 f3 81 00       	push   $0x81f320
  8030dc:	e8 88 20 00 00       	call   805169 <release_uspinlock>
  8030e1:	83 c4 10             	add    $0x10,%esp
				return;
  8030e4:	e9 20 04 00 00       	jmp    803509 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  8030e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030ec:	8b 00                	mov    (%eax),%eax
  8030ee:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  8030f3:	83 ec 0c             	sub    $0xc,%esp
  8030f6:	68 20 f3 81 00       	push   $0x81f320
  8030fb:	e8 69 20 00 00       	call   805169 <release_uspinlock>
  803100:	83 c4 10             	add    $0x10,%esp
				return;
  803103:	e9 01 04 00 00       	jmp    803509 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  803108:	a1 00 f3 81 00       	mov    0x81f300,%eax
  80310d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  803110:	e9 7d 01 00 00       	jmp    803292 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  803115:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803118:	8b 10                	mov    (%eax),%edx
  80311a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80311d:	8b 40 04             	mov    0x4(%eax),%eax
  803120:	01 c2                	add    %eax,%edx
  803122:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803125:	8b 00                	mov    (%eax),%eax
  803127:	39 c2                	cmp    %eax,%edx
  803129:	0f 85 5a 01 00 00    	jne    803289 <free+0x50e>
				if (mergeprev){
  80312f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803133:	0f 84 a1 00 00 00    	je     8031da <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  803139:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80313c:	8b 50 04             	mov    0x4(%eax),%edx
  80313f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803142:	8b 40 04             	mov    0x4(%eax),%eax
  803145:	01 c2                	add    %eax,%edx
  803147:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80314a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  80314d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803151:	75 17                	jne    80316a <free+0x3ef>
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	68 9b 64 80 00       	push   $0x80649b
  80315b:	68 0a 01 00 00       	push   $0x10a
  803160:	68 2c 64 80 00       	push   $0x80642c
  803165:	e8 2c e4 ff ff       	call   801596 <_panic>
  80316a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316d:	8b 40 08             	mov    0x8(%eax),%eax
  803170:	85 c0                	test   %eax,%eax
  803172:	74 11                	je     803185 <free+0x40a>
  803174:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803177:	8b 40 08             	mov    0x8(%eax),%eax
  80317a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80317d:	8b 52 0c             	mov    0xc(%edx),%edx
  803180:	89 50 0c             	mov    %edx,0xc(%eax)
  803183:	eb 0b                	jmp    803190 <free+0x415>
  803185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803188:	8b 40 0c             	mov    0xc(%eax),%eax
  80318b:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803190:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803193:	8b 40 0c             	mov    0xc(%eax),%eax
  803196:	85 c0                	test   %eax,%eax
  803198:	74 11                	je     8031ab <free+0x430>
  80319a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319d:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031a3:	8b 52 08             	mov    0x8(%edx),%edx
  8031a6:	89 50 08             	mov    %edx,0x8(%eax)
  8031a9:	eb 0b                	jmp    8031b6 <free+0x43b>
  8031ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ae:	8b 40 08             	mov    0x8(%eax),%eax
  8031b1:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8031b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8031ca:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8031cf:	48                   	dec    %eax
  8031d0:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					break;
  8031d5:	e9 c2 00 00 00       	jmp    80329c <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8031da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031dd:	8b 10                	mov    (%eax),%edx
  8031df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031e2:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  8031e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031e7:	8b 50 04             	mov    0x4(%eax),%edx
  8031ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ed:	8b 40 04             	mov    0x4(%eax),%eax
  8031f0:	01 c2                	add    %eax,%edx
  8031f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031f5:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8031f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031fc:	75 17                	jne    803215 <free+0x49a>
  8031fe:	83 ec 04             	sub    $0x4,%esp
  803201:	68 9b 64 80 00       	push   $0x80649b
  803206:	68 10 01 00 00       	push   $0x110
  80320b:	68 2c 64 80 00       	push   $0x80642c
  803210:	e8 81 e3 ff ff       	call   801596 <_panic>
  803215:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803218:	8b 40 08             	mov    0x8(%eax),%eax
  80321b:	85 c0                	test   %eax,%eax
  80321d:	74 11                	je     803230 <free+0x4b5>
  80321f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803222:	8b 40 08             	mov    0x8(%eax),%eax
  803225:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803228:	8b 52 0c             	mov    0xc(%edx),%edx
  80322b:	89 50 0c             	mov    %edx,0xc(%eax)
  80322e:	eb 0b                	jmp    80323b <free+0x4c0>
  803230:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803233:	8b 40 0c             	mov    0xc(%eax),%eax
  803236:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80323b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323e:	8b 40 0c             	mov    0xc(%eax),%eax
  803241:	85 c0                	test   %eax,%eax
  803243:	74 11                	je     803256 <free+0x4db>
  803245:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803248:	8b 40 0c             	mov    0xc(%eax),%eax
  80324b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80324e:	8b 52 08             	mov    0x8(%edx),%edx
  803251:	89 50 08             	mov    %edx,0x8(%eax)
  803254:	eb 0b                	jmp    803261 <free+0x4e6>
  803256:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803259:	8b 40 08             	mov    0x8(%eax),%eax
  80325c:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803261:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803264:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80326b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803275:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80327a:	48                   	dec    %eax
  80327b:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					mergenext = 1;
  803280:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  803287:	eb 13                	jmp    80329c <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  803289:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328c:	8b 40 08             	mov    0x8(%eax),%eax
  80328f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  803292:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803296:	0f 85 79 fe ff ff    	jne    803115 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  80329c:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8032a1:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  8032a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a8:	0f 85 ad 00 00 00    	jne    80335b <free+0x5e0>
  8032ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032b2:	0f 84 c3 01 00 00    	je     80347b <free+0x700>
				while(currentfree != NULL){
  8032b8:	e9 9e 00 00 00       	jmp    80335b <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8032bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032c0:	8b 50 04             	mov    0x4(%eax),%edx
  8032c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c6:	8b 40 04             	mov    0x4(%eax),%eax
  8032c9:	39 c2                	cmp    %eax,%edx
  8032cb:	0f 83 81 00 00 00    	jae    803352 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8032d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8032d5:	74 06                	je     8032dd <free+0x562>
  8032d7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8032db:	75 17                	jne    8032f4 <free+0x579>
  8032dd:	83 ec 04             	sub    $0x4,%esp
  8032e0:	68 bc 64 80 00       	push   $0x8064bc
  8032e5:	68 23 01 00 00       	push   $0x123
  8032ea:	68 2c 64 80 00       	push   $0x80642c
  8032ef:	e8 a2 e2 ff ff       	call   801596 <_panic>
  8032f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032fd:	89 50 0c             	mov    %edx,0xc(%eax)
  803300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803303:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803306:	89 50 08             	mov    %edx,0x8(%eax)
  803309:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80330c:	8b 40 0c             	mov    0xc(%eax),%eax
  80330f:	85 c0                	test   %eax,%eax
  803311:	74 0e                	je     803321 <free+0x5a6>
  803313:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803316:	8b 40 0c             	mov    0xc(%eax),%eax
  803319:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80331c:	89 50 08             	mov    %edx,0x8(%eax)
  80331f:	eb 08                	jmp    803329 <free+0x5ae>
  803321:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803324:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803329:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80332c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80332f:	89 50 0c             	mov    %edx,0xc(%eax)
  803332:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803337:	40                   	inc    %eax
  803338:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  80333d:	83 ec 0c             	sub    $0xc,%esp
  803340:	68 20 f3 81 00       	push   $0x81f320
  803345:	e8 1f 1e 00 00       	call   805169 <release_uspinlock>
  80334a:	83 c4 10             	add    $0x10,%esp
							return;
  80334d:	e9 b7 01 00 00       	jmp    803509 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  803352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803355:	8b 40 08             	mov    0x8(%eax),%eax
  803358:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  80335b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80335f:	0f 85 58 ff ff ff    	jne    8032bd <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  803365:	83 ec 0c             	sub    $0xc,%esp
  803368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80336b:	e8 d5 19 00 00       	call   804d45 <free_block>
  803370:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  803373:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803377:	75 17                	jne    803390 <free+0x615>
  803379:	83 ec 04             	sub    $0x4,%esp
  80337c:	68 78 64 80 00       	push   $0x806478
  803381:	68 2a 01 00 00       	push   $0x12a
  803386:	68 2c 64 80 00       	push   $0x80642c
  80338b:	e8 06 e2 ff ff       	call   801596 <_panic>
  803390:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  803396:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803399:	89 50 0c             	mov    %edx,0xc(%eax)
  80339c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80339f:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a2:	85 c0                	test   %eax,%eax
  8033a4:	74 0d                	je     8033b3 <free+0x638>
  8033a6:	a1 04 f3 81 00       	mov    0x81f304,%eax
  8033ab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8033ae:	89 50 08             	mov    %edx,0x8(%eax)
  8033b1:	eb 08                	jmp    8033bb <free+0x640>
  8033b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033b6:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8033bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033be:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8033c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8033cd:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8033d2:	40                   	inc    %eax
  8033d3:	a3 0c f3 81 00       	mov    %eax,0x81f30c
  8033d8:	e9 1b 01 00 00       	jmp    8034f8 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8033dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e0:	8b 50 04             	mov    0x4(%eax),%edx
  8033e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e6:	8b 40 04             	mov    0x4(%eax),%eax
  8033e9:	39 c2                	cmp    %eax,%edx
  8033eb:	0f 83 81 00 00 00    	jae    803472 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8033f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033f5:	74 06                	je     8033fd <free+0x682>
  8033f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033fb:	75 17                	jne    803414 <free+0x699>
  8033fd:	83 ec 04             	sub    $0x4,%esp
  803400:	68 bc 64 80 00       	push   $0x8064bc
  803405:	68 30 01 00 00       	push   $0x130
  80340a:	68 2c 64 80 00       	push   $0x80642c
  80340f:	e8 82 e1 ff ff       	call   801596 <_panic>
  803414:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803417:	8b 50 0c             	mov    0xc(%eax),%edx
  80341a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80341d:	89 50 0c             	mov    %edx,0xc(%eax)
  803420:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803423:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803426:	89 50 08             	mov    %edx,0x8(%eax)
  803429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342c:	8b 40 0c             	mov    0xc(%eax),%eax
  80342f:	85 c0                	test   %eax,%eax
  803431:	74 0e                	je     803441 <free+0x6c6>
  803433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803436:	8b 40 0c             	mov    0xc(%eax),%eax
  803439:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80343c:	89 50 08             	mov    %edx,0x8(%eax)
  80343f:	eb 08                	jmp    803449 <free+0x6ce>
  803441:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803444:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803449:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80344c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80344f:	89 50 0c             	mov    %edx,0xc(%eax)
  803452:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803457:	40                   	inc    %eax
  803458:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  80345d:	83 ec 0c             	sub    $0xc,%esp
  803460:	68 20 f3 81 00       	push   $0x81f320
  803465:	e8 ff 1c 00 00       	call   805169 <release_uspinlock>
  80346a:	83 c4 10             	add    $0x10,%esp
							return;
  80346d:	e9 97 00 00 00       	jmp    803509 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  803472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803475:	8b 40 08             	mov    0x8(%eax),%eax
  803478:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  80347b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80347f:	0f 85 58 ff ff ff    	jne    8033dd <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  803485:	83 ec 0c             	sub    $0xc,%esp
  803488:	ff 75 d0             	pushl  -0x30(%ebp)
  80348b:	e8 b5 18 00 00       	call   804d45 <free_block>
  803490:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  803493:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803497:	75 17                	jne    8034b0 <free+0x735>
  803499:	83 ec 04             	sub    $0x4,%esp
  80349c:	68 78 64 80 00       	push   $0x806478
  8034a1:	68 37 01 00 00       	push   $0x137
  8034a6:	68 2c 64 80 00       	push   $0x80642c
  8034ab:	e8 e6 e0 ff ff       	call   801596 <_panic>
  8034b0:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  8034b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b9:	89 50 0c             	mov    %edx,0xc(%eax)
  8034bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c2:	85 c0                	test   %eax,%eax
  8034c4:	74 0d                	je     8034d3 <free+0x758>
  8034c6:	a1 04 f3 81 00       	mov    0x81f304,%eax
  8034cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034ce:	89 50 08             	mov    %edx,0x8(%eax)
  8034d1:	eb 08                	jmp    8034db <free+0x760>
  8034d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d6:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8034db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034de:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8034e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8034ed:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8034f2:	40                   	inc    %eax
  8034f3:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			}
		release_uspinlock(&ulock);
  8034f8:	83 ec 0c             	sub    $0xc,%esp
  8034fb:	68 20 f3 81 00       	push   $0x81f320
  803500:	e8 64 1c 00 00       	call   805169 <release_uspinlock>
  803505:	83 c4 10             	add    $0x10,%esp
		return;
  803508:	90                   	nop
}
  803509:	c9                   	leave  
  80350a:	c3                   	ret    

0080350b <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80350b:	55                   	push   %ebp
  80350c:	89 e5                	mov    %esp,%ebp
  80350e:	83 ec 48             	sub    $0x48,%esp
  803511:	8b 45 10             	mov    0x10(%ebp),%eax
  803514:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803517:	e8 2d f2 ff ff       	call   802749 <uheap_init>
	if (size == 0) return NULL;
  80351c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803520:	75 0a                	jne    80352c <smalloc+0x21>
  803522:	b8 00 00 00 00       	mov    $0x0,%eax
  803527:	e9 84 05 00 00       	jmp    803ab0 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  80352c:	83 ec 0c             	sub    $0xc,%esp
  80352f:	68 20 f3 81 00       	push   $0x81f320
  803534:	e8 d8 1b 00 00       	call   805111 <acquire_uspinlock>
  803539:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80353c:	83 ec 0c             	sub    $0xc,%esp
  80353f:	6a 10                	push   $0x10
  803541:	e8 63 13 00 00       	call   8048a9 <alloc_block>
  803546:	83 c4 10             	add    $0x10,%esp
  803549:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  80354c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803550:	75 0a                	jne    80355c <smalloc+0x51>
				return NULL;
  803552:	b8 00 00 00 00       	mov    $0x0,%eax
  803557:	e9 54 05 00 00       	jmp    803ab0 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  80355c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803563:	8b 55 0c             	mov    0xc(%ebp),%edx
  803566:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803569:	01 d0                	add    %edx,%eax
  80356b:	48                   	dec    %eax
  80356c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80356f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803572:	ba 00 00 00 00       	mov    $0x0,%edx
  803577:	f7 75 e8             	divl   -0x18(%ebp)
  80357a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357d:	29 d0                	sub    %edx,%eax
  80357f:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803582:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803587:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80358a:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80358f:	85 c0                	test   %eax,%eax
  803591:	74 0f                	je     8035a2 <smalloc+0x97>
  803593:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803596:	8b 40 04             	mov    0x4(%eax),%eax
  803599:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80359c:	0f 83 25 01 00 00    	jae    8036c7 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8035a2:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8035a7:	2b 45 0c             	sub    0xc(%ebp),%eax
  8035aa:	89 c2                	mov    %eax,%edx
  8035ac:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8035b1:	39 c2                	cmp    %eax,%edx
  8035b3:	0f 82 f4 00 00 00    	jb     8036ad <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  8035b9:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8035be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  8035c1:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8035c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ca:	01 d0                	add    %edx,%eax
  8035cc:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  8035d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035d7:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8035d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035df:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8035e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035e6:	75 17                	jne    8035ff <smalloc+0xf4>
  8035e8:	83 ec 04             	sub    $0x4,%esp
  8035eb:	68 78 64 80 00       	push   $0x806478
  8035f0:	68 57 01 00 00       	push   $0x157
  8035f5:	68 2c 64 80 00       	push   $0x80642c
  8035fa:	e8 97 df ff ff       	call   801596 <_panic>
  8035ff:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803608:	89 50 0c             	mov    %edx,0xc(%eax)
  80360b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360e:	8b 40 0c             	mov    0xc(%eax),%eax
  803611:	85 c0                	test   %eax,%eax
  803613:	74 0d                	je     803622 <smalloc+0x117>
  803615:	a1 14 f3 81 00       	mov    0x81f314,%eax
  80361a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80361d:	89 50 08             	mov    %edx,0x8(%eax)
  803620:	eb 08                	jmp    80362a <smalloc+0x11f>
  803622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803625:	a3 10 f3 81 00       	mov    %eax,0x81f310
  80362a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80362d:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803632:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803635:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80363c:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803641:	40                   	inc    %eax
  803642:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803647:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80364a:	8b 00                	mov    (%eax),%eax
  80364c:	89 c2                	mov    %eax,%edx
  80364e:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803652:	52                   	push   %edx
  803653:	50                   	push   %eax
  803654:	ff 75 0c             	pushl  0xc(%ebp)
  803657:	ff 75 08             	pushl  0x8(%ebp)
  80365a:	e8 48 0c 00 00       	call   8042a7 <sys_create_shared_object>
  80365f:	83 c4 10             	add    $0x10,%esp
  803662:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  803665:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803669:	79 28                	jns    803693 <smalloc+0x188>
							free_block(allocblock);
  80366b:	83 ec 0c             	sub    $0xc,%esp
  80366e:	ff 75 ec             	pushl  -0x14(%ebp)
  803671:	e8 cf 16 00 00       	call   804d45 <free_block>
  803676:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803679:	83 ec 0c             	sub    $0xc,%esp
  80367c:	68 20 f3 81 00       	push   $0x81f320
  803681:	e8 e3 1a 00 00       	call   805169 <release_uspinlock>
  803686:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803689:	b8 00 00 00 00       	mov    $0x0,%eax
  80368e:	e9 1d 04 00 00       	jmp    803ab0 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  803693:	83 ec 0c             	sub    $0xc,%esp
  803696:	68 20 f3 81 00       	push   $0x81f320
  80369b:	e8 c9 1a 00 00       	call   805169 <release_uspinlock>
  8036a0:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8036a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a6:	8b 00                	mov    (%eax),%eax
  8036a8:	e9 03 04 00 00       	jmp    803ab0 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  8036ad:	83 ec 0c             	sub    $0xc,%esp
  8036b0:	68 20 f3 81 00       	push   $0x81f320
  8036b5:	e8 af 1a 00 00       	call   805169 <release_uspinlock>
  8036ba:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8036bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c2:	e9 e9 03 00 00       	jmp    803ab0 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8036c7:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8036cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8036cf:	e9 af 03 00 00       	jmp    803a83 <smalloc+0x578>
				if(size<currentfreeelement->size){
  8036d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d7:	8b 40 04             	mov    0x4(%eax),%eax
  8036da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036dd:	0f 86 28 02 00 00    	jbe    80390b <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  8036e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036e6:	8b 10                	mov    (%eax),%edx
  8036e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036eb:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  8036ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036f3:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8036f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036fa:	75 17                	jne    803713 <smalloc+0x208>
  8036fc:	83 ec 04             	sub    $0x4,%esp
  8036ff:	68 78 64 80 00       	push   $0x806478
  803704:	68 6f 01 00 00       	push   $0x16f
  803709:	68 2c 64 80 00       	push   $0x80642c
  80370e:	e8 83 de ff ff       	call   801596 <_panic>
  803713:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80371c:	89 50 0c             	mov    %edx,0xc(%eax)
  80371f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803722:	8b 40 0c             	mov    0xc(%eax),%eax
  803725:	85 c0                	test   %eax,%eax
  803727:	74 0d                	je     803736 <smalloc+0x22b>
  803729:	a1 14 f3 81 00       	mov    0x81f314,%eax
  80372e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803731:	89 50 08             	mov    %edx,0x8(%eax)
  803734:	eb 08                	jmp    80373e <smalloc+0x233>
  803736:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803739:	a3 10 f3 81 00       	mov    %eax,0x81f310
  80373e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803741:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803746:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803749:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803750:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803755:	40                   	inc    %eax
  803756:	a3 1c f3 81 00       	mov    %eax,0x81f31c
	                lastfreeelement->startva += size;
  80375b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80375e:	8b 10                	mov    (%eax),%edx
  803760:	8b 45 0c             	mov    0xc(%ebp),%eax
  803763:	01 c2                	add    %eax,%edx
  803765:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803768:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  80376a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80376d:	8b 40 04             	mov    0x4(%eax),%eax
  803770:	2b 45 0c             	sub    0xc(%ebp),%eax
  803773:	89 c2                	mov    %eax,%edx
  803775:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803778:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  80377b:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803780:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  803783:	e9 13 01 00 00       	jmp    80389b <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  803788:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80378b:	8b 50 04             	mov    0x4(%eax),%edx
  80378e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803791:	8b 40 04             	mov    0x4(%eax),%eax
  803794:	39 c2                	cmp    %eax,%edx
  803796:	0f 83 f6 00 00 00    	jae    803892 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  80379c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8037a0:	75 17                	jne    8037b9 <smalloc+0x2ae>
  8037a2:	83 ec 04             	sub    $0x4,%esp
  8037a5:	68 9b 64 80 00       	push   $0x80649b
  8037aa:	68 77 01 00 00       	push   $0x177
  8037af:	68 2c 64 80 00       	push   $0x80642c
  8037b4:	e8 dd dd ff ff       	call   801596 <_panic>
  8037b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037bc:	8b 40 08             	mov    0x8(%eax),%eax
  8037bf:	85 c0                	test   %eax,%eax
  8037c1:	74 11                	je     8037d4 <smalloc+0x2c9>
  8037c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c6:	8b 40 08             	mov    0x8(%eax),%eax
  8037c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037cc:	8b 52 0c             	mov    0xc(%edx),%edx
  8037cf:	89 50 0c             	mov    %edx,0xc(%eax)
  8037d2:	eb 0b                	jmp    8037df <smalloc+0x2d4>
  8037d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8037da:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8037df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e5:	85 c0                	test   %eax,%eax
  8037e7:	74 11                	je     8037fa <smalloc+0x2ef>
  8037e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037f2:	8b 52 08             	mov    0x8(%edx),%edx
  8037f5:	89 50 08             	mov    %edx,0x8(%eax)
  8037f8:	eb 0b                	jmp    803805 <smalloc+0x2fa>
  8037fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037fd:	8b 40 08             	mov    0x8(%eax),%eax
  803800:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803805:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803808:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80380f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803812:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803819:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80381e:	48                   	dec    %eax
  80381f:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803824:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803828:	74 06                	je     803830 <smalloc+0x325>
  80382a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80382e:	75 17                	jne    803847 <smalloc+0x33c>
  803830:	83 ec 04             	sub    $0x4,%esp
  803833:	68 bc 64 80 00       	push   $0x8064bc
  803838:	68 78 01 00 00       	push   $0x178
  80383d:	68 2c 64 80 00       	push   $0x80642c
  803842:	e8 4f dd ff ff       	call   801596 <_panic>
  803847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384a:	8b 50 0c             	mov    0xc(%eax),%edx
  80384d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803850:	89 50 0c             	mov    %edx,0xc(%eax)
  803853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803856:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803859:	89 50 08             	mov    %edx,0x8(%eax)
  80385c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385f:	8b 40 0c             	mov    0xc(%eax),%eax
  803862:	85 c0                	test   %eax,%eax
  803864:	74 0e                	je     803874 <smalloc+0x369>
  803866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803869:	8b 40 0c             	mov    0xc(%eax),%eax
  80386c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80386f:	89 50 08             	mov    %edx,0x8(%eax)
  803872:	eb 08                	jmp    80387c <smalloc+0x371>
  803874:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803877:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80387c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80387f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803882:	89 50 0c             	mov    %edx,0xc(%eax)
  803885:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80388a:	40                   	inc    %eax
  80388b:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		break;
  803890:	eb 13                	jmp    8038a5 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  803892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803895:	8b 40 08             	mov    0x8(%eax),%eax
  803898:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  80389b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80389f:	0f 85 e3 fe ff ff    	jne    803788 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8038a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038a8:	8b 00                	mov    (%eax),%eax
  8038aa:	89 c2                	mov    %eax,%edx
  8038ac:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8038b0:	52                   	push   %edx
  8038b1:	50                   	push   %eax
  8038b2:	ff 75 0c             	pushl  0xc(%ebp)
  8038b5:	ff 75 08             	pushl  0x8(%ebp)
  8038b8:	e8 ea 09 00 00       	call   8042a7 <sys_create_shared_object>
  8038bd:	83 c4 10             	add    $0x10,%esp
  8038c0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  8038c3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8038c7:	79 28                	jns    8038f1 <smalloc+0x3e6>
	                	free_block(allocblock);
  8038c9:	83 ec 0c             	sub    $0xc,%esp
  8038cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8038cf:	e8 71 14 00 00       	call   804d45 <free_block>
  8038d4:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  8038d7:	83 ec 0c             	sub    $0xc,%esp
  8038da:	68 20 f3 81 00       	push   $0x81f320
  8038df:	e8 85 18 00 00       	call   805169 <release_uspinlock>
  8038e4:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  8038e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ec:	e9 bf 01 00 00       	jmp    803ab0 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  8038f1:	83 ec 0c             	sub    $0xc,%esp
  8038f4:	68 20 f3 81 00       	push   $0x81f320
  8038f9:	e8 6b 18 00 00       	call   805169 <release_uspinlock>
  8038fe:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  803901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803904:	8b 00                	mov    (%eax),%eax
  803906:	e9 a5 01 00 00       	jmp    803ab0 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  80390b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390e:	8b 40 04             	mov    0x4(%eax),%eax
  803911:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803914:	0f 85 60 01 00 00    	jne    803a7a <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  80391a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391d:	8b 10                	mov    (%eax),%edx
  80391f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803922:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803924:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80392a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  80392d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803931:	75 17                	jne    80394a <smalloc+0x43f>
  803933:	83 ec 04             	sub    $0x4,%esp
  803936:	68 78 64 80 00       	push   $0x806478
  80393b:	68 8c 01 00 00       	push   $0x18c
  803940:	68 2c 64 80 00       	push   $0x80642c
  803945:	e8 4c dc ff ff       	call   801596 <_panic>
  80394a:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803953:	89 50 0c             	mov    %edx,0xc(%eax)
  803956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803959:	8b 40 0c             	mov    0xc(%eax),%eax
  80395c:	85 c0                	test   %eax,%eax
  80395e:	74 0d                	je     80396d <smalloc+0x462>
  803960:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803965:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803968:	89 50 08             	mov    %edx,0x8(%eax)
  80396b:	eb 08                	jmp    803975 <smalloc+0x46a>
  80396d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803970:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803978:	a3 14 f3 81 00       	mov    %eax,0x81f314
  80397d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803980:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803987:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  80398c:	40                   	inc    %eax
  80398d:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803992:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803996:	75 17                	jne    8039af <smalloc+0x4a4>
  803998:	83 ec 04             	sub    $0x4,%esp
  80399b:	68 9b 64 80 00       	push   $0x80649b
  8039a0:	68 8d 01 00 00       	push   $0x18d
  8039a5:	68 2c 64 80 00       	push   $0x80642c
  8039aa:	e8 e7 db ff ff       	call   801596 <_panic>
  8039af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b2:	8b 40 08             	mov    0x8(%eax),%eax
  8039b5:	85 c0                	test   %eax,%eax
  8039b7:	74 11                	je     8039ca <smalloc+0x4bf>
  8039b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bc:	8b 40 08             	mov    0x8(%eax),%eax
  8039bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8039c5:	89 50 0c             	mov    %edx,0xc(%eax)
  8039c8:	eb 0b                	jmp    8039d5 <smalloc+0x4ca>
  8039ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d0:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8039d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8039db:	85 c0                	test   %eax,%eax
  8039dd:	74 11                	je     8039f0 <smalloc+0x4e5>
  8039df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8039e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039e8:	8b 52 08             	mov    0x8(%edx),%edx
  8039eb:	89 50 08             	mov    %edx,0x8(%eax)
  8039ee:	eb 0b                	jmp    8039fb <smalloc+0x4f0>
  8039f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f3:	8b 40 08             	mov    0x8(%eax),%eax
  8039f6:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8039fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a08:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803a0f:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803a14:	48                   	dec    %eax
  803a15:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a1d:	8b 00                	mov    (%eax),%eax
  803a1f:	89 c2                	mov    %eax,%edx
  803a21:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803a25:	52                   	push   %edx
  803a26:	50                   	push   %eax
  803a27:	ff 75 0c             	pushl  0xc(%ebp)
  803a2a:	ff 75 08             	pushl  0x8(%ebp)
  803a2d:	e8 75 08 00 00       	call   8042a7 <sys_create_shared_object>
  803a32:	83 c4 10             	add    $0x10,%esp
  803a35:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  803a38:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a3c:	79 25                	jns    803a63 <smalloc+0x558>
						free_block(allocblock);
  803a3e:	83 ec 0c             	sub    $0xc,%esp
  803a41:	ff 75 ec             	pushl  -0x14(%ebp)
  803a44:	e8 fc 12 00 00       	call   804d45 <free_block>
  803a49:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803a4c:	83 ec 0c             	sub    $0xc,%esp
  803a4f:	68 20 f3 81 00       	push   $0x81f320
  803a54:	e8 10 17 00 00       	call   805169 <release_uspinlock>
  803a59:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803a5c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a61:	eb 4d                	jmp    803ab0 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  803a63:	83 ec 0c             	sub    $0xc,%esp
  803a66:	68 20 f3 81 00       	push   $0x81f320
  803a6b:	e8 f9 16 00 00       	call   805169 <release_uspinlock>
  803a70:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a76:	8b 00                	mov    (%eax),%eax
  803a78:	eb 36                	jmp    803ab0 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7d:	8b 40 08             	mov    0x8(%eax),%eax
  803a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803a83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a87:	0f 85 47 fc ff ff    	jne    8036d4 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  803a8d:	83 ec 0c             	sub    $0xc,%esp
  803a90:	ff 75 ec             	pushl  -0x14(%ebp)
  803a93:	e8 ad 12 00 00       	call   804d45 <free_block>
  803a98:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803a9b:	83 ec 0c             	sub    $0xc,%esp
  803a9e:	68 20 f3 81 00       	push   $0x81f320
  803aa3:	e8 c1 16 00 00       	call   805169 <release_uspinlock>
  803aa8:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803aab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ab0:	c9                   	leave  
  803ab1:	c3                   	ret    

00803ab2 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  803ab2:	55                   	push   %ebp
  803ab3:	89 e5                	mov    %esp,%ebp
  803ab5:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  803ab8:	e8 8c ec ff ff       	call   802749 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  803abd:	83 ec 0c             	sub    $0xc,%esp
  803ac0:	68 20 f3 81 00       	push   $0x81f320
  803ac5:	e8 47 16 00 00       	call   805111 <acquire_uspinlock>
  803aca:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  803acd:	83 ec 08             	sub    $0x8,%esp
  803ad0:	ff 75 0c             	pushl  0xc(%ebp)
  803ad3:	ff 75 08             	pushl  0x8(%ebp)
  803ad6:	e8 f6 07 00 00       	call   8042d1 <sys_size_of_shared_object>
  803adb:	83 c4 10             	add    $0x10,%esp
  803ade:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  803ae1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ae5:	79 1a                	jns    803b01 <sget+0x4f>
			release_uspinlock(&ulock);
  803ae7:	83 ec 0c             	sub    $0xc,%esp
  803aea:	68 20 f3 81 00       	push   $0x81f320
  803aef:	e8 75 16 00 00       	call   805169 <release_uspinlock>
  803af4:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803af7:	b8 00 00 00 00       	mov    $0x0,%eax
  803afc:	e9 6e 05 00 00       	jmp    80406f <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  803b01:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803b08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0e:	01 d0                	add    %edx,%eax
  803b10:	48                   	dec    %eax
  803b11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803b14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b17:	ba 00 00 00 00       	mov    $0x0,%edx
  803b1c:	f7 75 e8             	divl   -0x18(%ebp)
  803b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b22:	29 d0                	sub    %edx,%eax
  803b24:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803b27:	83 ec 0c             	sub    $0xc,%esp
  803b2a:	6a 10                	push   $0x10
  803b2c:	e8 78 0d 00 00       	call   8048a9 <alloc_block>
  803b31:	83 c4 10             	add    $0x10,%esp
  803b34:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  803b37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803b3b:	75 0a                	jne    803b47 <sget+0x95>
			return NULL;
  803b3d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b42:	e9 28 05 00 00       	jmp    80406f <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803b47:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803b4c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  803b4f:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803b54:	85 c0                	test   %eax,%eax
  803b56:	74 11                	je     803b69 <sget+0xb7>
  803b58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b5b:	8b 50 04             	mov    0x4(%eax),%edx
  803b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b61:	39 c2                	cmp    %eax,%edx
  803b63:	0f 83 21 01 00 00    	jae    803c8a <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  803b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b6c:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  803b71:	29 c2                	sub    %eax,%edx
  803b73:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803b78:	39 c2                	cmp    %eax,%edx
  803b7a:	0f 82 f0 00 00 00    	jb     803c70 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  803b80:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803b85:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  803b88:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b91:	01 d0                	add    %edx,%eax
  803b93:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  803b98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b9b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b9e:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803ba0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ba3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ba6:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  803ba9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803bad:	75 17                	jne    803bc6 <sget+0x114>
  803baf:	83 ec 04             	sub    $0x4,%esp
  803bb2:	68 78 64 80 00       	push   $0x806478
  803bb7:	68 c8 01 00 00       	push   $0x1c8
  803bbc:	68 2c 64 80 00       	push   $0x80642c
  803bc1:	e8 d0 d9 ff ff       	call   801596 <_panic>
  803bc6:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803bcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bcf:	89 50 0c             	mov    %edx,0xc(%eax)
  803bd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  803bd8:	85 c0                	test   %eax,%eax
  803bda:	74 0d                	je     803be9 <sget+0x137>
  803bdc:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803be1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803be4:	89 50 08             	mov    %edx,0x8(%eax)
  803be7:	eb 08                	jmp    803bf1 <sget+0x13f>
  803be9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bec:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803bf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bf4:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803bf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bfc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803c03:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803c08:	40                   	inc    %eax
  803c09:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803c0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c11:	8b 00                	mov    (%eax),%eax
  803c13:	83 ec 04             	sub    $0x4,%esp
  803c16:	50                   	push   %eax
  803c17:	ff 75 0c             	pushl  0xc(%ebp)
  803c1a:	ff 75 08             	pushl  0x8(%ebp)
  803c1d:	e8 cc 06 00 00       	call   8042ee <sys_get_shared_object>
  803c22:	83 c4 10             	add    $0x10,%esp
  803c25:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  803c28:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803c2c:	79 28                	jns    803c56 <sget+0x1a4>
							free_block(allocblock);
  803c2e:	83 ec 0c             	sub    $0xc,%esp
  803c31:	ff 75 e0             	pushl  -0x20(%ebp)
  803c34:	e8 0c 11 00 00       	call   804d45 <free_block>
  803c39:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803c3c:	83 ec 0c             	sub    $0xc,%esp
  803c3f:	68 20 f3 81 00       	push   $0x81f320
  803c44:	e8 20 15 00 00       	call   805169 <release_uspinlock>
  803c49:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  803c51:	e9 19 04 00 00       	jmp    80406f <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  803c56:	83 ec 0c             	sub    $0xc,%esp
  803c59:	68 20 f3 81 00       	push   $0x81f320
  803c5e:	e8 06 15 00 00       	call   805169 <release_uspinlock>
  803c63:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803c66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c69:	8b 00                	mov    (%eax),%eax
  803c6b:	e9 ff 03 00 00       	jmp    80406f <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  803c70:	83 ec 0c             	sub    $0xc,%esp
  803c73:	68 20 f3 81 00       	push   $0x81f320
  803c78:	e8 ec 14 00 00       	call   805169 <release_uspinlock>
  803c7d:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803c80:	b8 00 00 00 00       	mov    $0x0,%eax
  803c85:	e9 e5 03 00 00       	jmp    80406f <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803c8a:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803c92:	e9 ab 03 00 00       	jmp    804042 <sget+0x590>
				if(size<currentfreeelement->size){
  803c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9a:	8b 50 04             	mov    0x4(%eax),%edx
  803c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ca0:	39 c2                	cmp    %eax,%edx
  803ca2:	0f 86 24 02 00 00    	jbe    803ecc <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  803ca8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cab:	8b 10                	mov    (%eax),%edx
  803cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cb0:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803cb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cb8:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803cbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803cbf:	75 17                	jne    803cd8 <sget+0x226>
  803cc1:	83 ec 04             	sub    $0x4,%esp
  803cc4:	68 78 64 80 00       	push   $0x806478
  803cc9:	68 e0 01 00 00       	push   $0x1e0
  803cce:	68 2c 64 80 00       	push   $0x80642c
  803cd3:	e8 be d8 ff ff       	call   801596 <_panic>
  803cd8:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803cde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ce1:	89 50 0c             	mov    %edx,0xc(%eax)
  803ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ce7:	8b 40 0c             	mov    0xc(%eax),%eax
  803cea:	85 c0                	test   %eax,%eax
  803cec:	74 0d                	je     803cfb <sget+0x249>
  803cee:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803cf3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cf6:	89 50 08             	mov    %edx,0x8(%eax)
  803cf9:	eb 08                	jmp    803d03 <sget+0x251>
  803cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cfe:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803d03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d06:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803d15:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803d1a:	40                   	inc    %eax
  803d1b:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					lastfreeelement->startva += size;
  803d20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d23:	8b 10                	mov    (%eax),%edx
  803d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d28:	01 c2                	add    %eax,%edx
  803d2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d2d:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  803d2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d32:	8b 50 04             	mov    0x4(%eax),%edx
  803d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d38:	29 c2                	sub    %eax,%edx
  803d3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d3d:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803d40:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  803d48:	e9 13 01 00 00       	jmp    803e60 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  803d4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d50:	8b 50 04             	mov    0x4(%eax),%edx
  803d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d56:	8b 40 04             	mov    0x4(%eax),%eax
  803d59:	39 c2                	cmp    %eax,%edx
  803d5b:	0f 83 f6 00 00 00    	jae    803e57 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  803d61:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d65:	75 17                	jne    803d7e <sget+0x2cc>
  803d67:	83 ec 04             	sub    $0x4,%esp
  803d6a:	68 9b 64 80 00       	push   $0x80649b
  803d6f:	68 e8 01 00 00       	push   $0x1e8
  803d74:	68 2c 64 80 00       	push   $0x80642c
  803d79:	e8 18 d8 ff ff       	call   801596 <_panic>
  803d7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d81:	8b 40 08             	mov    0x8(%eax),%eax
  803d84:	85 c0                	test   %eax,%eax
  803d86:	74 11                	je     803d99 <sget+0x2e7>
  803d88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d8b:	8b 40 08             	mov    0x8(%eax),%eax
  803d8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d91:	8b 52 0c             	mov    0xc(%edx),%edx
  803d94:	89 50 0c             	mov    %edx,0xc(%eax)
  803d97:	eb 0b                	jmp    803da4 <sget+0x2f2>
  803d99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d9c:	8b 40 0c             	mov    0xc(%eax),%eax
  803d9f:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803da4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803da7:	8b 40 0c             	mov    0xc(%eax),%eax
  803daa:	85 c0                	test   %eax,%eax
  803dac:	74 11                	je     803dbf <sget+0x30d>
  803dae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803db1:	8b 40 0c             	mov    0xc(%eax),%eax
  803db4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803db7:	8b 52 08             	mov    0x8(%edx),%edx
  803dba:	89 50 08             	mov    %edx,0x8(%eax)
  803dbd:	eb 0b                	jmp    803dca <sget+0x318>
  803dbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dc2:	8b 40 08             	mov    0x8(%eax),%eax
  803dc5:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803dca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dcd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803dd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dd7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803dde:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803de3:	48                   	dec    %eax
  803de4:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803de9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ded:	74 06                	je     803df5 <sget+0x343>
  803def:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803df3:	75 17                	jne    803e0c <sget+0x35a>
  803df5:	83 ec 04             	sub    $0x4,%esp
  803df8:	68 bc 64 80 00       	push   $0x8064bc
  803dfd:	68 e9 01 00 00       	push   $0x1e9
  803e02:	68 2c 64 80 00       	push   $0x80642c
  803e07:	e8 8a d7 ff ff       	call   801596 <_panic>
  803e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e0f:	8b 50 0c             	mov    0xc(%eax),%edx
  803e12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e15:	89 50 0c             	mov    %edx,0xc(%eax)
  803e18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e1e:	89 50 08             	mov    %edx,0x8(%eax)
  803e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e24:	8b 40 0c             	mov    0xc(%eax),%eax
  803e27:	85 c0                	test   %eax,%eax
  803e29:	74 0e                	je     803e39 <sget+0x387>
  803e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e2e:	8b 40 0c             	mov    0xc(%eax),%eax
  803e31:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e34:	89 50 08             	mov    %edx,0x8(%eax)
  803e37:	eb 08                	jmp    803e41 <sget+0x38f>
  803e39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3c:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e44:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e47:	89 50 0c             	mov    %edx,0xc(%eax)
  803e4a:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803e4f:	40                   	inc    %eax
  803e50:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							break;
  803e55:	eb 13                	jmp    803e6a <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  803e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e5a:	8b 40 08             	mov    0x8(%eax),%eax
  803e5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  803e60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e64:	0f 85 e3 fe ff ff    	jne    803d4d <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803e6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e6d:	8b 00                	mov    (%eax),%eax
  803e6f:	83 ec 04             	sub    $0x4,%esp
  803e72:	50                   	push   %eax
  803e73:	ff 75 0c             	pushl  0xc(%ebp)
  803e76:	ff 75 08             	pushl  0x8(%ebp)
  803e79:	e8 70 04 00 00       	call   8042ee <sys_get_shared_object>
  803e7e:	83 c4 10             	add    $0x10,%esp
  803e81:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  803e84:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e88:	79 28                	jns    803eb2 <sget+0x400>
						free_block(allocblock);
  803e8a:	83 ec 0c             	sub    $0xc,%esp
  803e8d:	ff 75 e0             	pushl  -0x20(%ebp)
  803e90:	e8 b0 0e 00 00       	call   804d45 <free_block>
  803e95:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803e98:	83 ec 0c             	sub    $0xc,%esp
  803e9b:	68 20 f3 81 00       	push   $0x81f320
  803ea0:	e8 c4 12 00 00       	call   805169 <release_uspinlock>
  803ea5:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ead:	e9 bd 01 00 00       	jmp    80406f <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  803eb2:	83 ec 0c             	sub    $0xc,%esp
  803eb5:	68 20 f3 81 00       	push   $0x81f320
  803eba:	e8 aa 12 00 00       	call   805169 <release_uspinlock>
  803ebf:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803ec2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ec5:	8b 00                	mov    (%eax),%eax
  803ec7:	e9 a3 01 00 00       	jmp    80406f <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  803ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ecf:	8b 50 04             	mov    0x4(%eax),%edx
  803ed2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ed5:	39 c2                	cmp    %eax,%edx
  803ed7:	0f 85 5c 01 00 00    	jne    804039 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  803edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee0:	8b 10                	mov    (%eax),%edx
  803ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ee5:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803ee7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803eea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803eed:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803ef0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803ef4:	75 17                	jne    803f0d <sget+0x45b>
  803ef6:	83 ec 04             	sub    $0x4,%esp
  803ef9:	68 78 64 80 00       	push   $0x806478
  803efe:	68 fe 01 00 00       	push   $0x1fe
  803f03:	68 2c 64 80 00       	push   $0x80642c
  803f08:	e8 89 d6 ff ff       	call   801596 <_panic>
  803f0d:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803f13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f16:	89 50 0c             	mov    %edx,0xc(%eax)
  803f19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f1c:	8b 40 0c             	mov    0xc(%eax),%eax
  803f1f:	85 c0                	test   %eax,%eax
  803f21:	74 0d                	je     803f30 <sget+0x47e>
  803f23:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803f28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f2b:	89 50 08             	mov    %edx,0x8(%eax)
  803f2e:	eb 08                	jmp    803f38 <sget+0x486>
  803f30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f33:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803f38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f3b:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803f40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803f4a:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803f4f:	40                   	inc    %eax
  803f50:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803f55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f59:	75 17                	jne    803f72 <sget+0x4c0>
  803f5b:	83 ec 04             	sub    $0x4,%esp
  803f5e:	68 9b 64 80 00       	push   $0x80649b
  803f63:	68 ff 01 00 00       	push   $0x1ff
  803f68:	68 2c 64 80 00       	push   $0x80642c
  803f6d:	e8 24 d6 ff ff       	call   801596 <_panic>
  803f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f75:	8b 40 08             	mov    0x8(%eax),%eax
  803f78:	85 c0                	test   %eax,%eax
  803f7a:	74 11                	je     803f8d <sget+0x4db>
  803f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7f:	8b 40 08             	mov    0x8(%eax),%eax
  803f82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f85:	8b 52 0c             	mov    0xc(%edx),%edx
  803f88:	89 50 0c             	mov    %edx,0xc(%eax)
  803f8b:	eb 0b                	jmp    803f98 <sget+0x4e6>
  803f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f90:	8b 40 0c             	mov    0xc(%eax),%eax
  803f93:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9b:	8b 40 0c             	mov    0xc(%eax),%eax
  803f9e:	85 c0                	test   %eax,%eax
  803fa0:	74 11                	je     803fb3 <sget+0x501>
  803fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa5:	8b 40 0c             	mov    0xc(%eax),%eax
  803fa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fab:	8b 52 08             	mov    0x8(%edx),%edx
  803fae:	89 50 08             	mov    %edx,0x8(%eax)
  803fb1:	eb 0b                	jmp    803fbe <sget+0x50c>
  803fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fb6:	8b 40 08             	mov    0x8(%eax),%eax
  803fb9:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fcb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803fd2:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803fd7:	48                   	dec    %eax
  803fd8:	a3 0c f3 81 00       	mov    %eax,0x81f30c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803fdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fe0:	8b 00                	mov    (%eax),%eax
  803fe2:	83 ec 04             	sub    $0x4,%esp
  803fe5:	50                   	push   %eax
  803fe6:	ff 75 0c             	pushl  0xc(%ebp)
  803fe9:	ff 75 08             	pushl  0x8(%ebp)
  803fec:	e8 fd 02 00 00       	call   8042ee <sys_get_shared_object>
  803ff1:	83 c4 10             	add    $0x10,%esp
  803ff4:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803ff7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803ffb:	79 25                	jns    804022 <sget+0x570>
						free_block(allocblock);
  803ffd:	83 ec 0c             	sub    $0xc,%esp
  804000:	ff 75 e0             	pushl  -0x20(%ebp)
  804003:	e8 3d 0d 00 00       	call   804d45 <free_block>
  804008:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  80400b:	83 ec 0c             	sub    $0xc,%esp
  80400e:	68 20 f3 81 00       	push   $0x81f320
  804013:	e8 51 11 00 00       	call   805169 <release_uspinlock>
  804018:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80401b:	b8 00 00 00 00       	mov    $0x0,%eax
  804020:	eb 4d                	jmp    80406f <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  804022:	83 ec 0c             	sub    $0xc,%esp
  804025:	68 20 f3 81 00       	push   $0x81f320
  80402a:	e8 3a 11 00 00       	call   805169 <release_uspinlock>
  80402f:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  804032:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804035:	8b 00                	mov    (%eax),%eax
  804037:	eb 36                	jmp    80406f <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  804039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80403c:	8b 40 08             	mov    0x8(%eax),%eax
  80403f:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  804042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804046:	0f 85 4b fc ff ff    	jne    803c97 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  80404c:	83 ec 0c             	sub    $0xc,%esp
  80404f:	ff 75 e0             	pushl  -0x20(%ebp)
  804052:	e8 ee 0c 00 00       	call   804d45 <free_block>
  804057:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  80405a:	83 ec 0c             	sub    $0xc,%esp
  80405d:	68 20 f3 81 00       	push   $0x81f320
  804062:	e8 02 11 00 00       	call   805169 <release_uspinlock>
  804067:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80406a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80406f:	c9                   	leave  
  804070:	c3                   	ret    

00804071 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  804071:	55                   	push   %ebp
  804072:	89 e5                	mov    %esp,%ebp
  804074:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  804077:	e8 cd e6 ff ff       	call   802749 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80407c:	83 ec 04             	sub    $0x4,%esp
  80407f:	68 4c 65 80 00       	push   $0x80654c
  804084:	68 2d 02 00 00       	push   $0x22d
  804089:	68 2c 64 80 00       	push   $0x80642c
  80408e:	e8 03 d5 ff ff       	call   801596 <_panic>

00804093 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  804093:	55                   	push   %ebp
  804094:	89 e5                	mov    %esp,%ebp
  804096:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  804099:	83 ec 04             	sub    $0x4,%esp
  80409c:	68 74 65 80 00       	push   $0x806574
  8040a1:	68 40 02 00 00       	push   $0x240
  8040a6:	68 2c 64 80 00       	push   $0x80642c
  8040ab:	e8 e6 d4 ff ff       	call   801596 <_panic>

008040b0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8040b0:	55                   	push   %ebp
  8040b1:	89 e5                	mov    %esp,%ebp
  8040b3:	57                   	push   %edi
  8040b4:	56                   	push   %esi
  8040b5:	53                   	push   %ebx
  8040b6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8040b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8040bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8040c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8040c5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8040c8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8040cb:	cd 30                	int    $0x30
  8040cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8040d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8040d3:	83 c4 10             	add    $0x10,%esp
  8040d6:	5b                   	pop    %ebx
  8040d7:	5e                   	pop    %esi
  8040d8:	5f                   	pop    %edi
  8040d9:	5d                   	pop    %ebp
  8040da:	c3                   	ret    

008040db <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8040db:	55                   	push   %ebp
  8040dc:	89 e5                	mov    %esp,%ebp
  8040de:	83 ec 04             	sub    $0x4,%esp
  8040e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8040e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8040e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8040ea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8040ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f1:	6a 00                	push   $0x0
  8040f3:	51                   	push   %ecx
  8040f4:	52                   	push   %edx
  8040f5:	ff 75 0c             	pushl  0xc(%ebp)
  8040f8:	50                   	push   %eax
  8040f9:	6a 00                	push   $0x0
  8040fb:	e8 b0 ff ff ff       	call   8040b0 <syscall>
  804100:	83 c4 18             	add    $0x18,%esp
}
  804103:	90                   	nop
  804104:	c9                   	leave  
  804105:	c3                   	ret    

00804106 <sys_cgetc>:

int
sys_cgetc(void)
{
  804106:	55                   	push   %ebp
  804107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  804109:	6a 00                	push   $0x0
  80410b:	6a 00                	push   $0x0
  80410d:	6a 00                	push   $0x0
  80410f:	6a 00                	push   $0x0
  804111:	6a 00                	push   $0x0
  804113:	6a 02                	push   $0x2
  804115:	e8 96 ff ff ff       	call   8040b0 <syscall>
  80411a:	83 c4 18             	add    $0x18,%esp
}
  80411d:	c9                   	leave  
  80411e:	c3                   	ret    

0080411f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80411f:	55                   	push   %ebp
  804120:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  804122:	6a 00                	push   $0x0
  804124:	6a 00                	push   $0x0
  804126:	6a 00                	push   $0x0
  804128:	6a 00                	push   $0x0
  80412a:	6a 00                	push   $0x0
  80412c:	6a 03                	push   $0x3
  80412e:	e8 7d ff ff ff       	call   8040b0 <syscall>
  804133:	83 c4 18             	add    $0x18,%esp
}
  804136:	90                   	nop
  804137:	c9                   	leave  
  804138:	c3                   	ret    

00804139 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  804139:	55                   	push   %ebp
  80413a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80413c:	6a 00                	push   $0x0
  80413e:	6a 00                	push   $0x0
  804140:	6a 00                	push   $0x0
  804142:	6a 00                	push   $0x0
  804144:	6a 00                	push   $0x0
  804146:	6a 04                	push   $0x4
  804148:	e8 63 ff ff ff       	call   8040b0 <syscall>
  80414d:	83 c4 18             	add    $0x18,%esp
}
  804150:	90                   	nop
  804151:	c9                   	leave  
  804152:	c3                   	ret    

00804153 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  804153:	55                   	push   %ebp
  804154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  804156:	8b 55 0c             	mov    0xc(%ebp),%edx
  804159:	8b 45 08             	mov    0x8(%ebp),%eax
  80415c:	6a 00                	push   $0x0
  80415e:	6a 00                	push   $0x0
  804160:	6a 00                	push   $0x0
  804162:	52                   	push   %edx
  804163:	50                   	push   %eax
  804164:	6a 08                	push   $0x8
  804166:	e8 45 ff ff ff       	call   8040b0 <syscall>
  80416b:	83 c4 18             	add    $0x18,%esp
}
  80416e:	c9                   	leave  
  80416f:	c3                   	ret    

00804170 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  804170:	55                   	push   %ebp
  804171:	89 e5                	mov    %esp,%ebp
  804173:	56                   	push   %esi
  804174:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  804175:	8b 75 18             	mov    0x18(%ebp),%esi
  804178:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80417b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80417e:	8b 55 0c             	mov    0xc(%ebp),%edx
  804181:	8b 45 08             	mov    0x8(%ebp),%eax
  804184:	56                   	push   %esi
  804185:	53                   	push   %ebx
  804186:	51                   	push   %ecx
  804187:	52                   	push   %edx
  804188:	50                   	push   %eax
  804189:	6a 09                	push   $0x9
  80418b:	e8 20 ff ff ff       	call   8040b0 <syscall>
  804190:	83 c4 18             	add    $0x18,%esp
}
  804193:	8d 65 f8             	lea    -0x8(%ebp),%esp
  804196:	5b                   	pop    %ebx
  804197:	5e                   	pop    %esi
  804198:	5d                   	pop    %ebp
  804199:	c3                   	ret    

0080419a <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80419a:	55                   	push   %ebp
  80419b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80419d:	6a 00                	push   $0x0
  80419f:	6a 00                	push   $0x0
  8041a1:	6a 00                	push   $0x0
  8041a3:	6a 00                	push   $0x0
  8041a5:	ff 75 08             	pushl  0x8(%ebp)
  8041a8:	6a 0a                	push   $0xa
  8041aa:	e8 01 ff ff ff       	call   8040b0 <syscall>
  8041af:	83 c4 18             	add    $0x18,%esp
}
  8041b2:	c9                   	leave  
  8041b3:	c3                   	ret    

008041b4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8041b4:	55                   	push   %ebp
  8041b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8041b7:	6a 00                	push   $0x0
  8041b9:	6a 00                	push   $0x0
  8041bb:	6a 00                	push   $0x0
  8041bd:	ff 75 0c             	pushl  0xc(%ebp)
  8041c0:	ff 75 08             	pushl  0x8(%ebp)
  8041c3:	6a 0b                	push   $0xb
  8041c5:	e8 e6 fe ff ff       	call   8040b0 <syscall>
  8041ca:	83 c4 18             	add    $0x18,%esp
}
  8041cd:	c9                   	leave  
  8041ce:	c3                   	ret    

008041cf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8041cf:	55                   	push   %ebp
  8041d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8041d2:	6a 00                	push   $0x0
  8041d4:	6a 00                	push   $0x0
  8041d6:	6a 00                	push   $0x0
  8041d8:	6a 00                	push   $0x0
  8041da:	6a 00                	push   $0x0
  8041dc:	6a 0c                	push   $0xc
  8041de:	e8 cd fe ff ff       	call   8040b0 <syscall>
  8041e3:	83 c4 18             	add    $0x18,%esp
}
  8041e6:	c9                   	leave  
  8041e7:	c3                   	ret    

008041e8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8041e8:	55                   	push   %ebp
  8041e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8041eb:	6a 00                	push   $0x0
  8041ed:	6a 00                	push   $0x0
  8041ef:	6a 00                	push   $0x0
  8041f1:	6a 00                	push   $0x0
  8041f3:	6a 00                	push   $0x0
  8041f5:	6a 0d                	push   $0xd
  8041f7:	e8 b4 fe ff ff       	call   8040b0 <syscall>
  8041fc:	83 c4 18             	add    $0x18,%esp
}
  8041ff:	c9                   	leave  
  804200:	c3                   	ret    

00804201 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  804201:	55                   	push   %ebp
  804202:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  804204:	6a 00                	push   $0x0
  804206:	6a 00                	push   $0x0
  804208:	6a 00                	push   $0x0
  80420a:	6a 00                	push   $0x0
  80420c:	6a 00                	push   $0x0
  80420e:	6a 0e                	push   $0xe
  804210:	e8 9b fe ff ff       	call   8040b0 <syscall>
  804215:	83 c4 18             	add    $0x18,%esp
}
  804218:	c9                   	leave  
  804219:	c3                   	ret    

0080421a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80421a:	55                   	push   %ebp
  80421b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80421d:	6a 00                	push   $0x0
  80421f:	6a 00                	push   $0x0
  804221:	6a 00                	push   $0x0
  804223:	6a 00                	push   $0x0
  804225:	6a 00                	push   $0x0
  804227:	6a 0f                	push   $0xf
  804229:	e8 82 fe ff ff       	call   8040b0 <syscall>
  80422e:	83 c4 18             	add    $0x18,%esp
}
  804231:	c9                   	leave  
  804232:	c3                   	ret    

00804233 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  804233:	55                   	push   %ebp
  804234:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  804236:	6a 00                	push   $0x0
  804238:	6a 00                	push   $0x0
  80423a:	6a 00                	push   $0x0
  80423c:	6a 00                	push   $0x0
  80423e:	ff 75 08             	pushl  0x8(%ebp)
  804241:	6a 10                	push   $0x10
  804243:	e8 68 fe ff ff       	call   8040b0 <syscall>
  804248:	83 c4 18             	add    $0x18,%esp
}
  80424b:	c9                   	leave  
  80424c:	c3                   	ret    

0080424d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80424d:	55                   	push   %ebp
  80424e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  804250:	6a 00                	push   $0x0
  804252:	6a 00                	push   $0x0
  804254:	6a 00                	push   $0x0
  804256:	6a 00                	push   $0x0
  804258:	6a 00                	push   $0x0
  80425a:	6a 11                	push   $0x11
  80425c:	e8 4f fe ff ff       	call   8040b0 <syscall>
  804261:	83 c4 18             	add    $0x18,%esp
}
  804264:	90                   	nop
  804265:	c9                   	leave  
  804266:	c3                   	ret    

00804267 <sys_cputc>:

void
sys_cputc(const char c)
{
  804267:	55                   	push   %ebp
  804268:	89 e5                	mov    %esp,%ebp
  80426a:	83 ec 04             	sub    $0x4,%esp
  80426d:	8b 45 08             	mov    0x8(%ebp),%eax
  804270:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  804273:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  804277:	6a 00                	push   $0x0
  804279:	6a 00                	push   $0x0
  80427b:	6a 00                	push   $0x0
  80427d:	6a 00                	push   $0x0
  80427f:	50                   	push   %eax
  804280:	6a 01                	push   $0x1
  804282:	e8 29 fe ff ff       	call   8040b0 <syscall>
  804287:	83 c4 18             	add    $0x18,%esp
}
  80428a:	90                   	nop
  80428b:	c9                   	leave  
  80428c:	c3                   	ret    

0080428d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80428d:	55                   	push   %ebp
  80428e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  804290:	6a 00                	push   $0x0
  804292:	6a 00                	push   $0x0
  804294:	6a 00                	push   $0x0
  804296:	6a 00                	push   $0x0
  804298:	6a 00                	push   $0x0
  80429a:	6a 14                	push   $0x14
  80429c:	e8 0f fe ff ff       	call   8040b0 <syscall>
  8042a1:	83 c4 18             	add    $0x18,%esp
}
  8042a4:	90                   	nop
  8042a5:	c9                   	leave  
  8042a6:	c3                   	ret    

008042a7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8042a7:	55                   	push   %ebp
  8042a8:	89 e5                	mov    %esp,%ebp
  8042aa:	83 ec 04             	sub    $0x4,%esp
  8042ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8042b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8042b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8042b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8042ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8042bd:	6a 00                	push   $0x0
  8042bf:	51                   	push   %ecx
  8042c0:	52                   	push   %edx
  8042c1:	ff 75 0c             	pushl  0xc(%ebp)
  8042c4:	50                   	push   %eax
  8042c5:	6a 15                	push   $0x15
  8042c7:	e8 e4 fd ff ff       	call   8040b0 <syscall>
  8042cc:	83 c4 18             	add    $0x18,%esp
}
  8042cf:	c9                   	leave  
  8042d0:	c3                   	ret    

008042d1 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8042d1:	55                   	push   %ebp
  8042d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8042d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042da:	6a 00                	push   $0x0
  8042dc:	6a 00                	push   $0x0
  8042de:	6a 00                	push   $0x0
  8042e0:	52                   	push   %edx
  8042e1:	50                   	push   %eax
  8042e2:	6a 16                	push   $0x16
  8042e4:	e8 c7 fd ff ff       	call   8040b0 <syscall>
  8042e9:	83 c4 18             	add    $0x18,%esp
}
  8042ec:	c9                   	leave  
  8042ed:	c3                   	ret    

008042ee <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8042ee:	55                   	push   %ebp
  8042ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8042f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8042f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042fa:	6a 00                	push   $0x0
  8042fc:	6a 00                	push   $0x0
  8042fe:	51                   	push   %ecx
  8042ff:	52                   	push   %edx
  804300:	50                   	push   %eax
  804301:	6a 17                	push   $0x17
  804303:	e8 a8 fd ff ff       	call   8040b0 <syscall>
  804308:	83 c4 18             	add    $0x18,%esp
}
  80430b:	c9                   	leave  
  80430c:	c3                   	ret    

0080430d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80430d:	55                   	push   %ebp
  80430e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  804310:	8b 55 0c             	mov    0xc(%ebp),%edx
  804313:	8b 45 08             	mov    0x8(%ebp),%eax
  804316:	6a 00                	push   $0x0
  804318:	6a 00                	push   $0x0
  80431a:	6a 00                	push   $0x0
  80431c:	52                   	push   %edx
  80431d:	50                   	push   %eax
  80431e:	6a 18                	push   $0x18
  804320:	e8 8b fd ff ff       	call   8040b0 <syscall>
  804325:	83 c4 18             	add    $0x18,%esp
}
  804328:	c9                   	leave  
  804329:	c3                   	ret    

0080432a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80432a:	55                   	push   %ebp
  80432b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80432d:	8b 45 08             	mov    0x8(%ebp),%eax
  804330:	6a 00                	push   $0x0
  804332:	ff 75 14             	pushl  0x14(%ebp)
  804335:	ff 75 10             	pushl  0x10(%ebp)
  804338:	ff 75 0c             	pushl  0xc(%ebp)
  80433b:	50                   	push   %eax
  80433c:	6a 19                	push   $0x19
  80433e:	e8 6d fd ff ff       	call   8040b0 <syscall>
  804343:	83 c4 18             	add    $0x18,%esp
}
  804346:	c9                   	leave  
  804347:	c3                   	ret    

00804348 <sys_run_env>:

void sys_run_env(int32 envId)
{
  804348:	55                   	push   %ebp
  804349:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80434b:	8b 45 08             	mov    0x8(%ebp),%eax
  80434e:	6a 00                	push   $0x0
  804350:	6a 00                	push   $0x0
  804352:	6a 00                	push   $0x0
  804354:	6a 00                	push   $0x0
  804356:	50                   	push   %eax
  804357:	6a 1a                	push   $0x1a
  804359:	e8 52 fd ff ff       	call   8040b0 <syscall>
  80435e:	83 c4 18             	add    $0x18,%esp
}
  804361:	90                   	nop
  804362:	c9                   	leave  
  804363:	c3                   	ret    

00804364 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  804364:	55                   	push   %ebp
  804365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  804367:	8b 45 08             	mov    0x8(%ebp),%eax
  80436a:	6a 00                	push   $0x0
  80436c:	6a 00                	push   $0x0
  80436e:	6a 00                	push   $0x0
  804370:	6a 00                	push   $0x0
  804372:	50                   	push   %eax
  804373:	6a 1b                	push   $0x1b
  804375:	e8 36 fd ff ff       	call   8040b0 <syscall>
  80437a:	83 c4 18             	add    $0x18,%esp
}
  80437d:	c9                   	leave  
  80437e:	c3                   	ret    

0080437f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80437f:	55                   	push   %ebp
  804380:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  804382:	6a 00                	push   $0x0
  804384:	6a 00                	push   $0x0
  804386:	6a 00                	push   $0x0
  804388:	6a 00                	push   $0x0
  80438a:	6a 00                	push   $0x0
  80438c:	6a 05                	push   $0x5
  80438e:	e8 1d fd ff ff       	call   8040b0 <syscall>
  804393:	83 c4 18             	add    $0x18,%esp
}
  804396:	c9                   	leave  
  804397:	c3                   	ret    

00804398 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  804398:	55                   	push   %ebp
  804399:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80439b:	6a 00                	push   $0x0
  80439d:	6a 00                	push   $0x0
  80439f:	6a 00                	push   $0x0
  8043a1:	6a 00                	push   $0x0
  8043a3:	6a 00                	push   $0x0
  8043a5:	6a 06                	push   $0x6
  8043a7:	e8 04 fd ff ff       	call   8040b0 <syscall>
  8043ac:	83 c4 18             	add    $0x18,%esp
}
  8043af:	c9                   	leave  
  8043b0:	c3                   	ret    

008043b1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8043b1:	55                   	push   %ebp
  8043b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8043b4:	6a 00                	push   $0x0
  8043b6:	6a 00                	push   $0x0
  8043b8:	6a 00                	push   $0x0
  8043ba:	6a 00                	push   $0x0
  8043bc:	6a 00                	push   $0x0
  8043be:	6a 07                	push   $0x7
  8043c0:	e8 eb fc ff ff       	call   8040b0 <syscall>
  8043c5:	83 c4 18             	add    $0x18,%esp
}
  8043c8:	c9                   	leave  
  8043c9:	c3                   	ret    

008043ca <sys_exit_env>:


void sys_exit_env(void)
{
  8043ca:	55                   	push   %ebp
  8043cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8043cd:	6a 00                	push   $0x0
  8043cf:	6a 00                	push   $0x0
  8043d1:	6a 00                	push   $0x0
  8043d3:	6a 00                	push   $0x0
  8043d5:	6a 00                	push   $0x0
  8043d7:	6a 1c                	push   $0x1c
  8043d9:	e8 d2 fc ff ff       	call   8040b0 <syscall>
  8043de:	83 c4 18             	add    $0x18,%esp
}
  8043e1:	90                   	nop
  8043e2:	c9                   	leave  
  8043e3:	c3                   	ret    

008043e4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8043e4:	55                   	push   %ebp
  8043e5:	89 e5                	mov    %esp,%ebp
  8043e7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8043ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8043ed:	8d 50 04             	lea    0x4(%eax),%edx
  8043f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8043f3:	6a 00                	push   $0x0
  8043f5:	6a 00                	push   $0x0
  8043f7:	6a 00                	push   $0x0
  8043f9:	52                   	push   %edx
  8043fa:	50                   	push   %eax
  8043fb:	6a 1d                	push   $0x1d
  8043fd:	e8 ae fc ff ff       	call   8040b0 <syscall>
  804402:	83 c4 18             	add    $0x18,%esp
	return result;
  804405:	8b 4d 08             	mov    0x8(%ebp),%ecx
  804408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80440b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80440e:	89 01                	mov    %eax,(%ecx)
  804410:	89 51 04             	mov    %edx,0x4(%ecx)
}
  804413:	8b 45 08             	mov    0x8(%ebp),%eax
  804416:	c9                   	leave  
  804417:	c2 04 00             	ret    $0x4

0080441a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80441a:	55                   	push   %ebp
  80441b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80441d:	6a 00                	push   $0x0
  80441f:	6a 00                	push   $0x0
  804421:	ff 75 10             	pushl  0x10(%ebp)
  804424:	ff 75 0c             	pushl  0xc(%ebp)
  804427:	ff 75 08             	pushl  0x8(%ebp)
  80442a:	6a 13                	push   $0x13
  80442c:	e8 7f fc ff ff       	call   8040b0 <syscall>
  804431:	83 c4 18             	add    $0x18,%esp
	return ;
  804434:	90                   	nop
}
  804435:	c9                   	leave  
  804436:	c3                   	ret    

00804437 <sys_rcr2>:
uint32 sys_rcr2()
{
  804437:	55                   	push   %ebp
  804438:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80443a:	6a 00                	push   $0x0
  80443c:	6a 00                	push   $0x0
  80443e:	6a 00                	push   $0x0
  804440:	6a 00                	push   $0x0
  804442:	6a 00                	push   $0x0
  804444:	6a 1e                	push   $0x1e
  804446:	e8 65 fc ff ff       	call   8040b0 <syscall>
  80444b:	83 c4 18             	add    $0x18,%esp
}
  80444e:	c9                   	leave  
  80444f:	c3                   	ret    

00804450 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  804450:	55                   	push   %ebp
  804451:	89 e5                	mov    %esp,%ebp
  804453:	83 ec 04             	sub    $0x4,%esp
  804456:	8b 45 08             	mov    0x8(%ebp),%eax
  804459:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80445c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  804460:	6a 00                	push   $0x0
  804462:	6a 00                	push   $0x0
  804464:	6a 00                	push   $0x0
  804466:	6a 00                	push   $0x0
  804468:	50                   	push   %eax
  804469:	6a 1f                	push   $0x1f
  80446b:	e8 40 fc ff ff       	call   8040b0 <syscall>
  804470:	83 c4 18             	add    $0x18,%esp
	return ;
  804473:	90                   	nop
}
  804474:	c9                   	leave  
  804475:	c3                   	ret    

00804476 <rsttst>:
void rsttst()
{
  804476:	55                   	push   %ebp
  804477:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  804479:	6a 00                	push   $0x0
  80447b:	6a 00                	push   $0x0
  80447d:	6a 00                	push   $0x0
  80447f:	6a 00                	push   $0x0
  804481:	6a 00                	push   $0x0
  804483:	6a 21                	push   $0x21
  804485:	e8 26 fc ff ff       	call   8040b0 <syscall>
  80448a:	83 c4 18             	add    $0x18,%esp
	return ;
  80448d:	90                   	nop
}
  80448e:	c9                   	leave  
  80448f:	c3                   	ret    

00804490 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  804490:	55                   	push   %ebp
  804491:	89 e5                	mov    %esp,%ebp
  804493:	83 ec 04             	sub    $0x4,%esp
  804496:	8b 45 14             	mov    0x14(%ebp),%eax
  804499:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80449c:	8b 55 18             	mov    0x18(%ebp),%edx
  80449f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8044a3:	52                   	push   %edx
  8044a4:	50                   	push   %eax
  8044a5:	ff 75 10             	pushl  0x10(%ebp)
  8044a8:	ff 75 0c             	pushl  0xc(%ebp)
  8044ab:	ff 75 08             	pushl  0x8(%ebp)
  8044ae:	6a 20                	push   $0x20
  8044b0:	e8 fb fb ff ff       	call   8040b0 <syscall>
  8044b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8044b8:	90                   	nop
}
  8044b9:	c9                   	leave  
  8044ba:	c3                   	ret    

008044bb <chktst>:
void chktst(uint32 n)
{
  8044bb:	55                   	push   %ebp
  8044bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8044be:	6a 00                	push   $0x0
  8044c0:	6a 00                	push   $0x0
  8044c2:	6a 00                	push   $0x0
  8044c4:	6a 00                	push   $0x0
  8044c6:	ff 75 08             	pushl  0x8(%ebp)
  8044c9:	6a 22                	push   $0x22
  8044cb:	e8 e0 fb ff ff       	call   8040b0 <syscall>
  8044d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8044d3:	90                   	nop
}
  8044d4:	c9                   	leave  
  8044d5:	c3                   	ret    

008044d6 <inctst>:

void inctst()
{
  8044d6:	55                   	push   %ebp
  8044d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8044d9:	6a 00                	push   $0x0
  8044db:	6a 00                	push   $0x0
  8044dd:	6a 00                	push   $0x0
  8044df:	6a 00                	push   $0x0
  8044e1:	6a 00                	push   $0x0
  8044e3:	6a 23                	push   $0x23
  8044e5:	e8 c6 fb ff ff       	call   8040b0 <syscall>
  8044ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8044ed:	90                   	nop
}
  8044ee:	c9                   	leave  
  8044ef:	c3                   	ret    

008044f0 <gettst>:
uint32 gettst()
{
  8044f0:	55                   	push   %ebp
  8044f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8044f3:	6a 00                	push   $0x0
  8044f5:	6a 00                	push   $0x0
  8044f7:	6a 00                	push   $0x0
  8044f9:	6a 00                	push   $0x0
  8044fb:	6a 00                	push   $0x0
  8044fd:	6a 24                	push   $0x24
  8044ff:	e8 ac fb ff ff       	call   8040b0 <syscall>
  804504:	83 c4 18             	add    $0x18,%esp
}
  804507:	c9                   	leave  
  804508:	c3                   	ret    

00804509 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  804509:	55                   	push   %ebp
  80450a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80450c:	6a 00                	push   $0x0
  80450e:	6a 00                	push   $0x0
  804510:	6a 00                	push   $0x0
  804512:	6a 00                	push   $0x0
  804514:	6a 00                	push   $0x0
  804516:	6a 25                	push   $0x25
  804518:	e8 93 fb ff ff       	call   8040b0 <syscall>
  80451d:	83 c4 18             	add    $0x18,%esp
  804520:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  804525:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  80452a:	c9                   	leave  
  80452b:	c3                   	ret    

0080452c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80452c:	55                   	push   %ebp
  80452d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80452f:	8b 45 08             	mov    0x8(%ebp),%eax
  804532:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  804537:	6a 00                	push   $0x0
  804539:	6a 00                	push   $0x0
  80453b:	6a 00                	push   $0x0
  80453d:	6a 00                	push   $0x0
  80453f:	ff 75 08             	pushl  0x8(%ebp)
  804542:	6a 26                	push   $0x26
  804544:	e8 67 fb ff ff       	call   8040b0 <syscall>
  804549:	83 c4 18             	add    $0x18,%esp
	return ;
  80454c:	90                   	nop
}
  80454d:	c9                   	leave  
  80454e:	c3                   	ret    

0080454f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80454f:	55                   	push   %ebp
  804550:	89 e5                	mov    %esp,%ebp
  804552:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  804553:	8b 5d 14             	mov    0x14(%ebp),%ebx
  804556:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804559:	8b 55 0c             	mov    0xc(%ebp),%edx
  80455c:	8b 45 08             	mov    0x8(%ebp),%eax
  80455f:	6a 00                	push   $0x0
  804561:	53                   	push   %ebx
  804562:	51                   	push   %ecx
  804563:	52                   	push   %edx
  804564:	50                   	push   %eax
  804565:	6a 27                	push   $0x27
  804567:	e8 44 fb ff ff       	call   8040b0 <syscall>
  80456c:	83 c4 18             	add    $0x18,%esp
}
  80456f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  804572:	c9                   	leave  
  804573:	c3                   	ret    

00804574 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  804574:	55                   	push   %ebp
  804575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  804577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80457a:	8b 45 08             	mov    0x8(%ebp),%eax
  80457d:	6a 00                	push   $0x0
  80457f:	6a 00                	push   $0x0
  804581:	6a 00                	push   $0x0
  804583:	52                   	push   %edx
  804584:	50                   	push   %eax
  804585:	6a 28                	push   $0x28
  804587:	e8 24 fb ff ff       	call   8040b0 <syscall>
  80458c:	83 c4 18             	add    $0x18,%esp
}
  80458f:	c9                   	leave  
  804590:	c3                   	ret    

00804591 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  804591:	55                   	push   %ebp
  804592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  804594:	8b 4d 14             	mov    0x14(%ebp),%ecx
  804597:	8b 55 0c             	mov    0xc(%ebp),%edx
  80459a:	8b 45 08             	mov    0x8(%ebp),%eax
  80459d:	6a 00                	push   $0x0
  80459f:	51                   	push   %ecx
  8045a0:	ff 75 10             	pushl  0x10(%ebp)
  8045a3:	52                   	push   %edx
  8045a4:	50                   	push   %eax
  8045a5:	6a 29                	push   $0x29
  8045a7:	e8 04 fb ff ff       	call   8040b0 <syscall>
  8045ac:	83 c4 18             	add    $0x18,%esp
}
  8045af:	c9                   	leave  
  8045b0:	c3                   	ret    

008045b1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8045b1:	55                   	push   %ebp
  8045b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8045b4:	6a 00                	push   $0x0
  8045b6:	6a 00                	push   $0x0
  8045b8:	ff 75 10             	pushl  0x10(%ebp)
  8045bb:	ff 75 0c             	pushl  0xc(%ebp)
  8045be:	ff 75 08             	pushl  0x8(%ebp)
  8045c1:	6a 12                	push   $0x12
  8045c3:	e8 e8 fa ff ff       	call   8040b0 <syscall>
  8045c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8045cb:	90                   	nop
}
  8045cc:	c9                   	leave  
  8045cd:	c3                   	ret    

008045ce <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8045ce:	55                   	push   %ebp
  8045cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8045d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8045d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8045d7:	6a 00                	push   $0x0
  8045d9:	6a 00                	push   $0x0
  8045db:	6a 00                	push   $0x0
  8045dd:	52                   	push   %edx
  8045de:	50                   	push   %eax
  8045df:	6a 2a                	push   $0x2a
  8045e1:	e8 ca fa ff ff       	call   8040b0 <syscall>
  8045e6:	83 c4 18             	add    $0x18,%esp
	return;
  8045e9:	90                   	nop
}
  8045ea:	c9                   	leave  
  8045eb:	c3                   	ret    

008045ec <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8045ec:	55                   	push   %ebp
  8045ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8045ef:	6a 00                	push   $0x0
  8045f1:	6a 00                	push   $0x0
  8045f3:	6a 00                	push   $0x0
  8045f5:	6a 00                	push   $0x0
  8045f7:	6a 00                	push   $0x0
  8045f9:	6a 2b                	push   $0x2b
  8045fb:	e8 b0 fa ff ff       	call   8040b0 <syscall>
  804600:	83 c4 18             	add    $0x18,%esp
}
  804603:	c9                   	leave  
  804604:	c3                   	ret    

00804605 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  804605:	55                   	push   %ebp
  804606:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  804608:	6a 00                	push   $0x0
  80460a:	6a 00                	push   $0x0
  80460c:	6a 00                	push   $0x0
  80460e:	ff 75 0c             	pushl  0xc(%ebp)
  804611:	ff 75 08             	pushl  0x8(%ebp)
  804614:	6a 2d                	push   $0x2d
  804616:	e8 95 fa ff ff       	call   8040b0 <syscall>
  80461b:	83 c4 18             	add    $0x18,%esp
	return;
  80461e:	90                   	nop
}
  80461f:	c9                   	leave  
  804620:	c3                   	ret    

00804621 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  804621:	55                   	push   %ebp
  804622:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  804624:	6a 00                	push   $0x0
  804626:	6a 00                	push   $0x0
  804628:	6a 00                	push   $0x0
  80462a:	ff 75 0c             	pushl  0xc(%ebp)
  80462d:	ff 75 08             	pushl  0x8(%ebp)
  804630:	6a 2c                	push   $0x2c
  804632:	e8 79 fa ff ff       	call   8040b0 <syscall>
  804637:	83 c4 18             	add    $0x18,%esp
	return ;
  80463a:	90                   	nop
}
  80463b:	c9                   	leave  
  80463c:	c3                   	ret    

0080463d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80463d:	55                   	push   %ebp
  80463e:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  804640:	8b 55 0c             	mov    0xc(%ebp),%edx
  804643:	8b 45 08             	mov    0x8(%ebp),%eax
  804646:	6a 00                	push   $0x0
  804648:	6a 00                	push   $0x0
  80464a:	6a 00                	push   $0x0
  80464c:	52                   	push   %edx
  80464d:	50                   	push   %eax
  80464e:	6a 2e                	push   $0x2e
  804650:	e8 5b fa ff ff       	call   8040b0 <syscall>
  804655:	83 c4 18             	add    $0x18,%esp
	    return;
  804658:	90                   	nop
}
  804659:	c9                   	leave  
  80465a:	c3                   	ret    

0080465b <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80465b:	55                   	push   %ebp
  80465c:	89 e5                	mov    %esp,%ebp
  80465e:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  804661:	8b 45 08             	mov    0x8(%ebp),%eax
  804664:	ba 40 72 80 00       	mov    $0x807240,%edx
  804669:	29 d0                	sub    %edx,%eax
  80466b:	c1 f8 02             	sar    $0x2,%eax
  80466e:	89 c2                	mov    %eax,%edx
  804670:	89 d0                	mov    %edx,%eax
  804672:	c1 e0 02             	shl    $0x2,%eax
  804675:	01 d0                	add    %edx,%eax
  804677:	c1 e0 02             	shl    $0x2,%eax
  80467a:	01 d0                	add    %edx,%eax
  80467c:	c1 e0 02             	shl    $0x2,%eax
  80467f:	01 d0                	add    %edx,%eax
  804681:	89 c1                	mov    %eax,%ecx
  804683:	c1 e1 08             	shl    $0x8,%ecx
  804686:	01 c8                	add    %ecx,%eax
  804688:	89 c1                	mov    %eax,%ecx
  80468a:	c1 e1 10             	shl    $0x10,%ecx
  80468d:	01 c8                	add    %ecx,%eax
  80468f:	01 c0                	add    %eax,%eax
  804691:	01 d0                	add    %edx,%eax
  804693:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  804696:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804699:	c1 e0 0c             	shl    $0xc,%eax
  80469c:	89 c2                	mov    %eax,%edx
  80469e:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8046a3:	01 d0                	add    %edx,%eax
}
  8046a5:	c9                   	leave  
  8046a6:	c3                   	ret    

008046a7 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  8046a7:	55                   	push   %ebp
  8046a8:	89 e5                	mov    %esp,%ebp
  8046aa:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  8046ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8046b4:	eb 06                	jmp    8046bc <log2+0x15>
			n >>=1;
  8046b6:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  8046b9:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  8046bc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8046c0:	77 f4                	ja     8046b6 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  8046c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8046c5:	c9                   	leave  
  8046c6:	c3                   	ret    

008046c7 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8046c7:	55                   	push   %ebp
  8046c8:	89 e5                	mov    %esp,%ebp
  8046ca:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8046cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8046d0:	05 00 00 00 02       	add    $0x2000000,%eax
  8046d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8046d8:	73 16                	jae    8046f0 <initialize_dynamic_allocator+0x29>
  8046da:	68 98 65 80 00       	push   $0x806598
  8046df:	68 be 65 80 00       	push   $0x8065be
  8046e4:	6a 2d                	push   $0x2d
  8046e6:	68 d3 65 80 00       	push   $0x8065d3
  8046eb:	e8 a6 ce ff ff       	call   801596 <_panic>
		is_initialized = 1;
  8046f0:	c7 05 04 72 80 00 01 	movl   $0x1,0x807204
  8046f7:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  8046fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8046fd:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd= daEnd;
  804702:	8b 45 0c             	mov    0xc(%ebp),%eax
  804705:	a3 20 72 80 00       	mov    %eax,0x807220
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  80470a:	8b 15 20 72 80 00    	mov    0x807220,%edx
  804710:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804715:	29 c2                	sub    %eax,%edx
  804717:	89 d0                	mov    %edx,%eax
  804719:	c1 e8 0c             	shr    $0xc,%eax
  80471c:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  80471f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804726:	eb 2f                	jmp    804757 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  804728:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80472b:	89 d0                	mov    %edx,%eax
  80472d:	01 c0                	add    %eax,%eax
  80472f:	01 d0                	add    %edx,%eax
  804731:	c1 e0 02             	shl    $0x2,%eax
  804734:	05 48 72 80 00       	add    $0x807248,%eax
  804739:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  80473e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804741:	89 d0                	mov    %edx,%eax
  804743:	01 c0                	add    %eax,%eax
  804745:	01 d0                	add    %edx,%eax
  804747:	c1 e0 02             	shl    $0x2,%eax
  80474a:	05 4a 72 80 00       	add    $0x80724a,%eax
  80474f:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  804754:	ff 45 f4             	incl   -0xc(%ebp)
  804757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80475a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80475d:	7c c9                	jl     804728 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  80475f:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  804766:	00 00 00 
  804769:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  804770:	00 00 00 
  804773:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  80477a:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  80477d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804784:	e9 9c 00 00 00       	jmp    804825 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  804789:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  80478f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804792:	89 c8                	mov    %ecx,%eax
  804794:	01 c0                	add    %eax,%eax
  804796:	01 c8                	add    %ecx,%eax
  804798:	c1 e0 02             	shl    $0x2,%eax
  80479b:	05 44 72 80 00       	add    $0x807244,%eax
  8047a0:	89 10                	mov    %edx,(%eax)
  8047a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8047a5:	89 d0                	mov    %edx,%eax
  8047a7:	01 c0                	add    %eax,%eax
  8047a9:	01 d0                	add    %edx,%eax
  8047ab:	c1 e0 02             	shl    $0x2,%eax
  8047ae:	05 44 72 80 00       	add    $0x807244,%eax
  8047b3:	8b 00                	mov    (%eax),%eax
  8047b5:	85 c0                	test   %eax,%eax
  8047b7:	74 1b                	je     8047d4 <initialize_dynamic_allocator+0x10d>
  8047b9:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  8047bf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8047c2:	89 c8                	mov    %ecx,%eax
  8047c4:	01 c0                	add    %eax,%eax
  8047c6:	01 c8                	add    %ecx,%eax
  8047c8:	c1 e0 02             	shl    $0x2,%eax
  8047cb:	05 40 72 80 00       	add    $0x807240,%eax
  8047d0:	89 02                	mov    %eax,(%edx)
  8047d2:	eb 16                	jmp    8047ea <initialize_dynamic_allocator+0x123>
  8047d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8047d7:	89 d0                	mov    %edx,%eax
  8047d9:	01 c0                	add    %eax,%eax
  8047db:	01 d0                	add    %edx,%eax
  8047dd:	c1 e0 02             	shl    $0x2,%eax
  8047e0:	05 40 72 80 00       	add    $0x807240,%eax
  8047e5:	a3 28 72 80 00       	mov    %eax,0x807228
  8047ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8047ed:	89 d0                	mov    %edx,%eax
  8047ef:	01 c0                	add    %eax,%eax
  8047f1:	01 d0                	add    %edx,%eax
  8047f3:	c1 e0 02             	shl    $0x2,%eax
  8047f6:	05 40 72 80 00       	add    $0x807240,%eax
  8047fb:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804800:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804803:	89 d0                	mov    %edx,%eax
  804805:	01 c0                	add    %eax,%eax
  804807:	01 d0                	add    %edx,%eax
  804809:	c1 e0 02             	shl    $0x2,%eax
  80480c:	05 40 72 80 00       	add    $0x807240,%eax
  804811:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804817:	a1 34 72 80 00       	mov    0x807234,%eax
  80481c:	40                   	inc    %eax
  80481d:	a3 34 72 80 00       	mov    %eax,0x807234
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  804822:	ff 45 f0             	incl   -0x10(%ebp)
  804825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804828:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80482b:	0f 8c 58 ff ff ff    	jl     804789 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  804831:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  804838:	eb 36                	jmp    804870 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  80483a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80483d:	c1 e0 04             	shl    $0x4,%eax
  804840:	05 60 f2 81 00       	add    $0x81f260,%eax
  804845:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80484b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80484e:	c1 e0 04             	shl    $0x4,%eax
  804851:	05 64 f2 81 00       	add    $0x81f264,%eax
  804856:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80485c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80485f:	c1 e0 04             	shl    $0x4,%eax
  804862:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804867:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80486d:	ff 45 ec             	incl   -0x14(%ebp)
  804870:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804874:	7e c4                	jle    80483a <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  804876:	90                   	nop
  804877:	c9                   	leave  
  804878:	c3                   	ret    

00804879 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  804879:	55                   	push   %ebp
  80487a:	89 e5                	mov    %esp,%ebp
  80487c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  80487f:	8b 55 08             	mov    0x8(%ebp),%edx
  804882:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804887:	29 c2                	sub    %eax,%edx
  804889:	89 d0                	mov    %edx,%eax
  80488b:	c1 e8 0c             	shr    $0xc,%eax
  80488e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  804891:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804894:	89 d0                	mov    %edx,%eax
  804896:	01 c0                	add    %eax,%eax
  804898:	01 d0                	add    %edx,%eax
  80489a:	c1 e0 02             	shl    $0x2,%eax
  80489d:	05 48 72 80 00       	add    $0x807248,%eax
  8048a2:	8b 00                	mov    (%eax),%eax
  8048a4:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8048a7:	c9                   	leave  
  8048a8:	c3                   	ret    

008048a9 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8048a9:	55                   	push   %ebp
  8048aa:	89 e5                	mov    %esp,%ebp
  8048ac:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8048af:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8048b6:	76 16                	jbe    8048ce <alloc_block+0x25>
  8048b8:	68 ec 65 80 00       	push   $0x8065ec
  8048bd:	68 be 65 80 00       	push   $0x8065be
  8048c2:	6a 6c                	push   $0x6c
  8048c4:	68 d3 65 80 00       	push   $0x8065d3
  8048c9:	e8 c8 cc ff ff       	call   801596 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  8048ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8048d2:	75 0a                	jne    8048de <alloc_block+0x35>
		return NULL;
  8048d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8048d9:	e9 65 04 00 00       	jmp    804d43 <alloc_block+0x49a>
	}
	else if(size<=8){
  8048de:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  8048e2:	77 09                	ja     8048ed <alloc_block+0x44>
		size=8;
  8048e4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  8048eb:	eb 1f                	jmp    80490c <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  8048ed:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  8048f4:	eb 08                	jmp    8048fe <alloc_block+0x55>
			reqsize*=2;
  8048f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048f9:	01 c0                	add    %eax,%eax
  8048fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  8048fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804901:	3b 45 08             	cmp    0x8(%ebp),%eax
  804904:	72 f0                	jb     8048f6 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  804906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804909:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  80490c:	83 ec 0c             	sub    $0xc,%esp
  80490f:	ff 75 08             	pushl  0x8(%ebp)
  804912:	e8 90 fd ff ff       	call   8046a7 <log2>
  804917:	83 c4 10             	add    $0x10,%esp
  80491a:	83 e8 03             	sub    $0x3,%eax
  80491d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  804920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804923:	c1 e0 04             	shl    $0x4,%eax
  804926:	05 60 f2 81 00       	add    $0x81f260,%eax
  80492b:	8b 00                	mov    (%eax),%eax
  80492d:	85 c0                	test   %eax,%eax
  80492f:	0f 84 fb 00 00 00    	je     804a30 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  804935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804938:	c1 e0 04             	shl    $0x4,%eax
  80493b:	05 60 f2 81 00       	add    $0x81f260,%eax
  804940:	8b 00                	mov    (%eax),%eax
  804942:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  804945:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804949:	75 17                	jne    804962 <alloc_block+0xb9>
  80494b:	83 ec 04             	sub    $0x4,%esp
  80494e:	68 0d 66 80 00       	push   $0x80660d
  804953:	68 86 00 00 00       	push   $0x86
  804958:	68 d3 65 80 00       	push   $0x8065d3
  80495d:	e8 34 cc ff ff       	call   801596 <_panic>
  804962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804965:	8b 00                	mov    (%eax),%eax
  804967:	85 c0                	test   %eax,%eax
  804969:	74 10                	je     80497b <alloc_block+0xd2>
  80496b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80496e:	8b 00                	mov    (%eax),%eax
  804970:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804973:	8b 52 04             	mov    0x4(%edx),%edx
  804976:	89 50 04             	mov    %edx,0x4(%eax)
  804979:	eb 14                	jmp    80498f <alloc_block+0xe6>
  80497b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80497e:	8b 40 04             	mov    0x4(%eax),%eax
  804981:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804984:	c1 e2 04             	shl    $0x4,%edx
  804987:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  80498d:	89 02                	mov    %eax,(%edx)
  80498f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804992:	8b 40 04             	mov    0x4(%eax),%eax
  804995:	85 c0                	test   %eax,%eax
  804997:	74 0f                	je     8049a8 <alloc_block+0xff>
  804999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80499c:	8b 40 04             	mov    0x4(%eax),%eax
  80499f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049a2:	8b 12                	mov    (%edx),%edx
  8049a4:	89 10                	mov    %edx,(%eax)
  8049a6:	eb 13                	jmp    8049bb <alloc_block+0x112>
  8049a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049ab:	8b 00                	mov    (%eax),%eax
  8049ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8049b0:	c1 e2 04             	shl    $0x4,%edx
  8049b3:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  8049b9:	89 02                	mov    %eax,(%edx)
  8049bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8049c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8049ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049d1:	c1 e0 04             	shl    $0x4,%eax
  8049d4:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8049d9:	8b 00                	mov    (%eax),%eax
  8049db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8049de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049e1:	c1 e0 04             	shl    $0x4,%eax
  8049e4:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8049e9:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  8049eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049ee:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8049f3:	29 c2                	sub    %eax,%edx
  8049f5:	89 d0                	mov    %edx,%eax
  8049f7:	c1 e8 0c             	shr    $0xc,%eax
  8049fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  8049fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804a00:	89 d0                	mov    %edx,%eax
  804a02:	01 c0                	add    %eax,%eax
  804a04:	01 d0                	add    %edx,%eax
  804a06:	c1 e0 02             	shl    $0x2,%eax
  804a09:	05 4a 72 80 00       	add    $0x80724a,%eax
  804a0e:	66 8b 00             	mov    (%eax),%ax
  804a11:	8d 50 ff             	lea    -0x1(%eax),%edx
  804a14:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  804a17:	89 c8                	mov    %ecx,%eax
  804a19:	01 c0                	add    %eax,%eax
  804a1b:	01 c8                	add    %ecx,%eax
  804a1d:	c1 e0 02             	shl    $0x2,%eax
  804a20:	05 4a 72 80 00       	add    $0x80724a,%eax
  804a25:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  804a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a2b:	e9 13 03 00 00       	jmp    804d43 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  804a30:	a1 28 72 80 00       	mov    0x807228,%eax
  804a35:	85 c0                	test   %eax,%eax
  804a37:	0f 84 c9 01 00 00    	je     804c06 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  804a3d:	a1 28 72 80 00       	mov    0x807228,%eax
  804a42:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  804a45:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804a49:	75 17                	jne    804a62 <alloc_block+0x1b9>
  804a4b:	83 ec 04             	sub    $0x4,%esp
  804a4e:	68 0d 66 80 00       	push   $0x80660d
  804a53:	68 8f 00 00 00       	push   $0x8f
  804a58:	68 d3 65 80 00       	push   $0x8065d3
  804a5d:	e8 34 cb ff ff       	call   801596 <_panic>
  804a62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a65:	8b 00                	mov    (%eax),%eax
  804a67:	85 c0                	test   %eax,%eax
  804a69:	74 10                	je     804a7b <alloc_block+0x1d2>
  804a6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a6e:	8b 00                	mov    (%eax),%eax
  804a70:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804a73:	8b 52 04             	mov    0x4(%edx),%edx
  804a76:	89 50 04             	mov    %edx,0x4(%eax)
  804a79:	eb 0b                	jmp    804a86 <alloc_block+0x1dd>
  804a7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a7e:	8b 40 04             	mov    0x4(%eax),%eax
  804a81:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804a86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a89:	8b 40 04             	mov    0x4(%eax),%eax
  804a8c:	85 c0                	test   %eax,%eax
  804a8e:	74 0f                	je     804a9f <alloc_block+0x1f6>
  804a90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a93:	8b 40 04             	mov    0x4(%eax),%eax
  804a96:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804a99:	8b 12                	mov    (%edx),%edx
  804a9b:	89 10                	mov    %edx,(%eax)
  804a9d:	eb 0a                	jmp    804aa9 <alloc_block+0x200>
  804a9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804aa2:	8b 00                	mov    (%eax),%eax
  804aa4:	a3 28 72 80 00       	mov    %eax,0x807228
  804aa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804aac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804ab2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804ab5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804abc:	a1 34 72 80 00       	mov    0x807234,%eax
  804ac1:	48                   	dec    %eax
  804ac2:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  804ac7:	83 ec 0c             	sub    $0xc,%esp
  804aca:	ff 75 dc             	pushl  -0x24(%ebp)
  804acd:	e8 89 fb ff ff       	call   80465b <to_page_va>
  804ad2:	83 c4 10             	add    $0x10,%esp
  804ad5:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  804ad8:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804add:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804ae0:	29 c2                	sub    %eax,%edx
  804ae2:	89 d0                	mov    %edx,%eax
  804ae4:	c1 e8 0c             	shr    $0xc,%eax
  804ae7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  804aea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804aed:	83 ec 0c             	sub    $0xc,%esp
  804af0:	50                   	push   %eax
  804af1:	e8 fe dc ff ff       	call   8027f4 <get_page>
  804af6:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  804af9:	8b 45 08             	mov    0x8(%ebp),%eax
  804afc:	89 c2                	mov    %eax,%edx
  804afe:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804b01:	89 c8                	mov    %ecx,%eax
  804b03:	01 c0                	add    %eax,%eax
  804b05:	01 c8                	add    %ecx,%eax
  804b07:	c1 e0 02             	shl    $0x2,%eax
  804b0a:	05 48 72 80 00       	add    $0x807248,%eax
  804b0f:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  804b12:	b8 00 10 00 00       	mov    $0x1000,%eax
  804b17:	ba 00 00 00 00       	mov    $0x0,%edx
  804b1c:	f7 75 08             	divl   0x8(%ebp)
  804b1f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  804b22:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804b25:	8d 50 ff             	lea    -0x1(%eax),%edx
  804b28:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804b2b:	89 c8                	mov    %ecx,%eax
  804b2d:	01 c0                	add    %eax,%eax
  804b2f:	01 c8                	add    %ecx,%eax
  804b31:	c1 e0 02             	shl    $0x2,%eax
  804b34:	05 4a 72 80 00       	add    $0x80724a,%eax
  804b39:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  804b3c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  804b43:	e9 aa 00 00 00       	jmp    804bf2 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  804b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b4b:	0f af 45 08          	imul   0x8(%ebp),%eax
  804b4f:	89 c2                	mov    %eax,%edx
  804b51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804b54:	01 d0                	add    %edx,%eax
  804b56:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  804b59:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804b5d:	75 17                	jne    804b76 <alloc_block+0x2cd>
  804b5f:	83 ec 04             	sub    $0x4,%esp
  804b62:	68 2c 66 80 00       	push   $0x80662c
  804b67:	68 9d 00 00 00       	push   $0x9d
  804b6c:	68 d3 65 80 00       	push   $0x8065d3
  804b71:	e8 20 ca ff ff       	call   801596 <_panic>
  804b76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b79:	c1 e0 04             	shl    $0x4,%eax
  804b7c:	05 64 f2 81 00       	add    $0x81f264,%eax
  804b81:	8b 10                	mov    (%eax),%edx
  804b83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804b86:	89 50 04             	mov    %edx,0x4(%eax)
  804b89:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804b8c:	8b 40 04             	mov    0x4(%eax),%eax
  804b8f:	85 c0                	test   %eax,%eax
  804b91:	74 14                	je     804ba7 <alloc_block+0x2fe>
  804b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b96:	c1 e0 04             	shl    $0x4,%eax
  804b99:	05 64 f2 81 00       	add    $0x81f264,%eax
  804b9e:	8b 00                	mov    (%eax),%eax
  804ba0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804ba3:	89 10                	mov    %edx,(%eax)
  804ba5:	eb 11                	jmp    804bb8 <alloc_block+0x30f>
  804ba7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804baa:	c1 e0 04             	shl    $0x4,%eax
  804bad:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804bb3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804bb6:	89 02                	mov    %eax,(%edx)
  804bb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bbb:	c1 e0 04             	shl    $0x4,%eax
  804bbe:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804bc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804bc7:	89 02                	mov    %eax,(%edx)
  804bc9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804bcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bd5:	c1 e0 04             	shl    $0x4,%eax
  804bd8:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804bdd:	8b 00                	mov    (%eax),%eax
  804bdf:	8d 50 01             	lea    0x1(%eax),%edx
  804be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804be5:	c1 e0 04             	shl    $0x4,%eax
  804be8:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804bed:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  804bef:	ff 45 f0             	incl   -0x10(%ebp)
  804bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804bf5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  804bf8:	0f 8c 4a ff ff ff    	jl     804b48 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  804bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804c01:	e9 3d 01 00 00       	jmp    804d43 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c09:	40                   	inc    %eax
  804c0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804c0d:	e9 10 01 00 00       	jmp    804d22 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  804c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c15:	c1 e0 04             	shl    $0x4,%eax
  804c18:	05 60 f2 81 00       	add    $0x81f260,%eax
  804c1d:	8b 00                	mov    (%eax),%eax
  804c1f:	85 c0                	test   %eax,%eax
  804c21:	0f 84 f8 00 00 00    	je     804d1f <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c2a:	c1 e0 04             	shl    $0x4,%eax
  804c2d:	05 60 f2 81 00       	add    $0x81f260,%eax
  804c32:	8b 00                	mov    (%eax),%eax
  804c34:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  804c37:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804c3b:	75 17                	jne    804c54 <alloc_block+0x3ab>
  804c3d:	83 ec 04             	sub    $0x4,%esp
  804c40:	68 0d 66 80 00       	push   $0x80660d
  804c45:	68 a8 00 00 00       	push   $0xa8
  804c4a:	68 d3 65 80 00       	push   $0x8065d3
  804c4f:	e8 42 c9 ff ff       	call   801596 <_panic>
  804c54:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c57:	8b 00                	mov    (%eax),%eax
  804c59:	85 c0                	test   %eax,%eax
  804c5b:	74 10                	je     804c6d <alloc_block+0x3c4>
  804c5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c60:	8b 00                	mov    (%eax),%eax
  804c62:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804c65:	8b 52 04             	mov    0x4(%edx),%edx
  804c68:	89 50 04             	mov    %edx,0x4(%eax)
  804c6b:	eb 14                	jmp    804c81 <alloc_block+0x3d8>
  804c6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c70:	8b 40 04             	mov    0x4(%eax),%eax
  804c73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804c76:	c1 e2 04             	shl    $0x4,%edx
  804c79:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804c7f:	89 02                	mov    %eax,(%edx)
  804c81:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c84:	8b 40 04             	mov    0x4(%eax),%eax
  804c87:	85 c0                	test   %eax,%eax
  804c89:	74 0f                	je     804c9a <alloc_block+0x3f1>
  804c8b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c8e:	8b 40 04             	mov    0x4(%eax),%eax
  804c91:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804c94:	8b 12                	mov    (%edx),%edx
  804c96:	89 10                	mov    %edx,(%eax)
  804c98:	eb 13                	jmp    804cad <alloc_block+0x404>
  804c9a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c9d:	8b 00                	mov    (%eax),%eax
  804c9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804ca2:	c1 e2 04             	shl    $0x4,%edx
  804ca5:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804cab:	89 02                	mov    %eax,(%edx)
  804cad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804cb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804cb6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804cb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804cc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804cc3:	c1 e0 04             	shl    $0x4,%eax
  804cc6:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804ccb:	8b 00                	mov    (%eax),%eax
  804ccd:	8d 50 ff             	lea    -0x1(%eax),%edx
  804cd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804cd3:	c1 e0 04             	shl    $0x4,%eax
  804cd6:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804cdb:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804cdd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804ce0:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804ce5:	29 c2                	sub    %eax,%edx
  804ce7:	89 d0                	mov    %edx,%eax
  804ce9:	c1 e8 0c             	shr    $0xc,%eax
  804cec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  804cef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  804cf2:	89 d0                	mov    %edx,%eax
  804cf4:	01 c0                	add    %eax,%eax
  804cf6:	01 d0                	add    %edx,%eax
  804cf8:	c1 e0 02             	shl    $0x2,%eax
  804cfb:	05 4a 72 80 00       	add    $0x80724a,%eax
  804d00:	66 8b 00             	mov    (%eax),%ax
  804d03:	8d 50 ff             	lea    -0x1(%eax),%edx
  804d06:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  804d09:	89 c8                	mov    %ecx,%eax
  804d0b:	01 c0                	add    %eax,%eax
  804d0d:	01 c8                	add    %ecx,%eax
  804d0f:	c1 e0 02             	shl    $0x2,%eax
  804d12:	05 4a 72 80 00       	add    $0x80724a,%eax
  804d17:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  804d1a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804d1d:	eb 24                	jmp    804d43 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804d1f:	ff 45 ec             	incl   -0x14(%ebp)
  804d22:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804d26:	0f 8e e6 fe ff ff    	jle    804c12 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  804d2c:	83 ec 04             	sub    $0x4,%esp
  804d2f:	68 4f 66 80 00       	push   $0x80664f
  804d34:	68 b1 00 00 00       	push   $0xb1
  804d39:	68 d3 65 80 00       	push   $0x8065d3
  804d3e:	e8 53 c8 ff ff       	call   801596 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804d43:	c9                   	leave  
  804d44:	c3                   	ret    

00804d45 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804d45:	55                   	push   %ebp
  804d46:	89 e5                	mov    %esp,%ebp
  804d48:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  804d4e:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804d53:	39 c2                	cmp    %eax,%edx
  804d55:	72 0c                	jb     804d63 <free_block+0x1e>
  804d57:	8b 55 08             	mov    0x8(%ebp),%edx
  804d5a:	a1 20 72 80 00       	mov    0x807220,%eax
  804d5f:	39 c2                	cmp    %eax,%edx
  804d61:	72 19                	jb     804d7c <free_block+0x37>
  804d63:	68 6c 66 80 00       	push   $0x80666c
  804d68:	68 be 65 80 00       	push   $0x8065be
  804d6d:	68 c3 00 00 00       	push   $0xc3
  804d72:	68 d3 65 80 00       	push   $0x8065d3
  804d77:	e8 1a c8 ff ff       	call   801596 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  804d7f:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804d84:	29 c2                	sub    %eax,%edx
  804d86:	89 d0                	mov    %edx,%eax
  804d88:	c1 e8 0c             	shr    $0xc,%eax
  804d8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  804d8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804d91:	89 d0                	mov    %edx,%eax
  804d93:	01 c0                	add    %eax,%eax
  804d95:	01 d0                	add    %edx,%eax
  804d97:	c1 e0 02             	shl    $0x2,%eax
  804d9a:	05 48 72 80 00       	add    $0x807248,%eax
  804d9f:	8b 00                	mov    (%eax),%eax
  804da1:	0f b7 c0             	movzwl %ax,%eax
  804da4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  804da7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804dab:	75 17                	jne    804dc4 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  804dad:	83 ec 04             	sub    $0x4,%esp
  804db0:	68 a4 66 80 00       	push   $0x8066a4
  804db5:	68 cf 00 00 00       	push   $0xcf
  804dba:	68 d3 65 80 00       	push   $0x8065d3
  804dbf:	e8 d2 c7 ff ff       	call   801596 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804dc4:	83 ec 0c             	sub    $0xc,%esp
  804dc7:	ff 75 ec             	pushl  -0x14(%ebp)
  804dca:	e8 d8 f8 ff ff       	call   8046a7 <log2>
  804dcf:	83 c4 10             	add    $0x10,%esp
  804dd2:	83 e8 03             	sub    $0x3,%eax
  804dd5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  804ddb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  804dde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804de2:	75 17                	jne    804dfb <free_block+0xb6>
  804de4:	83 ec 04             	sub    $0x4,%esp
  804de7:	68 2c 66 80 00       	push   $0x80662c
  804dec:	68 d5 00 00 00       	push   $0xd5
  804df1:	68 d3 65 80 00       	push   $0x8065d3
  804df6:	e8 9b c7 ff ff       	call   801596 <_panic>
  804dfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804dfe:	c1 e0 04             	shl    $0x4,%eax
  804e01:	05 64 f2 81 00       	add    $0x81f264,%eax
  804e06:	8b 10                	mov    (%eax),%edx
  804e08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e0b:	89 50 04             	mov    %edx,0x4(%eax)
  804e0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e11:	8b 40 04             	mov    0x4(%eax),%eax
  804e14:	85 c0                	test   %eax,%eax
  804e16:	74 14                	je     804e2c <free_block+0xe7>
  804e18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e1b:	c1 e0 04             	shl    $0x4,%eax
  804e1e:	05 64 f2 81 00       	add    $0x81f264,%eax
  804e23:	8b 00                	mov    (%eax),%eax
  804e25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804e28:	89 10                	mov    %edx,(%eax)
  804e2a:	eb 11                	jmp    804e3d <free_block+0xf8>
  804e2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e2f:	c1 e0 04             	shl    $0x4,%eax
  804e32:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804e38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e3b:	89 02                	mov    %eax,(%edx)
  804e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e40:	c1 e0 04             	shl    $0x4,%eax
  804e43:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804e49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e4c:	89 02                	mov    %eax,(%edx)
  804e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804e57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e5a:	c1 e0 04             	shl    $0x4,%eax
  804e5d:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804e62:	8b 00                	mov    (%eax),%eax
  804e64:	8d 50 01             	lea    0x1(%eax),%edx
  804e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e6a:	c1 e0 04             	shl    $0x4,%eax
  804e6d:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804e72:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  804e74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804e77:	89 d0                	mov    %edx,%eax
  804e79:	01 c0                	add    %eax,%eax
  804e7b:	01 d0                	add    %edx,%eax
  804e7d:	c1 e0 02             	shl    $0x2,%eax
  804e80:	05 4a 72 80 00       	add    $0x80724a,%eax
  804e85:	66 8b 00             	mov    (%eax),%ax
  804e88:	8d 50 01             	lea    0x1(%eax),%edx
  804e8b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804e8e:	89 c8                	mov    %ecx,%eax
  804e90:	01 c0                	add    %eax,%eax
  804e92:	01 c8                	add    %ecx,%eax
  804e94:	c1 e0 02             	shl    $0x2,%eax
  804e97:	05 4a 72 80 00       	add    $0x80724a,%eax
  804e9c:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  804e9f:	b8 00 10 00 00       	mov    $0x1000,%eax
  804ea4:	ba 00 00 00 00       	mov    $0x0,%edx
  804ea9:	f7 75 ec             	divl   -0x14(%ebp)
  804eac:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  804eaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804eb2:	89 d0                	mov    %edx,%eax
  804eb4:	01 c0                	add    %eax,%eax
  804eb6:	01 d0                	add    %edx,%eax
  804eb8:	c1 e0 02             	shl    $0x2,%eax
  804ebb:	05 4a 72 80 00       	add    $0x80724a,%eax
  804ec0:	66 8b 00             	mov    (%eax),%ax
  804ec3:	0f b7 c0             	movzwl %ax,%eax
  804ec6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804ec9:	0f 85 d3 01 00 00    	jne    8050a2 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  804ecf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804ed2:	c1 e0 04             	shl    $0x4,%eax
  804ed5:	05 60 f2 81 00       	add    $0x81f260,%eax
  804eda:	8b 00                	mov    (%eax),%eax
  804edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  804edf:	e9 f1 00 00 00       	jmp    804fd5 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ee7:	8b 00                	mov    (%eax),%eax
  804ee9:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  804eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804eef:	c1 e0 0c             	shl    $0xc,%eax
  804ef2:	89 c2                	mov    %eax,%edx
  804ef4:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804ef9:	01 d0                	add    %edx,%eax
  804efb:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  804efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804f01:	40                   	inc    %eax
  804f02:	c1 e0 0c             	shl    $0xc,%eax
  804f05:	89 c2                	mov    %eax,%edx
  804f07:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804f0c:	01 d0                	add    %edx,%eax
  804f0e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  804f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f14:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  804f17:	0f 82 b8 00 00 00    	jb     804fd5 <free_block+0x290>
  804f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f20:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804f23:	0f 83 ac 00 00 00    	jae    804fd5 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  804f29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804f2d:	75 17                	jne    804f46 <free_block+0x201>
  804f2f:	83 ec 04             	sub    $0x4,%esp
  804f32:	68 0d 66 80 00       	push   $0x80660d
  804f37:	68 e2 00 00 00       	push   $0xe2
  804f3c:	68 d3 65 80 00       	push   $0x8065d3
  804f41:	e8 50 c6 ff ff       	call   801596 <_panic>
  804f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f49:	8b 00                	mov    (%eax),%eax
  804f4b:	85 c0                	test   %eax,%eax
  804f4d:	74 10                	je     804f5f <free_block+0x21a>
  804f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f52:	8b 00                	mov    (%eax),%eax
  804f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804f57:	8b 52 04             	mov    0x4(%edx),%edx
  804f5a:	89 50 04             	mov    %edx,0x4(%eax)
  804f5d:	eb 14                	jmp    804f73 <free_block+0x22e>
  804f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f62:	8b 40 04             	mov    0x4(%eax),%eax
  804f65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804f68:	c1 e2 04             	shl    $0x4,%edx
  804f6b:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804f71:	89 02                	mov    %eax,(%edx)
  804f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f76:	8b 40 04             	mov    0x4(%eax),%eax
  804f79:	85 c0                	test   %eax,%eax
  804f7b:	74 0f                	je     804f8c <free_block+0x247>
  804f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f80:	8b 40 04             	mov    0x4(%eax),%eax
  804f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804f86:	8b 12                	mov    (%edx),%edx
  804f88:	89 10                	mov    %edx,(%eax)
  804f8a:	eb 13                	jmp    804f9f <free_block+0x25a>
  804f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f8f:	8b 00                	mov    (%eax),%eax
  804f91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804f94:	c1 e2 04             	shl    $0x4,%edx
  804f97:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804f9d:	89 02                	mov    %eax,(%edx)
  804f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804fb5:	c1 e0 04             	shl    $0x4,%eax
  804fb8:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804fbd:	8b 00                	mov    (%eax),%eax
  804fbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  804fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804fc5:	c1 e0 04             	shl    $0x4,%eax
  804fc8:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804fcd:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  804fcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804fd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804fd9:	0f 85 05 ff ff ff    	jne    804ee4 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  804fdf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804fe2:	89 d0                	mov    %edx,%eax
  804fe4:	01 c0                	add    %eax,%eax
  804fe6:	01 d0                	add    %edx,%eax
  804fe8:	c1 e0 02             	shl    $0x2,%eax
  804feb:	05 48 72 80 00       	add    $0x807248,%eax
  804ff0:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  804ff5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804ff8:	89 d0                	mov    %edx,%eax
  804ffa:	01 c0                	add    %eax,%eax
  804ffc:	01 d0                	add    %edx,%eax
  804ffe:	c1 e0 02             	shl    $0x2,%eax
  805001:	05 4a 72 80 00       	add    $0x80724a,%eax
  805006:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  80500b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80500e:	89 d0                	mov    %edx,%eax
  805010:	01 c0                	add    %eax,%eax
  805012:	01 d0                	add    %edx,%eax
  805014:	c1 e0 02             	shl    $0x2,%eax
  805017:	05 40 72 80 00       	add    $0x807240,%eax
  80501c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  80501f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  805023:	75 17                	jne    80503c <free_block+0x2f7>
  805025:	83 ec 04             	sub    $0x4,%esp
  805028:	68 2c 66 80 00       	push   $0x80662c
  80502d:	68 eb 00 00 00       	push   $0xeb
  805032:	68 d3 65 80 00       	push   $0x8065d3
  805037:	e8 5a c5 ff ff       	call   801596 <_panic>
  80503c:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  805042:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805045:	89 50 04             	mov    %edx,0x4(%eax)
  805048:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80504b:	8b 40 04             	mov    0x4(%eax),%eax
  80504e:	85 c0                	test   %eax,%eax
  805050:	74 0c                	je     80505e <free_block+0x319>
  805052:	a1 2c 72 80 00       	mov    0x80722c,%eax
  805057:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80505a:	89 10                	mov    %edx,(%eax)
  80505c:	eb 08                	jmp    805066 <free_block+0x321>
  80505e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805061:	a3 28 72 80 00       	mov    %eax,0x807228
  805066:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805069:	a3 2c 72 80 00       	mov    %eax,0x80722c
  80506e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805071:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  805077:	a1 34 72 80 00       	mov    0x807234,%eax
  80507c:	40                   	inc    %eax
  80507d:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  805082:	83 ec 0c             	sub    $0xc,%esp
  805085:	ff 75 d0             	pushl  -0x30(%ebp)
  805088:	e8 ce f5 ff ff       	call   80465b <to_page_va>
  80508d:	83 c4 10             	add    $0x10,%esp
  805090:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  805093:	8b 45 cc             	mov    -0x34(%ebp),%eax
  805096:	83 ec 0c             	sub    $0xc,%esp
  805099:	50                   	push   %eax
  80509a:	e8 9e d7 ff ff       	call   80283d <return_page>
  80509f:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8050a2:	90                   	nop
  8050a3:	c9                   	leave  
  8050a4:	c3                   	ret    

008050a5 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8050a5:	55                   	push   %ebp
  8050a6:	89 e5                	mov    %esp,%ebp
  8050a8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8050ab:	83 ec 04             	sub    $0x4,%esp
  8050ae:	68 cc 66 80 00       	push   $0x8066cc
  8050b3:	68 01 01 00 00       	push   $0x101
  8050b8:	68 d3 65 80 00       	push   $0x8065d3
  8050bd:	e8 d4 c4 ff ff       	call   801596 <_panic>

008050c2 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  8050c2:	55                   	push   %ebp
  8050c3:	89 e5                	mov    %esp,%ebp
  8050c5:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  8050c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8050cc:	74 1c                	je     8050ea <init_uspinlock+0x28>
  8050ce:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8050d2:	74 16                	je     8050ea <init_uspinlock+0x28>
  8050d4:	68 f0 66 80 00       	push   $0x8066f0
  8050d9:	68 0f 67 80 00       	push   $0x80670f
  8050de:	6a 10                	push   $0x10
  8050e0:	68 24 67 80 00       	push   $0x806724
  8050e5:	e8 ac c4 ff ff       	call   801596 <_panic>
	strcpy(lk->name, name);
  8050ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8050ed:	83 c0 04             	add    $0x4,%eax
  8050f0:	83 ec 08             	sub    $0x8,%esp
  8050f3:	ff 75 0c             	pushl  0xc(%ebp)
  8050f6:	50                   	push   %eax
  8050f7:	e8 90 ce ff ff       	call   801f8c <strcpy>
  8050fc:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  8050ff:	b8 01 00 00 00       	mov    $0x1,%eax
  805104:	2b 45 10             	sub    0x10(%ebp),%eax
  805107:	89 c2                	mov    %eax,%edx
  805109:	8b 45 08             	mov    0x8(%ebp),%eax
  80510c:	89 10                	mov    %edx,(%eax)
}
  80510e:	90                   	nop
  80510f:	c9                   	leave  
  805110:	c3                   	ret    

00805111 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  805111:	55                   	push   %ebp
  805112:	89 e5                	mov    %esp,%ebp
  805114:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  805117:	90                   	nop
  805118:	8b 45 08             	mov    0x8(%ebp),%eax
  80511b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80511e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  805125:	8b 55 f4             	mov    -0xc(%ebp),%edx
  805128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80512b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80512e:	f0 87 02             	lock xchg %eax,(%edx)
  805131:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  805134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  805137:	85 c0                	test   %eax,%eax
  805139:	75 dd                	jne    805118 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80513b:	8b 45 08             	mov    0x8(%ebp),%eax
  80513e:	8d 48 04             	lea    0x4(%eax),%ecx
  805141:	a1 00 72 80 00       	mov    0x807200,%eax
  805146:	8d 50 20             	lea    0x20(%eax),%edx
  805149:	a1 00 72 80 00       	mov    0x807200,%eax
  80514e:	8b 40 10             	mov    0x10(%eax),%eax
  805151:	51                   	push   %ecx
  805152:	52                   	push   %edx
  805153:	50                   	push   %eax
  805154:	68 34 67 80 00       	push   $0x806734
  805159:	e8 06 c7 ff ff       	call   801864 <cprintf>
  80515e:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  805161:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  805166:	90                   	nop
  805167:	c9                   	leave  
  805168:	c3                   	ret    

00805169 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  805169:	55                   	push   %ebp
  80516a:	89 e5                	mov    %esp,%ebp
  80516c:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  80516f:	8b 45 08             	mov    0x8(%ebp),%eax
  805172:	8b 00                	mov    (%eax),%eax
  805174:	85 c0                	test   %eax,%eax
  805176:	75 18                	jne    805190 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  805178:	8b 45 08             	mov    0x8(%ebp),%eax
  80517b:	83 c0 04             	add    $0x4,%eax
  80517e:	50                   	push   %eax
  80517f:	68 58 67 80 00       	push   $0x806758
  805184:	6a 2b                	push   $0x2b
  805186:	68 24 67 80 00       	push   $0x806724
  80518b:	e8 06 c4 ff ff       	call   801596 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  805190:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  805195:	8b 45 08             	mov    0x8(%ebp),%eax
  805198:	8b 55 08             	mov    0x8(%ebp),%edx
  80519b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8051a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8051a4:	8d 48 04             	lea    0x4(%eax),%ecx
  8051a7:	a1 00 72 80 00       	mov    0x807200,%eax
  8051ac:	8d 50 20             	lea    0x20(%eax),%edx
  8051af:	a1 00 72 80 00       	mov    0x807200,%eax
  8051b4:	8b 40 10             	mov    0x10(%eax),%eax
  8051b7:	51                   	push   %ecx
  8051b8:	52                   	push   %edx
  8051b9:	50                   	push   %eax
  8051ba:	68 78 67 80 00       	push   $0x806778
  8051bf:	e8 a0 c6 ff ff       	call   801864 <cprintf>
  8051c4:	83 c4 10             	add    $0x10,%esp
}
  8051c7:	90                   	nop
  8051c8:	c9                   	leave  
  8051c9:	c3                   	ret    
  8051ca:	66 90                	xchg   %ax,%ax

008051cc <__udivdi3>:
  8051cc:	55                   	push   %ebp
  8051cd:	57                   	push   %edi
  8051ce:	56                   	push   %esi
  8051cf:	53                   	push   %ebx
  8051d0:	83 ec 1c             	sub    $0x1c,%esp
  8051d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8051d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8051db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8051df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8051e3:	89 ca                	mov    %ecx,%edx
  8051e5:	89 f8                	mov    %edi,%eax
  8051e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8051eb:	85 f6                	test   %esi,%esi
  8051ed:	75 2d                	jne    80521c <__udivdi3+0x50>
  8051ef:	39 cf                	cmp    %ecx,%edi
  8051f1:	77 65                	ja     805258 <__udivdi3+0x8c>
  8051f3:	89 fd                	mov    %edi,%ebp
  8051f5:	85 ff                	test   %edi,%edi
  8051f7:	75 0b                	jne    805204 <__udivdi3+0x38>
  8051f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8051fe:	31 d2                	xor    %edx,%edx
  805200:	f7 f7                	div    %edi
  805202:	89 c5                	mov    %eax,%ebp
  805204:	31 d2                	xor    %edx,%edx
  805206:	89 c8                	mov    %ecx,%eax
  805208:	f7 f5                	div    %ebp
  80520a:	89 c1                	mov    %eax,%ecx
  80520c:	89 d8                	mov    %ebx,%eax
  80520e:	f7 f5                	div    %ebp
  805210:	89 cf                	mov    %ecx,%edi
  805212:	89 fa                	mov    %edi,%edx
  805214:	83 c4 1c             	add    $0x1c,%esp
  805217:	5b                   	pop    %ebx
  805218:	5e                   	pop    %esi
  805219:	5f                   	pop    %edi
  80521a:	5d                   	pop    %ebp
  80521b:	c3                   	ret    
  80521c:	39 ce                	cmp    %ecx,%esi
  80521e:	77 28                	ja     805248 <__udivdi3+0x7c>
  805220:	0f bd fe             	bsr    %esi,%edi
  805223:	83 f7 1f             	xor    $0x1f,%edi
  805226:	75 40                	jne    805268 <__udivdi3+0x9c>
  805228:	39 ce                	cmp    %ecx,%esi
  80522a:	72 0a                	jb     805236 <__udivdi3+0x6a>
  80522c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  805230:	0f 87 9e 00 00 00    	ja     8052d4 <__udivdi3+0x108>
  805236:	b8 01 00 00 00       	mov    $0x1,%eax
  80523b:	89 fa                	mov    %edi,%edx
  80523d:	83 c4 1c             	add    $0x1c,%esp
  805240:	5b                   	pop    %ebx
  805241:	5e                   	pop    %esi
  805242:	5f                   	pop    %edi
  805243:	5d                   	pop    %ebp
  805244:	c3                   	ret    
  805245:	8d 76 00             	lea    0x0(%esi),%esi
  805248:	31 ff                	xor    %edi,%edi
  80524a:	31 c0                	xor    %eax,%eax
  80524c:	89 fa                	mov    %edi,%edx
  80524e:	83 c4 1c             	add    $0x1c,%esp
  805251:	5b                   	pop    %ebx
  805252:	5e                   	pop    %esi
  805253:	5f                   	pop    %edi
  805254:	5d                   	pop    %ebp
  805255:	c3                   	ret    
  805256:	66 90                	xchg   %ax,%ax
  805258:	89 d8                	mov    %ebx,%eax
  80525a:	f7 f7                	div    %edi
  80525c:	31 ff                	xor    %edi,%edi
  80525e:	89 fa                	mov    %edi,%edx
  805260:	83 c4 1c             	add    $0x1c,%esp
  805263:	5b                   	pop    %ebx
  805264:	5e                   	pop    %esi
  805265:	5f                   	pop    %edi
  805266:	5d                   	pop    %ebp
  805267:	c3                   	ret    
  805268:	bd 20 00 00 00       	mov    $0x20,%ebp
  80526d:	89 eb                	mov    %ebp,%ebx
  80526f:	29 fb                	sub    %edi,%ebx
  805271:	89 f9                	mov    %edi,%ecx
  805273:	d3 e6                	shl    %cl,%esi
  805275:	89 c5                	mov    %eax,%ebp
  805277:	88 d9                	mov    %bl,%cl
  805279:	d3 ed                	shr    %cl,%ebp
  80527b:	89 e9                	mov    %ebp,%ecx
  80527d:	09 f1                	or     %esi,%ecx
  80527f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  805283:	89 f9                	mov    %edi,%ecx
  805285:	d3 e0                	shl    %cl,%eax
  805287:	89 c5                	mov    %eax,%ebp
  805289:	89 d6                	mov    %edx,%esi
  80528b:	88 d9                	mov    %bl,%cl
  80528d:	d3 ee                	shr    %cl,%esi
  80528f:	89 f9                	mov    %edi,%ecx
  805291:	d3 e2                	shl    %cl,%edx
  805293:	8b 44 24 08          	mov    0x8(%esp),%eax
  805297:	88 d9                	mov    %bl,%cl
  805299:	d3 e8                	shr    %cl,%eax
  80529b:	09 c2                	or     %eax,%edx
  80529d:	89 d0                	mov    %edx,%eax
  80529f:	89 f2                	mov    %esi,%edx
  8052a1:	f7 74 24 0c          	divl   0xc(%esp)
  8052a5:	89 d6                	mov    %edx,%esi
  8052a7:	89 c3                	mov    %eax,%ebx
  8052a9:	f7 e5                	mul    %ebp
  8052ab:	39 d6                	cmp    %edx,%esi
  8052ad:	72 19                	jb     8052c8 <__udivdi3+0xfc>
  8052af:	74 0b                	je     8052bc <__udivdi3+0xf0>
  8052b1:	89 d8                	mov    %ebx,%eax
  8052b3:	31 ff                	xor    %edi,%edi
  8052b5:	e9 58 ff ff ff       	jmp    805212 <__udivdi3+0x46>
  8052ba:	66 90                	xchg   %ax,%ax
  8052bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8052c0:	89 f9                	mov    %edi,%ecx
  8052c2:	d3 e2                	shl    %cl,%edx
  8052c4:	39 c2                	cmp    %eax,%edx
  8052c6:	73 e9                	jae    8052b1 <__udivdi3+0xe5>
  8052c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8052cb:	31 ff                	xor    %edi,%edi
  8052cd:	e9 40 ff ff ff       	jmp    805212 <__udivdi3+0x46>
  8052d2:	66 90                	xchg   %ax,%ax
  8052d4:	31 c0                	xor    %eax,%eax
  8052d6:	e9 37 ff ff ff       	jmp    805212 <__udivdi3+0x46>
  8052db:	90                   	nop

008052dc <__umoddi3>:
  8052dc:	55                   	push   %ebp
  8052dd:	57                   	push   %edi
  8052de:	56                   	push   %esi
  8052df:	53                   	push   %ebx
  8052e0:	83 ec 1c             	sub    $0x1c,%esp
  8052e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8052e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8052eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8052ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8052f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8052f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8052fb:	89 f3                	mov    %esi,%ebx
  8052fd:	89 fa                	mov    %edi,%edx
  8052ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  805303:	89 34 24             	mov    %esi,(%esp)
  805306:	85 c0                	test   %eax,%eax
  805308:	75 1a                	jne    805324 <__umoddi3+0x48>
  80530a:	39 f7                	cmp    %esi,%edi
  80530c:	0f 86 a2 00 00 00    	jbe    8053b4 <__umoddi3+0xd8>
  805312:	89 c8                	mov    %ecx,%eax
  805314:	89 f2                	mov    %esi,%edx
  805316:	f7 f7                	div    %edi
  805318:	89 d0                	mov    %edx,%eax
  80531a:	31 d2                	xor    %edx,%edx
  80531c:	83 c4 1c             	add    $0x1c,%esp
  80531f:	5b                   	pop    %ebx
  805320:	5e                   	pop    %esi
  805321:	5f                   	pop    %edi
  805322:	5d                   	pop    %ebp
  805323:	c3                   	ret    
  805324:	39 f0                	cmp    %esi,%eax
  805326:	0f 87 ac 00 00 00    	ja     8053d8 <__umoddi3+0xfc>
  80532c:	0f bd e8             	bsr    %eax,%ebp
  80532f:	83 f5 1f             	xor    $0x1f,%ebp
  805332:	0f 84 ac 00 00 00    	je     8053e4 <__umoddi3+0x108>
  805338:	bf 20 00 00 00       	mov    $0x20,%edi
  80533d:	29 ef                	sub    %ebp,%edi
  80533f:	89 fe                	mov    %edi,%esi
  805341:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  805345:	89 e9                	mov    %ebp,%ecx
  805347:	d3 e0                	shl    %cl,%eax
  805349:	89 d7                	mov    %edx,%edi
  80534b:	89 f1                	mov    %esi,%ecx
  80534d:	d3 ef                	shr    %cl,%edi
  80534f:	09 c7                	or     %eax,%edi
  805351:	89 e9                	mov    %ebp,%ecx
  805353:	d3 e2                	shl    %cl,%edx
  805355:	89 14 24             	mov    %edx,(%esp)
  805358:	89 d8                	mov    %ebx,%eax
  80535a:	d3 e0                	shl    %cl,%eax
  80535c:	89 c2                	mov    %eax,%edx
  80535e:	8b 44 24 08          	mov    0x8(%esp),%eax
  805362:	d3 e0                	shl    %cl,%eax
  805364:	89 44 24 04          	mov    %eax,0x4(%esp)
  805368:	8b 44 24 08          	mov    0x8(%esp),%eax
  80536c:	89 f1                	mov    %esi,%ecx
  80536e:	d3 e8                	shr    %cl,%eax
  805370:	09 d0                	or     %edx,%eax
  805372:	d3 eb                	shr    %cl,%ebx
  805374:	89 da                	mov    %ebx,%edx
  805376:	f7 f7                	div    %edi
  805378:	89 d3                	mov    %edx,%ebx
  80537a:	f7 24 24             	mull   (%esp)
  80537d:	89 c6                	mov    %eax,%esi
  80537f:	89 d1                	mov    %edx,%ecx
  805381:	39 d3                	cmp    %edx,%ebx
  805383:	0f 82 87 00 00 00    	jb     805410 <__umoddi3+0x134>
  805389:	0f 84 91 00 00 00    	je     805420 <__umoddi3+0x144>
  80538f:	8b 54 24 04          	mov    0x4(%esp),%edx
  805393:	29 f2                	sub    %esi,%edx
  805395:	19 cb                	sbb    %ecx,%ebx
  805397:	89 d8                	mov    %ebx,%eax
  805399:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80539d:	d3 e0                	shl    %cl,%eax
  80539f:	89 e9                	mov    %ebp,%ecx
  8053a1:	d3 ea                	shr    %cl,%edx
  8053a3:	09 d0                	or     %edx,%eax
  8053a5:	89 e9                	mov    %ebp,%ecx
  8053a7:	d3 eb                	shr    %cl,%ebx
  8053a9:	89 da                	mov    %ebx,%edx
  8053ab:	83 c4 1c             	add    $0x1c,%esp
  8053ae:	5b                   	pop    %ebx
  8053af:	5e                   	pop    %esi
  8053b0:	5f                   	pop    %edi
  8053b1:	5d                   	pop    %ebp
  8053b2:	c3                   	ret    
  8053b3:	90                   	nop
  8053b4:	89 fd                	mov    %edi,%ebp
  8053b6:	85 ff                	test   %edi,%edi
  8053b8:	75 0b                	jne    8053c5 <__umoddi3+0xe9>
  8053ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8053bf:	31 d2                	xor    %edx,%edx
  8053c1:	f7 f7                	div    %edi
  8053c3:	89 c5                	mov    %eax,%ebp
  8053c5:	89 f0                	mov    %esi,%eax
  8053c7:	31 d2                	xor    %edx,%edx
  8053c9:	f7 f5                	div    %ebp
  8053cb:	89 c8                	mov    %ecx,%eax
  8053cd:	f7 f5                	div    %ebp
  8053cf:	89 d0                	mov    %edx,%eax
  8053d1:	e9 44 ff ff ff       	jmp    80531a <__umoddi3+0x3e>
  8053d6:	66 90                	xchg   %ax,%ax
  8053d8:	89 c8                	mov    %ecx,%eax
  8053da:	89 f2                	mov    %esi,%edx
  8053dc:	83 c4 1c             	add    $0x1c,%esp
  8053df:	5b                   	pop    %ebx
  8053e0:	5e                   	pop    %esi
  8053e1:	5f                   	pop    %edi
  8053e2:	5d                   	pop    %ebp
  8053e3:	c3                   	ret    
  8053e4:	3b 04 24             	cmp    (%esp),%eax
  8053e7:	72 06                	jb     8053ef <__umoddi3+0x113>
  8053e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8053ed:	77 0f                	ja     8053fe <__umoddi3+0x122>
  8053ef:	89 f2                	mov    %esi,%edx
  8053f1:	29 f9                	sub    %edi,%ecx
  8053f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8053f7:	89 14 24             	mov    %edx,(%esp)
  8053fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8053fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  805402:	8b 14 24             	mov    (%esp),%edx
  805405:	83 c4 1c             	add    $0x1c,%esp
  805408:	5b                   	pop    %ebx
  805409:	5e                   	pop    %esi
  80540a:	5f                   	pop    %edi
  80540b:	5d                   	pop    %ebp
  80540c:	c3                   	ret    
  80540d:	8d 76 00             	lea    0x0(%esi),%esi
  805410:	2b 04 24             	sub    (%esp),%eax
  805413:	19 fa                	sbb    %edi,%edx
  805415:	89 d1                	mov    %edx,%ecx
  805417:	89 c6                	mov    %eax,%esi
  805419:	e9 71 ff ff ff       	jmp    80538f <__umoddi3+0xb3>
  80541e:	66 90                	xchg   %ax,%ax
  805420:	39 44 24 04          	cmp    %eax,0x4(%esp)
  805424:	72 ea                	jb     805410 <__umoddi3+0x134>
  805426:	89 d9                	mov    %ebx,%ecx
  805428:	e9 62 ff ff ff       	jmp    80538f <__umoddi3+0xb3>
