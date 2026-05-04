
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 ef 13 00 00       	call   801425 <libmain>
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
  800067:	e8 ab 41 00 00       	call   804217 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 ee 41 00 00       	call   804262 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 fe 27 00 00       	call   8028c5 <malloc>
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
  8000df:	e8 33 41 00 00       	call   804217 <sys_calculate_free_frames>
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
  800125:	68 40 55 80 00       	push   $0x805540
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 a8 17 00 00       	call   8018d9 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 29 41 00 00       	call   804262 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 bc 55 80 00       	push   $0x8055bc
  800150:	6a 0c                	push   $0xc
  800152:	e8 82 17 00 00       	call   8018d9 <cprintf_colored>
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
  800174:	e8 9e 40 00 00       	call   804217 <sys_calculate_free_frames>
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
  8001b9:	e8 59 40 00 00       	call   804217 <sys_calculate_free_frames>
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
  8001f8:	68 34 56 80 00       	push   $0x805634
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 d5 16 00 00       	call   8018d9 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 56 40 00 00       	call   804262 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 c0 56 80 00       	push   $0x8056c0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 a8 16 00 00       	call   8018d9 <cprintf_colored>
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
  800270:	e8 64 43 00 00       	call   8045d9 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 38 57 80 00       	push   $0x805738
  80028f:	6a 0c                	push   $0xc
  800291:	e8 43 16 00 00       	call   8018d9 <cprintf_colored>
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
  8002ae:	e8 64 3f 00 00       	call   804217 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 a7 3f 00 00       	call   804262 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 f2 2a 00 00       	call   802dc3 <free>
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
  8002fc:	e8 61 3f 00 00       	call   804262 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 70 57 80 00       	push   $0x805770
  800318:	6a 0c                	push   $0xc
  80031a:	e8 ba 15 00 00       	call   8018d9 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 f0 3e 00 00       	call   804217 <sys_calculate_free_frames>
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
  800342:	68 bc 57 80 00       	push   $0x8057bc
  800347:	6a 0c                	push   $0xc
  800349:	e8 8b 15 00 00       	call   8018d9 <cprintf_colored>
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
  8003a0:	e8 34 42 00 00       	call   8045d9 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 18 58 80 00       	push   $0x805818
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 13 15 00 00       	call   8018d9 <cprintf_colored>
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
  800416:	68 50 58 80 00       	push   $0x805850
  80041b:	6a 03                	push   $0x3
  80041d:	e8 b7 14 00 00       	call   8018d9 <cprintf_colored>
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
  8004df:	68 80 58 80 00       	push   $0x805880
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 ee 13 00 00       	call   8018d9 <cprintf_colored>
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
  8005b9:	68 80 58 80 00       	push   $0x805880
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 14 13 00 00       	call   8018d9 <cprintf_colored>
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
  800693:	68 80 58 80 00       	push   $0x805880
  800698:	6a 0c                	push   $0xc
  80069a:	e8 3a 12 00 00       	call   8018d9 <cprintf_colored>
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
  80076d:	68 80 58 80 00       	push   $0x805880
  800772:	6a 0c                	push   $0xc
  800774:	e8 60 11 00 00       	call   8018d9 <cprintf_colored>
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
  800847:	68 80 58 80 00       	push   $0x805880
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 86 10 00 00       	call   8018d9 <cprintf_colored>
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
  800921:	68 80 58 80 00       	push   $0x805880
  800926:	6a 0c                	push   $0xc
  800928:	e8 ac 0f 00 00       	call   8018d9 <cprintf_colored>
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
  800a16:	68 80 58 80 00       	push   $0x805880
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 b7 0e 00 00       	call   8018d9 <cprintf_colored>
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
  800b14:	68 80 58 80 00       	push   $0x805880
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 b9 0d 00 00       	call   8018d9 <cprintf_colored>
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
  800c12:	68 80 58 80 00       	push   $0x805880
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 bb 0c 00 00       	call   8018d9 <cprintf_colored>
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
  800d10:	68 80 58 80 00       	push   $0x805880
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 bd 0b 00 00       	call   8018d9 <cprintf_colored>
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
  800dfd:	68 80 58 80 00       	push   $0x805880
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 d0 0a 00 00       	call   8018d9 <cprintf_colored>
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
  800eea:	68 80 58 80 00       	push   $0x805880
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 e3 09 00 00       	call   8018d9 <cprintf_colored>
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
  800fd7:	68 80 58 80 00       	push   $0x805880
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 f6 08 00 00       	call   8018d9 <cprintf_colored>
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
  800ffa:	68 d2 58 80 00       	push   $0x8058d2
  800fff:	6a 03                	push   $0x3
  801001:	e8 d3 08 00 00       	call   8018d9 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 f8 31 00 00       	call   804217 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 38 32 00 00       	call   804262 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 6b 18 00 00       	call   8028c5 <malloc>
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
  801084:	68 f0 58 80 00       	push   $0x8058f0
  801089:	6a 0c                	push   $0xc
  80108b:	e8 49 08 00 00       	call   8018d9 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 ca 31 00 00       	call   804262 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 2c 59 80 00       	push   $0x80592c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 1d 08 00 00       	call   8018d9 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 53 31 00 00       	call   804217 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 9c 59 80 00       	push   $0x80599c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 f1 07 00 00       	call   8018d9 <cprintf_colored>
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
  801102:	83 ec 28             	sub    $0x28,%esp

#if USE_KHEAP
	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
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
  801122:	68 e4 59 80 00       	push   $0x8059e4
  801127:	6a 15                	push   $0x15
  801129:	68 00 5a 80 00       	push   $0x805a00
  80112e:	e8 ab 04 00 00       	call   8015de <_panic>
	/*=================================================*/
#else
	panic("not handled!");
#endif
	//1. Alloc some spaces in PAGE allocator
	int correct = 1;
  801133:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	int eval;
	cprintf_colored(TEXT_cyan,"\n1. Alloc some spaces in PAGE allocator\n");
  80113a:	83 ec 08             	sub    $0x8,%esp
  80113d:	68 14 5a 80 00       	push   $0x805a14
  801142:	6a 03                	push   $0x3
  801144:	e8 90 07 00 00       	call   8018d9 <cprintf_colored>
  801149:	83 c4 10             	add    $0x10,%esp
	{
		eval = initial_page_allocations();
  80114c:	e8 7d f2 ff ff       	call   8003ce <initial_page_allocations>
  801151:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (eval != 100)
  801154:	83 7d f0 64          	cmpl   $0x64,-0x10(%ebp)
  801158:	74 17                	je     801171 <_main+0x72>
		{
			cprintf_colored(TEXT_TESTERR_CLR,"initial allocations are not correct!\nplease make sure the the kmalloc test is correct before testing the kfree\n");
  80115a:	83 ec 08             	sub    $0x8,%esp
  80115d:	68 40 5a 80 00       	push   $0x805a40
  801162:	6a 0c                	push   $0xc
  801164:	e8 70 07 00 00       	call   8018d9 <cprintf_colored>
  801169:	83 c4 10             	add    $0x10,%esp
			return ;
  80116c:	e9 b2 02 00 00       	jmp    801423 <_main+0x324>
		}
	}
	eval = 0;
  801171:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 pagealloc_end = ACTUAL_PAGE_ALLOC_START + totalRequestedSize ;
  801178:	a1 40 f2 81 00       	mov    0x81f240,%eax
  80117d:	2d 00 f0 ff 7d       	sub    $0x7dfff000,%eax
  801182:	89 45 ec             	mov    %eax,-0x14(%ebp)


	correct = 1;
  801185:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	//2. FREE Some
	cprintf_colored(TEXT_cyan,"%~\n2. Free some allocated spaces from PAGE ALLOCATOR [50%]\n");
  80118c:	83 ec 08             	sub    $0x8,%esp
  80118f:	68 b0 5a 80 00       	push   $0x805ab0
  801194:	6a 03                	push   $0x3
  801196:	e8 3e 07 00 00       	call   8018d9 <cprintf_colored>
  80119b:	83 c4 10             	add    $0x10,%esp
	{
		//3 MB Hole
		correct = freeSpaceInPageAlloc(1, 1);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	6a 01                	push   $0x1
  8011a3:	6a 01                	push   $0x1
  8011a5:	e8 f7 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 10;
  8011b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011b4:	74 04                	je     8011ba <_main+0xbb>
  8011b6:	83 45 f0 0a          	addl   $0xa,-0x10(%ebp)
		correct = 1;
  8011ba:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 4 MB Hole
		correct = freeSpaceInPageAlloc(3, 1);
  8011c1:	83 ec 08             	sub    $0x8,%esp
  8011c4:	6a 01                	push   $0x1
  8011c6:	6a 03                	push   $0x3
  8011c8:	e8 d4 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011cd:	83 c4 10             	add    $0x10,%esp
  8011d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 10;
  8011d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011d7:	74 04                	je     8011dd <_main+0xde>
  8011d9:	83 45 f0 0a          	addl   $0xa,-0x10(%ebp)
		correct = 1;
  8011dd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 1 MB Hole
		correct = freeSpaceInPageAlloc(5, 1);
  8011e4:	83 ec 08             	sub    $0x8,%esp
  8011e7:	6a 01                	push   $0x1
  8011e9:	6a 05                	push   $0x5
  8011eb:	e8 b1 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011f0:	83 c4 10             	add    $0x10,%esp
  8011f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  8011f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011fa:	74 04                	je     801200 <_main+0x101>
  8011fc:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  801200:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 2 MB Hole
		correct = freeSpaceInPageAlloc(7, 1);
  801207:	83 ec 08             	sub    $0x8,%esp
  80120a:	6a 01                	push   $0x1
  80120c:	6a 07                	push   $0x7
  80120e:	e8 8e f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801213:	83 c4 10             	add    $0x10,%esp
  801216:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  801219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80121d:	74 04                	je     801223 <_main+0x124>
  80121f:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  801223:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//1st 3 KB Hole
		correct = freeSpaceInPageAlloc(9, 1);
  80122a:	83 ec 08             	sub    $0x8,%esp
  80122d:	6a 01                	push   $0x1
  80122f:	6a 09                	push   $0x9
  801231:	e8 6b f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  80123c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801240:	74 04                	je     801246 <_main+0x147>
  801242:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  801246:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 3 KB Hole
		correct = freeSpaceInPageAlloc(11, 1);
  80124d:	83 ec 08             	sub    $0x8,%esp
  801250:	6a 01                	push   $0x1
  801252:	6a 0b                	push   $0xb
  801254:	e8 48 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  80125f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801263:	74 04                	je     801269 <_main+0x16a>
  801265:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  801269:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//5 KB Hole (should be merged with prev & next)
		correct = freeSpaceInPageAlloc(10, 1);
  801270:	83 ec 08             	sub    $0x8,%esp
  801273:	6a 01                	push   $0x1
  801275:	6a 0a                	push   $0xa
  801277:	e8 25 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  80127c:	83 c4 10             	add    $0x10,%esp
  80127f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  801282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801286:	74 04                	je     80128c <_main+0x18d>
  801288:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  80128c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//LAST 9 KB Hole (break should be moved down to the begin of alloc#9)
		correct = freeSpaceInPageAlloc(12, 1);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	6a 01                	push   $0x1
  801298:	6a 0c                	push   $0xc
  80129a:	e8 02 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  8012a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012a9:	74 04                	je     8012af <_main+0x1b0>
  8012ab:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  8012af:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}

	//3. Check the move-down of the BREAK
	correct = 1;
  8012b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n3. Check the move-down of the BREAK [20%]\n");
  8012bd:	83 ec 08             	sub    $0x8,%esp
  8012c0:	68 ec 5a 80 00       	push   $0x805aec
  8012c5:	6a 03                	push   $0x3
  8012c7:	e8 0d 06 00 00       	call   8018d9 <cprintf_colored>
  8012cc:	83 c4 10             	add    $0x10,%esp
	{
		uint32 expectedBreak = ACTUAL_PAGE_ALLOC_START + totalRequestedSize - 28*kilo;
  8012cf:	a1 40 f2 81 00       	mov    0x81f240,%eax
  8012d4:	2d 00 60 00 7e       	sub    $0x7e006000,%eax
  8012d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(uheapPageAllocBreak != expectedBreak)
  8012dc:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8012e1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8012e4:	74 1f                	je     801305 <_main+0x206>
		{correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"BREAK value is not correct! Expected = %x, Actual = %x\n", expectedBreak, uheapPageAllocBreak);}
  8012e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8012ed:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8012f2:	50                   	push   %eax
  8012f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8012f6:	68 1c 5b 80 00       	push   $0x805b1c
  8012fb:	6a 0c                	push   $0xc
  8012fd:	e8 d7 05 00 00       	call   8018d9 <cprintf_colored>
  801302:	83 c4 10             	add    $0x10,%esp
	}
	if (correct) eval += 20;
  801305:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801309:	74 04                	je     80130f <_main+0x210>
  80130b:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)

	//4. Test accessing a freed area (processes should be killed by the validation of the fault handler)
	correct = 1;
  80130f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n4. Test accessing a freed area (processes should be killed by the validation of the fault handler) [30%]\n");
  801316:	83 ec 08             	sub    $0x8,%esp
  801319:	68 54 5b 80 00       	push   $0x805b54
  80131e:	6a 03                	push   $0x3
  801320:	e8 b4 05 00 00       	call   8018d9 <cprintf_colored>
  801325:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  801328:	e8 91 31 00 00       	call   8044be <rsttst>
		int ID1 = sys_create_env("tf1_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80132d:	a1 00 72 80 00       	mov    0x807200,%eax
  801332:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  801338:	a1 00 72 80 00       	mov    0x807200,%eax
  80133d:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  801343:	89 c1                	mov    %eax,%ecx
  801345:	a1 00 72 80 00       	mov    0x807200,%eax
  80134a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801350:	52                   	push   %edx
  801351:	51                   	push   %ecx
  801352:	50                   	push   %eax
  801353:	68 c1 5b 80 00       	push   $0x805bc1
  801358:	e8 15 30 00 00       	call   804372 <sys_create_env>
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		sys_run_env(ID1);
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	ff 75 e4             	pushl  -0x1c(%ebp)
  801369:	e8 22 30 00 00       	call   804390 <sys_run_env>
  80136e:	83 c4 10             	add    $0x10,%esp

		//wait until the 1st slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  801371:	90                   	nop
  801372:	e8 c1 31 00 00       	call   804538 <gettst>
  801377:	83 f8 01             	cmp    $0x1,%eax
  80137a:	75 f6                	jne    801372 <_main+0x273>

		int ID2 = sys_create_env("tf1_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80137c:	a1 00 72 80 00       	mov    0x807200,%eax
  801381:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  801387:	a1 00 72 80 00       	mov    0x807200,%eax
  80138c:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  801392:	89 c1                	mov    %eax,%ecx
  801394:	a1 00 72 80 00       	mov    0x807200,%eax
  801399:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80139f:	52                   	push   %edx
  8013a0:	51                   	push   %ecx
  8013a1:	50                   	push   %eax
  8013a2:	68 cc 5b 80 00       	push   $0x805bcc
  8013a7:	e8 c6 2f 00 00       	call   804372 <sys_create_env>
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	89 45 e0             	mov    %eax,-0x20(%ebp)
		sys_run_env(ID2);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8013b8:	e8 d3 2f 00 00       	call   804390 <sys_run_env>
  8013bd:	83 c4 10             	add    $0x10,%esp

		//wait until the 2nd slave finishes the allocation & freeing operations
		while (gettst() != 2) ;
  8013c0:	90                   	nop
  8013c1:	e8 72 31 00 00       	call   804538 <gettst>
  8013c6:	83 f8 02             	cmp    $0x2,%eax
  8013c9:	75 f6                	jne    8013c1 <_main+0x2c2>

		//signal them to start accessing the freed area
		inctst();
  8013cb:	e8 4e 31 00 00       	call   80451e <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(15000);
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	68 98 3a 00 00       	push   $0x3a98
  8013d8:	e8 2d 3d 00 00       	call   80510a <env_sleep>
  8013dd:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  8013e0:	e8 53 31 00 00       	call   804538 <gettst>
  8013e5:	83 f8 03             	cmp    $0x3,%eax
  8013e8:	76 19                	jbe    801403 <_main+0x304>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  8013ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8013f1:	83 ec 08             	sub    $0x8,%esp
  8013f4:	68 d8 5b 80 00       	push   $0x805bd8
  8013f9:	6a 0c                	push   $0xc
  8013fb:	e8 d9 04 00 00       	call   8018d9 <cprintf_colored>
  801400:	83 c4 10             	add    $0x10,%esp
	}
	if (correct)
  801403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801407:	74 04                	je     80140d <_main+0x30e>
	{
		eval += 30;
  801409:	83 45 f0 1e          	addl   $0x1e,-0x10(%ebp)
	}
	cprintf_colored(TEXT_light_green, "%~\ntest free [1] [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);
  80140d:	83 ec 04             	sub    $0x4,%esp
  801410:	ff 75 f0             	pushl  -0x10(%ebp)
  801413:	68 64 5c 80 00       	push   $0x805c64
  801418:	6a 0a                	push   $0xa
  80141a:	e8 ba 04 00 00       	call   8018d9 <cprintf_colored>
  80141f:	83 c4 10             	add    $0x10,%esp

	return;
  801422:	90                   	nop
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	57                   	push   %edi
  801429:	56                   	push   %esi
  80142a:	53                   	push   %ebx
  80142b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80142e:	e8 ad 2f 00 00       	call   8043e0 <sys_getenvindex>
  801433:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801436:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801439:	89 d0                	mov    %edx,%eax
  80143b:	c1 e0 02             	shl    $0x2,%eax
  80143e:	01 d0                	add    %edx,%eax
  801440:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801447:	01 d0                	add    %edx,%eax
  801449:	89 c2                	mov    %eax,%edx
  80144b:	c1 e2 04             	shl    $0x4,%edx
  80144e:	29 c2                	sub    %eax,%edx
  801450:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  801457:	89 c2                	mov    %eax,%edx
  801459:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80145f:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801464:	a1 00 72 80 00       	mov    0x807200,%eax
  801469:	8a 40 20             	mov    0x20(%eax),%al
  80146c:	84 c0                	test   %al,%al
  80146e:	74 0d                	je     80147d <libmain+0x58>
		binaryname = myEnv->prog_name;
  801470:	a1 00 72 80 00       	mov    0x807200,%eax
  801475:	83 c0 20             	add    $0x20,%eax
  801478:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80147d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801481:	7e 0a                	jle    80148d <libmain+0x68>
		binaryname = argv[0];
  801483:	8b 45 0c             	mov    0xc(%ebp),%eax
  801486:	8b 00                	mov    (%eax),%eax
  801488:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	ff 75 0c             	pushl  0xc(%ebp)
  801493:	ff 75 08             	pushl  0x8(%ebp)
  801496:	e8 64 fc ff ff       	call   8010ff <_main>
  80149b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80149e:	a1 00 70 80 00       	mov    0x807000,%eax
  8014a3:	85 c0                	test   %eax,%eax
  8014a5:	0f 84 01 01 00 00    	je     8015ac <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8014ab:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8014b1:	bb 98 5d 80 00       	mov    $0x805d98,%ebx
  8014b6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8014bb:	89 c7                	mov    %eax,%edi
  8014bd:	89 de                	mov    %ebx,%esi
  8014bf:	89 d1                	mov    %edx,%ecx
  8014c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8014c3:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8014c6:	b9 56 00 00 00       	mov    $0x56,%ecx
  8014cb:	b0 00                	mov    $0x0,%al
  8014cd:	89 d7                	mov    %edx,%edi
  8014cf:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8014d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8014d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014db:	83 ec 08             	sub    $0x8,%esp
  8014de:	50                   	push   %eax
  8014df:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8014e5:	50                   	push   %eax
  8014e6:	e8 2b 31 00 00       	call   804616 <sys_utilities>
  8014eb:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8014ee:	e8 74 2c 00 00       	call   804167 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8014f3:	83 ec 0c             	sub    $0xc,%esp
  8014f6:	68 b8 5c 80 00       	push   $0x805cb8
  8014fb:	e8 ac 03 00 00       	call   8018ac <cprintf>
  801500:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801503:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801506:	85 c0                	test   %eax,%eax
  801508:	74 18                	je     801522 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80150a:	e8 25 31 00 00       	call   804634 <sys_get_optimal_num_faults>
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	50                   	push   %eax
  801513:	68 e0 5c 80 00       	push   $0x805ce0
  801518:	e8 8f 03 00 00       	call   8018ac <cprintf>
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	eb 59                	jmp    80157b <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801522:	a1 00 72 80 00       	mov    0x807200,%eax
  801527:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80152d:	a1 00 72 80 00       	mov    0x807200,%eax
  801532:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  801538:	83 ec 04             	sub    $0x4,%esp
  80153b:	52                   	push   %edx
  80153c:	50                   	push   %eax
  80153d:	68 04 5d 80 00       	push   $0x805d04
  801542:	e8 65 03 00 00       	call   8018ac <cprintf>
  801547:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80154a:	a1 00 72 80 00       	mov    0x807200,%eax
  80154f:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  801555:	a1 00 72 80 00       	mov    0x807200,%eax
  80155a:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  801560:	a1 00 72 80 00       	mov    0x807200,%eax
  801565:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80156b:	51                   	push   %ecx
  80156c:	52                   	push   %edx
  80156d:	50                   	push   %eax
  80156e:	68 2c 5d 80 00       	push   $0x805d2c
  801573:	e8 34 03 00 00       	call   8018ac <cprintf>
  801578:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80157b:	a1 00 72 80 00       	mov    0x807200,%eax
  801580:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  801586:	83 ec 08             	sub    $0x8,%esp
  801589:	50                   	push   %eax
  80158a:	68 84 5d 80 00       	push   $0x805d84
  80158f:	e8 18 03 00 00       	call   8018ac <cprintf>
  801594:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801597:	83 ec 0c             	sub    $0xc,%esp
  80159a:	68 b8 5c 80 00       	push   $0x805cb8
  80159f:	e8 08 03 00 00       	call   8018ac <cprintf>
  8015a4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8015a7:	e8 d5 2b 00 00       	call   804181 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8015ac:	e8 1f 00 00 00       	call   8015d0 <exit>
}
  8015b1:	90                   	nop
  8015b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015b5:	5b                   	pop    %ebx
  8015b6:	5e                   	pop    %esi
  8015b7:	5f                   	pop    %edi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    

008015ba <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	6a 00                	push   $0x0
  8015c5:	e8 e2 2d 00 00       	call   8043ac <sys_destroy_env>
  8015ca:	83 c4 10             	add    $0x10,%esp
}
  8015cd:	90                   	nop
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <exit>:

void
exit(void)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8015d6:	e8 37 2e 00 00       	call   804412 <sys_exit_env>
}
  8015db:	90                   	nop
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8015e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8015e7:	83 c0 04             	add    $0x4,%eax
  8015ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8015ed:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	74 16                	je     80160c <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015f6:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  8015fb:	83 ec 08             	sub    $0x8,%esp
  8015fe:	50                   	push   %eax
  8015ff:	68 fc 5d 80 00       	push   $0x805dfc
  801604:	e8 a3 02 00 00       	call   8018ac <cprintf>
  801609:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80160c:	a1 04 70 80 00       	mov    0x807004,%eax
  801611:	83 ec 0c             	sub    $0xc,%esp
  801614:	ff 75 0c             	pushl  0xc(%ebp)
  801617:	ff 75 08             	pushl  0x8(%ebp)
  80161a:	50                   	push   %eax
  80161b:	68 04 5e 80 00       	push   $0x805e04
  801620:	6a 74                	push   $0x74
  801622:	e8 b2 02 00 00       	call   8018d9 <cprintf_colored>
  801627:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80162a:	8b 45 10             	mov    0x10(%ebp),%eax
  80162d:	83 ec 08             	sub    $0x8,%esp
  801630:	ff 75 f4             	pushl  -0xc(%ebp)
  801633:	50                   	push   %eax
  801634:	e8 04 02 00 00       	call   80183d <vcprintf>
  801639:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	6a 00                	push   $0x0
  801641:	68 2c 5e 80 00       	push   $0x805e2c
  801646:	e8 f2 01 00 00       	call   80183d <vcprintf>
  80164b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80164e:	e8 7d ff ff ff       	call   8015d0 <exit>

	// should not return here
	while (1) ;
  801653:	eb fe                	jmp    801653 <_panic+0x75>

00801655 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80165b:	a1 00 72 80 00       	mov    0x807200,%eax
  801660:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	39 c2                	cmp    %eax,%edx
  80166b:	74 14                	je     801681 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80166d:	83 ec 04             	sub    $0x4,%esp
  801670:	68 30 5e 80 00       	push   $0x805e30
  801675:	6a 26                	push   $0x26
  801677:	68 7c 5e 80 00       	push   $0x805e7c
  80167c:	e8 5d ff ff ff       	call   8015de <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801681:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801688:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80168f:	e9 c5 00 00 00       	jmp    801759 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	01 d0                	add    %edx,%eax
  8016a3:	8b 00                	mov    (%eax),%eax
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	75 08                	jne    8016b1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8016a9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8016ac:	e9 a5 00 00 00       	jmp    801756 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8016b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8016bf:	eb 69                	jmp    80172a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8016c1:	a1 00 72 80 00       	mov    0x807200,%eax
  8016c6:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8016cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016cf:	89 d0                	mov    %edx,%eax
  8016d1:	01 c0                	add    %eax,%eax
  8016d3:	01 d0                	add    %edx,%eax
  8016d5:	c1 e0 03             	shl    $0x3,%eax
  8016d8:	01 c8                	add    %ecx,%eax
  8016da:	8a 40 04             	mov    0x4(%eax),%al
  8016dd:	84 c0                	test   %al,%al
  8016df:	75 46                	jne    801727 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016e1:	a1 00 72 80 00       	mov    0x807200,%eax
  8016e6:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8016ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016ef:	89 d0                	mov    %edx,%eax
  8016f1:	01 c0                	add    %eax,%eax
  8016f3:	01 d0                	add    %edx,%eax
  8016f5:	c1 e0 03             	shl    $0x3,%eax
  8016f8:	01 c8                	add    %ecx,%eax
  8016fa:	8b 00                	mov    (%eax),%eax
  8016fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801702:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801707:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	01 c8                	add    %ecx,%eax
  801718:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80171a:	39 c2                	cmp    %eax,%edx
  80171c:	75 09                	jne    801727 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80171e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801725:	eb 15                	jmp    80173c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801727:	ff 45 e8             	incl   -0x18(%ebp)
  80172a:	a1 00 72 80 00       	mov    0x807200,%eax
  80172f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801735:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801738:	39 c2                	cmp    %eax,%edx
  80173a:	77 85                	ja     8016c1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80173c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801740:	75 14                	jne    801756 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801742:	83 ec 04             	sub    $0x4,%esp
  801745:	68 88 5e 80 00       	push   $0x805e88
  80174a:	6a 3a                	push   $0x3a
  80174c:	68 7c 5e 80 00       	push   $0x805e7c
  801751:	e8 88 fe ff ff       	call   8015de <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801756:	ff 45 f0             	incl   -0x10(%ebp)
  801759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80175f:	0f 8c 2f ff ff ff    	jl     801694 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801765:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80176c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801773:	eb 26                	jmp    80179b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801775:	a1 00 72 80 00       	mov    0x807200,%eax
  80177a:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  801780:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801783:	89 d0                	mov    %edx,%eax
  801785:	01 c0                	add    %eax,%eax
  801787:	01 d0                	add    %edx,%eax
  801789:	c1 e0 03             	shl    $0x3,%eax
  80178c:	01 c8                	add    %ecx,%eax
  80178e:	8a 40 04             	mov    0x4(%eax),%al
  801791:	3c 01                	cmp    $0x1,%al
  801793:	75 03                	jne    801798 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801795:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801798:	ff 45 e0             	incl   -0x20(%ebp)
  80179b:	a1 00 72 80 00       	mov    0x807200,%eax
  8017a0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017a9:	39 c2                	cmp    %eax,%edx
  8017ab:	77 c8                	ja     801775 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017b3:	74 14                	je     8017c9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	68 dc 5e 80 00       	push   $0x805edc
  8017bd:	6a 44                	push   $0x44
  8017bf:	68 7c 5e 80 00       	push   $0x805e7c
  8017c4:	e8 15 fe ff ff       	call   8015de <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8017c9:	90                   	nop
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	53                   	push   %ebx
  8017d0:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8017d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d6:	8b 00                	mov    (%eax),%eax
  8017d8:	8d 48 01             	lea    0x1(%eax),%ecx
  8017db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017de:	89 0a                	mov    %ecx,(%edx)
  8017e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e3:	88 d1                	mov    %dl,%cl
  8017e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8017ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ef:	8b 00                	mov    (%eax),%eax
  8017f1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017f6:	75 30                	jne    801828 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8017f8:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  8017fe:	a0 24 72 80 00       	mov    0x807224,%al
  801803:	0f b6 c0             	movzbl %al,%eax
  801806:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801809:	8b 09                	mov    (%ecx),%ecx
  80180b:	89 cb                	mov    %ecx,%ebx
  80180d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801810:	83 c1 08             	add    $0x8,%ecx
  801813:	52                   	push   %edx
  801814:	50                   	push   %eax
  801815:	53                   	push   %ebx
  801816:	51                   	push   %ecx
  801817:	e8 07 29 00 00       	call   804123 <sys_cputs>
  80181c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80181f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801822:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	8b 40 04             	mov    0x4(%eax),%eax
  80182e:	8d 50 01             	lea    0x1(%eax),%edx
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	89 50 04             	mov    %edx,0x4(%eax)
}
  801837:	90                   	nop
  801838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801846:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80184d:	00 00 00 
	b.cnt = 0;
  801850:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801857:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	ff 75 08             	pushl  0x8(%ebp)
  801860:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801866:	50                   	push   %eax
  801867:	68 cc 17 80 00       	push   $0x8017cc
  80186c:	e8 5a 02 00 00       	call   801acb <vprintfmt>
  801871:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801874:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  80187a:	a0 24 72 80 00       	mov    0x807224,%al
  80187f:	0f b6 c0             	movzbl %al,%eax
  801882:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801888:	52                   	push   %edx
  801889:	50                   	push   %eax
  80188a:	51                   	push   %ecx
  80188b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801891:	83 c0 08             	add    $0x8,%eax
  801894:	50                   	push   %eax
  801895:	e8 89 28 00 00       	call   804123 <sys_cputs>
  80189a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80189d:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  8018a4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018b2:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  8018b9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	83 ec 08             	sub    $0x8,%esp
  8018c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c8:	50                   	push   %eax
  8018c9:	e8 6f ff ff ff       	call   80183d <vcprintf>
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8018d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018df:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	c1 e0 08             	shl    $0x8,%eax
  8018ec:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  8018f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018f4:	83 c0 04             	add    $0x4,%eax
  8018f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fd:	83 ec 08             	sub    $0x8,%esp
  801900:	ff 75 f4             	pushl  -0xc(%ebp)
  801903:	50                   	push   %eax
  801904:	e8 34 ff ff ff       	call   80183d <vcprintf>
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80190f:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  801916:	07 00 00 

	return cnt;
  801919:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801924:	e8 3e 28 00 00       	call   804167 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801929:	8d 45 0c             	lea    0xc(%ebp),%eax
  80192c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	83 ec 08             	sub    $0x8,%esp
  801935:	ff 75 f4             	pushl  -0xc(%ebp)
  801938:	50                   	push   %eax
  801939:	e8 ff fe ff ff       	call   80183d <vcprintf>
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801944:	e8 38 28 00 00       	call   804181 <sys_unlock_cons>
	return cnt;
  801949:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	53                   	push   %ebx
  801952:	83 ec 14             	sub    $0x14,%esp
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80195b:	8b 45 14             	mov    0x14(%ebp),%eax
  80195e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801961:	8b 45 18             	mov    0x18(%ebp),%eax
  801964:	ba 00 00 00 00       	mov    $0x0,%edx
  801969:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80196c:	77 55                	ja     8019c3 <printnum+0x75>
  80196e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801971:	72 05                	jb     801978 <printnum+0x2a>
  801973:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801976:	77 4b                	ja     8019c3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801978:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80197b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80197e:	8b 45 18             	mov    0x18(%ebp),%eax
  801981:	ba 00 00 00 00       	mov    $0x0,%edx
  801986:	52                   	push   %edx
  801987:	50                   	push   %eax
  801988:	ff 75 f4             	pushl  -0xc(%ebp)
  80198b:	ff 75 f0             	pushl  -0x10(%ebp)
  80198e:	e8 3d 39 00 00       	call   8052d0 <__udivdi3>
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	ff 75 20             	pushl  0x20(%ebp)
  80199c:	53                   	push   %ebx
  80199d:	ff 75 18             	pushl  0x18(%ebp)
  8019a0:	52                   	push   %edx
  8019a1:	50                   	push   %eax
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	ff 75 08             	pushl  0x8(%ebp)
  8019a8:	e8 a1 ff ff ff       	call   80194e <printnum>
  8019ad:	83 c4 20             	add    $0x20,%esp
  8019b0:	eb 1a                	jmp    8019cc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8019b2:	83 ec 08             	sub    $0x8,%esp
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	ff 75 20             	pushl  0x20(%ebp)
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	ff d0                	call   *%eax
  8019c0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8019c3:	ff 4d 1c             	decl   0x1c(%ebp)
  8019c6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8019ca:	7f e6                	jg     8019b2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8019cc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8019cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019da:	53                   	push   %ebx
  8019db:	51                   	push   %ecx
  8019dc:	52                   	push   %edx
  8019dd:	50                   	push   %eax
  8019de:	e8 fd 39 00 00       	call   8053e0 <__umoddi3>
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	05 54 61 80 00       	add    $0x806154,%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	0f be c0             	movsbl %al,%eax
  8019f0:	83 ec 08             	sub    $0x8,%esp
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	50                   	push   %eax
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	ff d0                	call   *%eax
  8019fc:	83 c4 10             	add    $0x10,%esp
}
  8019ff:	90                   	nop
  801a00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a08:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a0c:	7e 1c                	jle    801a2a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	8b 00                	mov    (%eax),%eax
  801a13:	8d 50 08             	lea    0x8(%eax),%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	89 10                	mov    %edx,(%eax)
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	8b 00                	mov    (%eax),%eax
  801a20:	83 e8 08             	sub    $0x8,%eax
  801a23:	8b 50 04             	mov    0x4(%eax),%edx
  801a26:	8b 00                	mov    (%eax),%eax
  801a28:	eb 40                	jmp    801a6a <getuint+0x65>
	else if (lflag)
  801a2a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a2e:	74 1e                	je     801a4e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	8b 00                	mov    (%eax),%eax
  801a35:	8d 50 04             	lea    0x4(%eax),%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	89 10                	mov    %edx,(%eax)
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	8b 00                	mov    (%eax),%eax
  801a42:	83 e8 04             	sub    $0x4,%eax
  801a45:	8b 00                	mov    (%eax),%eax
  801a47:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4c:	eb 1c                	jmp    801a6a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	8b 00                	mov    (%eax),%eax
  801a53:	8d 50 04             	lea    0x4(%eax),%edx
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	89 10                	mov    %edx,(%eax)
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	8b 00                	mov    (%eax),%eax
  801a60:	83 e8 04             	sub    $0x4,%eax
  801a63:	8b 00                	mov    (%eax),%eax
  801a65:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a6a:	5d                   	pop    %ebp
  801a6b:	c3                   	ret    

00801a6c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a6f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a73:	7e 1c                	jle    801a91 <getint+0x25>
		return va_arg(*ap, long long);
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	8b 00                	mov    (%eax),%eax
  801a7a:	8d 50 08             	lea    0x8(%eax),%edx
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	89 10                	mov    %edx,(%eax)
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	8b 00                	mov    (%eax),%eax
  801a87:	83 e8 08             	sub    $0x8,%eax
  801a8a:	8b 50 04             	mov    0x4(%eax),%edx
  801a8d:	8b 00                	mov    (%eax),%eax
  801a8f:	eb 38                	jmp    801ac9 <getint+0x5d>
	else if (lflag)
  801a91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a95:	74 1a                	je     801ab1 <getint+0x45>
		return va_arg(*ap, long);
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	8b 00                	mov    (%eax),%eax
  801a9c:	8d 50 04             	lea    0x4(%eax),%edx
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	89 10                	mov    %edx,(%eax)
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	8b 00                	mov    (%eax),%eax
  801aa9:	83 e8 04             	sub    $0x4,%eax
  801aac:	8b 00                	mov    (%eax),%eax
  801aae:	99                   	cltd   
  801aaf:	eb 18                	jmp    801ac9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	8b 00                	mov    (%eax),%eax
  801ab6:	8d 50 04             	lea    0x4(%eax),%edx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	89 10                	mov    %edx,(%eax)
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	8b 00                	mov    (%eax),%eax
  801ac3:	83 e8 04             	sub    $0x4,%eax
  801ac6:	8b 00                	mov    (%eax),%eax
  801ac8:	99                   	cltd   
}
  801ac9:	5d                   	pop    %ebp
  801aca:	c3                   	ret    

00801acb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	56                   	push   %esi
  801acf:	53                   	push   %ebx
  801ad0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ad3:	eb 17                	jmp    801aec <vprintfmt+0x21>
			if (ch == '\0')
  801ad5:	85 db                	test   %ebx,%ebx
  801ad7:	0f 84 c1 03 00 00    	je     801e9e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801add:	83 ec 08             	sub    $0x8,%esp
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	53                   	push   %ebx
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	ff d0                	call   *%eax
  801ae9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801aec:	8b 45 10             	mov    0x10(%ebp),%eax
  801aef:	8d 50 01             	lea    0x1(%eax),%edx
  801af2:	89 55 10             	mov    %edx,0x10(%ebp)
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	0f b6 d8             	movzbl %al,%ebx
  801afa:	83 fb 25             	cmp    $0x25,%ebx
  801afd:	75 d6                	jne    801ad5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801aff:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801b03:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801b0a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801b11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801b18:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b22:	8d 50 01             	lea    0x1(%eax),%edx
  801b25:	89 55 10             	mov    %edx,0x10(%ebp)
  801b28:	8a 00                	mov    (%eax),%al
  801b2a:	0f b6 d8             	movzbl %al,%ebx
  801b2d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801b30:	83 f8 5b             	cmp    $0x5b,%eax
  801b33:	0f 87 3d 03 00 00    	ja     801e76 <vprintfmt+0x3ab>
  801b39:	8b 04 85 78 61 80 00 	mov    0x806178(,%eax,4),%eax
  801b40:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801b42:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801b46:	eb d7                	jmp    801b1f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b48:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801b4c:	eb d1                	jmp    801b1f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b4e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801b55:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b58:	89 d0                	mov    %edx,%eax
  801b5a:	c1 e0 02             	shl    $0x2,%eax
  801b5d:	01 d0                	add    %edx,%eax
  801b5f:	01 c0                	add    %eax,%eax
  801b61:	01 d8                	add    %ebx,%eax
  801b63:	83 e8 30             	sub    $0x30,%eax
  801b66:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801b69:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6c:	8a 00                	mov    (%eax),%al
  801b6e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801b71:	83 fb 2f             	cmp    $0x2f,%ebx
  801b74:	7e 3e                	jle    801bb4 <vprintfmt+0xe9>
  801b76:	83 fb 39             	cmp    $0x39,%ebx
  801b79:	7f 39                	jg     801bb4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b7b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b7e:	eb d5                	jmp    801b55 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b80:	8b 45 14             	mov    0x14(%ebp),%eax
  801b83:	83 c0 04             	add    $0x4,%eax
  801b86:	89 45 14             	mov    %eax,0x14(%ebp)
  801b89:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8c:	83 e8 04             	sub    $0x4,%eax
  801b8f:	8b 00                	mov    (%eax),%eax
  801b91:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b94:	eb 1f                	jmp    801bb5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b9a:	79 83                	jns    801b1f <vprintfmt+0x54>
				width = 0;
  801b9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801ba3:	e9 77 ff ff ff       	jmp    801b1f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801ba8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801baf:	e9 6b ff ff ff       	jmp    801b1f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801bb4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801bb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bb9:	0f 89 60 ff ff ff    	jns    801b1f <vprintfmt+0x54>
				width = precision, precision = -1;
  801bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bc5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801bcc:	e9 4e ff ff ff       	jmp    801b1f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801bd1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801bd4:	e9 46 ff ff ff       	jmp    801b1f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801bd9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bdc:	83 c0 04             	add    $0x4,%eax
  801bdf:	89 45 14             	mov    %eax,0x14(%ebp)
  801be2:	8b 45 14             	mov    0x14(%ebp),%eax
  801be5:	83 e8 04             	sub    $0x4,%eax
  801be8:	8b 00                	mov    (%eax),%eax
  801bea:	83 ec 08             	sub    $0x8,%esp
  801bed:	ff 75 0c             	pushl  0xc(%ebp)
  801bf0:	50                   	push   %eax
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	ff d0                	call   *%eax
  801bf6:	83 c4 10             	add    $0x10,%esp
			break;
  801bf9:	e9 9b 02 00 00       	jmp    801e99 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801c01:	83 c0 04             	add    $0x4,%eax
  801c04:	89 45 14             	mov    %eax,0x14(%ebp)
  801c07:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0a:	83 e8 04             	sub    $0x4,%eax
  801c0d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801c0f:	85 db                	test   %ebx,%ebx
  801c11:	79 02                	jns    801c15 <vprintfmt+0x14a>
				err = -err;
  801c13:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801c15:	83 fb 64             	cmp    $0x64,%ebx
  801c18:	7f 0b                	jg     801c25 <vprintfmt+0x15a>
  801c1a:	8b 34 9d c0 5f 80 00 	mov    0x805fc0(,%ebx,4),%esi
  801c21:	85 f6                	test   %esi,%esi
  801c23:	75 19                	jne    801c3e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801c25:	53                   	push   %ebx
  801c26:	68 65 61 80 00       	push   $0x806165
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	ff 75 08             	pushl  0x8(%ebp)
  801c31:	e8 70 02 00 00       	call   801ea6 <printfmt>
  801c36:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801c39:	e9 5b 02 00 00       	jmp    801e99 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801c3e:	56                   	push   %esi
  801c3f:	68 6e 61 80 00       	push   $0x80616e
  801c44:	ff 75 0c             	pushl  0xc(%ebp)
  801c47:	ff 75 08             	pushl  0x8(%ebp)
  801c4a:	e8 57 02 00 00       	call   801ea6 <printfmt>
  801c4f:	83 c4 10             	add    $0x10,%esp
			break;
  801c52:	e9 42 02 00 00       	jmp    801e99 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c57:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5a:	83 c0 04             	add    $0x4,%eax
  801c5d:	89 45 14             	mov    %eax,0x14(%ebp)
  801c60:	8b 45 14             	mov    0x14(%ebp),%eax
  801c63:	83 e8 04             	sub    $0x4,%eax
  801c66:	8b 30                	mov    (%eax),%esi
  801c68:	85 f6                	test   %esi,%esi
  801c6a:	75 05                	jne    801c71 <vprintfmt+0x1a6>
				p = "(null)";
  801c6c:	be 71 61 80 00       	mov    $0x806171,%esi
			if (width > 0 && padc != '-')
  801c71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c75:	7e 6d                	jle    801ce4 <vprintfmt+0x219>
  801c77:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c7b:	74 67                	je     801ce4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c80:	83 ec 08             	sub    $0x8,%esp
  801c83:	50                   	push   %eax
  801c84:	56                   	push   %esi
  801c85:	e8 1e 03 00 00       	call   801fa8 <strnlen>
  801c8a:	83 c4 10             	add    $0x10,%esp
  801c8d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c90:	eb 16                	jmp    801ca8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c92:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c96:	83 ec 08             	sub    $0x8,%esp
  801c99:	ff 75 0c             	pushl  0xc(%ebp)
  801c9c:	50                   	push   %eax
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	ff d0                	call   *%eax
  801ca2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801ca5:	ff 4d e4             	decl   -0x1c(%ebp)
  801ca8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cac:	7f e4                	jg     801c92 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801cae:	eb 34                	jmp    801ce4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801cb0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801cb4:	74 1c                	je     801cd2 <vprintfmt+0x207>
  801cb6:	83 fb 1f             	cmp    $0x1f,%ebx
  801cb9:	7e 05                	jle    801cc0 <vprintfmt+0x1f5>
  801cbb:	83 fb 7e             	cmp    $0x7e,%ebx
  801cbe:	7e 12                	jle    801cd2 <vprintfmt+0x207>
					putch('?', putdat);
  801cc0:	83 ec 08             	sub    $0x8,%esp
  801cc3:	ff 75 0c             	pushl  0xc(%ebp)
  801cc6:	6a 3f                	push   $0x3f
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	ff d0                	call   *%eax
  801ccd:	83 c4 10             	add    $0x10,%esp
  801cd0:	eb 0f                	jmp    801ce1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801cd2:	83 ec 08             	sub    $0x8,%esp
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	53                   	push   %ebx
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	ff d0                	call   *%eax
  801cde:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ce1:	ff 4d e4             	decl   -0x1c(%ebp)
  801ce4:	89 f0                	mov    %esi,%eax
  801ce6:	8d 70 01             	lea    0x1(%eax),%esi
  801ce9:	8a 00                	mov    (%eax),%al
  801ceb:	0f be d8             	movsbl %al,%ebx
  801cee:	85 db                	test   %ebx,%ebx
  801cf0:	74 24                	je     801d16 <vprintfmt+0x24b>
  801cf2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cf6:	78 b8                	js     801cb0 <vprintfmt+0x1e5>
  801cf8:	ff 4d e0             	decl   -0x20(%ebp)
  801cfb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cff:	79 af                	jns    801cb0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d01:	eb 13                	jmp    801d16 <vprintfmt+0x24b>
				putch(' ', putdat);
  801d03:	83 ec 08             	sub    $0x8,%esp
  801d06:	ff 75 0c             	pushl  0xc(%ebp)
  801d09:	6a 20                	push   $0x20
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	ff d0                	call   *%eax
  801d10:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d13:	ff 4d e4             	decl   -0x1c(%ebp)
  801d16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d1a:	7f e7                	jg     801d03 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801d1c:	e9 78 01 00 00       	jmp    801e99 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d21:	83 ec 08             	sub    $0x8,%esp
  801d24:	ff 75 e8             	pushl  -0x18(%ebp)
  801d27:	8d 45 14             	lea    0x14(%ebp),%eax
  801d2a:	50                   	push   %eax
  801d2b:	e8 3c fd ff ff       	call   801a6c <getint>
  801d30:	83 c4 10             	add    $0x10,%esp
  801d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d36:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3f:	85 d2                	test   %edx,%edx
  801d41:	79 23                	jns    801d66 <vprintfmt+0x29b>
				putch('-', putdat);
  801d43:	83 ec 08             	sub    $0x8,%esp
  801d46:	ff 75 0c             	pushl  0xc(%ebp)
  801d49:	6a 2d                	push   $0x2d
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	ff d0                	call   *%eax
  801d50:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d59:	f7 d8                	neg    %eax
  801d5b:	83 d2 00             	adc    $0x0,%edx
  801d5e:	f7 da                	neg    %edx
  801d60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801d66:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d6d:	e9 bc 00 00 00       	jmp    801e2e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d72:	83 ec 08             	sub    $0x8,%esp
  801d75:	ff 75 e8             	pushl  -0x18(%ebp)
  801d78:	8d 45 14             	lea    0x14(%ebp),%eax
  801d7b:	50                   	push   %eax
  801d7c:	e8 84 fc ff ff       	call   801a05 <getuint>
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d87:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d8a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d91:	e9 98 00 00 00       	jmp    801e2e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d96:	83 ec 08             	sub    $0x8,%esp
  801d99:	ff 75 0c             	pushl  0xc(%ebp)
  801d9c:	6a 58                	push   $0x58
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	ff d0                	call   *%eax
  801da3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801da6:	83 ec 08             	sub    $0x8,%esp
  801da9:	ff 75 0c             	pushl  0xc(%ebp)
  801dac:	6a 58                	push   $0x58
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	ff d0                	call   *%eax
  801db3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801db6:	83 ec 08             	sub    $0x8,%esp
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	6a 58                	push   $0x58
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	ff d0                	call   *%eax
  801dc3:	83 c4 10             	add    $0x10,%esp
			break;
  801dc6:	e9 ce 00 00 00       	jmp    801e99 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801dcb:	83 ec 08             	sub    $0x8,%esp
  801dce:	ff 75 0c             	pushl  0xc(%ebp)
  801dd1:	6a 30                	push   $0x30
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	ff d0                	call   *%eax
  801dd8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801ddb:	83 ec 08             	sub    $0x8,%esp
  801dde:	ff 75 0c             	pushl  0xc(%ebp)
  801de1:	6a 78                	push   $0x78
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	ff d0                	call   *%eax
  801de8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801deb:	8b 45 14             	mov    0x14(%ebp),%eax
  801dee:	83 c0 04             	add    $0x4,%eax
  801df1:	89 45 14             	mov    %eax,0x14(%ebp)
  801df4:	8b 45 14             	mov    0x14(%ebp),%eax
  801df7:	83 e8 04             	sub    $0x4,%eax
  801dfa:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801dfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801e06:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801e0d:	eb 1f                	jmp    801e2e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801e0f:	83 ec 08             	sub    $0x8,%esp
  801e12:	ff 75 e8             	pushl  -0x18(%ebp)
  801e15:	8d 45 14             	lea    0x14(%ebp),%eax
  801e18:	50                   	push   %eax
  801e19:	e8 e7 fb ff ff       	call   801a05 <getuint>
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801e27:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e2e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801e32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e35:	83 ec 04             	sub    $0x4,%esp
  801e38:	52                   	push   %edx
  801e39:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e3c:	50                   	push   %eax
  801e3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e40:	ff 75 f0             	pushl  -0x10(%ebp)
  801e43:	ff 75 0c             	pushl  0xc(%ebp)
  801e46:	ff 75 08             	pushl  0x8(%ebp)
  801e49:	e8 00 fb ff ff       	call   80194e <printnum>
  801e4e:	83 c4 20             	add    $0x20,%esp
			break;
  801e51:	eb 46                	jmp    801e99 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e53:	83 ec 08             	sub    $0x8,%esp
  801e56:	ff 75 0c             	pushl  0xc(%ebp)
  801e59:	53                   	push   %ebx
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	ff d0                	call   *%eax
  801e5f:	83 c4 10             	add    $0x10,%esp
			break;
  801e62:	eb 35                	jmp    801e99 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801e64:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  801e6b:	eb 2c                	jmp    801e99 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801e6d:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  801e74:	eb 23                	jmp    801e99 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e76:	83 ec 08             	sub    $0x8,%esp
  801e79:	ff 75 0c             	pushl  0xc(%ebp)
  801e7c:	6a 25                	push   $0x25
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	ff d0                	call   *%eax
  801e83:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e86:	ff 4d 10             	decl   0x10(%ebp)
  801e89:	eb 03                	jmp    801e8e <vprintfmt+0x3c3>
  801e8b:	ff 4d 10             	decl   0x10(%ebp)
  801e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e91:	48                   	dec    %eax
  801e92:	8a 00                	mov    (%eax),%al
  801e94:	3c 25                	cmp    $0x25,%al
  801e96:	75 f3                	jne    801e8b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e98:	90                   	nop
		}
	}
  801e99:	e9 35 fc ff ff       	jmp    801ad3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e9e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea2:	5b                   	pop    %ebx
  801ea3:	5e                   	pop    %esi
  801ea4:	5d                   	pop    %ebp
  801ea5:	c3                   	ret    

00801ea6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801eac:	8d 45 10             	lea    0x10(%ebp),%eax
  801eaf:	83 c0 04             	add    $0x4,%eax
  801eb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebb:	50                   	push   %eax
  801ebc:	ff 75 0c             	pushl  0xc(%ebp)
  801ebf:	ff 75 08             	pushl  0x8(%ebp)
  801ec2:	e8 04 fc ff ff       	call   801acb <vprintfmt>
  801ec7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801eca:	90                   	nop
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed3:	8b 40 08             	mov    0x8(%eax),%eax
  801ed6:	8d 50 01             	lea    0x1(%eax),%edx
  801ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee2:	8b 10                	mov    (%eax),%edx
  801ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee7:	8b 40 04             	mov    0x4(%eax),%eax
  801eea:	39 c2                	cmp    %eax,%edx
  801eec:	73 12                	jae    801f00 <sprintputch+0x33>
		*b->buf++ = ch;
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	8b 00                	mov    (%eax),%eax
  801ef3:	8d 48 01             	lea    0x1(%eax),%ecx
  801ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef9:	89 0a                	mov    %ecx,(%edx)
  801efb:	8b 55 08             	mov    0x8(%ebp),%edx
  801efe:	88 10                	mov    %dl,(%eax)
}
  801f00:	90                   	nop
  801f01:	5d                   	pop    %ebp
  801f02:	c3                   	ret    

00801f03 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	01 d0                	add    %edx,%eax
  801f1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f28:	74 06                	je     801f30 <vsnprintf+0x2d>
  801f2a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f2e:	7f 07                	jg     801f37 <vsnprintf+0x34>
		return -E_INVAL;
  801f30:	b8 03 00 00 00       	mov    $0x3,%eax
  801f35:	eb 20                	jmp    801f57 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f37:	ff 75 14             	pushl  0x14(%ebp)
  801f3a:	ff 75 10             	pushl  0x10(%ebp)
  801f3d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f40:	50                   	push   %eax
  801f41:	68 cd 1e 80 00       	push   $0x801ecd
  801f46:	e8 80 fb ff ff       	call   801acb <vprintfmt>
  801f4b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f51:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f5f:	8d 45 10             	lea    0x10(%ebp),%eax
  801f62:	83 c0 04             	add    $0x4,%eax
  801f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801f68:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6e:	50                   	push   %eax
  801f6f:	ff 75 0c             	pushl  0xc(%ebp)
  801f72:	ff 75 08             	pushl  0x8(%ebp)
  801f75:	e8 89 ff ff ff       	call   801f03 <vsnprintf>
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f92:	eb 06                	jmp    801f9a <strlen+0x15>
		n++;
  801f94:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f97:	ff 45 08             	incl   0x8(%ebp)
  801f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9d:	8a 00                	mov    (%eax),%al
  801f9f:	84 c0                	test   %al,%al
  801fa1:	75 f1                	jne    801f94 <strlen+0xf>
		n++;
	return n;
  801fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fb5:	eb 09                	jmp    801fc0 <strnlen+0x18>
		n++;
  801fb7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fba:	ff 45 08             	incl   0x8(%ebp)
  801fbd:	ff 4d 0c             	decl   0xc(%ebp)
  801fc0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fc4:	74 09                	je     801fcf <strnlen+0x27>
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	8a 00                	mov    (%eax),%al
  801fcb:	84 c0                	test   %al,%al
  801fcd:	75 e8                	jne    801fb7 <strnlen+0xf>
		n++;
	return n;
  801fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801fe0:	90                   	nop
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	8d 50 01             	lea    0x1(%eax),%edx
  801fe7:	89 55 08             	mov    %edx,0x8(%ebp)
  801fea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fed:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ff0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801ff3:	8a 12                	mov    (%edx),%dl
  801ff5:	88 10                	mov    %dl,(%eax)
  801ff7:	8a 00                	mov    (%eax),%al
  801ff9:	84 c0                	test   %al,%al
  801ffb:	75 e4                	jne    801fe1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80200e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802015:	eb 1f                	jmp    802036 <strncpy+0x34>
		*dst++ = *src;
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	8d 50 01             	lea    0x1(%eax),%edx
  80201d:	89 55 08             	mov    %edx,0x8(%ebp)
  802020:	8b 55 0c             	mov    0xc(%ebp),%edx
  802023:	8a 12                	mov    (%edx),%dl
  802025:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202a:	8a 00                	mov    (%eax),%al
  80202c:	84 c0                	test   %al,%al
  80202e:	74 03                	je     802033 <strncpy+0x31>
			src++;
  802030:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802033:	ff 45 fc             	incl   -0x4(%ebp)
  802036:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802039:	3b 45 10             	cmp    0x10(%ebp),%eax
  80203c:	72 d9                	jb     802017 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80203e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80204f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802053:	74 30                	je     802085 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802055:	eb 16                	jmp    80206d <strlcpy+0x2a>
			*dst++ = *src++;
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	8d 50 01             	lea    0x1(%eax),%edx
  80205d:	89 55 08             	mov    %edx,0x8(%ebp)
  802060:	8b 55 0c             	mov    0xc(%ebp),%edx
  802063:	8d 4a 01             	lea    0x1(%edx),%ecx
  802066:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802069:	8a 12                	mov    (%edx),%dl
  80206b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80206d:	ff 4d 10             	decl   0x10(%ebp)
  802070:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802074:	74 09                	je     80207f <strlcpy+0x3c>
  802076:	8b 45 0c             	mov    0xc(%ebp),%eax
  802079:	8a 00                	mov    (%eax),%al
  80207b:	84 c0                	test   %al,%al
  80207d:	75 d8                	jne    802057 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802085:	8b 55 08             	mov    0x8(%ebp),%edx
  802088:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80208b:	29 c2                	sub    %eax,%edx
  80208d:	89 d0                	mov    %edx,%eax
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802094:	eb 06                	jmp    80209c <strcmp+0xb>
		p++, q++;
  802096:	ff 45 08             	incl   0x8(%ebp)
  802099:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	8a 00                	mov    (%eax),%al
  8020a1:	84 c0                	test   %al,%al
  8020a3:	74 0e                	je     8020b3 <strcmp+0x22>
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	8a 10                	mov    (%eax),%dl
  8020aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ad:	8a 00                	mov    (%eax),%al
  8020af:	38 c2                	cmp    %al,%dl
  8020b1:	74 e3                	je     802096 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	8a 00                	mov    (%eax),%al
  8020b8:	0f b6 d0             	movzbl %al,%edx
  8020bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020be:	8a 00                	mov    (%eax),%al
  8020c0:	0f b6 c0             	movzbl %al,%eax
  8020c3:	29 c2                	sub    %eax,%edx
  8020c5:	89 d0                	mov    %edx,%eax
}
  8020c7:	5d                   	pop    %ebp
  8020c8:	c3                   	ret    

008020c9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8020cc:	eb 09                	jmp    8020d7 <strncmp+0xe>
		n--, p++, q++;
  8020ce:	ff 4d 10             	decl   0x10(%ebp)
  8020d1:	ff 45 08             	incl   0x8(%ebp)
  8020d4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8020d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020db:	74 17                	je     8020f4 <strncmp+0x2b>
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	8a 00                	mov    (%eax),%al
  8020e2:	84 c0                	test   %al,%al
  8020e4:	74 0e                	je     8020f4 <strncmp+0x2b>
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	8a 10                	mov    (%eax),%dl
  8020eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ee:	8a 00                	mov    (%eax),%al
  8020f0:	38 c2                	cmp    %al,%dl
  8020f2:	74 da                	je     8020ce <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8020f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020f8:	75 07                	jne    802101 <strncmp+0x38>
		return 0;
  8020fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ff:	eb 14                	jmp    802115 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	8a 00                	mov    (%eax),%al
  802106:	0f b6 d0             	movzbl %al,%edx
  802109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210c:	8a 00                	mov    (%eax),%al
  80210e:	0f b6 c0             	movzbl %al,%eax
  802111:	29 c2                	sub    %eax,%edx
  802113:	89 d0                	mov    %edx,%eax
}
  802115:	5d                   	pop    %ebp
  802116:	c3                   	ret    

00802117 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	83 ec 04             	sub    $0x4,%esp
  80211d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802120:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802123:	eb 12                	jmp    802137 <strchr+0x20>
		if (*s == c)
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	8a 00                	mov    (%eax),%al
  80212a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80212d:	75 05                	jne    802134 <strchr+0x1d>
			return (char *) s;
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	eb 11                	jmp    802145 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802134:	ff 45 08             	incl   0x8(%ebp)
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	8a 00                	mov    (%eax),%al
  80213c:	84 c0                	test   %al,%al
  80213e:	75 e5                	jne    802125 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	83 ec 04             	sub    $0x4,%esp
  80214d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802150:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802153:	eb 0d                	jmp    802162 <strfind+0x1b>
		if (*s == c)
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	8a 00                	mov    (%eax),%al
  80215a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80215d:	74 0e                	je     80216d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80215f:	ff 45 08             	incl   0x8(%ebp)
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	8a 00                	mov    (%eax),%al
  802167:	84 c0                	test   %al,%al
  802169:	75 ea                	jne    802155 <strfind+0xe>
  80216b:	eb 01                	jmp    80216e <strfind+0x27>
		if (*s == c)
			break;
  80216d:	90                   	nop
	return (char *) s;
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80217f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802183:	76 63                	jbe    8021e8 <memset+0x75>
		uint64 data_block = c;
  802185:	8b 45 0c             	mov    0xc(%ebp),%eax
  802188:	99                   	cltd   
  802189:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80218c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80218f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802195:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802199:	c1 e0 08             	shl    $0x8,%eax
  80219c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80219f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8021a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8021ac:	c1 e0 10             	shl    $0x10,%eax
  8021af:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021b2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8021b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bb:	89 c2                	mov    %eax,%edx
  8021bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021c5:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8021c8:	eb 18                	jmp    8021e2 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8021ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021cd:	8d 41 08             	lea    0x8(%ecx),%eax
  8021d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d9:	89 01                	mov    %eax,(%ecx)
  8021db:	89 51 04             	mov    %edx,0x4(%ecx)
  8021de:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8021e2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021e6:	77 e2                	ja     8021ca <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8021e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021ec:	74 23                	je     802211 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8021ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8021f4:	eb 0e                	jmp    802204 <memset+0x91>
			*p8++ = (uint8)c;
  8021f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021f9:	8d 50 01             	lea    0x1(%eax),%edx
  8021fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802202:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  802204:	8b 45 10             	mov    0x10(%ebp),%eax
  802207:	8d 50 ff             	lea    -0x1(%eax),%edx
  80220a:	89 55 10             	mov    %edx,0x10(%ebp)
  80220d:	85 c0                	test   %eax,%eax
  80220f:	75 e5                	jne    8021f6 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80221c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  802228:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80222c:	76 24                	jbe    802252 <memcpy+0x3c>
		while(n >= 8){
  80222e:	eb 1c                	jmp    80224c <memcpy+0x36>
			*d64 = *s64;
  802230:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802233:	8b 50 04             	mov    0x4(%eax),%edx
  802236:	8b 00                	mov    (%eax),%eax
  802238:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80223b:	89 01                	mov    %eax,(%ecx)
  80223d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802240:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  802244:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  802248:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80224c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802250:	77 de                	ja     802230 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802252:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802256:	74 31                	je     802289 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802258:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80225b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80225e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802261:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802264:	eb 16                	jmp    80227c <memcpy+0x66>
			*d8++ = *s8++;
  802266:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802269:	8d 50 01             	lea    0x1(%eax),%edx
  80226c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80226f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802272:	8d 4a 01             	lea    0x1(%edx),%ecx
  802275:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802278:	8a 12                	mov    (%edx),%dl
  80227a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80227c:	8b 45 10             	mov    0x10(%ebp),%eax
  80227f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802282:	89 55 10             	mov    %edx,0x10(%ebp)
  802285:	85 c0                	test   %eax,%eax
  802287:	75 dd                	jne    802266 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802294:	8b 45 0c             	mov    0xc(%ebp),%eax
  802297:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8022a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8022a6:	73 50                	jae    8022f8 <memmove+0x6a>
  8022a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ae:	01 d0                	add    %edx,%eax
  8022b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8022b3:	76 43                	jbe    8022f8 <memmove+0x6a>
		s += n;
  8022b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8022bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8022be:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8022c1:	eb 10                	jmp    8022d3 <memmove+0x45>
			*--d = *--s;
  8022c3:	ff 4d f8             	decl   -0x8(%ebp)
  8022c6:	ff 4d fc             	decl   -0x4(%ebp)
  8022c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022cc:	8a 10                	mov    (%eax),%dl
  8022ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022d1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8022d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	75 e3                	jne    8022c3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8022e0:	eb 23                	jmp    802305 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8022e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022e5:	8d 50 01             	lea    0x1(%eax),%edx
  8022e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022f1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8022f4:	8a 12                	mov    (%edx),%dl
  8022f6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8022f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022fe:	89 55 10             	mov    %edx,0x10(%ebp)
  802301:	85 c0                	test   %eax,%eax
  802303:	75 dd                	jne    8022e2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
  80230d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802316:	8b 45 0c             	mov    0xc(%ebp),%eax
  802319:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80231c:	eb 2a                	jmp    802348 <memcmp+0x3e>
		if (*s1 != *s2)
  80231e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802321:	8a 10                	mov    (%eax),%dl
  802323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802326:	8a 00                	mov    (%eax),%al
  802328:	38 c2                	cmp    %al,%dl
  80232a:	74 16                	je     802342 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80232c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80232f:	8a 00                	mov    (%eax),%al
  802331:	0f b6 d0             	movzbl %al,%edx
  802334:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802337:	8a 00                	mov    (%eax),%al
  802339:	0f b6 c0             	movzbl %al,%eax
  80233c:	29 c2                	sub    %eax,%edx
  80233e:	89 d0                	mov    %edx,%eax
  802340:	eb 18                	jmp    80235a <memcmp+0x50>
		s1++, s2++;
  802342:	ff 45 fc             	incl   -0x4(%ebp)
  802345:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802348:	8b 45 10             	mov    0x10(%ebp),%eax
  80234b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80234e:	89 55 10             	mov    %edx,0x10(%ebp)
  802351:	85 c0                	test   %eax,%eax
  802353:	75 c9                	jne    80231e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802355:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802362:	8b 55 08             	mov    0x8(%ebp),%edx
  802365:	8b 45 10             	mov    0x10(%ebp),%eax
  802368:	01 d0                	add    %edx,%eax
  80236a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80236d:	eb 15                	jmp    802384 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	8a 00                	mov    (%eax),%al
  802374:	0f b6 d0             	movzbl %al,%edx
  802377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237a:	0f b6 c0             	movzbl %al,%eax
  80237d:	39 c2                	cmp    %eax,%edx
  80237f:	74 0d                	je     80238e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802381:	ff 45 08             	incl   0x8(%ebp)
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80238a:	72 e3                	jb     80236f <memfind+0x13>
  80238c:	eb 01                	jmp    80238f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80238e:	90                   	nop
	return (void *) s;
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80239a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8023a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023a8:	eb 03                	jmp    8023ad <strtol+0x19>
		s++;
  8023aa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	8a 00                	mov    (%eax),%al
  8023b2:	3c 20                	cmp    $0x20,%al
  8023b4:	74 f4                	je     8023aa <strtol+0x16>
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	8a 00                	mov    (%eax),%al
  8023bb:	3c 09                	cmp    $0x9,%al
  8023bd:	74 eb                	je     8023aa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	8a 00                	mov    (%eax),%al
  8023c4:	3c 2b                	cmp    $0x2b,%al
  8023c6:	75 05                	jne    8023cd <strtol+0x39>
		s++;
  8023c8:	ff 45 08             	incl   0x8(%ebp)
  8023cb:	eb 13                	jmp    8023e0 <strtol+0x4c>
	else if (*s == '-')
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8a 00                	mov    (%eax),%al
  8023d2:	3c 2d                	cmp    $0x2d,%al
  8023d4:	75 0a                	jne    8023e0 <strtol+0x4c>
		s++, neg = 1;
  8023d6:	ff 45 08             	incl   0x8(%ebp)
  8023d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8023e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023e4:	74 06                	je     8023ec <strtol+0x58>
  8023e6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8023ea:	75 20                	jne    80240c <strtol+0x78>
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	8a 00                	mov    (%eax),%al
  8023f1:	3c 30                	cmp    $0x30,%al
  8023f3:	75 17                	jne    80240c <strtol+0x78>
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	40                   	inc    %eax
  8023f9:	8a 00                	mov    (%eax),%al
  8023fb:	3c 78                	cmp    $0x78,%al
  8023fd:	75 0d                	jne    80240c <strtol+0x78>
		s += 2, base = 16;
  8023ff:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802403:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80240a:	eb 28                	jmp    802434 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80240c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802410:	75 15                	jne    802427 <strtol+0x93>
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	8a 00                	mov    (%eax),%al
  802417:	3c 30                	cmp    $0x30,%al
  802419:	75 0c                	jne    802427 <strtol+0x93>
		s++, base = 8;
  80241b:	ff 45 08             	incl   0x8(%ebp)
  80241e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802425:	eb 0d                	jmp    802434 <strtol+0xa0>
	else if (base == 0)
  802427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80242b:	75 07                	jne    802434 <strtol+0xa0>
		base = 10;
  80242d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	8a 00                	mov    (%eax),%al
  802439:	3c 2f                	cmp    $0x2f,%al
  80243b:	7e 19                	jle    802456 <strtol+0xc2>
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8a 00                	mov    (%eax),%al
  802442:	3c 39                	cmp    $0x39,%al
  802444:	7f 10                	jg     802456 <strtol+0xc2>
			dig = *s - '0';
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	8a 00                	mov    (%eax),%al
  80244b:	0f be c0             	movsbl %al,%eax
  80244e:	83 e8 30             	sub    $0x30,%eax
  802451:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802454:	eb 42                	jmp    802498 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	8a 00                	mov    (%eax),%al
  80245b:	3c 60                	cmp    $0x60,%al
  80245d:	7e 19                	jle    802478 <strtol+0xe4>
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	8a 00                	mov    (%eax),%al
  802464:	3c 7a                	cmp    $0x7a,%al
  802466:	7f 10                	jg     802478 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	8a 00                	mov    (%eax),%al
  80246d:	0f be c0             	movsbl %al,%eax
  802470:	83 e8 57             	sub    $0x57,%eax
  802473:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802476:	eb 20                	jmp    802498 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	8a 00                	mov    (%eax),%al
  80247d:	3c 40                	cmp    $0x40,%al
  80247f:	7e 39                	jle    8024ba <strtol+0x126>
  802481:	8b 45 08             	mov    0x8(%ebp),%eax
  802484:	8a 00                	mov    (%eax),%al
  802486:	3c 5a                	cmp    $0x5a,%al
  802488:	7f 30                	jg     8024ba <strtol+0x126>
			dig = *s - 'A' + 10;
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	8a 00                	mov    (%eax),%al
  80248f:	0f be c0             	movsbl %al,%eax
  802492:	83 e8 37             	sub    $0x37,%eax
  802495:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80249e:	7d 19                	jge    8024b9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8024a0:	ff 45 08             	incl   0x8(%ebp)
  8024a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024a6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8024aa:	89 c2                	mov    %eax,%edx
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	01 d0                	add    %edx,%eax
  8024b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8024b4:	e9 7b ff ff ff       	jmp    802434 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8024b9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8024ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024be:	74 08                	je     8024c8 <strtol+0x134>
		*endptr = (char *) s;
  8024c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8024c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024cc:	74 07                	je     8024d5 <strtol+0x141>
  8024ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024d1:	f7 d8                	neg    %eax
  8024d3:	eb 03                	jmp    8024d8 <strtol+0x144>
  8024d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <ltostr>:

void
ltostr(long value, char *str)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8024e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8024e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8024ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f2:	79 13                	jns    802507 <ltostr+0x2d>
	{
		neg = 1;
  8024f4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8024fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fe:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802501:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802504:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802507:	8b 45 08             	mov    0x8(%ebp),%eax
  80250a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80250f:	99                   	cltd   
  802510:	f7 f9                	idiv   %ecx
  802512:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802515:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802518:	8d 50 01             	lea    0x1(%eax),%edx
  80251b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80251e:	89 c2                	mov    %eax,%edx
  802520:	8b 45 0c             	mov    0xc(%ebp),%eax
  802523:	01 d0                	add    %edx,%eax
  802525:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802528:	83 c2 30             	add    $0x30,%edx
  80252b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80252d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802530:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802535:	f7 e9                	imul   %ecx
  802537:	c1 fa 02             	sar    $0x2,%edx
  80253a:	89 c8                	mov    %ecx,%eax
  80253c:	c1 f8 1f             	sar    $0x1f,%eax
  80253f:	29 c2                	sub    %eax,%edx
  802541:	89 d0                	mov    %edx,%eax
  802543:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802546:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80254a:	75 bb                	jne    802507 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80254c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802553:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802556:	48                   	dec    %eax
  802557:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80255a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80255e:	74 3d                	je     80259d <ltostr+0xc3>
		start = 1 ;
  802560:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802567:	eb 34                	jmp    80259d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802569:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256f:	01 d0                	add    %edx,%eax
  802571:	8a 00                	mov    (%eax),%al
  802573:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257c:	01 c2                	add    %eax,%edx
  80257e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802581:	8b 45 0c             	mov    0xc(%ebp),%eax
  802584:	01 c8                	add    %ecx,%eax
  802586:	8a 00                	mov    (%eax),%al
  802588:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80258a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80258d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802590:	01 c2                	add    %eax,%edx
  802592:	8a 45 eb             	mov    -0x15(%ebp),%al
  802595:	88 02                	mov    %al,(%edx)
		start++ ;
  802597:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80259a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025a3:	7c c4                	jl     802569 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8025a5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8025a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ab:	01 d0                	add    %edx,%eax
  8025ad:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8025b0:	90                   	nop
  8025b1:	c9                   	leave  
  8025b2:	c3                   	ret    

008025b3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
  8025b6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8025b9:	ff 75 08             	pushl  0x8(%ebp)
  8025bc:	e8 c4 f9 ff ff       	call   801f85 <strlen>
  8025c1:	83 c4 04             	add    $0x4,%esp
  8025c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8025c7:	ff 75 0c             	pushl  0xc(%ebp)
  8025ca:	e8 b6 f9 ff ff       	call   801f85 <strlen>
  8025cf:	83 c4 04             	add    $0x4,%esp
  8025d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8025d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8025dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8025e3:	eb 17                	jmp    8025fc <strcconcat+0x49>
		final[s] = str1[s] ;
  8025e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8025eb:	01 c2                	add    %eax,%edx
  8025ed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8025f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f3:	01 c8                	add    %ecx,%eax
  8025f5:	8a 00                	mov    (%eax),%al
  8025f7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8025f9:	ff 45 fc             	incl   -0x4(%ebp)
  8025fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802602:	7c e1                	jl     8025e5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802604:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80260b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802612:	eb 1f                	jmp    802633 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802614:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802617:	8d 50 01             	lea    0x1(%eax),%edx
  80261a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80261d:	89 c2                	mov    %eax,%edx
  80261f:	8b 45 10             	mov    0x10(%ebp),%eax
  802622:	01 c2                	add    %eax,%edx
  802624:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262a:	01 c8                	add    %ecx,%eax
  80262c:	8a 00                	mov    (%eax),%al
  80262e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802630:	ff 45 f8             	incl   -0x8(%ebp)
  802633:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802636:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802639:	7c d9                	jl     802614 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80263b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80263e:	8b 45 10             	mov    0x10(%ebp),%eax
  802641:	01 d0                	add    %edx,%eax
  802643:	c6 00 00             	movb   $0x0,(%eax)
}
  802646:	90                   	nop
  802647:	c9                   	leave  
  802648:	c3                   	ret    

00802649 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80264c:	8b 45 14             	mov    0x14(%ebp),%eax
  80264f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802655:	8b 45 14             	mov    0x14(%ebp),%eax
  802658:	8b 00                	mov    (%eax),%eax
  80265a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802661:	8b 45 10             	mov    0x10(%ebp),%eax
  802664:	01 d0                	add    %edx,%eax
  802666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80266c:	eb 0c                	jmp    80267a <strsplit+0x31>
			*string++ = 0;
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	8d 50 01             	lea    0x1(%eax),%edx
  802674:	89 55 08             	mov    %edx,0x8(%ebp)
  802677:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80267a:	8b 45 08             	mov    0x8(%ebp),%eax
  80267d:	8a 00                	mov    (%eax),%al
  80267f:	84 c0                	test   %al,%al
  802681:	74 18                	je     80269b <strsplit+0x52>
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	8a 00                	mov    (%eax),%al
  802688:	0f be c0             	movsbl %al,%eax
  80268b:	50                   	push   %eax
  80268c:	ff 75 0c             	pushl  0xc(%ebp)
  80268f:	e8 83 fa ff ff       	call   802117 <strchr>
  802694:	83 c4 08             	add    $0x8,%esp
  802697:	85 c0                	test   %eax,%eax
  802699:	75 d3                	jne    80266e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	8a 00                	mov    (%eax),%al
  8026a0:	84 c0                	test   %al,%al
  8026a2:	74 5a                	je     8026fe <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8026a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	83 f8 0f             	cmp    $0xf,%eax
  8026ac:	75 07                	jne    8026b5 <strsplit+0x6c>
		{
			return 0;
  8026ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b3:	eb 66                	jmp    80271b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8026b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8026b8:	8b 00                	mov    (%eax),%eax
  8026ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8026bd:	8b 55 14             	mov    0x14(%ebp),%edx
  8026c0:	89 0a                	mov    %ecx,(%edx)
  8026c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8026cc:	01 c2                	add    %eax,%edx
  8026ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8026d3:	eb 03                	jmp    8026d8 <strsplit+0x8f>
			string++;
  8026d5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	8a 00                	mov    (%eax),%al
  8026dd:	84 c0                	test   %al,%al
  8026df:	74 8b                	je     80266c <strsplit+0x23>
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	8a 00                	mov    (%eax),%al
  8026e6:	0f be c0             	movsbl %al,%eax
  8026e9:	50                   	push   %eax
  8026ea:	ff 75 0c             	pushl  0xc(%ebp)
  8026ed:	e8 25 fa ff ff       	call   802117 <strchr>
  8026f2:	83 c4 08             	add    $0x8,%esp
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	74 dc                	je     8026d5 <strsplit+0x8c>
			string++;
	}
  8026f9:	e9 6e ff ff ff       	jmp    80266c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8026fe:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8026ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802702:	8b 00                	mov    (%eax),%eax
  802704:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80270b:	8b 45 10             	mov    0x10(%ebp),%eax
  80270e:	01 d0                	add    %edx,%eax
  802710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802716:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80271b:	c9                   	leave  
  80271c:	c3                   	ret    

0080271d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802723:	8b 45 08             	mov    0x8(%ebp),%eax
  802726:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802729:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802730:	eb 4a                	jmp    80277c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802732:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	01 c2                	add    %eax,%edx
  80273a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80273d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802740:	01 c8                	add    %ecx,%eax
  802742:	8a 00                	mov    (%eax),%al
  802744:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802746:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274c:	01 d0                	add    %edx,%eax
  80274e:	8a 00                	mov    (%eax),%al
  802750:	3c 40                	cmp    $0x40,%al
  802752:	7e 25                	jle    802779 <str2lower+0x5c>
  802754:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275a:	01 d0                	add    %edx,%eax
  80275c:	8a 00                	mov    (%eax),%al
  80275e:	3c 5a                	cmp    $0x5a,%al
  802760:	7f 17                	jg     802779 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802762:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802765:	8b 45 08             	mov    0x8(%ebp),%eax
  802768:	01 d0                	add    %edx,%eax
  80276a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80276d:	8b 55 08             	mov    0x8(%ebp),%edx
  802770:	01 ca                	add    %ecx,%edx
  802772:	8a 12                	mov    (%edx),%dl
  802774:	83 c2 20             	add    $0x20,%edx
  802777:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802779:	ff 45 fc             	incl   -0x4(%ebp)
  80277c:	ff 75 0c             	pushl  0xc(%ebp)
  80277f:	e8 01 f8 ff ff       	call   801f85 <strlen>
  802784:	83 c4 04             	add    $0x4,%esp
  802787:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80278a:	7f a6                	jg     802732 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80278c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80278f:	c9                   	leave  
  802790:	c3                   	ret    

00802791 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802791:	55                   	push   %ebp
  802792:	89 e5                	mov    %esp,%ebp
  802794:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802797:	a1 08 70 80 00       	mov    0x807008,%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	0f 84 95 00 00 00    	je     802839 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8027a4:	83 ec 08             	sub    $0x8,%esp
  8027a7:	68 00 00 00 82       	push   $0x82000000
  8027ac:	68 00 00 00 80       	push   $0x80000000
  8027b1:	e8 59 1f 00 00       	call   80470f <initialize_dynamic_allocator>
  8027b6:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8027b9:	e8 93 1d 00 00       	call   804551 <sys_get_uheap_strategy>
  8027be:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8027c3:	a1 20 72 80 00       	mov    0x807220,%eax
  8027c8:	05 00 10 00 00       	add    $0x1000,%eax
  8027cd:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  8027d2:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8027d7:	a3 50 f2 81 00       	mov    %eax,0x81f250
		init_uspinlock(&ulock,"malloc",1);
  8027dc:	83 ec 04             	sub    $0x4,%esp
  8027df:	6a 01                	push   $0x1
  8027e1:	68 e8 62 80 00       	push   $0x8062e8
  8027e6:	68 20 f3 81 00       	push   $0x81f320
  8027eb:	e8 d8 29 00 00       	call   8051c8 <init_uspinlock>
  8027f0:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  8027f3:	c7 05 00 f3 81 00 00 	movl   $0x0,0x81f300
  8027fa:	00 00 00 
  8027fd:	c7 05 04 f3 81 00 00 	movl   $0x0,0x81f304
  802804:	00 00 00 
  802807:	c7 05 0c f3 81 00 00 	movl   $0x0,0x81f30c
  80280e:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  802811:	c7 05 10 f3 81 00 00 	movl   $0x0,0x81f310
  802818:	00 00 00 
  80281b:	c7 05 14 f3 81 00 00 	movl   $0x0,0x81f314
  802822:	00 00 00 
  802825:	c7 05 1c f3 81 00 00 	movl   $0x0,0x81f31c
  80282c:	00 00 00 
		__firstTimeFlag = 0;
  80282f:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  802836:	00 00 00 
	}
}
  802839:	90                   	nop
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802842:	8b 45 08             	mov    0x8(%ebp),%eax
  802845:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802850:	83 ec 08             	sub    $0x8,%esp
  802853:	68 06 04 00 00       	push   $0x406
  802858:	50                   	push   %eax
  802859:	e8 3d 19 00 00       	call   80419b <__sys_allocate_page>
  80285e:	83 c4 10             	add    $0x10,%esp
  802861:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802864:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802868:	79 14                	jns    80287e <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80286a:	83 ec 04             	sub    $0x4,%esp
  80286d:	68 f0 62 80 00       	push   $0x8062f0
  802872:	6a 2d                	push   $0x2d
  802874:	68 2c 63 80 00       	push   $0x80632c
  802879:	e8 60 ed ff ff       	call   8015de <_panic>
	return 0;
  80287e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802883:	c9                   	leave  
  802884:	c3                   	ret    

00802885 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802885:	55                   	push   %ebp
  802886:	89 e5                	mov    %esp,%ebp
  802888:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802899:	83 ec 0c             	sub    $0xc,%esp
  80289c:	50                   	push   %eax
  80289d:	e8 40 19 00 00       	call   8041e2 <__sys_unmap_frame>
  8028a2:	83 c4 10             	add    $0x10,%esp
  8028a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8028a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ac:	79 14                	jns    8028c2 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8028ae:	83 ec 04             	sub    $0x4,%esp
  8028b1:	68 38 63 80 00       	push   $0x806338
  8028b6:	6a 38                	push   $0x38
  8028b8:	68 2c 63 80 00       	push   $0x80632c
  8028bd:	e8 1c ed ff ff       	call   8015de <_panic>
}
  8028c2:	90                   	nop
  8028c3:	c9                   	leave  
  8028c4:	c3                   	ret    

008028c5 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8028cb:	e8 c1 fe ff ff       	call   802791 <uheap_init>
	if (size == 0) return NULL ;
  8028d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d4:	75 0a                	jne    8028e0 <malloc+0x1b>
  8028d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028db:	e9 e1 04 00 00       	jmp    802dc1 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  8028e0:	83 ec 0c             	sub    $0xc,%esp
  8028e3:	68 20 f3 81 00       	push   $0x81f320
  8028e8:	e8 2a 29 00 00       	call   805217 <acquire_uspinlock>
  8028ed:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  8028f0:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  8028f7:	77 23                	ja     80291c <malloc+0x57>
		release_uspinlock(&ulock);
  8028f9:	83 ec 0c             	sub    $0xc,%esp
  8028fc:	68 20 f3 81 00       	push   $0x81f320
  802901:	e8 69 29 00 00       	call   80526f <release_uspinlock>
  802906:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  802909:	83 ec 0c             	sub    $0xc,%esp
  80290c:	ff 75 08             	pushl  0x8(%ebp)
  80290f:	e8 dd 1f 00 00       	call   8048f1 <alloc_block>
  802914:	83 c4 10             	add    $0x10,%esp
  802917:	e9 a5 04 00 00       	jmp    802dc1 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80291c:	83 ec 0c             	sub    $0xc,%esp
  80291f:	6a 10                	push   $0x10
  802921:	e8 cb 1f 00 00       	call   8048f1 <alloc_block>
  802926:	83 c4 10             	add    $0x10,%esp
  802929:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  80292c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802930:	75 0a                	jne    80293c <malloc+0x77>
			return NULL;
  802932:	b8 00 00 00 00       	mov    $0x0,%eax
  802937:	e9 85 04 00 00       	jmp    802dc1 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  80293c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802943:	8b 55 08             	mov    0x8(%ebp),%edx
  802946:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802949:	01 d0                	add    %edx,%eax
  80294b:	48                   	dec    %eax
  80294c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80294f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802952:	ba 00 00 00 00       	mov    $0x0,%edx
  802957:	f7 75 e8             	divl   -0x18(%ebp)
  80295a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295d:	29 d0                	sub    %edx,%eax
  80295f:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802962:	a1 04 f3 81 00       	mov    0x81f304,%eax
  802967:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80296a:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80296f:	85 c0                	test   %eax,%eax
  802971:	74 0f                	je     802982 <malloc+0xbd>
  802973:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802976:	8b 40 04             	mov    0x4(%eax),%eax
  802979:	3b 45 08             	cmp    0x8(%ebp),%eax
  80297c:	0f 83 ea 00 00 00    	jae    802a6c <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  802982:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802987:	2b 45 08             	sub    0x8(%ebp),%eax
  80298a:	89 c2                	mov    %eax,%edx
  80298c:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802991:	39 c2                	cmp    %eax,%edx
  802993:	0f 86 b9 00 00 00    	jbe    802a52 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  802999:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80299e:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  8029a1:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	01 d0                	add    %edx,%eax
  8029ac:	a3 50 f2 81 00       	mov    %eax,0x81f250
					allocblock->startva = requestedblockva;
  8029b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029b7:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8029b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bf:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8029c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029c6:	75 14                	jne    8029dc <malloc+0x117>
  8029c8:	83 ec 04             	sub    $0x4,%esp
  8029cb:	68 78 63 80 00       	push   $0x806378
  8029d0:	6a 60                	push   $0x60
  8029d2:	68 2c 63 80 00       	push   $0x80632c
  8029d7:	e8 02 ec ff ff       	call   8015de <_panic>
  8029dc:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	89 50 0c             	mov    %edx,0xc(%eax)
  8029e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	74 0d                	je     8029ff <malloc+0x13a>
  8029f2:	a1 14 f3 81 00       	mov    0x81f314,%eax
  8029f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029fa:	89 50 08             	mov    %edx,0x8(%eax)
  8029fd:	eb 08                	jmp    802a07 <malloc+0x142>
  8029ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a02:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802a07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0a:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a19:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802a1e:	40                   	inc    %eax
  802a1f:	a3 1c f3 81 00       	mov    %eax,0x81f31c


					sys_allocate_user_mem(allocblock->startva ,size);
  802a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a27:	8b 00                	mov    (%eax),%eax
  802a29:	83 ec 08             	sub    $0x8,%esp
  802a2c:	ff 75 08             	pushl  0x8(%ebp)
  802a2f:	50                   	push   %eax
  802a30:	e8 34 1c 00 00       	call   804669 <sys_allocate_user_mem>
  802a35:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  802a38:	83 ec 0c             	sub    $0xc,%esp
  802a3b:	68 20 f3 81 00       	push   $0x81f320
  802a40:	e8 2a 28 00 00       	call   80526f <release_uspinlock>
  802a45:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802a48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	e9 6f 03 00 00       	jmp    802dc1 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  802a52:	83 ec 0c             	sub    $0xc,%esp
  802a55:	68 20 f3 81 00       	push   $0x81f320
  802a5a:	e8 10 28 00 00       	call   80526f <release_uspinlock>
  802a5f:	83 c4 10             	add    $0x10,%esp
					return NULL;
  802a62:	b8 00 00 00 00       	mov    $0x0,%eax
  802a67:	e9 55 03 00 00       	jmp    802dc1 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802a6c:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  802a74:	e9 39 03 00 00       	jmp    802db2 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 40 04             	mov    0x4(%eax),%eax
  802a7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a82:	0f 86 e7 01 00 00    	jbe    802c6f <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  802a88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a8b:	8b 10                	mov    (%eax),%edx
  802a8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a90:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  802a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a95:	8b 55 08             	mov    0x8(%ebp),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802a9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a9f:	75 14                	jne    802ab5 <malloc+0x1f0>
  802aa1:	83 ec 04             	sub    $0x4,%esp
  802aa4:	68 78 63 80 00       	push   $0x806378
  802aa9:	6a 72                	push   $0x72
  802aab:	68 2c 63 80 00       	push   $0x80632c
  802ab0:	e8 29 eb ff ff       	call   8015de <_panic>
  802ab5:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abe:	89 50 0c             	mov    %edx,0xc(%eax)
  802ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	74 0d                	je     802ad8 <malloc+0x213>
  802acb:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802ad0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad3:	89 50 08             	mov    %edx,0x8(%eax)
  802ad6:	eb 08                	jmp    802ae0 <malloc+0x21b>
  802ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adb:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae3:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aeb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802af2:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802af7:	40                   	inc    %eax
  802af8:	a3 1c f3 81 00       	mov    %eax,0x81f31c
                lastfreeelement->startva += size;
  802afd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b00:	8b 10                	mov    (%eax),%edx
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	01 c2                	add    %eax,%edx
  802b07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0a:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  802b0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0f:	8b 40 04             	mov    0x4(%eax),%eax
  802b12:	2b 45 08             	sub    0x8(%ebp),%eax
  802b15:	89 c2                	mov    %eax,%edx
  802b17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1a:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802b1d:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  802b25:	e9 0d 01 00 00       	jmp    802c37 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  802b2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2d:	8b 50 04             	mov    0x4(%eax),%edx
  802b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	39 c2                	cmp    %eax,%edx
  802b38:	0f 83 f0 00 00 00    	jae    802c2e <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802b3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b42:	75 14                	jne    802b58 <malloc+0x293>
  802b44:	83 ec 04             	sub    $0x4,%esp
  802b47:	68 9b 63 80 00       	push   $0x80639b
  802b4c:	6a 7a                	push   $0x7a
  802b4e:	68 2c 63 80 00       	push   $0x80632c
  802b53:	e8 86 ea ff ff       	call   8015de <_panic>
  802b58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5b:	8b 40 08             	mov    0x8(%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 11                	je     802b73 <malloc+0x2ae>
  802b62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b65:	8b 40 08             	mov    0x8(%eax),%eax
  802b68:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b6b:	8b 52 0c             	mov    0xc(%edx),%edx
  802b6e:	89 50 0c             	mov    %edx,0xc(%eax)
  802b71:	eb 0b                	jmp    802b7e <malloc+0x2b9>
  802b73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b76:	8b 40 0c             	mov    0xc(%eax),%eax
  802b79:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802b7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b81:	8b 40 0c             	mov    0xc(%eax),%eax
  802b84:	85 c0                	test   %eax,%eax
  802b86:	74 11                	je     802b99 <malloc+0x2d4>
  802b88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b91:	8b 52 08             	mov    0x8(%edx),%edx
  802b94:	89 50 08             	mov    %edx,0x8(%eax)
  802b97:	eb 0b                	jmp    802ba4 <malloc+0x2df>
  802b99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9c:	8b 40 08             	mov    0x8(%eax),%eax
  802b9f:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802ba4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802bb8:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802bbd:	48                   	dec    %eax
  802bbe:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802bc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bc7:	74 06                	je     802bcf <malloc+0x30a>
  802bc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bcd:	75 14                	jne    802be3 <malloc+0x31e>
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	68 bc 63 80 00       	push   $0x8063bc
  802bd7:	6a 7b                	push   $0x7b
  802bd9:	68 2c 63 80 00       	push   $0x80632c
  802bde:	e8 fb e9 ff ff       	call   8015de <_panic>
  802be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be6:	8b 50 0c             	mov    0xc(%eax),%edx
  802be9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bec:	89 50 0c             	mov    %edx,0xc(%eax)
  802bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf5:	89 50 08             	mov    %edx,0x8(%eax)
  802bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	74 0e                	je     802c10 <malloc+0x34b>
  802c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c05:	8b 40 0c             	mov    0xc(%eax),%eax
  802c08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c0b:	89 50 08             	mov    %edx,0x8(%eax)
  802c0e:	eb 08                	jmp    802c18 <malloc+0x353>
  802c10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c13:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c1e:	89 50 0c             	mov    %edx,0xc(%eax)
  802c21:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802c26:	40                   	inc    %eax
  802c27:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		break;
  802c2c:	eb 13                	jmp    802c41 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  802c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c31:	8b 40 08             	mov    0x8(%eax),%eax
  802c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  802c37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c3b:	0f 85 e9 fe ff ff    	jne    802b2a <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  802c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	83 ec 08             	sub    $0x8,%esp
  802c49:	ff 75 08             	pushl  0x8(%ebp)
  802c4c:	50                   	push   %eax
  802c4d:	e8 17 1a 00 00       	call   804669 <sys_allocate_user_mem>
  802c52:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  802c55:	83 ec 0c             	sub    $0xc,%esp
  802c58:	68 20 f3 81 00       	push   $0x81f320
  802c5d:	e8 0d 26 00 00       	call   80526f <release_uspinlock>
  802c62:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  802c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	e9 52 01 00 00       	jmp    802dc1 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 40 04             	mov    0x4(%eax),%eax
  802c75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c78:	0f 85 2b 01 00 00    	jne    802da9 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 10                	mov    (%eax),%edx
  802c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c86:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  802c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8e:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802c91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c95:	75 17                	jne    802cae <malloc+0x3e9>
  802c97:	83 ec 04             	sub    $0x4,%esp
  802c9a:	68 78 63 80 00       	push   $0x806378
  802c9f:	68 89 00 00 00       	push   $0x89
  802ca4:	68 2c 63 80 00       	push   $0x80632c
  802ca9:	e8 30 e9 ff ff       	call   8015de <_panic>
  802cae:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802cb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb7:	89 50 0c             	mov    %edx,0xc(%eax)
  802cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc0:	85 c0                	test   %eax,%eax
  802cc2:	74 0d                	je     802cd1 <malloc+0x40c>
  802cc4:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802cc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ccc:	89 50 08             	mov    %edx,0x8(%eax)
  802ccf:	eb 08                	jmp    802cd9 <malloc+0x414>
  802cd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd4:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdc:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ceb:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802cf0:	40                   	inc    %eax
  802cf1:	a3 1c f3 81 00       	mov    %eax,0x81f31c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  802cf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfa:	75 17                	jne    802d13 <malloc+0x44e>
  802cfc:	83 ec 04             	sub    $0x4,%esp
  802cff:	68 9b 63 80 00       	push   $0x80639b
  802d04:	68 8a 00 00 00       	push   $0x8a
  802d09:	68 2c 63 80 00       	push   $0x80632c
  802d0e:	e8 cb e8 ff ff       	call   8015de <_panic>
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 40 08             	mov    0x8(%eax),%eax
  802d19:	85 c0                	test   %eax,%eax
  802d1b:	74 11                	je     802d2e <malloc+0x469>
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 40 08             	mov    0x8(%eax),%eax
  802d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d26:	8b 52 0c             	mov    0xc(%edx),%edx
  802d29:	89 50 0c             	mov    %edx,0xc(%eax)
  802d2c:	eb 0b                	jmp    802d39 <malloc+0x474>
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 40 0c             	mov    0xc(%eax),%eax
  802d34:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	74 11                	je     802d54 <malloc+0x48f>
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 40 0c             	mov    0xc(%eax),%eax
  802d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d4c:	8b 52 08             	mov    0x8(%edx),%edx
  802d4f:	89 50 08             	mov    %edx,0x8(%eax)
  802d52:	eb 0b                	jmp    802d5f <malloc+0x49a>
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 40 08             	mov    0x8(%eax),%eax
  802d5a:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d73:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802d78:	48                   	dec    %eax
  802d79:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				sys_allocate_user_mem(allocblock->startva ,size);
  802d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d81:	8b 00                	mov    (%eax),%eax
  802d83:	83 ec 08             	sub    $0x8,%esp
  802d86:	ff 75 08             	pushl  0x8(%ebp)
  802d89:	50                   	push   %eax
  802d8a:	e8 da 18 00 00       	call   804669 <sys_allocate_user_mem>
  802d8f:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  802d92:	83 ec 0c             	sub    $0xc,%esp
  802d95:	68 20 f3 81 00       	push   $0x81f320
  802d9a:	e8 d0 24 00 00       	call   80526f <release_uspinlock>
  802d9f:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  802da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	eb 18                	jmp    802dc1 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	8b 40 08             	mov    0x8(%eax),%eax
  802daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  802db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db6:	0f 85 bd fc ff ff    	jne    802a79 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  802dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc1:	c9                   	leave  
  802dc2:	c3                   	ret    

00802dc3 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802dc3:	55                   	push   %ebp
  802dc4:	89 e5                	mov    %esp,%ebp
  802dc6:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802dcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802dd7:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  802dda:	e8 b2 f9 ff ff       	call   802791 <uheap_init>
		acquire_uspinlock(&ulock);
  802ddf:	83 ec 0c             	sub    $0xc,%esp
  802de2:	68 20 f3 81 00       	push   $0x81f320
  802de7:	e8 2b 24 00 00       	call   805217 <acquire_uspinlock>
  802dec:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  802def:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802df4:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802df7:	73 23                	jae    802e1c <free+0x59>
			free_block(virtual_address);
  802df9:	83 ec 0c             	sub    $0xc,%esp
  802dfc:	ff 75 08             	pushl  0x8(%ebp)
  802dff:	e8 89 1f 00 00       	call   804d8d <free_block>
  802e04:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  802e07:	83 ec 0c             	sub    $0xc,%esp
  802e0a:	68 20 f3 81 00       	push   $0x81f320
  802e0f:	e8 5b 24 00 00       	call   80526f <release_uspinlock>
  802e14:	83 c4 10             	add    $0x10,%esp
			return;
  802e17:	e9 35 07 00 00       	jmp    803551 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802e1c:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802e21:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802e24:	72 30                	jb     802e56 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  802e26:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802e2b:	83 ec 04             	sub    $0x4,%esp
  802e2e:	50                   	push   %eax
  802e2f:	ff 75 d8             	pushl  -0x28(%ebp)
  802e32:	68 f1 63 80 00       	push   $0x8063f1
  802e37:	e8 70 ea ff ff       	call   8018ac <cprintf>
  802e3c:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802e3f:	83 ec 04             	sub    $0x4,%esp
  802e42:	68 f9 63 80 00       	push   $0x8063f9
  802e47:	68 a7 00 00 00       	push   $0xa7
  802e4c:	68 2c 63 80 00       	push   $0x80632c
  802e51:	e8 88 e7 ff ff       	call   8015de <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802e56:	83 ec 0c             	sub    $0xc,%esp
  802e59:	6a 10                	push   $0x10
  802e5b:	e8 91 1a 00 00       	call   8048f1 <alloc_block>
  802e60:	83 c4 10             	add    $0x10,%esp
  802e63:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  802e66:	83 ec 0c             	sub    $0xc,%esp
  802e69:	6a 10                	push   $0x10
  802e6b:	e8 81 1a 00 00       	call   8048f1 <alloc_block>
  802e70:	83 c4 10             	add    $0x10,%esp
  802e73:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  802e76:	a1 10 f3 81 00       	mov    0x81f310,%eax
  802e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  802e7e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  802e85:	eb 1c                	jmp    802ea3 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 00                	mov    (%eax),%eax
  802e8c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802e8f:	75 09                	jne    802e9a <free+0xd7>
				foundVA = 1;
  802e91:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  802e98:	eb 0f                	jmp    802ea9 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  802ea3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea7:	75 de                	jne    802e87 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  802ea9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ead:	75 17                	jne    802ec6 <free+0x103>
				panic("INVALID ADDRESS!");
  802eaf:	83 ec 04             	sub    $0x4,%esp
  802eb2:	68 16 64 80 00       	push   $0x806416
  802eb7:	68 be 00 00 00       	push   $0xbe
  802ebc:	68 2c 63 80 00       	push   $0x80632c
  802ec1:	e8 18 e7 ff ff       	call   8015de <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 10                	mov    (%eax),%edx
  802ecb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ece:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 50 04             	mov    0x4(%eax),%edx
  802ed6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ed9:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  802edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee0:	75 17                	jne    802ef9 <free+0x136>
  802ee2:	83 ec 04             	sub    $0x4,%esp
  802ee5:	68 9b 63 80 00       	push   $0x80639b
  802eea:	68 c8 00 00 00       	push   $0xc8
  802eef:	68 2c 63 80 00       	push   $0x80632c
  802ef4:	e8 e5 e6 ff ff       	call   8015de <_panic>
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 40 08             	mov    0x8(%eax),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	74 11                	je     802f14 <free+0x151>
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 40 08             	mov    0x8(%eax),%eax
  802f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0c:	8b 52 0c             	mov    0xc(%edx),%edx
  802f0f:	89 50 0c             	mov    %edx,0xc(%eax)
  802f12:	eb 0b                	jmp    802f1f <free+0x15c>
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1a:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 40 0c             	mov    0xc(%eax),%eax
  802f25:	85 c0                	test   %eax,%eax
  802f27:	74 11                	je     802f3a <free+0x177>
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f32:	8b 52 08             	mov    0x8(%edx),%edx
  802f35:	89 50 08             	mov    %edx,0x8(%eax)
  802f38:	eb 0b                	jmp    802f45 <free+0x182>
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 40 08             	mov    0x8(%eax),%eax
  802f40:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f59:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802f5e:	48                   	dec    %eax
  802f5f:	a3 1c f3 81 00       	mov    %eax,0x81f31c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 50 04             	mov    0x4(%eax),%edx
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	83 ec 08             	sub    $0x8,%esp
  802f72:	52                   	push   %edx
  802f73:	50                   	push   %eax
  802f74:	e8 d4 16 00 00       	call   80464d <sys_free_user_mem>
  802f79:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  802f7c:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	75 7a                	jne    802fff <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  802f85:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802f89:	75 17                	jne    802fa2 <free+0x1df>
  802f8b:	83 ec 04             	sub    $0x4,%esp
  802f8e:	68 28 64 80 00       	push   $0x806428
  802f93:	68 d0 00 00 00       	push   $0xd0
  802f98:	68 2c 63 80 00       	push   $0x80632c
  802f9d:	e8 3c e6 ff ff       	call   8015de <_panic>
  802fa2:	8b 15 00 f3 81 00    	mov    0x81f300,%edx
  802fa8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fab:	89 50 08             	mov    %edx,0x8(%eax)
  802fae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fb1:	8b 40 08             	mov    0x8(%eax),%eax
  802fb4:	85 c0                	test   %eax,%eax
  802fb6:	74 0d                	je     802fc5 <free+0x202>
  802fb8:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802fbd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802fc0:	89 50 0c             	mov    %edx,0xc(%eax)
  802fc3:	eb 08                	jmp    802fcd <free+0x20a>
  802fc5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fc8:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802fcd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fd0:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802fd5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fd8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fdf:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802fe4:	40                   	inc    %eax
  802fe5:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			release_uspinlock(&ulock);
  802fea:	83 ec 0c             	sub    $0xc,%esp
  802fed:	68 20 f3 81 00       	push   $0x81f320
  802ff2:	e8 78 22 00 00       	call   80526f <release_uspinlock>
  802ff7:	83 c4 10             	add    $0x10,%esp
			return;
  802ffa:	e9 52 05 00 00       	jmp    803551 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  802fff:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803004:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  803007:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  80300e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  803015:	e9 d2 00 00 00       	jmp    8030ec <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  80301a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301d:	8b 10                	mov    (%eax),%edx
  80301f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803022:	8b 40 04             	mov    0x4(%eax),%eax
  803025:	01 c2                	add    %eax,%edx
  803027:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	39 c2                	cmp    %eax,%edx
  80302e:	0f 85 af 00 00 00    	jne    8030e3 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  803034:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803037:	8b 10                	mov    (%eax),%edx
  803039:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80303c:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  80303e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803041:	8b 50 04             	mov    0x4(%eax),%edx
  803044:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803047:	8b 40 04             	mov    0x4(%eax),%eax
  80304a:	01 c2                	add    %eax,%edx
  80304c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80304f:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  803052:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803056:	75 17                	jne    80306f <free+0x2ac>
  803058:	83 ec 04             	sub    $0x4,%esp
  80305b:	68 9b 63 80 00       	push   $0x80639b
  803060:	68 df 00 00 00       	push   $0xdf
  803065:	68 2c 63 80 00       	push   $0x80632c
  80306a:	e8 6f e5 ff ff       	call   8015de <_panic>
  80306f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803072:	8b 40 08             	mov    0x8(%eax),%eax
  803075:	85 c0                	test   %eax,%eax
  803077:	74 11                	je     80308a <free+0x2c7>
  803079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307c:	8b 40 08             	mov    0x8(%eax),%eax
  80307f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803082:	8b 52 0c             	mov    0xc(%edx),%edx
  803085:	89 50 0c             	mov    %edx,0xc(%eax)
  803088:	eb 0b                	jmp    803095 <free+0x2d2>
  80308a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308d:	8b 40 0c             	mov    0xc(%eax),%eax
  803090:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803098:	8b 40 0c             	mov    0xc(%eax),%eax
  80309b:	85 c0                	test   %eax,%eax
  80309d:	74 11                	je     8030b0 <free+0x2ed>
  80309f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030a8:	8b 52 08             	mov    0x8(%edx),%edx
  8030ab:	89 50 08             	mov    %edx,0x8(%eax)
  8030ae:	eb 0b                	jmp    8030bb <free+0x2f8>
  8030b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b3:	8b 40 08             	mov    0x8(%eax),%eax
  8030b6:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8030bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8030cf:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8030d4:	48                   	dec    %eax
  8030d5:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				mergeprev = 1;
  8030da:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  8030e1:	eb 13                	jmp    8030f6 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8030e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e6:	8b 40 08             	mov    0x8(%eax),%eax
  8030e9:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  8030ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030f0:	0f 85 24 ff ff ff    	jne    80301a <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  8030f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030f9:	8b 10                	mov    (%eax),%edx
  8030fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030fe:	8b 40 04             	mov    0x4(%eax),%eax
  803101:	01 c2                	add    %eax,%edx
  803103:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803108:	39 c2                	cmp    %eax,%edx
  80310a:	75 44                	jne    803150 <free+0x38d>

			if(mergeprev){
  80310c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803110:	74 1f                	je     803131 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  803112:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803115:	8b 00                	mov    (%eax),%eax
  803117:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  80311c:	83 ec 0c             	sub    $0xc,%esp
  80311f:	68 20 f3 81 00       	push   $0x81f320
  803124:	e8 46 21 00 00       	call   80526f <release_uspinlock>
  803129:	83 c4 10             	add    $0x10,%esp
				return;
  80312c:	e9 20 04 00 00       	jmp    803551 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  803131:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  80313b:	83 ec 0c             	sub    $0xc,%esp
  80313e:	68 20 f3 81 00       	push   $0x81f320
  803143:	e8 27 21 00 00       	call   80526f <release_uspinlock>
  803148:	83 c4 10             	add    $0x10,%esp
				return;
  80314b:	e9 01 04 00 00       	jmp    803551 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  803150:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803155:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  803158:	e9 7d 01 00 00       	jmp    8032da <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  80315d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803160:	8b 10                	mov    (%eax),%edx
  803162:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803165:	8b 40 04             	mov    0x4(%eax),%eax
  803168:	01 c2                	add    %eax,%edx
  80316a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	39 c2                	cmp    %eax,%edx
  803171:	0f 85 5a 01 00 00    	jne    8032d1 <free+0x50e>
				if (mergeprev){
  803177:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80317b:	0f 84 a1 00 00 00    	je     803222 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  803181:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803184:	8b 50 04             	mov    0x4(%eax),%edx
  803187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318a:	8b 40 04             	mov    0x4(%eax),%eax
  80318d:	01 c2                	add    %eax,%edx
  80318f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803192:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  803195:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803199:	75 17                	jne    8031b2 <free+0x3ef>
  80319b:	83 ec 04             	sub    $0x4,%esp
  80319e:	68 9b 63 80 00       	push   $0x80639b
  8031a3:	68 0a 01 00 00       	push   $0x10a
  8031a8:	68 2c 63 80 00       	push   $0x80632c
  8031ad:	e8 2c e4 ff ff       	call   8015de <_panic>
  8031b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b5:	8b 40 08             	mov    0x8(%eax),%eax
  8031b8:	85 c0                	test   %eax,%eax
  8031ba:	74 11                	je     8031cd <free+0x40a>
  8031bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031bf:	8b 40 08             	mov    0x8(%eax),%eax
  8031c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031c5:	8b 52 0c             	mov    0xc(%edx),%edx
  8031c8:	89 50 0c             	mov    %edx,0xc(%eax)
  8031cb:	eb 0b                	jmp    8031d8 <free+0x415>
  8031cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d3:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8031d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031db:	8b 40 0c             	mov    0xc(%eax),%eax
  8031de:	85 c0                	test   %eax,%eax
  8031e0:	74 11                	je     8031f3 <free+0x430>
  8031e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031eb:	8b 52 08             	mov    0x8(%edx),%edx
  8031ee:	89 50 08             	mov    %edx,0x8(%eax)
  8031f1:	eb 0b                	jmp    8031fe <free+0x43b>
  8031f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f6:	8b 40 08             	mov    0x8(%eax),%eax
  8031f9:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8031fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803201:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803212:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803217:	48                   	dec    %eax
  803218:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					break;
  80321d:	e9 c2 00 00 00       	jmp    8032e4 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  803222:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803225:	8b 10                	mov    (%eax),%edx
  803227:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80322a:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  80322c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80322f:	8b 50 04             	mov    0x4(%eax),%edx
  803232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803235:	8b 40 04             	mov    0x4(%eax),%eax
  803238:	01 c2                	add    %eax,%edx
  80323a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80323d:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  803240:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803244:	75 17                	jne    80325d <free+0x49a>
  803246:	83 ec 04             	sub    $0x4,%esp
  803249:	68 9b 63 80 00       	push   $0x80639b
  80324e:	68 10 01 00 00       	push   $0x110
  803253:	68 2c 63 80 00       	push   $0x80632c
  803258:	e8 81 e3 ff ff       	call   8015de <_panic>
  80325d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803260:	8b 40 08             	mov    0x8(%eax),%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	74 11                	je     803278 <free+0x4b5>
  803267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326a:	8b 40 08             	mov    0x8(%eax),%eax
  80326d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803270:	8b 52 0c             	mov    0xc(%edx),%edx
  803273:	89 50 0c             	mov    %edx,0xc(%eax)
  803276:	eb 0b                	jmp    803283 <free+0x4c0>
  803278:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327b:	8b 40 0c             	mov    0xc(%eax),%eax
  80327e:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803283:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803286:	8b 40 0c             	mov    0xc(%eax),%eax
  803289:	85 c0                	test   %eax,%eax
  80328b:	74 11                	je     80329e <free+0x4db>
  80328d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803290:	8b 40 0c             	mov    0xc(%eax),%eax
  803293:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803296:	8b 52 08             	mov    0x8(%edx),%edx
  803299:	89 50 08             	mov    %edx,0x8(%eax)
  80329c:	eb 0b                	jmp    8032a9 <free+0x4e6>
  80329e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a1:	8b 40 08             	mov    0x8(%eax),%eax
  8032a4:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8032a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8032bd:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8032c2:	48                   	dec    %eax
  8032c3:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					mergenext = 1;
  8032c8:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8032cf:	eb 13                	jmp    8032e4 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8032d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d4:	8b 40 08             	mov    0x8(%eax),%eax
  8032d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  8032da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032de:	0f 85 79 fe ff ff    	jne    80315d <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  8032e4:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8032e9:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  8032ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032f0:	0f 85 ad 00 00 00    	jne    8033a3 <free+0x5e0>
  8032f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032fa:	0f 84 c3 01 00 00    	je     8034c3 <free+0x700>
				while(currentfree != NULL){
  803300:	e9 9e 00 00 00       	jmp    8033a3 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  803305:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803308:	8b 50 04             	mov    0x4(%eax),%edx
  80330b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80330e:	8b 40 04             	mov    0x4(%eax),%eax
  803311:	39 c2                	cmp    %eax,%edx
  803313:	0f 83 81 00 00 00    	jae    80339a <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  803319:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80331d:	74 06                	je     803325 <free+0x562>
  80331f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803323:	75 17                	jne    80333c <free+0x579>
  803325:	83 ec 04             	sub    $0x4,%esp
  803328:	68 bc 63 80 00       	push   $0x8063bc
  80332d:	68 23 01 00 00       	push   $0x123
  803332:	68 2c 63 80 00       	push   $0x80632c
  803337:	e8 a2 e2 ff ff       	call   8015de <_panic>
  80333c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333f:	8b 50 0c             	mov    0xc(%eax),%edx
  803342:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803345:	89 50 0c             	mov    %edx,0xc(%eax)
  803348:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80334b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80334e:	89 50 08             	mov    %edx,0x8(%eax)
  803351:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803354:	8b 40 0c             	mov    0xc(%eax),%eax
  803357:	85 c0                	test   %eax,%eax
  803359:	74 0e                	je     803369 <free+0x5a6>
  80335b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80335e:	8b 40 0c             	mov    0xc(%eax),%eax
  803361:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803364:	89 50 08             	mov    %edx,0x8(%eax)
  803367:	eb 08                	jmp    803371 <free+0x5ae>
  803369:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80336c:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803371:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803374:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803377:	89 50 0c             	mov    %edx,0xc(%eax)
  80337a:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80337f:	40                   	inc    %eax
  803380:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  803385:	83 ec 0c             	sub    $0xc,%esp
  803388:	68 20 f3 81 00       	push   $0x81f320
  80338d:	e8 dd 1e 00 00       	call   80526f <release_uspinlock>
  803392:	83 c4 10             	add    $0x10,%esp
							return;
  803395:	e9 b7 01 00 00       	jmp    803551 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80339a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80339d:	8b 40 08             	mov    0x8(%eax),%eax
  8033a0:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  8033a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033a7:	0f 85 58 ff ff ff    	jne    803305 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  8033ad:	83 ec 0c             	sub    $0xc,%esp
  8033b0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033b3:	e8 d5 19 00 00       	call   804d8d <free_block>
  8033b8:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8033bb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033bf:	75 17                	jne    8033d8 <free+0x615>
  8033c1:	83 ec 04             	sub    $0x4,%esp
  8033c4:	68 78 63 80 00       	push   $0x806378
  8033c9:	68 2a 01 00 00       	push   $0x12a
  8033ce:	68 2c 63 80 00       	push   $0x80632c
  8033d3:	e8 06 e2 ff ff       	call   8015de <_panic>
  8033d8:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  8033de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033e1:	89 50 0c             	mov    %edx,0xc(%eax)
  8033e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	74 0d                	je     8033fb <free+0x638>
  8033ee:	a1 04 f3 81 00       	mov    0x81f304,%eax
  8033f3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8033f6:	89 50 08             	mov    %edx,0x8(%eax)
  8033f9:	eb 08                	jmp    803403 <free+0x640>
  8033fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033fe:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803403:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803406:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80340b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80340e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803415:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80341a:	40                   	inc    %eax
  80341b:	a3 0c f3 81 00       	mov    %eax,0x81f30c
  803420:	e9 1b 01 00 00       	jmp    803540 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  803425:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803428:	8b 50 04             	mov    0x4(%eax),%edx
  80342b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342e:	8b 40 04             	mov    0x4(%eax),%eax
  803431:	39 c2                	cmp    %eax,%edx
  803433:	0f 83 81 00 00 00    	jae    8034ba <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  803439:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80343d:	74 06                	je     803445 <free+0x682>
  80343f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803443:	75 17                	jne    80345c <free+0x699>
  803445:	83 ec 04             	sub    $0x4,%esp
  803448:	68 bc 63 80 00       	push   $0x8063bc
  80344d:	68 30 01 00 00       	push   $0x130
  803452:	68 2c 63 80 00       	push   $0x80632c
  803457:	e8 82 e1 ff ff       	call   8015de <_panic>
  80345c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80345f:	8b 50 0c             	mov    0xc(%eax),%edx
  803462:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803465:	89 50 0c             	mov    %edx,0xc(%eax)
  803468:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80346e:	89 50 08             	mov    %edx,0x8(%eax)
  803471:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803474:	8b 40 0c             	mov    0xc(%eax),%eax
  803477:	85 c0                	test   %eax,%eax
  803479:	74 0e                	je     803489 <free+0x6c6>
  80347b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80347e:	8b 40 0c             	mov    0xc(%eax),%eax
  803481:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803484:	89 50 08             	mov    %edx,0x8(%eax)
  803487:	eb 08                	jmp    803491 <free+0x6ce>
  803489:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348c:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803491:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803494:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803497:	89 50 0c             	mov    %edx,0xc(%eax)
  80349a:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80349f:	40                   	inc    %eax
  8034a0:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  8034a5:	83 ec 0c             	sub    $0xc,%esp
  8034a8:	68 20 f3 81 00       	push   $0x81f320
  8034ad:	e8 bd 1d 00 00       	call   80526f <release_uspinlock>
  8034b2:	83 c4 10             	add    $0x10,%esp
							return;
  8034b5:	e9 97 00 00 00       	jmp    803551 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8034ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034bd:	8b 40 08             	mov    0x8(%eax),%eax
  8034c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  8034c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034c7:	0f 85 58 ff ff ff    	jne    803425 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8034cd:	83 ec 0c             	sub    $0xc,%esp
  8034d0:	ff 75 d0             	pushl  -0x30(%ebp)
  8034d3:	e8 b5 18 00 00       	call   804d8d <free_block>
  8034d8:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8034db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034df:	75 17                	jne    8034f8 <free+0x735>
  8034e1:	83 ec 04             	sub    $0x4,%esp
  8034e4:	68 78 63 80 00       	push   $0x806378
  8034e9:	68 37 01 00 00       	push   $0x137
  8034ee:	68 2c 63 80 00       	push   $0x80632c
  8034f3:	e8 e6 e0 ff ff       	call   8015de <_panic>
  8034f8:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  8034fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803501:	89 50 0c             	mov    %edx,0xc(%eax)
  803504:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803507:	8b 40 0c             	mov    0xc(%eax),%eax
  80350a:	85 c0                	test   %eax,%eax
  80350c:	74 0d                	je     80351b <free+0x758>
  80350e:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803513:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803516:	89 50 08             	mov    %edx,0x8(%eax)
  803519:	eb 08                	jmp    803523 <free+0x760>
  80351b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351e:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803523:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803526:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80352b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803535:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80353a:	40                   	inc    %eax
  80353b:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			}
		release_uspinlock(&ulock);
  803540:	83 ec 0c             	sub    $0xc,%esp
  803543:	68 20 f3 81 00       	push   $0x81f320
  803548:	e8 22 1d 00 00       	call   80526f <release_uspinlock>
  80354d:	83 c4 10             	add    $0x10,%esp
		return;
  803550:	90                   	nop
}
  803551:	c9                   	leave  
  803552:	c3                   	ret    

00803553 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  803553:	55                   	push   %ebp
  803554:	89 e5                	mov    %esp,%ebp
  803556:	83 ec 48             	sub    $0x48,%esp
  803559:	8b 45 10             	mov    0x10(%ebp),%eax
  80355c:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80355f:	e8 2d f2 ff ff       	call   802791 <uheap_init>
	if (size == 0) return NULL;
  803564:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803568:	75 0a                	jne    803574 <smalloc+0x21>
  80356a:	b8 00 00 00 00       	mov    $0x0,%eax
  80356f:	e9 84 05 00 00       	jmp    803af8 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  803574:	83 ec 0c             	sub    $0xc,%esp
  803577:	68 20 f3 81 00       	push   $0x81f320
  80357c:	e8 96 1c 00 00       	call   805217 <acquire_uspinlock>
  803581:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803584:	83 ec 0c             	sub    $0xc,%esp
  803587:	6a 10                	push   $0x10
  803589:	e8 63 13 00 00       	call   8048f1 <alloc_block>
  80358e:	83 c4 10             	add    $0x10,%esp
  803591:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  803594:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803598:	75 0a                	jne    8035a4 <smalloc+0x51>
				return NULL;
  80359a:	b8 00 00 00 00       	mov    $0x0,%eax
  80359f:	e9 54 05 00 00       	jmp    803af8 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  8035a4:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8035ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b1:	01 d0                	add    %edx,%eax
  8035b3:	48                   	dec    %eax
  8035b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8035b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8035bf:	f7 75 e8             	divl   -0x18(%ebp)
  8035c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c5:	29 d0                	sub    %edx,%eax
  8035c7:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8035ca:	a1 04 f3 81 00       	mov    0x81f304,%eax
  8035cf:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8035d2:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8035d7:	85 c0                	test   %eax,%eax
  8035d9:	74 0f                	je     8035ea <smalloc+0x97>
  8035db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035de:	8b 40 04             	mov    0x4(%eax),%eax
  8035e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035e4:	0f 83 25 01 00 00    	jae    80370f <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8035ea:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8035ef:	2b 45 0c             	sub    0xc(%ebp),%eax
  8035f2:	89 c2                	mov    %eax,%edx
  8035f4:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8035f9:	39 c2                	cmp    %eax,%edx
  8035fb:	0f 82 f4 00 00 00    	jb     8036f5 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  803601:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803606:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  803609:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80360f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803612:	01 d0                	add    %edx,%eax
  803614:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  803619:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80361c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80361f:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803621:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803624:	8b 55 0c             	mov    0xc(%ebp),%edx
  803627:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80362a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80362e:	75 17                	jne    803647 <smalloc+0xf4>
  803630:	83 ec 04             	sub    $0x4,%esp
  803633:	68 78 63 80 00       	push   $0x806378
  803638:	68 57 01 00 00       	push   $0x157
  80363d:	68 2c 63 80 00       	push   $0x80632c
  803642:	e8 97 df ff ff       	call   8015de <_panic>
  803647:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  80364d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803650:	89 50 0c             	mov    %edx,0xc(%eax)
  803653:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803656:	8b 40 0c             	mov    0xc(%eax),%eax
  803659:	85 c0                	test   %eax,%eax
  80365b:	74 0d                	je     80366a <smalloc+0x117>
  80365d:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803662:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803665:	89 50 08             	mov    %edx,0x8(%eax)
  803668:	eb 08                	jmp    803672 <smalloc+0x11f>
  80366a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80366d:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803675:	a3 14 f3 81 00       	mov    %eax,0x81f314
  80367a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80367d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803684:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803689:	40                   	inc    %eax
  80368a:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80368f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803692:	8b 00                	mov    (%eax),%eax
  803694:	89 c2                	mov    %eax,%edx
  803696:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80369a:	52                   	push   %edx
  80369b:	50                   	push   %eax
  80369c:	ff 75 0c             	pushl  0xc(%ebp)
  80369f:	ff 75 08             	pushl  0x8(%ebp)
  8036a2:	e8 48 0c 00 00       	call   8042ef <sys_create_shared_object>
  8036a7:	83 c4 10             	add    $0x10,%esp
  8036aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  8036ad:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8036b1:	79 28                	jns    8036db <smalloc+0x188>
							free_block(allocblock);
  8036b3:	83 ec 0c             	sub    $0xc,%esp
  8036b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8036b9:	e8 cf 16 00 00       	call   804d8d <free_block>
  8036be:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8036c1:	83 ec 0c             	sub    $0xc,%esp
  8036c4:	68 20 f3 81 00       	push   $0x81f320
  8036c9:	e8 a1 1b 00 00       	call   80526f <release_uspinlock>
  8036ce:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8036d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d6:	e9 1d 04 00 00       	jmp    803af8 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  8036db:	83 ec 0c             	sub    $0xc,%esp
  8036de:	68 20 f3 81 00       	push   $0x81f320
  8036e3:	e8 87 1b 00 00       	call   80526f <release_uspinlock>
  8036e8:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8036eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ee:	8b 00                	mov    (%eax),%eax
  8036f0:	e9 03 04 00 00       	jmp    803af8 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  8036f5:	83 ec 0c             	sub    $0xc,%esp
  8036f8:	68 20 f3 81 00       	push   $0x81f320
  8036fd:	e8 6d 1b 00 00       	call   80526f <release_uspinlock>
  803702:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803705:	b8 00 00 00 00       	mov    $0x0,%eax
  80370a:	e9 e9 03 00 00       	jmp    803af8 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80370f:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803714:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803717:	e9 af 03 00 00       	jmp    803acb <smalloc+0x578>
				if(size<currentfreeelement->size){
  80371c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371f:	8b 40 04             	mov    0x4(%eax),%eax
  803722:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803725:	0f 86 28 02 00 00    	jbe    803953 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  80372b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80372e:	8b 10                	mov    (%eax),%edx
  803730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803733:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  803735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80373b:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  80373e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803742:	75 17                	jne    80375b <smalloc+0x208>
  803744:	83 ec 04             	sub    $0x4,%esp
  803747:	68 78 63 80 00       	push   $0x806378
  80374c:	68 6f 01 00 00       	push   $0x16f
  803751:	68 2c 63 80 00       	push   $0x80632c
  803756:	e8 83 de ff ff       	call   8015de <_panic>
  80375b:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803761:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803764:	89 50 0c             	mov    %edx,0xc(%eax)
  803767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80376a:	8b 40 0c             	mov    0xc(%eax),%eax
  80376d:	85 c0                	test   %eax,%eax
  80376f:	74 0d                	je     80377e <smalloc+0x22b>
  803771:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803776:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803779:	89 50 08             	mov    %edx,0x8(%eax)
  80377c:	eb 08                	jmp    803786 <smalloc+0x233>
  80377e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803781:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803789:	a3 14 f3 81 00       	mov    %eax,0x81f314
  80378e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803791:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803798:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  80379d:	40                   	inc    %eax
  80379e:	a3 1c f3 81 00       	mov    %eax,0x81f31c
	                lastfreeelement->startva += size;
  8037a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037a6:	8b 10                	mov    (%eax),%edx
  8037a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ab:	01 c2                	add    %eax,%edx
  8037ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b0:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  8037b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b5:	8b 40 04             	mov    0x4(%eax),%eax
  8037b8:	2b 45 0c             	sub    0xc(%ebp),%eax
  8037bb:	89 c2                	mov    %eax,%edx
  8037bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c0:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8037c3:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8037c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  8037cb:	e9 13 01 00 00       	jmp    8038e3 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  8037d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d3:	8b 50 04             	mov    0x4(%eax),%edx
  8037d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d9:	8b 40 04             	mov    0x4(%eax),%eax
  8037dc:	39 c2                	cmp    %eax,%edx
  8037de:	0f 83 f6 00 00 00    	jae    8038da <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8037e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8037e8:	75 17                	jne    803801 <smalloc+0x2ae>
  8037ea:	83 ec 04             	sub    $0x4,%esp
  8037ed:	68 9b 63 80 00       	push   $0x80639b
  8037f2:	68 77 01 00 00       	push   $0x177
  8037f7:	68 2c 63 80 00       	push   $0x80632c
  8037fc:	e8 dd dd ff ff       	call   8015de <_panic>
  803801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803804:	8b 40 08             	mov    0x8(%eax),%eax
  803807:	85 c0                	test   %eax,%eax
  803809:	74 11                	je     80381c <smalloc+0x2c9>
  80380b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80380e:	8b 40 08             	mov    0x8(%eax),%eax
  803811:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803814:	8b 52 0c             	mov    0xc(%edx),%edx
  803817:	89 50 0c             	mov    %edx,0xc(%eax)
  80381a:	eb 0b                	jmp    803827 <smalloc+0x2d4>
  80381c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80381f:	8b 40 0c             	mov    0xc(%eax),%eax
  803822:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803827:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80382a:	8b 40 0c             	mov    0xc(%eax),%eax
  80382d:	85 c0                	test   %eax,%eax
  80382f:	74 11                	je     803842 <smalloc+0x2ef>
  803831:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803834:	8b 40 0c             	mov    0xc(%eax),%eax
  803837:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80383a:	8b 52 08             	mov    0x8(%edx),%edx
  80383d:	89 50 08             	mov    %edx,0x8(%eax)
  803840:	eb 0b                	jmp    80384d <smalloc+0x2fa>
  803842:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803845:	8b 40 08             	mov    0x8(%eax),%eax
  803848:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80384d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803850:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803857:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80385a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803861:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803866:	48                   	dec    %eax
  803867:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80386c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803870:	74 06                	je     803878 <smalloc+0x325>
  803872:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803876:	75 17                	jne    80388f <smalloc+0x33c>
  803878:	83 ec 04             	sub    $0x4,%esp
  80387b:	68 bc 63 80 00       	push   $0x8063bc
  803880:	68 78 01 00 00       	push   $0x178
  803885:	68 2c 63 80 00       	push   $0x80632c
  80388a:	e8 4f dd ff ff       	call   8015de <_panic>
  80388f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803892:	8b 50 0c             	mov    0xc(%eax),%edx
  803895:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803898:	89 50 0c             	mov    %edx,0xc(%eax)
  80389b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80389e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038a1:	89 50 08             	mov    %edx,0x8(%eax)
  8038a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8038aa:	85 c0                	test   %eax,%eax
  8038ac:	74 0e                	je     8038bc <smalloc+0x369>
  8038ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038b7:	89 50 08             	mov    %edx,0x8(%eax)
  8038ba:	eb 08                	jmp    8038c4 <smalloc+0x371>
  8038bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038bf:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8038c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038ca:	89 50 0c             	mov    %edx,0xc(%eax)
  8038cd:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8038d2:	40                   	inc    %eax
  8038d3:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		break;
  8038d8:	eb 13                	jmp    8038ed <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  8038da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038dd:	8b 40 08             	mov    0x8(%eax),%eax
  8038e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  8038e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038e7:	0f 85 e3 fe ff ff    	jne    8037d0 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8038ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038f0:	8b 00                	mov    (%eax),%eax
  8038f2:	89 c2                	mov    %eax,%edx
  8038f4:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8038f8:	52                   	push   %edx
  8038f9:	50                   	push   %eax
  8038fa:	ff 75 0c             	pushl  0xc(%ebp)
  8038fd:	ff 75 08             	pushl  0x8(%ebp)
  803900:	e8 ea 09 00 00       	call   8042ef <sys_create_shared_object>
  803905:	83 c4 10             	add    $0x10,%esp
  803908:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  80390b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80390f:	79 28                	jns    803939 <smalloc+0x3e6>
	                	free_block(allocblock);
  803911:	83 ec 0c             	sub    $0xc,%esp
  803914:	ff 75 ec             	pushl  -0x14(%ebp)
  803917:	e8 71 14 00 00       	call   804d8d <free_block>
  80391c:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  80391f:	83 ec 0c             	sub    $0xc,%esp
  803922:	68 20 f3 81 00       	push   $0x81f320
  803927:	e8 43 19 00 00       	call   80526f <release_uspinlock>
  80392c:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  80392f:	b8 00 00 00 00       	mov    $0x0,%eax
  803934:	e9 bf 01 00 00       	jmp    803af8 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  803939:	83 ec 0c             	sub    $0xc,%esp
  80393c:	68 20 f3 81 00       	push   $0x81f320
  803941:	e8 29 19 00 00       	call   80526f <release_uspinlock>
  803946:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  803949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	e9 a5 01 00 00       	jmp    803af8 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  803953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803956:	8b 40 04             	mov    0x4(%eax),%eax
  803959:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80395c:	0f 85 60 01 00 00    	jne    803ac2 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  803962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803965:	8b 10                	mov    (%eax),%edx
  803967:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80396a:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80396c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80396f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803972:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803975:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803979:	75 17                	jne    803992 <smalloc+0x43f>
  80397b:	83 ec 04             	sub    $0x4,%esp
  80397e:	68 78 63 80 00       	push   $0x806378
  803983:	68 8c 01 00 00       	push   $0x18c
  803988:	68 2c 63 80 00       	push   $0x80632c
  80398d:	e8 4c dc ff ff       	call   8015de <_panic>
  803992:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80399b:	89 50 0c             	mov    %edx,0xc(%eax)
  80399e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8039a4:	85 c0                	test   %eax,%eax
  8039a6:	74 0d                	je     8039b5 <smalloc+0x462>
  8039a8:	a1 14 f3 81 00       	mov    0x81f314,%eax
  8039ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039b0:	89 50 08             	mov    %edx,0x8(%eax)
  8039b3:	eb 08                	jmp    8039bd <smalloc+0x46a>
  8039b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039b8:	a3 10 f3 81 00       	mov    %eax,0x81f310
  8039bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039c0:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8039c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8039cf:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  8039d4:	40                   	inc    %eax
  8039d5:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8039da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039de:	75 17                	jne    8039f7 <smalloc+0x4a4>
  8039e0:	83 ec 04             	sub    $0x4,%esp
  8039e3:	68 9b 63 80 00       	push   $0x80639b
  8039e8:	68 8d 01 00 00       	push   $0x18d
  8039ed:	68 2c 63 80 00       	push   $0x80632c
  8039f2:	e8 e7 db ff ff       	call   8015de <_panic>
  8039f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fa:	8b 40 08             	mov    0x8(%eax),%eax
  8039fd:	85 c0                	test   %eax,%eax
  8039ff:	74 11                	je     803a12 <smalloc+0x4bf>
  803a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a04:	8b 40 08             	mov    0x8(%eax),%eax
  803a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a0a:	8b 52 0c             	mov    0xc(%edx),%edx
  803a0d:	89 50 0c             	mov    %edx,0xc(%eax)
  803a10:	eb 0b                	jmp    803a1d <smalloc+0x4ca>
  803a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a15:	8b 40 0c             	mov    0xc(%eax),%eax
  803a18:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a20:	8b 40 0c             	mov    0xc(%eax),%eax
  803a23:	85 c0                	test   %eax,%eax
  803a25:	74 11                	je     803a38 <smalloc+0x4e5>
  803a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  803a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a30:	8b 52 08             	mov    0x8(%edx),%edx
  803a33:	89 50 08             	mov    %edx,0x8(%eax)
  803a36:	eb 0b                	jmp    803a43 <smalloc+0x4f0>
  803a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3b:	8b 40 08             	mov    0x8(%eax),%eax
  803a3e:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a50:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803a57:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803a5c:	48                   	dec    %eax
  803a5d:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a65:	8b 00                	mov    (%eax),%eax
  803a67:	89 c2                	mov    %eax,%edx
  803a69:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803a6d:	52                   	push   %edx
  803a6e:	50                   	push   %eax
  803a6f:	ff 75 0c             	pushl  0xc(%ebp)
  803a72:	ff 75 08             	pushl  0x8(%ebp)
  803a75:	e8 75 08 00 00       	call   8042ef <sys_create_shared_object>
  803a7a:	83 c4 10             	add    $0x10,%esp
  803a7d:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  803a80:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a84:	79 25                	jns    803aab <smalloc+0x558>
						free_block(allocblock);
  803a86:	83 ec 0c             	sub    $0xc,%esp
  803a89:	ff 75 ec             	pushl  -0x14(%ebp)
  803a8c:	e8 fc 12 00 00       	call   804d8d <free_block>
  803a91:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803a94:	83 ec 0c             	sub    $0xc,%esp
  803a97:	68 20 f3 81 00       	push   $0x81f320
  803a9c:	e8 ce 17 00 00       	call   80526f <release_uspinlock>
  803aa1:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa9:	eb 4d                	jmp    803af8 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  803aab:	83 ec 0c             	sub    $0xc,%esp
  803aae:	68 20 f3 81 00       	push   $0x81f320
  803ab3:	e8 b7 17 00 00       	call   80526f <release_uspinlock>
  803ab8:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803abe:	8b 00                	mov    (%eax),%eax
  803ac0:	eb 36                	jmp    803af8 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac5:	8b 40 08             	mov    0x8(%eax),%eax
  803ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803acb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803acf:	0f 85 47 fc ff ff    	jne    80371c <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  803ad5:	83 ec 0c             	sub    $0xc,%esp
  803ad8:	ff 75 ec             	pushl  -0x14(%ebp)
  803adb:	e8 ad 12 00 00       	call   804d8d <free_block>
  803ae0:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803ae3:	83 ec 0c             	sub    $0xc,%esp
  803ae6:	68 20 f3 81 00       	push   $0x81f320
  803aeb:	e8 7f 17 00 00       	call   80526f <release_uspinlock>
  803af0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803af3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803af8:	c9                   	leave  
  803af9:	c3                   	ret    

00803afa <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  803afa:	55                   	push   %ebp
  803afb:	89 e5                	mov    %esp,%ebp
  803afd:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  803b00:	e8 8c ec ff ff       	call   802791 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  803b05:	83 ec 0c             	sub    $0xc,%esp
  803b08:	68 20 f3 81 00       	push   $0x81f320
  803b0d:	e8 05 17 00 00       	call   805217 <acquire_uspinlock>
  803b12:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  803b15:	83 ec 08             	sub    $0x8,%esp
  803b18:	ff 75 0c             	pushl  0xc(%ebp)
  803b1b:	ff 75 08             	pushl  0x8(%ebp)
  803b1e:	e8 f6 07 00 00       	call   804319 <sys_size_of_shared_object>
  803b23:	83 c4 10             	add    $0x10,%esp
  803b26:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  803b29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b2d:	79 1a                	jns    803b49 <sget+0x4f>
			release_uspinlock(&ulock);
  803b2f:	83 ec 0c             	sub    $0xc,%esp
  803b32:	68 20 f3 81 00       	push   $0x81f320
  803b37:	e8 33 17 00 00       	call   80526f <release_uspinlock>
  803b3c:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b44:	e9 6e 05 00 00       	jmp    8040b7 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  803b49:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803b50:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b56:	01 d0                	add    %edx,%eax
  803b58:	48                   	dec    %eax
  803b59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803b5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  803b64:	f7 75 e8             	divl   -0x18(%ebp)
  803b67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6a:	29 d0                	sub    %edx,%eax
  803b6c:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803b6f:	83 ec 0c             	sub    $0xc,%esp
  803b72:	6a 10                	push   $0x10
  803b74:	e8 78 0d 00 00       	call   8048f1 <alloc_block>
  803b79:	83 c4 10             	add    $0x10,%esp
  803b7c:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  803b7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803b83:	75 0a                	jne    803b8f <sget+0x95>
			return NULL;
  803b85:	b8 00 00 00 00       	mov    $0x0,%eax
  803b8a:	e9 28 05 00 00       	jmp    8040b7 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803b8f:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803b94:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  803b97:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803b9c:	85 c0                	test   %eax,%eax
  803b9e:	74 11                	je     803bb1 <sget+0xb7>
  803ba0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ba3:	8b 50 04             	mov    0x4(%eax),%edx
  803ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ba9:	39 c2                	cmp    %eax,%edx
  803bab:	0f 83 21 01 00 00    	jae    803cd2 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  803bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bb4:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  803bb9:	29 c2                	sub    %eax,%edx
  803bbb:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803bc0:	39 c2                	cmp    %eax,%edx
  803bc2:	0f 82 f0 00 00 00    	jb     803cb8 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  803bc8:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803bcd:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  803bd0:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd9:	01 d0                	add    %edx,%eax
  803bdb:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  803be0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803be3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803be6:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803be8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803beb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bee:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  803bf1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803bf5:	75 17                	jne    803c0e <sget+0x114>
  803bf7:	83 ec 04             	sub    $0x4,%esp
  803bfa:	68 78 63 80 00       	push   $0x806378
  803bff:	68 c8 01 00 00       	push   $0x1c8
  803c04:	68 2c 63 80 00       	push   $0x80632c
  803c09:	e8 d0 d9 ff ff       	call   8015de <_panic>
  803c0e:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803c14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c17:	89 50 0c             	mov    %edx,0xc(%eax)
  803c1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  803c20:	85 c0                	test   %eax,%eax
  803c22:	74 0d                	je     803c31 <sget+0x137>
  803c24:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803c29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c2c:	89 50 08             	mov    %edx,0x8(%eax)
  803c2f:	eb 08                	jmp    803c39 <sget+0x13f>
  803c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c34:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803c39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c3c:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c44:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803c4b:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803c50:	40                   	inc    %eax
  803c51:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803c56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c59:	8b 00                	mov    (%eax),%eax
  803c5b:	83 ec 04             	sub    $0x4,%esp
  803c5e:	50                   	push   %eax
  803c5f:	ff 75 0c             	pushl  0xc(%ebp)
  803c62:	ff 75 08             	pushl  0x8(%ebp)
  803c65:	e8 cc 06 00 00       	call   804336 <sys_get_shared_object>
  803c6a:	83 c4 10             	add    $0x10,%esp
  803c6d:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  803c70:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803c74:	79 28                	jns    803c9e <sget+0x1a4>
							free_block(allocblock);
  803c76:	83 ec 0c             	sub    $0xc,%esp
  803c79:	ff 75 e0             	pushl  -0x20(%ebp)
  803c7c:	e8 0c 11 00 00       	call   804d8d <free_block>
  803c81:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803c84:	83 ec 0c             	sub    $0xc,%esp
  803c87:	68 20 f3 81 00       	push   $0x81f320
  803c8c:	e8 de 15 00 00       	call   80526f <release_uspinlock>
  803c91:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803c94:	b8 00 00 00 00       	mov    $0x0,%eax
  803c99:	e9 19 04 00 00       	jmp    8040b7 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  803c9e:	83 ec 0c             	sub    $0xc,%esp
  803ca1:	68 20 f3 81 00       	push   $0x81f320
  803ca6:	e8 c4 15 00 00       	call   80526f <release_uspinlock>
  803cab:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803cae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cb1:	8b 00                	mov    (%eax),%eax
  803cb3:	e9 ff 03 00 00       	jmp    8040b7 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  803cb8:	83 ec 0c             	sub    $0xc,%esp
  803cbb:	68 20 f3 81 00       	push   $0x81f320
  803cc0:	e8 aa 15 00 00       	call   80526f <release_uspinlock>
  803cc5:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ccd:	e9 e5 03 00 00       	jmp    8040b7 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803cd2:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803cda:	e9 ab 03 00 00       	jmp    80408a <sget+0x590>
				if(size<currentfreeelement->size){
  803cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce2:	8b 50 04             	mov    0x4(%eax),%edx
  803ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ce8:	39 c2                	cmp    %eax,%edx
  803cea:	0f 86 24 02 00 00    	jbe    803f14 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  803cf0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cf3:	8b 10                	mov    (%eax),%edx
  803cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cf8:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803cfa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d00:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803d03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d07:	75 17                	jne    803d20 <sget+0x226>
  803d09:	83 ec 04             	sub    $0x4,%esp
  803d0c:	68 78 63 80 00       	push   $0x806378
  803d11:	68 e0 01 00 00       	push   $0x1e0
  803d16:	68 2c 63 80 00       	push   $0x80632c
  803d1b:	e8 be d8 ff ff       	call   8015de <_panic>
  803d20:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803d26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d29:	89 50 0c             	mov    %edx,0xc(%eax)
  803d2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d2f:	8b 40 0c             	mov    0xc(%eax),%eax
  803d32:	85 c0                	test   %eax,%eax
  803d34:	74 0d                	je     803d43 <sget+0x249>
  803d36:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803d3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d3e:	89 50 08             	mov    %edx,0x8(%eax)
  803d41:	eb 08                	jmp    803d4b <sget+0x251>
  803d43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d46:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803d4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d4e:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803d53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803d5d:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803d62:	40                   	inc    %eax
  803d63:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					lastfreeelement->startva += size;
  803d68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d6b:	8b 10                	mov    (%eax),%edx
  803d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d70:	01 c2                	add    %eax,%edx
  803d72:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d75:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  803d77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d7a:	8b 50 04             	mov    0x4(%eax),%edx
  803d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d80:	29 c2                	sub    %eax,%edx
  803d82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d85:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803d88:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  803d90:	e9 13 01 00 00       	jmp    803ea8 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  803d95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d98:	8b 50 04             	mov    0x4(%eax),%edx
  803d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d9e:	8b 40 04             	mov    0x4(%eax),%eax
  803da1:	39 c2                	cmp    %eax,%edx
  803da3:	0f 83 f6 00 00 00    	jae    803e9f <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  803da9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803dad:	75 17                	jne    803dc6 <sget+0x2cc>
  803daf:	83 ec 04             	sub    $0x4,%esp
  803db2:	68 9b 63 80 00       	push   $0x80639b
  803db7:	68 e8 01 00 00       	push   $0x1e8
  803dbc:	68 2c 63 80 00       	push   $0x80632c
  803dc1:	e8 18 d8 ff ff       	call   8015de <_panic>
  803dc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dc9:	8b 40 08             	mov    0x8(%eax),%eax
  803dcc:	85 c0                	test   %eax,%eax
  803dce:	74 11                	je     803de1 <sget+0x2e7>
  803dd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dd3:	8b 40 08             	mov    0x8(%eax),%eax
  803dd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dd9:	8b 52 0c             	mov    0xc(%edx),%edx
  803ddc:	89 50 0c             	mov    %edx,0xc(%eax)
  803ddf:	eb 0b                	jmp    803dec <sget+0x2f2>
  803de1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803de4:	8b 40 0c             	mov    0xc(%eax),%eax
  803de7:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803dec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803def:	8b 40 0c             	mov    0xc(%eax),%eax
  803df2:	85 c0                	test   %eax,%eax
  803df4:	74 11                	je     803e07 <sget+0x30d>
  803df6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803df9:	8b 40 0c             	mov    0xc(%eax),%eax
  803dfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dff:	8b 52 08             	mov    0x8(%edx),%edx
  803e02:	89 50 08             	mov    %edx,0x8(%eax)
  803e05:	eb 0b                	jmp    803e12 <sget+0x318>
  803e07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e0a:	8b 40 08             	mov    0x8(%eax),%eax
  803e0d:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803e12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e15:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803e1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e1f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803e26:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803e2b:	48                   	dec    %eax
  803e2c:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803e31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e35:	74 06                	je     803e3d <sget+0x343>
  803e37:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e3b:	75 17                	jne    803e54 <sget+0x35a>
  803e3d:	83 ec 04             	sub    $0x4,%esp
  803e40:	68 bc 63 80 00       	push   $0x8063bc
  803e45:	68 e9 01 00 00       	push   $0x1e9
  803e4a:	68 2c 63 80 00       	push   $0x80632c
  803e4f:	e8 8a d7 ff ff       	call   8015de <_panic>
  803e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e57:	8b 50 0c             	mov    0xc(%eax),%edx
  803e5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e5d:	89 50 0c             	mov    %edx,0xc(%eax)
  803e60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e66:	89 50 08             	mov    %edx,0x8(%eax)
  803e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e6c:	8b 40 0c             	mov    0xc(%eax),%eax
  803e6f:	85 c0                	test   %eax,%eax
  803e71:	74 0e                	je     803e81 <sget+0x387>
  803e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e76:	8b 40 0c             	mov    0xc(%eax),%eax
  803e79:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e7c:	89 50 08             	mov    %edx,0x8(%eax)
  803e7f:	eb 08                	jmp    803e89 <sget+0x38f>
  803e81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e84:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e8f:	89 50 0c             	mov    %edx,0xc(%eax)
  803e92:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803e97:	40                   	inc    %eax
  803e98:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							break;
  803e9d:	eb 13                	jmp    803eb2 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  803e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ea2:	8b 40 08             	mov    0x8(%eax),%eax
  803ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  803ea8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803eac:	0f 85 e3 fe ff ff    	jne    803d95 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803eb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803eb5:	8b 00                	mov    (%eax),%eax
  803eb7:	83 ec 04             	sub    $0x4,%esp
  803eba:	50                   	push   %eax
  803ebb:	ff 75 0c             	pushl  0xc(%ebp)
  803ebe:	ff 75 08             	pushl  0x8(%ebp)
  803ec1:	e8 70 04 00 00       	call   804336 <sys_get_shared_object>
  803ec6:	83 c4 10             	add    $0x10,%esp
  803ec9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  803ecc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ed0:	79 28                	jns    803efa <sget+0x400>
						free_block(allocblock);
  803ed2:	83 ec 0c             	sub    $0xc,%esp
  803ed5:	ff 75 e0             	pushl  -0x20(%ebp)
  803ed8:	e8 b0 0e 00 00       	call   804d8d <free_block>
  803edd:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803ee0:	83 ec 0c             	sub    $0xc,%esp
  803ee3:	68 20 f3 81 00       	push   $0x81f320
  803ee8:	e8 82 13 00 00       	call   80526f <release_uspinlock>
  803eed:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ef5:	e9 bd 01 00 00       	jmp    8040b7 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  803efa:	83 ec 0c             	sub    $0xc,%esp
  803efd:	68 20 f3 81 00       	push   $0x81f320
  803f02:	e8 68 13 00 00       	call   80526f <release_uspinlock>
  803f07:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803f0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f0d:	8b 00                	mov    (%eax),%eax
  803f0f:	e9 a3 01 00 00       	jmp    8040b7 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  803f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f17:	8b 50 04             	mov    0x4(%eax),%edx
  803f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f1d:	39 c2                	cmp    %eax,%edx
  803f1f:	0f 85 5c 01 00 00    	jne    804081 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  803f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f28:	8b 10                	mov    (%eax),%edx
  803f2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f2d:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803f2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f35:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803f38:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803f3c:	75 17                	jne    803f55 <sget+0x45b>
  803f3e:	83 ec 04             	sub    $0x4,%esp
  803f41:	68 78 63 80 00       	push   $0x806378
  803f46:	68 fe 01 00 00       	push   $0x1fe
  803f4b:	68 2c 63 80 00       	push   $0x80632c
  803f50:	e8 89 d6 ff ff       	call   8015de <_panic>
  803f55:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803f5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f5e:	89 50 0c             	mov    %edx,0xc(%eax)
  803f61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f64:	8b 40 0c             	mov    0xc(%eax),%eax
  803f67:	85 c0                	test   %eax,%eax
  803f69:	74 0d                	je     803f78 <sget+0x47e>
  803f6b:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803f70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f73:	89 50 08             	mov    %edx,0x8(%eax)
  803f76:	eb 08                	jmp    803f80 <sget+0x486>
  803f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f7b:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f83:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803f88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f8b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803f92:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803f97:	40                   	inc    %eax
  803f98:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803f9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fa1:	75 17                	jne    803fba <sget+0x4c0>
  803fa3:	83 ec 04             	sub    $0x4,%esp
  803fa6:	68 9b 63 80 00       	push   $0x80639b
  803fab:	68 ff 01 00 00       	push   $0x1ff
  803fb0:	68 2c 63 80 00       	push   $0x80632c
  803fb5:	e8 24 d6 ff ff       	call   8015de <_panic>
  803fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fbd:	8b 40 08             	mov    0x8(%eax),%eax
  803fc0:	85 c0                	test   %eax,%eax
  803fc2:	74 11                	je     803fd5 <sget+0x4db>
  803fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc7:	8b 40 08             	mov    0x8(%eax),%eax
  803fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fcd:	8b 52 0c             	mov    0xc(%edx),%edx
  803fd0:	89 50 0c             	mov    %edx,0xc(%eax)
  803fd3:	eb 0b                	jmp    803fe0 <sget+0x4e6>
  803fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd8:	8b 40 0c             	mov    0xc(%eax),%eax
  803fdb:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe3:	8b 40 0c             	mov    0xc(%eax),%eax
  803fe6:	85 c0                	test   %eax,%eax
  803fe8:	74 11                	je     803ffb <sget+0x501>
  803fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fed:	8b 40 0c             	mov    0xc(%eax),%eax
  803ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ff3:	8b 52 08             	mov    0x8(%edx),%edx
  803ff6:	89 50 08             	mov    %edx,0x8(%eax)
  803ff9:	eb 0b                	jmp    804006 <sget+0x50c>
  803ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ffe:	8b 40 08             	mov    0x8(%eax),%eax
  804001:	a3 00 f3 81 00       	mov    %eax,0x81f300
  804006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804009:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  804010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804013:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80401a:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80401f:	48                   	dec    %eax
  804020:	a3 0c f3 81 00       	mov    %eax,0x81f30c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  804025:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804028:	8b 00                	mov    (%eax),%eax
  80402a:	83 ec 04             	sub    $0x4,%esp
  80402d:	50                   	push   %eax
  80402e:	ff 75 0c             	pushl  0xc(%ebp)
  804031:	ff 75 08             	pushl  0x8(%ebp)
  804034:	e8 fd 02 00 00       	call   804336 <sys_get_shared_object>
  804039:	83 c4 10             	add    $0x10,%esp
  80403c:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  80403f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  804043:	79 25                	jns    80406a <sget+0x570>
						free_block(allocblock);
  804045:	83 ec 0c             	sub    $0xc,%esp
  804048:	ff 75 e0             	pushl  -0x20(%ebp)
  80404b:	e8 3d 0d 00 00       	call   804d8d <free_block>
  804050:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  804053:	83 ec 0c             	sub    $0xc,%esp
  804056:	68 20 f3 81 00       	push   $0x81f320
  80405b:	e8 0f 12 00 00       	call   80526f <release_uspinlock>
  804060:	83 c4 10             	add    $0x10,%esp
						return NULL;
  804063:	b8 00 00 00 00       	mov    $0x0,%eax
  804068:	eb 4d                	jmp    8040b7 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  80406a:	83 ec 0c             	sub    $0xc,%esp
  80406d:	68 20 f3 81 00       	push   $0x81f320
  804072:	e8 f8 11 00 00       	call   80526f <release_uspinlock>
  804077:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80407a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80407d:	8b 00                	mov    (%eax),%eax
  80407f:	eb 36                	jmp    8040b7 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  804081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804084:	8b 40 08             	mov    0x8(%eax),%eax
  804087:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  80408a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80408e:	0f 85 4b fc ff ff    	jne    803cdf <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  804094:	83 ec 0c             	sub    $0xc,%esp
  804097:	ff 75 e0             	pushl  -0x20(%ebp)
  80409a:	e8 ee 0c 00 00       	call   804d8d <free_block>
  80409f:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8040a2:	83 ec 0c             	sub    $0xc,%esp
  8040a5:	68 20 f3 81 00       	push   $0x81f320
  8040aa:	e8 c0 11 00 00       	call   80526f <release_uspinlock>
  8040af:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8040b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040b7:	c9                   	leave  
  8040b8:	c3                   	ret    

008040b9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8040b9:	55                   	push   %ebp
  8040ba:	89 e5                	mov    %esp,%ebp
  8040bc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8040bf:	e8 cd e6 ff ff       	call   802791 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8040c4:	83 ec 04             	sub    $0x4,%esp
  8040c7:	68 4c 64 80 00       	push   $0x80644c
  8040cc:	68 2d 02 00 00       	push   $0x22d
  8040d1:	68 2c 63 80 00       	push   $0x80632c
  8040d6:	e8 03 d5 ff ff       	call   8015de <_panic>

008040db <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8040db:	55                   	push   %ebp
  8040dc:	89 e5                	mov    %esp,%ebp
  8040de:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8040e1:	83 ec 04             	sub    $0x4,%esp
  8040e4:	68 74 64 80 00       	push   $0x806474
  8040e9:	68 40 02 00 00       	push   $0x240
  8040ee:	68 2c 63 80 00       	push   $0x80632c
  8040f3:	e8 e6 d4 ff ff       	call   8015de <_panic>

008040f8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8040f8:	55                   	push   %ebp
  8040f9:	89 e5                	mov    %esp,%ebp
  8040fb:	57                   	push   %edi
  8040fc:	56                   	push   %esi
  8040fd:	53                   	push   %ebx
  8040fe:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  804101:	8b 45 08             	mov    0x8(%ebp),%eax
  804104:	8b 55 0c             	mov    0xc(%ebp),%edx
  804107:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80410a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80410d:	8b 7d 18             	mov    0x18(%ebp),%edi
  804110:	8b 75 1c             	mov    0x1c(%ebp),%esi
  804113:	cd 30                	int    $0x30
  804115:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  804118:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80411b:	83 c4 10             	add    $0x10,%esp
  80411e:	5b                   	pop    %ebx
  80411f:	5e                   	pop    %esi
  804120:	5f                   	pop    %edi
  804121:	5d                   	pop    %ebp
  804122:	c3                   	ret    

00804123 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  804123:	55                   	push   %ebp
  804124:	89 e5                	mov    %esp,%ebp
  804126:	83 ec 04             	sub    $0x4,%esp
  804129:	8b 45 10             	mov    0x10(%ebp),%eax
  80412c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80412f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  804132:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  804136:	8b 45 08             	mov    0x8(%ebp),%eax
  804139:	6a 00                	push   $0x0
  80413b:	51                   	push   %ecx
  80413c:	52                   	push   %edx
  80413d:	ff 75 0c             	pushl  0xc(%ebp)
  804140:	50                   	push   %eax
  804141:	6a 00                	push   $0x0
  804143:	e8 b0 ff ff ff       	call   8040f8 <syscall>
  804148:	83 c4 18             	add    $0x18,%esp
}
  80414b:	90                   	nop
  80414c:	c9                   	leave  
  80414d:	c3                   	ret    

0080414e <sys_cgetc>:

int
sys_cgetc(void)
{
  80414e:	55                   	push   %ebp
  80414f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  804151:	6a 00                	push   $0x0
  804153:	6a 00                	push   $0x0
  804155:	6a 00                	push   $0x0
  804157:	6a 00                	push   $0x0
  804159:	6a 00                	push   $0x0
  80415b:	6a 02                	push   $0x2
  80415d:	e8 96 ff ff ff       	call   8040f8 <syscall>
  804162:	83 c4 18             	add    $0x18,%esp
}
  804165:	c9                   	leave  
  804166:	c3                   	ret    

00804167 <sys_lock_cons>:

void sys_lock_cons(void)
{
  804167:	55                   	push   %ebp
  804168:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80416a:	6a 00                	push   $0x0
  80416c:	6a 00                	push   $0x0
  80416e:	6a 00                	push   $0x0
  804170:	6a 00                	push   $0x0
  804172:	6a 00                	push   $0x0
  804174:	6a 03                	push   $0x3
  804176:	e8 7d ff ff ff       	call   8040f8 <syscall>
  80417b:	83 c4 18             	add    $0x18,%esp
}
  80417e:	90                   	nop
  80417f:	c9                   	leave  
  804180:	c3                   	ret    

00804181 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  804181:	55                   	push   %ebp
  804182:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  804184:	6a 00                	push   $0x0
  804186:	6a 00                	push   $0x0
  804188:	6a 00                	push   $0x0
  80418a:	6a 00                	push   $0x0
  80418c:	6a 00                	push   $0x0
  80418e:	6a 04                	push   $0x4
  804190:	e8 63 ff ff ff       	call   8040f8 <syscall>
  804195:	83 c4 18             	add    $0x18,%esp
}
  804198:	90                   	nop
  804199:	c9                   	leave  
  80419a:	c3                   	ret    

0080419b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80419b:	55                   	push   %ebp
  80419c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80419e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a4:	6a 00                	push   $0x0
  8041a6:	6a 00                	push   $0x0
  8041a8:	6a 00                	push   $0x0
  8041aa:	52                   	push   %edx
  8041ab:	50                   	push   %eax
  8041ac:	6a 08                	push   $0x8
  8041ae:	e8 45 ff ff ff       	call   8040f8 <syscall>
  8041b3:	83 c4 18             	add    $0x18,%esp
}
  8041b6:	c9                   	leave  
  8041b7:	c3                   	ret    

008041b8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8041b8:	55                   	push   %ebp
  8041b9:	89 e5                	mov    %esp,%ebp
  8041bb:	56                   	push   %esi
  8041bc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8041bd:	8b 75 18             	mov    0x18(%ebp),%esi
  8041c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8041c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8041c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8041cc:	56                   	push   %esi
  8041cd:	53                   	push   %ebx
  8041ce:	51                   	push   %ecx
  8041cf:	52                   	push   %edx
  8041d0:	50                   	push   %eax
  8041d1:	6a 09                	push   $0x9
  8041d3:	e8 20 ff ff ff       	call   8040f8 <syscall>
  8041d8:	83 c4 18             	add    $0x18,%esp
}
  8041db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8041de:	5b                   	pop    %ebx
  8041df:	5e                   	pop    %esi
  8041e0:	5d                   	pop    %ebp
  8041e1:	c3                   	ret    

008041e2 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8041e2:	55                   	push   %ebp
  8041e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8041e5:	6a 00                	push   $0x0
  8041e7:	6a 00                	push   $0x0
  8041e9:	6a 00                	push   $0x0
  8041eb:	6a 00                	push   $0x0
  8041ed:	ff 75 08             	pushl  0x8(%ebp)
  8041f0:	6a 0a                	push   $0xa
  8041f2:	e8 01 ff ff ff       	call   8040f8 <syscall>
  8041f7:	83 c4 18             	add    $0x18,%esp
}
  8041fa:	c9                   	leave  
  8041fb:	c3                   	ret    

008041fc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8041fc:	55                   	push   %ebp
  8041fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8041ff:	6a 00                	push   $0x0
  804201:	6a 00                	push   $0x0
  804203:	6a 00                	push   $0x0
  804205:	ff 75 0c             	pushl  0xc(%ebp)
  804208:	ff 75 08             	pushl  0x8(%ebp)
  80420b:	6a 0b                	push   $0xb
  80420d:	e8 e6 fe ff ff       	call   8040f8 <syscall>
  804212:	83 c4 18             	add    $0x18,%esp
}
  804215:	c9                   	leave  
  804216:	c3                   	ret    

00804217 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  804217:	55                   	push   %ebp
  804218:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80421a:	6a 00                	push   $0x0
  80421c:	6a 00                	push   $0x0
  80421e:	6a 00                	push   $0x0
  804220:	6a 00                	push   $0x0
  804222:	6a 00                	push   $0x0
  804224:	6a 0c                	push   $0xc
  804226:	e8 cd fe ff ff       	call   8040f8 <syscall>
  80422b:	83 c4 18             	add    $0x18,%esp
}
  80422e:	c9                   	leave  
  80422f:	c3                   	ret    

00804230 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  804230:	55                   	push   %ebp
  804231:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  804233:	6a 00                	push   $0x0
  804235:	6a 00                	push   $0x0
  804237:	6a 00                	push   $0x0
  804239:	6a 00                	push   $0x0
  80423b:	6a 00                	push   $0x0
  80423d:	6a 0d                	push   $0xd
  80423f:	e8 b4 fe ff ff       	call   8040f8 <syscall>
  804244:	83 c4 18             	add    $0x18,%esp
}
  804247:	c9                   	leave  
  804248:	c3                   	ret    

00804249 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  804249:	55                   	push   %ebp
  80424a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80424c:	6a 00                	push   $0x0
  80424e:	6a 00                	push   $0x0
  804250:	6a 00                	push   $0x0
  804252:	6a 00                	push   $0x0
  804254:	6a 00                	push   $0x0
  804256:	6a 0e                	push   $0xe
  804258:	e8 9b fe ff ff       	call   8040f8 <syscall>
  80425d:	83 c4 18             	add    $0x18,%esp
}
  804260:	c9                   	leave  
  804261:	c3                   	ret    

00804262 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  804262:	55                   	push   %ebp
  804263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  804265:	6a 00                	push   $0x0
  804267:	6a 00                	push   $0x0
  804269:	6a 00                	push   $0x0
  80426b:	6a 00                	push   $0x0
  80426d:	6a 00                	push   $0x0
  80426f:	6a 0f                	push   $0xf
  804271:	e8 82 fe ff ff       	call   8040f8 <syscall>
  804276:	83 c4 18             	add    $0x18,%esp
}
  804279:	c9                   	leave  
  80427a:	c3                   	ret    

0080427b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80427b:	55                   	push   %ebp
  80427c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80427e:	6a 00                	push   $0x0
  804280:	6a 00                	push   $0x0
  804282:	6a 00                	push   $0x0
  804284:	6a 00                	push   $0x0
  804286:	ff 75 08             	pushl  0x8(%ebp)
  804289:	6a 10                	push   $0x10
  80428b:	e8 68 fe ff ff       	call   8040f8 <syscall>
  804290:	83 c4 18             	add    $0x18,%esp
}
  804293:	c9                   	leave  
  804294:	c3                   	ret    

00804295 <sys_scarce_memory>:

void sys_scarce_memory()
{
  804295:	55                   	push   %ebp
  804296:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  804298:	6a 00                	push   $0x0
  80429a:	6a 00                	push   $0x0
  80429c:	6a 00                	push   $0x0
  80429e:	6a 00                	push   $0x0
  8042a0:	6a 00                	push   $0x0
  8042a2:	6a 11                	push   $0x11
  8042a4:	e8 4f fe ff ff       	call   8040f8 <syscall>
  8042a9:	83 c4 18             	add    $0x18,%esp
}
  8042ac:	90                   	nop
  8042ad:	c9                   	leave  
  8042ae:	c3                   	ret    

008042af <sys_cputc>:

void
sys_cputc(const char c)
{
  8042af:	55                   	push   %ebp
  8042b0:	89 e5                	mov    %esp,%ebp
  8042b2:	83 ec 04             	sub    $0x4,%esp
  8042b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8042bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8042bf:	6a 00                	push   $0x0
  8042c1:	6a 00                	push   $0x0
  8042c3:	6a 00                	push   $0x0
  8042c5:	6a 00                	push   $0x0
  8042c7:	50                   	push   %eax
  8042c8:	6a 01                	push   $0x1
  8042ca:	e8 29 fe ff ff       	call   8040f8 <syscall>
  8042cf:	83 c4 18             	add    $0x18,%esp
}
  8042d2:	90                   	nop
  8042d3:	c9                   	leave  
  8042d4:	c3                   	ret    

008042d5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8042d5:	55                   	push   %ebp
  8042d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8042d8:	6a 00                	push   $0x0
  8042da:	6a 00                	push   $0x0
  8042dc:	6a 00                	push   $0x0
  8042de:	6a 00                	push   $0x0
  8042e0:	6a 00                	push   $0x0
  8042e2:	6a 14                	push   $0x14
  8042e4:	e8 0f fe ff ff       	call   8040f8 <syscall>
  8042e9:	83 c4 18             	add    $0x18,%esp
}
  8042ec:	90                   	nop
  8042ed:	c9                   	leave  
  8042ee:	c3                   	ret    

008042ef <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8042ef:	55                   	push   %ebp
  8042f0:	89 e5                	mov    %esp,%ebp
  8042f2:	83 ec 04             	sub    $0x4,%esp
  8042f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8042f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8042fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8042fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  804302:	8b 45 08             	mov    0x8(%ebp),%eax
  804305:	6a 00                	push   $0x0
  804307:	51                   	push   %ecx
  804308:	52                   	push   %edx
  804309:	ff 75 0c             	pushl  0xc(%ebp)
  80430c:	50                   	push   %eax
  80430d:	6a 15                	push   $0x15
  80430f:	e8 e4 fd ff ff       	call   8040f8 <syscall>
  804314:	83 c4 18             	add    $0x18,%esp
}
  804317:	c9                   	leave  
  804318:	c3                   	ret    

00804319 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  804319:	55                   	push   %ebp
  80431a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80431c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80431f:	8b 45 08             	mov    0x8(%ebp),%eax
  804322:	6a 00                	push   $0x0
  804324:	6a 00                	push   $0x0
  804326:	6a 00                	push   $0x0
  804328:	52                   	push   %edx
  804329:	50                   	push   %eax
  80432a:	6a 16                	push   $0x16
  80432c:	e8 c7 fd ff ff       	call   8040f8 <syscall>
  804331:	83 c4 18             	add    $0x18,%esp
}
  804334:	c9                   	leave  
  804335:	c3                   	ret    

00804336 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  804336:	55                   	push   %ebp
  804337:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  804339:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80433c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80433f:	8b 45 08             	mov    0x8(%ebp),%eax
  804342:	6a 00                	push   $0x0
  804344:	6a 00                	push   $0x0
  804346:	51                   	push   %ecx
  804347:	52                   	push   %edx
  804348:	50                   	push   %eax
  804349:	6a 17                	push   $0x17
  80434b:	e8 a8 fd ff ff       	call   8040f8 <syscall>
  804350:	83 c4 18             	add    $0x18,%esp
}
  804353:	c9                   	leave  
  804354:	c3                   	ret    

00804355 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  804355:	55                   	push   %ebp
  804356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  804358:	8b 55 0c             	mov    0xc(%ebp),%edx
  80435b:	8b 45 08             	mov    0x8(%ebp),%eax
  80435e:	6a 00                	push   $0x0
  804360:	6a 00                	push   $0x0
  804362:	6a 00                	push   $0x0
  804364:	52                   	push   %edx
  804365:	50                   	push   %eax
  804366:	6a 18                	push   $0x18
  804368:	e8 8b fd ff ff       	call   8040f8 <syscall>
  80436d:	83 c4 18             	add    $0x18,%esp
}
  804370:	c9                   	leave  
  804371:	c3                   	ret    

00804372 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  804372:	55                   	push   %ebp
  804373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  804375:	8b 45 08             	mov    0x8(%ebp),%eax
  804378:	6a 00                	push   $0x0
  80437a:	ff 75 14             	pushl  0x14(%ebp)
  80437d:	ff 75 10             	pushl  0x10(%ebp)
  804380:	ff 75 0c             	pushl  0xc(%ebp)
  804383:	50                   	push   %eax
  804384:	6a 19                	push   $0x19
  804386:	e8 6d fd ff ff       	call   8040f8 <syscall>
  80438b:	83 c4 18             	add    $0x18,%esp
}
  80438e:	c9                   	leave  
  80438f:	c3                   	ret    

00804390 <sys_run_env>:

void sys_run_env(int32 envId)
{
  804390:	55                   	push   %ebp
  804391:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  804393:	8b 45 08             	mov    0x8(%ebp),%eax
  804396:	6a 00                	push   $0x0
  804398:	6a 00                	push   $0x0
  80439a:	6a 00                	push   $0x0
  80439c:	6a 00                	push   $0x0
  80439e:	50                   	push   %eax
  80439f:	6a 1a                	push   $0x1a
  8043a1:	e8 52 fd ff ff       	call   8040f8 <syscall>
  8043a6:	83 c4 18             	add    $0x18,%esp
}
  8043a9:	90                   	nop
  8043aa:	c9                   	leave  
  8043ab:	c3                   	ret    

008043ac <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8043ac:	55                   	push   %ebp
  8043ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8043af:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b2:	6a 00                	push   $0x0
  8043b4:	6a 00                	push   $0x0
  8043b6:	6a 00                	push   $0x0
  8043b8:	6a 00                	push   $0x0
  8043ba:	50                   	push   %eax
  8043bb:	6a 1b                	push   $0x1b
  8043bd:	e8 36 fd ff ff       	call   8040f8 <syscall>
  8043c2:	83 c4 18             	add    $0x18,%esp
}
  8043c5:	c9                   	leave  
  8043c6:	c3                   	ret    

008043c7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8043c7:	55                   	push   %ebp
  8043c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8043ca:	6a 00                	push   $0x0
  8043cc:	6a 00                	push   $0x0
  8043ce:	6a 00                	push   $0x0
  8043d0:	6a 00                	push   $0x0
  8043d2:	6a 00                	push   $0x0
  8043d4:	6a 05                	push   $0x5
  8043d6:	e8 1d fd ff ff       	call   8040f8 <syscall>
  8043db:	83 c4 18             	add    $0x18,%esp
}
  8043de:	c9                   	leave  
  8043df:	c3                   	ret    

008043e0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8043e0:	55                   	push   %ebp
  8043e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8043e3:	6a 00                	push   $0x0
  8043e5:	6a 00                	push   $0x0
  8043e7:	6a 00                	push   $0x0
  8043e9:	6a 00                	push   $0x0
  8043eb:	6a 00                	push   $0x0
  8043ed:	6a 06                	push   $0x6
  8043ef:	e8 04 fd ff ff       	call   8040f8 <syscall>
  8043f4:	83 c4 18             	add    $0x18,%esp
}
  8043f7:	c9                   	leave  
  8043f8:	c3                   	ret    

008043f9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8043f9:	55                   	push   %ebp
  8043fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8043fc:	6a 00                	push   $0x0
  8043fe:	6a 00                	push   $0x0
  804400:	6a 00                	push   $0x0
  804402:	6a 00                	push   $0x0
  804404:	6a 00                	push   $0x0
  804406:	6a 07                	push   $0x7
  804408:	e8 eb fc ff ff       	call   8040f8 <syscall>
  80440d:	83 c4 18             	add    $0x18,%esp
}
  804410:	c9                   	leave  
  804411:	c3                   	ret    

00804412 <sys_exit_env>:


void sys_exit_env(void)
{
  804412:	55                   	push   %ebp
  804413:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  804415:	6a 00                	push   $0x0
  804417:	6a 00                	push   $0x0
  804419:	6a 00                	push   $0x0
  80441b:	6a 00                	push   $0x0
  80441d:	6a 00                	push   $0x0
  80441f:	6a 1c                	push   $0x1c
  804421:	e8 d2 fc ff ff       	call   8040f8 <syscall>
  804426:	83 c4 18             	add    $0x18,%esp
}
  804429:	90                   	nop
  80442a:	c9                   	leave  
  80442b:	c3                   	ret    

0080442c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80442c:	55                   	push   %ebp
  80442d:	89 e5                	mov    %esp,%ebp
  80442f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  804432:	8d 45 f8             	lea    -0x8(%ebp),%eax
  804435:	8d 50 04             	lea    0x4(%eax),%edx
  804438:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80443b:	6a 00                	push   $0x0
  80443d:	6a 00                	push   $0x0
  80443f:	6a 00                	push   $0x0
  804441:	52                   	push   %edx
  804442:	50                   	push   %eax
  804443:	6a 1d                	push   $0x1d
  804445:	e8 ae fc ff ff       	call   8040f8 <syscall>
  80444a:	83 c4 18             	add    $0x18,%esp
	return result;
  80444d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  804450:	8b 45 f8             	mov    -0x8(%ebp),%eax
  804453:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804456:	89 01                	mov    %eax,(%ecx)
  804458:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80445b:	8b 45 08             	mov    0x8(%ebp),%eax
  80445e:	c9                   	leave  
  80445f:	c2 04 00             	ret    $0x4

00804462 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  804462:	55                   	push   %ebp
  804463:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  804465:	6a 00                	push   $0x0
  804467:	6a 00                	push   $0x0
  804469:	ff 75 10             	pushl  0x10(%ebp)
  80446c:	ff 75 0c             	pushl  0xc(%ebp)
  80446f:	ff 75 08             	pushl  0x8(%ebp)
  804472:	6a 13                	push   $0x13
  804474:	e8 7f fc ff ff       	call   8040f8 <syscall>
  804479:	83 c4 18             	add    $0x18,%esp
	return ;
  80447c:	90                   	nop
}
  80447d:	c9                   	leave  
  80447e:	c3                   	ret    

0080447f <sys_rcr2>:
uint32 sys_rcr2()
{
  80447f:	55                   	push   %ebp
  804480:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  804482:	6a 00                	push   $0x0
  804484:	6a 00                	push   $0x0
  804486:	6a 00                	push   $0x0
  804488:	6a 00                	push   $0x0
  80448a:	6a 00                	push   $0x0
  80448c:	6a 1e                	push   $0x1e
  80448e:	e8 65 fc ff ff       	call   8040f8 <syscall>
  804493:	83 c4 18             	add    $0x18,%esp
}
  804496:	c9                   	leave  
  804497:	c3                   	ret    

00804498 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  804498:	55                   	push   %ebp
  804499:	89 e5                	mov    %esp,%ebp
  80449b:	83 ec 04             	sub    $0x4,%esp
  80449e:	8b 45 08             	mov    0x8(%ebp),%eax
  8044a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8044a4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8044a8:	6a 00                	push   $0x0
  8044aa:	6a 00                	push   $0x0
  8044ac:	6a 00                	push   $0x0
  8044ae:	6a 00                	push   $0x0
  8044b0:	50                   	push   %eax
  8044b1:	6a 1f                	push   $0x1f
  8044b3:	e8 40 fc ff ff       	call   8040f8 <syscall>
  8044b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8044bb:	90                   	nop
}
  8044bc:	c9                   	leave  
  8044bd:	c3                   	ret    

008044be <rsttst>:
void rsttst()
{
  8044be:	55                   	push   %ebp
  8044bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8044c1:	6a 00                	push   $0x0
  8044c3:	6a 00                	push   $0x0
  8044c5:	6a 00                	push   $0x0
  8044c7:	6a 00                	push   $0x0
  8044c9:	6a 00                	push   $0x0
  8044cb:	6a 21                	push   $0x21
  8044cd:	e8 26 fc ff ff       	call   8040f8 <syscall>
  8044d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8044d5:	90                   	nop
}
  8044d6:	c9                   	leave  
  8044d7:	c3                   	ret    

008044d8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8044d8:	55                   	push   %ebp
  8044d9:	89 e5                	mov    %esp,%ebp
  8044db:	83 ec 04             	sub    $0x4,%esp
  8044de:	8b 45 14             	mov    0x14(%ebp),%eax
  8044e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8044e4:	8b 55 18             	mov    0x18(%ebp),%edx
  8044e7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8044eb:	52                   	push   %edx
  8044ec:	50                   	push   %eax
  8044ed:	ff 75 10             	pushl  0x10(%ebp)
  8044f0:	ff 75 0c             	pushl  0xc(%ebp)
  8044f3:	ff 75 08             	pushl  0x8(%ebp)
  8044f6:	6a 20                	push   $0x20
  8044f8:	e8 fb fb ff ff       	call   8040f8 <syscall>
  8044fd:	83 c4 18             	add    $0x18,%esp
	return ;
  804500:	90                   	nop
}
  804501:	c9                   	leave  
  804502:	c3                   	ret    

00804503 <chktst>:
void chktst(uint32 n)
{
  804503:	55                   	push   %ebp
  804504:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  804506:	6a 00                	push   $0x0
  804508:	6a 00                	push   $0x0
  80450a:	6a 00                	push   $0x0
  80450c:	6a 00                	push   $0x0
  80450e:	ff 75 08             	pushl  0x8(%ebp)
  804511:	6a 22                	push   $0x22
  804513:	e8 e0 fb ff ff       	call   8040f8 <syscall>
  804518:	83 c4 18             	add    $0x18,%esp
	return ;
  80451b:	90                   	nop
}
  80451c:	c9                   	leave  
  80451d:	c3                   	ret    

0080451e <inctst>:

void inctst()
{
  80451e:	55                   	push   %ebp
  80451f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  804521:	6a 00                	push   $0x0
  804523:	6a 00                	push   $0x0
  804525:	6a 00                	push   $0x0
  804527:	6a 00                	push   $0x0
  804529:	6a 00                	push   $0x0
  80452b:	6a 23                	push   $0x23
  80452d:	e8 c6 fb ff ff       	call   8040f8 <syscall>
  804532:	83 c4 18             	add    $0x18,%esp
	return ;
  804535:	90                   	nop
}
  804536:	c9                   	leave  
  804537:	c3                   	ret    

00804538 <gettst>:
uint32 gettst()
{
  804538:	55                   	push   %ebp
  804539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80453b:	6a 00                	push   $0x0
  80453d:	6a 00                	push   $0x0
  80453f:	6a 00                	push   $0x0
  804541:	6a 00                	push   $0x0
  804543:	6a 00                	push   $0x0
  804545:	6a 24                	push   $0x24
  804547:	e8 ac fb ff ff       	call   8040f8 <syscall>
  80454c:	83 c4 18             	add    $0x18,%esp
}
  80454f:	c9                   	leave  
  804550:	c3                   	ret    

00804551 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  804551:	55                   	push   %ebp
  804552:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  804554:	6a 00                	push   $0x0
  804556:	6a 00                	push   $0x0
  804558:	6a 00                	push   $0x0
  80455a:	6a 00                	push   $0x0
  80455c:	6a 00                	push   $0x0
  80455e:	6a 25                	push   $0x25
  804560:	e8 93 fb ff ff       	call   8040f8 <syscall>
  804565:	83 c4 18             	add    $0x18,%esp
  804568:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  80456d:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  804572:	c9                   	leave  
  804573:	c3                   	ret    

00804574 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  804574:	55                   	push   %ebp
  804575:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  804577:	8b 45 08             	mov    0x8(%ebp),%eax
  80457a:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80457f:	6a 00                	push   $0x0
  804581:	6a 00                	push   $0x0
  804583:	6a 00                	push   $0x0
  804585:	6a 00                	push   $0x0
  804587:	ff 75 08             	pushl  0x8(%ebp)
  80458a:	6a 26                	push   $0x26
  80458c:	e8 67 fb ff ff       	call   8040f8 <syscall>
  804591:	83 c4 18             	add    $0x18,%esp
	return ;
  804594:	90                   	nop
}
  804595:	c9                   	leave  
  804596:	c3                   	ret    

00804597 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  804597:	55                   	push   %ebp
  804598:	89 e5                	mov    %esp,%ebp
  80459a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80459b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80459e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8045a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8045a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8045a7:	6a 00                	push   $0x0
  8045a9:	53                   	push   %ebx
  8045aa:	51                   	push   %ecx
  8045ab:	52                   	push   %edx
  8045ac:	50                   	push   %eax
  8045ad:	6a 27                	push   $0x27
  8045af:	e8 44 fb ff ff       	call   8040f8 <syscall>
  8045b4:	83 c4 18             	add    $0x18,%esp
}
  8045b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8045ba:	c9                   	leave  
  8045bb:	c3                   	ret    

008045bc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8045bc:	55                   	push   %ebp
  8045bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8045bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8045c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8045c5:	6a 00                	push   $0x0
  8045c7:	6a 00                	push   $0x0
  8045c9:	6a 00                	push   $0x0
  8045cb:	52                   	push   %edx
  8045cc:	50                   	push   %eax
  8045cd:	6a 28                	push   $0x28
  8045cf:	e8 24 fb ff ff       	call   8040f8 <syscall>
  8045d4:	83 c4 18             	add    $0x18,%esp
}
  8045d7:	c9                   	leave  
  8045d8:	c3                   	ret    

008045d9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8045d9:	55                   	push   %ebp
  8045da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8045dc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8045df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8045e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e5:	6a 00                	push   $0x0
  8045e7:	51                   	push   %ecx
  8045e8:	ff 75 10             	pushl  0x10(%ebp)
  8045eb:	52                   	push   %edx
  8045ec:	50                   	push   %eax
  8045ed:	6a 29                	push   $0x29
  8045ef:	e8 04 fb ff ff       	call   8040f8 <syscall>
  8045f4:	83 c4 18             	add    $0x18,%esp
}
  8045f7:	c9                   	leave  
  8045f8:	c3                   	ret    

008045f9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8045f9:	55                   	push   %ebp
  8045fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8045fc:	6a 00                	push   $0x0
  8045fe:	6a 00                	push   $0x0
  804600:	ff 75 10             	pushl  0x10(%ebp)
  804603:	ff 75 0c             	pushl  0xc(%ebp)
  804606:	ff 75 08             	pushl  0x8(%ebp)
  804609:	6a 12                	push   $0x12
  80460b:	e8 e8 fa ff ff       	call   8040f8 <syscall>
  804610:	83 c4 18             	add    $0x18,%esp
	return ;
  804613:	90                   	nop
}
  804614:	c9                   	leave  
  804615:	c3                   	ret    

00804616 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  804616:	55                   	push   %ebp
  804617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  804619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80461c:	8b 45 08             	mov    0x8(%ebp),%eax
  80461f:	6a 00                	push   $0x0
  804621:	6a 00                	push   $0x0
  804623:	6a 00                	push   $0x0
  804625:	52                   	push   %edx
  804626:	50                   	push   %eax
  804627:	6a 2a                	push   $0x2a
  804629:	e8 ca fa ff ff       	call   8040f8 <syscall>
  80462e:	83 c4 18             	add    $0x18,%esp
	return;
  804631:	90                   	nop
}
  804632:	c9                   	leave  
  804633:	c3                   	ret    

00804634 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  804634:	55                   	push   %ebp
  804635:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  804637:	6a 00                	push   $0x0
  804639:	6a 00                	push   $0x0
  80463b:	6a 00                	push   $0x0
  80463d:	6a 00                	push   $0x0
  80463f:	6a 00                	push   $0x0
  804641:	6a 2b                	push   $0x2b
  804643:	e8 b0 fa ff ff       	call   8040f8 <syscall>
  804648:	83 c4 18             	add    $0x18,%esp
}
  80464b:	c9                   	leave  
  80464c:	c3                   	ret    

0080464d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80464d:	55                   	push   %ebp
  80464e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  804650:	6a 00                	push   $0x0
  804652:	6a 00                	push   $0x0
  804654:	6a 00                	push   $0x0
  804656:	ff 75 0c             	pushl  0xc(%ebp)
  804659:	ff 75 08             	pushl  0x8(%ebp)
  80465c:	6a 2d                	push   $0x2d
  80465e:	e8 95 fa ff ff       	call   8040f8 <syscall>
  804663:	83 c4 18             	add    $0x18,%esp
	return;
  804666:	90                   	nop
}
  804667:	c9                   	leave  
  804668:	c3                   	ret    

00804669 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  804669:	55                   	push   %ebp
  80466a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80466c:	6a 00                	push   $0x0
  80466e:	6a 00                	push   $0x0
  804670:	6a 00                	push   $0x0
  804672:	ff 75 0c             	pushl  0xc(%ebp)
  804675:	ff 75 08             	pushl  0x8(%ebp)
  804678:	6a 2c                	push   $0x2c
  80467a:	e8 79 fa ff ff       	call   8040f8 <syscall>
  80467f:	83 c4 18             	add    $0x18,%esp
	return ;
  804682:	90                   	nop
}
  804683:	c9                   	leave  
  804684:	c3                   	ret    

00804685 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  804685:	55                   	push   %ebp
  804686:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  804688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80468b:	8b 45 08             	mov    0x8(%ebp),%eax
  80468e:	6a 00                	push   $0x0
  804690:	6a 00                	push   $0x0
  804692:	6a 00                	push   $0x0
  804694:	52                   	push   %edx
  804695:	50                   	push   %eax
  804696:	6a 2e                	push   $0x2e
  804698:	e8 5b fa ff ff       	call   8040f8 <syscall>
  80469d:	83 c4 18             	add    $0x18,%esp
	    return;
  8046a0:	90                   	nop
}
  8046a1:	c9                   	leave  
  8046a2:	c3                   	ret    

008046a3 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8046a3:	55                   	push   %ebp
  8046a4:	89 e5                	mov    %esp,%ebp
  8046a6:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8046a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8046ac:	ba 40 72 80 00       	mov    $0x807240,%edx
  8046b1:	29 d0                	sub    %edx,%eax
  8046b3:	c1 f8 02             	sar    $0x2,%eax
  8046b6:	89 c2                	mov    %eax,%edx
  8046b8:	89 d0                	mov    %edx,%eax
  8046ba:	c1 e0 02             	shl    $0x2,%eax
  8046bd:	01 d0                	add    %edx,%eax
  8046bf:	c1 e0 02             	shl    $0x2,%eax
  8046c2:	01 d0                	add    %edx,%eax
  8046c4:	c1 e0 02             	shl    $0x2,%eax
  8046c7:	01 d0                	add    %edx,%eax
  8046c9:	89 c1                	mov    %eax,%ecx
  8046cb:	c1 e1 08             	shl    $0x8,%ecx
  8046ce:	01 c8                	add    %ecx,%eax
  8046d0:	89 c1                	mov    %eax,%ecx
  8046d2:	c1 e1 10             	shl    $0x10,%ecx
  8046d5:	01 c8                	add    %ecx,%eax
  8046d7:	01 c0                	add    %eax,%eax
  8046d9:	01 d0                	add    %edx,%eax
  8046db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8046de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8046e1:	c1 e0 0c             	shl    $0xc,%eax
  8046e4:	89 c2                	mov    %eax,%edx
  8046e6:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8046eb:	01 d0                	add    %edx,%eax
}
  8046ed:	c9                   	leave  
  8046ee:	c3                   	ret    

008046ef <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  8046ef:	55                   	push   %ebp
  8046f0:	89 e5                	mov    %esp,%ebp
  8046f2:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  8046f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8046fc:	eb 06                	jmp    804704 <log2+0x15>
			n >>=1;
  8046fe:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  804701:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  804704:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804708:	77 f4                	ja     8046fe <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  80470a:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80470d:	c9                   	leave  
  80470e:	c3                   	ret    

0080470f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80470f:	55                   	push   %ebp
  804710:	89 e5                	mov    %esp,%ebp
  804712:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  804715:	8b 45 08             	mov    0x8(%ebp),%eax
  804718:	05 00 00 00 02       	add    $0x2000000,%eax
  80471d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804720:	73 16                	jae    804738 <initialize_dynamic_allocator+0x29>
  804722:	68 98 64 80 00       	push   $0x806498
  804727:	68 be 64 80 00       	push   $0x8064be
  80472c:	6a 2d                	push   $0x2d
  80472e:	68 d3 64 80 00       	push   $0x8064d3
  804733:	e8 a6 ce ff ff       	call   8015de <_panic>
		is_initialized = 1;
  804738:	c7 05 04 72 80 00 01 	movl   $0x1,0x807204
  80473f:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  804742:	8b 45 08             	mov    0x8(%ebp),%eax
  804745:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd= daEnd;
  80474a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80474d:	a3 20 72 80 00       	mov    %eax,0x807220
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  804752:	8b 15 20 72 80 00    	mov    0x807220,%edx
  804758:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80475d:	29 c2                	sub    %eax,%edx
  80475f:	89 d0                	mov    %edx,%eax
  804761:	c1 e8 0c             	shr    $0xc,%eax
  804764:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  804767:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80476e:	eb 2f                	jmp    80479f <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  804770:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804773:	89 d0                	mov    %edx,%eax
  804775:	01 c0                	add    %eax,%eax
  804777:	01 d0                	add    %edx,%eax
  804779:	c1 e0 02             	shl    $0x2,%eax
  80477c:	05 48 72 80 00       	add    $0x807248,%eax
  804781:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  804786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804789:	89 d0                	mov    %edx,%eax
  80478b:	01 c0                	add    %eax,%eax
  80478d:	01 d0                	add    %edx,%eax
  80478f:	c1 e0 02             	shl    $0x2,%eax
  804792:	05 4a 72 80 00       	add    $0x80724a,%eax
  804797:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  80479c:	ff 45 f4             	incl   -0xc(%ebp)
  80479f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8047a2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8047a5:	7c c9                	jl     804770 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  8047a7:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  8047ae:	00 00 00 
  8047b1:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  8047b8:	00 00 00 
  8047bb:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  8047c2:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  8047c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8047cc:	e9 9c 00 00 00       	jmp    80486d <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8047d1:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  8047d7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8047da:	89 c8                	mov    %ecx,%eax
  8047dc:	01 c0                	add    %eax,%eax
  8047de:	01 c8                	add    %ecx,%eax
  8047e0:	c1 e0 02             	shl    $0x2,%eax
  8047e3:	05 44 72 80 00       	add    $0x807244,%eax
  8047e8:	89 10                	mov    %edx,(%eax)
  8047ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8047ed:	89 d0                	mov    %edx,%eax
  8047ef:	01 c0                	add    %eax,%eax
  8047f1:	01 d0                	add    %edx,%eax
  8047f3:	c1 e0 02             	shl    $0x2,%eax
  8047f6:	05 44 72 80 00       	add    $0x807244,%eax
  8047fb:	8b 00                	mov    (%eax),%eax
  8047fd:	85 c0                	test   %eax,%eax
  8047ff:	74 1b                	je     80481c <initialize_dynamic_allocator+0x10d>
  804801:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804807:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80480a:	89 c8                	mov    %ecx,%eax
  80480c:	01 c0                	add    %eax,%eax
  80480e:	01 c8                	add    %ecx,%eax
  804810:	c1 e0 02             	shl    $0x2,%eax
  804813:	05 40 72 80 00       	add    $0x807240,%eax
  804818:	89 02                	mov    %eax,(%edx)
  80481a:	eb 16                	jmp    804832 <initialize_dynamic_allocator+0x123>
  80481c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80481f:	89 d0                	mov    %edx,%eax
  804821:	01 c0                	add    %eax,%eax
  804823:	01 d0                	add    %edx,%eax
  804825:	c1 e0 02             	shl    $0x2,%eax
  804828:	05 40 72 80 00       	add    $0x807240,%eax
  80482d:	a3 28 72 80 00       	mov    %eax,0x807228
  804832:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804835:	89 d0                	mov    %edx,%eax
  804837:	01 c0                	add    %eax,%eax
  804839:	01 d0                	add    %edx,%eax
  80483b:	c1 e0 02             	shl    $0x2,%eax
  80483e:	05 40 72 80 00       	add    $0x807240,%eax
  804843:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804848:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80484b:	89 d0                	mov    %edx,%eax
  80484d:	01 c0                	add    %eax,%eax
  80484f:	01 d0                	add    %edx,%eax
  804851:	c1 e0 02             	shl    $0x2,%eax
  804854:	05 40 72 80 00       	add    $0x807240,%eax
  804859:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80485f:	a1 34 72 80 00       	mov    0x807234,%eax
  804864:	40                   	inc    %eax
  804865:	a3 34 72 80 00       	mov    %eax,0x807234
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  80486a:	ff 45 f0             	incl   -0x10(%ebp)
  80486d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804870:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804873:	0f 8c 58 ff ff ff    	jl     8047d1 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  804879:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  804880:	eb 36                	jmp    8048b8 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  804882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804885:	c1 e0 04             	shl    $0x4,%eax
  804888:	05 60 f2 81 00       	add    $0x81f260,%eax
  80488d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804896:	c1 e0 04             	shl    $0x4,%eax
  804899:	05 64 f2 81 00       	add    $0x81f264,%eax
  80489e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8048a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8048a7:	c1 e0 04             	shl    $0x4,%eax
  8048aa:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8048af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8048b5:	ff 45 ec             	incl   -0x14(%ebp)
  8048b8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8048bc:	7e c4                	jle    804882 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8048be:	90                   	nop
  8048bf:	c9                   	leave  
  8048c0:	c3                   	ret    

008048c1 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  8048c1:	55                   	push   %ebp
  8048c2:	89 e5                	mov    %esp,%ebp
  8048c4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8048c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8048ca:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8048cf:	29 c2                	sub    %eax,%edx
  8048d1:	89 d0                	mov    %edx,%eax
  8048d3:	c1 e8 0c             	shr    $0xc,%eax
  8048d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  8048d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8048dc:	89 d0                	mov    %edx,%eax
  8048de:	01 c0                	add    %eax,%eax
  8048e0:	01 d0                	add    %edx,%eax
  8048e2:	c1 e0 02             	shl    $0x2,%eax
  8048e5:	05 48 72 80 00       	add    $0x807248,%eax
  8048ea:	8b 00                	mov    (%eax),%eax
  8048ec:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8048ef:	c9                   	leave  
  8048f0:	c3                   	ret    

008048f1 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8048f1:	55                   	push   %ebp
  8048f2:	89 e5                	mov    %esp,%ebp
  8048f4:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8048f7:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8048fe:	76 16                	jbe    804916 <alloc_block+0x25>
  804900:	68 ec 64 80 00       	push   $0x8064ec
  804905:	68 be 64 80 00       	push   $0x8064be
  80490a:	6a 6c                	push   $0x6c
  80490c:	68 d3 64 80 00       	push   $0x8064d3
  804911:	e8 c8 cc ff ff       	call   8015de <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  804916:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80491a:	75 0a                	jne    804926 <alloc_block+0x35>
		return NULL;
  80491c:	b8 00 00 00 00       	mov    $0x0,%eax
  804921:	e9 65 04 00 00       	jmp    804d8b <alloc_block+0x49a>
	}
	else if(size<=8){
  804926:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  80492a:	77 09                	ja     804935 <alloc_block+0x44>
		size=8;
  80492c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  804933:	eb 1f                	jmp    804954 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  804935:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  80493c:	eb 08                	jmp    804946 <alloc_block+0x55>
			reqsize*=2;
  80493e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804941:	01 c0                	add    %eax,%eax
  804943:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  804946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804949:	3b 45 08             	cmp    0x8(%ebp),%eax
  80494c:	72 f0                	jb     80493e <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  80494e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804951:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  804954:	83 ec 0c             	sub    $0xc,%esp
  804957:	ff 75 08             	pushl  0x8(%ebp)
  80495a:	e8 90 fd ff ff       	call   8046ef <log2>
  80495f:	83 c4 10             	add    $0x10,%esp
  804962:	83 e8 03             	sub    $0x3,%eax
  804965:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  804968:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80496b:	c1 e0 04             	shl    $0x4,%eax
  80496e:	05 60 f2 81 00       	add    $0x81f260,%eax
  804973:	8b 00                	mov    (%eax),%eax
  804975:	85 c0                	test   %eax,%eax
  804977:	0f 84 fb 00 00 00    	je     804a78 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  80497d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804980:	c1 e0 04             	shl    $0x4,%eax
  804983:	05 60 f2 81 00       	add    $0x81f260,%eax
  804988:	8b 00                	mov    (%eax),%eax
  80498a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  80498d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804991:	75 17                	jne    8049aa <alloc_block+0xb9>
  804993:	83 ec 04             	sub    $0x4,%esp
  804996:	68 0d 65 80 00       	push   $0x80650d
  80499b:	68 86 00 00 00       	push   $0x86
  8049a0:	68 d3 64 80 00       	push   $0x8064d3
  8049a5:	e8 34 cc ff ff       	call   8015de <_panic>
  8049aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049ad:	8b 00                	mov    (%eax),%eax
  8049af:	85 c0                	test   %eax,%eax
  8049b1:	74 10                	je     8049c3 <alloc_block+0xd2>
  8049b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049b6:	8b 00                	mov    (%eax),%eax
  8049b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049bb:	8b 52 04             	mov    0x4(%edx),%edx
  8049be:	89 50 04             	mov    %edx,0x4(%eax)
  8049c1:	eb 14                	jmp    8049d7 <alloc_block+0xe6>
  8049c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049c6:	8b 40 04             	mov    0x4(%eax),%eax
  8049c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8049cc:	c1 e2 04             	shl    $0x4,%edx
  8049cf:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  8049d5:	89 02                	mov    %eax,(%edx)
  8049d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049da:	8b 40 04             	mov    0x4(%eax),%eax
  8049dd:	85 c0                	test   %eax,%eax
  8049df:	74 0f                	je     8049f0 <alloc_block+0xff>
  8049e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049e4:	8b 40 04             	mov    0x4(%eax),%eax
  8049e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049ea:	8b 12                	mov    (%edx),%edx
  8049ec:	89 10                	mov    %edx,(%eax)
  8049ee:	eb 13                	jmp    804a03 <alloc_block+0x112>
  8049f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049f3:	8b 00                	mov    (%eax),%eax
  8049f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8049f8:	c1 e2 04             	shl    $0x4,%edx
  8049fb:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804a01:	89 02                	mov    %eax,(%edx)
  804a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a19:	c1 e0 04             	shl    $0x4,%eax
  804a1c:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804a21:	8b 00                	mov    (%eax),%eax
  804a23:	8d 50 ff             	lea    -0x1(%eax),%edx
  804a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a29:	c1 e0 04             	shl    $0x4,%eax
  804a2c:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804a31:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804a33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804a36:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804a3b:	29 c2                	sub    %eax,%edx
  804a3d:	89 d0                	mov    %edx,%eax
  804a3f:	c1 e8 0c             	shr    $0xc,%eax
  804a42:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  804a45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804a48:	89 d0                	mov    %edx,%eax
  804a4a:	01 c0                	add    %eax,%eax
  804a4c:	01 d0                	add    %edx,%eax
  804a4e:	c1 e0 02             	shl    $0x2,%eax
  804a51:	05 4a 72 80 00       	add    $0x80724a,%eax
  804a56:	66 8b 00             	mov    (%eax),%ax
  804a59:	8d 50 ff             	lea    -0x1(%eax),%edx
  804a5c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  804a5f:	89 c8                	mov    %ecx,%eax
  804a61:	01 c0                	add    %eax,%eax
  804a63:	01 c8                	add    %ecx,%eax
  804a65:	c1 e0 02             	shl    $0x2,%eax
  804a68:	05 4a 72 80 00       	add    $0x80724a,%eax
  804a6d:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  804a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a73:	e9 13 03 00 00       	jmp    804d8b <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  804a78:	a1 28 72 80 00       	mov    0x807228,%eax
  804a7d:	85 c0                	test   %eax,%eax
  804a7f:	0f 84 c9 01 00 00    	je     804c4e <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  804a85:	a1 28 72 80 00       	mov    0x807228,%eax
  804a8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  804a8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804a91:	75 17                	jne    804aaa <alloc_block+0x1b9>
  804a93:	83 ec 04             	sub    $0x4,%esp
  804a96:	68 0d 65 80 00       	push   $0x80650d
  804a9b:	68 8f 00 00 00       	push   $0x8f
  804aa0:	68 d3 64 80 00       	push   $0x8064d3
  804aa5:	e8 34 cb ff ff       	call   8015de <_panic>
  804aaa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804aad:	8b 00                	mov    (%eax),%eax
  804aaf:	85 c0                	test   %eax,%eax
  804ab1:	74 10                	je     804ac3 <alloc_block+0x1d2>
  804ab3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804ab6:	8b 00                	mov    (%eax),%eax
  804ab8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804abb:	8b 52 04             	mov    0x4(%edx),%edx
  804abe:	89 50 04             	mov    %edx,0x4(%eax)
  804ac1:	eb 0b                	jmp    804ace <alloc_block+0x1dd>
  804ac3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804ac6:	8b 40 04             	mov    0x4(%eax),%eax
  804ac9:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804ace:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804ad1:	8b 40 04             	mov    0x4(%eax),%eax
  804ad4:	85 c0                	test   %eax,%eax
  804ad6:	74 0f                	je     804ae7 <alloc_block+0x1f6>
  804ad8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804adb:	8b 40 04             	mov    0x4(%eax),%eax
  804ade:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804ae1:	8b 12                	mov    (%edx),%edx
  804ae3:	89 10                	mov    %edx,(%eax)
  804ae5:	eb 0a                	jmp    804af1 <alloc_block+0x200>
  804ae7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804aea:	8b 00                	mov    (%eax),%eax
  804aec:	a3 28 72 80 00       	mov    %eax,0x807228
  804af1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804af4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804afa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804afd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804b04:	a1 34 72 80 00       	mov    0x807234,%eax
  804b09:	48                   	dec    %eax
  804b0a:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  804b0f:	83 ec 0c             	sub    $0xc,%esp
  804b12:	ff 75 dc             	pushl  -0x24(%ebp)
  804b15:	e8 89 fb ff ff       	call   8046a3 <to_page_va>
  804b1a:	83 c4 10             	add    $0x10,%esp
  804b1d:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  804b20:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804b25:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804b28:	29 c2                	sub    %eax,%edx
  804b2a:	89 d0                	mov    %edx,%eax
  804b2c:	c1 e8 0c             	shr    $0xc,%eax
  804b2f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  804b32:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804b35:	83 ec 0c             	sub    $0xc,%esp
  804b38:	50                   	push   %eax
  804b39:	e8 fe dc ff ff       	call   80283c <get_page>
  804b3e:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  804b41:	8b 45 08             	mov    0x8(%ebp),%eax
  804b44:	89 c2                	mov    %eax,%edx
  804b46:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804b49:	89 c8                	mov    %ecx,%eax
  804b4b:	01 c0                	add    %eax,%eax
  804b4d:	01 c8                	add    %ecx,%eax
  804b4f:	c1 e0 02             	shl    $0x2,%eax
  804b52:	05 48 72 80 00       	add    $0x807248,%eax
  804b57:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  804b5a:	b8 00 10 00 00       	mov    $0x1000,%eax
  804b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  804b64:	f7 75 08             	divl   0x8(%ebp)
  804b67:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  804b6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804b6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  804b70:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804b73:	89 c8                	mov    %ecx,%eax
  804b75:	01 c0                	add    %eax,%eax
  804b77:	01 c8                	add    %ecx,%eax
  804b79:	c1 e0 02             	shl    $0x2,%eax
  804b7c:	05 4a 72 80 00       	add    $0x80724a,%eax
  804b81:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  804b84:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  804b8b:	e9 aa 00 00 00       	jmp    804c3a <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  804b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b93:	0f af 45 08          	imul   0x8(%ebp),%eax
  804b97:	89 c2                	mov    %eax,%edx
  804b99:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804b9c:	01 d0                	add    %edx,%eax
  804b9e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  804ba1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804ba5:	75 17                	jne    804bbe <alloc_block+0x2cd>
  804ba7:	83 ec 04             	sub    $0x4,%esp
  804baa:	68 2c 65 80 00       	push   $0x80652c
  804baf:	68 9d 00 00 00       	push   $0x9d
  804bb4:	68 d3 64 80 00       	push   $0x8064d3
  804bb9:	e8 20 ca ff ff       	call   8015de <_panic>
  804bbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bc1:	c1 e0 04             	shl    $0x4,%eax
  804bc4:	05 64 f2 81 00       	add    $0x81f264,%eax
  804bc9:	8b 10                	mov    (%eax),%edx
  804bcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804bce:	89 50 04             	mov    %edx,0x4(%eax)
  804bd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804bd4:	8b 40 04             	mov    0x4(%eax),%eax
  804bd7:	85 c0                	test   %eax,%eax
  804bd9:	74 14                	je     804bef <alloc_block+0x2fe>
  804bdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bde:	c1 e0 04             	shl    $0x4,%eax
  804be1:	05 64 f2 81 00       	add    $0x81f264,%eax
  804be6:	8b 00                	mov    (%eax),%eax
  804be8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804beb:	89 10                	mov    %edx,(%eax)
  804bed:	eb 11                	jmp    804c00 <alloc_block+0x30f>
  804bef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bf2:	c1 e0 04             	shl    $0x4,%eax
  804bf5:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804bfb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804bfe:	89 02                	mov    %eax,(%edx)
  804c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c03:	c1 e0 04             	shl    $0x4,%eax
  804c06:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804c0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804c0f:	89 02                	mov    %eax,(%edx)
  804c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804c14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c1d:	c1 e0 04             	shl    $0x4,%eax
  804c20:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804c25:	8b 00                	mov    (%eax),%eax
  804c27:	8d 50 01             	lea    0x1(%eax),%edx
  804c2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c2d:	c1 e0 04             	shl    $0x4,%eax
  804c30:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804c35:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  804c37:	ff 45 f0             	incl   -0x10(%ebp)
  804c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c3d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  804c40:	0f 8c 4a ff ff ff    	jl     804b90 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  804c46:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804c49:	e9 3d 01 00 00       	jmp    804d8b <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804c4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c51:	40                   	inc    %eax
  804c52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804c55:	e9 10 01 00 00       	jmp    804d6a <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  804c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c5d:	c1 e0 04             	shl    $0x4,%eax
  804c60:	05 60 f2 81 00       	add    $0x81f260,%eax
  804c65:	8b 00                	mov    (%eax),%eax
  804c67:	85 c0                	test   %eax,%eax
  804c69:	0f 84 f8 00 00 00    	je     804d67 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c72:	c1 e0 04             	shl    $0x4,%eax
  804c75:	05 60 f2 81 00       	add    $0x81f260,%eax
  804c7a:	8b 00                	mov    (%eax),%eax
  804c7c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  804c7f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804c83:	75 17                	jne    804c9c <alloc_block+0x3ab>
  804c85:	83 ec 04             	sub    $0x4,%esp
  804c88:	68 0d 65 80 00       	push   $0x80650d
  804c8d:	68 a8 00 00 00       	push   $0xa8
  804c92:	68 d3 64 80 00       	push   $0x8064d3
  804c97:	e8 42 c9 ff ff       	call   8015de <_panic>
  804c9c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804c9f:	8b 00                	mov    (%eax),%eax
  804ca1:	85 c0                	test   %eax,%eax
  804ca3:	74 10                	je     804cb5 <alloc_block+0x3c4>
  804ca5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804ca8:	8b 00                	mov    (%eax),%eax
  804caa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804cad:	8b 52 04             	mov    0x4(%edx),%edx
  804cb0:	89 50 04             	mov    %edx,0x4(%eax)
  804cb3:	eb 14                	jmp    804cc9 <alloc_block+0x3d8>
  804cb5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804cb8:	8b 40 04             	mov    0x4(%eax),%eax
  804cbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804cbe:	c1 e2 04             	shl    $0x4,%edx
  804cc1:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804cc7:	89 02                	mov    %eax,(%edx)
  804cc9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804ccc:	8b 40 04             	mov    0x4(%eax),%eax
  804ccf:	85 c0                	test   %eax,%eax
  804cd1:	74 0f                	je     804ce2 <alloc_block+0x3f1>
  804cd3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804cd6:	8b 40 04             	mov    0x4(%eax),%eax
  804cd9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804cdc:	8b 12                	mov    (%edx),%edx
  804cde:	89 10                	mov    %edx,(%eax)
  804ce0:	eb 13                	jmp    804cf5 <alloc_block+0x404>
  804ce2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804ce5:	8b 00                	mov    (%eax),%eax
  804ce7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804cea:	c1 e2 04             	shl    $0x4,%edx
  804ced:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804cf3:	89 02                	mov    %eax,(%edx)
  804cf5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804cf8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804cfe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804d01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d0b:	c1 e0 04             	shl    $0x4,%eax
  804d0e:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804d13:	8b 00                	mov    (%eax),%eax
  804d15:	8d 50 ff             	lea    -0x1(%eax),%edx
  804d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d1b:	c1 e0 04             	shl    $0x4,%eax
  804d1e:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804d23:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804d25:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804d28:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804d2d:	29 c2                	sub    %eax,%edx
  804d2f:	89 d0                	mov    %edx,%eax
  804d31:	c1 e8 0c             	shr    $0xc,%eax
  804d34:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  804d37:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  804d3a:	89 d0                	mov    %edx,%eax
  804d3c:	01 c0                	add    %eax,%eax
  804d3e:	01 d0                	add    %edx,%eax
  804d40:	c1 e0 02             	shl    $0x2,%eax
  804d43:	05 4a 72 80 00       	add    $0x80724a,%eax
  804d48:	66 8b 00             	mov    (%eax),%ax
  804d4b:	8d 50 ff             	lea    -0x1(%eax),%edx
  804d4e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  804d51:	89 c8                	mov    %ecx,%eax
  804d53:	01 c0                	add    %eax,%eax
  804d55:	01 c8                	add    %ecx,%eax
  804d57:	c1 e0 02             	shl    $0x2,%eax
  804d5a:	05 4a 72 80 00       	add    $0x80724a,%eax
  804d5f:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  804d62:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804d65:	eb 24                	jmp    804d8b <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804d67:	ff 45 ec             	incl   -0x14(%ebp)
  804d6a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804d6e:	0f 8e e6 fe ff ff    	jle    804c5a <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  804d74:	83 ec 04             	sub    $0x4,%esp
  804d77:	68 4f 65 80 00       	push   $0x80654f
  804d7c:	68 b1 00 00 00       	push   $0xb1
  804d81:	68 d3 64 80 00       	push   $0x8064d3
  804d86:	e8 53 c8 ff ff       	call   8015de <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804d8b:	c9                   	leave  
  804d8c:	c3                   	ret    

00804d8d <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804d8d:	55                   	push   %ebp
  804d8e:	89 e5                	mov    %esp,%ebp
  804d90:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804d93:	8b 55 08             	mov    0x8(%ebp),%edx
  804d96:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804d9b:	39 c2                	cmp    %eax,%edx
  804d9d:	72 0c                	jb     804dab <free_block+0x1e>
  804d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  804da2:	a1 20 72 80 00       	mov    0x807220,%eax
  804da7:	39 c2                	cmp    %eax,%edx
  804da9:	72 19                	jb     804dc4 <free_block+0x37>
  804dab:	68 6c 65 80 00       	push   $0x80656c
  804db0:	68 be 64 80 00       	push   $0x8064be
  804db5:	68 c3 00 00 00       	push   $0xc3
  804dba:	68 d3 64 80 00       	push   $0x8064d3
  804dbf:	e8 1a c8 ff ff       	call   8015de <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  804dc7:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804dcc:	29 c2                	sub    %eax,%edx
  804dce:	89 d0                	mov    %edx,%eax
  804dd0:	c1 e8 0c             	shr    $0xc,%eax
  804dd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  804dd6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804dd9:	89 d0                	mov    %edx,%eax
  804ddb:	01 c0                	add    %eax,%eax
  804ddd:	01 d0                	add    %edx,%eax
  804ddf:	c1 e0 02             	shl    $0x2,%eax
  804de2:	05 48 72 80 00       	add    $0x807248,%eax
  804de7:	8b 00                	mov    (%eax),%eax
  804de9:	0f b7 c0             	movzwl %ax,%eax
  804dec:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  804def:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804df3:	75 17                	jne    804e0c <free_block+0x7f>
		panic("page is empty(already not allocated)");
  804df5:	83 ec 04             	sub    $0x4,%esp
  804df8:	68 a4 65 80 00       	push   $0x8065a4
  804dfd:	68 cf 00 00 00       	push   $0xcf
  804e02:	68 d3 64 80 00       	push   $0x8064d3
  804e07:	e8 d2 c7 ff ff       	call   8015de <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804e0c:	83 ec 0c             	sub    $0xc,%esp
  804e0f:	ff 75 ec             	pushl  -0x14(%ebp)
  804e12:	e8 d8 f8 ff ff       	call   8046ef <log2>
  804e17:	83 c4 10             	add    $0x10,%esp
  804e1a:	83 e8 03             	sub    $0x3,%eax
  804e1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804e20:	8b 45 08             	mov    0x8(%ebp),%eax
  804e23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  804e26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804e2a:	75 17                	jne    804e43 <free_block+0xb6>
  804e2c:	83 ec 04             	sub    $0x4,%esp
  804e2f:	68 2c 65 80 00       	push   $0x80652c
  804e34:	68 d5 00 00 00       	push   $0xd5
  804e39:	68 d3 64 80 00       	push   $0x8064d3
  804e3e:	e8 9b c7 ff ff       	call   8015de <_panic>
  804e43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e46:	c1 e0 04             	shl    $0x4,%eax
  804e49:	05 64 f2 81 00       	add    $0x81f264,%eax
  804e4e:	8b 10                	mov    (%eax),%edx
  804e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e53:	89 50 04             	mov    %edx,0x4(%eax)
  804e56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e59:	8b 40 04             	mov    0x4(%eax),%eax
  804e5c:	85 c0                	test   %eax,%eax
  804e5e:	74 14                	je     804e74 <free_block+0xe7>
  804e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e63:	c1 e0 04             	shl    $0x4,%eax
  804e66:	05 64 f2 81 00       	add    $0x81f264,%eax
  804e6b:	8b 00                	mov    (%eax),%eax
  804e6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804e70:	89 10                	mov    %edx,(%eax)
  804e72:	eb 11                	jmp    804e85 <free_block+0xf8>
  804e74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e77:	c1 e0 04             	shl    $0x4,%eax
  804e7a:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804e80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e83:	89 02                	mov    %eax,(%edx)
  804e85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e88:	c1 e0 04             	shl    $0x4,%eax
  804e8b:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e94:	89 02                	mov    %eax,(%edx)
  804e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804ea2:	c1 e0 04             	shl    $0x4,%eax
  804ea5:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804eaa:	8b 00                	mov    (%eax),%eax
  804eac:	8d 50 01             	lea    0x1(%eax),%edx
  804eaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804eb2:	c1 e0 04             	shl    $0x4,%eax
  804eb5:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804eba:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  804ebc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804ebf:	89 d0                	mov    %edx,%eax
  804ec1:	01 c0                	add    %eax,%eax
  804ec3:	01 d0                	add    %edx,%eax
  804ec5:	c1 e0 02             	shl    $0x2,%eax
  804ec8:	05 4a 72 80 00       	add    $0x80724a,%eax
  804ecd:	66 8b 00             	mov    (%eax),%ax
  804ed0:	8d 50 01             	lea    0x1(%eax),%edx
  804ed3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804ed6:	89 c8                	mov    %ecx,%eax
  804ed8:	01 c0                	add    %eax,%eax
  804eda:	01 c8                	add    %ecx,%eax
  804edc:	c1 e0 02             	shl    $0x2,%eax
  804edf:	05 4a 72 80 00       	add    $0x80724a,%eax
  804ee4:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  804ee7:	b8 00 10 00 00       	mov    $0x1000,%eax
  804eec:	ba 00 00 00 00       	mov    $0x0,%edx
  804ef1:	f7 75 ec             	divl   -0x14(%ebp)
  804ef4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  804ef7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804efa:	89 d0                	mov    %edx,%eax
  804efc:	01 c0                	add    %eax,%eax
  804efe:	01 d0                	add    %edx,%eax
  804f00:	c1 e0 02             	shl    $0x2,%eax
  804f03:	05 4a 72 80 00       	add    $0x80724a,%eax
  804f08:	66 8b 00             	mov    (%eax),%ax
  804f0b:	0f b7 c0             	movzwl %ax,%eax
  804f0e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804f11:	0f 85 d3 01 00 00    	jne    8050ea <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  804f17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804f1a:	c1 e0 04             	shl    $0x4,%eax
  804f1d:	05 60 f2 81 00       	add    $0x81f260,%eax
  804f22:	8b 00                	mov    (%eax),%eax
  804f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  804f27:	e9 f1 00 00 00       	jmp    80501d <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f2f:	8b 00                	mov    (%eax),%eax
  804f31:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  804f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804f37:	c1 e0 0c             	shl    $0xc,%eax
  804f3a:	89 c2                	mov    %eax,%edx
  804f3c:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804f41:	01 d0                	add    %edx,%eax
  804f43:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  804f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804f49:	40                   	inc    %eax
  804f4a:	c1 e0 0c             	shl    $0xc,%eax
  804f4d:	89 c2                	mov    %eax,%edx
  804f4f:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804f54:	01 d0                	add    %edx,%eax
  804f56:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  804f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f5c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  804f5f:	0f 82 b8 00 00 00    	jb     80501d <free_block+0x290>
  804f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f68:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804f6b:	0f 83 ac 00 00 00    	jae    80501d <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  804f71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804f75:	75 17                	jne    804f8e <free_block+0x201>
  804f77:	83 ec 04             	sub    $0x4,%esp
  804f7a:	68 0d 65 80 00       	push   $0x80650d
  804f7f:	68 e2 00 00 00       	push   $0xe2
  804f84:	68 d3 64 80 00       	push   $0x8064d3
  804f89:	e8 50 c6 ff ff       	call   8015de <_panic>
  804f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f91:	8b 00                	mov    (%eax),%eax
  804f93:	85 c0                	test   %eax,%eax
  804f95:	74 10                	je     804fa7 <free_block+0x21a>
  804f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f9a:	8b 00                	mov    (%eax),%eax
  804f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804f9f:	8b 52 04             	mov    0x4(%edx),%edx
  804fa2:	89 50 04             	mov    %edx,0x4(%eax)
  804fa5:	eb 14                	jmp    804fbb <free_block+0x22e>
  804fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804faa:	8b 40 04             	mov    0x4(%eax),%eax
  804fad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804fb0:	c1 e2 04             	shl    $0x4,%edx
  804fb3:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804fb9:	89 02                	mov    %eax,(%edx)
  804fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fbe:	8b 40 04             	mov    0x4(%eax),%eax
  804fc1:	85 c0                	test   %eax,%eax
  804fc3:	74 0f                	je     804fd4 <free_block+0x247>
  804fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fc8:	8b 40 04             	mov    0x4(%eax),%eax
  804fcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804fce:	8b 12                	mov    (%edx),%edx
  804fd0:	89 10                	mov    %edx,(%eax)
  804fd2:	eb 13                	jmp    804fe7 <free_block+0x25a>
  804fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fd7:	8b 00                	mov    (%eax),%eax
  804fd9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804fdc:	c1 e2 04             	shl    $0x4,%edx
  804fdf:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804fe5:	89 02                	mov    %eax,(%edx)
  804fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ff3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804ffd:	c1 e0 04             	shl    $0x4,%eax
  805000:	05 6c f2 81 00       	add    $0x81f26c,%eax
  805005:	8b 00                	mov    (%eax),%eax
  805007:	8d 50 ff             	lea    -0x1(%eax),%edx
  80500a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80500d:	c1 e0 04             	shl    $0x4,%eax
  805010:	05 6c f2 81 00       	add    $0x81f26c,%eax
  805015:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  805017:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80501a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  80501d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  805021:	0f 85 05 ff ff ff    	jne    804f2c <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  805027:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80502a:	89 d0                	mov    %edx,%eax
  80502c:	01 c0                	add    %eax,%eax
  80502e:	01 d0                	add    %edx,%eax
  805030:	c1 e0 02             	shl    $0x2,%eax
  805033:	05 48 72 80 00       	add    $0x807248,%eax
  805038:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  80503d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  805040:	89 d0                	mov    %edx,%eax
  805042:	01 c0                	add    %eax,%eax
  805044:	01 d0                	add    %edx,%eax
  805046:	c1 e0 02             	shl    $0x2,%eax
  805049:	05 4a 72 80 00       	add    $0x80724a,%eax
  80504e:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  805053:	8b 55 f0             	mov    -0x10(%ebp),%edx
  805056:	89 d0                	mov    %edx,%eax
  805058:	01 c0                	add    %eax,%eax
  80505a:	01 d0                	add    %edx,%eax
  80505c:	c1 e0 02             	shl    $0x2,%eax
  80505f:	05 40 72 80 00       	add    $0x807240,%eax
  805064:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  805067:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80506b:	75 17                	jne    805084 <free_block+0x2f7>
  80506d:	83 ec 04             	sub    $0x4,%esp
  805070:	68 2c 65 80 00       	push   $0x80652c
  805075:	68 eb 00 00 00       	push   $0xeb
  80507a:	68 d3 64 80 00       	push   $0x8064d3
  80507f:	e8 5a c5 ff ff       	call   8015de <_panic>
  805084:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  80508a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80508d:	89 50 04             	mov    %edx,0x4(%eax)
  805090:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805093:	8b 40 04             	mov    0x4(%eax),%eax
  805096:	85 c0                	test   %eax,%eax
  805098:	74 0c                	je     8050a6 <free_block+0x319>
  80509a:	a1 2c 72 80 00       	mov    0x80722c,%eax
  80509f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8050a2:	89 10                	mov    %edx,(%eax)
  8050a4:	eb 08                	jmp    8050ae <free_block+0x321>
  8050a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8050a9:	a3 28 72 80 00       	mov    %eax,0x807228
  8050ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8050b1:	a3 2c 72 80 00       	mov    %eax,0x80722c
  8050b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8050b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8050bf:	a1 34 72 80 00       	mov    0x807234,%eax
  8050c4:	40                   	inc    %eax
  8050c5:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  8050ca:	83 ec 0c             	sub    $0xc,%esp
  8050cd:	ff 75 d0             	pushl  -0x30(%ebp)
  8050d0:	e8 ce f5 ff ff       	call   8046a3 <to_page_va>
  8050d5:	83 c4 10             	add    $0x10,%esp
  8050d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  8050db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8050de:	83 ec 0c             	sub    $0xc,%esp
  8050e1:	50                   	push   %eax
  8050e2:	e8 9e d7 ff ff       	call   802885 <return_page>
  8050e7:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8050ea:	90                   	nop
  8050eb:	c9                   	leave  
  8050ec:	c3                   	ret    

008050ed <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8050ed:	55                   	push   %ebp
  8050ee:	89 e5                	mov    %esp,%ebp
  8050f0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8050f3:	83 ec 04             	sub    $0x4,%esp
  8050f6:	68 cc 65 80 00       	push   $0x8065cc
  8050fb:	68 01 01 00 00       	push   $0x101
  805100:	68 d3 64 80 00       	push   $0x8064d3
  805105:	e8 d4 c4 ff ff       	call   8015de <_panic>

0080510a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80510a:	55                   	push   %ebp
  80510b:	89 e5                	mov    %esp,%ebp
  80510d:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  805110:	8b 55 08             	mov    0x8(%ebp),%edx
  805113:	89 d0                	mov    %edx,%eax
  805115:	c1 e0 02             	shl    $0x2,%eax
  805118:	01 d0                	add    %edx,%eax
  80511a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  805121:	01 d0                	add    %edx,%eax
  805123:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80512a:	01 d0                	add    %edx,%eax
  80512c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  805133:	01 d0                	add    %edx,%eax
  805135:	c1 e0 04             	shl    $0x4,%eax
  805138:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  80513b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  805142:	0f 31                	rdtsc  
  805144:	89 45 e8             	mov    %eax,-0x18(%ebp)
  805147:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80514a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80514d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  805150:	89 45 f0             	mov    %eax,-0x10(%ebp)
  805153:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  805156:	eb 46                	jmp    80519e <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  805158:	0f 31                	rdtsc  
  80515a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80515d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  805160:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805163:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  805166:	89 45 e0             	mov    %eax,-0x20(%ebp)
  805169:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80516c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80516f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805172:	29 c2                	sub    %eax,%edx
  805174:	89 d0                	mov    %edx,%eax
  805176:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  805179:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80517c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80517f:	89 d1                	mov    %edx,%ecx
  805181:	29 c1                	sub    %eax,%ecx
  805183:	8b 55 d8             	mov    -0x28(%ebp),%edx
  805186:	8b 45 e0             	mov    -0x20(%ebp),%eax
  805189:	39 c2                	cmp    %eax,%edx
  80518b:	0f 97 c0             	seta   %al
  80518e:	0f b6 c0             	movzbl %al,%eax
  805191:	29 c1                	sub    %eax,%ecx
  805193:	89 c8                	mov    %ecx,%eax
  805195:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  805198:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80519b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80519e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8051a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8051a4:	72 b2                	jb     805158 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8051a6:	90                   	nop
  8051a7:	c9                   	leave  
  8051a8:	c3                   	ret    

008051a9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8051a9:	55                   	push   %ebp
  8051aa:	89 e5                	mov    %esp,%ebp
  8051ac:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8051af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8051b6:	eb 03                	jmp    8051bb <busy_wait+0x12>
  8051b8:	ff 45 fc             	incl   -0x4(%ebp)
  8051bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8051be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8051c1:	72 f5                	jb     8051b8 <busy_wait+0xf>
	return i;
  8051c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8051c6:	c9                   	leave  
  8051c7:	c3                   	ret    

008051c8 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  8051c8:	55                   	push   %ebp
  8051c9:	89 e5                	mov    %esp,%ebp
  8051cb:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  8051ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8051d2:	74 1c                	je     8051f0 <init_uspinlock+0x28>
  8051d4:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8051d8:	74 16                	je     8051f0 <init_uspinlock+0x28>
  8051da:	68 f0 65 80 00       	push   $0x8065f0
  8051df:	68 0f 66 80 00       	push   $0x80660f
  8051e4:	6a 10                	push   $0x10
  8051e6:	68 24 66 80 00       	push   $0x806624
  8051eb:	e8 ee c3 ff ff       	call   8015de <_panic>
	strcpy(lk->name, name);
  8051f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8051f3:	83 c0 04             	add    $0x4,%eax
  8051f6:	83 ec 08             	sub    $0x8,%esp
  8051f9:	ff 75 0c             	pushl  0xc(%ebp)
  8051fc:	50                   	push   %eax
  8051fd:	e8 d2 cd ff ff       	call   801fd4 <strcpy>
  805202:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  805205:	b8 01 00 00 00       	mov    $0x1,%eax
  80520a:	2b 45 10             	sub    0x10(%ebp),%eax
  80520d:	89 c2                	mov    %eax,%edx
  80520f:	8b 45 08             	mov    0x8(%ebp),%eax
  805212:	89 10                	mov    %edx,(%eax)
}
  805214:	90                   	nop
  805215:	c9                   	leave  
  805216:	c3                   	ret    

00805217 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  805217:	55                   	push   %ebp
  805218:	89 e5                	mov    %esp,%ebp
  80521a:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  80521d:	90                   	nop
  80521e:	8b 45 08             	mov    0x8(%ebp),%eax
  805221:	89 45 f4             	mov    %eax,-0xc(%ebp)
  805224:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80522b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80522e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805231:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  805234:	f0 87 02             	lock xchg %eax,(%edx)
  805237:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  80523a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80523d:	85 c0                	test   %eax,%eax
  80523f:	75 dd                	jne    80521e <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  805241:	8b 45 08             	mov    0x8(%ebp),%eax
  805244:	8d 48 04             	lea    0x4(%eax),%ecx
  805247:	a1 00 72 80 00       	mov    0x807200,%eax
  80524c:	8d 50 20             	lea    0x20(%eax),%edx
  80524f:	a1 00 72 80 00       	mov    0x807200,%eax
  805254:	8b 40 10             	mov    0x10(%eax),%eax
  805257:	51                   	push   %ecx
  805258:	52                   	push   %edx
  805259:	50                   	push   %eax
  80525a:	68 34 66 80 00       	push   $0x806634
  80525f:	e8 48 c6 ff ff       	call   8018ac <cprintf>
  805264:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  805267:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  80526c:	90                   	nop
  80526d:	c9                   	leave  
  80526e:	c3                   	ret    

0080526f <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  80526f:	55                   	push   %ebp
  805270:	89 e5                	mov    %esp,%ebp
  805272:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  805275:	8b 45 08             	mov    0x8(%ebp),%eax
  805278:	8b 00                	mov    (%eax),%eax
  80527a:	85 c0                	test   %eax,%eax
  80527c:	75 18                	jne    805296 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  80527e:	8b 45 08             	mov    0x8(%ebp),%eax
  805281:	83 c0 04             	add    $0x4,%eax
  805284:	50                   	push   %eax
  805285:	68 58 66 80 00       	push   $0x806658
  80528a:	6a 2b                	push   $0x2b
  80528c:	68 24 66 80 00       	push   $0x806624
  805291:	e8 48 c3 ff ff       	call   8015de <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  805296:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  80529b:	8b 45 08             	mov    0x8(%ebp),%eax
  80529e:	8b 55 08             	mov    0x8(%ebp),%edx
  8052a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8052a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8052aa:	8d 48 04             	lea    0x4(%eax),%ecx
  8052ad:	a1 00 72 80 00       	mov    0x807200,%eax
  8052b2:	8d 50 20             	lea    0x20(%eax),%edx
  8052b5:	a1 00 72 80 00       	mov    0x807200,%eax
  8052ba:	8b 40 10             	mov    0x10(%eax),%eax
  8052bd:	51                   	push   %ecx
  8052be:	52                   	push   %edx
  8052bf:	50                   	push   %eax
  8052c0:	68 78 66 80 00       	push   $0x806678
  8052c5:	e8 e2 c5 ff ff       	call   8018ac <cprintf>
  8052ca:	83 c4 10             	add    $0x10,%esp
}
  8052cd:	90                   	nop
  8052ce:	c9                   	leave  
  8052cf:	c3                   	ret    

008052d0 <__udivdi3>:
  8052d0:	55                   	push   %ebp
  8052d1:	57                   	push   %edi
  8052d2:	56                   	push   %esi
  8052d3:	53                   	push   %ebx
  8052d4:	83 ec 1c             	sub    $0x1c,%esp
  8052d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8052db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8052df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8052e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8052e7:	89 ca                	mov    %ecx,%edx
  8052e9:	89 f8                	mov    %edi,%eax
  8052eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8052ef:	85 f6                	test   %esi,%esi
  8052f1:	75 2d                	jne    805320 <__udivdi3+0x50>
  8052f3:	39 cf                	cmp    %ecx,%edi
  8052f5:	77 65                	ja     80535c <__udivdi3+0x8c>
  8052f7:	89 fd                	mov    %edi,%ebp
  8052f9:	85 ff                	test   %edi,%edi
  8052fb:	75 0b                	jne    805308 <__udivdi3+0x38>
  8052fd:	b8 01 00 00 00       	mov    $0x1,%eax
  805302:	31 d2                	xor    %edx,%edx
  805304:	f7 f7                	div    %edi
  805306:	89 c5                	mov    %eax,%ebp
  805308:	31 d2                	xor    %edx,%edx
  80530a:	89 c8                	mov    %ecx,%eax
  80530c:	f7 f5                	div    %ebp
  80530e:	89 c1                	mov    %eax,%ecx
  805310:	89 d8                	mov    %ebx,%eax
  805312:	f7 f5                	div    %ebp
  805314:	89 cf                	mov    %ecx,%edi
  805316:	89 fa                	mov    %edi,%edx
  805318:	83 c4 1c             	add    $0x1c,%esp
  80531b:	5b                   	pop    %ebx
  80531c:	5e                   	pop    %esi
  80531d:	5f                   	pop    %edi
  80531e:	5d                   	pop    %ebp
  80531f:	c3                   	ret    
  805320:	39 ce                	cmp    %ecx,%esi
  805322:	77 28                	ja     80534c <__udivdi3+0x7c>
  805324:	0f bd fe             	bsr    %esi,%edi
  805327:	83 f7 1f             	xor    $0x1f,%edi
  80532a:	75 40                	jne    80536c <__udivdi3+0x9c>
  80532c:	39 ce                	cmp    %ecx,%esi
  80532e:	72 0a                	jb     80533a <__udivdi3+0x6a>
  805330:	3b 44 24 08          	cmp    0x8(%esp),%eax
  805334:	0f 87 9e 00 00 00    	ja     8053d8 <__udivdi3+0x108>
  80533a:	b8 01 00 00 00       	mov    $0x1,%eax
  80533f:	89 fa                	mov    %edi,%edx
  805341:	83 c4 1c             	add    $0x1c,%esp
  805344:	5b                   	pop    %ebx
  805345:	5e                   	pop    %esi
  805346:	5f                   	pop    %edi
  805347:	5d                   	pop    %ebp
  805348:	c3                   	ret    
  805349:	8d 76 00             	lea    0x0(%esi),%esi
  80534c:	31 ff                	xor    %edi,%edi
  80534e:	31 c0                	xor    %eax,%eax
  805350:	89 fa                	mov    %edi,%edx
  805352:	83 c4 1c             	add    $0x1c,%esp
  805355:	5b                   	pop    %ebx
  805356:	5e                   	pop    %esi
  805357:	5f                   	pop    %edi
  805358:	5d                   	pop    %ebp
  805359:	c3                   	ret    
  80535a:	66 90                	xchg   %ax,%ax
  80535c:	89 d8                	mov    %ebx,%eax
  80535e:	f7 f7                	div    %edi
  805360:	31 ff                	xor    %edi,%edi
  805362:	89 fa                	mov    %edi,%edx
  805364:	83 c4 1c             	add    $0x1c,%esp
  805367:	5b                   	pop    %ebx
  805368:	5e                   	pop    %esi
  805369:	5f                   	pop    %edi
  80536a:	5d                   	pop    %ebp
  80536b:	c3                   	ret    
  80536c:	bd 20 00 00 00       	mov    $0x20,%ebp
  805371:	89 eb                	mov    %ebp,%ebx
  805373:	29 fb                	sub    %edi,%ebx
  805375:	89 f9                	mov    %edi,%ecx
  805377:	d3 e6                	shl    %cl,%esi
  805379:	89 c5                	mov    %eax,%ebp
  80537b:	88 d9                	mov    %bl,%cl
  80537d:	d3 ed                	shr    %cl,%ebp
  80537f:	89 e9                	mov    %ebp,%ecx
  805381:	09 f1                	or     %esi,%ecx
  805383:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  805387:	89 f9                	mov    %edi,%ecx
  805389:	d3 e0                	shl    %cl,%eax
  80538b:	89 c5                	mov    %eax,%ebp
  80538d:	89 d6                	mov    %edx,%esi
  80538f:	88 d9                	mov    %bl,%cl
  805391:	d3 ee                	shr    %cl,%esi
  805393:	89 f9                	mov    %edi,%ecx
  805395:	d3 e2                	shl    %cl,%edx
  805397:	8b 44 24 08          	mov    0x8(%esp),%eax
  80539b:	88 d9                	mov    %bl,%cl
  80539d:	d3 e8                	shr    %cl,%eax
  80539f:	09 c2                	or     %eax,%edx
  8053a1:	89 d0                	mov    %edx,%eax
  8053a3:	89 f2                	mov    %esi,%edx
  8053a5:	f7 74 24 0c          	divl   0xc(%esp)
  8053a9:	89 d6                	mov    %edx,%esi
  8053ab:	89 c3                	mov    %eax,%ebx
  8053ad:	f7 e5                	mul    %ebp
  8053af:	39 d6                	cmp    %edx,%esi
  8053b1:	72 19                	jb     8053cc <__udivdi3+0xfc>
  8053b3:	74 0b                	je     8053c0 <__udivdi3+0xf0>
  8053b5:	89 d8                	mov    %ebx,%eax
  8053b7:	31 ff                	xor    %edi,%edi
  8053b9:	e9 58 ff ff ff       	jmp    805316 <__udivdi3+0x46>
  8053be:	66 90                	xchg   %ax,%ax
  8053c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8053c4:	89 f9                	mov    %edi,%ecx
  8053c6:	d3 e2                	shl    %cl,%edx
  8053c8:	39 c2                	cmp    %eax,%edx
  8053ca:	73 e9                	jae    8053b5 <__udivdi3+0xe5>
  8053cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8053cf:	31 ff                	xor    %edi,%edi
  8053d1:	e9 40 ff ff ff       	jmp    805316 <__udivdi3+0x46>
  8053d6:	66 90                	xchg   %ax,%ax
  8053d8:	31 c0                	xor    %eax,%eax
  8053da:	e9 37 ff ff ff       	jmp    805316 <__udivdi3+0x46>
  8053df:	90                   	nop

008053e0 <__umoddi3>:
  8053e0:	55                   	push   %ebp
  8053e1:	57                   	push   %edi
  8053e2:	56                   	push   %esi
  8053e3:	53                   	push   %ebx
  8053e4:	83 ec 1c             	sub    $0x1c,%esp
  8053e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8053eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8053ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8053f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8053f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8053fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8053ff:	89 f3                	mov    %esi,%ebx
  805401:	89 fa                	mov    %edi,%edx
  805403:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  805407:	89 34 24             	mov    %esi,(%esp)
  80540a:	85 c0                	test   %eax,%eax
  80540c:	75 1a                	jne    805428 <__umoddi3+0x48>
  80540e:	39 f7                	cmp    %esi,%edi
  805410:	0f 86 a2 00 00 00    	jbe    8054b8 <__umoddi3+0xd8>
  805416:	89 c8                	mov    %ecx,%eax
  805418:	89 f2                	mov    %esi,%edx
  80541a:	f7 f7                	div    %edi
  80541c:	89 d0                	mov    %edx,%eax
  80541e:	31 d2                	xor    %edx,%edx
  805420:	83 c4 1c             	add    $0x1c,%esp
  805423:	5b                   	pop    %ebx
  805424:	5e                   	pop    %esi
  805425:	5f                   	pop    %edi
  805426:	5d                   	pop    %ebp
  805427:	c3                   	ret    
  805428:	39 f0                	cmp    %esi,%eax
  80542a:	0f 87 ac 00 00 00    	ja     8054dc <__umoddi3+0xfc>
  805430:	0f bd e8             	bsr    %eax,%ebp
  805433:	83 f5 1f             	xor    $0x1f,%ebp
  805436:	0f 84 ac 00 00 00    	je     8054e8 <__umoddi3+0x108>
  80543c:	bf 20 00 00 00       	mov    $0x20,%edi
  805441:	29 ef                	sub    %ebp,%edi
  805443:	89 fe                	mov    %edi,%esi
  805445:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  805449:	89 e9                	mov    %ebp,%ecx
  80544b:	d3 e0                	shl    %cl,%eax
  80544d:	89 d7                	mov    %edx,%edi
  80544f:	89 f1                	mov    %esi,%ecx
  805451:	d3 ef                	shr    %cl,%edi
  805453:	09 c7                	or     %eax,%edi
  805455:	89 e9                	mov    %ebp,%ecx
  805457:	d3 e2                	shl    %cl,%edx
  805459:	89 14 24             	mov    %edx,(%esp)
  80545c:	89 d8                	mov    %ebx,%eax
  80545e:	d3 e0                	shl    %cl,%eax
  805460:	89 c2                	mov    %eax,%edx
  805462:	8b 44 24 08          	mov    0x8(%esp),%eax
  805466:	d3 e0                	shl    %cl,%eax
  805468:	89 44 24 04          	mov    %eax,0x4(%esp)
  80546c:	8b 44 24 08          	mov    0x8(%esp),%eax
  805470:	89 f1                	mov    %esi,%ecx
  805472:	d3 e8                	shr    %cl,%eax
  805474:	09 d0                	or     %edx,%eax
  805476:	d3 eb                	shr    %cl,%ebx
  805478:	89 da                	mov    %ebx,%edx
  80547a:	f7 f7                	div    %edi
  80547c:	89 d3                	mov    %edx,%ebx
  80547e:	f7 24 24             	mull   (%esp)
  805481:	89 c6                	mov    %eax,%esi
  805483:	89 d1                	mov    %edx,%ecx
  805485:	39 d3                	cmp    %edx,%ebx
  805487:	0f 82 87 00 00 00    	jb     805514 <__umoddi3+0x134>
  80548d:	0f 84 91 00 00 00    	je     805524 <__umoddi3+0x144>
  805493:	8b 54 24 04          	mov    0x4(%esp),%edx
  805497:	29 f2                	sub    %esi,%edx
  805499:	19 cb                	sbb    %ecx,%ebx
  80549b:	89 d8                	mov    %ebx,%eax
  80549d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8054a1:	d3 e0                	shl    %cl,%eax
  8054a3:	89 e9                	mov    %ebp,%ecx
  8054a5:	d3 ea                	shr    %cl,%edx
  8054a7:	09 d0                	or     %edx,%eax
  8054a9:	89 e9                	mov    %ebp,%ecx
  8054ab:	d3 eb                	shr    %cl,%ebx
  8054ad:	89 da                	mov    %ebx,%edx
  8054af:	83 c4 1c             	add    $0x1c,%esp
  8054b2:	5b                   	pop    %ebx
  8054b3:	5e                   	pop    %esi
  8054b4:	5f                   	pop    %edi
  8054b5:	5d                   	pop    %ebp
  8054b6:	c3                   	ret    
  8054b7:	90                   	nop
  8054b8:	89 fd                	mov    %edi,%ebp
  8054ba:	85 ff                	test   %edi,%edi
  8054bc:	75 0b                	jne    8054c9 <__umoddi3+0xe9>
  8054be:	b8 01 00 00 00       	mov    $0x1,%eax
  8054c3:	31 d2                	xor    %edx,%edx
  8054c5:	f7 f7                	div    %edi
  8054c7:	89 c5                	mov    %eax,%ebp
  8054c9:	89 f0                	mov    %esi,%eax
  8054cb:	31 d2                	xor    %edx,%edx
  8054cd:	f7 f5                	div    %ebp
  8054cf:	89 c8                	mov    %ecx,%eax
  8054d1:	f7 f5                	div    %ebp
  8054d3:	89 d0                	mov    %edx,%eax
  8054d5:	e9 44 ff ff ff       	jmp    80541e <__umoddi3+0x3e>
  8054da:	66 90                	xchg   %ax,%ax
  8054dc:	89 c8                	mov    %ecx,%eax
  8054de:	89 f2                	mov    %esi,%edx
  8054e0:	83 c4 1c             	add    $0x1c,%esp
  8054e3:	5b                   	pop    %ebx
  8054e4:	5e                   	pop    %esi
  8054e5:	5f                   	pop    %edi
  8054e6:	5d                   	pop    %ebp
  8054e7:	c3                   	ret    
  8054e8:	3b 04 24             	cmp    (%esp),%eax
  8054eb:	72 06                	jb     8054f3 <__umoddi3+0x113>
  8054ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8054f1:	77 0f                	ja     805502 <__umoddi3+0x122>
  8054f3:	89 f2                	mov    %esi,%edx
  8054f5:	29 f9                	sub    %edi,%ecx
  8054f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8054fb:	89 14 24             	mov    %edx,(%esp)
  8054fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  805502:	8b 44 24 04          	mov    0x4(%esp),%eax
  805506:	8b 14 24             	mov    (%esp),%edx
  805509:	83 c4 1c             	add    $0x1c,%esp
  80550c:	5b                   	pop    %ebx
  80550d:	5e                   	pop    %esi
  80550e:	5f                   	pop    %edi
  80550f:	5d                   	pop    %ebp
  805510:	c3                   	ret    
  805511:	8d 76 00             	lea    0x0(%esi),%esi
  805514:	2b 04 24             	sub    (%esp),%eax
  805517:	19 fa                	sbb    %edi,%edx
  805519:	89 d1                	mov    %edx,%ecx
  80551b:	89 c6                	mov    %eax,%esi
  80551d:	e9 71 ff ff ff       	jmp    805493 <__umoddi3+0xb3>
  805522:	66 90                	xchg   %ax,%ax
  805524:	39 44 24 04          	cmp    %eax,0x4(%esp)
  805528:	72 ea                	jb     805514 <__umoddi3+0x134>
  80552a:	89 d9                	mov    %ebx,%ecx
  80552c:	e9 62 ff ff ff       	jmp    805493 <__umoddi3+0xb3>
