
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 0f 14 00 00       	call   801445 <libmain>
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
  800067:	e8 cb 41 00 00       	call   804237 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 0e 42 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 1e 28 00 00       	call   8028e5 <malloc>
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
  8000df:	e8 53 41 00 00       	call   804237 <sys_calculate_free_frames>
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
  800125:	68 a0 54 80 00       	push   $0x8054a0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 c8 17 00 00       	call   8018f9 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 49 41 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 1c 55 80 00       	push   $0x80551c
  800150:	6a 0c                	push   $0xc
  800152:	e8 a2 17 00 00       	call   8018f9 <cprintf_colored>
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
  800174:	e8 be 40 00 00       	call   804237 <sys_calculate_free_frames>
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
  8001b9:	e8 79 40 00 00       	call   804237 <sys_calculate_free_frames>
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
  8001f8:	68 94 55 80 00       	push   $0x805594
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 f5 16 00 00       	call   8018f9 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 76 40 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 20 56 80 00       	push   $0x805620
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 c8 16 00 00       	call   8018f9 <cprintf_colored>
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
  800270:	e8 84 43 00 00       	call   8045f9 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 98 56 80 00       	push   $0x805698
  80028f:	6a 0c                	push   $0xc
  800291:	e8 63 16 00 00       	call   8018f9 <cprintf_colored>
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
  8002ae:	e8 84 3f 00 00       	call   804237 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 c7 3f 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 12 2b 00 00       	call   802de3 <free>
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
  8002fc:	e8 81 3f 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 d0 56 80 00       	push   $0x8056d0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 da 15 00 00       	call   8018f9 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 10 3f 00 00       	call   804237 <sys_calculate_free_frames>
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
  800342:	68 1c 57 80 00       	push   $0x80571c
  800347:	6a 0c                	push   $0xc
  800349:	e8 ab 15 00 00       	call   8018f9 <cprintf_colored>
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
  8003a0:	e8 54 42 00 00       	call   8045f9 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 78 57 80 00       	push   $0x805778
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 33 15 00 00       	call   8018f9 <cprintf_colored>
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
  800416:	68 b0 57 80 00       	push   $0x8057b0
  80041b:	6a 03                	push   $0x3
  80041d:	e8 d7 14 00 00       	call   8018f9 <cprintf_colored>
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
  8004df:	68 e0 57 80 00       	push   $0x8057e0
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 0e 14 00 00       	call   8018f9 <cprintf_colored>
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
  8005b9:	68 e0 57 80 00       	push   $0x8057e0
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 34 13 00 00       	call   8018f9 <cprintf_colored>
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
  800693:	68 e0 57 80 00       	push   $0x8057e0
  800698:	6a 0c                	push   $0xc
  80069a:	e8 5a 12 00 00       	call   8018f9 <cprintf_colored>
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
  80076d:	68 e0 57 80 00       	push   $0x8057e0
  800772:	6a 0c                	push   $0xc
  800774:	e8 80 11 00 00       	call   8018f9 <cprintf_colored>
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
  800847:	68 e0 57 80 00       	push   $0x8057e0
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 a6 10 00 00       	call   8018f9 <cprintf_colored>
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
  800921:	68 e0 57 80 00       	push   $0x8057e0
  800926:	6a 0c                	push   $0xc
  800928:	e8 cc 0f 00 00       	call   8018f9 <cprintf_colored>
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
  800a16:	68 e0 57 80 00       	push   $0x8057e0
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 d7 0e 00 00       	call   8018f9 <cprintf_colored>
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
  800b14:	68 e0 57 80 00       	push   $0x8057e0
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 d9 0d 00 00       	call   8018f9 <cprintf_colored>
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
  800c12:	68 e0 57 80 00       	push   $0x8057e0
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 db 0c 00 00       	call   8018f9 <cprintf_colored>
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
  800d10:	68 e0 57 80 00       	push   $0x8057e0
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 dd 0b 00 00       	call   8018f9 <cprintf_colored>
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
  800dfd:	68 e0 57 80 00       	push   $0x8057e0
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 f0 0a 00 00       	call   8018f9 <cprintf_colored>
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
  800eea:	68 e0 57 80 00       	push   $0x8057e0
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 03 0a 00 00       	call   8018f9 <cprintf_colored>
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
  800fd7:	68 e0 57 80 00       	push   $0x8057e0
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 16 09 00 00       	call   8018f9 <cprintf_colored>
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
  800ffa:	68 32 58 80 00       	push   $0x805832
  800fff:	6a 03                	push   $0x3
  801001:	e8 f3 08 00 00       	call   8018f9 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 18 32 00 00       	call   804237 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 58 32 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 8b 18 00 00       	call   8028e5 <malloc>
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
  801084:	68 50 58 80 00       	push   $0x805850
  801089:	6a 0c                	push   $0xc
  80108b:	e8 69 08 00 00       	call   8018f9 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 ea 31 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 8c 58 80 00       	push   $0x80588c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 3d 08 00 00       	call   8018f9 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 73 31 00 00       	call   804237 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 fc 58 80 00       	push   $0x8058fc
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 11 08 00 00       	call   8018f9 <cprintf_colored>
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
  801124:	68 44 59 80 00       	push   $0x805944
  801129:	6a 0f                	push   $0xf
  80112b:	68 60 59 80 00       	push   $0x805960
  801130:	e8 c9 04 00 00       	call   8015fe <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801135:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	uint32 *x,*y,*z, *expectedVA;
	int diff, expected;
	int freeFrames, usedDiskPages ;
	int32 parentenvID = sys_getparentenvid();
  80113c:	e8 d8 32 00 00       	call   804419 <sys_getparentenvid>
  801141:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_lock_cons();
  801144:	e8 3e 30 00 00       	call   804187 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  801149:	e8 e9 30 00 00       	call   804237 <sys_calculate_free_frames>
  80114e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801151:	e8 2c 31 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
  801156:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = sget(parentenvID,"z");
  801159:	83 ec 08             	sub    $0x8,%esp
  80115c:	68 7b 59 80 00       	push   $0x80597b
  801161:	ff 75 f0             	pushl  -0x10(%ebp)
  801164:	e8 b1 29 00 00       	call   803b1a <sget>
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
  801186:	68 80 59 80 00       	push   $0x805980
  80118b:	6a 24                	push   $0x24
  80118d:	68 60 59 80 00       	push   $0x805960
  801192:	e8 67 04 00 00       	call   8015fe <_panic>
		expected = 1 ; /*1 table in UH*/
  801197:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80119e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8011a1:	e8 91 30 00 00       	call   804237 <sys_calculate_free_frames>
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
  8011d2:	e8 60 30 00 00       	call   804237 <sys_calculate_free_frames>
  8011d7:	29 c6                	sub    %eax,%esi
  8011d9:	89 f0                	mov    %esi,%eax
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	53                   	push   %ebx
  8011df:	ff 75 dc             	pushl  -0x24(%ebp)
  8011e2:	50                   	push   %eax
  8011e3:	68 fc 59 80 00       	push   $0x8059fc
  8011e8:	6a 28                	push   $0x28
  8011ea:	68 60 59 80 00       	push   $0x805960
  8011ef:	e8 0a 04 00 00       	call   8015fe <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8011f4:	e8 89 30 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
  8011f9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8011fc:	74 14                	je     801212 <_main+0x113>
		{panic("Wrong page file allocation: ");}
  8011fe:	83 ec 04             	sub    $0x4,%esp
  801201:	68 9a 5a 80 00       	push   $0x805a9a
  801206:	6a 2a                	push   $0x2a
  801208:	68 60 59 80 00       	push   $0x805960
  80120d:	e8 ec 03 00 00       	call   8015fe <_panic>
	}
	sys_unlock_cons();
  801212:	e8 8a 2f 00 00       	call   8041a1 <sys_unlock_cons>

	sys_lock_cons();
  801217:	e8 6b 2f 00 00       	call   804187 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  80121c:	e8 16 30 00 00       	call   804237 <sys_calculate_free_frames>
  801221:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801224:	e8 59 30 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
  801229:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = sget(parentenvID,"y");
  80122c:	83 ec 08             	sub    $0x8,%esp
  80122f:	68 b7 5a 80 00       	push   $0x805ab7
  801234:	ff 75 f0             	pushl  -0x10(%ebp)
  801237:	e8 de 28 00 00       	call   803b1a <sget>
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  801242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801245:	05 00 10 00 00       	add    $0x1000,%eax
  80124a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (y != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, y);
  80124d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801250:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801253:	74 1a                	je     80126f <_main+0x170>
  801255:	83 ec 0c             	sub    $0xc,%esp
  801258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80125b:	ff 75 e0             	pushl  -0x20(%ebp)
  80125e:	68 80 59 80 00       	push   $0x805980
  801263:	6a 34                	push   $0x34
  801265:	68 60 59 80 00       	push   $0x805960
  80126a:	e8 8f 03 00 00       	call   8015fe <_panic>
		expected = 0 ;
  80126f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  801276:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  801279:	e8 b9 2f 00 00       	call   804237 <sys_calculate_free_frames>
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
  8012a0:	e8 92 2f 00 00       	call   804237 <sys_calculate_free_frames>
  8012a5:	29 c3                	sub    %eax,%ebx
  8012a7:	89 d8                	mov    %ebx,%eax
  8012a9:	83 ec 0c             	sub    $0xc,%esp
  8012ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8012af:	50                   	push   %eax
  8012b0:	68 bc 5a 80 00       	push   $0x805abc
  8012b5:	6a 38                	push   $0x38
  8012b7:	68 60 59 80 00       	push   $0x805960
  8012bc:	e8 3d 03 00 00       	call   8015fe <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8012c1:	e8 bc 2f 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
  8012c6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8012c9:	74 14                	je     8012df <_main+0x1e0>
		{panic("Wrong page file allocation: ");}
  8012cb:	83 ec 04             	sub    $0x4,%esp
  8012ce:	68 9a 5a 80 00       	push   $0x805a9a
  8012d3:	6a 3a                	push   $0x3a
  8012d5:	68 60 59 80 00       	push   $0x805960
  8012da:	e8 1f 03 00 00       	call   8015fe <_panic>
	}
	sys_unlock_cons();
  8012df:	e8 bd 2e 00 00       	call   8041a1 <sys_unlock_cons>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8012e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	83 f8 14             	cmp    $0x14,%eax
  8012ec:	74 14                	je     801302 <_main+0x203>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 54 5b 80 00       	push   $0x805b54
  8012f6:	6a 3e                	push   $0x3e
  8012f8:	68 60 59 80 00       	push   $0x805960
  8012fd:	e8 fc 02 00 00       	call   8015fe <_panic>

	sys_lock_cons();
  801302:	e8 80 2e 00 00       	call   804187 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  801307:	e8 2b 2f 00 00       	call   804237 <sys_calculate_free_frames>
  80130c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80130f:	e8 6e 2f 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
  801314:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = sget(parentenvID,"x");
  801317:	83 ec 08             	sub    $0x8,%esp
  80131a:	68 8b 5b 80 00       	push   $0x805b8b
  80131f:	ff 75 f0             	pushl  -0x10(%ebp)
  801322:	e8 f3 27 00 00       	call   803b1a <sget>
  801327:	83 c4 10             	add    $0x10,%esp
  80132a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 2 * PAGE_SIZE);
  80132d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801330:	05 00 20 00 00       	add    $0x2000,%eax
  801335:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  801338:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80133b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80133e:	74 1a                	je     80135a <_main+0x25b>
  801340:	83 ec 0c             	sub    $0xc,%esp
  801343:	ff 75 d0             	pushl  -0x30(%ebp)
  801346:	ff 75 e0             	pushl  -0x20(%ebp)
  801349:	68 80 59 80 00       	push   $0x805980
  80134e:	6a 46                	push   $0x46
  801350:	68 60 59 80 00       	push   $0x805960
  801355:	e8 a4 02 00 00       	call   8015fe <_panic>
		expected = 0 ;
  80135a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  801361:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  801364:	e8 ce 2e 00 00       	call   804237 <sys_calculate_free_frames>
  801369:	29 c3                	sub    %eax,%ebx
  80136b:	89 d8                	mov    %ebx,%eax
  80136d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  801370:	83 ec 04             	sub    $0x4,%esp
  801373:	ff 75 dc             	pushl  -0x24(%ebp)
  801376:	ff 75 dc             	pushl  -0x24(%ebp)
  801379:	ff 75 d8             	pushl  -0x28(%ebp)
  80137c:	e8 b7 ec ff ff       	call   800038 <inRange>
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	75 24                	jne    8013ac <_main+0x2ad>
			panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  801388:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80138b:	e8 a7 2e 00 00       	call   804237 <sys_calculate_free_frames>
  801390:	29 c3                	sub    %eax,%ebx
  801392:	89 d8                	mov    %ebx,%eax
  801394:	83 ec 0c             	sub    $0xc,%esp
  801397:	ff 75 dc             	pushl  -0x24(%ebp)
  80139a:	50                   	push   %eax
  80139b:	68 bc 5a 80 00       	push   $0x805abc
  8013a0:	6a 4a                	push   $0x4a
  8013a2:	68 60 59 80 00       	push   $0x805960
  8013a7:	e8 52 02 00 00       	call   8015fe <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8013ac:	e8 d1 2e 00 00       	call   804282 <sys_pf_calculate_allocated_pages>
  8013b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8013b4:	74 14                	je     8013ca <_main+0x2cb>
		{panic("Wrong page file allocation: ");}
  8013b6:	83 ec 04             	sub    $0x4,%esp
  8013b9:	68 9a 5a 80 00       	push   $0x805a9a
  8013be:	6a 4c                	push   $0x4c
  8013c0:	68 60 59 80 00       	push   $0x805960
  8013c5:	e8 34 02 00 00       	call   8015fe <_panic>
	}
	sys_unlock_cons();
  8013ca:	e8 d2 2d 00 00       	call   8041a1 <sys_unlock_cons>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8013cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 f8 0a             	cmp    $0xa,%eax
  8013d7:	74 14                	je     8013ed <_main+0x2ee>
  8013d9:	83 ec 04             	sub    $0x4,%esp
  8013dc:	68 54 5b 80 00       	push   $0x805b54
  8013e1:	6a 50                	push   $0x50
  8013e3:	68 60 59 80 00       	push   $0x805960
  8013e8:	e8 11 02 00 00       	call   8015fe <_panic>

	*z = *x + *y ;
  8013ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013f0:	8b 10                	mov    (%eax),%edx
  8013f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013f5:	8b 00                	mov    (%eax),%eax
  8013f7:	01 c2                	add    %eax,%edx
  8013f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013fc:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  8013fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801401:	8b 00                	mov    (%eax),%eax
  801403:	83 f8 1e             	cmp    $0x1e,%eax
  801406:	74 14                	je     80141c <_main+0x31d>
  801408:	83 ec 04             	sub    $0x4,%esp
  80140b:	68 54 5b 80 00       	push   $0x805b54
  801410:	6a 53                	push   $0x53
  801412:	68 60 59 80 00       	push   $0x805960
  801417:	e8 e2 01 00 00       	call   8015fe <_panic>

	//To indicate that it's completed successfully
	inctst();
  80141c:	e8 1d 31 00 00       	call   80453e <inctst>

	cprintf_colored(TEXT_green, "Slave1 completed.\n");
  801421:	83 ec 08             	sub    $0x8,%esp
  801424:	68 8d 5b 80 00       	push   $0x805b8d
  801429:	6a 02                	push   $0x2
  80142b:	e8 c9 04 00 00       	call   8018f9 <cprintf_colored>
  801430:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  801433:	c7 05 00 70 80 00 00 	movl   $0x0,0x807000
  80143a:	00 00 00 
	return;
  80143d:	90                   	nop
}
  80143e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801441:	5b                   	pop    %ebx
  801442:	5e                   	pop    %esi
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	57                   	push   %edi
  801449:	56                   	push   %esi
  80144a:	53                   	push   %ebx
  80144b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80144e:	e8 ad 2f 00 00       	call   804400 <sys_getenvindex>
  801453:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801456:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801459:	89 d0                	mov    %edx,%eax
  80145b:	c1 e0 02             	shl    $0x2,%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801467:	01 d0                	add    %edx,%eax
  801469:	89 c2                	mov    %eax,%edx
  80146b:	c1 e2 04             	shl    $0x4,%edx
  80146e:	29 c2                	sub    %eax,%edx
  801470:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  801477:	89 c2                	mov    %eax,%edx
  801479:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80147f:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801484:	a1 00 72 80 00       	mov    0x807200,%eax
  801489:	8a 40 20             	mov    0x20(%eax),%al
  80148c:	84 c0                	test   %al,%al
  80148e:	74 0d                	je     80149d <libmain+0x58>
		binaryname = myEnv->prog_name;
  801490:	a1 00 72 80 00       	mov    0x807200,%eax
  801495:	83 c0 20             	add    $0x20,%eax
  801498:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80149d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a1:	7e 0a                	jle    8014ad <libmain+0x68>
		binaryname = argv[0];
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	8b 00                	mov    (%eax),%eax
  8014a8:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  8014ad:	83 ec 08             	sub    $0x8,%esp
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 44 fc ff ff       	call   8010ff <_main>
  8014bb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8014be:	a1 00 70 80 00       	mov    0x807000,%eax
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	0f 84 01 01 00 00    	je     8015cc <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8014cb:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8014d1:	bb 98 5c 80 00       	mov    $0x805c98,%ebx
  8014d6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8014db:	89 c7                	mov    %eax,%edi
  8014dd:	89 de                	mov    %ebx,%esi
  8014df:	89 d1                	mov    %edx,%ecx
  8014e1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8014e3:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8014e6:	b9 56 00 00 00       	mov    $0x56,%ecx
  8014eb:	b0 00                	mov    $0x0,%al
  8014ed:	89 d7                	mov    %edx,%edi
  8014ef:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8014f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8014f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014fb:	83 ec 08             	sub    $0x8,%esp
  8014fe:	50                   	push   %eax
  8014ff:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801505:	50                   	push   %eax
  801506:	e8 2b 31 00 00       	call   804636 <sys_utilities>
  80150b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80150e:	e8 74 2c 00 00       	call   804187 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	68 b8 5b 80 00       	push   $0x805bb8
  80151b:	e8 ac 03 00 00       	call   8018cc <cprintf>
  801520:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801523:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801526:	85 c0                	test   %eax,%eax
  801528:	74 18                	je     801542 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80152a:	e8 25 31 00 00       	call   804654 <sys_get_optimal_num_faults>
  80152f:	83 ec 08             	sub    $0x8,%esp
  801532:	50                   	push   %eax
  801533:	68 e0 5b 80 00       	push   $0x805be0
  801538:	e8 8f 03 00 00       	call   8018cc <cprintf>
  80153d:	83 c4 10             	add    $0x10,%esp
  801540:	eb 59                	jmp    80159b <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801542:	a1 00 72 80 00       	mov    0x807200,%eax
  801547:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80154d:	a1 00 72 80 00       	mov    0x807200,%eax
  801552:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	52                   	push   %edx
  80155c:	50                   	push   %eax
  80155d:	68 04 5c 80 00       	push   $0x805c04
  801562:	e8 65 03 00 00       	call   8018cc <cprintf>
  801567:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80156a:	a1 00 72 80 00       	mov    0x807200,%eax
  80156f:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  801575:	a1 00 72 80 00       	mov    0x807200,%eax
  80157a:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  801580:	a1 00 72 80 00       	mov    0x807200,%eax
  801585:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80158b:	51                   	push   %ecx
  80158c:	52                   	push   %edx
  80158d:	50                   	push   %eax
  80158e:	68 2c 5c 80 00       	push   $0x805c2c
  801593:	e8 34 03 00 00       	call   8018cc <cprintf>
  801598:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80159b:	a1 00 72 80 00       	mov    0x807200,%eax
  8015a0:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	50                   	push   %eax
  8015aa:	68 84 5c 80 00       	push   $0x805c84
  8015af:	e8 18 03 00 00       	call   8018cc <cprintf>
  8015b4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8015b7:	83 ec 0c             	sub    $0xc,%esp
  8015ba:	68 b8 5b 80 00       	push   $0x805bb8
  8015bf:	e8 08 03 00 00       	call   8018cc <cprintf>
  8015c4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8015c7:	e8 d5 2b 00 00       	call   8041a1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8015cc:	e8 1f 00 00 00       	call   8015f0 <exit>
}
  8015d1:	90                   	nop
  8015d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d5:	5b                   	pop    %ebx
  8015d6:	5e                   	pop    %esi
  8015d7:	5f                   	pop    %edi
  8015d8:	5d                   	pop    %ebp
  8015d9:	c3                   	ret    

008015da <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8015e0:	83 ec 0c             	sub    $0xc,%esp
  8015e3:	6a 00                	push   $0x0
  8015e5:	e8 e2 2d 00 00       	call   8043cc <sys_destroy_env>
  8015ea:	83 c4 10             	add    $0x10,%esp
}
  8015ed:	90                   	nop
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <exit>:

void
exit(void)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8015f6:	e8 37 2e 00 00       	call   804432 <sys_exit_env>
}
  8015fb:	90                   	nop
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801604:	8d 45 10             	lea    0x10(%ebp),%eax
  801607:	83 c0 04             	add    $0x4,%eax
  80160a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80160d:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  801612:	85 c0                	test   %eax,%eax
  801614:	74 16                	je     80162c <_panic+0x2e>
		cprintf("%s: ", argv0);
  801616:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	50                   	push   %eax
  80161f:	68 fc 5c 80 00       	push   $0x805cfc
  801624:	e8 a3 02 00 00       	call   8018cc <cprintf>
  801629:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80162c:	a1 04 70 80 00       	mov    0x807004,%eax
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	ff 75 0c             	pushl  0xc(%ebp)
  801637:	ff 75 08             	pushl  0x8(%ebp)
  80163a:	50                   	push   %eax
  80163b:	68 04 5d 80 00       	push   $0x805d04
  801640:	6a 74                	push   $0x74
  801642:	e8 b2 02 00 00       	call   8018f9 <cprintf_colored>
  801647:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80164a:	8b 45 10             	mov    0x10(%ebp),%eax
  80164d:	83 ec 08             	sub    $0x8,%esp
  801650:	ff 75 f4             	pushl  -0xc(%ebp)
  801653:	50                   	push   %eax
  801654:	e8 04 02 00 00       	call   80185d <vcprintf>
  801659:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80165c:	83 ec 08             	sub    $0x8,%esp
  80165f:	6a 00                	push   $0x0
  801661:	68 2c 5d 80 00       	push   $0x805d2c
  801666:	e8 f2 01 00 00       	call   80185d <vcprintf>
  80166b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80166e:	e8 7d ff ff ff       	call   8015f0 <exit>

	// should not return here
	while (1) ;
  801673:	eb fe                	jmp    801673 <_panic+0x75>

00801675 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80167b:	a1 00 72 80 00       	mov    0x807200,%eax
  801680:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801686:	8b 45 0c             	mov    0xc(%ebp),%eax
  801689:	39 c2                	cmp    %eax,%edx
  80168b:	74 14                	je     8016a1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	68 30 5d 80 00       	push   $0x805d30
  801695:	6a 26                	push   $0x26
  801697:	68 7c 5d 80 00       	push   $0x805d7c
  80169c:	e8 5d ff ff ff       	call   8015fe <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8016a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8016a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016af:	e9 c5 00 00 00       	jmp    801779 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8016b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	01 d0                	add    %edx,%eax
  8016c3:	8b 00                	mov    (%eax),%eax
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	75 08                	jne    8016d1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8016c9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8016cc:	e9 a5 00 00 00       	jmp    801776 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8016d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8016df:	eb 69                	jmp    80174a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8016e1:	a1 00 72 80 00       	mov    0x807200,%eax
  8016e6:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8016ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016ef:	89 d0                	mov    %edx,%eax
  8016f1:	01 c0                	add    %eax,%eax
  8016f3:	01 d0                	add    %edx,%eax
  8016f5:	c1 e0 03             	shl    $0x3,%eax
  8016f8:	01 c8                	add    %ecx,%eax
  8016fa:	8a 40 04             	mov    0x4(%eax),%al
  8016fd:	84 c0                	test   %al,%al
  8016ff:	75 46                	jne    801747 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801701:	a1 00 72 80 00       	mov    0x807200,%eax
  801706:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80170c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80170f:	89 d0                	mov    %edx,%eax
  801711:	01 c0                	add    %eax,%eax
  801713:	01 d0                	add    %edx,%eax
  801715:	c1 e0 03             	shl    $0x3,%eax
  801718:	01 c8                	add    %ecx,%eax
  80171a:	8b 00                	mov    (%eax),%eax
  80171c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80171f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801722:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801727:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	01 c8                	add    %ecx,%eax
  801738:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80173a:	39 c2                	cmp    %eax,%edx
  80173c:	75 09                	jne    801747 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80173e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801745:	eb 15                	jmp    80175c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801747:	ff 45 e8             	incl   -0x18(%ebp)
  80174a:	a1 00 72 80 00       	mov    0x807200,%eax
  80174f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801758:	39 c2                	cmp    %eax,%edx
  80175a:	77 85                	ja     8016e1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80175c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801760:	75 14                	jne    801776 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	68 88 5d 80 00       	push   $0x805d88
  80176a:	6a 3a                	push   $0x3a
  80176c:	68 7c 5d 80 00       	push   $0x805d7c
  801771:	e8 88 fe ff ff       	call   8015fe <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801776:	ff 45 f0             	incl   -0x10(%ebp)
  801779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80177f:	0f 8c 2f ff ff ff    	jl     8016b4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801785:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80178c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801793:	eb 26                	jmp    8017bb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801795:	a1 00 72 80 00       	mov    0x807200,%eax
  80179a:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8017a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017a3:	89 d0                	mov    %edx,%eax
  8017a5:	01 c0                	add    %eax,%eax
  8017a7:	01 d0                	add    %edx,%eax
  8017a9:	c1 e0 03             	shl    $0x3,%eax
  8017ac:	01 c8                	add    %ecx,%eax
  8017ae:	8a 40 04             	mov    0x4(%eax),%al
  8017b1:	3c 01                	cmp    $0x1,%al
  8017b3:	75 03                	jne    8017b8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8017b5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017b8:	ff 45 e0             	incl   -0x20(%ebp)
  8017bb:	a1 00 72 80 00       	mov    0x807200,%eax
  8017c0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017c9:	39 c2                	cmp    %eax,%edx
  8017cb:	77 c8                	ja     801795 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8017cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017d3:	74 14                	je     8017e9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	68 dc 5d 80 00       	push   $0x805ddc
  8017dd:	6a 44                	push   $0x44
  8017df:	68 7c 5d 80 00       	push   $0x805d7c
  8017e4:	e8 15 fe ff ff       	call   8015fe <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8017e9:	90                   	nop
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	53                   	push   %ebx
  8017f0:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8017f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f6:	8b 00                	mov    (%eax),%eax
  8017f8:	8d 48 01             	lea    0x1(%eax),%ecx
  8017fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fe:	89 0a                	mov    %ecx,(%edx)
  801800:	8b 55 08             	mov    0x8(%ebp),%edx
  801803:	88 d1                	mov    %dl,%cl
  801805:	8b 55 0c             	mov    0xc(%ebp),%edx
  801808:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80180c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180f:	8b 00                	mov    (%eax),%eax
  801811:	3d ff 00 00 00       	cmp    $0xff,%eax
  801816:	75 30                	jne    801848 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801818:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  80181e:	a0 24 72 80 00       	mov    0x807224,%al
  801823:	0f b6 c0             	movzbl %al,%eax
  801826:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801829:	8b 09                	mov    (%ecx),%ecx
  80182b:	89 cb                	mov    %ecx,%ebx
  80182d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801830:	83 c1 08             	add    $0x8,%ecx
  801833:	52                   	push   %edx
  801834:	50                   	push   %eax
  801835:	53                   	push   %ebx
  801836:	51                   	push   %ecx
  801837:	e8 07 29 00 00       	call   804143 <sys_cputs>
  80183c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80183f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801842:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184b:	8b 40 04             	mov    0x4(%eax),%eax
  80184e:	8d 50 01             	lea    0x1(%eax),%edx
  801851:	8b 45 0c             	mov    0xc(%ebp),%eax
  801854:	89 50 04             	mov    %edx,0x4(%eax)
}
  801857:	90                   	nop
  801858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801866:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80186d:	00 00 00 
	b.cnt = 0;
  801870:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801877:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	ff 75 08             	pushl  0x8(%ebp)
  801880:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801886:	50                   	push   %eax
  801887:	68 ec 17 80 00       	push   $0x8017ec
  80188c:	e8 5a 02 00 00       	call   801aeb <vprintfmt>
  801891:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801894:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  80189a:	a0 24 72 80 00       	mov    0x807224,%al
  80189f:	0f b6 c0             	movzbl %al,%eax
  8018a2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8018a8:	52                   	push   %edx
  8018a9:	50                   	push   %eax
  8018aa:	51                   	push   %ecx
  8018ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8018b1:	83 c0 08             	add    $0x8,%eax
  8018b4:	50                   	push   %eax
  8018b5:	e8 89 28 00 00       	call   804143 <sys_cputs>
  8018ba:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8018bd:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  8018c4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018d2:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  8018d9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	83 ec 08             	sub    $0x8,%esp
  8018e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e8:	50                   	push   %eax
  8018e9:	e8 6f ff ff ff       	call   80185d <vcprintf>
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8018f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018ff:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	c1 e0 08             	shl    $0x8,%eax
  80190c:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  801911:	8d 45 0c             	lea    0xc(%ebp),%eax
  801914:	83 c0 04             	add    $0x4,%eax
  801917:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80191a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191d:	83 ec 08             	sub    $0x8,%esp
  801920:	ff 75 f4             	pushl  -0xc(%ebp)
  801923:	50                   	push   %eax
  801924:	e8 34 ff ff ff       	call   80185d <vcprintf>
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80192f:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  801936:	07 00 00 

	return cnt;
  801939:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801944:	e8 3e 28 00 00       	call   804187 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801949:	8d 45 0c             	lea    0xc(%ebp),%eax
  80194c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	83 ec 08             	sub    $0x8,%esp
  801955:	ff 75 f4             	pushl  -0xc(%ebp)
  801958:	50                   	push   %eax
  801959:	e8 ff fe ff ff       	call   80185d <vcprintf>
  80195e:	83 c4 10             	add    $0x10,%esp
  801961:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801964:	e8 38 28 00 00       	call   8041a1 <sys_unlock_cons>
	return cnt;
  801969:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	53                   	push   %ebx
  801972:	83 ec 14             	sub    $0x14,%esp
  801975:	8b 45 10             	mov    0x10(%ebp),%eax
  801978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80197b:	8b 45 14             	mov    0x14(%ebp),%eax
  80197e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801981:	8b 45 18             	mov    0x18(%ebp),%eax
  801984:	ba 00 00 00 00       	mov    $0x0,%edx
  801989:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80198c:	77 55                	ja     8019e3 <printnum+0x75>
  80198e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801991:	72 05                	jb     801998 <printnum+0x2a>
  801993:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801996:	77 4b                	ja     8019e3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801998:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80199b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80199e:	8b 45 18             	mov    0x18(%ebp),%eax
  8019a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a6:	52                   	push   %edx
  8019a7:	50                   	push   %eax
  8019a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8019ae:	e8 81 38 00 00       	call   805234 <__udivdi3>
  8019b3:	83 c4 10             	add    $0x10,%esp
  8019b6:	83 ec 04             	sub    $0x4,%esp
  8019b9:	ff 75 20             	pushl  0x20(%ebp)
  8019bc:	53                   	push   %ebx
  8019bd:	ff 75 18             	pushl  0x18(%ebp)
  8019c0:	52                   	push   %edx
  8019c1:	50                   	push   %eax
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	ff 75 08             	pushl  0x8(%ebp)
  8019c8:	e8 a1 ff ff ff       	call   80196e <printnum>
  8019cd:	83 c4 20             	add    $0x20,%esp
  8019d0:	eb 1a                	jmp    8019ec <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8019d2:	83 ec 08             	sub    $0x8,%esp
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	ff 75 20             	pushl  0x20(%ebp)
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	ff d0                	call   *%eax
  8019e0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8019e3:	ff 4d 1c             	decl   0x1c(%ebp)
  8019e6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8019ea:	7f e6                	jg     8019d2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8019ec:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8019ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fa:	53                   	push   %ebx
  8019fb:	51                   	push   %ecx
  8019fc:	52                   	push   %edx
  8019fd:	50                   	push   %eax
  8019fe:	e8 41 39 00 00       	call   805344 <__umoddi3>
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	05 54 60 80 00       	add    $0x806054,%eax
  801a0b:	8a 00                	mov    (%eax),%al
  801a0d:	0f be c0             	movsbl %al,%eax
  801a10:	83 ec 08             	sub    $0x8,%esp
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	50                   	push   %eax
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	ff d0                	call   *%eax
  801a1c:	83 c4 10             	add    $0x10,%esp
}
  801a1f:	90                   	nop
  801a20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a28:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a2c:	7e 1c                	jle    801a4a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	8b 00                	mov    (%eax),%eax
  801a33:	8d 50 08             	lea    0x8(%eax),%edx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	89 10                	mov    %edx,(%eax)
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	8b 00                	mov    (%eax),%eax
  801a40:	83 e8 08             	sub    $0x8,%eax
  801a43:	8b 50 04             	mov    0x4(%eax),%edx
  801a46:	8b 00                	mov    (%eax),%eax
  801a48:	eb 40                	jmp    801a8a <getuint+0x65>
	else if (lflag)
  801a4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a4e:	74 1e                	je     801a6e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8b 00                	mov    (%eax),%eax
  801a55:	8d 50 04             	lea    0x4(%eax),%edx
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	89 10                	mov    %edx,(%eax)
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	8b 00                	mov    (%eax),%eax
  801a62:	83 e8 04             	sub    $0x4,%eax
  801a65:	8b 00                	mov    (%eax),%eax
  801a67:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6c:	eb 1c                	jmp    801a8a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8b 00                	mov    (%eax),%eax
  801a73:	8d 50 04             	lea    0x4(%eax),%edx
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	89 10                	mov    %edx,(%eax)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8b 00                	mov    (%eax),%eax
  801a80:	83 e8 04             	sub    $0x4,%eax
  801a83:	8b 00                	mov    (%eax),%eax
  801a85:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a8a:	5d                   	pop    %ebp
  801a8b:	c3                   	ret    

00801a8c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a8f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a93:	7e 1c                	jle    801ab1 <getint+0x25>
		return va_arg(*ap, long long);
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	8b 00                	mov    (%eax),%eax
  801a9a:	8d 50 08             	lea    0x8(%eax),%edx
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	89 10                	mov    %edx,(%eax)
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	83 e8 08             	sub    $0x8,%eax
  801aaa:	8b 50 04             	mov    0x4(%eax),%edx
  801aad:	8b 00                	mov    (%eax),%eax
  801aaf:	eb 38                	jmp    801ae9 <getint+0x5d>
	else if (lflag)
  801ab1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ab5:	74 1a                	je     801ad1 <getint+0x45>
		return va_arg(*ap, long);
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	8b 00                	mov    (%eax),%eax
  801abc:	8d 50 04             	lea    0x4(%eax),%edx
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	89 10                	mov    %edx,(%eax)
  801ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac7:	8b 00                	mov    (%eax),%eax
  801ac9:	83 e8 04             	sub    $0x4,%eax
  801acc:	8b 00                	mov    (%eax),%eax
  801ace:	99                   	cltd   
  801acf:	eb 18                	jmp    801ae9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	8b 00                	mov    (%eax),%eax
  801ad6:	8d 50 04             	lea    0x4(%eax),%edx
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	89 10                	mov    %edx,(%eax)
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	8b 00                	mov    (%eax),%eax
  801ae3:	83 e8 04             	sub    $0x4,%eax
  801ae6:	8b 00                	mov    (%eax),%eax
  801ae8:	99                   	cltd   
}
  801ae9:	5d                   	pop    %ebp
  801aea:	c3                   	ret    

00801aeb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801af3:	eb 17                	jmp    801b0c <vprintfmt+0x21>
			if (ch == '\0')
  801af5:	85 db                	test   %ebx,%ebx
  801af7:	0f 84 c1 03 00 00    	je     801ebe <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801afd:	83 ec 08             	sub    $0x8,%esp
  801b00:	ff 75 0c             	pushl  0xc(%ebp)
  801b03:	53                   	push   %ebx
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	ff d0                	call   *%eax
  801b09:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0f:	8d 50 01             	lea    0x1(%eax),%edx
  801b12:	89 55 10             	mov    %edx,0x10(%ebp)
  801b15:	8a 00                	mov    (%eax),%al
  801b17:	0f b6 d8             	movzbl %al,%ebx
  801b1a:	83 fb 25             	cmp    $0x25,%ebx
  801b1d:	75 d6                	jne    801af5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801b1f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801b23:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801b2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801b31:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801b38:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b42:	8d 50 01             	lea    0x1(%eax),%edx
  801b45:	89 55 10             	mov    %edx,0x10(%ebp)
  801b48:	8a 00                	mov    (%eax),%al
  801b4a:	0f b6 d8             	movzbl %al,%ebx
  801b4d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801b50:	83 f8 5b             	cmp    $0x5b,%eax
  801b53:	0f 87 3d 03 00 00    	ja     801e96 <vprintfmt+0x3ab>
  801b59:	8b 04 85 78 60 80 00 	mov    0x806078(,%eax,4),%eax
  801b60:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801b62:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801b66:	eb d7                	jmp    801b3f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b68:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801b6c:	eb d1                	jmp    801b3f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b6e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801b75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b78:	89 d0                	mov    %edx,%eax
  801b7a:	c1 e0 02             	shl    $0x2,%eax
  801b7d:	01 d0                	add    %edx,%eax
  801b7f:	01 c0                	add    %eax,%eax
  801b81:	01 d8                	add    %ebx,%eax
  801b83:	83 e8 30             	sub    $0x30,%eax
  801b86:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801b89:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8c:	8a 00                	mov    (%eax),%al
  801b8e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801b91:	83 fb 2f             	cmp    $0x2f,%ebx
  801b94:	7e 3e                	jle    801bd4 <vprintfmt+0xe9>
  801b96:	83 fb 39             	cmp    $0x39,%ebx
  801b99:	7f 39                	jg     801bd4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b9b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b9e:	eb d5                	jmp    801b75 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba3:	83 c0 04             	add    $0x4,%eax
  801ba6:	89 45 14             	mov    %eax,0x14(%ebp)
  801ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bac:	83 e8 04             	sub    $0x4,%eax
  801baf:	8b 00                	mov    (%eax),%eax
  801bb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801bb4:	eb 1f                	jmp    801bd5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801bb6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bba:	79 83                	jns    801b3f <vprintfmt+0x54>
				width = 0;
  801bbc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801bc3:	e9 77 ff ff ff       	jmp    801b3f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801bc8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801bcf:	e9 6b ff ff ff       	jmp    801b3f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801bd4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801bd5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bd9:	0f 89 60 ff ff ff    	jns    801b3f <vprintfmt+0x54>
				width = precision, precision = -1;
  801bdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801be2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801be5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801bec:	e9 4e ff ff ff       	jmp    801b3f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801bf1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801bf4:	e9 46 ff ff ff       	jmp    801b3f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801bf9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfc:	83 c0 04             	add    $0x4,%eax
  801bff:	89 45 14             	mov    %eax,0x14(%ebp)
  801c02:	8b 45 14             	mov    0x14(%ebp),%eax
  801c05:	83 e8 04             	sub    $0x4,%eax
  801c08:	8b 00                	mov    (%eax),%eax
  801c0a:	83 ec 08             	sub    $0x8,%esp
  801c0d:	ff 75 0c             	pushl  0xc(%ebp)
  801c10:	50                   	push   %eax
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	ff d0                	call   *%eax
  801c16:	83 c4 10             	add    $0x10,%esp
			break;
  801c19:	e9 9b 02 00 00       	jmp    801eb9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801c1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c21:	83 c0 04             	add    $0x4,%eax
  801c24:	89 45 14             	mov    %eax,0x14(%ebp)
  801c27:	8b 45 14             	mov    0x14(%ebp),%eax
  801c2a:	83 e8 04             	sub    $0x4,%eax
  801c2d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801c2f:	85 db                	test   %ebx,%ebx
  801c31:	79 02                	jns    801c35 <vprintfmt+0x14a>
				err = -err;
  801c33:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801c35:	83 fb 64             	cmp    $0x64,%ebx
  801c38:	7f 0b                	jg     801c45 <vprintfmt+0x15a>
  801c3a:	8b 34 9d c0 5e 80 00 	mov    0x805ec0(,%ebx,4),%esi
  801c41:	85 f6                	test   %esi,%esi
  801c43:	75 19                	jne    801c5e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801c45:	53                   	push   %ebx
  801c46:	68 65 60 80 00       	push   $0x806065
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	ff 75 08             	pushl  0x8(%ebp)
  801c51:	e8 70 02 00 00       	call   801ec6 <printfmt>
  801c56:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801c59:	e9 5b 02 00 00       	jmp    801eb9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801c5e:	56                   	push   %esi
  801c5f:	68 6e 60 80 00       	push   $0x80606e
  801c64:	ff 75 0c             	pushl  0xc(%ebp)
  801c67:	ff 75 08             	pushl  0x8(%ebp)
  801c6a:	e8 57 02 00 00       	call   801ec6 <printfmt>
  801c6f:	83 c4 10             	add    $0x10,%esp
			break;
  801c72:	e9 42 02 00 00       	jmp    801eb9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c77:	8b 45 14             	mov    0x14(%ebp),%eax
  801c7a:	83 c0 04             	add    $0x4,%eax
  801c7d:	89 45 14             	mov    %eax,0x14(%ebp)
  801c80:	8b 45 14             	mov    0x14(%ebp),%eax
  801c83:	83 e8 04             	sub    $0x4,%eax
  801c86:	8b 30                	mov    (%eax),%esi
  801c88:	85 f6                	test   %esi,%esi
  801c8a:	75 05                	jne    801c91 <vprintfmt+0x1a6>
				p = "(null)";
  801c8c:	be 71 60 80 00       	mov    $0x806071,%esi
			if (width > 0 && padc != '-')
  801c91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c95:	7e 6d                	jle    801d04 <vprintfmt+0x219>
  801c97:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c9b:	74 67                	je     801d04 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca0:	83 ec 08             	sub    $0x8,%esp
  801ca3:	50                   	push   %eax
  801ca4:	56                   	push   %esi
  801ca5:	e8 1e 03 00 00       	call   801fc8 <strnlen>
  801caa:	83 c4 10             	add    $0x10,%esp
  801cad:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801cb0:	eb 16                	jmp    801cc8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801cb2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801cb6:	83 ec 08             	sub    $0x8,%esp
  801cb9:	ff 75 0c             	pushl  0xc(%ebp)
  801cbc:	50                   	push   %eax
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	ff d0                	call   *%eax
  801cc2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801cc5:	ff 4d e4             	decl   -0x1c(%ebp)
  801cc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ccc:	7f e4                	jg     801cb2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801cce:	eb 34                	jmp    801d04 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801cd0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801cd4:	74 1c                	je     801cf2 <vprintfmt+0x207>
  801cd6:	83 fb 1f             	cmp    $0x1f,%ebx
  801cd9:	7e 05                	jle    801ce0 <vprintfmt+0x1f5>
  801cdb:	83 fb 7e             	cmp    $0x7e,%ebx
  801cde:	7e 12                	jle    801cf2 <vprintfmt+0x207>
					putch('?', putdat);
  801ce0:	83 ec 08             	sub    $0x8,%esp
  801ce3:	ff 75 0c             	pushl  0xc(%ebp)
  801ce6:	6a 3f                	push   $0x3f
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	ff d0                	call   *%eax
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	eb 0f                	jmp    801d01 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801cf2:	83 ec 08             	sub    $0x8,%esp
  801cf5:	ff 75 0c             	pushl  0xc(%ebp)
  801cf8:	53                   	push   %ebx
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	ff d0                	call   *%eax
  801cfe:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801d01:	ff 4d e4             	decl   -0x1c(%ebp)
  801d04:	89 f0                	mov    %esi,%eax
  801d06:	8d 70 01             	lea    0x1(%eax),%esi
  801d09:	8a 00                	mov    (%eax),%al
  801d0b:	0f be d8             	movsbl %al,%ebx
  801d0e:	85 db                	test   %ebx,%ebx
  801d10:	74 24                	je     801d36 <vprintfmt+0x24b>
  801d12:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d16:	78 b8                	js     801cd0 <vprintfmt+0x1e5>
  801d18:	ff 4d e0             	decl   -0x20(%ebp)
  801d1b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d1f:	79 af                	jns    801cd0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d21:	eb 13                	jmp    801d36 <vprintfmt+0x24b>
				putch(' ', putdat);
  801d23:	83 ec 08             	sub    $0x8,%esp
  801d26:	ff 75 0c             	pushl  0xc(%ebp)
  801d29:	6a 20                	push   $0x20
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	ff d0                	call   *%eax
  801d30:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d33:	ff 4d e4             	decl   -0x1c(%ebp)
  801d36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d3a:	7f e7                	jg     801d23 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801d3c:	e9 78 01 00 00       	jmp    801eb9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d41:	83 ec 08             	sub    $0x8,%esp
  801d44:	ff 75 e8             	pushl  -0x18(%ebp)
  801d47:	8d 45 14             	lea    0x14(%ebp),%eax
  801d4a:	50                   	push   %eax
  801d4b:	e8 3c fd ff ff       	call   801a8c <getint>
  801d50:	83 c4 10             	add    $0x10,%esp
  801d53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d56:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5f:	85 d2                	test   %edx,%edx
  801d61:	79 23                	jns    801d86 <vprintfmt+0x29b>
				putch('-', putdat);
  801d63:	83 ec 08             	sub    $0x8,%esp
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	6a 2d                	push   $0x2d
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	ff d0                	call   *%eax
  801d70:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d79:	f7 d8                	neg    %eax
  801d7b:	83 d2 00             	adc    $0x0,%edx
  801d7e:	f7 da                	neg    %edx
  801d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d83:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801d86:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d8d:	e9 bc 00 00 00       	jmp    801e4e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d92:	83 ec 08             	sub    $0x8,%esp
  801d95:	ff 75 e8             	pushl  -0x18(%ebp)
  801d98:	8d 45 14             	lea    0x14(%ebp),%eax
  801d9b:	50                   	push   %eax
  801d9c:	e8 84 fc ff ff       	call   801a25 <getuint>
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801da7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801daa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801db1:	e9 98 00 00 00       	jmp    801e4e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801db6:	83 ec 08             	sub    $0x8,%esp
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	6a 58                	push   $0x58
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	ff d0                	call   *%eax
  801dc3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801dc6:	83 ec 08             	sub    $0x8,%esp
  801dc9:	ff 75 0c             	pushl  0xc(%ebp)
  801dcc:	6a 58                	push   $0x58
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	ff d0                	call   *%eax
  801dd3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801dd6:	83 ec 08             	sub    $0x8,%esp
  801dd9:	ff 75 0c             	pushl  0xc(%ebp)
  801ddc:	6a 58                	push   $0x58
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	ff d0                	call   *%eax
  801de3:	83 c4 10             	add    $0x10,%esp
			break;
  801de6:	e9 ce 00 00 00       	jmp    801eb9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801deb:	83 ec 08             	sub    $0x8,%esp
  801dee:	ff 75 0c             	pushl  0xc(%ebp)
  801df1:	6a 30                	push   $0x30
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	ff d0                	call   *%eax
  801df8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801dfb:	83 ec 08             	sub    $0x8,%esp
  801dfe:	ff 75 0c             	pushl  0xc(%ebp)
  801e01:	6a 78                	push   $0x78
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
  801e06:	ff d0                	call   *%eax
  801e08:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801e0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0e:	83 c0 04             	add    $0x4,%eax
  801e11:	89 45 14             	mov    %eax,0x14(%ebp)
  801e14:	8b 45 14             	mov    0x14(%ebp),%eax
  801e17:	83 e8 04             	sub    $0x4,%eax
  801e1a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801e26:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801e2d:	eb 1f                	jmp    801e4e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801e2f:	83 ec 08             	sub    $0x8,%esp
  801e32:	ff 75 e8             	pushl  -0x18(%ebp)
  801e35:	8d 45 14             	lea    0x14(%ebp),%eax
  801e38:	50                   	push   %eax
  801e39:	e8 e7 fb ff ff       	call   801a25 <getuint>
  801e3e:	83 c4 10             	add    $0x10,%esp
  801e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801e47:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e4e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e55:	83 ec 04             	sub    $0x4,%esp
  801e58:	52                   	push   %edx
  801e59:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e5c:	50                   	push   %eax
  801e5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e60:	ff 75 f0             	pushl  -0x10(%ebp)
  801e63:	ff 75 0c             	pushl  0xc(%ebp)
  801e66:	ff 75 08             	pushl  0x8(%ebp)
  801e69:	e8 00 fb ff ff       	call   80196e <printnum>
  801e6e:	83 c4 20             	add    $0x20,%esp
			break;
  801e71:	eb 46                	jmp    801eb9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e73:	83 ec 08             	sub    $0x8,%esp
  801e76:	ff 75 0c             	pushl  0xc(%ebp)
  801e79:	53                   	push   %ebx
  801e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7d:	ff d0                	call   *%eax
  801e7f:	83 c4 10             	add    $0x10,%esp
			break;
  801e82:	eb 35                	jmp    801eb9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801e84:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  801e8b:	eb 2c                	jmp    801eb9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801e8d:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  801e94:	eb 23                	jmp    801eb9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e96:	83 ec 08             	sub    $0x8,%esp
  801e99:	ff 75 0c             	pushl  0xc(%ebp)
  801e9c:	6a 25                	push   $0x25
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	ff d0                	call   *%eax
  801ea3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ea6:	ff 4d 10             	decl   0x10(%ebp)
  801ea9:	eb 03                	jmp    801eae <vprintfmt+0x3c3>
  801eab:	ff 4d 10             	decl   0x10(%ebp)
  801eae:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb1:	48                   	dec    %eax
  801eb2:	8a 00                	mov    (%eax),%al
  801eb4:	3c 25                	cmp    $0x25,%al
  801eb6:	75 f3                	jne    801eab <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801eb8:	90                   	nop
		}
	}
  801eb9:	e9 35 fc ff ff       	jmp    801af3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801ebe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801ebf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec2:	5b                   	pop    %ebx
  801ec3:	5e                   	pop    %esi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    

00801ec6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801ecc:	8d 45 10             	lea    0x10(%ebp),%eax
  801ecf:	83 c0 04             	add    $0x4,%eax
  801ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed8:	ff 75 f4             	pushl  -0xc(%ebp)
  801edb:	50                   	push   %eax
  801edc:	ff 75 0c             	pushl  0xc(%ebp)
  801edf:	ff 75 08             	pushl  0x8(%ebp)
  801ee2:	e8 04 fc ff ff       	call   801aeb <vprintfmt>
  801ee7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801eea:	90                   	nop
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef3:	8b 40 08             	mov    0x8(%eax),%eax
  801ef6:	8d 50 01             	lea    0x1(%eax),%edx
  801ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f02:	8b 10                	mov    (%eax),%edx
  801f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f07:	8b 40 04             	mov    0x4(%eax),%eax
  801f0a:	39 c2                	cmp    %eax,%edx
  801f0c:	73 12                	jae    801f20 <sprintputch+0x33>
		*b->buf++ = ch;
  801f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f11:	8b 00                	mov    (%eax),%eax
  801f13:	8d 48 01             	lea    0x1(%eax),%ecx
  801f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f19:	89 0a                	mov    %ecx,(%edx)
  801f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  801f1e:	88 10                	mov    %dl,(%eax)
}
  801f20:	90                   	nop
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    

00801f23 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f32:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	01 d0                	add    %edx,%eax
  801f3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f48:	74 06                	je     801f50 <vsnprintf+0x2d>
  801f4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f4e:	7f 07                	jg     801f57 <vsnprintf+0x34>
		return -E_INVAL;
  801f50:	b8 03 00 00 00       	mov    $0x3,%eax
  801f55:	eb 20                	jmp    801f77 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f57:	ff 75 14             	pushl  0x14(%ebp)
  801f5a:	ff 75 10             	pushl  0x10(%ebp)
  801f5d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f60:	50                   	push   %eax
  801f61:	68 ed 1e 80 00       	push   $0x801eed
  801f66:	e8 80 fb ff ff       	call   801aeb <vprintfmt>
  801f6b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f71:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f7f:	8d 45 10             	lea    0x10(%ebp),%eax
  801f82:	83 c0 04             	add    $0x4,%eax
  801f85:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801f88:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8e:	50                   	push   %eax
  801f8f:	ff 75 0c             	pushl  0xc(%ebp)
  801f92:	ff 75 08             	pushl  0x8(%ebp)
  801f95:	e8 89 ff ff ff       	call   801f23 <vsnprintf>
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801fab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fb2:	eb 06                	jmp    801fba <strlen+0x15>
		n++;
  801fb4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801fb7:	ff 45 08             	incl   0x8(%ebp)
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	8a 00                	mov    (%eax),%al
  801fbf:	84 c0                	test   %al,%al
  801fc1:	75 f1                	jne    801fb4 <strlen+0xf>
		n++;
	return n;
  801fc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fd5:	eb 09                	jmp    801fe0 <strnlen+0x18>
		n++;
  801fd7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fda:	ff 45 08             	incl   0x8(%ebp)
  801fdd:	ff 4d 0c             	decl   0xc(%ebp)
  801fe0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fe4:	74 09                	je     801fef <strnlen+0x27>
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	8a 00                	mov    (%eax),%al
  801feb:	84 c0                	test   %al,%al
  801fed:	75 e8                	jne    801fd7 <strnlen+0xf>
		n++;
	return n;
  801fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  802000:	90                   	nop
  802001:	8b 45 08             	mov    0x8(%ebp),%eax
  802004:	8d 50 01             	lea    0x1(%eax),%edx
  802007:	89 55 08             	mov    %edx,0x8(%ebp)
  80200a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200d:	8d 4a 01             	lea    0x1(%edx),%ecx
  802010:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802013:	8a 12                	mov    (%edx),%dl
  802015:	88 10                	mov    %dl,(%eax)
  802017:	8a 00                	mov    (%eax),%al
  802019:	84 c0                	test   %al,%al
  80201b:	75 e4                	jne    802001 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80201d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80202e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802035:	eb 1f                	jmp    802056 <strncpy+0x34>
		*dst++ = *src;
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	8d 50 01             	lea    0x1(%eax),%edx
  80203d:	89 55 08             	mov    %edx,0x8(%ebp)
  802040:	8b 55 0c             	mov    0xc(%ebp),%edx
  802043:	8a 12                	mov    (%edx),%dl
  802045:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204a:	8a 00                	mov    (%eax),%al
  80204c:	84 c0                	test   %al,%al
  80204e:	74 03                	je     802053 <strncpy+0x31>
			src++;
  802050:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802053:	ff 45 fc             	incl   -0x4(%ebp)
  802056:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802059:	3b 45 10             	cmp    0x10(%ebp),%eax
  80205c:	72 d9                	jb     802037 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80205e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80206f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802073:	74 30                	je     8020a5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802075:	eb 16                	jmp    80208d <strlcpy+0x2a>
			*dst++ = *src++;
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	8d 50 01             	lea    0x1(%eax),%edx
  80207d:	89 55 08             	mov    %edx,0x8(%ebp)
  802080:	8b 55 0c             	mov    0xc(%ebp),%edx
  802083:	8d 4a 01             	lea    0x1(%edx),%ecx
  802086:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802089:	8a 12                	mov    (%edx),%dl
  80208b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80208d:	ff 4d 10             	decl   0x10(%ebp)
  802090:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802094:	74 09                	je     80209f <strlcpy+0x3c>
  802096:	8b 45 0c             	mov    0xc(%ebp),%eax
  802099:	8a 00                	mov    (%eax),%al
  80209b:	84 c0                	test   %al,%al
  80209d:	75 d8                	jne    802077 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8020a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ab:	29 c2                	sub    %eax,%edx
  8020ad:	89 d0                	mov    %edx,%eax
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8020b4:	eb 06                	jmp    8020bc <strcmp+0xb>
		p++, q++;
  8020b6:	ff 45 08             	incl   0x8(%ebp)
  8020b9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	8a 00                	mov    (%eax),%al
  8020c1:	84 c0                	test   %al,%al
  8020c3:	74 0e                	je     8020d3 <strcmp+0x22>
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	8a 10                	mov    (%eax),%dl
  8020ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cd:	8a 00                	mov    (%eax),%al
  8020cf:	38 c2                	cmp    %al,%dl
  8020d1:	74 e3                	je     8020b6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	8a 00                	mov    (%eax),%al
  8020d8:	0f b6 d0             	movzbl %al,%edx
  8020db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020de:	8a 00                	mov    (%eax),%al
  8020e0:	0f b6 c0             	movzbl %al,%eax
  8020e3:	29 c2                	sub    %eax,%edx
  8020e5:	89 d0                	mov    %edx,%eax
}
  8020e7:	5d                   	pop    %ebp
  8020e8:	c3                   	ret    

008020e9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8020ec:	eb 09                	jmp    8020f7 <strncmp+0xe>
		n--, p++, q++;
  8020ee:	ff 4d 10             	decl   0x10(%ebp)
  8020f1:	ff 45 08             	incl   0x8(%ebp)
  8020f4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8020f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020fb:	74 17                	je     802114 <strncmp+0x2b>
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	8a 00                	mov    (%eax),%al
  802102:	84 c0                	test   %al,%al
  802104:	74 0e                	je     802114 <strncmp+0x2b>
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	8a 10                	mov    (%eax),%dl
  80210b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210e:	8a 00                	mov    (%eax),%al
  802110:	38 c2                	cmp    %al,%dl
  802112:	74 da                	je     8020ee <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802114:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802118:	75 07                	jne    802121 <strncmp+0x38>
		return 0;
  80211a:	b8 00 00 00 00       	mov    $0x0,%eax
  80211f:	eb 14                	jmp    802135 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	8a 00                	mov    (%eax),%al
  802126:	0f b6 d0             	movzbl %al,%edx
  802129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212c:	8a 00                	mov    (%eax),%al
  80212e:	0f b6 c0             	movzbl %al,%eax
  802131:	29 c2                	sub    %eax,%edx
  802133:	89 d0                	mov    %edx,%eax
}
  802135:	5d                   	pop    %ebp
  802136:	c3                   	ret    

00802137 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802140:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802143:	eb 12                	jmp    802157 <strchr+0x20>
		if (*s == c)
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	8a 00                	mov    (%eax),%al
  80214a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80214d:	75 05                	jne    802154 <strchr+0x1d>
			return (char *) s;
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	eb 11                	jmp    802165 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802154:	ff 45 08             	incl   0x8(%ebp)
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	8a 00                	mov    (%eax),%al
  80215c:	84 c0                	test   %al,%al
  80215e:	75 e5                	jne    802145 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802160:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 04             	sub    $0x4,%esp
  80216d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802170:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802173:	eb 0d                	jmp    802182 <strfind+0x1b>
		if (*s == c)
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	8a 00                	mov    (%eax),%al
  80217a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80217d:	74 0e                	je     80218d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80217f:	ff 45 08             	incl   0x8(%ebp)
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	8a 00                	mov    (%eax),%al
  802187:	84 c0                	test   %al,%al
  802189:	75 ea                	jne    802175 <strfind+0xe>
  80218b:	eb 01                	jmp    80218e <strfind+0x27>
		if (*s == c)
			break;
  80218d:	90                   	nop
	return (char *) s;
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
  802196:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80219f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021a3:	76 63                	jbe    802208 <memset+0x75>
		uint64 data_block = c;
  8021a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a8:	99                   	cltd   
  8021a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8021af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8021b9:	c1 e0 08             	shl    $0x8,%eax
  8021bc:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021bf:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8021c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8021cc:	c1 e0 10             	shl    $0x10,%eax
  8021cf:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021d2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8021d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021db:	89 c2                	mov    %eax,%edx
  8021dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021e5:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8021e8:	eb 18                	jmp    802202 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8021ea:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021ed:	8d 41 08             	lea    0x8(%ecx),%eax
  8021f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f9:	89 01                	mov    %eax,(%ecx)
  8021fb:	89 51 04             	mov    %edx,0x4(%ecx)
  8021fe:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802202:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802206:	77 e2                	ja     8021ea <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  802208:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80220c:	74 23                	je     802231 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80220e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802211:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  802214:	eb 0e                	jmp    802224 <memset+0x91>
			*p8++ = (uint8)c;
  802216:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802219:	8d 50 01             	lea    0x1(%eax),%edx
  80221c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80221f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802222:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  802224:	8b 45 10             	mov    0x10(%ebp),%eax
  802227:	8d 50 ff             	lea    -0x1(%eax),%edx
  80222a:	89 55 10             	mov    %edx,0x10(%ebp)
  80222d:	85 c0                	test   %eax,%eax
  80222f:	75 e5                	jne    802216 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80223c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  802248:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80224c:	76 24                	jbe    802272 <memcpy+0x3c>
		while(n >= 8){
  80224e:	eb 1c                	jmp    80226c <memcpy+0x36>
			*d64 = *s64;
  802250:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802253:	8b 50 04             	mov    0x4(%eax),%edx
  802256:	8b 00                	mov    (%eax),%eax
  802258:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80225b:	89 01                	mov    %eax,(%ecx)
  80225d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802260:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  802264:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  802268:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80226c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802270:	77 de                	ja     802250 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802272:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802276:	74 31                	je     8022a9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802278:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80227b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80227e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802281:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802284:	eb 16                	jmp    80229c <memcpy+0x66>
			*d8++ = *s8++;
  802286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802289:	8d 50 01             	lea    0x1(%eax),%edx
  80228c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80228f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802292:	8d 4a 01             	lea    0x1(%edx),%ecx
  802295:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802298:	8a 12                	mov    (%edx),%dl
  80229a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80229c:	8b 45 10             	mov    0x10(%ebp),%eax
  80229f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	75 dd                	jne    802286 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8022b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8022c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8022c6:	73 50                	jae    802318 <memmove+0x6a>
  8022c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ce:	01 d0                	add    %edx,%eax
  8022d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8022d3:	76 43                	jbe    802318 <memmove+0x6a>
		s += n;
  8022d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8022db:	8b 45 10             	mov    0x10(%ebp),%eax
  8022de:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8022e1:	eb 10                	jmp    8022f3 <memmove+0x45>
			*--d = *--s;
  8022e3:	ff 4d f8             	decl   -0x8(%ebp)
  8022e6:	ff 4d fc             	decl   -0x4(%ebp)
  8022e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ec:	8a 10                	mov    (%eax),%dl
  8022ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022f1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8022f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	75 e3                	jne    8022e3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802300:	eb 23                	jmp    802325 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802305:	8d 50 01             	lea    0x1(%eax),%edx
  802308:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80230b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80230e:	8d 4a 01             	lea    0x1(%edx),%ecx
  802311:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802314:	8a 12                	mov    (%edx),%dl
  802316:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802318:	8b 45 10             	mov    0x10(%ebp),%eax
  80231b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80231e:	89 55 10             	mov    %edx,0x10(%ebp)
  802321:	85 c0                	test   %eax,%eax
  802323:	75 dd                	jne    802302 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802336:	8b 45 0c             	mov    0xc(%ebp),%eax
  802339:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80233c:	eb 2a                	jmp    802368 <memcmp+0x3e>
		if (*s1 != *s2)
  80233e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802341:	8a 10                	mov    (%eax),%dl
  802343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802346:	8a 00                	mov    (%eax),%al
  802348:	38 c2                	cmp    %al,%dl
  80234a:	74 16                	je     802362 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80234c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80234f:	8a 00                	mov    (%eax),%al
  802351:	0f b6 d0             	movzbl %al,%edx
  802354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802357:	8a 00                	mov    (%eax),%al
  802359:	0f b6 c0             	movzbl %al,%eax
  80235c:	29 c2                	sub    %eax,%edx
  80235e:	89 d0                	mov    %edx,%eax
  802360:	eb 18                	jmp    80237a <memcmp+0x50>
		s1++, s2++;
  802362:	ff 45 fc             	incl   -0x4(%ebp)
  802365:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802368:	8b 45 10             	mov    0x10(%ebp),%eax
  80236b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80236e:	89 55 10             	mov    %edx,0x10(%ebp)
  802371:	85 c0                	test   %eax,%eax
  802373:	75 c9                	jne    80233e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802382:	8b 55 08             	mov    0x8(%ebp),%edx
  802385:	8b 45 10             	mov    0x10(%ebp),%eax
  802388:	01 d0                	add    %edx,%eax
  80238a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80238d:	eb 15                	jmp    8023a4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	8a 00                	mov    (%eax),%al
  802394:	0f b6 d0             	movzbl %al,%edx
  802397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239a:	0f b6 c0             	movzbl %al,%eax
  80239d:	39 c2                	cmp    %eax,%edx
  80239f:	74 0d                	je     8023ae <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8023a1:	ff 45 08             	incl   0x8(%ebp)
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8023aa:	72 e3                	jb     80238f <memfind+0x13>
  8023ac:	eb 01                	jmp    8023af <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8023ae:	90                   	nop
	return (void *) s;
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8023ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8023c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023c8:	eb 03                	jmp    8023cd <strtol+0x19>
		s++;
  8023ca:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8a 00                	mov    (%eax),%al
  8023d2:	3c 20                	cmp    $0x20,%al
  8023d4:	74 f4                	je     8023ca <strtol+0x16>
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	8a 00                	mov    (%eax),%al
  8023db:	3c 09                	cmp    $0x9,%al
  8023dd:	74 eb                	je     8023ca <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	8a 00                	mov    (%eax),%al
  8023e4:	3c 2b                	cmp    $0x2b,%al
  8023e6:	75 05                	jne    8023ed <strtol+0x39>
		s++;
  8023e8:	ff 45 08             	incl   0x8(%ebp)
  8023eb:	eb 13                	jmp    802400 <strtol+0x4c>
	else if (*s == '-')
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	8a 00                	mov    (%eax),%al
  8023f2:	3c 2d                	cmp    $0x2d,%al
  8023f4:	75 0a                	jne    802400 <strtol+0x4c>
		s++, neg = 1;
  8023f6:	ff 45 08             	incl   0x8(%ebp)
  8023f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802404:	74 06                	je     80240c <strtol+0x58>
  802406:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80240a:	75 20                	jne    80242c <strtol+0x78>
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	8a 00                	mov    (%eax),%al
  802411:	3c 30                	cmp    $0x30,%al
  802413:	75 17                	jne    80242c <strtol+0x78>
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	40                   	inc    %eax
  802419:	8a 00                	mov    (%eax),%al
  80241b:	3c 78                	cmp    $0x78,%al
  80241d:	75 0d                	jne    80242c <strtol+0x78>
		s += 2, base = 16;
  80241f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802423:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80242a:	eb 28                	jmp    802454 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80242c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802430:	75 15                	jne    802447 <strtol+0x93>
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	8a 00                	mov    (%eax),%al
  802437:	3c 30                	cmp    $0x30,%al
  802439:	75 0c                	jne    802447 <strtol+0x93>
		s++, base = 8;
  80243b:	ff 45 08             	incl   0x8(%ebp)
  80243e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802445:	eb 0d                	jmp    802454 <strtol+0xa0>
	else if (base == 0)
  802447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80244b:	75 07                	jne    802454 <strtol+0xa0>
		base = 10;
  80244d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	8a 00                	mov    (%eax),%al
  802459:	3c 2f                	cmp    $0x2f,%al
  80245b:	7e 19                	jle    802476 <strtol+0xc2>
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	8a 00                	mov    (%eax),%al
  802462:	3c 39                	cmp    $0x39,%al
  802464:	7f 10                	jg     802476 <strtol+0xc2>
			dig = *s - '0';
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	8a 00                	mov    (%eax),%al
  80246b:	0f be c0             	movsbl %al,%eax
  80246e:	83 e8 30             	sub    $0x30,%eax
  802471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802474:	eb 42                	jmp    8024b8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	8a 00                	mov    (%eax),%al
  80247b:	3c 60                	cmp    $0x60,%al
  80247d:	7e 19                	jle    802498 <strtol+0xe4>
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	8a 00                	mov    (%eax),%al
  802484:	3c 7a                	cmp    $0x7a,%al
  802486:	7f 10                	jg     802498 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	8a 00                	mov    (%eax),%al
  80248d:	0f be c0             	movsbl %al,%eax
  802490:	83 e8 57             	sub    $0x57,%eax
  802493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802496:	eb 20                	jmp    8024b8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	8a 00                	mov    (%eax),%al
  80249d:	3c 40                	cmp    $0x40,%al
  80249f:	7e 39                	jle    8024da <strtol+0x126>
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	8a 00                	mov    (%eax),%al
  8024a6:	3c 5a                	cmp    $0x5a,%al
  8024a8:	7f 30                	jg     8024da <strtol+0x126>
			dig = *s - 'A' + 10;
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	8a 00                	mov    (%eax),%al
  8024af:	0f be c0             	movsbl %al,%eax
  8024b2:	83 e8 37             	sub    $0x37,%eax
  8024b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8024be:	7d 19                	jge    8024d9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8024c0:	ff 45 08             	incl   0x8(%ebp)
  8024c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8024ca:	89 c2                	mov    %eax,%edx
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	01 d0                	add    %edx,%eax
  8024d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8024d4:	e9 7b ff ff ff       	jmp    802454 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8024d9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8024da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024de:	74 08                	je     8024e8 <strtol+0x134>
		*endptr = (char *) s;
  8024e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8024e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024ec:	74 07                	je     8024f5 <strtol+0x141>
  8024ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024f1:	f7 d8                	neg    %eax
  8024f3:	eb 03                	jmp    8024f8 <strtol+0x144>
  8024f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <ltostr>:

void
ltostr(long value, char *str)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
  8024fd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802507:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80250e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802512:	79 13                	jns    802527 <ltostr+0x2d>
	{
		neg = 1;
  802514:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80251b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802521:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802524:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802527:	8b 45 08             	mov    0x8(%ebp),%eax
  80252a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80252f:	99                   	cltd   
  802530:	f7 f9                	idiv   %ecx
  802532:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802538:	8d 50 01             	lea    0x1(%eax),%edx
  80253b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80253e:	89 c2                	mov    %eax,%edx
  802540:	8b 45 0c             	mov    0xc(%ebp),%eax
  802543:	01 d0                	add    %edx,%eax
  802545:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802548:	83 c2 30             	add    $0x30,%edx
  80254b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80254d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802550:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802555:	f7 e9                	imul   %ecx
  802557:	c1 fa 02             	sar    $0x2,%edx
  80255a:	89 c8                	mov    %ecx,%eax
  80255c:	c1 f8 1f             	sar    $0x1f,%eax
  80255f:	29 c2                	sub    %eax,%edx
  802561:	89 d0                	mov    %edx,%eax
  802563:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802566:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80256a:	75 bb                	jne    802527 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80256c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802573:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802576:	48                   	dec    %eax
  802577:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80257a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80257e:	74 3d                	je     8025bd <ltostr+0xc3>
		start = 1 ;
  802580:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802587:	eb 34                	jmp    8025bd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80258f:	01 d0                	add    %edx,%eax
  802591:	8a 00                	mov    (%eax),%al
  802593:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802596:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802599:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259c:	01 c2                	add    %eax,%edx
  80259e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a4:	01 c8                	add    %ecx,%eax
  8025a6:	8a 00                	mov    (%eax),%al
  8025a8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8025aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b0:	01 c2                	add    %eax,%edx
  8025b2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8025b5:	88 02                	mov    %al,(%edx)
		start++ ;
  8025b7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8025ba:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c3:	7c c4                	jl     802589 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8025c5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8025c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025cb:	01 d0                	add    %edx,%eax
  8025cd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8025d0:	90                   	nop
  8025d1:	c9                   	leave  
  8025d2:	c3                   	ret    

008025d3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8025d3:	55                   	push   %ebp
  8025d4:	89 e5                	mov    %esp,%ebp
  8025d6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8025d9:	ff 75 08             	pushl  0x8(%ebp)
  8025dc:	e8 c4 f9 ff ff       	call   801fa5 <strlen>
  8025e1:	83 c4 04             	add    $0x4,%esp
  8025e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8025e7:	ff 75 0c             	pushl  0xc(%ebp)
  8025ea:	e8 b6 f9 ff ff       	call   801fa5 <strlen>
  8025ef:	83 c4 04             	add    $0x4,%esp
  8025f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8025f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8025fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802603:	eb 17                	jmp    80261c <strcconcat+0x49>
		final[s] = str1[s] ;
  802605:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802608:	8b 45 10             	mov    0x10(%ebp),%eax
  80260b:	01 c2                	add    %eax,%edx
  80260d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802610:	8b 45 08             	mov    0x8(%ebp),%eax
  802613:	01 c8                	add    %ecx,%eax
  802615:	8a 00                	mov    (%eax),%al
  802617:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802619:	ff 45 fc             	incl   -0x4(%ebp)
  80261c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80261f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802622:	7c e1                	jl     802605 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802624:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80262b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802632:	eb 1f                	jmp    802653 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802634:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802637:	8d 50 01             	lea    0x1(%eax),%edx
  80263a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80263d:	89 c2                	mov    %eax,%edx
  80263f:	8b 45 10             	mov    0x10(%ebp),%eax
  802642:	01 c2                	add    %eax,%edx
  802644:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80264a:	01 c8                	add    %ecx,%eax
  80264c:	8a 00                	mov    (%eax),%al
  80264e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802650:	ff 45 f8             	incl   -0x8(%ebp)
  802653:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802656:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802659:	7c d9                	jl     802634 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80265b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80265e:	8b 45 10             	mov    0x10(%ebp),%eax
  802661:	01 d0                	add    %edx,%eax
  802663:	c6 00 00             	movb   $0x0,(%eax)
}
  802666:	90                   	nop
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80266c:	8b 45 14             	mov    0x14(%ebp),%eax
  80266f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802675:	8b 45 14             	mov    0x14(%ebp),%eax
  802678:	8b 00                	mov    (%eax),%eax
  80267a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802681:	8b 45 10             	mov    0x10(%ebp),%eax
  802684:	01 d0                	add    %edx,%eax
  802686:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80268c:	eb 0c                	jmp    80269a <strsplit+0x31>
			*string++ = 0;
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	8d 50 01             	lea    0x1(%eax),%edx
  802694:	89 55 08             	mov    %edx,0x8(%ebp)
  802697:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80269a:	8b 45 08             	mov    0x8(%ebp),%eax
  80269d:	8a 00                	mov    (%eax),%al
  80269f:	84 c0                	test   %al,%al
  8026a1:	74 18                	je     8026bb <strsplit+0x52>
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	8a 00                	mov    (%eax),%al
  8026a8:	0f be c0             	movsbl %al,%eax
  8026ab:	50                   	push   %eax
  8026ac:	ff 75 0c             	pushl  0xc(%ebp)
  8026af:	e8 83 fa ff ff       	call   802137 <strchr>
  8026b4:	83 c4 08             	add    $0x8,%esp
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	75 d3                	jne    80268e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	8a 00                	mov    (%eax),%al
  8026c0:	84 c0                	test   %al,%al
  8026c2:	74 5a                	je     80271e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8026c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	83 f8 0f             	cmp    $0xf,%eax
  8026cc:	75 07                	jne    8026d5 <strsplit+0x6c>
		{
			return 0;
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d3:	eb 66                	jmp    80273b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8026d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	8d 48 01             	lea    0x1(%eax),%ecx
  8026dd:	8b 55 14             	mov    0x14(%ebp),%edx
  8026e0:	89 0a                	mov    %ecx,(%edx)
  8026e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ec:	01 c2                	add    %eax,%edx
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8026f3:	eb 03                	jmp    8026f8 <strsplit+0x8f>
			string++;
  8026f5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	8a 00                	mov    (%eax),%al
  8026fd:	84 c0                	test   %al,%al
  8026ff:	74 8b                	je     80268c <strsplit+0x23>
  802701:	8b 45 08             	mov    0x8(%ebp),%eax
  802704:	8a 00                	mov    (%eax),%al
  802706:	0f be c0             	movsbl %al,%eax
  802709:	50                   	push   %eax
  80270a:	ff 75 0c             	pushl  0xc(%ebp)
  80270d:	e8 25 fa ff ff       	call   802137 <strchr>
  802712:	83 c4 08             	add    $0x8,%esp
  802715:	85 c0                	test   %eax,%eax
  802717:	74 dc                	je     8026f5 <strsplit+0x8c>
			string++;
	}
  802719:	e9 6e ff ff ff       	jmp    80268c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80271e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80271f:	8b 45 14             	mov    0x14(%ebp),%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80272b:	8b 45 10             	mov    0x10(%ebp),%eax
  80272e:	01 d0                	add    %edx,%eax
  802730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802736:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80273b:	c9                   	leave  
  80273c:	c3                   	ret    

0080273d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80273d:	55                   	push   %ebp
  80273e:	89 e5                	mov    %esp,%ebp
  802740:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802743:	8b 45 08             	mov    0x8(%ebp),%eax
  802746:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802749:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802750:	eb 4a                	jmp    80279c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802752:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	01 c2                	add    %eax,%edx
  80275a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80275d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802760:	01 c8                	add    %ecx,%eax
  802762:	8a 00                	mov    (%eax),%al
  802764:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802766:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802769:	8b 45 0c             	mov    0xc(%ebp),%eax
  80276c:	01 d0                	add    %edx,%eax
  80276e:	8a 00                	mov    (%eax),%al
  802770:	3c 40                	cmp    $0x40,%al
  802772:	7e 25                	jle    802799 <str2lower+0x5c>
  802774:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277a:	01 d0                	add    %edx,%eax
  80277c:	8a 00                	mov    (%eax),%al
  80277e:	3c 5a                	cmp    $0x5a,%al
  802780:	7f 17                	jg     802799 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802782:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802785:	8b 45 08             	mov    0x8(%ebp),%eax
  802788:	01 d0                	add    %edx,%eax
  80278a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80278d:	8b 55 08             	mov    0x8(%ebp),%edx
  802790:	01 ca                	add    %ecx,%edx
  802792:	8a 12                	mov    (%edx),%dl
  802794:	83 c2 20             	add    $0x20,%edx
  802797:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802799:	ff 45 fc             	incl   -0x4(%ebp)
  80279c:	ff 75 0c             	pushl  0xc(%ebp)
  80279f:	e8 01 f8 ff ff       	call   801fa5 <strlen>
  8027a4:	83 c4 04             	add    $0x4,%esp
  8027a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8027aa:	7f a6                	jg     802752 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8027ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8027b7:	a1 08 70 80 00       	mov    0x807008,%eax
  8027bc:	85 c0                	test   %eax,%eax
  8027be:	0f 84 95 00 00 00    	je     802859 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8027c4:	83 ec 08             	sub    $0x8,%esp
  8027c7:	68 00 00 00 82       	push   $0x82000000
  8027cc:	68 00 00 00 80       	push   $0x80000000
  8027d1:	e8 59 1f 00 00       	call   80472f <initialize_dynamic_allocator>
  8027d6:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8027d9:	e8 93 1d 00 00       	call   804571 <sys_get_uheap_strategy>
  8027de:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8027e3:	a1 20 72 80 00       	mov    0x807220,%eax
  8027e8:	05 00 10 00 00       	add    $0x1000,%eax
  8027ed:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  8027f2:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8027f7:	a3 50 f2 81 00       	mov    %eax,0x81f250
		init_uspinlock(&ulock,"malloc",1);
  8027fc:	83 ec 04             	sub    $0x4,%esp
  8027ff:	6a 01                	push   $0x1
  802801:	68 e8 61 80 00       	push   $0x8061e8
  802806:	68 20 f3 81 00       	push   $0x81f320
  80280b:	e8 1a 29 00 00       	call   80512a <init_uspinlock>
  802810:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  802813:	c7 05 00 f3 81 00 00 	movl   $0x0,0x81f300
  80281a:	00 00 00 
  80281d:	c7 05 04 f3 81 00 00 	movl   $0x0,0x81f304
  802824:	00 00 00 
  802827:	c7 05 0c f3 81 00 00 	movl   $0x0,0x81f30c
  80282e:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  802831:	c7 05 10 f3 81 00 00 	movl   $0x0,0x81f310
  802838:	00 00 00 
  80283b:	c7 05 14 f3 81 00 00 	movl   $0x0,0x81f314
  802842:	00 00 00 
  802845:	c7 05 1c f3 81 00 00 	movl   $0x0,0x81f31c
  80284c:	00 00 00 
		__firstTimeFlag = 0;
  80284f:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  802856:	00 00 00 
	}
}
  802859:	90                   	nop
  80285a:	c9                   	leave  
  80285b:	c3                   	ret    

0080285c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80285c:	55                   	push   %ebp
  80285d:	89 e5                	mov    %esp,%ebp
  80285f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802870:	83 ec 08             	sub    $0x8,%esp
  802873:	68 06 04 00 00       	push   $0x406
  802878:	50                   	push   %eax
  802879:	e8 3d 19 00 00       	call   8041bb <__sys_allocate_page>
  80287e:	83 c4 10             	add    $0x10,%esp
  802881:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802884:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802888:	79 14                	jns    80289e <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80288a:	83 ec 04             	sub    $0x4,%esp
  80288d:	68 f0 61 80 00       	push   $0x8061f0
  802892:	6a 2d                	push   $0x2d
  802894:	68 2c 62 80 00       	push   $0x80622c
  802899:	e8 60 ed ff ff       	call   8015fe <_panic>
	return 0;
  80289e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a3:	c9                   	leave  
  8028a4:	c3                   	ret    

008028a5 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
  8028a8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8028b9:	83 ec 0c             	sub    $0xc,%esp
  8028bc:	50                   	push   %eax
  8028bd:	e8 40 19 00 00       	call   804202 <__sys_unmap_frame>
  8028c2:	83 c4 10             	add    $0x10,%esp
  8028c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8028c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028cc:	79 14                	jns    8028e2 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	68 38 62 80 00       	push   $0x806238
  8028d6:	6a 38                	push   $0x38
  8028d8:	68 2c 62 80 00       	push   $0x80622c
  8028dd:	e8 1c ed ff ff       	call   8015fe <_panic>
}
  8028e2:	90                   	nop
  8028e3:	c9                   	leave  
  8028e4:	c3                   	ret    

008028e5 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8028e5:	55                   	push   %ebp
  8028e6:	89 e5                	mov    %esp,%ebp
  8028e8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8028eb:	e8 c1 fe ff ff       	call   8027b1 <uheap_init>
	if (size == 0) return NULL ;
  8028f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f4:	75 0a                	jne    802900 <malloc+0x1b>
  8028f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fb:	e9 e1 04 00 00       	jmp    802de1 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  802900:	83 ec 0c             	sub    $0xc,%esp
  802903:	68 20 f3 81 00       	push   $0x81f320
  802908:	e8 6c 28 00 00       	call   805179 <acquire_uspinlock>
  80290d:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  802910:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  802917:	77 23                	ja     80293c <malloc+0x57>
		release_uspinlock(&ulock);
  802919:	83 ec 0c             	sub    $0xc,%esp
  80291c:	68 20 f3 81 00       	push   $0x81f320
  802921:	e8 ab 28 00 00       	call   8051d1 <release_uspinlock>
  802926:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  802929:	83 ec 0c             	sub    $0xc,%esp
  80292c:	ff 75 08             	pushl  0x8(%ebp)
  80292f:	e8 dd 1f 00 00       	call   804911 <alloc_block>
  802934:	83 c4 10             	add    $0x10,%esp
  802937:	e9 a5 04 00 00       	jmp    802de1 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80293c:	83 ec 0c             	sub    $0xc,%esp
  80293f:	6a 10                	push   $0x10
  802941:	e8 cb 1f 00 00       	call   804911 <alloc_block>
  802946:	83 c4 10             	add    $0x10,%esp
  802949:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  80294c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802950:	75 0a                	jne    80295c <malloc+0x77>
			return NULL;
  802952:	b8 00 00 00 00       	mov    $0x0,%eax
  802957:	e9 85 04 00 00       	jmp    802de1 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  80295c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802963:	8b 55 08             	mov    0x8(%ebp),%edx
  802966:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802969:	01 d0                	add    %edx,%eax
  80296b:	48                   	dec    %eax
  80296c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80296f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802972:	ba 00 00 00 00       	mov    $0x0,%edx
  802977:	f7 75 e8             	divl   -0x18(%ebp)
  80297a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297d:	29 d0                	sub    %edx,%eax
  80297f:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802982:	a1 04 f3 81 00       	mov    0x81f304,%eax
  802987:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80298a:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80298f:	85 c0                	test   %eax,%eax
  802991:	74 0f                	je     8029a2 <malloc+0xbd>
  802993:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802996:	8b 40 04             	mov    0x4(%eax),%eax
  802999:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299c:	0f 83 ea 00 00 00    	jae    802a8c <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  8029a2:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8029a7:	2b 45 08             	sub    0x8(%ebp),%eax
  8029aa:	89 c2                	mov    %eax,%edx
  8029ac:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8029b1:	39 c2                	cmp    %eax,%edx
  8029b3:	0f 86 b9 00 00 00    	jbe    802a72 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  8029b9:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8029be:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  8029c1:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	01 d0                	add    %edx,%eax
  8029cc:	a3 50 f2 81 00       	mov    %eax,0x81f250
					allocblock->startva = requestedblockva;
  8029d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029d7:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8029d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8029df:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8029e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029e6:	75 14                	jne    8029fc <malloc+0x117>
  8029e8:	83 ec 04             	sub    $0x4,%esp
  8029eb:	68 78 62 80 00       	push   $0x806278
  8029f0:	6a 60                	push   $0x60
  8029f2:	68 2c 62 80 00       	push   $0x80622c
  8029f7:	e8 02 ec ff ff       	call   8015fe <_panic>
  8029fc:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a05:	89 50 0c             	mov    %edx,0xc(%eax)
  802a08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 0d                	je     802a1f <malloc+0x13a>
  802a12:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802a17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a1a:	89 50 08             	mov    %edx,0x8(%eax)
  802a1d:	eb 08                	jmp    802a27 <malloc+0x142>
  802a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a22:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2a:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802a2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a39:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802a3e:	40                   	inc    %eax
  802a3f:	a3 1c f3 81 00       	mov    %eax,0x81f31c


					sys_allocate_user_mem(allocblock->startva ,size);
  802a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a47:	8b 00                	mov    (%eax),%eax
  802a49:	83 ec 08             	sub    $0x8,%esp
  802a4c:	ff 75 08             	pushl  0x8(%ebp)
  802a4f:	50                   	push   %eax
  802a50:	e8 34 1c 00 00       	call   804689 <sys_allocate_user_mem>
  802a55:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  802a58:	83 ec 0c             	sub    $0xc,%esp
  802a5b:	68 20 f3 81 00       	push   $0x81f320
  802a60:	e8 6c 27 00 00       	call   8051d1 <release_uspinlock>
  802a65:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802a68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6b:	8b 00                	mov    (%eax),%eax
  802a6d:	e9 6f 03 00 00       	jmp    802de1 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  802a72:	83 ec 0c             	sub    $0xc,%esp
  802a75:	68 20 f3 81 00       	push   $0x81f320
  802a7a:	e8 52 27 00 00       	call   8051d1 <release_uspinlock>
  802a7f:	83 c4 10             	add    $0x10,%esp
					return NULL;
  802a82:	b8 00 00 00 00       	mov    $0x0,%eax
  802a87:	e9 55 03 00 00       	jmp    802de1 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802a8c:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  802a94:	e9 39 03 00 00       	jmp    802dd2 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa2:	0f 86 e7 01 00 00    	jbe    802c8f <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  802aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aab:	8b 10                	mov    (%eax),%edx
  802aad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab0:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  802ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab8:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802abb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802abf:	75 14                	jne    802ad5 <malloc+0x1f0>
  802ac1:	83 ec 04             	sub    $0x4,%esp
  802ac4:	68 78 62 80 00       	push   $0x806278
  802ac9:	6a 72                	push   $0x72
  802acb:	68 2c 62 80 00       	push   $0x80622c
  802ad0:	e8 29 eb ff ff       	call   8015fe <_panic>
  802ad5:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ade:	89 50 0c             	mov    %edx,0xc(%eax)
  802ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	74 0d                	je     802af8 <malloc+0x213>
  802aeb:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802af0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af3:	89 50 08             	mov    %edx,0x8(%eax)
  802af6:	eb 08                	jmp    802b00 <malloc+0x21b>
  802af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afb:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b03:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b12:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802b17:	40                   	inc    %eax
  802b18:	a3 1c f3 81 00       	mov    %eax,0x81f31c
                lastfreeelement->startva += size;
  802b1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b20:	8b 10                	mov    (%eax),%edx
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	01 c2                	add    %eax,%edx
  802b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2a:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  802b2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2f:	8b 40 04             	mov    0x4(%eax),%eax
  802b32:	2b 45 08             	sub    0x8(%ebp),%eax
  802b35:	89 c2                	mov    %eax,%edx
  802b37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3a:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802b3d:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  802b45:	e9 0d 01 00 00       	jmp    802c57 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  802b4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4d:	8b 50 04             	mov    0x4(%eax),%edx
  802b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b53:	8b 40 04             	mov    0x4(%eax),%eax
  802b56:	39 c2                	cmp    %eax,%edx
  802b58:	0f 83 f0 00 00 00    	jae    802c4e <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802b5e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b62:	75 14                	jne    802b78 <malloc+0x293>
  802b64:	83 ec 04             	sub    $0x4,%esp
  802b67:	68 9b 62 80 00       	push   $0x80629b
  802b6c:	6a 7a                	push   $0x7a
  802b6e:	68 2c 62 80 00       	push   $0x80622c
  802b73:	e8 86 ea ff ff       	call   8015fe <_panic>
  802b78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7b:	8b 40 08             	mov    0x8(%eax),%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	74 11                	je     802b93 <malloc+0x2ae>
  802b82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b85:	8b 40 08             	mov    0x8(%eax),%eax
  802b88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b8b:	8b 52 0c             	mov    0xc(%edx),%edx
  802b8e:	89 50 0c             	mov    %edx,0xc(%eax)
  802b91:	eb 0b                	jmp    802b9e <malloc+0x2b9>
  802b93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b96:	8b 40 0c             	mov    0xc(%eax),%eax
  802b99:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802b9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 11                	je     802bb9 <malloc+0x2d4>
  802ba8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bab:	8b 40 0c             	mov    0xc(%eax),%eax
  802bae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bb1:	8b 52 08             	mov    0x8(%edx),%edx
  802bb4:	89 50 08             	mov    %edx,0x8(%eax)
  802bb7:	eb 0b                	jmp    802bc4 <malloc+0x2df>
  802bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bbc:	8b 40 08             	mov    0x8(%eax),%eax
  802bbf:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802bc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802bd8:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802bdd:	48                   	dec    %eax
  802bde:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802be3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be7:	74 06                	je     802bef <malloc+0x30a>
  802be9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bed:	75 14                	jne    802c03 <malloc+0x31e>
  802bef:	83 ec 04             	sub    $0x4,%esp
  802bf2:	68 bc 62 80 00       	push   $0x8062bc
  802bf7:	6a 7b                	push   $0x7b
  802bf9:	68 2c 62 80 00       	push   $0x80622c
  802bfe:	e8 fb e9 ff ff       	call   8015fe <_panic>
  802c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c06:	8b 50 0c             	mov    0xc(%eax),%edx
  802c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0c:	89 50 0c             	mov    %edx,0xc(%eax)
  802c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c15:	89 50 08             	mov    %edx,0x8(%eax)
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	74 0e                	je     802c30 <malloc+0x34b>
  802c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c25:	8b 40 0c             	mov    0xc(%eax),%eax
  802c28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c2b:	89 50 08             	mov    %edx,0x8(%eax)
  802c2e:	eb 08                	jmp    802c38 <malloc+0x353>
  802c30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c33:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c3e:	89 50 0c             	mov    %edx,0xc(%eax)
  802c41:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802c46:	40                   	inc    %eax
  802c47:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		break;
  802c4c:	eb 13                	jmp    802c61 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  802c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c51:	8b 40 08             	mov    0x8(%eax),%eax
  802c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  802c57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c5b:	0f 85 e9 fe ff ff    	jne    802b4a <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  802c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	83 ec 08             	sub    $0x8,%esp
  802c69:	ff 75 08             	pushl  0x8(%ebp)
  802c6c:	50                   	push   %eax
  802c6d:	e8 17 1a 00 00       	call   804689 <sys_allocate_user_mem>
  802c72:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  802c75:	83 ec 0c             	sub    $0xc,%esp
  802c78:	68 20 f3 81 00       	push   $0x81f320
  802c7d:	e8 4f 25 00 00       	call   8051d1 <release_uspinlock>
  802c82:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  802c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c88:	8b 00                	mov    (%eax),%eax
  802c8a:	e9 52 01 00 00       	jmp    802de1 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 40 04             	mov    0x4(%eax),%eax
  802c95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c98:	0f 85 2b 01 00 00    	jne    802dc9 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 10                	mov    (%eax),%edx
  802ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca6:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  802ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cab:	8b 55 08             	mov    0x8(%ebp),%edx
  802cae:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802cb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cb5:	75 17                	jne    802cce <malloc+0x3e9>
  802cb7:	83 ec 04             	sub    $0x4,%esp
  802cba:	68 78 62 80 00       	push   $0x806278
  802cbf:	68 89 00 00 00       	push   $0x89
  802cc4:	68 2c 62 80 00       	push   $0x80622c
  802cc9:	e8 30 e9 ff ff       	call   8015fe <_panic>
  802cce:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd7:	89 50 0c             	mov    %edx,0xc(%eax)
  802cda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 0d                	je     802cf1 <malloc+0x40c>
  802ce4:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802ce9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cec:	89 50 08             	mov    %edx,0x8(%eax)
  802cef:	eb 08                	jmp    802cf9 <malloc+0x414>
  802cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf4:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802cf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfc:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802d01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d0b:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802d10:	40                   	inc    %eax
  802d11:	a3 1c f3 81 00       	mov    %eax,0x81f31c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  802d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1a:	75 17                	jne    802d33 <malloc+0x44e>
  802d1c:	83 ec 04             	sub    $0x4,%esp
  802d1f:	68 9b 62 80 00       	push   $0x80629b
  802d24:	68 8a 00 00 00       	push   $0x8a
  802d29:	68 2c 62 80 00       	push   $0x80622c
  802d2e:	e8 cb e8 ff ff       	call   8015fe <_panic>
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 40 08             	mov    0x8(%eax),%eax
  802d39:	85 c0                	test   %eax,%eax
  802d3b:	74 11                	je     802d4e <malloc+0x469>
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 40 08             	mov    0x8(%eax),%eax
  802d43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d46:	8b 52 0c             	mov    0xc(%edx),%edx
  802d49:	89 50 0c             	mov    %edx,0xc(%eax)
  802d4c:	eb 0b                	jmp    802d59 <malloc+0x474>
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 40 0c             	mov    0xc(%eax),%eax
  802d54:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	74 11                	je     802d74 <malloc+0x48f>
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	8b 40 0c             	mov    0xc(%eax),%eax
  802d69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6c:	8b 52 08             	mov    0x8(%edx),%edx
  802d6f:	89 50 08             	mov    %edx,0x8(%eax)
  802d72:	eb 0b                	jmp    802d7f <malloc+0x49a>
  802d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d77:	8b 40 08             	mov    0x8(%eax),%eax
  802d7a:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d93:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802d98:	48                   	dec    %eax
  802d99:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				sys_allocate_user_mem(allocblock->startva ,size);
  802d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da1:	8b 00                	mov    (%eax),%eax
  802da3:	83 ec 08             	sub    $0x8,%esp
  802da6:	ff 75 08             	pushl  0x8(%ebp)
  802da9:	50                   	push   %eax
  802daa:	e8 da 18 00 00       	call   804689 <sys_allocate_user_mem>
  802daf:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  802db2:	83 ec 0c             	sub    $0xc,%esp
  802db5:	68 20 f3 81 00       	push   $0x81f320
  802dba:	e8 12 24 00 00       	call   8051d1 <release_uspinlock>
  802dbf:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  802dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc5:	8b 00                	mov    (%eax),%eax
  802dc7:	eb 18                	jmp    802de1 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 40 08             	mov    0x8(%eax),%eax
  802dcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  802dd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd6:	0f 85 bd fc ff ff    	jne    802a99 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  802ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de1:	c9                   	leave  
  802de2:	c3                   	ret    

00802de3 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802de3:	55                   	push   %ebp
  802de4:	89 e5                	mov    %esp,%ebp
  802de6:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802def:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802df7:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  802dfa:	e8 b2 f9 ff ff       	call   8027b1 <uheap_init>
		acquire_uspinlock(&ulock);
  802dff:	83 ec 0c             	sub    $0xc,%esp
  802e02:	68 20 f3 81 00       	push   $0x81f320
  802e07:	e8 6d 23 00 00       	call   805179 <acquire_uspinlock>
  802e0c:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  802e0f:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802e14:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802e17:	73 23                	jae    802e3c <free+0x59>
			free_block(virtual_address);
  802e19:	83 ec 0c             	sub    $0xc,%esp
  802e1c:	ff 75 08             	pushl  0x8(%ebp)
  802e1f:	e8 89 1f 00 00       	call   804dad <free_block>
  802e24:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  802e27:	83 ec 0c             	sub    $0xc,%esp
  802e2a:	68 20 f3 81 00       	push   $0x81f320
  802e2f:	e8 9d 23 00 00       	call   8051d1 <release_uspinlock>
  802e34:	83 c4 10             	add    $0x10,%esp
			return;
  802e37:	e9 35 07 00 00       	jmp    803571 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802e3c:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802e41:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802e44:	72 30                	jb     802e76 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  802e46:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802e4b:	83 ec 04             	sub    $0x4,%esp
  802e4e:	50                   	push   %eax
  802e4f:	ff 75 d8             	pushl  -0x28(%ebp)
  802e52:	68 f1 62 80 00       	push   $0x8062f1
  802e57:	e8 70 ea ff ff       	call   8018cc <cprintf>
  802e5c:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802e5f:	83 ec 04             	sub    $0x4,%esp
  802e62:	68 f9 62 80 00       	push   $0x8062f9
  802e67:	68 a7 00 00 00       	push   $0xa7
  802e6c:	68 2c 62 80 00       	push   $0x80622c
  802e71:	e8 88 e7 ff ff       	call   8015fe <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802e76:	83 ec 0c             	sub    $0xc,%esp
  802e79:	6a 10                	push   $0x10
  802e7b:	e8 91 1a 00 00       	call   804911 <alloc_block>
  802e80:	83 c4 10             	add    $0x10,%esp
  802e83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  802e86:	83 ec 0c             	sub    $0xc,%esp
  802e89:	6a 10                	push   $0x10
  802e8b:	e8 81 1a 00 00       	call   804911 <alloc_block>
  802e90:	83 c4 10             	add    $0x10,%esp
  802e93:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  802e96:	a1 10 f3 81 00       	mov    0x81f310,%eax
  802e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  802e9e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  802ea5:	eb 1c                	jmp    802ec3 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 00                	mov    (%eax),%eax
  802eac:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802eaf:	75 09                	jne    802eba <free+0xd7>
				foundVA = 1;
  802eb1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  802eb8:	eb 0f                	jmp    802ec9 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 40 08             	mov    0x8(%eax),%eax
  802ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  802ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec7:	75 de                	jne    802ea7 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  802ec9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ecd:	75 17                	jne    802ee6 <free+0x103>
				panic("INVALID ADDRESS!");
  802ecf:	83 ec 04             	sub    $0x4,%esp
  802ed2:	68 16 63 80 00       	push   $0x806316
  802ed7:	68 be 00 00 00       	push   $0xbe
  802edc:	68 2c 62 80 00       	push   $0x80622c
  802ee1:	e8 18 e7 ff ff       	call   8015fe <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	8b 10                	mov    (%eax),%edx
  802eeb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802eee:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 50 04             	mov    0x4(%eax),%edx
  802ef6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ef9:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  802efc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f00:	75 17                	jne    802f19 <free+0x136>
  802f02:	83 ec 04             	sub    $0x4,%esp
  802f05:	68 9b 62 80 00       	push   $0x80629b
  802f0a:	68 c8 00 00 00       	push   $0xc8
  802f0f:	68 2c 62 80 00       	push   $0x80622c
  802f14:	e8 e5 e6 ff ff       	call   8015fe <_panic>
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	8b 40 08             	mov    0x8(%eax),%eax
  802f1f:	85 c0                	test   %eax,%eax
  802f21:	74 11                	je     802f34 <free+0x151>
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 40 08             	mov    0x8(%eax),%eax
  802f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f2c:	8b 52 0c             	mov    0xc(%edx),%edx
  802f2f:	89 50 0c             	mov    %edx,0xc(%eax)
  802f32:	eb 0b                	jmp    802f3f <free+0x15c>
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3a:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 40 0c             	mov    0xc(%eax),%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	74 11                	je     802f5a <free+0x177>
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f52:	8b 52 08             	mov    0x8(%edx),%edx
  802f55:	89 50 08             	mov    %edx,0x8(%eax)
  802f58:	eb 0b                	jmp    802f65 <free+0x182>
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	8b 40 08             	mov    0x8(%eax),%eax
  802f60:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f79:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802f7e:	48                   	dec    %eax
  802f7f:	a3 1c f3 81 00       	mov    %eax,0x81f31c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	8b 50 04             	mov    0x4(%eax),%edx
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	83 ec 08             	sub    $0x8,%esp
  802f92:	52                   	push   %edx
  802f93:	50                   	push   %eax
  802f94:	e8 d4 16 00 00       	call   80466d <sys_free_user_mem>
  802f99:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  802f9c:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	75 7a                	jne    80301f <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  802fa5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802fa9:	75 17                	jne    802fc2 <free+0x1df>
  802fab:	83 ec 04             	sub    $0x4,%esp
  802fae:	68 28 63 80 00       	push   $0x806328
  802fb3:	68 d0 00 00 00       	push   $0xd0
  802fb8:	68 2c 62 80 00       	push   $0x80622c
  802fbd:	e8 3c e6 ff ff       	call   8015fe <_panic>
  802fc2:	8b 15 00 f3 81 00    	mov    0x81f300,%edx
  802fc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fcb:	89 50 08             	mov    %edx,0x8(%eax)
  802fce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fd1:	8b 40 08             	mov    0x8(%eax),%eax
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	74 0d                	je     802fe5 <free+0x202>
  802fd8:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802fdd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802fe0:	89 50 0c             	mov    %edx,0xc(%eax)
  802fe3:	eb 08                	jmp    802fed <free+0x20a>
  802fe5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fe8:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802fed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ff0:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802ff5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ff8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fff:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803004:	40                   	inc    %eax
  803005:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			release_uspinlock(&ulock);
  80300a:	83 ec 0c             	sub    $0xc,%esp
  80300d:	68 20 f3 81 00       	push   $0x81f320
  803012:	e8 ba 21 00 00       	call   8051d1 <release_uspinlock>
  803017:	83 c4 10             	add    $0x10,%esp
			return;
  80301a:	e9 52 05 00 00       	jmp    803571 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  80301f:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803024:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  803027:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  80302e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  803035:	e9 d2 00 00 00       	jmp    80310c <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  80303a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303d:	8b 10                	mov    (%eax),%edx
  80303f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	01 c2                	add    %eax,%edx
  803047:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80304a:	8b 00                	mov    (%eax),%eax
  80304c:	39 c2                	cmp    %eax,%edx
  80304e:	0f 85 af 00 00 00    	jne    803103 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  803054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803057:	8b 10                	mov    (%eax),%edx
  803059:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80305c:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  80305e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803061:	8b 50 04             	mov    0x4(%eax),%edx
  803064:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803067:	8b 40 04             	mov    0x4(%eax),%eax
  80306a:	01 c2                	add    %eax,%edx
  80306c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80306f:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  803072:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803076:	75 17                	jne    80308f <free+0x2ac>
  803078:	83 ec 04             	sub    $0x4,%esp
  80307b:	68 9b 62 80 00       	push   $0x80629b
  803080:	68 df 00 00 00       	push   $0xdf
  803085:	68 2c 62 80 00       	push   $0x80622c
  80308a:	e8 6f e5 ff ff       	call   8015fe <_panic>
  80308f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803092:	8b 40 08             	mov    0x8(%eax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	74 11                	je     8030aa <free+0x2c7>
  803099:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309c:	8b 40 08             	mov    0x8(%eax),%eax
  80309f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030a2:	8b 52 0c             	mov    0xc(%edx),%edx
  8030a5:	89 50 0c             	mov    %edx,0xc(%eax)
  8030a8:	eb 0b                	jmp    8030b5 <free+0x2d2>
  8030aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b0:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8030b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bb:	85 c0                	test   %eax,%eax
  8030bd:	74 11                	je     8030d0 <free+0x2ed>
  8030bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030c8:	8b 52 08             	mov    0x8(%edx),%edx
  8030cb:	89 50 08             	mov    %edx,0x8(%eax)
  8030ce:	eb 0b                	jmp    8030db <free+0x2f8>
  8030d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d3:	8b 40 08             	mov    0x8(%eax),%eax
  8030d6:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8030db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8030ef:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8030f4:	48                   	dec    %eax
  8030f5:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				mergeprev = 1;
  8030fa:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  803101:	eb 13                	jmp    803116 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  803103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803106:	8b 40 08             	mov    0x8(%eax),%eax
  803109:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  80310c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803110:	0f 85 24 ff ff ff    	jne    80303a <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  803116:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803119:	8b 10                	mov    (%eax),%edx
  80311b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80311e:	8b 40 04             	mov    0x4(%eax),%eax
  803121:	01 c2                	add    %eax,%edx
  803123:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803128:	39 c2                	cmp    %eax,%edx
  80312a:	75 44                	jne    803170 <free+0x38d>

			if(mergeprev){
  80312c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803130:	74 1f                	je     803151 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  803132:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803135:	8b 00                	mov    (%eax),%eax
  803137:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  80313c:	83 ec 0c             	sub    $0xc,%esp
  80313f:	68 20 f3 81 00       	push   $0x81f320
  803144:	e8 88 20 00 00       	call   8051d1 <release_uspinlock>
  803149:	83 c4 10             	add    $0x10,%esp
				return;
  80314c:	e9 20 04 00 00       	jmp    803571 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  803151:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803154:	8b 00                	mov    (%eax),%eax
  803156:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  80315b:	83 ec 0c             	sub    $0xc,%esp
  80315e:	68 20 f3 81 00       	push   $0x81f320
  803163:	e8 69 20 00 00       	call   8051d1 <release_uspinlock>
  803168:	83 c4 10             	add    $0x10,%esp
				return;
  80316b:	e9 01 04 00 00       	jmp    803571 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  803170:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803175:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  803178:	e9 7d 01 00 00       	jmp    8032fa <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  80317d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803180:	8b 10                	mov    (%eax),%edx
  803182:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803185:	8b 40 04             	mov    0x4(%eax),%eax
  803188:	01 c2                	add    %eax,%edx
  80318a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318d:	8b 00                	mov    (%eax),%eax
  80318f:	39 c2                	cmp    %eax,%edx
  803191:	0f 85 5a 01 00 00    	jne    8032f1 <free+0x50e>
				if (mergeprev){
  803197:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319b:	0f 84 a1 00 00 00    	je     803242 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  8031a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031a4:	8b 50 04             	mov    0x4(%eax),%edx
  8031a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031aa:	8b 40 04             	mov    0x4(%eax),%eax
  8031ad:	01 c2                	add    %eax,%edx
  8031af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031b2:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8031b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031b9:	75 17                	jne    8031d2 <free+0x3ef>
  8031bb:	83 ec 04             	sub    $0x4,%esp
  8031be:	68 9b 62 80 00       	push   $0x80629b
  8031c3:	68 0a 01 00 00       	push   $0x10a
  8031c8:	68 2c 62 80 00       	push   $0x80622c
  8031cd:	e8 2c e4 ff ff       	call   8015fe <_panic>
  8031d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d5:	8b 40 08             	mov    0x8(%eax),%eax
  8031d8:	85 c0                	test   %eax,%eax
  8031da:	74 11                	je     8031ed <free+0x40a>
  8031dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031df:	8b 40 08             	mov    0x8(%eax),%eax
  8031e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031e5:	8b 52 0c             	mov    0xc(%edx),%edx
  8031e8:	89 50 0c             	mov    %edx,0xc(%eax)
  8031eb:	eb 0b                	jmp    8031f8 <free+0x415>
  8031ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f3:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8031f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	74 11                	je     803213 <free+0x430>
  803202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803205:	8b 40 0c             	mov    0xc(%eax),%eax
  803208:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80320b:	8b 52 08             	mov    0x8(%edx),%edx
  80320e:	89 50 08             	mov    %edx,0x8(%eax)
  803211:	eb 0b                	jmp    80321e <free+0x43b>
  803213:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803216:	8b 40 08             	mov    0x8(%eax),%eax
  803219:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80321e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803221:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803232:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803237:	48                   	dec    %eax
  803238:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					break;
  80323d:	e9 c2 00 00 00       	jmp    803304 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  803242:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803245:	8b 10                	mov    (%eax),%edx
  803247:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80324a:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  80324c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80324f:	8b 50 04             	mov    0x4(%eax),%edx
  803252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803255:	8b 40 04             	mov    0x4(%eax),%eax
  803258:	01 c2                	add    %eax,%edx
  80325a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80325d:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  803260:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803264:	75 17                	jne    80327d <free+0x49a>
  803266:	83 ec 04             	sub    $0x4,%esp
  803269:	68 9b 62 80 00       	push   $0x80629b
  80326e:	68 10 01 00 00       	push   $0x110
  803273:	68 2c 62 80 00       	push   $0x80622c
  803278:	e8 81 e3 ff ff       	call   8015fe <_panic>
  80327d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803280:	8b 40 08             	mov    0x8(%eax),%eax
  803283:	85 c0                	test   %eax,%eax
  803285:	74 11                	je     803298 <free+0x4b5>
  803287:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328a:	8b 40 08             	mov    0x8(%eax),%eax
  80328d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803290:	8b 52 0c             	mov    0xc(%edx),%edx
  803293:	89 50 0c             	mov    %edx,0xc(%eax)
  803296:	eb 0b                	jmp    8032a3 <free+0x4c0>
  803298:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80329b:	8b 40 0c             	mov    0xc(%eax),%eax
  80329e:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8032a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a9:	85 c0                	test   %eax,%eax
  8032ab:	74 11                	je     8032be <free+0x4db>
  8032ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032b6:	8b 52 08             	mov    0x8(%edx),%edx
  8032b9:	89 50 08             	mov    %edx,0x8(%eax)
  8032bc:	eb 0b                	jmp    8032c9 <free+0x4e6>
  8032be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c1:	8b 40 08             	mov    0x8(%eax),%eax
  8032c4:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8032c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8032dd:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8032e2:	48                   	dec    %eax
  8032e3:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					mergenext = 1;
  8032e8:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8032ef:	eb 13                	jmp    803304 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8032f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f4:	8b 40 08             	mov    0x8(%eax),%eax
  8032f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  8032fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032fe:	0f 85 79 fe ff ff    	jne    80317d <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  803304:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803309:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  80330c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803310:	0f 85 ad 00 00 00    	jne    8033c3 <free+0x5e0>
  803316:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80331a:	0f 84 c3 01 00 00    	je     8034e3 <free+0x700>
				while(currentfree != NULL){
  803320:	e9 9e 00 00 00       	jmp    8033c3 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  803325:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803328:	8b 50 04             	mov    0x4(%eax),%edx
  80332b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80332e:	8b 40 04             	mov    0x4(%eax),%eax
  803331:	39 c2                	cmp    %eax,%edx
  803333:	0f 83 81 00 00 00    	jae    8033ba <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  803339:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80333d:	74 06                	je     803345 <free+0x562>
  80333f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803343:	75 17                	jne    80335c <free+0x579>
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	68 bc 62 80 00       	push   $0x8062bc
  80334d:	68 23 01 00 00       	push   $0x123
  803352:	68 2c 62 80 00       	push   $0x80622c
  803357:	e8 a2 e2 ff ff       	call   8015fe <_panic>
  80335c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80335f:	8b 50 0c             	mov    0xc(%eax),%edx
  803362:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803365:	89 50 0c             	mov    %edx,0xc(%eax)
  803368:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80336b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80336e:	89 50 08             	mov    %edx,0x8(%eax)
  803371:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803374:	8b 40 0c             	mov    0xc(%eax),%eax
  803377:	85 c0                	test   %eax,%eax
  803379:	74 0e                	je     803389 <free+0x5a6>
  80337b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80337e:	8b 40 0c             	mov    0xc(%eax),%eax
  803381:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803384:	89 50 08             	mov    %edx,0x8(%eax)
  803387:	eb 08                	jmp    803391 <free+0x5ae>
  803389:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80338c:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803391:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803394:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803397:	89 50 0c             	mov    %edx,0xc(%eax)
  80339a:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80339f:	40                   	inc    %eax
  8033a0:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  8033a5:	83 ec 0c             	sub    $0xc,%esp
  8033a8:	68 20 f3 81 00       	push   $0x81f320
  8033ad:	e8 1f 1e 00 00       	call   8051d1 <release_uspinlock>
  8033b2:	83 c4 10             	add    $0x10,%esp
							return;
  8033b5:	e9 b7 01 00 00       	jmp    803571 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8033ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033bd:	8b 40 08             	mov    0x8(%eax),%eax
  8033c0:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  8033c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033c7:	0f 85 58 ff ff ff    	jne    803325 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  8033cd:	83 ec 0c             	sub    $0xc,%esp
  8033d0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033d3:	e8 d5 19 00 00       	call   804dad <free_block>
  8033d8:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8033db:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033df:	75 17                	jne    8033f8 <free+0x615>
  8033e1:	83 ec 04             	sub    $0x4,%esp
  8033e4:	68 78 62 80 00       	push   $0x806278
  8033e9:	68 2a 01 00 00       	push   $0x12a
  8033ee:	68 2c 62 80 00       	push   $0x80622c
  8033f3:	e8 06 e2 ff ff       	call   8015fe <_panic>
  8033f8:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  8033fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803401:	89 50 0c             	mov    %edx,0xc(%eax)
  803404:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803407:	8b 40 0c             	mov    0xc(%eax),%eax
  80340a:	85 c0                	test   %eax,%eax
  80340c:	74 0d                	je     80341b <free+0x638>
  80340e:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803413:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803416:	89 50 08             	mov    %edx,0x8(%eax)
  803419:	eb 08                	jmp    803423 <free+0x640>
  80341b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80341e:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803423:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803426:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80342b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80342e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803435:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80343a:	40                   	inc    %eax
  80343b:	a3 0c f3 81 00       	mov    %eax,0x81f30c
  803440:	e9 1b 01 00 00       	jmp    803560 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  803445:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803448:	8b 50 04             	mov    0x4(%eax),%edx
  80344b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80344e:	8b 40 04             	mov    0x4(%eax),%eax
  803451:	39 c2                	cmp    %eax,%edx
  803453:	0f 83 81 00 00 00    	jae    8034da <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  803459:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80345d:	74 06                	je     803465 <free+0x682>
  80345f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803463:	75 17                	jne    80347c <free+0x699>
  803465:	83 ec 04             	sub    $0x4,%esp
  803468:	68 bc 62 80 00       	push   $0x8062bc
  80346d:	68 30 01 00 00       	push   $0x130
  803472:	68 2c 62 80 00       	push   $0x80622c
  803477:	e8 82 e1 ff ff       	call   8015fe <_panic>
  80347c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80347f:	8b 50 0c             	mov    0xc(%eax),%edx
  803482:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803485:	89 50 0c             	mov    %edx,0xc(%eax)
  803488:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80348e:	89 50 08             	mov    %edx,0x8(%eax)
  803491:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803494:	8b 40 0c             	mov    0xc(%eax),%eax
  803497:	85 c0                	test   %eax,%eax
  803499:	74 0e                	je     8034a9 <free+0x6c6>
  80349b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349e:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034a4:	89 50 08             	mov    %edx,0x8(%eax)
  8034a7:	eb 08                	jmp    8034b1 <free+0x6ce>
  8034a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ac:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8034b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034b7:	89 50 0c             	mov    %edx,0xc(%eax)
  8034ba:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8034bf:	40                   	inc    %eax
  8034c0:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  8034c5:	83 ec 0c             	sub    $0xc,%esp
  8034c8:	68 20 f3 81 00       	push   $0x81f320
  8034cd:	e8 ff 1c 00 00       	call   8051d1 <release_uspinlock>
  8034d2:	83 c4 10             	add    $0x10,%esp
							return;
  8034d5:	e9 97 00 00 00       	jmp    803571 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8034da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034dd:	8b 40 08             	mov    0x8(%eax),%eax
  8034e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  8034e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034e7:	0f 85 58 ff ff ff    	jne    803445 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8034ed:	83 ec 0c             	sub    $0xc,%esp
  8034f0:	ff 75 d0             	pushl  -0x30(%ebp)
  8034f3:	e8 b5 18 00 00       	call   804dad <free_block>
  8034f8:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8034fb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034ff:	75 17                	jne    803518 <free+0x735>
  803501:	83 ec 04             	sub    $0x4,%esp
  803504:	68 78 62 80 00       	push   $0x806278
  803509:	68 37 01 00 00       	push   $0x137
  80350e:	68 2c 62 80 00       	push   $0x80622c
  803513:	e8 e6 e0 ff ff       	call   8015fe <_panic>
  803518:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  80351e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803521:	89 50 0c             	mov    %edx,0xc(%eax)
  803524:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803527:	8b 40 0c             	mov    0xc(%eax),%eax
  80352a:	85 c0                	test   %eax,%eax
  80352c:	74 0d                	je     80353b <free+0x758>
  80352e:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803533:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803536:	89 50 08             	mov    %edx,0x8(%eax)
  803539:	eb 08                	jmp    803543 <free+0x760>
  80353b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353e:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803543:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803546:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80354b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803555:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80355a:	40                   	inc    %eax
  80355b:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			}
		release_uspinlock(&ulock);
  803560:	83 ec 0c             	sub    $0xc,%esp
  803563:	68 20 f3 81 00       	push   $0x81f320
  803568:	e8 64 1c 00 00       	call   8051d1 <release_uspinlock>
  80356d:	83 c4 10             	add    $0x10,%esp
		return;
  803570:	90                   	nop
}
  803571:	c9                   	leave  
  803572:	c3                   	ret    

00803573 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  803573:	55                   	push   %ebp
  803574:	89 e5                	mov    %esp,%ebp
  803576:	83 ec 48             	sub    $0x48,%esp
  803579:	8b 45 10             	mov    0x10(%ebp),%eax
  80357c:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80357f:	e8 2d f2 ff ff       	call   8027b1 <uheap_init>
	if (size == 0) return NULL;
  803584:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803588:	75 0a                	jne    803594 <smalloc+0x21>
  80358a:	b8 00 00 00 00       	mov    $0x0,%eax
  80358f:	e9 84 05 00 00       	jmp    803b18 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  803594:	83 ec 0c             	sub    $0xc,%esp
  803597:	68 20 f3 81 00       	push   $0x81f320
  80359c:	e8 d8 1b 00 00       	call   805179 <acquire_uspinlock>
  8035a1:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8035a4:	83 ec 0c             	sub    $0xc,%esp
  8035a7:	6a 10                	push   $0x10
  8035a9:	e8 63 13 00 00       	call   804911 <alloc_block>
  8035ae:	83 c4 10             	add    $0x10,%esp
  8035b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  8035b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035b8:	75 0a                	jne    8035c4 <smalloc+0x51>
				return NULL;
  8035ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8035bf:	e9 54 05 00 00       	jmp    803b18 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  8035c4:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8035cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d1:	01 d0                	add    %edx,%eax
  8035d3:	48                   	dec    %eax
  8035d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8035d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035da:	ba 00 00 00 00       	mov    $0x0,%edx
  8035df:	f7 75 e8             	divl   -0x18(%ebp)
  8035e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e5:	29 d0                	sub    %edx,%eax
  8035e7:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8035ea:	a1 04 f3 81 00       	mov    0x81f304,%eax
  8035ef:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8035f2:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8035f7:	85 c0                	test   %eax,%eax
  8035f9:	74 0f                	je     80360a <smalloc+0x97>
  8035fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035fe:	8b 40 04             	mov    0x4(%eax),%eax
  803601:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803604:	0f 83 25 01 00 00    	jae    80372f <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  80360a:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80360f:	2b 45 0c             	sub    0xc(%ebp),%eax
  803612:	89 c2                	mov    %eax,%edx
  803614:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803619:	39 c2                	cmp    %eax,%edx
  80361b:	0f 82 f4 00 00 00    	jb     803715 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  803621:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803626:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  803629:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80362f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803632:	01 d0                	add    %edx,%eax
  803634:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  803639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80363f:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803644:	8b 55 0c             	mov    0xc(%ebp),%edx
  803647:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80364a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80364e:	75 17                	jne    803667 <smalloc+0xf4>
  803650:	83 ec 04             	sub    $0x4,%esp
  803653:	68 78 62 80 00       	push   $0x806278
  803658:	68 57 01 00 00       	push   $0x157
  80365d:	68 2c 62 80 00       	push   $0x80622c
  803662:	e8 97 df ff ff       	call   8015fe <_panic>
  803667:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  80366d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803670:	89 50 0c             	mov    %edx,0xc(%eax)
  803673:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803676:	8b 40 0c             	mov    0xc(%eax),%eax
  803679:	85 c0                	test   %eax,%eax
  80367b:	74 0d                	je     80368a <smalloc+0x117>
  80367d:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803682:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803685:	89 50 08             	mov    %edx,0x8(%eax)
  803688:	eb 08                	jmp    803692 <smalloc+0x11f>
  80368a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80368d:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803692:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803695:	a3 14 f3 81 00       	mov    %eax,0x81f314
  80369a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80369d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8036a4:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  8036a9:	40                   	inc    %eax
  8036aa:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8036af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b2:	8b 00                	mov    (%eax),%eax
  8036b4:	89 c2                	mov    %eax,%edx
  8036b6:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8036ba:	52                   	push   %edx
  8036bb:	50                   	push   %eax
  8036bc:	ff 75 0c             	pushl  0xc(%ebp)
  8036bf:	ff 75 08             	pushl  0x8(%ebp)
  8036c2:	e8 48 0c 00 00       	call   80430f <sys_create_shared_object>
  8036c7:	83 c4 10             	add    $0x10,%esp
  8036ca:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  8036cd:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8036d1:	79 28                	jns    8036fb <smalloc+0x188>
							free_block(allocblock);
  8036d3:	83 ec 0c             	sub    $0xc,%esp
  8036d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8036d9:	e8 cf 16 00 00       	call   804dad <free_block>
  8036de:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8036e1:	83 ec 0c             	sub    $0xc,%esp
  8036e4:	68 20 f3 81 00       	push   $0x81f320
  8036e9:	e8 e3 1a 00 00       	call   8051d1 <release_uspinlock>
  8036ee:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8036f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f6:	e9 1d 04 00 00       	jmp    803b18 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  8036fb:	83 ec 0c             	sub    $0xc,%esp
  8036fe:	68 20 f3 81 00       	push   $0x81f320
  803703:	e8 c9 1a 00 00       	call   8051d1 <release_uspinlock>
  803708:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  80370b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80370e:	8b 00                	mov    (%eax),%eax
  803710:	e9 03 04 00 00       	jmp    803b18 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  803715:	83 ec 0c             	sub    $0xc,%esp
  803718:	68 20 f3 81 00       	push   $0x81f320
  80371d:	e8 af 1a 00 00       	call   8051d1 <release_uspinlock>
  803722:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803725:	b8 00 00 00 00       	mov    $0x0,%eax
  80372a:	e9 e9 03 00 00       	jmp    803b18 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80372f:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803734:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803737:	e9 af 03 00 00       	jmp    803aeb <smalloc+0x578>
				if(size<currentfreeelement->size){
  80373c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373f:	8b 40 04             	mov    0x4(%eax),%eax
  803742:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803745:	0f 86 28 02 00 00    	jbe    803973 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  80374b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80374e:	8b 10                	mov    (%eax),%edx
  803750:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803753:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  803755:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803758:	8b 55 0c             	mov    0xc(%ebp),%edx
  80375b:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  80375e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803762:	75 17                	jne    80377b <smalloc+0x208>
  803764:	83 ec 04             	sub    $0x4,%esp
  803767:	68 78 62 80 00       	push   $0x806278
  80376c:	68 6f 01 00 00       	push   $0x16f
  803771:	68 2c 62 80 00       	push   $0x80622c
  803776:	e8 83 de ff ff       	call   8015fe <_panic>
  80377b:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803784:	89 50 0c             	mov    %edx,0xc(%eax)
  803787:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80378a:	8b 40 0c             	mov    0xc(%eax),%eax
  80378d:	85 c0                	test   %eax,%eax
  80378f:	74 0d                	je     80379e <smalloc+0x22b>
  803791:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803796:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803799:	89 50 08             	mov    %edx,0x8(%eax)
  80379c:	eb 08                	jmp    8037a6 <smalloc+0x233>
  80379e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a1:	a3 10 f3 81 00       	mov    %eax,0x81f310
  8037a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a9:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8037ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037b8:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  8037bd:	40                   	inc    %eax
  8037be:	a3 1c f3 81 00       	mov    %eax,0x81f31c
	                lastfreeelement->startva += size;
  8037c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c6:	8b 10                	mov    (%eax),%edx
  8037c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037cb:	01 c2                	add    %eax,%edx
  8037cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d0:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  8037d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d5:	8b 40 04             	mov    0x4(%eax),%eax
  8037d8:	2b 45 0c             	sub    0xc(%ebp),%eax
  8037db:	89 c2                	mov    %eax,%edx
  8037dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e0:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8037e3:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8037e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  8037eb:	e9 13 01 00 00       	jmp    803903 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  8037f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f3:	8b 50 04             	mov    0x4(%eax),%edx
  8037f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f9:	8b 40 04             	mov    0x4(%eax),%eax
  8037fc:	39 c2                	cmp    %eax,%edx
  8037fe:	0f 83 f6 00 00 00    	jae    8038fa <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  803804:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803808:	75 17                	jne    803821 <smalloc+0x2ae>
  80380a:	83 ec 04             	sub    $0x4,%esp
  80380d:	68 9b 62 80 00       	push   $0x80629b
  803812:	68 77 01 00 00       	push   $0x177
  803817:	68 2c 62 80 00       	push   $0x80622c
  80381c:	e8 dd dd ff ff       	call   8015fe <_panic>
  803821:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803824:	8b 40 08             	mov    0x8(%eax),%eax
  803827:	85 c0                	test   %eax,%eax
  803829:	74 11                	je     80383c <smalloc+0x2c9>
  80382b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80382e:	8b 40 08             	mov    0x8(%eax),%eax
  803831:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803834:	8b 52 0c             	mov    0xc(%edx),%edx
  803837:	89 50 0c             	mov    %edx,0xc(%eax)
  80383a:	eb 0b                	jmp    803847 <smalloc+0x2d4>
  80383c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80383f:	8b 40 0c             	mov    0xc(%eax),%eax
  803842:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803847:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80384a:	8b 40 0c             	mov    0xc(%eax),%eax
  80384d:	85 c0                	test   %eax,%eax
  80384f:	74 11                	je     803862 <smalloc+0x2ef>
  803851:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803854:	8b 40 0c             	mov    0xc(%eax),%eax
  803857:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80385a:	8b 52 08             	mov    0x8(%edx),%edx
  80385d:	89 50 08             	mov    %edx,0x8(%eax)
  803860:	eb 0b                	jmp    80386d <smalloc+0x2fa>
  803862:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803865:	8b 40 08             	mov    0x8(%eax),%eax
  803868:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80386d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803870:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803877:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80387a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803881:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803886:	48                   	dec    %eax
  803887:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80388c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803890:	74 06                	je     803898 <smalloc+0x325>
  803892:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803896:	75 17                	jne    8038af <smalloc+0x33c>
  803898:	83 ec 04             	sub    $0x4,%esp
  80389b:	68 bc 62 80 00       	push   $0x8062bc
  8038a0:	68 78 01 00 00       	push   $0x178
  8038a5:	68 2c 62 80 00       	push   $0x80622c
  8038aa:	e8 4f dd ff ff       	call   8015fe <_panic>
  8038af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b2:	8b 50 0c             	mov    0xc(%eax),%edx
  8038b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b8:	89 50 0c             	mov    %edx,0xc(%eax)
  8038bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038c1:	89 50 08             	mov    %edx,0x8(%eax)
  8038c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8038ca:	85 c0                	test   %eax,%eax
  8038cc:	74 0e                	je     8038dc <smalloc+0x369>
  8038ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038d7:	89 50 08             	mov    %edx,0x8(%eax)
  8038da:	eb 08                	jmp    8038e4 <smalloc+0x371>
  8038dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038df:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8038e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038ea:	89 50 0c             	mov    %edx,0xc(%eax)
  8038ed:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8038f2:	40                   	inc    %eax
  8038f3:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		break;
  8038f8:	eb 13                	jmp    80390d <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  8038fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fd:	8b 40 08             	mov    0x8(%eax),%eax
  803900:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  803903:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803907:	0f 85 e3 fe ff ff    	jne    8037f0 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80390d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803910:	8b 00                	mov    (%eax),%eax
  803912:	89 c2                	mov    %eax,%edx
  803914:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803918:	52                   	push   %edx
  803919:	50                   	push   %eax
  80391a:	ff 75 0c             	pushl  0xc(%ebp)
  80391d:	ff 75 08             	pushl  0x8(%ebp)
  803920:	e8 ea 09 00 00       	call   80430f <sys_create_shared_object>
  803925:	83 c4 10             	add    $0x10,%esp
  803928:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  80392b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80392f:	79 28                	jns    803959 <smalloc+0x3e6>
	                	free_block(allocblock);
  803931:	83 ec 0c             	sub    $0xc,%esp
  803934:	ff 75 ec             	pushl  -0x14(%ebp)
  803937:	e8 71 14 00 00       	call   804dad <free_block>
  80393c:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  80393f:	83 ec 0c             	sub    $0xc,%esp
  803942:	68 20 f3 81 00       	push   $0x81f320
  803947:	e8 85 18 00 00       	call   8051d1 <release_uspinlock>
  80394c:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  80394f:	b8 00 00 00 00       	mov    $0x0,%eax
  803954:	e9 bf 01 00 00       	jmp    803b18 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  803959:	83 ec 0c             	sub    $0xc,%esp
  80395c:	68 20 f3 81 00       	push   $0x81f320
  803961:	e8 6b 18 00 00       	call   8051d1 <release_uspinlock>
  803966:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  803969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80396c:	8b 00                	mov    (%eax),%eax
  80396e:	e9 a5 01 00 00       	jmp    803b18 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  803973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803976:	8b 40 04             	mov    0x4(%eax),%eax
  803979:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80397c:	0f 85 60 01 00 00    	jne    803ae2 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  803982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803985:	8b 10                	mov    (%eax),%edx
  803987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80398a:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80398c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80398f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803992:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803995:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803999:	75 17                	jne    8039b2 <smalloc+0x43f>
  80399b:	83 ec 04             	sub    $0x4,%esp
  80399e:	68 78 62 80 00       	push   $0x806278
  8039a3:	68 8c 01 00 00       	push   $0x18c
  8039a8:	68 2c 62 80 00       	push   $0x80622c
  8039ad:	e8 4c dc ff ff       	call   8015fe <_panic>
  8039b2:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8039b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039bb:	89 50 0c             	mov    %edx,0xc(%eax)
  8039be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8039c4:	85 c0                	test   %eax,%eax
  8039c6:	74 0d                	je     8039d5 <smalloc+0x462>
  8039c8:	a1 14 f3 81 00       	mov    0x81f314,%eax
  8039cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039d0:	89 50 08             	mov    %edx,0x8(%eax)
  8039d3:	eb 08                	jmp    8039dd <smalloc+0x46a>
  8039d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039d8:	a3 10 f3 81 00       	mov    %eax,0x81f310
  8039dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039e0:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8039e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8039ef:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  8039f4:	40                   	inc    %eax
  8039f5:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8039fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039fe:	75 17                	jne    803a17 <smalloc+0x4a4>
  803a00:	83 ec 04             	sub    $0x4,%esp
  803a03:	68 9b 62 80 00       	push   $0x80629b
  803a08:	68 8d 01 00 00       	push   $0x18d
  803a0d:	68 2c 62 80 00       	push   $0x80622c
  803a12:	e8 e7 db ff ff       	call   8015fe <_panic>
  803a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1a:	8b 40 08             	mov    0x8(%eax),%eax
  803a1d:	85 c0                	test   %eax,%eax
  803a1f:	74 11                	je     803a32 <smalloc+0x4bf>
  803a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a24:	8b 40 08             	mov    0x8(%eax),%eax
  803a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a2a:	8b 52 0c             	mov    0xc(%edx),%edx
  803a2d:	89 50 0c             	mov    %edx,0xc(%eax)
  803a30:	eb 0b                	jmp    803a3d <smalloc+0x4ca>
  803a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a35:	8b 40 0c             	mov    0xc(%eax),%eax
  803a38:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a40:	8b 40 0c             	mov    0xc(%eax),%eax
  803a43:	85 c0                	test   %eax,%eax
  803a45:	74 11                	je     803a58 <smalloc+0x4e5>
  803a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4a:	8b 40 0c             	mov    0xc(%eax),%eax
  803a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a50:	8b 52 08             	mov    0x8(%edx),%edx
  803a53:	89 50 08             	mov    %edx,0x8(%eax)
  803a56:	eb 0b                	jmp    803a63 <smalloc+0x4f0>
  803a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5b:	8b 40 08             	mov    0x8(%eax),%eax
  803a5e:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803a77:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803a7c:	48                   	dec    %eax
  803a7d:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803a82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a85:	8b 00                	mov    (%eax),%eax
  803a87:	89 c2                	mov    %eax,%edx
  803a89:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803a8d:	52                   	push   %edx
  803a8e:	50                   	push   %eax
  803a8f:	ff 75 0c             	pushl  0xc(%ebp)
  803a92:	ff 75 08             	pushl  0x8(%ebp)
  803a95:	e8 75 08 00 00       	call   80430f <sys_create_shared_object>
  803a9a:	83 c4 10             	add    $0x10,%esp
  803a9d:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  803aa0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803aa4:	79 25                	jns    803acb <smalloc+0x558>
						free_block(allocblock);
  803aa6:	83 ec 0c             	sub    $0xc,%esp
  803aa9:	ff 75 ec             	pushl  -0x14(%ebp)
  803aac:	e8 fc 12 00 00       	call   804dad <free_block>
  803ab1:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803ab4:	83 ec 0c             	sub    $0xc,%esp
  803ab7:	68 20 f3 81 00       	push   $0x81f320
  803abc:	e8 10 17 00 00       	call   8051d1 <release_uspinlock>
  803ac1:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803ac4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac9:	eb 4d                	jmp    803b18 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  803acb:	83 ec 0c             	sub    $0xc,%esp
  803ace:	68 20 f3 81 00       	push   $0x81f320
  803ad3:	e8 f9 16 00 00       	call   8051d1 <release_uspinlock>
  803ad8:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ade:	8b 00                	mov    (%eax),%eax
  803ae0:	eb 36                	jmp    803b18 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae5:	8b 40 08             	mov    0x8(%eax),%eax
  803ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aef:	0f 85 47 fc ff ff    	jne    80373c <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  803af5:	83 ec 0c             	sub    $0xc,%esp
  803af8:	ff 75 ec             	pushl  -0x14(%ebp)
  803afb:	e8 ad 12 00 00       	call   804dad <free_block>
  803b00:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803b03:	83 ec 0c             	sub    $0xc,%esp
  803b06:	68 20 f3 81 00       	push   $0x81f320
  803b0b:	e8 c1 16 00 00       	call   8051d1 <release_uspinlock>
  803b10:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b18:	c9                   	leave  
  803b19:	c3                   	ret    

00803b1a <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  803b1a:	55                   	push   %ebp
  803b1b:	89 e5                	mov    %esp,%ebp
  803b1d:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  803b20:	e8 8c ec ff ff       	call   8027b1 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  803b25:	83 ec 0c             	sub    $0xc,%esp
  803b28:	68 20 f3 81 00       	push   $0x81f320
  803b2d:	e8 47 16 00 00       	call   805179 <acquire_uspinlock>
  803b32:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  803b35:	83 ec 08             	sub    $0x8,%esp
  803b38:	ff 75 0c             	pushl  0xc(%ebp)
  803b3b:	ff 75 08             	pushl  0x8(%ebp)
  803b3e:	e8 f6 07 00 00       	call   804339 <sys_size_of_shared_object>
  803b43:	83 c4 10             	add    $0x10,%esp
  803b46:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  803b49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b4d:	79 1a                	jns    803b69 <sget+0x4f>
			release_uspinlock(&ulock);
  803b4f:	83 ec 0c             	sub    $0xc,%esp
  803b52:	68 20 f3 81 00       	push   $0x81f320
  803b57:	e8 75 16 00 00       	call   8051d1 <release_uspinlock>
  803b5c:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b64:	e9 6e 05 00 00       	jmp    8040d7 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  803b69:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803b70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b76:	01 d0                	add    %edx,%eax
  803b78:	48                   	dec    %eax
  803b79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  803b84:	f7 75 e8             	divl   -0x18(%ebp)
  803b87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b8a:	29 d0                	sub    %edx,%eax
  803b8c:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803b8f:	83 ec 0c             	sub    $0xc,%esp
  803b92:	6a 10                	push   $0x10
  803b94:	e8 78 0d 00 00       	call   804911 <alloc_block>
  803b99:	83 c4 10             	add    $0x10,%esp
  803b9c:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  803b9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803ba3:	75 0a                	jne    803baf <sget+0x95>
			return NULL;
  803ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  803baa:	e9 28 05 00 00       	jmp    8040d7 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803baf:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803bb4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  803bb7:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803bbc:	85 c0                	test   %eax,%eax
  803bbe:	74 11                	je     803bd1 <sget+0xb7>
  803bc0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bc3:	8b 50 04             	mov    0x4(%eax),%edx
  803bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bc9:	39 c2                	cmp    %eax,%edx
  803bcb:	0f 83 21 01 00 00    	jae    803cf2 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  803bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd4:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  803bd9:	29 c2                	sub    %eax,%edx
  803bdb:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803be0:	39 c2                	cmp    %eax,%edx
  803be2:	0f 82 f0 00 00 00    	jb     803cd8 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  803be8:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803bed:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  803bf0:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803bf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bf9:	01 d0                	add    %edx,%eax
  803bfb:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  803c00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c03:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803c06:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803c08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c0e:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  803c11:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c15:	75 17                	jne    803c2e <sget+0x114>
  803c17:	83 ec 04             	sub    $0x4,%esp
  803c1a:	68 78 62 80 00       	push   $0x806278
  803c1f:	68 c8 01 00 00       	push   $0x1c8
  803c24:	68 2c 62 80 00       	push   $0x80622c
  803c29:	e8 d0 d9 ff ff       	call   8015fe <_panic>
  803c2e:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803c34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c37:	89 50 0c             	mov    %edx,0xc(%eax)
  803c3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  803c40:	85 c0                	test   %eax,%eax
  803c42:	74 0d                	je     803c51 <sget+0x137>
  803c44:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803c49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c4c:	89 50 08             	mov    %edx,0x8(%eax)
  803c4f:	eb 08                	jmp    803c59 <sget+0x13f>
  803c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c54:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c5c:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c64:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803c6b:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803c70:	40                   	inc    %eax
  803c71:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803c76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c79:	8b 00                	mov    (%eax),%eax
  803c7b:	83 ec 04             	sub    $0x4,%esp
  803c7e:	50                   	push   %eax
  803c7f:	ff 75 0c             	pushl  0xc(%ebp)
  803c82:	ff 75 08             	pushl  0x8(%ebp)
  803c85:	e8 cc 06 00 00       	call   804356 <sys_get_shared_object>
  803c8a:	83 c4 10             	add    $0x10,%esp
  803c8d:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  803c90:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803c94:	79 28                	jns    803cbe <sget+0x1a4>
							free_block(allocblock);
  803c96:	83 ec 0c             	sub    $0xc,%esp
  803c99:	ff 75 e0             	pushl  -0x20(%ebp)
  803c9c:	e8 0c 11 00 00       	call   804dad <free_block>
  803ca1:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803ca4:	83 ec 0c             	sub    $0xc,%esp
  803ca7:	68 20 f3 81 00       	push   $0x81f320
  803cac:	e8 20 15 00 00       	call   8051d1 <release_uspinlock>
  803cb1:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb9:	e9 19 04 00 00       	jmp    8040d7 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  803cbe:	83 ec 0c             	sub    $0xc,%esp
  803cc1:	68 20 f3 81 00       	push   $0x81f320
  803cc6:	e8 06 15 00 00       	call   8051d1 <release_uspinlock>
  803ccb:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803cce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cd1:	8b 00                	mov    (%eax),%eax
  803cd3:	e9 ff 03 00 00       	jmp    8040d7 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  803cd8:	83 ec 0c             	sub    $0xc,%esp
  803cdb:	68 20 f3 81 00       	push   $0x81f320
  803ce0:	e8 ec 14 00 00       	call   8051d1 <release_uspinlock>
  803ce5:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ced:	e9 e5 03 00 00       	jmp    8040d7 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803cf2:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803cfa:	e9 ab 03 00 00       	jmp    8040aa <sget+0x590>
				if(size<currentfreeelement->size){
  803cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d02:	8b 50 04             	mov    0x4(%eax),%edx
  803d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d08:	39 c2                	cmp    %eax,%edx
  803d0a:	0f 86 24 02 00 00    	jbe    803f34 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  803d10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d13:	8b 10                	mov    (%eax),%edx
  803d15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d18:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803d1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d20:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803d23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d27:	75 17                	jne    803d40 <sget+0x226>
  803d29:	83 ec 04             	sub    $0x4,%esp
  803d2c:	68 78 62 80 00       	push   $0x806278
  803d31:	68 e0 01 00 00       	push   $0x1e0
  803d36:	68 2c 62 80 00       	push   $0x80622c
  803d3b:	e8 be d8 ff ff       	call   8015fe <_panic>
  803d40:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803d46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d49:	89 50 0c             	mov    %edx,0xc(%eax)
  803d4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d4f:	8b 40 0c             	mov    0xc(%eax),%eax
  803d52:	85 c0                	test   %eax,%eax
  803d54:	74 0d                	je     803d63 <sget+0x249>
  803d56:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803d5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d5e:	89 50 08             	mov    %edx,0x8(%eax)
  803d61:	eb 08                	jmp    803d6b <sget+0x251>
  803d63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d66:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803d6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d6e:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803d73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803d7d:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803d82:	40                   	inc    %eax
  803d83:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					lastfreeelement->startva += size;
  803d88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d8b:	8b 10                	mov    (%eax),%edx
  803d8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d90:	01 c2                	add    %eax,%edx
  803d92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d95:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  803d97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d9a:	8b 50 04             	mov    0x4(%eax),%edx
  803d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803da0:	29 c2                	sub    %eax,%edx
  803da2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803da5:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803da8:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  803db0:	e9 13 01 00 00       	jmp    803ec8 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  803db5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803db8:	8b 50 04             	mov    0x4(%eax),%edx
  803dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbe:	8b 40 04             	mov    0x4(%eax),%eax
  803dc1:	39 c2                	cmp    %eax,%edx
  803dc3:	0f 83 f6 00 00 00    	jae    803ebf <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  803dc9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803dcd:	75 17                	jne    803de6 <sget+0x2cc>
  803dcf:	83 ec 04             	sub    $0x4,%esp
  803dd2:	68 9b 62 80 00       	push   $0x80629b
  803dd7:	68 e8 01 00 00       	push   $0x1e8
  803ddc:	68 2c 62 80 00       	push   $0x80622c
  803de1:	e8 18 d8 ff ff       	call   8015fe <_panic>
  803de6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803de9:	8b 40 08             	mov    0x8(%eax),%eax
  803dec:	85 c0                	test   %eax,%eax
  803dee:	74 11                	je     803e01 <sget+0x2e7>
  803df0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803df3:	8b 40 08             	mov    0x8(%eax),%eax
  803df6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803df9:	8b 52 0c             	mov    0xc(%edx),%edx
  803dfc:	89 50 0c             	mov    %edx,0xc(%eax)
  803dff:	eb 0b                	jmp    803e0c <sget+0x2f2>
  803e01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e04:	8b 40 0c             	mov    0xc(%eax),%eax
  803e07:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803e0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  803e12:	85 c0                	test   %eax,%eax
  803e14:	74 11                	je     803e27 <sget+0x30d>
  803e16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e19:	8b 40 0c             	mov    0xc(%eax),%eax
  803e1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e1f:	8b 52 08             	mov    0x8(%edx),%edx
  803e22:	89 50 08             	mov    %edx,0x8(%eax)
  803e25:	eb 0b                	jmp    803e32 <sget+0x318>
  803e27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e2a:	8b 40 08             	mov    0x8(%eax),%eax
  803e2d:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803e32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803e3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803e46:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803e4b:	48                   	dec    %eax
  803e4c:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803e51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e55:	74 06                	je     803e5d <sget+0x343>
  803e57:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e5b:	75 17                	jne    803e74 <sget+0x35a>
  803e5d:	83 ec 04             	sub    $0x4,%esp
  803e60:	68 bc 62 80 00       	push   $0x8062bc
  803e65:	68 e9 01 00 00       	push   $0x1e9
  803e6a:	68 2c 62 80 00       	push   $0x80622c
  803e6f:	e8 8a d7 ff ff       	call   8015fe <_panic>
  803e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e77:	8b 50 0c             	mov    0xc(%eax),%edx
  803e7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e7d:	89 50 0c             	mov    %edx,0xc(%eax)
  803e80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e86:	89 50 08             	mov    %edx,0x8(%eax)
  803e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  803e8f:	85 c0                	test   %eax,%eax
  803e91:	74 0e                	je     803ea1 <sget+0x387>
  803e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e96:	8b 40 0c             	mov    0xc(%eax),%eax
  803e99:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e9c:	89 50 08             	mov    %edx,0x8(%eax)
  803e9f:	eb 08                	jmp    803ea9 <sget+0x38f>
  803ea1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ea4:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803eaf:	89 50 0c             	mov    %edx,0xc(%eax)
  803eb2:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803eb7:	40                   	inc    %eax
  803eb8:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							break;
  803ebd:	eb 13                	jmp    803ed2 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  803ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ec2:	8b 40 08             	mov    0x8(%eax),%eax
  803ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  803ec8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ecc:	0f 85 e3 fe ff ff    	jne    803db5 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803ed2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ed5:	8b 00                	mov    (%eax),%eax
  803ed7:	83 ec 04             	sub    $0x4,%esp
  803eda:	50                   	push   %eax
  803edb:	ff 75 0c             	pushl  0xc(%ebp)
  803ede:	ff 75 08             	pushl  0x8(%ebp)
  803ee1:	e8 70 04 00 00       	call   804356 <sys_get_shared_object>
  803ee6:	83 c4 10             	add    $0x10,%esp
  803ee9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  803eec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ef0:	79 28                	jns    803f1a <sget+0x400>
						free_block(allocblock);
  803ef2:	83 ec 0c             	sub    $0xc,%esp
  803ef5:	ff 75 e0             	pushl  -0x20(%ebp)
  803ef8:	e8 b0 0e 00 00       	call   804dad <free_block>
  803efd:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803f00:	83 ec 0c             	sub    $0xc,%esp
  803f03:	68 20 f3 81 00       	push   $0x81f320
  803f08:	e8 c4 12 00 00       	call   8051d1 <release_uspinlock>
  803f0d:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803f10:	b8 00 00 00 00       	mov    $0x0,%eax
  803f15:	e9 bd 01 00 00       	jmp    8040d7 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  803f1a:	83 ec 0c             	sub    $0xc,%esp
  803f1d:	68 20 f3 81 00       	push   $0x81f320
  803f22:	e8 aa 12 00 00       	call   8051d1 <release_uspinlock>
  803f27:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803f2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f2d:	8b 00                	mov    (%eax),%eax
  803f2f:	e9 a3 01 00 00       	jmp    8040d7 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  803f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f37:	8b 50 04             	mov    0x4(%eax),%edx
  803f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f3d:	39 c2                	cmp    %eax,%edx
  803f3f:	0f 85 5c 01 00 00    	jne    8040a1 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  803f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f48:	8b 10                	mov    (%eax),%edx
  803f4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f4d:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803f4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f55:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803f58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803f5c:	75 17                	jne    803f75 <sget+0x45b>
  803f5e:	83 ec 04             	sub    $0x4,%esp
  803f61:	68 78 62 80 00       	push   $0x806278
  803f66:	68 fe 01 00 00       	push   $0x1fe
  803f6b:	68 2c 62 80 00       	push   $0x80622c
  803f70:	e8 89 d6 ff ff       	call   8015fe <_panic>
  803f75:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803f7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f7e:	89 50 0c             	mov    %edx,0xc(%eax)
  803f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f84:	8b 40 0c             	mov    0xc(%eax),%eax
  803f87:	85 c0                	test   %eax,%eax
  803f89:	74 0d                	je     803f98 <sget+0x47e>
  803f8b:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803f90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f93:	89 50 08             	mov    %edx,0x8(%eax)
  803f96:	eb 08                	jmp    803fa0 <sget+0x486>
  803f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f9b:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803fa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fa3:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803fb2:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803fb7:	40                   	inc    %eax
  803fb8:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803fbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fc1:	75 17                	jne    803fda <sget+0x4c0>
  803fc3:	83 ec 04             	sub    $0x4,%esp
  803fc6:	68 9b 62 80 00       	push   $0x80629b
  803fcb:	68 ff 01 00 00       	push   $0x1ff
  803fd0:	68 2c 62 80 00       	push   $0x80622c
  803fd5:	e8 24 d6 ff ff       	call   8015fe <_panic>
  803fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fdd:	8b 40 08             	mov    0x8(%eax),%eax
  803fe0:	85 c0                	test   %eax,%eax
  803fe2:	74 11                	je     803ff5 <sget+0x4db>
  803fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe7:	8b 40 08             	mov    0x8(%eax),%eax
  803fea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fed:	8b 52 0c             	mov    0xc(%edx),%edx
  803ff0:	89 50 0c             	mov    %edx,0xc(%eax)
  803ff3:	eb 0b                	jmp    804000 <sget+0x4e6>
  803ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ff8:	8b 40 0c             	mov    0xc(%eax),%eax
  803ffb:	a3 04 f3 81 00       	mov    %eax,0x81f304
  804000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804003:	8b 40 0c             	mov    0xc(%eax),%eax
  804006:	85 c0                	test   %eax,%eax
  804008:	74 11                	je     80401b <sget+0x501>
  80400a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80400d:	8b 40 0c             	mov    0xc(%eax),%eax
  804010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804013:	8b 52 08             	mov    0x8(%edx),%edx
  804016:	89 50 08             	mov    %edx,0x8(%eax)
  804019:	eb 0b                	jmp    804026 <sget+0x50c>
  80401b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80401e:	8b 40 08             	mov    0x8(%eax),%eax
  804021:	a3 00 f3 81 00       	mov    %eax,0x81f300
  804026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804029:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  804030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804033:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80403a:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80403f:	48                   	dec    %eax
  804040:	a3 0c f3 81 00       	mov    %eax,0x81f30c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  804045:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804048:	8b 00                	mov    (%eax),%eax
  80404a:	83 ec 04             	sub    $0x4,%esp
  80404d:	50                   	push   %eax
  80404e:	ff 75 0c             	pushl  0xc(%ebp)
  804051:	ff 75 08             	pushl  0x8(%ebp)
  804054:	e8 fd 02 00 00       	call   804356 <sys_get_shared_object>
  804059:	83 c4 10             	add    $0x10,%esp
  80405c:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  80405f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  804063:	79 25                	jns    80408a <sget+0x570>
						free_block(allocblock);
  804065:	83 ec 0c             	sub    $0xc,%esp
  804068:	ff 75 e0             	pushl  -0x20(%ebp)
  80406b:	e8 3d 0d 00 00       	call   804dad <free_block>
  804070:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  804073:	83 ec 0c             	sub    $0xc,%esp
  804076:	68 20 f3 81 00       	push   $0x81f320
  80407b:	e8 51 11 00 00       	call   8051d1 <release_uspinlock>
  804080:	83 c4 10             	add    $0x10,%esp
						return NULL;
  804083:	b8 00 00 00 00       	mov    $0x0,%eax
  804088:	eb 4d                	jmp    8040d7 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  80408a:	83 ec 0c             	sub    $0xc,%esp
  80408d:	68 20 f3 81 00       	push   $0x81f320
  804092:	e8 3a 11 00 00       	call   8051d1 <release_uspinlock>
  804097:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80409a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80409d:	8b 00                	mov    (%eax),%eax
  80409f:	eb 36                	jmp    8040d7 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8040a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a4:	8b 40 08             	mov    0x8(%eax),%eax
  8040a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8040aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040ae:	0f 85 4b fc ff ff    	jne    803cff <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8040b4:	83 ec 0c             	sub    $0xc,%esp
  8040b7:	ff 75 e0             	pushl  -0x20(%ebp)
  8040ba:	e8 ee 0c 00 00       	call   804dad <free_block>
  8040bf:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8040c2:	83 ec 0c             	sub    $0xc,%esp
  8040c5:	68 20 f3 81 00       	push   $0x81f320
  8040ca:	e8 02 11 00 00       	call   8051d1 <release_uspinlock>
  8040cf:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8040d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040d7:	c9                   	leave  
  8040d8:	c3                   	ret    

008040d9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8040d9:	55                   	push   %ebp
  8040da:	89 e5                	mov    %esp,%ebp
  8040dc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8040df:	e8 cd e6 ff ff       	call   8027b1 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8040e4:	83 ec 04             	sub    $0x4,%esp
  8040e7:	68 4c 63 80 00       	push   $0x80634c
  8040ec:	68 2d 02 00 00       	push   $0x22d
  8040f1:	68 2c 62 80 00       	push   $0x80622c
  8040f6:	e8 03 d5 ff ff       	call   8015fe <_panic>

008040fb <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8040fb:	55                   	push   %ebp
  8040fc:	89 e5                	mov    %esp,%ebp
  8040fe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  804101:	83 ec 04             	sub    $0x4,%esp
  804104:	68 74 63 80 00       	push   $0x806374
  804109:	68 40 02 00 00       	push   $0x240
  80410e:	68 2c 62 80 00       	push   $0x80622c
  804113:	e8 e6 d4 ff ff       	call   8015fe <_panic>

00804118 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  804118:	55                   	push   %ebp
  804119:	89 e5                	mov    %esp,%ebp
  80411b:	57                   	push   %edi
  80411c:	56                   	push   %esi
  80411d:	53                   	push   %ebx
  80411e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  804121:	8b 45 08             	mov    0x8(%ebp),%eax
  804124:	8b 55 0c             	mov    0xc(%ebp),%edx
  804127:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80412a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80412d:	8b 7d 18             	mov    0x18(%ebp),%edi
  804130:	8b 75 1c             	mov    0x1c(%ebp),%esi
  804133:	cd 30                	int    $0x30
  804135:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  804138:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80413b:	83 c4 10             	add    $0x10,%esp
  80413e:	5b                   	pop    %ebx
  80413f:	5e                   	pop    %esi
  804140:	5f                   	pop    %edi
  804141:	5d                   	pop    %ebp
  804142:	c3                   	ret    

00804143 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  804143:	55                   	push   %ebp
  804144:	89 e5                	mov    %esp,%ebp
  804146:	83 ec 04             	sub    $0x4,%esp
  804149:	8b 45 10             	mov    0x10(%ebp),%eax
  80414c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80414f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  804152:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  804156:	8b 45 08             	mov    0x8(%ebp),%eax
  804159:	6a 00                	push   $0x0
  80415b:	51                   	push   %ecx
  80415c:	52                   	push   %edx
  80415d:	ff 75 0c             	pushl  0xc(%ebp)
  804160:	50                   	push   %eax
  804161:	6a 00                	push   $0x0
  804163:	e8 b0 ff ff ff       	call   804118 <syscall>
  804168:	83 c4 18             	add    $0x18,%esp
}
  80416b:	90                   	nop
  80416c:	c9                   	leave  
  80416d:	c3                   	ret    

0080416e <sys_cgetc>:

int
sys_cgetc(void)
{
  80416e:	55                   	push   %ebp
  80416f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  804171:	6a 00                	push   $0x0
  804173:	6a 00                	push   $0x0
  804175:	6a 00                	push   $0x0
  804177:	6a 00                	push   $0x0
  804179:	6a 00                	push   $0x0
  80417b:	6a 02                	push   $0x2
  80417d:	e8 96 ff ff ff       	call   804118 <syscall>
  804182:	83 c4 18             	add    $0x18,%esp
}
  804185:	c9                   	leave  
  804186:	c3                   	ret    

00804187 <sys_lock_cons>:

void sys_lock_cons(void)
{
  804187:	55                   	push   %ebp
  804188:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80418a:	6a 00                	push   $0x0
  80418c:	6a 00                	push   $0x0
  80418e:	6a 00                	push   $0x0
  804190:	6a 00                	push   $0x0
  804192:	6a 00                	push   $0x0
  804194:	6a 03                	push   $0x3
  804196:	e8 7d ff ff ff       	call   804118 <syscall>
  80419b:	83 c4 18             	add    $0x18,%esp
}
  80419e:	90                   	nop
  80419f:	c9                   	leave  
  8041a0:	c3                   	ret    

008041a1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8041a1:	55                   	push   %ebp
  8041a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8041a4:	6a 00                	push   $0x0
  8041a6:	6a 00                	push   $0x0
  8041a8:	6a 00                	push   $0x0
  8041aa:	6a 00                	push   $0x0
  8041ac:	6a 00                	push   $0x0
  8041ae:	6a 04                	push   $0x4
  8041b0:	e8 63 ff ff ff       	call   804118 <syscall>
  8041b5:	83 c4 18             	add    $0x18,%esp
}
  8041b8:	90                   	nop
  8041b9:	c9                   	leave  
  8041ba:	c3                   	ret    

008041bb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8041bb:	55                   	push   %ebp
  8041bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8041be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8041c4:	6a 00                	push   $0x0
  8041c6:	6a 00                	push   $0x0
  8041c8:	6a 00                	push   $0x0
  8041ca:	52                   	push   %edx
  8041cb:	50                   	push   %eax
  8041cc:	6a 08                	push   $0x8
  8041ce:	e8 45 ff ff ff       	call   804118 <syscall>
  8041d3:	83 c4 18             	add    $0x18,%esp
}
  8041d6:	c9                   	leave  
  8041d7:	c3                   	ret    

008041d8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8041d8:	55                   	push   %ebp
  8041d9:	89 e5                	mov    %esp,%ebp
  8041db:	56                   	push   %esi
  8041dc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8041dd:	8b 75 18             	mov    0x18(%ebp),%esi
  8041e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8041e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8041e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ec:	56                   	push   %esi
  8041ed:	53                   	push   %ebx
  8041ee:	51                   	push   %ecx
  8041ef:	52                   	push   %edx
  8041f0:	50                   	push   %eax
  8041f1:	6a 09                	push   $0x9
  8041f3:	e8 20 ff ff ff       	call   804118 <syscall>
  8041f8:	83 c4 18             	add    $0x18,%esp
}
  8041fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8041fe:	5b                   	pop    %ebx
  8041ff:	5e                   	pop    %esi
  804200:	5d                   	pop    %ebp
  804201:	c3                   	ret    

00804202 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  804202:	55                   	push   %ebp
  804203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  804205:	6a 00                	push   $0x0
  804207:	6a 00                	push   $0x0
  804209:	6a 00                	push   $0x0
  80420b:	6a 00                	push   $0x0
  80420d:	ff 75 08             	pushl  0x8(%ebp)
  804210:	6a 0a                	push   $0xa
  804212:	e8 01 ff ff ff       	call   804118 <syscall>
  804217:	83 c4 18             	add    $0x18,%esp
}
  80421a:	c9                   	leave  
  80421b:	c3                   	ret    

0080421c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80421c:	55                   	push   %ebp
  80421d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80421f:	6a 00                	push   $0x0
  804221:	6a 00                	push   $0x0
  804223:	6a 00                	push   $0x0
  804225:	ff 75 0c             	pushl  0xc(%ebp)
  804228:	ff 75 08             	pushl  0x8(%ebp)
  80422b:	6a 0b                	push   $0xb
  80422d:	e8 e6 fe ff ff       	call   804118 <syscall>
  804232:	83 c4 18             	add    $0x18,%esp
}
  804235:	c9                   	leave  
  804236:	c3                   	ret    

00804237 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  804237:	55                   	push   %ebp
  804238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80423a:	6a 00                	push   $0x0
  80423c:	6a 00                	push   $0x0
  80423e:	6a 00                	push   $0x0
  804240:	6a 00                	push   $0x0
  804242:	6a 00                	push   $0x0
  804244:	6a 0c                	push   $0xc
  804246:	e8 cd fe ff ff       	call   804118 <syscall>
  80424b:	83 c4 18             	add    $0x18,%esp
}
  80424e:	c9                   	leave  
  80424f:	c3                   	ret    

00804250 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  804250:	55                   	push   %ebp
  804251:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  804253:	6a 00                	push   $0x0
  804255:	6a 00                	push   $0x0
  804257:	6a 00                	push   $0x0
  804259:	6a 00                	push   $0x0
  80425b:	6a 00                	push   $0x0
  80425d:	6a 0d                	push   $0xd
  80425f:	e8 b4 fe ff ff       	call   804118 <syscall>
  804264:	83 c4 18             	add    $0x18,%esp
}
  804267:	c9                   	leave  
  804268:	c3                   	ret    

00804269 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  804269:	55                   	push   %ebp
  80426a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80426c:	6a 00                	push   $0x0
  80426e:	6a 00                	push   $0x0
  804270:	6a 00                	push   $0x0
  804272:	6a 00                	push   $0x0
  804274:	6a 00                	push   $0x0
  804276:	6a 0e                	push   $0xe
  804278:	e8 9b fe ff ff       	call   804118 <syscall>
  80427d:	83 c4 18             	add    $0x18,%esp
}
  804280:	c9                   	leave  
  804281:	c3                   	ret    

00804282 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  804282:	55                   	push   %ebp
  804283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  804285:	6a 00                	push   $0x0
  804287:	6a 00                	push   $0x0
  804289:	6a 00                	push   $0x0
  80428b:	6a 00                	push   $0x0
  80428d:	6a 00                	push   $0x0
  80428f:	6a 0f                	push   $0xf
  804291:	e8 82 fe ff ff       	call   804118 <syscall>
  804296:	83 c4 18             	add    $0x18,%esp
}
  804299:	c9                   	leave  
  80429a:	c3                   	ret    

0080429b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80429b:	55                   	push   %ebp
  80429c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80429e:	6a 00                	push   $0x0
  8042a0:	6a 00                	push   $0x0
  8042a2:	6a 00                	push   $0x0
  8042a4:	6a 00                	push   $0x0
  8042a6:	ff 75 08             	pushl  0x8(%ebp)
  8042a9:	6a 10                	push   $0x10
  8042ab:	e8 68 fe ff ff       	call   804118 <syscall>
  8042b0:	83 c4 18             	add    $0x18,%esp
}
  8042b3:	c9                   	leave  
  8042b4:	c3                   	ret    

008042b5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8042b5:	55                   	push   %ebp
  8042b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8042b8:	6a 00                	push   $0x0
  8042ba:	6a 00                	push   $0x0
  8042bc:	6a 00                	push   $0x0
  8042be:	6a 00                	push   $0x0
  8042c0:	6a 00                	push   $0x0
  8042c2:	6a 11                	push   $0x11
  8042c4:	e8 4f fe ff ff       	call   804118 <syscall>
  8042c9:	83 c4 18             	add    $0x18,%esp
}
  8042cc:	90                   	nop
  8042cd:	c9                   	leave  
  8042ce:	c3                   	ret    

008042cf <sys_cputc>:

void
sys_cputc(const char c)
{
  8042cf:	55                   	push   %ebp
  8042d0:	89 e5                	mov    %esp,%ebp
  8042d2:	83 ec 04             	sub    $0x4,%esp
  8042d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8042d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8042db:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8042df:	6a 00                	push   $0x0
  8042e1:	6a 00                	push   $0x0
  8042e3:	6a 00                	push   $0x0
  8042e5:	6a 00                	push   $0x0
  8042e7:	50                   	push   %eax
  8042e8:	6a 01                	push   $0x1
  8042ea:	e8 29 fe ff ff       	call   804118 <syscall>
  8042ef:	83 c4 18             	add    $0x18,%esp
}
  8042f2:	90                   	nop
  8042f3:	c9                   	leave  
  8042f4:	c3                   	ret    

008042f5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8042f5:	55                   	push   %ebp
  8042f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8042f8:	6a 00                	push   $0x0
  8042fa:	6a 00                	push   $0x0
  8042fc:	6a 00                	push   $0x0
  8042fe:	6a 00                	push   $0x0
  804300:	6a 00                	push   $0x0
  804302:	6a 14                	push   $0x14
  804304:	e8 0f fe ff ff       	call   804118 <syscall>
  804309:	83 c4 18             	add    $0x18,%esp
}
  80430c:	90                   	nop
  80430d:	c9                   	leave  
  80430e:	c3                   	ret    

0080430f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80430f:	55                   	push   %ebp
  804310:	89 e5                	mov    %esp,%ebp
  804312:	83 ec 04             	sub    $0x4,%esp
  804315:	8b 45 10             	mov    0x10(%ebp),%eax
  804318:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80431b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80431e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  804322:	8b 45 08             	mov    0x8(%ebp),%eax
  804325:	6a 00                	push   $0x0
  804327:	51                   	push   %ecx
  804328:	52                   	push   %edx
  804329:	ff 75 0c             	pushl  0xc(%ebp)
  80432c:	50                   	push   %eax
  80432d:	6a 15                	push   $0x15
  80432f:	e8 e4 fd ff ff       	call   804118 <syscall>
  804334:	83 c4 18             	add    $0x18,%esp
}
  804337:	c9                   	leave  
  804338:	c3                   	ret    

00804339 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  804339:	55                   	push   %ebp
  80433a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80433c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80433f:	8b 45 08             	mov    0x8(%ebp),%eax
  804342:	6a 00                	push   $0x0
  804344:	6a 00                	push   $0x0
  804346:	6a 00                	push   $0x0
  804348:	52                   	push   %edx
  804349:	50                   	push   %eax
  80434a:	6a 16                	push   $0x16
  80434c:	e8 c7 fd ff ff       	call   804118 <syscall>
  804351:	83 c4 18             	add    $0x18,%esp
}
  804354:	c9                   	leave  
  804355:	c3                   	ret    

00804356 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  804356:	55                   	push   %ebp
  804357:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  804359:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80435c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80435f:	8b 45 08             	mov    0x8(%ebp),%eax
  804362:	6a 00                	push   $0x0
  804364:	6a 00                	push   $0x0
  804366:	51                   	push   %ecx
  804367:	52                   	push   %edx
  804368:	50                   	push   %eax
  804369:	6a 17                	push   $0x17
  80436b:	e8 a8 fd ff ff       	call   804118 <syscall>
  804370:	83 c4 18             	add    $0x18,%esp
}
  804373:	c9                   	leave  
  804374:	c3                   	ret    

00804375 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  804375:	55                   	push   %ebp
  804376:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  804378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80437b:	8b 45 08             	mov    0x8(%ebp),%eax
  80437e:	6a 00                	push   $0x0
  804380:	6a 00                	push   $0x0
  804382:	6a 00                	push   $0x0
  804384:	52                   	push   %edx
  804385:	50                   	push   %eax
  804386:	6a 18                	push   $0x18
  804388:	e8 8b fd ff ff       	call   804118 <syscall>
  80438d:	83 c4 18             	add    $0x18,%esp
}
  804390:	c9                   	leave  
  804391:	c3                   	ret    

00804392 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  804392:	55                   	push   %ebp
  804393:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  804395:	8b 45 08             	mov    0x8(%ebp),%eax
  804398:	6a 00                	push   $0x0
  80439a:	ff 75 14             	pushl  0x14(%ebp)
  80439d:	ff 75 10             	pushl  0x10(%ebp)
  8043a0:	ff 75 0c             	pushl  0xc(%ebp)
  8043a3:	50                   	push   %eax
  8043a4:	6a 19                	push   $0x19
  8043a6:	e8 6d fd ff ff       	call   804118 <syscall>
  8043ab:	83 c4 18             	add    $0x18,%esp
}
  8043ae:	c9                   	leave  
  8043af:	c3                   	ret    

008043b0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8043b0:	55                   	push   %ebp
  8043b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8043b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b6:	6a 00                	push   $0x0
  8043b8:	6a 00                	push   $0x0
  8043ba:	6a 00                	push   $0x0
  8043bc:	6a 00                	push   $0x0
  8043be:	50                   	push   %eax
  8043bf:	6a 1a                	push   $0x1a
  8043c1:	e8 52 fd ff ff       	call   804118 <syscall>
  8043c6:	83 c4 18             	add    $0x18,%esp
}
  8043c9:	90                   	nop
  8043ca:	c9                   	leave  
  8043cb:	c3                   	ret    

008043cc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8043cc:	55                   	push   %ebp
  8043cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8043cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8043d2:	6a 00                	push   $0x0
  8043d4:	6a 00                	push   $0x0
  8043d6:	6a 00                	push   $0x0
  8043d8:	6a 00                	push   $0x0
  8043da:	50                   	push   %eax
  8043db:	6a 1b                	push   $0x1b
  8043dd:	e8 36 fd ff ff       	call   804118 <syscall>
  8043e2:	83 c4 18             	add    $0x18,%esp
}
  8043e5:	c9                   	leave  
  8043e6:	c3                   	ret    

008043e7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8043e7:	55                   	push   %ebp
  8043e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8043ea:	6a 00                	push   $0x0
  8043ec:	6a 00                	push   $0x0
  8043ee:	6a 00                	push   $0x0
  8043f0:	6a 00                	push   $0x0
  8043f2:	6a 00                	push   $0x0
  8043f4:	6a 05                	push   $0x5
  8043f6:	e8 1d fd ff ff       	call   804118 <syscall>
  8043fb:	83 c4 18             	add    $0x18,%esp
}
  8043fe:	c9                   	leave  
  8043ff:	c3                   	ret    

00804400 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  804400:	55                   	push   %ebp
  804401:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  804403:	6a 00                	push   $0x0
  804405:	6a 00                	push   $0x0
  804407:	6a 00                	push   $0x0
  804409:	6a 00                	push   $0x0
  80440b:	6a 00                	push   $0x0
  80440d:	6a 06                	push   $0x6
  80440f:	e8 04 fd ff ff       	call   804118 <syscall>
  804414:	83 c4 18             	add    $0x18,%esp
}
  804417:	c9                   	leave  
  804418:	c3                   	ret    

00804419 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  804419:	55                   	push   %ebp
  80441a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80441c:	6a 00                	push   $0x0
  80441e:	6a 00                	push   $0x0
  804420:	6a 00                	push   $0x0
  804422:	6a 00                	push   $0x0
  804424:	6a 00                	push   $0x0
  804426:	6a 07                	push   $0x7
  804428:	e8 eb fc ff ff       	call   804118 <syscall>
  80442d:	83 c4 18             	add    $0x18,%esp
}
  804430:	c9                   	leave  
  804431:	c3                   	ret    

00804432 <sys_exit_env>:


void sys_exit_env(void)
{
  804432:	55                   	push   %ebp
  804433:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  804435:	6a 00                	push   $0x0
  804437:	6a 00                	push   $0x0
  804439:	6a 00                	push   $0x0
  80443b:	6a 00                	push   $0x0
  80443d:	6a 00                	push   $0x0
  80443f:	6a 1c                	push   $0x1c
  804441:	e8 d2 fc ff ff       	call   804118 <syscall>
  804446:	83 c4 18             	add    $0x18,%esp
}
  804449:	90                   	nop
  80444a:	c9                   	leave  
  80444b:	c3                   	ret    

0080444c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80444c:	55                   	push   %ebp
  80444d:	89 e5                	mov    %esp,%ebp
  80444f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  804452:	8d 45 f8             	lea    -0x8(%ebp),%eax
  804455:	8d 50 04             	lea    0x4(%eax),%edx
  804458:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80445b:	6a 00                	push   $0x0
  80445d:	6a 00                	push   $0x0
  80445f:	6a 00                	push   $0x0
  804461:	52                   	push   %edx
  804462:	50                   	push   %eax
  804463:	6a 1d                	push   $0x1d
  804465:	e8 ae fc ff ff       	call   804118 <syscall>
  80446a:	83 c4 18             	add    $0x18,%esp
	return result;
  80446d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  804470:	8b 45 f8             	mov    -0x8(%ebp),%eax
  804473:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804476:	89 01                	mov    %eax,(%ecx)
  804478:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80447b:	8b 45 08             	mov    0x8(%ebp),%eax
  80447e:	c9                   	leave  
  80447f:	c2 04 00             	ret    $0x4

00804482 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  804482:	55                   	push   %ebp
  804483:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  804485:	6a 00                	push   $0x0
  804487:	6a 00                	push   $0x0
  804489:	ff 75 10             	pushl  0x10(%ebp)
  80448c:	ff 75 0c             	pushl  0xc(%ebp)
  80448f:	ff 75 08             	pushl  0x8(%ebp)
  804492:	6a 13                	push   $0x13
  804494:	e8 7f fc ff ff       	call   804118 <syscall>
  804499:	83 c4 18             	add    $0x18,%esp
	return ;
  80449c:	90                   	nop
}
  80449d:	c9                   	leave  
  80449e:	c3                   	ret    

0080449f <sys_rcr2>:
uint32 sys_rcr2()
{
  80449f:	55                   	push   %ebp
  8044a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8044a2:	6a 00                	push   $0x0
  8044a4:	6a 00                	push   $0x0
  8044a6:	6a 00                	push   $0x0
  8044a8:	6a 00                	push   $0x0
  8044aa:	6a 00                	push   $0x0
  8044ac:	6a 1e                	push   $0x1e
  8044ae:	e8 65 fc ff ff       	call   804118 <syscall>
  8044b3:	83 c4 18             	add    $0x18,%esp
}
  8044b6:	c9                   	leave  
  8044b7:	c3                   	ret    

008044b8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8044b8:	55                   	push   %ebp
  8044b9:	89 e5                	mov    %esp,%ebp
  8044bb:	83 ec 04             	sub    $0x4,%esp
  8044be:	8b 45 08             	mov    0x8(%ebp),%eax
  8044c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8044c4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8044c8:	6a 00                	push   $0x0
  8044ca:	6a 00                	push   $0x0
  8044cc:	6a 00                	push   $0x0
  8044ce:	6a 00                	push   $0x0
  8044d0:	50                   	push   %eax
  8044d1:	6a 1f                	push   $0x1f
  8044d3:	e8 40 fc ff ff       	call   804118 <syscall>
  8044d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8044db:	90                   	nop
}
  8044dc:	c9                   	leave  
  8044dd:	c3                   	ret    

008044de <rsttst>:
void rsttst()
{
  8044de:	55                   	push   %ebp
  8044df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8044e1:	6a 00                	push   $0x0
  8044e3:	6a 00                	push   $0x0
  8044e5:	6a 00                	push   $0x0
  8044e7:	6a 00                	push   $0x0
  8044e9:	6a 00                	push   $0x0
  8044eb:	6a 21                	push   $0x21
  8044ed:	e8 26 fc ff ff       	call   804118 <syscall>
  8044f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8044f5:	90                   	nop
}
  8044f6:	c9                   	leave  
  8044f7:	c3                   	ret    

008044f8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8044f8:	55                   	push   %ebp
  8044f9:	89 e5                	mov    %esp,%ebp
  8044fb:	83 ec 04             	sub    $0x4,%esp
  8044fe:	8b 45 14             	mov    0x14(%ebp),%eax
  804501:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  804504:	8b 55 18             	mov    0x18(%ebp),%edx
  804507:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80450b:	52                   	push   %edx
  80450c:	50                   	push   %eax
  80450d:	ff 75 10             	pushl  0x10(%ebp)
  804510:	ff 75 0c             	pushl  0xc(%ebp)
  804513:	ff 75 08             	pushl  0x8(%ebp)
  804516:	6a 20                	push   $0x20
  804518:	e8 fb fb ff ff       	call   804118 <syscall>
  80451d:	83 c4 18             	add    $0x18,%esp
	return ;
  804520:	90                   	nop
}
  804521:	c9                   	leave  
  804522:	c3                   	ret    

00804523 <chktst>:
void chktst(uint32 n)
{
  804523:	55                   	push   %ebp
  804524:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  804526:	6a 00                	push   $0x0
  804528:	6a 00                	push   $0x0
  80452a:	6a 00                	push   $0x0
  80452c:	6a 00                	push   $0x0
  80452e:	ff 75 08             	pushl  0x8(%ebp)
  804531:	6a 22                	push   $0x22
  804533:	e8 e0 fb ff ff       	call   804118 <syscall>
  804538:	83 c4 18             	add    $0x18,%esp
	return ;
  80453b:	90                   	nop
}
  80453c:	c9                   	leave  
  80453d:	c3                   	ret    

0080453e <inctst>:

void inctst()
{
  80453e:	55                   	push   %ebp
  80453f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  804541:	6a 00                	push   $0x0
  804543:	6a 00                	push   $0x0
  804545:	6a 00                	push   $0x0
  804547:	6a 00                	push   $0x0
  804549:	6a 00                	push   $0x0
  80454b:	6a 23                	push   $0x23
  80454d:	e8 c6 fb ff ff       	call   804118 <syscall>
  804552:	83 c4 18             	add    $0x18,%esp
	return ;
  804555:	90                   	nop
}
  804556:	c9                   	leave  
  804557:	c3                   	ret    

00804558 <gettst>:
uint32 gettst()
{
  804558:	55                   	push   %ebp
  804559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80455b:	6a 00                	push   $0x0
  80455d:	6a 00                	push   $0x0
  80455f:	6a 00                	push   $0x0
  804561:	6a 00                	push   $0x0
  804563:	6a 00                	push   $0x0
  804565:	6a 24                	push   $0x24
  804567:	e8 ac fb ff ff       	call   804118 <syscall>
  80456c:	83 c4 18             	add    $0x18,%esp
}
  80456f:	c9                   	leave  
  804570:	c3                   	ret    

00804571 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  804571:	55                   	push   %ebp
  804572:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  804574:	6a 00                	push   $0x0
  804576:	6a 00                	push   $0x0
  804578:	6a 00                	push   $0x0
  80457a:	6a 00                	push   $0x0
  80457c:	6a 00                	push   $0x0
  80457e:	6a 25                	push   $0x25
  804580:	e8 93 fb ff ff       	call   804118 <syscall>
  804585:	83 c4 18             	add    $0x18,%esp
  804588:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  80458d:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  804592:	c9                   	leave  
  804593:	c3                   	ret    

00804594 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  804594:	55                   	push   %ebp
  804595:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  804597:	8b 45 08             	mov    0x8(%ebp),%eax
  80459a:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80459f:	6a 00                	push   $0x0
  8045a1:	6a 00                	push   $0x0
  8045a3:	6a 00                	push   $0x0
  8045a5:	6a 00                	push   $0x0
  8045a7:	ff 75 08             	pushl  0x8(%ebp)
  8045aa:	6a 26                	push   $0x26
  8045ac:	e8 67 fb ff ff       	call   804118 <syscall>
  8045b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8045b4:	90                   	nop
}
  8045b5:	c9                   	leave  
  8045b6:	c3                   	ret    

008045b7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8045b7:	55                   	push   %ebp
  8045b8:	89 e5                	mov    %esp,%ebp
  8045ba:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8045bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8045be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8045c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8045c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8045c7:	6a 00                	push   $0x0
  8045c9:	53                   	push   %ebx
  8045ca:	51                   	push   %ecx
  8045cb:	52                   	push   %edx
  8045cc:	50                   	push   %eax
  8045cd:	6a 27                	push   $0x27
  8045cf:	e8 44 fb ff ff       	call   804118 <syscall>
  8045d4:	83 c4 18             	add    $0x18,%esp
}
  8045d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8045da:	c9                   	leave  
  8045db:	c3                   	ret    

008045dc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8045dc:	55                   	push   %ebp
  8045dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8045df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8045e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e5:	6a 00                	push   $0x0
  8045e7:	6a 00                	push   $0x0
  8045e9:	6a 00                	push   $0x0
  8045eb:	52                   	push   %edx
  8045ec:	50                   	push   %eax
  8045ed:	6a 28                	push   $0x28
  8045ef:	e8 24 fb ff ff       	call   804118 <syscall>
  8045f4:	83 c4 18             	add    $0x18,%esp
}
  8045f7:	c9                   	leave  
  8045f8:	c3                   	ret    

008045f9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8045f9:	55                   	push   %ebp
  8045fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8045fc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8045ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  804602:	8b 45 08             	mov    0x8(%ebp),%eax
  804605:	6a 00                	push   $0x0
  804607:	51                   	push   %ecx
  804608:	ff 75 10             	pushl  0x10(%ebp)
  80460b:	52                   	push   %edx
  80460c:	50                   	push   %eax
  80460d:	6a 29                	push   $0x29
  80460f:	e8 04 fb ff ff       	call   804118 <syscall>
  804614:	83 c4 18             	add    $0x18,%esp
}
  804617:	c9                   	leave  
  804618:	c3                   	ret    

00804619 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  804619:	55                   	push   %ebp
  80461a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80461c:	6a 00                	push   $0x0
  80461e:	6a 00                	push   $0x0
  804620:	ff 75 10             	pushl  0x10(%ebp)
  804623:	ff 75 0c             	pushl  0xc(%ebp)
  804626:	ff 75 08             	pushl  0x8(%ebp)
  804629:	6a 12                	push   $0x12
  80462b:	e8 e8 fa ff ff       	call   804118 <syscall>
  804630:	83 c4 18             	add    $0x18,%esp
	return ;
  804633:	90                   	nop
}
  804634:	c9                   	leave  
  804635:	c3                   	ret    

00804636 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  804636:	55                   	push   %ebp
  804637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  804639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80463c:	8b 45 08             	mov    0x8(%ebp),%eax
  80463f:	6a 00                	push   $0x0
  804641:	6a 00                	push   $0x0
  804643:	6a 00                	push   $0x0
  804645:	52                   	push   %edx
  804646:	50                   	push   %eax
  804647:	6a 2a                	push   $0x2a
  804649:	e8 ca fa ff ff       	call   804118 <syscall>
  80464e:	83 c4 18             	add    $0x18,%esp
	return;
  804651:	90                   	nop
}
  804652:	c9                   	leave  
  804653:	c3                   	ret    

00804654 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  804654:	55                   	push   %ebp
  804655:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  804657:	6a 00                	push   $0x0
  804659:	6a 00                	push   $0x0
  80465b:	6a 00                	push   $0x0
  80465d:	6a 00                	push   $0x0
  80465f:	6a 00                	push   $0x0
  804661:	6a 2b                	push   $0x2b
  804663:	e8 b0 fa ff ff       	call   804118 <syscall>
  804668:	83 c4 18             	add    $0x18,%esp
}
  80466b:	c9                   	leave  
  80466c:	c3                   	ret    

0080466d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80466d:	55                   	push   %ebp
  80466e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  804670:	6a 00                	push   $0x0
  804672:	6a 00                	push   $0x0
  804674:	6a 00                	push   $0x0
  804676:	ff 75 0c             	pushl  0xc(%ebp)
  804679:	ff 75 08             	pushl  0x8(%ebp)
  80467c:	6a 2d                	push   $0x2d
  80467e:	e8 95 fa ff ff       	call   804118 <syscall>
  804683:	83 c4 18             	add    $0x18,%esp
	return;
  804686:	90                   	nop
}
  804687:	c9                   	leave  
  804688:	c3                   	ret    

00804689 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  804689:	55                   	push   %ebp
  80468a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80468c:	6a 00                	push   $0x0
  80468e:	6a 00                	push   $0x0
  804690:	6a 00                	push   $0x0
  804692:	ff 75 0c             	pushl  0xc(%ebp)
  804695:	ff 75 08             	pushl  0x8(%ebp)
  804698:	6a 2c                	push   $0x2c
  80469a:	e8 79 fa ff ff       	call   804118 <syscall>
  80469f:	83 c4 18             	add    $0x18,%esp
	return ;
  8046a2:	90                   	nop
}
  8046a3:	c9                   	leave  
  8046a4:	c3                   	ret    

008046a5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8046a5:	55                   	push   %ebp
  8046a6:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8046a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8046ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8046ae:	6a 00                	push   $0x0
  8046b0:	6a 00                	push   $0x0
  8046b2:	6a 00                	push   $0x0
  8046b4:	52                   	push   %edx
  8046b5:	50                   	push   %eax
  8046b6:	6a 2e                	push   $0x2e
  8046b8:	e8 5b fa ff ff       	call   804118 <syscall>
  8046bd:	83 c4 18             	add    $0x18,%esp
	    return;
  8046c0:	90                   	nop
}
  8046c1:	c9                   	leave  
  8046c2:	c3                   	ret    

008046c3 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8046c3:	55                   	push   %ebp
  8046c4:	89 e5                	mov    %esp,%ebp
  8046c6:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8046c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8046cc:	ba 40 72 80 00       	mov    $0x807240,%edx
  8046d1:	29 d0                	sub    %edx,%eax
  8046d3:	c1 f8 02             	sar    $0x2,%eax
  8046d6:	89 c2                	mov    %eax,%edx
  8046d8:	89 d0                	mov    %edx,%eax
  8046da:	c1 e0 02             	shl    $0x2,%eax
  8046dd:	01 d0                	add    %edx,%eax
  8046df:	c1 e0 02             	shl    $0x2,%eax
  8046e2:	01 d0                	add    %edx,%eax
  8046e4:	c1 e0 02             	shl    $0x2,%eax
  8046e7:	01 d0                	add    %edx,%eax
  8046e9:	89 c1                	mov    %eax,%ecx
  8046eb:	c1 e1 08             	shl    $0x8,%ecx
  8046ee:	01 c8                	add    %ecx,%eax
  8046f0:	89 c1                	mov    %eax,%ecx
  8046f2:	c1 e1 10             	shl    $0x10,%ecx
  8046f5:	01 c8                	add    %ecx,%eax
  8046f7:	01 c0                	add    %eax,%eax
  8046f9:	01 d0                	add    %edx,%eax
  8046fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8046fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804701:	c1 e0 0c             	shl    $0xc,%eax
  804704:	89 c2                	mov    %eax,%edx
  804706:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80470b:	01 d0                	add    %edx,%eax
}
  80470d:	c9                   	leave  
  80470e:	c3                   	ret    

0080470f <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  80470f:	55                   	push   %ebp
  804710:	89 e5                	mov    %esp,%ebp
  804712:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  804715:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  80471c:	eb 06                	jmp    804724 <log2+0x15>
			n >>=1;
  80471e:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  804721:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  804724:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804728:	77 f4                	ja     80471e <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  80472a:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80472d:	c9                   	leave  
  80472e:	c3                   	ret    

0080472f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80472f:	55                   	push   %ebp
  804730:	89 e5                	mov    %esp,%ebp
  804732:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  804735:	8b 45 08             	mov    0x8(%ebp),%eax
  804738:	05 00 00 00 02       	add    $0x2000000,%eax
  80473d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804740:	73 16                	jae    804758 <initialize_dynamic_allocator+0x29>
  804742:	68 98 63 80 00       	push   $0x806398
  804747:	68 be 63 80 00       	push   $0x8063be
  80474c:	6a 2d                	push   $0x2d
  80474e:	68 d3 63 80 00       	push   $0x8063d3
  804753:	e8 a6 ce ff ff       	call   8015fe <_panic>
		is_initialized = 1;
  804758:	c7 05 04 72 80 00 01 	movl   $0x1,0x807204
  80475f:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  804762:	8b 45 08             	mov    0x8(%ebp),%eax
  804765:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd= daEnd;
  80476a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80476d:	a3 20 72 80 00       	mov    %eax,0x807220
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  804772:	8b 15 20 72 80 00    	mov    0x807220,%edx
  804778:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80477d:	29 c2                	sub    %eax,%edx
  80477f:	89 d0                	mov    %edx,%eax
  804781:	c1 e8 0c             	shr    $0xc,%eax
  804784:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  804787:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80478e:	eb 2f                	jmp    8047bf <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  804790:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804793:	89 d0                	mov    %edx,%eax
  804795:	01 c0                	add    %eax,%eax
  804797:	01 d0                	add    %edx,%eax
  804799:	c1 e0 02             	shl    $0x2,%eax
  80479c:	05 48 72 80 00       	add    $0x807248,%eax
  8047a1:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  8047a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8047a9:	89 d0                	mov    %edx,%eax
  8047ab:	01 c0                	add    %eax,%eax
  8047ad:	01 d0                	add    %edx,%eax
  8047af:	c1 e0 02             	shl    $0x2,%eax
  8047b2:	05 4a 72 80 00       	add    $0x80724a,%eax
  8047b7:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  8047bc:	ff 45 f4             	incl   -0xc(%ebp)
  8047bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8047c2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8047c5:	7c c9                	jl     804790 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  8047c7:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  8047ce:	00 00 00 
  8047d1:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  8047d8:	00 00 00 
  8047db:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  8047e2:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  8047e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8047ec:	e9 9c 00 00 00       	jmp    80488d <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8047f1:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  8047f7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8047fa:	89 c8                	mov    %ecx,%eax
  8047fc:	01 c0                	add    %eax,%eax
  8047fe:	01 c8                	add    %ecx,%eax
  804800:	c1 e0 02             	shl    $0x2,%eax
  804803:	05 44 72 80 00       	add    $0x807244,%eax
  804808:	89 10                	mov    %edx,(%eax)
  80480a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80480d:	89 d0                	mov    %edx,%eax
  80480f:	01 c0                	add    %eax,%eax
  804811:	01 d0                	add    %edx,%eax
  804813:	c1 e0 02             	shl    $0x2,%eax
  804816:	05 44 72 80 00       	add    $0x807244,%eax
  80481b:	8b 00                	mov    (%eax),%eax
  80481d:	85 c0                	test   %eax,%eax
  80481f:	74 1b                	je     80483c <initialize_dynamic_allocator+0x10d>
  804821:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804827:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80482a:	89 c8                	mov    %ecx,%eax
  80482c:	01 c0                	add    %eax,%eax
  80482e:	01 c8                	add    %ecx,%eax
  804830:	c1 e0 02             	shl    $0x2,%eax
  804833:	05 40 72 80 00       	add    $0x807240,%eax
  804838:	89 02                	mov    %eax,(%edx)
  80483a:	eb 16                	jmp    804852 <initialize_dynamic_allocator+0x123>
  80483c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80483f:	89 d0                	mov    %edx,%eax
  804841:	01 c0                	add    %eax,%eax
  804843:	01 d0                	add    %edx,%eax
  804845:	c1 e0 02             	shl    $0x2,%eax
  804848:	05 40 72 80 00       	add    $0x807240,%eax
  80484d:	a3 28 72 80 00       	mov    %eax,0x807228
  804852:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804855:	89 d0                	mov    %edx,%eax
  804857:	01 c0                	add    %eax,%eax
  804859:	01 d0                	add    %edx,%eax
  80485b:	c1 e0 02             	shl    $0x2,%eax
  80485e:	05 40 72 80 00       	add    $0x807240,%eax
  804863:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804868:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80486b:	89 d0                	mov    %edx,%eax
  80486d:	01 c0                	add    %eax,%eax
  80486f:	01 d0                	add    %edx,%eax
  804871:	c1 e0 02             	shl    $0x2,%eax
  804874:	05 40 72 80 00       	add    $0x807240,%eax
  804879:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80487f:	a1 34 72 80 00       	mov    0x807234,%eax
  804884:	40                   	inc    %eax
  804885:	a3 34 72 80 00       	mov    %eax,0x807234
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  80488a:	ff 45 f0             	incl   -0x10(%ebp)
  80488d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804890:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804893:	0f 8c 58 ff ff ff    	jl     8047f1 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  804899:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8048a0:	eb 36                	jmp    8048d8 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  8048a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8048a5:	c1 e0 04             	shl    $0x4,%eax
  8048a8:	05 60 f2 81 00       	add    $0x81f260,%eax
  8048ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8048b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8048b6:	c1 e0 04             	shl    $0x4,%eax
  8048b9:	05 64 f2 81 00       	add    $0x81f264,%eax
  8048be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8048c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8048c7:	c1 e0 04             	shl    $0x4,%eax
  8048ca:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8048cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8048d5:	ff 45 ec             	incl   -0x14(%ebp)
  8048d8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8048dc:	7e c4                	jle    8048a2 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8048de:	90                   	nop
  8048df:	c9                   	leave  
  8048e0:	c3                   	ret    

008048e1 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  8048e1:	55                   	push   %ebp
  8048e2:	89 e5                	mov    %esp,%ebp
  8048e4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8048e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8048ea:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8048ef:	29 c2                	sub    %eax,%edx
  8048f1:	89 d0                	mov    %edx,%eax
  8048f3:	c1 e8 0c             	shr    $0xc,%eax
  8048f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  8048f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8048fc:	89 d0                	mov    %edx,%eax
  8048fe:	01 c0                	add    %eax,%eax
  804900:	01 d0                	add    %edx,%eax
  804902:	c1 e0 02             	shl    $0x2,%eax
  804905:	05 48 72 80 00       	add    $0x807248,%eax
  80490a:	8b 00                	mov    (%eax),%eax
  80490c:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80490f:	c9                   	leave  
  804910:	c3                   	ret    

00804911 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  804911:	55                   	push   %ebp
  804912:	89 e5                	mov    %esp,%ebp
  804914:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  804917:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80491e:	76 16                	jbe    804936 <alloc_block+0x25>
  804920:	68 ec 63 80 00       	push   $0x8063ec
  804925:	68 be 63 80 00       	push   $0x8063be
  80492a:	6a 6c                	push   $0x6c
  80492c:	68 d3 63 80 00       	push   $0x8063d3
  804931:	e8 c8 cc ff ff       	call   8015fe <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  804936:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80493a:	75 0a                	jne    804946 <alloc_block+0x35>
		return NULL;
  80493c:	b8 00 00 00 00       	mov    $0x0,%eax
  804941:	e9 65 04 00 00       	jmp    804dab <alloc_block+0x49a>
	}
	else if(size<=8){
  804946:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  80494a:	77 09                	ja     804955 <alloc_block+0x44>
		size=8;
  80494c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  804953:	eb 1f                	jmp    804974 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  804955:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  80495c:	eb 08                	jmp    804966 <alloc_block+0x55>
			reqsize*=2;
  80495e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804961:	01 c0                	add    %eax,%eax
  804963:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  804966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804969:	3b 45 08             	cmp    0x8(%ebp),%eax
  80496c:	72 f0                	jb     80495e <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  80496e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804971:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  804974:	83 ec 0c             	sub    $0xc,%esp
  804977:	ff 75 08             	pushl  0x8(%ebp)
  80497a:	e8 90 fd ff ff       	call   80470f <log2>
  80497f:	83 c4 10             	add    $0x10,%esp
  804982:	83 e8 03             	sub    $0x3,%eax
  804985:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  804988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80498b:	c1 e0 04             	shl    $0x4,%eax
  80498e:	05 60 f2 81 00       	add    $0x81f260,%eax
  804993:	8b 00                	mov    (%eax),%eax
  804995:	85 c0                	test   %eax,%eax
  804997:	0f 84 fb 00 00 00    	je     804a98 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  80499d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049a0:	c1 e0 04             	shl    $0x4,%eax
  8049a3:	05 60 f2 81 00       	add    $0x81f260,%eax
  8049a8:	8b 00                	mov    (%eax),%eax
  8049aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  8049ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8049b1:	75 17                	jne    8049ca <alloc_block+0xb9>
  8049b3:	83 ec 04             	sub    $0x4,%esp
  8049b6:	68 0d 64 80 00       	push   $0x80640d
  8049bb:	68 86 00 00 00       	push   $0x86
  8049c0:	68 d3 63 80 00       	push   $0x8063d3
  8049c5:	e8 34 cc ff ff       	call   8015fe <_panic>
  8049ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049cd:	8b 00                	mov    (%eax),%eax
  8049cf:	85 c0                	test   %eax,%eax
  8049d1:	74 10                	je     8049e3 <alloc_block+0xd2>
  8049d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049d6:	8b 00                	mov    (%eax),%eax
  8049d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049db:	8b 52 04             	mov    0x4(%edx),%edx
  8049de:	89 50 04             	mov    %edx,0x4(%eax)
  8049e1:	eb 14                	jmp    8049f7 <alloc_block+0xe6>
  8049e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049e6:	8b 40 04             	mov    0x4(%eax),%eax
  8049e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8049ec:	c1 e2 04             	shl    $0x4,%edx
  8049ef:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  8049f5:	89 02                	mov    %eax,(%edx)
  8049f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049fa:	8b 40 04             	mov    0x4(%eax),%eax
  8049fd:	85 c0                	test   %eax,%eax
  8049ff:	74 0f                	je     804a10 <alloc_block+0xff>
  804a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a04:	8b 40 04             	mov    0x4(%eax),%eax
  804a07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804a0a:	8b 12                	mov    (%edx),%edx
  804a0c:	89 10                	mov    %edx,(%eax)
  804a0e:	eb 13                	jmp    804a23 <alloc_block+0x112>
  804a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a13:	8b 00                	mov    (%eax),%eax
  804a15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804a18:	c1 e2 04             	shl    $0x4,%edx
  804a1b:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804a21:	89 02                	mov    %eax,(%edx)
  804a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a39:	c1 e0 04             	shl    $0x4,%eax
  804a3c:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804a41:	8b 00                	mov    (%eax),%eax
  804a43:	8d 50 ff             	lea    -0x1(%eax),%edx
  804a46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a49:	c1 e0 04             	shl    $0x4,%eax
  804a4c:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804a51:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804a53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804a56:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804a5b:	29 c2                	sub    %eax,%edx
  804a5d:	89 d0                	mov    %edx,%eax
  804a5f:	c1 e8 0c             	shr    $0xc,%eax
  804a62:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  804a65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804a68:	89 d0                	mov    %edx,%eax
  804a6a:	01 c0                	add    %eax,%eax
  804a6c:	01 d0                	add    %edx,%eax
  804a6e:	c1 e0 02             	shl    $0x2,%eax
  804a71:	05 4a 72 80 00       	add    $0x80724a,%eax
  804a76:	66 8b 00             	mov    (%eax),%ax
  804a79:	8d 50 ff             	lea    -0x1(%eax),%edx
  804a7c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  804a7f:	89 c8                	mov    %ecx,%eax
  804a81:	01 c0                	add    %eax,%eax
  804a83:	01 c8                	add    %ecx,%eax
  804a85:	c1 e0 02             	shl    $0x2,%eax
  804a88:	05 4a 72 80 00       	add    $0x80724a,%eax
  804a8d:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  804a90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a93:	e9 13 03 00 00       	jmp    804dab <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  804a98:	a1 28 72 80 00       	mov    0x807228,%eax
  804a9d:	85 c0                	test   %eax,%eax
  804a9f:	0f 84 c9 01 00 00    	je     804c6e <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  804aa5:	a1 28 72 80 00       	mov    0x807228,%eax
  804aaa:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  804aad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804ab1:	75 17                	jne    804aca <alloc_block+0x1b9>
  804ab3:	83 ec 04             	sub    $0x4,%esp
  804ab6:	68 0d 64 80 00       	push   $0x80640d
  804abb:	68 8f 00 00 00       	push   $0x8f
  804ac0:	68 d3 63 80 00       	push   $0x8063d3
  804ac5:	e8 34 cb ff ff       	call   8015fe <_panic>
  804aca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804acd:	8b 00                	mov    (%eax),%eax
  804acf:	85 c0                	test   %eax,%eax
  804ad1:	74 10                	je     804ae3 <alloc_block+0x1d2>
  804ad3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804ad6:	8b 00                	mov    (%eax),%eax
  804ad8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804adb:	8b 52 04             	mov    0x4(%edx),%edx
  804ade:	89 50 04             	mov    %edx,0x4(%eax)
  804ae1:	eb 0b                	jmp    804aee <alloc_block+0x1dd>
  804ae3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804ae6:	8b 40 04             	mov    0x4(%eax),%eax
  804ae9:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804aee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804af1:	8b 40 04             	mov    0x4(%eax),%eax
  804af4:	85 c0                	test   %eax,%eax
  804af6:	74 0f                	je     804b07 <alloc_block+0x1f6>
  804af8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804afb:	8b 40 04             	mov    0x4(%eax),%eax
  804afe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804b01:	8b 12                	mov    (%edx),%edx
  804b03:	89 10                	mov    %edx,(%eax)
  804b05:	eb 0a                	jmp    804b11 <alloc_block+0x200>
  804b07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804b0a:	8b 00                	mov    (%eax),%eax
  804b0c:	a3 28 72 80 00       	mov    %eax,0x807228
  804b11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804b14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804b1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804b1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804b24:	a1 34 72 80 00       	mov    0x807234,%eax
  804b29:	48                   	dec    %eax
  804b2a:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  804b2f:	83 ec 0c             	sub    $0xc,%esp
  804b32:	ff 75 dc             	pushl  -0x24(%ebp)
  804b35:	e8 89 fb ff ff       	call   8046c3 <to_page_va>
  804b3a:	83 c4 10             	add    $0x10,%esp
  804b3d:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  804b40:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804b45:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804b48:	29 c2                	sub    %eax,%edx
  804b4a:	89 d0                	mov    %edx,%eax
  804b4c:	c1 e8 0c             	shr    $0xc,%eax
  804b4f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  804b52:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804b55:	83 ec 0c             	sub    $0xc,%esp
  804b58:	50                   	push   %eax
  804b59:	e8 fe dc ff ff       	call   80285c <get_page>
  804b5e:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  804b61:	8b 45 08             	mov    0x8(%ebp),%eax
  804b64:	89 c2                	mov    %eax,%edx
  804b66:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804b69:	89 c8                	mov    %ecx,%eax
  804b6b:	01 c0                	add    %eax,%eax
  804b6d:	01 c8                	add    %ecx,%eax
  804b6f:	c1 e0 02             	shl    $0x2,%eax
  804b72:	05 48 72 80 00       	add    $0x807248,%eax
  804b77:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  804b7a:	b8 00 10 00 00       	mov    $0x1000,%eax
  804b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  804b84:	f7 75 08             	divl   0x8(%ebp)
  804b87:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  804b8a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804b8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  804b90:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804b93:	89 c8                	mov    %ecx,%eax
  804b95:	01 c0                	add    %eax,%eax
  804b97:	01 c8                	add    %ecx,%eax
  804b99:	c1 e0 02             	shl    $0x2,%eax
  804b9c:	05 4a 72 80 00       	add    $0x80724a,%eax
  804ba1:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  804ba4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  804bab:	e9 aa 00 00 00       	jmp    804c5a <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  804bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804bb3:	0f af 45 08          	imul   0x8(%ebp),%eax
  804bb7:	89 c2                	mov    %eax,%edx
  804bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804bbc:	01 d0                	add    %edx,%eax
  804bbe:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  804bc1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804bc5:	75 17                	jne    804bde <alloc_block+0x2cd>
  804bc7:	83 ec 04             	sub    $0x4,%esp
  804bca:	68 2c 64 80 00       	push   $0x80642c
  804bcf:	68 9d 00 00 00       	push   $0x9d
  804bd4:	68 d3 63 80 00       	push   $0x8063d3
  804bd9:	e8 20 ca ff ff       	call   8015fe <_panic>
  804bde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804be1:	c1 e0 04             	shl    $0x4,%eax
  804be4:	05 64 f2 81 00       	add    $0x81f264,%eax
  804be9:	8b 10                	mov    (%eax),%edx
  804beb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804bee:	89 50 04             	mov    %edx,0x4(%eax)
  804bf1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804bf4:	8b 40 04             	mov    0x4(%eax),%eax
  804bf7:	85 c0                	test   %eax,%eax
  804bf9:	74 14                	je     804c0f <alloc_block+0x2fe>
  804bfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bfe:	c1 e0 04             	shl    $0x4,%eax
  804c01:	05 64 f2 81 00       	add    $0x81f264,%eax
  804c06:	8b 00                	mov    (%eax),%eax
  804c08:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804c0b:	89 10                	mov    %edx,(%eax)
  804c0d:	eb 11                	jmp    804c20 <alloc_block+0x30f>
  804c0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c12:	c1 e0 04             	shl    $0x4,%eax
  804c15:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804c1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804c1e:	89 02                	mov    %eax,(%edx)
  804c20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c23:	c1 e0 04             	shl    $0x4,%eax
  804c26:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804c2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804c2f:	89 02                	mov    %eax,(%edx)
  804c31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804c34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c3d:	c1 e0 04             	shl    $0x4,%eax
  804c40:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804c45:	8b 00                	mov    (%eax),%eax
  804c47:	8d 50 01             	lea    0x1(%eax),%edx
  804c4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c4d:	c1 e0 04             	shl    $0x4,%eax
  804c50:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804c55:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  804c57:	ff 45 f0             	incl   -0x10(%ebp)
  804c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c5d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  804c60:	0f 8c 4a ff ff ff    	jl     804bb0 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  804c66:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804c69:	e9 3d 01 00 00       	jmp    804dab <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804c6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c71:	40                   	inc    %eax
  804c72:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804c75:	e9 10 01 00 00       	jmp    804d8a <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  804c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c7d:	c1 e0 04             	shl    $0x4,%eax
  804c80:	05 60 f2 81 00       	add    $0x81f260,%eax
  804c85:	8b 00                	mov    (%eax),%eax
  804c87:	85 c0                	test   %eax,%eax
  804c89:	0f 84 f8 00 00 00    	je     804d87 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c92:	c1 e0 04             	shl    $0x4,%eax
  804c95:	05 60 f2 81 00       	add    $0x81f260,%eax
  804c9a:	8b 00                	mov    (%eax),%eax
  804c9c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  804c9f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804ca3:	75 17                	jne    804cbc <alloc_block+0x3ab>
  804ca5:	83 ec 04             	sub    $0x4,%esp
  804ca8:	68 0d 64 80 00       	push   $0x80640d
  804cad:	68 a8 00 00 00       	push   $0xa8
  804cb2:	68 d3 63 80 00       	push   $0x8063d3
  804cb7:	e8 42 c9 ff ff       	call   8015fe <_panic>
  804cbc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804cbf:	8b 00                	mov    (%eax),%eax
  804cc1:	85 c0                	test   %eax,%eax
  804cc3:	74 10                	je     804cd5 <alloc_block+0x3c4>
  804cc5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804cc8:	8b 00                	mov    (%eax),%eax
  804cca:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804ccd:	8b 52 04             	mov    0x4(%edx),%edx
  804cd0:	89 50 04             	mov    %edx,0x4(%eax)
  804cd3:	eb 14                	jmp    804ce9 <alloc_block+0x3d8>
  804cd5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804cd8:	8b 40 04             	mov    0x4(%eax),%eax
  804cdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804cde:	c1 e2 04             	shl    $0x4,%edx
  804ce1:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804ce7:	89 02                	mov    %eax,(%edx)
  804ce9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804cec:	8b 40 04             	mov    0x4(%eax),%eax
  804cef:	85 c0                	test   %eax,%eax
  804cf1:	74 0f                	je     804d02 <alloc_block+0x3f1>
  804cf3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804cf6:	8b 40 04             	mov    0x4(%eax),%eax
  804cf9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804cfc:	8b 12                	mov    (%edx),%edx
  804cfe:	89 10                	mov    %edx,(%eax)
  804d00:	eb 13                	jmp    804d15 <alloc_block+0x404>
  804d02:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804d05:	8b 00                	mov    (%eax),%eax
  804d07:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804d0a:	c1 e2 04             	shl    $0x4,%edx
  804d0d:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804d13:	89 02                	mov    %eax,(%edx)
  804d15:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804d18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804d1e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804d21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d2b:	c1 e0 04             	shl    $0x4,%eax
  804d2e:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804d33:	8b 00                	mov    (%eax),%eax
  804d35:	8d 50 ff             	lea    -0x1(%eax),%edx
  804d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d3b:	c1 e0 04             	shl    $0x4,%eax
  804d3e:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804d43:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804d45:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804d48:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804d4d:	29 c2                	sub    %eax,%edx
  804d4f:	89 d0                	mov    %edx,%eax
  804d51:	c1 e8 0c             	shr    $0xc,%eax
  804d54:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  804d57:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  804d5a:	89 d0                	mov    %edx,%eax
  804d5c:	01 c0                	add    %eax,%eax
  804d5e:	01 d0                	add    %edx,%eax
  804d60:	c1 e0 02             	shl    $0x2,%eax
  804d63:	05 4a 72 80 00       	add    $0x80724a,%eax
  804d68:	66 8b 00             	mov    (%eax),%ax
  804d6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  804d6e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  804d71:	89 c8                	mov    %ecx,%eax
  804d73:	01 c0                	add    %eax,%eax
  804d75:	01 c8                	add    %ecx,%eax
  804d77:	c1 e0 02             	shl    $0x2,%eax
  804d7a:	05 4a 72 80 00       	add    $0x80724a,%eax
  804d7f:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  804d82:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804d85:	eb 24                	jmp    804dab <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804d87:	ff 45 ec             	incl   -0x14(%ebp)
  804d8a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804d8e:	0f 8e e6 fe ff ff    	jle    804c7a <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  804d94:	83 ec 04             	sub    $0x4,%esp
  804d97:	68 4f 64 80 00       	push   $0x80644f
  804d9c:	68 b1 00 00 00       	push   $0xb1
  804da1:	68 d3 63 80 00       	push   $0x8063d3
  804da6:	e8 53 c8 ff ff       	call   8015fe <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804dab:	c9                   	leave  
  804dac:	c3                   	ret    

00804dad <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804dad:	55                   	push   %ebp
  804dae:	89 e5                	mov    %esp,%ebp
  804db0:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804db3:	8b 55 08             	mov    0x8(%ebp),%edx
  804db6:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804dbb:	39 c2                	cmp    %eax,%edx
  804dbd:	72 0c                	jb     804dcb <free_block+0x1e>
  804dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  804dc2:	a1 20 72 80 00       	mov    0x807220,%eax
  804dc7:	39 c2                	cmp    %eax,%edx
  804dc9:	72 19                	jb     804de4 <free_block+0x37>
  804dcb:	68 6c 64 80 00       	push   $0x80646c
  804dd0:	68 be 63 80 00       	push   $0x8063be
  804dd5:	68 c3 00 00 00       	push   $0xc3
  804dda:	68 d3 63 80 00       	push   $0x8063d3
  804ddf:	e8 1a c8 ff ff       	call   8015fe <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804de4:	8b 55 08             	mov    0x8(%ebp),%edx
  804de7:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804dec:	29 c2                	sub    %eax,%edx
  804dee:	89 d0                	mov    %edx,%eax
  804df0:	c1 e8 0c             	shr    $0xc,%eax
  804df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  804df6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804df9:	89 d0                	mov    %edx,%eax
  804dfb:	01 c0                	add    %eax,%eax
  804dfd:	01 d0                	add    %edx,%eax
  804dff:	c1 e0 02             	shl    $0x2,%eax
  804e02:	05 48 72 80 00       	add    $0x807248,%eax
  804e07:	8b 00                	mov    (%eax),%eax
  804e09:	0f b7 c0             	movzwl %ax,%eax
  804e0c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  804e0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804e13:	75 17                	jne    804e2c <free_block+0x7f>
		panic("page is empty(already not allocated)");
  804e15:	83 ec 04             	sub    $0x4,%esp
  804e18:	68 a4 64 80 00       	push   $0x8064a4
  804e1d:	68 cf 00 00 00       	push   $0xcf
  804e22:	68 d3 63 80 00       	push   $0x8063d3
  804e27:	e8 d2 c7 ff ff       	call   8015fe <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804e2c:	83 ec 0c             	sub    $0xc,%esp
  804e2f:	ff 75 ec             	pushl  -0x14(%ebp)
  804e32:	e8 d8 f8 ff ff       	call   80470f <log2>
  804e37:	83 c4 10             	add    $0x10,%esp
  804e3a:	83 e8 03             	sub    $0x3,%eax
  804e3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804e40:	8b 45 08             	mov    0x8(%ebp),%eax
  804e43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  804e46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804e4a:	75 17                	jne    804e63 <free_block+0xb6>
  804e4c:	83 ec 04             	sub    $0x4,%esp
  804e4f:	68 2c 64 80 00       	push   $0x80642c
  804e54:	68 d5 00 00 00       	push   $0xd5
  804e59:	68 d3 63 80 00       	push   $0x8063d3
  804e5e:	e8 9b c7 ff ff       	call   8015fe <_panic>
  804e63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e66:	c1 e0 04             	shl    $0x4,%eax
  804e69:	05 64 f2 81 00       	add    $0x81f264,%eax
  804e6e:	8b 10                	mov    (%eax),%edx
  804e70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e73:	89 50 04             	mov    %edx,0x4(%eax)
  804e76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804e79:	8b 40 04             	mov    0x4(%eax),%eax
  804e7c:	85 c0                	test   %eax,%eax
  804e7e:	74 14                	je     804e94 <free_block+0xe7>
  804e80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e83:	c1 e0 04             	shl    $0x4,%eax
  804e86:	05 64 f2 81 00       	add    $0x81f264,%eax
  804e8b:	8b 00                	mov    (%eax),%eax
  804e8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804e90:	89 10                	mov    %edx,(%eax)
  804e92:	eb 11                	jmp    804ea5 <free_block+0xf8>
  804e94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e97:	c1 e0 04             	shl    $0x4,%eax
  804e9a:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ea3:	89 02                	mov    %eax,(%edx)
  804ea5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804ea8:	c1 e0 04             	shl    $0x4,%eax
  804eab:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804eb4:	89 02                	mov    %eax,(%edx)
  804eb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804eb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804ebf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804ec2:	c1 e0 04             	shl    $0x4,%eax
  804ec5:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804eca:	8b 00                	mov    (%eax),%eax
  804ecc:	8d 50 01             	lea    0x1(%eax),%edx
  804ecf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804ed2:	c1 e0 04             	shl    $0x4,%eax
  804ed5:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804eda:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  804edc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804edf:	89 d0                	mov    %edx,%eax
  804ee1:	01 c0                	add    %eax,%eax
  804ee3:	01 d0                	add    %edx,%eax
  804ee5:	c1 e0 02             	shl    $0x2,%eax
  804ee8:	05 4a 72 80 00       	add    $0x80724a,%eax
  804eed:	66 8b 00             	mov    (%eax),%ax
  804ef0:	8d 50 01             	lea    0x1(%eax),%edx
  804ef3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804ef6:	89 c8                	mov    %ecx,%eax
  804ef8:	01 c0                	add    %eax,%eax
  804efa:	01 c8                	add    %ecx,%eax
  804efc:	c1 e0 02             	shl    $0x2,%eax
  804eff:	05 4a 72 80 00       	add    $0x80724a,%eax
  804f04:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  804f07:	b8 00 10 00 00       	mov    $0x1000,%eax
  804f0c:	ba 00 00 00 00       	mov    $0x0,%edx
  804f11:	f7 75 ec             	divl   -0x14(%ebp)
  804f14:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  804f17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804f1a:	89 d0                	mov    %edx,%eax
  804f1c:	01 c0                	add    %eax,%eax
  804f1e:	01 d0                	add    %edx,%eax
  804f20:	c1 e0 02             	shl    $0x2,%eax
  804f23:	05 4a 72 80 00       	add    $0x80724a,%eax
  804f28:	66 8b 00             	mov    (%eax),%ax
  804f2b:	0f b7 c0             	movzwl %ax,%eax
  804f2e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804f31:	0f 85 d3 01 00 00    	jne    80510a <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  804f37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804f3a:	c1 e0 04             	shl    $0x4,%eax
  804f3d:	05 60 f2 81 00       	add    $0x81f260,%eax
  804f42:	8b 00                	mov    (%eax),%eax
  804f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  804f47:	e9 f1 00 00 00       	jmp    80503d <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f4f:	8b 00                	mov    (%eax),%eax
  804f51:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  804f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804f57:	c1 e0 0c             	shl    $0xc,%eax
  804f5a:	89 c2                	mov    %eax,%edx
  804f5c:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804f61:	01 d0                	add    %edx,%eax
  804f63:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  804f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804f69:	40                   	inc    %eax
  804f6a:	c1 e0 0c             	shl    $0xc,%eax
  804f6d:	89 c2                	mov    %eax,%edx
  804f6f:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804f74:	01 d0                	add    %edx,%eax
  804f76:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  804f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f7c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  804f7f:	0f 82 b8 00 00 00    	jb     80503d <free_block+0x290>
  804f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f88:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804f8b:	0f 83 ac 00 00 00    	jae    80503d <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  804f91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804f95:	75 17                	jne    804fae <free_block+0x201>
  804f97:	83 ec 04             	sub    $0x4,%esp
  804f9a:	68 0d 64 80 00       	push   $0x80640d
  804f9f:	68 e2 00 00 00       	push   $0xe2
  804fa4:	68 d3 63 80 00       	push   $0x8063d3
  804fa9:	e8 50 c6 ff ff       	call   8015fe <_panic>
  804fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fb1:	8b 00                	mov    (%eax),%eax
  804fb3:	85 c0                	test   %eax,%eax
  804fb5:	74 10                	je     804fc7 <free_block+0x21a>
  804fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fba:	8b 00                	mov    (%eax),%eax
  804fbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804fbf:	8b 52 04             	mov    0x4(%edx),%edx
  804fc2:	89 50 04             	mov    %edx,0x4(%eax)
  804fc5:	eb 14                	jmp    804fdb <free_block+0x22e>
  804fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fca:	8b 40 04             	mov    0x4(%eax),%eax
  804fcd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804fd0:	c1 e2 04             	shl    $0x4,%edx
  804fd3:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804fd9:	89 02                	mov    %eax,(%edx)
  804fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fde:	8b 40 04             	mov    0x4(%eax),%eax
  804fe1:	85 c0                	test   %eax,%eax
  804fe3:	74 0f                	je     804ff4 <free_block+0x247>
  804fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804fe8:	8b 40 04             	mov    0x4(%eax),%eax
  804feb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804fee:	8b 12                	mov    (%edx),%edx
  804ff0:	89 10                	mov    %edx,(%eax)
  804ff2:	eb 13                	jmp    805007 <free_block+0x25a>
  804ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ff7:	8b 00                	mov    (%eax),%eax
  804ff9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804ffc:	c1 e2 04             	shl    $0x4,%edx
  804fff:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  805005:	89 02                	mov    %eax,(%edx)
  805007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80500a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  805010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805013:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80501a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80501d:	c1 e0 04             	shl    $0x4,%eax
  805020:	05 6c f2 81 00       	add    $0x81f26c,%eax
  805025:	8b 00                	mov    (%eax),%eax
  805027:	8d 50 ff             	lea    -0x1(%eax),%edx
  80502a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80502d:	c1 e0 04             	shl    $0x4,%eax
  805030:	05 6c f2 81 00       	add    $0x81f26c,%eax
  805035:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  805037:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80503a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  80503d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  805041:	0f 85 05 ff ff ff    	jne    804f4c <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  805047:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80504a:	89 d0                	mov    %edx,%eax
  80504c:	01 c0                	add    %eax,%eax
  80504e:	01 d0                	add    %edx,%eax
  805050:	c1 e0 02             	shl    $0x2,%eax
  805053:	05 48 72 80 00       	add    $0x807248,%eax
  805058:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  80505d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  805060:	89 d0                	mov    %edx,%eax
  805062:	01 c0                	add    %eax,%eax
  805064:	01 d0                	add    %edx,%eax
  805066:	c1 e0 02             	shl    $0x2,%eax
  805069:	05 4a 72 80 00       	add    $0x80724a,%eax
  80506e:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  805073:	8b 55 f0             	mov    -0x10(%ebp),%edx
  805076:	89 d0                	mov    %edx,%eax
  805078:	01 c0                	add    %eax,%eax
  80507a:	01 d0                	add    %edx,%eax
  80507c:	c1 e0 02             	shl    $0x2,%eax
  80507f:	05 40 72 80 00       	add    $0x807240,%eax
  805084:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  805087:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80508b:	75 17                	jne    8050a4 <free_block+0x2f7>
  80508d:	83 ec 04             	sub    $0x4,%esp
  805090:	68 2c 64 80 00       	push   $0x80642c
  805095:	68 eb 00 00 00       	push   $0xeb
  80509a:	68 d3 63 80 00       	push   $0x8063d3
  80509f:	e8 5a c5 ff ff       	call   8015fe <_panic>
  8050a4:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  8050aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8050ad:	89 50 04             	mov    %edx,0x4(%eax)
  8050b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8050b3:	8b 40 04             	mov    0x4(%eax),%eax
  8050b6:	85 c0                	test   %eax,%eax
  8050b8:	74 0c                	je     8050c6 <free_block+0x319>
  8050ba:	a1 2c 72 80 00       	mov    0x80722c,%eax
  8050bf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8050c2:	89 10                	mov    %edx,(%eax)
  8050c4:	eb 08                	jmp    8050ce <free_block+0x321>
  8050c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8050c9:	a3 28 72 80 00       	mov    %eax,0x807228
  8050ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8050d1:	a3 2c 72 80 00       	mov    %eax,0x80722c
  8050d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8050d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8050df:	a1 34 72 80 00       	mov    0x807234,%eax
  8050e4:	40                   	inc    %eax
  8050e5:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  8050ea:	83 ec 0c             	sub    $0xc,%esp
  8050ed:	ff 75 d0             	pushl  -0x30(%ebp)
  8050f0:	e8 ce f5 ff ff       	call   8046c3 <to_page_va>
  8050f5:	83 c4 10             	add    $0x10,%esp
  8050f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  8050fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8050fe:	83 ec 0c             	sub    $0xc,%esp
  805101:	50                   	push   %eax
  805102:	e8 9e d7 ff ff       	call   8028a5 <return_page>
  805107:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80510a:	90                   	nop
  80510b:	c9                   	leave  
  80510c:	c3                   	ret    

0080510d <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80510d:	55                   	push   %ebp
  80510e:	89 e5                	mov    %esp,%ebp
  805110:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  805113:	83 ec 04             	sub    $0x4,%esp
  805116:	68 cc 64 80 00       	push   $0x8064cc
  80511b:	68 01 01 00 00       	push   $0x101
  805120:	68 d3 63 80 00       	push   $0x8063d3
  805125:	e8 d4 c4 ff ff       	call   8015fe <_panic>

0080512a <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  80512a:	55                   	push   %ebp
  80512b:	89 e5                	mov    %esp,%ebp
  80512d:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  805130:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  805134:	74 1c                	je     805152 <init_uspinlock+0x28>
  805136:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  80513a:	74 16                	je     805152 <init_uspinlock+0x28>
  80513c:	68 f0 64 80 00       	push   $0x8064f0
  805141:	68 0f 65 80 00       	push   $0x80650f
  805146:	6a 10                	push   $0x10
  805148:	68 24 65 80 00       	push   $0x806524
  80514d:	e8 ac c4 ff ff       	call   8015fe <_panic>
	strcpy(lk->name, name);
  805152:	8b 45 08             	mov    0x8(%ebp),%eax
  805155:	83 c0 04             	add    $0x4,%eax
  805158:	83 ec 08             	sub    $0x8,%esp
  80515b:	ff 75 0c             	pushl  0xc(%ebp)
  80515e:	50                   	push   %eax
  80515f:	e8 90 ce ff ff       	call   801ff4 <strcpy>
  805164:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  805167:	b8 01 00 00 00       	mov    $0x1,%eax
  80516c:	2b 45 10             	sub    0x10(%ebp),%eax
  80516f:	89 c2                	mov    %eax,%edx
  805171:	8b 45 08             	mov    0x8(%ebp),%eax
  805174:	89 10                	mov    %edx,(%eax)
}
  805176:	90                   	nop
  805177:	c9                   	leave  
  805178:	c3                   	ret    

00805179 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  805179:	55                   	push   %ebp
  80517a:	89 e5                	mov    %esp,%ebp
  80517c:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  80517f:	90                   	nop
  805180:	8b 45 08             	mov    0x8(%ebp),%eax
  805183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  805186:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80518d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  805190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805193:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  805196:	f0 87 02             	lock xchg %eax,(%edx)
  805199:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  80519c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80519f:	85 c0                	test   %eax,%eax
  8051a1:	75 dd                	jne    805180 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8051a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8051a6:	8d 48 04             	lea    0x4(%eax),%ecx
  8051a9:	a1 00 72 80 00       	mov    0x807200,%eax
  8051ae:	8d 50 20             	lea    0x20(%eax),%edx
  8051b1:	a1 00 72 80 00       	mov    0x807200,%eax
  8051b6:	8b 40 10             	mov    0x10(%eax),%eax
  8051b9:	51                   	push   %ecx
  8051ba:	52                   	push   %edx
  8051bb:	50                   	push   %eax
  8051bc:	68 34 65 80 00       	push   $0x806534
  8051c1:	e8 06 c7 ff ff       	call   8018cc <cprintf>
  8051c6:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8051c9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8051ce:	90                   	nop
  8051cf:	c9                   	leave  
  8051d0:	c3                   	ret    

008051d1 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8051d1:	55                   	push   %ebp
  8051d2:	89 e5                	mov    %esp,%ebp
  8051d4:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  8051d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8051da:	8b 00                	mov    (%eax),%eax
  8051dc:	85 c0                	test   %eax,%eax
  8051de:	75 18                	jne    8051f8 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  8051e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8051e3:	83 c0 04             	add    $0x4,%eax
  8051e6:	50                   	push   %eax
  8051e7:	68 58 65 80 00       	push   $0x806558
  8051ec:	6a 2b                	push   $0x2b
  8051ee:	68 24 65 80 00       	push   $0x806524
  8051f3:	e8 06 c4 ff ff       	call   8015fe <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8051f8:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8051fd:	8b 45 08             	mov    0x8(%ebp),%eax
  805200:	8b 55 08             	mov    0x8(%ebp),%edx
  805203:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  805209:	8b 45 08             	mov    0x8(%ebp),%eax
  80520c:	8d 48 04             	lea    0x4(%eax),%ecx
  80520f:	a1 00 72 80 00       	mov    0x807200,%eax
  805214:	8d 50 20             	lea    0x20(%eax),%edx
  805217:	a1 00 72 80 00       	mov    0x807200,%eax
  80521c:	8b 40 10             	mov    0x10(%eax),%eax
  80521f:	51                   	push   %ecx
  805220:	52                   	push   %edx
  805221:	50                   	push   %eax
  805222:	68 78 65 80 00       	push   $0x806578
  805227:	e8 a0 c6 ff ff       	call   8018cc <cprintf>
  80522c:	83 c4 10             	add    $0x10,%esp
}
  80522f:	90                   	nop
  805230:	c9                   	leave  
  805231:	c3                   	ret    
  805232:	66 90                	xchg   %ax,%ax

00805234 <__udivdi3>:
  805234:	55                   	push   %ebp
  805235:	57                   	push   %edi
  805236:	56                   	push   %esi
  805237:	53                   	push   %ebx
  805238:	83 ec 1c             	sub    $0x1c,%esp
  80523b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80523f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  805243:	8b 7c 24 38          	mov    0x38(%esp),%edi
  805247:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80524b:	89 ca                	mov    %ecx,%edx
  80524d:	89 f8                	mov    %edi,%eax
  80524f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  805253:	85 f6                	test   %esi,%esi
  805255:	75 2d                	jne    805284 <__udivdi3+0x50>
  805257:	39 cf                	cmp    %ecx,%edi
  805259:	77 65                	ja     8052c0 <__udivdi3+0x8c>
  80525b:	89 fd                	mov    %edi,%ebp
  80525d:	85 ff                	test   %edi,%edi
  80525f:	75 0b                	jne    80526c <__udivdi3+0x38>
  805261:	b8 01 00 00 00       	mov    $0x1,%eax
  805266:	31 d2                	xor    %edx,%edx
  805268:	f7 f7                	div    %edi
  80526a:	89 c5                	mov    %eax,%ebp
  80526c:	31 d2                	xor    %edx,%edx
  80526e:	89 c8                	mov    %ecx,%eax
  805270:	f7 f5                	div    %ebp
  805272:	89 c1                	mov    %eax,%ecx
  805274:	89 d8                	mov    %ebx,%eax
  805276:	f7 f5                	div    %ebp
  805278:	89 cf                	mov    %ecx,%edi
  80527a:	89 fa                	mov    %edi,%edx
  80527c:	83 c4 1c             	add    $0x1c,%esp
  80527f:	5b                   	pop    %ebx
  805280:	5e                   	pop    %esi
  805281:	5f                   	pop    %edi
  805282:	5d                   	pop    %ebp
  805283:	c3                   	ret    
  805284:	39 ce                	cmp    %ecx,%esi
  805286:	77 28                	ja     8052b0 <__udivdi3+0x7c>
  805288:	0f bd fe             	bsr    %esi,%edi
  80528b:	83 f7 1f             	xor    $0x1f,%edi
  80528e:	75 40                	jne    8052d0 <__udivdi3+0x9c>
  805290:	39 ce                	cmp    %ecx,%esi
  805292:	72 0a                	jb     80529e <__udivdi3+0x6a>
  805294:	3b 44 24 08          	cmp    0x8(%esp),%eax
  805298:	0f 87 9e 00 00 00    	ja     80533c <__udivdi3+0x108>
  80529e:	b8 01 00 00 00       	mov    $0x1,%eax
  8052a3:	89 fa                	mov    %edi,%edx
  8052a5:	83 c4 1c             	add    $0x1c,%esp
  8052a8:	5b                   	pop    %ebx
  8052a9:	5e                   	pop    %esi
  8052aa:	5f                   	pop    %edi
  8052ab:	5d                   	pop    %ebp
  8052ac:	c3                   	ret    
  8052ad:	8d 76 00             	lea    0x0(%esi),%esi
  8052b0:	31 ff                	xor    %edi,%edi
  8052b2:	31 c0                	xor    %eax,%eax
  8052b4:	89 fa                	mov    %edi,%edx
  8052b6:	83 c4 1c             	add    $0x1c,%esp
  8052b9:	5b                   	pop    %ebx
  8052ba:	5e                   	pop    %esi
  8052bb:	5f                   	pop    %edi
  8052bc:	5d                   	pop    %ebp
  8052bd:	c3                   	ret    
  8052be:	66 90                	xchg   %ax,%ax
  8052c0:	89 d8                	mov    %ebx,%eax
  8052c2:	f7 f7                	div    %edi
  8052c4:	31 ff                	xor    %edi,%edi
  8052c6:	89 fa                	mov    %edi,%edx
  8052c8:	83 c4 1c             	add    $0x1c,%esp
  8052cb:	5b                   	pop    %ebx
  8052cc:	5e                   	pop    %esi
  8052cd:	5f                   	pop    %edi
  8052ce:	5d                   	pop    %ebp
  8052cf:	c3                   	ret    
  8052d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8052d5:	89 eb                	mov    %ebp,%ebx
  8052d7:	29 fb                	sub    %edi,%ebx
  8052d9:	89 f9                	mov    %edi,%ecx
  8052db:	d3 e6                	shl    %cl,%esi
  8052dd:	89 c5                	mov    %eax,%ebp
  8052df:	88 d9                	mov    %bl,%cl
  8052e1:	d3 ed                	shr    %cl,%ebp
  8052e3:	89 e9                	mov    %ebp,%ecx
  8052e5:	09 f1                	or     %esi,%ecx
  8052e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8052eb:	89 f9                	mov    %edi,%ecx
  8052ed:	d3 e0                	shl    %cl,%eax
  8052ef:	89 c5                	mov    %eax,%ebp
  8052f1:	89 d6                	mov    %edx,%esi
  8052f3:	88 d9                	mov    %bl,%cl
  8052f5:	d3 ee                	shr    %cl,%esi
  8052f7:	89 f9                	mov    %edi,%ecx
  8052f9:	d3 e2                	shl    %cl,%edx
  8052fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8052ff:	88 d9                	mov    %bl,%cl
  805301:	d3 e8                	shr    %cl,%eax
  805303:	09 c2                	or     %eax,%edx
  805305:	89 d0                	mov    %edx,%eax
  805307:	89 f2                	mov    %esi,%edx
  805309:	f7 74 24 0c          	divl   0xc(%esp)
  80530d:	89 d6                	mov    %edx,%esi
  80530f:	89 c3                	mov    %eax,%ebx
  805311:	f7 e5                	mul    %ebp
  805313:	39 d6                	cmp    %edx,%esi
  805315:	72 19                	jb     805330 <__udivdi3+0xfc>
  805317:	74 0b                	je     805324 <__udivdi3+0xf0>
  805319:	89 d8                	mov    %ebx,%eax
  80531b:	31 ff                	xor    %edi,%edi
  80531d:	e9 58 ff ff ff       	jmp    80527a <__udivdi3+0x46>
  805322:	66 90                	xchg   %ax,%ax
  805324:	8b 54 24 08          	mov    0x8(%esp),%edx
  805328:	89 f9                	mov    %edi,%ecx
  80532a:	d3 e2                	shl    %cl,%edx
  80532c:	39 c2                	cmp    %eax,%edx
  80532e:	73 e9                	jae    805319 <__udivdi3+0xe5>
  805330:	8d 43 ff             	lea    -0x1(%ebx),%eax
  805333:	31 ff                	xor    %edi,%edi
  805335:	e9 40 ff ff ff       	jmp    80527a <__udivdi3+0x46>
  80533a:	66 90                	xchg   %ax,%ax
  80533c:	31 c0                	xor    %eax,%eax
  80533e:	e9 37 ff ff ff       	jmp    80527a <__udivdi3+0x46>
  805343:	90                   	nop

00805344 <__umoddi3>:
  805344:	55                   	push   %ebp
  805345:	57                   	push   %edi
  805346:	56                   	push   %esi
  805347:	53                   	push   %ebx
  805348:	83 ec 1c             	sub    $0x1c,%esp
  80534b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80534f:	8b 74 24 34          	mov    0x34(%esp),%esi
  805353:	8b 7c 24 38          	mov    0x38(%esp),%edi
  805357:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80535b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80535f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  805363:	89 f3                	mov    %esi,%ebx
  805365:	89 fa                	mov    %edi,%edx
  805367:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80536b:	89 34 24             	mov    %esi,(%esp)
  80536e:	85 c0                	test   %eax,%eax
  805370:	75 1a                	jne    80538c <__umoddi3+0x48>
  805372:	39 f7                	cmp    %esi,%edi
  805374:	0f 86 a2 00 00 00    	jbe    80541c <__umoddi3+0xd8>
  80537a:	89 c8                	mov    %ecx,%eax
  80537c:	89 f2                	mov    %esi,%edx
  80537e:	f7 f7                	div    %edi
  805380:	89 d0                	mov    %edx,%eax
  805382:	31 d2                	xor    %edx,%edx
  805384:	83 c4 1c             	add    $0x1c,%esp
  805387:	5b                   	pop    %ebx
  805388:	5e                   	pop    %esi
  805389:	5f                   	pop    %edi
  80538a:	5d                   	pop    %ebp
  80538b:	c3                   	ret    
  80538c:	39 f0                	cmp    %esi,%eax
  80538e:	0f 87 ac 00 00 00    	ja     805440 <__umoddi3+0xfc>
  805394:	0f bd e8             	bsr    %eax,%ebp
  805397:	83 f5 1f             	xor    $0x1f,%ebp
  80539a:	0f 84 ac 00 00 00    	je     80544c <__umoddi3+0x108>
  8053a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8053a5:	29 ef                	sub    %ebp,%edi
  8053a7:	89 fe                	mov    %edi,%esi
  8053a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8053ad:	89 e9                	mov    %ebp,%ecx
  8053af:	d3 e0                	shl    %cl,%eax
  8053b1:	89 d7                	mov    %edx,%edi
  8053b3:	89 f1                	mov    %esi,%ecx
  8053b5:	d3 ef                	shr    %cl,%edi
  8053b7:	09 c7                	or     %eax,%edi
  8053b9:	89 e9                	mov    %ebp,%ecx
  8053bb:	d3 e2                	shl    %cl,%edx
  8053bd:	89 14 24             	mov    %edx,(%esp)
  8053c0:	89 d8                	mov    %ebx,%eax
  8053c2:	d3 e0                	shl    %cl,%eax
  8053c4:	89 c2                	mov    %eax,%edx
  8053c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8053ca:	d3 e0                	shl    %cl,%eax
  8053cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8053d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8053d4:	89 f1                	mov    %esi,%ecx
  8053d6:	d3 e8                	shr    %cl,%eax
  8053d8:	09 d0                	or     %edx,%eax
  8053da:	d3 eb                	shr    %cl,%ebx
  8053dc:	89 da                	mov    %ebx,%edx
  8053de:	f7 f7                	div    %edi
  8053e0:	89 d3                	mov    %edx,%ebx
  8053e2:	f7 24 24             	mull   (%esp)
  8053e5:	89 c6                	mov    %eax,%esi
  8053e7:	89 d1                	mov    %edx,%ecx
  8053e9:	39 d3                	cmp    %edx,%ebx
  8053eb:	0f 82 87 00 00 00    	jb     805478 <__umoddi3+0x134>
  8053f1:	0f 84 91 00 00 00    	je     805488 <__umoddi3+0x144>
  8053f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8053fb:	29 f2                	sub    %esi,%edx
  8053fd:	19 cb                	sbb    %ecx,%ebx
  8053ff:	89 d8                	mov    %ebx,%eax
  805401:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  805405:	d3 e0                	shl    %cl,%eax
  805407:	89 e9                	mov    %ebp,%ecx
  805409:	d3 ea                	shr    %cl,%edx
  80540b:	09 d0                	or     %edx,%eax
  80540d:	89 e9                	mov    %ebp,%ecx
  80540f:	d3 eb                	shr    %cl,%ebx
  805411:	89 da                	mov    %ebx,%edx
  805413:	83 c4 1c             	add    $0x1c,%esp
  805416:	5b                   	pop    %ebx
  805417:	5e                   	pop    %esi
  805418:	5f                   	pop    %edi
  805419:	5d                   	pop    %ebp
  80541a:	c3                   	ret    
  80541b:	90                   	nop
  80541c:	89 fd                	mov    %edi,%ebp
  80541e:	85 ff                	test   %edi,%edi
  805420:	75 0b                	jne    80542d <__umoddi3+0xe9>
  805422:	b8 01 00 00 00       	mov    $0x1,%eax
  805427:	31 d2                	xor    %edx,%edx
  805429:	f7 f7                	div    %edi
  80542b:	89 c5                	mov    %eax,%ebp
  80542d:	89 f0                	mov    %esi,%eax
  80542f:	31 d2                	xor    %edx,%edx
  805431:	f7 f5                	div    %ebp
  805433:	89 c8                	mov    %ecx,%eax
  805435:	f7 f5                	div    %ebp
  805437:	89 d0                	mov    %edx,%eax
  805439:	e9 44 ff ff ff       	jmp    805382 <__umoddi3+0x3e>
  80543e:	66 90                	xchg   %ax,%ax
  805440:	89 c8                	mov    %ecx,%eax
  805442:	89 f2                	mov    %esi,%edx
  805444:	83 c4 1c             	add    $0x1c,%esp
  805447:	5b                   	pop    %ebx
  805448:	5e                   	pop    %esi
  805449:	5f                   	pop    %edi
  80544a:	5d                   	pop    %ebp
  80544b:	c3                   	ret    
  80544c:	3b 04 24             	cmp    (%esp),%eax
  80544f:	72 06                	jb     805457 <__umoddi3+0x113>
  805451:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  805455:	77 0f                	ja     805466 <__umoddi3+0x122>
  805457:	89 f2                	mov    %esi,%edx
  805459:	29 f9                	sub    %edi,%ecx
  80545b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80545f:	89 14 24             	mov    %edx,(%esp)
  805462:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  805466:	8b 44 24 04          	mov    0x4(%esp),%eax
  80546a:	8b 14 24             	mov    (%esp),%edx
  80546d:	83 c4 1c             	add    $0x1c,%esp
  805470:	5b                   	pop    %ebx
  805471:	5e                   	pop    %esi
  805472:	5f                   	pop    %edi
  805473:	5d                   	pop    %ebp
  805474:	c3                   	ret    
  805475:	8d 76 00             	lea    0x0(%esi),%esi
  805478:	2b 04 24             	sub    (%esp),%eax
  80547b:	19 fa                	sbb    %edi,%edx
  80547d:	89 d1                	mov    %edx,%ecx
  80547f:	89 c6                	mov    %eax,%esi
  805481:	e9 71 ff ff ff       	jmp    8053f7 <__umoddi3+0xb3>
  805486:	66 90                	xchg   %ax,%ax
  805488:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80548c:	72 ea                	jb     805478 <__umoddi3+0x134>
  80548e:	89 d9                	mov    %ebx,%ecx
  805490:	e9 62 ff ff ff       	jmp    8053f7 <__umoddi3+0xb3>
